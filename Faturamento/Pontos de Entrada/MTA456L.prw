#include "totvs.ch" 

/*/{Protheus.doc} MTA456L
(long_description)
@type  Function
@author user
@since 21/04/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function MTA456L()

Local _nOpcx    := PARAMIXB[1]

Default cEmpAnt	:= "01"
 
	IF cEmpAnt $ "01|10" .And. _nOpcx == 4
		If U_MUDACOR()
			U_SndLibCred(SC9->C9_PEDIDO)
		Endif
	Endif

Return