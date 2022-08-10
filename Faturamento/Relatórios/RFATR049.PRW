#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR049  ºAutor  ³Lizandra	Marques    º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Reescrito - Faturamento por dia                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Grupo Masipack                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR049()

PRIVATE titulo    := ""
PRIVATE cString   := "SF2"
PRIVATE wnrel     := "RFATR049"
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog  := "RFATR049"
PRIVATE _mpag     := 0
Private cPerg     := "XRFATR049A"
Private cArqCSV   := ""
Private cRegCSV   := ""
PRIVATE cArqTrab  := ""
PRIVATE cFilTrab  := ""
PRIVATE nLastKey  := 0
Private Li        := 99
PRIVATE CbTxt     := ""
PRIVATE cabec1    := ""
PRIVATE cabec2    := ""
PRIVATE tamanho   := "M"
PRIVATE limite    := 132
Private nTotSeg   := 0
Private nTotDia   := 0
Private nTotFat   := 0
Private nTotTipo  := 0
Private nTotMaq   := 0
Private nTotPecas := 0
Private nTotExp   := 0
Private nTotServ  := 0
Private nTotTerc  := 0
Private nTotOut   := 0
Private nOrdem    := 0
Private dDtEmiAnt := CTOD("")
Private cTpVenda  := ""
Private cSegmento := ""
Private lPrim     := .T.
titulo	:= "Faturamento por dia"
cDesc1	:= "Esse programa tem por finalidade imprimir o relatorio de"
cDesc2	:= "acordo com os parametrosdo usuário"

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

nOrdem := aReturn[8]

Titulo := "Faturamento por Data de Emissão   - Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)

cArqCSV := "C:\Relato_Microsiga\Faturamento_Diario.csv"
cabec1 := "EMISSAO    TIPO DE VENDA                   PEDIDO  CLIENTE                                    VALOR          N. FISCAL  UF  PAIS TIPO"
//         123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o123456789n123456789c123456789D123456789V123456789
/*
If (cArqCSV := FCreate(cArqCSV)) == -1
	Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
	cRegCSV := Titulo
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	cRegCSV := "DT.EMISSÃO;TIPO DE VENDA;PEDIDO;CLIENTE;VALOR"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
*/

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
EndIf

RptStatus({|| ImpRel()}, )

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpRel  ºAutor  ³Lizandra	           º Data ³  20/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reescrito - chamada do relatorio                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Grupo Masipack                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static FUNCTION ImpRel()

Local aCampos   := {}
Local oTable

IF Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()           
ENDIF

AADD(aCampos,{ "TB_NATUREZ","C",10,0 } )
AADD(aCampos,{ "TB_TOTAL"  ,"N",12,2 } )
AADD(aCampos,{ "TB_DESCRI" ,"C",30,0 })

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:AddIndex( "IND1", {"TB_NATUREZ"} )
oTable:Create()

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF

_cQUery := " SELECT DISTINCT F2_TIPO, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, "
_cQuery += "                 F2_EMISSAO, F2_VALFAT, A1_NREDUZ,  A1_EST,   "
_cQuery += "                 A1_PAIS, YA_DESCR, C5_NATUREZ, ED_DESCRIC,   "
_cQuery += "                 C5_NUM, F2_VALBRUT "
If  SubStr(cNumEmp,1,2) <> "15"
	_cQuery += "                 , C5_MSTPVEN  "
End If
_cQuery += " FROM " + RetSqlName("SF2") +  " F2 "
_cQuery += " INNER JOIN " + RetSqlName("SD2") + " D2 "
_cQuery += "       ON D2_DOC = F2_DOC AND D2_SERIE = D2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
_cQuery += "       AND D2_EMISSAO = F2_EMISSAO AND D2_DTDIGIT = F2_DTDIGIT "
_cQuery += "       AND D2_FILIAL = '" + xFilial("SD2") + "' AND D2.D_E_L_E_T_ = ' '   "
_cQuery += " INNER JOIN " + RetSqlName("SC5") + " C5 "
_cQuery += "       ON C5_NUM = D2_PEDIDO AND C5_FILIAL = '" + xFilial("SC5") + "' AND C5.D_E_L_E_T_ = ' '   "
_cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1  "
_cQuery += "       ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = F2_CLIENTE "
_cQuery += "       AND A1_LOJA = F2_LOJA AND A1.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlName("SYA") + " YA "
_cQuery += "       ON YA_FILIAL = '" + xFilial("SYA") + "' AND YA_CODGI = A1_PAIS AND YA.D_E_L_E_T_ = ' ' "
_cQuery += " INNER JOIN " + RetSqlName("SED") + " ED "
_cQuery += "       ON LTRIM(RTRIM(C5_NATUREZ)) = LTRIM(RTRIM(ED_CODIGO)) "
_cQuery += "       AND ED_FILIAL= '" + xFilial("SED") + "' AND ED.D_E_L_E_T_ = ' ' "     
_cQuery += " INNER JOIN " + RetSqlName("SF4") + " F4"
_cQuery += "       ON D2_TES = F4_CODIGO "
IF MV_PAR07 == 1
	_cQuery += " 	 AND F4_DUPLIC = 'S' "
