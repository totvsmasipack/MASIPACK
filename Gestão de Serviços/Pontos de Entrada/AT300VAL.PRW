#Include "Topconn.ch"
#Include "Rwmake.ch"
#INCLUDE "AP5MAIL.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AT300VAL  �Autor  �Lizandra Marques    � Data �  16/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail para o tecnico responsavel na efetivacao      ���
���          � do chamado.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION AT300VAL()

	Local _lRet  := .T.

	If !PARAMIXB[3]
		Return .t.
	EndIf

	IF !EMPTY(AB1->AB1_MSMAIL)

		// Campos que serao usados para envio de e_mail
		Private _cTitulo   := ""
		Private _cDestino  := ""
		Private _cCco      := ""
		Private _cMsg      := ""
		Private _cAnexo    := ""

		_aArea 	  		:= GetArea()
		
			IF PARAMIXB[3]
				IF SUBSTR(cNumEmp,1,2) == "01"
					_cDestino:= ALLTRIM(AB1->AB1_MSMAIL)
					IF PARAMIXB[1] == 1
						_cTitulo := "Inclusao de Or�amento"
					ELSEIF PARAMIXB[1] == 2	
						_cTitulo := "Inclusao de Ordem de Servi�o"
					ELSEIF PARAMIXB[1] == 3	
						_cTitulo := "Inclusao de HelpDesk" 
					EndIf
					DBSELECTAREA("AB2")	
					DBSETORDER(1)
					AB2->(DBSEEK(xFILIAL("AB2")+PARAMIXB[2]))
					_cMsg := ""
					Do WHILE AB2->AB2_NRCHAM == PARAMIXB[2] 
						_cMsg    += "Numero do Chamado T�cnico: " + AB2->AB2_NRCHAM + AB2->AB2_ITEM
						_cMsg    += CHR(13)+CHR(10)
						_cMsg    += "Cliente : " + AB1->AB1_CODCLI + "/" + AB1->AB1_LOJA + " - " +Posicione("SA1",1,xFilial("AB1") + AB1->AB1_CODCLI  + AB1->AB1_LOJA,"A1_NREDUZ") + CHR(13)+CHR(10)
						_cMsg    += "Produto/Equipamento: "+ AB2->AB2_CODPRO + CHR(13)+CHR(10) 
						_cMsg    += "N�mero de S�rie: "+ AB2->AB2_NUMSER + CHR(13)+CHR(10)
						_cMsg    += "Contato : " + AB1->AB1_CONTAT + "     " + CHR(13)+CHR(10)
						_cMsg    += "Telefone: " + AB1->AB1_TEL + CHR(13)+CHR(10)
						_cMsg    += "Resumo  : " + AB1->AB1_MSRESU
						_cMsg    += CHR(13)+CHR(10) 
						_cMsg    += CHR(13)+CHR(10)
						AB2->(DBSKIP())
					EndDo
					If _cMsg <> ""                                             
						oMail:= EnvMail():NEW(.F.)
						If oMail:ConnMail()
							oMail:SendMail(_ctitulo,_cDestino,,,_cMsg)
						EndIf
						oMail:DConnMail()
						_lRet := .T.
					EndIf
				ENDIF
			ENDIF
		RestArea(_aArea)
	ENDIF
RETURN _lRet