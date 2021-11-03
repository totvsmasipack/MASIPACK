#include 'totvs.ch'
#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} User Function RESTA033
Função para controle de produtos do cliente
@type  User Function
@author E. DINIZ [ DS2U ]
@since 07/10/2020
@version version
/*/
User Function RESTA033()

Local oBrowse

	oBrowse := FwMBrowse():New()
    oBrowse:SetAlias("ZZ2")
    oBrowse:SetDescription("Dados do Produto do Cliente")
    oBrowse:SetAttach(.T.)
    oBrowse:SetMenuDef('RESTA033')
    oBrowse:Activate()

Return


// Definição dos menus da rotina
Static Function MenuDef()

Local aRotina := {}

    ADD OPTION aRotina Title 'Visualizar'	Action 'VIEWDEF.RESTA033'	OPERATION 2 ACCESS 0
    ADD OPTION aRotina Title 'Excluir'		Action 'VIEWDEF.RESTA033'	OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'		Action 'U_RESTR043()'		OPERATION 8 ACCESS 0

Return aRotina


// Definição do Modelo de Dados da rotina
Static Function ModelDef()

Local bInitMdl	:= {|oModel| VldInitMdl(oModel)	}
Local bCommit	:= {|oModel| CommitMdl(oModel)	}
Local bPosValid	:= {|oModel| ValidMdl(oModel)	}
Local cFldCab	:= 'ZZ2_DOC|ZZ2_SERIE|ZZ2_CLIENT|ZZ2_LOJA|ZZ2_NOME|ZZ2_DATA|ZZ2_CLIFOR'
Local oCabec	:= FWFormStruct(1,'ZZ2',{|cCampo| Alltrim(cCampo) $ cFldCab	})
Local oItems	:= FWFormStruct(1,'ZZ2',{|cCampo| !( Alltrim(cCampo) $ cFldCab )})
Local oModel	:= MPFormModel():New('ESTA033MVC', bInitMdl, bPosValid, bCommit)

	oCabec:SetProperty('ZZ2_NOME', MODEL_FIELD_INIT,{|| SUBSTR( POSICIONE( IF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2'), 1, FWxFilial( IF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2')) + ZZ2->(ZZ2_CLIENT+ZZ2_LOJA), IF( ZZ2->ZZ2_CLIFOR=='C','A1_NOME','A2_NOME' )), 1, TamSX3('ZZ2_NOME')[1]) })

	oCabec:AddTrigger('ZZ2_LOJA','ZZ2_NOME',{|| .T. },{|| SUBSTR( POSICIONE( IF(oModel:GetValue('ZZ2MASTER','ZZ2_CLIFOR')=='C','SA1','SA2'), 1, FWxFilial( IF(oModel:GetValue('ZZ2MASTER','ZZ2_CLIFOR')=='C','SA1','SA2') ) + oModel:GetValue('ZZ2MASTER','ZZ2_CLIENT') + oModel:GetValue('ZZ2MASTER','ZZ2_LOJA'), IF( oModel:GetValue('ZZ2MASTER','ZZ2_CLIFOR')=='C','A1_NOME','A2_NOME' ) ), 1, TamSX3('ZZ2_NOME')[1]) })
	oCabec:AddTrigger('ZZ2_LOJA','ZZ2_DATA',{|| .T. },{|| dDataBase })
	
	oItems:SetProperty('ZZ2_DESC', MODEL_FIELD_INIT,{|| PadR(POSICIONE('SB1',1,FWxFilial('SB1')+ZZ2->ZZ2_COD,'B1_DESC'),TamSX3('ZZ2_DESC')[1]) })
	oItems:AddTrigger('ZZ2_COD','ZZ2_DESC'	,{|| .T. },{|| PadR(POSICIONE('SB1',1,FWxFilial('SB1')+oModel:GetValue('ZZ2ITENS','ZZ2_COD'),'B1_DESC'),TamSX3('ZZ2_DESC')[1])})
	oItems:AddTrigger('ZZ2_COD','ZZ2_ETIQ'	,{|| .T. },{|| 'N' })
	oItems:AddTrigger('ZZ2_COD','ZZ2_IMPURE',{|| .T. },{|| 'N' })
	oItems:AddTrigger('ZZ2_COD','ZZ2_AVARIA',{|| .T. },{|| 'N' })
	oItems:AddTrigger('ZZ2_COD','ZZ2_AVARIA',{|| .T. },{|| 'N' })
	oItems:AddTrigger('ZZ2_COD','ZZ2_LOCARM',{|| .T. },{|| 'N' })
	oItems:AddTrigger('ZZ2_COD','ZZ2_SOLCHV',{|| .T. },{|| 'N' })
	oItems:AddTrigger('ZZ2_COD','ZZ2_CTRTEM',{|| .T. },{|| 'N' })
	oItems:AddTrigger('ZZ2_COD','ZZ2_RECOME',{|| .T. },{|| 'N' })

	oModel:AddFields( 'ZZ2MASTER', , oCabec)
	oModel:GetModel( 'ZZ2MASTER' ):SetDescription('ZZ2MASTER')
	oModel:SetPrimaryKey({'ZZ2_FILIAL','ZZ2_DOC','ZZ2_SERIE','ZZ2_CLIENT','ZZ2_LOJA'})

	oModel:AddGrid('ZZ2ITENS','ZZ2MASTER',oItems)
	oModel:GetModel( 'ZZ2ITENS' ):SetDescription( 'Itens da Nota Fiscal' )
	oModel:GetModel('ZZ2ITENS'):SetUniqueLine({'ZZ2_ITEM'})
	oModel:GetModel('ZZ2ITENS'):SetNoInsertLine(.T.)
	oModel:GetModel('ZZ2ITENS'):SetOptional(.T.)
	oModel:SetRelation('ZZ2ITENS',{{'ZZ2_FILIAL','FWxFilial("ZZ2")'},{'ZZ2_DOC','ZZ2_DOC'},{'ZZ2_SERIE','ZZ2_SERIE'},{'ZZ2_CLIENT','ZZ2_CLIENT'},{'ZZ2_LOJA','ZZ2_LOJA'}},ZZ2->(IndexKey(1)) )
	
Return oModel

// Criação da View da rotina
Static Function ViewDef()

Local cFldCab	:= 'ZZ2_DOC|ZZ2_SERIE|ZZ2_CLIENT|ZZ2_LOJA|ZZ2_NOME|ZZ2_DATA|ZZ2_CLIFOR'
Local oCabec	:= FWFormStruct(2,'ZZ2',{|cCampo| Alltrim(cCampo) $ cFldCab	})
Local oItems	:= FWFormStruct(2,'ZZ2',{|cCampo| !( Alltrim(cCampo) $ cFldCab )})
Local oModel	:= FWLoadModel('RESTA033') 
Local oView

	oCabec:SetNoFolder()
	oItems:SetNoFolder()

    oView := FWFormView():New()
	oView:SetUseCursor(.F.)
	oView:SetModel(oModel)
	oView:EnableControlBar(.T.)
	
    oView:AddField('ZZ2CABEC', oCabec,'ZZ2MASTER')
	oView:EnableTitleView('ZZ2CABEC', 'Principal')
    oView:CreateHorizontalBox('CABEC',40)
    oView:SetOwnerView('ZZ2CABEC','CABEC')
	
	oView:AddGrid("ZZ2GRID", oItems, 'ZZ2ITENS')
	oView:EnableTitleView('ZZ2GRID', 'Itens da Nota Fiscal')
	oView:CreateHorizontalBox('GRID',60)
	oView:SetOwnerView('ZZ2GRID','GRID')
	
Return oView


/*/{Protheus.doc} Static Function VldInitMdl
Função para validar o Modelo de dados, antes de ativa-lo
@type  Static Function
@author E. DINIZ [ DS2U ]
@since 07/10/2020
@version version
/*/
Static Function VldInitMdl(oModel)

Local _lRet	:= .T.
Local _nx	:= 0

	Do Case
		Case Empty(SF1->F1_DOC)
			_lRet := .F.
			Help( ,, 'F1DOCVAZIO',,'Documento Fiscal não informado', 1, 0 )

		Case Empty(SF1->F1_SERIE)
			_lRet := .F.
			Help( ,, 'SERIEVAZIO',,'Serie da Nota Fiscal não informada', 1, 0 )

		Case Empty(SF1->F1_TIPO)
			_lRet := .F.
			Help( ,, 'TIPOVAZIO',,'Tipo da Nota Fiscal não informada', 1, 0 )

		Case Empty(SF1->F1_FORNECE)
			_lRet := .F.
			Help( ,, 'FORNVAZIO',,'Fornecedor/Cliente da Nota Fiscal não informada', 1, 0 )
		
		Case Empty(SF1->F1_LOJA)
			_lRet := .F.
			Help( ,, 'LOJAVAZIO',,'Loja do Fornecedor/Cliente da Nota Fiscal não informada', 1, 0 )
	EndCase

	If _lRet
		For _nx := 1 To Len(aCols)
			If Empty( aCols[_nx][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_COD'})] ) .And. !(aCols[_nx][Len(aCols[_nx])])
				_lRet := .F.
				Help( ,, 'ESTA33VLD',,'Codigo do produto não informado no item ' + StrZero(_nx,4) + ' da Nota Fiscal', 1, 0 )
				Exit
			Endif
		Next _nx
	Endif

Return _lRet

/*/{Protheus.doc} Static Function ValidMdl
Função para validar o Modelo de dados, antes do seu commit
@type  Static Function
@author E. DINIZ [ DS2U ]
@since 07/10/2020
@version version
/*/
Static Function ValidMdl(oModel)

Local _lRet	:= .F.

	If oModel:GetModel("ZZ2MASTER"):GetOperation() == MODEL_OPERATION_INSERT .And.  FwAlertYesNo('Deseja confirmar a inclusão dos dados?','TOTVS')
		_lRet := .T.
	ElseIf oModel:GetModel("ZZ2MASTER"):GetOperation() == MODEL_OPERATION_UPDATE .And.  FwAlertYesNo('Deseja confirmar a alteração dos dados?','TOTVS')
		_lRet := .T.
		ElseIf oModel:GetModel("ZZ2MASTER"):GetOperation() == MODEL_OPERATION_DELETE .And.  FwAlertYesNo('Deseja confirmar o delete dos dados?','TOTVS')
		_lRet := .T.
	Endif

Return _lRet


/*/{Protheus.doc} Static Function CommitMdl
Função para realizar o commit dos dados contidos na Model
@type  Static Function
@author E. DINIZ [ DS2U ]
@since 07/10/2020
@version version
/*/
Static Function CommitMdl(oModel)          

Local _lRet		:= .F.

	If ( oModel:GetModel("ZZ2MASTER"):GetOperation() == MODEL_OPERATION_INSERT ) .Or. ( oModel:GetModel("ZZ2MASTER"):GetOperation() == MODEL_OPERATION_UPDATE )

		If FwFormCommit(oModel)
			_lRet := .T.

			If FwAlertYesNo('Imprimir o relatório?','TOTVS')
				U_RESTR043()
			Endif

		Endif

    EndIf

Return _lRet

/*/{Protheus.doc} User Function GetProdCli
Função para chamada no menu da Pre-Nota
@type  User Function
@author E. DINIZ [ DS2U ]
@since 07/10/2020
@version version
/*/
User Function GetProdCli()

Local _aArea	:= {SA1->(GetArea()),SA2->(GetArea()),SB1->(GetArea())}
Local _lAllItem	:= .F.
Local _nx		:= 0
Local oMdlZZ2	:= Nil

	If FUNNAME() == 'MATA140'

		If Len(aCols) > 1 .And. FwAlertYesNo('Deseja carregar todos os itens do Documento?','TOTVS')
			_lAllItem := .T.
		Endif

		dbSelectArea('ZZ2')
		ZZ2->(dbSetOrder(1))
		If ZZ2->(dbSeek(FWxFilial('ZZ2') + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_ITEM'})] )))
		
			oMdlZZ2 := FwLoadModel('RESTA033')
			oMdlZZ2:SetOperation(MODEL_OPERATION_UPDATE)
			oMdlZZ2:Activate()

			FWExecView( 'Dados Adicionais do Produto do Cliente - Alterar', "RESTA033", MODEL_OPERATION_UPDATE, , { || .T. }, /*bOk*/, 20, /*aEnableButtons*/, {|| .T. }/*bCancel*/, /*cOperatId*/ , /*cToolBar*/ , oMdlZZ2 )
		
		Else

			oMdlZZ2 := FwLoadModel('RESTA033')
			oMdlZZ2:SetOperation(MODEL_OPERATION_INSERT)
			oMdlZZ2:Activate()

			//CABECALHO
			oMdlZZ2:SetValue('ZZ2MASTER','ZZ2_DOC'		, SF1->F1_DOC			, .T.)
			oMdlZZ2:SetValue('ZZ2MASTER','ZZ2_SERIE'	, SF1->F1_SERIE			, .T.)
			oMdlZZ2:SetValue('ZZ2MASTER','ZZ2_CLIFOR'	, IIF(SF1->F1_TIPO$'D|B','C','F') , .T.)
			oMdlZZ2:SetValue('ZZ2MASTER','ZZ2_CLIENT'	, SF1->F1_FORNECE		, .T.)
			oMdlZZ2:SetValue('ZZ2MASTER','ZZ2_LOJA'		, SF1->F1_LOJA			, .T.)

			//ITENS
			If _lAllItem
				oMdlZZ2:GetModel('ZZ2ITENS'):SetNoInsertLine(.F.)
				For _nx := 1 To Len(aCols)
					If !(aCols[_nx][Len(aCols[_nx])])
						If Len(aCols) >= _nx .And. _nx > 1
							oMdlZZ2:GetModel("ZZ2ITENS"):AddLine()
							oMdlZZ2:GetModel("ZZ2ITENS"):GoLine( oMdlZZ2:GetModel("ZZ2ITENS"):Length() )
						Endif
						oMdlZZ2:SetValue('ZZ2ITENS','ZZ2_ITEM'	, aCols[_nx][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_ITEM' 	})]	, .T.)
						oMdlZZ2:SetValue('ZZ2ITENS','ZZ2_COD'	, aCols[_nx][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_COD'	})]	, .T.)
						oMdlZZ2:SetValue('ZZ2ITENS','ZZ2_QUANT'	, aCols[_nx][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_QUANT'	})]	, .T.)
					Endif
				Next _nx
				oMdlZZ2:GetModel('ZZ2ITENS'):SetNoInsertLine(.T.)
			Else
				oMdlZZ2:SetValue('ZZ2ITENS','ZZ2_ITEM'		, aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_ITEM' 	})]		, .T.)
				oMdlZZ2:SetValue('ZZ2ITENS','ZZ2_COD'		, aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_COD'		})]		, .T.)
				oMdlZZ2:SetValue('ZZ2ITENS','ZZ2_QUANT'		, aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == 'D1_QUANT'	})]		, .T.)
			Endif

			FWExecView( 'Dados Adicionais do Produto do Cliente - Inlcuir', "RESTA033", MODEL_OPERATION_UPDATE, , { || .T. }, /*bOk*/, 20, /*aEnableButtons*/, {|| .T. } /*bCancel*/, /*cOperatId*/ , /*cToolBar*/ , oMdlZZ2 )

		Endif
	
	Endif

	AEval(_aArea,{|x| RestArea(x)})

Return


/*/{Protheus.doc} User Function GetName
Retorna o nome do cliente/fornecedor para a Browse da rotina
@type  User Function
@author E. DINIZ [ DS2U ]
@since 07/10/2020
@version version
/*/
User Function GetName()
Return PadR( POSICIONE( IF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2'), 1, FWxFilial( IF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2')) + ZZ2->(ZZ2_CLIENT+ZZ2_LOJA), IF( ZZ2->ZZ2_CLIFOR=='C','A1_NOME','A2_NOME' )), TamSX3('ZZ2_NOME')[1] )
