#Include "Topconn.ch"
#Include "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RFINR002  ³ Autor ³ Aparecida F.Stevanato³ Data ³ 15.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Relação de Notas Fiscais p/ Ctas. à Pagar       ³±±
±±³            Reescrito - Lizandra 25/01/13                              ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINR002()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL wnrel		   := "RFINR002"
LOCAL cDesc1	   := "Emissao de Relaçao de Notas Fiscais"
PRIVATE Titulo	   := "Notas Fiscais"
PRIVATE aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE Tamanho   := "M"
PRIVATE Limite    := 132
PRIVATE wnrel     := "RFINR002"
PRIVATE nomeprog  := "RFINR002"
PRIVATE nLastKey  := 0
PRIVATE cString   := "SF1"
PRIVATE M_PAG	   := 1
PRIVATE Li        := 99
Private cPerg	   := "XRFINR002 "
Private Cabec1    := ""
Private Cabec2    := ""
Private _cForn    := ""
Private _cLoja    := ""
Private _NumDup   := ""
Private _QtdDup   := 0
Private nVlrTotal := 0

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,,,.F.,,.F.,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RFIN02Imp(@lEnd,wnrel,cString,Tamanho)},Titulo)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFIN02IMP                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RFIN02Imp(lEnd,wnrel,cString,Tamanho)

mv_par01 := UPPER(mv_par01)
mv_par02 := UPPER(mv_par02)
mv_par03 := UPPER(mv_par03)
mv_par04 := UPPER(mv_par04)
mv_par05 := UPPER(mv_par05)
mv_par06 := UPPER(mv_par06)
mv_par09 := UPPER(Alltrim(mv_par09))

Cabec1  := "NUMERO   SER  DATA DE   DATA DE   FORNECEDOR                              TOTAL DA NOTA                  T  Í  T  U  L  O  S"
Cabec2  := "              EMISSÃO   DIGITAÇÃO                                           COM IPI          VALOR       NÚMERO        VENCTO.  "

nOrdem  := aReturn[8]

Titulo := "Relatorio  de  Notas  Fiscais  -  "  + "Por Nota"

Titulo += " Periodo: "+ DTOC(mv_par07) + " a " + DTOC(mv_par08)
If !Empty(mv_par09)
	Titulo += " (" + mv_par09 + ")"
EndIf

MsgRun("Aguarde, Imprimindo !!!!",, { || RFIN02Nota(lEnd,Tamanho) })


Set Device To Screen
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a Impressao de acordo com a Ordem Selecionada         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function RFIN02Nota(lEnd,Tamanho)

