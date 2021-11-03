#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function MT380GRV
Ponto de Entrada executado enquanto ocorre a gravação dos empenhos na tabela SD4
(Não é necessário usar o reclock, pois o mesmo está ativo na função padrão.)
@type  Function
@author E.DINIZ - [ DS2U ]
@since 18/10/2021
/*/
User Function MT380GRV()

Local _aArea	:= { SB1->(GetArea()), SB2->(GetArea()), SC2->(GetArea()), SD4->(GetArea()) }

    //*******************************************
	//* PROCESSA A MARCAÇÃO DA LISTA DE FALTA	*
	//*******************************************
	FwMsgRun(,{|| U_RESTG006({ FWCodEmp(), FUNNAME(), SD4->D4_OP }) }, 'Aguarde..','Processando dado(s) do(s) empenho(s)')

	AEval(_aArea,{ |x| RestArea(x) })

Return
