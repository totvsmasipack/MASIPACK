#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} User Function RFATA021
    Cadastro de Motoristas visitantes
    @type  Function
    @author user
    @since 22/01/2020
/*/    
User Function RFATA021()

Local oBrowse
     
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("DA4")
    oBrowse:SetDescription("Cadastro de Motoristas")
    oBrowse:SetAttach(.T.)
    oBrowse:SetMenuDef('RFATA021')

    oBrowse:AddLegend( "DA4->DA4_BLQMOT == '2'", "GREEN",   "Não Bloqueado" )
    oBrowse:AddLegend( "DA4->DA4_BLQMOT == '1'", "RED",     "Bloqueado"     )
    
    oBrowse:Activate()

Return

// Definição dos menus da rotina
Static Function MenuDef()

Local aRotina := {}

    ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.RFATA021' OPERATION 2 ACCESS 0
    ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.RFATA021' OPERATION 3 ACCESS 0
    ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.RFATA021' OPERATION 4 ACCESS 0
    ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.RFATA021' OPERATION 5 ACCESS 0

Return aRotina

// Definição do Modelo de Dados da rotina
Static Function ModelDef()

Local oModel
Local oStruDA4 := FWFormStruct( 1, 'DA4' )
    
    oModel := MPFormModel():New('A021MVC', , ,{|oModel| SaveModel(oModel) })
    oModel:AddFields( 'DA4MASTER', /*cOwner*/, oStruDA4)
    oModel:SetDescription( 'Cadastro de Motoristas' )
    oModel:SetPrimaryKey({"DA4_FILIAL", "DA4_COD"})
    oModel:GetModel( 'DA4MASTER' ):SetDescription( 'Motorista' )

Return oModel

// Criação da View da rotina
Static Function ViewDef()
Local oModel := FWLoadModel( 'RFATA021' ) 
Local oStruDA4 := FWFormStruct( 2, 'DA4' )
Local oView

    oView := FWFormView():New()
    oView:SetModel( oModel )
    oView:AddField( 'VIEW_DA4', oStruDA4, 'DA4MASTER' )
    oView:EnableTitleView('VIEW_DA4', 'Motorista')
    oView:CreateHorizontalBox( 'TELA' , 100 )
    oView:SetOwnerView( 'VIEW_DA4', 'TELA' )

Return oView

// Função para salvar e fechar a model
Static Function SaveModel(oModel)

    Begin Transaction
        
        FwFormCommit( oModel )
    
    End Transaction

Return .T.