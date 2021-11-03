#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTM017  ºAutor  ³Victor Dessunte     º Data ³  10/18/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de comparacao dos ultimos dois meses do digitado º±±
±±º          ³ no parametro                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTM017()

Local 	_cQry     := ""
Local 	_cMesAnt1 := ""
Local 	_cAnoAnt1 := ""
Local 	_cMesAnt2 := ""
Local 	_cAnoAnt2 := ""
Private _cDtAnt1   := ""
Private _cDtAnt2   := ""

If Pergunte("RESTM017",.T.)
	LjMsgRun("Gerando dados aguarde..." ,,{||GerDad()})
	LjMsgRun("Gerando planilha..."		,,{||GerPla()})
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTM017  ºAutor  ³Victor Dessunte     º Data ³  10/18/17   º±±
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

_cQry := " SELECT " + CRLF
_cQry += "		B1_COD							'CODIGO'	 		, " + CRLF
_cQry += "		B1_DESC							'DESCRICAO'		, " + CRLF
_cQry += "		B1_UM								'UM'		  		, " + CRLF
_cQry += "		B1_PROCED						'PROCEDENCIA'	, " + CRLF
_cQry += "		B1_UPRC							'PRC_COMPRA'	, " + CRLF
_cQry += "		B1_UCOM							'DT_COMPRA'		, " + CRLF
_cQry += "		B1_CUSTD	  						'CUSTD'			, " + CRLF
_cQry += "		B1_UCALSTD						'DT_CUSTD'		, " + CRLF
_cQry += "		ISNULL(B2_QATU			,'')	'QUANTIDADE'	, " + CRLF
_cQry += "		ISNULL(B2_CM1			,'')	'CUSTO_MEDIO'	, " + CRLF
_cQry += "		ISNULL(B91.B9_DATA	,'')	'DT_FECH1'		, " + CRLF
_cQry += "		ISNULL(B91.B9_QINI	,'')	'QTD_FECH1'		, " + CRLF
_cQry += "		ISNULL(B91.B9_CM1		,'')	'CM_FECH1'		, " + CRLF
_cQry += "		ISNULL(B91.B9_VINI1	,'')	'VINI_FECH1'	, " + CRLF
_cQry += "		ISNULL(B91.B9_CUSTD	,'')	'CUSTD_FECH1'	, " + CRLF
_cQry += "		ISNULL(B92.B9_DATA	,'')	'DT_FECH2'		, " + CRLF
_cQry += "		ISNULL(B92.B9_QINI	,'')	'QTD_FECH2'		, " + CRLF
_cQry += "		ISNULL(B92.B9_CM1		,'')	'CM_FECH2'		, " + CRLF
_cQry += "		ISNULL(B92.B9_VINI1	,'')	'VINI_FECH2'	, " + CRLF
_cQry += "		ISNULL(B92.B9_CUSTD	,'')	'CUSTD_FECH2'	, " + CRLF
_cQry += "		ISNULL(B93.B9_DATA	,'')	'DT_FECH3'		, " + CRLF
_cQry += "		ISNULL(B93.B9_QINI	,'')	'QTD_FECH3'		, " + CRLF
_cQry += "		ISNULL(B93.B9_CM1		,'')	'CM_FECH3'		, " + CRLF
_cQry += "		ISNULL(B93.B9_VINI1	,'')	'VINI_FECH3'	, " + CRLF
_cQry += "		ISNULL(B93.B9_CUSTD	,'')	'CUSTD_FECH3'  , " + CRLF
_cQry += "		(	SELECT  " + CRLF
_cQry += "				TOP 1 ISNULL(DA1_PRCVEN ,'') " + CRLF
_cQry += "			FROM " + CRLF
_cQry += 				RetSqlName("DA1") + " DA1 " + CRLF
_cQry += "			WHERE " + CRLF
_cQry += "					DA1.D_E_L_E_T_	= '' " + CRLF
_cQry += "			AND 	DA1_FILIAL		= '" + xFilial("DA1") + "' " + CRLF
_cQry += "			AND 	DA1_CODPRO		= '" + MV_PAR04 + "' " + CRLF
_cQry += "			AND 	DA1_CODPRO		= B1_COD " + CRLF
_cQry += "			ORDER BY R_E_C_N_O_ DESC ) AS 'TABPRC'" + CRLF

_cQry += "	FROM " + CRLF
_cQry += 		RetSqlName("SB1") + " B1 INNER JOIN " + RetSqlName("SB2") + " B2 " + CRLF
_cQry += "		ON	B2.D_E_L_E_T_	= '' " + CRLF
_cQry += "		AND B2_FILIAL		= '" + xFilial("SB2") + "' " + CRLF
_cQry += "		AND B2_LOCAL		= '01' " + CRLF
_cQry += "		AND B2_COD			= B1_COD " + CRLF

If !Empty(MV_PAR01)
	_cQry += "		LEFT JOIN " + RetSqlName("SB9") + " B91 " + CRLF
	_cQry += "		ON	B91.D_E_L_E_T_	= '' " + CRLF
	_cQry += "		AND B91.B9_FILIAL	= '" + xFilial("SB9") + "' " + CRLF
	_cQry += "		AND B91.B9_LOCAL	= '01' " + CRLF
	_cQry += "		AND B91.B9_DATA	LIKE '" + MV_PAR01 + "%' " + CRLF
	_cQry += "		AND B91.B9_COD		= B1_COD " + CRLF
