#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG031  �Autor  �Lizandra Marquesd   � Data �  12/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica TES  - n�o pode gerar financeiro no caso de        ���
���          �Beneficiamento                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG031()

Areaant:=Alias()

npos   := ascan(aheader,{|x|alltrim(x[2])=="C6_PRODUTO"})
wPRO    := acols[n,npos]   

_npos   := ascan(aheader,{|x|alltrim(x[2])=="C6_TES"})
_wTES    := acols[n,_npos]   

SF4->(dbSetOrder(1))
SF4->(dbSeek(xFilial("SF4")+_wTES))

IF SF4->F4_DUPLIC == "S" .AND. M->C5_TIPO == "B"
	apmsgAlert("TES para BENEFICIAMENTO n�o deve gerar financeiro. VERIFIQUE.")
ENDIF	
                                        
DbSelectArea(Areaant)

Return