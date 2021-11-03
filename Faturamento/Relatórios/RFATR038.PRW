#Include "Rwmake.ch"      
#Include "Topconn.ch"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RFATR038³ Autor ³ Aparecida de F.Stevanato³Data ³ 22.09.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Comissoes  (Nacional e Exportação)   	     	  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
// Reescrito em 19/12/2013 por Ana Paula QF
*/

User Function RFATR038()
				  
Private titulo    := ""
Private cString   := "SC5"
Private wnrel     := "RFATR038"
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }    
Private nomeprog  := "RFATR038"
Private cPerg	   := "FATR38" + Space(4)
Private nLastKey  := 0
Private Li        := 99 
Private CbTxt     := ""
Private cabec1    := ""
Private cabec2    := ""
Private tamanho   := "G"
Private limite    := 220
Private CbCont    := 0
Private nCont     := 0
Private nComVend  := 0 
Private nComRepr  := 0
Private nTotVend  := 0
Private nTotComis := 0
Private nMetas    := GetMV("MV_MSMETAS")    // Parametro contendo o valor das metas a ser cumprida
Private cTpVend   := ""

Pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros
//³ mv_par01			// Da data (emissão)
//³ mv_par02			// Ate a data (emissão)
//³ mv_par03			// Categoria
//³ mv_par04			// 1-Nacional ou 2-Exportação
//³ mv_par05			// Vendedor 
//³ mv_par06			// Tipo Vend.1-Interno 2-Externo 3-Todos
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

If MV_PAR05 == "ZZZZZZZ" .OR. MV_PAR05 == "      "
   MV_PAR06 := 3
EndIf   

cabec1 := "PEDIDO  CLIENTE                      NUM.C.E.        PAIS/REGIAO         VENDEDOR/              C O M I S S Ã O       SUPERVISOR       C O M I S S Ã O           V  A  L  O  R  E  S     D  O     P  E  D  I  D  O     "
cabec2 := "                                                                         REPRESENTANTE          %         VALOR                        %         VALOR     EQUIPTOS.       FRETE      SEGURO       MONTAGEM     DESPESA"

  

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif
If mv_par04 = 1        // apenas Venda Nacional
   titulo := "Relação de Comissões - " + "Nacional"
ElseIf mv_par04 = 2
   //VICTOR DESSUNTE - 27/07/2017
   //INICIO - TICKET: 2017072737000042
   nMetas := GETMV("MV_MSMETA2") //Meta de vendas (Exportacao)
   //FIM - TICKET: 2017072737000042
   titulo := "Relação de Comissões - " + "Exportação"
ElseIf mv_par04 = 3
	titulo := 	"Relação de Comissões - " + "Técnico" 
EndIf
titulo += "  (Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02) + ")" 
RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ ImpRel	³  Chamada do Relatorio                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRel(lEnd,WnRel,cString)

