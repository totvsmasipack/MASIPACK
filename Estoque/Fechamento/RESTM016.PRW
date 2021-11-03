#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTM016  ºAutor  ³Victor Dessunte     º Data ³  10/16/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de compras x contabil                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTM016()

If Pergunte("RESTR030",.T.)
	LjMsgRun("Gerando dados..."		,,{||GerDad()})
	If TRB->(!EOF())
		LjMsgRun("Gerando planilha..."	,,{||GerPla()})
	Else
		MsgAlert("Sem dados para gerar o relatório!")
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTM016  ºAutor  ³Victor Dessunte     º Data ³  10/16/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera dados                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GerDad()

Local _cQry := ""

/*MATERIAIS PRODUTIVOS COM TES QUE CONTROLA ESTOQUE*/
_cQry := " SELECT " + CRLF
_cQry += " 	A.*, " + CRLF
_cQry += " 	CT2_HIST					'HIST_CT2'			, " + CRLF
_cQry += " 	ISNULL(SUM(CT2_VALOR),0)	'VALOR_CT2' " + CRLF
_cQry += " FROM " + CRLF
_cQry += " (	SELECT  " + CRLF
_cQry += " 		F1_FORNECE + '-' + F1_LOJA	'FORNECEDOR'		, " + CRLF
_cQry += " 		CASE " + CRLF
_cQry += " 			WHEN F1_TIPO IN('D','B') THEN " + CRLF
_cQry += " 				A1_NREDUZ " + CRLF
_cQry += " 			ELSE " + CRLF
_cQry += " 				A2_NREDUZ " + CRLF
_cQry += " 		END								'NOME'				, " + CRLF
_cQry += " 		D1_DOC							'NF'					, " + CRLF
_cQry += " 		D1_SERIE							'SERIE'				, " + CRLF
_cQry += " 		F1_TIPO							'TIPO'				, " + CRLF
_cQry += " 		D1_DTDIGIT						'DT'					, " + CRLF
_cQry += " 		D1_CF								'CFOP'				, " + CRLF
_cQry += " 		ISNULL(SUM(D1_TOTAL),0)		'TOTAL'				, " + CRLF
_cQry += " 		ISNULL(SUM(D1_CUSTO),0)		'CUSTO1'				, " + CRLF
_cQry += " 		ISNULL(SUM(D1_VALIPI),0)	'IPI'					, " + CRLF
_cQry += " 		ISNULL(SUM(D1_VALICM),0)	'ICMS'				, " + CRLF
_cQry += " 		ISNULL(SUM(D1_VALCOF),0)	'COFINS'				, " + CRLF
_cQry += " 		ISNULL(SUM(D1_VALFRE),0)	'FRETE'				, " + CRLF
_cQry += " 		ISNULL(SUM(D1_VALIMP5),0)	'COFINS_APURACAO'	, " + CRLF
_cQry += " 		ISNULL(SUM(D1_VALIMP6),0)	'PIS_APURACAO' " + CRLF
_cQry += " 	FROM " + CRLF
_cQry +=  		RetSqlName("SD1") + " SD1  " + CRLF
		
_cQry += " 		INNER JOIN " + RetSqlName("SF1") + " SF1 " + CRLF
_cQry += " 		ON	SF1.D_E_L_E_T_	= '' " + CRLF
_cQry += " 		AND F1_FILIAL		= '" + xFilial("SF1") + "' " + CRLF
_cQry += " 		AND F1_DOC			= D1_DOC " + CRLF
_cQry += " 		AND F1_SERIE		= D1_SERIE " + CRLF
_cQry += " 		AND F1_FORNECE		= D1_FORNECE " + CRLF
_cQry += " 		AND F1_LOJA			= D1_LOJA " + CRLF

_cQry += " 		INNER JOIN " + RetSqlName("SF4") + " SF4 " + CRLF
_cQry += " 		ON	SF4.D_E_L_E_T_	= '' " + CRLF
_cQry += " 		AND F4_CODIGO		= D1_TES " + CRLF
_cQry += " 		AND F4_ESTOQUE		= 'S' " + CRLF
_cQry += "		AND F4_FILIAL		= '" + xFilial("SF4") + "' " + CRLF

_cQry += " 		INNER JOIN " + RetSqlName("SB1") + " B1 " + CRLF
_cQry += " 		ON	B1.D_E_L_E_T_	= '' " + CRLF
_cQry += " 		AND B1_FILIAL		= '" + xFilial("SB1") + "' " + CRLF
_cQry += " 		AND B1_COD			= D1_COD " + CRLF
_cQry += " 		AND SUBSTRING(B1_PROCED,2,1) = 'P' " + CRLF

_cQry += " 		LEFT JOIN " + RetSqlName("SA2") + " A2 " + CRLF
_cQry += " 		ON	A2.D_E_L_E_T_	= ''  " + CRLF
_cQry += " 		AND A2_FILIAL		= '" + xFilial("SA2") + "' " + CRLF
_cQry += " 		AND A2_COD			= F1_FORNECE  " + CRLF
_cQry += " 		AND A2_LOJA			= F1_LOJA " + CRLF

