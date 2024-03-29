
#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG034  �Autor  �Lizandra Marques    � Data �  09/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � VERIIVA SE A MOEDA ULTILIZADA NO OR�CAMENTO � A MESMA DA   ���
���            TABELA                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG034()

_aArea  := GetArea()   
_nMoeda := 0

IF INCLUI
	Private _nMoeda := M->CJ_MOEDA
	Private _cTabela:= M->CJ_TABELA
//	Private _cVAR1  := M->CJ_ORCAM
ELSE	
	Private _nMoeda := SCJ->CJ_MOEDA
	Private _cTabela:= SCJ->CJ_TABELA
//	Private _cVAR1  := SCJ->CJ_ORCAM
ENDIF

DA1->(dbSetOrder(1))
IF DA1->(dbSeek(xFilial("DA1")+_cTabela))
	IF DA1->DA1_MOEDA <> _nMOEDA
		ApMsgAlert("Moeda do or�amento diferente da moeda da tabela de pre�o. Verifique.")
		_nMoeda := DA1->DA1_MOEDA
	ENDIF
ELSE		
	ApMsgAlert("N�o existe itens para essa Tabela de Pre�o. Verifique.")
ENDIF	     

RestArea(_aArea)

Return(_nMoeda)