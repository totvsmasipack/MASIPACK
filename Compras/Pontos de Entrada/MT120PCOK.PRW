#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � MT120PCOK  篈utor  �  Eduardo Mantoan           � 03/10/2014罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.   Verifica FORNECEDOR     												   	北  
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/
User Function MT120PCOK()
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Controle de validade do programa									�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪� 
Local _aArea := GetArea()
Local _aAreaSC7 := SC7->(GetArea())
Local _aAreaSC1 := SC1->(GetArea())
Local _aAreaSC8 := SC8->(GetArea())
Private cFor := CA120FORN

_dDtVenc:="20/10/2014"
If DDATABASE<=CTOD(_dDtVenc) .OR. DATE()<=CTOD(_dDtVenc)
  
	Return .T.
Endif

If !(SUBSTR(cNumEmp,1,2) $ "01")  // MASIPACK 
	RETURN .T.	
EndIf


DBSELECTAREA("SA2")
DBSETORDER(1)
DBSEEK(xFilial("SA2")+cFor)
If DTOS(SA2->A2_MSDTCER) == "        "
	If SA2->A2_MSDTQUE < DATE()  .AND. (ALTERA .OR. INCLUI) .AND. (SA2->A2_NATUREZ == "A01" .OR. SA2->A2_NATUREZ == "A05")
		ALERT("A validade do question醨io do fornecedor expirou. Realizar nova avalia玢o para desbloquear!")
		Return .F.
	EndIf 
Else
	If SA2->A2_MSDTCER < DATE()  .AND. (ALTERA .OR. INCLUI) .AND. (SA2->A2_NATUREZ == "A01" .OR. SA2->A2_NATUREZ == "A05")
		ALERT("A validade do certificado do fornecedor expirou. Realizar nova avalia玢o para desbloquear!")
		Return .F.
	EndIf
EndIf 

RestArea(_aAreaSC8)
RestArea(_aAreaSC7)
RestArea(_aAreaSC1)
RestArea(_aArea)
	
Return .T.
