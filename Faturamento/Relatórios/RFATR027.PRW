#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATR027  ºAutor  ³AParecida F. Stevanatoº Data ³ 31/08/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao de Acompanhamento do Pedido            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Reescrito - Lizandra - 09/07/13
*/

User Function RFATR027()

Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2      := "de Acompanhamento de Pedidos"
Private cDesc3      := ""
Private titulo      := "Acompanhamento de Pedidos de Venda"
Private aOrd        := {"Por Pedido","Por Depto. Origem","Por Depto. Destino","Por Previsão de Entrega","Por Cliente","Por Entrega Original"}
Private _nLin       := 80
Private nOrdem      := 1
Private Cabec1      := ""
Private Cabec2      := ""
Private lEnd        := .F.
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RFATR027"
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private wnrel       := "RFATR027"
Private cPerg		  := "XRFATR027 "
Private m_pag       := 1
Private X           := 0
Private cPedAnt     := ""
Private cTecAnt     := ""
Private cDepOri     := ""
Private cDepDes     := ""
Private cPos        := ""
Private nTarefa     := 0
Private cVendedor   := ""
Private cContrato   := ""
Private cArqCSV     := "C:\Relato_Microsiga\Acompanhamento_PV.csv"
Private cRegCSV     := ""
Private dDtEntPV    := CTOD("")
Private cLogCom     := ""
Private cLogEng     := ""
Private cLogProd    := ""
Private cLogMont    := ""
Private cLogTest    := ""
Private cLogObs     := ""
Private nLogCom     := 0
Private nLogEng     := 0
Private nLogProd    := 0
Private nLogMont    := 0
Private nLogTest    := 0
Private nLogObs     := 0
Private nVlrPed     := 0
Private nVlrTot     := 0
Private aValor      := {}

Pergunte(cPerg,.F.)

MV_PAR03 := Upper(MV_PAR03)
MV_PAR04 := Upper(MV_PAR04)
MV_PAR07 := Upper(MV_PAR07)
MV_PAR08 := Upper(MV_PAR08)
MV_PAR09 := Upper(MV_PAR09)
MV_PAR11 := Upper(MV_PAR11)
MV_PAR15 := Upper(MV_PAR15)


Private cString := "SZM"

dbSelectArea("SZM")

