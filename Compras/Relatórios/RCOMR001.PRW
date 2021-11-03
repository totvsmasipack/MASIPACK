#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"
#define _CRLF CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCOMR001 ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Compras                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   ALTERADO POR APARECIDA LAYOUT MASIPACK - 30/09/2003                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// mv_par13 Envia e-mail para Fornecedor?	//Comentado todas as chamadas do MV_PAR13 por FMD conforme solicitacao Eduardo - 23/09/10
// Reescrito em 19/07/2013 por Ana Paula QF

User Function RCOMR001(cAlias,nReg,nOpcx)

Local cDesc1	  := "Emissao pedidos de compras ou autorizacoes de entrega"
Local cDesc2	  := "cadastradados e que ainda nao foram impressos"
Local cDesc3	  := "G"
Local aRet
Local cUsrName

Private tamanho   := "G"
Private limite    := 220
Private cabec1    := ""
Private cabec2    := ""
Private Li        := 01
Private nTipo     := 18
Private cPerg     := "XRCOMR001 "
Private nomeprog  := "RCOMR001"
Private wnrel     := "RCOMR001"
Private cString   := "SC7"
Private nCont     := 0
Private titulo	  := "Emissao Pedidos de Compras ou Autorizacoes de Entrega"
Private aReturn   := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Private nLastKey  := 0
Private nBegin	  := 0
Private cTexto1   := ""
Private cTexto2   := ""
Private cTexto3   := ""
Private cRev      := ""
Private cMensagem := " "
Private cTitulo   := " "
Private cPedido   := Space(06)
Private cMail     := " "
Private cEnd      := " "
Private cInfTec   := ""
Private _cDE		:= ""
Private cObsItem
Private cObsIt
Private nTotalNF	 :=  0//MaFisRet(1,'NF_TOTAL')
Private nTotIpi	 := 0//MaFisRet(1,'NF_VALIPI')  
Private nTotFrete  := 0//MaFisRet(1,'NF_FRETE')
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Campo Descricao do Produto    	     ³
//³ mv_par06               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par07               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par08               Pedidos ? Liberados Bloqueados Ambos  ³
//³ mv_par09               Impr. SC's Firmes, Previstas ou Ambas ³
//³ mv_par10               Endereco de Entrega                   ³
//³ mv_par11               A partir da data de entrega           ³
//³ mv_par12               Ate a data de entrega                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,nomeprog,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif
mv_par05 := "B1_DESC"
nTipo := If(aReturn[4]==1,15,18)

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := "SELECT SC7.C7_NUM,    SC7.C7_ITEM,    SC7.C7_PRODUTO, SC7.C7_TIPO,    SC7.C7_EMISSAO, SC7.C7_DATPRF, SC7.C7_TOTAL,   "
_cQuery += "       SC7.C7_PRECO,SC7.C7_FRETE,  SC7.C7_QUANT,   SC7.C7_UM, SC7.C7_DESCRI,  SC7.C7_FORNECE, SC7.C7_SEGUM,  SC7.C7_QTSEGUM, "
_cQuery += "       SC7.C7_OBS,    SC7.C7_QTDREEM, SC7.C7_DESC1,   SC7.C7_DESC2,   SC7.C7_DESC3,   SC7.C7_VALIPI, SC7.C7_MSG,     "
IF SUBSTR(cNumEmp,1,2) <> "15"
	IF SUBSTR(cNumEmp,1,2)  == "01"
		_cQuery += "       	 SB1.B1_MSCONF, SB1.B1_MSCERT,  "
	ENDIF
	_cQuery += "       SC7.C7_MSTXT1, SC7.C7_MSTXT2, SC7.C7_MSTXT3, SA5.A5_MSCARAC, "
	//Ivandro Santos - 07/04/17 - inicio da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	_cQuery += "       SA2.A2_MSPONT, SA2.A2_EMAIL2, "
	//_cQuery += "       SA2.A2_MSPONT, SA2.A2_EMAIL2, SB1.B1_DESCP, "
	//_cQuery += "       ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB1.B1_MSDTEC)),' ' ) AS B1_MSDTEC,  "
	_cQuery += "       ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB5.B5_MSOBS)),' ' ) AS B5_MSOBS,  "
	//Ticket#2017031037000107 — Fim da alteração
ELSE
	//_cQuery += "       SA2.A2_MSEMAIL, " - Alteração feita por campo não existir mais / Felipe Freitas
	_cQuery += "       ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SB5.B5_MSOBS)),' ' ) AS B5_MSOBS, SA2.A2_EMAIL2, "
ENDIF
_cQuery += "       SC7.C7_FILENT,  SC7.C7_REAJUST, SC7.C7_MOEDA,   SC7.C7_COND,   SC7.C7_CONTATO, "
_cQuery += "       SC7.C7_VLDESC, SC7.C7_IPI, SE4.E4_DESCRI, SB1.B1_PROCED,  "
_cQuery += "       SB1.B1_FABRIC, SB1.B1_REVATU,  SB1.B1_DESC,    SB5.B5_CEME,    SB5.B5_DES,      "
_cQuery += "       SA5.A5_CODPRF,   SA2.A2_COD,     SA2.A2_LOJA,    SA2.A2_NOME,   SA2.A2_RISCO,   "
_cQuery += "       SA2.A2_END,     SA2.A2_BAIRRO,  SA2.A2_MUN,     SA2.A2_EST,    SA2.A2_CEP,     "
_cQuery += "       SA2.A2_CGC,    SA2.A2_TIPO,    SA2.A2_INSCR,   SA2.A2_DDD,     SA2.A2_TEL,     SA2.A2_FAX     "
_cQuery += "FROM "+RetSqlName("SC7")+" SC7 "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' AND SE4.E4_CODIGO = SC7.C7_COND AND SE4.D_E_L_E_T_ = ' '  "
_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC7.C7_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' AND SB5.B5_COD = SC7.C7_PRODUTO AND SB5.D_E_L_E_T_ = ' ' "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SA5")+" SA5 ON SA5.A5_FILIAL = '"+xFilial("SA5")+"' AND SA5.A5_FORNECE = SC7.C7_FORNECE AND A5_LOJA = C7_LOJA AND SA5.A5_PRODUTO = SC7.C7_PRODUTO AND SA5.D_E_L_E_T_ = ' ' "
_cQuery += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA AND SA2.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE SC7.C7_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
_cQuery += "  AND SC7.C7_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"'  "
_cQuery += "  AND SC7.C7_DATPRF  BETWEEN '"+DtoS(MV_PAR11)+"' AND '"+DtoS(MV_PAR12)+"'  "
If mv_par07 = 1
	_cQuery += "  AND SC7.C7_TIPO = '1' "
