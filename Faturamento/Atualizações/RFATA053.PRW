#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATA053  ºAutor  ³Aparecida F.Stevanato º Data ³  17/05/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza Desconto (Orçamento/Pedido de Venda)               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA053()

Private _cProd   := ""
Private _fRet    := .T.
Private _nAlt    := 0
Private _nMoeda  := 1
Private _nPreco  := 0
Private _cTabela := ""

aOpcao   := {"1-Orçamento","2-Pedido de Venda"}
_aOper   := {"1-Desconto","2-Acréscimo"}
cOpcao   := Space(15)
_cOper   := Space(15)
cNum     := Space(6)
cItem    := Space(2)
nPerc    := 0.00

DEFINE MSDIALOG _oDlg1 FROM  090,1 TO 380,330 TITLE "Atualiza Desconto/Acréscimo - Vendas" PIXEL
@ 010,015 Say "Esta rotina Atualiza Desconto/Acréscimo(Orcamento/PV)"          Size 151,010 OF _oDlg1 PIXEL
@ 020,000 Say Replicate("_",100)                                     Size 200,010 PIXEL COLOR CLR_HBLUE
@ 035,015 Say "Opção..........................................: "    Size 065,006 PIXEL COLOR CLR_HBLUE
@ 050,015 Say "Orcamento/Pedido............: " 						 Size 065,006 PIXEL COLOR CLR_HBLUE
@ 065,015 Say "Item...............................................:" Size 065,006 PIXEL COLOR CLR_HBLUE
@ 068,110 Say "(Brancos p/Todos)" 	                                 Size 045,006 PIXEL COLOR CLR_HBLUE
@ 080,015 Say "Desconto / Acréscimo....: "                           Size 065,006 PIXEL COLOR CLR_HBLUE
@ 095,015 Say "Percentual.............................:"             Size 065,006 PIXEL COLOR CLR_HBLUE
@ 035,080 ComboBox cOpcao Items aOpcao                               Size 060,010 OBJECT oOpcao
@ 050,080 MsGet cNum                                                 Size 035,010 PIXEL OF _oDlg1
@ 065,080 MsGet cItem Valid ValCadastro()                            Size 025,010 PIXEL OF _oDlg1
@ 080,080 ComboBox _cOper Items _aOper                               Size 060,010 OBJECT oOpera
@ 095,080 MsGet nPerc Picture "99.99" Valid _ValPerc()               Size 035,010 PIXEL OF _oDlg1
@ 120,050 BmpButton Type 1 Action Processa( { || _AtuDesc()} )
@ 120,100 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1  Centered
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AtuDesc          º  Atualiza Desconto conforme Opcao        º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _AtuDesc()
If Alltrim(cNum) == ""
	Return
EndIf

If nPerc == 0
	If !MsgBox("*** ATENÇÃO, Deseja Zerar o Desconto ???","AVISO","YESNO")
		Return
	EndIf
EndIf

If SubStr(cOpcao,1,1) == "1"
	If Alltrim(cItem) == ""
		SCK->(DbSeek(xFilial("SCK")+cNum))
		Do While SCK->(!Eof()) .And. SCK->CK_NUM == cNum
//			IF SUBSTR(cNumEmp,1,2) = "01" // ALTERADO 01/10/13 - CALCULOS DIFERENTES PARA FABRIMA/MASIPACK - LIZANDRA
				RecLock("SCK",.F.)                      
				IF SUBSTR(_cOper,1,1) == "1"
//					IF _nMoeda == 1
						SCK->CK_PRCVEN  := SCK->CK_PRCVEN - (SCK->CK_PRCVEN  * nPerc / 100)
//					ELSE
//						SCK->CK_PRCVEN  := (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda)) - (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//					ENDIF					
				ELSE
//					IF _nMoeda == 1
						SCK->CK_PRCVEN  := SCK->CK_PRCVEN + (SCK->CK_PRCVEN  * nPerc / 100)
//					ELSE
//						SCK->CK_PRCVEN  := (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda)) + (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//					ENDIF					
				ENDIF	
				SCK->CK_PRUNIT  := SCK->CK_PRCVEN
				SCK->CK_VALOR   := SCK->CK_PRCVEN * SCK->CK_QTDVEN
				SCK->CK_MSDESC  := nPerc
				SCK->CK_DESCONT := 0
				SCK->CK_VALDESC := 0
				SCK->(MsUnLock())
				_nAlt++
			/*  // tirado em 10/02/15 - a pedido da Fabrima (Maria) - Lizandra		
			ELSE  // CALCULO FABRIMA
				_cProd := Alltrim(SCK->CK_PRODUTO)
				_AtuCK_C6()
			ENDIF
			*/	
			
			SCK->(DbSkip())
		EndDo
	Else
//		IF SUBSTR(cNumEmp,1,2) = "01" // ALTERADO 01/10/13 - CALCULOS DIFERENTES PARA FABRIMA/MASIPACK - LIZANDRA
			RecLock("SCK",.F.)
			IF SUBSTR(_cOper,1,1) == "1"
