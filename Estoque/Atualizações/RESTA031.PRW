#INCLUDE "MATA185.CH"
#INCLUDE "PROTHEUS.CH"
/*/ 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±              
±±³Fun‡…o    ³ MATA185  ³ Autor ³ Edson Maricate        ³ Data ³16.11.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Baixa as Pre-requisicoes gerando as requisicoes.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void mata185(ExpA1,ExpA2,ExpN1,ExpA3)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com lista de campos (SCP)     	  (Rot.Aut)   ³±±
±±³          ³ ExpA2 = Array com lista de campos (SD3)     	  (Rot.Aut)   ³±±
±±³          ³ ExpN1 = numero da opcao selecionada 			  (Rot.Aut)   ³±±
±±³          ³ ExpA3 = Array contendo parametros p/ perguntas (Rot.Aut)OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cesar Valadao ³15/02/00³2280  ³ Exclusao de Pre-Requisicao             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡ao ³ PLANO DE MELHORIA CONTINUA        ³Programa: MATA185.PRX   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data       ³ Bops               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³Marcos V. Ferreira        ³13/01/2006  ³                    ³±±
±±³      02  ³Marcos V. Ferreira        ³11/01/2006  ³                    ³±±
±±³      03  ³                          ³            ³                    ³±±
±±³      04  ³                          ³            ³                    ³±±
±±³      05  ³                          ³            ³                    ³±±
±±³      06  ³Marcos V. Ferreira        ³11/01/2006  ³                    ³±±
±±³      07  ³Marcos V. Ferreira        ³13/01/2006  ³                    ³±±
±±³      08  ³Marcos V. Ferreira        ³18/01/2006  ³                    ³±±
±±³      09  ³Marcos V. Ferreira        ³18/01/2006  ³                    ³±±
±±³      10  ³Ricardo Berti		        ³26/07/2006  ³ 00000103637        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTA031(xAutoSCP,xAutoSD3,nOpcAuto,xPerg,xAutoAFH)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCor  := {	{"U_A185BtVe()", "BR_VERMELHO"},;
	   				{"U_A185BtAz()", "BR_AZUL"	},;
					{"U_A185BtVd()", "BR_VERDE"	},;
					{"U_A185BtAm()", "BR_AMARELO"	},;
					{"U_A185BtLa()", "BR_LARANJA"	}}  
					
Local aMT185COR  := {}   // Variavel utilizada no PE: MT185COR

Local cFiltraSCP := ""
Local cFiltro    := ""
Local aFldSD3	 := {}
Local nX		 := 0

PRIVATE l185Auto := (xAutoSCP <> Nil .And. xAutoSD3 <> Nil .And. nOpcAuto <> Nil)
PRIVATE aAutoSCP := xAutoSCP
PRIVATE aAutoSD3 := xAutoSD3
PRIVATE aAutoAFH := aClone(xAutoAFH)       
PRIVATE aPerg	 := IIf((ValType(xPerg) == "A" .And. (Len(xPerg)>=3 .And. Len(xPerg)<=5)),xPerg,{1,1,2,1,1})  // xPerg[4] = Existe uma SC para Préquisição 1-Deleta 2-Mantem, xPerg[5] = dDataBase < SCP->CP_EMISSAO

PRIVATE aRotina	 := MenuDef()
//Variavel de integracao com o PMS sera utilizada para alimentar os campos D3_PROJPMS e D3_TSKPMS
PRIVATE lCallPrj := GetMV('MV_INTPMS')=="S"
PRIVATE _cProjCod:= SPACE(LEN(AFH->AFH_PROJET))	//variavel utilizada no x3_relacao funcao pmsCpoInic()
PRIVATE _cTarefa := SPACE(LEN(AFH->AFH_TAREFA))	//variavel utilizada no x3_relacao Funcao PmsCpoInic()
PRIVATE cRevisa  := SPACE(LEN(AFH->AFH_REVISA))	//variavel utilizada no x3_relacao Funcao PmsCpoInic()
PRIVATE cNuSATOP := ""
PRIVATE cITSATOP := ""
PRIVATE lPermBx  := GetNewPar("MV_BXPRERQ",.F.)
PRIVATE cMarca
PRIVATE cCadastro := OemToAnsi(STR0005) //"Geracao das Requisicoes"
PRIVATE aAcho:={}
PRIVATE cCusMed := GetMv("MV_CUSMED")

	//Ajuste SD3 - PMS
	AjstSX7Pms()

	If l185Auto
		aRotina := {{STR0003,"U_A185Baixar" 	, 0 , 1,0,nil},;	//"Baixar"
					{STR0054,"U_A185Estorn"	, 0 , 2,0,nil},;	//"Estorno"
					{STR0004,"U_A185Exclui" 	, 0 , 5,0,nil},;	//"Excluir"
					{STR0037,"U_A185Encer"  	, 0 , 6,0,nil}} 	//"Encerrar"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ P.E. Utilizado para alterar as cores da legenda              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("MT185COR")
		aMT185COR := ExecBlock("MT185COR",.F.,.F., {aCor})
		If ( Valtype(aMT185COR) == "A" )
			aCor := aClone( aMT185COR )
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao que preenche o array AACHO                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A240AAcho({"D3_COD","D3_QUANT","D3_QTSEGUM"})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX2")
	dbSeek("SD3")
/*
	dbSelectArea("SX3")
	dbSeek("SD3")
	While !EOF() .And. (x3_arquivo == "SD3")
		If X3USO(x3_usado) .And. cNivel >= x3_nivel .And. (ASCAN(aAcho,Trim(x3_campo)) == 0) .And. X3_PROPRI == "U"
			AADD(aAcho,TRIM(x3_campo))
		Endif
		dbSkip()
	End
*/
	aFldSD3 := FwSx3Util():GetListFieldsStruct("SD3",.F.)
	For nX := 1 To Len(aFldSD3)
		IF aScan(aAcho,ALLTRIM(aFldSD3[nX,1])) == 0 .And. !(ALLTRIM(aFldSD3[nX,1]) $ "D3_FILIAL|") 
			AADD(aAcho,ALLTRIM(aFldSD3[nX,1]))
		ENDIF
	Next nX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTA185",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                                    ³
	//³ mv_par01        // Qt. Processo Compras   Da Pre-Requisicao/Do Produto  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o custo medio e' calculado On-Line               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTA240",.F.)

	If !l185Auto
		Set Key VK_F12 TO MTA185PERG()
	Endif

	dbSelectArea("SCQ")
	dbSetOrder(1)

	If BOF() .And. EOF() .And. !l185Auto
		HELP(" ",1,"RECNO")
	Else
		If !l185Auto
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Endereca a funcao de BROWSE                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MT185FIL")
			cFiltraSCP := ExecBlock("MT185FIL",.F.,.F.)
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada para verificacao de filtros na Mbrowse      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If  ExistBlock("M185FILB") 
				cFiltro := ExecBlock("M185FILB",.F.,.F.)
				If Valtype(cFiltro) <> "C"
					cFiltro := ""		
				EndIf
			EndIf

			mBrowse( 6, 1,22,75,"SCP",,,,,,aCor,,,,,,,, IF(!Empty(cFiltro),cFiltro, NIL),,,,cFiltraSCP)
			
		Else
			MsRotAuto(nOpcAuto,aAutoSCP,"SCP")
		Endif
	EndIf

	dbSelectArea("SCQ")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desativa tecla que aciona perguntas                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !l185Auto
		Set Key VK_F12 To
	Endif

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Baixar³ Autor ³ Larson Zordan 	    ³ Data ³ 22.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada da funcao para o tipo de baixa 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum					                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MatA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185Baixar(cAlias,nReg,nOpc)

Local lRet     	:= .T.
Local lRetPE     	:= .T.
Local cNum		 	:= ''
Local cItem		:= ''
Local nX		 	:= 0
Local aAreaAFH   	:= AFH->(GetArea())
Local lPIMSInt	:= SuperGetMV("MV_PIMSINT",.F.,.F.)

AFH->(DbSetOrder(2))
If AFH->(DbSeek(xFilial("AFH")+SCP->CP_NUM+SCP->CP_ITEM))
	_cProjCod:= AFH->AFH_PROJET	//variavel utilizada no x3_relacao funcao pmsCpoInic()
	_cTarefa := AFH->AFH_TAREFA	//variavel utilizada no x3_relacao Funcao PmsCpoInic()
	cRevisa  := AFH->AFH_REVISA	//variavel utilizada no x3_relacao Funcao PmsCpoInic()
EndIf
AFH->(RestArea(aAreaAFH))

//Variavel utilizada no PMSXFUNB para validar se SA é originado pela integração rm top x protheus
cNuSATOP := SCP->CP_NUM
cITSATOP := SCP->CP_ITEM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa perguntas deste programa                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTA185",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento para utilizacao da ROTINA AUTOMATICA					|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l185Auto
	For nX:=1 to len(aAutoSCP)
		If Upper(AllTrim(aAutoSCP[nX,1])) == "CP_NUM"
			cNum := aAutoSCP[nX,2]
		ElseIf Upper(AllTrim(aAutoSCP[nX,1])) == "CP_ITEM"
			cItem := aAutoSCP[nX,2]
		EndIf
	Next
	If !SCP->(dbSeek(xFilial("SCP")+cNum+cItem))
		Help(" ",1,"REGNOIS")
		Return .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada que possibilita customizar a execucao da Baixa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock('M185BAIX')
	lRetPE 	:= ExecBlock('M185BAIX', .F., .F., {mv_par01})
	lRet 	:= If(!(ValType(lRetPE)=='L'), .T., lRetPE)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica calendário contábil                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet      
	lRet := CtbValiDt(Nil,dDataBase,,Nil ,Nil ,{"EST001"})
EndIf

If lRet      
	If dDataBase < SCP->CP_EMISSAO
		If l185Auto
			lRet:= aPerg[5] == 1
		Else
			lRet:=Aviso(OemToAnsi(STR0035),STR0063,{OemToAnsi(STR0040),OemToAnsi(STR0039)}) == 1
		EndIf	
	EndIf
	If lRet
		If (mv_par01 == 1 .Or. l185Auto) .And. (ValType(lPIMSInt) == "L") .And. !lPIMSInt
			U_A185Manual(cAlias,nReg,nOpc)
		Else
			A185Automa(cAlias,nReg,nOpc)
		EndIf
	EndIf	
EndIf
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Gera  ³ Autor ³ Edson Maricate        ³ Data ³ 25.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera requisicoes                                      	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum					                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.				                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MatA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185Gera()
Local aRetSA	:={}
Local aNumScDhnA:= {}
Local aNumScDhnB:= {}
Local nQtRes	:= 0   // Saldo da quantidade reservada apos requisicao
Local nQtDisp	:= 0
Local lSCAglut	:=.F.
Local lRet		:=.F.
Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)
Local nAjustaSC1:= 3
Local nQuant	:= 0
Local cProjPMS	:=	""
Local cTaskPMS	:=	""
Local cNumSEq	:=	""
Local cSolic, cItSolic, nRecno, cSCNum
Local cItemPR, cNumAE
Local cDocSC	:= ""
Local cItSC		:= ""
Local cDocAE	:= ""
Local cItAE		:= ""
Local cAliasDHN	:= ""

PRIVATE cXFUNC	:= "U_A185AtuSD3"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel utilizada na A240INCLUI() p/ atualizar o campo D3_DTLANC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aAtuSD3	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
	PRIVATE nHdlPrv				// Endereco do arquivo de contra prova dos lanctos cont.
	PRIVATE lCriaHeader := .T.	// Para criar o header do arquivo Contra Prova
	PRIVATE cLoteEst 			// Numero do lote para lancamentos do estoque
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Estoque         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
	PRIVATE cArquivo		// Nome do arquivo contra prova
	PRIVATE aCtbDia := {}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis indicam para as funcoes de validacao qual    ³
//³ programa as esta' chamando                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private l240Auto := l185Auto, l250Auto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis indicam para as funcoes de validacao qual    ³
//³ programa as esta' chamando                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE l240:=.T.,l250:=.F.,l241:=.F.,l242:=.F.,l261:=.F.,l185 :=.T.

aRetSA := ca100RetCQ(SCP->CP_NUM,SCP->CP_ITEM)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ca100RetCQ() ----------->                   ³
//³ [1] -  Saldo do Item                        ³
//³ [2] -  Quantidade diponivel ja reservada    ³
//³ [3] -  Quantidade em Processo de Compra     ³
//³ [4] -  Situacao Atual                       ³
//³ [5] -  Numero da Solicitacao de Compras     ³
//³ [6] -  Numero de Requisicao                 ³
//³ [7] -  Quantidade ja Entregue               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Pergunta MTA240						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A185AtuPer(1)

dbSelectArea("SCQ")
dbSetOrder(1)
dbSeek(xFilial()+SCP->CP_NUM+SCP->CP_ITEM)

dbSelectArea("SD3")
dbSetOrder(1)

