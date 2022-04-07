#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function MT120ISC
	MT120ISC - Manipula o acols do pedido de compras no retorno da escolha da SC
@type  Function
@author E.DINIZ - [ DS2U ]
@since 07/04/2022
@see https://tdn.totvs.com/display/PROT/MT120ISC+-++Manipula+o+acols+do+pedido+de+compras
/*/
User Function MT120ISC()

Local _aArea	:= {SC1->(GetArea()), SC7->(GetArea())}
Local _nRetFor	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_RETFOR"})	//Identifica o campo Retorno do Fornecedor
Local _nUltPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})		//Identifica o campo Preço Unitário
Local _nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})	//Identifica o campo do código do Produto

	If _nRetFor > 0
		aCols[N][_nRetFor] 	:= 'N'
	Endif

	If _nPosPrd > 0 .And. _nUltPrc > 0
		aCols[N][_nUltPrc] 	:= U_RCOMG016( aCols[N][_nPosPrd] )
	Endif

	AEval(_aArea,{|x| RestArea(x) })

Return