wnrel:=SetPrint(cString,NomeProg,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

RptStatus({|lEnd| _fImpRel(@lEnd,wnRel,cString,Tamanho)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fImpRel  ºAutor  ³Aparecida F.Stevanato  º Data ³  29/10/03  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao do relatorio.                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fImpRel()

Local aSX5ZF	:= {}
Local aSX5ZE	:= {}
Local cDepOri	:= ""
Local cDepDes	:= ""
Local nX		:= 0
Local X

/*
DBSelectArea("SX5")
SX5->(DbSetOrder(1))
SX5->(DbGotop())
If SX5->(DbSeek("  ZF"))
	Do While ! SX5->(Eof()) .And. SX5->X5_TABELA == "ZF"
		If SX5->X5_CHAVE == mv_par07
			cDepOri := SubStr(Alltrim(Upper(SX5->X5_DESCRI)),1,20)
		EndIf
		If SX5->X5_CHAVE == mv_par08
			cDepDes := SubStr(Alltrim(Upper(SX5->X5_DESCRI)),1,20)
		EndIf
		SX5->(DBSkip())
		Loop
	EndDo
EndIf
*/

aSX5ZF := FwGetSX5('ZF')
For nX := 1 To Len(aSX5ZF)
	IF MV_PAR07 == aSX5ZF[nX,3]
		cDepOri := SubStr(Alltrim(aSX5ZF[nX,4]),1,20)
	ENDIF

	IF MV_PAR08 == aSX5ZF[nX,3]
		cDepOri := SubStr(Alltrim(aSX5ZF[nX,4]),1,20)
	ENDIF
Next nX

If (cArqCSV := FCreate("C:\Relato_Microsiga\Acompanhamento_PV.csv")) == -1
	Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
	If mv_par15 == "LOGAPV"
		cRegCSV := "Acompanhamento de PV - Log da Reunião em: " + DTOC(Date()) + " - Periodo de: " + DTOC(mv_par01) + " à " + DTOC(mv_par02)
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		cRegCSV := ""
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		cRegCSV := "Pedido;Eng.;Multa;Cliente;Vendedor;Entrega Original;Entrega Prevista;Inicio da Montagem;Comercial;Engenharias;PCP/Produção;Montagem;Testes;Obs;Listas Separadas;Contrato;Emissão do Contrato;Vlr.Pedido"
	Else
		cRegCSV := "Relação do Acompanhamento de PV - emitida em " + DTOC(Date()) + " - Periodo de: " + DTOC(mv_par01) + " à " + DTOC(mv_par02)
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		cRegCSV := ""
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		cRegCSV := "Pedido;Contrato;Cliente;Vendedor;Data Evento;Assunto;Prev.Entrega;Data Conclusão;Concluido por;Depto.Origem;Usuario;Depto.Destino;Status;Ent.Original;Ent.Prevista"
	EndIf
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf

nOrdem  := aReturn[8]

ImpParam() // Imprime parametros escolhidos pelo usuario.


If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := " SELECT ZM_DATA, ZM_ASSUNTO, ZM_LIDO, ZM_ACEITE, ZM_PEDIDO, ZM_DTPREV, ZM_DEPTO, "
_cQuery += "         ZM_DEPTDES, ZM_CLIENTE, ZM_STATUS, ZM_CODTEC, ZM_MSUSER, ZM_ULTALT, ZM_DTCOM, "
_cQuery += "         ZM_USUACEI, ZM_DTACEIT, ZM_USUALTE, ZM_DTLIDO, "
_cQuery += "         ZM_USULIDO, ZM_ENTLOG, ZM_PREVLOG, ZM_INIMONT, ZM_DTENG, "
_cQuery += "         ZM_DTPROD, ZM_DTMONT, ZM_DTTEST, ZM_RESUMO, "
_cQuery += "         ZM_CODCLI, ZM_PREVLOG, ZM_COPIA, ZM_NOASSUN, "
_cQuery += "         C5_MSVLPED, C5_MOEDA, C5_VEND1, C5_MSDTPEN, C5_MSDTENT, C5_MSENG, C5_ORCAM, "
_cQuery += "         A3_NREDUZ, "
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_EVENTO)),'') AS EVENTO,   "
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_LOGTEST)),'') AS LOGTEST, "  
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_OBS)),'') AS OBS, "   
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_LOGENG)),'') AS LOGENG, "   
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_LOGMONT)),'') AS LOGMONT, "  
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_LOGCOM)),'') AS LOGCOM, "  
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_LOGPROD)),'') AS LOGPROD, "   
_cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),ZM_COMENT)),'') AS COMENT "  
_cQuery += " FROM " + RetSqlname("SZM") + " ZM "
_cQuery += " INNER JOIN " + RetSqlname("SC5") + " C5 "
_cQuery += "       ON C5_NUM = ZM_PEDIDO "
_cQuery += " INNER JOIN " + RetSqlName("SA3") + " A3 "
_cQuery += "       ON C5_VEND1 = A3_COD "
_cQuery += "WHERE ZM_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
_cQuery += "      AND ZM_PEDIDO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
_cQuery += "      AND ZM_FILIAL = '" +xFilial("SZM") +"' AND ZM.D_E_L_E_T_ = ' ' "
_cQuery += "      AND C5_FILIAL = '" +xFilial("SC5") +"' AND C5.D_E_L_E_T_ = ' ' "
_cQuery += "      AND A3_FILIAL = '" +xFilial("SA3") +"' AND A3.D_E_L_E_T_ = ' ' "
_cQuery += "      AND ZM_DTPREV BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "
//IF !EMPTY(cDepOri)
//	_cQuery += "      AND ZM_DEPTO = '" + MV_PAR07 + "' "
//ENDIF
//IF !EMPTY(cDepDes)
//	_cQuery += "      AND ZM_DEPTDES = '" + MV_PAR08 + "' "
//ENDIF
IF !EMPTY(cDepOri)
	_cQuery += "      AND ZM_DEPTO = '" + cDepOri + "' "
ENDIF
IF !EMPTY(cDepDes)
	_cQuery += "      AND ZM_DEPTDES = '" + cDepDes + "' "
ENDIF
IF EMPTY(MV_PAR09) .OR. SUBSTR(MV_PAR09,1,3) == "ZZZ"
	_cQuery += " AND ZM_CLIENTE BETWEEN '      ' AND 'ZZZZZZ' "
ELSE
	_cQuery += " AND ZM_CLIENTE = '" + MV_PAR09 + "' "
ENDIF
IF EMPTY(MV_PAR15) .OR. SUBSTR(MV_PAR15,1,3) == "ZZZ"
	_cQuery += " AND ZM_ASSUNTO BETWEEN '      ' AND 'ZZZZZZ' "
