#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATR066  �Autor  �Lizandra Marques    � Data �  03/12/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ranking de produto por valor                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATR066()

//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio            �
//����������������������������������������������������������������

titulo  := "Produtos Faturados por valor."
cDesc1  := "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2  := "Produtos Faturados por valor."
cDesc3  := ""
cString := "SD2"
wnrel   := "RFATR066"

//��������������������������������������������������������������Ŀ
//� Variaveis padrao de todos os relatorios                      �
//����������������������������������������������������������������

aReturn := { "Zebrado", 1,"Faturamento", 1, 2, 1, "",1 }

nLastkey := 0
cPerg    := "XRFATR066"
nLin		:= 9
nTipo    := 15
m_pag    := 0
cabec1   := ""
cabec2   := ""
nomeprog := "RFATR066"


//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������

Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

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
	Alert("Arquivo para o Excel n�o pode ser criado - Avise o Depto. de Inform�tica")
EndIf

cRegCSV1 := "CODIGO;"+"DESCRI��O;"+"TOTAL VENDIDO QTDE.;"+"TOTAL VENDIDO VALOR;"+"PRE�O DE TABELA;"+"ULTIMA COMPRA;"+"VL. ULTIMA COMPRA;"
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



//������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape  �
//��������������������������������������������������������������


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