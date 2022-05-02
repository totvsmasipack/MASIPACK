#Include "Topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPR005  ºAutor  ³Lizandra Marques    º Data ³  03/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Impressão das OP´s em Aberto                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RPCPR005()
	// Magistralmente alterada por Molina com ajuda do
	// pretigiado cavalheiro Marcos no dia de nosso Sr
	// de 01/04/2019

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Relatorio de OP´s em aberto"
Local cPict			:= ""
Local titulo		:= "Relatorio das OP´s em aberto"
local Li			:= 80
Local imprime		:= .T.
Local aOrd			:= {"Data Final","O P s","Por Produto","Falta/Dt.Necessidade","Data da Necessidade","Posicao","Data Inicio"}
PRIVATE aDesenhos	:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private limite		:= 132
Private tamanho		:= "G"
Private nomeprog	:= "RPCPR005"
Private nTipo		:= 15
Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	:= 0
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "RPCPR005"
Private cArqCSV		:= "c:\relato_microsiga\Ops_Abertas.csv"
Private cRegCSV		:= ""
cPerg				:="XRPCPR005"

Pergunte(cPerg,.F.)

Private cString := "SC2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport() },)

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunReport ºAutor  ³Lizandra Marques    º Data ³  23/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão do relatório                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,Li)

Local aCampos := {}
Local j := 0
Local oTable
Local nOrdem := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aCampos,{ "TB_DATAJI"    ,"D",08,0 } )
AADD(aCampos,{ "TB_DATPRF"    ,"D",08,0 } )
AADD(aCampos,{ "TB_DATPRI"    ,"D",08,0 } )
AADD(aCampos,{ "TB_NUM"		  ,"C",06,0 } )
AADD(aCampos,{ "TB_ITEM"	  ,"C",02,0 } )
AADD(aCampos,{ "TB_SEQUEN"	  ,"C",03,0 } )
AADD(aCampos,{ "TB_PRODUTO"   ,"C",15,0 } )
AADD(aCampos,{ "TB_REVATU"    ,"C",03,0 } )
AADD(aCampos,{ "TB_DESC"      ,"C",35,0 } )
AADD(aCampos,{ "TB_UM"	      ,"C",02,0 } )
AADD(aCampos,{ "TB_MSQUANT"	  ,"N",12,3 } )
AADD(aCampos,{ "TB_MSEMPEN"	  ,"N",12,3 } )
AADD(aCampos,{ "TB_QUANT"	  ,"N",12,2 } )
AADD(aCampos,{ "TB_VATU1"     ,"N",12,2 } )
AADD(aCampos,{ "TB_LOCAL"     ,"C",08,0 } )
AADD(aCampos,{ "TB_MSPOSIC"   ,"C",80,0 } )
AADD(aCampos,{ "TB_MSPOSI1"   ,"C",17,0 } )
AADD(aCampos,{ "TB_NREDUZ"    ,"C",15,0 } )
AADD(aCampos,{ "TB_OBS"       ,"C",105,0 } )
AADD(aCampos,{ "TB_MSLIS"     ,"C",01,0 } )
AADD(aCampos,{ "TB_MSFAL"     ,"C",01,0 } )
AADD(aCampos,{ "TB_DTNEC"     ,"D",08,0 } )
AADD(aCampos,{ "TB_ENTREGA"   ,"D",08,0 } )
AADD(aCampos,{ "TB_IMP"       ,"D",08,0 } )
AADD(aCampos,{ "TB_MSUSER"    ,"C",10,0 } )
AADD(aCampos,{ "TB_MSIMPR"    ,"C",01,0 } )
AADD(aCampos,{ "TB_MSCI"      ,"C",12,0 } )
AADD(aCampos,{ "TB_MSDTCI"    ,"D",08,0 } )
AADD(aCampos,{ "TB_PEDIDO"    ,"C",06,0 } )
AADD(aCampos,{ "TB_OPSANT"    ,"N",12,3 } )
AADD(aCampos,{ "TB_SETUP"     ,"N",12,3 } )
AADD(aCampos,{ "TB_TEMPADT"   ,"N",12,3 } )
AADD(aCampos,{ "TB_TEMPADF"   ,"N",12,3 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:AddIndex( "IDX1", {'TB_PRODUTO','TB_NUM','TB_ITEM','TB_SEQUEN'} )

IF nOrdem == 1
	oTable:AddIndex( "IDX2", {'TB_DATPRF','TB_PRODUTO'} )
ELSEIF nOrdem == 2
	oTable:AddIndex( "IDX2", {'TB_NUM','TB_ITEM','TB_SEQUEN'} )
ELSEIF nOrdem == 3
	oTable:AddIndex( "IDX2", {'TB_PRODUTO','TB_NUM','TB_ITEM','TB_SEQUEN'} )
ELSEIF nOrdem == 4
	oTable:AddIndex( "IDX2", {'SUBSTR(TB_MSLF,1,1)','TB_DTNEC','TB_PRODUTO'} )
ELSEIF nOrdem == 5
	oTable:AddIndex( "IDX2", {'TB_DTNEC','TB_PRODUTO'} )
ELSEIF nOrdem == 6
	oTable:AddIndex( "IDX2", {'TB_MSPOSI1','TB_DATPRF'} )
ELSEIF nOrdem == 7
	oTable:AddIndex( "IDX2", {'TB_DATPRI','TB_PRODUTO'} )
ENDIF

oTable:Create()

If (cArqCSV := FCreate("C:\Relato_Microsiga\OPs_Abertasb.csv")) == -1
	Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
	Do Case
		Case  mv_par05 == 1
			cRegCSV := "Apenas OPs"
		Case mv_par05  == 2
			cRegCSV := "Apenas Listas"
		Case mv_par05  == 3
			cRegCSV := "Listas e OPs"
	EndCase
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	cRegCSV := " OP -> De: " + (mv_par01)+  " ate: " + (mv_par02)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	cRegCSV := "Codigo -> De: " + (mv_par03)+ " ate: " + (mv_par04)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	cRegCSV := "Ordens de Produção Abertas - Periodo: de " + DTOC(mv_par07)+ " à " + DTOC(mv_par08)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	Do Case
		Case  mv_par06 == 1
			cRegCSV := "Situação da OP: EM PROCESSO"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
		Case mv_par06  == 2
			cRegCSV := "Situação da OP: SEM PROCESSO"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
		Case mv_par06  == 3
			cRegCSV := "Situação da OP: TODAS"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	EndCase
	cRegCSV := "Posição: " + mv_par09
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	If mv_par10 == 1
		cRegCSV := "Imprime Desenhos: Nao"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	ElseIf mv_par10 == 2
		cRegCSV := "Imprime Desenhos: Faltantes"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	Else
		cRegCSV := "Imprime Desenhos: Todos"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	EndIf
	If mv_par11 == 1
		cRegCSV := "Imprime Detalhes: Sim"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	Else
		cRegCSV := "Imprime Detalhes: Não"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	EndIf
	cRegCSV := "Empenhos - Periodo: de " + DTOC(mv_par12)+ " à " + DTOC(mv_par13)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10))
	cRegCSV := "FALTA;LISTA;IMPRESSAO;USUARIO;PRODUTO;REV;DESCRICAO;UM;ESTOQUE;OP;DT INICIO;DT FIM;SALDO OP;CLIENTE;OBSERVACAO;CUSTO OP;LOCAL;POSIÇÃO;DT.APONTAM.;CI;DATA CI;PEDIDO;EMPENHO;OP´s ANTERIORES;TORNO;FRESA"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf


