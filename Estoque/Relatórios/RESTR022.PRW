#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³restr022  ³ Autor ³   Lizandra            ³ Data ³ 11/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ REQUISIÇOES/DEVOLUÇÕES EM ABERTO                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MASIPACK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RESTR022()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo	  := "Requisições/Devoluções ao Almoxarifado"
cDesc1	  := "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2	  := "acordo com os parametrosdo usuário"
cDesc3	  := ""
wnrel	  := "RESTR022"
tamanho	  := "P"
aReturn	  := { "Zebrado", 1,"Gerencial", 1, 2, 1, "",1 }
nLastkey  := 0
cPerg	  := "XRESTR022 "
nTipo	  := 18
cabec1	  := ""
cabec2	  := ""
nomeprog  := "RESTR022"
cstring	  := ""

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
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

RptStatus({|| ImpEST22()}, )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpEST22 ³ Autor ³ LIZANDRA              ³ Data ³ 11/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AP - Masipack                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static FUNCTION ImpEST22()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aDesenhos := {}
cDesenho  := ""
cbtxt	:= Space(10)
cbcont	:= 00
li		:= 80
m_pag	:= 1
_cUser	:= CUSERNAME
cabec1 := "Numero  99 Produto        Descricao                        Emissao         Saldo"
//         D999999 99 99999999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 9,999,999.99 
///////////123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O
//         xxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxx
cabec2 := "Usuario                   OBS: "

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF

IF MV_PAR03 == 2
	
	titulo := "Requisicoes em aberto - "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
	
	_cQuery := " SELECT CP_PRODUTO AS PROD, B1_DESC AS DESCRI, CP_NUM AS NUM, CP_ITEM AS ITEM, CP_SOLICIT AS SOLICIT, "
	_cQuery += "        CP_EMISSAO AS EMISSAO, (CP_QUANT - CP_QUJE) AS SALDO, CP_OBS AS OBS "
	_cQuery += " FROM " + RetSqlName("SCP") + " CP "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
	_cQuery += "       ON B1_COD = CP_PRODUTO "
	_cQuery += " WHERE (CP_QUANT - CP_QUJE > 0) AND CP_STATUS <> 'E' "
	_cQuery += "       AND CP_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND CP_FILIAL = '01' AND CP.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND B1_FILIAL = '01' AND B1.D_E_L_E_T_ = ' ' "    
  //	_cQuery += "       AND B1_LOCAL NOT IN ('S')  "    	
	_cQuery += " ORDER BY CP_EMISSAO, CP_PRODUTO "
	
ELSE
	
	titulo := "Devolucoes em aberto - "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
	
	_cQuery := " SELECT ZP_PRODUTO AS PROD, B1_DESC AS DESCRI, ZP_NUM AS NUM, ZP_ITEM AS ITEM, ZP_SOLICIT AS SOLICIT, "
	_cQuery += "        ZP_EMISSAO AS EMISSAO, (ZP_QUANT - ZP_QUJE) AS SALDO, ZP_OBS AS OBS "
	_cQuery += " FROM " + RetSqlName("SZP") + " ZP "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
	_cQuery += "       ON B1_COD = ZP_PRODUTO "
	_cQuery += " WHERE (ZP_QUANT - ZP_QUJE > 0) AND ZP_STATUS <> 'E' "
	_cQuery += "       AND ZP_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND ZP_FILIAL = '01' AND ZP.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND B1_FILIAL = '01' AND B1.D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY ZP_EMISSAO, ZP_PRODUTO "
ENDIF

TcQuery _cQuery New Alias "QR1"

TcSetField ("QR1","SALDO","N",12,2)
TcSetField ("QR1","EMISSAO","D",08,0)

Do While !QR1->(Eof())
	

	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	@li,00 PSAY IIF(MV_PAR03==1,"D","R") + QR1->NUM
	@li,09 PSAY QR1->ITEM
	@li,12 PSAY QR1->PROD
	@li,27 PSAY SUBSTR(QR1->DESCRI,1,32)
	@li,60 PSAY QR1->EMISSAO
	@li,69 PSAY TRANSFORM(SALDO,"@E 9,999,999.99")
	li++
	@li,00 PSAY QR1->SOLICIT
	@li,27 PSAY QR1->OBS
	li++
	@ Li,000 Psay __PrtFatLine()
	li++
	QR1->(dbSkip())
ENDDO
Set Device To Screen

QR1->(DbCloseArea())

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

RETURN
