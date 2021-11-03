#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR066  ºAutor  ³Lizandra Marques    º Data ³  03/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ranking de produto por valor                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR066()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo  := "Produtos Faturados por valor."
cDesc1  := "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2  := "Produtos Faturados por valor."
cDesc3  := ""
cString := "SD2"
wnrel   := "RFATR066"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aReturn := { "Zebrado", 1,"Faturamento", 1, 2, 1, "",1 }

nLastkey := 0
cPerg    := "XRFATR066"
nLin		:= 9
nTipo    := 15
m_pag    := 0
cabec1   := ""
cabec2   := ""
nomeprog := "RFATR066"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

If SubStr(cNumEmp,1,2) = "01"
	cNomarq := "C:\Relato_Microsiga\ranking_valor_produto_mas"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)+".csv"
ElseIf SubStr(cNumEmp,1,2) = "10"
	cNomarq := "C:\Relato_Microsiga\ranking_valor_produto_fab"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)+".csv"
ElseIf SubStr(cNumEmp,1,2) = "15"
	cNomarq := "C:\Relato_Microsiga\ranking_valor_produto_hel"+STRZERO(MONTH(MV_PAR01),2)+STRZERO(YEAR(MV_PAR01),4)+".csv"
EndIf
If (cArqCSV := FCreate(cNomarq)) == -1
	Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
EndIf

cRegCSV1 := "CODIGO;"+"DESCRIÇÃO;"+"TOTAL VENDIDO QTDE.;"+"TOTAL VENDIDO VALOR;"+"PREÇO DE TABELA;"+"ULTIMA COMPRA;"+"VL. ULTIMA COMPRA;"
FWRITE(CARQCSV,cRegCSV1+CHR(13)+CHR(10))
cRegCSV1 := ""
FWRITE(CARQCSV,cRegCSV1+CHR(13)+CHR(10))

SetDefault(aReturn,cString)

If nLastKey == 27
	set filter to
	Return
Endif

RptStatus({|lEnd| ImpR066(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return

/******************************/
Static FUNCTION ImpR066(lEnd,wnrel,cString)
/******************************/

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := " SELECT D2_COD, B1_DESC, SUM(D2_QUANT) AS QUANT, SUM(D2_TOTAL) AS TOTAL, DA1_PRCVEN, B1_UCOM, B1_UPRC "
_cQuery += " FROM " + RetSqlname("SD2") + " D2 "
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
_cQuery += "       ON B1_COD = D2_COD "
_cQuery += " LEFT JOIN " + RetSqlName("DA1") + " DA1 "
_cQuery += "       ON DA1_CODPRO = D2_COD AND DA1_CODTAB = '" + MV_PAR03 + "' "
_cQuery += " INNER JOIN " + RetSqlName("SF4") + " F4 "
_cQuery += "       ON F4_CODIGO = D2_TES "
_cQuery += " WHERE D2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND D2.D_E_L_E_T_ = ' ' "
_cQuery += "       AND B1.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' ' AND DA1.D_E_L_E_T_ = ' ' "
_cQuery += "       AND F4_DUPLIC = 'S' "
_cQuery += " GROUP BY D2_COD, B1_DESC, DA1_PRCVEN, B1_UCOM, B1_UPRC "
_cQuery += " ORDER BY TOTAL DESC "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","TOTAL"     ,"N",12,2)
TcSetField("QR1","QUANT"     ,"N",12,2)
TcSetField("QR1","DA1_PRCVEN","N",12,2)
TcSetField("QR1","B1_UCOM"   ,"D",08,0)
TcSetField("QR1","B1_UPRC"   ,"N",12,2)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


QR1->(DBGotop())

SetRegua(QR1->(LastRec()))

Do While !QR1->(Eof())
	cRegCSV1 := "_" + QR1->D2_COD + ";" + QR1->B1_DESC +";"+Transform(QR1->QUANT,"@E 99,999,999,999.99")+";"+Transform(QR1->TOTAL,"@E 99,999,999,999.99")+";"+Transform(QR1->DA1_PRCVEN,"@E 99,9999.99")+";"+DTOS(QR1->B1_UCOM)+";"+Transform(QR1->B1_UPRC,"@E 99,999,999.99")
	FWRITE(CARQCSV,cRegCSV1+CHR(13)+CHR(10))

	QR1->(DbSkip())
EndDo

QR1->(DbCloseArea())

FClose(cArqCSV)

If ApOleClient('MsExcel')
   oExcelApp:= MsExcel():New()
   oExcelApp:WorkBooks:Open(cNomarq)
   oExcelApp:SetVisible(.T.)
  
EndIf

Return