titulo		:= "Relatorio das OP´s em aberto"
Li			:= 80
Cabec1      :="PRODUTO            DESCRICAO                 UM OP                   FIM      SALDO     CUSTO OP LF    LOCAL POSICAO"
//              123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O123456789N123456789C123456789D123456789V123456789T12345678
//              999999999999999 A XXXXXXXXXXXXXXXXXXXXXXXXX XX 9999999999999 X 99/99/99 99.999.999 9.999.999,99 XX 99999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Cabec2	:= ""


If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf


_cCond	:= " !TRB->(EOF())  "

_cQuery := " SELECT C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN, C2_DATAJI, C2_DATPRF, (C2_QUANT-C2_QUJE-C2_PERDA) AS SALDO, "
_cQuery += "        C2_MSREDUZ, C2_MSPOSIC, C2_VATU1,C2_MSIMPR, C2_MSUSER, C2_MSCI, C2_MSDTCI, C2_PEDIDO, "
_cQuery += "        C2_MSPED, C2_MSLISTA, C2_DATPRI, C2_OBS, B2.B2_QATU, "
_cQuery += "        B1_REVATU, B1_DESC, B1_UM,  B1_LOCAL, "
_cQuery += "        D4_MSLF, D4_QUANT, D4_DATA, D4_COD, D4_OP, B2EMP.B2_QEMP [SLDEMP], "
_cQuery += "        C6_NUM, C6_PRODUTO, (C6_QTDVEN - C6_QTDENT) AS QUANTC6, "
_cQuery += "        C5_NUM, C5_MSDTENT "
_cQuery += "        G2_TEMPAD, G2_SETUP, G2_RECURSO "
_cQuery += " FROM " + RetSqlName("SC2") + " C2 "
_cQuery += " INNER JOIN " + retSqlName("SB1") + " B1 "
_cQuery += "       ON C2_PRODUTO = B1_COD "
_cQuery += " INNER JOIN " + RetSqlName("SB2") + " B2 "
_cQuery += "       ON C2_PRODUTO = B2.B2_COD "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SD4") + " D4 "
_cQuery += "       ON (C2_PRODUTO = D4_COD OR C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP) AND D4_FILIAL = '" + xFilial("SD4") + "' AND  D4.D_E_L_E_T_ = ' ' "
_cQuery += "       AND D4_QUANT >0 "

