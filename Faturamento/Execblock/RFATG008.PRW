#Include "Protheus.ch" 
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG008  �Autor  �Lizandra Marques    � Data �  19/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica a duplicidade do campo pedido do cliente           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RFATG008() 

Local _cClient	:= M->C5_CLIENTE
Local _cPedCli	:= M->C5_PC

_aArea 		:= GetArea()
_aAreaC5	:= SC5->(GetArea())
_lRet		:= M->C5_PC

dbSelectArea("SC5")
DbOrderNickName('MASC501') 

IF SC5->(dbSeek(xFilial("SC5")+_cPedCli+_cClient))
	ApMsgInfo("Pedido de Cliente ja Cadastrado. Verifique!!!")
	_lRet:= SPACE(20)
ENDIF                  
RestArea(_aAreaC5)
RestArea(_aArea)

Return(_lRet)