////  PROGRAMA PARA SELECIONAR O ANO DO NOSSO NUMERO DO NUMERO CNAB QUANDO NAO
////  NAO TIVER TEM QUE SER COLOCADO "00"

user function pagano(_RETANO)

_RETANO  :=  "000"

If SubStr(SE2->E2_CODBAR,1,3) == "237"

   _RETANO  := StrZero(Val(SubStr(SE2->E2_CODBAR,26,2)),3)

ElseIf SubStr(SE2->E2_LINDIG,1,3) == "237"

   _RETANO  := StrZero(Val(SubStr(SE2->E2_LINDIG,12,2)),3)

EndIf

return(_RETANO)
