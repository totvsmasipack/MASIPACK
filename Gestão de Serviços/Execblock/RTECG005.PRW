#Include "Topconn.ch"
#Include "Rwmake.ch"
#INCLUDE "AP5MAIL.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RTECG005  �Autor  �Eduardo Bego Mantoan� Data �  15/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Help-Desk.     											  ���
���          � 			                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION RTECG005()

	// Campos que serao usados para envio de e_mail
	Private _cTitulo   := ""
	Private _cDestino  := ""
	Private _cCco      := ""
	Private _cMsg      := ""
	Private _cAnexo    := "" 
	DBSELECTAREA("AB2")	
	DBSETORDER(1)
	AB2->(dbGoTop())
	AB2->(DBSEEK(xFILIAL("AB2")+ABK->ABK_NRCHAM))
	_cProd:= ALLTRIM(AB2->AB2_CODPRO)
	DBSELECTAREA("AB1")	
	DBSETORDER(1)
	AB1->(dbGoTop())
	AB1->(DBSEEK(xFILIAL("AB1")+ABK->ABK_NRCHAM))
	_cDestino:= ALLTRIM(AB1->AB1_MSMAIL)
	
	If _cDestino == "                "
		ALERT("E-mail do t�cnico n�o encontrado")
		Return
	EndIf
	_aArea 	  		:= GetArea()
	If !(ABK->ABK_SITUAC == "1")
		IF SUBSTR(cNumEmp,1,2) == "01"
			_cTitulo := "HelpDesk - "+ABK->ABK_NRCHAM 
			_cMsg := ""
			_cMsg    += "Numero do Help-Desk: " + ABK->ABK_NRCHAM+" Sequ�ncia: "+ABK->ABK_SEQ
			_cMsg    += CHR(13)+CHR(10)
			_cMsg    += "Cliente : " + ABK->ABK_CODCLI + "/" + ABK->ABK_LOJA + " - " +ABK->ABK_MSNCLI + CHR(13)+CHR(10)
			_cMsg    += "Produto/Equipamento: "+ _cProd + "/" +Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_DESC") + CHR(13)+CHR(10) 
			_cMsg    += "Situa��o: " + IIF(ABK->ABK_SITUAC == "2","Em Aberto","Pendente") + CHR(13)+CHR(10)
			_cMsg    += "N�mero de S�rie: "+ AB2->AB2_NUMSER + CHR(13)+CHR(10)
			_cMsg    += "Contato : " + AB1->AB1_CONTAT + "     " + CHR(13)+CHR(10)
			_cMsg    += "Telefone: " + AB1->AB1_TEL + CHR(13)+CHR(10)
			_cMsg    += "Resumo  : " + AB1->AB1_MSRESU
			_cMsg    += CHR(13)+CHR(10) 
			_cMsg    += CHR(13)+CHR(10)
			If _cMsg <> ""                                             
				oMail:= EnvMail():NEW(.F.)
				If oMail:ConnMail()
					oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
					Msgbox("E-mail enviado!","Aten��o...","INFO")
				EndIf
				oMail:DConnMail()
			EndIf
		ENDIF
	Else
		ALERT("Help-Desk encontra-se encerrado")
	EndIf		
	RestArea(_aArea)

RETURN 