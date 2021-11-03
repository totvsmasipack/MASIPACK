****************************************************************************************
* Programa...: PAGBAN.PRX
* Finalidade.: Extrair o Banco do Fornecedor do Codigo de Barras ou da Linha Digitavel  
****************************************************************************************

user function pagban(_BANCO)

_BANCO := "000"

IF !EMPTY(SUBSTR(SE2->E2_CODBAR,1,3))
   _BANCO  :=  SUBSTR(SE2->E2_CODBAR,1,3)
ElseIf !EMPTY(SUBSTR(SE2->E2_LINDIG,1,3))
   _BANCO  :=  SUBSTR(SE2->E2_LINDIG,1,3)
EndIf
    
return(_BANCO)
