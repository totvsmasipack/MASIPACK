/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥ M410STTS ∫Autor ≥Aparecida de F.Stevanato Data ≥12/02/2008 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Ponto de Entrada - Atualiza Data de Entrega nos Itens     ∫±±
±±∫          ≥  Atualiza Cliente Planejamento da eletronica (SZ1)         ∫±±
±±∫          ≥  Gera Acompanhamento de pedido (SZM)                       ∫±±
±±∫          ≥  Atualiza Categoria do Pedido de acordo com Depto.         ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

#include "rwmake.ch"
#include "protheus.ch"

User Function M410STTS()

Local I 
Local _oRadio 	:= Nil
Local _cVoltage := SPACE(03)
Local _aVoltage := {'200','380','400','415','440','460','480','575'}
Local _cFrequen := SPACE(02)
Local _aFrequen := {'50','60'}

Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cDeptoUsu := ""
Private _cGrupo    := ""
Private _aGrupos   := {}

Private cEvento   := ""
Private cCodDepDes:= ""
Private cDeptoDes := ""
Private cAssunto  := ""
Private nDias     := 0
Private fInclui   := .F.
Private cAux      := ""

// Campos que serao usados para envio de e_mail
Private _cTitulo   := ""
Private _cDestino  := ""
Private _cCco      := ""
Private _cMsg      := ""
Private _cCli      := ""
Private _cVend     := ""
Private _cAnexo    := ""

