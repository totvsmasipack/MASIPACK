User Function MUNIC()

_cRet:= IIF(EMPTY(SA1->A1_ENDCOB),SUBSTR(SA1->A1_MUN,1,15),SUBSTR(SA1->A1_MUNC,1,15))
                         
RETURN(_cRet)
