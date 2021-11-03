#Include "Protheus.ch"
#Include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RFATR062  ³ Autor ³   Lizandra            ³ Data ³ 22/04/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carteira de Pedidos                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATR062()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo:="Produto por Familia - SC6"
cDesc1:="Esse programa tem por finalidade imprimir o relatorio de"
cDesc2:="Produto por familia (carteira de pedidos)."
cDesc3:=""
cString:="SB1"
wnrel:="RFATR062"
tamanho:="G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aReturn:={ "Zebrado", 1,"Faturamento", 1, 2, 1, "",1 }

nLastkey:=0
cPerg:="XRFATR062"

li:=80
nTipo:=15
m_pag:=0
cabec1:=""
cabec2:=""
nomeprog:="RFATR062"

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
SetDefault(aReturn,cString)
If nLastKey == 27
	set filter to
	Return
Endif

RptStatus({|| ImpFat05()}, )// Substituido pelo assistente de conversao do AP5 IDE em 10/05/02 ==> RptStatus({|| Execute(GLImp)}, )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpFat05 ³ Autor ³ Lizandra              ³ Data ³ 10.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ImpFat05                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUNCTION ImpFat05()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//titulo := "REL.DE PEDIDOS DE PRODUTO x FAMILIA "                                                     
///        123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O123456789N123456789C123456789D
//         99999999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9.999.999   9.999.999,99  9.999.999 999999 99/99/99 99/99/99
cabec1 := "CODIGO         DENOMINACAO                   QUANTIDADE      VLR.TOTAL    ESTOQUE PEDIDO  EMISSAO  ENTREGA   PREV.ENT. UPRC"
cabec2 := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cQuery := " SELECT C6_PRODUTO, B1_DESC, (C6_QTDVEN-C6_QTDENT) AS SALDO, ((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) AS VALOR, " 
_cQuery += "        B2_QATU AS ESTOQUE, C5_EMISSAO, C6_ENTREG, C6_NUM, B1_UPRC, A1_NREDUZ, C5_MSDTPEN, C5_MSDTENT "
_cQuery += " FROM " + RetSqlName("SC6") + " C6 "
_cQuery += " INNER JOIN " + RetSqlName("SC5") + " C5 "
_cQuery += "       ON C6_NUM = C5_NUM "
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
_cQuery += "       ON C6_PRODUTO = B1_COD "
_cQuery += " INNER JOIN " + RetSqlName("SB2") + " B2 "
_cQuery += "       ON C6_PRODUTO = B2_COD AND B2_LOCAL = B1_LOCPAD "
_cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 "
_cQuery += "       ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA "
_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6.D_E_L_E_T_ = ' ' AND C6_LOCAL = B1_LOCPAD "
_cQuery += "       AND C6_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
_cQuery += "       AND C5_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
_cQuery += "       AND C6_ENTREG  BETWEEN '" + DTOS(MV_PAR12) + "' AND '" + DTOS(MV_PAR13) + "' "
_cQuery += "       AND C6_CLI+C6_LOJA BETWEEN '" + MV_PAR07+MV_PAR08 + "' AND '" + MV_PAR09+MV_PAR10 + "' "
_cQuery += "       AND C6_BLQ <> 'R' "                                 
_cQuery += "       AND C5_MSCATEG = '3' "
_cQuery += "       AND C6_PRODUTO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "    
_cQuery += "       AND A1_FILIAL = '" + xFilial("SA1") + "' AND A1.D_E_L_E_T_ = ' ' "
_cQuery += "       AND B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
_cQuery += "       AND B2_FILIAL = '" + xFilial("SB2") + "' AND B2.D_E_L_E_T_ = ' ' "
_cQuery += "       AND C5_FILIAL = '" + xFilial("SC5") + "' AND C5.D_E_L_E_T_ = ' ' "
If MV_PAR11 == 1
	_cQuery += "  AND (C6_QTDVEN - C6_QTDENT) > 0 "
Endif

_cQuery += " ORDER BY C6_NUM "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","SALDO"     ,"N",12,02)
TcSetField("QR1","VALOR"     ,"N",12,02)
TcSetField("QR1","B1_UPRC"   ,"N",12,02)
TcSetField("QR1","ESTOQUE"   ,"N",12,02)
TcSetField("QR1","C5_EMISSAO","D",08,00)
TcSetField("QR1","C5_MSDTENT","D",08,00)
TcSetField("QR1","C5_MSDTPEN","D",08,00)
TcSetField("QR1","C6_ENTREG" ,"D",08,00)

_nTotGer := 0
_nTOTFGC	:= 0  

dDT 	:= 	Date()
cArq   :="C:\Relato_Microsiga\PV_PECA_CARTEIRA_"+DTOS(MV_PAR03)+"_"+DTOS(MV_PAR04)+".CSV"  

IF (cArqCSV := FCreate(cArq)) == -1 

	Alert("Arquivo para o Excel não pode ser criado - Verifique se o mesmo não está aberto - Avise o Depto. de Informática")
	Return   
	
