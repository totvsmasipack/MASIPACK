User Function DTGERACAO()

Local _cRet

_cRet:= Substr(DtoS(DDATABASE),7,2)+Substr(DtoS(DDATABASE),5,2)+Substr(DtoS(DDATABASE),1,4)
                                   
RETURN(_cRet)