_cQry += " 		LEFT JOIN " + RetSqlName("SA1") + " A1 " + CRLF
_cQry += " 		ON	A1.D_E_L_E_T_	= ' '  " + CRLF
_cQry += " 		AND A1_FILIAL		= '" + xFilial("SA1") + "' " + CRLF
_cQry += " 		AND A1_COD			= F1_FORNECE  " + CRLF
_cQry += " 		AND A1_LOJA			= F1_LOJA " + CRLF
_cQry += " 	WHERE " + CRLF
_cQry += " 			SD1.D_E_L_E_T_	= '' " + CRLF
_cQry += " 		AND D1_FILIAL		= '" + xFilial("SD1") + "' " + CRLF
_cQry += " 		AND D1_LOCAL		= '01' " + CRLF
_cQry += " 		AND D1_DTDIGIT		LIKE '" + MV_PAR01 + "%'" + CRLF
_cQry += " 	GROUP BY " + CRLF
_cQry += " 		F1_FORNECE +'-'+F1_LOJA, " + CRLF
_cQry += " 		A1_NREDUZ, " + CRLF
_cQry += " 		A2_NREDUZ, " + CRLF
_cQry += " 		D1_DOC, " + CRLF
_cQry += " 		D1_SERIE, " + CRLF
_cQry += " 		F1_TIPO, " + CRLF
_cQry += " 		D1_DTDIGIT, " + CRLF
_cQry += " 		D1_CF) A  " + CRLF
	
_cQry += " 	LEFT JOIN " + RetSqlName("CT2") + " CT2 " + CRLF
_cQry += " 	ON	CT2.D_E_L_E_T_	= '' " + CRLF
_cQry += " 	AND CT2_FILIAL		= '" + xFilial("CT2") + "' " + CRLF
_cQry += " 	AND CT2_DATA		= A.DT " + CRLF
_cQry += " 	AND CT2_HIST		LIKE '%'+RTRIM(LTRIM(A.NF))+'%' " + CRLF
_cQry += " 	AND CT2_HIST		LIKE '%'+RTRIM(LTRIM(A.NOME))+'%' " + CRLF
_cQry += " 	AND CT2_DEBITO		IN('112000005','112000006','112000010','330100001') " + CRLF
_cQry += " GROUP BY " + CRLF
_cQry += " 	A.CFOP, " + CRLF
_cQry += " 	A.COFINS, " + CRLF
_cQry += " 	A.[COFINS_APURACAO], " + CRLF
_cQry += " 	A.CUSTO1, " + CRLF
_cQry += " 	A.DT, " + CRLF
_cQry += " 	A.FORNECEDOR, " + CRLF
_cQry += " 	A.FRETE, " + CRLF
_cQry += " 	A.ICMS, " + CRLF
_cQry += " 	A.IPI, " + CRLF
_cQry += " 	A.NF, " + CRLF
_cQry += " 	A.SERIE, " + CRLF
_cQry += " 	A.TIPO, " + CRLF
_cQry += " 	A.NOME, " + CRLF
_cQry += " 	A.[PIS_APURACAO], " + CRLF
_cQry += " 	A.TOTAL, " + CRLF
_cQry += " 	CT2_HIST " + CRLF
_cQry += " ORDER BY 1,3 "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

TRB->(dbGoTop())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTM016  ºAutor  ³Victor Dessunte     º Data ³  10/16/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera planilha com dados                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GerPla()

Local oExcel 		:= FWMSEXCEL():New()
Local cNomeArq		:= Upper(AllTrim(SM0->M0_NOME)	+	'_'	+ AllTrim(MV_PAR01)	+ '_' +	AllTrim(DTOS(DATE()))	+	'_'	+	AllTrim(StrTran(TIME(),':',''))	+	'_'	+ 'RESTM016.xml')

oExcel:AddWorkSheet("Compras")
oExcel:AddTable("Compras"	,"Compras do mês")
oExcel:AddColumn("Compras"	,"Compras do mês","Fornecedor"			,1,1,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Nome"					,1,1,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","NF"						,1,1,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Serie"					,1,1,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Tipo"					,1,1,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Data"					,1,4,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","CFOP"					,1,1,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Total"					,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Custo"					,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","IPI"						,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","ICMS"					,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Cofins"					,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Frete"					,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Cofins Apuração"		,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","PIS Apuração"			,3,2,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Hist.CT2"				,1,1,.F.)
oExcel:AddColumn("Compras"	,"Compras do mês","Valor CT2"				,3,2,.F.)

TRB->(dbGoTop())
While TRB->(!EOF())
	oExcel:AddRow("Compras"	,"Compras do mês",{	TRB->FORNECEDOR		,; //01-CODIGO E LOJA DO FORNECEDOR
																TRB->NOME				,; //02-NOME DO FORNECEDOR
																TRB->NF					,; //03-NUMERO DA NOTA FISCAL
																TRB->SERIE				,; //04-SERIE DA NOTA FISCAL
																TRB->TIPO				,; //05-TIPO DA NOTA FISCAL
																STOD(TRB->DT)			,; //06-DATA DA EMISSAO DA NOTA FISCAL
																TRB->CFOP				,; //07-CFOP
																TRB->TOTAL				,; //08-VALOR TOTAL DA NOTA FISCAL
																TRB->CUSTO1				,; //09-CUSTO DA NOTA FISCAL
																TRB->IPI					,; //10-IPI
																TRB->ICMS				,; //11-ICMS
																TRB->COFINS	  			,; //12-COFINS
																TRB->FRETE		  		,; //13-FRETE
																TRB->COFINS_APURACAO	,; //14-COFINS APURACAO
																TRB->PIS_APURACAO		,; //15-PIS APURACAO
																TRB->HIST_CT2			,; //16-HISTORICO DA TABELA CT2
																TRB->VALOR_CT2			}) //17-VALOR NA CONTABILIDADE
	
	TRB->(dbSkip())
End

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/" + cNomeArq)

If File("C:/RELATO_MICROSIGA/" + cNomeArq)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/" + cNomeArq)
	oExcelApp:SetVisible(.T.)
EndIf

Return
