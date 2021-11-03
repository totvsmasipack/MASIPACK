User Function BAIRRO()

_cRet:= IIF(EMPTY(SA1->A1_ENDCOB),SUBSTR(SA1->A1_BAIRRO,1,12),SUBSTR(SA1->A1_BAIRROC,1,12))

                         
RETURN(_cRet)
