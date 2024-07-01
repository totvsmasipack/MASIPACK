#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ RCOMR003 ³ Autor³ Aparecida de F.Stevanato³ Data  05.03.06  ³±±
±±                    Alteracao³ Solange Ap.Vezu           Data  03.07.07  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descricao ³ Emissao da Relacao de Pedidos de Compras em Aberto          ³±±
±±             Alteração, Novo Parâmetro 13 - Emite Conf.Entrega           ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/
// Alterado por Ana Paula QF em 04/06/2012 - Acrescentada a Condição de Pagamento abaixo da descricao
// Alterado por Ana Paula QF em 07/03/2013 - Acrescentado Query e as perguntas
// Reescrito por Lizandra - 15/03/13
// Alterado por Ana Paula QFaustino 18/03/2013 - Parametros da Query      
// Alterado para duas casas decimais os campos de quantidade e valor a pedido do Jose Carlos (contabilidade) - 23/07/13 - Lizandra
// Incluido C1_MSEMPRESA - M=MASIPACK, F=FABRIMA, L=LABORTUBE - LIZANDRA -  31/07/13
User Function RCOMR003()                                               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel    := "RCOMR003"
Local cDesc1   := "Emissao da Relacao de  Pedidos de Compras."
Local cDesc2   := ""
Local cDesc3   := ""
Local aOrd     := {"Por Data de Entrega","Por Pedido"}
Local cMSREUNI := space(01)                                                       
Local dMSREUNI

Private titulo   := "Relacao dos Pedidos de Compras"
Private cPerg    := "XRCOMR003 "
Private cString  := "SC7"
Private aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
Private nomeprog := "RCOMR003"
Private nLastKey := 0
Private cabec1   := ""
Private cabec2   := ""
Private tamanho  := "G"
Private Li       := 80
Private cFornAnt := ""
Private cAnterior:= ""
Private cFor     := ""
Private cLoja    := ""
Private cCampo   := ""
Private cArqTrab := ""
Private cFilTrab := ""
Private cNumSC   := ""
Private cItemSC  := ""
Private nTxMoeda := 1
Private nVlrItem := 0
Private nVlrSaldo:= 0
Private nVlrForn := 0
Private nTotSaldo:= 0                                                                                               
Private _nTotM	  := 0
Private _nTotF	  := 0 
Private _nTotL	  := 0
Private _nTotH	  := 0
Private _nTotE	  := 0
Private nTotParc := 0
Private nOrdem   := 0
Private cObs     := ""
Private m_pag    := 1
Private lFiltro  := .T. // Habilita/Desabilita o Filtro

_cEmail	:= ""

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,Tamanho)

If nLastKey==27
	Set Filter to
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},titulo)

dbSelectArea("QR1")
QR1->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SUBSTR(cNumEmp,1,2)  <>  "15"
	Ferase(cArqTrab+GetDBExtension())
	Ferase(cArqTrab+OrdBagExt())
	Ferase(cFilTrab+OrdBagExt())  
ENDIF	

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpRel    ºAutor  ³Lizandra            º Data ³  03/15/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do relatorio                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION IMPREL()

Local cFilterUser

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01       // do produto                                 ³
//³ mv_par02       // ate o produto                              ³
//³ mv_par03       // data de emissao de                         ³
//³ mv_par04       // data de emissao ate                        ³
//³ mv_par05       // data de entrega inicial                    ³
//³ mv_par06       // data de entrega final                      ³
//³ mv_par07       // todas ou em aberto ou residuos ou atendidos³
//³ mv_par08       // pedidos com retorno do fornecedor          ³
//³ mv_par09       // Impr. SC's Firmes, Previstas ou Ambas      ³
//³ mv_par10       // Fornecedor de                              ³
//³ mv_par11       // Fornecedor ate                             ³ 
//³ mv_par12       // Específico para Fornecedor (Sim , Não)     ³
//³ mv_par13       // Emite Conf.Entrega         (Sim , Não)     ³
//³ mv_par14       // Itens c/ Pre-Nota     (Sim , Não, Ambos)   ³
//³ mv_par15       // Apenas Reunião             (Sim , Não)     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

nOrdem := aReturn[8]  // Por data de entrega (Compras) ou por Pedido (PCP)

                  
cQuery := " SELECT SA2.A2_NREDUZ,  SC7.C7_DATPRF,  SC7.C7_NUM,     SC7.C7_ITEM,   SC7.C7_SEQUEN,  SC7.C7_PRODUTO, SC7.C7_DESCRI, "
cQuery += "        SC7.C7_FORNECE, SC7.C7_LOJA,    SC7.C7_QUANT,   SC7.C7_QUJE,   SC7.C7_PRECO,   SC7.C7_VLDESC,  SC7.C7_MOEDA,  "
cQuery += "        SC7.C7_EMISSAO, SC7.C7_REAJUST, SC7.C7_NUMSC,   SC7.C7_ITEMSC, SC7.C7_RESIDUO, SC7.C7_IPIBRUT, SC7.C7_IPI,    "
cQuery += "        SC7.C7_RETFOR,  SC7.C7_OBS,     SC7.C7_QTDACLA, SC7.C7_COND,   SC7.C7_SEGUM,   SC7.C7_QTSEGUM,   "
cQuery += "        SA2.A2_TEL, SA2.A2_DDD,     SA2.A2_FAX,    SA2.A2_CONTATO,  SA2.A2_RISCO,  SC7.C7_TOTAL, "
If SubStr(cNumEmp,1,2) == "01"  // identifica a empresa que comprou pela masipack - Lizandra - Jul/13
	cQuery += "        C1_MSEMPRE,                                                               
