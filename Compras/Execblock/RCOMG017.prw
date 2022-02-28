#INCLUDE 'TOTVS.CH'

/*---------------------------------------------------------------------------------------------------*
| User Function:  RCOMG017                                                                          |
| Desc: Execblock utilizado para bloquear edição dos acols financeiro ao classificar DOC ENTRADA    |
|       quando se tratar de compra com adiantamento (PA)                                            |
|                                                                                                   |
| @author  DS2U (THOMAS MORAES)																		|
| @since   Fev.2022																					|
| @version 1.0																					    |
| @type    function                                  												|
*---------------------------------------------------------------------------------------------------*/

User Function RCOMG017()
Local lRet        := .T. //.T. = permite editar E2_VENCTO no acols - .F. = Nao permite editar

If (FWIsInCallStack('MATA103')) //Verifica se está na rotina DOCUMENTO DE ENTRADA

    DBSelectArea("SD1")
    SD1->(dbSetOrder(1))
    If SD1->(dbSeek(FwxFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
        If !Empty(SD1->D1_PEDIDO)
            
            DBSelectArea("SE4")
            SE4->(dbSetOrder(1)) //SE4->E4_FILIAL+E4_CODIGO
            If SE4->(dbSeek(FWxFilial("SE4") + cCondicao))

                // Se tiver configurado com adiantamento (PA do Compras), bloqueia alteracao do E2_VENCTO
                If SE4->E4_CTRADT == "1"
                    lRet := .F.
                Else
                    lRet := .T.
                EndIf
            EndIf
        EndIf
    EndIf
EndIf

If lRet == .F.
    FWAlertInfo("Não é permitido editar data de vencimento para título com adiantamento (PA) do compras", "Título vinculado a adiantamento (PA)")
EndIf

Return lret
