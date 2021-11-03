#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥RFATA014  ∫Autor  ≥Aparecida F.Stevanato ∫ Data ≥  01/06/08 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Funcao para Alterar Volumes da NF de Saida/Entrada ou PV    ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function RFATA014()

Private _nRet := .T.
cNFiscal   := Space(6)
cSerieNF   := Space(3)
cTipoEmb   := Space(15)
cTipoNF    := Space(15)
cTransp    := Space(6)
cLocEmb    := Space(30)
aTipoNF    := {"Pedido de Venda"}
nPesoBru   := 0
nPesoLiq   := 0
nVolumes   := 0

@ 089,185 To 480,600 Dialog _oDlg1 Title OemToAnsi("Volume Pedido de Venda")
@ 009,011 To 025,188
@ 025,011 To 170,188
@ 015,024 Say OemToAnsi("Esta rotina tem como objetivo Alterar o Cabec do PV") Size 151,010
//@ 035,024 Say OemToAnsi("Tipo PV................. : ")                        Size 055,006
@ 035,024 Say OemToAnsi("PV......................... : ")                     Size 055,006
//@ 065,024 Say OemToAnsi("Serie.................................. : ")         Size 055,006
@ 050,024 Say OemToAnsi("Peso Bruto............ : ")                 Size 055,006
@ 065,024 Say OemToAnsi("Peso Liquido......... : ")                   Size 055,006
@ 080,024 Say OemToAnsi("Qtde. Volumes...... : ")                     Size 055,006
@ 095,024 Say OemToAnsi("Tipo Embalagem........ : ")                          Size 055,006
@ 110,024 Say OemToAnsi("Transportadora......... : ")                         Size 055,006
@ 125,024 Say OemToAnsi("Local de Embarque... : ")                              Size 055,006
//@ 035,084 ComboBox cTipoNF Items aTipoNF                                      Size 055,020  object oTipoNF
@ 035,084 Get cNFiscal Valid ChecaNota() F3 "SC5"                           Size 030,008  object oNFiscal
//@ 065,084 Get cSerieNF Valid ChecaNota()                                      Size 020,008
@ 050,084 Get nPesoBru Picture "@E 9999999.999"                               Size 060,008
@ 065,084 Get nPesoLiq Valid ValPesos() Picture "@E 9999999.999"              Size 060,008
@ 080,084 Get nVolumes Picture "@E 999999"                                    Size 030,008
@ 095,084 Get cTipoEmb Picture "@!"                                 		  Size 060,008
@ 110,084 Get cTransp  Valid ValTransp() F3 "SA4"                    	      Size 060,008
@ 125,084 Get cLocEmb Picture "@!"                                 		      Size 100,008
@ 150,110 BmpButton Type 1 Action Processa( { || Atualiza() } )
@ 150,150 BmpButton Type 2 Action _fSaida()
Activate Dialog _oDlg1 Centered

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥Atualiza  ∫  fecha tela                                     ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function _fSaida()
_oDlg1:End()

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥Atualiza  ∫  Atualiza SC5                                   ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function Atualiza()
If _nRet .And. Alltrim(cNFiscal) <> ""
	If APMsgYesNo("*** Confirma AtualizaÁ„o ***")
		IF SC5->(dbSeek(xFilial("SC5") +cNFiscal))
			RecLock("SC5",.F.)
			SC5->C5_PBRUTO  := nPesoBru
			SC5->C5_PESOL   := nPesoLiq
			SC5->C5_ESPECI1 := cTipoEmb
			SC5->C5_VOLUME1 := nVolumes
			If Alltrim(cTransp) <> ""
				SC5->C5_TRANSP  := cTransp
			EndIf
			If Alltrim(cLocEmb) <> ""
				SC5->C5_E_LOCAL := cLocEmb
			EndIf
			SC5->(MsUnLock())
			ApMsgInfo("OK, AtualizaÁ„o efetuada !!!")
		ENDIF	
	EndIf
	cNFiscal   := Space(9)
	//cSerieNF   := Space(3)
	cTipoEmb   := Space(15)
	cTransp    := Space(6)
	cLocEmb    := Space(30)
	nPesoBru   := 0
	nPesoLiq   := 0
	nVolumes   := 0
	MS_FLUSH()
Endif
Return


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥Atualiza  ∫  Valida transportadora                          ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function ValTransp()
_nRet := .T.
If Alltrim(cTransp) <> ""
	SA4->(DbSetOrder(1))
	If !SA4->(DbSeek(xFilial("SA4")+cTransp))
		ApMsgStop("Transportadora n„o cadastrada !!!")
		_nRet := .F.
	EndIf
EndIf

Return _nRet

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥Atualiza  ∫  Valida transportadora                          ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function ValPesos()
_nRet := .T.
If nPesoLiq > nPesoBru
	ApMsgStop("Peso Liquido n„o poder ser maior que Peso Bruto !!!")
	_nRet := .F.
EndIf

Return _nRet

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥Atualiza  ∫  Atualiza Volume                                ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/Static Function ChecaNota()              // Verifica a ExistÍncia da Nota Fiscal
_nRet := .T.

If Alltrim(cNFiscal) <> ""
	IF SC5->(dbSeek(xFilial("SC5") +cNFiscal))
		If !Empty(SC5->C5_NOTA)
			apmsgStop("Pedido j· faturado !!!")
			_nRet := .F.
		Else
			nPesoBru := SC5->C5_PBRUTO
			nPesoLiq := SC5->C5_PESOL
			cTipoEmb := SC5->C5_ESPECI1
			nVolumes := SC5->C5_VOLUME1
			cTransp  := SC5->C5_TRANSP
			cLocEmb  := SC5->C5_E_LOCAL
		EndIf
	Else
		apmsgStop("Pedido n„o cadastrado !!!")
		_nRet := .F.
	EndIf
	If !_nRet
		cNFiscal := Space(9)
		cSerieNF := Space(3)
		oNFiscal:SetFocus()
		_nRet := .T.
	EndIf
Else
	_nRet := .F.
EndIf

Return _nRet