#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RFATA030L ºAutor  ³Microsiga           º Data ³  28/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ATUALIZAÇÃO DA TABELA SZM - APV                            º±±
±±º          ³ REESCRITO                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA030()

Local aSX5ZF 	  := {}
Private _cUsuario := RetCodUsr()
Private _aUsuario := {}
Private cCadastro := "Acompanhamento de Pedido"
Private cDeptoUsu := ""
Private cDeptoOri := ""
Private cDeptoDes := ""
Private cUsuSenha := ""
Private fRet      := .T.
Private cDepto    := ""
Private cStatus   := ""
Private _cFiltro  := ""
Private aDeptos   := {}
Private aChaves   := {}
Private aLogs     := {}
Private cEng      := ""
Private _lRet     := .T.
Private _lGrava   := .T.
Private cTexto    := ""
Private cPedido   := ""
Private cEvento   := ""
Private I         := 0
Private oDlg, oList1, oList2, nList1:= 1, nList2 := 0, aItems:={},nItem := 0
Private cPerg := "XRFATA030"
Private _cTitulo  := "" // Campos que serao usado para envio de e_mail
Private _cDestino := ""
Private _cCco     := ""
Private _cHtml    := ""
Private _cAnexo   := ""
Private cVldOK    := "" // Validacao da tela (botao OK) - Inclusao e alteracao. Pode-se utilizar ExecBlock.
Private cVldExc   := "" // Validacao para permitir a exclusao.  Pode-se utilizar ExecBlock.
Private _cDE	  := GetMV("MV_WFMAIL")
Private _cSenha	  := GetMV("MV_WFPASSW")
Private aRotina	  := {}
	
	aRotina := {	{"Pesquisa" ,"AxPesqui"		,0,1} ,;	// Pesquisa
					{"Visualiza","AxVisual"		,0,2} ,;	// Visualiza
					{"Inclui"   ,"u_INCAPV"		,0,3} ,;	// Inclui
					{"Altera"   ,"u_ALTAPV"		,0,4} ,;	// Altera
					{"Exclui"   ,"u_EXCAPV"		,0,5} ,;	// Exclui
					{"Legenda"  ,"u_Legenda()"	,0,6} ,;	// Legenda
					{"Lib Almox","u_LibAlmox"	,0,4} }		// Libera ao Almox

	Pergunte(cPerg,.T.)

	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario := PswRet()
		cUsuSenha := UsrRetName(_cUsuario)
		cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
		If SubStr(cNumEmp,1,2) == "01" .AND. SUBSTR(cDeptoUsu,1,12) == "ENG.MECANICA"
			cDeptoUsu := "ENG.MECANICA"
		EndIf
	EndIf

	mv_par02 := Upper(mv_par02)
	mv_par03 := Upper(Alltrim(mv_par03))
	mv_par04 := Upper(mv_par04)

	SC5->(DbSetOrder(1))

	dbSelectArea("SZM")
	SZM->(dbSetOrder(1))

	If SubStr(mv_par03,1,2) <> "ZZ" .Or. mv_par03 <> ""
		If !SZM->(DbSeek(xFilial("SZM")+mv_par03))
			ApMsgAlert("Não há acompanhamento para este pedido !!!")
			mv_par03 := ""
		EndIf
	EndIf

	_cFiltro := ""

	If mv_par01 == 5// Filtra Status do APV
		_cFiltro := '(Alltrim(SZM->ZM_STATUS) == "A" .Or. Alltrim(SZM->ZM_STATUS) == "P" .Or. Alltrim(SZM->ZM_STATUS) == "R")'
	ElseIf mv_par01 == 4
		_cFiltro := '(Alltrim(SZM->ZM_STATUS) == "E")'
	ElseIf mv_par01 == 3
		_cFiltro := '(Alltrim(SZM->ZM_STATUS) == "P")'
	ElseIf mv_par01 == 2
		_cFiltro := '(Alltrim(SZM->ZM_STATUS) == "A")'
	ElseIf mv_par01 == 1
		_cFiltro := ""
	EndIf

	If SubStr(mv_par02,1,2) <> "ZZ" .And. Alltrim(mv_par02) <> ""
