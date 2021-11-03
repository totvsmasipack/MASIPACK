#include 'totvs.ch'


/*/{Protheus.doc} User Function RCOMG014
Função para validar a data da entrega informada no pedido de compras
@type  Function
@author E.DINIZ
@since 02/08/2021
/*/
User Function RCOMG014()

Local _cAlert	:= 'Os itens abaixo estão com a Data de Entrega Anterior a Data Atual:' + CRLF + CRLF
Local _cHelp	:= 'Para efetivar a inclusão/alteração do pedido, ajuste a Data de Entrega dos itens mencionados acima para uma data posterior à ' + DTOC(dDataBase)
Local _lRet     := .T.
Local _nDtEnt	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == 'C7_DATPRF'	})
Local _nItem	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == 'C7_ITEM'	})
Local _nQtde	:= aScan(aHeader,{|x| Alltrim(x[2]) == 'C7_QUANT'	})
Local _nQuje	:= aScan(aHeader,{|x| Alltrim(x[2]) == 'C7_QUJE'	})
Local _nPos		:= 0

	For _nPos := 1 To Len(aCols)
		If dDataBase > aCols[_nPos][_nDtEnt] .And. !(aCols[_nPos][Len(aCols[_nPos])]) .And. aCols[_nPos][_nQtde] > aCols[_nPos][_nQuje]
			_lRet	:= .F.
			_cAlert += 'Item ' + aCols[_nPos][_nItem] + ' | Entrega: ' + DTOC(aCols[_nPos][_nDtEnt]) + CRLF
		Endif
	Next _nPos

	If !(_lRet)
		Help(Nil, Nil, "ENTRANTIGA", Nil, _cAlert, 1, 0, Nil, Nil, Nil, Nil, Nil, {_cHelp} )
	Endif

Return _lRet
