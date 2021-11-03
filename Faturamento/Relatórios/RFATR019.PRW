#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RFATR019	³ Autor ³Aparecida de F.Stevanato³Data ³ 24/04/07³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos com pendência				  	      	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
Reescrito em 11/03/13 - Lizandra
*/

User Function RFATR019()

PRIVATE titulo    := "Relacao de Pedidos com pendência"
PRIVATE cString   := "SC6"
PRIVATE tamanho   := "M"
PRIVATE wnrel     := "RFATR019"
PRIVATE aOrd      := ""
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog  := "RFATR019"
Private cPerg     := "XRFATR019 "
PRIVATE nLastKey  := 0
PRIVATE CbTxt     := ""
PRIVATE cabec1    := "PEDIDO  CLIENTE                   MULTA IT  PRODUTO         DESCRICAO                            PRAZO      QTDE.      SALDO"
PRIVATE cabec2    := ""
PRIVATE Li        := 80
PRIVATE limite    := 132
PRIVATE CbCont    := 0
PRIVATE cImp      := .F.
Private cPed      := ""
Private cPend     := ""
Private cCli      := ""
Private cLoja     := ""
Private cPos      := ""
Private X         := 0

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,aOrd,,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Descricao ³ Chamada do Relatorio 									  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRel(lEnd,WnRel,cString)

Local X

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := " SELECT C5_NUM, C5_MSPOSIC, C5_CLIENTE, C5_LOJACLI, "
_cQuery += "        C6_NUM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_ITEM, C6_DESCRI, C6_ENTREG, "
_cQuery += "        A1_NREDUZ, B1_ETIQUET, C5_MSMULTA, "
_cQuery += "        (CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),C5_MSPEND))) AS PENDENCIA "
_cQuery += " FROM " + RetSqlName("SC5") +  " C5 "
_cQuery += " INNER JOIN " + RetSqlName("SC6") + " C6 "
_cQuery += "       ON C5_NUM = C6_NUM "
_cQuery += "       AND C6_FILIAL = '" + xFilial("SC6") + "' AND C6.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
_cQuery += "       ON B1_COD = C6_PRODUTO "
_cQuery += "       AND B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 "
_cQuery += "       ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA "
_cQuery += "       AND A1_FILIAL = '" + xFilial("SA1") + "' AND A1.D_E_L_E_T_ = ' ' "
_cQuery += " WHERE C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
_cQuery += "       AND C5_TIPO = 'N' AND C6_BLQ <> 'R' "
_cQuery += "       AND (CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),C5_MSPEND))) IS NOT NULL "
_cQuery += "       AND SUBSTRING((CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),C5_MSPEND))),2,10) <> '          ' "
_cQuery += "       AND C5_FILIAL = '" + xFilial("SC5") + "' AND C5.D_E_L_E_T_ = ' ' "
IF MV_PAR05 == 1
	_cQuery += "       AND C6_QTDVEN > C6_QTDENT  "
ENDIF
IF MV_PAR03 == 2
	_cQuery += "       AND C5_MSMULTA = 'S' "
ENDIF      

IF MV_PAR04 == 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"  

	_cQuery += "       AND C5_MSCATEG IN ('2','3') "  
	
ELSEIF MV_PAR04 == 3 .AND. SubStr(cNumEmp,1,2) $ "01_10" 

	_cQuery += "       AND (C5_MSCATEG = '1' OR B1_ETIQUET = 'S') "   
	
ELSEIF MV_PAR04 == 3 .AND. SubStr(cNumEmp,1,2) $ "15_40_45"
	_cQuery += "       AND  B1_ETIQUET = 'S' " 	
ENDIF
_cQuery += " ORDER BY C5_NUM, C6_ITEM "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","C6_ENTREG" ,"D",08,00)
TcSetField("QR1","C6_QTDVEN" ,"N",12,02)
TcSetField("QR1","C6_QTDENT" ,"N",12,02)

QR1->(DbGoTop())

Do WHILE !QR1->(EOF())

	cPed := QR1->C6_NUM
	
	If lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	If Li + 3 >= 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf
	Li++
	@Li, 00 Psay cPed
	@Li, 8 Psay QR1->C5_CLIENTE+"/"+QR1->C5_LOJACLI+"-"+QR1->A1_NREDUZ
	
	While !QR1->(Eof()) .AND. QR1->C6_NUM == cPed
		If Li >= 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			Li++
			@Li, 00 Psay cPed
			@Li, 8 Psay QR1->C5_CLIENTE + "/" + QR1->C5_LOJACLI + "-" + SUBSTR(QR1->A1_NREDUZ,1,15)
		EndIf
		If QR1->C5_MSMULTA == "S"
			@Li, 35 Psay "Sim"
		Else
			@Li, 35 Psay "Nao"
		EndIf
		@Li, 41 Psay QR1->C6_ITEM
		@Li, 44 Psay QR1->C6_PRODUTO
		@Li, 60 Psay SubStr(QR1->C6_DESCRI,1,35)
		@Li, 97 Psay QR1->C6_ENTREG
		@Li,106 Psay QR1->C6_QTDVEN   PICTURE "@E 999.999"
		@Li,117 Psay (QR1->C6_QTDVEN - QR1->C6_QTDENT)   PICTURE "@E 999.999"
		Li++
		cPend := ALLTRIM(QR1->PENDENCIA)
		QR1->(dbSkip())
	ENDDO
	If Li >= 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		Li++
		@Li, 00 Psay cPed
		@Li, 8 Psay QR1->C5_CLIENTE + "/" + QR1->C5_LOJACLI + "-" + SUBSTR(QR1->A1_NREDUZ,1,18)
	EndIf
	@Li,000 Psay "PENDENCIA: "
	For X := 1 TO MLCOUNT(cPend,80)
		li++
		If Li >= 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		EndIf
		@li,012 PSay MEMOLINE(cPend,80,X)
	Next
	If !Empty(QR1->C5_MSPOSIC)
		li+=2
		@li,002 Psay "POSIÇÃO:  " + QR1->C5_MSPOSIC
	EndIf
	li++
	@li,000 Psay __PrtFatLine()
	li++
EndDo               


QR1->(dbCloseArea())

If Li != 80
	Roda(cbcont,cbtxt)
Endif

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return