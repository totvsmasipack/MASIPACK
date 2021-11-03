User Function DTPAGTO()

Local _cRet

_cRet:= Substr(DtoS(SE2->E2_VENCREA),7,2)+Substr(DtoS(SE2->E2_VENCREA),5,2)+Substr(DtoS(SE2->E2_VENCREA),1,4)
                                   
RETURN(_cRet)