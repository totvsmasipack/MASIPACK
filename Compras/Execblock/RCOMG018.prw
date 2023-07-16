#INCLUDE 'TOTVS.CH'

/*------------------------------------------------------------------------------------------------------*
| User Function:  RCOMG018                                                                              |
| Desc: Execblock utilizado para obter inclusão/alteração do objeto no TlistBox (browser) do método     |
|       "bValid" no ponto de entrada MT110CP2, que adiciona campos na grid de Aprovação de Solicitação  |
|        de Compras                                                                                     |
|                                                                                                       |
| @author  DS2U (THOMAS MORAES)																		    |
| @since   Mai.2023																					    |
| @version 1.0																					        |
| @type    function                                  												    |
*-------------------------------------------------------------------------------------------------------*/

User Function RCOMG018(aItens, oQual)
Local _nX         := 0
Local aAreaSC1    := SC1->(GetArea())
Local _cNumSC     := cNumSC
Local lRet        := .T.

For _nX := 1 To Len(aItens)

    DbSelectArea("SC1")
    SC1->(dbSetOrder(1)) // Filial + Numero SC + Item
    SC1->(dbSeek(xFilial("SC1") + _cNumSC + aItens[_nX][5]))

    RecLock("SC1", .F.)		
    SC1->C1_MSAPROP := aItens[_nX][6]
    MsUnLock() //Confirma e finaliza a operação

Next _nX

RestArea(aAreaSC1)

Return lRet
