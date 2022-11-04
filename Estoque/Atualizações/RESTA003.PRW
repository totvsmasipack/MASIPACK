#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "bitmap.ch"
#define SW_SHOWNORMAL       1 // Normal
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณFuncao    ณ RESTA003ณ Autor ณ Aparecida de F.StevanatoณData ณ 20.01.09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ-ฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Acompanhamento das Ordens de Producao (BaixaMP)         	  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณAlterac๕esณ 26/11/2010 - Alteracao para gravar Movimentacoes no SD3    ณฑฑ
ฑฑณ          ณ 07/01/2016 - Fun็ใo  ) permitir usuแrio ROliveira          ณฑฑ
ฑฑณ          ณ              alterar campos C2_DATPRI E C2_DATPRF          ณฑฑ   
ฑฑณ          ณ 25/01/2019 - Alteracao letra do diretorio                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
*/

User Function RESTA003()

	Local	oBpm			:= Nil
	Private oPsqSHB			:= nil
	Private _lExiste		:= .F.
	Private _lAltMao 		:= .F.
	Private _lAltTem 		:= .F.
	Private _lAltDt			:= .F.
	Private _cUsuario   	:= ""
	Private cUsuarioSZS 	:= ""
	Private cUsuarioSX5 	:= ""
	Private _aUsuario   	:= {}
	Private _cUsuSenha  	:= ""
	Private _cDeptoUsu  	:= ""
	Private titulo      	:= ""
	Private cString     	:= "SC2"
	Private nomeprog    	:= "RESTA003"
	Private _cNumOP     	:= ""
	Private cSetor      	:= ""
	Private _cUltOpe		:= ""
	Private cCodSet			:= SPACE(06)
	Private cRecurso		:= SPACE(50)
	Private cTE         	:= SPACE(15)
	Private cCodSetor   	:= ""
	Private cValidMsg   	:= ""
	Private nQtde       	:= 0
	Private cProg       	:= ""
	Private cOrigem     	:= ""
	Private cDestino    	:= ""
	Private cArq        	:= ""
	Private nQuant      	:= 0
	Private nEstoque    	:= 0
	Private nQtdSD4     	:= 0
	Private nQtdSC2     	:= 0
	Private I           	:= 0
	Private _lProc      	:= .T.
	Private cProduto    	:= ""
	Private cMens       	:= ""
	Private cMens2			:= ""
	Private nDias       	:= 0
	Private cMP         	:= ""
	Private nEmpVD      	:= 0
	//Variaveis criadas para atender a funcao GravaSD3()
	Private lBxComp			:= .F.	// Baixa componentes
	Private lFimOp			:= .F.	// Finaliza OP alimentando estoque
	Private lBxFalta		:= .F.	// Baixa itens lista de faltas
	Private nQtd1			:= 0
	Private nQtd2			:= 0
	Private nQtd3			:= 0
	Private nVcust1			:= 0
	Private nVcust2			:= 0
	Private nVcust3			:= 0
	Private cCcusto			:= ""
	Private aAreaSX5		:= {}
	Private _cObserv		:= ""
	PRIVATE LMSERROAUTO		:= .F.	// INDICA SE GEROU ERRO NA TRANSACAO
	PRIVATE CPRODSD3		:= ""		// PRODUTO
	PRIVATE NQTDSD3	   		:= 0		// QUANTIDADE
	PRIVATE oListBox 		:= NIL
	Private aArqlist		:= {{"","","","","",""}}
	Private oVerde 			:= LoadBitmap( GetResources(), "BR_VERDE_OCEAN" 		)
	Private oVermelho		:= LoadBitmap( GetResources(), "BR_VERMELHO_OCEAN" 	)
	Private _cCod			:= SPACE(15)
	Private _cDescric		:= SPACE(30)
	Private _oCod			:= Nil
	Private _oDescr			:= Nil
	Private _lReqOk			:= .F.
	Private cArqPRN
	Private cLocal
	Private cProd
	Private cRev
	Private _nCol 			:= 0
	Private _lGerou			:= .F.

	//CASO NAO SEJA MASIPACK, UTILIZAR VERSAO ANTIGA DO RESTA003 NOMEADA COMO RESTA333
	///If SM0->M0_CODIGO <> '01'
	//	U_RESTA333()
	//	Return
	//EndIf

	_cUsuario  := RetCodUsr()
	_cUsuSenha := UsrRetname(_cUsuario)

	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario	:= PswRet()
		_cUsuSenha	:= UsrRetName(_cUsuario)
		cUsuarioSX5	:= Upper(Alltrim(_aUsuario[1][2]))
		cUsuarioSZS	:= Upper(Alltrim(_aUsuario[1][4]))
		_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
	EndIf

	DbSelectArea("SHB")
	SHB->(DBSetOrder(1))

	cSetor   := Space(30)
	_dtIni	 := CTOD("")
	_dtFim	 := CTOD("")
	nDias    := GetMV("MV_MSDDPRD")