_cQuery += " LEFT JOIN " + RetSQLName('SB2') + " B2EMP ON B2EMP.B2_FILIAL = '"+FWxFilial('SB2')+"' AND B2EMP.B2_COD = D4_COD AND B2EMP.B2_LOCAL = D4_LOCAL AND B2EMP.D_E_L_E_T_ = ' ' "

_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC6") + " C6 "
_cQuery += "       ON C2_PRODUTO = C6_PRODUTO AND C6_BLQ = ' ' AND C6_MSPCP <> '        ' "
_cQuery += "       AND C6_FILIAL = '" + xFilial("SC6") + "' AND  C6.D_E_L_E_T_ = ' ' "
_cQuery += "       AND (C6_QTDVEN - C6_QTDENT ) > 0 "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC5") + " C5 "
_cQuery += "       ON C6_NUM = C5_NUM "
_cQuery += "       AND C5_FILIAL = '" + xFilial("SC5") + "' AND  C5.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SG2") + " G2"
_cQuery += "       ON C2_PRODUTO = G2_PRODUTO AND G2_FILIAL = '" + xFilial("SG2") + "' AND G2.D_E_L_E_T_ = ' ' 
_cQuery += " WHERE C2_PRODUTO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
_cQuery += "       AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
IF nOrdem == 7
	_cQuery += "          AND C2_DATPRI BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) +  "' "
ELSE
	_cQuery += "       AND C2_DATPRF BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) +  "' "
ENDIF
_cQuery += "       AND C2_FILIAL = '" + xFilial("SC2") + "' AND B1_FILIAL = '" + xFilial("SB1") + "' "
_cQuery += "       AND B2.B2_FILIAL = '" + xFilial("SB2") + "' AND B2.D_E_L_E_T_ = ' ' "
_cQuery += "       AND (C2_QUJE + C2_PERDA) < C2_QUANT AND C2_DATRF = '        ' AND C2.D_E_L_E_T_ = ' ' AND  B1.D_E_L_E_T_ = ' ' "
IF MV_PAR05 == 1  // LISTA / OP
	_cQuery += "   AND C2_MSLISTA <> 'S' "
ELSEIF MV_PAR05 == 2
	_cQuery += "   AND C2_MSLISTA <> 'N' "
ENDIF
IF MV_PAR06 == 1   // EM PROCESSO
	_cQuery += "       AND UPPER(C2_MSPOSIC) LIKE  '%" + UPPER(ALLTRIM(MV_PAR09)) + "%' AND C2_MSPOSIC <> '                    ' "
ELSEIF MV_PAR06 == 2	  // SEM PROCESSO
	_cQuery += "       AND C2_MSPOSIC = '' "