Else
	_cQuery += "  AND SC7.C7_TIPO = '2' "
EndIf
If MV_PAR08 = 1
	_cQuery += "  AND SC7.C7_CONAPRO = 'L' "
ElseIf MV_PAR08 = 2
	_cQuery += "  AND SC7.C7_CONAPRO = 'B' "
EndIf
_cQuery += "  AND SC7.C7_FILIAL = '"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ = ' '  "
_cQuery += "ORDER BY SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_SEQUEN  "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","C7_EMISSAO","D",08,00)
TcSetField("QR1","C7_DATPRF" ,"D",08,00)

If mv_par07 == 1     // Pedido de Compra
	RptStatus({|lEnd| C110PC(@lEnd,wnRel,cString,nReg)},titulo)
ElseIf MV_PAR07 == 2 // Autorização de Entrega
	RptStatus({|lEnd| C110AE(@lEnd,wnRel,cString,nReg)},titulo)
EndIf

QR1->(dbCloseArea())

lPedido := .F.

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C110PC(lEnd,WnRel,cString,nReg)
Local i
Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aSavRec := {}
Local nLinObs := 0

Private cCGCPict, cCepPict

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

nDescProd := 0
nTotal    := 0
nTotMerc  := 0
nWrel     := 0
nLimit    := 45
NumPed    := Space(6)

SetRegua(RecCount())           	           // TOTAL DE ELEMENTOS DA REGUA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do While !QR1->(EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	IncRegua()
	          
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par09, 'SC7')
		dbSkip()
		Loop
	EndIf
	*/
//	MaFisEnd()  

//	MaFisIniPC(QR1->C7_NUM,QR1->C7_ITEM)
	
	//MaFisIni(QR1->C7_NUM)
	AbreArq()                                                  
	ImpCabec()
	
	nTotal    := 0
	nTotMerc  := 0
	nDescProd := 0
	nReem     := QR1->C7_QTDREEM + 1
	nSavRec   := SC7->(Recno())
	NumPed    := QR1->C7_NUM
	nLinObs   := 0
	nCont     := 1
	nTotalNF	 := 0//MaFisRet(1,'NF_TOTAL')
 	nTotIpi	 := 0//MaFisRet(1,'NF_VALIPI')  
 	nTotFrete := 0//MaFisRet(1,'NF_FRETE')
	Do While NumPed == QR1->C7_NUM
		
		If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
			AADD(aSavRec,Recno())
		Endif
		IF lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se havera salto de formulario                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If li > 63
			ImpCabec()
		Endif
		
		Li+= 2
		@ li,001 PSAY Replicate("-",limite)
		li++
		@ li,001 PSAY QR1->C7_ITEM  		Picture PesqPict("SC7","C7_ITEM")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa Descricao do Produto                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ImpProd()
		
		If li > 59
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		Endif
		If QR1->C7_DESC1 != 0 .or. QR1->C7_DESC2 != 0 .or. QR1->C7_DESC3 != 0
			nDescProd+= CalcDesc(QR1->C7_TOTAL,QR1->C7_DESC1,QR1->C7_DESC2,QR1->C7_DESC3)
		Else
			nDescProd+=QR1->C7_VLDESC
		Endif
		
		QR1->(dbSkip())
		
	EndDo
	
	dbGoto(nSavRec)
	
	If li > 59
		ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
		ImpCabec()
	Endif
	
	FinalPed(nDescProd)		// Imprime os dados complementares do PC
	
	//MaFisEnd()
	
	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			// José Roberto em 24/04/2019
			// RecLock("SC7",.F.)        //Atualizacao do flag de Impressao
			// C7_QTDREEM := (QR1->C7_QTDREEM+1)
			// C7_EMITIDO := "S"
			// SC7->(MsUnLock())
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	Endif
	
	aSavRec := {}
	
	Loop
	
EndDo

if aReturn[5] == 3
	Eject
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110AE   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C110AE(lEnd,WnRel,cString,nReg)
Local i
Local nReem
Local nSavRec,aSavRec := {}
Local nLinObs := 0

Private cCGCPict, cCepPict
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

nDescProd:= 0
nTotal   := 0
nTotMerc	:= 0
NumPed   := Space(6)

