/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RESTA005  ºAutor  ³Aparecida de F.Stevanatoº Data  11/12/06 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se há produto cadastrado no local (0 ou 1)         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "Rwmake.ch"
#Include "Topconn.ch"

User Function RESTA005()
Private cCod   := ""
Private nEmpVD := 0
Private nEstq  := 0
Private nOrdem
Private cRet := .T.
Private nLocal := Alltrim(M->B1_LOCAL)

If Len(nLocal) >= 7 .And. (SubStr(nLocal,1,1) == "4" .OR. SubStr(nLocal,1,1) == "1")
	nOrdem := SB1->(OrdSetFocus())
	cCod   := M->B1_COD
	SB1->(DbSetOrder(9))
	SB2->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial()+nLocal))
		If Substr(SB1->B1_LOCAL,1,1) = "4"
			Do While Alltrim(SB1->B1_LOCAL) == nLocal .AND. !SB1->(EOF())
				nEmpVD := 0
				If SB2->(DbSeek(xFilial()+SB1->B1_COD))
					nEmpVD := SB2->B2_RESERVA
					nEstq  := SB2->B2_QATU
				EndIf
				If nEstq = 0
					ApMsgInfo("Atenção, Local sendo Reutilizado Produto => "+SB1->B1_COD+ " " + SB1->B1_DESC)
					RecLock("SB1",.F.)
					SB1->B1_LOCAL  :=  ""
					SB1->(MsUnLock())
					SB1->(DbSeek(xFilial()+nLocal))
				Else
					SB1->(DbSkip())
				EndIf
			EndDo
		Else
			M->B1_LOCAL := ""
			cRet := .F.
			ApMsgInfo("Atenção, Local já Utilizado para o Produto => "+SB1->B1_COD+ " " + SB1->B1_DESC)
		EndIf
	EndIf
	SB1->(OrdSetFocus(nOrdem))
	DbSeek(xFilial("SB1")+cCod)
EndIf

Return(cRet)
