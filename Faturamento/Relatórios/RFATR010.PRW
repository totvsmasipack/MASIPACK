#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR010  ºAutor  ³Lizandra Marques    º Data ³  23/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de faturamento por NCM. Lei 12546/11              º±±
±±º          ³Desoneração da folha de pagamento                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
// Alterado por Ana Paula em 29/10/2012 para gerar arquivo CSV para importar desoneração da Folha no RH
*/

User Function RFATR010()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo  := "Produtos Faturados por NCM."
cDesc1  := "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2  := "Produtos Faturados por NCM."
cDesc3  := ""
cString := "SD2"
wnrel   := "RFATR010"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aReturn := { "Zebrado", 1,"Faturamento", 1, 2, 1, "",1 }

nLastkey := 0
cPerg    := "XRFATR010"

nTipo    := 15
m_pag    := 0
cabec1   := ""
cabec2   := ""
nomeprog := "RFATR010"

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	set filter to
	Return
Endif

//Arquivo gerado para importação do RH
If SubStr(cNumEmp,1,2) = "01"
	cNomarq := "Desoneracao_Folha_Mas_"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)
ElseIf SubStr(cNumEmp,1,2) = "10"
	cNomarq := "Desoneracao_Folha_Fab_"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)
ElseIf SubStr(cNumEmp,1,2) = "15"
	cNomarq := "Desoneracao_Folha_Hel_"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)
