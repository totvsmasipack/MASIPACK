#include 'totvs.ch'
#include 'fwmvcdef.ch'
#include 'topconn.ch'

/*/{Protheus.doc} User Function RFATG007
Funcao p/ Atualizar Data de Conclusao Maquinas (Categoria 1)
@type  User Function
@author Aparecida F.Stevanato
@since 25/09/2007
/*/
User Function RFATG007()

Local aButton	:= {}
Local aSays		:= {}
Local cTitle	:= "TOTVS | Alteração Data da Conclusão"
Local cPerg		:= "RFATG007"
Local nOpca		:= 0

	If cEmpAnt $ "01|10"
		
		If Pergunte(cPerg,.T.)

			AADD(aSays,"Este programa tem como objetivo de alterar a Data da Conclusão do Pedido de Venda")

			AADD(aButton, {5,.T.,{|| Pergunte(cPerg,.T. )}})
			AADD(aButton, {1,.T.,{|o| If(ValidaPedido(),(nOpca := 1, FechaBatch()), Nil) }})
			AADD(aButton, {2,.T.,{|o| FechaBatch() }})

			FormBatch(cTitle, aSays, aButton)

			If nOpca == 1
				Processa( { || FATG07UPD() } )
			Endif
		
		Endif

	Else
		
		FwAlertError("Rotina não desenvolvida para a " + Alltrim(SM0->M0_NOME))
		Return
	
	Endif

Return


/*/{Protheus.doc} FATG07UPD
//TODO Atualiza data de Conclusão do Pedido  
@author Aparecida F.Stevanato
@since 25/09/2007
@version 1.0
@type function
/*/
Static Function FATG07UPD()

Local aDepto	:= FWSFALLUSERS({RetCodUsr()},{"USR_DEPTO"})
Local nOpsPed	:= 0
Local nOpsFin	:= 0
Local nPerc		:= 0
Local nDias     := 3
Local cAssunto  := "PEDLIB"
Local _cTitulo	:= ""
Local _cDestino	:= ""
Local _cComCopia := ""
Local _cEmail	:= ""
Local _chtml	:= ""
Local oMail

