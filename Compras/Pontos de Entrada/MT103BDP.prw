#INCLUDE 'TOTVS.CH'

/*---------------------------------------------------------------------------------------------------*
| Ponto de Entrada:  MT103BDP                                                                       |
| Desc: Está localizado no Documento de Entrada e tem a finalidade de indicar se o aCols de         |
| Duplicatas será bloqueado.                                                                        |
|                                                                                                   |
| @author  DS2U (THOMAS MORAES)																		|
| @since   Dez.2021																					|
| @version 1.0																					    |
| @type    function                                  												|
*---------------------------------------------------------------------------------------------------*/

User Function MT103BDP
Local lRet        := .F. //.T. = Bloqueia a edição do Acols SE2 - .F. = Não Bloqueia
Public cCondicao  := M->F1_COND

If !INCLUI

    DBSelectArea("SE4")
    SE4->(dbSetOrder(1)) //SE4->E4_FILIAL+E4_CODIGO
    If SE4->(dbSeek(FWxFilial("SE4") + cCondicao))

        // Se tiver configurado com adiantamento (PA do Compras), bloqueia alteração do aCols
        If SE4->E4_CTRADT == "1"
            lRet := .T.
        Else
            lRet := .F.
        EndIf
    EndIf
EndIf

Return lret
