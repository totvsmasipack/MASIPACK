#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} NSUSRBTN
Ponto de entrada da Browse do NfSync.
@author DS2U (SDA)
@since 15/07/2019
@version 1.0
@return xRet, Retorno conforme P.E. processado

@type function
/*/
User Function NSUSRBTN()

Local alRotAux := {} 

AADD( alRotAux, {"Desmembra PC" , "U_MASA01(1)", 0, 4, 0, nil } )
AADD( alRotAux, {"Produto Teste" , "U_MASA01(2)", 0, 4, 0, nil } )
AADD( alRotAux, {"Produto Demonstração" , "U_MASA01(3)", 0, 4, 0, nil } )
//AADD( alRotAux, {"Produto Provisório" , "U_MASA01(4)", 0, 4, 0, nil } ) // TODO NAO ACHEI LOGICA PARA DESENVOLVER PROVISORIOS
 
Return alRotAux