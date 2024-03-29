#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG001  �Autor  �Adriano Luis Brandao� Data �  20/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para atualizar o campo Z4_RAZAO automaticamente     ���
���          � atraves de um gatilho.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG001()

_cRet 	:= ""

_aArea 	:= GetArea()

DbSelectArea("SA1")
_aAreaA1 := GetArea()
DbSetOrder(1)

DbSelectArea("SC5")
_aAreaC5 := GetArea()
SC5->(DbSetOrder(1)) 

If DbSeek(xFilial("SC5")+M->Z4_PEDIDO)         
   If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
      _cRet := SA1->A1_NOME
   EndIf
EndIf

RestArea(_aAreaC5)
RestArea(_aAreaA1)                        
RestArea(_aArea)   

Return(_cRet)