IF SUBSTR(cNumEmp,1,2) <> "15" .AND. SUBSTR(cNumEmp,1,2) <> "06"
	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario := PswRet()
		_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
		_aGrupos  := PswRet(1)[1][10]
		For I := 1 to Len(_aGrupos)
			_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
		Next I
		_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)
	EndIf
	
	SA1->(DbSetOrder(1))
	SZM->(DbSetOrder(1))
	
	If SubStr(cNumEmp,1,2) $ "01_10_11"
		// Atualiza Categoria na inclus„o do pedido de acordo com o depto. do usuario
		If Inclui
			RecLock("SC5",.F.)
			If "ENGENHARIA" $ UPPER(_cGrupo) .And. cEmpAnt == "01" .And. Alltrim(SC5->(C5_CLIENTE + C5_LOJACLI)) $ "00835200|99999900"
				SC5->C5_MSCATEG := "7"
			ElseIf "PROJETOS" $ UPPER(_cGrupo) .OR. "ENGENHARIA" $ UPPER(_cGrupo)
				SC5->C5_MSCATEG := "0"
			Else
				If _cDeptoUsu == "COMERCIAL"
					SC5->C5_MSCATEG := "1"
					// Envia e_mail para Gerente Comercial
					If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
						_cCli := SA1->A1_NREDUZ
					EndIf
					SA3->(DbSetorder(1))
					SA3->(DbGotop())
					If SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1))
						_cVend := SA3->A3_NREDUZ
					EndIf
					_cMsg  := "AtenÁ„o, Pedido Novo"+CHR(13)+CHR(10)
					_cMsg  += CHR(13)+CHR(10)
					_cMsg  += "Pedido: "+SC5->C5_NUM+ " - Data de Entrega: " + DTOC(SC5->C5_MSDTENT)+CHR(13)+CHR(10)
					_cMsg  += "Cliente: "+Alltrim(SC5->C5_CLIENTE)+"/"+SC5->C5_LOJACLI+" - "+_cCli+CHR(13)+CHR(10)
					_cMsg  += "Contrato: "+SC5->C5_ORCAM+CHR(13)+CHR(10)
					_cMsg  += "Vendedor: "+Alltrim(SC5->C5_VEND1)+" - "+_cVend+CHR(13)+CHR(10)
					_cMsg  += CHR(13)+CHR(10)
					//Alert(_cMsg)
					_cTitulo  := "Inclus„o de Pedido"
					If SubStr(cNumEmp,1,2) == "01"
						_cDestino := "sidnei.s@masipack.com.br"
					ElseIf SubStr(cNumEmp,1,2) == "10"
						_cDestino := "fabrima@fabrima.com.br"
					EndIf
					IF SC5->C5_CONDPAG $ 'VFF/VFC/VCA'
						_cDestino := ";cobranca@masipack.com.br;cobranca3@masipack.com.br;financeiro@masipack.com.br"
					ENDIF	
					_cCco     := ""
					oMail:= EnvMail():NEW(.F.)
					If oMail:ConnMail()
						oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
					EndIf
					oMail:DConnMail()
				ElseIf _cDeptoUsu == "COMEX/COMERCIAL"
					If SC5->C5_TIPOCLI == "X"
						SC5->C5_MSCATEG := "2"
					Else
						SC5->C5_MSCATEG := "3"
					EndIf
				ElseIf _cDeptoUsu == "VENDA DE PECAS"
					If SC5->C5_TIPOCLI == "X"
						SC5->C5_MSCATEG := "2"
					Else
						SC5->C5_MSCATEG := "3"
					EndIf
				ElseIf _cDeptoUsu == "203-MAKLASER"
					SC5->C5_MSCATEG := "5"
				ElseIf _cDeptoUsu == "ASSIST.TECNICA"
					SC5->C5_MSCATEG := "6"
				Else
					SC5->C5_MSCATEG := "4"
				EndIf
			EndIf
			SC5->C5_MSMONTA := CTOD(Space(8))
			SC5->(MsUnLock())
		Else
			If Altera .And. (SC5->C5_CLIENTE <> M->C5_CLIENTE .Or. SC5->C5_LOJACLI <> M->C5_LOJACLI)
				SZ1->(DbSetOrder(1))
				If SZ1->(DbSeek(xFilial("SZ1")+SC5->C5_NUM))
					RecLock("SZ1",.F.)
					SZ1->Z1_CODCLI  := SC5->C5_CLIENTE
					SZ1->Z1_LOJACLI := SC5->C5_LOJACLI
					If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
						SZ1->Z1_CLIENTE := SA1->A1_NOME
					EndIf
					SZ1->(MsUnlock())
				EndIf
			EndIf
		EndIf
		
		//VICTOR DESSUNTE - 10/07/2017
		//INICIO - TICKET: 2017070737000053
		If SC5->C5_MSCATEG == "1"
			If SC5->C5_VOLTAGE == 0 .OR. SC5->C5_HZ == 0
				_cVoltage := IIF(SC5->C5_VOLTAGE 	<> 0,ALLTRIM(STR(SC5->C5_VOLTAGE))	,SPACE(03))
				_cFrequen := IIF(SC5->C5_HZ 		<> 0,ALLTRIM(STR(SC5->C5_HZ))		,SPACE(02))
				
				DEFINE MSDIALOG _oDlg FROM  094,1 TO 230,340 TITLE "Informe o Campo!" PIXEL STYLE DS_MODALFRAME
								
				@ 05,07 TO 50, 165 OF _oDlg  PIXEL
				@ 10,13 SAY OemToAnsi("Os campos Voltagem e Frequencia devem ser preenchidos!") PIXEL
				@ 22,13 SAY OemToAnsi("Voltagem:") PIXEL
				@ 20,50 COMBOBOX _oRadio VAR _cVoltage ITEMS _aVoltage SIZE 060,080 PIXEL
				@ 37,13 SAY OemToAnsi("Frequencia:") PIXEL
				@ 35,50 COMBOBOX _oRadio VAR _cFrequen ITEMS _aFrequen SIZE 060,080 PIXEL
				_oDlg:lEscClose := .F.
								
				DEFINE SBUTTON FROM 053,140 TYPE 1 ENABLE OF _oDlg ACTION {|| IIF(!Empty(_cVoltage) .AND. !Empty(_cFrequen),_oDlg:End(),Alert("Preencher todos os campos!")) }
				ACTIVATE MSDIALOG _oDlg CENTERED
				
				If !Empty(_cVoltage) .AND. !Empty(_cFrequen)
					Reclock("SC5",.F.)
					SC5->C5_VOLTAGE	:= VAL(_cVoltage)
					SC5->C5_HZ		:= VAL(_cFrequen)
					SC5->(MsUnlock())
				EndIf
			EndIf
		EndIf
		//FIM - TICKET: 2017070737000053
		
		If SC5->C5_MSCATEG == "1" .And. _cDeptoUsu == "COMERCIAL"
			fInclui := .T.  //23/10/14 - LIZANDRA - REUNIAO COMERCIAL/FINANCEIRO
			If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
				Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
					cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
					If "VERIFICAR SINAL DO PV" $ cAux
						fInclui := .F.
					EndIf
					SZM->(dbSkip())
					Loop
				Enddo
			EndIf
			If fInclui
				cEvento   := "VERIFICAR SINAL DO PV."
				cAssunto  := "SINAL"
				cCodDepDes:= "FINANC"
				cDeptoDes := "FINANCEIRO"
				nDias     := 4
				GravaSZM()
			EndIf
			If SC5->C5_MSLAYEN == "S"
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Pedido possui LAY-OUT" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cEvento   := "Pedido possui LAY-OUT, Favor providencia-lo."
					cAssunto  := "LAYOUT"
					cCodDepDes:= "LAYOUT"
					cDeptoDes := "ENG.MECANICA(LAYOUT)"
					nDias     := 10
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSPLANT == "S"
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Pedido possui Planta de Embalagem" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cAssunto  := "PLANTA"
					cEvento   := "Pedido possui Planta de Embalagem, Favor providencia-la."
					cCodDepDes:= "ENGMEB"
					cDeptoDes := "ENG.MECANICA(EMBALAGEM)"
					nDias := 7
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSMOCK == "S"
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Pedido possui Mock-Up" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cAssunto  := "MOKUP"
					cEvento   := "Pedido possui Mock-Up, Favor providencia-lo."
					cCodDepDes:= "ENGMEB"
					cDeptoDes := "ENG.MECANICA(EMBALAGEM)"
					nDias := 7
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSDADFI == "S"
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Verificar DocumentaÁ„o junto" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cAssunto  := "FINANC"
					cEvento   := "Verificar DocumentaÁ„o junto ‡ ¿rea Adm/Financeira"
					cCodDepDes:= "FINANC"
					CDeptoDes := "FINANCEIRO"
					nDias     := 14
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSASSIN == "N"
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Contrato sem evidencia de Assinatura" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cAssunto  := "ASSINA"
					cEvento   := "Contrato sem evidencia de Assinatura! Favor contatar Cliente."
					cCodDepDes:= "COMERC"
					cDeptoDes := "COMERCIAL"
					nDias     := 30
					GravaSZM()
				EndIf
			EndIf
		// INCLUIDO 23/10/14 - REUNI√O COMRECIAL/FINANCEIRO - LIZANDRA
			If SC5->C5_CONDPAG == "VFF"  //VENDA FABRICANTE FINAME
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "PENDENCIA DOCUMENTACAO FINAME FABRICANTE" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cEvento   := "PENDENCIA DOCUMENTACAO FINAME FABRICANTE"
					cAssunto  := "DOCFIN"
					cCodDepDes:= "FINANC"
					cDeptoDes := "FINANCEIRO"
					nDias     := 10
					GravaSZM()
				EndIf
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "LIBERACAO PAC CLIENTE - FINAME FABRICANTE" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cEvento   := "LIBERACAO PAC CLIENTE - FINAME FABRICANTE"
					cAssunto  := "LIBPAC"
					cCodDepDes:= "FINANC"
					cDeptoDes := "FINANCEIRO"
					nDias     := 10
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_CONDPAG == "VFC"  //VENDA FABRICANTE FINAME
				fInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "LIBERACAO PAC CLIENTE - FINAME FABRICANTE" $ cAux
							fInclui := .F.
						EndIf
						SZM->(dbSkip())
						Loop
					Enddo
				EndIf
				If fInclui
					cEvento   := "LIBERACAO PAC CLIENTE - FINAME FABRICANTE"
					cAssunto  := "LIBPAC"
					cCodDepDes:= "FINANC"
					cDeptoDes := "FINANCEIRO"
					nDias     := 10
					GravaSZM()
				EndIf
			EndIf
		EndIf
		

		/*
		If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		Do While ! SC6->(Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
		RecLock("SC6",.F.)
		If SC5->C5_MSCATEG <> "5"
		SC6->C6_ENTREG  := SC5->C5_MSDTENT
		EndIf
		SC6->(MsUnLock())
		SC6->(DbSkip())
		Loop
		EndDo
		EndIf
		*/
	ENDIF