//	If (_cUsuSenha $ SuperGetMv("MS_APONDT",,"")) .OR. (_cDeptoUsu $ SuperGetMv("MS_APONDT",,""))
	If _cUsuario $ GetMv("MS_APONDT") .Or. FwIsAdmin()
		_lAltDt := .T.
	EndIf

	Do While _lProc

   //		aCaminho := {" ","L:\USINAGEM\CNC\PROG\FRESAS\DISCOVER\","L:\USINAGEM\CNC\PROG\FRESAS\DISC1250\"} Alterado letra do diretorio
        aCaminho := {" ","J:\USINAGEM\CNC\PROG\FRESAS\DISCOVER\","J:\USINAGEM\CNC\PROG\FRESAS\DISC1250\"}
		cCaminho := Space(50)
		_cNumOP  := Space(11)
		cTE      := Space(15)
		cProg    := Space(15)
		_cCod	 := SPACE(15)
		_cDescric:= SPACE(30)
		nQtde    := 0
		_cPosic	 := "   "
		_aPrat	 := {"T001","T003","T004"}
		_cPrat	 := " "
		fRet     := .F.
		aArqlist	:= {{"","","","","",""}}
		_lExiste	:= .F.

		If SUBSTR(_cDeptoUsu,1,3) $ "201*205*207" //MONTAGEM, ALMOXARIFADO E PCP
			_cSetup	:= '   :  '
			_cTempo	:= '   :  '
			_cPict	:= '@E 999:99'
			_cMask	:= 'hhh:mm'
		Else
			_cSetup	:= '  :  '
			_cTempo	:= '  :  '
			_cPict	:= '@E 99:99'
			_cMask	:= 'hh:mm'
		EndIf

		_nMao		:= 0
		_nRecG2	:= 0
		_lAltMao	:= .F.
		_lAltTem	:= .F.
		@ 000,000 To 575,775 Dialog _oDlg1 Title OemToAnsi("PCP - Acompanhamento das OP's")
		@ 009,011 To 270,190
		@ 009,192 To 270,385
		@ 015,020 Say OemToAnsi("Setor:")				  				 								Size 070,008
		@ 030,020 Say OemToAnsi("Recurso:")																Size 070,008
		@ 045,020 Say OemToAnsi("Caminho.....................:")				  					Size 070,008
		@ 060,020 Say OemToAnsi("Programa....................:")				 					Size 070,008
		@ 075,020 SAY OemToAnsi("Prateleira..................:")									Size 070,008
		@ 090,020 SAY OemToAnsi("Posicao.....................:")									Size 070,008
		@ 105,020 Say OemToAnsi("_____________________________________________________")	Size 210,008
		@ 120,020 Say OemToAnsi("Ordem de produ็ใo.:")												Size 070,008
		@ 135,020 Say OemToAnsi("Qtde........................:")					  				Size 070,008
		@ 150,020 Say OemToAnsi("C๓digo do produto...:")						  					Size 070,008
		@ 165,020 SAY OemToAnsi("Descri็ใo.................:")				 						Size 070,008
		@ 180,020 Say OemToAnsi("Tratamento Externo..:")						  					Size 070,008
		@ 195,020 SAY OemToAnsi("Data inicio.................:")				 					Size 070,008
		@ 210,020 SAY OemToAnsi("Data fim....................:")				 					Size 070,008
		@ 225,020 SAY OemToAnsi("SET UP......................:")									Size 070,008
		@ 240,020 SAY OemToAnsi("TEMPO PC.................:")										Size 070,008
		@ 255,020 SAY OemToAnsi("Mao de Obra.............:")										Size 070,008
		@ 225,122 SAY OemToAnsi(_cMask)																Size 070,008
		@ 240,122 SAY OemToAnsi(_cMask)																Size 070,008
		@ 015,265 SAY OemToAnsi("O P E R A ว ี E S")												Size 100,100 COLOR CLR_RED

		@ 025,195 LISTBOX oListBox Fields HEADER "","Oprac","C๓d","Desc.","Temp. Pe็a","SET UP" SIZE 188,235 OF _oDlg1 PIXEL ColSizes 10,18,27,58,35,20
		oListBox:SetArray(aArqList)
		oListBox:bLine := {|| {	IIF(!EMPTY(aArqList[oListBox:nAt][1]),oVerde,oVermelho),;
		aArqList[oListBox:nAt][2],;
		aArqList[oListBox:nAt][3],;
		aArqList[oListBox:nAt][4],;
		aArqList[oListBox:nAt][5],;
		aArqList[oListBox:nAt][6]}}

//		@ 015,038 Get			cCodSet 		Valid ValidaSetor()	F3 "SHB_1"																Size 030,008
//		@ 015,067 BUTTON "?" 	SIZE 006,010 PIXEL OF oPsqSHB ACTION UndoFilter()

		oGet02 := TGet():New(015,045,{|u| If(PCount() > 0, cCodSet := u, cCodSet) },_oDlg1,030,008,"@!",{|| NAOVAZIO() .AND. ExistCpo('SHB',cCodSet,1) .AND. ValidaSetor() },CLR_BLACK,CLR_WHITE,,.F.,,.T.,,.F.,,.F.,.F.,{|| .T. },.F.,.F.,,'cCodSet',,,,.T.,,,)
        oGet02:cF3 := 'SHB_1'

		@ 015,080 Get 	  		cSetor 		WHEN .F.								 															Size 100,008
		@ 030,045 Get			cRecurso		WHEN .F.																							Size 135,008
		@ 045,075 ComboBox 	cCaminho		Items aCaminho								  						  							Size 105,008 OBJECT oCaminho
		@ 060,075 Get 	  		cProg 		Valid ValidaProg()	Picture "@!"			 						  					Size 045,008 OBJECT oProg
		@ 075,075 ComboBox 	_cPrat 		Items _aPrat														  							Size 045,008 OBJECT oPrat
		@ 090,075 Get 	 		_cPosic												   							 							Size 045,008 OBJECT oPosic
		@ 120,075 Get 	 		_cNumOP		Valid ValidaOP()						 							  				  			Size 055,008 OBJECT oOP
		@ 135,075 Get 	 		nQtde 		Valid ValidaQtde()	Picture "@E 9999" 		 					  					Size 035,008
		@ 150,075 Get			_cCod			WHEN .F.																							Size 050,008 OBJECT _oCod
		@ 165,075 Get			_cDescric	WHEN .F.																							Size 110,008 OBJECT _oDescr
		@ 180,075 Get 	 		cTE 						 				Picture "@!" 			When ("TRAT.EXTERNO" $ cSetor .OR. "AGUARD MP" $ cSetor )	Size 070,008
		@ 195,075 Get 			_dtIni		Valid ValidaDI() 						 			When _lAltDt			  	  			Size 045,008 OBJECT oDini
		@ 210,075 Get 			_dtFim		Valid ValidaDF() 						 			When _lAltDt				 			Size 045,008 OBJECT oDfim

		@ 225,075 MsGet _cSetup PICTURE _cPict	When _lAltTem	Size 045,008 PIXEL OF _oDlg1 VALID RTA03B(_cSetup)
		@ 240,075 MsGet _cTempo PICTURE _cPict	When _lAltTem	Size 045,008 PIXEL OF _oDlg1 VALID RTA03B(_cTempo)
		@ 255,075 MsGet _nMao   PICTURE "99"	When _lAltMao	Size 045,008 PIXEL OF _oDlg1

		@ 272,095 BmpButton Type 1 	Action 	Processa( { || AtualizaOP() })
		@ 272,129 BUTTON "Tempo" SIZE 028,011 PIXEL OF _oDlg1 ACTION RTA03A()
		@ 272,165 BmpButton Type 2 	Action _fFinaliza()

		@ 272,210 BITMAP oBmp RESNAME "BR_VERDE_OCEAN" 		PIXEL oF _oDlg1 SIZE 050,050 NOBORDER
		@ 272,300 BITMAP oBmp RESNAME "BR_VERMELHO_OCEAN" 	PIXEL oF _oDlg1 SIZE 050,050 NOBORDER
		@ 272,220 SAY "Apontamento Efetuado" 		Size 070,008
		@ 272,310 SAY "Pendente de Apontamento" 	Size 070,008

		If Alltrim(cSetor) <> ""
			If SubStr(Alltrim(cSetor),1,5) == "FRESA" .AND. !(("ANALISE" $ cSetor) .OR. ("ENTREGUE" $ cSetor))
				oCaminho:SetFocus()
			Else
				cCaminho := Space(50)
				oOP:SetFocus()
			EndIf
		EndIf

		Activate Dialog _oDlg1 Centered
	EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  04/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fFinaliza()

	_lProc := .F.
	_oDlg1:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  04/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaSetor()

	fRet		:= .T.
	_cNumOP	:= Space(11)
	cCcusto	:= ""

	If !Empty(Alltrim(cCodSet))
		cCodSetor := cCodSet
		cValidMsg := SHB->HB_MSMSG
		SHB->(DbSetOrder(1))
		If SHB->(DbSeek(xFilial("SHB")+cCodSetor))
			cSetor	:= SHB->HB_NOME
			cCcusto	:= SHB->HB_CC
			dbSelectArea("SH1")
			SH1->(dbSetOrder(1))
			If SH1->(dbSeek(xFilial("SH1")+SHB->HB_MSRECUR))
				cRecurso := SHB->HB_MSRECUR + " - " + SH1->H1_DESCRI
			EndIf
			If Alltrim(cSetor) <> Alltrim(SHB->HB_NOME)
				ApMsgStop("Setor Incoerente - Escolha um Setor")
//				UndoFilter()
				fRet := .F.
			Else
				If SubStr(Alltrim(cSetor),1,5) <> "FRESA"
					oOP:SetFocus()
				EndIf
			EndIf
		ELSE
			ApMsgStop("Setor Invแilido - Nใo encontrado")
//			UndoFilter()
			fRet := .F.
		EndIf
	Else
		ApMsgStop("Escolha um Setor!!")
//		UndoFilter()
		fRet := .F.
	EndIf


Return fRet


/*/{Protheus.doc} UndoFilter
	//TODO Retorna o filtro caso o usuแrio venha acionar o filtro de pesquisa novamente.
	@author alison.goncalves
	@since 21/03/2018
	@version 1.0
	@type function
/*/
Static Function UndoFilter()
	Local aCT := & (Alltrim(GetMV("MS_CENTRAB")))                                                                                                                                                                      
	nRetCT := Ascan(aCT,{|x|x[1]==SubStr(_cDeptoUsu,1,3)})
	If CONPAD1(,,,IIF(nRetCT>0,aCT[nRetCT][2],"SHB"),cCodSet,,.F.)  
		cCodSet	:= SHB->HB_COD
		cSetor	:= SHB->HB_NOME
		cCcusto	:= SHB->HB_CC
	
		ValidaSetor()
	EndIF
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  04/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaOP()

	fRet  := .T.
	cMP   := ""
	cMens := ""
	cCC := ""
	_NQSB1:= 0
	_NQSB2:= 0

	If Alltrim(_cNumOP) <> ""
		If Len(Alltrim(_cNumOP)) < 11
			_cNumOP := Alltrim(_cNumOP) + "01001"
		EndIf
		SC2->(DbSetOrder(1))
		SC2->(DbGoTop())
		If SC2->(DbSeek(xFilial("SC2")+_cNumOP))
			cProduto := Alltrim(SC2->C2_PRODUTO)
			_cProd	:= SC2->C2_PRODUTO          // LIZANDRA
			IF Alltrim(cCodSetor) == "205100"
				IF SG1->(DBSEEK(xFilial("SG1")+cProduto))
					lTS := .F.
					WHILE !lTS .AND. ALLTRIM(SG1->G1_COD) == ALLTRIM(cProduto) .AND. !SG1->(EOF())
						IF SUBSTR(SG1->G1_COMP,1,2) == "TS"
							lTS := .T.
						ENDIF
						SG1->(DBSKIP())
					ENDDO
					IF !lTS
						cMens := "Produto sem TS cadastrado em sua estrutura! Favor avisar Engenharia."
						U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens)
						GravaSZS()
					ENDIF
				ENDIF
			ENDIF
			If !Empty(SC2->C2_DATRF)
				U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde,"Ordem de produ็ใo jแ concluida em: "+DTOC(SC2->C2_DATRF))
				IF Alltrim(cCodSetor) == "205999"
					cMens := cSetor
					RecLock("SC2",.F.)
					SC2->C2_MSPOSIC := cMens
					SC2->(MsUnlock())
				ENDIF
				fRet := .F.
			Else
				_cQry := " SELECT
				_cQry += " 		TOP 1 H6_QTDPROD QTD
				_cQry += " FROM " + RetSqlName("SH6") + " 
				_cQry += " WHERE 
				_cQry += " 		D_E_L_E_T_ 	= ' ' "
				_cQry += " AND 	H6_OP 		= '" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN + "' "
				_cQry += " ORDER BY R_E_C_N_O_ DESC "

				If Select("TMPC2") > 0
					TMPC2->(dbCloseArea())
				EndIf

				TCQUERY _cQry NEW ALIAS "TMPC2"

				TMPC2->(dbGoTop())

				If TMPC2->(!EOF())
					nQuant := TMPC2->QTD
				Else
					nQuant := SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
				EndIf

				If nQuant  < 0
					nQuant := 0
				EndIf

				If Select("TMPC2") > 0
					TMPC2->(dbCloseArea())
				EndIf

				SD4->(DbSetOrder(2))
				If SD4->(DbSeek(xFilial("SD4")+_cNumOP))
					If Alltrim(cSetor) == "AGUARDANDO MATERIA-PRIMA"
						Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_OP) == Alltrim(_cNumOP)
							If SubStr(SD4->D4_COD,1,2) == "MP"
								cMP += SD4->D4_COD + " "
							EndIf
							SD4->(DbSkip())
						EndDo
					EndIf
				EndIf
			EndIf
		Else
			ApMsgStop("Ordem de produ็ใo nใo encontrada! "+_cNumOP)
			fRet := .F.
		EndIf
	EndIf

	If fRet    ////////////////LIZANDRA VERIFICAR QUANDO A QUANTIDADE FOR MAIOR.... QUE C2_QUANT
		/*
		VICTOR DESSUNTE - 23/05/2016
		RECUPERA TEMPOS UTILIZADOS NA OPERACAO
		*/
		If !Empty(_cNumOp)
			_cCod := SC2->C2_PRODUTO
			_oCod:cCaption := _cCod
			_oCod:Refresh()

			_cDescric := POSICIONE("SB1",1,XFILIAL("SB1")+SC2->C2_PRODUTO,"B1_DESC")
			_oDescr:cCaption := _cDescric
			_oDescr:Refresh()

			If !Empty(SHB->HB_MSRECUR)
				_nRecG2 := VerG2(SC2->C2_PRODUTO,SHB->HB_MSRECUR,1,_cNumOp)
				If _nRecG2 > 0
					dbSelectArea("SG2")
					SG2->(dbGoTo(_nRecG2))
				Else
					//Caso nao encontrar o recurso, altera o roteiro de operacoes.
					_nRecG2 := VerG2(SC2->C2_PRODUTO,SHB->HB_MSRECUR,2,_cNumOp)
					If _nRecG2 > 0
						dbSelectArea("SG2")
						SG2->(dbGoTo(_nRecG2))
						If SC2->C2_PRODUTO == SG2->G2_PRODUTO
							RecLock("SG2",.F.)
							SG2->G2_RECURSO := SHB->HB_MSRECUR
							SG2->(MsUnlock())
						EndIf
					Else
						_nRecG2 := VerG2(SC2->C2_PRODUTO,SHB->HB_MSRECUR,3,_cNumOP)
						If _nRecG2 > 0
							dbSelectArea("SG2")
							SG2->(dbGoTo(_nRecG2))
						Else
							//MONTAGEM
							If SUBSTR(SHB->HB_COD,1,3) == '201' .AND. Alltrim(SB1->B1_UM) == 'CJ'
								_cQuery := "SELECT COUNT(*) OPERACAO "
								_cQuery += "FROM " + RetSqlName("SG2") + " SG2 "
								_cQuery += "WHERE SG2.D_E_L_E_T_ = '' AND SG2.G2_PRODUTO = '" + SC2->C2_PRODUTO + "' AND SG2.G2_OPERAC = '01'"
								
								If Select("TOPR") > 0
									TOPR->(dbCloseArea())
								EndIf 
								
								dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), "TOPR", .F., .T.) 
								dbSelectArea("TOPR")
								TOPR->(dbGoTop()) 								
								
								If TOPR->OPERACAO == 0	
								RecLock("SG2",.T.)
								SG2->G2_FILIAL 	:= '01'
								SG2->G2_CODIGO 	:= '01'
								SG2->G2_PRODUTO 	:= SC2->C2_PRODUTO
								SG2->G2_OPERAC		:= '01'
								SG2->G2_RECURSO	:= SHB->HB_MSRECUR
								SG2->G2_TEMPAD		:= 8
								SG2->G2_MAOOBRA	:= 1
								SG2->(MsUnlock())
								_nRecG2 := SG2->(RECNO())
								TOPR->(dbCloseArea())
								EndIf
							//ALMOXARIFADO
							ElseIf SUBSTR(_cDeptoUsu,1,3) == "205" .AND. SUBSTR(SHB->HB_COD,1,3) == "205" .AND. Alltrim(SB1->B1_UM) == 'CJ'
								_cQuery := "SELECT COUNT(*) OPERACAO "
								_cQuery += "FROM " + RetSqlName("SG2") + " SG2 "
								_cQuery += "WHERE SG2.D_E_L_E_T_ = '' AND SG2.G2_PRODUTO = '" + SC2->C2_PRODUTO + "' AND SG2.G2_OPERAC = '99'"
								
								If Select("TOPR2") > 0
									TOPR2->(dbCloseArea())
								EndIf 

								dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), "TOPR2", .F., .T.) 
								dbSelectArea("TOPR2")
								TOPR2->(dbGoTop())
								
								If TOPR2->OPERACAO == 0				
									RecLock("SG2",.T.)
									SG2->G2_FILIAL 	:= '01'
									SG2->G2_CODIGO 	:= '01'
									SG2->G2_PRODUTO := SC2->C2_PRODUTO
									SG2->G2_OPERAC		:= '99'
									SG2->G2_RECURSO	:= SHB->HB_MSRECUR
									SG2->G2_TEMPAD		:= 0.0001
									SG2->G2_MAOOBRA	:= 1
									SG2->(MsUnlock())
									_nRecG2 := SG2->(RECNO())		
									TOPR2->(dbCloseArea())
								EndIf
							Else
								Alert("Roteiro de opera็๕es nใo cadastrado!")
								fRet := .F.
							EndIf
						EndIf
					EndIf
				EndIf

				If SC2->C2_PRODUTO == SG2->G2_PRODUTO .AND. ALLTRIM(SHB->HB_MSRECUR) $ SG2->G2_RECURSO
					_cSetup 	:= STRZERO(INT(SG2->G2_SETUP) ,IIF(SUBSTR(_cDeptoUsu,1,3)$'201*205',3,2))+':'+STRZERO((SG2->G2_SETUP-INT(SG2->G2_SETUP))*60,2)
					_cTempo	:= STRZERO(INT(SG2->G2_TEMPAD),IIF(SUBSTR(_cDeptoUsu,1,3)$'201*205',3,2))+':'+STRZERO((SG2->G2_TEMPAD-INT(SG2->G2_TEMPAD))*60,2)
					_nMao	:= SG2->G2_MAOOBRA
				EndIf

				_cQry := " SELECT MAX(G2_OPERAC) OPERAC FROM " + RetSqlName("SG2") + " WHERE D_E_L_E_T_ = ' ' AND G2_PRODUTO = '" + SC2->C2_PRODUTO + "' "

				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf

				TCQUERY _cQry NEW ALIAS "TRB"

				If TRB->(!EOF())
					_cUltOpe := TRB->OPERAC
				EndIf

				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf

				If Empty(aArqList[1][2])
					_cQry := " SELECT 																					" + CRLF
					_cQry += "		ISNULL(H6_OP,'') APONT,															" + CRLF
					_cQry += "		G2_OPERAC	,																		" + CRLF
					_cQry += "		G2_RECURSO	,																		" + CRLF
					_cQry += "		H1_DESCRI	,																		" + CRLF
					_cQry += "		G2_TEMPAD	,																		" + CRLF
					_cQry += "		G2_SETUP																				" + CRLF
					_cQry += " FROM 																						" + CRLF
					_cQry +=   		RetSqlName("SG2") + " G2 INNER JOIN " + RetSqlName("SH1") + " H1	" + CRLF
					_cQry += "		ON	H1.D_E_L_E_T_	= ' '															" + CRLF
					_cQry += "		AND H1_CODIGO		= G2_RECURSO												" + CRLF
					_cQry += "		LEFT JOIN " + RetSqlName("SH6") + " H6										" + CRLF
					_cQry += "		ON	 H6.D_E_L_E_T_	= ' '															" + CRLF
					_cQry += " 		AND H6_OP			= '" + _cNumOp + "'										" + CRLF
					_cQry += "		AND H6_OPERAC		= G2_OPERAC													" + CRLF
					_cQry += " WHERE																						" + CRLF
					_cQry += "		G2.D_E_L_E_T_	= ' ' 															" + CRLF
					_cQry += " AND	G2_FILIAL		= '" + xFilial("SG2") 	+ "' 								" + CRLF
					_cQry += " AND	G2_PRODUTO		= '" + SC2->C2_PRODUTO 	+ "'								" + CRLF
					_cQry += " AND	G2_CODIGO		= '" + IIF(EMPTY(SC2->C2_ROTEIRO),'01'	,SC2->C2_ROTEIRO)	+ "'	" + CRLF
					_cQry += " ORDER BY G2_OPERAC																		"

					If Select("TRBG2") > 0
						TRBG2->(dbCloseArea())
					EndIf

					TCQUERY _cQry NEW ALIAS "TRBG2"

					TRBG2->(dbGoTop())
					While TRBG2->(!EOF())
						AADD(aArqList,{	TRBG2->APONT		,;
						TRBG2->G2_OPERAC	,;
						TRBG2->G2_RECURSO	,;
						TRBG2->H1_DESCRI	,;
						STRZERO(INT(TRBG2->G2_TEMPAD),IIF(SUBSTR(_cDeptoUsu,1,3)$'201*205',3,2))+':'+STRZERO((TRBG2->G2_TEMPAD-INT(TRBG2->G2_TEMPAD))*60,2)	,;
						STRZERO(INT(TRBG2->G2_SETUP) ,IIF(SUBSTR(_cDeptoUsu,1,3)$'201*205',3,2))+':'+STRZERO((TRBG2->G2_SETUP-INT(TRBG2->G2_SETUP))*60,2)		})
						TRBG2->(dbSkip())
					End
					ADEL(aArqList,1)
					ASIZE(aArqList,Len(aArqList)-1)
					oListBox:Refresh()
				EndIf
			EndIf
		EndIf

		//VERIFICA SE JA EXISTE APONTAMENTO DA OPERACAO
		If ASCAN(aArqList,{|x|x[2]==SG2->G2_OPERAC .AND. !EMPTY(x[1])}) > 0
			Alert("Opera็ใo jแ apontada!")
			fRet := .F.
		EndIf

		nQtde := nQuant
	Else
		GravaSZS()
		nQtde  := 0
		nQuant := 0
	EndIf

