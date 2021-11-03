#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} RPCPR009
//TODO Descrição: Ordens de Producao.
@author Solange Ap.Vezú
@since 04.06.07
@version 1.0
@return NIL
@type function
/*/
User Function RPCPR009()

Private cPerg      := "RPCP09"
Private nLastKey   := 0
Private cDesenho   := ""  										// Armazena o código do Desenho
Private aDesenhos  := {}  		   								// Matriz que armazena os desenhos para posterior impressao
Private cDescr     := ""
Private cProduto   := ""
Private cCodAlter  := ""
Private nImp       := 0                                                                   
Private cLocal     := ""
Private cTRT       := "" 
Private nLargura   := 0
Private nAltura    := 0
Private nCol       := 1 
Private nLin       := 1                                                                  
Private nEstoque   := 0
Private J          := 0
Private dDtEnt     := CTOD("")
Private nLoteMin   := 0
Private nLoteEcon  := 0
Private nEstSeg    := 0
Private cDiaSemana := ""
Private _cUsuario  := RetCodUsr()
Private _cUsuSenha := ""
Private _cDeptoUsu := ""
Private _aUsuario  := {}
Private cUsuarioSZS := ""
Private cCor       := ""
Private _cObs		 := ""
Private _nPag      := 0
Private _nPesoBru  := 0 

//Variaveis utilizadas para verificar empenhos da OP
Private _nReg      := ""
Private cEmpenho   := ""
Private aEmpenhos  := ""
Private cCliente   := ""
Private cPedido    := ""
Private aPedidos   := ""

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario  := PswRet()
   _cUsuSenha := UsrRetName(_cUsuario)
   cUsuarioSZS := _aUsuario[1][4]  
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da OP                                 ³
//³ mv_par02            // Ate a OP                              ³
//³ mv_par03            // Da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Imprime Roteiro de Operações? S/N     ³
//³ mv_par06            // Impr. OP's Firmes, Previstas ou Ambas?³
//³ mv_par07            // Observacao 1                          ³
//³ mv_par08            // Observacao 2                          ³
//³ mv_par09            // Máquina                               ³
//³ mv_par10            // Imprime? 1- Impressora 2-Video        ³
//³ mv_par11            // Qual Impressora?                      ³
//³ mv_par12            // Qual Servido Impressão?               ³
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

If !(Pergunte(cPerg,.T.))
   Return
EndIf 
If Empty(mv_par01) .or. Empty(mv_par02)
   apmsgStop("OP não pode estar em Branco")
   Return
EndIf
If !ChkFile("SH8",.F.)
	Help(" ",1,"SH8EmUso")
	Return
Endif

mv_par05 := 1 // Imprimir sempre o roteiro de operacoes

oFont1 := TFont():New("Times New Roman"	,,10,,.F.,,,,,.F.)   		// Comprimido
oFont2 := TFont():New("Times New Roman"	,,15,,.F.,,,,,.F.)   		// Normal  
oFont3 := TFont():New("Times New Roman"	,,18,,.F.,,,,,.F.)   		// Expandido
oFont4 := TFont():New("Courier New"		,,13,,.F.,,,,,.F.)  	   	// Normal
oFont7 := TFont():New("Times New Roman"	,,20,,.T.,,,,,.F.)
oFont8 := TFont():New("Courier New"		,,12,,.F.,,,,,.F.)
oFont9 := TFont():New("Courier New"		,,10,,.F.,,,,,.F.)   

oPrn := TMSPrinter():New("RPCPR009") 

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	ClosFile("SH8")
	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	Return
Endif
RptStatus({|| R820Imp()})
Return NIL

/*/{Protheus.doc} R820Imp
//TODO Descrição: Chamada do Relatório.
@author Waldemiro L. Lustosa
@since 13.11.1995
@version 1.0
@return NIL
@type function
/*/
Static Function R820Imp()

Local I := 0
Local j := 0
Local K := 0

Local cOPRet		:= ''
Local cLocalOP		:= ''
Local 	_cPath 		:= ""
Local 	nQuant      := 1
Local   cObsSC2		:= ""
Local   _cOperPeca	:= ""
Local aExtDes    	:= {{".PRI",.T.},{".PRN",.T.},{".PDF",.T.},{".PLT",.T.}}
Local aFiles     	:= {}
Local nD := 0
Private aDesen2		:= {}
Private aArray    	:= {}
Private Li        	:= 0

dbSelectArea("SZ2")             						   			// Utilizado para impressão do código de Barras
dbSetOrder(1)
If dbSeek(xFilial("SZ2")+Alltrim(mv_par11))
   nLargura := SZ2->Z2_LARGURA / 10
   nAltura  := SZ2->Z2_ALTURA 
   nCol     := SZ2->Z2_COLUNA
   If nAltura == 0.45
      nLin  := 14
   Else
      nLin  := 28
   EndIf      
EndIf   
   
dbSelectArea("SC2")
SC2->(dbSetOrder(1))
dbSeek(xFilial("SC2")+Alltrim(mv_par01))
 
Do While Alltrim(sc2->c2_num + sc2->c2_item + sc2->c2_sequen) <= ALLTRIM(mv_par02) .and. !sc2->(EOF())
	IF lEnd
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	If SC2->C2_DATPRF < mv_par03 .Or. SC2->C2_DATPRF > mv_par04 .or. !(Empty(SC2->C2_DATRF))
		dbSkip()
		Loop
	Endif

	If !MtrAValOP(mv_par06, 'SC2')
		dbSkip()
		Loop
	EndIf

	If !EMPTY(SC2->C2_MSIMPR) .And. MV_PAR14 == 2
		cOPRet += " OP Desconsiderada: " + SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) + CRLF
 		SC2->(dbSkip())
		Loop
	EndIf
	
	If FWCodEmp() $ '01|10'
//		If !EMPTY(SC2->C2_MSIMPR)
//			If !MsgYesNo("Atenção!!! Esta OP já foi impressa, deseja realmente reimprimi-la?")
//				Return
//			Else
		
		RecLock("SZS",.T.)
		SZS->ZS_FILIAL  := "01"
		SZS->ZS_OP      := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		SZS->ZS_PRODUTO := SC2->C2_PRODUTO
		SZS->ZS_QTDE    := SC2->C2_QUANT
		SZS->ZS_POSICAO := "Reimpressão da OP"
		SZS->ZS_CC      := "XXXXXX"
		SZS->ZS_DATA    := Date()
		SZS->ZS_HORA    := Time()
		SZS->ZS_USUARIO := UPPER(cUsuarioSZS)
		SZS->ZS_DEPTO   := _cDeptoUsu
		SZS->(MsUnlock())
//			EndIf
	Endif
	
	cProduto  := SC2->C2_PRODUTO
	_nReg := SC2->(Recno())
	
	If !(cEmpAnt == "15")
		VerEmpenhos()
	Endif
	
	VerPedidos()
	dbSelectArea("SC2")
	dbGoto(_nReg)
	cCodBarra := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	cObsSC2	  := Alltrim(SC2->C2_OBS)
	nQuant    := aSC2Sld()
	cProc     := ""
	cLocal    := ""
	nEstoque  := 0
	_nPesoBru := 0
	
	SB2->(DbSetOrder(1))
	If SB2->(DbSeek(xFilial("SB2")+cProduto+"01"))
		nEstoque := SB2->B2_QATU
	EndIf
	
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+cProduto))

		cLocal   := SB1->B1_LOCAL
		_nPesoBru:= SB1->B1_PESBRU
		_cOPmae	:= SB1->B1_MSOPMAE // INCLUIDO 17/10/13 PEÇAS SOLDADAS QUE SÃO ENCERRADAS NO ALMOXARIFADO.
	EndIf
	cTRT   := "000"
	//Adiciona o primeiro elemento da estrutura, ou seja, o Pai
	AddAr820(nQuant)
	
	MontStruc(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)
	
	oPrn:Say(0, 0, " ",oFont1,100)     							   			// startando a impressora
	_nPag := 0
	cabecOp()
	
	SG2->(DbSetOrder(1))
	SH1->(DbSetOrder(1))
	For I := 2 TO Len(aArray)
		_cOperPeca := ""
		If SG2->(DbSeek(xFilial("SG2")+aArray[I][1]+Alltrim(aArray[I][9]))) .And. cEmpAnt $ '01|10'
			Do While !SG2->(EOF()) . And. (SG2->G2_PRODUTO + SG2->G2_CODIGO) == (aArray[I][1] + aArray[I][9])
				SH1->(DbSeek(xFilial("SH1") + SG2->G2_RECURSO))
				_cOPerPeca += Alltrim(SH1->H1_MSOPER) + " / "
				SG2->(DbSkip())
			EndDo
		EndIf
		IF Substr(cNumemp,1,2) == "01" .And. Substr(aArray[I][8],1,3) <> "001" .and. cProc = ""			// MASIPACK considera tratamento externo quando SD4->D4_TRT for diferente de 001.
			Li += 50
			oPrn:Say (Li,010,PADC(" " + "TRATAMENTO EXTERNO" + " ",94,"*"),oFont2)
			cProc = "OK"
			Li += 090
		ElseIf Substr(cNumemp,1,2) == "10" .And. Substr(aArray[I][8],1,3) >= "100" .and. cProc = ""		// FABRIMA considera tratamento externo quando SD4->D4_TRT for maior que 099.
			Li += 50
			oPrn:Say (Li,010,PADC(" " + "TRATAMENTO EXTERNO" + " ",94,"*"),oFont2)
			cProc = "OK"
			Li += 090
		EndIF
		oPrn:Say (Li,010,Alltrim(aArray[I][8])+Space(03)+Alltrim(aArray[I][1])+Alltrim(aArray[I][14]),oFont1)							// CODIGO PRODUTO
		cProdEmp:= Alltrim(aArray[I][1])+Alltrim(aArray[I][14])
		cDescr := Alltrim(aArray[I][2])
		dbSelectArea("SG1")
		SG1->(dbSetOrder(1))
		IF Substr(cNumemp,1,2) == "01"
			SG1->(dbSeek(xFilial("SG1")+cProduto+aArray[I][1]))
		Else
			SG1->(dbSeek(xFilial("SG1")+cProduto+aArray[I][1]+aArray[I][8]))
		Endif
		If Found() .And. !Empty(SG1->G1_OBSERV)
			cDescr := Alltrim(cDescr) + " " + Alltrim(SG1->G1_OBSERV)
		EndIf
		oPrn:Say (li,400,SubStr(cDescr,1,55), oFont1)
		oPrn:Say (Li,1550,aArray[I][4], oFont1)
		oPrn:Say (Li,1640,Transform(aArray[I][5]/aArray[I][13],"@E 9,999.999"), oFont1)  // Vlr.Unit.
		oPrn:Say (Li,1810,Transform(aArray[I][5],IIF(aArray[I][4] = "PC","@E 999,999","@E 9,999.999")), oFont1) 			     // Total
		oPrn:Say (Li, 1900, STR(aArray[I][10]), oFont1)
		oPrn:Say (Li, 2150, aArray[I][11], oFont1)
		IF Len(cDescr) > 55
			Li+= 50
			oPrn:Say (li,400, Alltrim(SubStr(cDescr,56,Len(cDescr) - 55)), oFont1)
		ENDIF
		cCodAlter := ""
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+Alltrim(aArray[I][1])))
		If SB1->B1_MSBLQL = "1"
			Li+=50
			oPrn:Say (li,400, "** CODIGO BLOQUEADO **", oFont1)
			cCodAlter := Alltrim(SB1->B1_ALTER)
		EndIf
		If !Empty(cCodAlter)
			If SB1->(DbSeek(xFilial("SB1")+cCodAlter))
				oPrn:Say (li,800, "Codigo Alternativo: "+cCodAlter + "     Local: "+ SB1->B1_LOCAL, oFont1)
			EndIf
		EndIf				
		IF !(Substr(Alltrim(aArray[I][1]),1,2) == "AC") .And. aArray[I,15] == "N"
			MSBar("CODE128",Li/111,0.3,cProdEmp,oPrn,.T.,,.T.,nLargura*0.7,nAltura*0.5,,,,.F.)
		Endif
		If !Empty(_cOperPeca)
			Li+=50
			oPrn:Say (Li,400,_cOperPeca, oFont1)
		EndIf
		SB1->(DbSeek(xFilial("SB1")+Alltrim(aArray[I][1])))                   // PARA CODIGOS MOD
		IF SubStr(aArray[I][8],1,3) <> "001"
			Li += 50
			IF li > 2870 								   						//³ Se nao couber, salta para proxima folha
				CabecOp()	   													// imprime cabecalho da OP
			EndIF
			oPrn:Say (Li,010, Replicate ("-",140), oFont2)
		EndIF
		IF SubStr(aArray[I][8],1,3) == "001"
			Li += 70
			IF li > 2870 								   						//³ Se nao couber, salta para proxima folha
				CabecOp()	   													// imprime cabecalho da OP
			EndIF
			oPrn:Say (Li,010, Replicate ("-",140), oFont2)
		ENDIF
		Li += 50
		IF li > 2870 								   						//³ Se nao couber, salta para proxima folha
			CabecOp()	   													// imprime cabecalho da OP
		EndIF
	Next I
	
	IF li > 2870
		CabecOp()
	EndIF
	
	If mv_par05 == 1														// Imprime o Roteiro de Operações
		_cRoteiro := "  "
		_cRoteiro := sc2->c2_roteiro
		IF EMPTY(_cRoteiro)
			_cRoteiro := "01"
		ENDIF
		If sg2->(DBSEEK(xFilial("SG2") + sc2->c2_produto+_cRoteiro))   // incluido o roteiro na pesquisa - LIZANDRA 09/05/12
			Li += 50
			oPrn:Say(Li,010,PADC(" OPERAÇÕES ",92,"*"),oFont2)
			Li += 50
			
			oPrn:Say(Li,1250,"SETUP"				,oFont1)
			oPrn:Say(Li,1450,"TEMPO POR PEÇA"	,oFont1)
			Li+=50
			Do While sg2->g2_produto + sg2->g2_codigo == sc2->c2_produto + _cRoteiro .AND. !sg2->(EOF())
				oPrn:Say(Li,0010,SG2->G2_OPERAC,oFont1)						// Operacao
				sh1->(DBSEEK(xFilial("SH1") + sg2->g2_recurso))
				IF cEmpAnt $ '01|10'
					cLocalOP	:= sh1->h1_mslocal
					IF !EMPTY(sg2->g2_mslocal)
						cLocalOP := sg2->g2_mslocal
					ENDIF
				ENDIF
				oPrn:Say(Li,0150,ALLTRIM(SG2->G2_RECURSO),oFont1)  //C.Custo + Operacao + Descrição
				oPrn:Say(Li,400,Alltrim(SH1->H1_DESCRI),oFont1)  										  //Descrição
				Li += 5
				
				_cHor := ""
				_cMin := ""
				If SG2->G2_SETUP == 0
					_cHor := '0h'
					_cMin := '00min'
				ElseIf SG2->G2_SETUP < 1
					_cHor := '0h'
					_cMin := ALLTRIM(STR(SG2->G2_SETUP * 60)) + 'min'
					If AT('.',_cMin) > 0
						_cMin := SubStr(_cMin,1,AT('.',_cMin)-1)+'min'
					EndIf
				ElseIf SG2->G2_SETUP > 0.99
					_cHr := AllTrim(STR(SG2->G2_SETUP))
					If AT('.',_cHr) > 0
						_cHor	:= SubStr(_cHr,1,AT('.',_cHr)-1)+'h'
						_cMin	:= ALLTRIM(STR(VAL(SubStr(_cHr,AT('.',_cHr),Len(_cHr)))*60))+'min'
					Else
						_cHor := _cHr+'h'
						_cMin := "00min"
					EndIf
				EndIf
				oPrn:Say(Li,1250,_cHor+_cMin ,oFont1)
				
				_cHor := ""
				_cMin := ""
				If SG2->G2_TEMPAD == 0
					_cHor := '0h'
					_cMin := '00min'
				ElseIf SG2->G2_TEMPAD < 1
					_cHor := '0h'
					_cMin := ALLTRIM(STR(SG2->G2_TEMPAD * 60)) + 'min'
					If AT('.',_cMin) > 0
						_cMin := SubStr(_cMin,1,AT('.',_cMin)-1)+'min'
					EndIf
				ElseIf SG2->G2_TEMPAD > 0.99
					_cHr := AllTrim(STR(SG2->G2_TEMPAD))
					If AT('.',_cHr) > 0
						_cHor	:= SubStr(_cHr,1,AT('.',_cHr)-1)+'h'
						_cMin	:= ALLTRIM(STR(VAL(SubStr(_cHr,AT('.',_cHr),Len(_cHr)))*60))+'min'
					Else
						_cHor := _cHr+'h'
						_cMin := "00min"
					EndIf
				EndIf
				oPrn:Say(Li,1450,_cHor+_cMin										,oFont1)
				
				If cEmpAnt $ "01|10"
					If SG2->G2_MSOK == "S"
						oPrn:Say(Li,1830,"Tempo OK",oFont1)
					EndIf
				Endif

				IF !EMPTY(cLocalOP)
					oPrn:Say(Li,2000,"Local: "+cLocalOP,oFont1)					  		            	//Local
				Else
					IF ALLTRIM(sg2->g2_recurso) == "C018"
						Li +=15
						oPrn:Say(Li,2000,"Local: _______________",oFont1)
						Li -=15
					ENDIF
				ENDIF
				Li += 50
				IF cEmpAnt $ "01|10"
					IF !EMPTY(sg2->g2_msprog)
						IF Substr(cNumEmp,1,2) == "01"  
							oPrn:Say(Li,150,"Progs.: "+Rtrim(sg2->g2_msprog),oFont1)				  		//MsProg
						ELSE
							oPrn:Say(Li,150,Rtrim(sg2->g2_msprog),oFont1)				  		//MsProg
						ENDIF
						Li += 50
					ENDIF
					IF !EMPTY(sg2->g2_msobs)
						oPrn:Say(Li,150,"Obs.: "+ALLTRIM(sg2->g2_msobs),oFont1)
						Li += 50					  			//MsObs
					ENDIF
				ENDIF
				SG2->(DBSKIP())
				If li > 3000
					CabecOp()
				EndIF
			Enddo
		Endif
	EndIf
	Li+=30
	
	IF Li > 2700
		CabecOp()
	EndIF
	
	// Imprime linhas para observações
	Li+=20
	oPrn:Say (Li, 010,"Operações:", oFont2)
	Li+=20 
    For K := 1 TO 3
    	oPrn:Say (Li,010,Replicate ("_",100), oFont2)
	    Li+=70 
	    If Li > 2700
	       Exit
	    EndIf
	Next K 
	Li := 3000
	oPrn:Say (Li,010,Replicate ("_",100), oFont2)
	Li+=50
	oPrn:Say (Li,0010, "Estoque de Segurança: " + Transform(nEstSeg,"@E 999,999.999"),oFont2)
	oPrn:Say (Li,1000, "Lote Mínimo: " + Transform(nLoteMin,"@E 999,999.999"),oFont2)
	oPrn:Say (Li,1800, "Lote Economico: " + Transform(nLoteEcon,"@E 999,999.999"),oFont2)
	li+=70
	
	//****************************
	//Usuario,Emissão e Impressao
	//****************************
	If cEmpAnt $ '01|10'
		If !Empty(SC2->C2_MSIMPR)
			If mv_par10 == 1
				RecLock("SC2",.F.)
				SC2->C2_MSIMPR := Date()
				SC2->(MsUnLock())
			EndIf
			oPrn:Say (Li,010, "Usuário: " + SC2->C2_MSUSER + "     Emissão: "+DTOC(SC2->C2_EMISSAO)+"     Impressão: "+DTOC(SC2->C2_MSIMPR)+"  ** REIMPRESSAO **", oFont2)
		Else
			RecLock("SC2",.F.)
			SC2->C2_MSIMPR := Date()
			SC2->(MsUnLock())
			oPrn:Say (Li,010, "Usuário: " + SC2->C2_MSUSER + "     Emissão: "+DTOC(SC2->C2_EMISSAO)+"     Impressão: "+DTOC(SC2->C2_MSIMPR), oFont2)
			If Substr(cNumEmp,1,2) $ "01_10"  																// Imprime cabecalho da OP
				GravaSZS()
			EndIf
		Endif
	Endif
	
	Li := 0
	
	If mv_par12 == 1
		cDrive := "H:"
	Else
		cDrive := "P:"
	EndIf
	_cPath := cDrive + "\PLOTTER\"
	
	If MV_PAR13 == 3
		_cPath := "H:\PLOTTER\"
		If Substr(cDesenho,1,2) == "CL"
			_cPath += Substr(cDesenho,3,2) + "\"
		ELSE
			_cPath += Substr(cDesenho,1,2) + "\"
		ENDIF
		For nD:=1 to 4
			ADir(_cPath+cDesenho+aExtDes[nD][1], aFiles)
			If len (aFiles) > 0
				aExtDes[nD][2] := .T.
				AADD(aDesenhos,"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + aExtDes[nD][1] + " LPT1" )
			Else
				aExtDes[nD][2] := .F.
			Endif
		Next
		IF !(aExtDes[1][2]) .And. !(aExtDes[2][2]) .And. !(aExtDes[3][2]) .And. !(aExtDes[4][2])
			_cPath := "P:\PLOTTER\"
			If Substr(cDesenho,1,1) == "X"
				If ExistDir(_cPath+Substr(cDesenho,1,3))
					_cPath += Substr(cDesenho,1,3) + "\"
				Else
					_cPath += Substr(cDesenho,2,3) + "\"
				Endif
			ElseIf Substr(cDesenho,1,2) == "70"
				_cPath += Substr(cDesenho,1,2) + "\"
			Else
				_cPath += Substr(cDesenho,1,3) + "\"
			Endif
			For nD:=1 to 4
				ADir(_cPath+cDesenho+aExtDes[nD][1], aFiles)
				If len (aFiles) > 0
					aExtDes[nD][2] := .T.
					AADD(aDesenhos,"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + aExtDes[nD][1] + " LPT1" )
				Else
					aExtDes[nD][2] := .F.
				Endif
			Next
		Endif
	
	Else
		
		If MV_PAR13 == 1
			If Substr(cDesenho,1,2) == "CL"
				_cPath += Substr(cDesenho,3,2) + "\"
			ELSE
				_cPath += Substr(cDesenho,1,2) + "\"
			ENDIF
		ElseIf MV_PAR13 == 2
			_cPath += Substr(cDesenho,1,3) + "\"
		Endif

		For nD:=1 to 4
			
			If File( _cPath + cDesenho + aExtDes[nD][1] )
				aExtDes[nD][2] := .T.
				AADD(aDesenhos,"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + aExtDes[nD][1] + " LPT1" )
			Else
				aExtDes[nD][2] := .F.
			Endif
		Next

	EndIf

//	IF !(aExtDes[1][2]) .And. !(aExtDes[2][2]) .And. !(aExtDes[3][2]) .And. !(aExtDes[4][2])
//		AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PDF LPT1" )
//		AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PLT LPT1" )
//		AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PRI LPT1" )
//		AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PRN LPT1" )
//	EndIf
	
//	AADD(aDesen2,_cPath + Alltrim(cDesenho) + ".PDF")
//	AADD(aDesen2,_cPath + Alltrim(cDesenho) + ".PLT")
//	AADD(aDesen2,_cPath + Alltrim(cDesenho) + ".PRI")
//	AADD(aDesen2,_cPath + Alltrim(cDesenho) + ".PRN")
	Li   := 70
	nImp := 0
	m_pag := 1
	cDesenho  := ""
	aArray    := {}
	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	dbSkip()
Enddo

if !Empty(cOPRet)
	FwAlertWarning(cOPRet,'OPs Reimpressas')
endif


dbSelectArea("SH8")
dbCloseArea()
		
//***************************************************************
//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     
//***************************************************************
ClosFile("SH8")
   				
dbSelectArea("SC2")
Set Filter To
SC2->(dbSetOrder(1))
dbCloseArea()

oPrn:EndPage()   // Finaliza a pagina

If mv_par10 == 2
	oPrn:Preview()   // Video
	// As linhas abaixo são para imprimir desenhos de ops já emitidas SEM os desenhos
	
	FOR j := 1 TO LEN(aDesenhos)
		WaitRun(aDesenhos[j])
	NEXT
	
Else
	oPrn:Setup()
	oPrn:Print()
	For j := 1 To Len(aDesenhos)
		WaitRun(aDesenhos[j])
	Next
Endif

oPrn:End()
MS_FLUSH()
Return NIL                                                                                   
			
/*/{Protheus.doc} AddAr820
//TODO Descrição: Adiciona um elemento ao Array.
@author Paulo Boschetti
@since 01/06/2018
@version 1.0
@return NIL
@param nQuantItem, numeric, descricao: Quantidade da estrutura
@type function
/*/
Static Function AddAr820(nQuantItem)
Local cDesc 	:= ""
Local cRoteiro:="" 

cDesc := Alltrim(GetAdvFval("SB5","B5_CEME",xFilial("SB5")+SB1->B1_COD,1," "))
If Empty(cDesc)
   cDesc := SB1->B1_DESC
EndIf
        
If SC2->C2_DESTINA == "P"
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEM)
	If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
		cDesc := C6_DESCRI
	ElseIf C6_PRODUTO # SB1->B1_COD
		dbSelectArea("SB5")
		SB5->(dbSetOrder(1))
		dbSeek(xFilial("SB5")+SB1->B1_COD)
		If Found() .and. !Empty(B5_CEME)
			cDesc := B5_CEME
		EndIf
	EndIf
Else   
	IF EMPTY(cDesc) 
		dbSelectArea("SB5")
		SB5->(dbSetOrder(1))
		dbSeek(xFilial("SB5")+SB1->B1_COD)
		If Found() .and. !Empty(B5_CEME)
			cDesc := B5_CEME
  	  EndIf
	ENDIF  	  
EndIf

//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
If !Empty(SC2->C2_ROTEIRO)
	cRoteiro:=SC2->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		SG2->(dbSetOrder(3))
		If dbSeek(xFilial("SG2")+SC2->C2_PRODUTO+"01")
			RecLock("SB1",.F.)
			B1_OPERPAD := "01"
			MsUnLock()
			cRoteiro:="01"
		EndIf
	EndIf
EndIf

dbSelectArea("SB2")
SB2->(dbSetOrder(1))
dbSeek(xFilial("SB2")+SB1->B1_COD+SD4->D4_LOCAL)

If cEmpAnt $ '01|10'
	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,cLocal,SB2->B2_LOCALIZ,cTRT,cRoteiro,SB1->B1_PESO,SB1->B1_LOCAL,SB1->B1_MSAMBIE,SC2->C2_QUANT,SB1->B1_REVATU,SC2->C2_MSLISTA} )
Else
	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,cLocal,SB2->B2_LOCALIZ,cTRT,cRoteiro,SB1->B1_PESO,SB1->B1_LOCAL,SB1->B1_MSAMBIE,SC2->C2_QUANT,SB1->B1_REVATU,''} )
Endif

RETURN

/*/{Protheus.doc} MontStruc
//TODO Descrição auto-gerada.
@author Ary Medeiros
@since 19/10/1993
@version 1.0
@return NIL
@param cOp, characters, descricao: Codigo do produto a ser explodido
@param nQuant, numeric, descricao: Quantidade base a ser explodida
@type function
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
SD4->(DBORDERNICKNAME("OPTRTCOD"))
SD4->(dbSeek(xFilial("SD4")+cOp))

