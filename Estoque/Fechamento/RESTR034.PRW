#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTR034  ºAutor  ³Victor Dessunte     º Data ³  11/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Comparativo de Estoque                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTR034()

	If Pergunte("RESTR034",.T.)
		LjMsgRun("Gerando dados aguarde..." ,,{||GeraDad()})
		LjMsgRun("Gerando planilha..."		,,{||GeraPla()})
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraDad   ºAutor  ³Victor Dessunte     º Data ³  11/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera dados para emissao da planilha                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraDad()

	Local _cQry := ""

	_cQry := " SELECT " + CRLF
	_cQry += " 	B2_COD							AS 'CODIGO'		, " + CRLF
	_cQry += " 	B1_DESC							AS 'DESCRICAO'	, " + CRLF
	_cQry += " 	B2_QATU							AS 'QTD_ATUAL'	, " + CRLF
	_cQry += " 	B2_CM1							AS 'CM1_ATU'	, " + CRLF
	_cQry += " 	B2_VATU1							AS 'TOT_ATU'	, " + CRLF
	_cQry += " 	B9_DATA							AS 'DT_FECH'	, " + CRLF
	_cQry += " 	B9_QINI							AS 'QTD_FECH'	, " + CRLF
	_cQry += " 	B9_CM1							AS 'CM1_FECH'	, " + CRLF
	_cQry += " 	B9_VINI1							AS 'TOT_FECH'	, " + CRLF
	_cQry += " 	ISNULL(SUM(C6_QTDVEN),0)	AS 'PEDIDO'		, " + CRLF
	_cQry += " 	ISNULL(SUM(D4_QUANT),0)		AS 'EMPENHO' 	, " + CRLF
	_cQry += " 	ISNULL(SUM(C6_QTDVEN) + SUM(D4_QUANT),0)	AS 'PED_EMP' ," + CRLF
	_cQry += " 	ISNULL((SUM(C6_QTDVEN) + SUM(D4_QUANT)) - B2_QATU,0)	AS 'RESULTADO' " + CRLF

	_cQry += " FROM " + CRLF
	_cQry +=  	RetSqlName("SB2") + " B2 " + CRLF

	_cQry += " 		INNER JOIN " + RetSqlName("SB1") + " B1 " + CRLF
	_cQry += " 		ON		B1.D_E_L_E_T_	= '' " + CRLF
	_cQry += " 		AND 	B1_FILIAL		= '" + xFilial("SB1") + "' " + CRLF
	_cQry += " 		AND 	B1_COD			= B2_COD " + CRLF

	If MV_PAR03 == 1 //PRODUTIVO
		_cQry += " 		AND 	B1_PROCED		LIKE '%P' " + CRLF
	ElseIf MV_PAR03 == 2 //NAO PRODUTIVO
		_cQry += " 		AND 	B1_PROCED		LIKE '%N' " + CRLF
	EndIf

	_cQry += " 		LEFT JOIN " + RetSqlName("SC6") + " C6 " + CRLF
	_cQry += " 		ON		C6.D_E_L_E_T_	= '' " + CRLF
	_cQry += " 		AND 	C6_FILIAL		= '" + xFilial("SC6") + "' " + CRLF
	_cQry += " 		AND 	C6_NOTA			= '' " + CRLF
	_cQry += " 		AND 	C6_PRODUTO		= B2_COD " + CRLF

	_cQry += " 		LEFT JOIN " + RetSqlName("SD4") + " D4 " + CRLF
	_cQry += " 		ON		D4.D_E_L_E_T_	= '' " + CRLF
	_cQry += " 		AND 	D4_FILIAL		= '" + xFilial("SD4") + "' " + CRLF
	_cQry += " 		AND 	D4_LOCAL			= '01' " + CRLF
	_cQry += " 		AND 	D4_COD			= B2_COD " + CRLF
	_cQry += " 		AND 	D4_QUANT			> 0 " + CRLF

	_cQry += " 		LEFT JOIN " + RetSqlName("SB9") + " B9 " + CRLF
	_cQry += " 		ON		B9.D_E_L_E_T_	= '' " + CRLF
	_cQry += " 		AND 	B9_FILIAL		= '" + xFilial("SB9") + "' " + CRLF
	_cQry += " 		AND 	B9_LOCAL			= '01' " + CRLF
	_cQry += " 		AND 	B9_DATA			= '" + DTOS(GETMV("MV_ULMES")) + "' " + CRLF
	_cQry += " 		AND 	B9_COD			= B2_COD " + CRLF
	_cQry += " WHERE " + CRLF
	_cQry += " 			B2.D_E_L_E_T_	= '' " + CRLF
	_cQry += " 	AND 	B2_FILIAL		= '" + xFilial("SB2") + "' " + CRLF
	_cQry += " 	AND 	B2_LOCAL			= '01' " + CRLF
	_cQry += " 	AND 	B2_COD			BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF
	_cQry += " GROUP BY " + CRLF
	_cQry += " 		B2_COD	, " + CRLF
	_cQry += " 		B1_DESC	, " + CRLF
	_cQry += " 		B2_QATU	, " + CRLF
	_cQry += " 		B2_CM1	, " + CRLF                 	
	_cQry += " 		B2_VATU1	, " + CRLF
	_cQry += " 		B9_DATA	, " + CRLF
	_cQry += " 		B9_QINI	, " + CRLF
	_cQry += " 		B9_CM1	, " + CRLF
	_cQry += " 		B9_VINI1 " + CRLF
	_cQry += " HAVING ISNULL(SUM(C6_QTDVEN),0)+ISNULL(SUM(D4_QUANT),0)+B2_QATU+B9_QINI <> 0 " + CRLF
	_cQry += " ORDER BY 1 "

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	TCQUERY _cQry NEW ALIAS "TRB"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GerPla    ºAutor  ³Victor Dessunte     º Data ³  10/16/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera planilha com dados                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraPla()
	Local cFile 	:= 'C:/RELATO_MICROSIGA/' + Upper(AllTrim(SM0->M0_NOME))	+	'_'	+ ALLTRIM(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_RESTR034.xml'
	Local oExcel 	:= FWMSEXCEL():New()

	oExcel:AddWorkSheet("Comparativo")
	oExcel:AddTable("Comparativo"	,"Comparativo de Estoque")
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Código"					,1,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Descrição"				,1,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Qtd.Atual"				,2,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Custo Médio"			,3,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Valor Atual"			,3,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Data Fech."				,1,4,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Qtd.Fech."				,2,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Custo Médio Fech."	,3,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Valor Fech."			,3,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Qtd. Pedido"			,2,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Qtd. Empenho"			,2,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Soma Ped. + Emp."		,2,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Resultado"				,2,1,.F.)

	TRB->(dbGoTop())
	While TRB->(!EOF())
		oExcel:AddRow("Comparativo","Comparativo de Estoque",{	TRB->CODIGO	  			,; //01
		TRB->DESCRICAO			,; //02
		TRB->QTD_ATUAL			,; //03
		TRB->CM1_ATU			,; //04
		TRB->TOT_ATU			,; //05
		STOD(TRB->DT_FECH)	,; //06
		TRB->QTD_FECH			,; //07
		TRB->CM1_FECH			,; //08
		TRB->TOT_FECH			,; //09
		TRB->PEDIDO				,; //10
		TRB->EMPENHO			,; //11
		TRB->PED_EMP			,; //12
		TRB->RESULTADO			}) //13
		TRB->(dbSkip())
	End

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	oExcel:Activate()
	oExcel:GetXMLFile(cFile)

	If File(cFile)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cFile)
		oExcelApp:SetVisible(.T.)
	EndIf

Return