ENDIF
IF SUBSTR(cNumEmp,1,2) <> "15"
	//Ivandro Santos - 06/04/17
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	cQuery += "  	SA2.A2_MSFATMI, SA2.A2_MSPONT, SA2.A2_MSRETIR, SA2.A2_EMAIL2, B5_CEME, SC7.C7_MSPV, "
	//cQuery += "  	SA2.A2_MSFATMI, SA2.A2_MSPONT, SA2.A2_MSRETIR, SA2.A2_EMAIL2, B1_DESCP, SC7.C7_MSPV, "
	//Ticket#2017031037000107 — Fim da alteração
ELSE
	//cQuery += "       SA2.A2_MSEMAIL, " - Alteração feita por campo não existir mais / Felipe Freitas
	cQuery += "       SA2.A2_EMAIL2, "
ENDIF
cQuery += "        C1_SOLICIT, C1_MSAPROP, B1_DESC, B1_PROCED, E4_DESCRI, B1_TIPCONV, B1_CONV "
cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 "
cQuery += "       ON SA2.A2_FILIAL = '" + xFilial("SA2")+"' AND SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA "
cQuery += "       AND SA2.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER JOIN " + RetSqlName("SC1") + "  C1 "
cQuery += "      ON C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC "
cQuery += "      AND C1_FILIAL = '" + xFilial("SC1") + "' AND C1.D_E_L_E_T_ = ' ' "
cQuery += "LEFT OUTER JOIN " + RetSqlName("SE4") + "  E4 "
cQuery += "      ON C7_COND = E4_CODIGO  "
cQuery += "      AND E4_FILIAL = '" + xFilial("SE4") + "' AND E4.D_E_L_E_T_ = ' ' "
cQuery += "INNER JOIN " + RetSqlName("SB1") + "  B1 "
cQuery += "      ON C7_PRODUTO = B1_COD "
cQuery += "      AND B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' ' "
//Ivandro Santos - 06/04/17
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
cQuery += "LEFT JOIN " + RetSqlName("SB5") + "  B5 "
cQuery += "      ON C7_PRODUTO = B5_COD "
cQuery += "      AND B5_FILIAL = '" + xFilial("SB5") + "' AND B5.D_E_L_E_T_ = ' ' "
//Ticket#2017031037000107 — Fim da alteração
cQuery += "WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += "  AND SC7.C7_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += "  AND SC7.C7_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
cQuery += "  AND SC7.C7_DATPRF  BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"' "
cQuery += "  AND SC7.C7_FORNECE BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
cQuery += "  AND SC7.D_E_L_E_T_ = ' ' "
If MV_PAR07 == 2  // Em Aberto
	cQuery += "  AND SC7.C7_RESIDUO = ' ' "
	cQuery += "  AND SC7.C7_QUANT -  SC7.C7_QUJE > 0 "
ElseIf MV_PAR07 == 3 // Residuos
	cQuery +="  AND SC7.C7_RESIDUO <> ' ' "
ElseIf MV_PAR07 == 4 // Atendidos
	cQuery +="  AND SC7.C7_QUANT <= SC7.C7_QUJE "
EndIf
If MV_PAR08 = 1 // Pedidos com Retorno do Fornecedor
	cQuery += "  AND SC7.C7_RETFOR = 'S' "
ElseIf MV_PAR08 = 2
	cQuery += "  AND SC7.C7_RETFOR IN ('N',' ') "
EndIf
If MV_PAR14 = 1 //Itens com Pre-Nota
	cQuery += "  AND SC7.C7_QTDACLA > 0 "
ElseIf MV_PAR14 = 2 // Itens Sem Pre-Nota
	cQuery += "  AND SC7.C7_QTDACLA = 0 "
EndIf  
/*
IF SUBSTR(cNumEmp,1,2) <> "15"
	If MV_PAR15 = 1 // Apenas Reuniao
		cQuery += "  AND SC7.C7_MSREUNI <> ' ' "
//	Else
//		cQuery += "  AND SC7.C7_MSREUNI = ' ' "
	EndIf
endif	
*/
IF MV_PAR16 == 1 
	cQuery += "      AND SUBSTRING(B1_PROCED,2,1) = 'P' "
ELSEIF MV_PAR16 == 2 
	cQuery += "      AND SUBSTRING(B1_PROCED,2,1) <> 'P' "
ENDIF

//VICTOR DESSUNTE - 20/05/2016
//SOLICITADO POR EDUARDO POMPERMAYER

If MV_PAR17 == 2
	cQuery += " AND SUBSTRING(SC7.C7_PRODUTO,1,2) <> 'TS'  "  // 27/11/2013 - PRODUTO BENEFICIAMENTO NÃO PRECISA APARECER NO RELATÓRIO 
	                                                          // A PEDIDO DO SR.JOSE CARLOS (CONTABILIDADE)
EndIf