ENDIF
_cQuery += " ORDER BY C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","C2_DATAJI" ,"D",08,00)
TcSetField("QR1","C2_DATPRF" ,"D",08,00)
TcSetField("QR1","SALDO"     ,"N",12,02)
TcSetField("QR1","QUANT"     ,"N",12,02)
TcSetField("QR1","C2_VATU1"  ,"N",12,02)
TcSetField("QR1","C2_MSIMPR" ,"D",08,00)
TcSetField("QR1","D4_QUANT"  ,"N",12,02)
TcSetField("QR1","D4_DATA"   ,"D",08,00)
TcSetField("QR1","C2_DATPRI" ,"D",08,00)
TcSetField("QR1","C2_MSDTCI" ,"D",08,00)
TcSetField("QR1","C5_MSDTENT","D",08,00)
TcSetField("QR1","G2_TEMPAD" ,"N",12,02)
TcSetField("QR1","D4_SETUP"  ,"N",12,02)

QR1->(DbGoTop())

GravaTrb(nOrdem)  // arquivo de trabalho

QR1->(DbCloseArea())

_dDataF := CTOD("")
_dDataN	:= CTOD("")
_cop	:= SPACE(13)
_cProd	:= SPACE(15)
_cFL	:= SPACE(04)
_cPoosic:= SPACE(40)

dbSelectarea("TRB")
TRB->(DbGoTop())

IF nOrdem == 1
	titulo+=" - Por Data Final"
	_cCond += ""
ELSEIF nOrdem == 2
	titulo+=" - Por Número da OP"
	_cCond += ""
ELSEIF nOrdem == 3
	titulo+=" - Por Produto"
	_cCond += ""
ELSEIF nOrdem == 4
	titulo+=" - Falta e Data Necessidade"
	_cCond += ""
ELSEIF nOrdem == 5
	titulo+=" - Data da Necessidade"
	_cCond += ""
ELSEIF nOrdem == 6
	titulo+=" - Posicao e Data Final"
	_cCond += "  .AND. _cPosic == TRB->TB_MSPOSI1 "
ELSEIF nOrdem == 7
	titulo+=" - Por Data Inicial "
	_cCond += ""
EndIf


IF li > 60
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
	li := 9
ENDIF
Do Case
	Case  mv_par05 == 1
		@li,000 Psay PADC("Apenas Listas",220)
	Case mv_par05  == 2
		@li,000 Psay PADC("Apenas OPs",220)
	Case mv_par05  == 3
		@li,000 Psay PADC("Listas e OPs",220)
EndCase

Li++
@ Li,000 Psay PADC(" OP -> De: " + (mv_par01)+  " ate: " + (mv_par02),220)
Li++
@Li,000 Psay PADC("Codigo -> De: " + (mv_par03)+ " ate: " + (mv_par04),220)
Li++
@Li,000 Psay PADC("Data -> De: " + DTOC(mv_par07)+ " ate: " + DTOC(mv_par08),220)
Li++

Do Case
	Case  mv_par06 == 1
		@li,000 Psay PADC("Situação da OP: EM PROCESSO",220)
	Case mv_par06  == 2
		@li,000 Psay PADC("Situação da OP: SEM PROCESSO",220)
	Case mv_par06  == 3
		@li,000 Psay PADC("Situação da OP: TODAS",220)
EndCase

Li++
@Li,000 Psay PADC("Posição: " + mv_par09,220)
Li++
If mv_par10 == 1
	@Li,000 Psay PADC("Imprime Desenhos: Nao",220)
ElseIf mv_par10 == 2
	@Li,000 Psay PADC("Imprime Desenhos: Faltantes",220)
Else
	@Li,000 Psay PADC("Imprime Desenhos: Todos",220)
EndIf

Li++
If mv_par11 == 1
	@Li,000 Psay PADC("Imprime Detalhes: Sim",220)
Else
	@Li,000 Psay PADC("Imprime Detalhes: Não",220)
EndIf

Li++
@ Li,000 Psay __PrtFatLine()
Li++

TRB->(DbGoTop())

