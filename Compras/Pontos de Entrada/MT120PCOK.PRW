#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MT120PCOK  ºAutor  ³  Eduardo Mantoan           ³ 03/10/2014º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.   Verifica FORNECEDOR     												   	±±  
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function MT120PCOK()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de validade do programa									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
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
		ALERT("A validade do questionário do fornecedor expirou. Realizar nova avaliação para desbloquear!")
		Return .F.
	EndIf 
Else
	If SA2->A2_MSDTCER < DATE()  .AND. (ALTERA .OR. INCLUI) .AND. (SA2->A2_NATUREZ == "A01" .OR. SA2->A2_NATUREZ == "A05")
		ALERT("A validade do certificado do fornecedor expirou. Realizar nova avaliação para desbloquear!")
		Return .F.
	EndIf
EndIf 

RestArea(_aAreaSC8)
RestArea(_aAreaSC7)
RestArea(_aAreaSC1)
RestArea(_aArea)
	
Return .T.
