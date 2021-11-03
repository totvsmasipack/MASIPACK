#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³MS520DEL  ºAutor  ³Aparecida F.Stevanato º Data ³  02/10/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza Pedido e Estoque da N.Fiscal Cancelada             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MS520DEL()

Private cPedido    := ""
Private AtuEstoque := ""
Private cDescTes   := ""
Private cItem      := ""
Private cLoja      := ""
Private cTes       := ""
Private cProd      := ""
Private cCliente   := ""
Private cCFOP      := ""
Private nVlrUnit   := 0
Private nVlrTot    := 0
Private nQtdFat    := 0
Private fRet       := .T.
Private _lCompras  := .F.

// Campos que serao usados para envio de e_mail
Private _cTitulo   := ""
Private _cDestino  := ""
Private _cCco      := ""
Private _cMsg      := ""
Private _cAnexo    := ""
Private _cCli      := ""
Private _cUser     := Alltrim(UsrRetName(RetCodUsr()))


//If SubStr(cNumEmp,1,2) $ "01_10_40"
IF SUBSTR(cNumEmp,1,2) <> "15"
	If SF2->F2_TIPO $ "NIPC"
		cCliente := "C00" + SC6->C6_CLI
		SA1->(DbSetorder(1))
		If SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			_cCli := SA1->A1_NREDUZ
		EndIf
	Else
		cCliente := "00" + SC6->C6_CLI
		SA2->(DbSetorder(1))
		If SA2->(DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			_cCli := SA2->A2_NREDUZ
		EndIf
	EndIf

	If SC6->(DbSeek(xFilial("SC6")+Alltrim(SF2->F2_DOC)+Space(3)+SF2->F2_SERIE))
		Do While ! SC6->(Eof()) .And. Alltrim(SC6->C6_NOTA) == Alltrim(SF2->F2_DOC) .And. Alltrim(SC6->C6_SERIE) == Alltrim(SF2->F2_SERIE)
			cPedido  := SC6->C6_NUM
			cItem    := SC6->C6_ITEM
			cLoja    := SC6->C6_LOJA
			nVlrUnit := SC6->C6_PRCVEN
			nVlrTot  := SC6->C6_VALOR
			cProd    := SC6->C6_PRODUTO
			cTes     := SC6->C6_TES
			AtuEstoque := "N"
			SF4->(dbSetOrder(1))
			If SF4->(DbSeek(xFilial("SF4")+cTes))
				AtuEstoque := SF4->F4_ESTOQUE
			EndIf
			nQtdFat   := SC6->C6_QTDENT
			
			/*  TIRADO  19/08/13 -  LIZANDRA - O SISTEMA DEVE FAZER ISSO.
			If SubStr(cNumEmp,1,2) $ "01_10" .And. SC6->C6_MSATUB1 == "M"
			RecLock("SC6",.F.)
			SC6->C6_QTDLIB := 0
			SC6->C6_QTDENT := 0
			SC6->C6_NOTA   := ""
			SC6->C6_SERIE  := ""
			SC6->C6_DATFAT := CTOD("")
			SC6->C6_MSATUB1:= "N"
			SC6->(MsUnLock())
			Else
			*/
			RecLock("SC6",.F.)
			SC6->C6_MSATUB1 := "N"
			SC6->(MsUnLock())
			//         EndIf
			SC6->(DbSkip())
		EndDo
	EndIf
	//SC5->(DbSetOrder(6))
	SC5->(DBORDERNICKNAME("NOTASERIE"))
	If SC5->(DbSeek(xFilial("SC5")+SF2->F2_DOC))
		Do While ! SC5->(Eof()) .And. SC5->C5_NOTA == SF2->F2_DOC
			cPedido := SC5->C5_NUM
			If SC5->C5_MSCATEG $ "0_1_2" .OR. (SUBSTR(cNumEmp,1,2) $ '40_45')
				RecLock("SC5",.F.)
				SC5->C5_NOTA     := ""
				SC5->C5_SERIE    := ""
				SC5->C5_TIPLIB   := "1"
				SC5->C5_LIBEROK  := ""
				SC5->(MsUnLock())
			EndIf
			DbSelectArea("AA3")
			//AA3->(DbSetOrder(8))
			AA3->(DBORDERNICKNAME("AA3_PEDPRO"))
			If AA3->(DbSeek(xFilial("AA3")+cPedido))
				Do While ! AA3->(Eof()) .And. AA3->AA3_MSPED == cPedido
					RecLock("AA3",.F.)
					AA3->(DbDelete())
					AA3->(MsUnLock())
					AA3->(DbSkip())
				EndDo
			EndIf
			SZM->(DbSetOrder(9))
			If SZM->(DbSeek(xFilial("SZM")+"STARTU"+cPedido))         // Exclui o Acompanhamento de Pedido
				RecLock("SZM",.F.)
				SZM->(DbDelete())
				SZM->(MsUnLock())
			EndIf
			SC5->(DbSkip())
		EndDo
	EndIf
	
	// Retira do histórico de Itens do Cliente, do Pedido e Mensagens da Nota Fiscal - Nota fiscal cancelada
	/*
	DbSelectArea("SZN")
	SZN->(DbSetOrder(5))
	If SZN->(DbSeek(xFilial("SZN")+SF2->F2_DOC+SF2->F2_SERIE))
	Do While ! SZN->(Eof()) .And. Alltrim(SZN->ZN_NOTA) == Alltrim(SF2->F2_DOC) .And. SZN->ZN_SERIE == SF2->F2_SERIE
	RecLock("SZN",.F.)
	SZN->(DbDelete())
	SZN->(MsUnLock())
	SZN->(DbSkip())
	EndDo
	EndIf
	*/
	SZO->(DbSetOrder(1))
	If SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+Alltrim(SF2->F2_DOC)))         // Exclui as mensagens da nota fiscal
		RecLock("SZO",.F.)
		SZO->(DbDelete())
		SZO->(MsUnLock())
	EndIf
EndIf

Return fRet