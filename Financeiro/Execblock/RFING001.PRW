#Include "Protheus.ch" 
#Include "Topconn.ch"  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFING001  �Autor  �Lizandra Marques    � Data �  13/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para preencher as contas cont�beis                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RFING001() 

Local _cBco	:= M->EH_BANCO
Local _cCC	:= M->EH_AGENCIA
Local _cAg	:= M->EH_CONTA   
Local _nVal	:= M->EH_VALOR   


_aArea		:= GetArea()
_aAreaA6		:= SA6->(GetArea())

dbSelectArea("SA6")

IF M->EH_APLEMP = 'APL'
	IF SA6->(dbSeek(xFilial("SA6")+_cBco+_cCC+_cAg))
   	M->EH_DEBITO   := SA6->A6_MSCTAAP
   	M->EH_CREDIT   := SA6->A6_CONTA
	ENDIF                  
ENDIF
RestArea(_aAreaA6)
RestArea(_aArea)

Return (_nVal)