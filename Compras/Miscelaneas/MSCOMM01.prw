#include 'totvs.ch'
#include 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MSCOMM01
Tela de Consulta de Preços
@type  Function
@author Masipack
@since 04/06/2020
/*/
User Function MSCOMM01()

Local _aFldSA2  := {'A2_COD','A2_LOJA','A2_NREDUZ'}
Local _aFldSC7  := {'C7_NUM','C7_EMISSAO','C7_ITEM','C7_PRODUTO','C7_QUANT','C7_PRECO','C7_TOTAL','C7_COND','C7_IPI'}
Local _aColumns := {}
Local _cAlsTmp  := ''
Local _cProduto := ''
Local _lBrowse  := .T.
Local _nX       := 0
Local _oBrw     := Nil
Local _oDlg     := Nil
Local _oTbl     := Nil

DEFAULT aCols := Nil

    _lBrowse  := !(ValType(aCols) == 'A')
    
    _cProduto := If( _lBrowse, SC7->C7_PRODUTO, aCols[n,aScan(aHeader,{|x,y| Alltrim(x[2]) == "C7_PRODUTO" })] )
    
    For _nX := 1 to Len(_aFldSA2)
        AADD(_aColumns,{_aFldSA2[_nX],TamSX3(_aFldSA2[_nX])[3],TamSX3(_aFldSA2[_nX])[1],TamSX3(_aFldSA2[_nX])[2]})
    Next _nX

    For _nX := 1 to Len(_aFldSC7)
        AADD(_aColumns,{_aFldSC7[_nX],TamSX3(_aFldSC7[_nX])[3],TamSX3(_aFldSC7[_nX])[1],TamSX3(_aFldSC7[_nX])[2]})
    Next _nX
    
    _oTbl := FWTemporaryTable():New()
    _oTbl:SetFields(_aColumns)
	_oTbl:Create()
    _cAlsTmp := _oTbl:GetAlias()

    If GetPCInfo(_lBrowse,@_cAlsTmp)
    
        DEFINE MsDialog _oDlg TITLE 'Consulta Preços | Produto: ' + _cProduto FROM 0,0 To 300,750 Pixel
        
        _oBrw := FWFormBrowse():New()
        _oBrw:SetDescription('Ultimas Compras | ' + Alltrim(POSICIONE('SB1',1,FWxFilial('SB1')+_cProduto,"B1_DESC")))
        _oBrw:SetDataTable(.T.)
        _oBrw:SetAlias(_cAlsTmp)
        _oBrw:SetOwner(_oDlg)
        _oBrw:DisableReport()
        _oBrw:DisableDetails()
        _oBrw:SetUseFilter(.F.)

        /********************************
        * Adiciona as Colunas na Browse *
        *********************************/
        _aColumns := {}
        For _nX := 1 to Len(_aFldSA2)
            AADD(_aColumns,FWBrwColumn():New())
            _aColumns[Len(_aColumns)]:SetData( &("{|| (_cAlsTmp)->" + _aFldSA2[_nX] + "}") )
            _aColumns[Len(_aColumns)]:SetTitle( RetTitle(_aFldSA2[_nX]) )
            _aColumns[Len(_aColumns)]:SetSize( TamSX3(_aFldSA2[_nX])[1] )
            _aColumns[Len(_aColumns)]:SetType( TamSX3(_aFldSA2[_nX])[3] )
            _aColumns[Len(_aColumns)]:SetDecimal( TamSX3(_aFldSA2[_nX])[2])
            _aColumns[Len(_aColumns)]:SetPicture( PesqPict('SA2',_aFldSA2[_nX]) )
        Next _nX

        For _nX := 1 to Len(_aFldSC7)
            AADD(_aColumns,FWBrwColumn():New())
            _aColumns[Len(_aColumns)]:SetData(  &("{|| (_cAlsTmp)->" + _aFldSC7[_nX] + "}") )
            _aColumns[Len(_aColumns)]:SetTitle( RetTitle(_aFldSC7[_nX]) )
            _aColumns[Len(_aColumns)]:SetSize( TamSX3(_aFldSC7[_nX])[1] )
            _aColumns[Len(_aColumns)]:SetType( TamSX3(_aFldSC7[_nX])[3] )
            _aColumns[Len(_aColumns)]:SetDecimal( TamSX3(_aFldSC7[_nX])[2])
            _aColumns[Len(_aColumns)]:SetPicture( PesqPict('SC7',_aFldSC7[_nX]) )
        Next _nX

        _oBrw:SetColumns(_aColumns)
		_oBrw:AddButton('Fechar' ,{|| _oDlg:End() })
        _oBrw:Activate()

        ACTIVATE MsDialog _oDlg CENTERED
    
    Endif

    (_cAlsTmp)->(dbCloseArea())
    _oTbl:Delete()

