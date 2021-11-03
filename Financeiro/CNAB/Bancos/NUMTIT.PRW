User Function NUMTIT()

_cRet:= SUBSTR(SE1->E1_PREFIXO,1,1)+SUBSTR(SE1->E1_NUM,1,6)+SE1->E1_PARCELA                 
//Endif
                                    
RETURN(_cRet)
