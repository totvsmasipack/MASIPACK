#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATG006  ºAutor  ³Aparecida F.Stevanato º Data ³  02/10/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza Estoques - N.Fiscal Masipack                       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG006(NumNF)
Private AtuEstoque := ""
Private cGrpVendas := ""
Private cDescTes   := ""
Private cObs       := ""
Private cDesc      := ""

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	SF4->(dbSetOrder(1))
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	If SD2->(DbSeek(xFilial("SD2")+NumNF))
		Do While ! SD2->(Eof()) .And. SD2->D2_DOC == NumNF
			If SD2->D2_MSSZ8 <> "X"
				SC5->(DbSetOrder(1))
				If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
					cGrpVendas := SC5->C5_MSTPVEN
				EndIf
				AtuEstoque := "N"      //   atualizar pela Tes.
				cDescTes := SF4->F4_TEXTO
				If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
					AtuEstoque := SF4->F4_ESTOQUE
				Else
					ApMsgStop("TES não encontrada, Avise a Informatica: " + SD2->D2_DOC+SD2->D2_TES)
				EndIf
				cObs  := ""
				cDesc := ""
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
					cDesc := SB1->B1_DESC
					RecLock("SB1",.F.)
					If Empty(SB1->B1_MSGRVEN) .And. cGrpVendas == "RE"
						SB1->B1_MSGRVEN := "RE"
					EndIf
					If AtuEstoque == "S"
						SC6->(DbSetOrder(1))
						If SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
							cObs := SC6->C6_MSOBS
						EndIf

						RecLock("SC6",.F.)
						SC6->C6_MSATUB1 := "S"
						SC6->(MsUnLock())
					Else
						AtuEstoque := "N"
					EndIf
					SB1->(MsUnLock())
					RecLock("SD2",.F.)
					SD2->D2_MSSZ8 := "X"
					SD2->D2_MSOBS := "RFATG006 - SAIDA POR NF - " + cDescTes
					SD2->D2_MSUSER:= UsrRetName(RetCodUsr())
					SD2->(MsUnLock())
					//				GravaHistor()
				Else
					ApMsgStop("Produto não encontrado: " + SD2->D2_PRODUTO)
				EndIf
			EndIf
			SD2->(DbSkip())
		EndDo
		SD2->(DbSeek(xFilial("SD2")+NumNF))
	EndIf
ENDIF
Return
