#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG012  �Autor  �                    � Data �  22/07/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para verificar Cliente no Pedido original           ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������� 
// alterado 14/10/14 - Lizandra
�����������������������������������������������������������������������������
*/

USER Function RFATG012()

_nRec  := SC5->(Recno())
_aArea := GetArea()     

IF SUBSTR(cNumEmp,1,2) $ "01_10"
	IF M->C5_NUM <> M->C5_MSLINK
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		IF DbSeek(xFilial("SC5")+M->C5_MSLINK)
			IF M->C5_CLIENTE <> SC5->C5_CLIENTE
				ApMsgStop("Cliente do Pedido Original diferente ")
				M->C5_MSLINK := ""
			ENDIF
		ELSE
			ApMsgStop("Pedido Original n�o existe - Verifique ")
			M->C5_MSLINK := ""
		ENDIF
	ENDIF
ENDIF
        
dbGoto(_nRec)

RestArea(_aArea)

Return(M->C5_MSLINK)
