/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPONTO DE ENTRADA PCP   บAutor" "  ณData ณ  03/11/06         บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNวAO PARA NAO DEIXAR INCLUIR MATERIAL COMPRADO           บฑฑ
ฑฑบ          ณ E IMPRODUTIVO NA ESTRUTURA.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA200 - MASIPACK.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบAltera็ใo ณ Incluํda valida็ใo na fun็ใo MSPEDCON nใo permitir exclusใoบฑฑ
ฑฑบ          ณ de empenho caso o Pedido de Venda foi concluํdo-Ivandro-6/6บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
		
		/* TIRADO NO DIA 19/03/12 LIZANDRA /  Zษ ROBERTO
		
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
				If !MsgBox("*** ATENวรO, Esta exclusใo Interfere nas Ordens de Produ็ใo ***","AVISO","YESNO")
					SG1->G1_MSATUOP := "N"
				EndIf
			EndIf
		Endif
		sg1->g1_msuser := SUBSTR(cUsuario,7,15)
		sg1->(MsUnlock())
	ENDIF
	//Efetua a valida็ใo para altera็ใo na estrutura
	//lRetorno := U_MSPEDCON(SG1->G1_COD,"EST") - Valida็ใo retirada a pedido do Vagner (Montagem)
ENDIF

RETURN lRetorno