IF nOrdem == 1
	cQuery += "ORDER BY SA2.A2_NREDUZ, SC7.C7_DATPRF, SC7.C7_NUM, SC7.C7_ITEM "
ElseIf nOrdem == 2 	
	cQuery += "ORDER BY SA2.A2_NREDUZ, SC7.C7_NUM, SC7.C7_ITEM "
EndIf	
	
TcQuery cQuery New Alias "QR1"

TcSetField("QR1","C7_EMISSAO" ,"D",08,00)
TcSetField("QR1","C7_DATPRF"  ,"D",08,00)
//TcSetField("QR1","C7_MSREUNI" ,"D",08,00)
TcSetField("QR1","C7_QUANT"   ,"N",12,02)
TcSetField("QR1","C7_PRECO"   ,"N",12,04)
TcSetField("QR1","C7_VLDESC"  ,"N",12,02)
TcSetField("QR1","C7_QTSEGUM" ,"N",12,02)


SetRegua(RecCount())
QR1->(DbGoTop())

cabec1 := "Relacao dos Pedidos de Compras"
titulo += " -  POR FORNECEDOR"

If mv_par07==1  //Todos
	titulo+="  (GERAL)"
Elseif mv_par07==2  //Em Aberto
	titulo+="  (EM ABERTO)"
Elseif mv_par07==3 //Residuos
	titulo+="  (RESIDUOS)"
Elseif mv_par07==4 //Atendidos
	titulo+="  (ATENDIDOS)"
Endif

If mv_par12 == 2  // Especifico por Fornecedor - Nao
	cabec1 := "PEDIDO ITEM  CODIGO          DESCRICAO DO PRODUTO                     ENTREGA            Q U A N T I D A D E S      IPI      PREÇO   MOEDA   T O T A L   RETORNO  " + "RESID. SOLIC.       APROPRIAÇÃO               USUARIO"
	cabec2 := "NUMERO       PRODUTO                                                  PREVISTA FR   PEDIDA     ENTREGUE    SALDO     %      UNITARIO        (C/IMPOSTOS) FORNEC.  " + "ELIM.  COMPRA"
Else
	cabec1 := "PEDIDO ITEM  CODIGO          DESCRICAO DO PRODUTO                     ENTREGA            Q U A N T I D A D E S      IPI      PREÇO   MOEDA   T O T A L   RETORNO  " + "OBSERVAÇÕES DO PEDIDO"
	cabec2 := "NUMERO       PRODUTO                                                  PREVISTA FR   PEDIDA     ENTREGUE    SALDO     %      UNITARIO        (C/IMPOSTOS) FORNEC.  "
EndIf

If mv_par13 == 1  // Emite confirmacao de Entrega - Sim
	cabec1 := ""
	cabec2 := ""
Endif

nVlrForn	 := 0
nTotSaldo := 0  
_nTotM	 := 0
_nTotF	 := 0
_nTotL	 := 0

TB_TXMOEDA := 0

If QR1->C7_MOEDA > 1
	cCampo := "SM2->M2_MOEDA"+Alltrim(STR(QR1->C7_MOEDA))
	SM2->(DBSetOrder(1))
	If SM2->(DBSeek(QR1->C7_EMISSAO))
		TB_TXMOEDA := &cCampo
	EndIf
Else
	TB_TXMOEDA := 1
EndIf
         
IF SUBSTR(cNumEmp,1,2) <> "15"
	CheckMslf()
ENDIF	

//Filtro do usuario
cFilterUser:=QR1->(aReturn[7])

