
/*/
-------------------------------------------------------------------------------
{Protheus.doc} FISTRFNFE
Este ponto de entrada tem por finalidade incluir novos botões na rotina SPEDNFE()
https://tdn.totvs.com/pages/releaseview.action?pageId=6077029

@author T. MORAES [DS2U]
@since 12.jul.2021
@type function
-------------------------------------------------------------------------------
/*/

User Function FISTRFNFE()

Local aArea := GetArea()

    aAdd(aRotina,{"PRE-DANFE","U_PREDNFLOAD('S')" , 0 , 3,0,NIL})
    
    RestArea(aArea)

Return