ELSEIF MV_PAR07 == 2	
	_cQuery += " 	 AND F4_DUPLIC = 'N' "
ENDIF	
_cQuery += "       AND F4.D_E_L_E_T_ = ' ' AND F4_FILIAL= '" + xFilial("SF4") + "' "
_cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "' AND F2_TIPO = 'N' " //AND F2_DUPL <> '         ' "
_cQuery += "       AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "	    AND C5_NATUREZ BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " 
_cQuery += "	    AND F2_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
If  SubStr(cNumEmp,1,2) <> "15"
	_cQuery += "	    AND C5_MSTPVEN BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' " 
EndIf
_cQuery += "       AND F2.D_E_L_E_T_ = ' ' "

If MV_PAR10 == 1
	_cQuery += " UNION SELECT DISTINCT F2_TIPO, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA,F2_EMISSAO, F2_VALFAT, A1_NREDUZ,  A1_EST,"
	_cQuery += "A1_PAIS, YA_DESCR, C5_NATUREZ, ED_DESCRIC,C5_NUM, F2_VALBRUT "
	If  SubStr(cNumEmp,1,2) <> "15"
	_cQuery += "                 , C5_MSTPVEN  "
	EndIf
	_cQuery += " FROM " + RetSqlName("SF2") +  " F2 "
	_cQuery += " INNER JOIN " + RetSqlName("SD2") + " D2 "
	_cQuery += "       ON D2_DOC = F2_DOC AND D2_SERIE = D2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
	_cQuery += "       AND D2_EMISSAO = F2_EMISSAO AND D2_DTDIGIT = F2_DTDIGIT "
	_cQuery += "       AND D2_FILIAL = '" + xFilial("SD2") + "' AND D2.D_E_L_E_T_ = ' '   "
	_cQuery += " INNER JOIN " + RetSqlName("SC5") + " C5 "
	_cQuery += "       ON C5_NUM = D2_PEDIDO AND C5_FILIAL = '" + xFilial("SC5") + "' AND C5.D_E_L_E_T_ = ' '   "
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1  "
	_cQuery += "       ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = F2_CLIENTE "
	_cQuery += "       AND A1_LOJA = F2_LOJA AND A1.D_E_L_E_T_ = ' ' "
	_cQuery += " INNER JOIN " + RetSqlName("SYA") + " YA "
	_cQuery += "       ON YA_FILIAL = '" + xFilial("SYA") + "' AND YA_CODGI = A1_PAIS AND YA.D_E_L_E_T_ = ' ' "
	_cQuery += " INNER JOIN " + RetSqlName("SED") + " ED "
	_cQuery += "       ON LTRIM(RTRIM(C5_NATUREZ)) = LTRIM(RTRIM(ED_CODIGO)) "
	_cQuery += "       AND ED_FILIAL= '" + xFilial("SED") + "' AND ED.D_E_L_E_T_ = ' ' "     
	_cQuery += " INNER JOIN " + RetSqlName("SF4") + " F4"
	_cQuery += "       ON D2_TES = F4_CODIGO "
	_cQuery += "       AND F4.D_E_L_E_T_ = ' ' AND F4_FILIAL= '" + xFilial("SF4") + "' "
	_cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "' AND F2_TIPO = 'N' " //AND F2_DUPL <> '         ' "
	_cQuery += "       AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "	    AND C5_NATUREZ = 'V05.8     ' " 
	_cQuery += "	    AND F2_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " 
	If  SubStr(cNumEmp,1,2) <> "15"
		_cQuery += "	    AND C5_MSTPVEN BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' " 
	EndIf
	_cQuery += "       AND F2.D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY F2_EMISSAO, C5_NATUREZ "
Else
	_cQuery += " ORDER BY F2_EMISSAO, C5_NATUREZ "
EndIf
	
TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","F2_EMISSAO","D",08,00)
TcSetField("QR1","F2_VALFAT" ,"N",12,02)
TcSetField("QR1","F2_VALBRUT","N",12,02)


cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