ENDIF

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥VICTOR DESSUNTE - 03/03/2016≥
//≥VERIFICA SE EXISTE EMPENHO  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
/*If SM0->M0_CODIGO $ "01*10" .AND. (INCLUI .OR. ALTERA)
	LJMSGRUN("Checando empenho dos produtos",,{|| MSENVEMPPV()})
EndIf*/

Return .T.

/*****************************/
Static Function GravaSZM()
/****************************/

Local _lGrava := .T.

If cAssunto == "LOGPV"
	SZM->(DbSetOrder(9))
	SZM->(DbGoTop())
	If SZM->(DbSeek(xFilial("SZM")+"LOGPV "+SC5->C5_NUM))
		Do While SZM->(!Eof()) .And. SZM->ZM_PEDIDO == SC5->C5_NUM .And. Alltrim(SZM->ZM_ASSUNTO) == "LOGPV"
			If SZM->ZM_DATA == Date()
				If "Montagem" $ SZM->ZM_EVENTO
					_lGrava := .F.
				EndIf
			EndIf
			SZM->(DbSkip())
		EndDo
	EndIf
Else
	If cAssunto == "LAYOUT" .OR. cAssunto == "MOKUP" .OR. cAssunto == "ASSINA"
		SZM->(DbSetOrder(9))
		SZM->(DbGoTop())
		If SZM->(DbSeek(xFilial("SZM")+Alltrim(cAssunto)+SC5->C5_NUM))
			_lGrava := .F.
		EndIf
	EndIf
