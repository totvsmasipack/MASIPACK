User Function VLRTIT()

Local _cRet

_cRet:= ((SE2->E2_SALDO+SE2->E2_ACRESC) - SE2->E2_DECRESC) * 100
                                   
RETURN(_cRet)