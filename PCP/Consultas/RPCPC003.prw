#include 'totvs.ch'
#include 'protheus.ch'
#include 'TopConn.ch'

/*/{Protheus.doc} User Function RPCPC003
Consulta Empenhos e Pedidos de Compras em Aberto
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/12/2021
/*/
User Function RPCPC003()

Local aPerg     := {}
Local aPanel	:= Array(3)
Local cQuery	:= ''
Local oDlg		:= Nil

Private aField		:= Array(3)
Private aEmpeOP		:= {}
Private aPedido		:= {}
Private oBrw1		:= Nil
Private oBrw2		:= Nil
Private oBrw3		:= Nil

	AADD(aPerg,{1, "Produto de",	SPACE( FWSX3Util():GetFieldStruct( 'B1_COD' )[3] ),		"@!",	".T.",	"SB1",	".T.",	80,	.F.})
	AADD(aPerg,{1, "Produto até",	SPACE( FWSX3Util():GetFieldStruct( 'B1_COD' )[3] ),		"@!",	".T.",	"SB1",	".T.",	80,	.F.})
	AADD(aPerg,{1, "Tipo de",		SPACE( FWSX3Util():GetFieldStruct( 'B1_TIPO' )[3] ),	"@!",	".T.",	"02",	".T.",	30,	.F.})
	AADD(aPerg,{1, "Tipo até",		SPACE( FWSX3Util():GetFieldStruct( 'B1_TIPO' )[3] ),	"@!",	".T.",	"02",	".T.",	30,	.F.})
	AADD(aPerg,{1, "Grupo de",		SPACE( FWSX3Util():GetFieldStruct( 'B1_GRUPO' )[3] ),	"@!",	".T.",	"SBM",	".T.",	40,	.F.})
	AADD(aPerg,{1, "Grupo até",		SPACE( FWSX3Util():GetFieldStruct( 'B1_GRUPO' )[3] ),	"@!",	".T.",	"SBM",	".T.",	40,	.F.})
	AADD(aPerg,{2, "Pedidos c/ Res. Eliminado?",	1, {"1=Sim", "2=Não"},	090, ".T.", .F.})

	If ParamBox(aPerg, "Compras x Necessidades",,,,,,,,.F.,.F.)
		
		aField[1] := "B1_COD,B1_DESC,B1_UM,B1_LOCPAD,B1_LOCAL,B1_PRODSBP,B1_ESTSEG,B1_LE,B1_LM,B1_MSBLQL,B2_QATU,B2_QEMP,B2_RESERVA"
		aField[2] := "C7_NUM,C7_ITEM,C7_PRODUTO,C7_QUANT,C7_QUJE,C7_EMISSAO,C7_DATPRF,C7_RESIDUO"
		aField[3] := "D4_OP,D4_COD,D4_QUANT,D4_QTDEORI"
		
		cQuery := DefineQuery(aField[1],'')

		oDlg := GetDialog(@aPanel)

		DefineView(1, @oDlg, aPanel, aField, cQuery)
		oBrw1:Activate()
		
		cQuery := DefineQuery(aField[2], (oBrw1:Alias())->B1_COD)
		GetPedido(cQuery)
		DefineView(2, @oDlg, aPanel, aField, '')
		oBrw2:Activate()
		
		cQuery := DefineQuery(aField[3], (oBrw1:Alias())->B1_COD)
		GetEmpOP(cQuery)
		DefineView(3, @oDlg, aPanel, aField, '')		
		oBrw3:Activate()

		oDlg:Activate()

	Endif

Return


/*/{Protheus.doc} User Function GetDialog
Função para definição do Dialog da consulta
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/12/2021
/*/
Static Function GetDialog(aPanel)

