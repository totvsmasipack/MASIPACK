/////  PROGRAMA PARA SEPARAR A C/C DO CODIGO DE BARRA PARA O PORGRAMA DO
///// PAGFOR - POSICOES ( 105 - 117 )

user function pagacta(_Ctaced)

_CTACED := "0000000000000" 

IF !Empty(SUBSTR(SE2->E2_CODBAR,1,3))
   If SUBSTR(SE2->E2_CODBAR,1,3) == "237"
      _Ctaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
   Endif
Else
   If SUBSTR(SE2->E2_LINDIG,1,3) == "237"
      _Ctaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_LINDIG,24,7)),13,0)
   EndIf
EndIf

return(_Ctaced)
