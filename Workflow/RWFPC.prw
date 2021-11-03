#include 'protheus.ch'
#include 'totvs.ch'
#include "Topconn.ch"
#include 'FWBROWSE.ch'
#include 'FWMVCDEF.ch'

/*/{Protheus.doc} RWFPC
// Envio do pedido de compras por e-mail
@author Específicos Masipack
@since 29/05/2019
@version 1.0
/*/
User Function RWFPC()

Local cQuery := ''

Private lMarkAll := .F.

	If Pergunte('XWFPC001',.T.)

		cQuery := " SELECT  '' AS C7_MARK, C7_NUM, C7_FORNECE, C7_LOJA, C7_XENVIAD, A2_NOME, A2_EMAIL2, A2_TEL "
		cQuery += " FROM " + RetSQLName('SC7') + " SC7 "

		cQuery += " 	INNER JOIN " + RetSQLName('SA2') + " SA2 ON "
		cQuery += " 	A2_FILIAL = '" + FWxFilial('SA2') + "' "
		cQuery += " 	AND SA2.A2_COD = SC7.C7_FORNECE "
		cQuery += " 	AND SA2.A2_LOJA = SC7.C7_LOJA "
		cQuery += " 	AND A2_EST != 'EX' "
		cQuery += " 	AND SA2.D_E_L_E_T_ = ' ' "

		cQuery += " WHERE C7_FILIAL = '" + FWxFilial('SC7') + "' "
		cQuery += " AND C7_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
		cQuery += " AND C7_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"'
		cQuery += " AND C7_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"'

		If MV_PAR07 == 1	// Pedidos em Aberto
			
			cQuery += " AND C7_QUANT > C7_QUJE "
		
		ElseIf MV_PAR07 == 2	// Pedidos Em Atraso

			cQuery += " AND C7_QUANT > SC7.C7_QUJE "
			cQuery += " AND C7_DATPRF < '" + DTOS(dDataBase) + "' "
			
		Endif

		cQuery += " AND C7_RESIDUO = ' ' "
		cQuery += " AND SC7.D_E_L_E_T_ = ' '
		
		cQuery += " GROUP BY SC7.C7_NUM, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_XENVIAD, SA2.A2_NOME, SA2.A2_EMAIL2, SA2.A2_TEL "
		cQuery += " ORDER BY SC7.C7_NUM "
		
		cQuery := ChangeQuery(cQuery)

		ShowFormSC7(cQuery)
	
	Endif

Return


/*/{Protheus.doc} ShowFormSC7
Função para exibição do FormBrowse dos pedidos de compras (SC7)
@type  Static Function
@author user
@since 24/09/2020
/*/
Static Function ShowFormSC7(cQuery)

Local aCpoTMP	:= {'C7_MARK','C7_NUM','C7_FORNECE','C7_LOJA','A2_NOME','A2_EMAIL2','A2_TEL','C7_XENVIAD'}
//Local aCpoSC7	:= {'C7_NUM','C7_ITEM','C7_PRODUTO','C7_QUANT','C7_QUJE','C7_DATPRF'}
Local aIndex	:= {"C7_NUM"}
Local aSeekSC7	:= {{ "Num. Pedido", {{"Pedido","C",TamSx3('C7_NUM')[1],0,"",,}} }}
Local cAlias	:= GetNextAlias()
Local cTitle	:= 'Pedidos de Compras' + IIF(MV_PAR07 == 1,' - Em Aberto',IIF(MV_PAR07 == 2,' - Em Atraso',' - Todos'))
Local nPos		:= 0
Local oDlg		:= CreateModal(cTitle)
Local oBrwTMP, /*oBrwSC7,*/ oCol, oModal, oLayer
	
	oModal := oDlg:GetPanelMain()

	oLayer := FWLayer():New()
    oLayer:Init(oModal, .F., .T.)
    oLayer:AddLine("LIN1",100, .F.)
//	oLayer:AddLine("LIN2",040, .F.)
	oLayer:AddCollumn("COL1", 100, .F., "LIN1")