Local aCoord	:= FWGetDialogSize()
Local oLayer	:= Nil
Local oRet		:= Nil

	oRet := FwDialogModal():New()
	oRet:SetEscClose(.F.)
	oRet:SetPos(aCoord[1], aCoord[2])
	oRet:SetSize(aCoord[3]/2, aCoord[4]/2) //altura x largura
	oRet:CreateDialog()
	oRet:AddButtons({{"", "Fechar", {|| oRet:DeActivate() }, , , .T., .F. }})

	oLayer := FWLayer():New()
	oLayer:Init(oRet:GetPanelMain(), .F.)

	oLayer:AddLine("L01", 040, .T.)
	oLayer:AddLine("L02", 060, .T.)

	oLayer:AddCollumn("L01CABE", 100, .F., "L01")
	oLayer:AddCollumn("L01PEDC", 050, .F., "L02")
	oLayer:AddCollumn("L01ORDP", 050, .F., "L02")

	oLayer:AddWindow("L01CABE", "L01CABE", "", 100, .F., .F., /*bAction*/, "L01", /*bGotFocus*/)
	oLayer:AddWindow("L01PEDC", "L01PEDC", "Pedido de Compra", 100, .F., .F., /*bAction*/, "L02", /*bGotFocus*/)
	oLayer:AddWindow("L01ORDP", "L01ORDP", "Empenho da Ordem de Produção", 100, .F., .F., /*bAction*/, "L02", /*bGotFocus*/)

	aPanel[1] := oLayer:GetWinPanel("L01CABE"  ,"L01CABE"	,"L01")	//oLayer:GetColPanel("L01CABE","L01")
	aPanel[2] := oLayer:GetWinPanel("L01PEDC"  ,"L01PEDC"	,"L02") //oLayer:GetColPanel("L01PEDC","L02")
	aPanel[3] := oLayer:GetWinPanel("L01ORDP"  ,"L01ORDP"	,"L02") //oLayer:GetColPanel("L01ORDP","L02")

Return oRet


/*/{Protheus.doc} User Function DefineQuery
Função para definição da query da consulta
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/12/2021
/*/
Static Function DefineQuery(cField, cProduto)

Local cRet	:= ''
	
	cRet	:= "SELECT " + cField
	cRet	+= "FROM " + RetSQLName('SD4') + " D4 "
	cRet	+= "	INNER JOIN " + RetSQLName('SC7') + " C7 ON "
	cRet	+= "	C7_FILIAL		= D4_FILIAL AND "
	cRet	+= "	C7_PRODUTO		= D4_COD	AND "
	cRet	+= "	C7_QUANT		> C7_QUJE	AND "
	If MV_PAR07 == '2'
		cRet	+= "	C7_RESIDUO		!= 'S'		AND "
	Endif
	cRet	+= "	C7.D_E_L_E_T_	= ' ' "
	cRet	+= "	INNER JOIN " + RetSQLName('SB1') + " B1 ON "
	cRet	+= "	B1_FILIAL		= D4_FILIAL  AND "
	cRet	+= "	B1_COD			= C7_PRODUTO AND "
	cRet	+= "	B1.D_E_L_E_T_	= ' ' "
	cRet	+= "	INNER JOIN " + RetSQLName('SB2') + " B2 ON "
	cRet	+= "	B2_FILIAL		= B1_FILIAL  AND "
	cRet	+= "	B2_COD			= B1_COD AND "
	cRet	+= "	B2_LOCAL		= B1_LOCPAD AND "
	cRet	+= "	B2.D_E_L_E_T_	= ' ' "
	cRet	+= "WHERE	D4_FILIAL	= '"+FWxFilial('SD4')+"'		AND "
	If Empty(cProduto)
		cRet	+= "	D4_COD 			BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02+ "' AND "
		cRet	+= "	B1_TIPO			BETWEEN '" +MV_PAR03+ "' AND '" +MV_PAR04+ "' AND "
		cRet	+= "	B1_GRUPO		BETWEEN '" +MV_PAR05+ "' AND '" +MV_PAR06+ "' AND "
	Else
		cRet	+= "	C7_PRODUTO		= '"+cProduto+"' AND "
		cRet	+= "	D4_COD			= '"+cProduto+"' AND "
	Endif
	cRet	+= "	D4_QUANT	> 0	AND "
	cRet	+= "	D4.D_E_L_E_T_	= ' ' "
	cRet	+= "GROUP BY " + cField
	cRet	+= "ORDER BY " + cField

	cRet := ChangeQuery(cRet)

