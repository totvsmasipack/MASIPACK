#Include "Rwmake.ch"
#Include "Topconn.ch" 
#Define _CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT105MNU  ºAutor  ³Eduardo Mantoan º Data ³  07/10/2014    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui botao e-mail no browser						      º±±
±±º          ³                                      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT105MNU()
	
	Local aRet := {}  
     
	aAdd(aRet,{'e-Mail','ExecBlock("MEmail")', 0 , 2})

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT105MNU  ºAutor  ³Eduardo Mantoan º Data ³  07/10/2014    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui botao e-mail no browser							  º±±
±±º          ³                                      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MEmail()

	Local _cUser  	 := CUSERNAME
	Local _cUsuario := RetCodUsr()
	Local _cNomeUsu := UsrFullName(_cUsuario)
	Local cMensagem := "" 
	Local cPath     := "" 
	Local cCco      := "vagner.cm@masipack.com.br"
	Local cDestina  := "almoxarifado.masipack@masipack.com.br" 
	Local cTitulo   := "Solicitação ao Armazem"   

	cMensagem := " Número         : "+SCP->CP_NUM + "/"+SCP->CP_ITEM+" - Emissão: "+DTOC(SCP->CP_EMISSAO) 	+ _CRLF 
	cMensagem += " Produto        : "+ALLTRIM(SCP->CP_PRODUTO)+" - "+ALLTRIM(SCP->CP_DESCRI)				+ _CRLF
	cMensagem += " Quantidade     : "+STR(SCP->CP_QUANT)+" - "+SCP->CP_UM 									+ _CRLF   
	cMensagem += " Solicitante    : "+SCP->CP_SOLICIT+" - "+_cNomeUsu										+ _CRLF 
	cMensagem += " Observação     : "+SCP->CP_OBS 															+ _CRLF  
	cMensagem += " Dat.Necessidade: "+DTOC(SCP->CP_DATPRF)													+ _CRLF  
	cMensagem += " OP             : "+SCP->CP_OP 															+ _CRLF
	cMensagem += " SC             : "+SCP->CP_NUMSC 														+ _CRLF

	If SCP->CP_QUJE < SCP->CP_QUANT
		If AllTrim(_cUser) == AllTrim(SCP->CP_SOLICIT)
			oMail:= EnvMail():NEW(.F.)
			If oMail:ConnMail()
				MsgRun("Enviando e-mail para "+cDestina ,, { || oMail:SendMail(cTitulo,cDestina,cCco,,cMensagem) } )
				Msgbox("Email enviado com sucesso!","Atenção...","INFO")
			EndIf
			oMail:DConnMail()  
		Else
			ALERT("Sem permissão para enviar e-mail desta solicitação")
		EndIf
	Else
		ALERT("Solicitação já atendida, não há necessidade de disparar o e-mail!")	
	EndIf

Return 