//	oLayer:AddCollumn("COL2", 100, .F., "LIN2")
    
	oBrwTMP := FWFormBrowse():New()
	oBrwTMP:SetOwner(oLayer:GetColPanel("COL1","LIN1"))
	oBrwTMP:SetDescription(cTitle)
    oBrwTMP:SetAlias(cAlias)
    oBrwTMP:SetDataQuery(.T.)
    oBrwTMP:SetQuery(cQuery)
	oBrwTMP:AddMarkColumns({||IIf((cAlias)->C7_MARK == 'X', "LBOK", "LBNO")}, {|| MarkBrw(cAlias) }, /*{|| MarkAllBrw(cAlias) }*/)
	oBrwTMP:AddLegend( "Empty(C7_XENVIAD)", "RED", "Envio Pendente" )
	oBrwTMP:AddLegend( "!Empty(C7_XENVIAD)", "GREEN", "Envio Realizado" )
    oBrwTMP:DisableDetails()
	oBrwTMP:AddButton('Confirmar',	{|| IF( FwAlertYesNo('Enviar e-mails aos Fornecedores selecionados?',"TOTVS"), (Processa({|lEnd| ProcRegua(0), b_SendMail(cAlias) },"Aguarde..","",.F.), oDlg:DeActivate()), Nil) })
	oBrwTMP:AddButton('Cancelar',	{|| oDlg:DeActivate() })
	oBrwTMP:AddButton('Pedido', 	{|| FWMsgRun(, {|| b_ConsPed(cAlias) }, "Aguarde", "Buscando Pedido") })
	oBrwTMP:AddButton('Fornecedor', {|| FWMsgRun(, {|| b_ConsFor(cAlias) }, "Aguarde", "Buscando Fornecedor") })
	oBrwTMP:SetQueryIndex(aIndex)
	oBrwTMP:SetSeek(,aSeekSC7)

	

	For nPos := 1 To Len(aCpoTMP)
		If !(aCpoTMP[nPos] == 'C7_MARK')
			oCol := FWBrwColumn():New()
			oCol:SetTitle( RetTitle(aCpoTMP[nPos]) )
			oCol:SetData( &("{|| (cAlias)->" + aCpoTMP[nPos] + " }") )
			oCol:SetType( TamSX3(aCpoTMP[nPos])[3] )
			oCol:SetSize( TamSX3(aCpoTMP[nPos])[1] )
			oCol:SetDecimal( TamSX3(aCpoTMP[nPos])[2] )
			oCol:SetPicture( PesqPict('SC7',aCpoTMP[nPos]) )
			oBrwTMP:SetColumns({oCol})
		Endif
    Next nPos

	oBrwTMP:Activate()
/*
	oBrwSC7 := FWFormBrowse():New()
	oBrwSC7:SetOwner(oLayer:GetColPanel("COL2","LIN2"))
	oBrwSC7:SetDescription('Itens do Pedido de Compra')
    oBrwSC7:SetAlias('SC7')
    oBrwSC7:SetDataTable(.T.)
	oBrwSC7:AddLegend( "SC7->C7_QUJE == 0", "GREEN", "Item Pendente" )
	oBrwSC7:AddLegend( "SC7->C7_QUJE > 0 .And. SC7->C7_QUANT > SC7->C7_QUJE", "YELLOW", "Item Parcialmente Atendido" )
	oBrwSC7:AddLegend( "SC7->C7_QUANT == SC7->C7_QUJE", "RED", "Item Atendido" )
    oBrwSC7:DisableDetails()

	For nPos := 1 To Len(aCpoSC7)
		oCol := FWBrwColumn():New()
		oCol:SetTitle( RetTitle(aCpoSC7[nPos]) )
		oCol:SetData( &("{|| " + aCpoSC7[nPos] + " }") )
		oCol:SetType( TamSX3(aCpoSC7[nPos])[3] )
		oCol:SetSize( TamSX3(aCpoSC7[nPos])[1] )
		oCol:SetDecimal( TamSX3(aCpoSC7[nPos])[2] )
		oCol:SetPicture( PesqPict('SC7',aCpoSC7[nPos]) )
		oBrwSC7:SetColumns({oCol})
    Next nPos
	
	oBrwSC7:Activate()

	oRelation := FWBrwRelation():New() 
	oRelation:AddRelation(oBrwTMP,oBrwSC7,{{"C7_NUM","C7_NUM"}})
	oRelation:Activate()

	oBrwSC7:Refresh()
*/
	oDlg:Activate()

Return


/*/{Protheus.doc} CreateMotal
Função para a criação da Modal
@type  Static Function
@author user
@since 24/09/2020
/*/
Static Function CreateModal(cTitle)

Local aCoors    := FWGetDialogSize()
Local uRet

    uRet := FwDialogModal():New()
	uRet:SetBackground(.T.)
	uRet:SetEscClose(.T.)