If If(l185Auto,U_A185RotAut(),A240Inclui("SD3",RecNo(),Nil))
	A240Comum()
	If !(lWmsNew .And. IntWMS(SCP->CP_PRODUTO))
		nQuant		:=	SD3->D3_QUANT
		cProjPMS	:=	SD3->D3_PROJPMS
		cTaskPMS	:=	SD3->D3_TASKPMS
		cNumSEq		:=	SD3->D3_NUMSEQ
	Else
		nQuant		:=	DH1->DH1_QUANT
		cProjPMS	:=	DH1->DH1_PROJPM
		cTaskPMS	:=	DH1->DH1_TASKPM
		cNumSEq		:=	DH1->DH1_NUMSEQ
	EndIf

	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial()+SCP->CP_PRODUTO+SCP->CP_LOCAL)
	Reclock("SB2",.F.)
	SB2->B2_QEMPSA := Max(0,B2_QEMPSA - If(nQuant < aRetSA[2], nQuant, aRetSA[2]))
	MsUnLock()
	dbSelectArea("SCP")
	Reclock("SCP",.F.)
	SCP->CP_QUJE := SCP->CP_QUJE + nQuant
	If SCP->CP_QUJE >= SCP->CP_QUANT
		SCP->CP_STATUS := "E"
		INCLUI := .F.
	EndIf
	MsUnLock()
	If IntePMS() .And. !Empty(cProjPMS).And.!Empty(cTaskPMS)
		DbSelectArea('AF8')
		DbSetOrder(1)
		MsSeek(xFilial()+cProjPMS)
		DbSelectArea('AFH')
		DbSetOrder(1)
		If MsSeek(xFilial()+cProjPMS+AF8->AF8_REVISA+cTaskPMS+SCP->CP_NUM+SCP->CP_ITEM)
			RecLock('AFH',.F.)
			AFH_QUJE	+=	nQuant
			MsUnLock()
		Endif
	Endif
	dbSelectArea("SCQ")
	While !Eof() .And. CQ_FILIAL+CQ_NUM+CQ_ITEM == xFilial()+SCP->CP_NUM+SCP->CP_ITEM
		//Recupera a SC gerada pela Central de Compras
		aNumScDhnA := COMPosDHN({2,{SCQ->CQ_FILIAL,SCQ->CQ_NUM,SCQ->CQ_ITEM}})
		If aNumSCDhnA[1]
			If (aNumScDhnA[2])->DHN_TIPO == "1" //Solicitação de Compra
				cDocSC	:= (aNumScDhnA[2])->DHN_DOCDES
				cItSC	:= (aNumScDhnA[2])->DHN_ITDES
			ElseIf (aNumScDhnA[2])->DHN_TIPO == "3" //Autorização de Entrega
				cDocAE	:= (aNumScDhnA[2])->DHN_DOCDES
				cItAE	:= (aNumScDhnA[2])->DHN_ITDES
			EndIf
			(aNumScDhnA[2])->(DbCloseArea())
		EndIf
		If nQuant > 0 .And. Empty(SCQ->CQ_NUMREQ)
			If !Empty(cDocSC)
				If nQuant > aRetSA[2]	//If SCQ->CQ_QTDISP==0
					RecLock("SCQ",.F.)
					SCQ->CQ_QTDISP := SCQ->CQ_QTDISP + nQuant - aRetSA[2]
					MsUnlock()
					dbSelectArea("SC1")
					If SC1->(dbSeek(xFilial() + cDocSC + cItSC))
						If Empty(SC1->C1_PEDIDO) .And. Empty(SC1->C1_COTACAO)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se Gerou SC Aglutinada. ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nRecno := SCQ->(Recno())
							SCQ->(dbSeek(xFilial()+SC1->C1_NUM+SC1->C1_ITEM))
							lSCAglut := .F.
							cSCNum := SCQ->CQ_NUM
							aNumScDhnB := COMPosDHN({3,{'1',xFilial("DHN"),SC1->C1_NUM,SC1->C1_ITEM}})
							If aNumScDhnB[1]
								cAliasDHN := aNumScDhnB[2]
								If !Empty(cAliasDHN)
									While !((cAliasDHN)->(EOF())) .And. (cAliasDHN)->DHN_TIPO == "1" .And. (cAliasDHN)->(DHN_FILDES+DHN_DOCDES+DHN_ITDES) == xFilial("SC1")+SC1->C1_NUM+SC1->C1_ITEM
										If SCQ->(DbSeek((cAliasDHN)->(DHN_FILORI + DHN_DOCORI + AllTrim(DHN_ITORI))))
											While !(SCQ->(EoF())) .And. SCQ->(CQ_FILIAL + CQ_NUM + AllTrim(CQ_ITEM)) == (cAliasDHN)->(DHN_FILORI + DHN_DOCORI + AllTrim(DHN_ITORI))
												If cSCNum != SCQ->CQ_NUM
													lSCAglut := .T.
													Exit
												EndIf
												SCQ->(dbSkip())
											EndDo
										EndIf
										(cAliasDHN)->(dbSkip())
									EndDo
									(cAliasDHN)->(dbCloseArea())
								EndIf
							EndIf
							SCQ->(dbGoTo(nRecno))
							SCQ->(dbSetOrder(1))
							// Se Gerou SC Aglutinada, Nao Posso Deletar!!!
							If lSCAglut
								// "Existe uma SC Para Esta Pre-Requisicao." ### "Ajusta-la" ### "Mante-la"
								If l185Auto
									nAjustaSC1 := aPerg[1]
								Else
									nAjustaSC1 := Aviso("SIGAEST", STR0028, {STR0029, STR0031})
								EndIf
							Else
								// "Existe uma SC Para Esta Pre-Requisicao." ### "Ajusta-la" ### "Deleta-la" ### "Mante-la"
								If l185Auto
									nAjustaSC1 := aPerg[2]
								Else
									nAjustaSC1 := Aviso("SIGAEST", STR0028, {STR0029, STR0030, STR0031})
								EndIf
							EndIf
						Else
							// "Existe uma SC Em Processo de Compra. Nao Sera Alterada."
							If !l185Auto
								Aviso("SIGAEST", STR0032, {" Ok "})
							EndIf
						EndIf
					EndIf
					dbSelectArea("SCQ")
				EndIf
				cSolic  := cDocSC
				cItSolic:= cItSC
				nQtRes  += SCQ->CQ_QUANT - nQuant
			ElseIf !Empty(cDocAE)
				cNumAE  := cDocAE
				cItAE   := cItAE
				nQtRes  += SCQ->CQ_QUANT - nQuant
			Else
				nQtRes  += SCQ->CQ_QUANT - nQuant
			EndIf

			RecLock("SCQ",.F.)
			SCQ->CQ_NUMREQ := cNumSEq
			If nQuant - SCQ->CQ_QTDISP < 0
				nQtDisp+= SCQ->CQ_QTDISP - nQuant
			EndIf
			MsUnlock()
			cItemPR := SCQ->CQ_NUMSQ
			Exit
		EndIf
		dbSkip()
	EndDo
	If nQtRes > 0 .Or. nQtDisp > 0
		If nQtRes > 0
			a106AtuCQ(nQtRes,nQtDisp,cItemPR,.F.)
			RecLock("SCQ",.F.)
			MsUnlock()
		Else
			a106AtuCQ(nQtDisp,nQtDisp,cItemPR,.F.)
		EndIf
	EndIf
	If nAjustaSC1 == 1 .Or. (!lSCAglut .And. nAjustaSC1 == 2)
		dbSelectArea("SC1")
		If !(Empty(cDocSC)) .And. dbSeek(xFilial() + cDocSC + cItSC)
			If SC1->C1_QUANT - nQuant == 0
				nAjustaSC1 := 2	// Se a SC For Ficar Com Qtd Zero, Deleta-a.
			EndIf
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial()+SCP->CP_PRODUTO+SCP->CP_LOCAL)
			If Reclock("SB2",.F.)
				SB2->B2_SALPEDI := B2_SALPEDI - If(nAjustaSC1==1, nQuant, SC1->C1_QUANT)
				MsUnLock()
			EndIf
			dbSelectArea("SC1")
			RecLock("SC1",.F.)
			If nAjustaSC1 == 1
				SC1->C1_QUANT := C1_QUANT - nQuant
				MsUnLock()
			Else
				dbDelete()
				MsUnLock()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desvincula da SC e Muda Status Para "D"eletado. ³
				//³ Usado no MATR115.                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SCQ")
				RecLock("SCQ",.F.)
				SCQ->CQ_STATUSC := "D"	// Deletada
				MsUnlock()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se Foi Excluida a SC, Encerra a Pre-Requisicao. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SCP")
				RecLock("SCP",.F.)
				SCP->CP_STATUS := "E"
				MsUnLock()
			EndIf
		EndIf
	EndIf

	//Integração SIGAMDT
	MdtIntSCP( 1 , SCP->CP_NUM , SCP->CP_ITEM , cNumSEq , SCP->CP_PRODUTO )

	If ExistBlock("M185GRV")
		ExecBlock("M185GRV",.F.,.F.,{.T.})
	EndIf
	lRet := .T.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Pergunta MTA185						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A185AtuPer(2)
Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Manual³ Autor ³ Edson Maricate        ³ Data ³02.12.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Baixa das Pre-requisicoes.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Manual(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.				                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185Manual(cAlias,nReg,nOpc)
LOCAL nOpcA     := 3
LOCAL aRetCQ    := {}
LOCAL nQAtu     := 0
LOCAL nQtSal    := 0
LOCAL nQtRes    := 0
LOCAL nQtdProc  := 0
LOCAL cPict     := PesqPictQt('D3_QUANT')
LOCAL lM185Mod1 := ExistBlock("M185MOD1")
LOCAL lMT185OK  := ExistBlock("MT185OK")
LOCAL nX		:= 0
LOCAL aButton	:= {}
LOCAL lRet		:= .T.
LOCAL lContinua	:= .T.
LOCAL oDlg
LOCAL aUsButtons := {}
Local lAuto		:= .F.

Local oSize 	:= {} 
Local oSizeA 	:= {}
Local oSizeB 	:= {}
Local oSizeB1	:= {}
Local oSizeB2	:= {}
Local lMT185BUT := .F.

PRIVATE bPMSDlgSA	:= {|| PmsDlgSAB(SCP->CP_NUM,SCP->CP_ITEM,nQtRequ)}
PRIVATE aRatAFH		:= {}
PRIVATE nQtRequ 	:= CriaVar("D3_QUANT",.F.)
PRIVATE cNewDoc		:= ""  // Novo No.do Documento, atualizado na A240TudoOK
PRIVATE lChgNewDoc	:= .F. // Indica se No.do Documento foi alterado, atualizado na A240TudoOK
PRIVATE aDadosPRJ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0]
PRIVATE aGETS[0]

cCadastro := OemToAnsi(STR0008) //"Baixa Pre-requisicao"

Pergunte("MTA185",.F.)

If Type("aAutoAFH") <> "U"
	lAuto:= aAutoAFH <> NIL .And. ValType(aAutoAFH) = 'A'
EndIf

If !SoftLock("SCP")
	lRet := .F.
EndIf

If lRet .And. SCP->CP_STATUS == "E"
	If Inclui //IF utilizado para nao exibir mensagem quando baixada a pre-requisicao
		HELP("   ",1,"A185BX")
	EndIf	
	lRet := .F.
EndIf

If lRet .And. Empty(SCP->CP_PREREQU)
	If Inclui //IF utilizado para nao exibir mensagem quando baixada a pre-requisicao
		HELP("   ",1,"A185PRE")
	EndIf	
	lRet := .F.
EndIf

If lRet
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_LOCAL)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ca100RetCQ() ----------->                   ³
		//³ [1] -  Saldo do Item                        ³
		//³ [2] -  Quantidade diponivel ja reservada    ³
		//³ [3] -  Quantidade em Processo de Compra     ³
		//³ [4] -  Situacao Atual                       ³
		//³ [5] -  Numero da Solicitacao de Compras     ³
		//³ [6] -  Numero de Requisicao                 ³
		//³ [7] -  Quantidade ja Entregue               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRetCQ  := ca100RetCQ(SCP->CP_NUM,SCP->CP_ITEM)
		nQatu   := SB2->B2_QATU
		nQtRes  := SB2->B2_RESERVA+SB2->B2_QEMP+SB2->B2_QEMPSA+SB2->B2_QACLASS-If(mv_par03==1.And.!Empty(SCP->CP_OP),SCP->CP_QUANT,0)
		nQtSal  := nQAtu - nQtRes
		nQtRequ := aRetCQ[2]
	Else
		Help(" ",1,"REGNOIS")
		lRet := .F.
	EndIf

	If lRet
		If IntePms() // Se usa PMS integrado com o ERP
			If lAuto
				PmsDlgSAB(SCP->CP_NUM,SCP->CP_ITEM,,aAutoAFH)
			Else
				SetKey(VK_F10,bPMSDlgSA)
				aButton := { {'PROJETPMS',{||Eval(bPMSDlgSA)},STR0066,STR0065} } //"Gerenciamento de Projetos"##"Projetos"
			EndIf
		Endif
		nQtdProc:= If( (mv_par02==2), U_A185QtProc(SCP->CP_PRODUTO), aRetCQ[3] )

		lMT185BUT := ExistBlock( "MT185BUT" )
		While .T.
		   
		    If lMT185BUT
		        If ValType( aUsButtons := ExecBlock( "MT185BUT", .F., .F. ) ) == "A"
				    AEval( aUsButtons, { |x| AAdd( aButton, x ) } ) 
		        EndIf
	        EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para processamento dos Gets          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nOpcA:=0
			dbSelectArea(cAlias)
			If !l185Auto
				DEFINE MSDIALOG oDlg FROM 000, 000 TO 320, 700 TITLE OemToAnsi(STR0008) OF oMainWnd PIXEL // Baixa Pre-Requisicao
				
				oSize := FwDefSize():New(.T.,,,oDlg) 
				oSize:AddObject("FOLDERA", 20, 100, .T., .T.) 		// Totalmente dimensionavel
				oSize:AddObject("FOLDERB", 80, 100, .T., .T.) 		// Totalmente dimensionavel
				oSize:lProp 	 	:= .T. 								// Proporcional
				oSize:lLateral 	:= .T.            					// Divisão lateral
				oSize:aMargins 	:= {3, 3, 3, 3} 						// Espaco ao lado dos objetos 0, entre eles 3 
				oSize:Process() 											// Dispara os calculos

				oSizeA := FwDefSize():New()
				oSizeA:aWorkArea 	:= oSize:GetNextCallArea("FOLDERA") 
				oSizeA:AddObject("FOLDERA1", 100, 10, .T., .T.) 		// Totalmente dimensionavel
				oSizeA:AddObject("FOLDERA2", 100, 26, .T., .T.) 		// Totalmente dimensionavel
				oSizeA:AddObject("FOLDERA3", 100, 26, .T., .T.) 		// Totalmente dimensionavel
				oSizeA:AddObject("FOLDERA4", 100, 26, .T., .T.) 		// Totalmente dimensionavel
				oSizeA:lProp 	 	:= .T. 								// Proporcional
				oSizeA:aMargins 	:= {3, 3, 3, 3}						// Espaco ao lado dos objetos 0, entre eles 3 
				oSizeA:Process() 											// Dispara os calculos				
				
				oSizeB := FwDefSize():New() 
				oSizeB:aWorkArea := oSize:GetNextCallArea("FOLDERB") 
				oSizeB:AddObject("FOLDERB1", 100, 30, .T., .T.) 		// Totalmente dimensionavel
				oSizeB:AddObject("FOLDERB2", 100, 70, .T., .T.) 		// Totalmente dimensionavel
				oSizeB:lProp 	 	:= .T. 								// Proporcional
				oSizeB:aMargins 	:= {0, 0, 0, 0}						// Espaco ao lado dos objetos 0, entre eles 3 
				oSizeB:Process() 											// Dispara os calculos
				
				oSizeB1 := FwDefSize():New() 
				oSizeB1:aWorkArea 	:= oSizeB:GetNextCallArea("FOLDERB1") 
				oSizeB1:AddObject("FOLDERB11", 100, 50, .T., .T.) 	// Totalmente dimensionavel
				oSizeB1:AddObject("FOLDERB12", 100, 50, .T., .T.) 	// Totalmente dimensionavel
				oSizeB1:lProp 	:= .T. 								// Proporcional
				oSizeB1:aMargins 	:= {3, 3, 3, 3}						// Espaco ao lado dos objetos 0, entre eles 3 
				oSizeB1:Process() 										// Dispara os calculos
				
				oSizeB2 := FwDefSize():New() 
				oSizeB2:aWorkArea 	:= oSizeB:GetNextCallArea("FOLDERB2") 
				oSizeB2:AddObject("FOLDERB21", 72, 100, .T., .T.) 	// Totalmente dimensionavel
				oSizeB2:AddObject("FOLDERB22", 28, 100, .T., .T.) 	// Totalmente dimensionavel
				oSizeB2:lProp 	:= .T. 								// Proporcional
				oSizeB2:lLateral	:= .T.
				oSizeB2:aMargins	:= {3, 3, 3, 3}						// Espaco ao lado dos objetos 0, entre eles 3 
				oSizeB2:Process() 										// Dispara os calculos								

				@ oSize:GetDimension("FOLDERA","LININI"), oSize:GetDimension("FOLDERA","COLINI") TO oSize:GetDimension("FOLDERA","LINEND"), oSize:GetDimension("FOLDERA","COLEND") LABEL "" OF oDlg PIXEL
				
				@ oSizeB:GetDimension("FOLDERB1","LININI"), oSizeB:GetDimension("FOLDERB1","COLINI") TO oSizeB:GetDimension("FOLDERB1","LINEND"), oSizeB:GetDimension("FOLDERB1","COLEND") LABEL "" OF oDlg  PIXEL
				@ oSizeB:GetDimension("FOLDERB2","LININI")+3, oSizeB:GetDimension("FOLDERB2","COLINI") TO oSizeB:GetDimension("FOLDERB2","LINEND"), oSizeB:GetDimension("FOLDERB2","COLEND") LABEL "" OF oDlg  PIXEL
				
				@ oSizeA:GetDimension("FOLDERA1","LININI"), oSizeA:GetDimension("FOLDERA1","COLINI") Say OemToAnsi(STR0010) SIZE oSizeA:GetDimension("FOLDERA1","LINEND"), oSizeA:GetDimension("FOLDERA1","COLEND") OF oDlg PIXEL  //"Resumo do Estoque"
				@ oSizeA:GetDimension("FOLDERA2","LININI"), oSizeA:GetDimension("FOLDERA2","COLINI") Say OemToAnsi(STR0011) SIZE oSizeA:GetDimension("FOLDERA2","LINEND"), oSizeA:GetDimension("FOLDERA2","COLEND") OF oDlg PIXEL  //"Quantidade Atual"
				@ oSizeA:GetDimension("FOLDERA2","LININI")+10, oSizeA:GetDimension("FOLDERA2","COLINI") MSGET nQatu When .F. Picture cPict SIZE oSizeA:GetDimension("FOLDERA2","XSIZE"), 10 OF oDlg PIXEL
				@ oSizeA:GetDimension("FOLDERA3","LININI"), oSizeA:GetDimension("FOLDERA3","COLINI") Say OemToAnsi(STR0012) SIZE oSizeA:GetDimension("FOLDERA3","LINEND"), oSizeA:GetDimension("FOLDERA3","COLEND") OF oDlg PIXEL  //"- Reservas PV/OP"
				@ oSizeA:GetDimension("FOLDERA3","LININI")+10, oSizeA:GetDimension("FOLDERA3","COLINI") MSGET nQtRes When .F. Picture cPict SIZE oSizeA:GetDimension("FOLDERA3","XSIZE"), 10 OF oDlg PIXEL
				@ oSizeA:GetDimension("FOLDERA4","LININI"), oSizeA:GetDimension("FOLDERA4","COLINI") Say OemToAnsi(STR0013) SIZE oSizeA:GetDimension("FOLDERA4","LINEND"), oSizeA:GetDimension("FOLDERA4","COLEND") OF oDlg PIXEL  //"= Qtd. Disponivel"
				@ oSizeA:GetDimension("FOLDERA4","LININI")+10, oSizeA:GetDimension("FOLDERA4","COLINI") MSGET nQtSal When .F. Picture cPict SIZE oSizeA:GetDimension("FOLDERA4","XSIZE"), 10 OF oDlg PIXEL
				
				@ oSizeB1:GetDimension("FOLDERB11","LININI")+2, oSizeB1:GetDimension("FOLDERB11","COLINI") Say OemToAnsi(STR0014) SIZE oSizeB1:GetDimension("FOLDERB11","LINEND"), oSizeB1:GetDimension("FOLDERB11","COLEND") OF oDlg PIXEL //"Numero "
				@ oSizeB1:GetDimension("FOLDERB11","LININI"), oSizeB1:GetDimension("FOLDERB11","COLINI")+30 MSGET SCP->CP_NUM When .F. SIZE 30, 10 OF oDlg PIXEL
				@ oSizeB1:GetDimension("FOLDERB11","LININI")+2, oSizeB1:GetDimension("FOLDERB11","COLINI")+70 Say OemToAnsi(STR0015)SIZE oSizeB1:GetDimension("FOLDERB11","LINEND"), oSizeB1:GetDimension("FOLDERB11","COLEND") OF oDlg PIXEL  //"Produto "
				@ oSizeB1:GetDimension("FOLDERB11","LININI"), oSizeB1:GetDimension("FOLDERB11","COLINI")+100 MSGET SCP->CP_PRODUTO When .F. SIZE 169, 10 OF oDlg PIXEL
				@ oSizeB1:GetDimension("FOLDERB12","LININI")+2, oSizeB1:GetDimension("FOLDERB12","COLINI") Say OemToAnsi(STR0016) SIZE oSizeB1:GetDimension("FOLDERB12","LINEND"), oSizeB1:GetDimension("FOLDERB12","COLEND") OF oDlg PIXEL  //"Descricao "
				@ oSizeB1:GetDimension("FOLDERB12","LININI"), oSizeB1:GetDimension("FOLDERB12","COLINI")+30 MSGET SCP->CP_DESCRI When .F. SIZE 239, 10 OF oDlg PIXEL
				
				@ oSizeB2:GetDimension("FOLDERB21","LININI")+7, oSizeB2:GetDimension("FOLDERB21","COLINI") Say OemToAnsi(STR0017) SIZE oSizeB2:GetDimension("FOLDERB21","LINEND"), oSizeB2:GetDimension("FOLDERB21","COLEND") OF oDlg PIXEL //"Saldo da Pre-Requisicao "
				@ oSizeB2:GetDimension("FOLDERB22","LININI")+5,oSizeB2:GetDimension("FOLDERB22","COLINI") MSGET aRetCQ[1] Picture cPict When .F. SIZE 72, 10 OF oDlg PIXEL RIGHT
				@ oSizeB2:GetDimension("FOLDERB21","LININI")+27, oSizeB2:GetDimension("FOLDERB21","COLINI") Say OemToAnsi(STR0018) SIZE oSizeB2:GetDimension("FOLDERB21","LINEND"), oSizeB2:GetDimension("FOLDERB21","COLEND") OF oDlg PIXEL //"Quantidade disp. para entrega"
				@ oSizeB2:GetDimension("FOLDERB22","LININI")+25,oSizeB2:GetDimension("FOLDERB22","COLINI") MSGET aRetCQ[2] Picture cPict When .F. SIZE 72, 10 OF oDlg PIXEL RIGHT
				@ oSizeB2:GetDimension("FOLDERB21","LININI")+47, oSizeB2:GetDimension("FOLDERB21","COLINI") Say OemToAnsi(STR0019) SIZE oSizeB2:GetDimension("FOLDERB21","LINEND"), oSizeB2:GetDimension("FOLDERB21","COLEND") OF oDlg PIXEL //"Quantidade em processo de compra"
				@ oSizeB2:GetDimension("FOLDERB22","LININI")+45, oSizeB2:GetDimension("FOLDERB22","COLINI") MSGET nQtdProc  Picture cPict When .F. SIZE 72, 10 OF oDlg PIXEL RIGHT
				@ oSizeB2:GetDimension("FOLDERB21","LININI")+67, oSizeB2:GetDimension("FOLDERB21","COLINI") Say OemToAnsi(STR0020) SIZE oSizeB2:GetDimension("FOLDERB21","LINEND"), oSizeB2:GetDimension("FOLDERB21","COLEND") OF oDlg PIXEL  //"Quantidade a Requisitar"
				@ oSizeB2:GetDimension("FOLDERB22","LININI")+65, oSizeB2:GetDimension("FOLDERB22","COLINI") MSGET nQtRequ Picture cPict Valid U_A185QtRequ(nQtRequ,aRetCQ[2],aRetCQ[1],nQatu) SIZE 72, 10 OF oDlg PIXEL

				DEFINE SBUTTON FROM 300, 500 TYPE 1 ACTION (IIF(U_A185QtRequ(nQtRequ,aRetCQ[2],aRetCQ[1],nQatu),(nOpca := 1,oDlg:End()),)) ENABLE OF oDlg
				ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg ,{||IIF(U_A185QtRequ(nQtRequ,aRetCQ[2],aRetCQ[1],nQatu,,.F.) .And. IIF(!lMT185OK,.T.,U_A185OK(lMT185OK)),(nOpca := 1,oDlg:End()),)},{||nOpca:=3,oDlg:End()},,aButton) CENTERED
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Quantidade a ser baixada pela rotina automatica |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX:=1 to len(aAutoSCP)
					If Upper(AllTrim(aAutoSCP[nX,1])) == "CP_QUANT"
						nQtRequ := aAutoSCP[nX,2]
					EndIf	
				Next 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida a quantidade a ser baixada				|
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If U_A185QtRequ(nQtRequ,aRetCQ[2],aRetCQ[1],nQatu)	
					nOpcA := 1	
				Else
					Exit
				EndIf	
			EndIF
		
			dbSelectArea(cAlias)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ P.E. Utilizado para validar a baixa da pre-requisicao  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lM185Mod1 .And. nOpcA == 1
				If !ExecBlock("M185MOD1",.F.,.F.,{SCP->CP_FILIAL,SCP->CP_PRODUTO,SCP->CP_LOCAL,nQatu,nQtRes,nQtSal,SCP->CP_NUM,aRetCQ[1],aRetCQ[2],nQtdProc,nQtRequ})
					nOpca := 3
				Endif	
			EndIf

			IF nOpcA == 1
				Begin Transaction

					If IntePMS().And. Len(aRatAFH) > 0
						aDadosPrjTmp	:=	PMSAFHDados(aRatAFH,SCP->CP_ITEM,nQtRequ)

						//
						// Gera um movimento interno para cada rateio
						// no PMS.
						//
						// A quantidade de cada movimento interno será definida
						// pelo campo AFH_QBAIX.
						//						
						For nX:=1 To Len(aDadosPrjTmp)
							aDadosPRJ	:=	aDadosPrjTmp[nX]
							AAdd(aDadosPRJ,(nX > 1))
							lContinua := U_A185Gera()
							If !lContinua
								Exit
							Endif	
						Next nX	
					Else

						// Verificar se existem amarrações de Solicitação ao Armazém
						// com o PMS
						If IntePms()
							lContinua := PmsAFHVal(SCP->CP_NUM, SCP->CP_ITEM, aRatAFH)

							If lContinua			
								lContinua := U_A185Gera()
							EndIf
						Else
							lContinua := U_A185Gera()
						EndIf						
					Endif
				End Transaction
				
				If lContinua .And. lChgNewDoc
					Help("",1,"A240DOC",,cNewDoc,4,30)
				EndIf			
				
				Exit
			Else
				MsUnLock()
			EndIf
			If nOpcA == 3
				Exit
			EndIf
		EndDo
	EndIf	
