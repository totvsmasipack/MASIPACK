#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFATG050  �Autor �Eduardo Bego Mantoan	   Data � 15/04/2015���
�������������������������������������������������������������������������͹��
���Desc.     �  Aprova��o de or�amento 					         			  ���
�����������������������������������������������������������������������������
*/

User Function RFATG050()  

	Local aAreaAtu     := GetArea()  
	Local _aUsuario  	:= {}               
	Local _cUsuario   := RetCodUsr()
	Local _cUser		:= cUserName
	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario := PswRet()
		_cDeparUsu := Upper(Alltrim(_aUsuario[1][12]))
		_cCargoUsu := Upper(Alltrim(_aUsuario[1][13])) 
	Else
		Return(aBotao)
	EndIf       
	 
 	If (!Altera .AND. !INCLUI) .AND. (_cDeparUsu $ "informatica" .OR. _cCargoUsu $ "GERENTE DE VENDAS") .AND. M->CJ_STATUS == "A" .AND. (SCJ->CJ_MSLIBER == "N" .OR. SCJ->CJ_MSLIBER == "") .AND. SCJ->CJ_MSBLQ = 2								//                                        
		If SUBSTR(cNumEmp,1,2) $ "01_10"  // MASIPACK/FABRIMA
			If M->CJ_MSAPROV == "N" .OR. alltrim(M->CJ_MSAPROV) == ""
				If apMsgYesNo("Confirma aprova��o do or�amento ?")    
					Reclock("SCJ",.f.)
						SCJ->CJ_STATUS	 := "A" 
			         SCJ->CJ_MSLIBER := "S" 
			         SCJ->CJ_MSUSULI := ALLTRIM(cUserName)
						SCJ->CJ_MSDTLIB := dDataBase
          			SCJ->CJ_MSHOLIB := substr(TIME(),1,5)	
			      MsUnlock()
				EndIf
			EndIf 
		EndIf
	Else
		ALERT("N�o possui acesso para aprova��o de or�amento")
	EndIF
	
	        

	RestArea(aAreaAtu) 
	 
Return()