Do While !Eof() .And. SD4->D4_FILIAL+SD4->D4_OP == xFilial("SD4")+cOp
	IF SUBSTR(SD4->D4_COD,1,3) == 'MOD'
		dbSelectArea("SD4")
		dbSkip() 
		Loop
	ENDIF
    cLocal := SD4->D4_LOCAL
    cTRT   := SD4->D4_TRT 
    dbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	dbSeek(xFilial("SB1")+SD4->D4_COD)
	If SD4->D4_QUANT > 0								//.Or. (lItemNeg .And. SD4->D4_QUANT < 0)        
	   AddAr820(SD4->D4_QUANT)
	EndIf
	dbSelectArea("SD4")
	SD4->(dbSkip())
Enddo

Return

/*/{Protheus.doc} CabecOp
//TODO Descrição: Monta o cabecalho da Ordem de Producao.
@author Paulo Boschetti
@since 01/06/2018
@version 1.0
@return NIL
@type function
/*/
Static Function CabecOp()
Local J := 0
Local cCabec1 := Alltrim(SM0->M0_NOME) 	//"        ORDEM  DE  PRODUCAO       O.P. nº:"
Local cPed := "" 
If Li > 0 
   oPrn:EndPage()
EndIF 
Li := 0
_nPag++
oPrn:StartPage()   															//Inicia uma nova pagina 
dbSelectArea("SC2")
SC2->(dbSetOrder(1))
//Cod.Barras será impresso em todas as paginas da OP
MSBar("CODE128",01,04,cProduto,oPrn,.T.,,.T.,nLargura,nAltura,,,,.F.)
MSBar("CODE128",01,nCol-2,SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,oPrn,.T.,,.T.,nLargura,nAltura,,,,.F.)
Li += 255  
oPrn:Say (Li,020, cCabec1, oFont2)
oPrn:Say (Li,400, "- ORDEM DE PRODUÇÃO",oFont2)
oPrn:Say (Li,1630, "O.P. nº: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, oFont3) 
Li+=50
oPrn:Say (Li,010, Replicate ("-",140),oFont2)
Li +=40
cPed := SubStr(SC2->C2_NUM,1,6) 
oPrn:Say (Li, 0010, "Pag.: " + Str(_nPag,2), oFont2)
If !(Empty(mv_par09))
	oPrn:Say (Li, 0300, "Maq.: " + Alltrim(mv_par09), oFont2)
Endif
oPrn:Say (Li, 1630, "ACOMPANHA PEÇA", oFont2)
Li += 80
dbSelectArea("SC2")
SC2->(dbSetOrder(1))
cPed   := IIF(Substr(cNumemp,1,2)=="15",SC2->C2_PEDIDO,SubStr(SC2->C2_NUM,1,6))
nQuant := (SC2->C2_QUANT-(SC2->C2_QUJE+SC2->C2_PERDA))
If cEmpAnt $ '01|10' 
	If !Empty(SC2->C2_MSREDUZ)
		oPrn:Say (Li,300, "Cliente: "+SC2->C2_MSREDUZ, oFont2)
	Endif
Else
	SC5->(DbSetOrder(1))
	IF SC5->(dbSeek(xFilial("SC5")+cPed))
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			oPrn:Say (Li,300, "Cliente: "+SA1->A1_NREDUZ, oFont2)
       		//oPrn:Say (Li,1300, "Quant: "+nQuant, oFont2) 											// quantidade
		EndIf
	EndIf
Endif

If cEmpAnt $ '01|10' 
	If !Empty(SC2->C2_MSPED)
		oPrn:Say (Li, 1100, "(P.V.: "+SC2->C2_MSPED+")", oFont2)
	Endif
Else
	If !Empty(SC2->C2_PEDIDO) 
		oPrn:Say (Li, 1100, "(P.V.: "+SC2->C2_PEDIDO+")", oFont2)
	Endif
Endif

If cEmpAnt $ '01|10' 
	If Alltrim(SC2->C2_MSREDUZ)=="FABRIMA"
		oPrn:Say (Li,1600, "Contrato: "+SC5->C5_ORCAM, oFont2)
	Endif
Endif
Li += 80                  

// imprime observação para o operador da solda

IF _cOPmae == "S"
    oPrn:Say (Li,300,"SOLDA OP MAE", oFont2)
ENDIF    
Li +=50               

//********************************************************************
//Verifica se existem OBSERVACOES nos Parametros e no SC2->C2_OBS
//********************************************************************
If !(Empty(mv_par07))
    oPrn:Say (Li,300,mv_par07, oFont2)
	If !(Empty(mv_par08))
		Li += 80
		oPrn:Say (Li,300,mv_par08, oFont2)
	Endif
EndIf 
Li +=50               

IF SUBSTR(SC2->C2_OBS,1,8) == "RPCPA011"
	_cObs := SubStr(SC2->C2_OBS,12,LEN(SC2->C2_OBS))
Else
	_cObs := SC2->C2_OBS
ENDIF

If !(Empty(Substr(_cObs,1,50)))
	oPrn:Say (Li,300,Substr(_cObs,1,50), oFont2)
	If !(Empty(Substr(_cObs,51,50)))
		Li += 80
		oPrn:Say (Li,300,Substr(_cObs,51,54), oFont2)
	Endif
ELSE
   RecLock("SC2",.F.)
   sc2->c2_obs := ALLTRIM(mv_par07) + SPACE(1) + ALLTRIM(mv_par08)
   SC2->(MsUnLock())
Endif

If SUBSTR(cNumEmp,1,2) == "01"
	Li += 50
	oPrn:Say(Li,1650,"P/  ______________________________",oFont1)   
	Li += 50
	oPrn:Say(Li,1650,"NF: ______________________________",oFont1)  
	Li += 50
	oPrn:Say(Li,1650,"Data: ________ /________ /________",oFont1)			  		
	Li += 50   
EndIf
// Imprime Empenhos
If Len(aEmpenhos) > 0 .And. _nPag == 1
   Li+=80
   cEmpenho := ""
   oPrn:Say (Li,0010,"Empenhos: ", oFont2)
   For J := 1 TO Len(aEmpenhos)
       // Serão impressos no maximo 30 empenhos
          nResto := J % 3
          If nResto == 0
             cEmpenho += aEmpenhos[J]
             Li+=50
             oPrn:Say (Li,0050,cEmpenho, oFont8)
             cEmpenho := ""
          Else
             cEmpenho += aEmpenhos[J]  + "/"
          EndIf
   Next J
   cEmpenho := Alltrim(cEmpenho)
   If !Empty(cEmpenho)
      If SubStr(cEmpenho,Len(cEmpenho),1) == "/"
         cEmpenho := SubStr(cEmpenho,1,Len(cEmpenho)-1)
      EndIf   
      Li+=50
      oPrn:Say (Li,0050,SubStr(cEmpenho,1,Len(cEmpenho)), oFont8)
   EndIf   
EndIf

// Imprime Pedidos
If Len(aPedidos) > 0 .And. _nPag == 1
   Li+=80
   cPedido := ""
   oPrn:Say (Li,0010,"Pedidos: ", oFont2)
   For J := 1 TO Len(aPedidos)
       nResto := J % 2
       If nResto == 0
          cPedido += aPedidos[J]
          Li+=50
          oPrn:Say (Li,0050,cPedido, oFont9)
          cPedido := ""
       Else
          cPedido += aPedidos[J]  + " |"
       EndIf
   Next J
   cPedido := Alltrim(cPedido)
   If !Empty(cPedido)
      If SubStr(cPedido,Len(cPedido),2) == " |"
         cPedido := SubStr(cPedido,1,Len(cPedido)-2)
      EndIf   
      Li+=50
      oPrn:Say (Li,0050,SubStr(cPedido,1,Len(cPedido)-2), oFont9)
   EndIf   
EndIf  

// Imprime dados da CI 
If cEmpAnt $ '01'
   If !EMPTY(sc2->c2_msci)
      Li+=80
      oPrn:Say (Li,0010,"Comunicacao Interna [CI]: " + sc2->c2_msci + " - Data: " + DTOC(sc2->c2_msdtci), oFont2)
   ENDIF   
EndIf                                                                               

Li += 080 

IF SUBSTR(cNumEmp,1,2) <> '01'
	Li += 50
	cDiaSemana := Alltrim(DiaSemana(SC2->C2_DATPRI))
	oPrn:Say (Li,010, "Início Efetivo :          /       /      ",oFont7)
	oPrn:Say (Li,1500,"Fim Efetivo :          /       /      ",oFont7)
	Li += 80  
ELSE	
	cDiaSemana := Alltrim(DiaSemana(SC2->C2_DATPRI)) 
	oPrn:Say (Li,010, "Data Entregue:      /      /      ",oFont7)
	oPrn:Say (Li,750, "Início Previsto:      /      /      ",oFont7)
	oPrn:Say (Li,1500,"Fim Efetivo:      /      /      ",oFont7)
	Li+=50
ENDIF	
oPrn:Say (Li,010, Replicate ("-",140), oFont2)
Li += 90
_nQuant := SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA) 
oPrn:Say (Li,010, "Produto: ", oFont2)
Li +=5
oPrn:Say (Li,220,Alltrim(aArray[1][1]), oFont4)	//Produto
SB1->(DbSeek(xFilial("SB1")+Alltrim(aArray[1][1])))
nLoteMin  := SB1->B1_LM
nEstSeg   := SB1->B1_ESTSEG
nLoteEcon := SB1->B1_LE
oPrn:Say (Li,700, "Rev. "+ Alltrim(SB1->B1_REVATU) + "  " + SB1->B1_DESC, oFont4)