//				IF _nMoeda == 1
					SCK->CK_PRCVEN  := SCK->CK_PRCVEN - (SCK->CK_PRCVEN  * nPerc / 100)
//				ELSE
//					SCK->CK_PRCVEN  := (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda)) - (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//				ENDIF					
			ELSE
//				IF _nMoeda == 1
					SCK->CK_PRCVEN  := SCK->CK_PRCVEN + (SCK->CK_PRCVEN  * nPerc / 100)
//				ELSE
//					SCK->CK_PRCVEN  := (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda)) + (SCK->CK_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//				ENDIF					
			ENDIF				
			SCK->CK_PRUNIT  := SCK->CK_PRCVEN
			SCK->CK_VALOR   := SCK->CK_PRCVEN * SCK->CK_QTDVEN
			SCK->CK_MSDESC  := nPerc
			SCK->CK_DESCONT := 0
			SCK->CK_VALDESC := 0
			SCK->(MsUnLock())
			_nAlt++
			/*  // tirado em 10/02/15 - a pedido da Fabrima (Maria) - Lizandra		
		ELSE  // CALCULO FABRIMA
			_AtuCK_C6()
		ENDIF
		*/	
	EndIf
ElseIf SubStr(cOpcao,1,1) == "2"
	If Alltrim(cItem) == ""
		SC6->(DbSeek(xFilial("SC6")+cNum))
		Do While SC6->(!Eof()) .And. SC6->C6_NUM == cNum
			If SC6->C6_QTDENT == 0
//				IF SUBSTR(cNumEmp,1,2) = "01" // ALTERADO 01/10/13 - CALCULOS DIFERENTES PARA FABRIMA/MASIPACK - LIZANDRA
					RecLock("SC6",.F.)
					IF SUBSTR(_cOper,1,1) == "1"
//						IF _nMoeda == 1
							SC6->C6_PRCVEN  := SC6->C6_PRCVEN - (SC6->C6_PRCVEN  * nPerc / 100)
//						ELSE
//							SC6->C6_PRCVEN  := (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda)) - (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//						ENDIF					
					ELSE
//						IF _nMoeda == 1
							SC6->C6_PRCVEN  := SC6->C6_PRCVEN + (SC6->C6_PRCVEN  * nPerc / 100)
//						ELSE
//							SC6->C6_PRCVEN  := (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda)) + (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//						ENDIF					
					ENDIF	
					SC6->C6_PRUNIT  := SC6->C6_PRCVEN
					SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
					SC6->C6_MSDESC  := nPerc
					SC6->C6_DESCONT := 0
					SC6->C6_VALDESC := 0
					SC6->(MsUnLock())
					_nAlt++
			/*  // tirado em 10/02/15 - a pedido da Fabrima (Maria) - Lizandra		
				ELSE // CALCULO FABRIMA
					_cProd := Alltrim(SC6->C6_PRODUTO)
					_AtuCK_C6()
				ENDIF
			*/
			EndIf
			SC6->(DbSkip())
		EndDo
	Else
//		IF SUBSTR(cNumEmp,1,2) = "01" // ALTERADO 01/10/13 - CALCULOS DIFERENTES PARA FABRIMA/MASIPACK - LIZANDRA
			RecLock("SC6",.F.)
			IF SUBSTR(_cOper,1,1) == "1"
//				IF _nMoeda == 1
					SC6->C6_PRCVEN  := SC6->C6_PRCVEN - (SC6->C6_PRCVEN  * nPerc / 100)
//				ELSE
//					SC6->C6_PRCVEN  := (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda)) - (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//				ENDIF					
			ELSE
//				IF _nMoeda == 1
					SC6->C6_PRCVEN  := SC6->C6_PRCVEN + (SC6->C6_PRCVEN  * nPerc / 100)
//				ELSE
//					SC6->C6_PRCVEN  := (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda)) + (SC6->C6_PRCVEN / RecMoeda(Date(),_nMoeda) * nPerc / 100)
//				ENDIF					
			ENDIF			
			SC6->C6_PRUNIT  := SC6->C6_PRCVEN
			SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
			SC6->C6_MSDESC  := nPerc
			SC6->C6_DESCONT := 0
			SC6->C6_VALDESC := 0
			SC6->(MsUnLock())
			_nAlt++
			/*  // tirado em 10/02/15 - a pedido da Fabrima (Maria) - Lizandra		
		ELSE	// CALCULO FABRIMA
			_AtuCK_C6()
		ENDIF
		*/
	EndIf
EndIf
If _nAlt > 0
	apMsgInfo("Atualizacão Efetuada com sucesso !!!!")
Else
	apMsgStop("Não Houve Atualização - Verifique !!!!")
EndIf

cNum  := Space(6)
cItem := Space(2)
nPerc := 0.00
Return

