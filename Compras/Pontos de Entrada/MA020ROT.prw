#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MA020ROT
    Ponto de entrada para adicionar botões ao cadastro de fornecedor.
    @type  Function
    @author Fernando Corrêa (DS2U)
    @since 13/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function MA020ROT()
    
    Local aButtons 		:= {} // botões a adicionar
    Local cFilCust      := SUPERGETMV( "ES_MSPENDF",,'01|10' )

    If cEmpAnt $ cFilCust
        AAdd(aButtons,{ 'Pendencia Financeira.' ,  'u_RCOMA025()'  , 0, 4 } )
    EndIf 

Return aButtons 