/*		SX5->(DbGotop())
		If SX5->(DbSeek(xFilial("SX5")+"ZF"+mv_par02))
			cDepto :=  Alltrim(SubStr(X5DESCRI(),1,20)) // Deve estar com 20 posicoes = tamanho na tabela (SZM)
			cDepto := Upper(cDepto)
		EndIf
		If !Empty(Alltrim(_cFiltro))
			_cFiltro += ' .And. '
		EndIf
		IF "PCP" $ cDepto
			_cFiltro += 'cDepto $ Alltrim(SZM->ZM_CODDEPT)'  //Alterado para atender 201-MONTAGEM
		ELSE
			_cFiltro += '(cDepto $ Alltrim(SZM->ZM_DEPTO) .Or. cDepto $ Alltrim(SZM->ZM_DEPTDES))'  //Alterado para atender 201-MONTAGEM
		ENDIF
*/
		aSX5ZF := FwGetSX5('ZF',MV_PAR02)
		IF Len(aSX5ZF) > 0 .And. !Empty(aSX5ZF[1,4])
			cDepto := UPPER(Alltrim(SubStr(aSX5ZF[1,4],1,20))) // Deve estar com 20 posicoes = tamanho na tabela (SZM)
		Endif

		If !Empty(_cFiltro)
			_cFiltro += ' .And. '
		EndIf

		IF "PCP" $ cDepto
			_cFiltro += 'cDepto $ Alltrim(SZM->ZM_CODDEPT)'  //Alterado para atender 201-MONTAGEM
		ELSE
			_cFiltro += '(cDepto $ Alltrim(SZM->ZM_DEPTO) .Or. cDepto $ Alltrim(SZM->ZM_DEPTDES))'  //Alterado para atender 201-MONTAGEM
		ENDIF

	EndIf

	If SubStr(mv_par03,1,2) <> "ZZ" .And. Alltrim(mv_par03) <> ""  // Filtra Pedido
		If !Empty(Alltrim(_cFiltro))
			_cFiltro += ' .And. '
		EndIf
		_cFiltro += '(SZM->ZM_PEDIDO == mv_par03)'
	EndIf
	If SubStr(mv_par04,1,2) <> "ZZ" .And. Alltrim(mv_par04) <> ""  // Filtra Assunto
		If !Empty(Alltrim(_cFiltro))
			_cFiltro += ' .And. '
		EndIf
		_cFiltro += '(Alltrim(SZM->ZM_ASSUNTO) == Alltrim(mv_par04))'
	EndIf

	SET FILTER TO &_cFiltro


	aCores := {}// CORES APV
	If (SUBSTR(cNumEmp,1,2) $ '01_10')
		aCores := {{"ZM_STATUS  <> 'E' .AND. !(ZM_ASSUNTO  = 'AUTORI' .AND. ZM_STATUS  = 'A') .AND. !(ZM_ASSUNTO  = 'LIBPV ' .AND. ZM_STATUS  = 'A') .AND. !(ZM_STATUS  = 'B') .AND. !(ZM_STATUS  = 'P' .AND. ZM_ASSUNTO = 'AUTORI').AND. !(ZM_ASSUNTO  = 'LIBPV ' .AND. ZM_STATUS  = 'S') .AND. !(ZM_STATUS  = 'S')     " ,'BR_VERDE'   },;
		{"ZM_ASSUNTO  = 'AUTORI' .AND. ZM_STATUS  = 'A'"                            ,'BR_BRANCO'  },;
		{"ZM_ASSUNTO  = 'LIBPV ' .AND. ZM_STATUS  = 'A'"                            ,'BR_MARROM'  },;
		{"ZM_ACEITE = .T. .OR. ZM_STATUS  = 'E'   "                                 ,'BR_VERMELHO'},;
		{"ZM_STATUS  = 'B' "                                                        ,'BR_PINK'    },;
		{"ZM_STATUS  = 'P' .AND. ZM_ASSUNTO = 'AUTORI'"                             ,'BR_LARANJA' },;
		{"ZM_STATUS  = 'S' .AND. ZM_ASSUNTO = 'LIBPV '"                             ,'BR_AZUL'    },;
		{"(ZM_ASSUNTO = 'AUTORI' .OR.  ZM_ASSUNTO = 'LIBPV ') .AND. ZM_STATUS = 'E'",'DISABLE'}}
	ENDIF
	mBrowse( 6, 1, 22, 75, "SZM",,,,,, aCores )
Return
///////////////////////////////////////
///////////LEGENDA DE CORES ///////////
///////////////////////////////////////
User Function Legenda()
	Local aLegenda  := {}
	Local cCadastro := "APV"

	AADD(aLegenda,{"BR_VERDE" 		,"Fabrica Geral"				})
	AADD(aLegenda,{"BR_BRANCO" 	,"Aguardando Lib. PCP"		})
	AADD(aLegenda,{"BR_MARROM" 	,"Aguardando Sep. Almox"	})
	AADD(aLegenda,{"BR_VERMELHO" 	,"Encerrado"					})
	AADD(aLegenda,{"BR_PINK" 		,"Beneficiamento"				})
	AADD(aLegenda,{"BR_LARANJA" 	,"em Processo PCP"			})
	AADD(aLegenda,{"BR_AZUL" 		,"em Separação Atlmox."		})
	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidaOK  ºAutor  ³MASIPACK       º Data      ³  05/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite Alteração e Exclusão somente pelos usuários        º±±
