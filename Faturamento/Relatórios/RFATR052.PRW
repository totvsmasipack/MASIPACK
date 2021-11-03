#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RFATR052  ³ Autor ³   Lizandra            ³ Data ³ 27/09/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CONSULTA (IMPRESSAO) DE PRODUTOS POR DESCRICAO             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MASIPACK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATR052()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo	  := "Consulta/Impressao do cadastro de produto"
cDesc1	  := "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2	  := "acordo com os parametrosdo usuário"
cDesc3	  := ""
wnrel	  := "RFATR052"
tamanho	  := "P"
aReturn	  := { "Zebrado", 1,"Gerencial", 1, 2, 1, "",1 }
nLastkey  := 0
cPerg	  := "XRFATR052 "
nTipo	  := 18
cabec1	  := ""
cabec2	  := ""
nomeprog  := "RFATR052"
cstring	  := ""

Pergunte(cPerg,.F.)

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

RptStatus({|| ImpFAT52()}, )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpFAT52 ³ Autor ³ LIZANDRA              ³ Data ³ 27/09/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AP - Masipack                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static FUNCTION ImpFAT52()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aDesenhos := {}
cDesenho  := ""
cbtxt	:= Space(10)
cbcont	:= 00
li		:= 80
m_pag	:= 1
cabec1 := "Codigo           Descricao                            Fantasma    Blq  Grupo"
//         999999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  X           XXX
///////////123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O
//         99/99/99 99:99:99        xxxxxxxxxxxxxxxxxxxxxxxxx      xxxxxxxxxxxxxxxxxxxxxxxxxxx
cabec2 := "Descricao Prolongada"

//Ivandro Santos - 06/04/17 - Início da alteração
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
_cQuery := " SELECT B1_COD, B1_DESC, ISNULL(B5_CEME,'') AS 'B5_CEME', B1_FANTASM, B1_MSBLQL, B1_GRUPO "
//_cQuery := " SELECT B1_COD, B1_DESC, B1_DESCP, B1_FANTASM, B1_MSBLQL, B1_GRUPO "             
_cQuery += " FROM " + RetSqlName("SB1") + " B1 "
_cQuery += " LEFT JOIN " + RetSQLName("SB5") + " B5 ON B5_COD = B1_COD "
_cQuery += " 		AND B5_FILIAL = '" + xFilial("SB5") + "' AND B5.D_E_L_E_T_ = ' ' "
//Ticket#2017031037000107 — Fim da alteração
_cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
IF MV_PAR02 == 1
	_cQuery += " AND B1_DESC LIKE '%" + RTRIM(MV_PAR01) + "%' "
ELSE	
	_cQuery += " AND B1_GRUPO LIKE '%" + ALLTRIM(MV_PAR01) + "%' "
ENDIF	
_cQuery += " ORDER BY B1_DESC "

TcQuery _cQuery New Alias "QR1"


Do While !QR1->(Eof())
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	@li,01 PSAY QR1->B1_COD
	@li,18 PSAY QR1->B1_DESC
	@li,55 PSAY IIF(QR1->B1_FANTASM = "S", "Sim","Nao")
	@li,67 PSAY IIF(QR1->B1_MSBLQL = "1", "Sim","Nao") 
	@lI,72 PSAY QR1->B1_GRUPO
	li++                                  
	//Ivandro Santos - 06/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	IF !EMPTY(QR1->B5_CEME)	//IF !EMPTY(QR1->B1_DESCP)
		@li,01 PSAY SUBSTR(QR1->B5_CEME,1,80)	//@li,01 PSAY SUBSTR(QR1->B1_DESCP,1,80)
		//Ticket#2017031037000107 — Fim da alteração
		li += 2
	ENDIF	
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