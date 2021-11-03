#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ RCOMR004  ³ Autor ³ Claudinei M. Benzi   ³ Data ³ 05.12.91 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Emissao das Solicitacoes de Compras                        ³±±
±±             Impressoes do Relatorio são diferentes MASIPACK E FABRIMA  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// Alterado por Ana Paula QF em 04/10/2012 - campo empenho, acumulado, atual, 2 meses apos
// Alterado por Ana Paula QF em 02/07/2013 - Reescrito (Masipack e Fabrima)
/*/

User Function RCOMR004(cAlias,nReg,nOpcx)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local wnrel		:= "RCOMR004"
Local cDesc1	:= "Emissao das solicitacoes de compras cadastradas"
Local cDesc2	:= ""
Local cDesc3	:= ""
Local cAliasSC1 := "SC1"

STATIC aTamSXG,aTamSXG2, nPosLoja, nPosNome, nTamNome

Private lAuto	  := (nReg!=Nil)
Private Titulo	  := "Solicitacao de Compra"
Private aReturn   := {"Zebrado",10,"Administracao",2,2,1,"",0}
Private aLinha	  := {}
Private Tamanho   := "M"
Private Limite    := 132
Private nomeprog  := "RCOMR004"
Private nLastKey  := 0
Private cString   := "SC1"
Private M_PAG	  := 1
Private li        := 99
Private Cabec1    := ""
Private Cabec2    := ""
Private cOBS      := ""
Private cAproPlano:= ""
Private nI        := 0
Private I         := 0
Private nFor      := 0
Private nDiaFor   := 0
Private nDiaSem   := 0
Private cFornece  := ""
Private aDesenhos := {}
Private aFornece  := {}
Private cDesenho  := ""
Private _cPath    := ""
Private cFabric   := ""
Private aSemana   := {"Domingo","Segunda-Feira","Terça-Feira","Quarta-Feira","Quinta-Feira","Sexta-Feira","Sabado"}
Private cImp      := .T.
Private aPedidos  := {}
Private cPedidos  := ""
Private cInfTec   := ""
Private cPerg     := "XRCOMR004 "
Private cSegun    := ""

IF SUBSTR(cNumEmp,1,2) = "15"
	cPerg     := "XRCOMR004H"
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte("RCOM04",.F.)

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Do Numero                                        ³
//³ mv_par02    Ate o Numero                                     ³
//³ mv_par03    Todas ou em Aberto                               ³
//³ mv_par04    A Partir da data de emissao                      ³
//³ mv_par05    Ate a data de emissao                            ³
//³ mv_par06    Imprime Empenhos ?                               ³
//³ mv_par07    Impr. SC's Firmes, Previstas ou Ambas            ³
//³ mv_par08    Imprime Desenhos ?                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verif. conteudo das variaveis Grupo Forn. (001) e Loja (002) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)
wnrel:=SetPrint(cString,wnrel,If(!lAuto,cPerg,Nil),@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,!lAuto)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	If SubStr(cNumEmp,1,2) $ "01"
		MV_PAR09 := 1
	EndIf
	
	IF MV_PAR09 == 1
		RptStatus({|lEnd| R140ImpMas(@lEnd,wnrel,cString,nReg)},Titulo)
	ELSE
		RptStatus({|lEnd| R140ImpFab(@lEnd,wnrel,cString,nReg)},Titulo)
	ENDIF
ELSE
	RptStatus({|lEnd| R140ImpMas(@lEnd,wnrel,cString,nReg)},Titulo)
ENDIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C140IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio MASIPACK                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR004                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R140ImpMas(lEnd,wnrel,cString,nReg)

Local X, nI, I
Local nContador  := 0
Local cbCont     := 0
Local cAliasSC1  := "SC1"
Local nNumAnt    := ""
Local cUsuario   := ""
Local dEmissao   := ""
Local nQtdAnter  := 0
Local nQtdMAtual := 0
Local nQtdMProx1 := 0
Local nQtdMProx2 := 0
Local nSoma      := 0
Local j
Local aExtDes    	:= {{".PRI",.T.},{".PRN",.T.},{".PDF",.T.},{".PLT",.T.}}
Local aFiles     	:= {}

Local nA        := 0
Local nB 		:= 0
Local nC 		:= 0
Local nD 		:= 0
Local nE 		:= 0
Local nF 		:= 0
Local nTotG     := 0
Local nTotH     := 0
Local cCompra   := Space(20)
Local _nRecSC1	:= 0
Private nTotal  := 0

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	cQry1 := "SELECT SC1.C1_FILIAL,  SC1.C1_NUM,    SC1.C1_ITEM,  SC1.C1_PRODUTO, SC1.C1_UM, SC1.C1_SEGUM, SC1.C1_QUANT, SC1.C1_DATPRF, SC1.C1_QTSEGUM, "
	cQry1 += "       SC1.C1_DESCRI,  SC1.C1_OBS,    SC1.C1_CC,    SC1.C1_CONTA,   SC1.C1_EMISSAO, SC1.C1_LOCAL,   SC1.C1_SOLICIT, SC1.C1_MSPLANO, "
	cQry1 += "       SC1.C1_QUJE,    SC1.C1_IMPORT, SC1.C1_CLASS, SC1.C1_USER,    SC1.C1_QTDORIG, SC1.C1_QTDREEM, SC1.C1_MSREUNI,C1_MSAPROP,  "
	cQry1 += "       SC1.C1_OBS,     SC1.C1_MSULIMP,SC1.C1_QTDREEM, C1_MSULIMP,   SC1.R_E_C_N_O_  AS _NREG,
	cQry1 += "       SC1.C1_MSINTER, "
	If SubStr(cNumEmp,1,2) == "01"   // identifica a empresa que comprou pela masipack - Lizandra - Jul/13
		cQry1 += "       	SC1.C1_MSEMPRE, "
	ENDIF
	//Ivandro Santos - 07/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	cQry1 += "       SB1.B1_DESC, SB1.B1_QE , ISNULL(SB5.B5_CEME,'') AS 'B5_CEME',  ISNULL(SB5.B5_MSOBS,'') AS 'B5_MSOBS',SB1.B1_PROCED,  SB1.B1_FANTASM, SB1.B1_REVATU  "
	//cQry1 += "       SB1.B1_DESC, SB1.B1_QE ,SB1.B1_DESCP,  SB1.B1_MSDTEC,SB1.B1_PROCED,  SB1.B1_FANTASM, SB1.B1_REVATU,  SB1.B1_UPRC,    SB1.B1_FABRIC,  "
	cQry1 += "       , SB1.B1_UPRC, SB1.B1_FABRIC,SB1.B1_LOCAL,  SB1.B1_ESTSEG,SB1.B1_LM,SB1.B1_LE, SB1.B1_EMAX, SB1.B1_PE, SB1.B1_TIPE,    "
	//Ticket#2017031037000107 — Fim da alteração
	cQry1 += "       SB1.B1_MSGRPMA, SB1.B1_MSGRVEN,SB1.B1_CONV,SB1.B1_TIPCONV, SB2.B2_QATU, "
	//Ivandro Santos - 07/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)	
	//cQry1 += "       CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B1_MSDTEC)) AS B1_MSDTEC, "
	cQry1 += "       CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B5_MSOBS)) AS B5_MSOBS, "
	//Ticket#2017031037000107 — Fim da alteração
	//Ticket#2016090537000144 — Tolerancias 2/3 - Informar na Impressão da SC se o produto MP tem tolerancia cadastrada 
	//Ivandro Santos - 06/09/16
	cQry1 += "       CASE WHEN
	cQry1 += "       ZE_ESPMIN+ZE_ESPMAX+ZE_LARGMIN+ZE_LARGMAX+ZE_ALTMIN+ZE_ALTMAX+ZE_DIAMMIN+ZE_DIAMMAX+ZE_DIAEMIN+ZE_DIAEMAX+ZE_DIAIMIN+ZE_DIAIMAX+ZE_PAREMIN+ZE_PAREMAX+ZE_ALMAMIN+ZE_ALMAMAX+ZE_LADOMIN+ZE_LADOMAX > 0 "
	cQry1 += "       THEN 'S' ELSE 'N' END 'TOLERANCIA' "
	cQry1 += "FROM "+RetSqlName("SC1")+" SC1 "
	cQry1 += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC1.C1_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	cQry1 += "LEFT  JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' AND SB5.B5_COD = SC1.C1_PRODUTO AND SB5.D_E_L_E_T_ = ' ' "
	//Ticket#2017031037000107 — Fim da alteração
	cQry1 += "INNER JOIN "+RetSqlName("SB2")+" SB2 "
	cQry1 += "      ON SB2.B2_FILIAL = '"+xFilial("SB2")+"' AND SB2.B2_COD = SC1.C1_PRODUTO AND SB2.D_E_L_E_T_ = ' ' AND B2_LOCAL = B1_LOCPAD "
	cQry1 += "LEFT JOIN "+RetSqlName("SZE")+" SZE ON SZE.ZE_FILIAL = '"+xFilial("SZE")+"' AND SZE.ZE_CODIGO = SC1.C1_PRODUTO AND SZE.D_E_L_E_T_ = ' ' "
	cQry1 += "      AND SUBSTRING(C1_PRODUTO,1,2) = 'MP' "
	//Ticket#2016090537000144 — Fim da alteração
	cQry1 += "WHERE SC1.C1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQry1 += "AND SC1.C1_EMISSAO BETWEEN '"+DtoS(MV_PAR04)+"' AND '"+DtoS(MV_PAR05)+"' "
	cQry1 += "AND SC1.C1_FILIAL = '"+xFilial("SC1")+"' AND SC1.D_E_L_E_T_ = '' "
	If MV_PAR03 == 2
		cQry1 += " AND (SC1.C1_QUANT - SC1.C1_QUJE) > 0 "
	EndIf
	cQry1 += "ORDER BY SC1.C1_NUM, SC1.C1_ITEM "
	
	TcQuery cQry1 New Alias "QR1"
	TcSetField("QR1","C1_EMISSAO","D",08,00)
	TcSetField("QR1","C1_DATPRF" ,"D",08,00)
	TcSetField("QR1","C1_MSULIMP","D",08,00)
	TcSetField("QR1","C1_QUANT"  ,"N",12,03)
	TcSetField("QR1","C1_QUJE"   ,"N",12,03)
	TcSetField("QR1","C1_QTDREEM","N",02,00)
	TcSetField("QR1","B2_QATU"   ,"N",12,03)
	TcSetField("QR1","B1_ESTSEG" ,"N",12,03)
	TcSetField("QR1","B1_LM"     ,"N",12,03)
	TcSetField("QR1","B1_LE","N",12,03)
	TcSetField("QR1","B1_EMAX","N",12,03)
	TcSetField("QR1","B1_UPRC","N",12,04) // INCLUIDO PARA TRATAR PREÇO UNITÁRIO DA LABORTUB
ELSE
	_cQuery := " SELECT C1_NUM, C1_ITEM, C1_PRODUTO, C1_UM, C1_QUANT, C1_DATPRF, C1_SEGUM, C1_QTSEGUM,"
	_cQuery += "        C1_OBS, C1_EMISSAO, C1_SOLICIT, C1_QUJE, C1_USER, C1_QTDREEM, C1_MSAPROP, "
	_cQuery += "        C1_OBS, C1.R_E_C_N_O_  AS _NREG,
	_cQuery += "        B1_DESC, B1_FANTASM, B1_REVATU, B1_UPRC, B1_FABRIC, B1_PROCED,  "
	_cQuery += "        B1_ESTSEG, B1_LM, B1_LE, B1_EMAX, B1_PE, B1_TIPE, B1_QE , B1_LOCPAD,B1_CONV,B1_TIPCONV,   "
	_cQuery += "        B2_QATU, B5_CEME, B1_MSGRPMA,   "
	_cQuery += "        C1_MSINTER, "
	//Ivandro Santos - 25/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	//_cQuery += "        CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B5_MSOBS)) AS B1_MSDTEC "
	_cQuery += "        CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B5_MSOBS)) AS B5_MSOBS "
	//Ticket#2017031037000107 — Fim da alteração
	_cQuery += " FROM "+RetSqlName("SC1")+" C1 "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
	_cQuery += "	    ON B1_FILIAL = '" + xFilial("SB1") + "' AND B1_COD = C1_PRODUTO AND B1.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT OUTER JOIN " +  RetSqlName("SB5") + " B5 "
	_cQuery += "       ON B5_FILIAL =  '" + xFilial("SB5") + "' AND B5.D_E_L_E_T_ = '' "
	_cQuery += "       AND B5_COD = C1_PRODUTO  "
	_cQuery += " INNER JOIN "+RetSqlName("SB2")+" B2 "
	_cQuery += "       ON B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = C1_PRODUTO AND B2.D_E_L_E_T_ = ' ' AND B2_LOCAL = B1_LOCPAD "
	_cQuery += " WHERE C1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += "       AND C1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	_cQuery += "       AND C1_DATPRF BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
	_cQuery += "       AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1.D_E_L_E_T_ = '' "
	If mv_par08 == 2
		_cQuery += " 		 AND (C1_QUANT - C1_QUJE) > 0 "
	EndIf
	_cQuery += " 		 AND C1_RESIDUO <> 'R' "
	IF MV_PAR07 == 1
		_cQuery += "       AND C1_TPOP = 'F'  "
	ELSEIF MV_PAR07 == 2
		_cQuery += "       AND C1_TPOP = 'P'  "
	ENDIF
	_cQuery += "ORDER BY C1_NUM, C1_ITEM "
	
	TcQuery _cQuery New Alias "QR1"
	
	TcSetField("QR1","C1_EMISSAO","D",08,00)
	TcSetField("QR1","C1_DATPRF" ,"D",08,00)
	TcSetField("QR1","C1_QUANT"  ,"N",12,04)
	TcSetField("QR1","C1_QUJE"   ,"N",12,04)
	TcSetField("QR1","C1_QTDREEM","N",02,00)
	TcSetField("QR1","B2_QATU"   ,"N",12,03)
	TcSetField("QR1","B1_ESTSEG" ,"N",12,03)
	TcSetField("QR1","B1_LM"     ,"N",12,03)
	TcSetField("QR1","B1_LE","N",12,03)
	TcSetField("QR1","B1_EMAX","N",12,03)
	TcSetField("QR1","B1_UPRC","N",12,04)
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a Impressao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo  := "Solicitacoes de Compra Valorizadas "
Cabec1  := "Solic.No     Codigo          Rev  D e s c r i ç ã o                      Qtde.  UN  Ult.Preço     Total     Necessário"+" FORNECEDORES"
Cabec2  := "-                                                                         (A)        Compra                   p/ dia"
//////////  0123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o123456789n123456789C123456789D123456789V123456789

SetRegua(RecCount())		// Total de Elementos da regua

Do While !QR1->(Eof())
	
	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		dbSkip()
		Loop
	EndIf
	
	dEmissao := QR1->C1_EMISSAO
	_nReemp	 := QR1->C1_QTDREEM
	_nRecSC1 := QR1->_NREG
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de OPs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(MV_PAR07, 'SC1')
		dbSkip()
		Loop
	EndIf
	
	If QR1->C1_NUM <> nNumAnt
		If nNumAnt <> ""
			li++
			@li,030 PSAY "T  O  T  A  L   ==> "
			@li,084 PSAY nTotal Picture "@E 9,999,999.9999" //,PesqPict("SB1","B1_UPRC",15,2)
			li+=2
			@li,001 PSAY Replicate ("-",132)
			li++
			@li,001 PSAY "Data de Emissão: "
			@li,019 PSAY dEmissao
			@li,050 PSAY "Data de Impressao: "
			@li,069 PSAY dDatabase
			IF _nReemp >= 1
				@li,100 PSAY "No. de Reemissao: "
				@li,119 PSAY STRZERO(_nReemp,2)
			ENDIF
			li+=2
			@li,001 PSAY "       Emitente: " + cUsuario
			li+=3
			@li,034 PSAY "_____________________________"
			
			@li,094 PSAY "____/____/____"
			li++
			//@li,001 PSAY "Emitente: " + cUsuario
			@li,040 PSAY "Visto Liberação"
			@li,097 PSAY "Data - Lib."
			
			IF _nRecSC1 > 0
				SC1->(dbGOTO(_nRecSC1))
				RecLock("SC1",.F.)
				IF SUBSTR(cNumEmp,1,2) <> "15"
					SC1->C1_MSULIMP := dDatabase
				ENDIF
				SC1->C1_QTDREEM += 1
				SC1->(MSUNLOCK())
				dbSelectArea("QR1")
			ENDIF
			
		EndIf
		
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		
		nNumAnt  := QR1->C1_NUM
		cUsuario := QR1->C1_Solicit
		dEmissao := QR1->C1_EMISSAO
		_nRecSC1 := QR1->_NREG
		_nReemp	 := QR1->C1_QTDREEM
		nTotal   := 0
		
		li := 8
		
	EndIf
	cInfTec := ""
	cAproPlano := ""
	cFabric := ""
	cOBS := ""
	
	If !Empty(QR1->C1_MSAPROP)
		cAproPlano := "Apropriação: " + Alltrim(QR1->C1_MSAPROP) + " "
	EndIf
	
	IF SUBSTR(cNumEmp,1,2) <> "15"
		//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
		If Empty(QR1->B5_CEME)					//If Empty(QR1->B1_DESCP)
			cDescri := Alltrim(QR1->B1_DESC)
		Else
			cDescri := Alltrim(QR1->B5_CEME)	//cDescri := Alltrim(QR1->B1_DESCP)
		EndIf
		//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
		/*
		If !Empty(QR1->B1_MSDTEC)
			cInfTec := Alltrim(QR1->B1_MSDTEC)
		EndIf
        */
		If !Empty(QR1->B5_MSOBS)
			cInfTec := Alltrim(QR1->B5_MSOBS)
		EndIf
		
		cDesenho := Alltrim(QR1->C1_Produto)+ Alltrim(QR1->B1_REVATU)
		
		If !Empty(QR1->C1_MSPlano)
			cAproPlano := cAproPlano + "Plano: " + Alltrim(QR1->C1_MSPlano)
		EndIf
	ELSE
		If !Empty(QR1->B5_CEME)
			cDescri := Alltrim(QR1->B5_CEME)
		Else
			cDescri := Alltrim(QR1->B1_DESC)
		EndIf
		//Ivandro Santos - 25/04/17 - Início da alteração
		//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
		/*If !Empty(QR1->B1_MSDTEC)
			cInfTec := Alltrim(QR1->B1_MSDTEC)
		EndIf*/
		If !Empty(QR1->B5_MSOBS)
			cInfTec := Alltrim(QR1->B5_MSOBS)
		EndIf
		//Ticket#2017031037000107 — Fim da alteração
	ENDIF
	
	If Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da Linha do Produto Solicitado                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nA := QR1->C1_QUANT
	
	li++
	@ li,000 PSAY QR1->C1_NUM + "/"
	@ li,007 PSAY QR1->C1_ITEM Picture PesqPict("SC1","C1_ITEM")
	@ li,012 PSAY SubStr(QR1->C1_PRODUTO,1,15) + "-" + QR1->B1_REVATU
	//@ li,030 PSAY SubStr(cDescri,1,30)
	@ li,063 PSAY QR1->C1_QUANT Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.99","@E 9,999,999.9999")
	@ li,080 PSAY QR1->C1_UM
	@ li,083 PSAY QR1->B1_UPRC Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.99","@E 9,999.9999")
	@ li,095 PSAY (QR1->B1_UPRC * QR1->C1_QUANT) Picture "@E 999,999.99"
	@ li,112 PSAY If(Empty(QR1->C1_DATPRF),QR1->C1_EMISSAO,QR1->C1_DATPRF)
	li++
	@ li,000 PSAY 'Descrição: '
	@ li,012 PSAY cDescri
	If !EMPTY(QR1->C1_QTSEGUM)
		li++
		@ li,031 PSAY "Segunda unidade de medida ----->"
		@ li,067 PSAY QR1->C1_QTSEGUM Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.99","@E 9,999,999.9999")
		@ li,080 PSAY QR1->C1_SEGUM
		cSegun:= "S"
		If QR1->B1_TIPCONV == "M"
			
			@ li,083 PSAY (QR1->B1_UPRC/QR1->B1_CONV) Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.999","@E 9,999.9999")
			@ li,095 PSAY ((QR1->B1_UPRC/QR1->B1_CONV) * QR1->C1_QTSEGUM) Picture "@E 999,999.999"
			
		Else
			
			@ li,083 PSAY (QR1->B1_UPRC*QR1->B1_CONV) Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.999","@E 9,999.9999")
			@ li,095 PSAY ((QR1->B1_UPRC*QR1->B1_CONV) * QR1->C1_QTSEGUM) Picture "@E 999,999.999"
			
		EndIf
	EndIf
	
	
	
	nTotal := nTotal + (QR1->B1_UPRC * QR1->C1_QUANT)
	
	If !Empty(QR1->B1_FABRIC)
		cFabric := "Fabricante:  " + Alltrim(QR1->B1_FABRIC)
	EndIf
	
	If !Empty(QR1->C1_OBS)
		cOBS := "Obs.: " + Alltrim(QR1->C1_OBS)
	EndIf
	li++
	//	@ li,000 PSAY "Quantidade da embalagem: " + STR(QR1->B1_QE)
	
	// IMPRESSAO DOS DESENHOS
	//Ticket#2016080537000182 — Tarefa ID 121 - Impressão de Desenhos junto às SCs
	//Ivandro Santos	
	IF SUBSTR(cNumEmp,1,2) <> "15" .and. MV_PAR08 == 1 //acrescentado o parâmetro para agilizar a impressão da SC quando não for necessário o desenho
		If MV_PAR10 == 3 //SubStr(cNumEmp,1,2) == "01"
			_cPath := "H:\PLOTTER\"
			If Substr(cDesenho,1,2) == "CL"
				_cPath += Substr(cDesenho,3,2) + "\"
			ELSE
				_cPath += Substr(cDesenho,1,2) + "\"
			ENDIF
			For nD:=1 to 4
				ADir(_cPath+cDesenho+aExtDes[nD][1], aFiles)
				If len (aFiles) > 0
					aExtDes[nD][2] := .T.
					AADD(aDesenhos,"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + aExtDes[nD][1] + " LPT1" )
				Else
					aExtDes[nD][2] := .F.
				Endif
			Next
			IF !(aExtDes[1][2]) .And. !(aExtDes[2][2]) .And. !(aExtDes[3][2]) .And. !(aExtDes[4][2])
				_cPath := "P:\PLOTTER\"
				If Substr(cDesenho,1,1) == "X"
					If ExistDir(_cPath+Substr(cDesenho,1,3))
						_cPath += Substr(cDesenho,1,3) + "\"
					Else
						_cPath += Substr(cDesenho,2,3) + "\"
					Endif
				ElseIf Substr(cDesenho,1,2) == "70"
					_cPath += Substr(cDesenho,1,2) + "\"
				Else
					_cPath += Substr(cDesenho,1,3) + "\"
				Endif
				For nD:=1 to 4
					ADir(_cPath+cDesenho+aExtDes[nD][1], aFiles)
					If len (aFiles) > 0
						aExtDes[nD][2] := .T.
						AADD(aDesenhos,"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + aExtDes[nD][1] + " LPT1" )
					Else
						aExtDes[nD][2] := .F.
					Endif
				Next
			Endif
			FOR j := 1 TO LEN(aDesenhos)
				WaitRun(aDesenhos[j])
			NEXT
			aDesenhos := {}
		Else
			_cPath += "H:\PLOTTER\"
			If SubStr(cNumEmp,1,2) == "01"
				If Substr(cDesenho,1,2) == "CL"
					_cPath += Substr(cDesenho,3,2) + "\"
				ELSE
					_cPath += Substr(cDesenho,1,2) + "\"
				ENDIF
			ElseIf SubStr(cNumEmp,1,2) == "10"
				_cPath += Substr(cDesenho,1,3) + "\"
			Endif
			AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PDF LPT1" )
			AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PLT LPT1" )
			AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PRI LPT1" )
			AADD(aDesenhos,/*"H:\Plotter\Plot\plot2015.bat " +*/"cmd /c COPY /B " + _cPath + Alltrim(cDesenho) + ".PRN LPT1" )
			
			FOR j := 1 TO LEN(aDesenhos)
				WaitRun(aDesenhos[j])
			NEXT
			aDesenhos := {}
		EndIf
		/*If aReturn[5] > 1 .And. mv_par08 == 1
			_cPath := "H:\PLOTTER\"
			If SubStr(cNumEmp,1,2) == "01"
				If Substr(cDesenho,1,2) == "CL"
					_cPath += Substr(cDesenho,3,2) + "\"
				ELSE
					_cPath += Substr(cDesenho,1,2) + "\"
				ENDIF
				IF SUBSTR(cDesenho,11,2) == "MP"
					cDesenho := SUBSTR(cDesenho,1,10) + SUBSTR(cDesenho,13,1)
				ENDIF
			ElseIf SubStr(cNumEmp,1,2) == "10"
				_cPath  := SubStr(cDesenho,1,3)  + "\"
			ElseIf SubStr(cNumEmp,1,2) == "40"
				_cPath  := SubStr(cDesenho,1,3)  + "\"
			EndIf
			
			AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
			AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
			AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
			
			WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
			WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
			WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
			
		EndIf*/
	ENDIF
	//Ticket#2016080537000182 — Fim da alteração
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os fornecedores indicados para este produto          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nContador := 0
	nDiaFor   := 0    // Amarracao por Produto
	aFornece  := {}
	
	If Select("QRY2") > 0
		DbSelectArea("QRY2")
		DbCloseArea()
	EndIf
	
	_cQry2 := "SELECT SA2.A2_COD, SA2.A2_LOJA, "
	IF SUBSTR(cNumEmp,1,2) <> "15"
		_cQry2 += " SA2.A2_MSDIASE, "
	ENDIF
	_cQry2 += " SA2.A2_NREDUZ "
	_cQry2 += "FROM "+RetSqlName("SA5")+" SA5 "
	_cQry2 += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.A2_COD = SA5.A5_FORNECE AND SA2.A2_LOJA = SA5.A5_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	_cQry2 += "WHERE SA5.A5_PRODUTO = '"+AllTrim(QR1->C1_PRODUTO)+"' "
	_cQry2 += "  AND SA5.A5_FILIAL = '  ' AND SA5.D_E_L_E_T_ = ' ' "
	
	TcQuery _cQry2 New Alias "QR2"
	
	While !QR2->(EOF())
		IF SUBSTR(cNumEmp,1,2) <> "15"
			nDiaFor  := Val(QR2->A2_MSDIASE)
		ENDIF
		nContador++
		cFornece := QR2->A2_COD + "-" + Substr(QR2->A2_NREDUZ,1,15)
		AADD(aFornece,{cFornece,QR2->A2_COD+QR2->A2_LOJA})
		QR2->(dbSkip())
	EndDo
	QR2->(DbCloseArea())
	
	If !Empty(cDescri)
		nFor := 1
		If Len(cDescri) > 30
			Li++
			@ li,030 PSAY ''//SubStr(cDescri,31,70)
		EndIf
	EndIf
	
	If !Empty(SUBSTR(cAproPlano,1,80))
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,000 PSAY SUBSTR(cAproPlano,1,80)
	EndIf
	
	If !Empty(SUBSTR(cAproPlano,81,74))
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			
			Li++
		EndIf
		@ li,012 PSAY SUBSTR(cAproPlano,81,74)
	EndIf
	
	If !Empty(SUBSTR(cAproPlano,155,23))
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,000 PSAY SUBSTR(cAproPlano,155,23)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	ENDIF
	
	Li++
	If !Empty(cInfTec)
		For X := 1 TO MLCOUNT(cInfTec,70)
			Li++
			If Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				@ Li, 012 Psay "Continuação do item anterior ......"
				Li:=9
				Li++
			EndIf
			@li,030 PSay MEMOLINE(cInfTec,70,X)
			If nFor <= nContador
				@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
				nFor++
			EndIf
		Next
		Li++
	EndIf
	
	Li++
	If !Empty(cFabric)
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,012 PSAY Alltrim(cFabric)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	EndIf
	
	If !Empty(cObs)
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,0 PSAY SubStr(cOBS,1,76)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	EndIf
	
	If Len(cObs) > 76
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,030 PSAY SubStr(cOBS, 77,70)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	EndIf
	
	Li++
	IF Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		
		Li++
	EndIf
	//Ticket#2016090537000144 — Tolerancias 2/3 - Informar na Impressão da SC se o produto MP tem tolerancia cadastrada
	IF SUBSTR(cNumEmp,1,2) <> "15"
		@ li,000 PSAY "Tolerância de medidas: " + IIf(QR1->TOLERANCIA=="S","SIM","NAO")
		Li++                                                                           
	Endif                                  
	//Ticket#2016090537000144 — Fim da alteração
	IF SUBSTR(cNumEmp,1,2) == "01"   //CONDIÇÃO INCLUIDA A PEDIDO DA CONTABILIDADE - 31/07/13 - LIZANDRA
		@ Li,000 PSAY "Empresa: "
		IF EMPTY(QR1->C1_MSEMPRE).OR.QR1->C1_MSEMPRE == "M"
			@ Li,010 PSAY "Masipack"
		ELSEIF QR1->C1_MSEMPRE == "F"
			@ Li,010 PSAY "Fabrima"
		ELSEIF QR1->C1_MSEMPRE == "H"
			@ Li,010 PSAY "Helsimplast"
		ELSEIF QR1->C1_MSEMPRE == "E"
			@ Li,010 PSAY "Memb"
			
		ELSEIF QR1->C1_MSEMPRE == "L"
			@ Li,010 PSAY "Labortube"
		ENDIF
		Li++
	ENDIF
	
	//VICTOR DESSUNTE - 18/03/2016
	//SOLICITADO POR IARA
	IF SUBSTR(cNumEmp,1,2) <> "01"
		@Li,012 PSAY "Código Masipack: " + AllTrim(QR1->B1_MSGRPMA)
		Li++
		Li++
	ENDIF
	
	IF SUBSTR(cNumEmp,1,2) <> "15"
		@ Li,012 PSAY "Prazo Entrega:    " + Transform(QR1->B1_PE,'@E 9999')+"      Tipo.....: " + QR1->B1_TIPE +"          Grp.Vendas..: " + SB1->B1_MSGRVEN+"         Proced.: " + (QR1->B1_PROCED)
	ELSE
		@ Li,012 PSAY "Prazo Entrega:    " + Transform(QR1->B1_PE,'@E 9999')+"      Tipo.....: " + QR1->B1_TIPE + "         Proced.: " + (QR1->B1_PROCED)
	ENDIF
	
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	If QR1->C1_MSINTER == "S"
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			Li:=9
			
		EndIf
		Li++
		Li++
		@ Li,009 PSAY "Solicitação é INTERCOMPANY ! :  "
		Li++
	EndIf
	If SUBSTR(cNumEmp,1,2) <> "15"
		If !Empty(QR1->B1_MSGRPMA)
			Li++
			IF Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				@ Li, 012 Psay "Continuação do item anterior ......"
				Li:=9
				Li++
			EndIf
			IF SUBSTR(cNumEmp,1,2) <> "40"
				@ Li,009 PSAY "Cod.Grp.Masipack:  " + QR1->B1_MSGRPMA
			ELSE
				@ Li,009 PSAY "Cod.Grp.Masipack......:  " + QR1->B1_MSGRPMA
			ENDIF
			If nFor <= nContador
				@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
				nFor++
			EndIf
		EndIf
	ENDIF
	
	Li++
	If Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	nE := QR1->B1_ESTSEG
	@ li, 012 PSAY " Est.Seg.(E).: " + Transform(QR1->B1_ESTSEG,'@E 999,999.999')  + "  Lote Min.: " + Transform(QR1->B1_LM,'@E 9,999.999') + "  Lote Econ...: " + Transform(QR1->B1_LE,'@E 9,999.999')  + "  Estoq.Max.: " + Transform(QR1->B1_EMAX,'@E 99,999.999')
	IF SUBSTR(cNumEmp,1,2) <> "15"
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	ENDIF
	
	Li++
	
	nEmpProd  := 0
	nMesAnter := Month(Date()) - 1
	nMesAtual := Month(Date())
	nAnoAtual := Year(Date())
	nAnoAnter := Year(Date()) - 1
	
	If nMesAtual = 11
		nMesProx1 := 12
		nAnoProx1 := Year(Date())
		nMesProx2 := 1
		nAnoProx2 := Year(Date())+ 1
	ElseIf nMesAtual = 12
		nMesProx1 := 1
		nAnoProx1 := Year(Date()) + 1
		nMesProx2 := 2
		nAnoProx2 := Year(Date()) + 1
	ElseIf nMesAtual < 11
		nMesProx1 := Month(Date()) + 1
		nAnoProx1 := Year(Date())
		nMesProx2 := Month(Date()) + 2
		nAnoProx2 := Year(Date())
	EndIf
	
	cMesAtual := Strzero(nMesAtual,2)
	cMesAnter := Strzero(nMesAnter,2)
	cMesProx1 := Strzero(nMesProx1,2)
	cMesProx2 := Strzero(nMesProx2,2)
	cAnoAtual := Strzero(nAnoAtual,4)
	cAnoProx1 := Strzero(nAnoProx1,4)
	cAnoProx2 := Strzero(nAnoProx2,4)
	cAnoAnter := Strzero(nAnoAnter,4)
	
	cProduto := QR1->C1_PRODUTO
	
	If Select("QR3") > 0
		dbSelectArea("QR3")
		dbCloseArea()
	EndIf
	
	_cQry3 := "SELECT SD4.D4_DATA, SD4.D4_QUANT "
	_cQry3 += "FROM "+RetSqlName("SD4")+" SD4 "
	_cQry3 += "WHERE SD4.D4_COD = '"+Alltrim(QR1->C1_PRODUTO)+"' "
	_cQry3 += "AND SD4.D4_QUANT > 0 "
	_cQry3 += "AND SD4.D_E_L_E_T_ = '' AND SD4.D4_FILIAL = '"+xFilial("SD4")+"'  "
	_cQry3 += "ORDER BY SD4.D4_DATA "
	
	TcQuery _cQry3 New Alias "QR3"
	
	TcSetField("QR3","D4_DATA" ,"D",08,00)
	TcSetField("QR3","D4_QUANT","N",12,03)
	
	nQtdAnter  := 0
	nQtdMAtual := 0
	nQtdMProx1 := 0
	nQtdMProx2 := 0
	nSoma      := 0
	
	QR3->(DbGoTop())
	Do While !QR3->(EOF())
		If (Strzero(MONTH(QR3->D4_DATA),2) <= cMesAnter .and. Strzero(Year(QR3->D4_DATA),4) == cAnoAtual) .OR. (Strzero(MONTH(QR3->D4_DATA),2) > cMesAnter .and. Strzero(Year(QR3->D4_DATA),4) <= cAnoAnter)
			nQtdAnter += QR3->D4_QUANT
		ElseIf Strzero(MONTH(QR3->D4_DATA),2) == cMesAtual .and. Strzero(Year(QR3->D4_DATA),4) == cAnoAtual
			nQtdMAtual += QR3->D4_QUANT
		ElseIf Strzero(MONTH(QR3->D4_DATA),2) == cMesProx1 .and. Strzero(Year(QR3->D4_DATA),4) == cAnoProx1
			nQtdMProx1 += QR3->D4_QUANT
		ElseIf Strzero(MONTH(QR3->D4_DATA),2) == cMesProx2 .and. Strzero(Year(QR3->D4_DATA),4) == cAnoProx2
			nQtdMProx2 += QR3->D4_QUANT
		EndIf
		QR3->(DBSKIP())
	EndDo
	nSoma := nQtdAnter + nQtdMAtual + nQtdMProx1 + nQtdMProx2
	nsomaSD4 := nQtdAnter + nQtdMAtual + nQtdMProx1 + nQtdMProx2
	
	QR3->(DbCloseArea())
	
	If Select("QRY4") > 0
		DbSelectArea("QRY4")
		DbCloseArea()
	EndIf
	
	_cQry4 := "SELECT (SC6.C6_QTDVEN - SC6.C6_QTDENT) as nQtde, SC6.C6_ENTREG  "
	_cQry4 += "FROM "+RetSqlName("SC6")+" SC6 "
	_cQry4 += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SC6.C6_TES AND SF4.D_E_L_E_T_= '' "
	_cQry4 += "WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_ = '' "
	_cQry4 += "AND SC6.C6_PRODUTO = '"+Alltrim(cProduto)+"'  "
	_cQry4 += "AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 "
	_cQry4 += "AND SC6.C6_BLQ <> 'R' "
	_cQry4 += "AND SF4.F4_ESTOQUE = 'S' "
	_cQry4 += "ORDER BY SC6.C6_ENTREG "
	
	TcQuery _cQry4 New Alias "QR4"
	
	TcSetField("QR4","C6_ENTREG","D",08,00)
	TcSetField("QR4","nQtde","N",12,03)
	
	Do While !QR4->(EOF())
		
		If (Strzero(MONTH(QR4->C6_ENTREG),2) <= cMesAnter .and. StrZero(Year(QR4->C6_ENTREG),4) == cAnoAtual) .OR. (StrZero(MONTH(QR4->C6_ENTREG),2) > cMesAnter .and. StrZero(Year(QR4->C6_ENTREG),4) <= cAnoAnter)
			nQtdAnter += QR4->nQtde
		ElseIf (StrZero(MONTH(QR4->C6_ENTREG),2) == cMesAtual .and. StrZero(Year(QR4->C6_ENTREG),4) == cAnoAtual)
			nQtdMAtual += QR4->nQtde
		ElseIf (StrZero(MONTH(QR4->C6_ENTREG),2) == cMesProx1 .and. StrZero(Year(QR4->C6_ENTREG),4) == cAnoProx1)
			nQtdMProx1 += QR4->nQtde
		ElseIf (StrZero(MONTH(QR4->C6_ENTREG),2) == cMesProx2 .and. StrZero(Year(QR4->C6_ENTREG),4) == cAnoProx2)
			nQtdMProx2 += QR4->nQtde
		EndIf
		
		nSoma += QR4->nQtde
		
		QR4->(DBSKIP())
		
	EndDo
	QR4->(DbCloseArea())
	
	nB := QR1->B2_QATU
	nF := nSoma
	
	dbSelectArea("SB2")
	SB2->(dbSetOrder(1))
	_nQtd10 := 0
	
	IF SUBSTR(cNumEmp,1,2) == "40" .AND. SUBSTR(QR1->C1_PRODUTO,1,3) = "DIA"
		IF dbSeek(xFilial("SB2")+QR1->C1_PRODUTO + "10")
			_nQtd10 := SB2->B2_QATU + QR1->B2_QATU
		ENDIF
	ENDIF
	IF _nQtd10 == 0
		_nQtd10 := QR1->B2_QATU
	ENDIF
	If cSegun == "S"
		IF SUBSTR(cNumEmp,1,2) <> "15"
			@ li,012 PSAY " Estoque (B).: " + Transform(_nQtd10,'@E 999,999.999') + "  Local....:   " + QR1->B1_LOCAL+" Fantasma....: " + QR1->B1_FANTASM + "          QTD. Emba.:" + Transform(QR1->B1_QE,'@E 999,999.999')
		ELSE
			@ li,012 PSAY " Estoque (B).: " + Transform(QR1->B2_QATU,'@E 999,999.999') + "  Local....:   " + QR1->B1_LOCPAD+" Fantasma....: " + QR1->B1_FANTASM + "          QTD. Emba.:" + Transform(QR1->B1_QE,'@E 999,999.999')
		ENDIF
	Else
		IF SUBSTR(cNumEmp,1,2) <> "15"
			@ li,012 PSAY " Estoque (B).: " + Transform(_nQtd10,'@E 999,999.999') + "  Local....:   " + QR1->B1_LOCAL+" Fantasma....: " + QR1->B1_FANTASM + "          QTD. Emba.:" + Transform(QR1->B1_QE,'@E 999,999.999')
		ELSE
			@ li,012 PSAY " Estoque (B).: " + Transform(QR1->B2_QATU,'@E 999,999.999') + "  Local....:   " + QR1->B1_LOCPAD+" Fantasma....: " + QR1->B1_FANTASM + "          QTD. Emba.:" + Transform(QR1->B1_QE,'@E 999,999.999')
		ENDIF
	EndIf
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	Li++
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	Li++
	IF Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	@ li,012 PSAY " Acumulado...: " + Transform(nQtdAnter,'@E 999,999.999')
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	Li++
	IF Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	
	@ li,015 PSAY str(nMesAtual,2)+"/"+str(nAnoAtual,4)+"...: "+ Transform(nQtdMAtual,'@E 999,999.999')
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	Li++
	IF Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	@ li,015 PSAY str(nMesProx1,2)+"/"+str(nAnoProx1,4)+"...: " + Transform(nQtdMProx1,'@E 999,999.999')
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	Li++
	IF Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	@ li,015 PSAY str(nMesProx2,2)+"/"+str(nAnoProx2,4)+"...: " + Transform(nQtdMProx2,'@E 999,999.999')
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	Li++
	IF Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	@ li,015 Psay "              " + replicate("-",10)
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	Li++
	IF Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	@ li,015 Psay "TOTAL (F) =>" + Transform(nSoma,'@E 9,999,999.9999')
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	If nContador >= nFor
		For nI := nFor to nContador
			Li++
			If Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				@ Li, 012 Psay "Continuação do item anterior ......"
				Li:=9
				Li++
			EndIf
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		Next nI
	EndIf
	
	If nContador == 1 .And. nDiaFor > 0
		If Dow(SC1->C1_DATPRF) <> nDiaFor
			Li+=2
			@ Li,012 Psay "Atenção, Data de entrega, Dia da semana: "+aSemana[Dow(SC1->C1_DATPRF)] + " diferente do Fornecedor: "+aSemana[nDiaFor]
		EndIf
	EndIf
	
	// SOLICITACOES PENDENTES
	nI := 0
	nSomaSC1 := 0
	cNumSC := QR1->C1_NUM
	
	If Select("QRSC1") > 0
		DbSelectArea("QRSC1")
		DbCloseArea()
	EndIf
	
	_cQrySC1 := "SELECT SC1.C1_NUM, SC1.C1_ITEM, SC1.C1_DATPRF, SC1.C1_RESIDUO, SC1.C1_QUANT, SC1.C1_QUJE, SC1.C1_OBS, SB1.B1_CUSTD "
	_cQrySC1 += "FROM "+RetSqlName("SC1")+" SC1 "
	_cQrySC1 += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD = SC1.C1_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	_cQrySC1 += "WHERE SC1.C1_PRODUTO = '"+Alltrim(cProduto)+"' AND SC1.C1_FILIAL = '"+xFilial("SC1")+"' AND SC1.D_E_L_E_T_ = '' "
	_cQrySC1 += "AND SC1.C1_QUJE < SC1.C1_QUANT "
	_cQrySC1 += "AND SC1.C1_RESIDUO = ' ' "
	_cQrySC1 += "AND SC1.C1_NUM <> '"+cNumSC+"' "
	_cQrySC1 += "ORDER BY SC1.C1_NUM "
	
	TcQuery _cQrySC1 New Alias "QRSC1"
	
	TcSetField("QRSC1","C1_DATPRF","D",08,00)
	TcSetField("QRSC1","C1_QUANT","N",12,03)
	TcSetField("QRSC1","C1_QUJE","N",12,03)
	
	While QRSC1->(!EOF())
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		If  nI == 0
			Li++
			@ Li,012 Psay "SOLICITAÇÕES PENDENTES P/ESTE ITEM: "
			Li++
			@ Li,012 Psay "Solicitação/Item              Qtd.Pendente  Vlr.Unitario  Dt.Entrega            Observação "
			Li++
		EndIf
		@ Li,012 Psay QRSC1->C1_NUM + "/" + QRSC1->C1_ITEM
		@ Li,043 Psay QRSC1->C1_QUANT - QRSC1->C1_QUJE Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 99,999.999","@E 999,999.99")
		@ Li,054 Psay QRSC1->B1_CUSTD Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 99,999,999.99","@E 999,999.9999")
		@ Li,072 Psay QRSC1->C1_DATPRF
		@ Li,093 Psay QRSC1->C1_OBS   Picture "@!"
		nSomaSC1 += QRSC1->C1_QUANT - QRSC1->C1_QUJE
		nI++
		QRSC1->(dbSkip())
	EndDo
	
	If !Empty(nSomaSC1)
		nC := nSomaSC1
		Li++
		@ Li,012 Psay "Total Solic.Pendentes (C)     " + Transform(nSomaSC1,"@E 9,999,999.9999")
	Else
		nC := 0
		Li++
		Li++
		@ Li,012 Psay "Total Solic.Pendentes (C)     " + Transform(nC,"@E 9,999,999.9999")
	EndIf
	QRSC1->(DbCloseArea())
	
	// PEDIDOS PENDENTES
	nI := 0
	nSomaSC7 := 0
	
	If Select("QRSC7") > 0
		DbSelectArea("QRSC7")
		DbCloseArea()
	EndIf
	
	_cQrySC7 := "SELECT SC7.C7_NUM,  SC7.C7_ITEM,   SC7.C7_PRECO,  SC7.C7_DATPRF,  SC7.C7_QUANT, SC7.C7_QUJE, SC7.C7_FORNECE, SC7.C7_LOJA,  "
	_cQrySC7 += "       SC7.C7_COND, SE4.E4_DESCRI, SA2.A2_NREDUZ, SC7.C7_RESIDUO, SC7.C7_OBS  "
	_cQrySC7 += "FROM "+RetSqlName("SC7")+" SC7  "
	_cQrySC7 += "LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL='"+xFilial("SA2")+"' AND SA2.A2_COD=SC7.C7_FORNECE "
	_cQrySC7 += "                                      AND SA2.A2_LOJA=SC7.C7_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	_cQrySC7 += "LEFT OUTER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL='"+xFilial("SE4")+"' AND SE4.E4_CODIGO=SC7.C7_COND AND SE4.D_E_L_E_T_ = ' ' "
	_cQrySC7 += "WHERE SC7.C7_PRODUTO = '"+Alltrim(cProduto)+"'  "
	_cQrySC7 += "AND SC7.C7_FILIAL = '"+xFilial("SC7")+"'  "
	_cQrySC7 += "AND SC7.D_E_L_E_T_ = ' '   "
	_cQrySC7 += "AND SC7.C7_QUJE < SC7.C7_QUANT "
	_cQrySC7 += "AND SC7.C7_RESIDUO = ' '  "
	_cQrySC7 += "AND SC7.C7_NUMSC <> '"+cNumSC+"' "
	_cQrySC7 += "ORDER BY SC7.C7_NUM, SC7.C7_DATPRF "
	
	TcQuery _cQrySC7 New Alias "QRSC7"
	
	TcSetField("QRSC7","C7_DATPRF","D",08,00)
	TcSetField("QRSC7","C7_QUANT","N",12,03)
	TcSetField("QRSC7","C7_QUJE","N",12,03)
	
	While QRSC7->(!EOF())
		
		If !Empty(QRSC7->A2_NREDUZ)
			cForn := SubStr(QRSC7->A2_NREDUZ,1,15)
		Else
			cForn := "Fornecedor não encontrado"
		EndIf
		
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		
		If  nI == 0
			Li++
			@ Li,012 Psay "PEDIDOS PENDENTES P/ESTE ITEM: "
			Li++
			@ Li,012 Psay "Pedido/Item  Fornecedor       Qtd.Pendente  Vlr.Unitario  Dt.Entrega  Cond.Pgto   Observação "
			Li++
		EndIf
		@ Li,012 Psay QRSC7->C7_NUM + "/" + QRSC7->C7_ITEM
		@ Li,026 Psay cForn
		@ Li,043 Psay QRSC7->C7_QUANT - QRSC7->C7_QUJE Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 99,999.999","@E 999,999.99")
		@ Li,054 Psay QRSC7->C7_PRECO Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 99,999,999.99","@E 999,999.9999")
		@ Li,072 Psay QRSC7->C7_DATPRF
		
		If !Empty(QRSC7->E4_DESCRI)
			@ Li,083 Psay Substr(QRSC7->E4_DESCRI,1,10)
		Else
			@ Li,083 Psay Substr(QRSC7->C7_COND,1,10)
		EndIf
		@ Li,094 Psay QRSC7->C7_OBS Picture "@!"
		
		nSomaSC7 += QRSC7->C7_QUANT - QRSC7->C7_QUJE
		
		nI++
		
		QRSC7->(dbSkip())
		
	EndDo
	
	If !Empty(nSomaSC7)
		nD := nSomaSC7
		Li++
		@ Li,012 Psay "Total Ped.Pendentes (D)     " + Transform(nSomaSC7,"@E 9,999,999.9999")
	Else
		nD := 0
		Li++
		@ Li,012 Psay "Total Ped.Pendentes (D)     " + Transform(nD,"@E 9,999,999.9999")
	EndIf
	QRSC7->(DbCloseArea())
	
	aPedidos := {}
	If nContador == 1 .And. nI == 0 .And. Len(aFornece) > 0
		
		cFornece := aFornece[1][2]
		
		If Select("QR5") > 0
			DbSelectArea("QR5")
			DbCloseArea()
		EndIf
		
		_cQry5 := "SELECT SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_PRECO, SC7.C7_DATPRF, SC7.C7_QUANT, SC7.C7_QUJE, SC7.C7_FORNECE, SC7.C7_LOJA, "
		_cQry5 += "       SE4.E4_DESCRI, SA2.A2_NREDUZ "
		_cQry5 += "FROM "+RetSqlName("SC7")+" SC7 "
		_cQry5 += "LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL='"+xFilial("SA2")+"' AND SA2.A2_COND = SC7.C7_FORNECE AND SA2.A2_LOJA=SC7.C7_LOJA AND SC7.D_E_L_E_T_ = ' ' "
		_cQry5 += "LEFT OUTER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL='"+xFilial("SE4")+"' AND SE4.E4_CODIGO = SC7.C7_COND AND SE4.D_E_L_E_T_ = ' ' "
		_cQry5 += "WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ = ' ' "
		_cQry5 += "  AND SC7.C7_FORNECE ='"+cFornece+"'  "
		_cQry5 += "  AND SC7.C7_QUJE < SC7.C7_QUANT "
		_cQry5 += "  AND SC7.C7_RESIDUO = ' ' "
		_cQry5 += "  AND SC7.C7_NUMSC <> '"+QR1->C1_NUM+"'  "
		_cQry5 += "ORDER BY SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_NUM "
		
		TcQuery _cQry5 New Alias "QR5"
		
		While QR5->(!EOF())
			If QR5->C7_DATPRF > Date() .And. Len(aPedidos) < 6
				If ASCAN(aPedidos,{|x| x[1] == DTOS(QR5->C7_DATPRF)}) == 0
					AADD(aPedidos,{DTOS(QR5->C7_DATPRF),QR5->C7_NUM + "/" + SubStr(QR5->C7_ITEM,3,2)})
				EndIf
			EndIf
			QR5->(dbSkip())
		EndDo
		QR5->(DbCloseArea())
		
		cPedidos := ""
		If Len(aPedidos) > 0
			aSort(aPedidos,,,{ |x, y| x[1] < y[1] })
			Li++
			If Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				@ Li, 012 Psay "Continuação do item anterior ......"
				Li:=9
				Li++
			EndIf
			Li++
			@ Li,012 Psay "PEDIDOS PENDENTES P/ESTE FORNECEDOR: "
			Li++
			For I := 1 to Len(aPedidos)
				If I == 4
					@ Li,030 Psay Alltrim(cPedidos)
					Li++
					cPedidos := ""
				EndIf
				cPedidos += "Ped.: "+ aPedidos[I][2] + " " + "Entrega: "+ SubStr(aPedidos[I][1],7,2)+"/"+SubStr(aPedidos[I][1],5,2)+"/"+SubStr(aPedidos[I][1],3,2) + "  "
			Next I
			If cPedidos <> ""
				@ Li,030 Psay Alltrim(cPedidos)
			EndIf
		EndIf
	EndIf
	
	Li++
	nTotG := (nB + nC + nD) - (nE + nF)
	
	If nTotG = 0
		nTotG := (nB + nC + nD) - (nE + nF)
	ElseIf nTotG < 0
		nTotG := nTotG * (-1)
	ElseIf nTotG > 0
		nTotG := 0
	EndIf
	
	Li++
	@ li,012 Psay "Necessidade Compra ( B + C + D ) - ( E + F ) : " + Transform(nTotG,'@E 999,999.999')
	
	Li++
	@ Li,000 Psay Replicate("-",132)
	
	QR1->(dbSkip())
	
EndDo
QR1->(DbCloseArea())

If nNumAnt <> ""
	li++
	@li,030 PSAY "T  O  T  A  L   ==> "
	@li,084 PSAY nTotal Picture "@E 9,999,999.9999" //PesqPict("SB1","B1_UPRC",15,2)
	li += 2
	@li,001 PSAY Replicate ("-",132)
	li++
	@li,001 PSAY "Data de Emissão: "
	@li,019 PSAY dEmissao
	@li,050 PSAY "Data de Impressao: "
	@li,069 PSAY dDatabase
	IF _nReemp >= 1
		@li,100 PSAY "No. de Reemissao: "
		@li,119 PSAY STRZERO(_nReemp,2)
	ENDIF
	li+=2
	@li,001 PSAY "       Emitente: " + cUsuario
	li+=3
	@li,034 PSAY "_____________________________"
	@li,094 PSAY "____/____/____"
	li++
	//@li,001 PSAY "Emitente: " + cUsuario
	@li,040 PSAY "Visto Liberação"
	@li,097 PSAY "Data - Lib."
	
	IF _nRecSC1 > 0
		SC1->(dbGOTO(_nRecSC1))
		RecLock("SC1",.F.)
		IF SUBSTR(cNumEmp,1,2) <> "15"
			SC1->C1_MSULIMP := dDatabase
		ENDIF
		SC1->C1_QTDREEM += 1
		SC1->(MSUNLOCK())
	ENDIF
EndIf

If aReturn[5] = 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return  .T.
/*
//Impressao da Linha do Produto Solicitado Masipack
li++
@ li,000 PSAY QR1->C1_NUM + "/"
@ li,007 PSAY QR1->C1_ITEM Picture PesqPict("SC1","C1_ITEM")
@ li,012 PSAY SubStr(QR1->C1_PRODUTO,1,15) + "-" + QR1->B1_REVATU
@ li,030 PSAY SubStr(cDescri,1,35)
@ li,070 PSAY QR1->C1_QUANT Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.99","@E 9,999,999.9999")
@ li,083 PSAY QR1->C1_UM
@ li,086 PSAY QR1->B1_UPRC Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.99","@E 9,999.9999")
@ li,097 PSAY (QR1->B1_UPRC * QR1->C1_QUANT) Picture "@E 999,999.99"
@ li,108 PSAY If(Empty(QR1->C1_DATPRF),QR1->C1_EMISSAO,QR1->C1_DATPRF)

nTotal := nTotal + (QR1->B1_UPRC * QR1->C1_QUANT)
cDesenho := Alltrim(QR1->C1_Produto)+ Alltrim(QR1->B1_REVATU)

cFabric := ""
If !Empty(QR1->B1_FABRIC)
cFabric := "Fabricante:  " + Alltrim(QR1->B1_FABRIC)
EndIf

cOBS := ""
If !Empty(QR1->C1_OBS)
cOBS := "Obs.: " + Alltrim(QR1->C1_OBS)
EndIf

cAproPlano := ""
If !Empty(QR1->C1_MSAPROP)
cAproPlano := "Apropriação: " + Alltrim(QR1->C1_MSAPROP) + " "
EndIf

If !Empty(QR1->C1_MSPlano)
cAproPlano := cAproPlano + "Plano: " + Alltrim(QR1->C1_MSPlano)
EndIf

// IMPRESSAO DOS DESENHOS MASIPACK
If aReturn[5] > 1 .And. mv_par08 == 1
_cPath := "H:\PLOTTER\"
If SubStr(cNumEmp,1,2) == "01"
If Substr(cDesenho,1,2) == "CL"
_cPath += Substr(cDesenho,3,2) + "\"
ELSE
_cPath += Substr(cDesenho,1,2) + "\"
ENDIF
IF SUBSTR(cDesenho,11,2) == "MP"
cDesenho := SUBSTR(cDesenho,1,10) + SUBSTR(cDesenho,13,1)
ENDIF
ElseIf SubStr(cNumEmp,1,2) == "10"
_cPath  := SubStr(cDesenho,1,3)  + "\"
ElseIf SubStr(cNumEmp,1,2) == "40"
_cPath  := SubStr(cDesenho,1,3)  + "\"
EndIf

AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")

EndIf

Return .T.
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C140IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio FABRIMA                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR004                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R140ImpFab(lEnd,wnrel,cString,nReg)

Local X, nI, I
LOCAL nContador := 0
LOCAL cbCont    := 0
LOCAL cAliasSC1 := "SC1"
//LOCAL cArqInd   := ""
LOCAL nNumAnt   := ""
LOCAL cUsuario  := ""
LOCAL dEmissao  := ""
PRIVATE nTotal  := 0



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a Impressao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLocal   := '01'

If Select("QR1") > 0
	dbSelectArea("QR1")
	dbCloseArea()
EndIf

//MONTA ARRAY PARA IMPRESSÃO
cQry1 := "SELECT SC1.C1_NUM,    SC1.C1_ITEM, SC1.C1_PRODUTO, SC1.C1_QUANT, SC1.C1_QUJE, SC1.C1_EMISSAO, SC1.C1_SOLICIT, "
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
cQry1 += "       SC1.C1_DATPRF, ISNULL(SB5.B5_CEME,'') AS 'B5_CEME', SB1.B1_DESC,    SB1.B1_DESCP, SB1.B1_COD, SB1.B1_ESTSEG,  SB1.B1_LM,   SB1.B1_LE,    "
//cQry1 += "       SC1.C1_DATPRF, SB1.B1_DESC, SB1.B1_DESC,    SB1.B1_DESCP, SB1.B1_COD, SB1.B1_ESTSEG,  SB1.B1_LM,   SB1.B1_LE,    "
//Ticket#2017031037000107 — Fim da alteração
cQry1 += "       SC1.C1_UM, SB1.B1_FABRIC, SB1.B1_REVATU, SC1.C1_OBS, SB1.B1_UPRC, SC1.C1_MSAPROP,  SC1.C1_MSPLANO, SC1.C1_QTDREEM, "
cQry1 += "       SB1.B1_EMAX,   SB1.B1_PE,   SB1.B1_MSGRPMA, SB1.B1_LOCAL, SB2.B2_QEMP,  SB2.B2_RESERVA, SB2.B2_QPEDVEN, SB1.B1_TIPE, SB2.B2_QATU, "
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
cQry1 += "       ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB5.B5_MSOBS)),' ' ) AS B5_MSOBS "
//cQry1 += "       ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB1.B1_MSDTEC)),' ' ) AS B1_MSDTEC "
//Ticket#2017031037000107 — Fim da alteração
If SUBSTR(cNumEmp,1,2) <> "15"
	cQry1 += "       	,C1_MSINTER  "
EndIf
cQry1 += "FROM "+RetSqlName("SC1")+" SC1 "
cQry1 += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC1.C1_PRODUTO AND SB1.D_E_L_E_T_ = ' '    "
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
cQry1 += "LEFT  JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' AND SB5.B5_COD = SC1.C1_PRODUTO AND SB5.D_E_L_E_T_ = ' '    "
//Ticket#2017031037000107 — Fim da alteração
cQry1 += "INNER JOIN "+RetSqlName("SB2")+" SB2 ON SB2.B2_FILIAL = '"+xFilial("SB2")+"' AND SB2.B2_COD = SC1.C1_PRODUTO AND B2_LOCAL = B1_LOCPAD "
/*
IF SUBSTR(cNumEmp,1,2) == "10"
cQry1 += "    AND B2_LOCAL = '01'  "
ENDIF
*/
cQry1 += "WHERE SC1.C1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQry1 += "  AND SC1.C1_EMISSAO BETWEEN '"+DtoS(MV_PAR04)+"' AND '"+DtoS(MV_PAR05)+"' "
cQry1 += "  AND SC1.C1_FILIAL = '"+xFilial("SC1")+"' AND SC1.D_E_L_E_T_ = ' ' "
cQry1 += "  AND SB2.D_E_L_E_T_ = ' ' "
cQry1 += "ORDER BY SC1.C1_NUM, SC1.C1_ITEM  "

TcQuery cQry1 New Alias "QR1"

TcSetField("QR1","C1_EMISSAO","D",08,00)
TcSetField("QR1","C1_DATPRF" ,"D",08,00)
TcSetField("QR1","C1_QUANT"  ,"N",12,03)
TcSetField("QR1","C1_QUJE"   ,"N",12,03)
TcSetField("QR1","B2_QATU"   ,"N",12,03)
TcSetField("QR1","B1_ESTSEG" ,"N",12,03)
TcSetField("QR1","B1_LM"     ,"N",12,03)
TcSetField("QR1","B1_LE","N",12,03)
TcSetField("QR1","B1_EMAX","N",12,03)

dbSelectArea(cAliasSC1)
SetRegua(LastRec())
Titulo  := "Solicitacoes de Compra Valorizadas "
Cabec1  := "Solic.No     Codigo         Rev   D e s c r i ç ã o                       Qtde. UN  Ult.Preço  Total  Necessário"+"  FORNECEDORES"
Cabec2  := "-                                                                                     Compra            p/ dia"
Do While !QR1->(EOF())
	
	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra as que ja' tem pedido cadastrado                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SUBSTR(cNumEmp,1,2) <> "15" .AND. mv_par03 == 2) .OR. (SUBSTR(cNumEmp,1,2) == "15" .AND. mv_par08 == 2)
		If (QR1->C1_QUANT - QR1->C1_QUJE) == 0
			QR1->(dbSkip())
			Loop
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de OPs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par07, 'SC1')
		dbSkip()
		Loop
	EndIf
	
	If QR1->C1_NUM <> nNumAnt
		If nNumAnt <> ""
			li++
			@li,033 PSAY "T  O  T  A  L   ==> "
			@li,087 PSAY nTotal Picture "@E 9,999,999.9999" //ePesqPict("SB1","B1_UPRC",15,2)
			li+=2
			@li,001 PSAY Replicate ("-",132)
			li++
			@li,001 PSAY "Data de Emissão: "
			@li,019 PSAY dEmissao
			@li,050 PSAY "Data de Impressao: "
			@li,069 PSAY dDatabase
			li+=2
			@li,001 PSAY "       Emitente: " + cUsuario
			li+=3
			@li,034 PSAY "_____________________________"
			@li,094 PSAY "____/____/____"
			li++
			//@li,001 PSAY "Emitente: " + cUsuario
			@li,040 PSAY "Visto Liberação"
			@li,097 PSAY "Data - Lib."
		EndIf
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		
		nNumAnt  := QR1->C1_NUM
		cUsuario := QR1->C1_SOLICIT
		dEmissao := DTOC(QR1->C1_EMISSAO)
		nTotal   := 0
		li       := 8
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona os arquivos no registro a ser impresso             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	If Empty(QR1->B5_CEME)		//If Empty(QR1->B1_DESCP)
		cDescri := Alltrim(QR1->B1_DESC)
	Else
		cDescri := Alltrim(QR1->B5_CEME)	//cDescri := Alltrim(QR1->B1_DESCP)
	EndIf

	cInfTec := ""
	/*If !Empty(QR1->B1_MSDTEC)
		cInfTec := Alltrim(QR1->B1_MSDTEC)
	EndIf*/
	If !Empty(QR1->B5_MSOBS)
		cInfTec := Alltrim(QR1->B5_MSOBS)
	EndIf	

	//Ticket#2017031037000107 — Fim da alteração	
	If Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
	EndIf
	
	A140Solic(cDescri,cAliasSC1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os fornecedores indicados para este produto          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nContador := 0
	nDiaFor   := 0                         // Amarracao por Produto
	aFornece  := {}
	
	If Select("QRY2") > 0
		DbSelectArea("QRY2")
		DbCloseArea()
	EndIf
	
	_cQry2 := "SELECT SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, SA2.A2_MSDIASE "
	_cQry2 += "FROM "+RetSqlName("SA5")+" SA5 "
	_cQry2 += "LEFT OUTER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '  ' AND SA2.A2_COD = SA5.A5_FORNECE AND SA2.A2_LOJA = SA5.A5_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	_cQry2 += "WHERE SA5.A5_PRODUTO = '"+AllTrim(QR1->C1_PRODUTO)+"' "
	_cQry2 += "  AND SA5.A5_FILIAL = '  ' AND SA5.D_E_L_E_T_ = ' ' "
	
	TcQuery _cQry2 New Alias "QR2"
	
	While !QR2->(EOF())
		nDiaFor  := Val(QR2->A2_MSDIASE)
		nContador++
		cFornece := QR2->A2_COD + "-" + Substr(QR2->A2_NREDUZ,1,15)
		AADD(aFornece,{cFornece,QR2->A2_COD+QR2->A2_LOJA})
		QR2->(dbSkip())
	EndDo
	
	QR2->(DbCloseArea())
	
	nFor := 1
	If Len(cDescri) > 28
		Li++
		@ li,033 PSAY SubStr(cDescri,29,70)
	EndIf
	
	Li++
	If !Empty(SUBSTR(cAproPlano,1,80))
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,000 PSAY SUBSTR(cAproPlano,1,80)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
			Li++
		EndIf
	EndIf
	
	If !Empty(SUBSTR(cAproPlano,81,74))
		@ li,012 PSAY SUBSTR(cAproPlano,81,74)
	ENDIF
	
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	Li++
	If Li > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		@ Li, 012 Psay "Continuação do item anterior ......"
		Li:=9
		Li++
	EndIf
	
	If !Empty(SUBSTR(cAproPlano,155,23))
		@ li,000 PSAY SUBSTR(cAproPlano,155,23)
	ENDIF
	
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	
	If !Empty(cInfTec)
		For X := 1 TO MLCOUNT(cInfTec,70)
			Li++
			If Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				@ Li, 012 Psay "Continuação do item anterior ......"
				Li:=9
				Li++
			EndIf
			@li,033 PSay MEMOLINE(cInfTec,70,X)
			If nFor <= nContador
				@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
				nFor++
			EndIf
		Next
		Li++
	EndIf
	
	If !Empty(cFabric)
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,033 PSAY Alltrim(cFabric)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	EndIf
	
	If !Empty(cObs)
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,0 PSAY SubStr(cOBS,1,70)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	EndIf
	If Len(cObs) > 70
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li,033 PSAY SubStr(cOBS, 70,70)
		If nFor <= nContador
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		EndIf
	EndIf
	li++
	If SUBSTR(cNumEmp,1,2) <> "15"
		If QR1->C1_MSINTER == "S"
			If Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				Li:=9
				
			EndIf
			Li++
			@ Li,009 PSAY "Solicitação é INTERCOMPANY !  "
			Li++
			Li++
		EndIf
	EndIf
	nEmpProd := 0
	nEmpProd := QR1->B2_QEMP + QR1->B2_RESERVA + QR1->B2_QPEDVEN
	
	@ li,012 PSAY "Estoque.....: " + Transform(QR1->B2_QATU,'@E 999,999.999') + "  Empenho..: " + Transform(nEmpProd,'@E 99,999.999') + "  Local.......: " + QR1->B1_LOCAL
	If nFor <= nContador
		@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
		nFor++
	EndIf
	lLinha := .F.
	IF QR1->B1_ESTSEG + QR1->B1_LM + QR1->B1_LE + QR1->B1_EMAX > 0
		lLinha := .T.
		li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li, 012 PSAY "Est.Seg.....: " + Transform(QR1->B1_ESTSEG,'@E 99,999.999')  + "  Lote Min.: " + Transform(QR1->B1_LM,'@E 99,999.999') + "  Lote Econ...: " + Transform(QR1->B1_LE,'@E 99,999.999')  + IF(SB1->B1_EMAX > 0,"  Estoq.Max.: " + Transform(SB1->B1_EMAX,'@E 99,999.999'),"")
	ENDIF
	IF !EMPTY(SB1->B1_PE)
		lLinha := .T.
		li++
		IF Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		@ li, 033 PSAY "Prazo de Entrega: " + Transform(QR1->B1_PE,'@E 9999')  + "  Tipo: " + QR1->B1_TIPE + IF(!EMPTY(QR1->B1_MSGRPMA),"  Cod.Grupo Masipack: " + QR1->B1_MSGRPMA,"")
	ENDIF
	If nContador >= nFor
		For nI := nFor to nContador
			IF lLinha
				lLinha := .F.
			ELSE
				Li++
			ENDIF
			If Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				@ Li, 012 Psay "Continuação do item anterior ......"
				Li:=9
				Li++
			EndIf
			@ li,112 PSAY Substr(aFornece[nFor][1],1,21)
			nFor++
		Next nI
	EndIf
	
	If nContador == 1 .And. nDiaFor > 0
		If Dow(SC1->C1_DATPRF) <> nDiaFor
			Li+=2
			@ Li,012 Psay "Atenção, Data de entrega, Dia da semana: "+aSemana[Dow(SC1->C1_DATPRF)] + " diferente do Fornecedor: "+aSemana[nDiaFor]
		EndIf
	EndIf
	nI := 0
	
	If Select("QR5") > 0
		DbSelectArea("QR5")
		DbCloseArea()
	EndIf
	
	_cQry5 := "SELECT SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_PRECO, SC7.C7_DATPRF, SC7.C7_QUANT, SC7.C7_QUJE, SC7.C7_FORNECE, SC7.C7_LOJA, "
	_cQry5 += "       SE4.E4_DESCRI, SA2.A2_NREDUZ "
	_cQry5 += "FROM "+RetSqlName("SC7")+" SC7 "
	_cQry5 += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SA2.A2_COND = SC7.C7_FORNECE AND SA2.A2_LOJA=SC7.C7_LOJA AND SC7.D_E_L_E_T_ = ' ' "
	_cQry5 += "LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' AND SE4.E4_CODIGO = SC7.C7_COND AND SE4.D_E_L_E_T_ = ' ' "
	_cQry5 += "WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ = ' ' "
	_cQry5 += "  AND SC7.C7_FORNECE ='"+cFornece+"'  "
	_cQry5 += "  AND SC7.C7_QUJE < SC7.C7_QUANT "
	_cQry5 += "  AND SC7.C7_RESIDUO = ' ' "
	_cQry5 += "  AND SC7.C7_NUMSC <> '"+QR1->C1_NUM+"'  "
	_cQry5 += "ORDER BY SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_NUM "
	
	TcQuery _cQry5 New Alias "QR5"
	
	While !QR5->(EOF())
		If !Empty(QR5->A2_NREDUZ)
			cForn := SubStr(QR5->A2_NREDUZ,1,15)
		Else
			cForn := "Fornecedor não encontrado"
		EndIf
		
		Li++
		If Li > 60
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			@ Li, 012 Psay "Continuação do item anterior ......"
			Li:=9
			Li++
		EndIf
		
		If  nI == 0
			Li++
			@ Li,012 Psay "PEDIDOS PENDENTES P/ESTE ITEM: "
			Li++
			@ Li,012 Psay "Pedido/Item  Fornecedor       Qtd.Pendente  Vlr.Unitario  Dt.Entrega    Cond.Pgto"
			Li++
		EndIf
		
		@ Li,012 Psay QR5->C7_NUM + "/" + QR5->C7_ITEM
		@ Li,026 Psay cForn
		@ Li,043 Psay QR5->C7_QUANT - QR5->C7_QUJE Picture "@E 99,999.999"
		@ Li,054 Psay QR5->C7_PRECO Picture "@E 99,999,999.99"
		@ Li,072 Psay QR5->C7_DATPRF
		If !Empty(QR5->E4_DESCRI)
			@ Li,085 Psay QR5->E4_DESCRI
		Else
			@ Li,085 Psay QR5->C7_COND
		EndIf
		
		nI++
		
		QR5->(dbSkip())
		
	EndDo
	
	aPedidos := {}
	If nContador == 1 .And. nI == 0 .And. Len(aFornece) > 0
		
		cFornece := aFornece[1][2]
		
		If Select("QR5") > 0
			DbSelectArea("QR5")
			DbCloseArea()
		EndIf
		
		_cQry5 := "SELECT SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_PRECO, SC7.C7_DATPRF, SC7.C7_QUANT, SC7.C7_QUJE, SC7.C7_FORNECE, SC7.C7_LOJA, "
		_cQry5 += "       SE4.E4_DESCRI, SA2.A2_NREDUZ "
		_cQry5 += "FROM "+RetSqlName("SC7")+" SC7 "
		_cQry5 += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SA2.A2_COND = SC7.C7_FORNECE AND SA2.A2_LOJA=SC7.C7_LOJA AND SC7.D_E_L_E_T_ = ' ' "
		_cQry5 += "INNER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' AND SE4.E4_COND = SC7.C7_COND AND SE4.D_E_L_E_T_ = ' ' "
		_cQry5 += "WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ = ' ' "
		_cQry5 += "  AND SC7.C7_FORNECE ='"+cFornece+"'  "
		_cQry5 += "  AND SC7.C7_QUJE < SC7.C7_QUANT "
		_cQry5 += "  AND SC7.C7_RESIDUO = ' ' "
		_cQry5 += "  AND SC7.C7_NUMSC <> '"+QR1->C1_NUM+"'  "
		_cQry5 += "ORDER BY SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_NUM "
		
		TcQuery _cQry5 New Alias "QR5"
		
		While QR5->(!EOF())
			If QR5->C7_DATPRF > Date() .And. Len(aPedidos) < 6
				If ASCAN(aPedidos,{|x| x[1] == DTOS(QR5->C7_DATPRF)}) == 0
					AADD(aPedidos,{DTOS(QR5->C7_DATPRF),QR5->C7_NUM + "/" + SubStr(QR5->C7_ITEM,3,2)})
				EndIf
			EndIf
			QR5->(dbSkip())
		EndDo
		
		cPedidos := ""
		If Len(aPedidos) > 0
			aSort(aPedidos,,,{ |x, y| x[1] < y[1] })
			Li++
			If Li > 60
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				@ Li, 012 Psay "Continuação do item anterior ......"
				Li:=9
				Li++
			EndIf
			Li++
			@ Li,012 Psay "PEDIDOS PENDENTES P/ESTE FORNECEDOR: "
			Li++
			For I := 1 to Len(aPedidos)
				If I == 4
					@ Li,033 Psay Alltrim(cPedidos)
					Li++
					cPedidos := ""
				EndIf
				cPedidos += "Ped.: "+ aPedidos[I][2] + " " + "Entrega: "+ SubStr(aPedidos[I][1],7,2)+"/"+SubStr(aPedidos[I][1],5,2)+"/"+SubStr(aPedidos[I][1],3,2) + "  "
			Next I
			If cPedidos <> ""
				@ Li,033 Psay Alltrim(cPedidos)
			EndIf
		EndIf
	EndIf
	Li++
	@ Li,000 Psay Replicate("-",132)
	
	QR1->(dbSkip())
	
	Loop
EndDo

QR1->(dbCloseArea())

If nNumAnt <> ""
	li++
	@li,033 PSAY "T  O  T  A  L   ==> "
	@li,087 PSAY nTotal Picture "@E 9,999,999.9999" //PesqPict("SB1","B1_UPRC",15,2)
	li += 2
	@li,001 PSAY Replicate ("-",132)
	li++
	@li,001 PSAY "Data de Emissão: "
	@li,019 PSAY dEmissao
	li+=2
	@li,001 PSAY "       Emitente: " + cUsuario
	li+=3
	@li,034 PSAY "_____________________________"
	@li,094 PSAY "____/____/____"
	li++
	//@li,001 PSAY "Emitente: " + cUsuario
	@li,040 PSAY "Visto Liberação"
	@li,097 PSAY "Data - Lib."
EndIf

//dbSelectArea("SC1")
//RetIndex("SC1")
//If File(cArqInd+ OrdBagExt())
//	FErase(cArqInd+ OrdBagExt() )
//EndIf

If aReturn[5] = 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return  .T.

Static Function A140Solic(cDescri,cAliasSC1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Linha do Produto Solicitado                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local j

li++
@ li,000 PSAY QR1->C1_NUM + "/"
@ li,007 PSAY QR1->C1_ITEM Picture PesqPict("SC1","C1_ITEM")
@ li,012 PSAY SubStr(QR1->C1_PRODUTO,1,15) + "-" + QR1->B1_REVATU
@ li,033 PSAY SubStr(cDescri,1,28)
@ li,070 PSAY QR1->C1_QUANT Picture "@E 999,999.9999"
@ li,083 PSAY QR1->C1_UM
@ li,086 PSAY QR1->B1_UPRC Picture IIF(SUBSTR(cNumEmp,1,2) == "01","@E 999,999.99","@E 9,999.9999")
@ li,097 PSAY (QR1->B1_UPRC * QR1->C1_QUANT) Picture "@E 999,999.99"
@ li,108 PSAY If(Empty(QR1->C1_DATPRF),QR1->C1_EMISSAO,QR1->C1_DATPRF)

nTotal := nTotal + (QR1->B1_UPRC * QR1->C1_QUANT)
cDesenho := Alltrim(QR1->C1_Produto)+ Alltrim(QR1->B1_REVATU)

cFabric := ""
If !Empty(QR1->B1_FABRIC)
	cFabric := "Fabricante:  " + Alltrim(QR1->B1_FABRIC)
EndIf

cOBS := ""
If !Empty(QR1->C1_OBS)
	cOBS := "Obs.: " + Alltrim(QR1->C1_OBS)
EndIf

cAproPlano := ""
If !Empty(QR1->C1_MSAPROP)
	cAproPlano := "Apropriação: " + Alltrim(QR1->C1_MSAPROP) + " "
EndIf

If !Empty(QR1->C1_MSPlano)
	cAproPlano := cAproPlano + "Plano: " + Alltrim(QR1->C1_MSPlano)
EndIf

// IMPRESSÃO DOS DESENHOS
If aReturn[5] > 1 .And. mv_par08 == 1
	_cPath := "H:\PLOTTER\"
	If SubStr(cNumEmp,1,2) == "01"
		If Substr(cDesenho,1,2) == "CL"
			_cPath += Substr(cDesenho,3,2) + "\"
		ELSE
			_cPath += Substr(cDesenho,1,2) + "\"
		ENDIF
		IF SUBSTR(cDesenho,11,2) == "MP"
			cDesenho := SUBSTR(cDesenho,1,10) + SUBSTR(cDesenho,13,1)
		ENDIF
	ElseIf SubStr(cNumEmp,1,2) == "10"
		_cPath  := SubStr(cDesenho,1,3)  + "\"
	ElseIf SubStr(cNumEmp,1,2) == "40"
		_cPath  := SubStr(cDesenho,1,3)  + "\"
	EndIf
	
	AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
	AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
	AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
	WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
	WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
	WaitRun("H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
	
EndIf

Return .T.
