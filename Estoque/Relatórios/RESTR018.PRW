#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RESTR018  ³ Autor ³Lizandra /Ana Paula    ³ Data ³ 05/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tipod de movimentos                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MASIPACK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RESTR018()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo	:= "Requisições/Devoluções ao Almoxarifado"
cDesc1	:= "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2	:= "acordo com os parametrosdo usuário"
cDesc3	:= ""
wnrel	   := "RESTR018"
tamanho	:= "M"
limite   := 120
aReturn	:= { "Zebrado", 1,"Gerencial", 1, 2, 1, "",1 }
nLastkey := 0
cPerg	   := "XRESTR018 "
nTipo	   := 18
cabec1	:= ""
cabec2	:= ""
nomeprog := "RESTR018"
cstring	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

RptStatus({|| ImpEST18()}, )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpEST18 ³ Autor ³ Lizandra / Ana Paula  ³ Data ³ 05/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AP - Masipack                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static FUNCTION ImpEST18()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt	:= Space(10)
cbcont	:= 00
li		:= 80
m_pag	:= 1
_cUser	:= CUSERNAME
cabec1 := "Numero    Produto         Descricao                   Local                          Quant.  UM  C.C.  Procedencia"
//         D999999  99999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXX 99999999                      9,999.99  xx  9999           9X
///////////123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O123456789N1234567890123456789d123456
//         99/99/99 99:99:99        xxxxxxxxxxxxxxxxxxxxxxxxx    xxxxxxxxxxxxxxxxxxxxxxxxxxx             xx
cabec2 := "Data      Hora            Usuario                     OBS:                           "

titulo := "Movimentações ao Almox "+DTOC(mv_par01)+" a "+DTOC(mv_par02)

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf
	
_cQuery := " SELECT  D3_DOC, D3_COD, B1_DESC, B1_PROCED, "
IF SUBSTR(cNumEmp,1,2) <> '15'
	_cQuery += " B1_LOCAL, "                   
ENDIF	
_cQuery += "         D3_TM, D3_USUARIO, D3_UM,  D3_CC,  D3_QUANT, D3_MSOBS, D3_EMISSAO, D3_HORAS "
_cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
_cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 " 
_cQuery += " 		 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_ = ' ' " 
_cQuery += "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND SD3.D_E_L_E_T_ = ' ' " 
_cQuery += "	   AND D3_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " 
_cQuery += "	   AND D3_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery += "	   AND D3_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQuery += "		AND D3_TM BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQuery += "		AND SUBSTRING(D3_MSOBS,1,8) <> 'RFATG005'  " 
IF MV_PAR09 == 1 
	_cQuery += "		AND SUBSTRING(B1_PROCED,2,1) = 'P'  "  // PRODUTIVO
ELSEIF MV_PAR09 == 2
	_cQuery += "		AND SUBSTRING(B1_PROCED,2,1) <> 'P'  " // NAO PRODUTIVO
ENDIF	
IF  MV_PAR10 == 1
	_cQuery += "		AND SUBSTRING(B1_PROCED,1,1) = '1'  "   // PRODUZIDO
ELSEIF MV_PAR10 = 2	
	_cQuery += "		AND SUBSTRING(B1_PROCED,1,1) = '2'  "   // COMPRADO
ELSEIF MV_PAR10 = 3	
	_cQuery += "		AND SUBSTRING(B1_PROCED,1,1) = '3'  "   // IMPORTADO
ENDIF	
_cQuery += "ORDER BY D3_EMISSAO, D3_COD  " 

TcQuery _cQuery New Alias "QR1"

TcSetField ("QR1","D3_QUANT"  ,"N",12,2)
TcSetField ("QR1","D3_EMISSAO","D",08,0)

Do While !QR1->(Eof())
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	//@li,00 PSAY IIF(MV_PAR05==1,"D","R") + QR1->D3_DOC
	@li, 00 PSAY QR1->D3_DOC
	@li, 10 PSAY QR1->D3_COD
	@li, 26 PSAY SUBSTR(QR1->B1_DESC,1,27)
	IF SUBSTR(cNumEmp,1,2) $ '10_01'
		@li, 54 PSAY QR1->B1_LOCAL
		@li, 83 PSAY TRANSFORM(D3_QUANT,"@E 999,999.99")
	ELSE	
		@li, 60 PSAY TRANSFORM(D3_QUANT,"@E 999,999")
	ENDIF	
	@li, 93 PSAY QR1->D3_UM
	@li, 97 PSAY SUBSTR(QR1->D3_CC,1,4)
	@li,113 PSAY QR1->B1_PROCED
	li++
	@li, 00 PSAY QR1->D3_EMISSAO
	@li, 10 PSAY QR1->D3_HORAS
	@li, 26 PSAY QR1->D3_USUARIO
	@li, 54 PSAY QR1->D3_MSOBS
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
