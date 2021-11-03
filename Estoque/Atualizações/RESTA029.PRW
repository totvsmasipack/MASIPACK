#include "totvs.ch"


/*/{Protheus.doc} User Function RESTA029
Função para carregar o aCols das movimentações internas multiplas com base na referencia da OP
@type  User Function
@author Masipack 
@since 26/11/2019
/*/
User Function RESTA029()

Local aMvPar    := {}
Local cPerg     := 'MESTA029'
Local cRefer    := ''
Local nX        := 0
Local oSX1

    oSX1:=FWSX1Util():New()	
	oSX1:AddGroup("MTA240")
    oSX1:SearchGroup()
    
    For nX := 1 To Len(oSX1:aGrupo[1][2])
        aAdd(aMvPar,&( 'MV_PAR' + StrZero(nX,2,0)))
    Next nX
    
    If Pergunte(cPerg,.T.)

        cRefer := MV_PAR01
        For nX := 1 To Len( aMvPar )
            &('MV_PAR' + StrZero(nX,2,0)) := aMvPar[nX]
        Next nX
    
        If !Empty(cRefer)
            FwMsgRun(,{|| CarregaSD3(cRefer) }, "", "Carregando listas..")
        Else
            FwAlertWarning('Referencia não preenchida. Nenhuma OP carregada')
        Endif

    Endif

Return

/*/{Protheus.doc} User Function CarregaSD3
Atualiza o aCols do GetDados da rotina MATA241
@type  Static Function
@author Masipack 
@since 26/11/2019
/*/
Static Function CarregaSD3(cRefer)

Local aArea         := SD4->(GetArea())
Local _aCols        := aClone(aCols)
Local _cTRB         := GetNextAlias()
Local lRet          := .T.
Local nSaldo        := 0
Local nx            := 0

Default cTM         := SPACE(TamSX3("D3_TM")[1])
Default MV_PAR03    := 1
Default dDataBase   := DATE()
Default cRefer      := ''

    BEGINSQL ALIAS _cTRB
		
        SELECT	D4_COD, D4.R_E_C_N_O_ AS RECNOD4
        FROM	%Table:SD4% D4
        WHERE	D4_FILIAL = %xFilial:SD4%	AND
                D4_MSREFER = %Exp:cRefer%	AND
                D4.%NOTDEL%
        ORDER BY D4_COD
    
    ENDSQL

    If (_cTRB)->(EOF())

        (_cTRB)->(dbCloseArea())
        _cTRB := GetNextAlias()

        BEGINSQL ALIAS _cTRB

            SELECT	D4_COD, D4.R_E_C_N_O_ AS RECNOD4
            FROM	%Table:SD4% D4, %Table:SC2% C2
            WHERE	D4_FILIAL = %xFilial:SD4%		    AND
                    D4_QUANT > %Exp:0%                  AND
                    D4.%NOTDEL%	                        AND
                    C2_FILIAL = D4_FILIAL               AND
                    C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP    AND
                    C2_MSREFER = %Exp:cRefer%			AND
                    C2.%NOTDEL%
            ORDER BY D4_COD

        ENDSQL
    
    Endif
    
    If (_cTRB)->(!EOF())
        
        cTM := "603"
        
    While (_cTRB)->(!EOF())
            
            SD4->(dbGoTo((_cTRB)->RECNOD4))

            If SD4->D4_QUANT > 0 .And. !(SUBSTR(SD4->D4_COD,1,3) == "MOD")

				If !Empty( aCols[Len(aCols)][aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_OP"})] )
					AADD(_aCols,aCols[1])
				Endif
            
                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_OP"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := SD4->D4_OP
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_COD"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := SD4->D4_COD
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_GRUPO"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := POSICIONE("SB1",1,FWxFilial("SB1") + SD4->D4_COD, "B1_GRUPO")
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_TRT"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := SD4->D4_TRT
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_DESCRI"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := POSICIONE("SB1",1,FWxFilial("SB1") + SD4->D4_COD, "B1_DESC")
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_UM"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := POSICIONE("SB1",1,FWxFilial("SB1") + SD4->D4_COD, "B1_UM")
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_LOCAL"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := SD4->D4_LOCAL
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_MSREFER"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := SD4->D4_MSREFER
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_MSREDUZ"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := POSICIONE("SC2",1, FWxFilial("SC2") + cRefer,"C2_MSREDUZ")
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_MSLOCAL"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := POSICIONE("SB1",1,FWxFilial("SB1") + SD4->D4_COD, "B1_LOCAL")
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_HORAS"})
                If nx > 0
                    _aCols[Len(_aCols),nx] := TIME()
                Endif

                nx := aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_QUANT"})
                If nx > 0
                    
                    SB2->(dbSetOrder(1))
                    SB2->(MsSeek(xFilial("SB2") + SD4->D4_COD +POSICIONE("SB1",1,FWxFilial("SB1") + SD4->D4_COD, "B1_LOCPAD")))
                    
                    SF5->(dbSetOrder(1))
                    SF5->(dbSeek(xFilial("SF5") + cTM))

					nSaldo := SaldoSB2(.F.,.F.,dDataBase,.T.,.F.,"SB2",SD4->D4_QUANT,0,.T.,dDataBase,.T.) - MovSaldo(_aCols, SD4->D4_COD, aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_COD"}), aScan(aHeader,{|x,y|, Alltrim(x[2]) == "D3_QUANT"}))
					
					_aCols[Len(_aCols),Len(_aCols[Len(_aCols)])] := .F.

                    If ( SD4->D4_QUANT > nSaldo )
						
						If nSaldo <= 0
							_aCols[Len(_aCols),Len(_aCols[Len(_aCols)])] := .T.
                            _aCols[Len(_aCols),nx] := SD4->D4_QUANT
						Else
							_aCols[Len(_aCols),nx] := nSaldo
						Endif
					Else
                        _aCols[Len(_aCols),nx] := SD4->D4_QUANT
					Endif

				Endif

                aCols := aClone(_aCols)
                oGet:Refresh()
            Endif
            (_cTRB)->(dbSkip())
        Enddo

    Else
        lRet := .F.
        FwAlertError("Referência não encontrada","TOTVS")
    Endif

    (_cTRB)->(dbCloseArea())
    
    RestArea(aArea)

Return lRet


/*/{Protheus.doc} MovSaldo
Retorna o saldo do movimento no array do Movimento Interno
@type  Static Function
@author E.DINIZ [ DS2U ]
@since 24/03/2021
/*/
Static Function MovSaldo(_aCols, _cProduto, _nPosProd, _nPosQtd)
Local _nRet := 0
Local _nX   := 0

    For _nX := 1 To Len(_aCols)
        If Alltrim(_aCols[_nX, _nPosProd]) == Alltrim(_cProduto) .And. !(Len(_aCols) == _nX)
            _nRet += _aCols[_nX, _nPosQtd]
        Endif
    Next _nX

Return _nRet