SetRegua(Reccount())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do While !QR1->(EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par09, 'SC7')
		QR1->(dbSkip())
		Loop
	EndIf
	
  	//MaFisEnd()
	//MaFisIniPC(QR1->C7_NUM,QR1->C7_ITEM)
	
	nCont     := 0
	nTotal    := 0
	nTotMerc  := 0
	nDescProd := 0
	nReem     := QR1->C7_QTDREEM + 1
	nSavRec   := SC7->(Recno())
	NumPed    := QR1->C7_NUM
	nLinObs   := 0
	
	Do While NumPed == QR1->C7_NUM
		
		If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
			AADD(aSavRec,Recno())
		Endif
		
		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Goto Bottom
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se havera salto de formulario                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If li > 63
			ImpCabec()
		Endif
		
		Li += 2
		@ li,001 PSAY Replicate("-",limite)
		li++
		@ li,001 PSAY QR1->C7_ITEM  	Picture PesqPict("SC7","C7_ITEM")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa Descricao do Produto                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		ImpProd()		// Imprime dados do Produto
		
		If li > 59
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		Endif
		
		If QR1->C7_DESC1 != 0 .or. QR1->C7_DESC2 != 0 .or. QR1->C7_DESC3 != 0
			nDescProd += CalcDesc(QR1->C7_TOTAL,QR1->C7_DESC1,QR1->C7_DESC2,QR1->C7_DESC3)
		Else
			nDescProd += QR1->C7_VLDESC
		Endif
		
		QR1->(dbSkip())
		
	EndDo
	
	dbGoto(nSavRec)
	
	If li > 59
		ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
		ImpCabec()
	Endif
	
	FinalAE(nDescProd)		// dados complementares da Autorizacao de Entrega
	
	//MaFisEnd()
	
	If Len(aSavRec)>0
		dbGoto(aSavRec[Len(aSavRec)])
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			// José Roberto em 24/04/2019
			// RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			// C7_EMITIDO := "S"
			// C7_QTDREEM := (QR1->C7_QTDREEM+1)
			// SC7-(MsUnLock())
		Next
	Endif
	aSavRec := {}
	
	Loop
	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir dados Cadastrais do Produto.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProd()
Local X
Local cDesc
Local nLinRef  := 1
Local nBegin   := 0
Local nLinha   :=0
Local nTamDesc := 50

cProced := ""
cDescri  := ""
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
/*IF SUBSTR(cNumEmp,1,2) == "15"
		cDescri := Alltrim(QR1->B5_CEME)
	ELSE
		If QR1->B1_DESCP == "                                                                                                         "
			cDescri := Alltrim(QR1->B1_DESC)
		Else
			cDescri := Alltrim(QR1->B1_DESCP)
		EndIF
EndIF*/
cDescri := Alltrim(QR1->B5_CEME)
If Empty(Alltrim(cDescri))
	cDescri := Alltrim(QR1->B1_DESC)
Endif
//Ticket#2017031037000107 — fim da alteração
/*If Empty(mv_par05)
	mv_par05 := "B1_DESP"
EndIf

If AllTrim(mv_par05) == "B1_DESC"
	cDescri := Alltrim(QR1->B1_DESC)
ELSEIF AllTrim(mv_par05) == "B5_CEME"
	cDescri := Alltrim(QR1->B5_CEME)
ELSEIF AllTrim(mv_par05) == "C7_DESCRI"
	cDescri := Alltrim(QR1->C7_DESCRI)
ELSEIF AllTrim(mv_par05) == "B1_DESCP"
	IF SUBSTR(cNumEmp,1,2) == "15"
		cDescri := IIF(EMPTY(QR1->B5_CEME),Alltrim(QR1->B1_DESC),Alltrim(QR1->B5_CEME))
	ELSE
		cDescri := IIF(EMPTY(QR1->B1_DESCP),Alltrim(QR1->B1_DESC),Alltrim(QR1->B1_DESCP))
	ENDIF
ELSE
	cDescri := Alltrim(QR1->B1_DESCP)
ENDIF*/

cProced := Substr(QR1->B1_PROCED,2,1)
cObsItem := ALLTRIM(QR1->c7_obs)
cRev := QR1->B1_REVATU
cCertif  := ""
cInfTec := ""
cDesenho := ""
cConform := ""
IF SUBSTR(cNumEmp,1,2) <> "15"
	cDesenho := QR1->B5_DES   
	IF SUBSTR(cNumEmp,1,2) == '01'
		cConform := QR1->B1_MSCONF
		cCertif  := QR1->B1_MSCERT
	ENDIF	
	//Ivandro Santos - 25/04/17 - inicio da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	If !Empty(QR1->B5_MSOBS)
		cInfTec := Alltrim(QR1->B5_MSOBS)
	EndIf		
	/*If !Empty(QR1->B1_MSDTEC)
		cInfTec := Alltrim(QR1->B1_MSDTEC)
	EndIf*/
	//Ticket#2017031037000107 — Fim da alteração
ENDIF

If !Empty(QR1->B5_MSOBS)
	cInfTec := Alltrim(QR1->B5_MSOBS)
EndIf