//  uRet:SetTitle(Alltrim(cTitle))
    uRet:SetPos(aCoors[1], aCoors[2])
    uRet:SetSize(aCoors[3]/2, aCoors[4]/2)
    uRet:CreateDialog()

Return uRet

/*/{Protheus.doc} b_ConsPed
Consulta o pedido de compras posicionado
@type  Static Function
@author user
@since 24/09/2020
/*/
Static Function b_ConsPed(cAlias)

Private aRotina		:= {}
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private cCadastro	:= "Pedido de Compra - VISUALIZAR"
Private l120Auto	:= .F.
Private l120Visual	:= .T.
Private nOpc		:= 2
Private nOpcx		:= 2
Private nTipoPed	:= 1
	
	aAdd(aRotina,{"Pesquisar","PesqBrw"   , 0, 1, 0, .F. }) //"Pesquisar"
    aAdd(aRotina,{"Visualizar","A120Pedido", 0, 2, 0, Nil }) //"Visualizar"
    	
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7") + (cAlias)->C7_NUM))
	
	If SC7->(FOUND())
		A120Pedido("SC7", SC7->(RECNO()), 2)
	Endif
	
Return


/*/{Protheus.doc} b_ConsFor
Consulta o fornecedor do pedido de compras posicionado
@type  Static Function
@author user
@since 24/09/2020
/*/
Static Function b_ConsFor(cAlias)

Private cCadastro	:= "Fornecedor - VISUALIZAR"
	
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + (cAlias)->C7_FORNECE + (cAlias)->C7_LOJA))
	
	If SA2->(FOUND())
		A030Visual("SA2",SA2->(RECNO()),2)
	Endif

Return


/*/{Protheus.doc} MarkAllBrw
Função para selecionar todos os registros do Browse
@type  Static Function
@author user
@since 24/09/2020

Static Function MarkAllBrw(cAlias)

	lMarkAll := !(lMarkAll)
	
	While (cAlias)->(!EOF())
		
		Reclock((cAlias),.F.)
		(cAlias)->C7_MARK := IIF(lMarkAll,'X','')
		(cAlias)->(MsUnlock())
		
		(cAlias)->(dbSkip())
	Enddo

Return
/*/

/*/{Protheus.doc} MarkBrw
Função para selecionar todos os registros do Browse
@type  Static Function
@author user
@since 24/09/2020
/*/
Static Function MarkBrw(cAlias)

	Reclock((cAlias),.F.)
	(cAlias)->C7_MARK := IIF((cAlias)->C7_MARK == 'X','','X')
	(cAlias)->(MsUnlock())
	
Return

/*/{Protheus.doc} b_SendMail
Função para envio dos pedidos
@type  Static Function
@author user
@since 24/09/2020
/*/
Static Function b_SendMail(cAlias)