±±º          |                              dos Deptos. Origem e Destino  º±±
±±º          | 23/01/09 - Dispara e_mail na inclusão do assunto PRAZO     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSTudoOk(nOpc)

	Private _cTipo := ""

	fRet := .T.
	IF nOpc ==4
		SC5->(DbSetOrder(1))
		SC5->(DbGoTop())
		_cTipo := SC5->C5_TIPO
		If !SC5->(DbSeek(xFilial("SC5")+M->ZM_PEDIDO))
			apmsgStop("Pedido de venda não localizado: " + M->ZM_PEDIDO)
			fRet := .F.
			Return fRet
		Else
			cEng  := SC5->C5_MSENG
		EndIf
	ENDIF
	If nOpc == 3
		M->ZM_MSUSER := cUsuSenha
		If SubStr(cNumEmp,1,2) == "01" .AND. Alltrim(cUsuSenha) == "Carlao" .And. cEng == "H"
			M->ZM_DEPTO  := "ENG.MECANICA HORIZ."
		Else
			
			M->ZM_DEPTO  := Upper(Alltrim(_aUsuario[1][12])) //cDeptoUsu, acessar novamente => Deptos Engenharia Mecanica e Horizontal
			
		EndIf
		
		M->ZM_LIDO   := .F.
		M->ZM_ACEITE := .F.
		M->ZM_COMENT := ""
		
		If Alltrim(M->ZM_ASSUNTO) == "PRAZO" // Prepara para envio de e_mail, quando o assunto for alteracao no prazo de entrega
			_chtml	   := "<html>"+CRLF
			_chtml	   += "		<body>"+CRLF
			_chtml     += "			O Pedido abaixo, necessita alteração no prazo de entrega.<br><br>"+CRLF
			_chtml     += "			Data de entrega inicial: "+DTOC(SC5->C5_MSDTENT)+"<br>"+CRLF
			_chtml     += "			Data de entrega efetiva: "+DTOC(SC5->C5_MSDTPEN)+"<br>"+CRLF
			_chtml     += "			Pedido: "+M->ZM_PEDIDO+"<br>"+CRLF
			_chtml     += "			Cliente: "+M->ZM_CLIENTE+"<br>"+CRLF
			_chtml     += "			Emitente: "+Alltrim(M->ZM_MSUSER) + " - Depto: "+ Upper(Alltrim(M->ZM_DEPTO))+"<br>"+CRLF
			_chtml     += "			Destino: "+Alltrim(M->ZM_DEPTDES)+"<br>"+CRLF
			_chtml     += "			<BR>"+CRLF
			_chtml     += "			Evento: "+Alltrim(M->ZM_EVENTO)+"<br>"+CRLF
			_chtml     += "			Depto. Comercial, favor: <br>"+CRLF
			_chtml     += "			  .  Comunicar Cliente;<br>"+CRLF
			_chtml     += "			  .  Ajustar data no sistema de acordo com a nova negociação.<br><br>"+CRLF
			_chtml     += "			Por favor, verifique os documentos em sua área (Acompanhamento de Pedido de Vendas - APV, Ordens de Producao X Pedido de Vendas, entre outros).<br><br>"+CRLF
			_chtml     += "			Obrigado."+CRLF
			_chtml	   += "		</body>"+CRLF
			_chtml	   += "</html>"+CRLF
			_ctitulo  := "Alteração no Prazo de Entrega"
			_cDestino := Alltrim(GetMV("MS_RF30PRA"))+Alltrim(GetMV("MS_RF30PR1"))
			_cCco     := ""
			oMail:= EnvMail():NEW(.F.)
			If oMail:ConnMail()
				oMail:SendMail(_ctitulo,_cDestino,,,_chtml)
			EndIf
			oMail:DConnMail()
		Else
			U_EmailComercial()
		EndIf
	ElseIf nOpc == 4
		cDeptoOri := Upper(Alltrim(SZM->ZM_DEPTO))
		If SUBSTR(cDeptoOri,1,12) == "ENG.MECANICA"
			cDeptoOri := "ENG.MECANICA"
		EndIf
		cDeptoDes := Upper(Alltrim(SZM->ZM_DEPTDES))
		If SUBSTR(cDeptoDes,1,12) == "ENG.MECANICA"
			cDeptoDes := "ENG.MECANICA"
		EndIf
