#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT380EXC  �Autor  �Victor Dessunte     � Data �  03/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se devera ser excluido o empenho                     ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
���Altera��o � Inclu�da valida��o na fun��o MSPEDCON n�o permitir exclus�o���
���          � de empenho caso o Pedido de Venda foi conclu�do-Ivandro-6/6���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT380EXC()
                         
Local _aArea 	:= GetArea()
Local _lRet		:= .T.

	If cEmpAnt $ "01|10"
		_lRet := U_MSPEDCON(SD4->D4_OP,"EMP")
	Endif
	
	RestArea(_aArea)

Return _lRet