EndIf

//-- Libera os registros bloqueado pelo SoftLock
MsUnlockAll()

If IntePms()		// Se usa PMS integrado com o ERP
	SetKey(VK_F10,Nil)
EndIf

dbSelectArea(cAlias)
dbGoto(nReg)
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185AtuSD3³ Autor ³ Edson Maricate        ³ Data ³ 25.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza as variaveis de memoria para Inclusao no SD3.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MatA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185AtuSD3()
Local cSavAlias:= Alias()
Local aCTBEnt  := CTBEntArr()
Local nA	   := 0
Local lWmsNew := SuperGetMv("MV_WMSNEW",.F.,.F.)
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial()+SCP->CP_PRODUTO)
If IntePMS() .And. Type("aDadosPrj") == 'A'
	If aDadosPrj[4]
		M->D3_TM		:= SD3->D3_TM
	Endif                                                              
	M->D3_PROJPMS 	:= aDadosPrj[1]
	M->D3_TASKPMS 	:= aDadosPrj[2]
	M->D3_QUANT 	:= aDadosPrj[3]
Else
	M->D3_QUANT 	:= nQtRequ
Endif
M->D3_COD		:= SCP->CP_PRODUTO
M->D3_UM		:= SCP->CP_UM
M->D3_CONTA		:= SCP->CP_CONTA
M->D3_CLVL		:= SCP->CP_CLVL
M->D3_ITEMCTA	:= SCP->CP_ITEMCTA
M->D3_LOCAL		:= SCP->CP_LOCAL
M->D3_EMISSAO	:= DDATABASE
M->D3_GRUPO  	:= SB1->B1_GRUPO
M->D3_CC		:= SCP->CP_CC
M->D3_SEGUM		:= SCP->CP_SEGUM
M->D3_QTSEGUM	:= IIf(A185SegUm(M->D3_COD)==1,ConvUM(SCP->CP_PRODUTO,M->D3_QUANT,0,2),IIf(SCP->CP_QUANT == 0,0,(SCP->CP_QTSEGUM/SCP->CP_QUANT)*M->D3_QUANT))
M->D3_TIPO		:= SB1->B1_TIPO
M->D3_OP		:= SCP->CP_OP
M->D3_OSTEC		:= SCP->CP_NUMOS
M->D3_NUMSA := SCP->CP_NUM
M->D3_ITEMSA := SCP->CP_ITEM

If AllTrim(GetNewPar("MV_NGMNTNO","N")) == "1" .And. SubStr(M->D3_OP,7,5) == "OS001"
	M->D3_ORDEM := SubStr(M->D3_OP,1,6)
EndIf

For nA := 1 To Len(aCTBEnt)
	M->&("D3_EC"+aCTBEnt[nA]+"CR") := SCP->&("CP_EC"+aCTBEnt[nA]+"CR")
	M->&("D3_EC"+aCTBEnt[nA]+"DB") := SCP->&("CP_EC"+aCTBEnt[nA]+"DB")
Next nA

If lWmsNew .And. IntWMS(M->D3_COD)
	M->D3_SERVIC := Posicione("SB5",1,xFilial("SB5")+M->D3_COD,"B5_SERVREQ")
EndIf

If ExistBlock('MT185SD3')
	ExecBlock('MT185SD3',.F.,.F.)
EndIf	

dbSelectArea(cSavAlias)
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185QtRequ³ Autor ³ Edson Maricate        ³ Data ³02.12.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a quantidade digitada.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185QtRequ(ExpN1,ExpN2,ExpN3,ExpN4,ExpN5,ExpL1,ExpC1,ExpC2)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = qtde.                                              ³±±
±±³          ³ ExpN2 = qtde.disponivel                                    ³±±
±±³          ³ ExpN3 = Saldo                                              ³±±
±±³          ³ ExpN4 = qtde.atual                                         ³±±
±±³          ³ ExpN5 = qtde.total                                         ³±±
±±³          ³ ExpL1 = indica Bx.Pre                                 	  ³±±
±±³          ³ ExpC1 = projeto (PMS)                                	  ³±±
±±³          ³ ExpC2 = tarefa (PMS)                                 	  ³±±
±±³          ³ ExpA1 = Acols das pre-requisicoes - baixa por pre-requisic.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.             	                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185QtRequ(nQuant,nDisp,nQtSal,nQatu,nQtdTot,lBxPre,cProjeto,cTarefa,aCols)
Local lRet      := .T.
Local lEstNeg   := If(GetMV('MV_ESTNEG')=='N',.F.,.T.)
Local nPosRat	:=	0

//Qtd. Total selecionada
Default nQtdTot := 0
Default lBxPre	:= .T.
Default aCols   := {}

// Avalia se existe empenho para este item
If mv_par03 == 1 .And. AvalEmpSCP(SCP->CP_PRODUTO,SCP->CP_LOCAL,SCP->CP_OP,nQuant)
	Return lRet
EndIf

//Avalia se a OS já foi encerrada no SIGAMNT para encerrar a pré-requisição
If U_A185VldNG(SCP->CP_OP)
	Return lRet
EndIf

If lRet .And. ((nQatu-nQuant) < 0 .Or. ((nQtdTot+nQuant) > (SaldoSB2()+nDisp) .And. mv_par03 == 2 .And. !lPermBx)) .And. !lEstNeg
	Help(" ",1,"MA240NEGAT")
	lRet := .F.
EndIf
If lRet .And. nQuant > nQtSal
	Help ("    ",1,"QTDISP")  	// Exibe o Help
	lRet := .F.					// Nao Permite a baixa
EndIf
If lRet .And. nQuant > nDisp
	If !A185ValEmp(SCP->CP_PRODUTO,SCP->CP_LOCAL,nQuant,SCP->CP_NUM,SCP->CP_ITEM,aCols)
		lRet := .F.
	ElseIf nQuant <= nQtSal 
		// "Qtde. Disp. Nao Solicitada Para Esta Requisicao. Deseja Utiliza-la Mesmo Assim?" ### "Sim" ### "Nao"
		If !lPermBx
			If lBxPre .And. If(l185Auto,aPerg[3] == 2,Aviso("SIGAEST", STR0021, {STR0022, STR0023}) == 2)
				lRet := .F.
			EndIf
		Endif	
	Else
		Help ("    ",1,"QTDISP")  	// Exibe o Help
		lRet := .T.					// Permite a baixa
	EndIf
EndIf
If lRet .And. nQuant <= 0
	Help("    ",1,"VALZERADO")
	lRet := .F.
EndIf
If lRet .And. IntePMS() .And. (nPosRat := Ascan(aRatAFH,{|x| x[1]==SCP->CP_ITEM})) > 0
	lRet	:=	PMSAFHValid(nPosRat,nQuant,cProjeto,cTarefa)
Endif
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA185PERG³ Autor ³ Edson Maricate        ³ Data ³ 10/12/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada da funcao PERGUNTE                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA185PERG()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa tecla F12 para acionar perguntas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTA185",.T.)
Pergunte("MTA240",.T.)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Exclui³ Autor ³ Cesar Valadao         ³ Data ³07/02/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa da Exclusao das Pre-Requisicoes.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Exclui(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185Exclui(cAlias,nReg,nOpc)
Local oDlg			:= NIL

Local aAreaSCQ		:= {}
Local aObjects		:= {}                  
Local aSize			:= {} 
Local aInfo    		:= {}
Local aDocs			:= {}

Local cNumSa		:= ""
Local cChave		:= ".T."

Local nEntregSC7	:= 0
Local nOpcA			:= 0

Local lRet			:= .T.
Local lM185Excl		:= ExistBlock("M185EXCL")
Local lM185VldExc	:= ExistBlock("M185VLDEXC")
Local lPcoInt	  	:= SuperGetMV("MV_PCOINTE",.F.,"2")=="1"

Default nReg := Recno()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0], aGETS[0]

cCadastro := OemToAnsi(STR0006) //"Exclusao das Pre-requisicoes"

If SCP->CP_STATUS == "E"
	HELP("   ",1,"A185EXCL")
	Return .F.
EndIf

If Empty(SCP->CP_PREREQU)
	HELP("   ",1,"A185EXCPRE")
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica calendário contábil                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet 
	lRet := CtbValiDt(Nil,dDataBase,,Nil ,Nil ,{"EST001"})
EndIf

If !lRet
	Return .F.
EndIf

While .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para processamento dos Gets          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpcA:=0
	dbSelectArea(cAlias)
	SoftLock(cAlias)

	If !l185Auto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ajusta a largura para o tamanho padrao Protheus ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MsAdvSize()       
		aObjects := {}
		AAdd( aObjects, { 100, 100, .T., .T. } )
		aInfo    := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 } 
		aPosObj := MsObjSize( aInfo, aObjects ) 

		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL			
		nOpcA:=EnChoice( cAlias, nReg, nOpc, ,"AC",OemToAnsi(STR0007),,aPosObj[1])  //"Quanto … exclus„o?"
		nOpca := 1
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 2,oDlg:End()},{|| nOpca := 1,oDlg:End()})
	
		dbSelectArea(cAlias)
	Else
		nOpcA := 2
	Endif
	
	IF nOpcA == 2
		If lM185VldExc
			lRet :=	ExecBlock("M185VldExc",.F.,.F.)	
			lRet := If(ValType(lRet)#"L",.T.,lRet)
		EndIf
		If lRet		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apos passar por todas as verificacoes, deleta o registro     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Begin Transaction
				SCQ->(dbSeek(xFilial("SCQ")+SCP->CP_NUM+SCP->CP_ITEM))
				While !SCQ->(Eof()) .And. SCQ->(CQ_FILIAL+CQ_NUM+CQ_ITEM) == xFilial("SCQ")+SCP->CP_NUM+SCP->CP_ITEM
			
					If SCQ->CQ_QTDISP > 0
						dbSelectArea("SB2")
						dbSeek(xFilial()+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
						RecLock("SB2",.F.)
						Replace B2_QEMPSA With Max(0,B2_QEMPSA - SCQ->CQ_QTDISP)
						MsUnlock()
					EndIf

					If lM185Excl
						ExecBlock("M185EXCL",.F.,.F.)
					EndIf
					RecLock("SCQ",.F.,.T.)				
					SCQ->(dbDelete())
					SCQ->(MsUnlock())
					SCQ->(dbSkip())
				EndDo
				aadd(aDocs,;
					{SCP->CP_PRODUTO			,;			//aPequena[x,1] : Produto
							 SCP->CP_QUANT	,;			//aPequena[x,2] : Quantidade total
							 xFilial("SCP",cFilAnt),;			//aPequena[x,3] : Filial que será gerada o documento 
							 cFilAnt 			,;			//aPequena[x,4] : Filial que será feita entrega do produto 
							      				,;			//aPequena[x,5] : Documento que será gerado sendo 1=Solicitação de Compras e 2=Pedido de Compra
							      				,; 			//aPequena[x,6] : Fornecedor do produto
							      				,; 			//aPequena[x,7] : Loja do fornecedor do produto
							   					,;			//aPequena[x,8] : Condição de pagamento
							 SCP->CP_VUNIT	,;		 	//aPequena[x,9] : Preço do Produto
							 {}					,;		 	//aPequena[x,10] : Array de Rateios
							 SCP->CP_NUM		,;		 	//aPequena[x,11] : Código Documento
							 SCP->CP_ITEM		})		 	//aPequena[x,12] : Item do Documento 							 
				
				dbSelectArea("SCP")
				RecLock("SCP",.F.)
				SCP->CP_PREREQU := " "	// Permite Gerar Novas Pre-Requisicoes
				MsUnlock()	
				
				If lPcoInt
					PcoDetLan("000051","01","MATA110",.T.)
				EndIf				
				ComGeraDoc(aDocs,.T.,.F.,.F.,.T.,30,"MATA106",/*lEnviaEmail*/,/*Aglutina?*/,5  )
			End Transaction
		EndIf	
	Else
		MsUnLock()
	EndIf
	Exit
End

dbSelectArea(cAlias)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Estorn³ Autor ³ Larson Zordan         ³ Data ³07/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa do Estorno  das Pre-Requisicoes.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Estorn(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185Estorn(cAlias,nReg,nOpc)
Local oNo 	   		:= LoadBitmap( GetResources(), "LBNO"  )
Local oOk 	   		:= LoadBitmap( GetResources(), "LBTIK" )
Local nOpca    	:= 0
Local aAreaAnt 	:= GetArea()
Local aBaixas  	:= {}
Local aItSCQ   	:= {}
Local cItBx    	:= ''
Local dDataFec 	:= MVUlmes()
Local lDataFec 	:= .F.
Local oDlg
Local oDlgA
Local oLbxA      

Local aObjects 	:= {}                  
Local aInfo    	:= {}
Local oSizeA		:={}

Local lRet			:= .T.

Local aNumSCDhn	:= {}
Local cDocSC		:= ""
Local cItSC		:= ""
Local cDocAE		:= ""
Local cItAE		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis indicam para as funcoes de validacao qual    ³
//³ programa as esta' chamando                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE l240:=.T.,l250:=.F.,l241:=.F.,l242:=.F.,l261:=.F.,l185 :=.T.

If SCP->CP_QUJE == 0
	If SCP->CP_STATUS == "E" 
		If l185Auto
			AutoGrLog(OemToAnsi(STR0077))
		Else 
			Aviso("A185ESTORNO",OemToAnsi(STR0077),{OemToAnsi(STR0039)})		
		EndIf	  
   Else
		If l185Auto
			AutoGrLog(OemToAnsi(STR0056))
		Else 
			Aviso("A185ESTORNO",OemToAnsi(STR0056),{OemToAnsi(STR0039)})		
		EndIf	  
	EndIf                                      
	Return .F.
EndIf

If Empty(SCP->CP_PREREQU)
	Help("   ",1,"A185PRE")
	Return .F.
EndIf

//------------------------------------------------------
// Caso haja EPI entregue a algum funcionario, não
// poderá realizar o estorno (SIGAMDT)
// MV_NGMDTES deverá estar habilitado 
//------------------------------------------------------
If FindFunction('MDTValEst') .And. !MDTValEst( SCP->CP_NUM + SCP->CP_ITEM , SCP->CP_FILIAL , 2 )
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica calendário contábil                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet 
	lRet := CtbValiDt(Nil,dDataBase,,Nil ,Nil ,{"EST001"})
EndIf

If 	lRet
If !l185Auto  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta a largura para o tamanho padrao Protheus ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()       
	//aSize[5] := 1155      	
	//aSize[3] := 318
	aObjects := {}
	AAdd( aObjects, { 100, 100, .T., .T. } )
	aInfo    := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 } 
	aPosObj := MsObjSize( aInfo, aObjects ) 

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0055) FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL			
	nOpca := EnChoice( cAlias, nReg, nOpc, ,,,,aPosObj[1])
	Activate MsDialog oDlg On Init EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2,oDlg:End()},,)    