lPrim  	 := .T.
_dEmissao := CTOD("")

DO WHILE QR1->(!EOF())
	
	_dEmissao := QR1->F2_EMISSAO
	_nTdia	 := 0
	IF Li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	ENDIF
	
	DO WHILE _dEmissao == QR1->F2_EMISSAO .AND. QR1->(!Eof())
		
		_cNaturez := QR1->C5_NATUREZ
		_nVParc	 := 0
		_cDescN	 := QR1->ED_DESCRIC		
		_cDoc		 := ""
		
		DO WHILE _cNaturez == QR1->C5_NATUREZ .AND. _dEmissao == QR1->F2_EMISSAO .AND. QR1->(!Eof())
			IF lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Exit
			ENDIF
			IF Li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			ENDIF
			
			IF lPrim
				lPrim := .F.
				@ Li,000 PSAY _dEmissao
				@ Li,012 PSAY _cDescN
			ENDIF
			IF QR1->F2_DOC == _cDoc 
				_cDoc		 := QR1->F2_DOC 
				QR1->(dbSkip())   
				Loop
			ENDIF	
			_cDoc		 := QR1->F2_DOC 
			@ Li,044 PSAY QR1->C5_NUM
			@ Li,052 PSAY QR1->F2_CLIENTE + "/" + QR1->F2_LOJA + "-" + QR1->A1_NREDUZ
			@ Li,095 PSAY IIF(QR1->F2_VALFAT>0,TRANSFORM(QR1->F2_VALFAT,"@E 999,999,999.99"),TRANSFORM(QR1->F2_VALBRUT,"@E 999,999,999.99"))
			@ Li,110 PSAY QR1->F2_DOC
			@ Li,120 PSAY QR1->A1_EST
			@ Li,125 PSAY QR1->A1_PAIS
			If  SubStr(cNumEmp,1,2) <> "15"
				@ Li,130 PSAY QR1->C5_MSTPVEN			
			EndIf
			_nVParc	 += IIF(QR1->F2_VALFAT>0,QR1->F2_VALFAT,QR1->F2_VALBRUT)
			_nTdia	 += IIF(QR1->F2_VALFAT>0,QR1->F2_VALFAT,QR1->F2_VALBRUT)
			dbSelectArea("TRB")
         IF !TRB->(dbSeek(_cNaturez))   
	         RecLock("TRB",.T.)
				TB_NATUREZ	:= _cNaturez
				TB_TOTAL		:= IIF(QR1->F2_VALFAT>0,QR1->F2_VALFAT,QR1->F2_VALBRUT)
				TB_DESCRI	:= _cDescN
			ELSE	
	         RecLock("TRB",.F.)
				TB_TOTAL		+= IIF(QR1->F2_VALFAT>0,QR1->F2_VALFAT,QR1->F2_VALBRUT)
			ENDIF	         
			TRB->(MsUnLock())
			QR1->(dbSkip())
			Li++
		ENDDO
		lPrim := .T.
		IF Li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		ENDIF
		@ Li,095 PSAY "______________"
		Li++
		@ Li,044 PSAY "TOTAL " + _cDescN + "============>"
		@ Li,095 PSAY TRANSFORM(_nVParc,"@E 999,999,999.99")
		Li += 2
	ENDDO
	IF Li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	ENDIF
	@ Li,044 PSAY "TOTAL POR DIA ====>" 
	@ Li,095 PSAY TRANSFORM(_nTdia,"@E 999,999,999.99")
	Li += 2               
	@ Li,000 Psay __PrtFatLine()
   Li++
ENDDO

QR1->(dbCloseArea())

TRB->(dBGotop())

//VICTOR DESSUNTE - 08/02/2017
//INICIO - TICKET:2017020837000051                               
//IF Li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
//ENDIF
//FIM - TICKET:2017020837000051
Li++
@ Li,044 PSAY "T O T A L     G E R A L " 
Li += 2               
_nTotG	:= 0 
DO WHILE TRB->(!EOF())
	@ Li,044 PSAY TRB->TB_DESCRI + "======> " +  TRANSFORM(TRB->TB_TOTAL,"@E 999,999,999.99")
	Li ++
	_nTotG	+= TRB->TB_TOTAL
	TRB->(dbSkip())
ENDDO		
@ Li,082 PSAY "______________"
Li ++
@ Li,082 PSAY  TRANSFORM(_nTotG,"@E 999,999,999.99")
Li ++
@ Li,000 Psay __PrtFatLine()

TRB->(dbCloseArea())

Set Device To Screen

IF aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
ENDIF

MS_FLUSH()

Return
