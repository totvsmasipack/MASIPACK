#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFATG049  �Autor �Eduardo Bego Mantoan	   Data � 15/04/2015���
�������������������������������������������������������������������������͹��
���Desc.     �  Libera or�amento para aprova��o			         			  ���
�����������������������������������������������������������������������������
*/

User Function RFATG049()  

	Local aAreaAtu     := GetArea()  
	Local _aUsuario  	:= {}               
	Local _cUsuario   := RetCodUsr()
	Local _cUser		:= cUserName
 	If Altera .AND. ALLTRIM(_cUser) == ALLTRIM(M->CJ_MSUSER) .AND. M->CJ_STATUS == "A" .AND. M->CJ_MSBLQ = 1     
		If SUBSTR(cNumEmp,1,2) $ "01_10"  // MASIPACK/FABRIMA
			If M->CJ_MSAPROV == "N" .OR. alltrim(M->CJ_MSAPROV) == ""
				If apMsgYesNo("Confirma libera��o do or�amento para aprova��o?")   
//Se no or�amento conter itens especiais, assim que o or�amentista liberar, antes de ser liberado para aprova��o, a engenharia ter� que acertar. 
//criar status

					M->CJ_STATUS := "A" 
					M->CJ_MSBLQ  := 2
				EndIf
			EndIf 
		EndIf
	Else
		ALERT("S� � poss�vel liberar or�amento, o usu�rio que criou e em modo altera��o.")
	EndIF
	
	        

	RestArea(aAreaAtu) 
	 
Return()