#include 'protheus.ch'

/*/{Protheus.doc} User Function RFTAR058
@description Relatório de cálculo de comissões por período
@type  Function
@author Masipack
@since 12/03/2020
/*/
User Function RFATR058()

Local cPerg		:= "XRFATR058"
Local oReport
	
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()

Return


/*/{Protheus.doc} ReportDef
Definição do relatório 
@type  Static Function
@author user
@since 12/03/2020
/*/
Static Function ReportDef(cPerg)

Local aOrdem	:= {"Sintetico","Analitico"}
Local cDesc		:= "Este relatório gera as vendas de um período por vendedor e suas comissões"
Local cTitulo	:= "Relatório de Comissões de Técnicos"
Local oReport, oSection

	oReport := TReport():New("RFATR058",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)
	oReport:SetTotalInLine(.F.)

	oSection := TRSection():New(oReport,"Comissões",{"SC5","SA3","SF2"},aOrdem)

	TRCell():New(oSection,"C5_NUM"		,	"SC5",	RetTitle("C5_NUM")		,	PesqPict("SC5","C5_NUM")		,	TamSX3("C5_NUM")[1]+10)
	TRCell():New(oSection,"NFISCAL"		,	"   ",	"N. Fiscal"				,	PesqPict("SF2","F2_DOC")		,	TamSX3("F2_DOC")[1]+5)
	TRCell():New(oSection,"F2_CLIENTE"	,	"SF2",	RetTitle("F2_CLIENTE")	,	PesqPict("SF2","F2_CLIENTE")	,	TamSX3("F2_CLIENTE")[1]+5)
	TRCell():New(oSection,"F2_LOJA"		,	"SF2",	RetTitle("F2_LOJA")		,	PesqPict("SF2","F2_LOJA")		,	TamSX3("F2_LOJA")[1]+5)
	TRCell():New(oSection,"NOMECLI"		,	"   ",	RetTitle("A1_NOME")		,	PesqPict("SA1","A1_NOME")		,	20)
	TRCell():New(oSection,"PAIS"		,	"   ",	"País/Região"			,	PesqPict("SA1","A1_REGIAO")		,	TamSX3("A1_REGIAO")[1])
	TRCell():New(oSection,"A3_COD"		,	"SA3",	RetTitle("A3_COD")		,	PesqPict("SA3","A3_COD")		,	TamSX3("A3_COD")[1]+5)
	TRCell():New(oSection,"A3_NOME"		,	"SA3",	"Nome Vendedor"			,	PesqPict("SA3","A3_NOME")		,	TamSX3("A3_NOME")[1]+10)
	TRCell():New(oSection,"VNDTOTAL"	,	"   ",	"Vl Mercadoria"			,	PesqPict("SC6","C6_VALOR")		,	TamSX3("C6_VALOR")[1])
	TRCell():New(oSection,"PCOMISS"		,	"   ",	"% Comissao"			,	PesqPict("SC5","C5_COMIS1")		,	TamSX3("C5_COMIS1")[1])
	TRCell():New(oSection,"COMISSAO"	,	"   ",	"Vl Comissao"			,	PesqPict("SC6","C6_VALOR")		,	TamSX3("C6_VALOR")[1])

	TRFunction():New(oSection:Cell("VNDTOTAL"),"Total","SUM",Nil,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
	TRFunction():New(oSection:Cell("COMISSAO"),"Total1","SUM",Nil,"",,/*uFormula*/,.F.,.T.,.F.,oSection)

Return oReport

/*/{Protheus.doc} ReportDef
Impressão do relatório 
@type  Static Function
@author user
@since 12/03/2020
/*/
Static Function PrintReport(oReport)

Local cAlias	:= GetNextAlias()
Local cSelect1	:= ""
Local cSelect2	:= ""
Local cSelect3	:= ""
Local cSelect4	:= ""
Local cSelect5	:= ""
Local cGroup1	:= ""
Local cGroup2	:= ""
Local cGroup3	:= ""
Local cGroup4	:= ""
Local cGroup5	:= ""
Local cJoinA3	:= ""
Local cJoinC6	:= ""
Local cJoinD2	:= ""
Local cJoinF2	:= ""
Local cWhere1	:= ""
Local cWhere2	:= ""
Local cWhere3	:= ""
Local cWhere4	:= ""
Local cWhere5	:= ""
Local nOrder	:= oReport:GetOrder()
Local oSection	:= oReport:Section(1)

	oReport:SetTitle("Comissões de Técnicos - " + If(nOrder == 1,"Sintético","Analítico") + " | De: " + DTOC(MV_PAR01) + " até " + DTOC(MV_PAR02))

	If nOrder == 1

		oSection:Cell("C5_NUM"):Disable()
		oSection:Cell("NFISCAL"):Disable()
		oSection:Cell("F2_CLIENTE"):Disable()
		oSection:Cell("F2_LOJA"):Disable()
		oSection:Cell("NOMECLI"):Disable()
		oSection:Cell("PAIS"):Disable()

		cSelect1 := "%"
		cSelect1 += "A3_COD, A3_NOME, SUM(C6_VALOR) AS VNDTOTAL, C5_COMIS1 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS1) / 100),2) AS COMISSAO"
		cSelect1 += "%"

		cGroup1	:= "%"
		cGroup1	+= "A3_COD, A3_NOME, C5_COMIS1"
		cGroup1	+= "%"

		cSelect2 := "%"
		cSelect2 += "A3_COD, A3_NOME, SUM(C6_VALOR) AS VNDTOTAL, C5_COMIS2 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS2) / 100),2) AS COMISSAO"
		cSelect2 += "%"

		cGroup2	:= "%"
		cGroup2	+= "A3_COD, A3_NOME, C5_COMIS2"
		cGroup2	+= "%"

		cSelect3 := "%"
		cSelect3 += "A3_COD, A3_NOME, SUM(C6_VALOR) AS VNDTOTAL, C5_COMIS3 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS3) / 100),2) AS COMISSAO"
		cSelect3 += "%"

		cGroup3	:= "%"
		cGroup3	+= "A3_COD, A3_NOME, C5_COMIS3"
		cGroup3	+= "%"

		cSelect4 := "%"
		cSelect4 += "A3_COD, A3_NOME, SUM(C6_VALOR) AS VNDTOTAL, C5_COMIS4 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS4) / 100),2) AS COMISSAO"
		cSelect4 += "%"

		cGroup4	:= "%"
		cGroup4	+= "A3_COD, A3_NOME, C5_COMIS4"
		cGroup4	+= "%"

		cSelect5 := "%"
		cSelect5 += "A3_COD, A3_NOME, SUM(C6_VALOR) AS VNDTOTAL, C5_COMIS5 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS5) / 100),2) AS COMISSAO"
		cSelect5 += "%"

		cGroup5	:= "%"
		cGroup5	+= "A3_COD, A3_NOME, C5_COMIS5"
		cGroup5	+= "%"

	Else

		cSelect1 := "%"
		cSelect1 += "C5_NUM, RTRIM(F2_DOC)+'/'+RTRIM(F2_SERIE) AS NFISCAL, F2_CLIENTE, F2_LOJA,C6_VALOR AS VNDTOTAL, A3_COD, A3_NOME, C5_COMIS1 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS1) / 100),2) AS COMISSAO,"
		cSelect1 += "( SELECT A1_NOME FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS NOMECLI, "
		cSelect1 += "( SELECT RTRIM(A1_PAIS)+'/'+A1_EST FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS PAIS "
		cSelect1 += "%"

		cGroup1	:= "%"
		cGroup1	+= "C5_NUM, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, C6_VALOR, A3_COD, A3_NOME, C5_COMIS1"
		cGroup1	+= "%"

		cSelect2 := "%"
		cSelect2 += "C5_NUM, RTRIM(F2_DOC)+'/'+RTRIM(F2_SERIE) AS NFISCAL, F2_CLIENTE, F2_LOJA, C6_VALOR AS VNDTOTAL, A3_COD, A3_NOME, C5_COMIS2 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS2) / 100),2) AS COMISSAO,"
		cSelect2 += "( SELECT A1_NOME FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS NOMECLI, "
		cSelect2 += "( SELECT RTRIM(A1_PAIS)+'/'+A1_EST FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS PAIS "
		cSelect2 += "%"

		cGroup2	:= "%"
		cGroup2	+= "C5_NUM, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, C6_VALOR, A3_COD, A3_NOME, C5_COMIS2"
		cGroup2	+= "%"

		cSelect3 := "%"
		cSelect3 += "C5_NUM, RTRIM(F2_DOC)+'/'+RTRIM(F2_SERIE) AS NFISCAL, F2_CLIENTE, F2_LOJA, C6_VALOR AS VNDTOTAL, A3_COD, A3_NOME, C5_COMIS3 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS3) / 100),2) AS COMISSAO,"
		cSelect3 += "( SELECT A1_NOME FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS NOMECLI, "
		cSelect3 += "( SELECT RTRIM(A1_PAIS)+'/'+A1_EST FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS PAIS "
		cSelect3 += "%"

		cGroup3	:= "%"
		cGroup3	+= "C5_NUM, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, C6_VALOR, A3_COD, A3_NOME, C5_COMIS3"
		cGroup3	+= "%"

		cSelect4 := "%"
		cSelect4 += "C5_NUM, RTRIM(F2_DOC)+'/'+RTRIM(F2_SERIE) AS NFISCAL, F2_CLIENTE, F2_LOJA, C6_VALOR AS VNDTOTAL, A3_COD, A3_NOME, C5_COMIS4 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS4) / 100),2) AS COMISSAO,"
		cSelect4 += "( SELECT A1_NOME FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS NOMECLI, "
		cSelect4 += "( SELECT RTRIM(A1_PAIS)+'/'+A1_EST FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS PAIS "
		cSelect4 += "%"

		cGroup4	:= "%"
		cGroup4	+= "C5_NUM, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, C6_VALOR, A3_COD, A3_NOME, C5_COMIS4"
		cGroup4 += "%"

		cSelect5 := "%"
		cSelect5 += "C5_NUM, RTRIM(F2_DOC)+'/'+RTRIM(F2_SERIE) AS NFISCAL, F2_CLIENTE, F2_LOJA, C6_VALOR, A3_COD, A3_NOME, C5_COMIS5 AS PCOMISS, ROUND(((SUM(C6_VALOR) * C5_COMIS5) / 100),2) AS COMISSAO,"
		cSelect5 += "( SELECT A1_NOME FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS NOMECLI, "
		cSelect5 += "( SELECT RTRIM(A1_PAIS)+'/'+A1_EST FROM "+RetSQLName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D_E_L_E_T_ = ' ' ) AS PAIS "
		cSelect5 += "%"

		cGroup5	:= "%"
		cGroup5	+= "C5_NUM, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, C6_VALOR, A3_COD, A3_NOME, C5_COMIS5"
		cGroup5 += "%"

	Endif

	cWhere1	:= "%"
	cWhere2	:= "%"
	cWhere3	:= "%"
	cWhere4	:= "%"
	cWhere5	:= "%"
	If !Empty(MV_PAR01) .OR. !Empty(MV_PAR02) 
		cWhere1	+= " F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"
		cWhere2	+= " F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"
		cWhere3	+= " F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"
		cWhere4	+= " F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"
		cWhere5	+= " F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND"
	Endif
