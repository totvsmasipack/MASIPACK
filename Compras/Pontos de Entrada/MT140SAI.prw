#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function MT140SAI
P.E. utilizado na rotina MATA140 logo após o término do processamento das Inclusões / Alterações / Exclusões
@type  Function
@author E.DINIZ - [ DS2U ]
@since 28/10/2021
/*/
User Function MT140SAI()

Local _aArea	:= { SF1->(GetArea()), SD1->(GetArea()), ZN0->(GetArea()) }
Local _lDelete	:= PARAMIXB[1] == 5
	
	//Rotina para alterar status da NF no NFESync quando a Pré-Nota for excluída
	If _lDelete
		FwMsgRun(, {|oSay| u_RCOMG015( oSay, { PARAMIXB[2], PARAMIXB[3], PARAMIXB[6], PARAMIXB[4], PARAMIXB[5] } , Sleep(5000))}, 'Aguarde', 'Validando documento no NFESync..')
	Endif

	AEval(_aArea,{|x| RestArea(x) })

Return