Local aCampos := {}
Local oTable

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aCampos,{ "TB_TIPO"      ,"C",01,0 } )
AADD(aCampos,{ "TB_DOC"       ,"C",09,0 } )
AADD(aCampos,{ "TB_SERIE"     ,"C",03,0 } )
AADD(aCampos,{ "TB_FORNECE"   ,"C",06,0 } )
AADD(aCampos,{ "TB_LOJA"	  ,"C",02,0 } )
AADD(aCampos,{ "TB_EMISSAO"	  ,"D",08,0 } )
AADD(aCampos,{ "TB_DTDIGIT"   ,"D",08,0 } )
AADD(aCampos,{ "TB_STATUS"    ,"C",01,0 } )
AADD(aCampos,{ "TB_VALBRUT"   ,"N",12,2 } )
AADD(aCampos,{ "TB_MSAPROP"	  ,"C",30,0 } )
AADD(aCampos,{ "TB_PARCELA"	  ,"C",02,0 } )
AADD(aCampos,{ "TB_VALOR"	  ,"N",12,2 } )
AADD(aCampos,{ "TB_VENCREA"   ,"D",08,0 } )
AADD(aCampos,{ "TB_VENCTO"    ,"D",08,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRB") > 0
	DbSelectArea("TRB")
	TRB->(DbCloseArea())
EndIf                                                             

oTable := FWTemporaryTable():New('TRB',aCampos)
oTable:AddIndex( 'IDX1', {'TB_DOC','TB_SERIE','TB_FORNECE','TB_LOJA','TB_PARCELA'} )
oTable:Create()

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := " SELECT F1_TIPO, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_DTDIGIT, "
_cQuery += "        F1_STATUS, F1_VALBRUT, SUBSTRING(C1_MSAPROP,1,30) AS APROP, "
_cQuery += "        E2_PARCELA, E2_VALOR, E2_VENCREA, E2_VENCTO  "
_cQuery += " FROM " + RetSqlName("SF1") + " F1 "
_cQuery += " INNER JOIN " + RetSqlName("SD1") + " D1 "
_cQuery += "       ON D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE "
_cQuery += "       AND D1_LOJA = F1_LOJA "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SE2") + " E2 "
_cQuery += "       ON F1_SERIE = E2_PREFIXO AND F1_DOC = E2_NUM AND F1_FORNECE = E2_FORNECE AND F1_LOJA = E2_LOJA  "
_cQuery += "       AND E2_EMISSAO = F1_EMISSAO "
_cQuery += "       AND E2_FILIAL = '" + xFilial("SE2") + "' AND E2.D_E_L_E_T_ = ' '  "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC7") + " C7 "
_cQuery += "      ON D1_PEDIDO = C7_NUM AND D1_ITEMPC = C7_ITEM "
_cQuery += "      AND C7_FILIAL = '" + xFilial("SC7") + "' AND C7.D_E_L_E_T_ = ' ' "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC1") + " C1 "
_cQuery += "      ON C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC "
_cQuery += "      AND C1_FILIAL = '" + xFilial("SC1") + "' AND C1.D_E_L_E_T_ = ' '  "
_cQuery += " WHERE F1_FILIAL = '" + xFilial("SF1") + "' AND F1.D_E_L_E_T_ = ' ' "
_cQuery += "       AND F1_DOC BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
_cQuery += "       AND F1_SERIE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  "
_cQuery += "       AND F1_FORNECE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
_cQuery += "       AND F1_DTDIGIT BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' AND F1_STATUS = 'A' "
IF !EMPTY(MV_PAR09)
	_cQuery += "       AND UPPER(SC1->C1_MSAPROP) LIKE  '%" + UPPER(ALLTRIM(MV_PAR09)) + "%' SC1->C1_MSAPROP <> '                              ' "
ENDIF
_cQuery += "ORDER BY F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, E2_PARCELA "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","F1_EMISSAO","D",08,00)
TcSetField("QR1","F1_DTDIGIT","D",08,00)
TcSetField("QR1","F1_VALBRUT","N",12,02)
TcSetField("QR1","E2_VENCREA","D",08,00)
TcSetField("QR1","E2_VENCTO" ,"D",08,00)
TcSetField("QR1","E2_VALOR"  ,"N",12,02)

DO WHILE !QR1->(EOF())
	IF !TRB->(dbSeek(QR1->F1_DOC+QR1->F1_SERIE+QR1->F1_FORNECE+QR1->F1_LOJA+QR1->E2_PARCELA))
		RecLock("TRB",.T.)
		TB_TIPO		:= QR1->F1_TIPO
		TB_DOC		:= QR1->F1_DOC
		TB_SERIE	:= QR1->F1_SERIE
		TB_FORNECE	:= QR1->F1_FORNECE
		TB_LOJA		:= QR1->F1_LOJA
		TB_EMISSAO	:= QR1->F1_EMISSAO
		TB_DTDIGIT	:= QR1->F1_DTDIGIT
		TB_STATUS	:= QR1->F1_STATUS
		TB_VALBRUT	:= QR1->F1_VALBRUT
		TB_MSAPROP	:= QR1->APROP
		TB_PARCELA	:= QR1->E2_PARCELA
		TB_VALOR	:= QR1->E2_VALOR
		TB_VENCREA	:= QR1->E2_VENCREA
		TB_VENCTO	:= QR1->E2_VENCTO
		MSUNLOCK()
	ENDIF
	QR1->(dbSkip())
ENDDO
QR1->(dbCloseArea())

TRB->(dbGoTop())
_nTotal := 0
_cNomeF		:= ""
Do While !TRB->(Eof())
	If Li > 62
		cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
	ENDIF
	IF TRB->TB_TIPO $ "NIPC"
		_cNomeF := Posicione("SA2",1,xFilial("SA2")+TRB->TB_FORNECE+TRB->TB_LOJA,"A2_NOME")
	ELSE				
		_cNomeF := Posicione("SA1",1,xFilial("SA1")+TRB->TB_FORNECE+TRB->TB_LOJA,"A1_NOME")
	ENDIF	
	@ Li,000 PSAY TRB->TB_DOC
	@ Li,010 PSAY TRB->TB_SERIE
	@ Li,014 PSay TRB->TB_EMISSAO
	@ Li,024 PSAY TRB->TB_DTDIGIT
	@ Li,034 PSAY TRB->TB_FORNECE + "/" + TRB->TB_LOJA + "  " + SUBSTR(_cNomeF,1,28)
	@ Li,075 PSAY TRB->TB_VALBRUT PICTURE "@E 999,999,999.99"
	_nTotal += TRB->TB_VALBRUT
	_cFornece	:= TRB->TB_FORNECE
	_cLoja		:= TRB->TB_LOJA
	_cDoc		:= TRB->TB_DOC
	_cSerie     := TRB->TB_SERIE
	DO WHILE !TRB->(EOF()) .AND. TRB->TB_FORNECE == _cFornece .AND. TRB->TB_LOJA == _cLoja .AND. TRB->TB_DOC == _cDoc .AND. TRB->TB_SERIE == _cSerie
		If Li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
			@ Li,000 PSAY TRB->TB_DOC
			@ Li,010 PSAY TRB->TB_SERIE
			@ Li,014 PSay TRB->TB_EMISSAO
			@ Li,024 PSAY TRB->TB_DTDIGIT                               
			@ Li,034 PSAY TRB->TB_FORNECE + "/" + TRB->TB_LOJA + "  " + SUBSTR(_cNomeF,1,28)
			@ Li,075 PSAY TRB->TB_VALBRUT PICTURE "@E 999,999,999.99"
		EndIf
		@ Li,089 PSAY TRB->TB_VALOR  PICTURE "@E 999,999,999.99"
		IF !EMPTY(TRB->TB_VENCTO)
			@ Li,105 PSay TRB->TB_DOC + "/" + TRB->TB_PARCELA
			@ Li,120 PSay TRB->TB_VENCTO
		ENDIF	
		Li++
		TRB->(dbSkip())
	ENDDO
ENDDO
If Li > 62
	cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
	Li++
	@ Li,000 PSAY "VALOR TOTAL===============> "
	@ Li,068 PSAY _nTotal PICTURE "@E 999,999,999.99"
ELSE                     
	Li++
	@ Li,000 PSAY "VALOR TOTAL===============> "
	@ Li,068 PSAY _nTotal PICTURE "@E 999,999,999.99"
ENDIF

MS_FLUSH()

oTable:Delete()

Return