Return fRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  04/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaQtde()

	fRet := .T.

	If nQtde > 0
		If (nQtde <> nQuant) .And. (nQtde < (nQuant * 0.90) .Or. nQtde > (nQuant * 1.10))
			If !apMsgYesNo("Qtde.digitada e Qtde.da ultima opera็ใo fora do limite de 10%, Confirma ?")   //MsgBox(cMens,"AVISO","YESNO")
				fRet  := .F.
				cMens := ""
			Else
				GravaSZS()
			EndIf
		EndIf

		//VICTOR DESSUNTE - 19/01/2017
		//INICIO - TICKET: 2017011837000178 
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณNAO PERMITE APONTAMENTO DIFERENTE DA QUANT.       ณ
		//ณCASO SEJA LISTA OU B1_UM = 'CJ' POIS ELE REQUISITAณ
		//ณTODO O CUSTO DAS REQUISICOES PARA O PRIMEIRO      ณ
		//ณAPONTAMENTO, SENDO QUE DEVE SER RATEADO POR       ณ
		//ณIGUAL ENTRE A QUANTIDADE PRODUZIDA                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (Alltrim(SC2->C2_MSLISTA) == 'S' .OR. Alltrim(SB1->B1_UM) == 'CJ') .AND. SC2->C2_QUANT <> nQtde
			Alert("Nใo ้ permitido apontamento com a quantidade diferente da OP para Listas e produtos tipo 'CJ'")
			fRet := .F.
		EndIf	
		//FIM - TICKET: 2017011837000178 
	EndIf

Return fRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  04/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaProg()

	fRet     := .T.
	cOrigem  := ""
	cDestino := ""
	cMens := ""
	If SubStr(cCodSetor,1,3) == "202"
		If !Empty(Alltrim(cProg))
			cOrigem := Alltrim(cCaminho)+Alltrim(cProg)
			cDestino:= "Y:\MแQUINA " + SubStr(cCodSetor,5,2)
			cArq    := Alltrim(cCaminho)+Alltrim(cProg)+ "*.*"
			If !File(cArq)
				ApMsgStop("Programa nใo encontrado - Digite corretamente o Caminho\Programa")
				GravaSZS()
				cOrigem := ""
				cProg   := Space(15)
				oProg:SetFocus()
			Else
				If !File(cDestino)
					ApMsgStop("Nใo existe a pasta Destino => " + cDestino)
					IF !EMPTY(_cNumOP)
						GravaSZS()
					ENDIF
					cDestino := ""
					cProg   := Space(15)
				EndIf
			EndIf
		EndIf
	EndIf

