#include "protheus.ch"
#INCLUDE "Topconn.ch"
/*ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณRCOMR011  บAutor  ณJose Roberto      บ Data ณ  12/01/2007   บฑฑ
ฑฑ                       Atu:   ณSolange Vezu      บ Data ณ  18/09/2007   บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบDesc.     ณ Conferencia de pedidos de compra no ato da entrega         บฑฑ
ฑฑ           18/09/07   - Alterado Lay-out                                บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบUso       ณ AP - MASIPACK.                                             บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ*/
// Alterado por Ana Paula QF em 23/05/2012 inclusao dos campos de instrumentos e Obsservacoes da composicao quimica e do instrumento.
// Alterado por Ana Paula QF em 25/05/2012 Invertendo a impressao dos valores totais do pedido/condicao de pagamento.
// Alterado por Lizandra - 06/06/12 - cria็ใo da Query para alterar a ordem de impressใo dos itens - produto + dta de entrega - 
// Alterado por Eduardo - 02/10/14 - incluํdo B5_CERT
// Alterado por Ivandro - 28/03/16 - Inclusใo na Helsimplast para exig๊ncia de Certificado de Atoxidade

User Function RCOMR011()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local wnrel		   := "RCOMR011"
Local cDesc1	   := "Conferencia de pedidos de compra no ato da entrega"
Local cDesc2      := "referentes a compras efetuadas "
Private nForn     := 0
Private nOutSolic := 0
Private nEntradas := 0
Private npedido   := 0
Private cProduto  := ""
Private Titulo	   := "Rela็ao"
Private aReturn	:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private Tamanho   := "M"
Private Limite    := 132
Private nomeprog  := "RCOMR011"
Private nLastKey  := 0
Private cString   := "SC7"
Private Li        := 80
Private J         := 0
Private _cPath    := ""
Private cDesenho  := ""
Private aDesenhos := {}
Private cPerg	   := "XRCOMR011 "
Private Cabec2    := ""
Private nPos      := 0
Private cPict     := ""
Private M_PAG     := 1
Private aParcelas := {}
Private _lProc    := .T.
Private nVlrUnit  := 0
Private nLimite   := 28
Private nFrete    := 0
Private aEmpenhos := {}
Private _cPV      := ""
Private _cCli     := ""

cFornec  := ""
nParc    := 0
ncond    := 0
nCopias  := 0
nvenc    := Date()
nvenc1   := Date()
nvenc2   := Date()
nvenc3   := Date()
nvenc4   := Date()

Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,"","",.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| R011Imp(@lEnd,wnrel,cString)},Titulo)

If apmsgyesno("Deseja imprimir novamente?")
	U_RCOMR011()
ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณR011Imp  บAutor  ณ                     บ Data ณ  08/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function R011Imp(lEnd,wnrel,cString)

Local nCopias	:= 0
Local j			:= 0
Local X			:= 0

