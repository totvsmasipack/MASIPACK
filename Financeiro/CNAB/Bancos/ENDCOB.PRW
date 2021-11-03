User Function ENDCOB()

_cRet:= IIF(EMPTY(SA1->A1_ENDCOB),SUBSTR(SA1->A1_END,1,38),SUBSTR(SA1->A1_ENDCOB,1,38))

                         
RETURN(_cRet)
