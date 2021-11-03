#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATG049  ºAutor ³Eduardo Bego Mantoan	   Data ³ 15/04/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Libera orçamento para aprovação			         			  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG049()  

	Local aAreaAtu     := GetArea()  
	Local _aUsuario  	:= {}               
	Local _cUsuario   := RetCodUsr()
	Local _cUser		:= cUserName
 	If Altera .AND. ALLTRIM(_cUser) == ALLTRIM(M->CJ_MSUSER) .AND. M->CJ_STATUS == "A" .AND. M->CJ_MSBLQ = 1     
		If SUBSTR(cNumEmp,1,2) $ "01_10"  // MASIPACK/FABRIMA
			If M->CJ_MSAPROV == "N" .OR. alltrim(M->CJ_MSAPROV) == ""
				If apMsgYesNo("Confirma liberação do orçamento para aprovação?")   
//Se no orçamento conter itens especiais, assim que o orçamentista liberar, antes de ser liberado para aprovação, a engenharia terá que acertar. 
//criar status

					M->CJ_STATUS := "A" 
					M->CJ_MSBLQ  := 2
				EndIf
			EndIf 
		EndIf
	Else
		ALERT("Só é possível liberar orçamento, o usuário que criou e em modo alteração.")
	EndIF
	
	        

	RestArea(aAreaAtu) 
	 
Return()