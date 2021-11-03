#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR006  ºAutor  ³Adriano Luis Brandaoº Data ³  27/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Serie dos equipamentos.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
// Alterado em 11/07/2013 por Ana Paula QF - alteração na Query 
*/

User Function RFATR006()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "do numero de serie dos equipamentos."
Local cDesc3       := ""
Local cPict        := ""
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}

Private Titulo   	 := "Numero de serie dos equipamentos"
Private _nLin      := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "M"
Private nomeprog   := "RFATR006"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFATR006"
Private cPerg      := "XRFATR006 "
Private cString    := "AA3"

Pergunte(cPerg,.F.)

dbSelectArea("AA3")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({ |lEnd| _fImprime()  })

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fImprime ºAutor  ³Adriano Luis Brandaoº Data ³  27/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao do relatorio.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fImprime()

Cabec1 := "Pedido  Cliente               Codigo produto   Descricao do produto                     Serie       Data Emiss  Data Exp."
Cabec2 := ""
//         XXXXXX  XXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XXXXXXXXXX  99/99/9999  99/99/9999
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := " SELECT AA3_MSPED, A1_NREDUZ, AA3_CODPRO, B1_DESC, AA3_NUMSER, AA3_MSEMI, AA3_DTVEND, AA3_MSITEM "
_cQuery += " FROM " + RetSqlName("AA3") + " AA3 "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC5") + " C5 ON C5_NUM = AA3_MSPED AND C5_FILIAL = '" + xFilial("SC5") + "' AND C5.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SA1") + " A1 ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1_FILIAL = '" + xFilial("SA1") + "' AND A1.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = AA3_CODPRO AND B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' '  "
_cQuery += " WHERE AA3_DTVEND BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "       AND AA3_FILIAL = '" + xFilial("AA3") + "' AND AA3.D_E_L_E_T_ = ' ' "
If !EMPTY(MV_PAR03)
	_cQuery += "AND AA3_NUMSER = '" +(MV_PAR03) + "' "
EndIf
_cQuery += " ORDER BY AA3_MSPED, AA3_MSITEM, AA3_CODPRO "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","AA3_MSEMI" ,"D",08,00)
TcSetField("QR1","AA3_DTVEND" ,"D",08,00)

QR1->(DbGoTop())

Do While ! QR1->(Eof())
	
	If lEnd
		@ _nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If _nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		_nLin := 8
	Endif
	
	@ _nLin,000 Psay QR1->AA3_MSPED
	@ _nLin,008 Psay QR1->A1_NREDUZ
	@ _nLin,030 Psay QR1->AA3_CODPRO
	@ _nLin,047 Psay QR1->B1_DESC
	@ _nLin,089 Psay Substr(QR1->AA3_NUMSER,1,12)
	@ _nLin,101 Psay QR1->AA3_MSEMI
	@ _nLin,113 Psay QR1->AA3_DTVEND
	_nLin++
	
	QR1->(DbSkip())
	
EndDo

QR1->(dbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return