Else 
	nOpca := 1
EndIf

If nOpca == 1

	dbSelectArea("SCQ")
	dbSetOrder(1)
	If dbSeek(xFilial()+SCP->CP_NUM+SCP->CP_ITEM)
		While !Eof() .And. xFilial()+SCP->CP_NUM+SCP->CP_ITEM+SCP->CP_PRODUTO == CQ_FILIAL+CQ_NUM+CQ_ITEM+CQ_PRODUTO
			//Recupera a SC gerada pela Central de Compras
			aNumScDhn := COMPosDHN({2,{SCP->CP_FILIAL,SCP->CP_NUM,SCP->CP_ITEM,"1",'MATA106'}})
			If aNumSCDhn[1]
				cDocSC	:= (aNumScDhn[2])->DHN_DOCDES
				cItSC	:= (aNumScDhn[2])->DHN_ITDES
				(aNumSCDhn[2])->(DbCloseArea())
			EndIf
			aAdd(aItSCQ,{ SCQ->CQ_PRODUTO, SCQ->CQ_NUMREQ, SCQ->CQ_QTDISP, SCQ->CQ_QUANT, SCQ->(Recno()),cDocSC,cItSC})
			If !Empty(SCQ->CQ_NUMREQ)
				SD3->(dbSetOrder(4))
				If SD3->(dbSeek(xFilial("SD3")+SCQ->CQ_NUMREQ+"E0"+SCQ->CQ_PRODUTO))
					If dDataFec < SD3->D3_EMISSAO
						aAdd(aBaixas,{.T.,SD3->D3_EMISSAO,Transform(SD3->D3_QUANT,PesqPict("SD3","D3_QUANT",14)),SD3->(Recno()),SCQ->(Recno())})
					Else 
						lDataFec := .T.
					EndIf	
				EndIf	
			EndIf	
			SCQ->(dbSkip())
		EndDo
	EndIf

	If Len(aBaixas) > 1
		
		If !l185Auto
			Define MsDialog oDlgA Title OemToAnsi(STR0057) From 0, 0 To 20, 60 Of oMainWnd  //"Baixas Parciais"
			
			oSizeA := FwDefSize():New(.T.,,,oDlgA) 
			oSizeA:AddObject("FOLDERA", 100, 100, .T., .T.) 		// Totalmente dimensionavel
			oSizeA:lProp 	 	:= .T. 								// Proporcional
			oSizeA:aMargins 	:= {3, 3, 3, 3} 						// Espaco ao lado dos objetos 3, entre eles 3 
			oSizeA:Process() 											// Dispara os calculos
						
			@ oSizeA:GetDimension("FOLDERA","LININI"),oSizeA:GetDimension("FOLDERA","COLINI");
				ListBox oLbxA Var cItBx Fields Header " ", STR0058, STR0059, STR0060; 	//"Seq.","Data Baixa","Quant."
				Size oSizeA:GetDimension("FOLDERA","XSIZE"),oSizeA:GetDimension("FOLDERA","YSIZE");
				On DBLCLICK (aBaixas:=a185Marca(oLbxA:nAt,aBaixas),oLbxA:Refresh()) PIXEL OF oDlgA
			
			oLbxA:SetArray(aBaixas)
			oLbxA:bLine := { || {If(aBaixas[oLbxA:nAt,1],oOk,oNo),StrZero(oLbxA:nAt,2),aBaixas[oLbxA:nAt,2],aBaixas[oLbxA:nAt,3]}}
			
			Activate MsDialog oDlgA Center On Init EnchoiceBar(oDlgA,{|| nOpca := 1,oDlgA:End()},{|| nOpca := 2,oDlgA:End()},,)
		Else
			nOpca:=1		
		EndIf		
		
		If nOpca == 1
			Processa({|lEnd| A185MovSD3(aBaixas,aItSCQ)},STR0061,STR0062,.F.)  //"Processando...","Estorno das Baixas"
		EndIf
		
	Else
		If Len(aBaixas) > 0
			Processa({|lEnd| A185MovSD3(aBaixas,aItSCQ)},STR0061,STR0062,.F.) //"Processando...","Estorno das Baixas"
		Else
			If lDataFec
				Help(" ",1,"FECHTO")
			EndIf	
		EndIf
	EndIf	
	
EndIf
EndIf