cDesenho := Alltrim(aArray[1][1])+Alltrim(SB1->B1_REVATU)
li -=5  											//Descricao
oPrn:Say (Li,1880,"Qtde: ", oFont2)
Li +=5
oPrn:Say (Li,2060,STR(_nQuant,6)+" "+SC2->C2_UM, oFont4)
Li += 80
IF !SUBSTR(cNumEmp,1,2) $ "15_40_45" 
	If !Empty(aArray[1][11])
 		oPrn:Say (Li,010,"Local: ",oFont2) 								//Local
   	Li +=5
   	oPrn:Say (Li,220,aArray[1][11],oFont4)
   	Li -=5
	EndIf 
ELSE	
   oPrn:Say (Li,010,"Grupo: ",oFont2)
   oPrn:Say (Li,220,Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC"),oFont4)
ENDIF   
oPrn:Say (Li,0710,"Peso Bruto Total: ",oFont2)
oPrn:Say (Li,1110,Transform(_nPesoBru * _nQuant,'@E 9,999.999'), oFont4)    // Peso total das pecas

IF SUBSTR(cNumEmp,1,2) $ "15_40_45" 
   oPrn:Say (Li,1880,"Qtd.p/caixa: ",oFont2)
   oPrn:Say (Li,2250,TRANSFORM(Posicione("SB5",1,xFilial("SB5")+SB1->B1_COD,"B5_QE1"),"@E 999"),oFont4)
   _cFavor := Posicione("SC5",1,xFilial("SC5")+SC2->C2_PEDIDO,"C5_MSFAVOR")
 	IF !EMPTY(_cFavor)
		Li += 80
	   oPrn:Say (Li,010,"Favorecido.: ",oFont2)
	   oPrn:Say (Li,300,_cFavor,oFont4)
 	ENDIF
ENDIF   

If !Empty(aArray[1][12])      
   oPrn:Say (Li,1510,"Ambiente Manufatura: ",oFont2)                       //Ambiente Manufatura
   Li +=5  
   oPrn:Say (Li,1740,aArray[1][12],oFont4)
   Li -=5  
EndIf   
Li += 100
oPrn:Say (Li,010,PADC(" " + "  MATERIAL NECESSARIO  " + " ",92,"*"),oFont2)
Li += 60
oPrn:Say( Li,010,"Seq   Codigo                        D e s c r i ç ã o                                                                                                      UM     Unitario       Total      KG/M      Local",oFont1)
Li += 40
oPrn:Say (Li,010,Replicate("-",140),oFont2)
Li += 50

Return

/*/{Protheus.doc} VerEmpenhos
//TODO Descrição: .
@author Solange Ap.Vezú
@since 04/06/07
@version 1.0
@return NIL
@type function
/*/
Static Function VerEmpenhos()
   aEmpenhos := {} 
   SD4->(DbSetOrder(1))
   If SD4->(DbSeek(xFilial("SD4")+Alltrim(cProduto)))
      Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_COD) == Alltrim(cProduto)
         If SD4->D4_QUANT > 0
            If SC2->(DbSeek(xFilial("SC2")+SD4->D4_OP))
               cCor := Space(9)
               If SC5->(DbSeek(xFilial("SC5")+SC2->C2_MSPED))
                  If !Empty(SC5->C5_COR) .And. Alltrim(SC5->C5_COR) <> "TIT" 
                     cCor := "Cor: "+Alltrim(SC5->C5_COR)+ "-"
                  EndIf   
               EndIf 
               If (ASCAN(aEmpenhos,SC2->C2_NUM  + " " + cCor + SC2->C2_MSREDUZ)) == 0
                  AADD(aEmpenhos,SC2->C2_NUM  + " " + cCor + SC2->C2_MSREDUZ)
               EndIf   
            EndIf   
         EndIf   
         SD4->(DbSkip())
         Loop
      EndDo
   EndIf
