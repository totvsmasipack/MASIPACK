#include 'totvs.ch'

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篜rograma  ?MT120GRV  篈utor  ?                           ?02/06/2010罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篋esc.   Envia email quando houver Altera玢o no Prazo de Entrega 2018    北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
*/
User Function MT120GRV()

Local _lRet	:= .T.

	If cEmpAnt $ "01|10" .And. ParamIxb[3]
		FwMsgRun(, {|| _lRet := U_RCOMG013(ParamIxb[1])}, "Aguarde", "Checando dados do pedido " + ParamIxb[1])
	Endif

Return _lRet