ELSE
	_cQuery += " AND ZM_ASSUNTO = '" + MV_PAR15 + "' "
ENDIF
IF EMPTY(MV_PAR11) .OR. SUBSTR(MV_PAR11,1,3) == "ZZZ"
	_cQuery += " AND C5_VEND1 BETWEEN '      ' AND 'ZZZZZZ' "
ELSE
	_cQuery += " AND C5_VEND1 = '" + MV_PAR11 + "' "
ENDIF
IF MV_PAR12 == 1
	_cQuery += " AND ZM_LIDO = 'T'  "
ENDIF
IF MV_PAR16 == 1
	_cQuery += " AND ZM_ACEITE = 'T' "
ENDIF
IF MV_PAR10 == 1
	_cQuery += " AND ZM_STATUS = 'A' "
ELSEIF MV_PAR10 == 2
	_cQuery += " AND ZM_STATUS = 'P' "
ELSEIF MV_PAR10 == 3
	_cQuery += " AND ZM_STATUS = 'E' "
ELSEIF MV_PAR10 == 5
	_cQuery += " AND ZM_STATUS <> 'E' "
ENDIF
IF nOrdeM == 1
	_cQuery += " ORDER BY ZM_PEDIDO "
ELSEIF nOrdeM == 2
	_cQuery += " ORDER BY ZM_DEPTO, ZM_PEDIDO "
ELSEIF nOrdeM == 3
	_cQuery += " ORDER BY ZM_DEPTDES, ZM_PEDIDO "
ELSEIF nOrdeM == 4
	_cQuery += " ORDER BY ZM_DTPREV, ZM_PEDIDO "
ELSEIF nOrdeM == 4
	_cQuery += " ORDER BY ZM_CLIENTE, ZM_PEDIDO "
ELSE
	_cQuery += " ORDER BY ZM_ENTLOG, ZM_PEDIDO "
ENDIF

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","ZM_DATA"   ,"D",08,00)
TcSetField("QR1","ZM_DTPREV" ,"D",08,00)
TcSetField("QR1","ZM_ULTALT" ,"D",08,00)
TcSetField("QR1","ZM_DTCOM"  ,"D",08,00)
TcSetField("QR1","ZM_DTACEIT","D",08,00)
TcSetField("QR1","ZM_DTLIDO" ,"D",08,00)
TcSetField("QR1","ZM_DTENG"  ,"D",08,00)
TcSetField("QR1","ZM_DTPROD" ,"D",08,00)
TcSetField("QR1","ZM_DTMONT" ,"D",08,00)
TcSetField("QR1","ZM_DTTEST" ,"D",08,00)
TcSetField("QR1","C5_MSDTPEN","D",08,00)
TcSetField("QR1","C5_MSDTENT","D",08,00)
TcSetField("QR1","C5_MSVLPED","N",12,02)

QR1->(DbGoTop())

SetRegua(RecCount())