Return fRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  04/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtualizaOP()

	Local aSX5ZC		:= {}
	Local aSX5ZD		:= {}
	Local _aFaltantes	:= {}
	Local _oDlg			:= Nil
	Local oList1		:= Nil
	Local nList1		:= 1
	Local I, _nX

	//VICTOR DESSUNTE - 22/02/2017
	//INICIO - TICKET:2017022237000051 
	Local _aGoToFalta	:= {}
	//FIM - TICKET:2017022237000051

	If Alltrim(_cNumOP) == "" .Or. nQtde == 0
		apMsgAlert("Dados incoerentes (OP em branco ou Qtde = zeros) - Confira-os")
		fRet := .F.
		Return
	EndIf

	If nQtde > (SC2->C2_QUANT * 4)       // Verifica se houve altera็ใo do campo nqtde
		apMsgStop("Qtde. muito acima da OP => " + Str(nQtde,4))
		fRet := .F.
		Return
	EndIf

	If Alltrim(cDestino) <> ""
		cArq    := Alltrim(cCaminho)+Alltrim(cProg)+ ".*"
		If File(cArq)
			__CopyFile(cArq,cDestino)     // Copia um unico programa Exemplo: 206.mpf
		Else
			For I := 1 to 20              // Copia varios programas Exemplo: 50940601.mpf, 02.mpf e 03.mpf
				cArq := cOrigem + StrZero(I,2) + ".*"
				If File(cArq)
					__CopyFile(cArq,cDestino)
				EndIf
			Next I
		EndIf
	EndIf

	If !Empty(SHB->HB_MSRECUR)
		_nRecG2 := VerG2(SC2->C2_PRODUTO,SHB->HB_MSRECUR,1,_cNumOp)
		If _nRecG2 == 0
			_nRecG2 := VerG2(SC2->C2_PRODUTO,SHB->HB_MSRECUR,2,_cNumOp)
			If _nRecG2 == 0
				_nRecG2 := VerG2(SC2->C2_PRODUTO,SHB->HB_MSRECUR,3,_cNumOp)
				If _nRecG2 == 0
					Alert("Produto sem roteiro de opera็๕es cadastrado.")
					Return .F.
				EndIf
			EndIf
		EndIf
	EndIf

	RecLock("SC2",.F.)
	cMP := Alltrim(cMP)

	//VICTOR DESSUNTE - 18/04/2016
	IF !EMPTY(_dtIni) .AND. !EMPTY(_dtFim)
		SC2->C2_DATPRI := _dtIni
		SC2->C2_DATPRF := _dtFim
	ENDIF

	IF !("VERIFICAR" $ cSetor) .AND. !("FINALIZADA" $ cSetor) .AND. !("SEPARACAO" $ cSetor)
		If !Empty(cTE)
			SC2->C2_MSPOSIC := "(" + Alltrim(cCodSetor) +  ")- " +  Alltrim(cSetor) + " (" + ALLTRIM(cTE) + ") em " + DTOC(DATE()) + " - RESTA003"
		Else
			If !Empty(cMP)
				SC2->C2_MSPOSIC := "(" + Alltrim(cCodSetor) +  ")- " + Alltrim(cSetor) + " (" + cMP + ") em " + DTOC(Date()) + " - RESTA003"
			Else
				IF SUBSTR(cNumEmp,1,2) $ "01" .AND. SHB->HB_COD == "207300"  // ALTERAวรO FEITA A PEDIDO DO ALEXANDRE (PCP) EM 05/09/13 - LIZANDRA
					SC2->C2_MSPOSIC := "(" + Alltrim(cCodSetor) +  ")- " + Alltrim(cSetor) + " em " + DTOC(_dtIni) + " - RESTA003"
				ELSEIF ("FRESA" $ cSetor) .OR. ("TORNO" $ cSetor)  // ALTERAวรO FEITA A PEDIDO DO ALEXANDRE (PCP) EM 07/02/14 - LIZANDRA
					SC2->C2_MSPOSIC := "(" + Alltrim(cCodSetor) +  " / P" + STRZERO(VAL(_cPosic),3) + ")-" + Alltrim(cSetor) + " em " + DTOC(Date()) + " - RESTA003"
				ELSE
					SC2->C2_MSPOSIC := "(" + Alltrim(cCodSetor) +  ")-" + Alltrim(cSetor) + " em " + DTOC(Date()) + " - RESTA003"
				ENDIF
			EndIf
		EndIf
		cMens := SC2->C2_MSPOSIC
	ELSE
		cMens := "(" + Alltrim(cCodSetor) +  ")-" + Alltrim(cSetor) + " - RESTA003"
	ENDIF

	If SHB->HB_MSBXIT == "S" .Or. _cDeptoUsu $ "203-MAKLASER" .Or. ("ANALISE" $ cSetor) .Or. (_cDeptoUsu $ "PCP" .AND. SHB->HB_MSBXIT == "S")
		If Empty(SC2->C2_DATAJI)
			SC2->C2_DATAJI := Date()
		EndIf
		SC2->C2_MSULTQT := nQtde
	EndIf


	lFinalizada := .F.
	IF ("FINALIZADA" $ cSetor)
		DbSelectArea("SZS")
		SZS->(DbSetOrder(2))
		IF SZS->(DBSEEK(xFilial("SZS") + _cNumOP))
			WHILE ALLTRIM(SZS->ZS_OP) == ALLTRIM(_cNumOP) .and. !SZS->(EOF()) .AND. !lFinalizada
				IF cCodSetor $ SZS->ZS_POSICAO  // nao deixa que a OP seja finalizada no mesmo setor 2 vezes. Isso e necessario pq a mesma OP pode ser finalizada na Funilaria e na Pintura, por exemplo
					lFinalizada := .T.
				ENDIF
				SZS->(DBSKIP())
			ENDDO
		ENDIF
		IF !lFinalizada    // gravara o log pela 1.a vez
			IF SC2->C2_DATPRF > DATE()
				cMens += " - ADIANTADA. Fim Previsto: " + DTOC(SC2->C2_DATPRF)
			ENDIF
			IF SC2->C2_DATPRF + 3 < DATE()
				cMens += " - ATRASADA " + STR(DATE() - SC2->C2_DATPRF,3,0) + " dias. - Fim Previsto: " + DTOC(SC2->C2_DATPRF) + " - Impressao: " + DTOC(SC2->C2_MSIMPR)
				IF !EMPTY(SC2->C2_MSCI)
					cMens += " - CI: " + SC2->C2_MSCI
				ENDIF
			ENDIF
			IF ("OP FINALIZADA S/ BAIXA DE OP" $ cMens) .and. (SUBSTR(cNumEmp,1,2) $ "10") 
				SC2->C2_MSPOSIC := cMens
			EndIf 
		ELSE
			cMens := ""
		ENDIF
	ENDIF
		
	SC2->(MsUnlock())

	GravaSZS() // Log do Apontamento de Producao

	nQtdSD4 := 0
	nQtdSC2 := 0

	SD4->(DBSetOrder(3))
	SD4->(DBGoTop())
	SD4->(DbSeek(xFilial("SD4")+cProduto))
	Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_COD) == cProduto
		If SD4->D4_QUANT > 0 .And. SD4->D4_MSLF == "X"
			nQtdSD4 += SD4->D4_QUANT
		EndIf
		SD4->(DbSkip())
	EndDo

	IF nQtdSD4 > 0
		SC2->(DBSetOrder(2))
		SC2->(DBGoTop())
		SC2->(DbSeek(xFilial("SC2")+cProduto))
		Do While !SC2->(Eof()) .And. Alltrim(SC2->C2_PRODUTO) == cProduto
			If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> _cNumOP
				If Empty(SC2->C2_DATRF) .And. (SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)) > 0 .And. !Empty(SC2->C2_DATAJI)
					nQtdSC2 += (SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA))
				EndIf
			EndIf
			SC2->(DbSkip())
		EndDo
		SC2->(DbSetOrder(1))
		SC2->(DbGoTop())
		SC2->(DbSeek(xFilial("SC2")+_cNumOP))
	ENDIF

	If nQtdSC2 < nQtdSD4
		U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, "Esta pe็a estแ em Lista de Falta. Favor colocar Etiqueta de Lista de Falta (azul)")
	EndIf

	aSD4 := {}
	aAreaSX5 := SX5->(GetArea())

	If SHB->HB_MSBXIT == "S"    // baixa itens da OP
		SD4->(DbSetOrder(2))
		SD4->(DbGotop())
		If SD4->(DbSeek(xFilial("SD4") +_cNumOP))
			Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_OP) == Alltrim(_cNumOP)
				_lReqOk := .F.

				If SD4->D4_QUANT <= 0
					SD4->(dbSkip())
					Loop
				EndIf

				nEstoque := 0
				DbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+Alltrim(SD4->D4_COD)))
					IF SB1->B1_MSBLQL <> "1"   // LINHA INCLUIDA PARA VERIFICAR SE O PORDUTO ESTม BLOQUEADO NO SB1 - LIZANDRA 15/03/12
						SB2->(dbSetOrder(1))
						If SB2->(DbSeek(xFilial("SB2")+SD4->D4_COD+"01"))
							nEstoque := SB2->B2_QATU
						ENDIF
					ELSE   //LIZANDRA 15/03/12
						cMens := "PRODUTO " + SB1->B1_COD + " BLOQUEADO (B1_MSBLQL). Favor procurar Engenharia ou PCP."
						U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens)
						GravaSZS()
						EXIT  //LIZANDRA 15/03/12
					ENDIF	 //LIZANDRA 15/03/12
				EndIf

				// Chapas sใo zerados devido a baixa por requisicoes
				// Codigos TS sao excluidos devido a Entrada das NFs de entrada do beneficiamento - muitas vezes atrasam demais
				// If SubStr(SB1->B1_LOCAL,1,4) $ "2001_2002_2003_2004_2020_2021_2022_2023_2024_2025_2026_2028" .OR. SubStr(SD4->D4_COD,1,2) == "TS"

				/*
				VICTOR DESSUNTE - 18/07/2016
				- REQUISICAO DA MP SERA ATRAVES DO EMPENHO;
				- CASO TENHA SALDO EM ESTOQUE FARA A REQUISICAO ATRAVES DO EMPENHO PARA TS.
				*/
				//If SubStr(SD4->D4_COD,1,4) == "MP01" .OR. SubStr(SD4->D4_COD,1,2) == "TS"

				If SubStr(SD4->D4_COD,1,2) == "TS"
					_nReserv:=0
					SB2->(DbSetOrder(1))
					If SB2->(DbSeek(xFilial("SB2")+SD4->D4_COD+"01"))
						If SALDOSB2() <= 0
							_nReserv:=SB2->B2_RESERVA   // VARIมVEL CRIADA PARA DESCONTAR A QUANTIDADE RESERVADA PARA VENDA
							RecLock("SB2",.F.)
							SB2->B2_QEMP -= SD4->D4_QUANT
							If SB2->B2_QEMP < 0
								SB2->B2_QEMP := 0
							EndIf
							SB2->(MsUnlock())
							RecLock("SC2",.F.)
							SC2->C2_VATU1 += SB1->B1_CUSTD * SD4->D4_QUANT
							SC2->(MsUnlock())

							RecLock("SD4",.F.)
							SD4->D4_QUANT := 0
							SD4->D4_MSSEPAR := DATE()
							SD4->D4_MSCOMEN := "BAIXA DE ESTOQUE MANUAL"
							SD4->(MsUnlock())
							SD4->(dbSkip())
							Loop
						EndIf
					EndIf
				EndIf

				_nReserv:=0
				If SB2->(DbSeek(xFilial("SB2")+SD4->D4_COD+"01"))
					_nReserv:=SB2->B2_RESERVA   // VARIมVEL CRIADA PARA DESCONTAR A QUANTIDADE RESERVADA PARA VENDA
				ENDIF
				//    1     -    0,5        0,6
				If nEstoque -_nReserv >= SD4->D4_QUANT
					nQuant := SD4->D4_QUANT
				Else
					nQuant := nEstoque - _nReserv
				EndIf

				If nQuant < 0
					nQuant := 0
				EndIf

				If nQuant > 0
					If SubStr(SB1->B1_COD,1,2) == "TS"
						_lReqOk := .T.
					Else
