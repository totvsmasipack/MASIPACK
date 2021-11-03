#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCONA002  ºAutor  ³ Lizandra Marques       ºData ³ 31/08/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ atualiza codigo de atividade i inss patronal no b5         º±±
±±º          ³ de acordo com a classificacao fiscal (SYD)                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCONA002()

If apmsgYesNo("Confirma Atualização da tabela Complemento de produtos?")
	
	MsgRun("Atualizando !!!!",, { || AlteraSB5() })
	
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AlteraSB5  ºAutor  ³ Lizandra marques  º Data ³  31/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetiva alteração no SB5                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AlteraSB5()

SB1->(DbSetOrder(1))
SB1->(DBGotop())
Do While ! SB1->(Eof())
	IF !EMPTY(SB1->B1_POSIPI)
		IF SB5->(dbSeek(xFilial("SB5") + SB1->B1_COD))
			SYD->(DbSetOrder(1))
			IF SYD->(DbSeek(xFilial("SYD")+SB1->B1_POSIPI))
				RecLock("SB5",.F.)
				SB5->B5_INSPAT := SYD->YD_MSPORTA
				SB5->B5_CODATIV:= SYD->YD_MSCATIV
			ENDIF
		ELSE
			SYD->(DbSetOrder(1))
			IF SYD->(DbSeek(xFilial("SYD")+SB1->B1_POSIPI))
				RecLock("SB5",.T.)
				SB5->B5_FILIAL  := xFilial("SB5")
				SB5->B5_COD     := SB1->B1_COD
				//Ivandro Santos - 12/04/17
				//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
				SB5->B5_CEME    := SB1->B1_DESC
				//SB5->B5_CEME  := IIF(!Empty(SB1->B1_DESCP),SB1->B1_DESCP,SB1->B1_DESC)
				//Ticket#2017031037000107 — Fim da alteração
				SB5->B5_INSPAT  := SYD->YD_MSPORTA
				SB5->B5_CODATIV := SYD->YD_MSCATIV
			ENDIF	
		ENDIF
		SB5->(MsUnlock())
	ENDIF
	SB1->(DbSetOrder(1))
	SB1->(dbSKip())
EndDo

Return
