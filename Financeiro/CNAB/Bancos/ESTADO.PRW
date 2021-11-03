User Function ESTADO()

_cRet:= IIF(EMPTY(SA1->A1_ENDCOB),SA1->A1_EST,SA1->A1_ESTC)
                         
RETURN(_cRet)