Return cRet


/*/{Protheus.doc} User Function DefineView
Função para definição das seções da consulta
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/12/2021
/*/
Static Function DefineView(nOpc, oDlg, aPanel, aField, cQuery)

Local aAux	:= {}
Local aIdx	:= {}
Local aSeek	:= {}
Local cTRB	:= ''
Local nPos	:= 0
Local oCol	:= Nil

	If nOpc == 1

		cTRB := GetNextAlias()

		oBrw1 := FWFormBrowse():New()
		oBrw1:SetOwner(aPanel[nOpc])
		oBrw1:SetAlias(cTRB)
		oBrw1:SetDataQuery(.T.)
		oBrw1:SetQuery(cQuery)
		oBrw1:DisableDetails()
		oBrw1:DisableReport()
		
		oBrw1:SetChange( {|| LoadCompras() } )
		
		aIdX := {"B1_COD", "B1_DESC"}
		oBrw1:SetQueryIndex(aIdx)
		
		AADD(aSeek,{"Código",	{{"","C",FWSX3Util():GetFieldStruct( 'B1_COD' )[3],	0,"B1_COD",	"@!"}}})
		AADD(aSeek,{"Descrição",{{"","C",FWSX3Util():GetFieldStruct( 'B1_DESC' )[3],0,"B1_DESC","@!"}}})
		oBrw1:SetSeek(,aSeek)

		oBrw1:AddLegend( "(oBrw1:Alias())->B1_MSBLQL == '1'", "RED", 	"Produto Bloqueado" )
		oBrw1:AddLegend( "(oBrw1:Alias())->B1_MSBLQL <> '1'", "GREEN",	"Produto Ativo" )

		aAux := StrTokArr( aField[nOpc], "," ) 
		For nPos := 1 To Len(aAux)
			If !(Alltrim(aAux[nPos]) $ 'B1_MSBLQL|C7_RESIDUO')
			
				oCol := FWBrwColumn():New()
				oCol:SetTitle( RetTitle(Alltrim(aAux[nPos])) )
				oCol:SetData( &("{|| (oBrw1:Alias())->" + Alltrim(aAux[nPos]) + " }") )
				oCol:SetType( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[2] )
				oCol:SetSize( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[3] )
				oCol:SetDecimal( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[4] )
				
				If Alltrim(aAux[nPos]) == 'B1_PRODSBP'
					oCol:SetOptions({'C=Comprando','P=Produzindo'})
				ElseIf Alltrim(aAux[nPos]) == 'C7_RESIDUO'
					oCol:SetOptions({'S=Sim','N=Não'})
				Endif
				
				oCol:SetPicture( PesqPict( IIF(SubStr(Alltrim(aAux[nPos]),1,2) == 'B1', 'SB1', IIF(SubStr(Alltrim(aAux[nPos]),1,2) == 'C7','SC7','SB2')), Alltrim(aAux[nPos]) ) )
				oBrw1:SetColumns({oCol})
			
			Endif
		Next nPos
	
	ElseIf nOpc == 2

		oBrw2 := FWBrowse():New(aPanel[nOpc])
		oBrw2:DisableConfig()
		oBrw2:DisableReport()
		oBrw2:SetDataArray()
		oBrw2:SetArray(aPedido)

		aIdX := {"C7_NUM"}
		oBrw2:SetQueryIndex(aIdx)
		
		AADD(aSeek,{"N Pedido",	{{"",	"C",	FWSX3Util():GetFieldStruct( 'C7_NUM' )[3],	0,	"C7_NUM",	"@!"}}})
		oBrw2:SetSeek(,aSeek)

		aAux := StrTokArr( aField[nOpc], "," ) 
		For nPos := 1 To Len(aAux)
			If !(Alltrim(aAux[nPos]) $ 'C7_RESIDUO')
			
				oCol := FWBrwColumn():New()
				oCol:SetTitle( RetTitle(Alltrim(aAux[nPos])) )
				oCol:SetType( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[2] )
				oCol:SetSize( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[3] )
				oCol:SetDecimal( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[4] )
				
				If FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[2] == 'D'
					oCol:SetData( &(" { || DTOC(STOD(aPedido[oBrw2:At(),"+ cValToChar(nPos) +"])) }") )
				Else
					oCol:SetData( &(" { || aPedido[oBrw2:At(),"+ cValToChar(nPos) +"]}") )
				Endif

				oCol:SetPicture( PesqPict('SC7', Alltrim(aAux[nPos]) ))
				oBrw2:SetColumns({oCol})
			
			Endif
		Next nPos

	ElseIf nOpc == 3

		oBrw3 := FWBrowse():New(aPanel[nOpc])
		oBrw3:DisableConfig()
		oBrw3:DisableReport()
		oBrw3:SetDataArray()
		oBrw3:SetArray(aEmpeOP)

		aIdX := {"D4_OP"}
		oBrw3:SetQueryIndex(aIdx)
		
		AADD(aSeek,{"Ord Producao",	{{"",	"C",	FWSX3Util():GetFieldStruct( 'D4_OP' )[3],	0,	"D4_OP",	"@!"}}})
		oBrw3:SetSeek(,aSeek)

		aAux := StrTokArr( aField[nOpc], "," ) 
		For nPos := 1 To Len(aAux)
					
			oCol := FWBrwColumn():New()
			oCol:SetTitle( RetTitle(Alltrim(aAux[nPos])) )
			oCol:SetType( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[2] )
			oCol:SetSize( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[3] )
			oCol:SetDecimal( FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[4] )
			
			If FWSX3Util():GetFieldStruct( Alltrim(aAux[nPos]) )[2] == 'D'
				oCol:SetData( &(" { || DTOC(STOD(aEmpeOP[oBrw3:At(),"+ cValToChar(nPos) +"])) }") )
			Else
				oCol:SetData( &(" { || aEmpeOP[oBrw3:At(),"+ cValToChar(nPos) +"]}") )
			Endif
			
			oCol:SetPicture( PesqPict( 'SD4', Alltrim(aAux[nPos]) ) )
			oBrw3:SetColumns({oCol})
			
		Next nPos

	Endif
	
	

