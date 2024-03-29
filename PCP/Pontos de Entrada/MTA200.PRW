/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PONTO DE ENTRADA PCP   �Autor" "  �Data �  03/11/06         ���
�������������������������������������������������������������������������͹��
���Desc.     � FUN�AO PARA NAO DEIXAR INCLUIR MATERIAL COMPRADO           ���
���          � E IMPRODUTIVO NA ESTRUTURA.                                ���
�������������������������������������������������������������������������͹��
���Uso       � MATA200 - MASIPACK.                                        ���
�������������������������������������������������������������������������ͼ��
���Altera��o � Inclu�da valida��o na fun��o MSPEDCON n�o permitir exclus�o���
���          � de empenho caso o Pedido de Venda foi conclu�do-Ivandro-6/6���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "Rwmake.ch"

User Function MTA200()

Private nQuant := 0

lRetorno := .T.

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	
	IF ALLTRIM(paramixb) $ "AI"
		
		sb1->(DBSEEK(xFilial("SB1") + cProduto))
		
		IF SUBSTR(sb1->b1_proced,1,1) # "1"
			MSGINFO("Codigo pai (" + ALLTRIM(cProduto) + ") e comprado, nao pode ter estrutura!")
			lRetorno := .F.
		ENDIF
		
		/* TIRADO NO DIA 19/03/12 LIZANDRA /  Z� ROBERTO
		
		sb1->(DBSEEK(xFilial() + m->g1_comp))
		
		IF lRetorno
		IF SUBSTR(SB1->B1_PROCED,2,1) == "N"
		MsgInfo('Proibido material improdutivo na estrutura!')
		lRetorno := .F.
		ENDIF
		ENDIF
		*/
		m->g1_msuser := SUBSTR(cUsuario,7,15)
	ELSE
		nQuant := 0
		SC2->(DbSetOrder(2))
		If SC2->(DbSeek(xFilial("SC2")+SG1->G1_COD))
			Do While !SC2->(Eof()) .And. SC2->C2_PRODUTO == SG1->G1_COD
				SD4->(DbSetOrder(1))
				If SD4->(DbSeek(xFilial("SD4")+SG1->G1_COMP+(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)))
					nQuant += SD4->D4_QUANT
				EndIf
				SC2->(DbSkip())
				Loop
			EndDo
		EndIf
		RecLock("SG1",.F.)
		If SubStr(cNumEmp,1,2) $ "01_10"
			SG1->G1_MSATUOP := "S"
			If nQuant > 0
				If !MsgBox("*** ATEN��O, Esta exclus�o Interfere nas Ordens de Produ��o ***","AVISO","YESNO")
					SG1->G1_MSATUOP := "N"
				EndIf
			EndIf
		Endif
		sg1->g1_msuser := SUBSTR(cUsuario,7,15)
		sg1->(MsUnlock())
	ENDIF
	//Efetua a valida��o para altera��o na estrutura
	//lRetorno := U_MSPEDCON(SG1->G1_COD,"EST") - Valida��o retirada a pedido do Vagner (Montagem)
ENDIF

RETURN lRetorno
