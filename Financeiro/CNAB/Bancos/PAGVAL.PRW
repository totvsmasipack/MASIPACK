**************************************************************************
* Programa...: PAGVAL.PRX
* Finalidade.: Extrair o Valor do Codigo de Barras ou da Linha Digitavel
**************************************************************************

user function pagval(_Valor)

_Valor :="0000000000"

IF !Empty(SE2->E2_CODBAR)
   _Valor := SubStr(SE2->E2_CODBAR,10,10)
ElseIf !Empty(SE2->E2_LINDIG)
   _Valor := SubStr(SE2->E2_LINDIG,38,10)
Endif

Return(_Valor)
