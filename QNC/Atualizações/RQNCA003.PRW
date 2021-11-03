#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RQNCA002  ºAutor  ³Lizandra Marques    º Data 21/09/12     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          | Recupera Campos Memo do Plano de Acao  - tabela SYP       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RQNCA003()

Private nAlt	:= 0
Private cPerg	:= "XRQNCA003 "

if ! Pergunte(cPerg,.T.)
	Return
EndIf

If Empty(mv_par01)
	apMsgAlert("Por Favor, Informe o Numero do Plano de Ação")
	If ! Pergunte(cPerg,.T.)
		Return
	EndIf
EndIf

SYP->(DbSetOrder(1))
QI3->(DbSetOrder(2))

If QI3->(DbSeek(xFilial()+mv_par01))
	//   If !QI3->(Deleted())
	IF MV_PAR02 == 1
		If !Empty(QI3->QI3_PROBLE)
			Set Delete Off
			If SYP->(DbSeek(xFilial()+QI3->QI3_PROBLE))
				Do While SYP->(!EOf()) .And. QI3->QI3_PROBLE == SYP->YP_CHAVE
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
	ENDIF
	IF MV_PAR03 == 1
		If !Empty(QI3->QI3_LOCAL)
			Set Delete Off
			If SYP->(DbSeek(xFilial()+QI3->QI3_LOCAL))
				Do While SYP->(!EOf()) .And. QI3->QI3_LOCAL == SYP->YP_CHAVE
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
	ENDIF
	IF MV_PAR04 == 1
		If !Empty(QI3->QI3_RESESP)
			Set Delete Off
			If SYP->(DbSeek(xFilial()+QI3->QI3_RESESP))
				Do While SYP->(!EOf()) .And. QI3->QI3_RESESP == SYP->YP_CHAVE
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
	ENDIF
	IF MV_PAR05 == 1
		If !Empty(QI3->QI3_RESATI)
			Set Delete Off
			If SYP->(DbSeek(xFilial()+QI3->QI3_RESATI))
				Do While SYP->(!EOf()) .And. QI3->QI3_RESATI == SYP->YP_CHAVE
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
	ENDIF
	IF MV_PAR06 == 1
		If !Empty(QI3->QI3_OBSERV)
			Set Delete Off
			If SYP->(DbSeek(xFilial()+QI3->QI3_OBSERV))
				Do While SYP->(!EOf()) .And. QI3->QI3_OBSERV == SYP->YP_CHAVE
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
	ENDIF
	IF MV_PAR07 == 1
		If !Empty(QI3->QI3_METODO)
			Set Delete Off
			If SYP->(DbSeek(xFilial()+QI3->QI3_METODO))
				Do While SYP->(!EOf()) .And. QI3->QI3_METODO == SYP->YP_CHAVE
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
	ENDIF
	//   EndIf
Else
	apmsgAlert("Plano de Ação não cadastrada - Verifique")
EndIf

If nAlt > 0
	apMsgInfo("OK - Registros recuperados: " + Str(nAlt,6))
Else
	apMsgINFO("Não houve registros recuperados - Verifique")
EndIf

Set Delete On

Return