While !QR1->(Eof() )                                           
    /* verifica sc firmes - 
	If !MtrAValOP(mv_par09,'SC7')
		QR1->(dbSkip())
		Loop
	EndIf
    */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !QR1->(Empty(cFilterUser)).and.!QR1->((&cFilterUser))
		QR1->(dbSkip())
		Loop
	Endif
	IF SUBSTR(cNumEmp,1,2) <> "15"
		_cEmail	:= QR1->A2_EMAIL2
	ELSE	
		//_cEmail	:= QR1->A2_MSEMAIL - Alteração feita por campo não existir mais / Felipe Freitas
		_cEmail	:= QR1->A2_EMAIL2
	ENDIF	
	
	IncRegua()
	nTxMoeda := IIF(TB_TXMOEDA > 0,TB_TXMOEDA,Nil)     
	If Li > 60
		If cFornAnt == QR1->A2_NREDUZ
			If mv_par13 == 1 .and. m_pag == 1 //Emite Confirmacao de Entrega - Sim
				cabec1 := ""
				cabec2 := ""
			Elseif mv_par13 == 1 .and. m_pag > 1 //Emite Confirmacao de Entrega - Sim
				cabec1 := "PEDIDO ITEM  CODIGO          DESCRICAO DO PRODUTO                     ENTREGA            Q U A N T I D A D E S      IPI      PREÇO   MOEDA   T O T A L   RETORNO  " + "RESID. SOLIC.       APROPRIAÇÃO               USUARIO"
				cabec2 := "NUMERO       PRODUTO                                                  PREVISTA FR   PEDIDA     ENTREGUE    SALDO     %      UNITARIO        (C/IMPOSTOS) FORNEC.  " + "ELIM.  COMPRA"
			Endif
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			If mv_par13 == 2 //Emite Confirmacao de Entrega - Nao
				@ Li,012 PSAY "Fornecedor: " + cFor + "/" + cLoja + " - " + QR1->A2_NREDUZ + IIF(SUBSTR(cNumEmp,1,2)<>'15',"Pedido de Venda : "+SUBSTR(QR1->C7_MSPV,1,6)+" Item: "+SUBSTR(QR1->C7_MSPV,7,2),"")
				@ Li,055 PSAY "Fone.: (" +ALLTRIM(QR1->A2_DDD)+") " +Substr(QR1->A2_TEL,1,15) + " Fax.:" + QR1->A2_FAX + " Contato: " +  QR1->A2_CONTATO+" - "+"E-mail: "+_cEmail // Fone.: Fax: Contato: E-mail:
				IF SUBSTR(cNumEmp,1,2) <> '15'
					IF !EMPTY(QR1->A2_MSFATMI) .OR. !EMPTY(QR1->A2_MSRETIR)
						Li++
						@ Li,012 PSAY "Faturamento Minimo: " + STR(QR1->A2_MSFATMI,11,3) + "   Retira itens no Fornecedor? " + IIF(QR1->A2_MSRETIR == "1","S","N") 
					ENDIF
				ENDIF					
			Endif
				
			If nOrdem == 1
				cAnterior := DTOS(QR1->C7_DATPRF)
			Else
				cAnterior := QR1->C7_NUM
			EndIf
		Else
			IF nVlrItem > 0
				ImpTotFor()
			EndIf
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf
	Endif
	
	If cFornAnt <> QR1->A2_NREDUZ
		IF nVlrItem > 0
			ImpTotFor()
		EndIf
		cFornAnt := QR1->A2_NREDUZ
		cFor     := QR1->C7_FORNECE
		cLoja    := QR1->C7_LOJA
						
		If mv_par13 == 1  // Se par13 = S, Emite Confirmação de Entrega
			@ Li,030 PSAY "Att:   "+cFor+"-"+ cFornAnt + "   " + "Fone.: (" + ALLTRIM(QR1->A2_DDD) + ") " + Alltrim(QR1->A2_TEL)+" - "+" Fax.:"+Alltrim(QR1->A2_FAX)+" - "+" Contato: "+Alltrim(QR1->A2_CONTATO)+" - "+"E-mail: "+_cEmail  // Fone.: Fax: Contato: E-mail:
			Li := Li + 2    
			IF SUBSTR(cNumEmp,1,2) <> "15"
				@ Li,030 PSAY "Classificacao: " + QR1->A2_RISCO + SPACE(3) + "Pontuacao: " + STR(QR1->A2_MSPONT,6,2) + "%"
			ELSE	
				@ Li,030 PSAY "Classificacao: " + QR1->A2_RISCO 
			ENDIF	
			Li := Li + 2
			@ Li,80 PSAY "CONFIRMAÇÃO DE ENTREGA"
			Li := Li + 1
			@ Li,80 PSAY "======================"
			Li := Li + 1
			If SubStr(cNumEmp,1,2) == "01"
				@ Li,30 PSAY "É NORMA DA MASIPACK RECEBER RETORNO DE ACEITE OU DIVERGÊNCIAS DE TODOS OS PEDIDOS COLOCADOS, INCLUSIVE A POSIÇÃO DOS MESMOS EM ATRASO."
			Elseif SubStr(cNumEmp,1,2) $ "10_11"
				@ Li,30 PSAY "É NORMA DA FABRIMA RECEBER RETORNO DE ACEITE OU DIVERGÊNCIAS DE TODOS OS PEDIDOS COLOCADOS, INCLUSIVE A POSIÇÃO DOS MESMOS EM ATRASO."
			ElseIf SubStr(cNumEmp,1,2) $ "40"				
				@ Li,30 PSAY "É NORMA DA LABORTUBE RECEBER RETORNO DE ACEITE OU DIVERGÊNCIAS DE TODOS OS PEDIDOS COLOCADOS, INCLUSIVE A POSIÇÃO DOS MESMOS EM ATRASO."
			ElseIf SubStr(cNumEmp,1,2) $ "15" .AND. cFilant $ '01'		//Chamado 20240409000016		
				@ Li,30 PSAY "É NORMA DA MASITUBOS RECEBER RETORNO DE ACEITE OU DIVERGÊNCIAS DE TODOS OS PEDIDOS COLOCADOS, INCLUSIVE A POSIÇÃO DOS MESMOS EM ATRASO."
			ElseIf SubStr(cNumEmp,1,2) $ "15" .AND. cFilant $ '02_03'	//Chamado 20240409000016				
				@ Li,30 PSAY "É NORMA DA HELSIM RECEBER RETORNO DE ACEITE OU DIVERGÊNCIAS DE TODOS OS PEDIDOS COLOCADOS, INCLUSIVE A POSIÇÃO DOS MESMOS EM ATRASO."
			Endif
         
			//VICTOR DESSUNTE - 10/10/2016
			//INICIO - TICKET: 2016100737000183
			
			Li := Li + 2
			@ Li,30 PSAY "Segue em anexo a listagem com os pedidos colocados, favor confirmar as devidas datas de entrega."
			Li := Li + 1

			If SubStr(cNumEmp,1,2) == "01"     
				@ Li,30 PSAY "As posições dos mesmos deverão ser retransmitidas na própria listagem, através do e-mail: pedidos.compras@masipack.com.br"
		    ElseIf SubStr(cNumEmp,1,2) $ "15" //Chamado 20240409000016
				@ Li,30 PSAY "As posições dos mesmos deverão ser retransmitidas na própria listagem, através do e-mail: compras@helsimplast.com.br
			ElseIf SubStr(cNumEmp,1,2) $ "10" //Chamado 20240409000018
				@ Li,30 PSAY "As posições dos mesmos deverão ser retransmitidas na própria listagem, através do e-mail: pedidos02@fabrima.com.br"
			ElseIf SubStr(cNumEmp,1,2) $ "11_40_45"  
				@ Li,30 PSAY "As posições dos mesmos deverão ser retransmitidas na própria listagem, através do e-mail: followup@fabrima.com.br"
			Endif
			
			Li := Li + 2
			@ Li,30 PSAY "Comunicamos que o descumprimento dos prazos acordados nos credencia ao cancelamento sem sua prévia autorização."
			Li := Li + 2
			@ Li,30 PSAY "Contamos com sua compreensão e colaboração."
			Li := Li + 2
			@ Li,30 PSAY "Atenciosamente,"
			Li := Li + 2
			@ Li,30 PSAY "Departamentos de Compras"