If !Empty(QR1->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(QR1->A5_CODPRF)+")"
EndIf

nLinha:= MLCount(cDescri,nTamDesc)
@ li,006 PSAY Alltrim(QR1->C7_PRODUTO) + "-" + Alltrim(cRev)
@ li,022 PSAY SubStr(cDescri,1,50)
IF !EMPTY(SUBSTR(cDescri,51))
	li++
	@ li,022 PSAY Alltrim(SUBSTR(cDescri,51,50))
ENDIF
IF !EMPTY(SUBSTR(cDescri,101))
	li++
	@ li,022 PSAY Alltrim(SUBSTR(cDescri,101,50))
ENDIF

If !Empty(cInfTec)
	For X := 1 TO MLCOUNT(cInfTec,50)
		Li++
		If Li > 68
			ImpCabec()
		EndIf
		@li,022 PSay MEMOLINE(cInfTec,50,X)
	Next
EndIf

ImpCampos()

If !Empty(QR1->B1_FABRIC)
	Li++
	@ li, 022 Psay "Fabricante: " + Alltrim(QR1->B1_FABRIC)
EndIf

If !Empty(cObsItem)
	li++
	@ li,022 PSAY "Obs.: " + cObsItem
EndIf

If !Empty(cCertif) .And. cCertif == "S"
	li++
	@ li,022 PSAY "Certificado: " + cCertif
EndIf

If !Empty(cConform) .And. cConform == "S"
	li++
	@ li,022 PSAY "Conformidade: " + cConform
EndIf
IF SUBSTR(cNumEmp,1,2) <> "15"
	If !Empty(QR1->A5_MSCARAC)
		li++
		@ li,022 PSAY (QR1->A5_MSCARAC)
	EndIf
ENDIF

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCampos()

dbSelectArea("SC7")

//If MV_PAR06 == 2 .And. !Empty(QR1->C7_SEGUM)  - ALTERADO 22/05/14 LIZANDRA

If !Empty(QR1->C7_SEGUM)
	@ li,086 PSAY QR1->C7_SEGUM
Else
	@ li,086 PSAY QR1->C7_UM
EndIf


//If MV_PAR06 == 2 .And. !Empty(QR1->C7_SEGUM)

	IF ALLTRIM(QR1->C7_UM) == "PC"
		@ li,PCOL()+1	PSAY QR1->C7_QUANT Picture "@E 99,999,999"
	ELSE
		@ li,PCOL()+1	PSAY QR1->C7_QUANT Picture "@E 99,999.999"
	ENDIF

//If MV_PAR06 == 2 .And. !Empty(QR1->C7_SEGUM)

	@ li,PCOL()+2	PSAY QR1->C7_PRECO Picture "@E 999,999.9999"

@ li,PCOL()+2 PSAY QR1->C7_IPI Picture PesqPictQt("C7_IPI",5)
@ li,PCOL()+5 PSAY QR1->C7_VALIPI Picture "@E 999,999.99"
@ li,PCOL()+5 PSAY (QR1->C7_TOTAL + QR1->C7_VALIPI) Picture "@E 9,999,999.99"
@ li,PCOL()+5 PSAY QR1->C7_DATPRF
@ li,PCOL()+2 PSAY IIf(cProced=="P","*","#")

nTotal    := nTotal+QR1->C7_TOTAL
nTotMerc  := nTotMerc+QR1->C7_TOTAL//MaFisRet(1,"NF_TOTAL")
nTotIpi   += QR1->C7_VALIPI
nTotalNF  += QR1->C7_VALIPI + QR1->C7_TOTAL  
nTotFrete += QR1->C7_FRETE
cMascara  := "@E 99,999.999"
cMascara1 := "@E 99999-999"
cMascara2 := "9999"
cMascara3 := "@R 99.999.999/9999-99" 
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
/* 
IF SUBSTR(cNumEmp,1,2) == "15"
		cDescri := Alltrim(QR1->B5_CEME)
	ELSE
		If QR1->B1_DESCP == "                                                                                                         "
			cDescri := Alltrim(QR1->B1_DESC)
		Else
			cDescri := Alltrim(QR1->B1_DESCP)
		EndIF
EndIF*/
cDescri := Alltrim(QR1->B5_CEME)
If Empty(Alltrim(cDescri))
	cDescri := Alltrim(QR1->B1_DESC)
Endif
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
/*If Empty(mv_par05)
	mv_par05 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If AllTrim(mv_par05) == "B1_DESC"
	cDescri := Alltrim(QR1->B1_DESC)
ELSEIF AllTrim(mv_par05) == "B5_CEME"
	cDescri := Alltrim(QR1->B5_CEME)
ELSEIF AllTrim(mv_par05) == "C7_DESCRI"
	cDescri := Alltrim(QR1->C7_DESCRI)
ELSEIF AllTrim(mv_par05) == "B1_DESCP"
	IF SUBSTR(cNumEmp,1,2) == "15"
		cDescri := Alltrim(QR1->B5_CEME)
	ELSE
		cDescri := Alltrim(QR1->B1_DESCP)
	ENDIF
ELSE
	cDescri := Alltrim(QR1->B1_DESCP)
ENDIF

If AllTrim(mv_par05) == "B1_DESC"
	cRev    := QR1->B1_REVATU
	cDescri := QR1->B1_DESC
	IF SUBSTR(cNumEmp,1,2) <> "15"
		IF !EMPTY(QR1->B1_DESCP)            // descricao prolongada
			cDescri := QR1->B1_DESCP
		ENDIF
	ENDIF	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par05) == "B5_CEME"
	cDescri := QR1->B5_CEME
EndIf

cObsIt := QR1->C7_OBS
If AllTrim(mv_par05) == "C7_DESCRI"
	cDescri := QR1->C7_DESCRI
EndIf
cDescri := QR1->C7_DESCRI
If Empty(cDescri)
	cRev    := QR1->B1_REVATU
	cDescri := QR1->B1_DESC
	IF SUBSTR(cNumEmp,1,2) <> "15"
		If !Empty(QR1->B1_DESCP)
			cDescri := QR1->B1_DESCP
		EndIf
	ENDIF	
EndIf

If !Empty(QR1->A5_CODPRF)
	cDescri := cDescri + " ("+QR1->A5_CODPRF+")"
EndIf*/
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed(nDescProd)

Local nk 		:= 1,nG
Local nQuebra	:= 0
Local nTotDesc	:= nDescProd
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprov	:=""
Local cPath     := GetMv("MV_RELT")
Local cNome     := "rcomr001"
Local cArq 	    := cPath + cNome

Local nTotIcms	 := 0//MaFisRet(1,'NF_VALICM')
Local nTotDesp	 := 0//MaFisRet(1,'NF_DESPESA')


Local nTotSeguro:= 0//MaFisRet(1,'NF_SEGURO')
Local aValIVA   := 0//MaFisRet(1,"NF_VALIMP")
Local nValIVA   :=0

If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
	For nG:=1 to Len(aValIVA)
		nValIVA+=aValIVA[nG]
	Next
Endif

//cProced := Substr(QR1->B1_PROCED,2,1)
cMensagem := Formula(QR1->C7_MSG)
nTotLin   := 5
nTotLin1  := 3
nCont     := 0
nCont1    := 0

If !Empty(cMensagem)
	li++
	@ li,002 PSAY Padc(cMensagem,129)
Endif
li++
@ li,001 PSAY "-"
@ li,002 PSAY Replicate("-",limite)
li+=2

nTotLinhas :=  38

While li < nTotLinhas
	@ li,022 + nk PSAY " " // foi colocado espaço no lugar de -
	nk := IIf( nk == 42 , 1 , nk + 1 )
	li++
EndDo

@ li,002 PSAY Replicate("-",limite)
li++
@ li,002 PSAY "Desconto: "
@ li,012 PSAY nTotDesc Picture "@E 999,999.99"
@ li,030 PSAY "Frete:"
@ li,037 PSAY nTotFrete Picture "@E 999,999.99"
@ li,095 PSAY nTotIPI Picture "@E 9,999,999.99"
@ li,106 PSAY nTotalNF Picture "@E 999,999,999.99"
li++
@ li,002 PSAY Replicate("-",limite)
li++
//@ li,001 PSAY "******** NAO ACEITAREMOS EM NOSSO RECEBIMENTO MERCADORIAS COM TITLULOS COM VENCIMENTOS ENTRE OS DIAS 10/12/2015 E 11/01/2016 ********"
li++
@ li,001 PSAY "1) Favor retornar ACEITE ou DIVERGENCIA deste pedido pelo Tel.: " + Alltrim(SM0->M0_TEL) + " ou FAX: " + Alltrim(SM0->M0_FAX) + " (Ramal: 536)"
li++
If cEmpAnt == "01"
	@ li,001 PSAY "   ou através do e-mail: pedidos.compras@masipack.com.br"
	li++
	@ li,001 PSAY "2) A MASIPACK não autoriza a negociação de seus titulos."
ElseIf cEmpAnt == "10"
	@ li,001 PSAY "   ou através do e-mail: followup@fabrima.com.br"
	li++
	@ li,001 PSAY "2) A FABRIMA não autoriza a negociação de seus titulos."
ElseIf cEmpAnt == "15"
	@ li,001 PSAY "   ou através do e-mail: followup@fabrima.com.br"
	li++
	@ li,001 PSAY "2) A HELSIMPLAST não autoriza a negociação de seus titulos."
ElseIf cEmpAnt == "40"
	@ li,001 PSAY "   ou através do e-mail: "
	li++
	@ li,001 PSAY "2) A LABORTUBE não autoriza a negociação de seus titulos."
EndIf
li++
@ li,001 PSAY "3) Por favor, entregue os itens nas DATAS PROGRAMADAS e MENCIONE o numero de nosso pedido [ " + SC7->C7_NUM + " ] em sua NF."
li++
//Ivandro Santos - 09/06/17
//Ticket#2017060837000848 — Alteração do período de almoço da Fabrima nos pedidos de compras.
//@ li,001 PSAY "4) Nosso HORARIO DE RECEBIMENTO: de SEGUNDA a SEXTA, das 8:00H as 11:30H e das 13:30H as 16:30H."
If cEmpAnt == "10"
	@ li,001 PSAY "4) Nosso HORARIO DE RECEBIMENTO: de SEGUNDA a SEXTA, das 8:00H as 11:00H e das 12:30H as 16:30H."
Else
	@ li,001 PSAY "4) Nosso HORARIO DE RECEBIMENTO: de SEGUNDA à QUINTA das 08:00H as 11:45H e das 13:15H as 16:30H."
	li++
	@ li,001 PSAY "                                 de SEXTA-FEIRA das 08:00H as 11:45H e das 13:15H as 15:30H."
Endif
li+=2
/*
@ li,001 PSAY "   Observação: A partir do dia 04/11/2013, teremos novo horário para RECEBIMENTO DE MERCADORIAS:"
li++
@ li,001 PSAY "            de SEGUNDA à QUINTA das 08:00H as 11:45H e das 13:15H as 16:30H"
li++
@ li,001 PSAY "            as SEXTA-FEIRA      das 08:00H as 11:45H e das 13:15H as 15:30H"
li++
*/
If cEmpAnt == "15"
	@ li,001 PSAY "   Observações"
	li++
	@ li,001 PSAY "            Envio de NF. Eletrônica para o e-mail: nfe@helsimplast.com.br"
	li++
	@ li,001 PSAY "            Recebimento de NF. de Serviço até o dia 25 de cada mês."
Endif

li+=2
@ li,001 PSAY "* = MATERIAL DESTINADO A INDUSTRIALIZAÇÃO OU COMERCIALIZAÇÃO   /    # = MATERIAL DESTINADO A USO OU CONSUMO"

cTexto1   := " "
cTexto2   := " "
cTexto3   := " "
cMascara  := "@E 99,999.999"
cMascara1 := "@E 99999-999"
cMascara2 := "9999"
cMascara3 := "@R 99.999.999/9999-99"

IF SUBSTR(cNumEmp,1,2) <> "15"
	dbSelectArea("SM4")
	dbSetOrder(1)
	If !Empty(QR1->C7_MSTXT1)
		dbSeek(xFilial("SC7")+QR1->C7_MSTXT1)
		cTexto1 := SM4->M4_FORMULA
	EndIf
	If !Empty(QR1->C7_MSTXT2)
		dbSeek(xFilial("SC7")+QR1->C7_MSTXT2)
		cTexto2 := SM4->M4_FORMULA
	EndIf
	If !Empty(QR1->C7_MSTXT3)
		dbSeek(xFilial("SC7")+QR1->C7_MSTXT3)
		cTexto3 := SM4->M4_FORMULA
	EndIf
ENDIF
li += 2
@li,001 PSAY " "
li += 2
If !Empty(Alltrim(cTexto1))
	@li,016 PSAY Alltrim(cTexto1)
	li += 2
Endif
If !Empty(Alltrim(cTexto2))
	@li,016 PSAY Alltrim(cTexto2)
	li += 2
Endif
If !Empty(Alltrim(cTexto3))
	@li,016 PSAY Alltrim(cTexto3)
Endif
//EndIf
li += 1
/*
@li,110 PSAY "Marcos Videira"
li += 1
@li,110 PSAY "Comprador"
*/
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalAE  ³ Autor ³ Cristina Ogura        ³ Data ³ 05.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares da Autorizacao de Entrega  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalAE(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalAE(nDescProd)
Local nk := 1
Local nX
Local nTotDesc := nDescProd
Local nTotNF   := 0//MaFisRet(1,'NF_TOTAL')

cMensagem  := Formula(C7_MSG)

If !Empty(cMensagem)
	li++
	@ li,001 PSAY Padc(cMensagem,129)
Endif
li++
@ li,001 PSAY "-"
@ li,002 PSAY Replicate("-",limite)
li++
While li<39
	@ li,001 PSAY " "
	@ li,006 PSAY " "
	@ li,022 PSAY " "
	@ li,022 + nk PSAY " "
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,059 PSAY " "
	@ li,062 PSAY " "
	@ li,073 PSAY " "
	@ li,088 PSAY " "
	@ li,095 PSAY " "
	@ li,111 PSAY " "
	@ li,144 PSAY ""
	li++
EndDo
@ li,002 PSAY Replicate("-",limite)
li++
@ li,001 PSAY " "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo de Empresa SM0.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+QR1->C7_FILENT)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime endereco de entrega do SM0 somente se o MV_PAR10 =" "³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(MV_PAR10)
	@ li,003 PSAY "Local de Entrega  : " + SM0->M0_ENDENT
	@ li,057 PSAY "-"
	@ li,061 PSAY SM0->M0_CIDENT
	@ li,083 PSAY "-"
	@ li,085 PSAY SM0->M0_ESTENT
	@ li,088 PSAY "-"
	@ li,090 PSAY "CEP :"
	
	Private cCGCPict, cCepPict
	cCepPict:=PesqPict("SA2","A2_CEP")
	cCGCPict:=PesqPict("SA2","A2_CGC")
	@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPENT),cCepPict)
