#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMG003  ºAutor  ³Aparecida de F.Stevanatoº Data  05/05/06 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica dia da semana na data de entrega - Sol. Compras   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMG003()

Private aSemana := {"","Segunda-Feira","Terça-Feira","Quarta-Feira","Quinta-Feira","Sexta-Feira",""}
Private cFornec := ""
Private nForn   := 0
Private cProd   := ""
Private nPos    := 0
Private _lRet   := .T.

If Dow(M->C1_DATPRF) == 1  .Or. Dow(M->C1_DATPRF) == 7
	ApMsgStop("Data de Entrega não pode ser aos Sabados/Domingos")
	_lRet   := .F.
EndIf
IF SUBSTR(cNumEmp,1,2) <> "15"
	nPos  := Ascan(aHeader, { |x| Upper(Alltrim(x[2])) == "C1_PRODUTO"})
	cProd := aCols[n][nPos]
	SA5->(DbSetOrder(2))
	If SA5->(DbSeek(xFilial("SA5")+cProd))
		Do While ! SA5->(EOF()) .And. Alltrim(SA5->A5_PRODUTO) == Alltrim(cProd)
			cFornec := SA5->A5_FORNECE + SA5->A5_LOJA
			nForn++
			SA5->(DbSkip())
		EndDo
		If nForn == 1
			SA2->(DbSetOrder(1))
			If SA2->(DbSeek(xFilial("SA2")+cFornec))
				If Val(SA2->A2_MSDIASE) > 0  .And. Dow(M->C1_DATPRF) <> Val(SA2->A2_MSDIASE)
					ApMsgStop("Data de Entrega deve ser as "+aSemana[Val(SA2->A2_MSDIASE)])
					_lRet   := .F.
				EndIf
			EndIf
		EndIf
	EndIf
ENDIF

Return _lRet
