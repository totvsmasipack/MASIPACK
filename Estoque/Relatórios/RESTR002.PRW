#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} RESTR002
//TODO Funcao de Impressao de Etiquetas p/Identificar Pecas.
@author parecida de F.Stevanato 
@since 20/02/2009
@version 1.0
@return Nil	

@type function
@Obs Alterado 25/07/2014 - Eduardo Mantoan - Programa reescrito, 
baseado no RESTR024 feito por Lizandra - Alterado para incluir a descri��o do produto

/*/
User Function RESTR002()

	Private _cUsuario	:= RetCodUsr()
	Private _aUsuario  	:= {}
	Private _cUsuSenha 	:= ""
	Private _cDeptoUsu 	:= ""
	Private nLastKey   	:= 0
	Private cNum       	:= ""
	Private cItem      	:= 0 
	Private cProd      	:= ""
	Private cRev       	:= ""
	Private cProdAux   	:= ""
	Private nQtdEtiq   	:= 0
	Private nQtdPc     	:= 0
	Private nEtiq      	:= 0
	Private cTipo      	:= ""
	Private cNFiscal   	:= ""
	Private cLocal     	:= ""
	Private dDtEnt     	:= CTOD("")
	Private cArqPRN    	:= "c:\relato_microsiga\EtiqPecas.PRN"
	Private cRegPRN    	:= ""
	Private cTipo      	:= ""
	Private cForn      	:= "" 
	Private cDesc      	:= ""
	Private _nLin      	:= 0
	Private _nCol      	:= 0
	Private _fInicio   	:= .T.
	Private _fImpEtiq  	:= .F.
	Private _lProc     	:= .T.
	Private oEspes     	:= 0
	Private _oDlg2
	Private nEspes     	:= 0
	Private nLargu		:= "          "
	Private nCompr		:= "          "
	Private oItem	   

	_cUsuario  := RetCodUsr()
	_cUsuSenha := UsrRetname(_cUsuario)

	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario  := PswRet()
		_cUsuSenha := UsrRetName(_cUsuario)
		_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
	EndIf

	SC2->(DbSetOrder(1))
	SC7->(DbSetOrder(1))
	SB1->(DbSetOrder(1))
	SD1->(DbSetOrder(22))
	//SD1->(DbOrderNickName("MSSD1PCITE"))
	SB5->(DbSetOrder(1)) 

	aModelo  := {"1-Branca (5 Etiquetas)","2-Verde (3 Etiquetas)Almox","3-Verde (3 Etiquetas)Funilaria"}
	cNum     := Space(11)
	dDtEnt   := CTOD("")
	cNFiscal := Space(9)
	cModelo  := Space(20)

	If "ALMOXARIFADO" $ _cDeptoUsu
		_cDeptoUsu := "ALMOXARIFADO"
	EndIf  

	Do While _lProc 
		cItem    := Space(4)
		cProd    := Space(15)
		nQtdEtiq := 0
		cLocal   := ""
		fImpEtiq := .F.
		fRet     := .F.

		@ 089,185 To 500,600 Dialog _oDlg1 Title OemToAnsi("Etiquetas - Identificar Pe�as")
		@ 009,011 To 035,195
		@ 030,011 To 180,195
		@ 015,064 Say OemToAnsi("Etiqueta para Pe�as")              			Size 151,010
		@ 055,020 Say OemToAnsi("Modelo....................:")      			Size 070,008  
		@ 070,020 Say OemToAnsi("Pedido/OP................:")       			Size 070,008
		@ 070,125 Say OemToAnsi("Item:")                            			Size 070,008
		@ 085,020 Say OemToAnsi("Produto...................:")      			Size 070,008
		@ 100,020 Say OemToAnsi("Qtde Etiq / Qtde P�s............:")    		Size 070,008 
		@ 115,020 Say OemToAnsi("Espes.Compr.Larg..:")              			Size 070,008
		@ 130,020 Say OemToAnsi("Nota Fiscal..............:")       			Size 070,008
		@ 145,020 Say OemToAnsi("Data Entrada...........:")         			Size 070,008

		@ 052,075 ComboBox cModelo Items aModelo                    			Size 075,010 OBJECT oModelo
		@ 070,075 Get cNum   													Size 040,008 OBJECT oNum
		@ 070,140 Get cItem  Valid ValidaNum()                      			Size 020,008 OBJECT oItem
		@ 085,075 Get cProd  F3 "SB1"                               			Size 050,008
		@ 100,075 Get nQtdEtiq Picture "@E 999"                     			Size 035,008
		//Ivandro Santos - 07/12/17 
		//In�cio da altera��o: Ticket#2017112337000121 � Informa��o nas etiquetas
		@ 100,115 Get nQtdPc Picture "@E 999999"                    			Size 035,008  
		//Ticket#2017112337000121 � Fim da altera��o
		@ 115,075 Get nEspes Picture "@E 9999.99" 		           				Size 020,008
		@ 115,115 Get nCompr 				      		  		   				Size 035,008
		@ 115,155 Get nLargu 	   		      			  		   				Size 035,008 
		@ 130,075 Get cNFiscal F3 "SD1"                             			Size 035,008
		@ 145,075 Get dDtEnt Valid dDtEnt <= Date()                 			Size 035,008

		@ 165,110 BmpButton Type 1 Action Processa( { || ImpEtiq() })
		@ 165,145 BmpButton Type 2 Action fFinaliza()

		If !Empty(cNum)
			If Len(Alltrim(cNum)) > 6
				cNum := Space(11)
				oNum:SetFocus()
			Else
				cItem:=Space(4)   
				oItem:SetFocus()
			EndIf   
		EndIf 

		Activate Dialog _oDlg1 Centered
	End

Return


/*/{Protheus.doc} fFinaliza
//TODO Finaliza a tela e apaga o arquivo gerado .prn caso encontre
@author alison.goncalves
@since 11/04/2018
@version 1.0
@return Nil
@type function