Else
	@ li,003 PSAY "Local de Entrega  : " + MV_PAR10
Endif

@ li,144 PSAY " "

dbGoto(nRegistro)
dbSelectArea(cAlias)

li++
@ li,001 PSAY " "
@ li,003 PSAY "Local de Cobranca : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPCOB),cCepPict)
@ li,144 PSAY " "
li++
@ li,002 PSAY Replicate("-",limite)

li++
@ li,001 PSAY " "
@ li,003 PSAY "Total das Mercadorias : "
@ li,034 PSAY nTotal Picture "@E 99,999,999,999.99"
@ li,056 PSAY "Total com Impostos : "
@ li,094 PSAY nTotMerc Picture "@E 99,999,999,999.99"
li++
@ li,001 PSAY Replicate("-",53)
@ li,054 PSAY " "
@ li,055 PSAY Replicate("-",88)
@ li,144 PSAY " "
li++
dbSelectArea("SM4")
dbSeek(xFilial("SM4")+QR1->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY " "
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY QR1->C7_REAJUST Picture "@E 999,999.99"
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "| Total Geral : "

@ li,094 PSAY nTotNF Picture "@E 99,999,999,999.99"
@ li,144 PSAY " "
li++
@ li,002 PSAY Replicate("-",limite)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs 	:= cObs01
		cObs01:= Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li++
@ li,001 PSAY " Observacoes"
@ li,054 PSAY " Comprador    "
@ li,070 PSAY " Gerencia     "
@ li,085 PSAY " Diretoria    "
@ li,144 PSAY " "
li++
@ li,001 PSAY " "
@ li,003 PSAY cObs01
@ li,054 PSAY " "
@ li,070 PSAY " "
@ li,085 PSAY " "
@ li,144 PSAY " "
li++
@ li,001 PSAY " "
@ li,003 PSAY cObs02
@ li,054 PSAY " "
@ li,070 PSAY " "
@ li,085 PSAY " "
@ li,144 PSAY " "
li++
@ li,001 PSAY " "
@ li,003 PSAY cObs03
@ li,054 PSAY " "
@ li,070 PSAY " "
@ li,085 PSAY " "
@ li,144 PSAY " "

li++
@ li,001 PSAY " "
@ li,003 PSAY cObs04
@ li,054 PSAY " "
@ li,070 PSAY " "
@ li,085 PSAY " "
@ li,144 PSAY " "
li++
@ li,002 PSAY Replicate("-",limite)
li++
@ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
@ li,144 PSAY " "
li++
@ li,002 PSAY Replicate("-",limite)
li++
@ li,002 PSAY Replicate("-",limite)
li++
li++
@li,002 PSAY "Observações:        " + AllTrim(cTexto1)
li += 2
@li,020 PSAY Alltrim(cTexto2)
li += 2
@li,020 PSAY Alltrim(cTexto3)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()
li++
@ li,001 PSAY Replicate("-",limite)
li++
@ li,001 PSAY " "
@ li,090 PSAY "Continua ..."
@ li,144 PSAY " "
li++
@ li,001 PSAY Replicate("-",limite)
li:=0

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()

Local nOrden, cCGC
Local cMoeda := ""

If QR1->C7_MOEDA == 1
	cMoeda := "(R$)"
ElseIf QR1->C7_MOEDA == 2
	cMoeda := "(US$)"
ElseIf QR1->C7_MOEDA == 4
	cMoeda := "(EURO)"
EndIf

Li := 01

@ Li,001 PSAY PADC(ALLTRIM(SM0->M0_NOMECOM),limite)
Li++
@ Li,001 PSAY PADC(AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT)+ " - " + SM0->M0_ESTENT + " - " + ("CEP :") + Trans(SM0->M0_CEPENT,cCepPict),limite)
If cEmpAnt $ "01|10|15"
	Li++
	@ Li,001 PSAY PADC("TEL.: " + Alltrim(SM0->M0_TEL) + " FAX...: " + Alltrim(SM0->M0_FAX), limite)
