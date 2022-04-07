#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function nomeFunction
	MT160GRPC - Gravação de valores e campos no pedido de compras, logo após a geração do pedido quando analisada a cotação
@type  Function
@author E.DINIZ - [ DS2U ]
@since 07/04/2022
@see https://tdn.engpro.totvs.com.br/pages/releaseview.action?pageId=6085534
/*/
User Function MT160GRPC  

Local _aArea	:= { SC1->(GetArea()), SB1->(GetArea()), SA2->(GetArea()) }

	If FieldPos('C7_PRECO') > 0
		SC7->C7_PRECO	:= U_RCOMG016( SC7->C7_PRODUTO )
	Endif

	If FieldPos('C7_RETFOR') > 0	
		SC7->C7_RETFOR	:= 'N'
	Endif

	AEval(_aArea,{ |x| RestArea(x) })

Return