EndIf

If !Empty(MV_PAR02)
	_cQry += "		LEFT JOIN " + RetSqlName("SB9") + " B92 " + CRLF
	_cQry += "		ON	B92.D_E_L_E_T_	= '' " + CRLF
	_cQry += "		AND B92.B9_FILIAL	= '" + xFilial("SB9") + "' " + CRLF
	_cQry += "		AND B92.B9_LOCAL	= '01' " + CRLF
	_cQry += "		AND B92.B9_DATA	LIKE '" + MV_PAR02 + "%' " + CRLF
	_cQry += "		AND B92.B9_COD		= B1_COD " + CRLF
EndIf

If !Empty(MV_PAR03)
	_cQry += "		LEFT JOIN " + RetSqlName("SB9") + " B93 " + CRLF
	_cQry += "		ON	B93.D_E_L_E_T_	= '' " + CRLF
	_cQry += "		AND B93.B9_FILIAL	= '" + xFilial("SB9") + "' " + CRLF
	_cQry += "		AND B93.B9_LOCAL	= '01' " + CRLF
	_cQry += "		AND B93.B9_DATA	LIKE '" + MV_PAR03 + "%' " + CRLF
	_cQry += "		AND B93.B9_COD		= B1_COD " + CRLF
EndIf

_cQry += "	WHERE " + CRLF
_cQry += "			B1.D_E_L_E_T_	= '' " + CRLF
_cQry += "	AND 	B1_FILIAL		= '" + xFilial("SB1") + "' " + CRLF
_cQry += "	AND 	B1_PROCED		LIKE '%" + IIF(MV_PAR07==1,'P','N') + "' " + CRLF
_cQry += "	AND	B1_COD			BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF
_cQry += "	ORDER BY 1 "

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
±±ºPrograma  ³RESTM017  ºAutor  ³Victor Dessunte     º Data ³  10/18/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera planilha com dados                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GerPla()


Local cArqCSV  := "C:\Relato_Microsiga\RESTM017.csv"

If (cArqCSV := FCreate(cArqCSV)) == -1
	apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
	cRegCSV := "Código;Descrição;UM;Procedencia;R$ Compra;Data Compra;Custo Standard;Data Cus.Stand.;Qtd. Atual;Custo Médio;"
	cRegCSV += "Dt. Fech. 1;Qtd. Fech. 1;Cus.Méd.Fech. 1;R$ Inicial 1;Cus.Stand. 1;Dt. Fech. 2;Qtd. Fech. 2;Cus.Méd.Fech. 2;"
	cRegCSV += "R$ Inicial 2;Cus.Stand. 2;Dt. Fech. 3;Qtd. Fech. 3;Cus.Méd.Fech. 3;R$ Inicial 3;Cus.Stand. 3;R$ Tab. Preço"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf

TRB->(dbGoTop())
While TRB->(!EOF())
	
	cRegCSV := "_"+ALLTRIM(TRB->CODIGO)+";"+ALLTRIM(TRB->DESCRICAO)+";"+ALLTRIM(TRB->UM)+";"+ALLTRIM(TRB->PROCEDENCIA)+";"+ALLTRIM(TRANSFORM(TRB->PRC_COMPRA,"@E 9999,999,999,999.99"))+";"+DTOC(STOD(TRB->DT_COMPRA))+";"
	cRegCSV += ALLTRIM(TRANSFORM(TRB->CUSTD,"@E 9999,999,999,999.99"))+";"+DTOC(STOD(TRB->DT_CUSTD))+";"+ALLTRIM(TRANSFORM(TRB->QUANTIDADE,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->CUSTO_MEDIO,"@E 9999,999,999,999.99"))+";"+DTOC(STOD(TRB->DT_FECH1))+";"
	cRegCSV += ALLTRIM(TRANSFORM(TRB->QTD_FECH1,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->CM_FECH1,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->VINI_FECH1,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->CUSTD_FECH1,"@E 9999,999,999,999.99"))+";"+DTOC(STOD(TRB->DT_FECH2))+";"
	cRegCSV += ALLTRIM(TRANSFORM(TRB->QTD_FECH2,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->CM_FECH2,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->VINI_FECH2,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->CUSTD_FECH2,"@E 9999,999,999,999.99"))+";"+DTOC(STOD(TRB->DT_FECH3))+";"
	cRegCSV += ALLTRIM(TRANSFORM(TRB->QTD_FECH3,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->CM_FECH3,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->VINI_FECH3,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->CUSTD_FECH3,"@E 9999,999,999,999.99"))+";"+ALLTRIM(TRANSFORM(TRB->TABPRC,"@E 9999,999,999,999.99"))
	
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	TRB->(dbSkip())
End

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

FClose(cArqCSV)

If File("C:\Relato_Microsiga\RESTM017.csv")
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:\Relato_Microsiga\RESTM017.csv")
	oExcelApp:SetVisible(.T.)
EndIf

Return