Return 

/*/{Protheus.doc} VerPedidos
//TODO Descrição auto-gerada.
@author Solange Ap.Vezú
@since 04/06/2007
@version 1.0
@return NIL
@type function
/*/
Static Function VerPedidos()
	SF4->(DbSetOrder(1))
	SC5->(DbSetOrder(1))
   aPedidos := {} 
   SC6->(DbSetOrder(2))
   If SC6->(DbSeek(xFilial("SC6")+Alltrim(cProduto)))
      Do While !SC6->(Eof()) .And. Alltrim(SC6->C6_PRODUTO) == Alltrim(cProduto) 
         If SC6->C6_QTDVEN - SC6->C6_QTDENT > 0
            SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))
            If Empty(SC5->C5_NOTA) .And. Alltrim(SC5->C5_TIPO) == "N"  
               cCliente := ""
               dDtEnt   := CTOD("")
               If !Empty(SC5->C5_MSDTPEN)
	              dDtEnt := SC5->C5_MSDTPEN
	           Else
	              dDtEnt := SC5->C5_MSDTENT
	           EndIf
               If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
                  cCliente := Substr(SA1->A1_NREDUZ,1,18) + "- "
               EndIf   
               If SF4->(DbSeek(("SF4")+SC6->C6_TES))
                  If SF4->F4_ESTOQUE == "S"
                     AADD(aPedidos,SC6->C6_NUM + "/" + SC6->C6_ITEM  + " - " + cCliente  + " Qtde:" + Str(SC6->C6_QTDVEN - SC6->C6_QTDENT,3) + " - " + DTOC(dDtEnt))
                  EndIf   
               EndIf   
            EndIf   
         EndIf   
         SC6->(DbSkip())
      EndDo
    EndIf
Return 
  
/*/{Protheus.doc} GravaSZS
//TODO Descrição: Grava na tabela customizada sobre a posição da OP (SZS) a informação referente a impressão.
@author Solange Ap.Vezú
@since 04/06/2007
@version 1.0
@return NIL
@type function
/*/
Static Function GravaSZS()
   DbSelectArea("SZS")
   RecLock("SZS",.T.)
   SZS->ZS_FILIAL  := "01"
   SZS->ZS_OP      := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
   SZS->ZS_PRODUTO := SC2->C2_PRODUTO
   SZS->ZS_QTDE    := SC2->C2_QUANT
   SZS->ZS_POSICAO := "Impressão da OP" 
   SZS->ZS_CC      := "XXXXXX"
   SZS->ZS_DATA    := Date()
   SZS->ZS_HORA    := Time()
   SZS->ZS_USUARIO := UPPER(cUsuarioSZS)
   SZS->ZS_DEPTO   := _cDeptoUsu
   SZS->(MsUnlock())
Return
