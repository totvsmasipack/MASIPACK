#Include "MSCOMR005.ch"
#Include "Protheus.Ch"

/*/{Protheus.doc} RCOMR005
Relatório da análise da cotação ( Base: MATR210.prx )
@type  User Function
@author Masipack
@since 10/01/2020
/*/
User Function RCOMR005()

Local oReport

	oReport:= ReportDef()
	oReport:PrintDialog()
	                                               
Return

/*/{Protheus.doc} ReportDef
Relatório da análise da cotação ( Base: MATR210.prx )
@type  User Function
@author Masipack
@since 10/01/2020
@param nExp01: nReg = Registro posicionado do SC3 apartir Browse
@return oExpO1: Objeto do relatorio
/*/
Static Function ReportDef()

Local cArqTmp	:= GetNextAlias()
Local cTitle    := STR0002	//"Relacao de Analise das Cotacoes"
Local oReport 
Local oSection1
Local oSection2 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                           ³
	//³ mv_par01            // Da cotacao                              ³
	//³ mv_par02            // Ate a cotacao                           ³
	//³ mv_par03            // Lista por Fornecedor ou Valores         ³
	//³ mv_par04            // Sugere TE Padrao (S/N)                  ³
	//³ mv_par05            // Lista Encerradas (S/N)                  ³
	//³ mv_par06            // Descricao do produto                    ³
	//³ mv_par07            // Imprime Aliquota ICMS (Produtos/Cotação)³
	//³ mv_par08            // Imprime Aliquota IPI  (Produtos/Cotação)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTR210",.F.)

	oReport := TReport():New("RCOMR005",cTitle,"MTR210",{|oReport| ReportPrint(oReport,cArqTmp)},STR0001) //"Emissao da Relacao de Analise das Cotacoes"
	oReport:SetLandscape()
	oReport:DisableOrientation()

	oSection1 := TRSection():New(oReport,STR0032,{"cArqTmp","SC8"},/*aOrdem*/) //"Relacao de Analise das Cotacoes"
	TRCell():New(oSection1,"C8_NUM"		,cArqTmp	,"Nº Cotacao",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	oSection1:SetLineStyle()

	oSection2:= TRSection():New(oSection1,STR0033,{"cArqTmp","SC8","SB1","SB5"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
	TRCell():New(oSection2,"C8_PRODUTO"	,cArqTmp	,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"TB_DESCPRO"	,cArqTmp	,RetTitle("B1_DESC"),/*Picture*/,50,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"B1_UM"		,cArqTmp	,RetTitle("B1_UM"),/*Picture*/,5,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"ULT_PED"	,cArqTmp	,"Pedido",/*Picture*/,8,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"ULT_FORN"	,cArqTmp	,RetTitle("C7_FORNECE"),/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"ULT_COND"	,cArqTmp	,RetTitle("C7_COND"),/*Picture*/,15,/*lPixel*/,{|| POSICIONE("SE4",1,xFilial("SE4") + (cArqTmp)->ULT_COND, "E4_DESCRI") })
	TRCell():New(oSection2,"ULT_PRCUNI"	,cArqTmp	,RetTitle("C7_PRECO"),PesqPict("SC7","C7_PRECO"),TamSX3("C7_PRECO")[1]+8,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT",,"RIGHT")
	TRCell():New(oSection2,"ULT_DTENT"	,cArqTmp	,RetTitle("C7_DATPRF"),PesqPict("SC7","C7_DATPRF"),TamSX3("C7_DATPRF")[1]+10,/*lPixel*/,{|| STOD((cArqTmp)->ULT_DTENT)},"RIGHT",,"RIGHT")	
	TRCell():New(oSection2,"B5_MSOBS"	,cArqTmp	,RetTitle("B5_MSOBS"),PesqPict("SB5","B5_MSOBS"),80,/*lPixel*/,/*{|| code-block de impressao}*/,"LEFT",,"LEFT")	
	oSection2:Cell("TB_DESCPRO"):SetLineBreak() 
	
	oSection3:= TRSection():New(oSection2,STR0034,{"cArqTmp","SC8","SA2"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
	TRCell():New(oSection3,"C8_FORNECE"	,cArqTmp	,/*Titulo*/	,"@!",10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"A2_NOME"	,cArqTmp	,STR0025	,"@!",30,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"E4_DESCRI"	,cArqTmp	,"Cond. Pagto","@!",TamSX3("E4_DESCRI")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"C8_NUMSC"	,cArqTmp	,RetTitle("C8_NUMSC"),PesqPict("SC8","C8_NUMSC"),TamSX3("C8_NUMSC")[1],/*lPixel*/,/*{||  Val((cArqTmp)->C8_QUANT) }*/)
	TRCell():New(oSection3,"C8_QUANT"	,cArqTmp	,RetTitle("C8_QUANT"),PesqPict("SC8","C8_QUANT"),TamSX3("C8_QUANT")[1],/*lPixel*/,/*{||  Val((cArqTmp)->C8_QUANT) }*/)
	TRCell():New(oSection3,"C8_PRECO"	,cArqTmp	,RetTitle("C8_PRECO"),PesqPict("SC8","C8_PRECO"),TamSX3("C8_PRECO")[1],/*lPixel*/,/*{||  Val((cArqTmp)->C8_PRECO) }*/)
	TRCell():New(oSection3,"PRC_IMP"	,cArqTmp	,"Vl S/ Imp.",PesqPict("SC8","C8_PRECO"),TamSX3("C8_PRECO")[1],/*lPixel*/,/*{||  Val((cArqTmp)->C8_TOTAL) }*/,"RIGHT",,"RIGHT")
	TRCell():New(oSection3,"C8_TOTAL"	,cArqTmp	,RetTitle("C8_TOTAL"),PesqPict("SC8","C8_TOTAL"),TamSX3("C8_TOTAL")[1],/*lPixel*/,/*{||  Val((cArqTmp)->C8_TOTAL) }*/)
	TRCell():New(oSection3,"ALIIPI"		,cArqTmp	,"% IPI",PesqPict("SC8","C8_ALIIPI"),TamSX3("C8_ALIIPI")[1],/*lPixel*/,/*{||  Val((cArqTmp)->C8_ALIIPI) }*/)
	TRCell():New(oSection3,"PICM"		,cArqTmp	,"% ICMS",PesqPict("SC8","C8_PICM"),TamSX3("C8_PICM")[1],/*lPixel*/,/*{||  Val((cArqTmp)->C8_PICM) }*/)
	TRCell():New(oSection3,"C8_PRAZO"	,cArqTmp	,"Entrega",PesqPict("SC8","C8_DATPRF"),TamSX3("C8_DATPRF")[1]+4,/*lPixel*/,{||  DAYSUM(STOD((cArqTmp)->C8_DATPRF),(cArqTmp)->C8_PRAZO) },"LEFT",,"LEFT")
	TRCell():New(oSection3,"C8_DATPRF"	,cArqTmp	,RetTitle("C8_DATPRF"),PesqPict("SC8","C8_DATPRF"),TamSX3("C8_DATPRF")[1],/*lPixel*/,{||  STOD((cArqTmp)->C8_DATPRF) })
	TRCell():New(oSection3,"C8_OBS"		,cArqTmp	,RetTitle("C8_OBS"),PesqPict("SC8","C8_OBS"),60,/*lPixel*/,/*{||  STRTRAN((cArqTmp)->C8_OBS,Chr(13)," ### " ) }*/)
	oSection3:SetHeaderPage()

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Alexandre Inacio Lemes ³Data  ³09/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Analise das Cota‡oes.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cArqTmp)

Local cSelect		:= ""
Local cCodigo		:= ""
Local cOrder		:= ""
Local cProduto		:= ""
Local cWhere		:= ""
Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1) 
Local oSection3 	:= oReport:Section(1):Section(1):Section(1)

	cSelect := "%"
	cSelect	+= " C8_NUM, C8_PRODUTO, C8_FORNECE, C8_LOJA, A2_NOME, C8_QUANT, C8_PRECO, C8_TOTAL, C8_DATPRF, C8_PRAZO, B1_UM, C8_NUMSC, "
	cSelect += " ISNULL(" + ALLTRIM(MV_PAR06) + ",'N/D') AS TB_DESCPRO, "
	cSelect	+= " ISNULL(E4_DESCRI,'') AS E4_DESCRI, "
	cSelect	+= " ISNULL(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C8_OBS)),'') AS C8_OBS, "
	cSelect	+= " ISNULL(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),B5_MSOBS)),'') AS B5_MSOBS, "
	cSelect	+= If( MV_PAR07 == 1, "B1_PICM", "C8_PICM" ) + " AS PICM, "
	cSelect	+= If( MV_PAR08 == 1, "B1_IPI", "C8_ALIIPI" ) + " AS ALIIPI, "
	cSelect	+= " ISNULL(( CASE WHEN B1_PROCED IN ('2P') THEN ( C8_PRECO - ((C8_PRECO * ( (C8_PICM + " + Str(GetMV("MS_PCCOM05")) + " ) / 100)) ) ) ELSE 0 END ),'-') AS PRC_IMP, "
	cSelect	+= " ISNULL(( SELECT TOP 1 C7_NUM FROM "+RetSQLName("SC7")+" C7 WHERE C7_FILIAL = '"+xFilial("SC7")+"' AND C7_PRODUTO = C8_PRODUTO AND C7_RESIDUO = ' ' AND C7.D_E_L_E_T_ = ' ' ORDER BY C7_EMISSAO DESC ),'-') 	 AS ULT_PED, "
	cSelect	+= " ISNULL(( SELECT TOP 1 C7_FORNECE+'/'+C7_LOJA+' '+A2_NOME FROM " +RetSQLName("SC7")+ " C7, "+RetSQLName("SA2")+" A2 WHERE C7_FILIAL = '"+xFilial('SC7')+"' AND C7_PRODUTO = C8_PRODUTO AND C7_RESIDUO = ' ' AND C7.D_E_L_E_T_ = ' ' AND A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND A2.D_E_L_E_T_ = ' ' ORDER BY C7_EMISSAO DESC ),'-') AS ULT_FORN, " 
	cSelect	+= " ISNULL(( SELECT TOP 1 C7_COND FROM "  +RetSQLName("SC7")+ " C7 WHERE C7_FILIAL = '"+xFilial("SC7")+"' AND C7_PRODUTO = C8_PRODUTO AND C7_RESIDUO = ' ' AND C7.D_E_L_E_T_ = ' ' ORDER BY C7_EMISSAO DESC ),'-') AS ULT_COND, "
	cSelect	+= " ( SELECT TOP 1 C7_PRECO FROM  "  +RetSQLName("SC7")+ " C7 WHERE C7_FILIAL = '"+xFilial("SC7")+"' AND C7_PRODUTO = C8_PRODUTO AND C7_RESIDUO = ' ' AND C7.D_E_L_E_T_ = ' ' ORDER BY C7_EMISSAO DESC ) AS ULT_PRCUNI, "
	cSelect	+= " ( SELECT TOP 1 C7_DATPRF FROM " +RetSQLName("SC7")+ " C7 WHERE C7_FILIAL = '"+xFilial("SC7")+"' AND C7_PRODUTO = C8_PRODUTO AND C7_RESIDUO = ' ' AND C7.D_E_L_E_T_ = ' ' ORDER BY C7_EMISSAO DESC ) AS ULT_DTENT "
	cSelect += "%"

	cWhere	:= "%"
	cWhere	+= " C8_FILIAL = '"+xFilial("SC8")+"' AND "
	cWhere	+= " C8_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "

	If MV_PAR05 == 2
		cWhere	+= " C8_NUMPED = ' ' AND "
	Endif

	cWhere	+= " SC8.D_E_L_E_T_ = ' ' "
	cWhere	+= "%"

	cOrder := "%"
	If MV_PAR03 == 1
		cOrder += "C8_NUM, C8_PRODUTO, C8_FORNECE, C8_LOJA"
	Else
		cOrder += "C8_NUM, C8_PRODUTO, C8_PRECO "
	Endif
	cOrder += "%"

	BEGINSQL Alias cArqTmp
		
		SELECT  %Exp:cSelect%
		
		FROM    %Table:SC8% SC8

		INNER JOIN %Table:SB1% SB1 ON
		B1_FILIAL = %xFilial:SB1% AND  
		B1_COD = C8_PRODUTO AND
		SB1.%NOTDEL%

		INNER JOIN %Table:SA2% SA2 ON
		A2_FILIAL = %xFilial:SA2% AND  
		A2_COD = C8_FORNECE AND  
		A2_LOJA = C8_LOJA AND
		SA2.%NOTDEL%

		LEFT JOIN %Table:SE4% SE4 ON
		E4_FILIAL = %xFilial:SE4% AND  
		E4_CODIGO = C8_COND AND
		SE4.%NOTDEL%
		
		LEFT JOIN %Table:SB5% SB5 ON
		B5_FILIAL = %xFilial:SB5% AND
		B5_COD = C8_PRODUTO AND
		SB5.%NOTDEL%

		WHERE   %Exp:cWhere%
		ORDER BY %Exp:cOrder%
	ENDSQL

	While (cArqTmp)->(!EOF())

		If !(cCodigo == (cArqTmp)->C8_NUM)
			oSection1:Init()
			oSection1:PrintLine()
			oSection1:Finish()
		Endif

		If !(cProduto == (cArqTmp)->C8_PRODUTO) .And. (cArqTmp)->(C8_TOTAL) > 0
				
			oSection2:Init()
			oSection2:PrintLine()
			oSection2:Finish()

		//	oSection3:Finish()
		//	oSection3:Init()

			cProduto := (cArqTmp)->C8_PRODUTO

		Endif
		
		If (cArqTmp)->C8_TOTAL > 0
			oSection3:Init()
			oSection3:PrintLine()
			oSection3:Finish()
		Endif

		cCodigo  := (cArqTmp)->C8_NUM
		
		(cArqTmp)->(dbSkip())
	Enddo

	(cArqTmp)->(dbCloseArea())

Return 
