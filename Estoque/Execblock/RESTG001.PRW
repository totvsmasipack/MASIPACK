#Include "Rwmake.ch"
#Include "Topconn.ch"  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTG001  �Autor  �Lizandra Marques    � Data �  18/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Mensagem de alerta para invent�rio                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RESTG001()

	IF SUBSTR(cNumEmp,1,2) = "01" 
		ApMsgAlert("Antes de ajustar o saldo de estoque, favor verificar " + chr(13)+chr(10) + ;
			       "NECESSIDADES, NOTAS DE ENTRADA E SA�DA, EMPENHOS E LISTAS A SEPARAR." + chr(13)+chr(10)+;
			       "Verificar CHECK-LIST no almoxarifado.") 
	ELSE
		ApMsgAlert("Antes de ajustar o saldo de estoque, favor verificar " + chr(13)+chr(10) + ;
			       "NECESSIDADES, NOTAS DE ENTRADA E SA�DA, EMPENHOS E LISTAS A SEPARAR." )
	ENDIF		       
		        
Return 
