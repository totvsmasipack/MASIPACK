#include 'protheus.ch'

/*/{Protheus.doc} User Function MT120QRY
P.E. Filtro na MBRowse MATA120
@type  Function
@author E.DINIZ [ DS2U ]
@since 30/03/2021
/*/
User Function MT120QRY()

Local cRet      := ''   
    
    //Tecla F8 -> Consulta �ltimos pre�os por produto na MBrowse e na posi��o do aCols
    SetKey(VK_F8, {|| U_MSCOMM01() })

Return cRet
