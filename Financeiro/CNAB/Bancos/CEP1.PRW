User Function CEP1()
_cRet:=" "

If !Empty(SA1->A1_ENDCOB)    // Cliente não tem Endereco Cobranca
   _cRet := SUBSTR(SA1->A1_CEPC,1,5)  
Else 
   _cRet := SUBSTR(SA1->A1_CEP,1,5) 
Endif

                         
RETURN(_cRet)
