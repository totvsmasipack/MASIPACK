#Include "Protheus.ch"
#Include "Topconn.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTG005  ºAutor  ³Lizandra Marques    º Data ³  03/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDA ALTERAÇÃO DE UM DO PRODUTO                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTG005()

_aArea	:= GetArea()

_cUM	:= M->B1_UM
_cProc	:= SUBSTR(M->B1_PROCED,1,1)

IF _cProc <> "1"
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf
	_cQuery:= " SELECT DISTINCT B1_COD, B1_UM, B1_ESTSEG, B2_QATU, SUM(C7_QUANT - C7_QUJE) AS SALDOC7, "
	_cQuery+= "        SUM(D4_QUANT) AS SALDOD4, G1_COMP "
	_cQuery+= " FROM " + RetSqlName("SB1") + " B1 "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SB2") + "  B2 "
	_cQuery+= "        ON B1_COD = B2_COD AND B2_FILIAL = '" + xFilial("SB2") + "' AND B2.D_E_L_E_T_ = ' ' "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SG1") + " G1 "
	_cQuery+= "        ON B1_COD = G1_COMP AND G1_FILIAL = '" + xFilial("SG1") + "' AND G1.D_E_L_E_T_ = ' ' "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SD4") + " D4 "
	_cQuery+= "        ON B1_COD = D4_COD AND D4_FILIAL = '" + xFilial("SD4") + "' AND D4.D_E_L_E_T_ = ' ' "
	_cQuery+= "        AND D4_QUANT > 0 "
	_cQuery+= " LEFT OUTER JOIN " + RetSqlName("SC7") + " C7 "
	_cQuery+= "        ON B1_COD = C7_PRODUTO AND C7_FILIAL = '" + xFilial("SC7") + "' AND C7.D_E_L_E_T_ = ' ' "
	_cQuery+= "      AND C7_RESIDUO = ' ' AND (C7_QUANT - C7_QUJE) > 0 "
	_cQuery+= " WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
	_cQuery+= "       AND B1_COD = '" + M->B1_COD + "'  "
	_cQuery+= " GROUP BY B1_COD, B1_UM, B1_ESTSEG, B2_QATU, G1_COMP "
	TcQuery _cQuery New Alias "QR1"
	
	TcSetField("QR1","SALDOC7"   ,"N",12,03)
	TcSetField("QR1","SALDOD4"   ,"N",12,03)
	TcSetField("QR1","B2_QATU"   ,"N",12,03)
	
	QR1->(DbGoTop())
	
	DO WHILE !QR1->(EOF())
		IF QR1->SALDOC7 + QR1->SALDOD4 + QR1->B2_QATU > 0  .OR. !EMPTY(QR1->G1_COMP)
			ApMsgAlert("Veriique "+IF(QR1->B2_QATU>0,"Saldo, ","") + IF(QR1->SALDOD4>0 ," Empenho ","") + IF(QR1->SALDOC7>0," PC ","") + IF(!EMPTY(QR1->G1_COMP)," e Estrutura","") + ". Unidade de medida não pode ser alterada.")
			_cUM := QR1->B1_UM
		ENDIF
		QR1->(dbSkip())
	ENDDO
	
	QR1->(DbCloseArea())
ENDIF
If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf
RestArea(_aArea)
Return _cUM