/*
			Li := Li + 2
			@ Li,30 PSAY "POR ESSE MOTIVO SEGUE ANEXO LISTAGEM COM TODOS OS PEDIDOS COLOCADOS, FAVOR CONFIRMAR AS DEVIDAS DATAS DE ENTREGA."
			Li := Li + 1
			@ Li,30 PSAY "AS POSIÇÕES DOS MESMOS DEVERÃO SER RETRANSMITIDAS NA PRÓPRIA LISTAGEM ATRAVÉS DO"
			Li := Li + 2
			If SubStr(cNumEmp,1,2) == "01"     
			
				@ Li,30 PSAY "Cristina - Telefone: 55 11 3246-3666,4178-8099 - Ramal 375"   
				Li++
				@ Li,30 PSAY "E-Mail  : pedidos.compras@masipack.com.br - www.masipack.com.br" 
				
			ElseIf SubStr(cNumEmp,1,2) $ "10_11"  
			
				@ Li,30 PSAY "Maria Aparecida - Telefone: 55 11 3246-3666,4178-8099 - Ramal 382" 
				Li++
				@ Li,30 PSAY "E-Mail  : followup@fabrima.com.br - www.fabrima.com.br"  
					
			ElseIf SubStr(cNumEmp,1,2) $ "15_40_45"    
			
				@ Li,30 PSAY "Maria Aparecida - Telefone: 55 11 3246-3666,4178-8099 - Ramal 382"  
				Li++
				@ Li,30 PSAY "E-Mail  : followup@fabrima.com.br - www.fabrima.com.br"  
				
			Endif
			Li := Li + 2
			@ Li,30 PSAY "ESPERAMOS CONTAR COM SUA COMPREENSÃO E COLABORAÇÃO."
			Li := Li + 2
			@ Li,30 PSAY "ATENCIOSAMENTE"
			Li := Li + 2
			@ Li,30 PSAY "DEPARTAMENTO DE COMPRAS"
*/

			//FIM - TICKET: 2016100737000183

			Li := Li + 1
			@ Li,00 PSAY __PrtThinLine()
			Li := Li + 1
			@ Li,81 PSAY "RELACAO DOS PEDIDOS"
			Li := Li + 1
			@ Li,00 PSAY __PrtThinLine()
			Li := Li + 1
			@ Li,00 PSAY "PEDIDO ITEM  CODIGO          DESCRICAO DO PRODUTO                     ENTREGA         Q U A N T I D A D E S          IPI      PREÇO          T O T A L    RETORNO  "
			Li := Li + 1
			@ Li,00 PSAY "NUMERO       PRODUTO                                                  PREVISTA     PEDIDA     ENTREGUE      SALDO     %      UNITARIO       (C/IMPOSTOS)  FORNEC.  "
			Li := Li + 1
			@ Li,00 PSAY __PrtThinLine()
			Li := Li + 1
		Endif
		
		If mv_par13 == 2
			Li ++
			@ Li,00 PSAY __PrtThinLine()
			Li ++
			@ Li,022 PSAY "Fornecedor: " + cFor + "/" + cLoja + " - " + cFornAnt + "   " + "Fone.: (" +ALLTRIM(QR1->A2_DDD)+") " +Alltrim(QR1->A2_TEL) + " - " + " Fax.:" + Alltrim(QR1->A2_FAX) + " Contato: " +  Alltrim(QR1->A2_CONTATO)  // Fone.: Fax: Contato:
			Li ++
		Endif
		If nOrdem == 1
			cAnterior := DTOS(QR1->C7_DATPRF)
		Else
			cAnterior := QR1->C7_NUM
		EndIf
	Endif
	
	nItemIpi := 0
	nSalIpi := 0
	
	//MaFisIniPC(QR1->C7_NUM,QR1->C7_ITEM,QR1->C7_SEQUEN)
	
	ImpDet()
	
	QR1->(dbSkip())
EndDo

If nVlrItem > 0
	ImpTotFor()
EndIf
Li++
@ Li,000 PSAY Replicate("*",220)