@Obs Alterado por Alison Colocado o comentario da fun��o.
/*/
Static Function fFinaliza()

	_lProc := .F.
	FClose(cArqPRN)
	FErase("c:\relato_microsiga\EtiqPecas.prn")
	_oDlg1:End()

Return



/*/{Protheus.doc} ValidaNum
//TODO Valida numera��o
@author alison.goncalves
@since 11/04/2018
@version 1.0
@return fRet retorno l�gico, deveria ser lRet
@type function
@Obs Alison - Incluido comentario da fun��o
/*/
Static Function ValidaNum()
	Local lRet := .T.

	If Empty(cNum)  .Or. (Empty(cItem)  .And. Len(Alltrim(cNum)) <= 6)
		cNum  := Space(11)
		cItem := Space(4)
		_oDlg1:End()// Zera para permitir o re-preenchimento
		lRet := .F.
	EndIf

	If lRet
		cProd := ""
		If Len(Alltrim(cNum)) > 6
			If SC2->(DbSeek(xFilial()+Alltrim(cNum)))
				cProd    := Alltrim(SC2->C2_PRODUTO)
				nQtdEtiq := SC2->C2_QUANT
			Else
				apmsgSTOP("OP n�o encontrada")
				lRet := .F.
			EndIf
		Else            
			If SC7->(DbSeek(xFilial()+Alltrim(cNum)+cItem))
				cProd    := Alltrim(SC7->C7_PRODUTO)
				nQtdEtiq := SC7->C7_QUANT
				cForn    := ""

				If SA2->(DbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)) 
					cForn := Substr(SA2->A2_NREDUZ,1,12)
				EndIf

				If SubStr(cModelo,1,1) == "3"      //Funilaria 
					ConfB5()
				EndIf   
			Else
				apmsgStop("Pedido/Item n�o encontrado")
				lRet := .F.     
			EndIf
		EndIf    

		If SD1->(DbSeek(xFilial()+Alltrim(cNum)+cItem))
			cNFiscal := SD1->D1_DOC	
			dDtEnt   := SD1->D1_DTDIGIT	
		EndIf 

		cProdAux := cProd  
	EndIf

	fRet := lRet

Return lRet


/*/{Protheus.doc} ConfB5
//TODO Confere a espessura, caso altere j� atualiza o cadastroo
@author alison.goncalves
@since 11/04/2018
@version 1.0
@return nil
@Obs Alison - adicionado apenas o comentario da fun��o
@type function
/*/
Static Function ConfB5()
	If SB5->(DBSeek(xFilial()+cProd))
		If SB5->B5_ESPESS > 0 
			If nEspes <> 0  
				If nEspes <> SB5->B5_ESPESS
					DEFINE MSDIALOG _oDlg2 TITLE "Espessura Diferente - Deseja Confirmar?" FROM C(178),C(181) TO C(250),C(450) PIXEL

					// Cria Componentes Padroes do Sistema
					@ C(010),C(028) Get nEspes Picture "@E 999,99"                     Size  050,010
					@ C(025),C(028) BmpButton Type 1 Action Processa( { || GravB5() }) 
					@ C(025),C(080) BmpButton Type 2 Action _oDlg2:End()

					ACTIVATE MSDIALOG _oDlg2 CENTERED 	
				EndIf
			Else
				nEspes := SB5->B5_ESPESS
			EndIf 
		Else 

			DEFINE MSDIALOG _oDlg2 TITLE "Espessura n�o Cadastrada - Informe-a" FROM C(178),C(181) TO C(250),C(450) PIXEL
			// Cria Componentes Padroes do Sistema
			@ C(010),C(028) Get nEspes Picture "@E 999,99"                     Size  050,010
			@ C(025),C(028) BmpButton Type 1 Action Processa( { || GravB5() })
			@ C(025),C(080) BmpButton Type 2 Action _oDlg2:End()

			ACTIVATE MSDIALOG _oDlg2 CENTERED 

		EndIf
	EndIf
Return

/*/{Protheus.doc} GravB5
//TODO Atualiza a espessura 
@author alison.goncalves
@since 11/04/2018
@version 1.0
@return nil
@obs Alison - s� adicionei o comentario da fun��o j� existente
@type function
/*/
Static Function GravB5()
	If SB5->(DBSeek(xFilial()+cProd))
		RecLock("SB5",.f.)
		SB5->B5_ESPESS := nEspes	
		SB5->(MsUnLock())
	EndIf
	_oDlg2:End()
Return


/*/{Protheus.doc} ImpEtiq
//TODO Gera as etiquetas no seus respectivos formatos
@author alison.goncalves
@since 11/04/2018
@version 1.0
@return nil
@type function
@Obs Alison - apenas coloquei o cabe�alho da fun��o
/*/
Static Function ImpEtiq()

Local n

	cProd := Upper(cProd)

	If SubStr(cModelo,1,1) == "3"      //Funilaria 
		ConfB5()
	EndIf 

	If SB1->(DbSeek(xFilial()+cProd))
		cLocal := SB1->B1_LOCAL
		cDesc  := SB1->B1_DESC
		cUM    := SB1->B1_UM
		If !Empty(SB1->B1_REVATU)
			cRev := "-" + Alltrim(SB1->B1_REVATU)
		Else
			cRev := ""
		EndIf      
	Else
		cProd  := "Nao cadastrado" 
		cLocal := ""   
	EndIf


	If SubStr(cModelo,1,1) == "1"
		dDtEnt := Date()
	EndIf

	If Empty(dDtEnt)
		apmsgStop("Informe a Data de Entrada")
		fRet := .F.
		Return fRet
	EndIf 

	If cProd <> cProdAux .And. SubStr(cModelo,1,1) == "2"
		apmsgStop("Produto n�o pode ser alterado")
		cProd := cProdAux
		fRet := .F.
		Return fRet
	EndIf 

	If Len(Alltrim(cNum)) == 6
		cTipo := "Ped.: "
	Else
		cTipo := "OP.: "
	EndIf 

	If SubStr(cModelo,1,1) == "3" //Funilaria
		If apMsgYesNo("*** ATEN��O, Deseja Imprimir as Etiquetas ***")
			_fImpEtiq := .T.
		Else
			_fImpEtiq := .F.
		EndIf

		If cResp1:=msgbox("Impressora LPT1?","Aten��o...","YESNO")
			MSCBPRINTER("OS 214","LPT1",NIL,)
		Else
			MSCBPRINTER("OS 214","COM1",NIL,)
		EndIf


		MSCBCHKSTATUS(.F.)
		nCont := 0
		For n := 1 To nQtdEtiq

			If _fImpEtiq = .F.
				Return
			EndIf

			If nQtdEtiq > nCont
				MSCBBEGIN(1,4)

				MSCBSAY(05,03,"Codigo.:" + cProd    ,"B","2","01,01")
				MSCBSAY(09,03,SUBSTR(cDesc,1,22),"B","2","01,01")
				MSCBSAY(13,03,"E " + Alltrim(TRANSFORM(nEspes,"@E 9999.99mm"))+" C " + Alltrim(nCompr)+" L " + Alltrim(nLargu),"B","2","01,01")
				MSCBSAY(17,03,"NF: " + cNFiscal + "-"+ cForn,"B","2","01,01")
				MSCBSAY(21,03,cTipo + Alltrim(cNum) + "/" + cItem  ,"B","2","01,01")
				MSCBSAY(25,03,"Local.:" + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5),"B","2","01,01")
				MSCBSAY(29,03,"Data Entrada.:" + DTOC(dDtEnt),"B","2","01,01")

				nCont ++
				N++

				If nQtdEtiq > nCont

					MSCBSAY(35,03,"Codigo.:" + cProd    ,"B","2","01,01")
					MSCBSAY(39,03,SUBSTR(cDesc,1,22),"B","2","01,01")
					MSCBSAY(43,03,"E " + Alltrim(TRANSFORM(nEspes,"@E 9999.99mm"))+" C " + Alltrim(nCompr)+" L " + Alltrim(nLargu),"B","2","01,01")
					MSCBSAY(47,03,"NF: " + cNFiscal + "-"+ cForn,"B","2","01,01")
					MSCBSAY(51,03,cTipo + Alltrim(cNum) + "/" + cItem  ,"B","2","01,01")
					MSCBSAY(55,03,"Local.:" + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5),"B","2","01,01")
					MSCBSAY(59,03,"Data Entrada.:" + DTOC(dDtEnt),"B","2","01,01")

					nCont++
					N++

					If nQtdEtiq > nCont
						MSCBSAY(65,03,"Codigo.:" + cProd    ,"B","2","01,01")
						MSCBSAY(69,03,SUBSTR(cDesc,1,22),"B","2","01,01")
						MSCBSAY(73,03,"E " + Alltrim(TRANSFORM(nEspes,"@E 9999.99mm"))+" C " + Alltrim(nCompr)+" L " + Alltrim(nLargu),"B","2","01,01")
						MSCBSAY(77,03,"NF: " + cNFiscal + "-"+ cForn,"B","2","01,01")
						MSCBSAY(81,03,cTipo + Alltrim(cNum) + "/" + cItem  ,"B","2","01,01")
						MSCBSAY(85,03,"Local.:" + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5),"B","2","01,01")
						MSCBSAY(89,03,"Data Entrada.:" + DTOC(dDtEnt),"B","2","01,01")

						nCont++

					EndIf
				EndIf
				MSCBEND() //Fim da Imagem da Etiqueta
			EndIf
		NEXT N
		MSCBCLOSEPRINTER()
	ElseIf SubStr(cModelo,1,1) $ "2_1"  .And. !(SubStr(cNumEmp,1,2) == "15")//Funilaria
		// Monta etiqueta de acordo com o modelo 1 ou 2.
		MontaEtiq()   
	ElseIf SubStr(cModelo,1,1) $ "1" .And. SubStr(cNumEmp,1,2) == "15"//Branca com 5 ZLP S4M zebra
		Montazebra()

	EndIf
Return        


/*/{Protheus.doc} MontaEtiq
//TODO Monta cabe�alho da etiqueta.
@author alison.goncalves
@since 11/04/2018
@version 1.0
@return Nil
@type function
@Obs Alison  - S� inclui o cabe�alho da fun��o
/*/
Static Function MontaEtiq()
	Local lReturn	:= .T.
	Local I       	:= 0 
	Local nSalto  	:= 0

	If _fInicio
		lReturn := IniEtiq()   // Grava as informacoes iniciais no arquivo
	EndIf

	IF lReturn
		//Ivandro Santos - 07/12/17
		//In�cio da altera��o: Ticket#2017112337000121 � Informa��o nas etiquetas
		If Substr(cModelo,1,1) == "1"
			dDtEnt  := Date()
			nSalto  := 28
			nEtiq   := 5
		ElseIf Substr(cModelo,1,1) == "2"
			nSalto  := 25 
			nEtiq   := 3
		EndIf

		If Len(Alltrim(cNum)) == 6
			cTipo := "Ped.: "
		Else
			cTipo := "OP.: "
		EndIf 

		For I := 1 to nQtdEtiq
			If SubStr(cModelo,1,1) == "1"
				cRegPRN := "221100000990" + StrZero(_nLin,3) + cTipo + Alltrim(cNum) + "/" + cItem  
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=13
				cRegPRN := "221100000990" + StrZero(_nLin,3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=13
				cRegPRN := "221100000990" + StrZero(_nLin,3) + Alltrim(cProd) + cRev
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=13
				cRegPRN := "221100000990" + StrZero(_nLin,3) + "FAB: " + DTOC(dDtEnt)  
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=nSalto
				_nCol++
			Else
				cRegPRN := "291100301780" + StrZero(_nLin,3) + "Data Entrada: " + DTOC(dDtEnt)  
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=15
				cRegPRN := "291100301780" + StrZero(_nLin,3) + "NF: " + cNFiscal + "-"+cForn
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=15
				cRegPRN := "291100301780" + StrZero(_nLin,3) + cTipo + Alltrim(cNum) + "/" + cItem  
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=15
				//cRegPRN := "292100201790" + StrZero(_nLin,3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)
				cRegPRN := "291100301780" + StrZero(_nLin,3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=15
				cRegPRN := "292100201780" + StrZero(_nLin,3) + "QT: " + Alltrim(Str(nQtdPc))
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=15
				_cDesc := Alltrim(GetAdvFval("SB1","B1_DESC",xFilial("SB1")+cProd))
				cRegPRN := "292100201780" + StrZero(_nLin,3) + _cDesc
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=15
				cRegPRN := "292100201780" + StrZero(_nLin,3) + Alltrim(cProd) + cRev
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				_nLin+=nSalto
				_nCol++
			EndIf

			If _nCol == nEtiq 
				cRegPRN := "^" + StrZero(nEtiq,2,0)
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				cRegPRN := "Q0001"
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				cRegPRN :=  "E"
				FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))

				If I < nQtdEtiq
					cRegPRN := CHR(2) + "L"
					FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
					cRegPRN := "A2"
					FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
					cRegPRN := "D11"
					FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				EndIf   

				_nCol := 0
				If SubStr(cModelo,1,1) == "1"
					_nLin := 13
				Else
					_nLin := 15
				EndIf      
			EndIf
		Next

		If SubStr(cModelo,1,1) <> "1"
			If apMsgYesNo("*** ATEN��O, Deseja Imprimir as Etiquetas ***")
				_fImpEtiq := .T.
			Else
				_fImpEtiq := .F.

				If _nCol = 0
					cRegPRN := CHR(2) + "L"
					FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
					cRegPRN := "A2"
					FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
					cRegPRN := "D11"
					FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
				EndIf      

			EndIf
		Else
			_fImpEtiq := .T.
		EndIf             
	EndIF

	//Chama a finaliza��o da etique e manda para a impressora.
	FimEtiq()

Return lReturn     


/*/{Protheus.doc} IniEtiq
//Cria cabe�alho das etiquetas
@author alison.goncalves
@since 11/04/2018
@version 1.0
@return Nil
@type function
/*/
Static Function IniEtiq()
	Local lReturn	:= .T.

	//Inicializa etiquetas
	If SubStr(cModelo,1,1) == "1"
		_nLin := 13
	Else
		_nLin := 20
	EndIf   

	If (cArqPRN := FCreate("C:\Relato_Microsiga\EtiqPecas.PRN")) == -1
		apmsgStop("Arquivo de Etiquetas n�o pode ser criado - Avise o Depto. de Inform�tica")
		lReturn := .F.
	EndIf

	If lReturn
		cRegPRN := CHR(2) + "c0000"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := CHR(2) + "KI503"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := CHR(2) + "o0220"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := CHR(2) + "f220"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))

		If SubStr(cModelo,1,1) == "1"
			cRegPRN := CHR(2) + "KW0400"
		Else
			cRegPRN := CHR(2) + "KW0358"
		EndIf  

		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := CHR(2) + "KI7" + CHR(1)
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := CHR(2) + "V0"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := CHR(2) + "L"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))

		If SubStr(cModelo,1,1) == "1"
			cRegPRN := "H13"
		Else
			cRegPRN := "H12"
		EndIf  

		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := "PC"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := "A2"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN :=  "D11"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10)) 
		_fInicio := .F.
	EndIF	 

Return lReturn


Static Function FimEtiq()
	If _fImpEtiq
		If _nCol > 0
			cRegPRN := "^" + StrZero(nEtiq,2,0)
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "Q0001"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN :=  "E"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		EndIf

		// As linhas abaixo salta uma fileira de etiqueta, para evitar o uso da tecla FEED

		If SubStr(cModelo,1,1) > "2"
			cRegPRN := CHR(2) + "c0000"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := CHR(2) + "KI503"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := CHR(2) + "o0220"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := CHR(2) + "f220"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))

			If SubStr(cModelo,1,1) == "1"
				cRegPRN := CHR(2) + "KW0400"
			Else
				cRegPRN := CHR(2) + "KW0358"
			EndIf

			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := CHR(2) + "KI7" + CHR(1)
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := CHR(2) + "V0"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := CHR(2) + "L"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))

			If SubStr(cModelo,1,1) == "1"
				cRegPRN := "H13"
			Else
				cRegPRN := "H12"
			EndIf

			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "PC"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "A2"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "D11"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := ""
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "^" + StrZero(nEtiq,2,0)
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "Q0001"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN :=  "E"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		EndIf

		cRegPRN := CHR(2) + "Q"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		FClose(cArqPRN)

		//Manda para a impressora
		WaitRun("cmd /c copy c:\relato_microsiga\EtiqPecas.prn prn")
		//apaga da impressora
		WaitRun("cmd /c del c:\relato_microsiga\EtiqPecas.prn")
		_oDlg1:End()
		_fInicio := .T.
	Else
		_oDlg1:End()
	EndIf

Return



/*/{Protheus.doc} Montazebra
//TODO Monsta etique para zpl (Zebra s4m)
@author alison.goncalves
@since 12/04/2018
@version 1.0
@return .T., .F.	
@type function
/*/
Static Function Montazebra ()
	Local lReturn	:=	.T.
	Local nI		:=	0

	//Inicializa etiquetas
	//	If SubStr(cModelo,1,1) == "1"
	//		_nLin := 13
	//	Else
	//		_nLin := 20
	//	EndIf   

	If (cArqPRN := FCreate("C:\Relato_Microsiga\EtiqPecas.PRN")) == -1
		apmsgStop("Arquivo de Etiquetas n�o pode ser criado - Avise o Depto. de Inform�tica")
		lReturn := .F.
	EndIf

	If lReturn

		FWrite(cArqPRN,CHR(16)+ 'CT~~CD,~CC^~CT~' + CHR(13) +CHR(10))
		FWrite(cArqPRN,'^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ' + CHR(13) +CHR(10))
		For nI := 1 To nQtdEtiq 
			FWrite(cArqPRN,'^XA' + CHR(13) +CHR(10))
			FWrite(cArqPRN,'^MMT' + CHR(13) +CHR(10))
			FWrite(cArqPRN,'^PW703' + CHR(13) +CHR(10))
			FWrite(cArqPRN,'^LL0246' + CHR(13) +CHR(10))
			FWrite(cArqPRN,'^LS0' + CHR(13) +CHR(10))

			If nI  <= nQtdEtiq
				FWrite(cArqPRN,'^FT88,10^A0R,23,16^FH\^FD' + Space(3) + cTipo + Alltrim(cNum) + "/" + cItem  												+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT60,10^A0R,23,16^FH\^FD' + Space(3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)	+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT32,10^A0R,23,16^FH\^FD' + Space(3) + Alltrim(cProd) + cRev																+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT05,10^A0R,23,16^FH\^FD'  + Space(3) + "FAB: " + DTOC(dDtEnt)																+'^FS' + CHR(13) +CHR(10))
				nI++
			EndIf	

			If nI <= nQtdEtiq
				FWrite(cArqPRN,'^FT219,10^A0R,23,16^FH\^FD'+ Space(3) + cTipo + Alltrim(cNum) + "/" + cItem  												+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT191,10^A0R,23,16^FH\^FD'+ Space(3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)	+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT163,10^A0R,23,16^FH\^FD'+ Space(3) + Alltrim(cProd) + cRev																+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT135,10^A0R,23,16^FH\^FD'+ Space(3) + "FAB: " + DTOC(dDtEnt)																+'^FS' + CHR(13) +CHR(10))
				nI++
			EndIf

			If nI  <= nQtdEtiq
				FWrite(cArqPRN,'^FT357,10^A0R,23,16^FH\^FD'+ Space(3) + cTipo + Alltrim(cNum) + "/" + cItem  												+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT329,10^A0R,23,16^FH\^FD'+ Space(3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)	+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT301,10^A0R,23,16^FH\^FD'+ Space(3) + Alltrim(cProd) + cRev																+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT273,10^A0R,23,16^FH\^FD'+ Space(3) + "FAB: " + DTOC(dDtEnt)																+'^FS' + CHR(13) +CHR(10))
				nI++
			EndIf

			If nI <= nQtdEtiq
				FWrite(cArqPRN,'^FT493,10^A0R,23,16^FH\^FD'+ Space(3) + cTipo + Alltrim(cNum) + "/" + cItem  												+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT465,10^A0R,23,16^FH\^FD'+ Space(3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)	+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT437,10^A0R,23,16^FH\^FD'+ Space(3) + Alltrim(cProd) + cRev																+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT409,10^A0R,23,16^FH\^FD'+ Space(3) + "FAB: " + DTOC(dDtEnt)																+'^FS' + CHR(13) +CHR(10))
				nI++
			EndIf

			If nI <= nQtdEtiq
				FWrite(cArqPRN,'^FT628,10^A0R,23,16^FH\^FD'+ Space(3) + cTipo + Alltrim(cNum) + "/" + cItem  												+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT600,10^A0R,23,16^FH\^FD'+ Space(3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)	+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT572,10^A0R,23,16^FH\^FD'+ Space(3) + Alltrim(cProd) + cRev																+'^FS' + CHR(13) +CHR(10))
				FWrite(cArqPRN,'^FT544,10^A0R,23,16^FH\^FD'+ Space(3) + "FAB: " + DTOC(dDtEnt)																+'^FS' + CHR(13) +CHR(10))
			EndIf

			FWrite(cArqPRN,'^PQ1,0,1,Y^XZ' + CHR(13) +CHR(10))
		Next nI	


		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		FClose(cArqPRN)

		//Manda para a impressora
		WaitRun("cmd /c copy /B c:\relato_microsiga\EtiqPecas.prn COM1:")
		//apaga da impressora
		WaitRun("cmd /c del c:\relato_microsiga\EtiqPecas.prn")
		_oDlg1:End()
		_fInicio := .T.

	EndIf	
Return lReturn
