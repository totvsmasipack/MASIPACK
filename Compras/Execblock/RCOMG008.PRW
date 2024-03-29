#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMG008  �Autor  �Lizandra	Marques    � Data �  11/03/147  ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida quantidade ddo PC de acordo com a embalagem          ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RCOMG008()

Local _nPosQtd := aScan(aHeader,{|x| Alltrim(x[2])=="C1_QUANT" 	})
Local _nPosPrd := aScan(aHeader,{|x| Alltrim(x[2])=="C1_PRODUTO"	})
Local _nQtde 	:= aCols[n,_nPosQtd]
Local _cProduto:= aCols[n,_nPosPrd]
Local _nQtEmb 	:= Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_QE")

IF _nQtEmb > 0
	IF MOD(_nQtde,_nQtEmb) > 0
		ApMsgAlert("A Quantidade informada n�o � multipla da quantidade comprada!!!")
		_nQtde := (INT(_nQtde/_nQtEmb)*_nQtEmb) + _nQtEmb
	ENDIF
ENDIF	
Return(_nQtde)
