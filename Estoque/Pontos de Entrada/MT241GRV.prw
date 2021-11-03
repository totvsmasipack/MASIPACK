#include 'protheus.ch'
#include 'totvs.ch'

/*/{Protheus.doc} User Function MT241GRV
LOCALIZAÇÃO:  Função A241GRAVA (Gravação do movimento)
EM QUE PONTO: Após a gravação dos dados (aCols) no SD3, e tem a finalidade de atualizar algum arquivo ou campo.
@type  User Function
@author Masipack
@since 29/11/2019
@version version
@param  PARAMIXB[1] = Número do Documento
        PARAMIXB[2] = Vetor bidimensional com nome campo/valor do campo (somente será enviado se o Ponto de Entrada MT241CAB for utilizado)
@return Nil
@see https://tdn.totvs.com/display/public/PROT/MT241GRV+-+Atualiza+arquivo+ou+campo
/*/
User Function MT241GRV()

Local _aArea    := {SD3->(GetArea()),  SD4->(GetArea()), SB1->(GetArea())}
Local _aList    := aClone(aCols)
Local _aPos     := {}
Local _lDeleted	:= .F.
Local _lFalta   := .F.
Local _nI       := 0

    IF !(FWCodEmp() == "15")
    
        SD3->(dbSetOrder(1))	//D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
        SD4->(dbSetOrder(1))	//D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE

		AADD(_aPos,  aScan(aHeader,{|x| Alltrim(x[2]) == "D3_OP"	}))
        AADD(_aPos,  aScan(aHeader,{|x| Alltrim(x[2]) == "D3_COD"	}))
        AADD(_aPos,  aScan(aHeader,{|x| Alltrim(x[2]) == "D3_TRT"	}))
        
        FOR _nI := 1 TO Len(_aList)

			_lDeleted := _aList[_nI][Len(_aList[Len(_aList)])]

            //***************************************
            //* Grava os campos especí­ficos (SD4)   *
            //***************************************
            SD4->( dbSeek(FWxFilial("SD4") + _aList[_nI][_aPos[2]] + _aList[_nI][_aPos[1]] + _aList[_nI][_aPos[3]] )) 
			
			If SD4->(FOUND()) .And. _lDeleted
                _lFalta := .T.			
			ElseIf SD4->(FOUND()) .And. !(_lDeleted) .And. QtdComp(SD4->D4_QTDEORI) # QtdComp(SD4->D4_QUANT) .And. QtdComp(SD4->D4_QUANT) # QtdComp(0)
				_lFalta := .T.
            EndIf

            If _lFalta
				Reclock("SD4",.F.)
                SD4->D4_MSLF	:= "X"
				SD4->D4_MSDTLF	:= dDataBase
                SD4->(MsUnlock())
			Endif
            _lFalta   := .F.

            //***************************************
            //* Grava os campos específicos (SD3)   *
            //***************************************
            SD3->(dbGoTop())
            IF SD3->(dbSeek(FWxFilial("SD3") + _aList[_nI][1] + _aList[_nI][2] + _aList[_nI][8]))
                WHILE SD3->(!EOF()) .And. SD3->D3_FILIAL + SD3->D3_OP + SD3->D3_COD + SD3->D3_LOCAL == FWxFilial("SD3") + _aList[_nI][1] + _aList[_nI][2] + _aList[_nI][8]
                    IF Empty(SD3->D3_ESTORNO)
                        Reclock("SD3",.F.)
                        SD3->D3_MSREFER := POSICIONE("SD4",1,FWxFilial("SD4")+_aList[_nI][2]+_aList[_nI][1],"D4_MSREFER")
                        SD3->D3_MSLOCAL := POSICIONE("SB1",1,FWxFilial("SB1")+_aList[_nI][2],"B1_LOCAL")
                        SD3->(MsUnlock())
                    ENDIF
                    SD3->(dbSkip())
                ENDDO
            ENDIF
            
        NEXT _nI

        //***************************************
        //* Restaura a origem dos ponteiros     *
        //***************************************
        AEval(_aArea,{|x| RestArea(x) })
    
    ENDIF
    
Return
