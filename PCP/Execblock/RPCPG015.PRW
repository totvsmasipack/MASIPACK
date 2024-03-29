#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCPG015  �Autor  �Lizandra Marques    � Data �  01/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � VERIFICA ROTEIRO ALTERNATIVO PARA OP.                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RPCPG015()

_aArea	:= GetArea()
_aAreaG2:= SG2->(GetArea())

_cCod	:= M->C2_PRODUTO

IF SG2->(dbSeek(xFilial("SG2")+M->C2_PRODUTO+"01"))
	
	_cCod	:= M->C2_PRODUTO
	_nCont	:= 0
	_cRot	:= "01"
	DO WHILE !SG2->(EOF()) .AND. SG2->G2_PRODUTO == _cCod
		IF SG2->G2_CODIGO <> _cRot
			_nCont	+= 1
		ENDIF
		SG2->(dbSkip())
	ENDDO
	IF _nCont > 0 
		ApMsgAlert("Produto possue mais de um roteiro. Verifique.")
	ENDIF	
ENDIF

RestArea(_aAreaG2)
RestArea(_aArea)

Return (_cCod)