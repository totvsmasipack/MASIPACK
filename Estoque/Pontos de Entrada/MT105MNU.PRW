#Include "Rwmake.ch"
#Include "Topconn.ch" 
#Define _CRLF CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT105MNU  �Autor  �Eduardo Mantoan � Data �  07/10/2014    ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclui botao e-mail no browser						      ���
���          �                                      					  ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT105MNU()
	
	Local aRet := {}  
     
	aAdd(aRet,{'e-Mail','ExecBlock("MEmail")', 0 , 2})

Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT105MNU  �Autor  �Eduardo Mantoan � Data �  07/10/2014    ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclui botao e-mail no browser							  ���
���          �                                      					  ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MEmail()

	Local _cUser  	 := CUSERNAME
	Local _cUsuario := RetCodUsr()
	Local _cNomeUsu := UsrFullName(_cUsuario)
	Local cMensagem := "" 
	Local cPath     := "" 
	Local cCco      := "vagner.cm@masipack.com.br"
	Local cDestina  := "almoxarifado.masipack@masipack.com.br" 
	Local cTitulo   := "Solicita��o ao Armazem"   

	cMensagem := " N�mero         : "+SCP->CP_NUM + "/"+SCP->CP_ITEM+" - Emiss�o: "+DTOC(SCP->CP_EMISSAO) 	+ _CRLF 
	cMensagem += " Produto        : "+ALLTRIM(SCP->CP_PRODUTO)+" - "+ALLTRIM(SCP->CP_DESCRI)				+ _CRLF
	cMensagem += " Quantidade     : "+STR(SCP->CP_QUANT)+" - "+SCP->CP_UM 									+ _CRLF   
	cMensagem += " Solicitante    : "+SCP->CP_SOLICIT+" - "+_cNomeUsu										+ _CRLF 
	cMensagem += " Observa��o     : "+SCP->CP_OBS 															+ _CRLF  
	cMensagem += " Dat.Necessidade: "+DTOC(SCP->CP_DATPRF)													+ _CRLF  
	cMensagem += " OP             : "+SCP->CP_OP 															+ _CRLF
	cMensagem += " SC             : "+SCP->CP_NUMSC 														+ _CRLF

	If SCP->CP_QUJE < SCP->CP_QUANT
		If AllTrim(_cUser) == AllTrim(SCP->CP_SOLICIT)
			oMail:= EnvMail():NEW(.F.)
			If oMail:ConnMail()
				MsgRun("Enviando e-mail para "+cDestina ,, { || oMail:SendMail(cTitulo,cDestina,cCco,,cMensagem) } )
				Msgbox("Email enviado com sucesso!","Aten��o...","INFO")
			EndIf
			oMail:DConnMail()  
		Else
			ALERT("Sem permiss�o para enviar e-mail desta solicita��o")
		EndIf
	Else
		ALERT("Solicita��o j� atendida, n�o h� necessidade de disparar o e-mail!")	
	EndIf

Return 