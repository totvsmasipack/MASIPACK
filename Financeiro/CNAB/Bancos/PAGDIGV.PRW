**************************************************************************
* Programa...: PAGDIGV.PRX
* Finalidade.: Retornar o numero do Digito Verificador do Codigo de Barras
*              ou da Linha Digitavel
**************************************************************************
                          
user function pagdigv(_cDigVer)

_cDigVer := "0"

If !Empty(SE2->E2_CODBAR)
   _cDigVer := SubStr(SE2->E2_CODBAR,5,1)
ElseIf !Empty(SE2->E2_LINDIG)
   _cDigVer := SubStr(SE2->E2_LINDIG,33,1)
Endif

Return(_cDigVer)
   