Else
	Li++
	@ Li,001 PSAY PADC("TEL.Matriz: (11)41788099  "+"TEL.: "+ "(" + Substr(SM0->M0_TEL,1,2) + ")" + Substr(SM0->M0_TEL,4,8) + " " + " FAX...: " + "(" + Substr(SM0->M0_FAX,1,2) + ")" + Substr(SM0->M0_FAX,4,8) + " (Ramal: 536)" ,limite)
EndIf
Li++
If cPaisLoc == "BRA"
	@ Li,091 PSAY "I.E.: " + InscrEst()
	@ Li,118 PSAY "CNPJ: "
	@ Li,124 PSAY SM0->M0_CGC Picture "@R 99.999.999/9999-99"
else
	@ Li,001 PSAY PADC("CNPJ:" + " " + Transform(SM0->M0_CGC,cCgcPict),limite)
EndIf
Li++
If SubStr(cNumEmp,1,2) == "01"
	@ Li,001 PSAY PADC("E-mail: pedidos.compras@masipack.com.br" ,limite)
ElseIf SubStr(cNumEmp,1,2) $ "10"
	@ Li,001 PSAY PADC("E-mail: followup@fabrima.com.br" ,limite)
EndIf
Li++
@ Li,001 PSAY Replicate("=",limite + 2)
Li++
@ Li,001 PSAY "Data de Emissao: " + Dtoc(QR1->C7_EMISSAO)
@ Li,028 PSAY IIf(nOrdem>1,(" - continuacao")," ")
If QR1->C7_MOEDA == 2
	@ Li,046 PSAY "P  E  D  I  D  O    D  E    C  O  M  P  R  A  S  " + "  -  DOLAR"