IF !EMPTY(MV_PAR04)
	_cQuery := " SELECT DISTINCT C7_PRODUTO, C7_DATPRF,C7_MOEDA, C7_PRECO, C7_QUANT, C7_QUJE, C7_IPI, C7_VALFRE, "
	IF SUBSTR(cNumEmp,1,2) <> "15"
	//Ivandro Santos - 20/10/2016
	//Ticket#2016102037000176 — Rela็ใo PC na Portaria
		_cQuery += "  A2_MSDTCER, A2_MSDTQUE, A2_MSPONT, B1_MSCONF, "
	ENDIF
	//Ivandro Santos - 26/04/17 - Inํcio da altera็ใo
	//Ticket#2017031037000107 — Equaliza็ใo dos campos de descri็ใo do produto (Masipack e Fabrima)
	//_cQuery += "        ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B1_MSDTEC)),' ' ) AS B1_MSDTEC,  "
	_cQuery += "        ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B5_MSOBS)),' ' ) AS B5_MSOBS,  "
	////Ticket#2017031037000107 — Fim da altera็ใo
	_cQuery += "        B1_MSATOX, C7_NUM, C7_FORNECE, C7_LOJA, C7_ITEM, C7_NUMSC, C7_ITEMSC, C7_OBS, C7_QTDACLA, C7_COND, "
	_cQuery += "        A2_NOME, A2_RISCO, A2_CGC, A2_TIPO, "
	//Ticket#2016102037000176 — Fim da altera็ใo
	//Ivandro Santos - 07/04/17 - Inํcio da altera็ใo
	//Ticket#2017031037000107 — Equaliza็ใo dos campos de descri็ใo do produto (Masipack e Fabrima)
	_cQuery += "        B5_CEME, B1_DESC, B1_POSIPI, B1_IPI, B1_PICM, B1_UM, B1_LOCAL,
	//_cQuery += "        B1_DESCP, B1_DESC, B1_POSIPI, B1_IPI, B1_PICM, B1_UM, B1_LOCAL,
	_cQuery += "        B1_PROCED, B1_CONTA, B1_GRTRIB, B1_TIPO, B1_REVATU, "
	_cQuery += "        E4_COND, E4_DESCRI, C1_SOLICIT, "  //C1_MSAPROP,
	_cQuery += "        D4_OP, D4_TRT, D4_QUANT"
	
	If cEmpAnt $ "01|10"
		_cQuery += ", D4_MSLF, C2_MSPED, C2_MSREDUZ "
	Endif
	
	_cQuery += " FROM " + RetSqlName("SC7") + " C7 "
	_cQuery += " INNER JOIN " + RetSqlName("SA2") + " A2 "
	_cQuery += "       ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
	_cQuery += "       ON C7_PRODUTO = B1_COD "
	_cQuery += " LEFT JOIN " + RetSqlName("SB5") + " B5 "
	_cQuery += "       ON C7_PRODUTO = B5_COD "	
	_cQuery += "       AND B5.B5_FILIAL = "+xFilial("SB5")+" "
	_cQuery += "       AND B5.D_E_L_E_T_ = '' "
	//Ticket#2017031037000107 — Fim da altera็ใo
	_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC1") + " C1 "
	_cQuery += "      ON C7_NUMSC = C1_NUM AND C1_FILIAL = '" + xFilial("SC1") + "' AND C1.D_E_L_E_T_ = ' ' "
	_cQuery += "      AND C7_PRODUTO = C1_PRODUTO "
	_cQuery += " LEFT OUTER JOIN " + RetSqlName("SE4") + " E4 "
	_cQuery += "      ON C7_COND = E4_CODIGO AND E4_FILIAL = '" + xFilial("SE4") + "' AND E4.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT OUTER JOIN " + RetSqlName("SD4") + " D4 "
	_cQuery += "      ON C7_PRODUTO = D4_COD AND D4_FILIAL = '" + xFilial("SD4") + "' AND D4.D_E_L_E_T_ = ' ' "
	_cQuery += "      AND D4_QUANT > 0 "
		
	If cEmpAnt $ "01|10"
		_cQuery += " AND D4_MSLF <> ' ' "
		_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC2") + " C2 "
		_cQuery += "      ON SUBSTRING(D4_OP,1,11) = C2_NUM+C2_ITEM+C2_SEQUEN  AND C2.D_E_L_E_T_ = ' ' "
		_cQuery += "      AND C2_FILIAL = '" + xFilial("SC2") + "' AND C2_MSPED <> '      ' "
	Endif

	_cQuery += " WHERE C7_NUM = '" + MV_PAR01 + "' AND C7_RESIDUO = ' ' "
	_cQuery += "       AND C7_QUJE < C7_QUANT "
	_cQuery += "       AND C7_FILIAL = '" + xFilial("SC7") + "' AND C7.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND A2_FILIAL = '" + xFilial("SA2") + "' AND A2.D_E_L_E_T_ = ' ' "
	_cQuery += "       AND B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY C7_PRODUTO, C7_DATPRF "
	
	TcQuery _cQuery New Alias "QR1"
	
	TcSetField("QR1","C7_DATPRF" ,"D",08,00)
	TcSetField("QR1","A2_MSDTCER","D",08,00)
	TcSetField("QR1","A2_MSDTQUE","D",08,00)
	TcSetField("QR1","C7_PRECO"  ,"N",12,04)
	TcSetField("QR1","C7_QUANT"  ,"N",12,04)
	TcSetField("QR1","C7_QUJE"   ,"N",12,04)
	TcSetField("QR1","C7_IPI"    ,"N",12,02)
	TcSetField("QR1","C7_VALFRE" ,"N",12,02)
	TcSetField("QR1","B1_IPI"    ,"N",05,02)
	TcSetField("QR1","B1_PICM"   ,"N",05,02)
	
	QR1->(DbGoTop())
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicia a Impressao                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SetRegua(LastRec())
	
	aDesenhos := {}
	Titulo  := "Conferencia de Pedidos de Compra no Ato da Entrega"
	Cabec1  := "" //STR0012 // "I.T.   CODIGO        DESCRICAO                           UM       QTDE.    UNITARIO          TOTAL   %IPI    ENTRADA     LOCAL"
	//  99999999999999999999 999999999999999 999 99 9999 9999999999999999999999999999999999 XXXXXXXXX1XXXXXXXXX2XXXXXXXXX3XXXXXXXXX4XXX
	//   0         1         2         3         4         5         6         7         8         9        10        11        12
	//    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	
	M_PAG := 1
	
	lPedido     := .F.
	nFrete      := 0
	nTotalItens := 0
	nTotalIPI   := 0
	_cItPc := ""
	
	Do While !QR1->(Eof())
		
		IF _cItPc <> QR1->C7_ITEM
			
			_cItPc := QR1->C7_ITEM
			
			If QR1->C7_MOEDA > 1
				nVlrUnit := QR1->C7_PRECO * (RecMoeda(Date(),QR1->C7_MOEDA))
			Else
				nVlrUnit := QR1->C7_PRECO
			EndIf
			
			nTotalItens += (QR1->C7_QUANT - QR1->C7_QUJE) * nVlrUnit
			nTotalIPI   += (QR1->C7_QUANT - QR1->C7_QUJE) * nVlrUnit * QR1->C7_IPI / 100
			
			nFrete  += QR1->C7_VALFRE
			lPedido := .T.
			
		ENDIF
		QR1->(DBSKIP())
	ENDDO
	
	nTotalPed := nTotalItens + nTotalIPI + nFrete
	
	IF !lPedido
		apmsgAlert("Pedido de Compra ja atendido!")
		QR1->(dbCloseArea())
		Return
	Endif
	
	dCertificado  := CTOD(SPACE(8))
	dQuestionario := CTOD(SPACE(8))
	Li := 62
	
	
	For nCopias := 1 to mv_par02
		
		QR1->(DbGoTop())
		
		SetRegua(RecCount())
		
		Define Font oFont1 Name "Arial" Size 10,15 //Bold
		Define Font oFont2 Name "Arial" Size 10,20 //Bold
		
		Li++
		IF Li > 61
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			li += 2
		ENDIF
		
		@ Li,000 PSAY "PEDIDO:      " + QR1->C7_NUM + " - RECEBIDO EM: " + DTOC(DATE())
		
		Li += 2
		@ Li,000 PSAY "FORNECEDOR: " + QR1->C7_FORNECE + "/"+ QR1->C7_LOJA + " - " + Alltrim(QR1->A2_NOME)
		@ Li,100 PSAY "C.N.P.J.:"
		@ Li,110 PSAY QR1->A2_CGC Picture IIF(QR1->A2_TIPO == "J","@R 99.999.999/9999-99","@R 999999999-99")
		cFornec := QR1->A2_NOME
		
		Li += 2
		@ Li,000 PSAY "PONTUAวรO:          - CLASSIFICAวรO" + " - " + QR1->A2_RISCO
		//Ivandro Santos - 20/10/2016
		//Ticket#2016102037000176 — Rela็ใo PC na Portaria
		IF SUBSTR(cNumEmp,1,2) <> "15"
			If !Empty(QR1->A2_MSDTCER)
				@ Li,050 PSAY "VALIDADE DO CERTIFICADO: " + DTOC(QR1->A2_MSDTCER)
				IF QR1->A2_MSDTCER < DATE()
					dCertificado := QR1->A2_MSDTCER
				ENDIF
			EndIf
			
			If !Empty(QR1->A2_MSDTQUE)
				//Ticket#2016082937000128 — PEDIDO DE COMPRA - Ivandro Santos 29/08/16 - Retirado fun็ใo STOD
				@ Li,050 PSAY "VALIDADE DO QUESTIONARIO: " + DTOC(QR1->A2_MSDTQUE)
				//Ticket#2016082937000128 — Fim da altera็ใo
				IF QR1->A2_MSDTQUE < DATE()
					dQuestionario := QR1->A2_MSDTQUE
				ENDIF
			EndIf
		@ Li,017 PSAY QR1->A2_MSPONT
		Endif    
		//Ticket#2016102037000176 — Fim da altera็ใo
		IF !EMPTY(dCertificado) .OR. !EMPTY(dQuestionario)
			Li++
			IF Li > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				li += 2
			ENDIF
			@ Li,000 PSAY "*******************************************************************************************************"
			Li++
			@ Li,000 PSAY "*   ATENCAO! Fornecedor com Certificado ou Questinario fora do prazo de validade! Fale com Compras.   *"
			Li++
			@ Li,000 PSAY "*******************************************************************************************************"
		ENDIF
		
		Li += 3
		IF Li > 61
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			li += 2
		ENDIF
		@ Li,000 PSAY "Total dos Itens: R$ " + TRANSFORM(nTotalItens, "@E 999,999,999.99")
		
		Li++
		@ Li,000 PSAY "   Total do IPI: R$ " + TRANSFORM(nTotalIPI, "@E 999,999,999.99")
		
		Li++
		@ Li,000 PSAY "          Frete: R$ " + TRANSFORM(nFrete, "@E 999,999,999.99")
		
		Li++
		@ Li,000 PSAY "TOTAL DO PEDIDO: R$ " + TRANSFORM(nTotalPed, "@E 999,999,999.99")
		
		Li++
		@ Li,000 PSAY REPLICATE("=",132)
		
		i  := 1
		wpos := 0
		nParc := 1
		_cCond:= Alltrim(QR1->E4_COND)
		_aParc:= {}
		IF !EMPTY(_cCond)
			//		_aParc := Condicao(nTotalPed,QR1->C7_COND,,dDataBase)
			_aParc := Condicao(nTotalPed,QR1->C7_COND,,MV_PAR04)
			Li++
			@ Li,000 PSAY "COND. PAGTO: " + QR1->C7_COND + " - " + SUBSTR(QR1->E4_DESCRI,1,25) + " - VENCIMENTO(s):"
			
			IF Len(_aParc) > 0
				FOR j := 1 TO Len(_aParc)
					@ Li,056 PSAY DTOC(_aParc[J,1])
					@ Li,066 PSAY TRANSFORM(_aParc[J,2], "@E 999,999,999.99")
					Li++
				Next
			EndIf
			Li++
			IF Li > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				li += 2
			ENDIF
		ENDIF
		
		Li++
		@ Li,000 PSAY REPLICATE("=",132)
		
		Li++
		@ Li,000 PSAY "Pedido: " + QR1->C7_NUM + " - " + QR1->A2_NOME
		
		Li += 3
		@ Li,000 PSAY REPLICATE("=",57,oFont2)+" ITENS DO PEDIDO "+REPLICATE("=",58,oFont2)
		
		li += 2
		@ Li,000 Psay "I.T.   CODIGO        DESCRICAO                                  QTDE. F  UM     UNITARIO (R$)   TOTAL    %IPI    ENTRADA    LOCAL"
		
		Li++
		@ Li,000 PSAY REPLICATE("=",132)
		
		Li++
		cProduto := QR1->C7_PRODUTO
		
		QR1->(DbGoTop())
		
		DO WHILE !QR1->(EOF())
			Li++
			IF Li > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				Li++
				@ Li,000 PSAY REPLICATE("=",132)
				Li++
				@ Li,000 PSAY "Pedido: " + QR1->C7_NUM + " - " + QR1->A2_NOME
				Li += 3
				@ Li,000 PSAY REPLICATE("=",57,oFont2)+" ITENS DO PEDIDO "+REPLICATE("=",58,oFont2)
				li += 2
				@ Li,000 Psay "I.T.   CODIGO        DESCRICAO                                  QTDE. F  UM     UNITARIO (R$)   TOTAL    %IPI    ENTRADA    LOCAL"
				Li++
				@ Li,000 PSAY REPLICATE("=",132)
				Li++
			ENDIF
			
			@ Li,000 PSAY QR1->C7_ITEM
			@ Li,006 PSAY QR1->C7_PRODUTO
			
			cDesc  := QR1->B1_DESC
			cDesc2 := ""
			cDesc3 := ""
			//Ivandro Santos - 07/04/17 - Inํcio da altera็ใo
			//Ticket#2017031037000107 — Equaliza็ใo dos campos de descri็ใo do produto (Masipack e Fabrima)
			IF !EMPTY(QR1->B5_CEME)					//IF !EMPTY(QR1->B1_DESCP)
				cDesc  := SUBSTR(QR1->B5_CEME,1,35)	//cDesc  := SUBSTR(QR1->B1_DESCP,1,35)
				cDesc2 := SUBSTR(QR1->B5_CEME,36,35)	//cDesc2 := SUBSTR(QR1->B1_DESCP,36,35)
				cDesc3 := SUBSTR(QR1->B5_CEME,71)		//cDesc3 := SUBSTR(QR1->B1_DESCP,71)
			ENDIF                                           
			//Ticket#2017031037000107 — Fim da altera็ใo
			@ Li,021 PSAY cDesc
			
			IF !EMPTY(cDesc2)
				@ Li,56 PSAY cDesc2
			ENDIF
			
			IF !EMPTY(cDesc3)
				@ Li,92 PSAY cDesc3
			ENDIF
			
			IF QR1->C7_QUANT - INT(QR1->C7_QUANT) <> 0 					// qde inteira
				cMascara := "@E 99,999.99"
			ELSE
				cMascara := "@E 9,999,999"
			ENDIF
			
			Li++
			
			@ Li,060 PSAY TRANSFORM(QR1->C7_QUANT - QR1->C7_QUJE, cMascara)
			
			IF cEmpAnt $ "01|10"
				If !EMPTY(QR1->D4_MSLF)
					@ Li,070 PSAY "X"
				EndIf
			Endif

			@ Li,073 PSAY QR1->B1_UM
			
			If QR1->C7_MOEDA > 1
				nVlrUnit := QR1->C7_PRECO * (RecMoeda(Date(),QR1->C7_MOEDA))
			Else
				nVlrUnit := QR1->C7_PRECO
			EndIf
			@ Li,076 PSAY TRANSFORM(nVlrUnit,"@E 999,999.9999")
			@ Li,090 PSAY TRANSFORM((QR1->C7_QUANT - QR1->C7_QUJE) * nVlrUnit, "@E 9,999,999.99")
			@ Li,109 PSAY QR1->C7_IPI
			@ Li,114 PSAY QR1->C7_DATPRF  //SUBSTR(DTOC(sc7->c7_datprf),1,5)
			@ Li,124 PSAY QR1->B1_LOCAL
			
			Li++
			IF !EMPTY(QR1->C7_OBS)
				@ Li,021 PSAY QR1->C7_OBS
				li += 2
			ENDIF
			cCERT := ""
			cCERT1:= ""
			cCERT2:= ""
			Li++
			IF SUBSTR(cNumEmp,1,2) $ '01_15'  //Solicitado por Fernando Padial a inclusใo da Helsimplat
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				If DbSeek(xFilial("SB1")+QR1->C7_PRODUTO)
					IF SUBSTR(cNumEmp,1,2) == '01'
						cCERT := SB1->B1_MSCERT
						cCERT1:= SB1->B1_MSCONF
					Endif
					cCERT2:= SB1->B1_MSATOX
				EndIf
			ENDIF
			
			//VICTOR DESSUNTE - 23/09/2016
			//INICIO - TICKET: 2016092337000093

			@ Li,000 PSAY "Certificado Qualidade: "	+ IIF(cCert  == "S","SIM",IIF(cCert == "N","NรO",""))
			@ Li,040 PSAY "Certificado CE: " 			+ IIF(cCert1 == "S","SIM",IIF(cCert1 == "N","NรO",""))
			@ Li,095 PSAY "Certificado Atoxidade: "	+ IIF(cCert2 == "S","SIM",IIF(cCert2 == "N","NรO",""))
			
			/*
			If cCERT <> "S"
				@ Li,000 PSAY "Certificado Qualidade: NรO"
			Else
				@ Li,000 PSAY "Certificado Qualidade: SIM"
			EndIf
			If cCERT1<> "S"
				@ Li,040 PSAY "Certificado CE: NรO"
			Else
				@ Li,040 PSAY "Certificado CE: SIM"
			EndIf
			If cCERT2<> "S"
				@ Li,095 PSAY "Certificado Atoxidade: NรO"
			Else
				@ Li,095 PSAY "Certificado Atoxidade: SIM"
			EndIf
			*/
			//FIM - TICKET: 2016092337000093
			
			Li++
			If !Empty(QR1->C7_NUMSC)
				@ Li,000 PSAY "S.C.: "+ QR1->C7_NUMSC
				@ Li,040 PSAY "Resp.: " + SubStr(QR1->C1_SOLICIT,1,10)
			EndIf
			@ Li,060 PSAY "Classif. Fiscal: " + QR1->B1_POSIPI
			@ Li,095 PSAY "%IPI: "
			@ Li,101 PSAY QR1->B1_IPI Picture "@E 99.99"
			@ Li,110 PSAY "%ICMS: "
			@ Li,117 PSAY QR1->B1_PICM Picture "@E 99.99"
			
			_cApropr := Posicione("SC1",1,xFilial("SC1")+QR1->C7_NUMSC+QR1->C7_ITEMSC,"C1_MSAPROP")
			
			If !Empty(_cApropr)
				Li++
				@ Li,000 PSAY "Apropriacao.: " + _cApropr
			EndIf
			
			Li+=2
			Do Case
				Case QR1->B1_PROCED == "1P"
					@ Li,000 PSAY "PROCEDENCIA: 1P-FABRICADO PRODUTIVO   "
				Case QR1->B1_PROCED == "1N"
					@ Li,000 PSAY "PROCEDENCIA: 1N-FABRICADO IMPRODUTIVO "
				Case QR1->B1_PROCED == "2P"
					@ Li,000 PSAY "PROCEDENCIA: 2P-COMPRADO PRODUTIVO    "
				Case QR1->B1_PROCED == "2N"
					@ Li,000 PSAY "PROCEDENCIA: 2N-COMPRADO IMPRODUTIVO  "
				Case QR1->B1_PROCED == "3P"
					@ Li,000 PSAY "PROCEDENCIA: 3P-IMPORTADO PRODUTIVO   "
				Case QR1->B1_PROCED == "3N"
					@ Li,000 PSAY "PROCEDENCIA: 3N-IMPORTADO IMPRODUTIVO "
				OtherWise
					@ Li,000 PSAY "PROCEDENCIA:"+QR1->B1_PROCED+"             "
			EndCase
			
			@ Li,040 PSAY "C.Contabil: " + QR1->B1_CONTA
			@ Li,076 PSAY "Grupo Tributario: " + QR1->B1_GRTRIB
			@ Li,100 PSAY "Tipo: " + QR1->B1_TIPO
			cInfTec := ""
			//Ivandro Santos - 20/10/2016
			//Ticket#2016102037000176 — Rela็ใo PC na Portaria
			//Ivandro Santos - 26/04/17 - Inํcio da altera็ใo
			//Ticket#2017031037000107 — Equaliza็ใo dos campos de descri็ใo do produto (Masipack e Fabrima)
			/*IF SUBSTR(cNumEmp,1,2) <> "15"
				IF !EMPTY(QR1->B1_MSDTEC)
					cInfTec := Alltrim(QR1->B1_MSDTEC)
				ENDIF
			ENDIF*/
			IF !EMPTY(QR1->B5_MSOBS)
				cInfTec := Alltrim(QR1->B5_MSOBS)
			ENDIF
			//Ticket#2017031037000107 — Fim da altera็ใo			
			//Ticket#2016102037000176 — Fim da altera็ใo
			If !Empty(cInfTec)
				For X := 1 TO MLCOUNT(cInfTec,50)
					Li++
					If Li > 61
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
						Li++
						@ Li,000 PSAY REPLICATE("=",132)
						Li++
						@ Li,000 PSAY "Pedido: " + QR1->C7_NUM + " - " + QR1->A2_NOME
						Li += 3
						@ Li,000 PSAY REPLICATE("=",57,oFont2)+" ITENS DO PEDIDO "+REPLICATE("=",58,oFont2)
						li += 2
						@ Li,000 Psay "I.T.   CODIGO        DESCRICAO                                  QTDE. F  UM     UNITARIO (R$)   TOTAL    %IPI    ENTRADA    LOCAL"
						Li++
						@ Li,000 PSAY REPLICATE("=",132)
						Li += 2
					EndIf
					@li,022 PSay MEMOLINE(cInfTec,50,X)
				Next
			EndIf
			
			IF !EMPTY(QR1->C7_QTDACLA)
				Li++
				@ Li,000 PSAY "***** PRODUTO COM PRษ-NOTA LANวADA - AGUARDANDO CLASSIFICAวรO DA NF PELA AREA FISCAL *****"
				Li++
			ENDIF
			
			Li++
			IF Li > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				Li++
				@ Li,000 PSAY REPLICATE("=",132)
				Li++
				@ Li,000 PSAY "Pedido: " + QR1->C7_NUM + " - " + QR1->A2_NOME
				Li += 3
				@ Li,000 PSAY REPLICATE("=",57,oFont2)+" ITENS DO PEDIDO "+REPLICATE("=",58,oFont2)
				li += 2
				@ Li,000 Psay "I.T.   CODIGO        DESCRICAO                                  QTDE. F  UM     UNITARIO (R$)   TOTAL    %IPI    ENTRADA    LOCAL"
				Li++
				@ Li,000 PSAY REPLICATE("=",132)
				Li++
			ENDIF
			//Ticket#2016082537000082 — TOLERENCIA DE MEDIDAS - PEDIDO DE COMPRA
			//Ivandro Santos - 29/08/16 - alterado a ordem da impressใo do relat๓rio devido ao empenho pular para o pr๓ximo item do pedido
			// Acrescentado por FMD em 17/09/10 para tratar a tolerancia do produto materia prima
			If Substr(QR1->C7_PRODUTO,1,2) == "MP"
				cProduto := Alltrim(QR1->C7_PRODUTO)
				IF SUBSTR(cNumEmp,1,2) == "01"
					VerSZE(cProduto) // ESSA TABELA Sำ TEM CONTEฺDO NA EMPRESA 01 - MASIPACK
				ENDIF
			Else
				Li++
				IF Li > 61
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
					li += 2
				ENDIF
			Endif
			
			//**********************************************
			// Serแ utilizado para impressใo dos desenhos
			//**********************************************
			If MV_PAR03 == 1
				cDesenho := Alltrim(QR1->C7_PRODUTO) + Alltrim(QR1->B1_REVATU)
				_cPath := "H:\PLOTTER\"
				If SubStr(cNumEmp,1,2) == "01"
					If Substr(cDesenho,1,2) $ "CL_CD_CG_IM_FM"
						_cPath += Substr(cDesenho,3,2) + "\"
					Else
						_cPath += Substr(cDesenho,1,2) + "\"
					EndIf
				ElseIf SubStr(cNumEmp,1,2) == "10"
					_cPath  := SubStr(cDesenho,1,3) + "\"
				EndIf
				//Alert(cDesenho)
				If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
					AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
					AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
					AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
				EndIf
			EndIf
			
			//Imprime Empenhos
			If Li > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				Li++
				@ Li,000 PSAY REPLICATE("=",132)
				Li++
				@ Li,000 PSAY "Pedido: " + QR1->C7_NUM + " - " + QR1->A2_NOME
				Li += 3
				@ Li,000 PSAY REPLICATE("=",57,oFont2)+" ITENS DO PEDIDO "+REPLICATE("=",58,oFont2)
				li += 2
				@ Li,000 Psay "I.T.   CODIGO        DESCRICAO                                  QTDE. F  UM     UNITARIO (R$)   TOTAL    %IPI    ENTRADA    LOCAL"
				Li++
				@ Li,000 PSAY REPLICATE("=",132)
				Li += 2
			EndIf
			
			_cProd := QR1->C7_PRODUTO
			_cItem := QR1->C7_ITEM
			_nCont := 1
			IF !EMPTY(QR1->D4_OP)
				Li ++
				@ Li,040 Psay "***  EMPENHOS  PARA  ESTE  PRODUTO  ***"
				Li ++
				DO WHILE !QR1->(EOF()) .AND. QR1->C7_ITEM+QR1->C7_PRODUTO == _cItem+_cProd
					If Li > 61
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
						Li++
						@ Li,000 PSAY REPLICATE("=",132)
						Li++
						@ Li,000 PSAY "Pedido: " + QR1->C7_NUM + " - " + QR1->A2_NOME
						Li += 3
						@ Li,000 PSAY REPLICATE("=",57,oFont2)+" ITENS DO PEDIDO "+REPLICATE("=",58,oFont2)
						li += 2
						@ Li,000 Psay "I.T.   CODIGO        DESCRICAO                                  QTDE. F  UM     UNITARIO (R$)   TOTAL    %IPI    ENTRADA    LOCAL"
						Li++
						@ Li,000 PSAY REPLICATE("=",132)
						Li ++
						@ Li,040 Psay "***  EMPENHOS  PARA  ESTE  PRODUTO  ***"
						Li ++
					EndIf
					If cEmpAnt $ "01|10"
						IF _nCont == 1
							@ li,000 PSAY QR1->D4_OP + " - " + QR1->D4_TRT + " - Qtde: " + TRANSFORM(QR1->D4_QUANT,"@E 999,999.999") + " - PV: " + QR1->C2_MSPED + " " +QR1->C2_MSREDUZ
							_nCont := 2
						ELSEIF _nCont == 2
							@ li,065 PSAY QR1->D4_OP + " - " + QR1->D4_TRT + " - Qtde: " + TRANSFORM(QR1->D4_QUANT,"@E 999,999.999") + " - PV: " + QR1->C2_MSPED + " " +QR1->C2_MSREDUZ
							_nCont := 1
							li++
						ENDIF
					Endif
					QR1->(dbSKIP())
				ENDDO
			ELSE
				QR1->(dbSKIP())
			ENDIF
			
			Li++
			@ Li,000 PSAY REPLICATE("*",132)
			//Ticket#2016082537000082 — Fim da altera็ใo
		EndDo
		
		Li++
		IF Li > 61
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			li += 2
		ENDIF
		@ Li,000 PSAY "OBS:"
		@ Li,004 PSAY REPLICATE("_",126)
		Li += 3
		IF Li > 61
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			li += 2
		ENDIF
		
		@ Li,000 PSAY "Emitido por: " + Alltrim(UsrFullName(RetCodUsr())) + " em " + DTOC(DATE()) + " as " + SUBSTR(TIME(),1,5) + "   Visto do Responsแvel pelo Recebimento e  Liberacao: _____________"
		li += 2
		
		IF Li > 61
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			li += 2
		ENDIF
		
		Li := 99
	Next nCopias
	
	QR1->(dbCloseArea())
	
	If aReturn[5] > 1 .And. mv_par03 == 1
		For J := 1 TO LEN(aDesenhos)
			//alert(adesenhos[j])
			WaitRun(aDesenhos[j])
		Next
	EndIf
	
	If aReturn[5] = 1
		Set Printer TO
		OurSpool(wnrel)
	EndIf
	
	IF !EMPTY(dCertificado)
		ALERT("ATENCAO! Fornecedor com Certificado fora do prazo de validade! Fale com Compras.")
	ENDIF
	
	IF !EMPTY(dQuestionario)
		ALERT("ATENCAO! Fornecedor com Questionario fora do prazo de validade! Fale com Compras.")
	ENDIF
	
	MS_FLUSH()
ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ Programa     บ   VerSZE       บ Autor บ Fabio Marcelo Dias    บ Data บ  17/09/10    บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ Historico    บ 17/09/2010 Criacao.                                                  บฑฑ
ฑฑบ              บ Rotina que verifica se o existe tolerancia cadastrada para o produto,บฑฑ
ฑฑบ              บ caso exista realiza a impressao.                                     บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ Tabs.Utiliz  บ Descricao                                                   บ Acesso บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮอฮออออออออออนฑฑ
ฑฑบ    SZE       บ Cadastro de Tolerancia de Materia Prima                     บ Read   บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฮออออออนฑฑ
ฑฑบ Proprietario บ Customizado para Masipack                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function VerSZE()