Return


/*/{Protheus.doc} GetPCInfo
(long_description)
@type  Static Function
@author Masipack
@since 04/06/2020
/*/
Static Function GetPCInfo(_lBrowse,_cAlsTmp)

Local _cArqSql     := GetNextAlias()
Local _cProduto   := If( _lBrowse, SC7->C7_PRODUTO, aCols[n,aScan(aHeader,{|x,y| Alltrim(x[2]) == "C7_PRODUTO" })] )
Local _nTop       := GetMV('MS_PQUANT',.F.,5)
Local _lRet       := .T.

    BeginSQL Alias _cArqSql 
    
        SELECT  TOP %Exp:_nTop% A2_COD, A2_LOJA, A2_NREDUZ, C7_NUM, C7_EMISSAO,
                C7_ITEM, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_TOTAL, C7_COND, C7_IPI
        FROM %Table:SC7% SC7, %Table:SA2% SA2
        WHERE C7_FILIAL = %xFilial:SC7%
        AND C7_TIPO = '1'
        AND C7_PRODUTO = %Exp:_cProduto%
        AND SC7.%NOTDEL%
        AND A2_COD + A2_LOJA = C7_FORNECE + C7_LOJA
        AND SA2.%NOTDEL%
        ORDER BY C7_EMISSAO DESC

    EndSql

    If !(_cArqSql)->(EOF())

        While !(_cArqSql)->(EOF())
            
            IF !Empty((_cArqSql)->A2_COD)
                (_cAlsTmp)->(DbAppend())
                (_cAlsTmp)->A2_COD      := (_cArqSql)->A2_COD
                (_cAlsTmp)->A2_LOJA     := (_cArqSql)->A2_LOJA
                (_cAlsTmp)->A2_NREDUZ   := (_cArqSql)->A2_NREDUZ
                (_cAlsTmp)->C7_NUM      := (_cArqSql)->C7_NUM
                (_cAlsTmp)->C7_EMISSAO  := STOD((_cArqSql)->C7_EMISSAO)
                (_cAlsTmp)->C7_ITEM     := (_cArqSql)->C7_ITEM
                (_cAlsTmp)->C7_PRODUTO  := (_cArqSql)->C7_PRODUTO
                (_cAlsTmp)->C7_QUANT    := (_cArqSql)->C7_QUANT
                (_cAlsTmp)->C7_PRECO    := (_cArqSql)->C7_PRECO
                (_cAlsTmp)->C7_TOTAL    := (_cArqSql)->C7_TOTAL
                (_cAlsTmp)->C7_COND     := (_cArqSql)->C7_COND
                (_cAlsTmp)->C7_IPI      := (_cArqSql)->C7_IPI
            ENDIF
            (_cArqSql)->(dbSkip())
        Enddo
    
    Else
        _lRet := .F.
        FwAlertWarning('Não foram encontrados pedidos para o produto ' + _cProduto )
    Endif
    
    (_cArqSql)->(dbCloseArea())

Return _lRet