Do While !QR1->(EOF())
	
	
	If lEnd
		@_nLin,000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	cVendedor := "Não cadastrado"
	
	nVlrPed := QR1->C5_MSVLPED
	
	If QR1->C5_MOEDA > 1  .And. QR1->C5_MSVLPED > 0
		aValor  := FuncaMoeda(Date(),QR1->C5_MSVLPED,QR1->C5_MOEDA)
		nVlrPed := aValor[1]
	EndIf
	nVlrTot += nVlrPed
	
	If !Empty(QR1->C5_MSDTPEN)
		dDtEntPV := QR1->C5_MSDTPEN
	Else
		dDtEntPV := QR1->C5_MSDTENT
	EndIf

	cVendedor :=  SubStr(QR1->A3_NREDUZ,1,15)
	
	_nLin++
	If _nLin > 62
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,)
		_nLin := 6
	EndIf
	
	If Alltrim(QR1->ZM_PEDIDO) <> Alltrim(cPedAnt)
		If cPedAnt <> ""
			ImpRodaPedido()
		EndIf
		@ _nLin,000 Psay "Pedido: " + QR1->ZM_PEDIDO
		@ _nLin,016 Psay "Cliente: " + QR1->ZM_CODCLI + "-" + SubStr(QR1->ZM_CLIENTE,1,20)
		@ _nLin,067 Psay "Vendedor...: " + SubStr(cVendedor,1,14)
		_nLin+=2
		cPedAnt := QR1->ZM_PEDIDO
		cTecAnt := QR1->ZM_CODTEC
		nTarefa := 0
	EndIf
	
	If nTarefa > 0
		@ _nLin,008 Psay Replicate("-",124)
		_nLin++
	EndIf
	@ _nLin,008 Psay "Status:"
	If QR1->ZM_STATUS == "A"
		@ _nLin,016 Psay "Aberto"
	ElseIf QR1->ZM_STATUS == "P"
		@ _nLin,016 Psay "Em Processo"
	ElseIf QR1->ZM_STATUS == "E"
		@ _nLin,016 Psay "Encerrado"
	ElseIf QR1->ZM_STATUS == "R"
		@ _nLin,016 Psay "Reavaliar"
	EndIf
	_nLin+=2
	@ _nLin,008 Psay "De....: " + QR1->ZM_DEPTO
	@ _nLin,040 Psay "Emitente...: " + SubStr(QR1->ZM_MSUSER,1,13)
	@ _nLin,067 Psay "Emissão: " + DTOC(QR1->ZM_DATA)
	@ _nLin,086 Psay "Ult.Atualização: "
	If !Empty(QR1->ZM_ULTALT)
		@ _nLin,103 Psay DTOC(QR1->ZM_ULTALT) + " - " + Alltrim(QR1->ZM_USUALTE)
	EndIf
	_nLin+=2
	@ _nLin,008 Psay "Para..: " + QR1->ZM_DEPTDES
	@ _nLin,040 Psay "Resposta p/: " + DTOC(QR1->ZM_DTPREV)
	If QR1->ZM_STATUS == "E"
		@ _nLin,067 Psay "Tarefa realizada: "
		If (QR1->ZM_DTPREV - QR1->ZM_ULTALT) >= 0
			@ _nLin,085 Psay "No prazo"
		Else
			@ _nLin,085 Psay "com "
			@ _nLin,089 Psay Abs(QR1->ZM_DTPREV - QR1->ZM_ULTALT) Picture "@E 99"
			@ _nLin,093 Psay "dia(s) de atraso"
		EndIf
	EndIf
	If QR1->ZM_COPIA == "T"
		@ _nLin,114 Psay "Copia.: Sim"
	Else
		@ _nLin,114 Psay "Copia.: Não"
	EndIf
	
	If !Empty(Alltrim(QR1->EVENTO))
		nTarefa++
		_nLin+=2
		If _nLin > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			_nLin := 6
			@ _nLin,000 Psay QR1->ZM_PEDIDO
			@ _nLin,008 Psay "Assunto..: "
			If !Empty(QR1->ZM_DTLIDO)
				@ _nLin,067 Psay "Lido em: " + DTOC(QR1->ZM_DTLIDO) + " Usuario: " + QR1->ZM_USULIDO
			EndIf
			IF !EMPTY(QR1->ZM_DTACEIT)
				@ _nLin,110 PSAY "Concluido em: " + DTOC(QR1->ZM_DTACEIT)
			ENDIF
/*
			SX5->(DbGotop())
			IF SX5->(DbSeek(xFilial("SX5")+"ZE"+QR1->ZM_ASSUNTO))
				@ _nLin,019 Psay Alltrim(SX5->X5_DESCRI)
			EndIf
*/
			aSX5ZE := FwGetSX5('ZE', QR1->ZM_ASSUNTO)
			IF Len(aSX5ZE) > 0 .And. !Empty(aSX5ZE[1,4])
				@ _nLin,019 Psay aSX5ZE[1,4]
			ENDIF

			_nLin+=2
			@ _nLin,008 Psay "Tarefa...: "
		Else
			@ _nLin,008 Psay "Assunto..: "
			If !Empty(QR1->ZM_DTLIDO)
				@ _nLin,067 Psay "Lido em: " + DTOC(QR1->ZM_DTLIDO) + " Usuario: " + QR1->ZM_USULIDO
			EndIf