EndIf

If _lGrava
	RecLock("SZM",.T.)
	SZM->ZM_FILIAL  := "01"
	SZM->ZM_PEDIDO  := SC5->C5_NUM
	SZM->ZM_CODCLI  := SC5->C5_CLIENTE
	SZM->ZM_LOJACLI := SC5->C5_LOJACLI
	If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		SZM->ZM_CLIENTE := SA1->A1_NREDUZ
	EndIf
	SZM->ZM_DATA    := Date()
	SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
	SZM->ZM_DEPTO   := _cDeptoUsu
	SZM->ZM_ASSUNTO := cAssunto
	If cAssunto <> "LOGPV"
		SX5->(DbGotop())
		If SX5->(DbSeek(xFilial("SX5")+"ZE"+SZM->ZM_ASSUNTO))
			SZM->ZM_NOASSUN := SubStr(X5DESCRI(),1,30)
		EndIf
		SZM->ZM_STATUS  := "A"
	Else
		SZM->ZM_NOASSUN := "LOG DO PV"
		SZM->ZM_STATUS  := "E"
	EndIf
	SZM->ZM_EVENTO  := cEvento
	SZM->ZM_CODDEPT := cCodDepDes
	SZM->ZM_DEPTDES := cDeptoDes
	If cAssunto == "PROTES"
		SZM->ZM_DTPREV  := SC5->C5_MSDTENT - 15
	Else
		SZM->ZM_DTPREV  := Date() + nDias
	EndIf
	SZM->ZM_INIMONT := SC5->C5_MSMONTA
	SZM->(MsUnLock())
EndIf

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MSENVEMPPV∫Autor  ≥Victor Dessunte     ∫ Data ≥  03/03/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Envia e-mail com quantidades empenhadas no pedido de venda  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Masipack                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function MSENVEMPPV()

Local _aAreaF4	:= SF4->(GetAreA())
Local _aAreaB1	:= SB1->(GetArea())
Local _nX 		:= 0
Local _nEmp		:= 0
Local _cProd	:= ""
Local _cHtml1	:= ""
Local _cHtml2	:= ""
Local _cHtml3	:= ""
Local _cHtml4	:= ""
Local _cDesc	:= ""
Local _cBoa		:= ""
Local _cEmp		:= ""
Local _lOk		:= .F.
Local _nConta	:= 0

dbSelectArea("SF4")
SF4->(dbSetOrder(1))

dbSelectArea("SB2")
SB2->(dbSetOrder(1))

If SubStr(Time(),1,2) < "12"
	_cBoa := "Bom dia!"
ElseIf SubStr(Time(),1,2) < "18"
	_cBoa := "Boa tarde!"
Else
	_cBoa := "Boa noite!"
EndIf

If SM0->M0_CODIGO == "01"
	_cEmp := "Masipack"
ElseIf SM0->M0_CODIGO == "10"
	_cEmp := "Fabrima"
EndIf

_cHtml2+="<html>"
_cHtml2+="	<body>"
_cHtml2+="		<center>"
_cHtml2+="			<table cellspacing=0 cellpadding=2 bordercolor='ffffff' border='1' style='border-collapse: collapse;' >"
_cHtml2+="				<tr>"
_cHtml2+="					<td colspan ='6' bgcolor='#191970'><b><font color='#FFFFFF' size=5 face='Calibri'><CENTER>Pedido de Venda: " + M->C5_NUM + "<BR>"
_cHtml2+="						Cliente:" + M->C5_CLIENTE+"-"+M->C5_LOJACLI+" "+POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NREDUZ")+"</CENTER></font></b></td>"
_cHtml2+="				</tr>"
_cHtml2+="				<tr>"
_cHtml2+="					<td bgcolor='#696969'><b><font color='#FFFFFF' size=2 face='Calibri'>Item</font></b></td>"
_cHtml2+="					<td bgcolor='#696969'><b><font color='#FFFFFF' size=2 face='Calibri'>Codigo</font></b></td>"
_cHtml2+="					<td bgcolor='#696969'><b><font color='#FFFFFF' size=2 face='Calibri'>DescriÁ„o</font></b></td>"
_cHtml2+="					<td bgcolor='#696969'><b><font color='#FFFFFF' size=2 face='Calibri'>QTD. Vendida</font></b></td>"
_cHtml2+="					<td bgcolor='#696969'><b><font color='#FFFFFF' size=2 face='Calibri'>Saldo em estoque</font></b></td>"
_cHtml2+="					<td bgcolor='#696969'><b><font color='#FFFFFF' size=2 face='Calibri'>Total empenhado(incluindo Vendas)</font></b></td>"
_cHtml2+="				</tr>"

