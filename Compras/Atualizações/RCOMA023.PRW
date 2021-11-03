#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RCOMA023
	Função para alterar a Data de Entrega dos Pedidos de Compras em massa
@type  Function
@author E.DINIZ - [ DS2U ]
@since 29/09/2021
@version version
/*/
User Function RCOMA023()

Local _aField	:= {}
Local _aIndex	:= {}
Local _aMvPar	:= {}
Local _aSeekSC7	:= {}
Local _cAlias	:= ""
Local _cQuery	:= ""
Local _cTitle	:= ""
Local _nX		:= 0
Local _oBrowse	:= Nil
Local _oCol		:= Nil
Local _oDlg		:= Nil
Local _oLayer	:= Nil
Local _oModal	:= Nil

Private _lMarkAll := .T.

	For _nX := 1 To 60
		AADD( _aMvPar, &( "MV_PAR" + StrZero( _nX, 2, 0 ) ) )
	Next _nX

	_aField		:= {'C7_MARK','C7_NUM','C7_ITEM','C7_PRODUTO','C7_FORNECE','C7_LOJA','C7_OBS','C7_DATPRF'}
	_aIndex		:= {'C7_NUM'}
	_aSeekSC7	:= {{ 'Pedido', {{'Pedido','C',TamSx3('C7_NUM')[1],0,'',,}} }}

	_cAlias		:= GetNextAlias()
	_cTitle		:= 'Alteração da Data de Entrega'
	_cQuery		:= DefQuery(_aField)

	If !Empty(_cQuery)

		_oDlg		:= CreateModal()
		_oModal		:= _oDlg:GetPanelMain()

		_oLayer := FWLayer():New()
		_oLayer:Init(_oModal, .F., .T.)
		_oLayer:AddLine('LIN1',100, .F.)
		_oLayer:AddCollumn('COL1', 100, .F., 'LIN1')
		
		_oBrowse := FWFormBrowse():New()
		_oBrowse:SetOwner(_oLayer:GetColPanel("COL1","LIN1"))
		_oBrowse:SetDescription(_cTitle)
		_oBrowse:SetAlias(_cAlias)
		_oBrowse:SetDataQuery(.T.)
		_oBrowse:SetQuery(_cQuery)
		_oBrowse:AddMarkColumns( {||IIf((_cAlias)->C7_MARK == 'X', "LBTIK", "LBNO")},;
								 {|| (_cAlias)->C7_MARK := IIF((_cAlias)->C7_MARK == 'X','','X') },;
								 {|| _lMarkAll := !(_lMarkAll), (_cAlias)->(DbGoTop()), (_cAlias)->( DbEval( {|| C7_MARK := IIF(_lMarkAll,'X','') }, {|| .T. }, {|| (_cAlias)->(!EOF()) })), _oBrowse:GoTop(.T.) })
		_oBrowse:AddButton('Confirmar',	{|| IF( FwAlertYesNo('Confirma a alteração da Data de Entrega dos pedidos selecionados?',"ATENÇÃO"), (Processa({|lEnd| ProcRegua(0), DateChange(@_cAlias) },"Aguarde..","",.F.), _oDlg:DeActivate()), Nil) })
		_oBrowse:AddButton('Fechar',	{|| _oDlg:DeActivate() })
		_oBrowse:SetQueryIndex(_aIndex)
		_oBrowse:SetSeek(,_aSeekSC7)
		_Obrowse:DisableDetails(0)

		For _nX := 1 To Len(_aField)
			If !(_aField[_nX] == 'C7_MARK')
				_oCol := FWBrwColumn():New()
				If TamSX3(_aField[_nX])[3] == 'D'
					_oCol:SetData( &("{|| DTOC(STOD((_cAlias)->" + _aField[_nX] + ")) }") )
				Else
					_oCol:SetData( &("{|| (_cAlias)->" + _aField[_nX] + " }") )
				Endif
				_oCol:SetTitle( RetTitle(_aField[_nX]) )
				_oCol:SetType( TamSX3(_aField[_nX])[3] )
				_oCol:SetSize( TamSX3(_aField[_nX])[1] )
				_oCol:SetDecimal( TamSX3(_aField[_nX])[2] )
				_oCol:SetPicture( PesqPict('SC7',_aField[_nX]) )
				_oBrowse:SetColumns({_oCol})
			Endif
		Next _nX

		_oCol := FWBrwColumn():New()
		_oCol:SetTitle( 'Nova Entrega' )
		_oCol:SetData( {|| MV_PAR01 } )
		_oCol:SetType( TamSX3('C7_DATPRF')[3] )
		_oCol:SetSize( TamSX3('C7_DATPRF')[1] )
		_oCol:SetDecimal( TamSX3('C7_DATPRF')[2] )
		_oCol:SetPicture( PesqPict('SC7','C7_DATPRF') )
		_oBrowse:SetColumns({_oCol})

		_oBrowse:Activate()

		_oDlg:Activate()
	
	Endif

	For _nX := 1 To Len( _aMvPar )
		&( "mv_par" + StrZero( _nX, 2, 0 ) ) := _aMvPar[ _nX ]
	Next _nX

Return



/*/{Protheus.doc} CreateMotal
	Função para a criação da Modal
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 29/09/2021
/*/
Static Function CreateModal()

Local _aCoord	:= FWGetDialogSize()
Local uRet

    uRet := FwDialogModal():New()
	uRet:SetBackground(.T.)
	uRet:SetEscClose(.T.)
    uRet:SetPos(_aCoord[1], _aCoord[2])
    uRet:SetSize(_aCoord[3]/2.1, _aCoord[4]/2.5)
    uRet:CreateDialog()

Return uRet


/*/{Protheus.doc} DefQuery
	Definição da query para utilização na Browse
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 29/09/2021
/*/
Static Function DefQuery(_aField)

Local _cField	:= ""
Local _cPerg	:= "MSCOMA023"
Local _cRet		:= ""

	If Pergunte(_cPerg, .T.)

		AEval(_aField,{|x| _cField += IIF( x == 'C7_MARK', "'X' [C7_MARK]", x) + ',' })

		_cRet := "SELECT	" + SubStr(_cField, 1, RAT(',',_cField)-1) + SPACE(1)
		_cRet += "FROM	" + RetSqlName('SC7') + CRLF
		_cRet += "WHERE	C7_FILIAL	=	'"+FWxFilial('SC7')+"'			AND" + CRLF
		_cRet += "		C7_FORNECE	BETWEEN	'"+MV_PAR02+"'	AND	'"+MV_PAR04+"'	AND" + CRLF
		_cRet += "		C7_LOJA		BETWEEN	'"+MV_PAR03+"'			AND '"+MV_PAR05+"'		AND" + CRLF
		_cRet += "		C7_NUM		NOT IN (SELECT	E2_NUM" + CRLF
		_cRet += "							FROM	"+RetSqlName('SE2') + CRLF 
		_cRet += "							WHERE	E2_FILIAL	=	'"+FWxFilial('SE2')+"'		AND" + CRLF
		_cRet += "									E2_PREFIXO	=	'999'		AND" + CRLF
		_cRet += "									E2_NUM		=	C7_NUM		AND" + CRLF
		_cRet += "									E2_FORNECE	=	C7_FORNECE	AND" + CRLF
		_cRet += "									E2_LOJA		=	C7_LOJA		AND" + CRLF
		_cRet += "									E2_TIPO		=	'PA'		AND" + CRLF
		_cRet += "									D_E_L_E_T_	= ' '" + CRLF
		_cRet += ") AND" + CRLF
		_cRet += "		C7_COND		=	'"+MV_PAR06+"'			AND" + CRLF
		_cRet += "		C7_QUANT	>	C7_QUJE			AND" + CRLF
		_cRet += "		C7_RESIDUO	=	' '				AND" + CRLF
		_cRet += "		D_E_L_E_T_	=	' '" + CRLF
		_cRet += "ORDER BY C7_NUM, C7_ITEM" + CRLF

		_cRet := ChangeQuery(_cRet)

	Endif

Return _cRet


/*/{Protheus.doc} DateChange
	Efetua a alteração da Data de Entrega do Pedido de Compras
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 29/09/2021
/*/
Static Function DateChange(_cAlias)

Local _aArea	:= SC7->(GetArea())

	SC7->(DbSetOrder(1))

	While (_cAlias)->(!EOF())

		SC7->(DbSeek( FWxFilial('SC7') + (_cAlias)->( C7_NUM + C7_ITEM ) ))

		If !Empty((_cAlias)->C7_MARK) .And. SC7->(FOUND())
			Reclock('SC7',.F.)
			SC7->C7_DATPRF := MV_PAR01
			SC7->(MsUnlock())
		Endif
		
		(_cAlias)->(dbSkip())
	Enddo

	RestArea(_aArea)

Return