DO WHILE !TRB->(EOF())
	IF nOrdem == 6
		_dDataF := TRB->TB_DATPRF
		_cPosic	:= TRB->TB_MSPOSI1
	ENDIF
	_nCont	:= 0
	_nSaldo	:= 0
	DO WHILE&_cCond
		IF li > 55
			Li	:= cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			Li	:= 08
		ENDIF
		@Li ,000 PSAY TRB->TB_PRODUTO + " " + TRB->TB_REVATU
		@Li ,019 PSAY SUBSTR(TRB->TB_DESC,1,25)
		@Li ,045 PSAY TRB->TB_UM
		@Li ,048 PSAY TRB->TB_NUM + TRB->TB_ITEM + TRB->TB_SEQUEN
		@Li ,062 PSAY TRB->TB_MSIMPR
		@Li ,064 PSAY TRB->TB_DATPRF
		@Li ,073 PSAY TRB->TB_QUANT PICTURE PesqPict('SC2','C2_QUANT')
		@Li ,084 PSAY TRB->TB_VATU1 PICTURE "@E 9,999,999.99"
		@Li, 097 PSAY TRB->TB_MSFAL+TRB->TB_MSLIS
		@Li ,100 PSAY TRB->TB_LOCAL
		@Li ,109 PSAY IIF(EMPTY(TRB->TB_MSPOSIC),"",TRB->TB_MSPOSIC)
		_nCont++
		_nSaldo	+= TRB->TB_QUANT
		Li++
		_nEst:=0
		IF MV_PAR11 == 1 .AND. TRB->TB_MSLIS == "L"
			SD4->(DbSetOrder(2))
			If SD4->(DbSeek(xFilial("SD4")+TRB->TB_NUM + TRB->TB_ITEM + TRB->TB_SEQUEN))
				Do While ! SD4->(Eof()) .And. ALLTRIM(SD4->D4_OP) == ALLTRIM(TRB->TB_NUM) + ALLTRIM(TRB->TB_ITEM) + ALLTRIM(TRB->TB_SEQUEN)
					If SD4->D4_QUANT > 0
						SC2->(DbSetOrder(2))
						IF SC2->(DbSeek(xFilial("SC2")+Alltrim(SD4->D4_COD)))
							_lFirst := .T.
							DO WHILE !SC2->(EOF()) .AND. Alltrim(SD4->D4_COD) == ALLTRIM(SC2->C2_PRODUTO)
								IF EMPTY(SC2->C2_DATRF) 
									IF _lFirst
										_nEst := Posicione("SB2",1,xFilial("SB2")+SD4->D4_COD+"01","B2_QATU")
										@Li,019 Psay "Produto: " + SD4->D4_COD + " OP: " + Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) + " - Posição: " + SC2->C2_MSPOSIC + "  Data Fim da OP : " + DTOC(SC2->C2_DATPRF) + " Estoque:" + TRANSFORM(_nEst,"@E 999,999.999") + " Empenho:" + TRANSFORM(SD4->D4_QUANT,"@E 9,999.999")
										Li++
										_lFirst := .F.
									ELSE	
										@Li,019 Psay SPACE(24) + " OP: " + Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) + " - Posição: " + SC2->C2_MSPOSIC + "  Data Fim da OP : " + DTOC(SC2->C2_DATPRF) 
										Li++
									ENDIF	
								ENDIF
								SC2->(dbSkip())
							ENDDO		
						ENDIF	
					EndIf
					SD4->(DbSkip())
					Loop
				EndDo
			EndIf
		EndIf
		
		If mv_par10 == 3 .Or. (mv_par10 == 2 .And. SubStr(TRB->TB_MSFAL,1,1) == "X")										// Imprime desenho
			cDesenho := ALLTRIM(TRB->TB_PRODUTO) + ALLTRIM(TRB->TB_REVATU)
			_cPath := "H:\PLOTTER\"
			If SubStr(cNumEmp,1,2) == "01"
				If Substr(cDesenho,1,2) == "CL"
					_cPath += Substr(cDesenho,3,2) + "\"
				Else
					_cPath += Substr(cDesenho,1,2) + "\"
				EndIf
			ElseIf SubStr(cNumEmp,1,2) == "10"
				_cPath += Substr(cDesenho,1,3) + "\"
			EndIf
			If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
				AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
				AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
				AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
			EndIf
		EndIf
		dDtApont := ""
		nTam := Len(Alltrim(TRB->TB_MSPOSIC))
		If nTam > 10
			dDtApont  := SubStr(Alltrim(TRB->TB_MSPOSIC),nTam - 7, nTam)
			If SubStr(dDtApont,3,1)  <> "/" .Or. SubStr(dDtApont,6,1) <> "/"
				dDtApont := ""
			EndIf
		EndIf
		cRegCSV := TRB->TB_MSFAL+";"+TRB->TB_MSLIS+";"+DTOC(TRB->TB_IMP)+";"+TRB->TB_MSUSER+";_"+Alltrim(TRB->TB_PRODUTO)+";"+;
		Alltrim(TRB->TB_REVATU)+";"+TRB->TB_DESC+";"+TRB->TB_UM+";"+Transform(TRB->TB_MSQUANT,"@E 9,999,999.999")+";_"+TRB->TB_NUM+TB_ITEM+TB_SEQUEN+";"+;
		DTOC(TRB->TB_DATPRI)+";"+DTOC(TRB->TB_DATPRF)+";"+Transform(TRB->TB_QUANT,"@E 9,999,999.999")+";"+TRB->TB_NREDUZ+";"+TRB->TB_OBS+";"+Transform(TRB->TB_VATU1,"@E 99,999.999")+";_"+;
		TRB->TB_LOCAL+";"+TRB->TB_MSPOSIC+";"+dDtApont+";"+TRB->TB_MSCI+";"+DTOC(TRB->TB_MSDTCI)+";"+TRB->TB_PEDIDO+";"+transform(TRB->TB_MSEMPEN,"@E 9,999,999.99")+";"+TRANSFORM(TRB->TB_OPSANT,"@E 99,999.99")+";"+;
		TRANSFORM((TRB->TB_TEMPADT*TRB->TB_QUANT)+TRB->TB_SETUP,"@E 9,999,999.999");TRANSFORM((TRB->TB_TEMPADF*TRB->TB_QUANT)+TRB->TB_SETUP,"@E 9,999,999.999")
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		TRB->(dbSkip())
	ENDDO
	IF li > 55
		Li := cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
	ENDIF                                                                              
	IF nOrdem ==6
		Li++
		@Li ,000 PSAY "T O T A L =====> "
		@Li ,048 PSAY STRZERO(_nCont,3)
		@Li ,073 PSAY _nSaldo PICTURE PesqPict('SC2','C2_QUANT')
		Li++
		@ Li,000 Psay __PrtFatLine()
	ENDIF
	Li++
