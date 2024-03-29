#include "Topconn.ch"
#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATE001  �Autor  �Lizandra Marques    � Data �  28/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Preenche campo virtual com a situa��o do sc9               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATE001(_cBloq)

_aArea	:= GetArea()
_cBloq	:=""  
SC9->(DbSetOrder(1))
If SC9->(DbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
	_cNum := SC6->C6_NUM
	_cItem := SC6->C6_ITEM
	DO WHILE SC9->(!EOF()) .AND. SC9->C9_PEDIDO+SC9->C9_ITEM == _cNum+_cItem
		IF SC9->C9_BLEST == "02" .AND. SC9->C9_BLCRED == "01"
			_cBloq := "CREDITO/ESTOQUE"
		ELSEIF 	SC9->C9_BLEST == "  " .AND. SC9->C9_BLCRED == "01"
			_cBloq := "CREDITO"
		ELSEIF 	SC9->C9_BLEST == "02" .AND. SC9->C9_BLCRED == "  "
			_cBloq := "ESTOQUE"
		ELSEIF 	SC9->C9_BLEST == "  " .AND. SC9->C9_BLCRED == "  "
			_cBloq := "LIBERADO P/FATURAMENTO"
		ENDIF
		SC9->(dbSkip())
	ENDDO
ELSE
	_cBloq := ""
EndIf     
                               
IF SC6->C6_QTDENT==SC6->C6_QTDVEN
	_cBloq := "TOTALMENTE FATURADO"
ELSEIF SC6->C6_QTDEMP>0 .AND. SC6->C6_QTDEMP < SC6->C6_QTDVEN 	
	IF EMPTY(_cBloq)
		_cBloq := "PARCIALMENTE FATURADO"
	ENDIF
ENDIF	


RestArea(_aArea)
Return(_cBloq)	        
