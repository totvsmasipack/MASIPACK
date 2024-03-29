#include 'totvs.ch'
#include 'FWMVCDEF.ch'

/*/{Protheus.doc} User Function RESTA020
Fun��o para controle das devolu��es ao armaz�m
@type  Function
@author Masipack
@since 27/01/2020
@version version
/*/
User Function RESTA020()

//Local aDepto	:= FWSFALLUSERS({RetCodUsr()},{"USR_DEPTO"})
Local oBrowse

	oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SZP")
    oBrowse:SetDescription("Devolu��o ao Armaz�m")
    oBrowse:SetAttach(.T.)
    oBrowse:SetMenuDef('RESTA020')

    oBrowse:AddLegend( "SZP->ZP_QUJE == 0", "GREEN",   "Devolu��o Pendente" )
    oBrowse:AddLegend( "SZP->ZP_QUJE > 0 .AND. SZP->ZP_QUJE < SZP->ZP_QUANT", "YELLOW",     "Devolu��o Parcial")
	oBrowse:AddLegend( "SZP->ZP_QUJE == SZP->ZP_QUANT", "RED",     "Devolu��o Total")

//	IF !FwIsAdmin(RetCodUsr()) .And. !("ALMOX" $ UPPER(aDepto[1,3]))
//		oBrowse:SetFilterDefault("SZP->ZP_USER == " + RetCodUsr())
//	Endif

    oBrowse:Activate()

Return

// Defini��o dos menus da rotina
Static Function MenuDef()

Local aRotina := {}

    ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.RESTA020' OPERATION 2 ACCESS 0
    ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.RESTA020' OPERATION 3 ACCESS 0
    ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.RESTA020' OPERATION 4 ACCESS 0
    ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.RESTA020' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Impr. Devolucao' Action 'U_RESTR019' OPERATION 9 ACCESS 0

Return aRotina

// Defini��o do Modelo de Dados da rotina
Static Function ModelDef()

Local bLinePre	:= {|oGrid,nLine,cAction| fLinePre(oGrid,nLine,cAction)}
Local bLinePost	:= {|oGrid| fLinePost(oModel,oGrid) }				// Valida��o do conte�do da linha ao mudar o seu posicionamento
Local cFldCab	:= "ZP_NUM|ZP_EMISSAO|ZP_USER|ZP_SOLICIT|ZP_HORAS"
Local oStruCab	:= FWFormStruct(1,'SZP',{|cCampo| Alltrim(cCampo) $ cFldCab })
Local oStruSZP	:= FWFormStruct(1,'SZP',{|cCampo| !(Alltrim(cCampo) $ cFldCab) })
Local oModel

	oStruCab:SetProperty("ZP_NUM",MODEL_FIELD_WHEN,{|| .T. })
//	oStruSZP:AddField("","","ZP_MARK","L",1,0,{ |oModel| fMark(oModel) },Nil,Nil,Nil,Nil,Nil,Nil,.T.)

    oModel := MPFormModel():New('ESTA020MVC', ,{|oModel| ValidModel(oModel)})

	oModel:AddFields( 'SZPMASTER', /*cOwner*/, oStruCab)
	oModel:GetModel( 'SZPMASTER' ):SetDescription('Devolu��o')
	oModel:SetPrimaryKey({'ZP_FILIAL','ZP_NUM'})

    oModel:AddGrid('SZPITENS','SZPMASTER',oStruSZP,bLinePre,bLinePost,/*bPreVal*/,/*bPosVal*/)
	oModel:GetModel( 'SZPITENS' ):SetDescription( 'Itens da Devolu��o' )

	oModel:SetRelation('SZPITENS',{{'ZP_FILIAL','FWxFilial("SZP")'},{'ZP_NUM','ZP_NUM'}},SZP->(IndexKey(1)) )
	oModel:GetModel('SZPITENS'):SetUniqueLine({'ZP_ITEM'})
	oModel:GetModel('SZPITENS'):SetDelAllLine(.T.)
	
Return oModel


// Cria��o da View da rotina
Static Function ViewDef()

Local cFldCab	:= "ZP_NUM|ZP_EMISSAO|ZP_USER|ZP_SOLICIT"
Local cFldIte	:= "ZP_ITEM|ZP_PRODUTO|ZP_DESCRI|ZP_UM|ZP_QUANT|ZP_QUJE|ZP_LOCAL|ZP_CC|ZP_OBS"
Local oStruCab	:= FWFormStruct(2,'SZP',{|cCampo| Alltrim(cCampo) $ cFldCab })
Local oStruSZP	:= FWFormStruct(2,'SZP',{|cCampo| Alltrim(cCampo) $ cFldIte })
Local oModel	:= FWLoadModel('RESTA020') 
Local oView

	oStruCab:SetNoFolder()