/*			
			SX5->(DbGotop())
			IF SX5->(DbSeek(xFilial("SX5")+"ZE"+QR1->ZM_ASSUNTO))
				@ _nLin,019 Psay Alltrim(SX5->X5_DESCRI)
			EndIf
*/
			aSX5ZE := FwGetSX5('ZE', QR1->ZM_ASSUNTO)
			IF Len(aSX5ZE) > 0 .And. !Empty(aSX5ZE[1,4])
				@ _nLin,019 Psay aSX5ZE[1,4]
			ENDIF

			_nLin+=2
			@ _nLin,008 Psay "Tarefa...: "
		EndIf
		For X := 1 TO MLCOUNT(Alltrim(QR1->EVENTO),80)
			If _nLin > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				_nLin := 6
				@ _nLin, 000 Psay QR1->ZM_PEDIDO
				@ _nLin, 008 Psay "Tarefa...: "
			EndIf
			@ _nLin,019 PSAY MEMOLINE(Alltrim(QR1->EVENTO),80,X)
			_nLin++
		Next
	EndIf
	
	If !Empty(Alltrim(QR1->COMENT))
		If _nLin > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			_nLin := 6
			@ _nLin, 000 Psay QR1->ZM_PEDIDO
			@ _nLin, 008 Psay "Comentario do Destino: "
		Else
			_nLin++
			@ _nLin, 008 Psay "Comentario do Destino: "
		EndIf
		For X := 1 TO MLCOUNT(Alltrim(QR1->COMENT),80)
			If _nLin > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				_nLin := 6
				@ _nLin, 000 Psay QR1->ZM_PEDIDO
				@ _nLin, 008 Psay "Comentario do Destino: "
			EndIf
			@ _nLin,031 PSAY MEMOLINE(Alltrim(QR1->COMENT),80,X)
			_nLin++
		Next
		If !Empty(QR1->ZM_DTACEIT)
			_nLin++
			@ _nLin,008 PSAY "Data da Conclusão....: "+ DTOC(QR1->ZM_DTACEIT) + "   Usuario: "+ QR1->ZM_USUACEI
			_nLin++
		EndIf
	EndIf
	//If mv_par15 == "LOGAPV"
	If QR1->ZM_ASSUNTO == "LOGAPV"
		_nLin++
		@ _nLin, 008 Psay "Datas na Geração do Log => Entrega Original: " + DTOC(QR1->ZM_ENTLOG)
		@ _nLin, 070 Psay "Entrega Prevista: " + DTOC(QR1->ZM_PREVLOG)
		@ _nLin, 100 Psay "Inicio da Montagem: " + DTOC(QR1->ZM_INIMONT)
		_nLin++
	EndIf
	If !Empty(QR1->LOGCOM)
		_nLin++
		If _nLin > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			@ _nLin, 000 Psay QR1->ZM_PEDIDO
			@ _nLin, 008 Psay "Log Reunião - Comercial..: "
		Else
			@ _nLin, 008 Psay "Log Reunião - Comercial.: "
		EndIf
		For X := 1 TO MLCOUNT(Alltrim(QR1->LOGCOM),80)
			If _nLin > 68
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				@ _nLin, 000 Psay QR1->ZM_PEDIDO
				@ _nLin, 008 Psay "Log Reunião - Comercial..: "
			EndIf
			@ _nLin,035 PSAY MEMOLINE(Alltrim(QR1->LOGCOM),80,X)
			_nLin++
		Next
		If !Empty(QR1->ZM_DTCOM)
			_nLin++
			@ _nLin,008 Psay "Data Prevista: "+ DTOC(QR1->ZM_DTCOM)
			_nLin++
		EndIf
	EndIf
	If !Empty(QR1->LOGENG)
		_nLin++
		If _nLin > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			@ _nLin, 000 Psay QR1->ZM_PEDIDO
			@ _nLin, 008 Psay "Log Reunião - Engenharia: "
		Else
			@ _nLin, 008 Psay "Log Reunião - Engenharia: "
		EndIf
		For X := 1 TO MLCOUNT(Alltrim(QR1->LOGENG),80)
			If _nLin > 68
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				@ _nLin, 000 Psay QR1->ZM_PEDIDO
				@ _nLin, 008 Psay "Log Reunião - Engenharia: "
			EndIf
			@ _nLin,035 PSAY MEMOLINE(Alltrim(QR1->LOGENG),80,X)
			_nLin++
		Next
		If !Empty(QR1->ZM_DTENG)
			_nLin++
			@ _nLin,008 Psay "Data Prevista: "+ DTOC(QR1->ZM_DTENG)
			_nLin++
		EndIf
	EndIf
	If !Empty(QR1->LOGPROD)
		_nLin++
		If _nLin > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			@ _nLin, 000 Psay QR1->ZM_PEDIDO
			@ _nLin, 008 Psay "Log Reunião - PCP/Prod..: "
		Else
			@ _nLin, 008 Psay "Log Reunião - PCP/Prod..: "
		EndIf
		For X := 1 TO MLCOUNT(Alltrim(QR1->LOGPROD),80)
			If _nLin > 68
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				@ _nLin, 000 Psay QR1->ZM_PEDIDO
				@ _nLin, 008 Psay "Log de Reunião - PCP/Prod..: "
			EndIf
			@ _nLin,035 PSAY MEMOLINE(Alltrim(QR1->LOGPROD),80,X)
			_nLin++
		Next
		If !Empty(QR1->ZM_DTPROD)
			_nLin++
			@ _nLin,008 Psay "Data Prevista: "+ DTOC(QR1->ZM_DTPROD)
			_nLin++
		EndIf
	EndIf
	If !Empty(QR1->LOGMONT)
		_nLin++
		If _nLin > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			@ _nLin, 000 Psay QR1->ZM_PEDIDO
			@ _nLin, 008 Psay "Log Reunião - Montagem..: "
		Else
			@ _nLin, 008 Psay "Log Reunião - Montagem..: "
		EndIf
		For X := 1 TO MLCOUNT(Alltrim(QR1->LOGMONT),80)
			If _nLin > 68
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				@ _nLin, 000 Psay QR1->ZM_PEDIDO
				@ _nLin, 008 Psay "Log de Reunião - Montagem..: "
			EndIf
			@ _nLin,035 PSAY MEMOLINE(Alltrim(QR1->LOGMONT),80,X)
			_nLin++
		Next
		If !Empty(QR1->ZM_DTMONT)
			_nLin++
			@ _nLin,008 Psay "Data Prevista: "+ DTOC(QR1->ZM_DTMONT)
			_nLin++
		EndIf
	EndIf
	If !Empty(QR1->LOGTEST)
		_nLin++
		If _nLin > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			@ _nLin, 000 Psay QR1->ZM_PEDIDO
			@ _nLin, 008 Psay "Log Reunião - Testes....: "
		Else
			@ _nLin, 008 Psay "Log Reunião - Testes....: "
		EndIf
		For X := 1 TO MLCOUNT(Alltrim(QR1->LOGTEST),80)
			If _nLin > 68
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				@ _nLin, 000 Psay QR1->ZM_PEDIDO
				@ _nLin, 008 Psay "Log de Reunião - Testes....: "
			EndIf
			@ _nLin,035 PSAY MEMOLINE(Alltrim(QR1->LOGTEST),80,X)
			_nLin++
		Next
		If !Empty(QR1->ZM_DTTEST)
			_nLin++
			@ _nLin,008 Psay "Data Prevista: "+ DTOC(QR1->ZM_DTTEST)
			_nLin++
		EndIf
	EndIf
	//EndIf
	If mv_par15 == "LOGAPV"
		cLogCom  := ""
		cLogEng  := ""
		cLogProd := ""
		cLogMont := ""
		cLogTest := ""
		cLogObs  := ""
		If !Empty(QR1->LOGCOM)
			For X := 1 TO MLCOUNT(Alltrim(QR1->LOGCOM),80)
				cLogCom += " " + Alltrim(MEMOLINE(QR1->LOGCOM,80,X))
			Next
			cLogCom := StrTran(cLogCom,";",".")
			cLogCom := SubStr(cLogCom,1,250)
			nLogCom++
		EndIf
		If !Empty(QR1->LOGENG)
			For X := 1 TO MLCOUNT(Alltrim(QR1->LOGENG),80)
				cLogEng += " " + Alltrim(MEMOLINE(QR1->LOGENG,80,X))
			Next
			cLogEng := StrTran(cLogEng,";",".")
			cLogEng := SubStr(cLogEng,1,250)
			nLogEng++
		EndIf
		If !Empty(QR1->LOGPROD)
			For X := 1 TO MLCOUNT(Alltrim(QR1->LOGPROD),80)
				cLogProd += " " + Alltrim(MEMOLINE(QR1->LOGPROD,80,X))
			Next
			cLogProd := StrTran(cLogProd,";",".")
			cLogProd := SubStr(cLogProd,1,250)
			nLogProd++
		EndIf
		If !Empty(QR1->LOGMONT)
			For X := 1 TO MLCOUNT(Alltrim(QR1->LOGMONT),80)
				cLogMont += " " + Alltrim(MEMOLINE(QR1->LOGMONT,80,X))
			Next
			cLogMont := StrTran(cLogMont,";",".")
			cLogMont := SubStr(cLogMont,1,250)
			nLogMont++
		EndIf
		If !Empty(QR1->LOGTEST)
			For X := 1 TO MLCOUNT(Alltrim(QR1->LOGTEST),80)
				cLogTest += " " + Alltrim(MEMOLINE(QR1->LOGTEST,80,X))
			Next
			cLogTest := StrTran(cLogTest,";",".")
			cLogTest := SubStr(cLogTest,1,250)
			nLogTest++
			
		EndIf
		If !Empty(QR1->OBS)
			For X := 1 TO MLCOUNT(Alltrim(QR1->OBS),80)
				cLogObs += " " + Alltrim(MEMOLINE(QR1->OBS,80,X))
			Next
			cLogObs := StrTran(cLogObs,";",".")
			cLogObs := SubStr(cLogObs,1,250)
			nLogObs++
		EndIf
		cRegCSV := QR1->ZM_PEDIDO+";"+QR1->C5_MSENG+";"+QR1->C5_MSMULTA+";"+QR1->ZM_CODCLI+"-"+QR1->ZM_CLIENTE+";"+Alltrim(QR1->C5_VEND1)+"-"+cVendedor+";"+Dtoc(QR1->ZM_ENTLOG)+";"+Dtoc(QR1->ZM_PREVLOG)+";"+Dtoc(QR1->ZM_INIMONT)+";"+cLogCom+";"+cLogEng+";"+cLogProd+";"+cLogMont+";"+cLogTest+";"+cLogObs+";"+QR1->COMENT+";"+QR1->C5_ORCAM+";"+Dtoc(QR1->C5_MSDTCE)+";"+Transform(nVlrPed,"@E 999,999,999,999.99")
	Else
		cRegCSV := QR1->ZM_PEDIDO+";"+QR1->C5_ORCAM+";"+QR1->ZM_CLIENTE+";"+cVendedor+";"+Dtoc(QR1->ZM_DATA)+";"+QR1->ZM_NOASSUN+" "+QR1->ZM_RESUMO+";"+Dtoc(QR1->ZM_DTPREV)+";"+Dtoc(QR1->ZM_DTACEIT)+";"+QR1->ZM_USUACEI+";"+QR1->ZM_DEPTO+";"+QR1->ZM_MSUSER+";"+QR1->ZM_DEPTDES+";"+QR1->ZM_STATUS+";"+Dtoc(QR1->C5_MSDTENT)+";"+Dtoc(QR1->C5_MSDTPEN)
	EndIf
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	QR1->(DbSkip())
EndDo