RestArea(aAreaAnt)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Marca ³ Autor ³ Larson Zordan         ³ Data ³10/02/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marca as requisicoes a serem estornadas.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Marca(ExpA1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Posicao do item dentro do Array                    ³±±
±±³          ³ ExpA1 = Array com os dados da listbox                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = Array com os dados da listbox                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A185Marca(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return( aArray )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185MovSD3³ Autor ³ Larson Zordan         ³ Data ³10/02/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza os dados do estorno das pre-requisicoes           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185MovSD3(ExpA1,ExpA2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com as requisicoes (SD3)                     ³±±
±±³          ³ ExpA2 = Array com as pre-requisicoes (SCQ)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A185MovSD3(aDados,aItSCQ)

Local aRegSCQ    := {}
Local a241ISD3	 := {}
Local a09EST	 := {}
Local nX         := 0
Local nReg       := 0
Local nPos       := 0
Local nQtd       := 0
Local nQtDisp    := 0
Local lPrj		 :=	.F.
Local lRet       := .T.
Local lMT185EST  :=  .F.
//-- Variavel usada para verificar se o disparo da funcao IntegDef() pode ser feita manualmente
Local lIntegDef  :=  FWHasEAI("MATA241")

Private l240Auto := .T.
Private cCusMed  := GetMv("MV_CUSMED")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
	Private nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	Private lCriaHeader := .T. 	// Para criar o header do arquivo Contra Prova
	Private cLoteEst 			// Numero do lote para lancamentos do estoque
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Estoque         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	dbSelectArea("SX5")
//	dbSeek(xFilial()+"09EST")
	a09EST := FWGetSX5('ZC',xFilial()+"09EST")
//	cLoteEst:=IIF(Found(),Trim(X5_DESCRI),"EST ")
	cLoteEst:=IIF(Found(),Trim(a09EST[1,4]),"EST ")
	Private nTotal := 0 		// Total dos lancamentos contabeis
	Private cArquivo			// Nome do arquivo contra prova
EndIf

lMT185EST := ExistBlock('MT185EST')
For nX := 1 To Len(aDados)
	If aDados[nX,1]
		nReg := aDados[nX,4]
		dbSelectArea("SD3")
		dbGoTo(nReg)
		nQtd	:= SD3->D3_QUANT
		lPrj	:=	!Empty(SD3->D3_PROJPMS).And.!Empty(SD3->D3_TASKPMS)
		if lMT185EST 
			lRet :=	ExecBlock('MT185EST',.F.,.F.,{aDados[nx],aItSCQ})
			If Valtype(lRet) == "L"  .And. !lRet
				Loop
			EndIf
		EndIf
		If	lIntegDef
			AAdd(a241ISD3,nReg)
		EndIf
		
		If a240Estorn("SD3",nReg,4)
			nPos := aScan(aItSCQ,{ |x| x[5] == aDados[nX,5]})
			If nPos > 0
				
				//--> Deletar a pre-requisicao baixada
				SCQ->(dbGoTo(aItSCQ[nPos,5]))
				RecLock("SCQ",.F.)
				dbDelete()
				MsUnLock()
				dbGoto(Recno())
				
				//--> Atualizar o saldo da pre-requisicao
				SCQ->(dbGoTo(aItSCQ[Len(aItSCQ),5]))
				nQtDisp := SCQ->CQ_QTDISP
				If SCQ->(aItSCQ[Len(aItSCQ),5])<=SCQ->(LastRec()) .And. !(Eof().Or.Bof()) .And. Empty(SCQ->CQ_NUMREQ)
					RecLock("SCQ",.F.)
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Criar uma pre-requisicao do saldo estornado     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//--> Montar a estrutura do registro
					aEval(dbStruct(), {|z, w| aAdd(aRegSCQ, FieldGet(w)) } )
					//--> Gravar registro da pre-requisicao
					RecLock("SCQ",.T.)
					aEval(aRegSCQ, {|z, w| FieldPut(w, aRegSCQ[w]) } )
					Replace SCQ->CQ_NUMREQ  With Space(Len(SCQ->CQ_NUMREQ)),;
					SCQ->CQ_QUANT   With 0	,;
					SCQ->CQ_QTDISP  With 0   ,;
					SCQ->CQ_QTSEGUM With 0
					aAdd(aItSCQ,{ SCQ->CQ_PRODUTO, SCQ->CQ_NUMREQ, (SCQ->CQ_QTDISP+nQtd), (SCQ->CQ_QUANT+nQtd), SCQ->(Recno())})
				EndIf
				Replace SCQ->CQ_QUANT   With SCQ->CQ_QUANT  + nQtd ,;
				SCQ->CQ_QTDISP  With SCQ->CQ_QTDISP + A185QtdNeg(nQtd,aItSCQ[nPos,6],aItSCQ[nPos,7]),;
				SCQ->CQ_QTSEGUM With IIf(A185SegUm(SCQ->CQ_PRODUTO)==1,ConvUM(SCQ->CQ_PRODUTO,SCQ->CQ_QUANT,0,2),IIf(SCP->CP_QUANT == 0,0,(SCP->CP_QTSEGUM/SCP->CP_QUANT)*SCQ->CQ_QUANT))
				MsUnLock()
				dbGoto(Recno())
				
				//--> Atualizar o Saldo das Solicitacoes ao Armazem
				If SB2->(dbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_LOCAL))
					RecLock("SB2",.F.)
					Replace SB2->B2_QEMPSA With SB2->B2_QEMPSA + A185QtdNeg(nQtd,aItSCQ[nPos,6],aItSCQ[nPos,7])
					MsUnlock()
					dbGoto(Recno())
				EndIf
				
				//--> Atualizar o saldo da Qtde. Ja Entregue da Solic. Armaz.
				RecLock("SCP",.F.)
				Replace SCP->CP_QUJE With SCP->CP_QUJE - nQtd
				If SCP->CP_QUJE < SCP->CP_QUANT
					Replace SCP->CP_STATUS With " "
				EndIf
				MsUnLock()
				If IntePMS() .And. lPrj
					DbSelectArea('AF8')
					DbSetOrder(1)
					MsSeek(xFilial()+SD3->D3_PROJPMS)
					DbSelectArea('AFH')
					DbSetOrder(1)
					If MsSeek(xFilial()+SD3->D3_PROJPMS+AF8->AF8_REVISA+SD3->D3_TASKPMS+SCP->CP_NUM+SCP->CP_ITEM)
						RecLock('AFH',.F.)
						AFH_QUJE	-=	SD3->D3_QUANT
						MsUnLock()
					Endif
				Endif
				
				dbGoto(Recno())
			EndIf
		Endif
	EndIf
Next nX
//-- Estorno da baixa da pre-requisicao
If	lIntegDef
	//-- Atualiza array de recnos a serem processados na mensagem unica no MATA241
	MTA241SD3(a241ISD3)

	FwIntegDef( 'MATA241' )
EndIf
// Executa ponto de entrada apos o estorno
If ExistBlock('M185EST')
	ExecBlock('M185EST',.F.,.F.)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A185Bt?? ³ Autor ³ Cesar Valadao         ³ Data ³23/02/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Que Determina o Status das Pre-Requisicoes.         ³±±
±±³          ³ A185BtVd - Verde                                           ³±±
±±³          ³ A185BtAm - Amarelo                                         ³±±
±±³          ³ A185BtVe - Vermelho                                        ³±±
±±³          ³ A185BtAz - Azul                                            ³±±
±±³          ³ A185BtLa - Laranja                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Bt??()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / Nenhum                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A185BtVe()
Local lRet
If !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. (QtdComp(SCP->CP_QUANT) == QtdComp(SCP->CP_QUJE))
	lRet := .T.
EndIf
Return lRet

User Function A185BtVd()
Local lRet
If Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. QtdComp(SCP->CP_QUJE) == QtdComp(0)
	lRet := .T.
EndIf
Return lRet

User Function A185BtAm()
Local lRet
If Empty(SCP->CP_STATUS) .And. Empty(SCP->CP_PREREQU)
	lRet := .T.
EndIf
Return lRet

User Function A185BtAz()
Local lRet
If !Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. (QtdComp(SCP->CP_QUANT) > QtdComp(SCP->CP_QUJE))
	lRet := .T.
EndIf
Return lRet

User Function A185BtLa()
Local lRet
If Empty(SCP->CP_STATUS) .And. SCP->CP_PREREQU == "S" .And. QtdComp(SCP->CP_QUJE) > QtdComp(0)
	lRet := .T.
EndIf
Return lRet            


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a106AtuCQ ³ Autor ³ Edson Maricate        ³ Data ³ 25.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o arquivo de Pre-requisicoes.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A106AtuCQ(ExpN1,ExpN2,ExpC1,ExpL1)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = qtde.                                              ³±±
±±³          ³ ExpN2 = qtde.disponivel		                              ³±±
±±³          ³ ExpC1 = numero da pre-req.	                              ³±±
±±³          ³ ExpL1 = indica se atualiza SB2                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA106                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a106AtuCQ(nQuant,nQtDisp,cItemPR,lAtuSB2)
Local lMta106   := ExistBlock("MT106CQ")
Local aDadosGer :={nil,nil,nil,nil}

If lAtuSB2==Nil
	lAtuSB2 := .T.
EndIf

RecLock("SCQ",.T.)
SCQ->CQ_FILIAL := xFilial("SCQ")
SCQ->CQ_NUM    := SCP->CP_NUM
SCQ->CQ_ITEM   := SCP->CP_ITEM
SCQ->CQ_PRODUTO:= SCP->CP_PRODUTO
SCQ->CQ_LOCAL  := SCP->CP_LOCAL
SCQ->CQ_UM     := SCP->CP_UM
SCQ->CQ_QUANT  := nQuant
SCQ->CQ_QTSEGUM:= IIf(A185SegUm(SCQ->CQ_PRODUTO)==1,ConvUM(SCP->CP_PRODUTO,nQuant,0,2),IIf(SCP->CP_QUANT == 0,0,(SCP->CP_QTSEGUM/SCP->CP_QUANT)*nQuant))
SCQ->CQ_SEGUM  := SCP->CP_SEGUM
SCQ->CQ_QTDISP := nQtDisp
SCQ->CQ_NUMSQ  := cItemPR
SCQ->CQ_DATPRF := SCP->CP_DATPRF
SCQ->CQ_DESCRI := SCP->CP_DESCRI
SCQ->CQ_CC     := SCP->CP_CC
SCQ->CQ_CONTA  := SCP->CP_CONTA
SCQ->CQ_ITEMCTA:= SCP->CP_ITEMCTA
MsUnlock()

If lMta106
	Execblock("MT106CQ",.F.,.F.,aDadosGer)	//-- Ponto de Entrada executado tambem na MaSAPreReq (Comxfun)
Endif

If lAtuSB2
	dbSelectArea("SB2")
	Reclock("SB2",.F.)
	If nQtDisp > 0
		SB2->B2_QEMPSA := B2_QEMPSA + nQtDisp
	EndIf
	MsUnlock()
EndIf
dbSelectArea("SCQ")
MsUnlock()
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Legend³ Autor ³ Patricia A. Salomao   ³ Data ³ 18.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Legenda                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametos ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.		                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185Legend()   
Local aLegenda := {}     // Variavel para itens da Legenda
Local aMT185LEG := {}    // Variavel para o PE MT185LEG

aAdd(aLegenda,{"DISABLE"		,STR0034})          //Pre-Requisicao Baixada
aAdd(aLegenda,{"ENABLE"		    ,STR0035})   		//Baixar Pre-Requisicao
aAdd(aLegenda,{"BR_AMARELO"	    ,STR0036})   		//Gerar Pre-Requisicao
aAdd(aLegenda,{"BR_AZUL"		,STR0064})   		//Pre-Requisicao Encerrada
aAdd(aLegenda,{"BR_LARANJA"	    ,STR0069})		    //Parcialmente Baixada

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PE Utilizado para Manipular Legenda		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MT185LEG")
	aMT185LEG := ExecBlock("MT185LEG",.F.,.F., {aLegenda} )
	If ( Valtype(aMT185LEG) == "A" )
		aLegenda := aClone( aMT185LEG )
	EndIf
EndIf

BrwLegenda(STR0005,STR0033,aLegenda) //Legenda
								
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Encer ³ Autor ³ Marcelo Iuspa         ³ Data ³01/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa da Encerramento de Pre-Requisicoes.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Encer(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185Encer(cAlias,nReg,nOpc)
Local nQuantBaixa:= 0
Local nCQ_QUANT	 := 0
Local nQtdEnc    := 0
Local nEntregSC7 := 0
Local nOpca      := 1
Local nSC        := 2
Local nAE        := 2
Local aSC        := {}
Local aPed       := {}
Local oDlg
Local nX     
Local oSize
Local oEnch
Local lRet 	   := .T.
Local cDocSC		:= ""
Local cDocAE		:= ""

PRIVATE aTELA[0][0], aGETS[0]

cCadastro := STR0038 //"Encerramento de Pre-requisicoes"

If SCP->CP_STATUS == "E"
	HELP("   ",1,"A185JAENCE")
	Return(.F.)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica calendário contábil                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet 
	lRet := CtbValiDt(Nil,dDataBase,,Nil ,Nil ,{"EST001"})
EndIf

If !lRet
	Return .F.
EndIf

dbSelectArea(cAlias)
SoftLock(cAlias)
PcoInilan("000057")
If !l185Auto      
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula dimensões ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSize := FwDefSize():New()
	oSize:AddObject( "TELA", 100, 100, .T., .T., .T. ) // Totalmente dimensionavel

	oSize:lProp := .T. // Proporcional 
	oSize:aMargins := { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 

	oSize:Process() // Dispara os calculos 

	DEFINE MSDIALOG oDlg TITLE cCadastro ;
	       				 FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL

	oEnch:=MsMGet():New(cAlias, nReg, nOpc,,,,,oSize:aPosObj[1],,,,,,oDlg) 
    oEnch:oBox:Align := CONTROL_ALIGN_ALLCLIENT
     
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 2,oDlg:End()},{|| nOpca := 1,oDlg:End()})

	dbSelectArea(cAlias)
Else
	nOpcA:=2
Endif

If nOpca == 2
	Begin Transaction
		RecLock("SCP", .F.)
		SCP->CP_STATUS := "E"
		SCP->CP_PREREQU:= "S"
		MsUnlock()
		SC1->(dbSetOrder(1))
		SC7->(dbSetOrder(1))
		dbSelectArea("SCQ")
		dbSetOrder(1)
		dbSeek(xFilial()+SCP->CP_NUM+SCP->CP_ITEM)
		While !Eof() .And. xFilial()+SCP->CP_NUM+SCP->CP_ITEM == CQ_FILIAL+CQ_NUM+CQ_ITEM
			If Empty(CQ_NUMREQ)
				If SCQ->CQ_QTDISP > 0
					nQuantBaixa:=SCQ->CQ_QTDISP
					PcoDetLan("000057","01","MATA185")
				EndIf
				nCQ_QUANT := SCQ->CQ_QUANT
				RecLock("SCQ",.F.,.T.)
				dbDelete()			
				MsUnlock()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ha Solicitacao de Compras Pendente  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//Recupera a SC gerada pela Central de Compras
				aNumScDhn := COMPosDHN({2,{SCQ->CQ_FILIAL,SCQ->CQ_NUM,SCQ->CQ_ITEM,"1",'MATA106'}})
				If aNumSCDhn[1]
					If (aNumScDhn[2])->DHN_TIPO == "1" //Solicitação de Compra
						cDocSC	:= (aNumScDhn[2])->DHN_DOCDES
						cItSC	:= (aNumScDhn[2])->DHN_ITDES
					ElseIf (aNumScDhn[2])->DHN_TIPO == "3" //Autorização de Entrega
						cDocAE	:= (aNumScDhn[2])->DHN_DOCDES
						cItAE	:= (aNumScDhn[2])->DHN_ITDES
					EndIf
					(aNumSCDhn[2])->(DbCloseArea())
				EndIf
				
				//If !Empty(SCQ->CQ_NUMSC)
				If !Empty(cDocSC)
					//If SC1->(dbSeek(xFilial("SC1")+SCQ->CQ_NUMSC+SCQ->CQ_ITSC))
					If SC1->(dbSeek(xFilial("SC1") + cDocSC + cItSC))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Para SC Pendente, Qtd Ja entregue igual a zero e  ³
						//³ nao podera ter cotacao amarrada.                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SC1->C1_QUJE==0 .And. Empty(SC1->C1_COTACAO)
							aAdd(aSC,{cDocSC,cItSC})
						EndIf
					EndIf	
				//ElseIf !Empty(SCQ->CQ_NUMAE)
				ElseIf !Empty(cDocAE)
					If SC7->(dbSeek(xFilial("SC7") + cDocAE + cItAE))
						nEntregSC7:=SC7->C7_QUJE+SC7->C7_QTDACLA
						If nEntregSC7 <= 0
							aAdd(aPed,{cDocAE,cItAE,SC7->C7_NUMSC,SC7->C7_ITEMSC,nCQ_QUANT,nEntregSC7})
						EndIf
                    EndIf
				EndIF
				
			EndIf
			dbSkip()
		End
		
		If Len(aSC) > 0
			//"Existe uma SC Para Esta Pre-Requisicao." ### "Deleta-la" ### "Mante-la"
			If l185Auto
				nSC := aPerg[4]
			Else 
				nSC := Aviso("SIGAEST", STR0028, {STR0030, STR0031})
			EndIf	
			If nSC == 1
				SC1->(dbSetOrder(1))
				For nX := 1 To Len(aSC)
					If SC1->(dbSeek(xFilial("SC1")+aSC[nX,1]+aSC[nX,2]))
						nQtdEnc += SC1->C1_QUANT
						dbSelectArea("SC1")
						RecLock("SC1", .F.)
						dbDelete()
						MsUnlock()
					EndIf
				Next nX
			EndIf
		EndIf

		If Len(aPed) > 0
			//"Existe uma AE para esta Pre-Requisicao." ### "Deleta-la" ### "Mante-la"
			If l185Auto
				nAE := aPerg[4]
			Else 
				nAE := Aviso("SIGAEST", STR0070, {STR0030, STR0031})
			EndIf	
			If nAE == 1
				SC7->(dbSetOrder(1))
				For nX := 1 To Len(aPed)
					If SC7->(dbSeek(xFilial("SC7")+aPed[nX,1]+aPed[nX,2]))
						nQtdEnc += SC7->C7_QUANT
						dbSelectArea("SC7")
						RecLock("SC7", .F.)
						dbDelete()
						MsUnlock()
						// Volta saldo ate a autorizacao de entrega
						dbSelectArea("SC3")
						dbSetOrder(1)
						If dbSeek(xFilial("SC3")+aPed[nX,3]+aPed[nX,4])
							RecLock("SC3",.F.)
							Replace C3_QUJE With C3_QUJE - (aPed[nX,5]-aPed[nX,6])   // nCQ_Quant-nEntregSC7
							If C3_QUANT > C3_QUJE .And. C3_ENCER == "E"
								Replace C3_ENCER With " "
							Endif
							MsUnlock()
						EndIf
					EndIf
				Next nX
			EndIf
		EndIf
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2") + SCP->CP_PRODUTO + SCP->CP_LOCAL) 
			RecLock("SB2", .F.)
			SB2->B2_QEMPSA  -= Min(SB2->B2_QEMPSA,nQuantBaixa)
			SB2->B2_SALPEDI -= nQtdEnc
			MsUnlock()
		Endif
	End Transaction
	
	dbSelectArea(cAlias)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada MA185ENC                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("MA185ENC")
		ExecBlock("MA185ENC",.F.,.F.)
	EndIf
EndIf		
PcoFinLan("000057")
dbSelectArea(cAlias)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A185Tipo ³ Autor ³ Larson Zordan         ³ Data ³ 22.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona o Tipo de Baixa das Pre-Requisicoes              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Tipo(ExpC1,ExpN1,ExpN2)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. 						                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MatA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185Tipo(cAlias,nReg,nOpc)
Pergunte("MTA185",.T.)
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Automa³ Autor ³ Larson Zordan         ³ Data ³22.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Baixa Total das Pre-requisicoes.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Automa(ExpC1,ExpN1,ExpN2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. 						                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185Automa(cAlias,nReg,nOpc)
Local oRetCq   := Array(2)
Local aAreaAnt := GetArea()
Local aCols    := {}
Local aObjects := {}
Local aPosObj  := {}
Local aSize    := MsAdvSize()
Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local cCC      := ""
Local cVarQ    := ""
Local cNumSA   := ""
Local cPict    := PesqPictQt('D3_QUANT')
Local lPreRequ := .F.
Local lQual    := .F.
Local lStatus  := .F.
Local lGerar   := .F.
Local lRet	   := .T.
Local nQtRes   := 0
Local nQtSal   := 0
Local nQtTotal := 0
Local nQtdSegUm:= 0
Local nRegist  := SCP->(Recno())
Local oNo 	   := LoadBitmap( GetResources(), "LBNO"  )
Local oOk 	   := LoadBitmap( GetResources(), "LBTIK" )
Local lM185MOD2:= ExistBlock("M185MOD2")
Local uRet     := Nil
Local nX       := 0
Local aNumPrj  := {}

Local oDlg, oLbx, oChk, oQatu
Local oQtRes, oQtSal, oQtTotal
Local lPIMSInt	:= SuperGetMV("MV_PIMSINT",.F.,.F.)
Local lMT185BX := .F.

Private aRatAFH:= {}
Private aRetCQ := {}
Private nQAtu  := 0

Pergunte("MTA185",.F.)

dbSelectArea("SCP")
dbSetOrder(1)
cNumSA := CP_NUM
If dbSeek(xFilial()+cNumSA)
	lMT185BX := ExistBlock("MT185BX")
	While !Eof() .And. xFilial()+cNumSA == CP_FILIAL+CP_NUM
		If !SoftLock("SCP")
			Return .F.
		EndIf
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_LOCAL))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ca100RetCQ() ----------->                   ³
			//³ [1] -  Saldo do Item                        ³
			//³ [2] -  Quantidade diponivel ja reservada    ³
			//³ [3] -  Quantidade em Processo de Compra     ³
			//³ [4] -  Situacao Atual                       ³
			//³ [5] -  Numero da Solicitacao de Compras     ³
			//³ [6] -  Numero de Requisicao                 ³
			//³ [7] -  Quantidade ja Entregue               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aRetCQ := ca100RetCQ(SCP->CP_NUM,SCP->CP_ITEM)
		Else
			Help(" ",1,"REGNOIS")
			Return .F.
		EndIf
		If SCP->CP_STATUS == "E"
			lStatus := .T.
			dbSkip()
			Loop
		EndIf
		
		If Empty(SCP->CP_PREREQU)
			lPreRequ := .T.
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ P.E. utilizado para customizar o aCols da baixa da pre-requisicao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMT185BX 
			uRet := ExecBlock("MT185BX",.F.,.F.,{aRetCQ[2],SCP->CP_PRODUTO,SCP->CP_NUM,SCP->CP_ITEM})
			If Valtype(uRet) == "A" .And. Len(uRet) > 0
				For nX :=1 To Len(uRet)
					aAdd(aCols,uRet[nX])
				Next nX
			EndIf	
		Else
			//-- Tratamento para Segunda Unidade de Medida
			nQtdSegUm := IIf(A185SegUm(SCP->CP_PRODUTO)==1,ConvUM(SCP->CP_PRODUTO,aRetCQ[2],0,2),IIf(SCP->CP_QUANT == 0,0,(SCP->CP_QTSEGUM/SCP->CP_QUANT)*aRetCQ[2]))
			
			aAdd(aCols,{	.F.			,;									// Marca de selecao
							CP_NUM		,; 									// Numero da SA
							CP_ITEM		,;									// Item da SA
							CP_PRODUTO	,;									// Produto
							CP_DESCRI	,;									// Descricao do Produto
							CP_LOCAL	,;									// Armazem
							CP_UM		,;									// UM
							Transform(aRetCQ[2],PesqPictQt('D3_QUANT')),;	// Qtd. a Requisitar (Formato Caracter)
							aRetCQ[2]	,;									// Qtd. a Requisitar
							CP_CC		,;									// Centro de Custo
							CP_SEGUM	,;									// 2a.UM
							nQtdSegUm	,;									// Qtd. 2a.UM
							CP_OP		,;									// Ordem de Producao
							CP_CONTA	,;									// Conta Contabil
							CP_ITEMCTA	,;									// Item Contabil
							CP_CLVL		,;									// Classe Valor
							CriaVar('AFH_PROJET',.F.),; 				 	// Projeto
							CP_NUMOS 	,;									// Nr. da OS
							CriaVar('AFH_TAREFA',.F.),;				 	// Tarefa
							"SCP"	,;										// Alias Walk-Thru
							SCP->(RecNo()) ,;								// Recno Walk-Thru
							Iif(lPIMSInt,CP_NRBPIMS,' ')})								// Numero Boletim PIMS
															
			// Gravacao do PROJETO + TAREFA, caso exista amarrado a SA
			If IntePMS()
				aNumPrj := M185RetPrj(SCP->CP_NUM,SCP->CP_ITEM)
				If Len(aNumPrj) > 0
					aCols[Len(aCols)][17] := aNumPrj[1] // Projeto
					aCols[Len(aCols)][19] := aNumPrj[2] // Tarefa
				EndIf
			EndIf
		EndIf
		dbSkip()
	EndDo
Else
	Help(" ",1,"REGNOIS")
	lRet := .F.
EndIf

If lRet .And. Len(aCols) == 0 .And. lStatus
	If Inclui //IF utilizado para nao exibir mensagem quando baixada a pre-requisicao
		Help(" ",1,"A185BX")
	EndIf	
	lRet := .F.
EndIf	
If lRet .And. Len(aCols) == 0 .And. lPreRequ
	If Inclui //IF utilizado para nao exibir mensagem quando baixada a pre-requisicao
		Help(" ",1,"A185PRE")
	EndIf	
	lRet := .F.
EndIf	
           
If lRet .And. Len(aCols) == 0
	lRet := .F.
EndIf

If lRet
	dbSelectArea("SCP")
	dbGoTo(nRegist)
	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_LOCAL))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ca100RetCQ() ----------->                   ³
		//³ [1] -  Saldo do Item                        ³
		//³ [2] -  Quantidade diponivel ja reservada    ³
		//³ [3] -  Quantidade em Processo de Compra     ³
		//³ [4] -  Situacao Atual                       ³
		//³ [5] -  Numero da Solicitacao de Compras     ³
		//³ [6] -  Numero de Requisicao                 ³
		//³ [7] -  Quantidade ja Entregue               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRetCQ := ca100RetCQ(SCP->CP_NUM,SCP->CP_ITEM)
	EndIf	
	
	AADD(aObjects,{100,050,.T.,.F.,.F.})
	AADD(aObjects,{100,100,.T.,.T.,.F.})
	AADD(aObjects,{100,020,.T.,.F.,.F.})
	aPosObj:=MsObjSize(aInfo,aObjects)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula dimensões ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSize := FwDefSize():New( .F. )

	oSize:AddObject( "CIMA" , 100, 80, .T., .F., .T. ) // Nao dimensiona Y 
	oSize:AddObject( "BAIXO", 100, 60, .T., .T., .T. ) // Totalmente dimensionavel

	oSize:lProp := .T. // Proporcional 
	oSize:aMargins := { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 

	oSize:Process() // Dispara os calculos 

	Define MsDialog oDlg Title OemToAnsi(STR0067) Of oMainWnd Pixel From aSize[7],0 To aSize[6],aSize[5] //"Baixa da Pre-Requisicao"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona Panel ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oPanel1:= tPanel():New(000,000,,oDlg,,,,,,30,oSize:aPosObj[1,3])
	oPanel2:= tPanel():New(000,000,,oDlg,,,,,,70,oSize:aPosObj[2,3])

	oPanel1:Align := CONTROL_ALIGN_TOP
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	
	@ 2,aPosObj[1,2] To aPosObj[1,3]+11,aPosObj[1,4] Label OemToAnsi(STR0010) Of oPanel1 Pixel	//"Resumo do Estoque"
	
	@ 10, aPosObj[1,2]+  5 Say OemToAnsi(STR0011) Of oPanel1 Pixel 	//"Quantidade Atual"
	@ 25, aPosObj[1,2]+  5 Say OemToAnsi(STR0012) Of oPanel1 Pixel 	//"- Reservas PV/OP"
	@ 40, aPosObj[1,2]+  5 Say OemToAnsi(STR0013) Of oPanel1 Pixel 	//"= Qtd. Dispon¡vel"
	
	@ 10, aPosObj[1,2]+150 Say OemToAnsi(STR0017) Of oPanel1 Pixel 	//"Saldo da Pre-Requisicao "
	@ 25, aPosObj[1,2]+150 Say OemToAnsi(STR0018) Of oPanel1 Pixel 	//"Quantidade disp. para entrega"
	@ 40, aPosObj[1,2]+150 Say OemToAnsi(STR0019) Of oPanel1 Pixel 	//"Quantidade em processo de compra"
	
	@ 10, aPosObj[1,2]+ 75 MsGet oQAtu     Var Transform(nQAtu    ,cPict) Size 50,8 Of oPanel1 Pixel When .F.
	@ 25, aPosObj[1,2]+ 75 MsGet oQtRes    Var Transform(nQtRes   ,cPict) Size 50,8 Of oPanel1 Pixel When .F.
	@ 40, aPosObj[1,2]+ 75 MsGet oQtSal    Var Transform(nQtSal   ,cPict) Size 50,8 Of oPanel1 Pixel When .F.
	@ 10, aPosObj[1,2]+245 MsGet oRetCQ[1] Var Transform(aRetCQ[1],cPict) Size 50,8 Of oPanel1 Pixel When .F.
	@ 25, aPosObj[1,2]+245 MsGet oRetCQ[2] Var Transform(aRetCQ[2],cPict) Size 50,8 Of oPanel1 Pixel When .F.
	@ 40, aPosObj[1,2]+245 MsGet oQtTotal  Var Transform(nQtTotal ,cPict) Size 50,8 Of oPanel1 Pixel When .F.
	
	@ 55,aPosObj[1,2]+3 CheckBox oChk Var lQual PROMPT OemToAnsi(STR0046) Size 95,09 Of oPanel1 Pixel On CLICK ( AEval(aCols , {|z| z[1] := If(z[1]==.T.,.F.,If(z[9]>0,.T.,.F.))}), oLbx:Refresh(.F.) ) //"Selecionar Todos os Itens"
	
	@ aPosObj[2,1]+12,aPosObj[2,2] ListBox oLbx Var cVarQ Fields HEADER "",STR0014,STR0043,STR0015,STR0016,STR0044,STR0045,STR0020,STR0047 ;
		Size aPosObj[2,4]-3,aPosObj[2,3]-70 Of oDlg Pixel ;
		On DBLCLICK (aCols:=A185Troca(oLbx:nAt,aCols),oLbx:Refresh()) ;
		On Change (A185MudaVlr(oDlg,cNumSA,aCols[oLbx:nAt,3],aCols[oLbx:nAt,4],aCols[oLbx:nAt,6],aCols[oLbx:nAt,9],@aRetCQ,@nQAtu,@nQtRes,@nQtSal,aPosObj,.T.,oQAtu,oQtRes,oQtSal,oRetCQ,oQtTotal,@nQtTotal),oDlg:Refresh())
	
	oLbx:SetArray(aCols)
	oLbx:bLine := { || {If(aCols[oLbx:nAt,1],oOk,oNo),aCols[oLbx:nAt,2],aCols[oLbx:nAt,3],aCols[oLbx:nAt,4],aCols[oLbx:nAt,5],aCols[oLbx:nAt,6],aCols[oLbx:nAt,7],aCols[oLbx:nAt,8],aCols[oLbx:nAt,10]}}
	
	
	If IntePMS()
		@ aPosObj[3,3]-17, aPosObj[3,4]-160 BUTTON STR0065 SIZE 30 ,14   FONT oDlg:oFont ; //"Projetos"
			MESSAGE STR0066 ;//"Gerenciamento de projetos"   
			ACTION {|| If(aCols[oLbx:nAt,1],PmsDlgSAB(cNumSA,aCols[oLbx:nAt,3],aCols[oLbx:nAt,9]),Nil)}  OF oDlg PIXEL  
	
		SetKey(VK_F10,{|| If(aCols[oLbx:nAt,1],PmsDlgSAB(cNumSA,aCols[oLbx:nAt,3],(aCols[oLbx:nAt,9])),Nil)})
	Endif	
	Define SButton From aPosObj[3,3]-17, aPosObj[3,4]-120 Type 11 Enable Of oDlg Action A185EdtQtd(oLbx,aCols)
	Define SButton From aPosObj[3,3]-17, aPosObj[3,4]- 85 Type  1 Enable Of oDlg Action (lGerar:=.T.,oDlg:End())
	Define SButton From aPosObj[3,3]-17, aPosObj[3,4]- 50 Type  2 Enable Of oDlg Action (oDlg:End())
	
	Activate MsDialog oDlg Center

	If IntePms()		// Se usa PMS integrado com o ERP
		SetKey(VK_F10,Nil)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ P.E. utilizado para validar a baixa da Pre-Requisicao        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lM185MOD2 .And. lGerar
		lGerar := ExecBlock("M185MOD2",.F.,.F.,aCols)
	Endif
	
	If lGerar
		Processa( {|lEnd| A185GeraAut(cNumSA,aCols),@lEnd},STR0052,STR0053,.F.)
	EndIf

EndIf	

//-- Libera os registros bloqueado pelo SoftLock
MsUnlockAll()

RestArea(aAreaAnt)
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Troca ³ Autor ³ Larson Zordan         ³ Data ³22.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Troca a marca de selecao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185Troca(ExpN1,ExpA1)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Posicao da marca no array                          ³±±
±±³          ³ ExpA1 = Array com os dados                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = Array com os dados                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A185Troca(nIt,aArray)

//Marcar item selecionado
If !aArray[nIt,1]
	If U_A185QtRequ(aArray[nIt,9],aRetCQ[2],aRetCQ[1],nQAtu)
		aArray[nIt,1] := !aArray[nIt,1]
	EndIf       
Else
	//Desmarcar item selecionado
	aArray[nIt,1] := !aArray[nIt,1]
EndIf	
Return( aArray )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185MudaVl³ Autor ³ Larson Zordan         ³ Data ³22.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza os valores do Resumo do Estoque                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185MudaVlr(ExpO1,ExpC1,ExpC2,ExpC3,ExpC4,ExpN1,ExpA1,     ³±±
±±³          ³             ExpN2,ExpN3,ExpN4,ExpA2,ExpL1)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto da MsDialog                                 ³±±
±±³          ³ ExpC1 = Numero da SA                                       ³±±
±±³          ³ ExpC2 = Item da SA                                         ³±±
±±³          ³ ExpC3 = Produto                                            ³±±
±±³          ³ ExpC4 = Armazem                                            ³±±
±±³          ³ ExpN1 = Qtd. a Requisitar                                  ³±±
±±³          ³ ExpA1 = Array com valores das Pre-Requisicao               ³±±
±±³          ³ ExpN2 = Saldo Atual                                        ³±±
±±³          ³ ExpN3 = Reserva PV/OP                                      ³±±
±±³          ³ ExpN4 = Qtd. Disponivel                                    ³±±
±±³          ³ ExpA2 = Array das posicoes na Tela                         ³±±
±±³          ³ ExpL1 = Flag indicando se deve atualizar tela              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A185MudaVlr(oDlg,cNumSA,cItSA,cProduto,cLocal,nQtReq,aRetCQ,nQAtu,nQtRes,nQtSal,aPosObj,lTela,oQAtu,oQtRes,oQtSal,oRetCQ,oQtTotal,nQtTotal)

DEFAULT nQtReq   := 0
DEFAULT nQAtu    := 0
DEFAULT nQtRes   := 0
DEFAULT nQtSal   := 0
DEFAULT nQtTotal := 0
DEFAULT lTela    := .T.

dbSelectArea("SCP")
dbSeek(xFilial()+cNumSA+cItSA)
If SB2->(dbSeek(xFilial("SB2")+cProduto+cLocal))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ca100RetCQ() ----------->                   ³
	//³ [1] -  Saldo do Item                        ³
	//³ [2] -  Quantidade diponivel ja reservada    ³
	//³ [3] -  Quantidade em Processo de Compra     ³
	//³ [4] -  Situacao Atual                       ³
	//³ [5] -  Numero da Solicitacao de Compras     ³
	//³ [6] -  Numero de Requisicao                 ³
	//³ [7] -  Quantidade ja Entregue               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetCQ := ca100RetCQ(cNumSA,cItSA)
	nQAtu := SB2->B2_QATU
	nQtRes:= SB2->B2_RESERVA+SB2->B2_QEMP+SB2->B2_QEMPSA+SB2->B2_QACLASS-If(mv_par03==1.And.!Empty(SCP->CP_OP),SCP->CP_QUANT,0)
	nQtSal:= nQAtu - nQtRes
EndIf

nQtTotal := If( (mv_par02==2), U_A185QtProc(cProduto), aRetCQ[3] )

If lTela                
	oQatu:Refresh()
	oQtRes:Refresh()
	oQtSal:Refresh()
	oRetCq[1]:Refresh() 	
	oRetCq[2]:Refresh() 	
	oQtTotal:Refresh()
EndIf
	
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185EdtQtd³ Autor ³ Larson Zordan         ³ Data ³22.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Editar o campo Quantidade a Requisitar                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185EdtQtd(ExpO1,ExpA1)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto do ListBox                                  ³±±
±±³          ³ ExpA1 = Array com os dados                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = Array com os dados                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A185EdtQtd( oLbx,aCols )
Local nVlr1   := aCols[oLbx:nAt,8]
Local nVlr2   := aCols[oLbx:nAt,9]
Local cProd   := aCols[oLbx:nAt,4]
Local cLocal  := aCols[oLbx:nAt,6]
Local nQtdTot := 0
Local nX 	  := 0

aCols[oLbx:nAt,8] := aCols[oLbx:nAt,9]
lEditCell( aCols, oLbx , PesqPictQt('D3_QUANT'), 8 )
oLbx:SetFocus()
aCols[oLbx:nAt,9] := aCols[oLbx:nAt,8]
aCols[oLbx:nAt,8] := Transform(aCols[oLbx:nAt,8],PesqPictQt('D3_QUANT'))
For nX := 1 to Len(aCols)
	If aCols[nX,1] .And. cProd == aCols[nX,4] .And. cLocal == aCols[nX,6]
		nQtdTot := nQtdTot + Val(aCols[nX,8])
	EndIf	
Next nX
If ! U_A185QtRequ(aCols[oLbx:nAt,9],aRetCQ[2],aRetCQ[1],nQAtu,(nQtdTot-Val(aCols[oLbx:nAt,8])),,,,@aCols)
	aCols[oLbx:nAt,8] := nVlr1
	aCols[oLbx:nAt,9] := nVlr2
Else
	//Marca o item para baixa da pre-requisicao	
	aCols[oLbx:nAt,01] := .T.
	aCols[oLbx:nAt,12] :=  IIf(A185SegUm(SCP->CP_PRODUTO)==1,ConvUM(SCP->CP_PRODUTO,aCols[oLbx:nAt,9],0,2),IIf(SCP->CP_QUANT == 0,0,(SCP->CP_QTSEGUM/SCP->CP_QUANT)*aCols[oLbx:nAt,9]))
EndIf
Return( aCols )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185GeraAu³ Autor ³ Larson Zordan         ³ Data ³23.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera as requisicoes usando o Movimentos Modelo 2           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185GeraAut(ExpC1,ExpA1)			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Numero da SA                                       ³±±
±±³          ³ ExpA1 = Array com os dados                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A185GeraAut(cNumSa,aDados,lEnd)
Local aCopia    := {}
Local lMov      := .F.
Local lValZero  := .F.
Local nX		:= 1
Local cProjeto	:= ""	
Local cTarefa	:= ""
Local cDocumento:= ""
Local lChangeDoc:= .F.
Local lGeraBx   := .F.
Local aRetPE    := {}
Local lMT185Gera:= ExistBlock("MT185GERA")
Local lMT185Dad := ExistBlock("MT185DAD")
Local lCC
Local nZ
Local aDadosPrj	

//ÚÄÄIntegracao PMSÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Modifica o aDados para ficar aberto por projeto e gerar um registro no SD3³
//³por cada Solicitacao+item+tarefa                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If IntePMS().And. Type("aRatAFH")=="A" .And. Len(aRatAFH) > 0 
	While nX <= Len(aDados).And.Len(aDados[nX]) >= 21		// Incluidos campos ref. Walk-Thru
		If aDados[nX,1]             
			aDadosPrj	:=	PMSAFHDados(aRatAFH,aDados[nX,3],aDados[nX,9])
			aSize(aDados,Len(aDados)+(Len(aDadosPrj)-1))
			For nZ := 1 To Len(aDadosPrj)
				If aDadosPrj[nZ,3] > 0
					If nZ > 1
						aIns(aDados,nX+(nZ-1))
						aDados[nX+(nZ-1)]			:=	aClone(aDados[nX])
					EndIf
					aDados[nX+(nZ-1)]	[17]	:=	aDadosPrj[nZ][1]
					aDados[nX+(nZ-1)]	[19]	:=	aDadosPrj[nZ][2]
					aDados[nX+(nZ-1)]	[09]	:=	aDadosPrj[nZ][3]
				EndIf
			Next
			nX+= (nZ-1)
		Else
			nX++
		EndIf	 
	EndDo
EndIf		

Private bCols     := {|x,y|aCols[x][y]}
Private cXFUNC     := "U_A185Atu2SD3"
Private a185Dados := aClone(aDados)
Private aCC       := {}
Private aAlter    := {}
Private lMT241GRV := ExistBlock("MT241GRV")
Private lLogMov   := GetMV("MV_IMPMOV")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta variavel indica se utiliza segunda unidade de medida.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lUsaSegUm

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel utilizada na rotina de atualizacao da SCQ/SCP/SB2   ³
//³ disparada pelo MATA241 (controle de transacoes)              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aDadosCQ  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada MT185DAD               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lMT185Dad
	aRetPE:= ExecBlock("MT185DAD",.F.,.F.,aDados)
	If  ValType(aRetPE) == "A"
		aDados := aClone(aRetPE)
		a185Dados:= aClone(aRetPE)
	EndIf
EndIf

ProcRegua(Len(aDados),23,4)
For nX := 1 To Len(aDados)
	IncProc()
	If aDados[nX,1]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada MT185GERA              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMT185Gera
			ExecBlock("MT185GERA",.F.,.F.,aDados[nX])
		EndIf
		// Atualiza array aRetCQ
		A185MudaVlr(NIL,cNumSA,aDados[NX,3],aDados[nx,4],aDados[nx,6],aDados[nx,9],@aRetCQ,@nQAtu,,,,.F.)
		If Len(aDados[nX]) >= 21		// Incluidos campos ref. Walk-Thru
			cProjeto	:=	aDados[nX,17]
			cTarefa 	:=	aDados[nX,19]
		Else
			cProjeto	:=	""	
			cTarefa		:=	""
		Endif
		If !U_A185QtRequ(aDados[nX,9],aRetCQ[2],aRetCQ[1],nQAtu,,.F.,cProjeto,cTarefa)
			Exit
		EndIf
		nPos := aScan(aCC,{|x| x == aDados[nX,10]})
		If nPos == 0
			aAdd(aCC,aDados[nX,10])
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Existem itens selecionados              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMov := .T.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ha itens zerados.           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lValZero := If(aDados[nX,9]<=0,.T.,lValZero)
	EndIf	
Next nX

If !lMov
	Return(.F.)
EndIf

If lValZero
	Help(" ",1,"VALZERADO")
	Return(.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ha mais de um centro de custo. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lCC := If(Len(aCC)>1,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Notifica o usuario sobre o uso de mais de  ³
//| um Centro de Custo na Pre-Requisicao.      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCC
	If !MsgYesNo(	OemToAnsi(STR0048)+CHR(13)+; 			//"Esta Pre-Requisicao tem diversos Centros de Custos cadastrados."
					OemToAnsi(STR0049)+CHR(13)+; 			//"Portanto,  ao continuar a rotina,  voce devera digitar o Centro"
					OemToAnsi(STR0050)+CHR(13)+CHR(13)+;	//"de Custo adequado para os itens requisitados."
					OemToAnsi(STR0051))						//"Deseja continuar o processo de requisicao ?"
		Return(.F.)
	EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
	Private nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	Private lCriaHeader := .T.	// Para criar o header do arquivo Contra Prova
	Private cLoteEst 			// Numero do lote para lancamentos do estoque
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Estoque.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0 		// Total dos lancamentos contabeis
	PRIVATE cArquivo			// Nome do arquivo contra prova
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis indicam para as funcoes de validacao qual    ³
//³ programa as esta' chamando.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private l241Auto := .F., l250Auto := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis indicam para as funcoes de validacao qual    ³
//³ programa as esta' chamando.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private l240:=.F.,l250:=.F.,l241:=.T.,l242:=.F.,l261:=.F.,l185 :=.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Pergunta MTA240						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A185AtuPer(1)

aCopia  := aClone(aRotina)
aRotina := {}
For nX := 1 To 5	// Walk_Thru
	aAdd(aRotina,{ "" , "        ", 0 , 6} )
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A funcao A241Inclui abrira a transacao e gravara as informacoes da tabela SD3.    ³
//³ Se estiver tudo certo, ela executara a funcao A185AtuSCQ que atualizara as demais ³
//³ tabelas realizando corretamente o controle de transacao. Toda a operacao estara   ³
//³ em uma unica transacao aberta e finalizada pelo MATA241.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Variavel private a ser usada pela A185AtuSCQ
aDadosCQ := aClone(aDados)
dbSelectArea("SD3")
dbSetOrder(1)
lGeraBx := ( A241Inclui("SD3",0,1,@cDocumento,@lChangeDoc) == 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Pergunta MTA185						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A185AtuPer(2)

aRotina := aClone(aCopia)

If lChangeDoc
	Help("",1,"A240DOC",,cDocumento,4,30)  // No.Docto. foi alterado
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada no final do processo de baixa total ³
//³ das pre-requisicoes, apos o controle de transacao.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("M185FGR")
   ExecBlock("M185FGR",.F.,.F.,{lGeraBx,aDados})
EndIf

Return(.T.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185Atu2SD³ Autor ³ Larson Zordan         ³ Data ³23.07.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza as variaveis de memoria para Inclusao no SD3.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185Atu2SD3(aColsX)
Local aFldSD3	:= {}
Local cSavAlias	:= Alias()
Local nX		:= 0
Local i			:= 0
Local z			:= 0
Local nPosRec	:= GDFieldPos("D3_REC_WT")
Local nPosAlias	:= GDFieldPos("D3_ALI_WT")
Local lM185Camp := ExistBlock("M185CAMP")
Local lWmsNew := SuperGetMv("MV_WMSNEW",.F.,.F.)
Local cProdWms := ""

aCols := {}

For nX := 1 To Len(a185Dados)
	If a185Dados[nX,1]
		AADD(aCols,Array(Len(aHeader)+1))
		z ++
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+a185Dados[nX,4])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se trabalha com segunda unidade de medida. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lUsaSegUm := .T.
/*		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("B1_SEGUM")
		If !X3USO(X3_USADO)
			dbSeek("B2_QTSEGUM")
			If !X3USO(X3_USADO)
				lUsaSegUm := .F.
			EndIf
		EndIf
*/		
		For i:=1 to Len(aHeader)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria Linha do aCols.                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCampo:=Alltrim(aHeader[i,2])
			If nPosAlias <> i .And. nPosRec <> i
				If aHeader[i,8] == "C"
					aCols[z][i] := SPACE(aHeader[i,4])
				ElseIf aHeader[i,8] == "N"
					aCols[z][i] := 0
				ElseIf aHeader[i,8] == "D" .And. cCampo != "D3_DTVALID"
					aCols[z][i] := dDataBase
				ElseIf aHeader[i,8] == "D" .And. cCampo == "D3_DTVALID"
					aCols[z][i] := CriaVar("D3_DTVALID")
				ElseIf aHeader[i,8] == "M"
					aCols[z][i] := ""
				Else
					aCols[z][i] := Nil
				EndIf
				If aHeader[i,10] == "V"
					aCols[z][i] := CriaVar(cCampo)
				EndIf
			EndIf		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Insere dados na Linha do aCols.                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cCampo $ "D3_COD"
				aCols[z,i] := a185Dados[nX,4]
				If lWmsNew .And. IntWMS(a185Dados[nX,4])
					cProdWms := a185Dados[nX,4]
				EndIf
			ElseIf cCampo $ "D3_UM"
				aCols[z,i] := a185Dados[nX,7]
			ElseIf cCampo $ "D3_QUANT"
				aCols[z,i] := a185Dados[nX,9]
			ElseIf cCampo $ "D3_SEGUM"
				aCols[z,i] := a185Dados[nX,11]
			ElseIf cCampo $ "D3_QTSEGUM"
				aCols[z,i] := a185Dados[nX,12]
			ElseIf cCampo $ "D3_LOCAL"
				aCols[z,i] := a185Dados[nX,6]
			ElseIf cCampo $ "D3_OP"
				aCols[z,i] := a185Dados[nX,13]
			ElseIf cCampo == "D3_CONTA"
				aCols[z,i] := a185Dados[nX,14]
			ElseIf cCampo $ "D3_DESCRI"
				aCols[z,i] := a185Dados[nX,5]
			ElseIf cCampo $ "D3_ITEMCTA"
				aCols[z,i] := a185Dados[nX,15]
			ElseIf cCampo $ "D3_CLVL"
				aCols[z,i] := a185Dados[nX,16]
			ElseIf cCampo $ "D3_PROJPMS"
				aCols[z,i] := a185Dados[nX,17]
			ElseIf cCampo $ "D3_TASKPMS" .And. Len(a185Dados[nX]) >= 21	// Incluidos campos ref. Walk-Thru
				aCols[z,i] := a185Dados[nX,19]
			ElseIf cCampo $ "D3_OSTEC"
				aCols[z,i] := a185Dados[nX,18]
			ElseIf cCampo $ "D3_GRUPO"
				aCols[z,i] := SB1->B1_GRUPO
			ElseIf cCampo $ "D3_TIPO"
				aCols[z,i] := SB1->B1_TIPO
			ElseIf cCampo $ "D3_NUMSA"
				aCols[z,i] := a185Dados[nX,2]
			ElseIf cCampo $ "D3_NRBPIMS"
				aCols[z,i] := a185Dados[nX,22]
			ElseIf cCampo $ "D3_ITEMSA"
				aCols[z,i] := a185Dados[nX,3]
			ElseIf cCampo $ "D3_ORDEM"
				If AllTrim(GetNewPar("MV_NGMNTNO","N")) == "1" .And. SubStr(a185Dados[nX,13],7,5) == "OS001"
					aCols[z,i] := SubStr(a185Dados[nX,13],1,6)
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializador padrao dos campos de Usuario do SX3 	   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cCampo == "D3_ALI_WT"
				aCols[z,i] := a185Dados[nX,20]
			ElseIf cCampo == "D3_REC_WT"
				aCols[z,i] := a185Dados[nX,21]
			ElseIf cCampo == "D3_CC"
				aCols[z,i] := a185Dados[nX,10]
			ElseIf cCampo == "D3_SERVIC" .And. lWmsNew .And. Iif(!Empty(cProdWms),IntWMS(cProdWms),.F.)
				aCols[z,i] := Posicione("SB5",1,xFilial("SB5")+cProdWms,"B5_SERVREQ")
/*			Else
				dbSelectArea("SX3")
				dbSetOrder(2)
				dbSeek(cCampo)
				If SX3->X3_PROPRI == 'U' .And. !Empty(X3_RELACAO)
					aCols[z,i] := InitPad(X3_RELACAO)
				EndIf
*/			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ M185CAMP - P.E. utilizado para carregar campos de usuario ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lM185Camp
				ExecBlock("M185CAMP",.F.,.F.,{cCampo,z,nX,i})
			EndIf
		Next i
		FillCTBEnt("SCP",z,a185Dados[nX,21])
		aCols[z][Len(aHeader)+1] := .F.
	EndIf	
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Insere o Centro de Custo se for o mesmo para todos. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCC := If(Len(aCC)>1,cCC,aCC[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Campos que podem ser alterados na GetDados.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aAlter,"D3_CONTA"  )
aAdd(aAlter,"D3_OP"     )
aAdd(aAlter,"D3_GRUPO"  )
aAdd(aAlter,"D3_CUSTO1" )
aAdd(aAlter,"D3_CUSTO2" )
aAdd(aAlter,"D3_CUSTO3" )
aAdd(aAlter,"D3_CUSTO4" )
aAdd(aAlter,"D3_CUSTO5" )
aAdd(aAlter,"D3_TRT"    )
aAdd(aAlter,"D3_LOTECTL")
aAdd(aAlter,"D3_NUMLOTE")
aAdd(aAlter,"D3_DTVALID")
aAdd(aAlter,"D3_LOCALIZ")
aAdd(aAlter,"D3_NUMSERI")
aAdd(aAlter,"D3_PROJPMS")
aAdd(aAlter,"D3_TASKPMS")
aAdd(aAlter,"D3_ITEMCTA")
aAdd(aAlter,"D3_CLVL")
aAdd(aAlter,"D3_CC")
aAdd(aAlter,"D3_SERVIC")

If GetMv("MV_NGMNTES") = "S"
   aAdd(aAlter,"D3_ORDEM")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se Existem Campos de Usuario no SX3                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
SX3->(dbSetOrder(1))
If SX3->(dbSeek('SD3', .F.))
	Do While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == 'SD3'
		If SX3->X3_PROPRI == 'U'
			aAdd(aAlter,SX3->X3_CAMPO)
		EndIf
		SX3->(dbSkip())
	EndDo
EndIf
*/
aFldSD3 := FwSx3Util():GetListFieldsStruct("SD3",.F.)
For nX := 1 To Len(aFldSD3)
	IF aScan(aAlter,ALLTRIM(aFldSD3[nX,1])) == 0 .And. !(ALLTRIM(aFldSD3[nX,1]) $ "D3_FILIAL|") 
		aAdd(aAlter,ALLTRIM(aFldSD3[nX,1]))
	Endif
Next nX

dbSelectArea(cSavAlias)
aColsX := aClone(aCols)  // Walk-Thru

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185QtProc³ Autor ³ Larson Zordan         ³ Data ³11/12/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para Verificar as SC's amarradas ao produto         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := A185QtProc(ExpC1)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Produto                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = qtde.total                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185QtProc(cProduto)
Local aAreaAnt := GetArea()
Local nQtTotal := 0
Local aStruSC1
Local cAliasSC1
Local cQuery
Local nX

	
dbSelectArea("SC1")
dbSetOrder(2)


aStruSC1  := SC1->(dbStruct())
cAliasSC1 := "A185SC1"
cQuery    := "SELECT "
cQuery    += "SC1.C1_PRODUTO, Sum(SC1.C1_QUANT) C1_QUANT, Sum(SC1.C1_QUJE) C1_QUJE FROM "
cQuery    += RetSqlName("SC1")+" SC1 "
cQuery    += "WHERE "
cQuery    += "SC1.C1_FILIAL = '"+xFilial("SC1")+"' And "
cQuery    += "SC1.C1_PRODUTO = '"+cProduto+"' And "
cQuery    += "(SC1.C1_QUJE >= 0 Or SC1.C1_QUJE < SC1.C1_QUANT) And "
cQuery    += "SC1.D_E_L_E_T_ = ' ' "
cQuery    += "GROUP BY SC1.C1_PRODUTO "
cQuery    := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC1,.T.,.T.)
For nX := 1 To Len(aStruSC1)
	If ( aStruSC1[nX][2] <> "C" )
		TcSetField(cAliasSC1,aStruSC1[nX][1],aStruSC1[nX][2],aStruSC1[nX][3],aStruSC1[nX][4])
	EndIf
Next nX

nQtTotal := (cAliasSC1)->C1_QUANT - (cAliasSC1)->C1_QUJE

dbSelectArea(cAliasSC1)
dbCloseArea()

RestArea(aAreaAnt)
Return(nQtTotal)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185AtuPer³ Autor ³ Marcos V. Ferreira    ³ Data ³10/03/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza o pergunte para chamada das funcoes A240INCLUI e   ³±±
±±³			 ³A241INCLUI												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Tipo de configuracao de tecla F12	              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A185AtuPer(nTipo)
Default nTipo := 0

If nTipo == 1
	Pergunte("MTA240",.F.)
	If cCusMed <> "O"
		If !l185Auto
			SetKey(VK_F12, {|| MTA185PERG()})
		EndIf
	EndIf
 ElseIf nTipo == 2
	Pergunte("MTA185",.F.)
	If cCusMed <> "O"
		If !l185Auto
			SetKey(VK_F12, {|| MTA185PERG()})
		EndIf
	EndIf
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185QtdNeg³ Autor ³ Marcos V. Ferreira    ³ Data ³06/04/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a quantidade estornada, quando eh realizado um       ³±±
±±³			 ³estorno de quantidade negativa							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185QtdNeg(ExpN1,ExpC1,ExpC2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = qtde.                                              ³±±
±±³          ³ ExpC1 = Numero da SC                                       ³±±
±±³          ³ ExpC2 = Item da SC                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = qtde.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A185QtdNeg(nQtde,cNumSC,cItemSc)
Local lEstNeg
Local aAreaAnt

DEFAULT cNumSC := ""

If !Empty(cNumSC)
	lEstNeg := If(GetMV('MV_ESTNEG')=='N',.F.,.T.)
	aAreaAnt:= GetArea()
	
	dbSelectArea("SC1")
	SC1->(dbSetOrder(1))
	If lEstNeg .And. SC1->(dbSeek(xFilial("SC1")+cNumSc+cItemSc))
		If Empty(SC1->C1_PEDIDO) .And. Empty(SC1->C1_COTACAO)
			nQtde := 0
		Endif
	Endif
	RestArea(aAreaAnt)
EndIf
Return nQtde

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A185ValEmp³ Prog. ³ Marcos V. Ferreira    ³Data  ³18.04.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida o saldo empenhado da SA para baixa do pre-requisicao.|±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185ValEmp(ExpC1,ExpC2,ExpN1,ExpC3,ExpC4)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = cod.produto                                        ³±±
±±³          ³ ExpC2 = cod.local	                                      ³±±
±±³          ³ ExpN1 = qtde.                                              ³±±
±±³          ³ ExpC3 = Numero da SA                                       ³±±
±±³          ³ ExpC4 = Item da SA                                         ³±±
±±³          ³ ExpA1 = Acols das pre-requisicoes - baixa por pre-requisic.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.             	                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA185				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A185ValEmp(cProd,cLocal,nQuant,cNum,cItem,aCols)
Local lRet      := .F.
Local lEstNeg   := SuperGetMv("MV_ESTNEG",.T.,"S")=="S"
Local aAreaSCP  := SCP->(GetArea())
Local aAreaSCQ  := SCQ->(GetArea())
Local aAreaSB2  := SB2->(GetArea())
Local nRecSCQ   := 0
Local nTotDisp  := 0
Local nQatu     := 0 
Local nQtRes    := 0
Local nQtSal    := 0
Local nIndex    := 0
Local nQtDisp   := 0
Local cArquivo  := CriaTrab(,.F.)
Local cChave	:="CQ_FILIAL+CQ_PRODUTO+CQ_LOCAL"
Local cFor 	    :="CQ_FILIAL == '"+xFilial("SCQ")+"' .And. CQ_PRODUTO=='"+cProd+"' .And. CQ_LOCAL=='"+cLocal+"'"
Local aRequis   := {}
Local aNumScDhn := {}

Default aCols   := {}

If lEstNeg
	lRet := .T.
Else
	IndRegua("SCQ",cArquivo,cChave,,cFor)
	DbSelectArea("SCQ")
	nIndex := RetIndex("SCQ")
	DbSetOrder(nIndex+1)

    While !Eof()
	   If CQ_NUM == cNum .And. CQ_ITEM == cItem
		  If lPermBx .And. Empty(SCQ->CQ_NUMREQ)
			  nQtDisp := CQ_QTDISP
			  nRecSCQ := SCQ->(Recno())
		  EndIf
	   	  dbSkip()
	   	  Loop
	   EndIf
   	   If Empty(SCQ->CQ_NUMREQ)
	       nTotDisp += SCQ->CQ_QTDISP
	       aNumScDhn := COMPosDHN({2,{SCQ->CQ_FILIAL,SCQ->CQ_NUM,SCQ->CQ_ITEM,"1",'MATA106'}})
	       If lPermBx .And. (!(aNumScDhn[1]) .Or. (aNumScDhn[2])->DHN_TIPO <> "1") .And. Empty(SCQ->CQ_NUMREQ) .And. SCQ->CQ_QTDISP > 0
		       aAdd(aRequis,{.F.,SCQ->CQ_NUM, SCQ->CQ_ITEM, SCQ->CQ_PRODUTO, SCQ->CQ_QUANT, SCQ->CQ_QTDISP, SCQ->(Recno())})
		   EndIf
		   If aNumScDhn[1]
		   		(aNumScDhn[2])->(DbCloseArea())
		   EndIf
	   EndIf
	   dbSelectArea("SCQ")
       dbSkip()
    EndDo
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial()+cProd+cLocal)
		If (B2_QEMPSA-nTotDisp)>=nQuant
		   lRet := .T.
		Else 
			nQAtu := SB2->B2_QATU
//			nQtRes:= SB2->B2_RESERVA+SB2->B2_QEMP+SB2->B2_QEMPSA+SB2->B2_QACLASS-If(mv_par03==1.And.!Empty(SCP->CP_OP),SCP->CP_QUANT,0)
            nQtRes:= SB2->B2_RESERVA+SB2->B2_QEMPSA+SB2->B2_QACLASS
			nQtSal:= nQAtu - nQtRes
			If nQtSal >= nQuant
				lRet := .T.
			ElseIf (nQtSal+B2_QEMPSA-nTotDisp)>=nQuant
				lRet := .T.
			Else
				If !lPermBx
					Help(" ",1,"A185DISP")
				Else
					If Aviso("MV_BXPRERQ",STR0076,{STR0022, STR0023}) == 1 //"Deseja utilizar a quantidade que falta de outra pre-requisicao com saldo disponivel ?"
						lRet := U_A185BxPre(aRequis,nQuant-nQtDisp,nRecSCQ,aCols)
					EndIf	
				EndIf	
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura o SCQ                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
	dbSelectArea("SCQ")
	RetIndex("SCQ")
	dbClearFilter()
	Ferase(cArquivo+OrdBagExt())

EndIf
RestArea(aAreaSB2)
RestArea(aAreaSCP)
RestArea(aAreaSCQ)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A185BxEmp ³ Prog. ³ Marcos V. Ferreira    ³Data  ³15.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza o campo B2_QEMPSA na gravacao da pre-requisicao 	  |±±
±±³          ³modelo II.			                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A185BxEmp(ExpN1)				                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = numero da linha do aCols 	                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum					                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA185				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185BxEmp(nLinha)
Local aAreaAnt	:= GetArea()
Local aAreaSCP	:= SCP->(GetArea())
Local aAreaSCQ	:= SCQ->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())
Local nPosNumSA	:= 0
Local nPosItmSA	:= 0
Local nPosQuant	:= 0
Local nX 		:= 0
Local aRetSA	:= {}

Default nLinha	 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Baixa Empenho SA (Pre-Requisicao)			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Type('l185') == 'L' .And. l185) .And. (Type('l241') == 'L' .And. l241)
		
	For nx := 1 To Len(aHeader)
		Do Case
			Case Trim(aHeader[nx][2]) == "D3_NUMSA"
				nPosNumSA:=nX
			Case Trim(aHeader[nx][2]) == "D3_ITEMSA"
				nPosItmSA:=nX
			Case Trim(aHeader[nx][2]) == "D3_QUANT"
				nPosQuant:=nX
		EndCase
	Next nX
				
	dbSelectArea("SCP")
	If dbSeek(xFilial()+aCols[nLinha,nPosNumSa]+aCols[nLinha,nPosItmSa])
		aRetSA := ca100RetCQ(aCols[nLinha,nPosNumSa],aCols[nLinha,nPosItmSa])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ ca100RetCQ() ----------->                   ³
		//³ [1] -  Saldo do Item                        ³
		//³ [2] -  Quantidade diponivel ja reservada    ³
		//³ [3] -  Quantidade em Processo de Compra     ³
		//³ [4] -  Situacao Atual                       ³
		//³ [5] -  Numero da Solicitacao de Compras     ³
		//³ [6] -  Numero de Requisicao                 ³
		//³ [7] -  Quantidade ja Entregue               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SCQ")
		dbSetOrder(1)
		dbSeek(xFilial()+SCP->CP_NUM+SCP->CP_ITEM)
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial()+SCP->CP_PRODUTO+SCP->CP_LOCAL)
		If Reclock("SB2",.F.)
			SB2->B2_QEMPSA := B2_QEMPSA - If(aCols[nLinha,nPosQuant]<aRetSA[2], aCols[nLinha,nPosQuant], aRetSA[2])
		EndIf
	EndIf	
EndIf
RestArea(aAreaSCP)
RestArea(aAreaSCQ)
RestArea(aAreaSB2)
RestArea(aAreaAnt)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A185RotAut³ Prog. ³ Marcos V. Ferreira    ³Data  ³13.09.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Chama a rotina automatica do MATA240 para realizar a baixa  |±±
±±³          ³da pre-requisicao pela rotina automatica do MATA185         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.				                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA185				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A185RotAut()
Local cCampo  := ''
Local aCampos := {}
Local nX	  := 0
Local nPos	  := 0
Local aCopia
Local lAtuAFH := .F.

Private lMSHelpAuto := .F.

If Type("aAutoAFH") <> "U"
	lAtuAFH:= aAutoAFH <> NIL .And. ValType(aAutoAFH) = 'A'
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+SCP->CP_PRODUTO)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ATENCAO - estes campos sao os mesmos utilizados pela  |
	//| funcao A185AtuSD3() qualquer alteracao nesta funcao   | 
	//| tambem devera ser realizada no aArray aCampos         |	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos := {{"D3_COD"		,SCP->CP_PRODUTO	},{"D3_UM"	 	,SCP->CP_UM		},;
				{"D3_CONTA"		,SCP->CP_CONTA		},{"D3_CLVL"	,SCP->CP_CLVL	},;
				{"D3_ITEMCTA"	,SCP->CP_ITEMCTA	},{"D3_LOCAL"	,SCP->CP_LOCAL	},;
				{"D3_EMISSAO"	,DDATABASE			},{"D3_GRUPO"	,SB1->B1_GRUPO	},;
				{"D3_CC"		,SCP->CP_CC			},{"D3_SEGUM"	,SCP->CP_SEGUM	},;
				{"D3_QTSEGUM"	,SCP->CP_QTSEGUM	},{"D3_TIPO"	,SB1->B1_TIPO	},;
				{"D3_OP"		,SCP->CP_OP			},{"D3_OSTEC"	,SCP->CP_NUMOS	},;
				{"D3_QUANT"	,Iif(lAtuAFH,aDadosPrj[3],nQtRequ)			}}
				
	If lAtuAFH .And. !Empty(aDadosPrj[1]) 
		aAdd(aCampos,{"D3_PROJPMS"	,aDadosPrj[1] })
		aAdd(aCampos,{"D3_TASKPMS"	,aDadosPrj[2] })
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Prepara o array aAutoSD3 para baixa da pre-requisicao |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aCampos)
		nPos := aScan(aAutoSD3,{ |x| Upper(AllTrim(x[1])) == aCampos[nX,1]})
		If nPos > 0
			cCampo := Upper(AllTrim(aAutoSD3[nPos,1]))
			If Empty(cCampo) .Or. cCampo == "D3_COD" .Or. cCampo == "D3_GRUPO" .Or. cCampo == "D3_TIPO" .Or.;
				cCampo == "D3_QUANT" .Or. cCampo == "D3_PROJPMS" .Or. cCampo == "D3_TASKPMS"
				aAutoSD3[nPos,2] := aCampos[nX,2]
			EndIf
		Else
			aAdd(aAutoSD3,{aCampos[nX,1],aCampos[nX,2],Nil})
		EndIf                                              
	Next nX
			
	aCopia := aClone(aRotina)			

	aRotina	:= {	{nil,nil,nil,1,0,.F.},;
			  		{nil,nil,nil,2,0,.F.},;
			 		{nil,"A240Inclui"	, 0 , 3,0,nil}}	//"Incluir"
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza Inclusao do movimento via MsRotAuto           |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsRotAuto(3,aAutoSD3,"SD3")          

	aRotina := aClone(aCopia)			

