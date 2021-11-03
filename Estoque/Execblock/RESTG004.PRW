#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTG004  ºAutor  ³Lizandra Marques    º Data ³  09/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDA BLOQUEIO DO PRODUTO (B1_MSBLQL)                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTG004()

_aArea	:= GetArea()
_cBLQ		:= M->B1_MSBLQL

IF _cBLQ == '1'
	
	_cQuery:= " SELECT DISTINCT B1_COD, B2_QATU, SUM(C7_QUANT - C7_QUJE) AS SALDOC7, "
	_cQuery+= "        SUM(D4_QUANT) AS SALDOD4, SUM(C1_QUANT - C1_QUJE) AS SALDOC1, SUM((C2_QUANT - C2_QUJE+C2_PERDA)) AS SALDOC2 "
	_cQuery+= " FROM " + RetSqlName("SB1") + " B1 "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SB2") + "  B2 "
	_cQuery+= "        ON B1_COD = B2_COD AND B2_FILIAL = '" + xFilial("SB2") + "' AND B2.D_E_L_E_T_ = ' ' "
//	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SG1") + " G1 "
//	_cQuery+= "        ON B1_COD = G1_COMP AND G1_FILIAL = '" + xFilial("SG1") + "' AND G1.D_E_L_E_T_ = ' ' "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SD4") + " D4 "
	_cQuery+= "        ON B1_COD = D4_COD AND D4_FILIAL = '" + xFilial("SD4") + "' AND D4.D_E_L_E_T_ = ' ' "
	_cQuery+= "        AND D4_QUANT > 0 "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SC7") + " C7 "
	_cQuery+= "        ON B1_COD = C7_PRODUTO AND C7_FILIAL = '" + xFilial("SC7") + "' AND C7.D_E_L_E_T_ = ' ' "
	_cQuery+= "      AND C7_RESIDUO = ' ' AND (C7_QUANT - C7_QUJE) > 0 "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SC1") + " C1 "
	_cQuery+= "        ON B1_COD = C1_PRODUTO AND C1_FILIAL = '" + xFilial("SC1") + "' AND C1.D_E_L_E_T_ = ' ' "
	_cQuery+= "      AND C1_RESIDUO = ' ' AND (C1_QUANT - C1_QUJE) > 0 "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SC2") + " C2 "
	_cQuery+= "        ON B1_COD = C1_PRODUTO AND C1_FILIAL = '" + xFilial("SC1") + "' AND C1.D_E_L_E_T_ = ' ' "
	_cQuery+= "      AND (C2_QUANT - C2_QUJE+C2_PERDA) > 0 "
	_cQuery+= " WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
	_cQuery+= "       AND B1_COD = '" + M->B1_COD + "'  "
	_cQuery+= " GROUP BY B1_COD, B1_UM, B2_QATU  "
	TcQuery _cQuery New Alias "QR1"
	
	TcSetField("QR1","SALDOC7"   ,"N",12,03)
	TcSetField("QR1","SALDOD4"   ,"N",12,03)
	TcSetField("QR1","B2_QATU"   ,"N",12,03)
	
	QR1->(DbGoTop())
	
	
	DO WHILE !QR1->(EOF())
		IF QR1->SALDOC7 + QR1->SALDOD4 + QR1->B2_QATU > 0  //.OR. !EMPTY(QR1->G1_COMP)
			ApMsgAlert("Verifique "+IF(QR1->B2_QATU>0,"Saldo, ","") + IF(QR1->SALDOD4>0 ," Empenho, ","") + IF(QR1->SALDOC7>0," PC, ","") + IF(QR1->SALDOC1>0," Solicitação, ","") + IF(QR1->SALDOC2>0," OP´s ","") + ". Produto não pode ser bloqueado.")
			_cBLQ		:= "2"
		ENDIF
		QR1->(dbSkip())
	ENDDO

	QR1->(DbCloseArea())
	
ENDIF


RestArea(_aArea)

Return _cBLQ