If mv_par15 == "LOGAPV"
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	cRegCSV := ";;;;Total de Logs =>;;;;"+Str(nLogCom,3)+";"+Str(nLogEng,3)+";"+Str(nLogProd,3)+";"+Str(nLogMont,3)+";"+Str(nLogTest,3)+";"+Str(nLogObs,3)+";;;;"+Transform(nVlrTot,"@E 999,999,999,999.99")
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf

ImpRodaPedido()

QR1->(dbCloseArea())

FClose(cArqCSV)

Set Device to Screen

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpRodaPedido  ºAutor  ³Microsiga      º Data ³  09/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpRodaPedido()

Local X

If _nLin > 62
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	_nLin := 6
EndIf
@ _nLin,008 Psay Replicate("-",124)
_nLin++

SC5->(DbSetorder(1))
If SC5->(DBSeek(xFilial("SC5")+cPedAnt))
	If _nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		_nLin := 6
	EndIf
	cPos := ""
	If !Empty(SC5->C5_MSPOSIC)
		cPos :=  Alltrim(SC5->C5_MSPOSIC) + " "
	EndIf
	If !Empty(SC5->C5_MSCONCL)
		cPos += "Pedido enviado para expedição em: " + DTOC(SC5->C5_MSCONCL)
	EndIf
	If cPos <> ""
		@_nLin,008 Psay "Posição....: " + cPos
		_nLin++
	EndIf
	If !Empty(SC5->C5_MSDTPEN)
		@_nLin,008 Psay "Dt.Entrega.: "+ DTOC(SC5->C5_MSDTPEN)
	Else
		@_nLin,008 Psay "Dt.Entrega.: "+ DTOC(SC5->C5_MSDTENT)
	EndIf
	_nLin++
	If !Empty(SC5->C5_MSVISIT) .AND. SC5->C5_MSVISIT == "S"
		@_nLin,008 Psay "Visita.....: SIM"
		_nLin++
	EndIf
	If !Empty(SC5->C5_MSMULTA) .AND. SC5->C5_MSMULTA == "S"
		@_nLin,008 Psay "Multa......: SIM"
		_nLin++
	EndIf
	If !Empty(SC5->C5_PC)
		@_nLin,008 Psay "Ped.Cliente: " + SC5->C5_PC
		_nLin++
	EndIf
	@_nLin,008 Psay "Contrato...: " + SC5->C5_ORCAM
	_nLin++
	If !Empty(cTecAnt)
		If AA1->(DbSeek(xFilial("AA1")+cTecAnt))
			@_nLin,008 Psay "Tecnico....: " + cTecAnt + " - " + AA1->AA1_NOMTEC
			_nLin++
		EndIf
	EndIf
	If mv_par13 == 1 .And. !Empty(Alltrim(SC5->C5_MSPEND))
		If _nLin > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			_nLin := 6
			@_nLin,000 Psay cPedAnt
			@_nLin,008 Psay "Pendências.: "
		Else
			@_nLin,008 Psay "Pendências.: "
		EndIf
		FOR X := 1 TO MLCOUNT(Alltrim(SC5->C5_MSPEND),80)
			If _nLin > 62
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				_nLin := 6
				@_nLin,000 Psay cPedAnt
				@_nLin,008 Psay "Pendências.: "
			EndIf
			@_nLin,021 PSAY MEMOLINE(Alltrim(SC5->C5_MSPEND),80,X)
			_nLin++
		NEXT
	EndIf
	If mv_par14 == 1 .And. !Empty(Alltrim(SC5->C5_OBS))
		If _nLin > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			_nLin := 6
			@_nLin,000 Psay cPedAnt
			@_nLin,008 Psay "Observações: "
		Else
			@_nLin,008 Psay "Observações: "
		EndIf
		FOR X := 1 TO MLCOUNT(Alltrim(SC5->C5_OBS),80)
			If _nLin > 62
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				_nLin := 6
				@_nLin,000 Psay cPedAnt
				@_nLin,008 Psay "Observações: "
			EndIf
			@_nLin,021 PSAY MEMOLINE(Alltrim(SC5->C5_OBS),80,X)
			_nLin++
		NEXT
	EndIf
