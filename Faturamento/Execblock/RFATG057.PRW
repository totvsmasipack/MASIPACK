#INCLUDE "RWMAKE.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG057  �Autor  �Ivandro Santos      � Data �  03/24/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho criado para ser inicializador padr�o para o cadastro ��
���          �de clientes no campo c�digo.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG057()
Local _aArea    := GetArea()
Private _cCodCli := ""

If ApMsgYesNo("Deseja criar nova loja de cliente?")
	_cCodCli := SA1->A1_COD
Else
	_cCodCli := GetSXEnum("SA1","A1_COD")
Endif

RestArea(_aArea)
Return(_cCodCli)