If Li > 60
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIf

li+=2
@ li,088 PSAY "Total Geral "
@ li,130 PSAY nTotSaldo Picture "@E 999,999,999.99"
IF SUBSTR(cNumEmp,1,2) == "01"
	li+=1
	@ li,088 PSAY "Total Masipack "
	@ li,130 PSAY _nTotM Picture "@E 999,999,999.99"
	li+=1
	@ li,088 PSAY "Total Outros "
	@ li,130 PSAY _nTotF + _nTotL + _nTotH + _nTotE Picture "@E 999,999,999.99"
	li+=1

   /*
	IF MV_PAR16 == 1
		li+=1
		@ li,088 PSAY "Total Masipack "
		@ li,130 PSAY _nTotM Picture "@E 999,999,999.99"
	ELSEIF MV_PAR16 == 2
		li+=1
		@ li,088 PSAY "Total Fabrima "
		@ li,130 PSAY _nTotF Picture "@E 999,999,999.99"
	ELSEIF MV_PAR16 == 3
		li+=1
		@ li,088 PSAY "Total Labortube "
		@ li,130 PSAY _nTotL Picture "@E 999,999,999.99"
	ELSE	
		@ li,088 PSAY "Total Labortube "
		@ li,130 PSAY _nTotL Picture "@E 999,999,999.99"
		li+=1
		@ li,088 PSAY "Total Helsimplast "
		@ li,130 PSAY _nTotH Picture "@E 999,999,999.99"
		li+=1
		@ li,088 PSAY "Total Memb "
		@ li,130 PSAY _nTotE Picture "@E 999,999,999.99"
	ENDIF	                                               
	*/
ENDIF

li++          

Return  Nil

/***************************/
STATIC Function ImpDet()
/***************************/
Local J        := 0
Local nQtdSaldo:= 0
Local nTxMoeda := IIF(TB_TXMOEDA > 0,TB_TXMOEDA,Nil)  // VERIFICAR

If cAnterior <> ""
	If nOrdem == 1 .And. cAnterior <> DTOS(QR1->C7_DATPRF)
		cAnterior := DTOS(QR1->C7_DATPRF)
		Li++
		@ Li,000 PSAY __PrtThinLine()
	Endif
Else
	cAnterior := DTOS(QR1->C7_DATPRF)
EndIf
If cAnterior <> ""
	If nOrdem == 2 .And. cAnterior <> QR1->C7_NUM
		cAnterior := QR1->C7_NUM
		Li++
		@ Li,000 PSAY __PrtThinLine()
	EndIf
Else
	cAnterior := QR1->C7_NUM
EndIF

cDesc := ""                                     
IF SUBSTR(cNumEmp,1,2) <> "15"
	//Ivandro Santos - 06/04/17 - início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	cDesc := IIF(EMPTY(QR1->B5_CEME),QR1->B1_DESC,QR1->B5_CEME)
	//cDesc := IIF(EMPTY(QR1->B1_DESCP),QR1->B1_DESC,QR1->B1_DESCP)                                
	//Ticket#2017031037000107 — Fim da alteração
ELSE	                                           
	cDesc := QR1->B1_DESC
ENDIF	
Li++
@ li,000 PSAY QR1->C7_NUM
@ li,007 PSAY QR1->C7_ITEM
@ li,013 PSAY QR1->C7_PRODUTO
@ li,029 PSAY QR1->B1_PROCED + "-" +SUBSTR(cDesc,1,35)
@ li,070 PSAY QR1->C7_DATPRF

If SubStr(cNumEmp,1,2) <> "01" .AND. SUBSTR(cNumEmp,1,2) <> "15"
	_cMSLF	:= Posicione("TRB",1,QR1->C7_PRODUTO,"TB_MSLF")
	If !Empty(_cMSLF)
		@ li,079 PSAY QR1->TB_MSLF  Picture "@!"
	Endif
EndIf
cMSREUNI := " "
IF SUBSTR(cNumEmp,1,2) <> "15"
   /*
	If !EMPTY(QR1->C7_MSREUNI)
		cMSREUNI := "R"
	EndIf
	*/
ENDIF	

//@ li,080 PSAY QR1->C7_MSREUNI Picture "@!"
@ li,080 PSAY cMSREUNI       
//IF EMPTY(QR1->C7_QTSEGUM)
	@ li,078 PSAY QR1->C7_QUANT Picture "@e 9,999,999.99"
	nQtdSaldo := If(Empty(QR1->C7_RESIDUO),IIF(QR1->C7_QUANT-QR1->C7_QUJE<0,0,QR1->C7_QUANT-QR1->C7_QUJE),0)
	@ li,089 PSAY QR1->C7_QUJE  Picture "@e 9,999,999.99"
