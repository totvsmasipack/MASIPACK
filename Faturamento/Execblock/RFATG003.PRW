#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG003 �Autor  �Aparecida F.Stevanato � Data �  06/06/07  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para Verifica��o do bloqueio do Vendedor e         ���
���          �         Atualiza��o do % de comiss�o                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG003()

	Local _lRet := .T.
	
	If !SA3->(DbSeek(xFilial("SA3")+M->C5_VEND1))
		MsgAlert("C�digo de Vendedor: " + M->C5_VEND1 + " N�o Existe. Verifique o c�digo correto.","C�digo de Vendedor incorreto")
		_lRet := .F.
		Return(_lRet)
	Endif

	If SA3->A3_MSBLQL == "S"
		ApMsgInfo("Vendedor Bloqueado para Entrada de Pedidos!!!")
		_lRet := .F.
	Else
	   M->C5_COMIS1 := SA3->A3_COMIS
	   If SA3->A3_TIPVEND <> "2"
	      M->C5_COMIS2  := SA3->A3_MSCOMSU
	   EndIf
	EndIf

Return(_lRet)