Else
	@ Li,046 PSAY "P  E  D  I  D  O    D  E    C  O  M   P  R  A  S  "
EndIf
@ Li,111 PSAY "N. " + QR1->C7_NUM      Picture PesqPict("SC7","c7_num")
cPedido := QR1->C7_NUM
Li++
@ Li,001 PSAY Replicate("=",limite + 2)
Li+=3
@ Li,001 PSAY "Fornecedor: " + QR1->A2_COD+"/"+QR1->A2_LOJA+"-"+QR1->A2_NOME
If SubStr(cNumEmp,1,2) == "01"
	If QR1->A2_MSPONT > 0
		@ Li,095 PSAY "Pontuação: "+STR(QR1->A2_MSPONT,3)+"%    Classificação: "+QR1->A2_RISCO
	EndIf
EndIf
Li++
IF SUBSTR(cNumEmp,1,2) == "15"
	//cEnd := alltrim(QR1->A2_MSEMAIL) - Alteração feita por campo não existir mais / Felipe Freitas
	cEnd := alltrim(QR1->A2_EMAIL2)
ELSE
	cEnd := alltrim(QR1->A2_EMAIL2)
	//cEnd := alltrim(QR1->A2_MSEMAIL) - Alteração feita por campo não existir mais / Felipe Freitas
ENDIF
@ Li,001 PSAY "E-mail....: " + alltrim(cEnd)
Li++
@ Li,001 PSAY "Endereço..: " + Trim(QR1->A2_END) +"   "+ Trim(QR1->A2_BAIRRO)
Li++
@ Li,001 PSAY "Municipio.: " + Trim(QR1->A2_MUN)
@ Li,095 PSAY "UF....: " + QR1->A2_EST
@ Li,114 PSAY "CEP :"
@ Li,120 PSAY QR1->A2_CEP    		Picture PesqPict("SA2","A2_CEP")
Li++

@ Li,001 PSAY cCGC
dbSetOrder(nOrden)
@ Li,013 PSAY QR1->A2_CGC Picture IIF(QR1->A2_TIPO == "J","@R 99.999.999/9999-99","@R 999999999-99")
If ! ( cPaisLoc$"ARG|POR|EUA" )
	@ Li,095 PSAY "I.E.: " + Trim(QR1->A2_INSCR)
EndIf
Li++
@ Li,001 PSAY "FONE......: "
@ Li,013 PSAY "("+Substr(QR1->A2_DDD,1,3)+") "+Substr(QR1->A2_TEL,1,15)
@ Li,095 PSAY "FAX: "
@ Li,103 PSAY "("+Substr(QR1->A2_DDD,1,3)+") "+" " +QR1->A2_FAX + "  "
Li+=2
@ Li,001 PSAY "Condicao de Pagto " + SubStr(QR1->E4_DESCRI,1,34)
@ Li,095 PSAY "Contato: " + " " + QR1->C7_CONTATO
Li+=2
@ Li,001 PSAY Replicate("-",limite)
Li++
@ Li,001 PSAY "Item"
@ Li,006 PSAY "Codigo      "
@ Li,022 PSAY "|Descricao do Material"
@ Li,085 PSAY "|UM|     Qtde.  Unitario" + cMoeda
@ Li,116 PSAY "%IPI"
@ Li,123 PSAY "Valor do IPI
@ Li,141 PSAY "Valor Total"
@ Li,155 PSAY "Dt.Entrega"
Li++
@ Li,001 PSAY Replicate("-",limite)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AbreArq       ºAutor  ³Cecilia         º Data ³  26/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Abre arquivo temporario                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AbreArq()

