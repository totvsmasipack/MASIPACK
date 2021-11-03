#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR073  ºAutor  ³Victor Dessunte     º Data ³  07/24/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de intercomany para confrontar saida x entrada   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR073()

Local 	 _cQry     := ""
Private 	_cAba1 := ""
Private 	_cAba2 := ""
Private    cNomeArq  := Upper(AllTrim(SM0->M0_NOME) + '_' + AllTrim(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_' + 'RESTR073.xml')

If !Pergunte("RFATR073")
	Return
EndIf

LjMsgRun("Aguarde... Gerando Dados..."   ,,{||RFATR73A()})

If !TRB->(EOF()) .OR. !TRB2->(EOF())
	LjMsgRun("Aguarde... Gerando planilha...",,{||RFATR73B()})
Else
	Alert("Sem dados para exibição!")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR073  ºAutor  ³Victor Dessunte     º Data ³  07/24/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem do arquivo Excel                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RFATR73B()

Local oExcel	:= FWMSEXCEL():New()
Local _cTabela  := "Notas Fiscais Intercompany de " + ( AllTrim(SM0->M0_NOME) + " para " + _cAba1 )
Local _cTabela2 := "Notas Fiscais Intercompany de " + ( AllTrim(SM0->M0_NOME) + " para " + _cAba2 ) 

oExcel:AddWorkSheet(_cAba1)
oExcel:AddTable(_cAba1,_cTabela)
oExcel:AddColumn(_cAba1,_cTabela,"NF - Saída"			,1,1,.F.)
oExcel:AddColumn(_cAba1,_cTabela,"Série - Saída"		,1,1,.F.)
oExcel:AddColumn(_cAba1,_cTabela,"Valor"				,3,2,.F.)
oExcel:AddColumn(_cAba1,_cTabela,"Emissão"				,1,4,.F.)
oExcel:AddColumn(_cAba1,_cTabela,"Cliente"				,1,1,.F.)
oExcel:AddColumn(_cAba1,_cTabela,"Tipo Saída"			,1,1,.F.)
oExcel:AddColumn(_cAba1,_cTabela,"Fornecedor"			,1,1,.F.)
oExcel:AddColumn(_cAba1,_cTabela,"Tipo Entrada"		    ,1,1,.F.)

oExcel:AddWorkSheet(_cAba2)
oExcel:AddTable(_cAba2,_cTabela2)
oExcel:AddColumn(_cAba2,_cTabela2,"NF - Saída"			,1,1,.F.)
oExcel:AddColumn(_cAba2,_cTabela2,"Série - Saída"		,1,1,.F.)
oExcel:AddColumn(_cAba2,_cTabela2,"Valor"				,3,2,.F.)
oExcel:AddColumn(_cAba2,_cTabela2,"Emissão"				,1,4,.F.)
oExcel:AddColumn(_cAba2,_cTabela2,"Cliente"				,1,1,.F.)
oExcel:AddColumn(_cAba2,_cTabela2,"Tipo Saída"			,1,1,.F.)
oExcel:AddColumn(_cAba2,_cTabela2,"Fornecedor"			,1,1,.F.)
oExcel:AddColumn(_cAba2,_cTabela2,"Tipo Entrada"		,1,1,.F.)

dbSelectArea("TRB")
TRB->(dbGoTop())
While TRB->(!EOF())
	oExcel:AddRow(_cAba1,_cTabela,{	TRB->F2_DOC			,;//01-NUMERO DA NF
																							TRB->F2_SERIE		,;//02-SERIE DA NF
																							TRB->F2_VALBRUT	,;//03-VALOR BRUTO
																							TRB->F2EMIS			,;//04-EMISSAO
																							TRB->F2CLIENTE		,;//05-CLIENTE 
																							TRB->F2_TIPO		,;//06-TIPO DE SAIDA NF
																							TRB->F1FORNECE		,;//07-FORNECEDOR
																							TRB->F1TIPO			})//08-TIPO DE ENTRADA DA NF
	TRB->(dbSkip())
End

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

dbSelectArea("TRB2")
TRB2->(dbGoTop())
While TRB2->(!EOF())
	oExcel:AddRow(_cAba2,_cTabela2,{	TRB2->F2_DOC		,;//01-NUMERO DA NF
																							TRB2->F2_SERIE		,;//02-SERIE DA NF
																							TRB2->F2_VALBRUT	,;//03-VALOR BRUTO
																							TRB2->F2EMIS			,;//04-EMISSAO
																							TRB2->F2CLIENTE	,;//05-CLIENTE 
																							TRB2->F2_TIPO		,;//06-TIPO DE SAIDA NF
																							TRB2->F1FORNECE	,;//07-FORNECEDOR
																							TRB2->F1TIPO		})//08-TIPO DE ENTRADA DA NF
	TRB2->(dbSkip())
End

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf



//oExcel:Activate()
//oExcel:GetXMLFile("C:/RELATO_MICROSIGA/RFATR073.xml")

//If File("C:/RELATO_MICROSIGA/RFATR073.xml")
	//oExcelApp := MsExcel():New()
	//oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/RFATR073.xml")
	//oExcelApp:SetVisible(.T.)
//EndIf

oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/" + cNomeArq)

If File("C:/RELATO_MICROSIGA/" + cNomeArq)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/" + cNomeArq)
	oExcelApp:SetVisible(.T.)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR73A  ºAutor  ³Victor Dessunte     º Data ³  07/24/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra dados via querie                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RFATR73A()

Local _cQry			:= ""
Local _cTab1		:= ""
Local _cTab2		:= ""
Local _cCodCli1	:= ""
Local _cCodCli2	:= ""
Local _cCodFor1	:= ""
Local _cCodFor2	:= ""
Local _cCodCli11	:= ""
Local _cCodCli22	:= ""

If SM0->M0_CODIGO == '01' //MASIPACK
	_cAba1	 := "FABRIMA"
	_cAba2	 := "HELSIMPLAST"
	_cTab1    := "100" //FABRIMA
	_cTab2    := "150" //HELSIMPLAST
	_cCodCli1 := "006018" //CODIGO DE CLIENTE FABRIMA NA MASIPACK
	_cCodCli2 := "008352" //CODIGO DE CLIENTE HELSIMPLAST NA MASIPACK
	_cCodFor1 := "001256" //CODIGO DE FORNECEDOR MASIPACK NA FABRIMA
	_cCodFor2 := "000004" //CODIGO DE FORNECEDOR MASIPACK NA HELSIMPLAST
	_cCodCli11:= "999999" //CODIGO DE CLIENTE MASIPACK NA FABRIMA
	_cCodCli22:= "000002" //CODIGO DE CLIENTE MASIPACK NA HELSIMPLAST
ElseIf SM0->M0_CODIGO == '10' //FABRIMA
	_cAba1	 := "MASIPACK"
	_cAba2	 := "HELSIMPLAST"
	_cTab1 	 := "010" //MASIPACK
	_cTab2 	 := "150" //HELSIMPLAST
	_cCodCli1 := "999999" //CODIGO DE CLIENTE MASIPACK NA FABRIMA
	_cCodCli2 := "008352" //CODIGO DE CLIENTE HELSIMPLAST NA FABRIMA
	_cCodFor1 := "005144" //CODIGO DE FORNECEDOR FABRIMA NA MASIPACK
	_cCodFor2 := "000093" //CODIGO DE FORNECEDOR FABRIMA NA HELSIMPLAST
	_cCodCli11:= "006018" //CODIGO DE CLIENTE FABRIMA NA MASIPACK
	_cCodCli22:= "000013" //CODIGO DE CLIENTE FABRIMA NA HELSIMPLAST
ElseIf SM0->M0_CODIGO == '15' //HELSIMPLAST
	_cAba1	 := "MASIPACK"
	_cAba2	 := "FABRIMA"
	_cTab1 	 := "010" //MASIPACK
	_cTab2 	 := "100" //FABRIMA
	_cCodCli1 := "000002" //CODIGO DE CLIENTE MASIPACK NA HELSIMPLAST
	_cCodCli2 := "000013" //CODIGO DE CLIENTE FABRIMA NA HELSIMPLAST
	_cCodFor1 := "005001" //CODIGO DE FORNECEDOR HELSIMPLAST NA MASIPACK
	_cCodFor2 := "005001" //CODIGO DE FORNECEDOR HELSIMPLAST NA FABRIMA
	_cCodCli11:= "008352" //CODIGO DE CLIENTE HELSIMPLAST NA MASIPACK
	_cCodCli22:= "008352" //CODIGO DE CLIENTE HELSIMPLAST NA FABRIMA
Else
	Alert("Para gerar o relatório acesse uma das empresas Masipack, Fabrima ou Helsimplast.")
	Return
EndIf

_cQry := " SELECT " + CRLF
_cQry += " 	F2_DOC		, " + CRLF
_cQry += " 	F2_SERIE	, " + CRLF
_cQry += "	F2_VALBRUT , " + CRLF
_cQry += "	SUBSTRING(F2_EMISSAO,7,2) + '/' + SUBSTRING(F2_EMISSAO,5,2) + '/' + SUBSTRING(F2_EMISSAO,1,4) 'F2EMIS' , " + CRLF
_cQry += " 	F2_CLIENTE+'/'+F2_LOJA+' - '+A1_NREDUZ AS 'F2CLIENTE', " + CRLF
_cQry += " 	F2_TIPO, " + CRLF

_cQry += "	ISNULL(F1_FORNECE+'/'+F1_LOJA+' - ' + " + CRLF
_cQry += "	CASE F1_TIPO " + CRLF
_cQry += "		WHEN 'N' THEN " + CRLF
_cQry += " 			(SELECT ISNULL(A2_NREDUZ,'') FROM SA2010 A2 WHERE A2.D_E_L_E_T_ = ' ' AND A2_FILIAL = ' ' AND A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA) " + CRLF
_cQry += "	ELSE " + CRLF
_cQry += "		(SELECT ISNULL(A1_NREDUZ,'') FROM SA1010 A1 WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = ' ' AND A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA) " + CRLF
_cQry += "	END,'') AS 'F1FORNECE', " + CRLF

_cQry += " 	ISNULL(F1_TIPO,'') 'F1TIPO' " + CRLF
_cQry += " FROM " + CRLF
_cQry +=  	RetSqlName("SF2") + " F2 LEFT JOIN SF1" + _cTab1 + " F1 " + CRLF
_cQry += " 	ON	F1.D_E_L_E_T_	= '' " + CRLF
_cQry += " 	AND F1_FILIAL		= '01' " + CRLF
_cQry += " 	AND F1_DOC			LIKE '%'+LTRIM(RTRIM(F2_DOC))+'%' " + CRLF
_cQry += " 	AND F1_SERIE		= F2_SERIE " + CRLF
_cQry += " 	AND F1_FORNECE		= (CASE WHEN F1_TIPO = 'B' THEN '" + _cCodCli11 + "' ELSE '" + _cCodFor1 + "' END)" + CRLF
_cQry += " 	AND F1_LOJA			= '00' " + CRLF

_cQry += " 	LEFT JOIN " + RetSqlName("SA1") + " A1 " + CRLF
_cQry += " 	ON	A1.D_E_L_E_T_	= '' " + CRLF
_cQry += " 	AND A1_FILIAL		= '" + xFilial("SA1") + "' " + CRLF
_cQry += " 	AND A1_COD			= F2_CLIENTE " + CRLF
_cQry += " 	AND A1_LOJA			= F2_LOJA " + CRLF

_cQry += " WHERE " + CRLF
_cQry += " 		F2.D_E_L_E_T_	= '' " + CRLF
_cQry += " AND F2_FILIAL		= '" + xFilial("SF2") + "' " + CRLF
_cQry += " AND F2_CLIENTE		= '" + _cCodCli1 + "' " + CRLF
_cQry += " AND F2_LOJA			= '00' " + CRLF
_cQry += " AND F2_EMISSAO		BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF
_cQry += " ORDER BY 1,2 "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

_cQry := " SELECT " + CRLF
_cQry += " 	F2_DOC		, " + CRLF
_cQry += " 	F2_SERIE	, " + CRLF
_cQry += "	F2_VALBRUT , " + CRLF
_cQry += "	SUBSTRING(F2_EMISSAO,7,2) + '/' + SUBSTRING(F2_EMISSAO,5,2) + '/' + SUBSTRING(F2_EMISSAO,1,4) 'F2EMIS' , " + CRLF
_cQry += " 	F2_CLIENTE+'/'+F2_LOJA+' - '+A1_NREDUZ AS 'F2CLIENTE', " + CRLF
_cQry += " 	F2_TIPO, " + CRLF
_cQry += "	ISNULL(F1_FORNECE+'/'+F1_LOJA+' - ' + " + CRLF
_cQry += "	CASE F1_TIPO " + CRLF
_cQry += "		WHEN 'N' THEN " + CRLF
_cQry += " 			(SELECT ISNULL(A2_NREDUZ,'') FROM SA2" + IIF(_cTab2=='100','010',_cTab2) + " A2 WHERE A2.D_E_L_E_T_ = ' ' AND A2_FILIAL = '" + IIF(_cTab2 == '150','01','') + "' AND A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA) " + CRLF
_cQry += "	ELSE " + CRLF
_cQry += "		(SELECT ISNULL(A1_NREDUZ,'') FROM SA1" + IIF(_cTab2=='100','010',_cTab2) + " A1 WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '" + IIF(_cTab2 == '150','01','') + "' AND A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA) " + CRLF
_cQry += "	END,'') AS 'F1FORNECE', " + CRLF
_cQry += " 	ISNULL(F1_TIPO,'') 'F1TIPO' " + CRLF
_cQry += " FROM " + CRLF
_cQry +=  	RetSqlName("SF2") + " F2 LEFT JOIN SF1" + _cTab2 + " F1 " + CRLF
_cQry += " 	ON	F1.D_E_L_E_T_	= '' " + CRLF
_cQry += " 	AND F1_FILIAL		= '01' " + CRLF
_cQry += " 	AND F1_DOC			LIKE '%'+LTRIM(RTRIM(F2_DOC))+'%' " + CRLF
_cQry += " 	AND F1_SERIE		= F2_SERIE " + CRLF
_cQry += " 	AND F1_FORNECE		= (CASE WHEN F1_TIPO = 'B' THEN '" + _cCodCli22 + "' ELSE '" + _cCodFor2 + "' END)" + CRLF
_cQry += " 	AND F1_LOJA			= '00' " + CRLF

_cQry += " 	LEFT JOIN " + RetSqlName("SA1") + " A1 " + CRLF
_cQry += " 	ON	A1.D_E_L_E_T_	= '' " + CRLF
_cQry += " 	AND A1_FILIAL		= '" + xFilial("SA1") + "' " + CRLF
_cQry += " 	AND A1_COD			= F2_CLIENTE " + CRLF
_cQry += " 	AND A1_LOJA			= F2_LOJA " + CRLF

_cQry += " WHERE " + CRLF
_cQry += " 		F2.D_E_L_E_T_	= '' " + CRLF
_cQry += " AND F2_FILIAL		= '" + xFilial("SF2") + "' " + CRLF
_cQry += " AND F2_CLIENTE		= '" + _cCodCli2 + "' " + CRLF
_cQry += " AND F2_LOJA			= '00' " + CRLF
_cQry += " AND F2_EMISSAO		BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF
_cQry += " ORDER BY 1,2 "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB2"

Return