EndIf	

RETURN IIf(Type("lMsErroAuto") == "L",!lMsErroAuto,.F.)

 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³05/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
Static Function MenuDef()     
Private aRotina	:= {}

aRotina := {	{STR0001,"PesqBrw"   	, 0 , 1,0,.F.},;	//"Pesquisar"
		  		{STR0002,"AxVisual"   	, 0 , 2,0,Nil},;	//"Visualizar"
				{STR0042,"U_A185Tipo"   	, 0 , 2,0,Nil},;	//"Tipo Baixa"
				{STR0003,"U_A185Baixar" 	, 0 , 3,0,NIL},;	//"Baixar"
				{STR0054,"U_A185Estorn"	, 0 , 5,0,Nil},;	//"Estorno"
				{STR0004,"U_A185Exclui" 	, 0 , 5,0,Nil},;	//"Excluir"
				{STR0037,"U_A185Encer"  	, 0 , 5,0,Nil},; 	//"Encerrar"
				{STR0033,"U_A185Legenda"	, 0 , 1,0,.F.},; 	//"Legenda"
        	 	{STR0068,"MsDocument"	, 0 , 4,0,Nil },;	//"Conhecimento"
        	 	{STR0079,"MATR107"		, 0 , 8,0,Nil }} 	//"Termo de Retirada"

