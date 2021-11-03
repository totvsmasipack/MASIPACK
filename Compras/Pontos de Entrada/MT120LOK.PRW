#include 'totvs.ch'
#include 'protheus.ch'

/*/
{PROJETO} - MT120LOK.PRW
@desc:		Ponto de entrada para validação de linhas na rotina de pedido de compra.   
@author:	E.DINIZ - [ DS2U ]
@version: 	1.00
@since: 	04.08.2021
/*/
User Function MT120LOK()

Local _lRet := .T.

    If FwIsInCallStack('TUDOOK') .And. ( INCLUI .OR. ALTERA ) .And. cEmpAnt $ "01|10"
		FwMsgRun(, {|| _lRet := U_RCOMG014()}, "Aguarde", "Analisando as Datas de Entrega..")
	Endif

Return _lRet