//						SX5->(dbSetOrder(1))
//						SX5->(dbGoTop())
//						SX5->(dbSeek(xFilial("SX5")+"ZD"+cUsuarioSX5))
//						If nEstoque >= nQuant .And. (SubStr(SB1->B1_LOCAL,1,1) $ RTRIM(SX5->X5_DESCRI))
						aSX5ZD := FWGetSX5('ZD',SUBSTR(cUsuarioSX5,1,6))
						If Len(aSX5ZD) > 0
							aSX5ZD[1,4] := SPACE(2) + aSX5ZD[1,4]
							If nEstoque >= nQuant .And. (SubStr(SB1->B1_LOCAL,1,1) $ RTRIM(aSX5ZD[1,4]))
								If !("VERIFICAR" $ cSetor)     // Verificar itens so atualizara o LOG, nao a movimentacao
									If SB1->B1_CUSTD == 0
										RecLock("SB1",.F.)
										If nquant < 1
											SB1->B1_CUSTD := 1.0
										Else
											SB1->B1_CUSTD := 0.1
										Endif
										SB1->(MsUnlock())
									Endif
								EndIf
								_lReqOk := .T.
							
							Else
	//							If !(SubStr(SB1->B1_LOCAL,1,1) $ RTRIM(SX5->X5_DESCRI))
								If !(SubStr(SB1->B1_LOCAL,1,1) $ RTRIM(aSX5ZD[1,4]))
									cMens := "Verificar com Informatica se usuario pode baixar item da OP (Tabela Generica ZD) - Local: " + ALLTRIM(SB1->B1_LOCAL) + " - Produto: " + ALLTRIM(SB1->B1_COD) + " - " + SB1->B1_DESC
									U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens)
									GravaSZS()
								EndIf
								If nEstoque < nQuant
									cMens := "Verificar Saldo do Produto"
									Alert(cMens)
									GravaSZS()
								EndIf
							
							EndIf
						
						EndIf
					
					Endif

					If _lReqOk
						// As linhas abaixo foram criadas para gravar movimentacao na tabela SD3 - FMD 09/11/10
						// Baixa Componentes
						nQtd1		:= nQuant
						nVCust1		:= SB1->B1_CUSTD * nQuant
						_cObserv	:= "(" + cSetor + "XXX)" + "RESTA003 - Baixado"
						lBxComp		:= .T.
						LMSERROAUTO	:= .F.
						GravaSD3()

						If LMSERROAUTO == .T.
							U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, "Apresentou erro ao realizar baixa da OP: " + ALLTRIM(sd4->d4_op) + "Favor entrar em contato com o depto. de informแtica", "Erro Baixa de OP")
							Return()
						Endif
					EndIf
				EndIf

				SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD))
				IF SUBSTR(SD4->D4_COD,1,3) <> "MOD"
					If SD4->D4_QUANT > 0
						cMens := ""
						IF !("VERIFICAR" $ cSetor)
							IF SubStr(SB1->B1_LOCAL,1,1) $ " FU2"
								RecLock("SD4",.F.)
								SD4->D4_MSLF := "X"
								SD4->D4_MSSEPAR := DATE()
								SD4->(MsUnlock())
							EndIf
							cMens := "ATENCAO! Comp.Faltante: " + ALLTRIM(SB1->B1_COD) + " - " + ALLTRIM(SB1->B1_DESC) + " - Qde: " + STR(SD4->D4_QUANT,10,3) + " - Local: " + ALLTRIM(SB1->B1_LOCAL) +CHR(13)+CHR(10)
						ELSE
							IF nQuant < SD4->D4_QUANT
								cMens := "ATENCAO! Comp.Faltante: " + ALLTRIM(SB1->B1_COD) + " - " + ALLTRIM(SB1->B1_DESC) + " - Qde: " + STR(SD4->D4_QUANT,10,3) + " - Local: " + ALLTRIM(SB1->B1_LOCAL) +CHR(13)+CHR(10)
							ENDIF
						ENDIF

						cMens2 := ""

						IF !EMPTY(cMens)
							cMens2 := Alltrim(cMens)
							GravaSZS()
						ENDIF

						IF "Comp.Faltante" $ cMens
							cMens := ""
							SC2->(DBSETORDER(2))
							IF SC2->(DBSEEK(xFilial("SC2") + SD4->D4_COD))
								WHILE SC2->C2_PRODUTO == SD4->D4_COD .AND. !SC2->(EOF())
									IF EMPTY(SC2->C2_DATRF) .AND. !EMPTY(SC2->C2_MSPOSIC)
										cMens := ALLTRIM(SC2->C2_MSPOSIC) + "Comp.: " + ALLTRIM(SD4->D4_COD) + " - pela OP: " + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + " - Qde.: " + STR(SC2->C2_QUANT,5,0) + " PC"
										cMens2 += Alltrim(cMens)
										RecLock("SZS",.T.)
										SZS->ZS_FILIAL  := "01"
										SZS->ZS_OP      := _cNumOP
										SZS->ZS_PRODUTO := cProduto
										SZS->ZS_QTDE    := nQuant
										SZS->ZS_POSICAO := cMens
										SZS->ZS_DATA    := Date()
										SZS->ZS_CC		 := Alltrim(cCodSetor)
										SZS->ZS_HORA    := Time()
										SZS->ZS_USUARIO := UPPER(cUsuarioSZS)
										SZS->ZS_DEPTO   := _cDeptoUsu
										SZS->(MsUnlock())
										cMens := CHR(13)+CHR(10) +cMens
										cMens2 += +CHR(13)+CHR(10) +cMens
									ENDIF
									SC2->(DBSKIP())
								ENDDO
							ENDIF
							SC2->(DBSETORDER(1))
							SC2->(DbGoTop())
							SC2->(DbSeek(xFilial("SC2")+_cNumOP))
						ENDIF

						IF !EMPTY(cMens2)
							U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens2)
						ENDIF
						AADD(aSD4,sd4->d4_cod + " - " + sb1->b1_desc + " - Qde: " + STR(sd4->d4_quant,10,3))
					ENDIF
				ENDIF
				// ALTERAวรO SOLICITADA POR CLAUDINEI - FAZER A MANUTENวรO DAS PRATELEIRAS (T001/T003) DAS PEวAS DA USINAGEM (SG2)
				// LIZANDRA - 21/01/13
				IF SHB->HB_MSPRATE == "S"
					dbSelectArea("SG2")
					dbSetOrder(1)
					IF SG2->(dbSeek(xFilial("SG2")+SC2->C2_PRODUTO+"01"))
						IF EMPTY(SG2->G2_MSLOCAL)
							RecLock("SG2",.F.)
							SG2->G2_MSLOCAL := _cPrat
						ENDIF
						SG2->(MSUNLOCK())
					ELSE
						RecLock("SG2",.T.)
						SG2->G2_FILIAL	:= "01"
						SG2->G2_CODIGO	:= "01"
						SG2->G2_PRODUTO:= SC2->C2_PRODUTO
						SG2->G2_OPERAC	:= "01"
						SG2->G2_RECURSO:= SHB->HB_MSRECUR
						SG2->G2_TEMPAD	:= 1
						SG2->G2_MSLOCAL:= _cPrat
						SG2->G2_MSOBS	:= "RESTA003"
						SG2->(MSUNLOCK())
					ENDIF
				ENDIF
				dbSelectArea("SD4")
				SD4->(dbSkip())
			EndDo
		EndIf
	EndIf


	_nTempo := 0
	_nSetup := 0
	If !EMPTY(SHB->HB_MSRECUR)     // VERIFICA SE A OPERACAO ENCERRARA A OP
		If SC2->(DbSeek(xFilial("SC2")+_cNumOP))
			If _nRecG2 > 0
				dbSelectArea("SG2")
				dbGoTo(_nRecG2)
				If SC2->C2_PRODUTO == SG2->G2_PRODUTO
					_nTempo := ROUND(VAL(SUBSTR(_cTempo,AT(':',_cTempo)+1,LEN(_cTempo)))/60,4)+VAL(SUBSTR(_cTempo,1,AT(':',_cTempo)-1))
					_nSetup := ROUND(VAL(SUBSTR(_cSetup,AT(':',_cSetup)+1,LEN(_cSetup)))/60,4)+VAL(SUBSTR(_cSetup,1,AT(':',_cSetup)-1))

					RecLock("SG2",.F.)
					If (SG2->G2_TEMPAD <> _nTempo) .AND. _cTempo <> '000:00'
						SG2->G2_TEMPAD := _nTempo
					EndIf
					If (SG2->G2_SETUP <> _nSetup) .AND. _cSetup <> '000:00'
						SG2->G2_SETUP := _nSetup
					EndIf
					If (SG2->G2_MAOOBRA <> _nMao) .AND. _nMao > 0
						SG2->G2_MAOOBRA := _nMao
					EndIf
					SG2->(MsUnlock())
				EndIf
			EndIf

			_lDifZc := .F.
//			SX5->(dbGoTop())
//			SX5->(dbSeek(xFilial("SX5")+"ZC"+cUsuarioSX5))
			aSX5ZC := FWGetSX5('ZC',SUBSTR(cUsuarioSX5,1,6))
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			If Len(aSX5ZC) > 0
				aSX5ZC[1,4] := SPACE(2) + aSX5ZC[1,4]
				If AllTrim(_cUltOpe) == AllTrim(SG2->G2_OPERAC)
