#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M380ZEMP  �Autor  �Victor Dessunte     � Data �  03/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Determinar se o processo de zerar o empenho ser�, ou n�o    ���
���          �executado quando for confirmada a altera��o                 ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������͹��
���Altera��o �Inclu�da nova valida��o que verifica se o empenho alterado  ���
���          �tem Pedido de Venda que foi conclu�do - Ivandro 06/06/16    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M380ZEMP()
                         
Local _aArea 	:= GetArea()
Local _lRet		:= .T.

	If cEmpAnt $ '01|10'
		_lRet := U_MSPEDCON(M->D4_OP,"EMP")
	Endif
	
	RestArea(_aArea)

Return _lRet
