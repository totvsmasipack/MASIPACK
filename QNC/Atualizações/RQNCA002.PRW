#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  �RQNCA002  �Autor  �Lizandra Marques    � Data 24/01/12     ���
������������������������������������������������������������������������͹��
���          | Recupera Campos Memo da Acao  - tabela SYP                ���
������������������������������������������������������������������������͹��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RQNCA002()

Private nAlt := 0

Private cPerg    := "XRQNCA002 "

If ! Pergunte(cPerg,.T.)
	Return
EndIf

If Empty(mv_par01)
	APMsgALERT("Por Favor, Informe o Numero da A��o")
	If ! Pergunte(cPerg,.T.)
		Return
	EndIf
EndIf

SYP->(DbSetOrder(1))
QI5->(DbSetOrder(1))

If QI5->(DbSeek(xFilial()+mv_par01))
	//   If !QI5->(Deleted())
	If !Empty(QI5->QI5_DESCCO)
		Set Delete Off
		If SYP->(DbSeek(xFilial()+QI5->QI5_DESCCO))
			Do While SYP->(!EOf()) .And. QI5->QI5_DESCCO == SYP->YP_CHAVE
				If SYP->(Deleted())
					RecLock("SYP",.F.)
					SYP->(DbReCall())
					SYP->(MsUnlock())
					nAlt++
				EndIf
				SYP->(DbSkip())
			EndDo
		EndIf
	EndIf
	If !Empty(QI5->QI5_DESCOB)
		Set Delete Off
		If SYP->(DbSeek(xFilial()+QI5->QI5_DESCOB))
			Do While SYP->(!EOf()) .And. QI5->QI5_DESCOB == SYP->YP_CHAVE
				If SYP->(Deleted())
					RecLock("SYP",.F.)
					SYP->(DbReCall())
					SYP->(MsUnlock())
					nAlt++
				EndIf
				SYP->(DbSkip())
			EndDo
		EndIf
	EndIf
	//   EndIf
Else
	APMSGSTOP("A��o n�o cadastrada - Verifique")
EndIf

If nAlt > 0
	APMSGINFO("OK - Registros recuperados: " + Str(nAlt,6))
Else
	APMSGINFO("N�o houve registros recuperados - Verifique")
EndIf

Set Delete On

Return