/*	
	If IsInCallStack("U_A020ENCER")
		oStruSZP:AddField("ZP_MARK","01","","",{},"L","@BMP",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)
		oStruSZP:Setproperty('ZP_PRODUTO', MODEL_FIELD_NOUPD)
		oStruSZP:Setproperty('ZP_QUANT', MODEL_FIELD_NOUPD, .F.)
		oStruSZP:Setproperty('ZP_OBS', MODEL_FIELD_NOUPD, .F.)
		oStruSZP:Setproperty('ZP_CC', MODEL_FIELD_NOUPD, .F.)
	Endif
*/
    oView := FWFormView():New()
	oView:SetUseCursor(.F.)
	oView:SetModel(oModel)
	oView:EnableControlBar(.T.)
	
    oView:AddField('HEADER_SZP', oStruCab,'SZPMASTER')
	oView:EnableTitleView('HEADER_SZP', 'Principal')
    oView:CreateHorizontalBox('CABEC',30)
    oView:SetOwnerView('HEADER_SZP','CABEC')
	
	oView:AddGrid("GRID_SZP", oStruSZP, 'SZPITENS')
	oView:EnableTitleView('GRID_SZP', 'Itens a Devolver')
	oView:CreateHorizontalBox('GRID',70)
	oView:SetOwnerView('GRID_SZP','GRID')
	
	oView:AddIncrementField('GRID_SZP','ZP_ITEM')

Return oView

//Fun��o para valida��o da Model
Static Function ValidModel(oModel)

Local aArea	:= GetArea()
Local lOk	:= .T.
Local nX	:= 0
Local oGrid := oModel:GetModel( 'SZPITENS' )

	Do Case
		
		Case oModel:GetOperation() == MODEL_OPERATION_INSERT 
			
			If !(dDataBase == FwFldGet("ZP_EMISSAO"))
				lOk := .F.
				Help( ,, 'A020DTDIV',,"A data selecionada difere com a data do dia.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe a data de hoje: " + DToC(dDataBase) })
			Endif

		Case oModel:GetOperation() == MODEL_OPERATION_DELETE
			
			For nX := 1 To oGrid:Length()
				oGrid:GoLine(nX)
				If FwFldGet("ZP_QUJE") > 0
					lOk := .F.
					Help( ,, 'A020NODEL',,"Item " + FwFldGet("ZP_ITEM") + " j� devolvido ", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Deve ocorrer o estorno da movimenta��o do estoque para conseguir excluir o registro"})
					Exit
				Endif
			Next nX

	Endcase

	RestArea(aArea)

Return lOk

//Fun��o para controle da marca��o
/*
Static Function fMark(oModel)

Local oView	:= FwViewActive()
Local lMark	:= oModel:GetValue("ZP_OK")

	oModel:LoadValue("ZP_OK",lMark)
	oView:Refresh()

Return .T.
*/

//Fun��o para valida��o da linha digitada
Static Function fLinePost(oModel,oGrid)

Local aArea	:= GetArea()
Local lOk	:= .T.

	Do Case
		
		Case oModel:GetOperation() == MODEL_OPERATION_INSERT 
			
			dbSelectArea("SB1")
			SB1->(dbSetorder(1))
			If SB1->(dbSeek(FWxFilial("SB1") + FwFldGet("ZP_PRODUTO")))
				If "P" $ SB1->B1_PROCED .And. !(cEmpAnt == "01")
//					lOk := .F.
					Help(NIL, NIL, "A020FABR", NIL, "Devolu��o n�o permitida para produtos que s�o produtivos", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Esta rotina n�o deve ser utilizada para devolver produtos que s�o produtivos. Utilize o Movimento Interno para que a devolu��o ocorra atrav�s de uma Ordem de Produ��o."})
				ElseIf cEmpAnt == "01".And. SB1->B1_LOCPAD == "01"
//					lOk := .F.
					Help(NIL, NIL, "A020FABR", NIL, "Devolu��o n�o permitida para produtos que s�o produtivos", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Esta rotina n�o deve ser utilizada para devolver produtos que s�o produtivos. Utilize o Movimento Interno para que a devolu��o ocorra atrav�s de uma Ordem de Produ��o."})
				Endif
			Endif
		
		Case oModel:GetOperation() == MODEL_OPERATION_UPDATE

			dbSelectArea("SB1")
			SB1->(dbSetorder(1))
			If SB1->(dbSeek(FWxFilial("SB1") + FwFldGet("ZP_PRODUTO")))
				If "P" $ SB1->B1_PROCED .And. !(cEmpAnt == "01")
//					lOk := .F.
					Help(NIL, NIL, "A020FABR", NIL, "Devolu��o n�o permitida para produtos que s�o produtivos", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Esta rotina n�o deve ser utilizada para devolver produtos que s�o produtivos. Utilize o Movimento Interno para que a devolu��o ocorra atrav�s de uma Ordem de Produ��o."})
				ElseIf cEmpAnt == "01".And. SB1->B1_LOCPAD == "01"
//					lOk := .F.
					Help(NIL, NIL, "A020FABR", NIL, "Devolu��o n�o permitida para produtos que s�o produtivos", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Esta rotina n�o deve ser utilizada para devolver produtos que s�o produtivos. Utilize o Movimento Interno para que a devolu��o ocorra atrav�s de uma Ordem de Produ��o."})
				Endif
			Endif

	Endcase

	RestArea(aArea)

Return lOk


Static Function fLinePre(oGrid,nLine,cAction)

Local lRet	:= .T.

Default cAction := ''

	If !(Empty(cAction))
		If cAction == "DELETE" .And. FwFldGet('ZP_QUJE') > 0
			lRet := .F.
			Help(NIL, NIL, "A020NODEL", NIL, "Delete n�o permitido para produtos j� atendidos", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Produto " + Alltrim(FwFldGet("ZP_PRODUTO")) + " com o saldo total/parcial retornado ao estoque."})
		Endif
	Endif

Return lRet