ENDDO

FClose(cArqCSV)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Else
	For j := 1 TO Len(aDesenhos)
		WaitRun(aDesenhos[j])
	Next
Endif

MS_FLUSH()

TRB->(dbCloseArea())

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaTrb  ºAutor  ³Lizandra Marques    º Data ³  23/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Arquivo de trabalho                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaTrb(nOrdem)
_cPed := ""
DO WHILE !QR1->(EOF())
	IF !TRB->(dbSeek(QR1->C2_PRODUTO+QR1->C2_NUM+QR1->C2_ITEM+QR1->C2_SEQUEN))
		RecLock("TRB",.T.)
		TRB->TB_PRODUTO	:= QR1->C2_PRODUTO
		TRB->TB_NUM		:= QR1->C2_NUM
		TRB->TB_ITEM	:= QR1->C2_ITEM
		TRB->TB_SEQUEN	:= QR1->C2_SEQUEN
		TRB->TB_DATAJI	:= QR1->C2_DATAJI
		TRB->TB_DATPRI	:= QR1->C2_DATPRI
		TRB->TB_DATPRF	:= QR1->C2_DATPRF
		TRB->TB_QUANT	:= QR1->SALDO
		TRB->TB_NREDUZ	:= QR1->C2_MSREDUZ
		TRB->TB_OBS		:= QR1->C2_OBS
		TRB->TB_MSPOSIC	:= QR1->C2_MSPOSIC
		TRB->TB_MSPOSI1	:= SUBSTR(QR1->C2_MSPOSIC,1,17)
		TRB->TB_VATU1	:= QR1->C2_VATU1
		TRB->TB_REVATU	:= ALLTRIM(QR1->B1_REVATU)
		TRB->TB_DESC	:= QR1->B1_DESC
		TRB->TB_UM		:= QR1->B1_UM
		TRB->TB_MSQUANT	:= QR1->B2_QATU
		TRB->TB_LOCAL	:= QR1->B1_LOCAL
		TRB->TB_IMP		:= QR1->C2_MSIMPR
		TRB->TB_MSUSER	:= QR1->C2_MSUSER
		TRB->TB_MSCI	:= QR1->C2_MSCI
		TRB->TB_MSDTCI	:= QR1->C2_MSDTCI
		TRB->TB_MSEMPEN	:= QR1->SLDEMP
		If !Empty(QR1->C2_MSIMPR)
			TRB->TB_MSIMPR	:=  "I"
		EndIf
		If !Empty(SC2->C2_PEDIDO)
			TRB->TB_PEDIDO	:= QR1->C2_PEDIDO
		Else
			TRB->TB_PEDIDO	:= QR1->C2_MSPED
		EndIf
		IF QR1->D4_COD == QR1->C2_PRODUTO .AND. QR1->D4_MSLF == "X"
			TRB->TB_MSFAL := "X"    // ENQUANTO PRODUTO
		ELSEIF QR1->D4_OP == QR1->C2_NUM+QR1->C2_ITEM+QR1->C2_SEQUEN+"  " .AND.	QR1->D4_MSLF == "X"
			TRB->TB_MSLIS := "L"   // ENQUANTO OP
		ENDIF
		TRB->TB_SETUP := QR1->G2_SETUP
		IF SUBSTR(QR1->G2_RECURSO,1,4) == "U002"
			TRB->TB_TEMPADF := QR1->G2_TEMPAD
		ELSEIF SUBSTR(QR1->G2_RECURSO,1,4) == "U004" 			
			TRB->TB_TEMPADT := QR1->G2_TEMPAD
		ENDIF	
	ELSE
		RecLock("TRB",.F.)
		IF QR1->D4_COD == QR1->C2_PRODUTO .AND. QR1->D4_MSLF == "X"
			TRB->TB_MSFAL := "X"    // ENQUANTO PRODUTO
		ELSEIF QR1->D4_OP == QR1->C2_NUM+QR1->C2_ITEM+QR1->C2_SEQUEN+"  " .AND.	QR1->D4_MSLF == "X"
			TRB->TB_MSLIS := "L"   // ENQUANTO OP
		ENDIF         
		IF TRB->TB_SETUP == 0
			TRB->TB_SETUP := QR1->G2_SETUP
		ENDIF             
		IF SUBSTR(QR1->G2_RECURSO,1,4) == "U002"
			TRB->TB_TEMPADF += QR1->G2_TEMPAD
		ELSEIF SUBSTR(QR1->G2_RECURSO,1,4) == "U004" 			
			TRB->TB_TEMPADT += QR1->G2_TEMPAD
		ENDIF	
	ENDIF
	MsUnlock()
	_cPed := QR1->C6_NUM
	QR1->(dbSkip())