//				If !(SubStr(SB1->B1_LOCAL,1,1) $ RTRIM(SX5->X5_DESCRI))
					If !(SubStr(SB1->B1_LOCAL,1,1) $ RTRIM(aSX5ZC[1,4]))
						_lDifZc := .T.
					EndIf
				Endif
			EndIf

			//Ivandro Santos - 29/09/17 - inํcio da altera็ใo: Ticket#2017092837000153 — ENTRADA DE OP. 60351416001
			//If !VerEmp() .AND. Len(aSD4) == 0 .AND. !_lDifZc .AND. ((SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)) * 3) >= nQtde .AND. SB1->B1_MSBLQL <> "1"
			If !VerEmp() .AND. Len(aSD4) == 0 .AND. !_lDifZc .AND. ((SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)) * 4) >= nQtde .AND. SB1->B1_MSBLQL <> "1"  // lizandra 15/03/12
				//Ticket#2017092837000153 — Fim da altera็ใo
				If SB1->B1_CUSTD == 0
					RecLock("SB1",.F.)
					If nQuant < 1
						SB1->B1_CUSTD := 1.0
					Else
						SB1->B1_CUSTD := 0.1
					Endif
					SB1->(MsUnlock())
				Endif

				// U_AtuSB2(SC2->C2_PRODUTO,SB1->B1_QATU,SB1->B1_CUSTD,"RESTA003")
				// as linhas abaixo foram criadas para gravar movimentacao na tabela SD3 - FMD 09/11/10
				// Finalizar a OP alimentando estoque.
				If nQtde # 0
					nQtd2 := nQtde
				Else
					nQtd2 := SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
				Endif

				nVcust2		:= SC2->C2_VATU1
				_cObserv	:= "(" + cSetor + "XXX)" + "RESTA003 - Baixado"
				lFimOp		:= .T.
				LMSERROAUTO	:= .F.
				GravaSD3()

				IF !LMSERROAUTO .AND. !EMPTY(SC2->C2_DATRF)
					If ALLTRIM(SHB->HB_MSRECUR) == "A001"
						If "ALMOXARIFADO" $ _cDeptoUsu .OR. (SUBSTR(cNumEmp,1,2) $ "10" .AND. "207-PCP" $ _cDeptoUsu)
							If MsgBox("Imprime Etiquetas?","AVISO","YESNO")
								cLocal	:= SB1->B1_LOCAL //POSICIONE("SB1",1,XFILIAL("SB1")+SC2->C2_PRODUTO,SB1->B1_LOCAL)
								cProd		:= SC2->C2_PRODUTO
								cRev		:= "-" + ALLTRIM(SB1->B1_REVATU) //Alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+SC2->C2_PRODUTO,SB1->B1_REVATU))
								ImpEtiq()
							EndIf
						EndIf
					EndIf

					If nQtde # 0
						nQtd2 := nQtde
					Else
						nQtd2 := SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
					Endif

					nQuant := nQtd2

					//GRAVA COMO FINALIZADO SOMENTE NA ULTIMA OPERACAO
					If !Empty(SC2->C2_DATRF)
						RecLock("SC2",.F.)

						cMens := "(" + ALLTRIM(cCodSetor) + ")- OP encerrada automaticamente. " + " - RESTA003"

						IF SC2->C2_DATPRF > DATE()
							cMens += " - ADIANTADA. Fim Previsto: " + DTOC(SC2->C2_DATPRF)
						ENDIF
						IF SC2->C2_DATPRF + 3 < DATE()
							cMens += " - ATRASADA " + STR(DATE() - SC2->C2_DATPRF,3,0) + " dias. - Fim Previsto: " + DTOC(SC2->C2_DATPRF) + " - Impressao: " + DTOC(SC2->C2_MSIMPR)
							IF !EMPTY(SC2->C2_MSCI)
								cMens += " - CI: " + SC2->C2_MSCI
							ENDIF
						ENDIF

						SC2->C2_MSPOSIC := cMens
						SC2->(MsUnlock())
					EndIf

					GravaSZS()
				Else
					If LMSERROAUTO
						U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, "Apresentou erro ao realizar baixa da OP: " + ALLTRIM(sd4->d4_op) + "Favor entrar em contato com o depto. de informแtica", "Erro Baixa de OP")
						Return()
					EndIf
				Endif

				If SubStr(_cDeptoUsu,1,3) $ "205*201"

					// as linhas abaixo verificarao se o item pertence a listas de falta
					SB2->(DbSetOrder(1))
					SB2->(DbGoTop())

					SD4->(DbSetOrder(3))
					SD4->(DbGoTop())

					If SD4->(DbSeek(xFilial("SD4")+Alltrim(SC2->C2_PRODUTO)))
						nEmpVD := 0
						If SB2->(DbSeek(xFilial("SB2")+SC2->C2_PRODUTO+"01"))
							nEmpVD := SB2->B2_RESERVA
						EndIf
						_lOk := .F.
						_aFantantes := {}

						Do While SD4->(!EOF()) .And. Alltrim(SD4->D4_COD) == Alltrim(SC2->C2_PRODUTO)
							_aArea := SC2->(GetArea())
							If SD4->D4_MSLF == "X" .And. SD4->D4_QUANT > 0 .And. SB2->B2_QATU - nEmpVD > 0
								If SB2->B2_QATU - nEmpVD >= SD4->D4_QUANT
									_nQtde := SD4->D4_QUANT
								Else
									_nQtde := SB2->B2_QATU - nEmpVD
								EndIf

								//VICTOR DESSUNTE - 03/03/2017
								//INICIO - TICKET:2017020737000133
								If SM0->M0_CODIGO == '10' //FABRIMA
									AADD(_aFaltantes,AllTrim(SD4->D4_MSREFER)+'-'+AllTrim(SD4->D4_XITREFE) + " " + Alltrim(SD4->D4_OP)+"  "+POSICIONE("SC2",1,XFILIAL("SC2")+SD4->D4_OP,"C2_MSREDUZ")+"  "+Transform(SD4->D4_QUANT,"@E 99999.999"))
								Else
									AADD(_aFaltantes," " + Alltrim(SD4->D4_OP)+"  "+POSICIONE("SC2",1,XFILIAL("SC2")+SD4->D4_OP,"C2_MSREDUZ")+"  "+Transform(SD4->D4_QUANT,"@E 99999.999"))
								EndIf
								//FIM - TICKET:2017020737000133

								AADD(_aGoToFalta,SD4->(RECNO()))
							EndIf
							RestArea(_aArea)
							SD4->(DbSkip())
						End

						If !Empty(_aFaltantes)
							DEFINE MSDIALOG _oDlg FROM 0,0 TO 350,340 PIXEL TITLE "OPs com o Item em Lista de Falta"
							oList1:= tListBox():New(10,10,{|u|if(Pcount()>0,nList1:=u,nList1)},_aFaltantes,150,100,,_oDlg,,,,.T.)
							@ 140,040 BUTTON "Paga os Itens Faltantes" SIZE 070,12 ACTION (_lOk := .T.,_oDlg:End())
							@ 140,120 BUTTON "Cancela" SIZE 35,12 ACTION _oDlg:End()
							Activate Dialog _oDlg Centered
						EndIf


						If _lOk
							For _nX:=1 To Len(_aGoToFalta)
								// U_AtuSB2(SD4->D4_COD,SB2->B2_QATU,SB1->B1_CUSTD,"RESTA003")
								// as linhas abaixo foram criadas para gravar movimentacao na tabela SD3 - FMD 09/11/10
								// Baixa itens lista de falta

								//VICTOR DESSUNTE - 22/02/2017
								//INICIO - TICKET:2017022237000051 

								/*dbSelectArea("SD4")
								SD4->(dbSetOrder(1))
								SD4->(dbSeek(xFilial("SD4")+SC2->C2_PRODUTO+SubStr(_aFaltante[_nX],2,11)))*/

								dbSelectArea("SD4")
								SD4->(dbGoTo(_aGoToFalta[_nX]))

								//FIM - TICKET:2017022237000051 

								_nQtde	:= SD4->D4_QUANT
								nQtd3		:= _nQtde
								nVcust3	:= SB1->B1_CUSTD * _nQtde
								_cObserv	:= "RESTA003 - BAIXA AUTOM. DA LISTA DE FALTA"
								lBxFalta	:= .T.
								LMSERROAUTO	:= .F.
								GravaSD3()

								If LMSERROAUTO == .F.

									RecLock("SD4",.F.)
									SD4->D4_MSSEPAR := DATE()
									SD4->(MsUnlock())
								Else
									U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, "Apresentou erro ao realizar baixa da OP: " + ALLTRIM(sd4->d4_op) + "Favor entrar em contato com o depto. de informแtica", "Erro Baixa de OP")
									Return()
								Endif
							Next _nX
						EndIf
					EndIf
				EndIf

				//VICTOR DESSUNTE - 15/09/2016
				//INICIO - TICKET: 2016082637000071
				If !_lGerou
					ApMsgInfo("Apontamento realizado com sucesso!")
				EndIf
				//FIM - TICKET: 2016082637000071
			Else
				If _lDifZc
					cMens := "Verificar com Informatica se o usuario pode finalizar OP (Tabela Generica ZC) - Local: " + SB1->B1_LOCAL
					U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens)
					GravaSZS()
				EndIf
				If ((SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)) * 4) < nQtde
					cMens := "Verificar se a quantidade informada na ultima operacao e valida."
					U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens)
					GravaSZS()
				EndIf
				If Len(aSD4) > 0 .OR. _lExiste
					cMens := "Verifique se existem itens pendentes para essa OP."
					U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens)
					GravaSZS()
				EndIf
				If SB1->B1_MSBLQL == "1"
					cMens := "PRODUTO " + SB1->B1_COD + " BLOQUEADO (B1_MSBLQL). Favor procurar Engenharia ou PCP."
					U_ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cMens)
					GravaSZS()
				EndIf
			EndIf
		EndIf
	EndIf

	cCaminho := Space(50)
	cProg    := Space(15)
	RestArea(aAreaSX5)
	_oDlg1:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  04/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaSZS()

	IF !EMPTY(cMens) .And. !Empty(_cNumOP) .And. !Empty(cProduto)
		RecLock("SZS",.T.)
		SZS->ZS_FILIAL  := "01"
		SZS->ZS_OP      := _cNumOP
		SZS->ZS_PRODUTO := cProduto
		SZS->ZS_QTDE    := nQuant
		SZS->ZS_POSICAO := cMens
		SZS->ZS_CC		 := Alltrim(cCodSetor)
		SZS->ZS_DATA    := Date()
		SZS->ZS_HORA    := Time()
		SZS->ZS_USUARIO := UPPER(cUsuarioSZS)
		SZS->ZS_DEPTO   := _cDeptoUsu
		SZS->(MsUnlock())
	ENDIF

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   GRAVASD3     บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ    09/11/10  บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA GRAVAR MOVIMENTACAO NA TABELA SD3 (MOVIMENTOS INTERNOS)  บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION GRAVASD3()

	Local _aAreaSG2	:= {}
	LOCAL AAREASB1	:= SB1->(GETAREA())
	LOCAL AAREASC2	:= SC2->(GETAREA())
	LOCAL AAREASD4	:= SD4->(GETAREA())
	LOCAL AAREASB2	:= SB2->(GETAREA())
	LOCAL AMSD3		:= {}	// ARRAY CONTENDO OS PRODUTOS A SEREM GRAVADOS NO SD3
	LOCAL _aVetor	:= {}
	LOCAL CTIPOSD3	:= ""	// TIPO MOVIMENTACAO
	LOCAL CNOPSD3	:= ""	// NUMERO OP
	LOCAL CUNMSD3	:= ""	// UNIDADE MEDIDA
	LOCAL CDOCSD3	:= ""	// NUMERO DOCUMENTO
	LOCAL CGRUPSD3	:= ""	// GRUPO
	LOCAL CLOCSD3	:= ""	// LOCAL
	LOCAL NVALCSD3	:= 0	// VALOR CUSTO
	LOCAL CCUSTSD3	:= ""	// CENTRO DE CUSTO
	LOCAL COBSSD3	:= ""	// OBSERVACAO
	LOCAL CMENSAGEM	:= ""
	LOCAL _NQTDRES	:= 0
	LOCAL _NQTDPED	:= 0
	LOCAL _LALTSB2	:= .F.
	LOCAL CMSTRT	:= "001"
	Local _cTime	:= ""
	Local _cQry		:= ""

	_lGerou := .F.

	DBSELECTAREA("SB2")
	SB2->(DBSETORDER(1))
	SB2->(DBGOTOP())

	DO CASE
		// BAIXA COMPONTENTES
		CASE LBXCOMP	== .T.
		CTIPOSD3    := '602'
		CPRODSD3	:= SD4->D4_COD
		CUNMSD3		:= Alltrim(SB1->B1_UM)
		NQTDSD3		:= NQTD1
		CNOPSD3		:= SD4->D4_OP
		CLOCSD3		:= SB1->B1_LOCPAD
		CDOCSD3		:= "OP"+SUBSTR(CNOPSD3,1,6)
		CGRUPSD3	:= SB1->B1_GRUPO
		CCUSTSD3	:= CCCUSTO
		COBSSD3		:= _COBSERV
		CMSTRT      := SD4->D4_TRT

		// FINALIZA OP ALIMENTANDO ESTOQUE
		CASE LFIMOP == .T.
		CTIPOSD3    := '002'
		CPRODSD3	:= SC2->C2_PRODUTO
		CUNMSD3		:= Alltrim(SB1->B1_UM)
		NQTDSD3		:= NQTD2
		CNOPSD3		:= _CNUMOP
		CLOCSD3		:= SB1->B1_LOCPAD
		CDOCSD3		:= "OP"+SUBSTR(CNOPSD3,1,6)
		CGRUPSD3	:= SB1->B1_GRUPO
		CCUSTSD3	:= CCCUSTO
		COBSSD3		:= _COBSERV
		CMSTRT      := '001'

		// BAIXA ITENS LISTA DE FALTA
		CASE LBXFALTA == .T.
		CTIPOSD3    := '602'
		CPRODSD3	:= SD4->D4_COD
		CUNMSD3		:= Alltrim(SB1->B1_UM)
		NQTDSD3		:= NQTD3
		CNOPSD3		:= SD4->D4_OP
		CLOCSD3		:= SB1->B1_LOCPAD
		CDOCSD3		:= "OP"+SUBSTR(CNOPSD3,1,6)
		CGRUPSD3	:= SB1->B1_GRUPO
		CCUSTSD3	:= CCCUSTO
		COBSSD3		:= _COBSERV
		CMSTRT      := SD4->D4_TRT
	ENDCASE

	nSaldoLiq := 0
	IF SB2->(DBSEEK(XFILIAL("SB2")+PADR(CPRODSD3,15)+CLOCSD3)) .AND. CTIPOSD3 >= "500"
		IF ((SB2->B2_QATU - NQTDSD3) < SB2->B2_RESERVA) .OR. ((SB2->B2_QATU - NQTDSD3) < SB2->B2_SALPEDI)
			nSaldoLiq := SB2->B2_QATU - SB2->B2_RESERVA

			IF nSaldoLiq < 0
				nSaldoLiq := 0
			ENDIF

			IF NQTDSD3 > nSaldoLiq
				NQTDSD3 := nSaldoLiq
			ENDIF

		ENDIF
	ENDIF

	AMSD3:={	{"D3_FILIAL" ,'01'			,NIL},;
	{"D3_TM"     ,CTIPOSD3		,NIL},;
	{"D3_COD"    ,CPRODSD3		,NIL},;
	{"D3_UM"     ,CUNMSD3		,NIL},;
	{"D3_QUANT"  ,NQTDSD3		,NIL},;
	{"D3_CONTA"  ,'112000010'	,NIL},;
	{"D3_OP"     ,CNOPSD3		,NIL},;
	{"D3_LOCAL"  ,CLOCSD3		,NIL},;
	{"D3_DOC"    ,CDOCSD3		,NIL},;
	{"D3_EMISSAO",DATE()	  		,NIL},;
	{"D3_GRUPO"  ,CGRUPSD3		,NIL},;
	{"D3_CC"		 ,CCUSTSD3		,NIL},;
	{"D3_MSOBS"	 ,COBSSD3		,NIL},;
	{"D3_HORAS"  ,TIME()	  		,NIL},;
	{"D3_TRT"  	 ,CMSTRT	  		,NIL},;
	{"D3_CODLAN" ,""		 		,NIL} }

	IF NQTDSD3 > 0
		BEGIN TRANSACTION

			IF LBXCOMP == .T. .OR. LBXFALTA == .T. 		// BAIXA COMPONENTES OU BAIXA ITENS LISTA DE FALTA
				LJMSGRUN("Efetuando Movimenta็ใo Interna " +CPRODSD3,,{|| MSEXECAUTO({|X,Y|MATA240(X,Y)},AMSD3,3)})
				LBXCOMP	 := .F.
				LBXFALTA := .F.
			ELSE
				LFIMOP := .F.
				//_nRecG2 := VerG2(SC2->C2_PRODUTO,SHB->HB_MSRECUR,1,CNOPSD3)
				dbSelectArea("SG2")
				SG2->(dbGoTo(_nRecG2))
				_cOperG2 := SG2->G2_OPERAC
				If _nRecG2 > 0
					dbSelectArea("SG2")
					SG2->(dbSetOrder(1))
					If SG2->(dbSeek(xFilial("SG2")+SC2->C2_PRODUTO))
						dbSelectArea("SH6")
						SH6->(dbSetOrder(1))
						While SG2->G2_PRODUTO == SC2->C2_PRODUTO
							If VAL(SG2->G2_OPERAC) > VAL(_cOperG2)
								EXIT
							EndIf

							_cTimeFim 	:= ""
							_cTime		:= ""
							_nTime		:= 0

							If !SH6->(dbSeek(xFilial("SH6")+cNopSD3+'   '+cProdSd3+SG2->G2_OPERAC))
								_aAreaSG2 := SG2->(GetArea())
								_dDataFim := dDataBase
								If SG2->G2_TEMPAD == 0 .AND. SG2->G2_SETUP == 0
									_cTimeFim := IncTime(TIME(),1)
								Else
									If SG2->G2_MAOOBRA > 0
										_nMaoOb := SG2->G2_MAOOBRA
									Else
										_nMaoOb := 1
									EndIf

									If ALLTRIM(SG2->G2_RECURSO) $ "C025*P001" //TAMBOREAMENTO/PINTURA
										_cTimeFim := IncTime(TIME(),1)
									Else
										_cTimeFim := IncTime(TIME(),0,((SG2->G2_TEMPAD*60)*nQtdSd3)+((SG2->G2_SETUP/_nMaoOb)*60))
									EndIf
								EndIf

								_nTime := VAL(SUBSTR(_cTimeFim,1,AT(':',_cTimeFim)-1)+'.'+SUBSTR(_cTimeFim,AT(':',_cTimeFim)+1,2))
								If _nTime > 23.59
									_nX:=0
									_dDataFim := dDataBase
									While _nTime > 23.59
										_dDataFim := _dDataFim + 1
										_nTime := _nTime - 24
									End
								EndIf

								_cTime := STRZERO(INT(_nTime),2)+':'+STRZERO((_nTime-INT(_nTime))*100,2)

								//Caso nao tenha tempo ou seja a ultima opera
								If (SUBSTR(TIME(),1,5) == _cTime) //.OR. AllTrim(_cUltOpe) == AllTrim(SG2->G2_OPERAC)
									_cTime := INCTIME(TIME(),,1)
								EndIf

								//VICTOR DESSUNTE - 15/09/2016
								//INICIO - TICKET: 2016082637000071
								If SM0->M0_CODIGO == '01'
									If SUBSTR(SHB->HB_COD,1,3) $ "202*203*204*205" //Usinagem, Funilaria, Pintura e Almoxarifado
										If A680TEMPO(dDataBase,SubStr(TIME(),1,5),_dDataFim,SubStr(_cTime,1,5)) > 70 //CALCULA TEMPO TOTAL
											_lGerou := .T.
											Alert("Nใo ้ permitido apontamento com mais de 70 horas!")
										EndIf
									EndIf
								EndIf
								//FIM - TICKET: 2016082637000071

								If !_lGerou .And. f_VldSH6(cNopSD3,CPRODSD3, nQtdSd3)
									_aVetor := { 	{"H6_OP"			,cNopSD3				,NIL},;
									{"H6_PRODUTO"	,cProdSd3			,NIL},;
									{"H6_OPERAC"	,SG2->G2_OPERAC	,NIL},;
									{"H6_RECURSO"	,SG2->G2_RECURSO	,NIL},;
									{"H6_DTAPONT"	,dDataBase			,NIL},;
									{"H6_DATAINI"	,dDataBase			,NIL},;
									{"H6_HORAINI"	,TIME()				,NIL},;
									{"H6_DATAFIN"	,_dDataFim			,NIL},;
									{"H6_HORAFIN"	,_cTime				,NIL},;
									{"H6_LOCAL"  	,SC2->C2_LOCAL		,NIL},;
									{"H6_QTDPROD"	,nQtdSd3				,NIL} }

									LjMsgRun("Efetuando apondamento de produ็ใo... Opera็ใo: "+ SG2->G2_OPERAC,,{||MSExecAuto({|x| MATA681(x)},_aVetor)})
								EndIf
							EndIf
							SG2->(dbSkip())
						EndDo
					Else
						Alert("Roteiro de opera็๕es nใo encontrado!")
					EndIf
				Else
					Alert("Opera็ใo nใo encontrada")
				EndIf
			ENDIF

			IF LMSERROAUTO
				CFILELOG    := ""
				CPATH       := ""
				LMSERROAUTO := .F.
				DISARMTRANSACTION()		// CASO APRESENTE ERRO DESFAZ TRANSACAO

				AUTOGRLOG("INICIANDO O LOG")
				AUTOGRLOG("---------------")
				AUTOGRLOG("DATABASE...........: "+DTOC(DDATABASE))
				AUTOGRLOG("PRODUTO............: "+CPRODSD3)
				AUTOGRLOG("DATA...............: "+DTOC(MSDATE()))
				AUTOGRLOG("HORA...............: "+TIME())
				AUTOGRLOG("ENVIRONMENT........: "+GETENVSERVER())
				AUTOGRLOG("PATCH..............: "+GETSRVPROFSTRING("Startpath",""))
				AUTOGRLOG("ROOT...............: "+GETSRVPROFSTRING("SourcePath",""))
				AUTOGRLOG("VERSรO.............: "+GETVERSAO())
				AUTOGRLOG("MำDULO.............: "+"SIGA"+CMODULO)
				AUTOGRLOG("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
				AUTOGRLOG("NOME EMPRESA.......: "+CAPITAL(TRIM(SM0->M0_NOME)))
				AUTOGRLOG("NOME FILIAL........: "+CAPITAL(TRIM(SM0->M0_FILIAL)))
				AUTOGRLOG("USUมRIO............: "+SUBSTR(CUSUARIO,7,15))

				CFILELOG := NOMEAUTOLOG()

				IF  CFILELOG <> ""
					MOSTRAERRO(CPATH,CFILELOG)
				ENDIF

				// GRAVA LOG NA TABELA SZS
				RECLOCK("SZS",.T.)
				SZS->ZS_FILIAL  := "01"
				SZS->ZS_OP      := CNOPSD3
				SZS->ZS_PRODUTO := CPRODSD3
				SZS->ZS_QTDE    := NQTDSD3
				SZS->ZS_POSICAO := "ERRO ROTINA RESTA003 - FUNCAO GRAVASD3 - TIPO MOVIMENTO: " + CTIPOSD3
				SZS->ZS_DATA    := DATE()
				SZS->ZS_HORA    := TIME()
				SZS->ZS_CC		 := "XXXXXX"//Alltrim(cCodSetor)
				SZS->ZS_USUARIO := UPPER(CUSUARIOSZS)
				SZS->ZS_DEPTO   := _CDEPTOUSU
				SZS->(MSUNLOCK())

				CMENSAGEM := "O sistema apresentou um erro de processamento e serแ fechado !!!" + CHR(13);
				+ "Apresente estแ OP ao Depto. de Informแtica para que possam efetuar anแlise." + CHR(13);
				+ "Continue utilizando o sistema para apontar outras OP's. Obrigado !"

				USEREXCEPTION(CMENSAGEM)
			ENDIF

		END TRANSACTION

	ENDIF

	RESTAREA(AAREASB1)
	RESTAREA(AAREASC2)
	RESTAREA(AAREASD4)
	RESTAREA(AAREASB2)

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaDI  บAutor  ณVictor Dessunte     บ Data ณ  04/15/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se a data inicial e maior ou igual a data base ou   บฑฑ
ฑฑบ          ณ menor que data base + 10                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaDI()

	Local _lRet := .T.

	If !Empty(_dtIni)
		If (_dtIni < dDataBase) .OR. (_dtIni > dDataBase+10)
			Alert('A data inicial deve ser maior ou igual a ' + DTOC(dDataBase) + ' e menor ou igual a ' + DTOC(dDataBase+10))
			_lRet := .F.
		Else
			If Empty(_dtFim)
				_dtFim := _dtIni + SB1->B1_PE
				GETDREFRESH()
			EndIf
		EndIf
	EndIf

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDADF  บAutor  ณLizandra            บ Data ณ  16/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida data efetiva de inicio e fim da OP                  บฑฑ
ฑฑบ          ณ Pedido PCP - Vagner                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALIDADF()

	fRet := .T.

	If !Empty(_dtFim)
		If _dtIni > _dtFim
			Alert('A data final deve ser maior ou igual a data inicial')
			fRet := .F.
		EndIf
	EndIf

Return fRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณVictor Dessunte     บ Data ณ  05/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ- Impressao de Etiqueta no almoxarifado                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpEtiq()

	cProd    := Upper(CPRODSD3)
	nQtdEtiq := NQTDSD3
	nEtiq    := 5
	IniEtiq()      // Grava as informacoes iniciais no arquivo

	MontaEtiq()    // Monta etiqueta

	If _nCol > 0
		cRegPRN := "^" + StrZero(nEtiq,2,0)
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := "Q0001"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN :=  "E"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	EndIf

	// As linhas abaixo salta uma fileira de etiqueta, para evitar o uso da tecla FEED
	cRegPRN := CHR(2) + "c0000"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "KI503"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "o0220"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "f220"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "KW0400"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "KI7" + CHR(1)
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "V0"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "L"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := "H13"
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

	cRegPRN := CHR(2) + "Q"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	FClose(cArqPRN)

	//VICTOR DESSUNTE - 28/02/2017
	//INICIO - TICKET:2016122137000411 

	WaitRun("cmd /c copy c:\relato_microsiga\EtiqPecas.prn prn")
	WaitRun("cmd /c del c:\relato_microsiga\EtiqPecas.prn")

	/*
	If _cDeptoUsu $ "RECEBIMENTO_205-ALMOXARIFADO"
	WaitRun("F:\BAT\ImpEtiqAlm.bat")
	Else
	WaitRun("F:\BAT\ImpEtiqFab.bat")
	EndIf
	*/
	//FIM - TICKET:2016122137000411 


	FErase("c:\relato_microsiga\EtiqPecas.prn")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  05/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      \ ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IniEtiq()
	If (cArqPRN := FCreate("C:\Relato_Microsiga\EtiqPecas.PRN")) == -1
		Alert("Arquivo de Etiquetas nใo pode ser criado - Avise o Depto. de Informแtica")
		Return
	EndIf

	cRegPRN := CHR(2) + "c0000"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "KI503"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "o0220"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "f220"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "KW0400"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "KI7" + CHR(1)
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "V0"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := CHR(2) + "L"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := "H13"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := "PC"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := "A2"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN :=  "D11"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณMicrosiga           บ Data ณ  05/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaEtiq()

	Local _nLin 	:= 13
	Local I       	:= 0
	Local nSalto  	:= 28

	For I := 1 to nQtdEtiq
		cRegPRN := "221100000990" + StrZero(_nLin,3) + "FAB: " + DTOC(Date())
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		_nLin+=13
		cRegPRN := "221100000990" + StrZero(_nLin,3) + "OP: " + Alltrim(SD3->D3_OP)
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		_nLin+=13
		cRegPRN := "221100000990" + StrZero(_nLin,3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		_nLin+=13
		cRegPRN := "221100000990" + StrZero(_nLin,3) + Alltrim(cProd) + cRev
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		_nLin+=nSalto
		_nCol++
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
			_nLin := 13
		EndIf
	Next I

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณVictor Dessunte     บ Data ณ  05/23/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna Recno do cadastro de Operacoes                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerG2(_cProd,_cRecur,_nTp,_cOp)
	Local cAlsG2	:=	GetNextAlias()
	Local _cQry		:=	""
	Local _nRec		:=	0
	Local cWhere	:= '%'
	
	If _nTp == 2
		_cRecur := SubStr(_cRecur,1,4)
	EndIf
	
	If _nTp <> 3
		cWhere += " AND 	G2_RECURSO    = '" + _cRecur 		  + "'  %"	
	Else
		cWhere += " AND 	G2_RECURSO LIKE '" + AllTrim(_cRecur) + "%' %" 	
	EndIf
		
	BeginSql Alias cAlsG2
		SELECT	TOP 1 G2REC,H6OP
		FROM	(
					Select	G2.R_E_C_N_O_ G2REC,
							ISNULL(H6_OP,'') H6OP
							From	%Table:SG2% G2
							Inner Join %Table:SH1% H1 ON 	H1.H1_FILIAL	=	%xFilial:SH1% AND
															H1.H1_CODIGO	=	G2.G2_RECURSO AND
															H1.%NotDel%						  
							Left Join %Table:SH6% H6 ON		H6.H6_FILIAL	=	%xFilial:SH1% AND
															H6.H6_OP		=	%Exp:_cOp%	  AND
															H6.H6_OPERAC	=	G2.G2_OPERAC  AND
															H6.%NotDel%
							Where	G2.G2_FILIAL 	= %xFilial:SG2% AND
									G2.G2_PRODUTO	= %Exp:_cProd%  AND
									G2.G2_CODIGO	= '01'			AND
									G2.%NotDel%
									%Exp:cWhere%						
				) as T1
				WHERE H6OP = ''
				
	EndSql

	(cAlsG2)->(dbGoTop())
	Do While (cAlsG2)->(!EOF())
		If Empty((cAlsG2)->H6OP)
			_nRec := (cAlsG2)->G2REC
			Exit
		EndIf
		(cAlsG2)->(DbSkip())		
	EndDo

	If Select(cAlsG2) > 0
		(cAlsG2)->(dbCloseArea())
	EndIf

Return _nRec

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณVictor Dessunte     บ Data ณ  06/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Habilita campos para alteracao de tempos no roteiro de    บฑฑ
ฑฑบ          ณ  operacoes                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RTA03A()

	If Empty(cSetor) .OR. Empty(_cNumop)
		Alert("Setor ou Ordem de Produ็ใo nใo preenchidos!")
	Else
		If Empty(SHB->HB_MSRECUR)
			Alert("Opera็ใo sem recurso cadastrado!")
		Else
			If _nRecG2 > 0
				_lAltTem := .T.
				If SubsTr(_cDeptoUsu,1,3) $ "201*205*207" //MONTAGEM, ALMOXARIFADO E PCP
					_lAltMao := .T.
				EndIf
			Else
				Alert("Roteiro de opera็๕es nใo cadastrado!")
			EndIf
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณVictor Dessunte     บ Data ณ  06/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida campos Setup e Tempo Padrao                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RTA03B(_cTempo)

	Local _lRet

	If !Empty(_cTempo)
		If VAL(SubStr(_cTempo,AT(':',_cTempo)+1,Len(_cTempo))) > 59
			Alert("Os minutos nใo deve ser maior que 59!")
			_lRet := .F.
		EndIf

		If SUBSTR(SHB->HB_COD,1,3) $ "202*203*204*205" //Usinagem, Funilaria, Pintura e Almoxarifado
			If VAL(SubStr(_cTempo,1,AT(':',_cTempo)-1)) > 70
				Alert("Nใo ้ permitido apontamento com mais de 70 horas!")
				_lRet := .F.
			Else
				If VAL(SubStr(_cTempo,1,AT(':',_cTempo)-1)) == 70
					If VAL(SubStr(_cTempo,AT(':',_cTempo)+1,Len(_cTempo))) > 0
						Alert("Nใo ้ permitido apontamento com mais de 70 horas!")
						_lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA003  บAutor  ณVictor Dessunte     บ Data ณ  10/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existem empenhos pendentes para baixar         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerEmp()

	_cQry := "SELECT COUNT(*) EMP FROM " + RetSqlName("SD4") + " WHERE D_E_L_E_T_ = ' ' AND D4_OP = '" + _cNumOp + "' AND D4_QUANT > 0 "

	If Select("TRBD4") > 0
		TRBD4->(dbCloseArea())
	EndIf

	TCQUERY _cQry NEW ALIAS "TRBD4"

	TRBD4->(dbGoTop())
	If TRBD4->(!EOF())
		If TRBD4->EMP > 0
			_lExiste := .T.
		EndIf
	EndIf

	If Select("TRBD4") > 0
		TRBD4->(dbCloseArea())
	EndIf

Return _lExiste

//***************************************************************
//*	Valida a exist๊ncia do apontamento da SH6					*
//***************************************************************
Static Function f_VldSH6(cNopSD3, CPRODSD3, nQtdSd3)

Local aArea		:= GetArea()
Local nQuant	:= nQtdSd3
Local lRet		:= .T.

	//H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC+H6_SEQ+DTOS(H6_DATAINI)+H6_HORAINI+DTOS(H6_DATAFIN)+H6_HORAFIN
	SH6->(dbSetOrder(1))
	If SH6->(dbSeek( xFilial("SH6") + cNopSD3 + CPRODSD3 + SG2->G2_OPERAC ))
		
		While SH6->(!EOF()) .And. SH6->H6_FILIAL + SH6->H6_OP + SH6->H6_PRODUTO + SH6->H6_OPERAC == xFilial("SH6") + cNopSD3 + SH6->H6_PRODUTO + SG2->G2_OPERAC
			nQuant += SH6->H6_QTDPROD
			SH6->(dbSkip())
		EndDo

		If nQuant >= SC2->C2_QUANT
			
			cMsg := "Quantidade do movimento estแ maior que a quantidade da Ordem de Produ็ใo" + CRLF
			cMsg += "Solicite ao PCP ajustar a quantidade da OP ou Estorne esta opera็ใo."
			Alert(cMsg)
			lRet := .F.

		Endif
	Endif

	RestArea(aArea)

Return lRet
