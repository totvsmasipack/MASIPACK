#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} RESTR035
	//TODO Relatorio para comparativo de estoque.
	@author alison.goncalves
	@since 12/03/2018
	@version 1.0
	@return Nil
	@type function
/*/
User Function RESTR035()
	Local cNextAls	:= GetNextAlias()
	LjMsgRun("Gerando dados aguarde..." ,,{||GeraDad(cNextAls)})
	LjMsgRun("Gerando planilha..."		,,{||GeraPla(cNextAls)})
	
Return

/*/{Protheus.doc} GeraDad
	//TODO Busca os dados de estoque para geração de planilha
	@author alison.goncalves
	@since 12/03/2018
	@version 1.0
	@return Retorna o cursor com informações do estoque.
	@param cNextAls, characters, descricao
	@type function
/*/
Static Function GeraDad(cNextAls)


	BeginSql Alias cNextAls

		SELECT	B2_COD,
		ISNULL(B1_DESC,'') B1_DESC ,
		B1_PROCED,
		B1_LOCAL,
		B2_QFIM,
		B2_VFIM1,
		ISNULL(SUM(D4_QUANT) ,0) D4_QUANT,
		ISNULL(SUM(C6_QTDVEN),0) QTDVEN,
		ISNULL(SUM(C6_QTDENT),0) QTDENT, 
		ISNULL(SUM(C6_QTDVEN),0) - ISNULL(SUM(C6_QTDENT),0) AS PEDIDO_ENTREGUE

		FROM %Table:SB2% B2

		INNER JOIN %Table:SB1% B1 
		ON		B1.D_E_L_E_T_	= '' 
		AND 	B1_FILIAL		= %xfilial:SB1%
		AND 	B1_COD			= B2_COD 
		AND 	B1.%notDel%

		LEFT JOIN %Table:SC6% C6 
		ON		C6.D_E_L_E_T_	= '' 
		AND 	C6_FILIAL		= %xfilial:SB1%
		AND 	C6_PRODUTO		= B2_COD 
		AND 	C6.%notDel%

		LEFT JOIN %Table:SD4% D4 
		ON		D4.D_E_L_E_T_	= '' 
		AND 	D4_FILIAL		= %xfilial:SB1%
		AND 	D4_LOCAL		= '01'
		AND 	D4_COD			= B2_COD
		AND 	D4.%notDel%

		WHERE B2_QFIM > 0 Or B2_VFIM1 > 0 Or C6_QTDVEN is not null Or C6_QTDENT is not null

		GROUP BY B2_COD,B1_DESC, B2_QFIM,B2_VFIM1,B1_PROCED,B1_LOCAL


	EndSql

Return


/*/{Protheus.doc} GeraPla
	//TODO Gera planilha com as informações do cursor gerado.
	@author alison.goncalves
	@since 12/03/2018
	@version 1.0
	@return Gera um relatório em XML e abre no excel em colunas.
	@param cNextAls, characters, descricao
	@type function
/*/
Static Function GeraPla(cNextAls)
	Local cFile 	:= 'C:/RELATO_MICROSIGA/' + Upper(AllTrim(SM0->M0_NOME))	+	'_'	+ ALLTRIM(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_RESTR035.xml'
	Local oExcel 	:= FWMSEXCEL():New()

	oExcel:AddWorkSheet("Comparativo")
	oExcel:AddTable("Comparativo"	,"Comparativo de Estoque")
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Código"						,1,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Descrição"						,1,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Procedencia"					,1,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Local"							,1,1,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Qtd. Fim"						,1,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","Val. FIm"						,1,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","d4 quantidade"					,1,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","qtd venda."					,1,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","qtd ent"						,1,2,.F.)
	oExcel:AddColumn("Comparativo","Comparativo de Estoque","pedido - entregue"				,1,2,.F.)


	(cNextAls)->(dbGoTop())
	While (cNextAls)->(!EOF())
		oExcel:AddRow("Comparativo","Comparativo de Estoque",{	(cNextAls)->B2_COD,;
		(cNextAls)->B1_DESC,; 
		(cNextAls)->B1_PROCED,;
		(cNextAls)->B1_LOCAL,;
		(cNextAls)->B2_QFIM,;
		(cNextAls)->B2_VFIM1,;
		(cNextAls)->D4_QUANT,;
		(cNextAls)->QTDVEN,;
		(cNextAls)->QTDENT,;
		(cNextAls)->PEDIDO_ENTREGUE ;
		},;
		)

		(cNextAls)->(dbSkip())
	End

	If Select(cNextAls) > 0
		(cNextAls)->(dbCloseArea())
	EndIf

	oExcel:Activate()
	oExcel:GetXMLFile(cFile)

	If File(cFile)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cFile)
		oExcelApp:SetVisible(.T.)
	EndIf

Return
