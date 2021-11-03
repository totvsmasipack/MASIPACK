/////  PROGRAMA PARA SEPARAR A AGENCIA DO CODIGO DE BARRA PARA O PORGRAMA DO
///// PAGFOR - POSICOES ( 99 - 103 )
                    
user function pagagen(_Agencia)

_Agencia  :=  "00000"
 
If !Empty(SubStr(SE2->E2_CODBAR,1,3))
   If SubStr(SE2->E2_CODBAR,1,3) == "237"
      _Agencia  :=  StrZero(Val(SubStr(SE2->E2_CODBAR,20,4)),5)
   EndIf
Else
   If SUBSTR(SE2->E2_LINDIG,1,3) == "237"
     _Agencia  :=  StrZero(Val(SubStr(SE2->E2_LINDIG,5,4)),5)
   EndIf
EndIf     

return(_Agencia)
