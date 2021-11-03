#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "PROTHEUS.ch"
#define _CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RSCHG001     ºAutor  ³Eduardo Mantoan º Data ³ 28/10/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica Se existe APV em aberto, manda e-mail se for     º±±
±±º          ³ mais de 30 dias                                   	     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSCHG001()

	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf


	cQuery := " SELECT ZM_PEDIDO,ZM_CODCLI,ZM_CLIENTE,ZM_DEPTO,ZM_ASSUNTO,ZM_NOASSUN,ZM_STATUS,C5_MSDTENT  "
	cQuery += " FROM " + RetSqlName("SZM") + " SZM "
	cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 ON ZM_PEDIDO = C5_NUM AND C5_FILIAL= '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_= '' "
	cQuery += " WHERE ZM_STATUS <> 'E' "
	cQuery += " AND ZM_ASSUNTO LIKE 'DOCFIN' OR(ZM_ASSUNTO LIKE 'LIBPAC') "
	cQuery += " AND ZM_FILIAL = '"+xFilial("SZM")+"' AND SZM.D_E_L_E_T_= '' "
	cQuery += " ORDER BY ZM_PEDIDO  "

	TcQuery cQuery New Alias "QR1"

	dbSelectArea("QR1")
	dbGoTop()

	Do While !QR1->(EOF())
		cMensagem := "            " +_CRLF
		
		If	CTOD(DTOC(STOD(QR1->C5_MSDTENT))) < DDATABASE + 31
			
			cMensagem := "Existe um APV pendente para o pedido "+QR1->ZM_PEDIDO 		+_CRLF
			cMensagem += "Assunto: "+QR1->ZM_NOASSUN					                +_CRLF
			cMensagem += "Cliente: "+QR1->ZM_CODCLI+"-"+QR1->ZM_CLIENTE        	     	+_CRLF
			cMensagem += "Data de entrega do pedido: "+DTOC(STOD(QR1->C5_MSDTENT))  	+_CRLF
			cMensagem += "Departamento de origem APV: "+QR1->ZM_DEPTO					+_CRLF
			cMensagem += "Status: "+QR1->ZM_STATUS					                    +_CRLF
			
		EndIf
		
		If cMensagem <> "            "
			cTitulo   :=  "*APV* - URGENTE - "+QR1->ZM_NOASSUN
			cDestina  := "financeiro@masipack.com.br;cobranca@masipack.com.br;cobranca3@masipack.com.br"
			cCco      := "vendas@masipack.com.br;comercial@masipack.com.br"
			oMail:= EnvMail():NEW(.T.)
				If oMail:ConnMail()
					oMail:SendMail(cTitulo,cDestina,cCco,,cMensagem)
				EndIf
			oMail:DConnMail()
		EndIf
		
		QR1->(DBSKIP())
	EndDo

	QR1->(DbCloseArea())

	cQuery := " SELECT C5_NUM, C5_MSDTENT,C5_CLIENTE,C5_CLIENT,C5_MSPOSIC   "
	cQuery += " FROM " + RetSqlName("SC5") + " SC5    "
	cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 ON C6_NUM = C5_NUM AND C6_NOTA='    ' AND C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_= ''    "
	cQuery += " WHERE C5_CONDPAG LIKE 'VCA'      "
	cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_= ''

	TcQuery cQuery New Alias "QR1"

	dbSelectArea("QR1")
	dbGoTop()

	Do While !QR1->(EOF())
		
		cMensagem := "            " +_CRLF
		
		If	 CTOD(DTOC(STOD(QR1->C5_MSDTENT))) < DDATABASE + 11
			
			cMensagem := "Faltam 10 dias para a entrega do pedido "+QR1->C5_NUM 		+_CRLF
			cMensagem += "Cliente: "+QR1->C5_CLIENTE+"-"+QR1->C5_CLIENT       	     	+_CRLF
			cMensagem += "Data de entrega do pedido: "+DTOC(STOD(QR1->C5_MSDTENT))  	+_CRLF
			cMensagem += "Status: "+QR1->C5_MSPOSIC					                    +_CRLF
			
		EndIf
		
		If cMensagem <> "            "
			cTitulo   :=  "*Pedido de Vendas* - URGENTE - "+QR1->ZM_NOASSUN
			cDestina  := "financeiro@masipack.com.br;cobranca@masipack.com.br;cobranca3@masipack.com.br"
			cCco      := "vendas@masipack.com.br;comercial@masipack.com.br"
			oMail:= EnvMail():NEW(.T.)
				If oMail:ConnMail()
					oMail:SendMail(cTitulo,cDestina,cCco,,cMensagem)
				EndIf
			oMail:DConnMail()
		EndIf
		
		
		QR1->(DBSKIP())
	EndDo

	QR1->(DbCloseArea())

	cQuery := " SELECT ZM_PEDIDO,ZM_CODCLI,ZM_CLIENTE,ZM_DEPTO,ZM_ASSUNTO,ZM_NOASSUN,ZM_STATUS,ZM_VENPAC "
	cQuery += " FROM " + RetSqlName("SZM") + " SZM "
	cQuery += " WHERE ZM_STATUS <> 'E' "
	cQuery += " AND ZM_FILIAL = '"+xFilial("SZM")+"' AND SZM.D_E_L_E_T_= '' "
	cQuery += " ORDER BY ZM_PEDIDO  "

	TcQuery cQuery New Alias "QR1"

	dbSelectArea("QR1")
	dbGoTop()

	Do While !QR1->(EOF())
		
		cMensagem := "            " +_CRLF
		
		If	 CTOD(DTOC(QR1->ZM_VENPAC)) < DDATABASE + 16
			
			cMensagem := "Faltam 15 dias para o vencimento do APV "+QR1->ZM_PEDIDO 		+_CRLF
			cMensagem += "Assunto: "+QR1->ZM_NOASSUN					                +_CRLF
			cMensagem += "Cliente: "+QR1->ZM_CODCLI+"-"+QR1->ZM_CLIENTE        	     	+_CRLF
			cMensagem += "Departamento de origem APV: "+QR1->ZM_DEPTO					+_CRLF
			cMensagem += "Status: "+QR1->ZM_STATUS					                    +_CRLF
			
		EndIf
		
		If cMensagem <> "            "
			cTitulo   :=  "*Vencimento APV* - URGENTE - "+QR1->ZM_NOASSUN
			cDestina  := "financeiro@masipack.com.br;cobranca@masipack.com.br;cobranca3@masipack.com.br"
			cCco      := "vendas@masipack.com.br;comercial@masipack.com.br"
			oMail:= EnvMail():NEW(.T.)
				If oMail:ConnMail()
					oMail:SendMail(cTitulo,cDestina,cCco,,cMensagem)
				EndIf
			oMail:DConnMail()
		EndIf
		
		QR1->(DBSKIP())
	EndDo

	QR1->(DbCloseArea())

Return
