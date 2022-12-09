#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'

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

	_cTitle		:= 'TOTVS | Alteração da Data de Entrega'
	_cAlias		:= DefQuery(_aField)

	If _cAlias <> "" //Quando clicar em cancelar na dialog dos parametros
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
		_oBrowse:SetDataTable(.T.)
		_oBrowse:SetTemporary(.F.)
		_oBrowse:AddMarkColumns( {||IIf((_cAlias)->C7_MARK == 'X', "LBTIK", "LBNO")},;
								 {|| RecLock((_cAlias),.F.), (_cAlias)->C7_MARK := IIF((_cAlias)->C7_MARK == 'X','','X'), (_cAlias)->(MsUnlock()) },;
								 {|| _lMarkAll := !(_lMarkAll), (_cAlias)->(DbGoTop()), RecLock((_cAlias),.F.), (_cAlias)->( DbEval( {|| C7_MARK := IIF(_lMarkAll,'X',''), (_cAlias)->(MsUnlock()) }, {|| .T. }, {|| (_cAlias)->(!EOF()) })), _oBrowse:GoTop(.T.) })
		_oBrowse:AddButton('Confirmar',	{|| IF( FwAlertYesNo('Confirma a alteração da Data de Entrega dos pedidos selecionados?',"ATENÇÃO"), (Processa({|lEnd| ProcRegua(0), DateChange(@_cAlias) },"Aguarde..","",.F.), _oDlg:DeActivate()), Nil) })
		_oBrowse:AddButton('Fechar',	{|| _oDlg:DeActivate() })
		_oBrowse:SetQueryIndex(_aIndex)
		_oBrowse:SetSeek(,_aSeekSC7)
		_Obrowse:DisableDetails(0)

		For _nX := 1 To Len(_aField)
			If !(_aField[_nX] == 'C7_MARK')
				_oCol := FWBrwColumn():New()
				_oCol:SetData( &("{|| (_cAlias)->" + _aField[_nX] + " }") )
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
	EndIf

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
    uRet:SetSize(_aCoord[3]/2.6, _aCoord[4]/2.5)
	uRet:EnableFormBar(.F.)
    uRet:CreateDialog()

Return uRet


/*/{Protheus.doc} DefQuery
	Definição da query para utilização na Browse
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 29/09/2021
/*/
Static Function DefQuery(_aField)

Local _aCpoC7	:= {}
Local _cField	:= ''
Local _cPerg	:= 'MSCOMA023'
Local _cTRB		:= GetNextAlias()
Local _cRet		:= ''
Local _oTable	:= Nil

	If Pergunte(_cPerg, .T.)

		AEval(_aField,{|x| _cField += IIF( x == 'C7_MARK', "'X' [C7_MARK]", x) + ',' })
		_cField := '%' + SubStr(_cField, 1, RAT(',',_cField)-1) + '%'

		AEval(_aField,{|x| IIF(	x == 'C7_MARK',	AADD(_aCpoC7,{ Alltrim(x), 'C', 1, 0 }) , ;
												AADD(_aCpoC7,{ Alltrim(x), TamSX3(x)[3], TamSX3(x)[1],TamSX3(x)[2] }) ) })

		_oTable := FWTemporaryTable():New()  
		_oTable:SetFields(_aCpoC7)
		_oTable:Create() 	

		BEGINSQL ALIAS _cTRB

			SELECT	%Exp:_cField%
			FROM	%Table:SC7% SC7
			WHERE	SC7.C7_FILIAL	=	%xFilial:SC7%							AND
					SC7.C7_FORNECE	BETWEEN	%Exp:MV_PAR02%	AND	%Exp:MV_PAR04%	AND
					SC7.C7_LOJA		BETWEEN	%Exp:MV_PAR03%	AND %Exp:MV_PAR05%	AND
					SC7.C7_NUM		NOT IN (	
											SELECT	FIE_NUM
											FROM	%Table:FIE% FIE
											WHERE	FIE_FILIAL	=	SC7.C7_FILIAL	AND
													FIE_CART	=	%Exp:'P'%		AND
													FIE_PEDIDO	=	SC7.C7_NUM		AND
													FIE_TIPO	=	%Exp:'PA'%		AND
													FIE_FORNEC	=	SC7.C7_FORNECE	AND
													FIE_LOJA	=	SC7.C7_LOJA		AND
													FIE.%NOTDEL%
										) 				AND
					SC7.C7_COND		=	%Exp:MV_PAR06%	AND
					SC7.C7_QUANT	>	SC7.C7_QUJE		AND
					SC7.C7_RESIDUO	=	%Exp:''%		AND
					SC7.%NOTDEL%
			ORDER BY C7_NUM, C7_ITEM
		
		ENDSQL

		While (_cTRB)->(!EOF())
			
			(_oTable:GetAlias())->(dbAppend(.T.))
			(_oTable:GetAlias())->C7_MARK		:= (_cTRB)->C7_MARK
			(_oTable:GetAlias())->C7_NUM		:= (_cTRB)->C7_NUM
			(_oTable:GetAlias())->C7_ITEM		:= (_cTRB)->C7_ITEM
			(_oTable:GetAlias())->C7_PRODUTO	:= (_cTRB)->C7_PRODUTO
			(_oTable:GetAlias())->C7_FORNECE	:= (_cTRB)->C7_FORNECE
			(_oTable:GetAlias())->C7_LOJA		:= (_cTRB)->C7_LOJA
			(_oTable:GetAlias())->C7_OBS		:= (_cTRB)->C7_OBS
			(_oTable:GetAlias())->C7_DATPRF		:= STOD((_cTRB)->C7_DATPRF)

			(_cTRB)->(DbSkip())
		
		Enddo

		_cRet := (_oTable:GetAlias())

	Endif

	If Select(_cTRB) > 0
		(_cTRB)->(DbCloseArea())
	else
		Return _cRet //Retornara caractere ""
	EndIf

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