Return

/*/{Protheus.doc} User Function LoadCompras
Função para alterar de acordo com o produto posicionado
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/12/2021
/*/
Static Function LoadCompras()

Local cQuery	:= ""

	If FwIsInCallStack('OnMove')
		cQuery := DefineQuery(aField[2], (oBrw1:Alias())->B1_COD)
		GetPedido(cQuery)
		
		cQuery := DefineQuery(aField[3], (oBrw1:Alias())->B1_COD)
		GetEmpOP(cQuery)
	Endif

Return


/*/{Protheus.doc} User Function GetPedido
Função para atualizar o browse do pedido de compras
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/12/2021
/*/
Static Function GetPedido(cQuery)

Local cAlias 	:= GetNextAlias()
Local lUpdate	:= .F.

	If Len(aPedido) > 0
		aPedido := {}
		lUpdate := .T.
	Endif

	TCQUERY cQuery NEW ALIAS (cAlias)
	(cAlias)->(DbEval( {|| Aadd(aPedido, { C7_NUM, C7_ITEM, C7_PRODUTO, C7_QUANT, C7_QUJE, C7_EMISSAO, C7_DATPRF, C7_RESIDUO }) } ))
	(cAlias)->(DbCloseArea())

	If lUpdate
		oBrw2:Refresh()
	Endif
	
Return


/*/{Protheus.doc} User Function GetEmpOP
Função para atualizar o browse dos empenhos
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/12/2021
/*/
Static Function GetEmpOP(cQuery)

Local cAlias := GetNextAlias()
Local lUpdate	:= .F.
	
	If Len(aEmpeOP) > 0
		aEmpeOP := {}
		lUpdate := .T.
	Endif
	
	TCQUERY cQuery NEW ALIAS (cAlias)
	(cAlias)->(DbEval( {|| Aadd(aEmpeOP,{ D4_OP,D4_COD,D4_QUANT,D4_QTDEORI }) } ))
	(cAlias)->(DbCloseArea())

	If lUpdate
		oBrw3:Refresh()
	Endif
	
Return