Local aFldSX3	:= {}
Local cNoFld	:= "ZE_CODIGO|ZE_OBSERV|ZE_INSTRM1|ZE_INSTRM2|ZE_INSTRM3|ZE_INSTRM4|ZE_INSTRM5|ZE_OBSCOMP|ZE_OBSINST"
Local nUsado	:= 0
Local I			:= 0
Local nX		:= 0
Private aCampos := {}

	aFldSX3 := FWSX3Util():GetAllFields("SZE",.F.)
	
	For nX := 1 To Len(aFldSX3)
		If !(Alltrim(aFldSX3[nX]) $ cNoFld)
			nUsado++
			Aadd(aCampos, { AllTrim(RetTitle(aFldSX3[nX])), aFldSX3[nX], FWSX3Util():GetDescription( aFldSX3[nX] ), PesqPict("SZE",aFldSX3[nX]) })
		Endif
	Next nX

	dbSelectArea("SZE")
	SZE->(dbSetOrder(1))
	SZE->(dbGoTop())

	If SZE->(dbSeek(xFilial("SZE") + cProduto))
		Li++
		@ Li,006 PSAY "TOLERANCIAS DA MP: "
		Li++
		
		If Li > 61
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			li++
			li++
		Endif
		
		For I := 1 To Len(aCampos)
			
			IF Li > 61
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				li++
				li++
			ENDIF
			
			If !Empty(&(aCampos[I][2]))							// O '&' PERMITE MACRO EXECUTAR O CONTEUDO DO ARRAY E FAZER TRAZER O NOME DO CAMPO
				@ Li,008 PSAY Alltrim(aCampos[I][3]) + ":"
				@ Li,PCOL() PSAY REPLICATE ('.', nlimite - Len(Alltrim(aCampos[I][3])))
				
				If Type(aCampos[I][2]) == "N"
					@ Li,PCOL() PSAY SUBSTR(STR(SZE->&(aCampos[I][2]),8,3),1,7)    // O minimo fica com as casa descimais travadas, sem arredondar
				
				ElseIf Type(aCampos[I][2]) == "D"
					@ Li,PCOL() PSAY STOD(SZE->&(aCampos[I][2]))    // O minimo fica com as casa descimais travadas, sem arredondar
				
				ElseIf Type(aCampos[I][2]) == "C"
					@ Li,PCOL() PSAY SUBSTR(SZE->&(aCampos[I][2]),1,7)    // O minimo fica com as casa descimais travadas, sem arredondar
				
				Endif

				If I < Len(aCampos)
					I++
					
					If !Empty(&(aCampos[I][2])) .And. Type(aCampos[I][2]) == "N"
						@ Li,044 PSAY "  -  " + Alltrim(aCampos[I][3]) + ":"
						@ Li,PCOL() PSAY REPLICATE ('.', nlimite - Len(Alltrim(aCampos[I][3])))
						@ Li,PCOL() PSAY Round(SZE->&(aCampos[I][2]),1) Picture "@E 999.9"
						@ Li,PCOL() PSAY "  -  Encontrado:_____________________________"
						Li++
						Li++
					Else
						I -1
						@ Li,085 PSAY "  -  Encontrado:_____________________________"
						Li++
						Li++
					Endif
				Endif
			Endif
			
		Next I
		
	Endif

	If !Empty(SZE->ZE_OBSERV)
		@ Li,008 PSAY "Observacao Dimensional: " + UPPER(Alltrim(SZE->ZE_OBSERV))
		li++
	Endif

	If !Empty(SZE->ZE_OBSCOMP)
		li++
		@ Li,008 PSAY "Observacao Comp.Quimica: " + UPPER(Alltrim(SZE->ZE_OBSCOMP))
		li++
	Endif

	If !Empty(SZE->ZE_INSTRM1)
		LI++
		@ Li,008 PSAY "Instrumentos: " + UPPER(Alltrim(SZE->ZE_INSTRM1))
	Endif
	If !Empty(SZE->ZE_INSTRM2)
		LI++
		@ Li,022 PSAY UPPER(Alltrim(SZE->ZE_INSTRM2))
	Endif
	If !Empty(SZE->ZE_INSTRM3)
		LI++
		@ Li,022 PSAY UPPER(Alltrim(SZE->ZE_INSTRM3))
	Endif
	If !Empty(SZE->ZE_INSTRM4)
		LI++
		@ Li,022 PSAY UPPER(Alltrim(SZE->ZE_INSTRM4))
	Endif
	If !Empty(SZE->ZE_INSTRM5)
		LI++
		@ Li,022 PSAY UPPER(Alltrim(SZE->ZE_INSTRM5))
	Endif

	li++
	If !Empty(SZE->ZE_OBSINST)
		li++
		@ Li,008 PSAY "Observacao Instrumentos: " + UPPER(Alltrim(SZE->ZE_OBSINST))
		
	Endif

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCriaSx1  บAutor  ณLizandra Marques    บ Data ณ  13/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para criacao das perguntas.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSx1()

PutSx1(cPerg,"01","Pedido de Compra" ,"Pedido de Compra" ,"Pedido de Compra" ,"mv_ch1","C",06,0,0,"G","","SC7","","","MV_PAR01","","","","","","","","","","","","","","","","",,,)
PutSx1(cPerg,"02","No. de C๓pias" ,"No. de C๓pias" ,"No. de C๓pias" ,"mv_ch2","N",03,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",,,)
PutSx1(cPerg,"03","Imprime Desenhos" ,"Imprime Desenhos" ,"Imprime Desenhos" ,"mv_ch3","N",01,0,0,"C","","","","","MV_PAR03","Nao","Nao","Nao","","Sim","Sim","Sim","","","","","","","","","",,,)
PutSx1(cPerg,"04","Dt.Emissao NF" ,"Dt.Emissao NF" ,"Dt.Emissao NF" ,"mv_ch4","D",08,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",,,)

Return
