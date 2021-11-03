/////  PROGRAMA PARA SEPARAR A CARTEIRA DO CODIGO DE BARRA OU LINHA DIGITAVEL PARA O PROGRAMA DO PAGFOR - POSICOES ( 136 - 138 )
                    
User function Carteira()

_Carteira  :=  "000" 

IF !EMPTY(SUBSTR(SE2->E2_CODBAR,1,3))
   If SubStr(SE2->E2_CODBAR,1,3) == "237"
      _Agencia  :=  "0" + SubStr(SE2->E2_CODBAR,24,2)
   ElseIf !Empty(SUBSTR(SE2->E2_LINDIG,5,4))
      _Carteira  :=  "0"+SubStr(SE2->E2_LINDIG,9,1)+SubStr(SE2->E2_LINDIG,11,1)
   EndIf
EndIf
return(_Carteira)