//		If SubStr(cDeptoUsu,1,5) <> "INFOR" .And. SubStr(cDeptoUsu,1,5) <> "ADMIN"
		If !FWIsAdmin()
			IF (cDeptoUsu == cDeptoDes .AND. "ALMOX" $ UPPER(cDeptoUsu)) .OR. "PCP" $ cDeptoUsu .OR. "QUALIDADE" $ cDeptoUsu 
				fRet := .T.
			ELSE
				If !(cDeptoUsu $ cDeptoOri) .And. !(cDeptoOri $ cDeptoUsu) .And. cDeptoUsu <> cDeptoDes
					ApMsgStop("Somente o Depto. Origem e Destino poderão Alterar este Evento !!!")
					fRet := .F.
				Else
					If cDeptoUsu == cDeptoOri .And. cDeptoUsu <> cDeptoDes
						If SZM->ZM_COMENT <> M->ZM_COMENT .Or. SZM->ZM_ACEITE <> M->ZM_ACEITE .Or. SZM->ZM_LIDO <> M->ZM_LIDO
							ApMsgStop("Somente o Depto. Destino poderá Alterar Comentario, Lido e Concluido !!!")
							fRet := .F.
						EndIf
					EndIf
					If cDeptoUsu == cDeptoDes .And. cDeptoUsu <> cDeptoOri
						If SZM->ZM_ASSUNTO <> M->ZM_ASSUNTO .Or. SZM->ZM_EVENTO <> M->ZM_EVENTO .Or. SZM->ZM_CODDEPT <> M->ZM_CODDEPT .Or. SZM->ZM_STATUS <> M->ZM_STATUS .Or. SZM->ZM_DTPREV <> M->ZM_DTPREV
							ApMsgStop("Somente o Depto. Origem poderá Alterar estas informações !!!")
							fRet := .F.
						EndIf
					EndIf
				EndIf
			ENDIF
		EndIf
		If fRet
			If SZM->ZM_STATUS <> M->ZM_STATUS .And. M->ZM_STATUS == "R"
				If M->ZM_ACEITE
					M->ZM_ACEITE  := .F.
					M->ZM_ULTALT  := Date()
					M->ZM_HORAALT := Time()
				Else
					ApMsgStop("Reavaliar somente quando o Evento foi concluido pelo Destino !!!")
					fRet := .F.
				EndIf
			EndIf
			If M->ZM_ACEITE .And. (SZM->ZM_EVENTO <> M->ZM_EVENTO .Or. SZM->ZM_CODDEPT <> M->ZM_CODDEPT)
				ApMsgStop("Informação não pode ser alterada com a Conclusão do Depto. Destino!!!")
				fRet := .F.
			EndIf
			If SZM->ZM_ACEITE .And. (SZM->ZM_COMENT <> M->ZM_COMENT)
				ApMsgStop("Informação não pode ser alterada - Evento já Concluido!!!")
				fRet := .F.
			EndIf
			If SZM->ZM_STATUS <> M->ZM_STATUS .And. M->ZM_STATUS == "E" .And. !M->ZM_ACEITE
				ApMsgStop("Este Evento só poderá ser Encerrado após a Conclusão do Depto. Destino !!!")
				fRet := .F.
			Else
				M->ZM_USUALTE := cUsuSenha
				M->ZM_ULTALT  := Date()
				M->ZM_HORAALT := Time()
			EndIf
		EndIf
		If fRet
			If SZM->ZM_LIDO <> M->ZM_LIDO
				If M->ZM_LIDO
					M->ZM_STATUS  := "P"
					M->ZM_USULIDO := cUsuSenha
					M->ZM_DTLIDO  := Date()
				Else
					If Empty(Alltrim(M->ZM_COMENT))
						M->ZM_USULIDO := ""
						M->ZM_DTLIDO  := CTOD("")
					EndIf
				EndIf
			EndIf
			If !Empty(Alltrim(M->ZM_COMENT)) .And. !M->ZM_LIDO
				M->ZM_LIDO := .T.
				M->ZM_USULIDO := cUsuSenha
				M->ZM_DTLIDO  := Date()
			EndIf
			If SZM->ZM_ACEITE <> M->ZM_ACEITE
				If M->ZM_ACEITE
					M->ZM_USUACEI := cUsuSenha
					M->ZM_USUALTE := cUsuSenha
					M->ZM_DTACEIT := IIF(Empty(M->ZM_DTACEIT),Date(),M->ZM_DTACEIT)
					If !M->ZM_LIDO
						M->ZM_LIDO := .T.
						M->ZM_USULIDO := cUsuSenha
						M->ZM_DTLIDO  := Date()
					EndIf
				Else
					M->ZM_USUACEI := ""
					M->ZM_DTACEIT := CTOD("")
				EndIf
			EndIf
			If SZM->ZM_ASSUNTO <> M->ZM_ASSUNTO .Or. SZM->ZM_EVENTO <> M->ZM_EVENTO .Or. SZM->ZM_CODDEPT <> M->ZM_CODDEPT .Or. SZM->ZM_DTPREV <> M->ZM_DTPREV .Or. SZM->ZM_COMENT <> M->ZM_COMENT
				M->ZM_ULTALT := Date()
				M->ZM_HORAALT := Time()
			EndIf
			If SZM->ZM_EVENTO <> M->ZM_EVENTO
				M->ZM_EVENTO := Alltrim(M->ZM_EVENTO)+ CHR(13)+CHR(10) + "*** Ultima alteração em " + DTOC(Date()) + " as " +  Time()+ " ***"
			EndIf
			If SZM->ZM_COMENT <> M->ZM_COMENT
				M->ZM_COMENT := Alltrim(M->ZM_COMENT)+ CHR(13)+CHR(10) + "*** Ultima alteração em " + DTOC(Date()) + " as " +  Time() + " ***"
			EndIf
			U_EmailComercial()
			aLogs := {}
			If M->ZM_ASSUNTO == "LOGAPV"
				If !Empty(M->ZM_DTCOM)
					AADD(aLogs,{M->ZM_DTCOM,"COMERC"})
				EndIf
				If !Empty(M->ZM_DTENG)
					If cEng == "V"
						AADD(aLogs,{M->ZM_DTENG,"ENGMCV"})
					ElseIf cEng == "H"
						AADD(aLogs,{M->ZM_DTENG,"ENGMCH"})
					ElseIf cEng == "E"
						AADD(aLogs,{M->ZM_DTENG,"ENGMCE"})
					EndIf
				EndIf
				If !Empty(M->ZM_DTPROD)
					AADD(aLogs,{M->ZM_DTPROD,"PCP"})
				EndIf
				If !Empty(M->ZM_DTMONT)
					AADD(aLogs,{M->ZM_DTMONT,"MONTAG"})
				EndIf
				If !Empty(M->ZM_DTTEST)
					AADD(aLogs,{M->ZM_DTTEST,"TESTES"})
				EndIf
			EndIf
			If M->ZM_ASSUNTO == "STARTU" .And. SZM->ZM_STATUS <> M->ZM_STATUS .And. M->ZM_STATUS == "E"
				U_EmailMokup()
			EndIf
		EndIf
		
		If Upper(Alltrim(M->ZM_DEPTO)) == "ASSIST.TECNICA" .And. Upper(Alltrim(M->ZM_ASSUNTO)) == "CHATEC"
			If Val(M->ZM_PEDIDO) == 0
				ApMsgStop("Por favor, Informe um Numero de Pedido para o Chamado Tecnico!!!")
				fRet := .F.
			Else
				If _cTipo = "N"
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+M->ZM_CODCLI+M->ZM_LOJACLI))
				If AllTrim(SA1->A1_RISCO) $ "D_E"
					ApMsgStop("Cliente possui restrição financeira. Favor verificar com Depto. Financeiro!!!")
					fRet := .F.
				Else
					If Empty(M->ZM_CODTEC)
						ApMsgStop("Por favor informe o tecnico para este evento !!!")
						fRet := .F.
					EndIf
				EndIf
				EndIf
			EndIf
		EndIf
		If (Upper(Alltrim(M->ZM_DEPTO)) == "DOCUMENTACAO TECNICA" .Or. Upper(Alltrim(M->ZM_DEPTDES)) == "DOCUMENTACAO TECNICA")
			IF SZM->ZM_ACEITE <> M->ZM_ACEITE .AND. SZM->ZM_ACEITE .And. Upper(Alltrim(cUsuSenha)) <> Upper(Alltrim(GetMV("MS_APVUSCO")))
				ApMsgStop("Somente o Usuário "+Alltrim(GetMV("MS_APVUSCO"))+" pode alterar APV Concluído!!!")
				fRet := .F.
			Endif
		Endif
		If fRet
			If nOpc == 3
				DeptoDestino()
			EndIf
			If nOpc == 4 .And. Len(aLogs) > 0
				cPedido := M->ZM_PEDIDO
			EndIf
		EndIf

	ELSEIF nOpc == 5
		
		If Upper(SubStr(cDeptoUsu,1,5)) <> "INFOR" .And. Upper(SubStr(cDeptoUsu,1,5)) <> "ADMIN" .And.  Upper(Alltrim(cUsuSenha)) <> Upper(Alltrim(SZM->ZM_MSUSER)) // Informatica e o proprio usuario
			ApMsgStop("Somente o proprio Usuário poderá excluir este Evento !!!")
			fRet := .F.
		Else
			If SZM->ZM_STATUS $ "P_R"
				ApMsgStop("Evento em processo não pode ser excluido !!!")
				fRet := .F.
			EndIf
		EndIf
	ENDIF

