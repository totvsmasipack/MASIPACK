#include "totvs.ch"

/*/{Protheus.doc} A410EXC
	RETORNA SE DEVE EXCLUIR O PEDIDO DE VENDAS
@type  Function
@author user
@since 18/10/2019
@version version
@param param_name, param_type, param_descr
@return Retorna um valor lógico. Se retornar .F. impede a exclusão do Pedido de Venda.
@example
(examples)
@see (links_or_references)
/*/
User Function A410EXC()

Local aAreaSC6	:= SC6->(GetArea())
Local lRet		:= .T.

	If cEmpAnt $ "01|10"
		FwMsgRun(,{|| lRet := U_RFATG062(), "", "Validando Exclusão.." })	//Verifica se o pedido pode ser excluído ou não
	Endif
	
	RestArea(aAreaSC6)

Return lRet