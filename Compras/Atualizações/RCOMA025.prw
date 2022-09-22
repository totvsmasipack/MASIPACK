/*/{Protheus.doc} User Function RCOMA025
    Função para marcar/desmarcar fornecedor com pendência financeira
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
User Function RCOMA025()

    Local lOK := .F.

    If A2_XPENDFI != '1'
        If MsgYesNo("Deseja marcar o fornecedor com Pendência Financeira?", "Pendência")
            If RecLock("SA2", .F.)
                SA2->A2_XPENDFI := '1'
                SA2->(MsUnlock())
                lOk := .T.
            Else 
                lOk := .F.
            EndIf 
        EndIf 
    Else 
        If MsgYesNo("Deseja RETIRAR a pendÊncia financeira do fornecedor?", "Pendência")
            If RecLock("SA2", .F.)
                SA2->A2_XPENDFI := '2'
                SA2->(MsUnlock())
                lOk := .T.
            Else 
                lOk := .F.
            EndIf 
        EndIf 
    EndIf

    If lOk 
        MsgInfo("Operação realizada com sucesso!", "Sucesso.")
    Else 
        Alert("Operação não realizada.")
    EndIf 
    

Return NIL