Return fRet

User Function EmailMokup()

	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+SZM->ZM_CODCLI+SZM->ZM_LOJACLI))
		_cCli := SA1->A1_NREDUZ
	EndIf
	_cHtml  := "<html>"+CRLF
	_cHtml  += "		<body>"+CRLF
	_cHtml  += "			Instalação de maquina concluida no Cliente:<br><br>"+CRLF
	_cHtml  += "			Pedido: " + SZM->ZM_PEDIDO + " - APV encerrado em: " + DTOC(Date()) + "<br>"+CRLF
	_cHtml  += "			Cliente: "+Alltrim(SZM->ZM_CODCLI)+"/"+SZM->ZM_LOJACLI+" - "+_cCli+"<br><br>"+CRLF
	_cHtml  += "			Descartar o MOKUP após " + DTOC(Date() + 10)+", Sómente se o Cliente não solicitar ajustes.<br>"+CRLF
	_cHtml  += "			Se houver solicitação de ajustes, o Depto. Técnico informará através de email.<br><br>"+CRLF
	_cHtml  += "		</body>"+CRLF
	_cHtml  := "</html>"+CRLF
	_cTitulo  := "Maquina Instalada - Descartar MOKUP"
	_cDestino := "embalagem@masipack.com.br;doc.tec@masipack.com.br;comercial@masipack.com.br;vendas@masipack.com.br"
	oMail:= EnvMail():NEW(.F.)
	If oMail:ConnMail()
		oMail:SendMail(_ctitulo,_cDestino,,,_chtml)
	EndIf
	oMail:DConnMail()

Return