EndIf
If (cArqCSV := FCreate("C:\Relato_Microsiga\"+cNomarq+".csv")) == -1
	Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
EndIf

//Arquivo gerado para conferencia da Contabilidade
If MV_PAR03 = 2    // Relatorio Analitico
	If SubStr(cNumEmp,1,2) = "01"
		cNomarq1 := "Desonera_Analitico_Mas_"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)
	ElseIf SubStr(cNumEmp,1,2) = "10"
		cNomarq1 := "Desonera_Analitico_Fab_"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)
	ElseIf SubStr(cNumEmp,1,2) = "15"
		cNomarq1 := "Desonera_Analitico_Hel_"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)
	EndIf
	
	If (cArqCSV1 := FCreate("C:\Relato_Microsiga\"+cNomarq1+".csv")) == -1
		Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
	Else
		cRegCSV1 := ";"+";"+";"+"Desoneracao Analitica De "+DtoC(MV_PAR01)+" ate "+DtoC(MV_PAR02)
		FWRITE(CARQCSV1,cRegCSV1+CHR(13)+CHR(10))
		cRegCSV1 := ""
		FWRITE(CARQCSV1,cRegCSV1+CHR(13)+CHR(10))
		cRegCSV1 := ""
		FWRITE(CARQCSV1,cRegCSV1+CHR(13)+CHR(10))
		cRegCSV1 := "TIPO;"+"DOC;"+"D2_SERIE;"+"D2_COD;"+"CONTABIL;"+"IPI;"+"CFOP;"+"CLIENTE;"+"D2_EMISSAO;"+"FT_POSIPI;"+"FT_ITEM;"+"LOJA;"+"B5_CODATIV;"+"D2_NFORI;"+"D2_SERIORI;"+"ITEMORI"
		FWRITE(CARQCSV1,cRegCSV1+CHR(13)+CHR(10))
		cRegCSV1 := ""
		FWRITE(CARQCSV1,cRegCSV1+CHR(13)+CHR(10))
	EndIf
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	set filter to
	Return
Endif

RptStatus({|| ImpR10()}, )

Return

/******************************/
Static FUNCTION ImpR10
/******************************/

Local oTable 

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := " SELECT DISTINCT 'S' AS TIPO, D2_DOC AS DOC, D2_SERIE AS SERIE, D2_COD, FT_VALCONT AS CONTABIL, FT_VALIPI AS IPI, "
_cQuery += "        D2_CF, D2_CLIENTE AS CLIENTE, D2_EMISSAO, FT_POSIPI, FT_ITEM, "
_cQuery += "        D2_LOJA AS LOJA, B5_INSPAT, B5_CODATIV, D2_NFORI, D2_SERIORI, D2_ITEMORI AS ITEMORI, D2_TIPO AS TIPONF  "
_cQuery += " FROM " + RetSqlName("SD2") + " D2  "
_cQuery += " INNER JOIN " + RetSqlName("SF4") + " F4 "
_cQuery += "       ON F4_FILIAL = '" + xFilial("SF4") + "' AND D2_TES = F4_CODIGO "
_cQuery += " INNER JOIN " + RetSqlName("SFT") + " FT "
_cQuery += "       ON FT_ENTRADA = D2_EMISSAO AND FT_PRODUTO = D2_COD AND FT_SERIE = D2_SERIE "
_cQuery += "       AND FT_NFISCAL = D2_DOC AND FT_CLIEFOR = D2_CLIENTE AND FT_LOJA = D2_LOJA "
_cQuery += "       AND D2_ITEM = FT_ITEM "
_cQuery += "       AND FT_FILIAL = '" + xFilial("SFT") + "' AND FT_CFOP = D2_CF "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SB5") + " B5 "
_cQuery += "       ON D2_COD = B5_COD AND B5_FILIAL = '" + xFilial("SB5") + "' AND B5.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2") + "'  "
_cQuery += "       AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "       AND D2_DOC <> '033887' "
_cQuery += "       AND D2.D_E_L_E_T_ = ' ' "
_cQuery += "       AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ' ' "
_cQuery += "       AND FT.D_E_L_E_T_ = ' ' AND FT_DTCANC = '        ' "
_cQuery += "       AND D2_CF NOT IN ('5201','5202','6201','6202','5410','5556','5412','6412','5413','6413','6556','5660','5662','5553','7501') "

//VICTOR DESSUNTE - 03/07/2017
//INICIO - TICKET: 2017070337000097
_cQuery += " UNION ALL "

_cQuery += " SELECT "
_cQuery += "	DISTINCT 'S' AS TIPO, D2_DOC AS DOC,D2_SERIE AS SERIE, D2_COD,D2_TOTAL AS CONTABIL, 0 AS IPI,  "
_cQuery += "       D2_CF, D2_CLIENTE AS CLIENTE, D2_EMISSAO, '' AS 'FT_POSIPI', '' AS 'FT_ITEM',  "
_cQuery += "       D2_LOJA AS LOJA, B5_INSPAT, B5_CODATIV, D2_NFORI, D2_SERIORI, D2_ITEMORI AS ITEMORI, D2_TIPO AS TIPONF   "
_cQuery += " FROM  "
_cQuery += 	RetSqlName("SD2") + " D2 INNER JOIN " + RetSqlName("SF4") + " F4  "
_cQuery += "	ON	F4_FILIAL		= '" + xFilial("SF4") + "'  "
_cQuery += "	AND D2_TES			= F4_CODIGO "
_cQuery += "	AND D2.D_E_L_E_T_	= '' "
_cQuery += "	INNER JOIN " + RetSqlName("SB5") + " B5 "
_cQuery += "	ON B5.D_E_L_E_T_ = '' "
_cQuery += "	AND B5_FILIAL = '" + xFilial("SB5") + "' "
_cQuery += "	AND B5_COD = D2_COD "
_cQuery += " WHERE  "
_cQuery += "		 D2_FILIAL 		= '" + xFilial("SD2") + "' "
_cQuery += "	AND D2_EMISSAO 	BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "	AND D2.D_E_L_E_T_ = ' ' "
_cQuery += "	AND F4_DUPLIC 		= 'S' "
_cQuery += "	AND F4.D_E_L_E_T_ = ' ' "
_cQuery += "	AND D2_SERIE 		= 'B' "
//FIM - TICKET: 2017070337000097

_cQuery += " UNION ALL "

_cQuery += " SELECT DISTINCT 'E' AS TIPO, D1_DOC AS DOC, D1_SERIE AS SERIE, D1_COD, FT_VALCONT AS CONTABIL, FT_VALIPI AS IPI, "
_cQuery += "        D1_CF, D1_FORNECE AS CLIENTE, D1_DTDIGIT, FT_POSIPI, FT_ITEM, "
_cQuery += "        D1_LOJA AS LOJA, B5_INSPAT, B5_CODATIV, D1_NFORI, D1_SERIORI, D1_ITEMORI AS ITEMORI, D1_TIPO AS TIPONF "
_cQuery += " FROM " + RetSqlName("SD1") + " D1  "
_cQuery += " INNER JOIN " + RetSqlName("SF4") + " F4 "
_cQuery += "       ON F4_FILIAL = '" + xFilial("SF4") + "' AND D1_TES = F4_CODIGO "
_cQuery += " INNER JOIN " + RetSqlName("SFT") + " FT "
_cQuery += "       ON FT_ENTRADA = D1_DTDIGIT AND FT_PRODUTO = D1_COD AND FT_SERIE = D1_SERIE "
_cQuery += "       AND FT_NFISCAL = D1_DOC AND FT_CLIEFOR = D1_FORNECE AND FT_LOJA = D1_LOJA "
_cQuery += "       AND D1_ITEM = FT_ITEM "
_cQuery += "       AND FT_FILIAL = '" + xFilial("SFT") + "' AND FT_CFOP = D1_CF "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SB5") + " B5 "
_cQuery += "       ON D1_COD = B5_COD AND B5_FILIAL =  '" + xFilial("SB5") + "' AND B5.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE D1_FILIAL = '" + xFilial("SD1") + "' "
_cQuery += "       AND D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "       AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ' ' "
_cQuery += "       AND FT.D_E_L_E_T_ = ' ' AND FT_DTCANC = '        '"
_cQuery += "       AND D1_TIPO IN ('D','P') AND D1.D_E_L_E_T_ = ' ' "
_cQuery += "       AND D1_SERIE NOT IN ('NCC') "

_cQuery += " ORDER BY B5_CODATIV "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","CONTABIL","N",12,2)
TcSetField("QR1","IPI"     ,"N",12,2)

_aCampos := { {"TM_VFAT"		,"N",12,02	},;		      // VALOR FATURADO -  ENQUADRAMENTO
{"TM_NFAT"		,"N",12,02	},;  					// VALOR FATURADO  - NÃO ENQUADRADO
{"TM_EFAT"		,"N",12,02	},;  					// VALOR EXCLUSAO  - NÃO ENQUADRADO
{"TM_CODATIV"	,"C",08,00	} }  					// CODIGO DE ATIVIDADE

oTable := FWTemporaryTable():New("TMP",_aCampos)
oTable:AddIndex( "IND1", {"TM_CODATIV"} )
oTable:Create()

cUM := "  "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If MV_PAR03 = 1    // Relatorio Sintetico
	
	cbtxt    := Space(10)
	cbcont   := 00
	li       := 80
	m_pag    := 01
	tamanho  := "M"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao dos cabecalhos Sintético                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	titulo := "FATURAMENTO NCM/COD.ATIV.  "+DTOC(MV_PAR01) + " ate " + DTOC(MV_PAR02)
	//*********123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O123456789N123456789C123456789D123456789V123456789
	cabec1 := "CODIGO        RECEITA BRUTA  VL.ENQUADRADO  EXCLUSOES 7101 VL.N/ENQUADRA   BASE DE CALC. VL.CONTRIBUICAO     "
	//         99999999      99,999,999,99  99,999,999.99  999,999,999,99 99,999,999,99  999,999,999,99 999,999,999.99
	cabec2 := ""
Else
	// Relatorio Analitico
	li       := 05
	m_pag    := 0
	tamanho  := "M"
EndIf

nFat 		:= 0       
nFilial 	:= ""


cChave := STRZERO(YEAR(MV_PAR01),4)+STRZERO(MONTH(MV_PAR01),2)

QR1->(DBGotop())

SetRegua(QR1->(LastRec()))

Do While !QR1->(Eof())
	IF !TMP->(dbSeek(QR1->B5_CODATIV))
		RecLock("TMP",.T.)
		TMP->TM_CODATIV := QR1->B5_CODATIV
	Else
		RecLock("TMP",.F.)
	EndIf
	
	If QR1->TIPO == 'E' .AND. QR1->TIPONF == 'P' .AND. Alltrim(QR1->D2_CF) == '1101'
		QR1->(DbSkip())
		loop
	EndIf
	
	If QR1->TIPO == 'E'
		
		IF QR1->B5_INSPAT == "1"
			dbSelectArea("SD2")
			dbSetOrder(3)
			nFilial := xFilial("SD2")
		//	IF SD2->(dbSeek( xFilial("SD2") + QR1->D2_NFORI + QR1->D2_SERIORI + QR1->CLIENTE + QR1->LOJA + QR1->D2_COD + QR1->ITEMORI))
			IF SD2->(dbSeek( FWxFilial("SD2") + PadR(QR1->D2_NFORI,TamSX3('D2_NFORI')[1]) + PadR(QR1->D2_SERIORI,TamSX3('D2_SERIORI')[1]) + PadR(QR1->CLIENTE,TamSX3('D2_CLIENTE')[1]) + PadR(QR1->LOJA,TamSX3('D2_LOJA')[1]) + PadR(QR1->D2_COD,TamSX3('D2_COD')[1]) + PadR(QR1->ITEMORI,TamSX3('D2_ITEM')[1])))
				IF SD2->D2_CF $ "5101 ,6101 ,7101 ,5109 ,6107 ,6116 ,6922 ,6109 ,5922 ,7101 ,7127 ,7102 ,6110 ,7501 "
					IF SD2->D2_CF$ "7101 ,7127 ,7102 ,7501 "
						TMP->TM_EFAT -= QR1->CONTABIL - QR1->IPI   // EXCLUSAO
					ENDIF
					TMP->TM_VFAT -= QR1->CONTABIL - QR1->IPI       // VALOR ENQUADRADO
				ELSE
					TMP->TM_NFAT -= QR1->CONTABIL - QR1->IPI       // VALOR NÃO ENQUADRADO
				ENDIF
			ELSE
				TMP->TM_NFAT -= QR1->CONTABIL - QR1->IPI                                     
			ENDIF
		ELSE
			TMP->TM_NFAT -= QR1->CONTABIL - QR1->IPI
		ENDIF
	Else
		IF QR1->B5_INSPAT == "1"
			IF QR1->D2_CF$ "5101 ,6101 ,7101 ,5109 ,6107 ,6922 ,6109 ,5922 ,7127 ,7102,5405 ,6403 ,6405 ,7501 "
				IF QR1->D2_CF$ "7101 ,7127 ,7102 ,7501 "
					TMP->TM_EFAT += QR1->CONTABIL - QR1->IPI    //  EXCLUSAO
				ENDIF
				TMP->TM_VFAT += QR1->CONTABIL - QR1->IPI        // VALOR ENQUADRADO
			ELSE
				TMP->TM_NFAT += QR1->CONTABIL - QR1->IPI        // VALOR NAO ENQUADRADO
			ENDIF
		ELSE
			TMP->TM_NFAT += QR1->CONTABIL - QR1->IPI            // VALOR NAO ENQUADRADO
		ENDIF
	EndIf
	TMP->(MsUnLock())
	
	If MV_PAR03 = 2
		cRegCSV1 := QR1->TIPO+";"+"_"+QR1->DOC+";"+QR1->SERIE+";"+"_"+QR1->D2_COD+";"+Transform(QR1->CONTABIL,"@E 99,999,999,999.99")+";"+Transform(QR1->IPI,"@E 99,9999.99")+";"+QR1->D2_CF+";"+"_"+QR1->CLIENTE+";"+QR1->D2_EMISSAO+";"+QR1->FT_POSIPI+";"+QR1->FT_ITEM+";"+QR1->LOJA+";"+QR1->B5_CODATIV+";"+"_"+QR1->D2_NFORI+";"+QR1->D2_SERIORI+";"+QR1->ITEMORI
		FWRITE(CARQCSV1,cRegCSV1+CHR(13)+CHR(10))
	EndIf
	
	dbSelectArea("QR1")
	QR1->(IncpROC())
	QR1->(DbSkip())
	
EndDo

QR1->(DbCloseArea())

If MV_PAR03 = 2
	FClose(cArqCSV)
EndIf

TMP->(DbGotop())
_nTFat	:= 0
_nEFat  := 0
_nNFat 	:= 0
_nVFat 	:= 0
_nVFat 	:= 0
nSeq    := 0

_nBaseCalc  := 0
_nVlReceit  := 0
_nVlrExport := 0

IF MV_PAR03 = 1
	TMP->(DbGotop())
	While !TMP->(EOF())
		
		IF Li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If !Empty(TMP->TM_CODATIV)
			cCodAtiv := TMP->TM_CODATIV
		Else
			cCodAtiv := Space(08)
		EndIf
		
		_BaseCalc := (TMP->TM_VFAT - TMP->TM_EFAT)
		
		_VlrContr := (TMP->TM_VFAT - TMP->TM_EFAT)* 0.025
				
		@ li, 001 PSAY TMP->TM_CODATIV
		@ li, 015 PSAY TMP->TM_VFAT + TMP->TM_NFAT PICTURE "@E 999,999,999.99"      // RECEITA BRUTA
		@ li, 030 PSAY TMP->TM_VFAT PICTURE "@E 99,999,999.99"					    // VALOR ENQUADRADO
		@ li, 045 PSAY TMP->TM_EFAT PICTURE "@E 99,999,999.99"					    // EXCLUSÕES
		@ li, 060 PSAY TMP->TM_NFAT PICTURE "@E 99,999,999.99"					   	// VALOR NÃO ENQUADRADO
		
		@ li, 075 PSAY _BaseCalc    PICTURE "@E 99,999,999.99"     	                // BASE DE CALCULO - RECEITA BRUTA
		@ li, 090 PSAY _VlrContr    PICTURE "@E 99,999,999.99"                      // VL. CONTRIBUIÇÃO - RECEITA BRUTA
		
		Li++
		
		_nTFat	+= (TMP->TM_VFAT + TMP->TM_NFAT )
		_nNFAT 	+= TMP->TM_NFAT
		_nEFAT 	+= TMP->TM_EFAT
		_nVFAT 	+= TMP->TM_VFAT
			
		nSeq += 1
		
		_nBaseCalc  := (TMP->TM_VFAT - TMP->TM_EFAT)
		
		_nVlReceit  := (TMP->TM_VFAT + TMP->TM_NFAT)
		_nVlrExcl   := 0
		_nVlrExport := TMP->TM_EFAT
		
		If TMP->TM_VFAT = 0  //VALOR ENQUADRADO
			_cAliq      := "  1.00"
			_cVlrExcl   := "             0.00"
			_nVlContr   := 0.00
			_nVlrExport := 0.00
			_nBaseCalc  := TMP->TM_NFAT
			_nVlReceita := TMP->TM_NFAT
			
			cRegCSV := "S033"+";"+"_"+nFilial+";"+cChave+";"+"_"+strzero(nSeq,3)+";"+"_"+cCodAtiv+"2"+";"+Transform(_nBaseCalc,"@E 99999999999999.99")+";"+;
			(_cAliq)+";"+Transform(_nVlContr,"@E 99999999999999.99")+";"+Transform(_nVlReceita,"@E 99999999999999.99")+";"+;
			(_cVlrExcl)+";"+Transform(_nVlrExport,"@E 99999999999999.99")
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		Else
			_cAliq      := "  1.00"
			
			_nVlContr   := (TMP->TM_VFAT - TMP->TM_EFAT)* 0.025
			
			_nVlrExport := TMP->TM_EFAT
			_nVlReceita := TMP->TM_VFAT
			_cVlrExcl   := "             0.00"
			
			cRegCSV := "S033"+";"+"_"+nFilial+";"+cChave+";"+"_"+strzero(nSeq,3)+";"+"_"+cCodAtiv+"1"+";"+Transform(_nBaseCalc,"@E 99999999999999.99")+";"+;
			(_cAliq)+";"+Transform(_nVlContr,"@E 99999999999999.99")+";"+Transform(_nVlReceita,"@E 99999999999999.99")+";"+;
			(_cVlrExcl)+";"+Transform(_nVlrExport,"@E 99999999999999.99")
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			
			nSeq += 1
			_cAliq      := "  0.00"
			_nVlContr   := 0.00
			_nVlrExport := 0.00
			_nBaseCalc  := TMP->TM_NFAT
			_nVlReceita := TMP->TM_NFAT
			_cVlrExcl   := "             0.00"
			
			cRegCSV := "S033"+";"+"_"+nFilial+";"+cChave+";"+"_"+strzero(nSeq,3)+";"+"_"+cCodAtiv+"2"+";"+Transform(_nBaseCalc,"@E 99999999999999.99")+";"+;
			(_cAliq)+";"+Transform(_nVlContr,"@E 99999999999999.99")+";"+Transform(_nVlReceita,"@E 99999999999999.99")+";"+;
			(_cVlrExcl)+";"+Transform(_nVlrExport,"@E 99999999999999.99")
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		EndIf
		
		TMP->(DBSKIP())
	ENDDO
	
	IF Li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ Li,000 Psay __PrtFatLine()
		Li++
		@ li, 001 PSAY "TOTAIS =====> "
		@ li, 014 PSAY _nTFat PICTURE "@E 999,999,999.99"
		@ li, 030 PSAY _nVFat PICTURE "@E 99,999,999.99"
		@ li, 045 PSAY _nEFat PICTURE "@E 99,999,999.99"
		@ li, 060 PSAY _nNFAT PICTURE "@E 99,999,999.99"
		
		@ li, 075 PSAY (_nVFat - _nEFat) PICTURE "@E 999,999,999.99"
		@ li, 090 PSAY (_nVFat - _nEFat)* 0.025 PICTURE "@E 999,999,999.99"
		Li++
		@ Li,000 Psay __PrtFatLine()
	ELSE
		@ Li,000 Psay __PrtFatLine()
		Li++
		@ li, 001 PSAY "TOTAIS =====> "
		@ li, 014 PSAY _nTFat PICTURE "@E 999,999,999.99"
		@ li, 030 PSAY _nVFat PICTURE "@E 99,999,999.99"
		@ li, 045 PSAY _nEFat PICTURE "@E 99,999,999.99"
		@ li, 060 PSAY _nNFAT PICTURE "@E 99,999,999.99"
		@ li, 075 PSAY (_nVFat - _nEFat) PICTURE "@E 999,999,999.99"
		@ li, 090 PSAY (_nVFat - _nEFat)* 0.025 PICTURE "@E 999,999,999.99"
		Li++
		@ Li,000 Psay __PrtFatLine()
	ENDIF
		
ElseIf MV_PAR03 = 2  // Relatorio Analitico
	
	TMP->(DbGotop())
	While !TMP->(EOF())
		
		If !Empty(TMP->TM_CODATIV)
			cCodAtiv := TMP->TM_CODATIV
		Else
			cCodAtiv := Space(08)
		EndIf
		
		nSeq += 1
		_nBaseCalc  := (TMP->TM_VFAT - TMP->TM_EFAT)
		
		_nVlReceit  := (TMP->TM_VFAT + TMP->TM_NFAT)
		_nVlrExcl   := 0
		_nVlrExport := TMP->TM_EFAT
		
		If TMP->TM_VFAT = 0  //VALOR ENQUADRADO
			_cAliq      := "  1.00"
			_cVlrExcl   := "             0.00"
			_nVlContr   := 0.00
			_nVlrExport := 0.00
			_nBaseCalc  := TMP->TM_NFAT
			_nVlReceita := TMP->TM_NFAT
			
			cRegCSV := "S033"+";"+"_"+nFilial+";"+cChave+";"+"_"+strzero(nSeq,3)+";"+"_"+cCodAtiv+"2"+";"+Transform(_nBaseCalc,"@E 99999999999999.99")+";"+;
			(_cAliq)+";"+Transform(_nVlContr,"@E 99999999999999.99")+";"+Transform(_nVlReceita,"@E 99999999999999.99")+";"+;
			(_cVlrExcl)+";"+Transform(_nVlrExport,"@E 99999999999999.99")
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		Else
			_cAliq      := "  1.00"
			
			_nVlContr   := (TMP->TM_VFAT - TMP->TM_EFAT)* 0.025
			
			_nVlrExport := TMP->TM_EFAT
			_nVlReceita := TMP->TM_VFAT
			_cVlrExcl   := "             0.00"
			
			cRegCSV := "S033"+";"+"_"+nFilial+";"+cChave+";"+"_"+strzero(nSeq,3)+";"+"_"+cCodAtiv+"1"+";"+Transform(_nBaseCalc,"@E 99999999999999.99")+";"+;
			(_cAliq)+";"+Transform(_nVlContr,"@E 99999999999999.99")+";"+Transform(_nVlReceita,"@E 99999999999999.99")+";"+;
			(_cVlrExcl)+";"+Transform(_nVlrExport,"@E 99999999999999.99")
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			
			nSeq += 1
			_cAliq      := "  0.00"
			_nVlContr   := 0.00
			_nVlrExport := 0.00
			_nBaseCalc  := TMP->TM_NFAT
			_nVlReceita := TMP->TM_NFAT
			_cVlrExcl   := "             0.00"
			
			cRegCSV := "S033"+";"+"_"+nFilial+";"+cChave+";"+"_"+strzero(nSeq,3)+";"+"_"+cCodAtiv+"2"+";"+Transform(_nBaseCalc,"@E 99999999999999.99")+";"+;
			(_cAliq)+";"+Transform(_nVlContr,"@E 99999999999999.99")+";"+Transform(_nVlReceita,"@E 99999999999999.99")+";"+;
			(_cVlrExcl)+";"+Transform(_nVlrExport,"@E 99999999999999.99")
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		EndIf
		
		TMP->(DBSKIP())
	ENDDO

	FClose(cArqCSV)

	@ Li  ,000 Psay "Planilha gerada em => C:\RELATO_MICROSIGA\"+cNomarq+".CSV"
	@ Li+2,000 Psay "Planilha gerada em => C:\RELATO_MICROSIGA\"+cNomarq1+".CSV"

EndIf	
If MV_PAR04 = 1 

	cChave1 := STRZERO(DAY(MV_PAR01),2)+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)
	cChave2 := STRZERO(DAY(MV_PAR02),2)+STRZERO(MONTH(MV_PAR02),2)+STRZERO(YEAR(MV_PAR02),4)
	If (cArqTxt := FCreate("C:\Relato_Microsiga\"+cNomarq+".txt")) == -1
		Alert("Arquivo para o TXT não pode ser criado - Avise o Depto. de Informática")
	EndIf
		
	cRegTXT :="|P001|0|"
	FWrite(cArqTxt,cRegTXT+chr(13)+chr(10))
	If SubStr(cNumEmp,1,2) = "01" 
		cRegTXT :="|P010|58071614000144|" 
	ElseIf SubStr(cNumEmp,1,2) = "10"
		cRegTXT :="|P010|43222439000171|"  
	ElseIf SubStr(cNumEmp,1,2) = "15" 
		cRegTXT :="|P010|51317402000155|"
	EndIf
	FWrite(cArqTxt,cRegTXT+chr(13)+chr(10))
		
	
	
	TMP->(DbGotop())
	
	While !TMP->(EOF())
	
	    If TMP->TM_VFAT <= 0
	    	TMP->(DBSKIP())
	    	LOOP	
	    EndIf
	    
  		_BaseCalc := (TMP->TM_VFAT - TMP->TM_EFAT)
	
		_VlrContr := (TMP->TM_VFAT - TMP->TM_EFAT)* 0.025 
		
		cRegTXT := "|P100|"
		cRegTXT += cChave1         				  							 +"|" 	// Data Inicial
		cRegTXT += cChave2         											 +"|" 	// Data Final
		cRegTXT += AllTrim(Transform(_nTFat,      "@E 99999999999999.99|"))  // Total Bruto	
		cRegTXT += AllTrim(TMP->TM_CODATIV)		 							 +"|" 	// Codigo Atividade
		cRegTXT += AllTrim(Transform(TMP->TM_VFAT,"@E 99999999999999.99|"))	// VALOR ENQUADRADO
		cRegTXT += AllTrim(Transform(TMP->TM_EFAT,"@E 99999999999999.99|"))	// EXCLUSÕES
		cRegTXT += AllTrim(Transform(_BaseCalc,   "@E 99999999999999.99|"))  // BASE DE CALCULO - RECEITA BRUTA
		
		//VICTOR DESSUNTE - 26/10/17
		//INICIO - TICKET: 2017102637000136
		//cRegTXT += "1|"					  					  								// Alicota 
		cRegTXT += "2,5|"					  					  								// Alicota 
		//FIM - TICKET: 2017102637000136

		cRegTXT += AllTrim(Transform(_VlrContr,   "@E 99999999999999.99|"))  // VL. CONTRIBUIÇÃO - RECEITA BRUTA
		cRegTXT += "|"
		cRegTXT += "|"
		FWrite(cArqTxt,cRegTXT+chr(13)+chr(10))
		TMP->(DBSKIP())
	EndDo 
	FCLOSE(cArqTxt)
EndIf  

TMP->(DbCloseArea())




Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif
	
MS_FLUSH()
	
Return
