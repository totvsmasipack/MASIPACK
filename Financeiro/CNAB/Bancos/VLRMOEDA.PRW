User Function VLRMOEDA()
Local ndecs  := Msdecimais(SE1->E1_MOEDA) 

_cRet:= StrZero(xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,dDatabase,ndecs+1)*100,13,0) 
//Endif
                                    
RETURN(_cRet)
