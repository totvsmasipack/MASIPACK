**************************************************************************
* Programa...: PAGMOEDA.PRX
* Finalidade.: Extrair a Moeda do Codigo de Barras ou da Linha Digitavel
**************************************************************************
                   
user function pagmoeda(_cMoeda)

_cMoeda := "0"

If !Empty(SE2->E2_CODBAR)
   _cMoeda := SubStr(SE2->E2_CODBAR,4,1)
ElseIf !Empty(SE2->E2_LINDIG)
   _cMoeda := SubStr(SE2->E2_LINDIG,4,1)
Endif

Return(_cMoeda)
   
