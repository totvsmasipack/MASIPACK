#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RPCPR025  ³ Autor ³   Lizandra            ³ Data ³ 04/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ OP´s NAO IMPRESSAS                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MASIPACK/FABRIMA                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RPCPR025()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo	:= "OP´s não impressas"
cDesc1	:= "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2	:= "acordo com os parametrosdo usuário"
cDesc3	:= ""
wnrel	   := "RPCPR025"
tamanho	:= "G"
aReturn	:= { "Zebrado", 1,"Gerencial", 1, 2, 1, "",1 }
nLastkey := 0
cPerg	   := "XRPCPR025 "
nTipo	   := 18
cabec1	:= ""
cabec2	:= ""
nomeprog := "RPCPR025"
cstring	:= ""

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	set filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	set filter to
	Return
Endif

RptStatus({|| ImpPCP25()}, )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpPCP25 ³ Autor ³ LIZANDRA              ³ Data ³ 04/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AP - Masipack/Fabrima                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static FUNCTION ImpPCP25()

Local J := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aDesenhos := {}
cDesenho  := ""
cbtxt	    := Space(10)
cbcont 	 := 00
li		    := 80
m_pag	    := 1
cabec1    := "Usuario    Num. OP     Produto         Descrição                          Quantidade UM Cliente         Pedido  Emissão
//            XXXXXXXXXX 99999999999 999999999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999,999.99 xx XXXXXXXXXXXXXXX 999999 99/99/99
//////////////123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O123456789n123456789c123456789d123456789
cabec2 := ""

_cQuery := " SELECT C2_MSUSER, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, B1_DESC, "
_cQuery += "        C2_QUANT, C2_UM, C2_MSREDUZ, C2_MSPED, C2_EMISSAO "
_cQuery += " FROM " + RetSqlName("SC2") + " C2 "
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1  "  
_cQuery += "       ON B1_COD = C2_PRODUTO "
_cQuery += " WHERE C2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "       AND C2_MSIMPR = '        ' AND C2_DATRF = '        ' "
_cQuery += "       AND SUBSTRING(C2_MSUSER,1,5) <> '     ' AND C2_UM <> 'CJ' "
_cQuery += "       AND SUBSTRING(C2_MSPOSIC,1,5) <> 'RESTA' "
_cQuery += "       AND C2_FILIAL = '" + xFilial("SC2") + "' AND C2.D_E_L_E_T_ = ' '  "
_cQuery += "       AND B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' '  "
_cQuery += " ORDER BY C2_MSUSER, C2_NUM, C2_ITEM, C2_SEQUEN "

TcQuery _cQuery New Alias "QR1"

TcSetField ("QR1","C2_QUANT","N",12,2)
TcSetField ("QR1","C2_EMISSAO","D",08,0)

Do While !QR1->(Eof())
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	@ li,000 PSAY QR1->C2_MSUSER
	@ li,012 PSAY QR1->C2_NUM+QR1->C2_ITEM+QR1->C2_SEQUEN
	@ li,024 PSAY QR1->C2_PRODUTO
	@ li,040 PSAY SUBSTR(QR1->B1_DESC,1,35)
	@ li,075 PSAY TRANSFORM(QR1->C2_QUANT,"@E 999,999.99")
	@ li,086 PSAY QR1->C2_UM
	@ li,089 PSAY QR1->C2_MSREDUZ
	@ li,105 PSAY QR1->C2_MSPED
	@ li,112 PSAY QR1->C2_EMISSAO
	li++
	@ Li,000 Psay __PrtFatLine()
	li++
		
	QR1->(dbSkip())                  

EndDo

Set Device To Screen

QR1->(DbCloseArea())

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

//Imprime os desenhos
If Len(aDesenhos) > 0
	If aReturn[5] > 1 
		For J := 1 TO LEN(aDesenhos)
			WaitRun(aDesenhos[j])
		Next
	EndIf
Endif

RETURN