LOCAL aCampos   := {}
LOCAL aSX512	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"VENDEDOR","C",06,0 } )
AADD(aCampos,{"TPVEND"  ,"C",01,0 } )
AADD(aCampos,{"TOTCOMIS","N",15,2 } )
AADD(aCampos,{"TOTVEND" ,"N",15,2 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRB") > 0 
   DbSelectArea("TRB")
   DbCloseArea()
EndIf                               

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:AddIndex( "IND1", {"VENDEDOR"} )
oTable:Create()

dbSelectArea("TRB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
Li 	    := 80

ImpParam()

If Select("QR1")  > 0 
	DbSelectArea("QR1") 
	DbCloseArea()
EndIf	

_cQuery := "SELECT SC5.C5_NUM,      SC5.C5_CLIENTE, "

If MV_PAR03 <> '3'
	/*
	Ivandro Santos - Início da alteração
	//Ticket#2017050337000144 — RELATORIO DE COMISSAO
	//VICTOR DESSUNTE - 01/03/2017
	//INICIO - TICKET:2017022837000175 
	If MV_PAR04 == 2 .AND. SM0->M0_CODIGO == '01'
		_cQuery += " CASE "
		_cQuery += " 	WHEN C5_MOEDA = '2' THEN C5_MSVLPED * M2_MOEDA2 "
		_cQuery += " 	WHEN C5_MOEDA = '3' THEN C5_MSVLPED * M2_MOEDA3 "
		_cQuery += " 	WHEN C5_MOEDA = '4' THEN C5_MSVLPED * M2_MOEDA4 "
		_cQuery += " 	WHEN C5_MOEDA = '5' THEN C5_MSVLPED * M2_MOEDA5 "
		_cQuery += " 	ELSE "
		_cQuery += " 	C5_MSVLPED "
		_cQuery += " END AS 'C5_MSVLPED', "
	Else
	
	*/
	_cQuery += " SC5.C5_MSVLPED, "
	//EndIf
	//FIM - TICKET:2017022837000175
	//Ticket#2017050337000144 — Fim da alteração
Else
	_cQuery += " ( "
	_cQuery += "	SELECT SUM(C6_VALOR) VAL FROM " + RetSqlName("SC6") + " C6 WHERE C6.D_E_L_E_T_ = ' ' "
	_cQuery += "	AND C6_FILIAL = '" + xFilial("SC6") + "' "
	_cQuery += "	AND C6_NUM = SC5.C5_NUM "
	_cQuery += "	AND C6_BLQ <> 'S' "
	_cQuery += " ) C5_MSVLPED, "
EndIf

_cQuery += " SC5.C5_ORCAM,   SC5.C5_VEND1,   SC5.C5_COMIS1, SC5.C5_VEND2,  SC5.C5_COMIS2, "
_cQuery += "       SC5.C5_FRETAUT,  SC5.C5_FRETE,   SC5.C5_SEGURO,  SC5.C5_MSVLMON, SC5.C5_DESPESA, SA1.A1_PAIS,   SA1.A1_REGIAO, SA1.A1_EST,   "
//Ivandro Santos - 03/04/17
//Ticket#2017033137000103 — Pedidos Microsiga Masipack
IF SUBSTR(cNumEmp,1,2) $ '01_10'   //IF SUBSTR(cNumEmp,1,2) == '10'
//Ticket#2017033137000103 — Fim da alteração
	_cQuery += " SC5.C5_DTEFVEN, SC5.C5_EMISSAO,
ENDIF	
_cQuery += "       SA1.A1_NREDUZ,   SA3.A3_NREDUZ  "
_cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
_cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD=SC5.C5_CLIENTE AND "
_cQuery += "                                 SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  "
_cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL='"+xFilial("SA3")+"' AND SA3.A3_COD=SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' '  "

/*
Ivandro Santos - início da alteração
Ticket#2017050337000144 — RELATORIO DE COMISSAO
//VICTOR DESSUNTE - 01/03/2017
//INICIO - TICKET:2017022837000175 
If MV_PAR04 == 2 .AND. SM0->M0_CODIGO == '01'
	_cQuery += " LEFT JOIN " + RetSqlName("SM2") + " SM2 "
	_cQuery += " ON	SM2.D_E_L_E_T_	= '' "
	_cQuery += " AND M2_DATA			= C5_EMISSAO "
EndIf
//FIM - TICKET:2017022837000175
Ticket#2017050337000144 — Fim da alteração
*/
//Ivandro Santos - 03/04/17
//Ticket#2017033137000103 — Pedidos Microsiga Masipack
IF SUBSTR(cNumEmp,1,2) $ '01_10' //IF SUBSTR(cNumEmp,1,2) == '10'
//Ticket#2017033137000103 — Fim da alteração
	_cQuery += "WHERE (SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' OR  SC5.C5_DTEFVEN BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"')"
ELSE
	_cQuery += "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
ENDIF	
_cQuery += "  AND SC5.C5_VEND1 <> '999   ' "

If MV_PAR03 == 'Z' .OR. MV_PAR03 == ' '
	
Else 
	IF	SubStr(cNumEmp,1,2) $ "01_10"
  		_cQuery += " AND SC5.C5_MSCATEG = '"+MV_PAR03+"' "
 	EndIf
EndIf
If MV_PAR05 <> 'ZZZZZZ' .AND. MV_PAR05 <> '      '
	_cQuery += " AND SC5.C5_VEND1 = '"+MV_PAR05+"'  "
EndIf

//VICTOR DESSUNTE - 08/09/2016
//INICIO - TICKET: 2016090637000133
If MV_PAR03 <> '3'
	If MV_PAR04 <> 3 
		If MV_PAR06 == 1 
			_cQuery += " AND SA3.A3_TIPO = 'I' "
		ElseIf MV_PAR06 == 2
			_cQuery += " AND SA3.A3_TIPO = 'E' "
		EndIf
	EndIF

	If MV_PAR04 == 1
		_cQuery += " AND SA1.A1_EST != 'EX' "
	ElseIf MV_PAR04 == 2
		_cQuery += " AND SA1.A1_EST = 'EX' "
	ElseIF MV_PAR04 == 3
		_cQuery += " AND C5_MSTPVEN = 'VT' "               
	EndIf
	_cQuery += "  AND SC5.C5_LIBEROK <> 'S' "
EndIf

If MV_PAR03 == '3'
	//_cQuery += "  AND SC5.C5_LIBEROK = 'S' "
	_cQuery += "  AND SC5.C5_MSTPVEN IN('AC') "
	_cQuery += "  AND SC5.C5_COMIS1 > 0 "
Else
	_cQuery += "  AND SC5.C5_MSTPVEN NOT IN ('CP','RE','AT') "
EndIf
//FIM - TICKET: 2016090637000133

//_cQuery += "  AND SC5.C5_NOTA <> 'XXXXXX' "
_cQuery += "  AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' '  "
_cQuery += "ORDER BY SC5.C5_NUM "

TcQuery _cQuery New Alias "QR1"


//Ivandro Santos - 03/04/17
//Ticket#2017033137000103 — Pedidos Microsiga Masipack
IF SUBSTR(cNumEmp,1,2) $ '01_10'   //IF SUBSTR(cNumEmp,1,2) == '10'
//Ticket#2017033137000103 — Fim da alteração
	TcSetField ("QR1","C5_DTEFVEN" ,"D",08,0)
	TcSetField ("QR1","C5_EMISSAO" ,"D",08,0)
ENDIF	


SetRegua(RecCount())           	           // TOTAL DE ELEMENTOS DA REGUA 

QR1->(dbGoTop())
Do While QR1->(!Eof())                                                              
	
	//Ivandro Santos - 03/04/17
	//Ticket#2017033137000103 — Pedidos Microsiga Masipack
	IF SUBSTR(cNumEmp,1,2) $ '01_10'	//IF SUBSTR(cNumEmp,1,2) == '10'                      
	//Ticket#2017033137000103 — Fim da alteração
		IF !EMPTY(QR1->C5_DTEFVEN) .AND. (QR1->C5_DTEFVEN < MV_PAR01 .OR. QR1->C5_DTEFVEN > MV_PAR02)
			QR1->(dbSkip())
			LOOP
		ENDIF	
	ENDIF	
    
	IncRegua()
/*     
   If Alltrim(QR1->A1_PAIS) <> "BR"      
	  SYA->(dbSetOrder(1))
	  SYA->(dbSeek(xFilial("SYA")+QR1->A1_PAIS))
	  cPaisReg := SubStr(SYA->YA_DESCR,1,18)
   Else
      SX5->(DbSetOrder(1))
      SX5->(DbGotop())
      If Alltrim(QR1->A1_EST) == "SP"
         If SX5->(DbSeek(xFilial("SX5")+"R6"+QR1->A1_REGIAO))
            cPaisReg := SubStr(SX5->X5_DESCRI,1,18)
         Else
            cPaisReg := "SÃO PAULO"   
         EndIf   
      Else
         SX5->(DbSeek(xFilial("SX5")+"12"+QR1->A1_EST))
         cPaisReg := SubStr(SX5->X5_DESCRI,1,18)
      EndIf
   EndIf    
*/

//	IF !(QR1->A1_PAIS == "BR" )
	IF !(QR1->A1_EST == "EX" )
		SYA->(dbSetOrder(1))
		SYA->(dbSeek(xFilial("SYA")+QR1->A1_PAIS))
		cPaisReg := SubStr(SYA->YA_DESCR,1,18)
	ELSE
		aSX512 := FwGetSX5('12',ALLTRIM(QR1->A1_EST))
		If Len(aSX512) > 0
			cPaisReg := Alltrim(aSX512[1,4])
		Endif
	ENDIF

	nVlrPed := 0
	
	If QR1->C5_MSVLPED > 0
		nVlrPed := QR1->C5_MSVLPED
	Else
		nVlrPed := 0   
	EndIf
	
	nComVend := 0
	nComRepr := 0
   
	If Li > 62
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf
	@ Li,000 Psay QR1->C5_NUM
	@ Li,008 Psay QR1->C5_CLIENTE + "-" + Alltrim(QR1->A1_NREDUZ)
	@ Li,037 Psay SubStr(QR1->C5_ORCAM,1,13)
	@ Li,052 Psay cPaisReg
	@ Li,071 Psay Alltrim(QR1->C5_VEND1)
	@ Li,077 Psay "-" + SubStr(QR1->A3_NREDUZ,1,15)

	nComVend := QR1->C5_COMIS1
	
	@ Li,095 Psay QR1->C5_COMIS1                  Picture "@E 99.99"
	@ Li,101 Psay (nVlrPed * QR1->C5_COMIS1 /100) Picture "@E 999,999.99"
   
	If Alltrim(QR1->C5_VEND2) <> ""
		@ Li,113 Psay Alltrim(QR1->C5_VEND2)
		SA3->(DbSetOrder(1))
		If SA3->(DbSeek(xFilial("SA3")+Alltrim(QR1->C5_VEND2)))
			@ Li,120 Psay "-" + SubStr(SA3->A3_NREDUZ,1,12)
		EndIf
		nComRepr := QR1->C5_COMIS2
		
		@ Li,134 Psay nComRepr Picture "@E 99.99"
		@ Li,140 Psay (nVlrPed * nComRepr /100) Picture "@E 999,999.99" 
	EndIf 
   
	@ Li,152 Psay nVlrPed Picture "@E 99,999,999.99"
	@ Li,166 Psay (QR1->C5_FRETAUT + QR1->C5_FRETE) Picture "@E 999,999.99"
	@ Li,178 Psay QR1->C5_SEGURO  Picture "@E 999,999.99"
	@ Li,193 Psay QR1->C5_MSVLMON Picture "@E 999,999.99"
	@ Li,205 Psay QR1->C5_DESPESA Picture "@E 999,999.99"
	Li++

	If !TRB->(DbSeek(QR1->C5_VEND1))
		RecLock("TRB",.T.)                                                       
		TRB->VENDEDOR := QR1->C5_VEND1
		TRB->TPVEND   := cTpVend
		TRB->TOTVEND  := nVlrPed
		TRB->TOTCOMIS := nVlrPed * nComVend /100
	Else
		RecLock("TRB",.F.)
		TRB->TOTVEND  += nVlrPed
		TRB->TOTCOMIS += nVlrPed * nComVend /100
	EndIf   
	TRB->(MsUnlock())
	
	If !(Empty(QR1->C5_VEND2))
		If !TRB->(DbSeek(QR1->C5_VEND2))
			RecLock("TRB",.T.)                                                       
			TRB->VENDEDOR := Alltrim(QR1->C5_VEND2)
			TRB->TPVEND   := "I"
			TRB->TOTVEND  := nVlrPed
			TRB->TOTCOMIS := nVlrPed * nComRepr /100
		Else
			RecLock("TRB",.F.)
			TRB->TOTVEND  += nVlrPed
			TRB->TOTCOMIS += nVlrPed * nComRepr /100
		EndIf   
		TRB->(MsUnlock())
	EndIf
		
	QR1->(dbSkip())
      
EndDo

// Imprime Resumo das comissões para pagamento pelo Depto. Financeiro 

Cabec1 := "                    Vendedor/Representante       Tipo                Valor das Vendas    Valor das Comissões      Valor a Pagar"
Cabec2 := ""

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
@ Li,050 Psay "**********   R   E   S   U   M   O   **********"
Li+=3

TRB->(DbGoTop())
Do While TRB->(!Eof())
   If TRB->TOTVEND > 0
	   SA3->(DbSeek(xFilial("SA3")+Alltrim(TRB->VENDEDOR)))
	   If Li > 62 
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			@ Li,050 Psay "**********   R   E   S   U   M   O   **********"
			Li+=3
		EndIf
		@ Li,020 Psay Alltrim(TRB->VENDEDOR) + "-" + Alltrim(SA3->A3_NREDUZ)
		If TRB->TPVEND == "E"
			@ Li,050 Psay "Representante"
		Else
			@ Li,050 Psay "Interno"   
		EndIf   
		@ Li,071 Psay TRB->TOTVEND  Picture "@E 999,999,999.99" 
		@ Li,093 Psay TRB->TOTCOMIS Picture "@E 999,999,999.99"
		nTotVend += TRB->TOTVEND
		If TRB->TPVEND == "E" .Or. TRB->TOTVEND > nMetas 
			@ Li,112 Psay TRB->TOTCOMIS Picture "@E 999,999,999.99"
			nTotComis += TRB->TOTCOMIS
		Else
			If MV_PAR03 <> '3'
				@ Li,122 Psay "0,00 - Não atingiu as metas"
			Else
				@ Li,112 Psay TRB->TOTCOMIS Picture "@E 999,999,999.99"
				nTotComis += TRB->TOTCOMIS
			EndIf
   	EndIf      
   	Li+=2
   EndIf
   TRB->(Dbskip())
EndDo
Li+=2
@ Li,020 Psay "T O T A I S   ======> "
@ Li,067 Psay nTotVend  Picture "@E 999,999,999,999.99"
@ Li,112 Psay nTotComis Picture "@E 999,999,999.99"   

If li != 80
	Roda(cbcont,cbtxt)
Endif

QR1->(dbCloseArea())

TRB->(DbCloseArea())
//fErase(_cArq + '.dbf')

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//******************************
	Static Function ImpParam()
//******************************
   
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
Li:= 10
@ Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
Li+=3
@ Li,000 Psay "Data emissão de.: " + DTOC(mv_par01)
@ Li,037 Psay  "ate: " + DTOC(mv_par02)
Li+=2

If SubStr(mv_par03,1,3) = "Z".Or. Alltrim(mv_par03) = "" 
	@ Li,000 Psay "Categoria.........: Todas"
Else
	@ Li,000 Psay "Categoria.........: " + mv_par03
EndIf

Li+=2
If mv_par04 = 1 
   @ Li,000 Psay "Quais Pedidos.....: Nacional"
ElseIF mv_par04 = 2
	@ Li,000 Psay "Quais Pedidos.....: Exportação"
ElseIf mv_par04 = 3
	@ Li,000 Psay "Quais Pedidos.....: Assistência Técnica"
EndIf
Li+=2
If mv_par05 = "ZZZZZZ".Or. mv_par05 = "      " 
   @ Li,000 Psay "Vendedor..........: Todos"
Else
	@ Li,000 Psay "Vendedor..........: " + mv_par05
EndIf
Li+=2
If mv_par06 = 1 
	@ Li,000 Psay "Quais Vendedores..: Internos"
ElseIf mv_par06 = 2
	@ Li,000 Psay "Quais Vendedores..: Externos"
Else
	@ Li,000 Psay "Quais Vendedores..: Todos"
EndIf            
Li:=80      

Return