If ExistBlock ("MTA185MNU")
	ExecBlock ("MTA185MNU",.F.,.F.)
EndIf

Return (aRotina)
/*
EXEMPLO DE UM RDMAKE QUE EXECUTA O MATA185 VIA ROTINA AUTOMATICA
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MyMata185 ³ Autor ³ Ricardo Berti         ³ Data ³01/08/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de teste da rotina automatica do programa MATA185	   ³±±
±±³          ³      PARA BAIXA DE PRE-REQUISICOES                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar testes na rotina de    ³±±
±±³          ³BAIXA de Pre-Requisicoes                                     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function MyMata185()

Local aCamposSCP
Local aCamposSD3
Local cNum := "000085"  // No.da Requisicao
Local cItem := "03"		// No.do Item da Req.
LOCAL aRetCQ    := {}

dbSelectArea("SCP")
dbSetOrder(1)
If SCP->(dbSeek(xFilial("SCP")+cNum+cItem))
	aCamposSCP := {	{"CP_NUM"		,SCP->CP_NUM	,Nil 	},;
					{"CP_ITEM"		,SCP->CP_ITEM   ,Nil 	},;
	               	{"CP_QUANT"		,SCP->CP_QUANT  ,Nil 	}} 

	aCamposSD3 := { {"D3_TM"		,"501"			,Nil },;  // Tipo do Mov. 
	                {"D3_COD"		,SCP->CP_PRODUTO,Nil },;
                    {"D3_LOCAL"		,SCP->CP_LOCAL	,Nil },;
                    {"D3_DOC"		,"SK0050" 		,Nil },;  // No.do Docto.
                    {"D3_EMISSAO"	,DDATABASE		,Nil } }

	lMSHelpAuto := .F.
	lMsErroAuto := .F.

	MSExecAuto({|v,x,y,z| mata185(v,x,y)},aCamposSCP,aCamposSD3,1)  // 1 = BAIXA (ROT.AUT)

Else
	Aviso("SIGAEST", "Req. nao encontrada", {" Ok "})	
EndIf  
Return Nil
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185BxPre ³ Autor ³ Nereu Humberto Junior ³ Data ³16.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de transferencia de qtds. entre as pre-requisicoes    ³±±
±±³          ³ Utilizada apenas quando o MV_BXPRERQ esta com .T.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A185BxPre(aRequis,nQtdNec,nRecSCQ)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com as pre-requisicoes com qtds. disponiveis ³±±
±±³          ³ ExpN1 = Quantidade necessaria para a baixa total           ³±±
±±³          ³ ExpN2 = Recno da Pre-Requisicao                            ³±±
±±³          ³ ExpA1 = Acols das pre-requisicoes - baixa por pre-requisic.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA185                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A185BxPre(aRequis,nQuant,nRecSCQ,aCols)

Local nOpc       := 0
Local nx         := 0
Local aPreReq    := aRequis
Local nPreReq    := 0
Local oOk        := LoadBitMap(GetResources(), "LBOK")
Local oNo        := LoadBitMap(GetResources(), "LBNO")
Local aTitCampos := {}
Local bLine      := { || .T. }
Local cLine      := ""
Local lRet       := .F.
Local aAreaSCQ   := SCQ->(GetArea())
Local nQtdAux    := nQuant
Local oPanel,oDlg,oListBox

Default aCols    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe os dados na Tela                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !Empty(aPreReq) )    
	
	aTitCampos := {" ",OemToAnsi(RetTitle("CQ_NUM")),OemToAnsi(RetTitle("CQ_ITEM")),OemToAnsi(RetTitle("CQ_PRODUTO")),OemToAnsi(RetTitle("CQ_QUANT")),OemToAnsi(RetTitle("CQ_QTDISP"))} 
	cLine := "{If(aPreReq[oListBox:nAt,1],oOk,oNo),aPreReq[oListBox:nAT][2],aPreReq[oListBox:nAT][3],aPreReq[oListBox:nAT][4],aPreReq[oListBox:nAT][5],aPreReq[oListBox:nAT][6]}"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta dinamicamente o bline do CodeBlock                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	bLine := &( "{ || " + cLine + " }" )
	
	DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi(STR0071) Of oMainWnd PIXEL //"Pre-Requisicoes Disponiveis"
	
	@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED 
	oPanel:Align := CONTROL_ALIGN_TOP  
	
	oListBox := TWBrowse():New( 27,4,243,86,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aPreReq)
	oListBox:bLDblClick := { || aPreReq[oListBox:nAt,1] := !aPreReq[oListBox:nAt,1] }
	oListBox:bLine := bLine
	
	oListBox:Align := CONTROL_ALIGN_ALLCLIENT 
	
	@ 6  ,4   SAY OemToAnsi(STR0072) Of oPanel PIXEL SIZE 150 ,9 //"Quantidade a baixar: "
	@ 4  ,65  MSGET nQuant PICTURE PesqPict('SB2','B2_QATU') When .F. Of oPanel PIXEL SIZE 40,9
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nPreReq := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nPreReq := oListBox:nAt,oDlg:End())},,)

	If ( nOpc == 1 ) .And. Aviso(STR0073, STR0074, {STR0022, STR0023}) == 1 //Atencao#"Confirma a transferencia de quantidades entre as pre-requisicoes ?"
		For nx	:= 1 to Len(aPreReq)
			If aPreReq[nx][1]
				If nQtdAux > 0
					If nQtdAux > aPreReq[nx][5]
						nQtdGrv := aPreReq[nx][5]
						nQtdAux -= nQtdGrv
					Else
						nQtdGrv := nQtdAux
						nQtdAux -= nQtdGrv
					Endif	
					dbSelectArea("SCQ")
					dbGoto(aPreReq[nx][7])
					//Subtrai a quantidade necessaria da requisicao escolhida
					Reclock("SCQ",.F.)
	                SCQ->CQ_QTDISP -= nQtdGrv
					MsUnlock()
					nPos := aScan(aCols,{ |x| x[2] == SCQ->CQ_NUM .And. x[3] == SCQ->CQ_ITEM .And. x[4] == SCQ->CQ_PRODUTO})
					If nPos > 0
						aCols[nPos,8] := Transform(SCQ->CQ_QTDISP,PesqPictQt('D3_QUANT'))
						aCols[nPos,9] :=SCQ->CQ_QTDISP
                    Endif
					//Soma a quantidade na requisicao posicionada
					dbGoto(nRecSCQ)
					Reclock("SCQ",.F.)
	                SCQ->CQ_QTDISP += nQtdGrv
					MsUnlock()					
					lRet := .T.
				Endif	
			EndIf
		Next
	Endif	
Else
	Aviso(STR0073,STR0075,{"OK"}) //Atencao#"Não existe pre-requisicoes disponiveis !"
	lRet := .F.
Endif

RestArea(aAreaSCQ)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A185SegUM ³ Autor ³ Microsiga S/A         ³ Data ³03.10.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao utilizada para verificar se o produto utiliza       ³±±
±±³          ³ segunda unidade de medida com fator de conversao.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A185SegUM(cCod)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = 1 - Utiliza SegUM com fator de conversao           ³±±
±±³          ³         2 - Utiliza SegUM sem fator de conversao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA185                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A185SegUm(cCod)
Local nRet     := 1 //-- Caso não utilize SegUm Forcar ConvUM
Local aAreaAnt := GetArea()
Local aAreaSB1 := SB1->(GetArea())
dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cCod)
	If !Empty(SB1->B1_SEGUM) .And. !Empty(SB1->B1_CONV)
		lRet := 1
	ElseIf !Empty(SB1->B1_SEGUM) .And. Empty(SB1->B1_CONV)
		nRet := 2
	EndIf	
EndIf
RestArea(aAreaSB1)
RestArea(aAreaAnt)
Return nRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A185OK   ³Rev.   ³ Bruno Schmidt         ³ Data ³02.12.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Funcao de fazer validacaoes no momento de confirmar          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A185OK(ExpL1)                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL1: Verifica a Existencia do Ponto de Entrada             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.	                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina executa o Ponto de Entrada MT185OK para          ³±±
±±³          ³validacoes complementares quando se confirma a EnchoiceBar   ³±±
±±³          ³todas as informacoes vinculadas.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A185OK(lMT185OK)
Local lRet  := .T. 

IF lMT185OK
  lRet := ExecBlock("MT185OK",.F.,.F.)
	If ValType(lRet) <> "L"
		lRet:= .T.
	EndIf
EndIf  

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FillCTBEntºAutor  ³ Anieli Rodrigues	 º Data ³ 18/06/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inicaliza campos das entidades contabeis de acordo com a   º±±
±±º          ³ origem.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA185                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FillCTBEnt(cOrigem,nItem,nRecno)
Local aCTBEnt := CTBEntArr()
Local nX	  := 0
Local aAreaSCP := SCP->(GetArea())

SCP->(DbGoTo(nRecno))

For nX := 1 To Len(aCTBEnt)
	If GDFieldPos("D3_EC"+aCTBEnt[nX]+"CR",aHeader) > 0
		aCols[nItem,GDFieldPos("D3_EC"+aCTBEnt[nX]+"CR")] := (cOrigem)->&("CP_EC"+aCTBEnt[nX]+"CR")
	EndIf
	If GDFieldPos("D3_EC"+aCTBEnt[nX]+"DB",aHeader) > 0
		aCols[nItem,GDFieldPos("D3_EC"+aCTBEnt[nX]+"DB")] := (cOrigem)->&("CP_EC"+aCTBEnt[nX]+"DB")
	EndIf
Next nX

RestArea(aAreaSCP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A185VldNG  ºAutor  ³ Caio C. F.			º Data ³ 24/02/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Avalia se a OS já foi encerrada no SIGAMNT para encerrar   º±±
±±º          ³ a pré-requisição.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA185/MATA240                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A185VldNG(cOP)

Local lRet  := .F.
Local aArea := GetArea()
Local aAreaSTJ := STJ->(GetArea())

If GetMv("MV_NGMNTES") == "S" //Verifica se usa integração com SIGAMNT
	dbSelectArea("STJ")
 	dbSetOrder(1) // FILIAL + ORDEM + PLANO + TIPOOS + CODBEM + SERVICO + SEQRELA
 	If STJ->(dbSeek(xFilial("STJ")+SubStr(cOP,1,6)))
 		If STJ->TJ_TERMINO == "S"
 			lRet := .T.
 		EndIf	
	EndIf
EndIf

RestArea(aAreaSTJ)
RestArea(aArea)
	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³M185RetPrj ³ Autor ³ Materiais            ³ Data ³18/09/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o codigo do projeto e tarefa amarrado a SA         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA185                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function M185RetPrj(cNumSA,cItem)

Local aArea		:= GetArea()
Local aAreaAFH	:= AFH->(GetArea())
Local aRet			:= {}

dbSelectArea("AFH")
dbsetorder(2)
If MsSeek(xFilial("AFH")+cNumSA+cItem)
	aAdd(aRet,AFH->AFH_PROJET)
	aAdd(aRet,AFH->AFH_TAREFA)
EndIf

RestArea(aAreaAFH)
RestArea(aArea)

Return aRet

//------------------------------------------------------------------------------
/*/	{Protheus.doc} AjstSX7Pms

