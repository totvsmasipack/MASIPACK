#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥RFATA004  ∫Autor  ≥Aparecida de F.Stevanato∫ Data  16/05/08 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Manutencao na tabela SYD - Classificacıes Fiscais           ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function RFATA004()

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Declaracao de Variaveis                                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	Private cVldAlt := "" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Private cVldExc := "" // Validacao para permitir a exclusao.  Pode-se utilizar ExecBlock.

	Private aRotina   := {{"Pesquisa" ,"AxPesqui"  ,0,1} ,;   // Pesquisa
	{"Visualiza","AxVisual"  ,0,2} ,;   // Visualiza
	{"Inclui"   ,"AxInclui"  ,0,3} ,;   // Inclui
	{"Altera"   ,"AxAltera"  ,0,4} ,;   // Altera
	{"Exclui"   ,"AxDeleta"  ,0,5}}   // Exclui

	cVldAlt := "U_AltProd(nOpc)"
	cVldExc := "U_VerProd(5)"

	AxCadastro("SYD","ClassificaÁıes Fiscais",cVldExc,cVldAlt)

Return

User Function AltProd(nOpc)

	_cCodAtv	:= SYD->YD_MSCATIV

	If nOpc <> 4 .OR. (SYD->YD_PER_IPI == M->YD_PER_IPI .And. SYD->YD_ICMS_RE == M->YD_ICMS_RE)
		If nOpc <> 4 .OR. (SYD->YD_MSCATIV == M->YD_MSCATIV .And. SYD->YD_MSPORTA == M->YD_MSPORTA)
			Return .T.
		ELSE
			apMsgAlert("Atualize o cadastro de Complemento de Produtos para as outras empresas em: AtualizaÁıes -> Customizado -> Atualiza Complemento deProdutos")

			_cQuery := " SELECT B5_COD, B5_CODATIV, B5_INSPAT, B5.R_E_C_N_O_  AS REGISTRO "
			_cQuery += " FROM " + RetSqlName("SB5") + " B5 "
			_cQuery += " WHERE B5_CODATIV = '" + _cCodAtv + "' "
			_cQuery += "       AND B5_FILIAL = '" + xFilial("SB5") + "' AND B5.D_E_L_E_T_ = ' ' "

			TcQuery _cQuery New Alias "QR1"

			DO WHILE !QR1->(EOF())
				DbSelectArea("SB5")
				GO QR1->REGISTRO
				Reclock("SB5",.F.)
				SB5->B5_CODATIV	:= M->YD_MSCATIV
				SB5->B5_INSPAT	:= M->YD_MSPORTA
				SB5->(MsUnlock())
				QR1->(dbSkip())
			ENDDO
			QR1->(dbCloseArea())
		ENDIF
		Return .T.
	ELSE
		apMsgAlert("Atualize o cadastro de Produtos para as outras empresas em: AtualizaÁıes -> Customizado -> Atualiza %IPI/ICMS em Produtos")

		SB1->(DbOrderNickName("B1CLAFISC"))

		MsgRun("Atualizando %IPI em Produtos !!!!",,{||})

		If SB1->(DBSEEK(XFILIAL("SB1")+M->YD_TEC))
			WHILE SB1->B1_POSIPI == M->YD_TEC .AND. !SB1->(EOF())
				RecLock("SB1",.F.)
				SB1->B1_IPI  := M->YD_PER_IPI
				SB1->B1_PICM := M->YD_ICMS_RE
				SB1->(MsUnlock())
				SB1->(DBSKIP())
			ENDDO
		EndIf
		If nOpc <> 4 .OR. (SYD->YD_MSCATIV == M->YD_MSCATIV .And. SYD->YD_MSPORTA == M->YD_MSPORTA)
			Return .T.
		ELSE
			apMsgAlert("Atualize o cadastro de Complemento de Produtos para as outras empresas em: AtualizaÁıes -> Customizado -> Atualiza Complemento deProdutos")

			SB5->(DbOrderNickName("SB5MAS01"))

			MsgRun("Atualizando Complemento de Produtos !!!!",,{||})

			apMsgAlert("Atualize o cadastro de Complemento de Produtos para as outras empresas em: AtualizaÁıes -> Customizado -> Atualiza Complemento deProdutos")

			_cQuery := " SELECT B5_COD, B5_CODATIV, B5_INSPAT, B5.R_E_C_N_O_  AS REGISTRO "
			_cQuery += " FROM " + RetSqlName("SB5") + " B5 "
			_cQuery += " WHERE B5_CODATIV = '" + _cCodAtv + "' "
			_cQuery += "       AND B5_FILIAL = '" + xFilial("SB5") + "' AND B5.D_E_L_E_T_ = ' ' "

			TcQuery _cQuery New Alias "QR1"

			DO WHILE !QR1->(EOF())
				DbSelectArea("SB5")
				GO QR1->REGISTRO
				Reclock("SB5",.F.)
				SB5->B5_CODATIV	:= M->YD_MSCATIV
				SB5->B5_INSPAT	:= M->YD_MSPORTA
				SB5->(MsUnlock())
				QR1->(dbSkip())
			ENDDO
			QR1->(dbCloseArea())
		ENDIF
	EndIf

Return  .T.

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±∫Desc.     ≥ Verifica se existe Produtos com esta ClassificaÁ„o Fiscal  ∫±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ

User Function VerProd(nOpc)
	_cRet := .T.

	If nOpc <> 5
		Return .T.
	ELSE
		SB1->(DbOrderNickName("B1CLAFISC"))

		If SB1->(dbSeek(xFilial("SB1")+SYD->YD_TEC))
			apMsgStop("Existe Produtos com esta ClassificaÁ„o Fiscal - Exclus„o invalida")
			_cRet :=  .F.
		EndIf

		SB5->(DbOrderNickName("SB5MAS01"))

		If SB1->(dbSeek(xFilial("SB5")+SYD->YD_MSCATIV))
			apmsgStop("Existe Produtos com este Codigo de Atividade - Exclus„o invalida")
			_cRet :=  .F.
		EndIf
	EndIf

Return (_cRet)
