/*/{Protheus.doc} User Function RPCPC004
    Rotina para forçar numeração da referencia em caso de necessidade de correção.
    @type  Function
    @author user
    @since 27/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RPCPC004()

Local cRefer  := ""

If FwIsAdmin()
    cRefer := GetSX8Num('SC2','C2_MSREFER','C2_MSREFER' + cEmpAnt)

    Alert(cRefer)
Else 
    Alert("Rotina só pode ser acessada pelo administrador do sistema.")
EndIf 
    
Return 