User Function EmailComercial()

	If Upper(Alltrim(M->ZM_DEPTO)) == "COMERCIAL" .Or. Upper(Alltrim(M->ZM_DEPTDES)) == "COMERCIAL"  // Prepara para envio de e_mail, quando o depto (origem ou destino) - Comercial
		_chtml     := "<html>"+CRLF
		_chtml     += "		<body>"+CRLF
		_chtml     += "			E_mail informativo não é necessário responde-lo.<br><br>"+CRLF
		_chtml     += "			Pedido: "+M->ZM_PEDIDO+"<br>"+CRLF
		_chtml     += "			Cliente: "+M->ZM_CLIENTE+"<br><br>"+CRLF
		_chtml     += "			Depto Origem: "+Alltrim(M->ZM_DEPTO)+"<br><br>"+CRLF
		_chtml     += "			Evento: "+Alltrim(M->ZM_EVENTO)+"<br><br>"+CRLF
		_chtml     += "			Depto Destino: "+Alltrim(M->ZM_DEPTDES)+"<br>"+CRLF
		_chtml     += "		</body>"+CRLF
		_chtml     += "</html>"+CRLF
		If Alltrim(M->ZM_COMENT) <> ""
			_cHtml  += "		<br>Comentario do Destino: "+Alltrim(M->ZM_COMENT)+"<br>"+CRLF
		EndIf
		If M->ZM_STATUS == "A"
			cStatus := "Aberto"
		ElseIf M->ZM_STATUS == "P"
			cStatus := "Em Processo"
		ElseIf M->ZM_STATUS == "A"
			cStatus := "Encerrado"
		Else
			cStatus := "Reavaliar"
		EndIf
		_cHtml     += "		<br>Status: "+cStatus+"<br>"+CRLF
		_cTitulo  := "Acompanhamento de PV - Assunto: " + M->ZM_NOASSUN
		_cUF:=Posicione("SA1",1,xFilial("SA1")+M->ZM_CLIENTE+M->ZM_LOJACLI,"A1_EST")
		IF SubStr(cNumEmp,1,2)=="01"
			_cDestino := "vendas@masipack.com.br;comercial@masipack.com.br"
			_cCco     := ""
		Else
			_cDestino := "carlos.augusto@fabrima.com.br;crelia.saldanha@fabrima.com.br"
			If _cUF == "EX"
				_cCco     := "dirval.reis@fabrima.com.br"
			EndIf
		EndIf
		oMail:= EnvMail():NEW(.F.)
		If oMail:ConnMail()
			oMail:SendMail(_ctitulo,_cDestino,,,_chtml)
		EndIf
		oMail:DConnMail()
	ElseIf (Upper(Alltrim(M->ZM_DEPTO)) == "ASSIST.TECNICA" .AND. "ENG.MECANICA" $ Upper(Alltrim(M->ZM_DEPTDES)) ) .OR. ("ENG.MECANICA" $ Upper(Alltrim(M->ZM_DEPTO))  .AND. Upper(Alltrim(M->ZM_DEPTDES)) == "ASSIST.TECNICA")  // Prepara para envio de e_mail, quando o depto (origem E destino) - AT - ENG.MEcânica vice-versa
		_cHtml    := "<html>"+CRLF
		_cHtml	  += "		<body>"+CRLF
		_cHtml	  += "			E_mail informativo não é necessário responde-lo.<br><br>"+CRLF
		_cHtml    += "			Pedido: "+M->ZM_PEDIDO+"<br>"+CRLF
		_cHtml    += "			Cliente: "+M->ZM_CLIENTE+"<br><br>"+CRLF
		_cHtml    += "			Depto Origem: "+Alltrim(M->ZM_DEPTO)+"<br><br>"+CRLF
		_cHtml    += "			Evento: "+Alltrim(M->ZM_EVENTO)+"<br><br>"+CRLF
		_cHtml    += "			Depto Destino: "+Alltrim(M->ZM_DEPTDES)+"<br>"+CRLF
		If Alltrim(M->ZM_COMENT) <> ""
			_cHtml  += "		<br>Comentario do Destino: "+Alltrim(M->ZM_COMENT)+"<br>"+CRLF
		EndIf
		If M->ZM_STATUS == "A"
			cStatus := "Aberto"
		ElseIf M->ZM_STATUS == "P"
			cStatus := "Em Processo"
		ElseIf M->ZM_STATUS == "A"
			cStatus := "Encerrado"
		Else
			cStatus := "Reavaliar"
		EndIf
		_cHtml     += "			<br>Status: "+cStatus+"<br>"+CRLF
		_cTitulo  := "Acompanhamento de PV - Assunto: " + M->ZM_NOASSUN
		_cUF:=Posicione("SA1",1,xFilial("SA1")+M->ZM_CLIENTE+M->ZM_LOJACLI,"A1_EST")
		If SubStr(cNumEmp,1,2)=="01"
			If Upper(Alltrim(M->ZM_DEPTO)) == "ASSIST.TECNICA"
				_cDestino := "carlos.p@masipack.com.br;alessandra@masipack.com.br"
			ElseIf  Upper(Alltrim(M->ZM_DEPTDES)) $ "ENG.MECANICA"
				_cDestino :="olivia@masipack.com.br"
			EndIf
			_cCco     := ""
		Else
			If _cUF == "EX"
				_cCco     := "dirval.reis@fabrima.com.br"
			EndIf
		Endif
		oMail:= EnvMail():NEW(.F.)
		If oMail:ConnMail()
			oMail:SendMail(_ctitulo,_cDestino,,,_chtml)
		EndIf
		oMail:DConnMail()
	EndIf

Return

Static Function DeptoDestino()

Local aSX5ZF := FwGetSX5('ZF')
Local nX	 := 0

/*
	SX5->(DbGotop())
	If SX5->(DbSeek(xFilial("SX5")+"ZF"))
		Do While SX5->(!Eof())
			If Alltrim(SX5->X5_TABELA) == "ZF"
				If M->ZM_CODDEPT <> SX5->X5_CHAVE
					nItem++
					AADD(aChaves,SX5->X5_CHAVE)
					AADD(aItems,Strzero(nItem,2)+" - "+ X5DESCRI())
				EndIf
			EndIf
			SX5->(DbSkip())
		EndDo
	EndIf
*/
	For nX := 1 To Len(aSX5ZF)
		If !(M->ZM_CODDEPT == aSX5ZF[nX,3])
			nItem++
			AADD(aChaves,aSX5ZF[nX,3])
			AADD(aItems,Strzero(nItem,2)+" - "+ aSX5ZF[nX,4])
		EndIf
	Next nX

	DEFINE MSDIALOG oDlg FROM 0,0 TO 370,550 PIXEL TITLE "Duplica Evento p/Outros Deptos.?"
	oList1:= tListBox():New(10,10,{|u|if(Pcount()>0,nList1:=u,nList1)},aItems,100,140,,oDlg,,,,.T.)
	oList2:= tListBox():New(10,170,{|u|if(Pcount()>0,nList2:=u,nList2)},aDeptos,100,100,,oDlg,,,,.T.)
	@ 040,125 BUTTON "ADICIONA" SIZE 30,12 ACTION U_AddDepto()
	@ 065,125 BUTTON "REMOVE"   SIZE 30,12 ACTION U_DelDepto()
	@ 130,170 BUTTON "Grava Evento p/Deptos. Selecionados" SIZE 100,15 ACTION U_GravaDepto()
	ACTIVATE MSDIALOG oDlg CENTERED