Ajusta o dicionário SX7 - Gatilho dos campos D3_OP e D3_PROJPMS.
DSERFAT-46 Replica do Chamado TVQOFT da 11.8
@sample	AjstSX7Pms() 

@author	SQUAD CRM/Faturamento
@since	01/12/2017
@version 12.1.17
/*/ 
//------------------------------------------------------------------------------
Static Function AjstSX7Pms()
	Local aDadosSX7	:= {}
	
	aAdd(aDadosSX7, { {'D3_OP'		, '001' }, { { 'X7_REGRA', "IIF( FindFunction('PmsGatSD3'), PmsGatSD3('D3_PROJPMS'),SPACE(LEN(SD3->D3_PROJPMS)))", 	'SPACE(LEN(SD3->D3_PROJPMS))' } } } )
	aAdd(aDadosSX7, { {'D3_OP'		, '002' }, { { 'X7_REGRA', "IIF( FindFunction('PmsGatSD3'), PmsGatSD3('D3_TASKPMS'),SPACE(LEN(SD3->D3_TASKPMS)))", 	'SPACE(LEN(SD3->D3_TASKPMS))' } } } )
	aAdd(aDadosSX7, { {'D3_PROJPMS'	, '002' }, { { 'X7_REGRA', "IIF( FindFunction('PmsGatSD3'), PmsGatSD3('D3_OP'),SPACE(LEN(SD3->D3_OP)))"			 , 	'SPACE(LEN(SD3->D3_OP))' } } } )
	
	If FindFunction('ENGSX7117')
		EngSx7117(aDadosSX7)
	EndIf

Return Nil

/*/{Protheus.doc} CallsOfEst
	Criada para integrações com módulos de Ativos Fixos (ATFA012) e Compras (MATA103X).
	@type  Function
	@author Mauro Swincik Jr. - SQUAD Entradas
	@since 09/01/2019
	@version P12.1.17
	@return lRet, logical, indica se a chamada atual partiu das rotinas indicadas 
		na declaração de lRet.
/*/
User Function CallsOfEst()

Local lRet := FwIsInCallStack("MATA240") .Or. FwIsInCallStack("MATA241");
	.Or. FwIsInCallStack("MATA185") // .Or. ...


Return lRet 
