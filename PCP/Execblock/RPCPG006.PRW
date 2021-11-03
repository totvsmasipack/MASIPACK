#include "rwmake.ch"
#Include "Topconn.ch"


/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ RPCPG006   ¦ Autor ¦ Cecilia         ¦    Data  ¦ 16/11/09 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descricao ¦ Adquire proximo numero sequencial.			  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ GENERICO							  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function RPCPG006()

Local cData    := Substr(Dtoc(dDataBase),1,2) + Substr(Dtoc(dDataBase),4,2) + Substr(Dtoc(dDataBase),7,2)
Local cProxDoc := M->D3_DOC 
Private _cUsuario := RetCodUsr()
Private _aUsuario := {}
Private cDeptoUsu := ""

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario := PswRet()
   cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf
     
IF cDeptoUsu == "CALDERARIA"      
    
   If Select("TSD3") > 0
      dbSelectArea("TSD3")
	  dbCloseArea("TSD3")
    Endif   

   _cQuery	:= "SELECT MAX(D3_DOC) AS Doc FROM SD3010 "
   _cQuery	+= " WHERE D3_FILIAL = '" + xFilial("SD3") + "'"
   _cQuery	+= " AND SUBSTRING(D3_DOC,1,6) = '" + cData + "'"
   _cQuery	+= " AND D3_ESTORNO = ' '"
   _cQuery	+= " AND D_E_L_E_T_= ' '"
   dbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, _cQuery ), 'TSD3' , .T. , .F. ) 
   dbSelectArea("TSD3") 
   
   If Empty(Doc) 
      cProxDoc := cData + "001" 
      Return(cProxDoc)
   Else   
      cProxDoc := StrZero((Val(Doc)+1),9) 
      
   Endif
   TSD3->(dbCloseArea())
Endif

Return(cProxDoc)