/*
	If MV_PAR06 == 1	//Serviços? 1=Sim - 2=Não
		cWhere1	+= " F2_SERIE = 'E' AND"
		cWhere2	+= " F2_SERIE = 'E' AND"
		cWhere3	+= " F2_SERIE = 'E' AND"
		cWhere4	+= " F2_SERIE = 'E' AND"
		cWhere5	+= " F2_SERIE = 'E' AND"
	Else
		cWhere1	+= " F2_SERIE != 'E' AND"
		cWhere2	+= " F2_SERIE != 'E' AND"
		cWhere3	+= " F2_SERIE != 'E' AND"
		cWhere4	+= " F2_SERIE != 'E' AND"
		cWhere5	+= " F2_SERIE != 'E' AND"
	Endif
*/
	cWhere1	+= " C5_FILIAL = '"+xFilial("SC5")+"' AND"
	cWhere2	+= " C5_FILIAL = '"+xFilial("SC5")+"' AND"
	cWhere3	+= " C5_FILIAL = '"+xFilial("SC5")+"' AND"
	cWhere4	+= " C5_FILIAL = '"+xFilial("SC5")+"' AND"
	cWhere5	+= " C5_FILIAL = '"+xFilial("SC5")+"' AND"

	cWhere1	+= " C5_TIPO = 'N' AND"
	cWhere2	+= " C5_TIPO = 'N' AND"
	cWhere3	+= " C5_TIPO = 'N' AND"
	cWhere4	+= " C5_TIPO = 'N' AND"
	cWhere5	+= " C5_TIPO = 'N' AND"

	If !Empty(MV_PAR04)
		cWhere1	+= " C5_VEND1 = '"+MV_PAR04+"' AND"
		cWhere2	+= " C5_VEND2 = '"+MV_PAR04+"' AND"
		cWhere3	+= " C5_VEND3 = '"+MV_PAR04+"' AND"
		cWhere4	+= " C5_VEND4 = '"+MV_PAR04+"' AND"
		cWhere5	+= " C5_VEND5 = '"+MV_PAR04+"' AND"
	Endif

	If !Empty(MV_PAR03)
		cWhere1	+= " C5_MSCATEG = '"+MV_PAR03+"' AND"
		cWhere2	+= " C5_MSCATEG = '"+MV_PAR03+"' AND"
		cWhere3	+= " C5_MSCATEG = '"+MV_PAR03+"' AND"
		cWhere4	+= " C5_MSCATEG = '"+MV_PAR03+"' AND"
		cWhere5	+= " C5_MSCATEG = '"+MV_PAR03+"' AND"
	Endif

	If MV_PAR05 == 1	//Venda Técnica? 1=Sim - 2=Não
		cWhere1	+= " C5_MSTPVEN IN ('VT','AT') AND"
		cWhere2	+= " C5_MSTPVEN IN ('VT','AT') AND"
		cWhere3	+= " C5_MSTPVEN IN ('VT','AT') AND"
		cWhere4	+= " C5_MSTPVEN IN ('VT','AT') AND"
		cWhere5	+= " C5_MSTPVEN IN ('VT','AT') AND"

		cWhere1	+= " F2_SERIE = 'E' AND"
		cWhere2	+= " F2_SERIE = 'E' AND"
		cWhere3	+= " F2_SERIE = 'E' AND"
		cWhere4	+= " F2_SERIE = 'E' AND"
		cWhere5	+= " F2_SERIE = 'E' AND"
	Endif
	
	cWhere1	+= " C5_COMIS1 > 0 AND"
	cWhere2	+= " C5_COMIS2 > 0 AND"
	cWhere3	+= " C5_COMIS3 > 0 AND"
	cWhere4	+= " C5_COMIS4 > 0 AND"
	cWhere5	+= " C5_COMIS5 > 0 AND"

	cWhere1	+= " SUBSTRING(C5_NATUREZ,1,1) != 'T' AND" 
	cWhere2	+= " SUBSTRING(C5_NATUREZ,1,1) != 'T' AND" 
	cWhere3	+= " SUBSTRING(C5_NATUREZ,1,1) != 'T' AND" 
	cWhere4	+= " SUBSTRING(C5_NATUREZ,1,1) != 'T' AND" 
	cWhere5	+= " SUBSTRING(C5_NATUREZ,1,1) != 'T' AND" 
	
	cWhere1	+= "%"
	cWhere2	+= "%"
	cWhere3	+= "%"
	cWhere4	+= "%"
	cWhere5	+= "%"

	cJoinA3 := "%"
	cJoinA3 += RetSQLName("SA3") + " A3 ON"
	cJoinA3 += " A3_FILIAL = '"+xFilial('SA3')+"' AND"
	cJoinA3 += "%"

	cJoinC6 := "%"
	cJoinC6 += RetSQLName("SC6") + " C6 ON "
	cJoinC6 += " C6_FILIAL = C5_FILIAL AND"
	cJoinC6 += " C6_NUM = C5_NUM AND"
	cJoinC6 += " C6_CLI = C5_CLIENT AND"
	cJoinC6 += " C6_LOJA = C5_LOJACLI AND"
	cJoinC6 += "%"

	cJoinD2 := "%"
	cJoinD2 += RetSQLName("SD2") + " D2 ON"
	cJoinD2 += " D2_FILIAL = C6_FILIAL AND"
	cJoinD2 += " D2_PEDIDO = C6_NUM AND"
	cJoinD2 += " D2_ITEMPV = C6_ITEM AND"
	cJoinD2 += " D2_CLIENTE = C6_CLI AND"
	cJoinD2 += " D2_LOJA = C6_LOJA AND"
	cJoinD2 += " D2_DOC = C6_NOTA AND"
	cJoinD2 += " D2_SERIE = C6_SERIE AND"
	cJoinD2 += " D2_TIPO = C5_TIPO AND"
	cJoinD2 += "%"

	cJoinF2 := "%"
	cJoinF2 += RetSQLName("SF2") + " F2 ON"
	cJoinF2 += " F2_FILIAL = D2_FILIAL AND"
	cJoinF2 += " F2_DOC = D2_DOC AND"
	cJoinF2 += " F2_SERIE = D2_SERIE AND"
	cJoinF2 += " F2_CLIENTE = D2_CLIENTE AND"
	cJoinF2 += " F2_LOJA = D2_LOJA AND"
	cJoinF2 += " F2_TIPO = D2_TIPO AND"
	cJoinF2 += "%"

	oSection:BeginQuery()
	BEGINSQL Alias cAlias
		
		SELECT %Exp:cSelect1%
		FROM %Table:SC5% C5
		
		INNER JOIN %Exp:cJoinC6%
		C6.%NOTDEL%
		INNER JOIN %Exp:cJoinD2%
		D2.%NOTDEL%
		INNER JOIN %Exp:cJoinF2%
		F2.%NOTDEL%
		INNER JOIN %Exp:cJoinA3%
		A3_COD = C5_VEND1 AND
		A3.%NOTDEL%
		
		WHERE %Exp:cWhere1%
		C5.%NOTDEL%
		GROUP BY %Exp:cGroup1%

		UNION ALL

		SELECT %Exp:cSelect2%
		FROM %Table:SC5% C5
		
		INNER JOIN %Exp:cJoinC6%
		C6.%NOTDEL%
		INNER JOIN %Exp:cJoinD2%
		D2.%NOTDEL%
		INNER JOIN %Exp:cJoinF2%
		F2.%NOTDEL%
		INNER JOIN %Exp:cJoinA3%
		A3_COD = C5_VEND2 AND
		A3.%NOTDEL%
		
		WHERE %Exp:cWhere2%
		C5.%NOTDEL%
		GROUP BY %Exp:cGroup2%

		UNION ALL

		SELECT %Exp:cSelect3%
		FROM %Table:SC5% C5
		
		INNER JOIN %Exp:cJoinC6%
		C6.%NOTDEL%
		INNER JOIN %Exp:cJoinD2%
		D2.%NOTDEL%
		INNER JOIN %Exp:cJoinF2%
		F2.%NOTDEL%
		INNER JOIN %Exp:cJoinA3%
		A3_COD = C5_VEND3 AND
		A3.%NOTDEL%
		
		WHERE %Exp:cWhere3%
		C5.%NOTDEL%
		GROUP BY %Exp:cGroup3%

		UNION ALL

		SELECT %Exp:cSelect4%
		FROM %Table:SC5% C5
		
		INNER JOIN %Exp:cJoinC6%
		C6.%NOTDEL%
		INNER JOIN %Exp:cJoinD2%
		D2.%NOTDEL%
		INNER JOIN %Exp:cJoinF2%
		F2.%NOTDEL%
		INNER JOIN %Exp:cJoinA3%
		A3_COD = C5_VEND4 AND
		A3.%NOTDEL%
		
		WHERE %Exp:cWhere4%
		C5.%NOTDEL%
		GROUP BY %Exp:cGroup4%

		UNION ALL

		SELECT %Exp:cSelect5%
		FROM %Table:SC5% C5
		
		INNER JOIN %Exp:cJoinC6%
		C6.%NOTDEL%
		INNER JOIN %Exp:cJoinD2%
		D2.%NOTDEL%
		INNER JOIN %Exp:cJoinF2%
		F2.%NOTDEL%
		INNER JOIN %Exp:cJoinA3%
		A3_COD = C5_VEND5 AND
		A3.%NOTDEL%
		
		WHERE %Exp:cWhere5%
		C5.%NOTDEL%
		GROUP BY %Exp:cGroup5%

	ENDSQL
	oSection:EndQuery()
	oSection:Print()

	(cAlias)->(dbCloseArea())

Return