_cCor := "#E0FFFF"
For _nX:=1 To Len(aCols)
	If SF4->(dbSeek(xFilial("SF4")+aCols[_nX,GDFIELDPOS("C6_TES")]))
		If SF4->F4_ESTOQUE == 'S'
			If SB2->(dbSeek(xFilial("SB2")+aCols[_nX,GDFIELDPOS("C6_PRODUTO")]))
				_nEmp := u_MSEMPENHO(aCols[_nX,GDFIELDPOS("C6_PRODUTO")])
				If _nEmp > 0 .AND. _nEmp > SB2->B2_QATU
					_cDesc := POSICIONE("SB1",1,xFilial("SB1")+aCols[_nX,GDFIELDPOS("C6_PRODUTO")],"B1_DESC")
					If _cCor == "#FFFFFF"
						_cCor := "#E0FFFF"
					Else
						_cCor := "#FFFFFF"
					EndIf
					
					_cHtml3+="<tr>"
					_cHtml3+="	<td bgcolor='" + _cCor + "'><font color='#000000' size=2 face='Calibri'>" + aCols[_nX,GDFIELDPOS("C6_ITEM")] 															+ "</font></td>"
					_cHtml3+="	<td bgcolor='" + _cCor + "'><font color='#000000' size=2 face='Calibri'>" + aCols[_nX,GDFIELDPOS("C6_PRODUTO")] 														+ "</font></td>"
					_cHtml3+="	<td bgcolor='" + _cCor + "'><font color='#000000' size=2 face='Calibri'>" + _cDesc 																								+ "</font></td>"
					_cHtml3+="	<td bgcolor='" + _cCor + "'><font color='#000000' size=2 face='Calibri'>" + Transform(aCols[_nX,GDFIELDPOS("C6_QTDVEN")],PESQPICT("SC6","C6_QTDVEN"))	+ "</font></td>"
					_cHtml3+="	<td bgcolor='" + _cCor + "'><font color='#000000' size=2 face='Calibri'>" + Transform(SB2->B2_QATU,PESQPICT("SB2","B2_QATU")) 									+ "</font></td>"
					_cHtml3+="	<td bgcolor='" + _cCor + "'><font color='#000000' size=2 face='Calibri'>" + Transform(_nEmp,"@E 999,999,999.99")														+ "</font></td>"
					_cHtml3+="</tr>"
					
					_nConta++
					_lOk := .T.
				EndIf
			EndIf
		EndIf
	EndIf
Next _nX

_cHtml4+="				<tr>"
_cHtml4+="					<td colspan ='6' bgcolor='#ffffff'><font color='#000000' size=2 face='Calibri'><CENTER><br><br><br><br>E-mail gerado autom·ticamente<br>Favor n„o responder este e-mail.</CENTER></font></td>"
_cHtml4+="				</tr>"
_cHtml4+="			</table>"
_cHtml4+="		</center>"
_cHtml4+="	</body>"
_cHtml4+="</html>"

_cHtml1:= _cBoa + CRLF + CRLF

If _nConta == 1
	_cHtml1+= "O item abaixo foi acrescentado e seus empenhos podem interferir em outras vendas ou na produÁ„o"
Else
	_cHtml1+= "Os itens abaixo foram acrescentados e seus empenhos podem interferir em outras vendas ou na produÁ„o"
EndIf                                            	

If _lOk
	oMail:= EnvMail():NEW(.F.)
	If oMail:ConnMail()
		oMail:SendMail("PV - VerificaÁ„o Empenho X Estoque ("+_cEmp+")",SUPERGETMV("MS_XFUN001",,""),,,_cHtml1+CRLF+CRLF+CRLF+_cHtml2+_cHtml3+_cHtml4)
	EndIf
	oMail:DConnMail()
EndIf

RestArea(_aAreaB1)
RestArea(_aAreaF4)

Return
