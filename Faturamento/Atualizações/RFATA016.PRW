#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function RFATA016
Função para validação do campo da condição de pagamento
@type  Function
@author Masipack
@since 09/12/2019
/*/
User Function RFATA016(_cAlias)

Local _cCliente	:= IIF(_cAlias == "SCJ",M->CJ_CLIENTE,M->C5_CLIENTE)
Local _cLoja	:= IIF(_cAlias == "SCJ",M->CJ_LOJA,M->C5_LOJACLI)
Local _cCond	:= IIF(_cAlias == "SCJ",M->CJ_CONDPAG,M->C5_CONDPAG)
Local _cTipoPed	:= IIF(_cAlias == "SC5",M->C5_TIPO,"N")
lOCAL _nTiT		:= 0
Local lRet		:= .T.

	IF !(cEmpAnt == "15")
		
		IF  SUBSTR(_cCond,1,1) == "V"

			IF POSICIONE("SE4",1,xFilial("SE4")+_cCond,"E4_DIASCOR") == 45
				MsgInfo("Valor de venda tera um acréscimo de 5%")
			
			ELSEIF POSICIONE("SE4",1,xFilial("SE4")+_cCond,"E4_DIASCOR") == 60
				MsgInfo("Valor de venda tera um acréscimo de 10%")

			ELSEIF POSICIONE("SE4",1,xFilial("SE4")+_cCond,"E4_DIASCOR") == 70
				MsgInfo("Valor de venda tera um acréscimo de 15%")

			ELSEIF POSICIONE("SE4",1,xFilial("SE4")+_cCond,"E4_DIASCOR") == 90
				MsgInfo("Valor de venda tera um acréscimo de 20%")

			ELSEIF POSICIONE("SE4",1,xFilial("SE4")+_cCond,"E4_DIASCOR") == 120
				MsgInfo("Valor de venda tera um acréscimo de 25%")

			ELSEIF POSICIONE("SE4",1,xFilial("SE4")+_cCond,"E4_DIASCOR") == 180
				MsgInfo("Valor de venda tera um acréscimo de 35%")
			
			ENDIF
			
		ENDIF

		If _cTipoPed == "N"

			IF SELECT("QR1") > 0
				DbSelectArea("QR1")
				DbCloseArea()
			ENDIF
			
			_cQuery := " SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_VENCREA "
			_cQuery += " FROM " + RetSqlName("SE1") + " E1 "
			_cQuery += " WHERE E1_CLIENTE = '" +  _cCliente + "' AND E1_LOJA = '" + _cLoja + "' "
			_cQuery += "       AND DATEDIFF(DAY,CONVERT(SMALLDATETIME,E1_VENCREA),GETDATE()) > 10 "
			_cQuery += "	   AND E1.D_E_L_E_T_ = ' ' AND E1_FILIAL = '" + xFilial("SE1") + "' AND E1_SALDO > 0 "
			_cQuery += "	   AND E1_TIPO NOT IN ('NCC','RA') "

			TcQuery _cQuery New Alias "QR1"
			
			QR1->(dbGoTop())
			
			DO WHILE !QR1->(EOF())
				_nTiT++
				QR1->(dbSkip())
			ENDDO

			IF _nTit > 0
				ALERT("Cliente possui " + STRZERO(_nTiT,2) + " título(s) em atraso. Contate o departamento Financeiro.")
			ENDIF

			SA1->(DbSetOrder(1))
			IF SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja)) .And. !Empty(Alltrim(SA1->A1_MS_INF))
				MsgInfo(Alltrim(SA1->A1_MS_INF),"Observações do Cadastro do Cliente")
			ENDIF

			IF lRet .And. _cAlias == "SC5" .And. SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja)) .And. SA1->A1_RISCO $ "C_D_E" .And. !(SA1->A1_MSBLQL == "1")
				ALERT("Cliente possui restrição financeira. Favor verificar com Depto. Financeiro!!!")
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF

Return lRet
