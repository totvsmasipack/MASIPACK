#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QN040AUT  �Autor  �Victor Dessunte     � Data �  10/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Libera alteracao em ficha de nao conformidade por usuario  ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function QN040AUT()

Local _aArea := GetArea()
Local _lRet  := .F.
Local cUserFNC := POSICIONE("QAA",1,xFilial("QAA")+QI2_MAT,"QAA_LOGIN")

	If RetCodUsr() $ GetMv("MS_QNC0001") .OR. FwIsAdmin(RetCodUsr()) .OR. Alltrim(cUserFNC) == UPPER(Alltrim(cUserName)) 
		_lRet := .T.
	EndIf

	RestArea(_aArea)

Return _lRet