EndIf
nTarefa := 0
@ _nLin,000 Psay Replicate("*",132)
_nLin++
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpParam  ºAutor  ³Microsiga           º Data ³  09/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpParam()

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
_nLin:= 10
@_nLin,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
_nLin+=2
@_nLin,000 Psay "Data de Emissão de..: " + DTOC(mv_par01)
@_nLin,037 Psay  "ate: " + DTOC(mv_par02)
_nLin++
@_nLin,000 Psay "Pedido de...........: " + mv_par03
@_nLin,037 Psay "ate: " + mv_par04
_nLin++
@_nLin,000 Psay "Previsão Entrega de.: " + DTOC(mv_par05)
@_nLin,037 Psay  "ate: " + DTOC(mv_par06)
_nLin++
If Alltrim(mv_par07) == "" .Or. Substr(mv_par07,1,3) == "ZZZ"
	@_nLin,000 Psay "Depto. Origem.......: Todos"
Else
	@_nLin,000 Psay "Depto. Origem.......: " + mv_par07
EndIf
_nLin++
If Alltrim(mv_par08) == "" .Or. Substr(mv_par08,1,3) == "ZZZ"
	@_nLin,000 Psay "Depto. Destino......: Todos"
Else
	@_nLin,000 Psay "Depto. Destino......: " + mv_par08
EndIf
_nLin++
If Alltrim(mv_par09) == "" .Or. Substr(mv_par09,1,3) == "ZZZ"
	@_nLin,000 Psay "Cliente.............: Todos"
Else
	@_nLin,000 Psay "Cliente.............: " + mv_par09
EndIf
_nLin++
@_nLin,000 Psay "Quais...............: "
Do Case
	Case  mv_par10 == 1
		@_nLin,022 Psay "Aberto"
	Case mv_par10 == 2
		@_nLin,022 Psay "Em Processo"
	Case mv_par10 == 3
		@_nLin,022 Psay "Encerrado"
	Case mv_par10 == 4
		@_nLin,022 Psay "Todos"
	Case mv_par10 == 5
		@_nLin,022 Psay "Aberto/Em Processo"
EndCase
_nLin++
If Alltrim(mv_par11) == "" .Or. Substr(mv_par11,1,3) == "ZZZ"
	@_nLin,000 Psay "Vendedor............: Todos"
Else
	@_nLin,000 Psay "Vendedor............: " + mv_par11
EndIf
_nLin+=2
@_nLin,000 Psay "A planilha foi gravada em =>  C:\Relato_Microsiga\Acompanhamento_PV.csv"
_nLin:=80

Return