Local aFields := {}
Local oTable  := Nil

	If Select("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo Temporario                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aFields := {{"LINHA","C",220,0},{"IND","C",1,0}}

	oTable := FWTemporaryTable():New("TMP",aFields)
	oTable:AddIndex( "IND1", {"IND"} )
	oTable:Create()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Preparaemail  ºAutor  ³Paulo Bindo     º Data ³  04/25/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Converte o arquivo para ser enviado via email               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXP1 - DIRETORIO         ³
//³EXP2 - NOME DO ARQUIVO   ³
//³EXP3 - CONTA DE EMAIL    ³
//³EXP4 - TITULO RELATORIO  ³
//³EXP5 - DESCRICAO EMAIL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function PreparaEmail(cDirAtu,cArquivo,cMail,cTitle,cDesc)
Local oDlg
Local cNewFile
Local cFileToSend
Local lCopy   := .F.
Local nHdl    := -1
Local cMail   := cEnd
Local lSend   := .T.
Local lRename := .F.
Local aFiles  := {}
Local cArquivo:= "RCOMR001.Txt"
Local cDir    := GetMv("MV_RELT")
Local cFrom := ""
If SubStr(cNumEmp,1,2) == "01"
	cFrom   := "pedidos.compras@masipack.com.br"
ElseIf SubStr(cNumEmp,1,2) $ "10_11_15"
	cFrom   := "followup@fabrima.com.br"
ElseIf SubStr(cNumEmp,1,2) == "40"
	cFrom   := "pedidos.compras@masipack.com.br"
EndIf

Private cTitle := "", cDesc := ""

//copia o arquivo .##R para .TXT
cArquivo := cDir+cArquivo
If File(cArquivo)
	cFileToSend := Subs(cArquivo,1,At(".",cArquivo))+"TXT"
	If lRename
		cNewFile := cArquivo
		nHdl := 1
	Else
		cNewFile := Subs(cArquivo,1,At(".",cArquivo))+"TMP"
		__CopyFile(cArquivo,cNewFile)
		nHdl := If(File(cNewFile),1,-1)
	EndIf
	cHtmNewFile:=Subs(cArquivo,1,At(".",cArquivo))+"Html"
Else
	cNewFile := cArquivo
	nHdl := -1
EndIf

U_MsRel2Html( cFileToSend , cHtmNewFile )

cTitulo := "PEDIDO DE COMPRAS - "+ cPedido
cMensagem:="      "+_CRLF
cMensagem+="      "+_CRLF
cMensagem+="Favor retornar ACEITE ou DIVERGENCIA deste pedido pelo E-mail: pedidos.compras@masipack.com.br"+_CRLF
cMensagem+="      "+_CRLF
cMensagem+="CASO NÃO CONSIGA ATENDER A DATA DE ENTREGA PREVISTA DO PEDIDO, INFORMAR A DATA CORRETA DA ENTREGA NA MASIPACK, PARA NÃO SER RELACIONADO COMO ATRASO."+_CRLF
cMensagem+="      "+_CRLF
cMensagem+="      "+_CRLF
cMensagem+="      "+_CRLF
cMensagem+="      "+_CRLF
cMensagem+="Marcos Videira"+_CRLF
cMensagem+="Comprador"+_CRLF
cMensagem+="E-mails para XML: "+_CRLF
cMensagem+="Masipack => nfe@masipack.com.br"+_CRLF
cMensagem+="Maklaser => nfe@maklaser.com.br"+_CRLF
cMensagem+="Telefone: 55 11 3246-3666,4178-8099 - Ramal 361"+_CRLF
If SubStr(cNumEmp,1,2) == "01"
	cMensagem+="E-Mail  : pedidos.compras@masipack.com.br"+_CRLF
ElseIf SubStr(cNumEmp,1,2) $ "10_11"
	cMensagem+="E-Mail  : followup@fabrima.com.br"+_CRLF
ElseIf SubStr(cNumEmp,1,2) $ "40"
	cMensagem+="E-Mail  :  "+_CRLF
EndIf
cMensagem+="www.masipack.com.br"+_CRLF
EnvMail(cTitulo,cMail,cFrom,cMensagem,cHtmNewFile) //envia email para usuario do parametro

Ferase(cHtmNewFile)
Ferase(cArquivo)
Ferase(cNewFile)

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RCOMR001                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENVIAEMAILºAutor  ³Microsiga           º Data ³  12/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exp1 - Titulo do email                                      º±±
±±º          ³Exp2 - destinantarios                                       º±±
±±º          ³Exp3 - Destainatarios ocultos                               º±±
±±º          ³Exp4 - Corpo da mensagen                                    º±±
±±ºDesc.     ³Exp5 - Local do Arquivo                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ENVMAIL(cTitulo,cDestina,cCco,cMensagem,Path)

Local oMsg, oMail, oWF := TWFObj(), nInd, cBody
Local lResult   	:= .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cDestin 		:= cDestina
Local cTitulo 		:= cTitulo
Local cMensagem		:= cMensagem
Local cFrom         := cCco
Local cEmailBcc     := cCco
Local lAutentica    := GetMV("MV_RELAUTH")
Local cPath    		:= GetMv("MV_RELT")
Local cNomeArq 		:= "rcomr001"
Local cExtArq  		:= ".html"
Local cArquivo 		:= cPath + cNomeArq + cExtArq                              
Local _cDE				:= ""
//Private _cHttp	:= GetNewPar("MV_WFHTTP", "\\MSSRV-FSV01\P8\workflow\imagem\")
Private _cHttp	:= GetNewPar("MV_WFHTTP", "\\MSCLD-FSV01\P8\workflow\imagem\")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copia o HTML que esta no C:\Relato_Microsiga para o ROOTPATH do        ³
//³ Protheus                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CPYT2S("C:\relato_microsiga\"+cNomeArq+cExtArq,cPath,.T.)


cBody := ''
cBody += '<DIV><FONT face=Arial size=2><IMG alt="" hspace=0 '
cBody += 'src="' + _cHttp + 'informa.jpg" align=baseline '
cBody += 'border=0></FONT></DIV>'
cBody += '<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>'
cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
cBody += 'size=3><STRONG>Ap7 Workflow - Serviço Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tenta conexao com o servidor de E-Mail ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ; 	// Senha
RESULT   lResult             	// Resultado da tentativa de conexão

If lResult
	// Verifica se o E-mail necessita de Autenticacao
	If lAutentica
		lRet := MailAuth(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"))
	Else
		lRet := .T.
	Endif
	
	If lRet
		
		SEND MAIL;
		FROM           cCco;
		TO 		   cDestin;
		BCC       cEmailBcc;
		SUBJECT     cTitulo;
		BODY      cMensagem;
		ATTACHMENT cArquivo;
		RESULT 	lResult
		
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			Help(" ",1,"ATENCAO",,cError+ " " + cDestin,4,5)
		Endif
	Else
		GET MAIL ERROR cError
		Help(" ",1,"Autenticacao",,cError,4,5)
		MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
	Endif
	
	//(MailSend(cMailConta,{cEmail},{},{},cSubject,cMensagem,aFiles))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza conexao com o servidor de E-Mail ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DISCONNECT SMTP SERVER
	nWrel ++
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"Atencao",,cError,4,5)
Endif

Return