Local aArea		:= GetArea()
Local aFiles	:= {}
Local cCompra	:= GetNewPar("MV_XCOMPRA")
Local cDesc		:= ""
Local cFile		:= ""
Local cMoeda	:= ""
Local cMsg		:= ""
Local cObs		:= ""
Local cTo		:= ""
Local cTpoMaq	:= GetMv("MS_TIPOMAQ")
Local cProdRaiz	:= SuperGetMv("MS_PRDRAIZ",.F.,"")
Local lIntComp	:= .F.
Local lTpoMaq	:= .F.
Local lContinua := .F.
Local nTotal	:= 0
Local nTDesc	:= 0 
Local nTFrete	:= 0 
Local nTIPI		:= 0 
Local nTCIPI	:= 0 
Local nTLiq		:= 0
Local nCount	:= 0
Local oMail, oHtml

	(cAlias)->(dbGoTop())
	While (cAlias)->(!EOF())
		If !Empty((cAlias)->C7_MARK)
			nTotal++
		Endif
		(cAlias)->(dbSkip())
	Enddo

	ProcRegua(nTotal)

	(cAlias)->(dbGoTop())
	While (cAlias)->(!EOF())
		
		If !Empty((cAlias)->C7_MARK)
			
			IncProc("Preparando o pedido " + (cAlias)->C7_NUM + " para envio" )
			
			If ! SC7->(dbSeek( FWxFilial("SC7") + PadR((cAlias)->C7_NUM,TamSX3('C7_NUM')[1]) ))
				FwAlertError('Pedido ' + (cAlias)->C7_NUM + ' não encontrado!')
				(cAlias)->(dbSkip())
				Loop
			Endif
			
			//Valida o e-mail do fornecedor
			If Empty((cAlias)->A2_EMAIL2)
				cMsg := "Fornecedor com o campo de e-mail não preenchido!"
				Help("", 1, "MAILEMPTY", , cMsg, 1, 0)
				(cAlias)->(dbSkip())
				Loop
			Endif
			cTo := Alltrim((cAlias)->A2_EMAIL2)
			
			//Valido se o pedido é intercompany e se o produto é máquina
			SC7->(dbSeek( FWxFilial("SC7") + (cAlias)->C7_NUM ))
			
			lIntComp := cEmpAnt $ '01|10' .AND. SC7->C7_FORNECE $ '001256|005144'
			lTpoMaq	 := .F.

			While lIntComp .And. SC7->(!EOF()) .And. SC7->C7_FILIAL == FWxFilial("SC7") .And. SC7->C7_NUM == (cAlias)->C7_NUM
				If (SUBSTR(SC7->C7_PRODUTO,1,IIF(cEmpAnt=='01',3,6)) $ cTpoMaq) .OR. (cEmpAnt == "10" .And. SUBSTR(SC7->C7_PRODUTO,1,6) $ cProdRaiz)
					lTpoMaq	:= .T.
					Exit
				Endif
				SC7->(dbSkip())
			Enddo
			
			SC7->(dbSeek( FWxFilial("SC7") + (cAlias)->C7_NUM ))
			
			cMoeda := If(SC7->C7_MOEDA == 1, "R$ ", If(SC7->C7_MOEDA == 2, "US$ ", If(SC7->C7_MOEDA == 4, "EUR ", "")))
			
			//Posiciono na tabela de Fornecedor
			SA2->(dbSetOrder(1))
			SA2->(dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))
			
			//Posiciono na tabela de Condição de Pagamento
			SE4->(dbSetOrder(1))
			SE4->(dbSeek(xFilial("SE4") + SC7->C7_COND))
			
			//Inicia o método do email
			oMail := TWFProcess():New( "PEDCOM", "Envio Pedido de Compras" )
			
			If Substr(cEmpAnt,1,2) == "01"
				oMail:NewTask( "PEDCOM01", "\WORKFLOW\MODELOS\PC\PCEnvio.htm" )
				oMail:cSubject := "MASIPACK - Pedido de Compras Nr. " + SC7->C7_NUM + IF(MV_PAR07 == 2,' - EM ATRASO','')
			ElseIf Substr(cEmpAnt,1,2) $ "10|11"
				oMail:NewTask( "PEDCOM01", "\WORKFLOW\MODELOS\PC\PC_Fabrima.htm" )
				oMail:cSubject := "FABRIMA - Pedido de Compras Nr. " + SC7->C7_NUM + IF(MV_PAR07 == 2,' - EM ATRASO','')
			ElseIf Substr(cEmpAnt,1,2) == "15"
				oMail:NewTask( "PEDCOM01", "\WORKFLOW\MODELOS\PC\PCHelsim.html" )
				oMail:cSubject := "HELSIMPLAST - Pedido de Compras Nr. " + SC7->C7_NUM + IF(MV_PAR07 == 2,' - EM ATRASO','')
			ElseIf Substr(cEmpAnt,1,2) == "40"
				oMail:NewTask( "PEDCOM01", "\WORKFLOW\MODELOS\PC\PCLabortub.htm" )
				oMail:cSubject := "LABORTUBE - Pedido de Compras Nr. " + SC7->C7_NUM
			ElseIf Substr(cEmpAnt,1,2) == "45"
				oMail:NewTask( "PEDCOM01", "\WORKFLOW\MODELOS\PC\PCMemb.htm" )
				oMail:cSubject := "MEMB - Pedido de Compras Nr. " + SC7->C7_NUM
			Endif
			
			If lIntComp	// Pedido InterCompany
				If lTpoMaq	// Produto máquinas
					oMail:cTo  := Alltrim(GetMv("MS_WFPCMAQ"))
					oMail:cCC  := Alltrim(GetMv("MS_WFMAQCC"))
					oMail:cBCC := Alltrim(GetMv("MS_WFMQCCO"))
				Else
					oMail:cTo  := AllTrim(cTo) + Alltrim(GetMv("MS_INTMAIL"))
					oMail:cCC  := "compras@masipack.com.br"
				Endif
			Else
				oMail:cTo  := AllTrim(cTo)
				oMail:cCC  := "compras@masipack.com.br;" + SuperGetMV("MS_MAILCC",.F.,"compras@masipack.com.br")
			Endif

			oMail:bReturn := ""
			//Fim do método do e-mail
			
			//Início da montagem do HTML
			oHtml := oMail:oHtml
			oHtml:ValByName("MOTIVO",IF(MV_PAR07 == 2,' - EM ATRASO',''))
			oHtml:ValByName("PEDIDO",SC7->C7_NUM)
			oHtml:ValbyName("M0_NOMECOM",Alltrim(SM0->M0_NOMECOM))
			oHtml:ValbyName("M0_CGC",Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
			oHtml:ValbyName("M0_INSC",Alltrim(SM0->M0_INSC))
			oHtml:ValByName("C7_USER",cCompra)
			oHtml:ValByName("A2_CONTATO",Alltrim(SA2->A2_CONTATO))
			oHtml:ValByName("C7_EMISSAO",DTOC(SC7->C7_EMISSAO))
			oHtml:ValByName("C7_NUM",SC7->C7_NUM)
			
			If Len(Alltrim(SA2->A2_CGC)) == 14
				oHtml:ValByName("A2_CGC",Transform(SA2->A2_CGC,"@R 99.999.999/9999-99"))
			Else
				oHtml:ValByName("A2_CGC",Transform(SA2->A2_CGC,"@R 999.999.999-99"))
			EndIf
			
			oHtml:ValByName("A2_NOME",Alltrim(SA2->A2_NOME))
			oHtml:ValByName("A2_INSCR",Alltrim(SA2->A2_INSCR))
			oHtml:ValByName("A2_END",Alltrim(SA2->A2_END))
			oHtml:ValByName("A2_BAIRRO",Alltrim(SA2->A2_BAIRRO))
			oHtml:ValByName("A2_MUN",Alltrim(SA2->A2_MUN))
			oHtml:ValByName("A2_CEP",Transform(SA2->A2_CEP,"@R 99999-999"))
			oHtml:ValByName("A2_TEL",Alltrim(SA2->A2_TEL))
			oHtml:ValByName("A2_FAX",Alltrim(SA2->A2_FAX))
			oHtml:ValByName("E4_DESCRI",Alltrim(SE4->E4_DESCRI))
			
			//Montagem dos itens do pedido no HTML
			While SC7->(!EOF()) .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == (cAlias)->C7_NUM
				
				If ( !(SC7->C7_RESIDUO $ 'S') .And. ( MV_PAR07 == 1 .And. SC7->C7_QUANT > SC7->C7_QUJE ) .OR. ( MV_PAR07 == 2 .And. SC7->C7_QUANT > SC7->C7_QUJE .And. SC7->C7_DATPRF < dDataBase ) .OR. MV_PAR07 == 3 )
					lContinua := .T.
				Endif

				If lContinua

					cFile := "\DESENHOS\"
					cFile += Alltrim(SC7->C7_PRODUTO) + Alltrim(POSICIONE("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_REVATU"))+".PDF"
					
					If File(cFile) .And. aScan(aFiles,cFile) == 0
						oMail:AttachFile(cFile)
						AADD(aFiles,cFile)
					EndIf
					
					AADD( (oHtml:ValByName( "T1.1"	))	,SC7->C7_ITEM	)
					AADD( (oHtml:ValByName( "T1.2" 	))	,SC7->C7_PRODUTO)
					
					If ! SubStr(cNumEmp,1,2) == "15"
						cDesc	:= If( !Empty(POSICIONE("SB5", 1, xFilial("SB5") + SC7->C7_PRODUTO, "B5_CEME")),; 
										POSICIONE("SB5", 1, xFilial("SB5") + SC7->C7_PRODUTO, "B5_CEME"),;
										POSICIONE("SB1", 1, xFilial("SB1") + SC7->C7_PRODUTO, "B1_DESC") )	
					Else
						cDesc	:= POSICIONE("SB1", 1, xFilial("SB1") + SC7->C7_PRODUTO, "B1_DESC")
					Endif
					
					AADD( (oHtml:ValByName( "T1.3"	))	,cDesc)
					
					cObs	:= "Obs.: " + AllTrim(SC7->C7_OBS)
					AADD( (oHtml:ValByName( "T1.A3"	))	,cObs )
					
					AADD( (oHtml:ValByName( "T1.4"	))	,SC7->C7_UM)
					AADD( (oHtml:ValByName( "T1.5"	))	,Transform(Round(SC7->(C7_QUANT - C7_QUJE),2),"@E 999,999,999.99"))
					AADD( (oHtml:ValByName( "T1.6"	))	,cMoeda + Transform(Round(SC7->C7_PRECO,2),"@E 9,999,999.999999"))
					
					AADD( (oHtml:ValByName( "T1.7"	))	,Transform(SC7->C7_IPI,"@E 999.99"))
					AADD( (oHtml:ValByName( "T1.8"	))	,cMoeda + Transform(SC7->(((((C7_QUANT - C7_QUJE) * C7_PRECO) + C7_VALFRE) * C7_IPI) / 100),"@E 999,999,999.99"))
					AADD( (oHtml:ValByName( "T1.9"	))	,cMoeda + Transform(SC7->(((C7_QUANT - C7_QUJE) * C7_PRECO)),"@E 999,999,999.99"))
					AADD( (oHtml:ValByName( "T1.10"	))	,DTOC(SC7->C7_DATPRF))
					AADD( (oHtml:ValByName( "T1.11"	))	,If( SubStr(POSICIONE("SB1", 1, xFilial("SB1") + SC7->C7_PRODUTO, "B1_PROCED"),2,1) == "P", "I", "C" ) )
					
//					nTIPI 	+= SC7->(((((C7_QUANT - C7_QUJE) * C7_PRECO) * C7_IPI) /100))
					nTIPI 	+= SC7->(((((C7_QUANT - C7_QUJE) * C7_PRECO) + C7_VALFRE) * C7_IPI) / 100 )
					nTFrete	+= SC7->C7_VALFRE
					nTDesc	+= SC7->C7_VLDESC
//					nTCIPI	+= SC7->(((C7_QUANT - C7_QUJE) * C7_PRECO) + ((((C7_QUANT - C7_QUJE) * C7_PRECO) * C7_IPI) /100))
					nTCIPI	+= SC7->(((C7_QUANT - C7_QUJE) * C7_PRECO) + ((((C7_QUANT - C7_QUJE) * C7_PRECO) + C7_VALFRE) * C7_IPI) / 100)
					nTLiq	+= SC7->(((C7_QUANT - C7_QUJE) * C7_PRECO) + (((((C7_QUANT - C7_QUJE) * C7_PRECO) + C7_VALFRE) * C7_IPI) / 100)) - SC7->C7_VLDESC + SC7->C7_VALFRE

					lContinua := .F.

				Endif	
				
				SC7->(dbSkip())
				
			Enddo
			
			//Totalizadores
			oHtml:ValByName("DESCONTO"	,cMoeda + Transform(nTDesc,	 "@E 999,999,999.99"))
			oHtml:ValByName("FRETE"		,cMoeda + Transform(nTFrete, "@E 999,999,999.99"))
			oHtml:ValByName("TOTIPI"	,cMoeda + Transform(nTIPI,	 "@E 999,999,999.99"))
			oHtml:ValByName("TOTCIPI"	,cMoeda + Transform(nTCIPI,	 "@E 999,999,999.99"))
			oHtml:ValByName("TOTLIQUI"	,cMoeda + Transform(nTLiq,	 "@E 999,999,999.99"))
			oHtml:ValByName("C7_TOTAL"	,cMoeda + Transform(nTLiq,	 "@E 999,999,999.99"))
			
			nTDesc := nTFrete := nTIPI := nTCIPI := nTLiq := 0
			
			oMail:cPriority := "3"
			oMail:Start()
			oMail:Finish()
			
			Sleep(5000)

			nCount++

			SC7->(DbSeek(xFilial("SC7") + (cAlias)->C7_NUM))
			Do While !SC7->(EOF()) .And. SC7->C7_FILIAL == FWxFilial("SC7") .And. SC7->C7_NUM == (cAlias)->C7_NUM
				If RecLock("SC7",.F.)
					SC7->C7_XENVIAD := "E"
					SC7->(MsUnLock())
				Endif
				SC7->(DbSkip())
			EndDo

			oMail := Nil
			oHtml := Nil
			
		Endif
		
		(cAlias)->(dbSkip())
	Enddo
	
	If nCount > 0
		FwAlertSuccess( Alltrim(Str(nCount)) + " E-mail(s) Enviado(s)!","TOTVS")
	Endif
	
	RestArea(aArea)
	
Return