ENDDO
// ATUALIZAÇÃO DOS SALDO DE OP´S ANTERIORES

IF nOrdem == 7
	AtuOPAnt()
	AtuEmp()
ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuOPAnt  ºAutor  ³Lizandra Marques    º Data ³  23/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza saldo das ops anteriores                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuOPAnt()

If Select("QR2") > 0
	DbSelectArea("QR2")
	DbCloseArea()
EndIf

_cQuery2 := " SELECT C2_DATPRI, C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN, C2_DATPRF, (C2_QUANT-C2_QUJE-C2_PERDA) AS SALDO, "
_cQuery2 += "        C2_MSPOSIC "
_cQuery2 += " FROM " + RetSqlName("SC2") + " C2  "
_cQuery2 += " WHERE C2_PRODUTO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
_cQuery2 += "       AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
_cQuery2 += "       AND C2_DATPRI < = '" + DTOS(MV_PAR08) + "' AND C2_FILIAL = '" + xFilial("SC2") + "' "
_cQuery2 += "       AND C2.D_E_L_E_T_ = ' ' "
_cQuery2 += "       AND (C2_QUJE+C2_PERDA) < C2_QUANT AND C2_DATRF = '        '  "
IF MV_PAR05 == 1  // LISTA / OP
	_cQuery2 += "   AND C2_MSLISTA <> 'S' "
ELSEIF MV_PAR05 == 2
	_cQuery2 += "   AND C2_MSLISTA <> 'N' "