Return nil

User Function AddDepto()

Local I

	_lRet := .T.
	If Len(aDeptos) > 0
		For I := 1 to Len(aDeptos)
			If aItems[nList1] == aDeptos[I]
				apmsgStop("Depto. já foi escolhido")
				_lRet := .F.
			EndIf
		Next I
	EndIf
	If _lRet
		cTexto := aItems[nList1]
		AADD(aDeptos,cTexto)
		oList2:Refresh()
		oList2:SetArray(aDeptos)
	EndIf
	Return

	User Function DelDepto()

	oList2:Del(nList2)
	oList2:Refresh()
	oList2:SetArray(aDeptos)

Return

User Function GravaDepto()

Local aSX5ZF	:= {}
Local I

	Local J := 0

	For I := 1 to Len(aDeptos)
		J := Val(SubStr(aDeptos[I],1,2))
		RecLock("SZM",.T.)
		SZM->ZM_Filial  := "01"
		SZM->ZM_PEDIDO  := M->ZM_PEDIDO
		SZM->ZM_MSCAT   := M->ZM_MSCAT
		SZM->ZM_CODCLI  := M->ZM_CODCLI
		SZM->ZM_LOJACLI := M->ZM_LOJACLI
		SZM->ZM_CLIENTE := M->ZM_CLIENTE
		SZM->ZM_DATA    := Date()
		SZM->ZM_MSUSER  := M->ZM_MSUSER
		SZM->ZM_DEPTO   := M->ZM_DEPTO
		SZM->ZM_ASSUNTO := M->ZM_ASSUNTO
		SZM->ZM_NOASSUN := M->ZM_NOASSUN
		SZM->ZM_RESUMO  := M->ZM_RESUMO
		SZM->ZM_EVENTO  := M->ZM_EVENTO
		SZM->ZM_CODDEPT := aChaves[J]
/*		If SX5->(DbSeek(xFilial("SX5")+"ZF"+aChaves[J]))
			SZM->ZM_DEPTDES := X5DESCRI()
*/		
		aSX5ZF := FwGetSX5('ZF',aChaves[J])
		If Len(aSX5ZF) > 0 .And. !Empty(aSX5ZF[1,4])
			SZM->ZM_DEPTDES := aSX5ZF[1,4]
		Else
			SZM->ZM_DEPTDES := "DEPTO. NAO ENCONTRADO"
		EndIf
		SZM->ZM_DTPREV  := M->ZM_DTPREV
		SZM->ZM_STATUS  := M->ZM_STATUS
		SZM->ZM_CODTEC  := M->ZM_CODTEC
		SZM->ZM_LIDO    := .F.
		SZM->ZM_ACEITE  := .F.
		SZM->ZM_COMENT  := ""
		SZM->ZM_COPIA  := .T.
		SZM->(MsUnlock())
	Next I
	oDlg:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALTAPV    ºAutor  ³Lizandra/Eduardo    º Data ³  11/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Alteração de APV                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALTAPV()

	Local nOpca := 0
	Local aParam := {}

	cCadastro := "Alteração APV" // título da tela
	Opca := AxAltera("SZM",SZM->(Recno()),4,,,,,"U_MSTudoOk(4)","","",,aParam,,,.T.,,,,,)

Return nOpca

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXCAPV    ºAutor  ³Microsiga           º Data ³  11/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida exclusão APV                                        º±±
³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EXCAPV()

	Local nOpca := 0
	Local aParam := {}

	cCadastro := "Exclusão" // Título da tela
	Opca := AxDeleta("SZM",SZM->(Recno()),5) 

Return nOpca

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCAPV    ºAutor  ³Lizandra/Eduardo    º Data ³  11/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Inclusão de APV                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INCAPV()

	Local nOpca := 0
	Local aParam := {}

	cCadastro := "Inclusão APV" // Título da tela
	Opca := AxInclui("SZM",SZM->(Recno()), 3,,,,"U_MSTudoOk(3)",.F.,"",,aParam,,,.T.,,,,,)                                                                      

Return nOpca


User Function LibAlmox()

Local I

Private fRet := .T. 
_cUsuario  := RetCodUsr()
_aUsuario  := {}
_cDeptoUsu := ""
_cGrupo    := ""
_aGrupos   := {}

          
_aArea := GetArea()       

