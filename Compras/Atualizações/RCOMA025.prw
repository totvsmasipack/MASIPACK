/*/{Protheus.doc} User Function RCOMA025
    Fun��o para marcar/desmarcar fornecedor com pend�ncia financeira
    @type  Function
    @author Fernando Corr�a (DS2U)
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
        If MsgYesNo("Deseja marcar o fornecedor com Pend�ncia Financeira?", "Pend�ncia")
            If RecLock("SA2", .F.)
                SA2->A2_XPENDFI := '1'
                SA2->(MsUnlock())
                lOk := .T.
            Else 
                lOk := .F.
            EndIf 
        EndIf 
    Else 
        If MsgYesNo("Deseja RETIRAR a pend�ncia financeira do fornecedor?", "Pend�ncia")
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
        MsgInfo("Opera��o realizada com sucesso!", "Sucesso.")
    Else 
        Alert("Opera��o n�o realizada.")
    EndIf 
    

Return NIL