Default MV_PAR01	:= ""
Default dDataBase	:= DATE()
	
	// Verifica percentual de conclusão do Pedido
	dbSelectArea("SC2")
	SC2->(DbOrderNickName("C2_PEDIDO"))
	
	If SC2->(dbSeek(xFilial("SC2") + MV_PAR01))
		Do While ! SC2->(Eof()) .And. Alltrim(SC2->C2_MSPED) == MV_PAR01
			nOpsPed++
			If !Empty(SC2->C2_DATRF)
				nOpsFin++
			EndIf
			SC2->(DBSKIP())
		EndDo
	EndIf
	
	nPerc := ((nOPsFin / nOpsPed) * 100)

	If nPerc < 100
		If !(FwAlertYesNo("OP's não foram concluidas totalmente - Conclusão: " + STR(nPerc,3,0) + "% - Confirma Conclusão do Pedido ?"))
			Return
		EndIf
	Else
		If !(FwAlertYesNo("Confirma Conclusão do Pedido?"))
			Return
		EndIf
	EndIf

	If Select("SZMSQL") > 0
		DbSelectArea("SZMSQL")
		SZMSQL->(DbCloseArea())
	Endif                   

	_cQuery := "Select Count(*) as CONTSZM FROM "+RetSQLName("SZM")+" WHERE ZM_PEDIDO = '"+MV_PAR01+"' AND SUBSTRING(ZM_ASSUNTO,1,6) = '"+cAssunto+"' "
	_cQuery += "AND D_E_L_E_T_ = '' AND ZM_FILIAL = '"+xFilial("SZM")+"' "

	TCQUERY _cQuery NEW ALIAS "SZMSQL"

	DbSelectArea("SZMSQL")
	
	If SZMSQL->CONTSZM == 0
		cEvento   := "O pedido foi liberado pela montagem"
		cCodDepDes:= "FINANC"
		CDeptoDes := "FINANCEIRO"
		GravaSZM(nDias,UPPER(aDepto[1,3]),cAssunto)

		cCodDepDes:= "EXPED"
		CDeptoDes := "EXPEDICAO"
		GravaSZM(nDias,UPPER(aDepto[1,3]),cAssunto)

		cCodDepDes:= "COMERC"
		cDeptoDes := "COMERCIAL"
		GravaSZM(nDias,UPPER(aDepto[1,3]),cAssunto)

		cCodDepDes:= "AT"
		cDeptoDes := "ASSIST.TECNICA"
		GravaSZM(nDias,UPPER(aDepto[1,3]),cAssunto)

		If UPPER(aDepto[1,3]) == "TESTE DE PRODUTO"
			cCodDepDes:= "MONTAG"
			cDeptoDes := "MONTAGEM"
			GravaSZM(nDias,UPPER(aDepto[1,3]),cAssunto)
		EndIf
	Endif

	// Prepara para envio de e_mail

	SA1->(DBSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	
	AA3->(DBORDERNICKNAME("AA3_PEDPRO"))                                            
	
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		_chtml  := "Pedido abaixo foi concluido pela Montagem e será enviado para Expedição<BR>"+CRLF
		_chtml	+= "Pedido: "+SC5->C5_NUM+"<BR>"+CRLF
		_chtml	+= "Cliente: "+Alltrim(SA1->A1_NREDUZ)+"<BR>"+CRLF
		_chtml	+= "Engenharia: "+SC5->C5_MSENG+"<BR>"+CRLF
		_chtml	+= "Contrato: "+SC5->C5_ORCAM+"<BR>"+CRLF
		_chtml	+= "Data de início de Montagem: "+DTOC(SC5->C5_MSMONTA)+"<BR>"+CRLF
		_chtml	+= "Data de entrega original: "+DTOC(SC5->C5_MSDTENT)+"<BR>"+CRLF
//		_chtml	+= "Data de entrega prevista: "
		If !Empty(SC5->C5_MSDTPEN)
			_chtml  += DTOC(SC5->C5_MSDTPEN)+"<BR>"+CRLF
		Else
			_chtml  += DTOC(SC5->C5_MSDTENT)+"<BR>"+CRLF
		EndIf
		_chtml  += "Data da Conclusão: "+ DTOC(Date())+"<BR>"
		_chtml  += "Posição do Pedido: "+ Alltrim(SC5->C5_MSPOSIC)+"<BR>"
		_chtml  += +CRLF
		_chtml  += "Itens do Pedido: <BR>"

		Do While !SC6->(Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
			IF SB1->(DBSEEK(xFilial("SB1") + SC6->C6_PRODUTO))
				cPosipi := SB1->B1_POSIPI
				cDescri := Alltrim(GetAdvFval("SB5","B5_CEME",xFilial("SB5")+SC6->C6_PRODUTO,1," "))
				IF EMPTY(cDescri)
					cDescri := ALLTRIM(SB1->B1_DESC)
				ENDIF
				cMaquina := SB1->B1_MSMAQUI
			ENDIF
			_cNSerie := Posicione("AA3",11,xFilial("AA3")+SC5->C5_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO,"AA3_NUMSER")
			_chtml  += "Pos.IPI: " + cPosipi + " - Item: " + SC6->C6_ITEM + " - " + SC6->C6_PRODUTO + " - " + cMaquina + " - " + cDescri + " - Qtde: " + Str(SC6->C6_QTDVEN,5)+ " No.Série : " + _cNSerie +"<BR>"
			SC6->(DbSkip())
		EndDo
	EndIf
	_chtml     += +CRLF
	_chtml     += "Obrigado.<BR>"
	_cEmail := ""
	If cEmpAnt == "01"
		_cTitulo  := "Conclusao de Pedido pela Montagem (MASIPACK)"
		_cDestino := Alltrim(GetMV("MS_CMQ01"))
		_cComCopia := Alltrim(GetMV("MS_CMQ02")) + Alltrim(GetMV("MS_CMQ03"))
		IF Alltrim(SA1->A1_NREDUZ) == "FABRIMA"
			_cComCopia +=	Alltrim(GetMV("MS_CMQ04")) + Alltrim(GetMV("MS_CMQ05")) 
		ENDIF                                                                                                                                   
	ElseIf cEmpAnt == "10"
		_cTitulo  := "Conclusao de Pedido pela Montagem (FABRIMA)"
		_cDestino := Alltrim(GetMV("MS_CMQ01"))
		_cComCopia := Alltrim(GetMV("MS_CMQ02")) + Alltrim(GetMV("MS_CMQ03")) + Alltrim(GetMV("MS_CMQ04")) + Alltrim(GetMV("MS_CMQ05"))
	EndIf

	If Alltrim(SA1->A1_EST) == "EX"
		_cDestino += Alltrim(GetMV("MS_CONMQEX"))
	EndIf

	SA3->(dbSetOrder(1))
	If SA3->(dbSeek(xFilial("SA3")+Alltrim(SC5->C5_VEND1)))
		If Alltrim(SA3->A3_TIPO) == "I"
			_cEmail := Alltrim(SA3->A3_EMAIL)
			If !(_cEmail $ _cDestino)
				_cDestino += ";" +_cEmail
			EndIf
		EndIf
	EndIf
	If !Empty(SC5->C5_VEND2)
		If SA3->(dbSeek(xFilial("SA3")+Alltrim(SC5->C5_VEND2)))
			If Alltrim(SA3->A3_TIPO) == "I"
				_cEmail := Alltrim(SA3->A3_EMAIL)
				If !(_cEmail $ _cDestino)
					_cDestino += ";" +_cEmail
				EndIf
			EndIf
		EndIf
	EndIf
  
	If cEmpAnt == "01" // Masipack
		_cDE	:= GetMV("MV_WFMAIL")	
		_cSenha	:= GetMV("MV_WFPASSW")
	ElseIf cEmpAnt $ "10_11" // Fabrima
		_cDE	:= GetMV("MV_WFMAIL")	
		_cSenha	:= GetMV("MV_WFPASSW")
	Else	
		_cDE	:= GetMV("MV_WFMAIL")	
		_cSenha	:= GetMV("MV_WFPASSW")
	Endif

	oMail := EnvMail():NEW(.F.)
	If oMail:ConnMail()
		If oMail:SendMail(_cTitulo,_cDestino,_cComCopia,,_chtml)
			IncProc()
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5") + MV_PAR01))	
				Begin Transaction
					RecLock("SC5",.F.)
					SC5->C5_MSCONCL := dDataBase
					SC5->C5_MSPOSIC := STRZERO(nPerc,3,0) + "% em " + DTOC(DATE())
					SC5->(MsUnLock())
				End Transaction
				FwAlertSuccess("Pedido concluído com sucesso!")
			Endif
		EndIf
	EndIf
	oMail:DConnMail()

Return


/*/{Protheus.doc} ValidaPedido
//TODO Descrição auto-gerada.
@author Aparecida F.Stevanato
@since 25/09/2007
@version 1.0
@return Nulo

@type function
/*/

Static Function ValidaPedido()
	
Local lRet := .T.

Default MV_PAR01	:= ""
	
	dbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	
	If SC5->(DbSeek(xFilial("SC5") + MV_PAR01))
		If (SC5->C5_MSCATEG <> "1") .AND. (cEmpAnt $ '01_10')   // Masipack/Fabrima
			FwAlertError("Categoria do pedido Inválida." + CRLF + "Código da Categoria: " + SC5->C5_MSCATEG)
			lRet := .F.
		Else
			If !Empty(SC5->C5_NOTA) .AND. SC5->C5_NOTA <> 'XXXXXXXXX'
				IF !(FwAlertYesNo("Pedido já faturado. Desejar informar a sua conclusão? "))
					lRet := .F.
				ENDIF	
			Else
				If !Empty(SC5->C5_MSCONCL)
					FwAlertWarning("Pedido concluído em: " + DTOC(SC5->C5_MSCONCL))
					lRet := .F.
				Else
					IF !Empty(Alltrim(SC5->C5_MSPEND))
						FwAlertWarning("O campo Pendências está preenchido nesse pedido, favor encaminhar para Engenharia Mecanica/Eletrica.")
						lRet := .F.
					ENDIF
				EndIf
			EndIf
		EndIf
	Else
		FwAlertError("Pedido não encontrado!")
		lRet := .F.
	EndIf

Return lRet


/*/{Protheus.doc} GravaSZM
//TODO Cria informações do acompanhamento de pedido
@author alison.goncalves
@since 04/05/2018
@version 1.0
@return nulo
@obs Criado cabeçalho da função
@type function
/*/

Static Function GravaSZM(nDias,cDeptoUsu,cAssunto)

Default dDataBase	:= DATE()
	
	RecLock("SZM",.T.)
	
	SZM->ZM_FILIAL  := "01"
	SZM->ZM_PEDIDO  := SC5->C5_NUM
	SZM->ZM_CODCLI  := SC5->C5_CLIENTE
	SZM->ZM_MSCAT   := SC5->C5_MSCATEG
	SZM->ZM_LOJACLI := SC5->C5_LOJACLI
	SA1->(DbSetOrder(1))
	
	If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		SZM->ZM_CLIENTE := SA1->A1_NREDUZ
	EndIf
	
	SZM->ZM_DATA    := dDataBase
	
	If cCodDepDes  == "FINANC"
		SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
		SZM->ZM_DEPTO   := "EXPEDICAO"
	
	ElseIf cCodDepDes  == "AT"
		SZM->ZM_MSUSER  := "ROBSON"
		SZM->ZM_DEPTO   := "DOCUMENTACAO TECNICA"
	
	Else
		SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
		SZM->ZM_DEPTO   := cDeptoUsu
	
	EndIf
	
	SZM->ZM_ASSUNTO := cAssunto
	
	SX5->(DbGotop())
	If SX5->(DbSeek(xFilial("SX5")+"ZE"+SZM->ZM_ASSUNTO))
		SZM->ZM_NOASSUN := SubStr(X5DESCRI(),1,30)
	EndIf
	
	SZM->ZM_EVENTO  := cEvento
	SZM->ZM_CODDEPT := cCodDepDes
	SZM->ZM_DEPTDES := cDeptoDes
	SZM->ZM_DTPREV  := dDataBase + nDias
	SZM->ZM_STATUS  := "A"
	SZM->ZM_INIMONT := SC5->C5_MSMONTA
	SZM->(MsUnLock())

Return