ENDIF
_cQuery2 += "       AND C2_MSPOSIC <> '                            '  "
_cQuery2 += " ORDER BY C2_PRODUTO "

TcQuery _cQuery2 New Alias "QR2"

TcSetField("QR2","C2_DATAJI" ,"D",08,00)
TcSetField("QR2","C2_DATPRF" ,"D",08,00)
TcSetField("QR2","SALDO"     ,"N",12,02)
TcSetField("QR2","C2_DATPRI" ,"D",08,00)

QR2->(DbGoTop())
TRB->(DbGoTop())

DO WHILE !QR2->(EOF())
	IF TRB->(dbSeek(QR2->C2_PRODUTO))
		DO WHILE !TRB->(EOF()) .AND. QR2->C2_PRODUTO == TRB->TB_PRODUTO
			IF TRB->TB_DATPRI >= QR2->C2_DATPRI .AND. TRB->TB_NUM + TRB->TB_ITEM + TRB->TB_SEQUEN <> QR2->C2_NUM + QR2->C2_ITEM + QR2->C2_SEQUEN
				RecLock("TRB",.F.)
				TRB->TB_OPSANT	+= QR2->SALDO
				MsUnlock()
			ENDIF
			dbSelectarea("TRB")
			TRB->(dbSkip())
		ENDDO
	ENDIF
	QR2->(dbSkip())

ENDDO
QR2->(dbCloseArea())

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuEmp    ºAutor  ³Lizandra Marques    º Data ³  23/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza empenho                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuEmp()
                     
If Select("QR3") > 0
	DbSelectArea("QR3")
	DbCloseArea()
EndIf

_cQuery3 := " SELECT 'E' AS TIPO, D4_COD AS COD, SUM(D4_QUANT)AS SALDO "
_cQuery3 += " FROM " + RetSqlName("SD4") + " D4 "
_cQuery3 += " WHERE D4_FILIAL = '" + xFilial("SD4") + "' AND  D4.D_E_L_E_T_ = ' ' "
_cQuery3 += "       AND D4_DATA BETWEEN '" + DTOS(MV_PAR12) + "' AND '" + DTOS(MV_PAR13) + "' "
_cQuery3 += "       AND D4_QUANT  > 0 "
_cQuery3 += " GROUP BY D4_COD "
_cQuery3 += " UNION ALL "
_cQuery3 += " SELECT 'P' AS TIPO, C6_PRODUTO AS COD, SUM(C6_QTDVEN - C6_QTDENT) AS SALDO "
_cQuery3 += " FROM " + RetSqlName("SC6") + " C6 "
_cQuery3 += " INNER JOIN " + RetSqlName("SC5") + " C5 "
_cQuery3 += "       ON C5_NUM = C6_NUM "
_cQuery3 += " WHERE (C6_QTDVEN - C6_QTDENT) > 0 "
_cQuery3 += "       AND C6_FILIAL = '" + xFilial("SC6") + "' AND  C6.D_E_L_E_T_ = ' ' "
_cQuery3 += "       AND C5_FILIAL = '" + xFilial("SC5") + "' AND  C5.D_E_L_E_T_ = ' ' "
_cQuery3 += "       AND C6_BLQ = ' ' AND C6_MSPCP <> '       ' "
_cQuery3 += "       AND C5_MSDTENT BETWEEN '" + DTOS(MV_PAR12) + "' AND '" + DTOS(MV_PAR13) + "' "
_cQuery3 += " GROUP BY C6_PRODUTO "
_cQuery3 += " ORDER BY D4_COD "

TcQuery _cQuery3 New Alias "QR3"


TcSetField("QR3","SALDO","N",12,02)


QR3->(DbGoTop())
TRB->(DbGoTop())

DO WHILE !QR3->(EOF())
	IF TRB->(dbSeek(QR3->COD))
		DO WHILE !TRB->(EOF()) .AND. QR3->COD == TRB->TB_PRODUTO
			RecLock("TRB",.F.)
			TRB->TB_MSEMPEN  += QR3->SALDO
			MsUnlock()
			TRB->(dbSkip())
		ENDDO
	ENDIF
	QR3->(dbSkip())
ENDDO
QR3->(dbCloseArea())

RETURN