/*ELSE	
	@ li,078 PSAY QR1->C7_QTSEGUM Picture "@e 9,999,999.99"   
	IF QR1->B1_TIPCONV == 'M' 
		nQtdSaldo := (QR1->C7_QUANT-QR1->C7_QUJE) *  QR1->B1_CONV
		@ li,089 PSAY QR1->C7_QUJE * QR1->B1_CONV  Picture "@e 9,999,999.99"
	ELSE	
		nQtdSaldo := (QR1->C7_QUANT-QR1->C7_QUJE) /  QR1->B1_CONV
		@ li,089 PSAY QR1->C7_QUJE / QR1->B1_CONV  Picture "@e 9,999,999.99"
	ENDIF	
ENDIF */	
@ li,100 PSAY TRANSFORM(nQtdSaldo,"@E 9,999,999.99")
@ li,117 PSAY QR1->C7_IPI
//Ivandro Santos - 28/02/17
//Ticket#2017022837000139 — Relação dos Pedidos de Compras
//IF EMPTY(QR1->C7_QTSEGUM)
	@ li,120 PSAY QR1->C7_PRECO  Picture "@E 999,999.9999"
/*ELSE	
	@ li,120 PSAY ROUND(QR1->C7_TOTAL/QR1->C7_QTSEGUM,4)  Picture "@E 999,999.9999"
ENDIF	*/                                                
//Ticket#2017022837000139 — fim da alteração
If QR1->C7_MOEDA == 2
	@ Li,133 PSAY "Dolar"
ElseIf QR1->C7_MOEDA == 4
	@ Li,133 PSAY "Euro"
EndIf

If Empty(QR1->C7_REAJUST)
	nVlrSaldo := (nQtdSaldo * xMoeda(QR1->C7_PRECO,QR1->C7_MOEDA,1,QR1->C7_DATPRF,,nTxMoeda)- ;
	xMoeda(QR1->C7_VLDESC,QR1->C7_MOEDA,1,QR1->C7_DATPRF,,nTxMoeda))+ ;
	xMoeda(nSalIPI,QR1->C7_MOEDA,1,QR1->C7_DATPRF,,nTxMoeda)
Else
	nVlrSaldo := (nqtdSaldo * xMoeda(Formula(QR1->C7_REAJUST),QR1->C7_MOEDA,1,QR1->C7_DATPRF,,nTxMoeda)) + ;
	xMoeda(nSalIPI,QR1->C7_MOEDA,1,QR1->C7_DATPRF,,nTxMoeda)
EndIf
If QR1->C7_IPI > 0
	nVlrSaldo := nVlrSaldo + (nVlrSaldo * QR1->C7_IPI / 100)
EndIf

@ li,139 PSAY  nVlrSaldo Picture "@E 9,999,999.99"
@ Li,154 PSAY If(QR1->C7_RETFOR == "S","Sim","Nao")	   	 

cObs := AllTrim(QR1->C7_OBS)

If mv_par12 == 2
	@ Li,162 PSAY If(Empty(QR1->C7_RESIDUO),"Nao","Sim")		 
	 
	If SubStr(cNumEmp,1,2) == "01"
		IF !Empty(QR1->C7_NUMSC)      // INCLUIDO A PEDIDO DA CONTABILIDADE - 31/07/13 - LIZANDRA
			@ Li,168 PSAY QR1->C7_NUMSC + "/" + QR1->C7_ITEMSC
			IF EMPTY(QR1->C1_MSEMPRE) .OR. QR1->C1_MSEMPRE == "M" 
				@ Li,180 PSAY " Masipack"
				_nTotM += nVlrSaldo
			ELSEIF QR1->C1_MSEMPRE == "F"
				@ Li,180 PSAY " Fabrima"
				_nTotF += nVlrSaldo
			ELSEIF QR1->C1_MSEMPRE == "L"
				@ Li,180 PSAY " Labortube"
				_nTotL += nVlrSaldo
			ELSEIF QR1->C1_MSEMPRE == "H"
				@ Li,180 PSAY " Helsimplast"
				_nTotH += nVlrSaldo
			ELSEIF QR1->C1_MSEMPRE == "E"
				@ Li,180 PSAY " Memb"
				_nTotE += nVlrSaldo
			ENDIF	
//		Else
			
//			+ QR1->C7_ITEMSC + IIF(EMPTY(QR1->C1_MSEMPRE).OR.QR1->C1_MSEMPRE == "M","Masipack",IIF(QR1->C1_MSEMPRE == "F","Fabrima","Labortube"))	
			/*
			IF QR1->C1_MSEMPRE == "M"
			ELSEIF QR1->C1_MSEMPRE == "F"
			ELSEIF QR1->C1_MSEMPRE == "L"
			ENDIF	
			*/
		EndIf
	Else
		@ Li,168 PSAY QR1->C7_NUMSC + "/" + QR1->C7_ITEMSC
	EndIf
	
	@ Li, 208 PSAY QR1->C1_SOLICIT
	IF SUBSTR(cNumEmp,1,2) <> "15"
		If !Empty(QR1->C1_MSAPROP)
			Li++
			@ Li, 013 Psay "Apropriacao: " + QR1->C1_MSAPROP
		EndIf
	ENDIF	
	If Len(cDesc) > 35
		Li++
		@ Li,29 PSAY SubStr(cDesc,36,35)
	EndIf
	If Len(cDesc) > 70
		Li++
		@ Li,29 PSAY SubStr(cDesc,71,35)
	EndIf
	If Len(Alltrim(cObs)) > 0
		For J:=1 TO Len(Trim(cObs)) Step 35
			If !Empty(Subs(cObs,J,35))
				If Li > 60
					If mv_par13 == 1
						cabec1 := "PEDIDO ITEM  CODIGO          DESCRICAO DO PRODUTO                     ENTREGA            Q U A N T I D A D E S      IPI      PREÇO   MOEDA   T O T A L   RETORNO  " + "RESID. SOLIC.       APROPRIAÇÃO               USUARIO"
						cabec2 := "NUMERO       PRODUTO                                                  PREVISTA FR   PEDIDA     ENTREGUE    SALDO     %      UNITARIO        (C/IMPOSTOS) FORNEC.  " + "ELIM.  COMPRA"
					Endif
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				Endif
				Li++
				@ Li,29 PSAY SubStr(cObs,J,35)
			EndIf
		Next J
	EndIf
