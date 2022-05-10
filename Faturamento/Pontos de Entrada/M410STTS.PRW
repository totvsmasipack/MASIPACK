#include 'totvs.ch'


/*/{Protheus.doc} User Function M410STTS
(long_description)
@type  Function
@author user
@since 10/02/2022
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function M410STTS()

Local _aArea	:= {}
Local _aVoltage := {"110V", "220V"}
Local _aFrequen := {"60Hz"}
Local _cUsrMail	:= ''
Local _cMsg		:= ''
Local _cTo		:= ''
Local _oMail	:= Nil

Private _aUsrInf  := FWSFALLUSERS({ RetCodUsr() }, { "USR_DEPTO" })
Private cEvento   := ""
Private cCodDepDes:= ""
Private cDeptoDes := ""
Private cAssunto  := ""
Private nDias     := 0
Private lInclui   := .F.
Private cAux      := ""

	If FwCodEmp() $ '01|10'

		_aArea := {SA1->(GetArea()), SA3->(GetArea())}

		_cUsrMail	:= "; " + FWSFALLUSERS({ RetCodUsr() }, { "USR_EMAIL" })[1,3]

		DO CASE

			CASE "COMERCIAL" == _aUsrInf[1,3] .And. Inclui

				DbSelectArea('SA1')
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(FWxFilial("SA1") + SC5->(C5_CLIENTE + C5_LOJACLI)))

				DbSelectArea('SA3')
				SA3->(DbSetorder(1))
				SA3->(DbSeek(FWxFilial("SA3") + SC5->C5_VEND1))

				_cMsg  := "Atenção, Pedido Novo" + CHR(13)+CHR(10)
				_cMsg  += CHR(13)+CHR(10)
				_cMsg  += "Pedido: "	+ SC5->C5_NUM + " - Data de Entrega: " + DTOC(SC5->C5_MSDTENT) + CHR(13)+CHR(10)
				_cMsg  += "Cliente: "	+ Alltrim(SC5->C5_CLIENTE) + "/" + SC5->C5_LOJACLI + " - " + Alltrim(SA1->A1_NREDUZ) + CHR(13)+CHR(10)
				_cMsg  += "Contrato: "	+ SC5->C5_ORCAM + CHR(13)+CHR(10)
				_cMsg  += "Vendedor: "	+ Alltrim(SC5->C5_VEND1) + " - " + Alltrim(SA3->A3_NREDUZ) + CHR(13)+CHR(10)
				_cMsg  += CHR(13)+CHR(10)

				_cTo := "gustavo.rosa@masipack.com.br" + IIF( !Empty(_cUsrMail), _cUsrMail, "" )

				If SC5->C5_CONDPAG $ 'VFF|VFC|VCA'
					_cTo += ";cobranca@masipack.com.br;cobranca3@masipack.com.br;financeiro@masipack.com.br"
				Endif	

				_oMail:= EnvMail():NEW(.F.)
				If _oMail:ConnMail()
					_oMail:SendMail("Inclusão do Pedido de Venda",_cTo,,,_cMsg)
				EndIf
				_oMail:DConnMail()

			CASE Altera .And. (SC5->C5_CLIENTE <> M->C5_CLIENTE .Or. SC5->C5_LOJACLI <> M->C5_LOJACLI)
				
				SZ1->(DbSetOrder(1))
				If SZ1->(DbSeek(xFilial("SZ1")+SC5->C5_NUM))
					
					RecLock("SZ1",.F.)
					SZ1->Z1_CODCLI  := SC5->C5_CLIENTE
					SZ1->Z1_LOJACLI := SC5->C5_LOJACLI
					
					If SA1->(DbSeek(FWxFilial("SA1") + SC5->(C5_CLIENTE + C5_LOJACLI)))
						SZ1->Z1_CLIENTE := SA1->A1_NOME
					EndIf
					
					SZ1->(MsUnlock())
				EndIf

		ENDCASE


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
		
		If SC5->C5_MSCATEG == "1" .And. _aUsrInf[1,3] == "COMERCIAL"
			lInclui := .T.  //23/10/14 - LIZANDRA - REUNIAO COMERCIAL/FINANCEIRO
			If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
				Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
					cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
					If "VERIFICAR SINAL DO PV" $ cAux
						lInclui := .F.
						Exit
					EndIf
					SZM->(dbSkip())
					Loop
				Enddo
			EndIf
			If lInclui
				cEvento   := "VERIFICAR SINAL DO PV."
				cAssunto  := "SINAL"
				cCodDepDes:= "FINANC"
				cDeptoDes := "FINANCEIRO"
				nDias     := 4
				GravaSZM()
			EndIf
			If SC5->C5_MSLAYEN == "S"
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Pedido possui LAY-OUT" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				If lInclui
					cEvento   := "Pedido possui LAY-OUT, Favor providencia-lo."
					cAssunto  := "LAYOUT"
					cCodDepDes:= "LAYOUT"
					cDeptoDes := "ENG.MECANICA(LAYOUT)"
					nDias     := 10
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSPLANT == "S"
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Pedido possui Planta de Embalagem" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				If lInclui
					cAssunto  := "PLANTA"
					cEvento   := "Pedido possui Planta de Embalagem, Favor providencia-la."
					cCodDepDes:= "ENGMEB"
					cDeptoDes := "ENG.MECANICA(EMBALAGEM)"
					nDias := 7
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSMOCK == "S"
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Pedido possui Mock-Up" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				If lInclui
					cAssunto  := "MOKUP"
					cEvento   := "Pedido possui Mock-Up, Favor providencia-lo."
					cCodDepDes:= "ENGMEB"
					cDeptoDes := "ENG.MECANICA(EMBALAGEM)"
					nDias := 7
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSDADFI == "S"
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Verificar Documentação junto" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				If lInclui
					cAssunto  := "FINANC"
					cEvento   := "Verificar Documentação junto à Àrea Adm/Financeira"
					cCodDepDes:= "FINANC"
					CDeptoDes := "FINANCEIRO"
					nDias     := 14
					GravaSZM()
				EndIf
			EndIf
			If SC5->C5_MSASSIN == "N"
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "Contrato sem evidencia de Assinatura" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				If lInclui
					cAssunto  := "ASSINA"
					cEvento   := "Contrato sem evidencia de Assinatura! Favor contatar Cliente."
					cCodDepDes:= "COMERC"
					cDeptoDes := "COMERCIAL"
					nDias     := 30
					GravaSZM()
				EndIf
			EndIf
			
			// INCLUIDO 23/10/14 - REUNIÃO COMRECIAL/FINANCEIRO - LIZANDRA
			If SC5->C5_CONDPAG == "VFF"  //VENDA FABRICANTE FINAME
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "PENDENCIA DOCUMENTACAO FINAME FABRICANTE" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				If lInclui
					cEvento   := "PENDENCIA DOCUMENTACAO FINAME FABRICANTE"
					cAssunto  := "DOCFIN"
					cCodDepDes:= "FINANC"
					cDeptoDes := "FINANCEIRO"
					nDias     := 10
					GravaSZM()
				EndIf
				
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "LIBERACAO PAC CLIENTE - FINAME FABRICANTE" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				If lInclui
					cEvento   := "LIBERACAO PAC CLIENTE - FINAME FABRICANTE"
					cAssunto  := "LIBPAC"
					cCodDepDes:= "FINANC"
					cDeptoDes := "FINANCEIRO"
					nDias     := 10
					GravaSZM()
				EndIf
			EndIf

			If SC5->C5_CONDPAG == "VFC"  //VENDA FABRICANTE FINAME
				
				lInclui := .T.
				If SZM->(DbSeek(xFilial("SZM")+Alltrim(SC5->C5_NUM)))
					Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(SC5->C5_NUM)
						cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
						If "LIBERACAO PAC CLIENTE - FINAME FABRICANTE" $ cAux
							lInclui := .F.
							Exit
						EndIf
						SZM->(dbSkip())
					Enddo
				EndIf
				
				If lInclui
					cEvento   := "LIBERACAO PAC CLIENTE - FINAME FABRICANTE"
					cAssunto  := "LIBPAC"
					cCodDepDes:= "FINANC"
					cDeptoDes := "FINANCEIRO"
					nDias     := 10
					GravaSZM()
				EndIf
			EndIf
		EndIf
		
		AEval(_aArea,{|x| RestArea(x)})

	Endif

Return






Static Function GravaSZM()

Local _lGrava := .T.

	If cAssunto == "LOGPV"
		SZM->(DbSetOrder(9))
		SZM->(DbGoTop())
		If SZM->(DbSeek(xFilial("SZM")+"LOGPV "+SC5->C5_NUM))
			Do While SZM->(!Eof()) .And. SZM->ZM_PEDIDO == SC5->C5_NUM .And. Alltrim(SZM->ZM_ASSUNTO) == "LOGPV"
				If SZM->ZM_DATA == Date()
					If "Montagem" $ SZM->ZM_EVENTO
						_lGrava := .F.
						Exit
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
		SZM->ZM_DEPTO   := _aUsrInf[1,3]
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