ELSE
	cRegCSV := "PV´s de peças em carteira - emitida em    " + DTOC(dDT) 
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := " Emissao dos Pedidos de:    "+DTOC(MV_PAR03)+"    até:    "+DTOC(MV_PAR04)
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))  
   cRegCSV := " Entrega dos Pedidos de:    "+DTOC(MV_PAR12)+"    até:    "+DTOC(MV_PAR13) 
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Pula Linha 
ENDIF

cRegCSV := "Peças"
FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))                  
cRegCSV := ""
FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Pula Linha
cRegCSV := "Produto;Descrição;Saldo;Valor;Estoque;Pedido;Emissao;Entrega;Prev. entrega;Último preço;Cliente"
FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))



Do While !QR1->(EOF())
	_cNum := QR1->C6_NUM
	_nTOTFQ:=0
	_nTOTFV:=0  
	_nTOTFC	:= 0  
	
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li += 2
	EndIf
	DO WHILE !QR1->(EOF()).AND.QR1->C6_NUM == _cNum
		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li += 2
		ENDIF
		@li,  0 PSAY QR1->C6_PRODUTO
		@li, 16 PSAY SUBSTR(QR1->B1_DESC,1,30)
		@li, 47 PSAY TRANSFORM(QR1->SALDO  ,"@E 9,999,999")
		@li, 59 PSAY TRANSFORM(QR1->VALOR  ,"@E 9,999,999.99")
		@li, 73 PSAY TRANSFORM(QR1->ESTOQUE,"@E 9,999,999")
		@li, 83 PSAY QR1->C6_NUM 
		@li, 90 PSAY QR1->C5_EMISSAO
		@li, 99 PSAY QR1->C5_MSDTENT
		@li,110 PSAY QR1->C5_MSDTENT
		@li,120 PSAY TRANSFORM(QR1->B1_UPRC ,"@E 9,999,999.99")  
		@li,135 PSAY QR1->A1_NREDUZ
		li ++ 
		IF li > 55
			li := 80
		ENDIF
		_nTOTFV 		+= QR1->VALOR
		_nTotGer   	+= QR1->VALOR
		_nTOTFC   	+= QR1->B1_UPRC
		_nTOTFGC   	+= QR1->B1_UPRC    
		
		cRegCSV := "_"+QR1->C6_PRODUTO	  		 			  		+ ";"
		cRegCSV += QR1->B1_DESC   	   					     		+ ";"
		cRegCSV += TRANSFORM(QR1->SALDO  ,"@E 9,999,999") 		+ ";"
		cRegCSV += TRANSFORM(QR1->VALOR  ,"@E 9,999,999.99")  + ";"
		cRegCSV += TRANSFORM(QR1->ESTOQUE,"@E 9,999,999")	   + ";"
		cRegCSV += QR1->C6_NUM										   + ";"
		cRegCSV += DTOC(QR1->C5_EMISSAO)       	 	   + ";"
		cRegCSV += DTOC(QR1->C5_MSDTENT)		  	  	      + ";"
		cRegCSV += DTOC(QR1->C5_MSDTPEN)		  	  	      + ";"
		cRegCSV += TRANSFORM(QR1->B1_UPRC ,"@E 9,999,999.99") + ";"
		cRegCSV += QR1->A1_NREDUZ			 	  		  			   + ";"

	
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Grava Linha	   

		QR1->(dbSkip())
		
	ENDDO
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li += 2
		@li,  0 PSAY "TOTAL PEDIDO: "
		@li, 59 PSAY _nTOTFV PICTURE "@E 9,999,999.99"
		@li,110 PSAY _nTOTFC PICTURE "@E 9,999,999.99"
		LI:=LI+1
		@ li,00 PSAY REPLICATE("-",100)
		LI:=LI+1
	Else	
		@li,  0 PSAY "TOTAL PEDIDO: "
		@li, 59 PSAY TRANSFORM(_nTOTFV,"@E 9,999,999.99")
		@li,110 PSAY TRANSFORM(_nTOTFC,"@E 9,999,999.99")
		LI:=LI+1
		@ li,00 PSAY REPLICATE("-",110)
		LI:=LI+1
	ENDIF                  
EndDO

IF li != 80
	li:=li+1
	@li,  0 PSAY "T O T A L  G E R A L : "
	@li, 59 PSAY TRANSFORM(_nTotGer,"@E 9,999,999.99")
	@li,110 PSAY TRANSFORM(_nTOTFGC,"@E 9,999,999.99")
	roda(cbcont,cbtxt)
EndIF

QR1->(dbCloseArea())        
FClose(cArqCSV)

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

If ApOleClient('MsExcel')
   oExcelApp:= MsExcel():New()
   oExcelApp:WorkBooks:Open(cArq)
   oExcelApp:SetVisible(.T.)
  
EndIf

Return