PswOrder(1)
IF PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cDeptoUsu := UPPER(Alltrim(_aUsuario[1][12]))
	_aGrupos  := PswRet(1)[1][10]
	FOR I := 1 TO LEN(_aGrupos)
		_cGrupo += UPPER(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	NEXT I
	_cGrupo := SUBSTR(_cGrupo,1,LEN(_cGrupo)-1)
ENDIF

aOpcao   := {"Liberação PV para almoxarifado"}
cOpcao   := Space(20)
cPedido  := Space(6)
cItem    := Space(2)
DEFINE MSDIALOG _oDlg1 FROM  090,1 TO 330,330 TITLE "Liberação PV para almoxarifado" PIXEL  
@ 010,030 Say "Esta rotina libera PV para separação no estoque"      Size 151,010 OF _oDlg1 PIXEL
@ 020,000 Say Replicate("_",100)                                     Size 200,010 PIXEL COLOR CLR_HBLUE	
@ 055,024 Say "Pedido de Vendas : " 	  	    	               Size 055,006 PIXEL COLOR CLR_HBLUE	
@ 055,075 MsGet cPedido F3 "SC5"                                     Size 045,010 PIXEL OF _oDlg1
@ 095,080 BmpButton Type 1 Action Processa( { || AtuSC5() } )
@ 095,115 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1  Centered

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuSC5    ºAutor  ³Lizandra	           º Data ³  10/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtuSC5()

Local fInclui := .T.       
Local _cOBS   := ""
Local _cCOMENT:= ""

dbSelectArea('SC5')
SC5->(DbSetOrder(1))

IF SC5->(dbSeek(xFilial("SC5")+cPedido))
	RecLock("SC5",.F.)
	SC5->C5_MSPRIOR := "2"    
	MsUnlock()                       

	IF SZM->(DbSeek(xFilial("SZM")+Alltrim(cPedido)))
		DO WHILE !SZM->(EOF()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(cPedido)
			cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
			IF "AUTORIZACAO P/ FABRICAR PV" $ cAux
				_cOBS   := SZM->ZM_OBS
				_cCOMENT:= SZM->ZM_COMENT
			ENDIF
			SZM->(dbSkip())
			Loop
		ENDDO
	ENDIF

	IF SZM->(DbSeek(xFilial("SZM")+Alltrim(cPedido)))
		DO WHILE !SZM->(EOF()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(cPedido)
			cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
			IF "LIBERACAO PV P/ FATURAMENTO" $ cAux
				_cOBS   := SZM->ZM_OBS
				_cCOMENT:= SZM->ZM_COMENT
				fInclui := .F.
			ENDIF
			SZM->(dbSkip())
			Loop
		ENDDO
	ENDIF         
	IF !fInclui  
		IF apmsgYesNo("Já existe um APV para esse pedido. Confirma inclusão?")
			RecLock("SZM",.T.)
			SZM->ZM_FILIAL  := "01"
			SZM->ZM_PEDIDO  := SC5->C5_NUM
			SZM->ZM_MSCAT   := SC5->C5_MSCATEG
			SZM->ZM_CODCLI  := SC5->C5_CLIENTE
			SZM->ZM_LOJACLI := SC5->C5_LOJACLI
			SZM->ZM_CLIENTE := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
			SZM->ZM_DATA    := Date()
			SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
			SZM->ZM_DEPTO   := _cDeptoUsu
			SZM->ZM_ASSUNTO := "LIBPV"                   
			SX5->(DbGotop())
			If SX5->(DbSeek(xFilial("SX5")+"ZE"+SZM->ZM_ASSUNTO))
				SZM->ZM_NOASSUN := SubStr(X5DESCRI(),1,30)
			EndIf
			SZM->ZM_STATUS  := "A"
			SZM->ZM_EVENTO  := "LIBERACAO PV P/ FATURAMENTO."
			SZM->ZM_CODDEPT := "ALMOXI"
			SZM->ZM_DEPTDES := "205-ALMOXARIFADO"
			SZM->ZM_DTPREV  := Date() + 5
			SZM->ZM_INIMONT := SC5->C5_MSMONTA
			SZM->ZM_OBS	    := _cOBS +CHR(13)+CHR(10)+CHR(13)+CHR(10)+SC5->C5_MSOBSPN
			SZM->ZM_COMENT  := _cCOMENT
			SZM->(MsUnLock())
		ENDIF	
	ELSE	
		RecLock("SZM",.T.)
		SZM->ZM_FILIAL  := "01"
		SZM->ZM_PEDIDO  := SC5->C5_NUM
		SZM->ZM_MSCAT   := SC5->C5_MSCATEG
		SZM->ZM_CODCLI  := SC5->C5_CLIENTE
		SZM->ZM_LOJACLI := SC5->C5_LOJACLI
		SZM->ZM_CLIENTE := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
		SZM->ZM_DATA    := Date()
		SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
		SZM->ZM_DEPTO   := _cDeptoUsu
		SZM->ZM_ASSUNTO := "LIBPV"                   
		SX5->(DbGotop())
		If SX5->(DbSeek(xFilial("SX5")+"ZE"+SZM->ZM_ASSUNTO))
			SZM->ZM_NOASSUN := SubStr(X5DESCRI(),1,30)
		EndIf
		SZM->ZM_STATUS  := "A"
		SZM->ZM_EVENTO  := "LIBERACAO PV P/ FATURAMENTO."
		SZM->ZM_CODDEPT := "ALMOXI"
		SZM->ZM_DEPTDES := "205-ALMOXARIFADO"
		SZM->ZM_DTPREV  := Date() + 5
		SZM->ZM_INIMONT := SC5->C5_MSMONTA
		SZM->ZM_OBS	    := _cOBS+CHR(13)+CHR(10)+CHR(13)+CHR(10)+SC5->C5_MSOBSPN
		SZM->ZM_COMENT  := _cCOMENT
		SZM->(MsUnLock())
	ENDIF	
ELSE
	 apMsgStop("PV não encontrado")
ENDIF

Close(_oDlg1)

Return 