Else
	If !Empty(cOBS)
		@ Li,166 PSAY SubStr(cOBS,1,64)
		If Len(cOBS) > 64
			Li++
			If Len(cDesc) > 35
				@ Li,029 PSAY SubStr(cDesc,36,35)
			EndIf
			@ Li,166 PSAY SubStr(cOBS,65,64)
		EndIf
		If Len(cDesc) > 70
			Li++
			@ Li,029 PSAY SubStr(cDesc,71,35)
		EndIf
	Else
		If Len(cDesc) > 35
			Li++
			@ Li,029 PSAY SubStr(cDesc,36,35)
		EndIf
		If Len(cDesc) > 70
			Li++
			@ Li,029 PSAY SubStr(cDesc,71,35)
		EndIf
	EndIf
EndIf
nVlrItem  := nVlrItem + QR1->C7_QUANT * QR1->C7_PRECO
nVlrForn  := nVlrForn + nVlrSaldo     // Totaliza Fornecedor
nTotSaldo := nTotSaldo + nVlrSaldo    // Totaliza Geral

Li++
@ Li,029 PSAY "Cond.Pagto: " + AllTrim(Substr(QR1->E4_DESCRI,1,10))
IF SUBSTR(cNumEmp,1,2) <> "15"
	If !EMPTY(QR1->A2_MSRETIR)
		Li++
		@ Li,029 PSAY "Retirar no Fornecedor!"
	ENDIF
ENDIF	
If QR1->C7_QTDACLA > 0
	Li++
	@ Li,29 PSAY "*****  PRE-NOTA LANÇADA  ***** "
EndIf

Return

/**************************************************************/
Static Function ImpTotFor()  // Impressao dos totais p/ item
/**************************************************************/

Li++
@ Li,000 PSAY __PrtThinLine()
Li++
@ li,088 PSAY "Total do Fornecedor"  // Total por fornecedor
@ li,130 PSAY nVlrForn Picture "@E 9,999,999.99"
nVlrForn:=0

//======================================================
//Se "Emite Conf.Entrega", pula página a cada Fornecedor
//======================================================
If mv_par13 == 1
	cabec1 := "PEDIDO ITEM  CODIGO          DESCRICAO DO PRODUTO                     ENTREGA            Q U A N T I D A D E S      IPI      PREÇO   MOEDA   T O T A L   RETORNO  " + "RESID. SOLIC.       APROPRIAÇÃO               USUARIO"
	cabec2 := "NUMERO       PRODUTO                                                  PREVISTA FR   PEDIDA     ENTREGUE    SALDO     %      UNITARIO        (C/IMPOSTOS) FORNEC.  " + "ELIM.  COMPRA"
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Endif

Return .T.


// Verifica se produto esta na lista de falta
Static Function CheckMslf()

Local aCampos	:= {}
Local cQuery	:= ""
Local oTable	:= Nil

Private cArqTrab  := ""
Private cFilTrab  := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria array para gerar arquivo de trabalho                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Select("TRB") > 0
		dbSelectArea("TRB")
		TRB->(dbCloseArea())
	Endif

	AADD(aCampos,{ "TB_PRODUTO" ,"C",15,0 } )
	AADD(aCampos,{ "TB_MSLF"    ,"C",01,0 } )

	oTable := FWTemporaryTable():New("TRB",aCampos)
	oTable:AddIndex( 'IDX1', { 'TB_PRODUTO' } )
	oTable:Create()

	If Select("QR2") > 0
		DbSelectArea("QR2")
		QR2->(DbCloseArea())
	EndIf

	cQuery := "	SELECT SD4.D4_COD COD, SUM(SD4.D4_QUANT) QTD, SD4.D4_MSLF MSLF "
	cQuery += "	FROM " + RetSqlName("SD4") + " SD4 "
	cQuery += "	WHERE SD4.D_E_L_E_T_ = '' "
	cQuery += "	AND SD4.D4_QUANT > 0 "
	cQuery += "	AND SD4.D4_MSLF <> '' "
	cQuery += "	AND SD4.D4_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += "	GROUP BY SD4.D4_COD, SD4.D4_QUANT, SD4.D4_MSLF "
	cQuery += "	ORDER BY SD4.D4_COD

	TcQuery cQuery New Alias "QR2"

	dbSelectArea("QR2")
	QR2->(dbGoTop())

	Do While !QR2->(Eof())
		If !TRB->(DbSeek(QR2->COD))
			RecLock("TRB",.T.)
			TRB->TB_MSLF := QR2->MSLF
			TRB->(MsUnlock())
		Endif
		QR2->(dbSkip())
	EndDo

	dbSelectArea("QR2")
	QR2->(dbCloseArea()) 

Return