Static Function _AtuCK_C6()
If SubStr(_cOper,1,1) == "1"
	If Empty(_cTabela)
		If SB1->(DbSeek(xFilial("SB1")+_cProd))
			If _nMoeda == 1
				_nPreco  := SB1->B1_PRV1 - (SB1->B1_PRV1  * nPerc / 100)
			Else
				_nPreco := (SB1->B1_PRV1 / RecMoeda(Date(),_nMoeda)) - (SB1->B1_PRV1 / RecMoeda(Date(),_nMoeda) * nPerc / 100)
			EndIf
		Else
			ApMsgStop("Produto não encontrado => " + _cProd)
			Return
		EndIf
	Else
		If DA1->(DbSeek(xFilial("DA1")+_cTabela+_cProd))
			_nPreco := DA1->DA1_PRCVEN - (DA1->DA1_PRCVEN * nPerc / 100)
		Else
			ApMsgStop("Item não encontrado na Tabela de Preço => " + _cProd)
			Return
		EndIf
	EndIf
else
	If Empty(_cTabela)
		If SB1->(DbSeek(xFilial("SB1")+_cProd))
			If _nMoeda == 1
				_nPreco  := SB1->B1_PRV1 + (SB1->B1_PRV1  * nPerc / 100)
			Else
				_nPreco := (SB1->B1_PRV1 / RecMoeda(Date(),_nMoeda)) + (SB1->B1_PRV1 / RecMoeda(Date(),_nMoeda) * nPerc / 100)
			EndIf
		Else
			ApMsgStop("Produto não encontrado => " + _cProd)
			Return
		EndIf
	Else
		If DA1->(DbSeek(xFilial("DA1")+_cTabela+_cProd))
			_nPreco := DA1->DA1_PRCVEN + (DA1->DA1_PRCVEN * nPerc / 100)
		Else
			ApMsgStop("Item não encontrado na Tabela de Preço => " + _cProd)
			Return
		EndIf
	EndIf
ENDIF
If SubStr(cOpcao,1,1) == "1"
	RecLock("SCK",.F.)
	SCK->CK_PRCVEN  := _nPreco
	SCK->CK_PRUNIT  := _nPreco
	SCK->CK_VALOR   := SCK->CK_PRCVEN * SCK->CK_QTDVEN
	SCK->CK_MSDESC  := nPerc
	SCK->CK_DESCONT := 0
	SCK->CK_VALDESC := 0
	SCK->(MsUnLock())
ElseIf SubStr(cOpcao,1,1) == "2"
	RecLock("SC6",.F.)
	SC6->C6_PRCVEN  := _nPreco
	SC6->C6_PRUNIT  := _nPreco
	SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
	SC6->C6_MSDESC  := nPerc
	SC6->C6_DESCONT := 0
	SC6->C6_VALDESC := 0
	SC6->(MsUnLock())
EndIf
_nAlt++
Return



Static Function ValCadastro()
SB1->(DbSetOrder(1))
SC5->(DbSetOrder(1))
SC5->(DbGotop())
SC6->(DbSetOrder(1))
SCJ->(DbSetOrder(1))
SCJ->(DbGotop())
SCK->(DbSetOrder(1))
_fRet    := .T.
_cTabela := ""
If SubStr(cOpcao,1,1) == "1"
	If !SCJ->(DbSeek(xFilial("SCJ")+cNum))
		ApMsgStop("Orçamento não encontrado")
		_fRet := .F.
	Else
		If SCJ->CJ_STATUS == "B"
			ApMsgStop("Orçamento já efetivado")
			_fRet := .F.
		Else
			_nMoeda  := SCJ->CJ_MOEDA
			_cTabela := SCJ->CJ_TABELA
			If Alltrim(cItem) <> ""
				If !SCK->(DbSeek(xFilial("SCK")+cNum+cItem))
					ApMsgStop("Item do Orçamento não encontrado:" + cNum+"/"+cItem)
					_fRet := .F.
				Else
					_cProd := Alltrim(SCK->CK_PRODUTO)
				EndIf
			EndIf
		EndIf
	EndIf
ElseIf Substr(cOpcao,1,1) == "2"
	If !SC5->(DbSeek(xFilial("SC5")+cNum))
		ApMsgStop("Pedido não encontrado")
		_fRet := .F.
	Else
		If !Empty(SC5->C5_NOTA)
			ApMsgStop("Pedido já Faturado ou Eliminado por residuo")
			_fRet := .F.
		Else
			_nMoeda  := SC5->C5_MOEDA
			_cTabela := SC5->C5_TABELA
			If Alltrim(cItem) <> ""
				If !SC6->(DbSeek(xFilial("SC6")+cNum+cItem))
					ApMsgStop("Item do Pedido não encontrado: " + cNum+"/"+cItem)
					_fRet := .F.
				Else
					If SC6->C6_QTDENT > 0
						ApMsgStop("Já houve faturamento para este Item" + cNum)
						_fRet := .F.
					Else
						_cProd := Alltrim(SC6->C6_PRODUTO)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
If !_fRet
	_fRet := .T.
	cNum  := Space(6)
	cItem := Space(2)
	nPerc := 0.00
EndIf
Return _fRet

Return

Static Function _ValPerc()
_fRet := .T.
If nPerc < 0
	ApMsgStop("Percentual não pode ser negativo")
	_fRet := .F.
EndIf
Return _fRet