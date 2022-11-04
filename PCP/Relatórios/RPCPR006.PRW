
#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#Include "TOPCONN.CH"                    
#Include "TBICONN.CH"                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR850  ³ Autor ³ Jose Roberto          ³ Data ³ 13.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao Das Ordens de Producao  (OP x PV)  Status do PV     ³±±
±±³Descri‡…o ³Alterado em 13/06/08 (Incluido os parametros MV_PAR08,      ³±±
±±³          ³                       MV_PAR09 e MV_PAR11)                 ³±±
±±³Descri‡…o ³Alterado em 20/08/10 (Impressao dos componentes em falta e  ³±±
±±³          ³a situação dos mesmos conforme campo SC2->C2_MSPOSIC        ³±±
±±³          ³Fábio Dias.                                                 ³±±
±±³          ³                                                            ³±±
±±³Descricao ³Alterado em 08/12/10 (Impressao do resumo de apontamentos da³±±
±±³          ³Op e Criacao do MV_PAR10 para filtar o CC do desenho da OP  ³±± 
±±³Descricao ³Alterado em 30/05/11 (alteração do parametro mv_par09)      ³±±
±±³          ³1-Impr. Somente Desenhos  2-Impr. Somente Relatorio  3-Ambos³±±
±±³          ³                                                            ³±±
±±³Descricao ³Alterado em 31/10/11 por Ana Paula QFaustino                ³±±
±±³          ³ inclusão dos parametros (MV_PAR14-Aglutina Empenhos) e     ³±±
±±³          ³ (MV_PAR15 Dt.Empenho de) e (MV_PAR16-Dt.Empenho Ate)       ³±±
±±³          ³                                                            ³±±
±±³Descricao ³Alterado em 04/11/11 por Ana Paula QFaustino                ³±±
±±³          ³ inclusão dos parametros (MV_PAR17-Utiliza Gerenciador de   ³±±
±±³          ³ impressao? (S/N))                                          ³±±
±±³Descricao ³Alterado em 16/11/11 por Ana Paula QFaustino                ³±±
±±³          ³ os desenhos serão impressos de acordo com o array          ³±±
±±³          ³ APOSICSC2		                                            ³±±
±±³Descricao ³Alterado em 19/03/2012 por Ana Paula QFaustino              ³±±
±±³          ³ Colocar o Resumo distribuido em colunas  APOSICSC2         ³±±
±±³Descricao ³Alterado em 30/05/2012 por Ana Paula QFaustino              ³±±
±±³          ³ Somente vai imprimir desenhos que tiver no resumo Relatorio³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// Alterado em 19/09/2013 por Ana Paula QF
*/
User Function RPCPR006()

Local titulo 	   := "Relacao Das Ordens de Producao De Um PV"
Local cString	   := "SC2"
Local wnrel		   := "RPCPR006"
Local cDesc		   := "Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o."
Local aUsuario     := {}
Local cNomusu      := " " 

Private tamanho	   := "M"
Private aReturn    := {"Zebrado",1,"Administracao", 1, 2, 1, "",1 } 
Private cPerg      := "PCPR06" + Space(4)
Private nLastKey   := 0
Private li         := 80
Private aGrupos    := {}
Private aStruSC2   := {}
Private cAliasSC2  := "SC2"
Private cPend      := ""
Private cObs       := ""
Private X          := 0
Private _cPath     := ""
Private cDesenho   := ""
Private aDesenhos  := {}
Private aCategoria := {"Reaberto","Comercial","Comex","Venda de Peças","Outros","Maklaser","Assist.Tecnica"}
Private fImp       := .F.
Private dDtEntrega := CTOD("")
Private lPri       := .T.
Private _lParam    := .F.
Private _lRet      := .T.
Private cCcustoD   := ""
Private _cProd     := ""
Private aAreaSB1   := {}
PRIVATE aAreaSC2   := {}
PRIVATE aAreaSD4   := {}
Private aAreaSZ0   := {}
Private aPosicSc2  := {}	// Array criado p receber produto (SC2->C2_PRODUTO) e apontamento (SC2->C2_MSPOSIC), caso este campo n esteja vazio conforme solicitado por J.Roberto em 07/12/10
Private _cUsuario  := ""
Private _aUsuario  := {}
Private _cUsuSenha := {}
Private _cDeptoUsu := {}
Private cUsuario := ""
Private cData    := ""
Private cCCusto  := '201'
Private cNrDtCi  := ""
Private nB2QATU  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//³ MV_PAR01 Da OP                                               ³
//³ MV_PAR02 Ate a OP                                            ³
//³ MV_PAR03 Pedido                                              ³
//³ MV_PAR04 O Grupo                                             ³
//³ MV_PAR05 Imprime Itens empenhados "S/N"                      ³
//³ MV_PAR06 Imprime Pendencias       "S/N"                      ³
//³ MV_PAR07 Imprime Observações      "S/N"                      ³
//³ MV_PAR08 Imprime Apenas Faltantes "S/N"                      ³
//³ MV_PAR09 Imprime? 1-Somente Desenhos 2-Somente Relat. 3-Ambos³
//³ MV_PAR10 Filtra Desenhos por C.Custo ?                       ³
//³ MV_PAR11 Imprime Detalhes         "S/N"                      ³
//³ MV_PAR12 Acompanhamento PV 1-Em aberto 2-Todos               ³
//³ MV_PAR13 Apenas Listas            "S/N"                      ³
//³ MV_PAR14 Aglutina Empenho         "S/N"                      ³
//³ MV_PAR15 Data Empenho inicio                                 ³
//³ MV_PAR16 Data Empenho Final                                  ³
//³ MV_PAR17 Utiliza Gerenciador de Impressao "N/S"              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cUsuario  := RetCodUsr()

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
EndIf

cUsuario := SUBSTR(cUserName,1,15)
cData    := DtoS(Date())
Do While _lParam == .F.
	
	If !Pergunte(cPerg,.T.)
	   Return
	EndIf   
	
	MV_PAR01 := Alltrim(MV_PAR01)
	MV_PAR02 := Alltrim(MV_PAR02)
	MV_PAR03 := Alltrim(MV_PAR03)
	
	If Len(MV_PAR01) == 6
		MV_PAR01 += "01001"
	EndIf
	If Len(MV_PAR02) == 6
		MV_PAR02 += "99999"
	EndIf
	
	If MV_PAR01 == "" .And. SubStr(MV_PAR02,7,5) < "01001"
		apmsgStop("OP Final incorreta - Verifique")
		_lRet := .F.
	EndIf
	
	If MV_PAR02 < MV_PAR01
		apMsgStop("OP Final não pode ser menor que OP Inicial - Verifique")
		_lRet := .F.
	EndIf
	
	If !Empty(MV_PAR03)
		If (SubStr(MV_PAR01,1,6) <> "" .And. SubStr(MV_PAR01,1,6) <> MV_PAR03) .Or. (SubStr(MV_PAR02,1,2) <> "ZZ" .And. SubStr(MV_PAR02,1,6) <> MV_PAR03)
			apMsgStop("Parametros: Pedido e OP Inicial/Final incoerentes - Verifique")
			_lRet := .F.
		EndIf
	EndIf
	
	If !Empty(MV_PAR03)
		SC5->(DbSetOrder(1))
		If !SC5->(DbSeek(xFilial("SC5")+MV_PAR03))
			apMsgStop("Pedido não encontrado - Verifique")
			_lRet := .F.
		EndIf
	EndIf
	
	If _lRet
		_lParam := .T.
	Else
		If ! apMsgYesNo("*** Deseja corrigir os parametros ? ***")
			Return
		EndIf
		_lRet  := .T.
	EndIf
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

If Empty(MV_PAR03)
	MV_PAR12 := 3
EndIf

cCcustoD := Alltrim(MV_PAR10)

RptStatus({|lEnd| RPCP06Imp(@lEnd,tamanho,wnrel,cString)},Titulo)

Return NIL

*******************************************************
Static Function RPCP06Imp(lEnd,tamanho,wnrel,cString)  
*******************************************************
Local i := 0
Local J := 0
Local X := 0
Local nTipo    := 0
Local cStatus,nOrdem,cSeek
Local lQuery   := .F.
Local CbTxt

Private CbCont,cabec1,cabec2
Private nomeprog	:= "RPCPR006"
Private nOpsPedido	:= 0           // numero de OP´s do Pedido
Private nOpsFinaliz	:= 0          // numero de OP´s finalizadas do Pedido
Private cNumOpsc2	:= ""
Private cComponente := ""
Private cProgSZ0    := 'RPCPR006  '

cbtxt	:= SPACE(10)
cbcont	:= 0
m_pag	:= 1
nFalta	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Status do Pedido"
cabec1 := " OP/LS      Codigo             Descricao                                    Qde. P.V.   Cliente         Ref.      Grupo(s)"
cabec2 := ""

cabec(titulo,cabec1,cabec2,nomeprog,tamanho)

@ 008,000 PSAY "Ordens -> De " + ALLTRIM(MV_PAR01) + " a " + ALLTRIM(MV_PAR02)
@ 008,070 PSAY "Grupo: " + ALLTRIM(MV_PAR04)
@ 009,000 PSAY "Empenhos: "  + IF(MV_PAR05 == 1,"SIM","NAO")
@ 009,035 PSAY "Pendencias: " + IF(MV_PAR06 == 1,"SIM","NAO")
@ 009,070 PSAY "Obs.: " + IF(MV_PAR07 == 1,"SIM","NAO")
@ 010,000 PSAY "Apenas Faltantes: "  + IF(MV_PAR08 == 1,"SIM","NAO")
@ 010,035 PSAY "Imprime: "
If mv_par09 == 1
   @ 010,044 Psay "SOMENTE DESENHOS"
ElseIf mv_par09 == 2
   @ 010,044 Psay "SOMENTE RELATORIO"
ElseIf mv_par09 == 3
   @ 010,044 Psay "DESENHOS/RELAT."
EndIf       
@ 010,070 PSAY "Filtra Desenhos por CC: " + cCcustoD
@ 011,000 PSAY "Imprime Detalhes: " + IF(MV_PAR11 == 1,"SIM","NAO")
If MV_PAR12 = 3
	@011,035 PSAY "Imprime  Acompanhamento: Nenhum"
Else
	@011,035 PSAY "Imprime  Acompanhamento: " + IF(MV_PAR12 == 1,"Em Aberto","Todos")
EndIf
@ 011,070 PSAY "Apenas Listas: " + IF(MV_PAR13 == 1,"SIM","NAO") 
@ 012,000 PSAY "Aglutina Empenhos: "+ IF(MV_PAR14 == 1,"SIM","NAO")
@ 012,035 PSAY "Data Empenho de: " + DTOC(MV_PAR15)
@ 012,070 PSAY "Data Empenho Ate: "+ DTOC(MV_PAR16)
@ 013,000 PSAY "Utiliza Gerenciador de Impressao: "+ IF(MV_PAR17 == 1,"NAO","SIM") 
@ 014,000 PSAY REPLICATE("=",132)
cPend := ""
cObs  := ""
Li := 15
If !EMPTY(MV_PAR03)
	SC5->(DbSetOrder(1))
	IF sc5->(DBSEEK(xFilial("SC5") + MV_PAR03))
		cPend := Alltrim(SC5->C5_MSPEND)
		cObs  := Alltrim(SC5->C5_OBS)
		cEntrega  := DTOC(SC5->C5_MSDTENT)     // variavel usada para que esse valor apareca no linha dos apontamentos
		cMontagem := DTOC(SC5->C5_MSMONTA)     // variavel usada para que esse valor apareca no linha dos apontamentos
		If !Empty(SC5->C5_MSDTPEN)
			dDtEntrega := SC5->C5_MSDTPEN
		Else
			dDtEntrega := SC5->C5_MSDTENT
		EndIf
		If mv_par09 > 1
	       @ Li,000 PSAY "Pedido.: " + ALLTRIM(MV_PAR03)
		   If SC5->C5_MSLINK <> SC5->C5_NUM
		      @ Li,022 PSAY "Link: " + SC5->C5_MSLINK
		   EndIf
		   DtEmiNF := CTOD("")
		   If !Empty(SC5->C5_NOTA) .And. SC5->C5_NOTA <> "999999"
		      @ Li,035 PSAY "N.Fiscal: " + SC5->C5_NOTA
			  SF2->(DbSetOrder(1))
			  If SF2->(DbSeek(xFilial("SF2")+SC5->C5_NOTA))
			     DtEmiNF := SC5->C5_EMISSAO
			  EndIf
		   EndIf
		   If SubStr(cNumEmp,1,2) $ "01_10"
		   	@ Li,062 PSAY "Categoria: "+SC5->C5_MSCATEG+"-"+aCategoria[Val(SC5->C5_MSCATEG)+1] 
		   EndIf
		   @ Li,090  PSAY "Lay-out: " + Alltrim(SC5->C5_MSLAYOU)
		   SA1->(DBSEEK(xFilial("SA1") + SC5->C5_CLIENTE))
		   Li++
		   @ Li,000 PSAY "Cliente: " + ALLTRIM(SA1->A1_NOME)
		   @ Li,062 PSAY "Nome Reduzido: " + ALLTRIM(SA1->A1_NREDUZ)
		   @ Li,099  PSAY "Tipo de Venda: " + Alltrim(SC5->C5_MSTPVEN)
		   SC6->(DBSEEK(xFilial("SC6") + SC5->C5_NUM))
		   Li++
		   @ Li,000 PSAY "Emissao: " + DTOC(SC5->C5_EMISSAO)
	       @ Li,045 PSAY "Inicio Montagem: " + DTOC(SC5->C5_MSMONTA)
		   @ Li,074 PSAY "Entrega: " + DTOC(dDtEntrega)
		   @ Li,095 PSAY "Conclusao: "
		   If !Empty(SC5->C5_MSCONCL)
		      @ Li,106 PSAY SC5->C5_MSCONCL
		   Else
		      If !Empty(DtEmiNF)
			     @ Li,106 PSAY DtEmiNF
			  EndIf
		   EndIf
		EndIf   
	ENDIF
	If mv_par09 > 1
	   Li++
	   @ Li,000 PSAY "Multa: " + IF(SC5->C5_MSMULTA == "S","SIM","NAO")
	   @ Li,060 PSAY "Visita: " + IF(SC5->C5_MSVISIT == "S","SIM","NAO")
	   Li++
	   @ Li,000 PSAY REPLICATE("*",132)
	   Li++
	EndIf   
ENDIF
Li++

// Verifica o percentual de conclusão das OP's para o pedido (MV_PAR03)
If !Empty(MV_PAR03)
	SC2->(DBGOTOP())
	SC2->(DbOrderNickName("C2_PEDIDO"))
 	If SC2->(dbSeek(xFilial("SC2")+MV_PAR03))
		Do While !SC2->(Eof()) .And. Alltrim(SC2->C2_MSPED) = MV_PAR03
			If MV_PAR13 == 2 .Or. (MV_PAR13 == 1 .And. SC2->C2_MSLISTA == "S")
				nOpsPedido++
				If !Empty(SC2->C2_DATRF)
					nOpsFinaliz++
				EndIf
 			EndIf
			SC2->(DBSKIP())
			Loop
		EndDo
	EndIf
EndIf

SetRegua(RecCount())		// Total de Elementos da regua
SD4->(DBSETORDER(2))

If !Empty(MV_PAR03)
	SC2->(DbOrderNickName("C2_PEDIDO"))
	SC2->(DBGOTOP())
	cCondicao := "!SC2->(Eof()) .And. Alltrim(SC2->C2_MSPED) == MV_PAR03"
	SC2->(dbSeek(xFilial("SC2")+MV_PAR03))
ELSE
	SC2->(dbSetOrder(1))
	SC2->(DBGOTOP())
	SC2->(dbSeek(xFilial("SC2")+Alltrim(MV_PAR01)))
	cCondicao := "ALLTRIM(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN) <= MV_PAR02 .AND. !sc2->(EOF())"
EndIf

Do WHILE &cCondicao
	
	IncRegua()
	aGrupos := {}
	
	If lEnd
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	// verifica se a OP esta concluida. Se sim, ela nao sera impressa
	If !Empty(sc2->c2_datrf)
		SC2->(DBSKIP())
		LOOP
	EndIf
	
	// Imprime somente as OP's que estao em lista de separacao
	If MV_PAR13 == 1 .And. SC2->C2_MSLISTA <> "S"
		SC2->(DbSkip())
		Loop
	EndIf

	// Verifica todos os grupos existentes na OP
	SD4->(DBSEEK(XFILIAL("SD4") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN))
	Do While ALLTRIM(SD4->D4_OP) == SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN .AND. !SD4->(EOF())
		If Empty(SD4->D4_quant)
			SD4->(DbSkip())
			Loop
		EndIf
		
		SB1->(dbSeek(xFilial("SB1") + SD4->D4_COD))
		// ALTERAÇÃO FEITA EM 24/06/14 A PEDIDO DO PCP FABRIMA
		IF MV_PAR18 == 2 .AND. SUBSTR(SB1->B1_PROCED,1,1) <> '1'
			SD4->(dbSkip())
			LOOP
		ELSEIF MV_PAR18 == 3 .AND. SUBSTR(SB1->B1_PROCED,1,1) == '1'
			SD4->(dbSkip())
			LOOP
		ENDIF	
		If ASCAN(aGrupos, SB1->B1_GRUPO) == 0
			AADD(aGrupos, SB1->B1_GRUPO)
		EndIf
		SD4->(dbSkip())
	EndDo
	
	If !EMPTY(MV_PAR04)
		IF ASCAN(aGrupos, MV_PAR04) == 0
			// nao existe o grupo especificado nessa OP
			SC2->(DBSKIP())
			LOOP
		EndIf
	EndIf
	
	If mv_par09 > 1
		If Empty(MV_PAR03) .And. !lPri    // impressao de listas manualmente, sem junta-las com pedido
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		EndIf
		lPri := .F.
		@ Li,000 PSAY SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
		SB1->(DBSEEK(xFilial("SB1") + SC2->C2_PRODUTO))
		cUnid := SB1->B1_UM
		@ Li,012 PSAY Alltrim(SC2->C2_PRODUTO)
		If Alltrim(SB1->B1_REVATU) <> ""
			@ Li,PCOL() PSAY  "-" + SB1->B1_REVATU
		EndIf
		@ Li,032 PSAY SB1->B1_DESC
		@ Li,PCOL()+1 PSAY SC2->C2_QUANT - SC2->C2_QUJE Picture "@E 9,999,999.99"
		@ Li,PCOL()+2 PSAY SC2->C2_MSPED
		@ Li,PCOL()+2 PSAY SC2->C2_MSREDUZ
		@ Li,PCOL()+1 PSAY SPACE(8)
		@ Li,PCOL()+1 PSAY " "
		
		ASORT(aGrupos)
		
		For i := 1 TO LEN(aGrupos)
			@ Li,PCOL() PSAY ALLTRIM(aGrupos[i])
			IF i + 1 <= LEN(aGrupos)
				@ Li,PCOL() PSAY ","
			EndIf
		Next

		ChecaLinha()
		@ Li,031 PSAY "Inicio em.......: " + DTOC(SC2->C2_DATPRI) + "   Data Inicio Real: " + DTOC(SC2->C2_DATAJI)
		
		/*
			VICTOR DESSUNTE - 19/05/2016
			IMPRIME ROTEIRO DE OPERACOES NA LISTA
		*/
		dbSelectArea("SG2")
		SG2->(dbSetOrder(1))
		If SG2->(dbSeek(xFilial("SG2")+SC2->C2_PRODUTO))
			While SG2->(!EOF()) .AND. SG2->G2_PRODUTO == SC2->C2_PRODUTO
				Li++
				@ Li,031 PSAY "OPERACAO: " + ALLTRIM(SG2->G2_RECURSO) + '-' + ALLTRIM(POSICIONE("SH1",1,XFILIAL("SH1")+SG2->G2_RECURSO,"H1_DESCRI"))

				_cHor := ""
				_cMin := ""
				If SG2->G2_SETUP == 0
					_cHor := '0h'
					_cMin := '00min'
				ElseIf SG2->G2_SETUP < 1
					_cHor := '0h'
					_cMin := ALLTRIM(STR(SG2->G2_SETUP * 60)) + 'min'
					If AT('.',_cMin) > 0
						_cMin := SubStr(_cMin,1,AT('.',_cMin)-1)+'min'
					EndIf
				ElseIf SG2->G2_SETUP > 0.99
					_cHr := AllTrim(STR(SG2->G2_SETUP))
					If AT('.',_cHr) > 0
						_cHor	:= SubStr(_cHr,1,AT('.',_cHr)-1)+'h'
						_cMin	:= ALLTRIM(STR(VAL(SubStr(_cHr,AT('.',_cHr),Len(_cHr)))*60))+'min'
					Else
						_cHor := _cHr+'h'
						_cMin := "00min"
					EndIf
				EndIf
				@ Li,070 PSAY "MONTADORES: " + ALLTRIM(STR(SG2->G2_MAOOBRA))
				@ Li,085 PSAY "SET UP: " + _cHor + _cMin

				_cHor := ""
				_cMin := ""
				If SG2->G2_TEMPAD == 0
					_cHor := '0h'
					_cMin := '00min'
				ElseIf SG2->G2_TEMPAD < 1
					_cHor := '0h'
					_cMin := ALLTRIM(STR(SG2->G2_TEMPAD * 60)) + 'min'
					If AT('.',_cMin) > 0
						_cMin := SubStr(_cMin,1,AT('.',_cMin)-1)+'min'
					EndIf
				ElseIf SG2->G2_TEMPAD > 0.99
					_cHr := AllTrim(STR(SG2->G2_TEMPAD))
					If AT('.',_cHr) > 0
						_cHor	:= SubStr(_cHr,1,AT('.',_cHr)-1)+'h'
						_cMin	:= ALLTRIM(STR(VAL(SubStr(_cHr,AT('.',_cHr),Len(_cHr)))*60))+'min'
					Else
						_cHor := _cHr+'h'
						_cMin := "00min"
					EndIf
				EndIf

				@ Li,105 PSAY "TEMPO POR PECA: " + _cHor + _cMin
				
				SG2->(dbSkip())
			End
		EndIf
		
		If !Empty(SC2->C2_MSCI)
			ChecaLinha()
			@ Li,031 PSAY SC2->C2_MSCI + " - Data da CI: " + DTOC(SC2->C2_MSDTCI)
		EndIf

		If SubStr(cNumEmp,1,2) $ "01" 

			If !EMPTY(SC2->C2_MSPOSIC) .And. !('(201' $ SC2->C2_MSPOSIC)  
				ChecaLinha()
				aAreaSC2 := SC2->(GETAREA())	// Acrescentado este trecho para tratar apontamento de Ops
				_cProduto := SC2->C2_PRODUTO
            
				//*****************************************************
					SB1->(DbSetOrder(1))				
					If SB1->(dbSeek(xFilial("SB1") + _cProduto))
						cDescri := SB1->B1_DESC
					Else
						cDescri := ""
					EndIf
				//*****************************************************					
				
				SC2->(DbSetOrder(2))
				SC2->(DbSeek(xFilial("SC2")+_cProduto))
	
				Do While SC2->C2_PRODUTO == _cProduto .And. SC2->(!Eof())
					If SC2->(!Empty(SC2->C2_DATRF))
						SC2->(DBSKIP())
						Loop
					Endif
	
					cNrDtCI := ""
					If !EMPTY(SC2->C2_MSCI)
						cNrDtCI := " CI: "+ Alltrim(SC2->C2_MSCI) + " - Data da CI: " + DTOC(SC2->C2_MSDTCI)
					Else
						cNrDtCI := ""                                                 
					EndIf
					
					If "(" $ ALLTRIM(SC2->C2_MSPOSIC)
						nPosic := At("(",ALLTRIM(SC2->C2_MSPOSIC)) + 1
						cCCusto := substr(SC2->C2_MSPOSIC,nPosic,3)
					Else
						If Alltrim(cUnid) == 'CJ'
							cCCusto := "(201) -ANÁLISE DA MONTAGEM"						
						Else
							cCCusto := "(207) -ANÁLISE NO PCP"
						EndIf
						If aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO}) == 0
							If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
								// adiciona o conteudo no array para impressao no final do relatorio
								Aadd(aPosicSc2,{SC2->C2_PRODUTO,""," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,StrZero(day(SC2->C2_EMISSAO),2)+"/"+StrZero(Month(SC2->C2_EMISSAO),2),strzero(day(SC2->C2_DATPRF),2)+"/"+strzero(month(SC2->C2_DATPRF),2), ALLTRIM(SC2->C2_MSPOSIC), cCCusto, cDescri })	
							EndIf
						Endif
					EndIf
					
					If MV_PAR14 = 2
						If aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO}) == 0
							If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
								// adiciona o conteudo no array para impressao no final do relatorio
								Aadd(aPosicSc2,{SC2->C2_PRODUTO,""," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,StrZero(day(SC2->C2_EMISSAO),2)+"/"+StrZero(Month(SC2->C2_EMISSAO),2),strzero(day(SC2->C2_DATPRF),2)+"/"+strzero(month(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC), cCCusto, cDescri })	
							EndIf
						Endif
					Else
						// Alteração Efetuada em 16-11-2011 em conversa com José Roberto
						If DtoS(SC2->C2_DATRF) <= DtoS(MV_PAR16)	                
							nPos := aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO})
							If nPos > 0
								cCodOP := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) 
								nPos1 := aScan(aPosicSC2,{|x| x[2] == cCodOP })
								If nPos1 = 0
									If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
										// adiciona conteudo no array para impressao no final do relatorio
										Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
									Endif
								EndIf				  	
							Else
								If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
									// adiciona conteudo no array para impressao no final do relatorio
									Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
								EndIf
							Endif
						EndIf
					EndIf
					//////////////////////////////////
					SC2->(DBSKIP())
				End Do
				RESTAREA(AAREASC2)
				@ Li,031 PSAY ALLTRIM(SC2->C2_MSPOSIC)
			EndIf
		Else
			If !EMPTY(SC2->C2_MSPOSIC) .And. !('(201' $ SC2->C2_MSPOSIC)
				// .And. !('(201' $ SC2->C2_MSPOSIC)     Alterado em 28/05/2013 por Ana Paula QF
				ChecaLinha()
				aAreaSC2 := SC2->(GETAREA())	// Acrescentado este trecho para tratar apontamento de Ops
				_cProduto := SC2->C2_PRODUTO

				//*****************************************************
					SB1->(DbSetOrder(1))				
					If SB1->(dbSeek(xFilial("SB1") + _cProduto))
						cDescri := SB1->B1_DESC
					Else
						cDescri := ""
					EndIf
				//*****************************************************					

				SC2->(DbSetOrder(2))
				SC2->(DbSeek(xFilial("SC2")+_cProduto))
	
				Do While SC2->C2_PRODUTO == _cProduto .And. SC2->(!Eof())
					If SC2->(!Empty(SC2->C2_DATRF)) .Or. SC2->(EMPTY(SC2->C2_MSPOSIC))
						SC2->(DBSKIP())
						Loop
					Endif
	
					cNrDtCI := ""
					If !EMPTY(SC2->C2_MSCI)
						cNrDtCI := " CI: "+ Alltrim(SC2->C2_MSCI) + " - Data da CI: " + DTOC(SC2->C2_MSDTCI)
					Else
						cNrDtCI := ""                                                 
					EndIf
					
					If "(" $ ALLTRIM(SC2->C2_MSPOSIC)
						nPosic := At("(",ALLTRIM(SC2->C2_MSPOSIC)) + 1
						cCCusto := substr(SC2->C2_MSPOSIC,nPosic,3)
					Else
						cCCusto := " "
					EndIf
					
					If MV_PAR14 = 2
						If aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO}) == 0
							If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
								// adiciona o conteudo no array para impressao no final do relatorio
								Aadd(aPosicSc2,{SC2->C2_PRODUTO,""," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,StrZero(day(SC2->C2_EMISSAO),2)+"/"+StrZero(Month(SC2->C2_EMISSAO),2),strzero(day(SC2->C2_DATPRF),2)+"/"+strzero(month(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC), cCCusto, cDescri })	
							EndIf
						Endif
					Else
	                // Alteração Efetuada em 16-11-2011 em conversa com José Roberto
	                If DtoS(SC2->C2_DATRF) <= DtoS(MV_PAR16)	                
							nPos := aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO})
							If nPos > 0
								cCodOP := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) 
								nPos1 := aScan(aPosicSC2,{|x| x[2] == cCodOP })
								If nPos1 = 0
									If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
										// adiciona conteudo no array para impressao no final do relatorio
										Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
									Endif
								EndIf				  	
							Else
								If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
									// adiciona conteudo no array para impressao no final do relatorio
									Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
								EndIf
							Endif
						EndIf
					EndIf
					//////////////////////////////////
					SC2->(DBSKIP())
				End Do
				RESTAREA(AAREASC2)
				@ Li,031 PSAY ALLTRIM(SC2->C2_MSPOSIC)
			EndIf
		EndIf
	    
//////////////////////////////////
/////////////////////////////////
////////////////////////////////

		IF !EMPTY(SC2->C2_OBS)
			ChecaLinha()
			@ Li,031 PSAY "Obs da OP: " + ALLTRIM(SC2->C2_OBS)
			ChecaLinha()
		ENDIF
	   If Val(SC2->C2_SEQUEN) == 1
	      SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC6")+SC2->C2_NUM+SC2->C2_ITEM))
				If !Empty(AllTrim(SC6->C6_MSOBS))
					ChecaLinha()
					@ Li ,031 PSay "Obs do PV: "  + ALLTRIM(SC6->C6_MSOBS)
					ChecaLinha()
			 	EndIf
			 	If !Empty((SC6->C6_MSDTLIB))
					ChecaLinha()
					@Li ,031 PSay "Liberado pela Engenharia em "  + DTOC(SC6->C6_MSDTLIB)
					ChecaLinha()
				EndIf
			EndIf
	   EndIf
	   ChecaLinha()
	EndIf
	
	// *** Imprime Empenhos ***
	IF SD4->(dbSeek(xFilial("SD4") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)) .AND. MV_PAR05 == 1 //1"SIM" 2"NAO"
		WHILE ALLTRIM(sd4->d4_op) == SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN .AND. !SD4->(EOF())
			SB1->(dbSeek(xFilial("SB1") + SD4->D4_COD))
			// ALTERAÇÃO FEITA EM 24/06/14 A PEDIDO DO PCP FABRIMA
			IF MV_PAR18 == 2 .AND. SUBSTR(SB1->B1_PROCED,1,1) <> '1'
				SD4->(dbSkip())
				LOOP
			ELSEIF MV_PAR18 == 3 .AND. SUBSTR(SB1->B1_PROCED,1,1) == '1'
				SD4->(dbSkip())
				LOOP
			ENDIF	
	 		// FIM DA ALTERAÇÃO
			IF sd4->d4_quant > 0
				
				// *** Imprime os Faltantes ***
     			If MV_PAR14 = 1 .OR. MV_PAR14 = 2
     			    
					cQry1 := " SELECT SUM(SC6.C6_QTDVEN) - SUM(SC6.C6_QTDENT) AS nSomaSC6 " 
					cQry1 += " FROM "+RetSqlName("SC6")+" SC6 " 
					cQry1 += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_NUM = SC6.C6_NUM " 
					cQry1 += " WHERE SC6.D_E_L_E_T_ = ' ' " 
					cQry1 += "   AND SC5.D_E_L_E_T_ = ' ' " 
					cQry1 += "   AND SC6.C6_NOTA = ' ' " 
					cQry1 += "   AND SC6.C6_PRODUTO = '"+(SD4->D4_COD)+"'  " 
					cQry1 += "   AND SC5.C5_MSDTENT BETWEEN '"+DtoS(mv_par15)+"' AND '"+DtoS(mv_par16)+"' "  
					cQry1 += "   AND SC5.C5_MSDTPEN BETWEEN '"+DtoS(mv_par15)+"' AND '"+DtoS(mv_par16)+"' " 
					//cQry1 += "   AND SUBSTR(SC5->C5_NOTA,1,1) <> 'X' "  
															
					//Executa QUERY
					cQry1 := ChangeQuery(cQry1)
					
					DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry1),"TMP1",.T.,.T.)
					
					dbSelectArea("TMP1")
					TMP1->(dbGoTop())
					nTReg1 := TMP1->(RecCount())
					ProcRegua(nTReg1)
				
					dbGotop()
					nQtdeSC6 := nSomaSC6
				
					TMP1->(dbCloseArea())

					cQry1 := "SELECT SUM(SD4.D4_QUANT) AS nSomaSD4 "
					cQry1 += "FROM "+RetSqlName("SD4")+" SD4 "
					cQry1 += "WHERE SD4.D_E_L_E_T_ = ' ' "
					cQry1 += "  AND SD4.D4_COD = '"+(SD4->D4_COD)+"' "
					cQry1 += "  AND SD4.D4_DATA BETWEEN '"+DtoS(mv_par15)+"' AND '"+DtoS(mv_par16)+"' "
				
					//Executa QUERY
					cQry1 := ChangeQuery(cQry1)
				
					DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry1),"TMP1",.T.,.T.)
				
					dbSelectArea("TMP1")
					TMP1->(dbGoTop())
					nTReg1 := TMP1->(RecCount())
					ProcRegua(nTReg1)
			
					dbGotop()                                                                              
					nQtdeSD4 := nSomaSD4
			
					TMP1->(dbCloseArea())
					
					nQtdeEmp := nQtdeSC6 + nQtdeSD4

					// *** Imprime os Faltantes ***
					If MV_PAR08 == 1


						SB2->(DBSEEK(xFilial("SB2") + SD4->D4_COD+"01" ))
						nFalta := SB2->B2_QATU - nQtdeEmp
						IF nFalta >= 0
							SD4->(DBSKIP())
							LOOP
						Endif
					Endif
				Else
					// *** Imprime os Faltantes ***
					If MV_PAR08 == 1
						//SB1->(DBSEEK(xFilial("SB1") + sd4->d4_cod))

						SB2->(DBSEEK(xFilial("SB2")+SD4->D4_COD+"01"))
						nFalta := SB2->B2_QATU - SD4->D4_QUANT
						IF nFalta >= 0
							SD4->(DBSKIP())
							LOOP
						Endif
					Endif
				EndIf
				
				If mv_par09 > 1
					If MV_PAR11 == 1
						@ Li,012 PSAY REPLICATE("-",120)
						ChecaLinha()
					ENDIF
					SB1->(DBSEEK(xFilial("SB1") + sd4->d4_cod))
					SB2->(DBSEEK(xFilial("SB2") + SD4->D4_COD+"01")) 
					@ Li,012 PSAY Alltrim(sd4->d4_cod)
					If Alltrim(sb1->b1_revatu) <> ""
					   @ Li,PCOL() PSAY  "-" + sb1->b1_revatu
					EndIf
					@ Li,032 PSAY SubStr(sb1->b1_desc,1,29)
					@ Li,PCOL()+1 PSAY "Qtd: " + STR(sd4->d4_quant,4,0)
					@ Li,PCOL()+1 PSAY SB1->B1_UM
					@ Li,PCOL()+1 PSAY "Ref.: " + sd4->d4_msrefer
					@ Li,PCOL()+1 PSAY sd4->d4_mslf

					If MV_PAR14 = 1 .OR. MV_PAR14 = 2

						@ Li,PCOL()+1 PSAY "Est: "+ Transform(SB2->B2_QATU,'@E 99999')
						@ Li,PCOL()+1 PSAY "Emp: "+ Transform(nQtdeEmp,'@E 99999')
					Else

						@ Li,PCOL()+1 PSAY "Est: "+ Transform(SB2->B2_QATU,'@E 99999')
						@ Li,PCOL()+1 PSAY "Emp: "+ Transform(SB2->B2_QEMP,'@E 99999')
					EndIf
					@ Li,PCOL()+1 PSAY "Local: " + sb1->b1_local
					@ Li,PCOL()+1 PSAY "GP:" + ALLTRIM(sb1->b1_grupo)
					ChecaLinha()
				EndIf
				
				////////////////  IMPRIME DESENHO SOMENTE SE O DEPARTAMENTO FOR "201"  //////////////////////
				If MV_PAR09 == 1 .Or. MV_PAR09 == 3 .And. '201' $ _cDeptoUsu
				   // *** Verifica todos os desenhos dos itens da OP ***
				   SB1->(DbSetOrder(1))
				   If SB1->(dbSeek(xFilial()+sd4->d4_cod))
				      cDesenho := Alltrim(sd4->d4_cod) + Alltrim(sb1->b1_revatu)
				   EndIf
				   _cPath := "H:\PLOTTER\"
				   If SubStr(cNumEmp,1,2) == "01"
				      If Substr(cDesenho,1,2) == "CL" .or. Substr(cDesenho,1,2) == "IM"
				         _cPath += Substr(cDesenho,3,2) + "\"
				      Else
				         _cPath += Substr(cDesenho,1,2) + "\"
				      EndIf
				   ElseIf SubStr(cNumEmp,1,2) == "10"   
	                  _cPath += Substr(cDesenho,1,3) + "\"
	               EndIf
					 //Alert(cDesenho)
				   If cCcustoD $ SC2->C2_MSPOSIC .OR. Empty(cCcustoD)
				      If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
					     AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat "  + _cPath + Alltrim(cDesenho) + ".PLT")
						 AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat "  + _cPath + Alltrim(cDesenho) + ".PRI")
						 AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat "  + _cPath + Alltrim(cDesenho) + ".PRN")
					  EndIf
				   EndIf
				EndIf
				//////////////////////////////////////////////////////////////////////////////////////////////////
				
				If MV_PAR11 == 1
					cProd := SD4->D4_COD
					ImpDetalhes()
				Endif
				
			Endif
			SD4->(DBSKIP())
		Enddo
	ENDIF
	If mv_par09 > 1
	   @ Li,000 PSAY REPLICATE("*",132)
	   ChecaLinha()
	EndIf   
	SC2->(dbSkip())
EndDo

IF !EMPTY(MV_PAR03)
   If Li > 60
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
   EndIf   
	sc5->(DBSEEK(xFilial("SC5") + ALLTRIM(MV_PAR03))) 
	Li++
	@ li,000 PSAY "Total de OP´s para o pedido " + ALLTRIM(MV_PAR03) + ": " + STRZERO(nOpsPedido,3)
	Li++
	@ li,000 PSAY "         Total de OP´s finalizadas: " + STRZERO(nOpsFinaliz,3)
	Li++
	@ li,000 PSAY "               Conclusao do pedido: " + STR(nOPsFinaliz/nOpsPedido*100,3,0) + "%"
	IF EMPTY(sc5->c5_msposic) .OR. "%" $ ALLTRIM(sc5->c5_msposic) .OR. "INICIO" $ ALLTRIM(sc5->c5_msposic) .OR. "RESTA008" $ ALLTRIM(sc5->c5_msposic) .OR. "SD3250I" $ ALLTRIM(sc5->c5_msposic)
		RecLock("SC5",.F.)
		sc5->c5_msposic := STRZERO(nOPsFinaliz/nOpsPedido*100,3,0) + "% em " + DTOC(DATE())
		MsUnlock()
	ENDIF
ENDIF

If !Empty(MV_PAR03) .And. MV_PAR06 == 1 .And. !Empty(cPend) .And. mv_par09 > 1
	Li+=2
	If Li > 62
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf
	@li,000 Psay "PENDENCIA: "
	For X := 1 TO MLCOUNT(cPend,80)
		Li++
		If Li > 68
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		EndIf
		@li,012 PSay MEMOLINE(cPend,80,X)
	Next
EndIf

If !Empty(MV_PAR03) .And. mv_par09 > 1
	If MV_PAR07 == 1 .And. !Empty(cObs)
		Li+=2
		//If Li > 62
		//	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		//EndIf
		@ Li,000 Psay "OBSERVACÕES: "
		For X := 1 TO MLCOUNT(cObs,80)
			Li++
			If Li > 68
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				@ Li,000 Psay "OBSERVACÕES: "
			EndIf
			@ Li,012 PSay MEMOLINE(cObs,80,X)
		Next
	EndIf
    If MV_PAR12 <> 3
		Li+=2
		If Li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		EndIf
		@ Li,000 PSAY Replicate("*",52) + "  Acompanhamento do Pedido  " + Replicate("*",52)
		fImp := .F.
		SZM->(dbSetOrder(1))                           // Imprime acompanhamento do pedido
		If SZM->(DbSeek(xFilial("SZM")+Alltrim(MV_PAR03)))
			Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(MV_PAR03)
				If MV_PAR12 == 2 .Or. (MV_PAR12 == 1 .And. SZM->ZM_STATUS <> "E")
					If !Empty(SZM->ZM_EVENTO)
						fImp := .T.
					EndIf
				EndIf
				SZM->(DbSkip())
				Loop
			Enddo
		EndIf
		If fImp
			ImpAcompaPV()
		Else
			Li++
			@ Li,000 Psay "Não há eventos em aberto para este Pedido"
		EndIf
	EndIf
	Li++
	@ Li,000 PSAY Replicate("*",132)
Endif

If MV_PAR03 <> "" .And. (SC5->C5_MSCATEG <> "1" .OR. SubStr(cNumEmp,1,2) $ "15_40_45")
   SC6->(DbSetOrder(1))
   If SC6->(DbSeek(xFilial("SC6")+MV_PAR03))
	  If mv_par09 > 1
	     Li+=2
		 Checalinha()
		 @ Li,000 PSAY Replicate("=",53) + " ITENS DO PEDIDO DE VENDA " + Replicate("=",53)
		 Li+=2
		 @Li,001 PSAY "ITEM   UM  CODIGO           DESCRIÇÃO                                QTDE.PV  LOCAL      SALDO   PRAZO  LIBERACAO PCP"
		 //            00     PC  123456789012345  12345678901234567890123456789012345  999,999.999  1234567  999,999   5 D
		 Li++
		 @ Li,000 PSAY Replicate("-",132)
		 Li+=2
	  EndIf	  
	  Do While !SC6->(Eof()) .And. SC6->C6_NUM == MV_PAR03
	     If mv_par09 > 1
	        If Li >= 68
			    cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			    @ Li,000 PSAY Replicate("=",53) + " ITENS DO PEDIDO DE VENDA " + Replicate("=",53)
			    Li+=2
			    @ Li,001 PSAY "ITEM   UM  CODIGO           DESCRIÇÃO                                QTDE.PV  LOCAL      SALDO   PRAZO  LIBERACAO PCP"
			    Li++
				@ Li,000 PSAY Replicate("-",132)
				Li+=2
			EndIf
			@Li,001 PSAY SC6->C6_ITEM
			If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+"01"))
				@ Li,008 PSAY SB1->B1_UM
				@ Li,012 PSAY SC6->C6_PRODUTO
				@ Li,029 PSAY SB1->B1_DESC
				@ Li,066 PSAY (SC6->C6_QTDVEN - SC6->C6_QTDENT) Picture "@E 999,999.999"
				@ Li,079 PSAY SB1->B1_LOCAL
				@ Li,089 PSAY SB2->B2_QATU Picture "@E 999,999"

				@ Li,099 PSAY ALLTRIM(STR(SB1->B1_PE,5,0)) + " " + SB1->B1_TIPE
				If !Empty(SC6->C6_MSPCP) .And. SC6->C6_MSPCP <> CTOD("31/12/49")
			       @ Li, 106 PSay SC6->C6_MSPCP
			    EndIf  
			Else
				@ Li,029 PSAY "Produto não encontrado"
				@ Li,066 PSAY (SC6->C6_QTDVEN - SC6->C6_QTDENT) Picture "@E 999,999"
			EndIf
			Li++
		 EndIf	
		 If MV_PAR11 == 1
		    cProd := SC6->C6_PRODUTO
		    ImpDetalhes()
		 EndIf
		 SC6->(DbSkip())
	  EndDo
	  If mv_par09 > 1
	     ChecaLinha()
	     @ Li,000 PSAY Replicate("=",132)
	  EndIf   
   EndIf
EndIf

//*** Chamada da funcao que imprime o resumo dos apontamentos no final do relatorio ***
If mv_par09 > 1
   ImpApont()
EndIf   

If aReturn[5] == 1
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH() 

//*** IMPRIME OS DESENHOS REF. AOS ITENS DA OP ***  
//AcertaIMP()
If Len(aDesenhos) > 0
	If aReturn[5] > 1 .And. (mv_par09 == 1  .Or. mv_par09 == 3)
		For J := 1 TO LEN(aDesenhos)
			WaitRun(aDesenhos[j])
		Next
	EndIf
Endif
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChecaLinhaºAutor  ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Soma linha e quebra de pagina                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION ChecaLinha()

Local X := 0 

If mv_par09 > 1
   IF Li >= 68
	  cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
   ELSE
      Li++
   ENDIF
EndIf   
RETURN NIL

*****************************
Static Function ImpAcompaPV()
*****************************

Local cVendedor := "Não cadastrado"
Local nTarefa   := 0
Local X := 0

SC5->(DbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+MV_PAR03))
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1))
		cVendedor :=  SubStr(SA3->A3_NREDUZ,1,15)
	EndIf
EndIf

Li++
If Li > 62
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,)
	Li := 6
EndIf
If SZM->(DbSeek(xFilial("SZM")+Alltrim(MV_PAR03)))
	@ Li,000 Psay "Pedido: " + SZM->ZM_PEDIDO
	@ Li,016 Psay "Cliente: " + SubStr(SZM->ZM_CLIENTE,1,15)
	@ Li,040 Psay "Vendedor.......: " + cVendedor
	Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(MV_PAR03)
		If MV_PAR12 == 2 .Or. (MV_PAR12 == 1 .And. SZM->ZM_STATUS <> "E")
			If !Empty(Alltrim(SZM->ZM_EVENTO))
				nTarefa++
				Li++
				If Li > 62
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				Else
					If nTarefa > 1
						@ Li,008 Psay Replicate("-",124)
						Li++
					EndIf
				EndIf
				@ Li,008 Psay "De....: " + SZM->ZM_DEPTO
				@ Li,040 Psay "Emitente...: " + SubStr(SZM->ZM_MSUSER,1,10)
				@ Li,067 Psay "Emissão: " + DTOC(SZM->ZM_DATA)
				@ Li,086 Psay "Ult.Atualização: " + DTOC(SZM->ZM_ULTALT)
				@ Li,113 Psay "Status.:"
				If SZM->ZM_STATUS == "A"
					@ Li,121 Psay "Aberto"
				ElseIf SZM->ZM_STATUS == "P"
					@ Li,121 Psay "Em Processo"
				ElseIf SZM->ZM_STATUS == "E"
					@ Li,121 Psay "Encerrado"
				ElseIf SZM->ZM_STATUS == "R"
					@ Li,121 Psay "Reavaliar"
				EndIf
				Li+=2
				@ Li,008 Psay "Para..: " + SZM->ZM_DEPTDES
				@ Li,040 Psay "Resposta p/: " + DTOC(SZM->ZM_DTPREV)
				If SZM->ZM_STATUS == "E"
					@ Li,066 Psay "Tarefa realizada: "
					If (SZM->ZM_DTPREV - SZM->ZM_ULTALT) >= 0
						@ Li,084 Psay "No prazo"
					Else
						@ Li,084 Psay "com "
						@ Li,088 Psay Abs(SZM->ZM_DTPREV - SZM->ZM_ULTALT) Picture "@E 99"
						@ Li,091 Psay "dia(s) de atraso"
					EndIf
				EndIf
				Li+=2
				If Li > 62
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
					@ Li, 000 Psay SZM->ZM_PEDIDO
				EndIf
				@ Li, 008 Psay "Tarefa: "
				For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_EVENTO),80)
					If Li > 68
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						@ Li, 000 Psay SZM->ZM_PEDIDO
						@ Li, 008 Psay "Tarefa: "
					EndIf
					@ Li,016 PSAY MEMOLINE(Alltrim(SZM->ZM_EVENTO),80,X)
					Li++
				Next
				If !Empty(Alltrim(SZM->ZM_COMENT))
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						@ Li, 000 Psay SZM->ZM_PEDIDO
						@ Li, 008 Psay "Comentario do Destino: "
					Else
						@ Li, 008 Psay "Comentario do Destino: "
					EndIf
					For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_COMENT),80)
						If Li > 68
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
							@ Li, 000 Psay SZM->ZM_PEDIDO
							@ Li, 008 Psay "Comentario do Destino: "
						EndIf
						@ Li,031 PSAY MEMOLINE(Alltrim(SZM->ZM_COMENT),80,X)
						Li++
					Next
				EndIf
				If SZM->ZM_ASSUNTO == "LOGAPV"
					Li++
					@ Li, 008 Psay "Datas na Geração do Log => Entrega Original: " + DTOC(SZM->ZM_ENTLOG)
					@ Li, 070 Psay "Entrega Prevista: " + DTOC(SZM->ZM_PREVLOG)
					@ Li, 100 Psay "Inicio da Montagem: " + DTOC(SZM->ZM_INIMONT)
					Li++
				EndIf
				If !Empty(SZM->ZM_LOGCOM)
					Li++
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						@ Li, 000 Psay SZM->ZM_PEDIDO
						@ Li, 008 Psay "Log Reunião - Comercial..: "
					Else
						@ Li, 008 Psay "Log Reunião - Comercial.: "
					EndIf
					For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_LOGCOM),80)
						If Li > 68
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
							@ Li, 000 Psay SZM->ZM_PEDIDO
							@ Li, 008 Psay "Log Reunião - Comercial..: "
						EndIf
						@ Li,035 PSAY MEMOLINE(Alltrim(SZM->ZM_LOGCOM),80,X)
						Li++
					Next
					If !Empty(SZM->ZM_DTCOM)
						Li++
						@ Li,008 Psay "Data Prevista: "+ DTOC(SZM->ZM_DTCOM)
						Li++
					EndIf
				EndIf
				If !Empty(SZM->ZM_LOGENG)
					Li++
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						@ Li, 000 Psay SZM->ZM_PEDIDO
						@ Li, 008 Psay "Log Reunião - Engenharia: "
					Else
						@ Li, 008 Psay "Log Reunião - Engenharia: "
					EndIf
					For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_LOGENG),80)
						If Li > 68
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
							@ Li, 000 Psay SZM->ZM_PEDIDO
							@ Li, 008 Psay "Log Reunião - Engenharia: "
						EndIf
						@ Li,035 PSAY MEMOLINE(Alltrim(SZM->ZM_LOGENG),80,X)
						Li++
					Next
					If !Empty(SZM->ZM_DTENG)
						Li++
						@ Li,008 Psay "Data Prevista: "+ DTOC(SZM->ZM_DTENG)
						Li++
					EndIf
				EndIf
				If !Empty(SZM->ZM_LOGPROD)
					Li++
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						@ Li, 000 Psay SZM->ZM_PEDIDO
						@ Li, 008 Psay "Log Reunião - PCP/Prod..: "
					Else
						@ Li, 008 Psay "Log Reunião - PCP/Prod..: "
					EndIf
					For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_LOGPROD),80)
						If Li > 68
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
							@ Li, 000 Psay SZM->ZM_PEDIDO
							@ Li, 008 Psay "Log de Reunião - PCP/Prod..: "
						EndIf
						@ Li,035 PSAY MEMOLINE(Alltrim(SZM->ZM_LOGPROD),80,X)
						Li++
					Next
					If !Empty(SZM->ZM_DTPROD)
						Li++
						@ Li,008 Psay "Data Prevista: "+ DTOC(SZM->ZM_DTPROD)
						Li++
					EndIf
				EndIf
				If !Empty(SZM->ZM_LOGMONT)
					Li++
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						@ Li, 000 Psay SZM->ZM_PEDIDO
						@ Li, 008 Psay "Log Reunião - Montagem..: "
					Else
						@ Li, 008 Psay "Log Reunião - Montagem..: "
					EndIf
					For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_LOGMONT),80)
						If Li > 68
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
							@ Li, 000 Psay SZM->ZM_PEDIDO
							@ Li, 008 Psay "Log de Reunião - Montagem..: "
						EndIf
						@ Li,035 PSAY MEMOLINE(Alltrim(SZM->ZM_LOGMONT),80,X)
						Li++
					Next
					If !Empty(SZM->ZM_DTMONT)
						Li++
						@ Li,008 Psay "Data Prevista: "+ DTOC(SZM->ZM_DTMONT)
						Li++
					EndIf
				EndIf
				If !Empty(SZM->ZM_LOGTEST)
					Li++
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						@ Li, 000 Psay SZM->ZM_PEDIDO
						@ Li, 008 Psay "Log Reunião - Testes....: "
					Else
						@ Li, 008 Psay "Log Reunião - Testes....: "
					EndIf
					For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_LOGTEST),80)
						If Li > 68
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
							@ Li, 000 Psay SZM->ZM_PEDIDO
							@ Li, 008 Psay "Log de Reunião - Testes....: "
						EndIf
						@ Li,035 PSAY MEMOLINE(Alltrim(SZM->ZM_LOGTEST),80,X)
						Li++
					Next
					If !Empty(SZM->ZM_DTTEST)
						Li++
						@ Li,008 Psay "Data Prevista: "+ DTOC(SZM->ZM_DTTEST)
						Li++
					EndIf
				EndIf
				If !Empty(SZM->ZM_DTACEIT)
					@ Li,008 PSAY "Concluido em: "+ DTOC(SZM->ZM_DTACEIT)  + "  Usuario: "+ SZM->ZM_USUACEI
					Li++
				EndIf
			EndIf
		EndIf
		SZM->(DbSkip())
		Loop
	EndDo
EndIf

Return

*****************************
Static Function ImpDetalhes()
*****************************
Local cQuery := ""

// *** Imprime as OPs dos Empenhos ***
dbSelectArea("SC2")

// *** GRAVACAO DO REGISTRO ORIGINAL
//nRegSC2 := SC2->(RECNO())

aGravaSB1 := SB1->(GETAREA())
aGravaSC2 := SC2->(GETAREA())
aGravaSC6 := SC6->(GETAREA())
aGravaSD4 := SD4->(GETAREA())

SC2->(dbSetOrder(2))
SC2->(DBSEEK(XFILIAL("SC2") + cProd))

While SC2->C2_PRODUTO == cProd .AND. !sc2->(EOF())
	IF (SC2->C2_QUJE+SC2->C2_PERDA) < sc2->c2_quant .AND. EMPTY(sc2->c2_datrf)
	   If mv_par09 > 1
		 cUsu := Substr(Embaralha(SC2->C2_USERLGI,1),1,13)
		 If Substr(cUsu,1,1) <> '#'
			 _NomUsu := cUsu
		 Else
		 	 _CodUsu := substr(cUsu,3,6)
			 PswOrder(1)
			 If PswSeek(_CodUsu,.T.)
			 	 _NomUsu := UsrRetName(_CodUsu)
			 Else
				 _NomUsu := 'Não Existe'
	         EndIf
    	  EndIf
		  @ Li,016      PSAY "OP: "+ SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
		  @ Li,PCOL()+2 PSAY sc2->c2_msreduz
		  @ Li,PCOL()+2 PSAY "Qtde: "+ str((sc2->c2_quant - sc2->c2_quje - SC2->C2_PERDA),4,0)
		  @ Li,PCOL()+2 PSAY "Inicio: "
		  @ Li,PCOL()+2 PSAY sc2->c2_datpri
		  @ Li,PCOL()+2 PSAY "Entrega: "
		  @ Li,PCOL()+2 PSAY sc2->c2_datprf
		  @ Li,PCOL()+2 PSAY "Emitente: " + _NomUsu
		  //Substr(Embaralha(SC2->C2_USERLGI,1),1,13) // Embaralha - funcao da siga para embaralhar/desembaralhar usuario 0->embaralha  1->desembaralha
		  @ Li,PCOL()+2 PSAY substr(alltrim(sc2->c2_obs),1,46)
		  ChecaLinha()
	   EndIf

		cNrDtCI := ""
		IF !EMPTY(sc2->c2_msci)
			cNrDtCI := " CI: "+ alltrim(sc2->c2_msci)+ "-Dt.CI:" + DTOC(sc2->c2_msdtci)+" "
		Else
			cNrDtCI := ""
		ENDIF

		If SubStr(cNumEmp,1,2) $ "01" 

		   If !EMPTY(sc2->c2_msposic) 
		     //.And. !('(201' $ sc2->c2_msposic)  Alterado em 28/05/2013 por Ana Paula QF
				aAreaSC2 := SC2->(GETAREA())
				_cProd := SC2->C2_PRODUTO
				
				//*****************************************************
					SB1->(DbSetOrder(1))				
					If SB1->(dbSeek(xFilial("SB1") + _cProd ))
						cDescri := SB1->B1_DESC
					Else
						cDescri := ""
					EndIf
				//*****************************************************					
				
				SC2->(DbSetOrder(2))
				SC2->(DbSeek(xFilial("SC2") + _cProd))
				Do While SC2->C2_PRODUTO == _cProd .And. SC2->(!Eof())
					
					//*****************************************
						SB1->(DbSetOrder(1))
						If SB1->(DbSeek(xFilial("SB1") + _cProd))
							cDescri := SB1->B1_DESC
						Else
							cDescri := ""
						EndIf
					//*****************************************					
				
					If SC2->(!Empty(SC2->C2_DATRF)) .Or. SC2->(EMPTY(SC2->C2_MSPOSIC))
						SC2->(DBSKIP())
						Loop
					Endif
					If "(" $ ALLTRIM(SC2->C2_MSPOSIC)
						nPosic := At("(",ALLTRIM(SC2->C2_MSPOSIC)) + 1
						cCCusto := substr(SC2->C2_MSPOSIC,nPosic,3)
					Else
						cCCusto := " "
					EndIf
					//////////////////////////////////Alterado em 31/05/2012
					cNrDtCI := ""
		  			IF !EMPTY(sc2->c2_msci)
						cNrDtCI := " CI: "+ alltrim(sc2->c2_msci)+ "-Dt.CI:" + DTOC(sc2->c2_msdtci)+" "
					Else
						cNrDtCI := ""
					ENDIF
	 		        ///////////////////////////////////
	 				If MV_PAR14 = 2
					    If aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO}) == 0
					    	If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
								// adiciono conteudo no array para impressao no final do relatorio
								Aadd(aPosicSc2,{SC2->C2_PRODUTO,""," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+Alltrim(cNrDtCI), cCCusto, cDescri })	// adiciono conteudo no array para impressao no final do relatorio
							Endif
						EndIf
					Else
						If Dtos(sc2->c2_datprf) <= Dtos(MV_PAR16)
			                // Alteração Efetuada em 16-11-2011 em conversa com José Roberto
							nPos := aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO})
							If nPos > 0
								cCodOP := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
								nPos1 := aScan(aPosicSC2,{|x| x[2] == cCodOP })
								If nPos1 = 0 
									If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
										// adiciona conteudo no array para impressao no final do relatoriO
										Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+AllTrim(cNrDtCI), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
									EndIf
								EndIf				  	
							Else
								If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
									// adiciona conteudo no array para impressao no final do relatorio
									Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+AllTrim(cNrDtCI), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
								EndIf
							Endif
						EndIf
					EndIf				
					SC2->(DBSKIP())
				EndDo
				RESTAREA(AAREASC2)
				If mv_par09 > 1
			       @ Li,020 PSAY "Posicao em " + ALLTRIM(sc2->c2_msposic)
			    EndIf
				If (MV_PAR09 == 1 .And. MV_PAR17 == 1) .or. (MV_PAR09 == 3 .And. MV_PAR17 == 1)
					aAreaSB1 := SB1->(GetArea())
					SB1->(DbSetOrder(1))
					If SB1->(dbSeek(xFilial("SB1")+sd4->d4_cod))
						cDesenho := Alltrim(sd4->d4_cod) + Alltrim(sb1->b1_revatu)
					EndIf
					_cPath := "H:\PLOTTER\"
					If SubStr(cNumEmp,1,2) == "01" 
					   If Substr(cDesenho,1,2) == "CL"  .or. Substr(cDesenho,1,2) == "IM"
					      _cPath += Substr(cDesenho,3,2) + "\"
					   Else
					      _cPath += Substr(cDesenho,1,2) + "\"
					   EndIf
					ElseIf SubStr(cNumEmp,1,2) == "10"   
		                _cPath += Substr(cDesenho,1,3) + "\"
		            EndIf
		            If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) .And. (!("PINTURA INICIADA") $ ALLTRIM(SC2->C2_MSPOSIC))
						If DtoS(SC2->C2_DATRF) <= DtoS(MV_PAR16) .AND. cCcustoD $ SC2->C2_MSPOSIC .OR. Empty(cCcustoD)
							If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
								AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
								AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
								AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
							Endif
						Endif
					EndIf
					RestArea(aAreaSB1)
				EndIf									   
			Endif
			If mv_par09 > 1
				IF !EMPTY(sc2->c2_obs)
					ChecaLinha()
					@ Li,020 PSAY "Obs.: " + ALLTRIM(sc2->c2_obs)
				Endif
				
				cNrDtCI := ""
				IF !EMPTY(sc2->c2_msci)
					cNrDtCI := " CI: "+ Alltrim(sc2->c2_msci) + " - Data da CI: " + DTOC(sc2->c2_msdtci)
					ChecaLinha()
					@ Li,020 PSAY "CI: " + Alltrim(sc2->c2_msci) + " - Data da CI: " + DTOC(sc2->c2_msdtci)
				Else
					cNrDtCI := ""
				EndIf
			EndIf
			
		Else
		
			If !EMPTY(sc2->c2_msposic) .And. !('(201' $ sc2->c2_msposic)
				aAreaSC2 := SC2->(GETAREA())
				_cProd := SC2->C2_PRODUTO
				
				//*****************************************
					SB1->(DbSetOrder(1))
					If SB1->(DbSeek(xFilial("SB1") + _cProd))
						cDescri := SB1->B1_DESC
					Else
						cDescri := ""
					EndIf
				//*****************************************					

				SC2->(DbSetOrder(2))
				SC2->(DbSeek(xFilial("SC2")+_cProd))
				Do While SC2->C2_PRODUTO == _cProd .And. SC2->(!Eof())
					If SC2->(!Empty(SC2->C2_DATRF)) .Or. SC2->(EMPTY(SC2->C2_MSPOSIC))
						SC2->(DBSKIP())
						Loop
					Endif
					If "(" $ ALLTRIM(SC2->C2_MSPOSIC)
						nPosic := At("(",ALLTRIM(SC2->C2_MSPOSIC)) + 1
						cCCusto := substr(SC2->C2_MSPOSIC,nPosic,3)
					Else
						cCCusto := " "
					EndIf
					//////////////////////////////////Alterado em 31/05/2012
					cNrDtCI := ""
					IF !EMPTY(sc2->c2_msci)
						cNrDtCI := " CI: "+ alltrim(sc2->c2_msci)+ "-Dt.CI:" + DTOC(sc2->c2_msdtci)+" "
					Else
						cNrDtCI := ""
					ENDIF
					///////////////////////////////////
					If MV_PAR14 = 2
						If aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO}) == 0
							If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
								// adiciono conteudo no array para impressao no final do relatorio
								Aadd(aPosicSc2,{SC2->C2_PRODUTO,""," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+Alltrim(cNrDtCI), cCCusto, cDescri })	// adiciono conteudo no array para impressao no final do relatorio
							Endif
						EndIf
					Else
						If Dtos(sc2->c2_datprf) <= Dtos(MV_PAR16)
							// Alteração Efetuada em 16-11-2011 em conversa com José Roberto
							nPos := aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO})
							If nPos > 0
								cCodOP := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
								nPos1 := aScan(aPosicSC2,{|x| x[2] == cCodOP })
								If nPos1 = 0 
									If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
										// adiciona conteudo no array para impressao no final do relatoriO
										Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+AllTrim(cNrDtCI), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
									EndIf
								EndIf				  	
							Else
								If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
									// adiciona conteudo no array para impressao no final do relatorio
									Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,STRZERO(DAY(SC2->C2_EMISSAO),2)+"/"+STRZERO(MONTH(SC2->C2_EMISSAO),2),STRZERO(DAY(SC2->C2_DATPRF),2)+"/"+STRZERO(MONTH(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+AllTrim(cNrDtCI), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
								EndIf
							Endif
						EndIf
					EndIf				
					SC2->(DBSKIP())
				EndDo

				RESTAREA(AAREASC2)
				If mv_par09 > 1
			       @ Li,020 PSAY "Posicao em " + ALLTRIM(sc2->c2_msposic)
				EndIf
				If (MV_PAR09 == 1 .And. MV_PAR17 == 1) .or. (MV_PAR09 == 3 .And. MV_PAR17 == 1)
					aAreaSB1 := SB1->(GetArea())
					SB1->(DbSetOrder(1))
					If SB1->(dbSeek(xFilial("SB1")+sd4->d4_cod))
						cDesenho := Alltrim(sd4->d4_cod) + Alltrim(sb1->b1_revatu)
					EndIf
					_cPath := "H:\PLOTTER\"
					If SubStr(cNumEmp,1,2) == "01" 
					   If Substr(cDesenho,1,2) == "CL"  .or. Substr(cDesenho,1,2) == "IM"
					      _cPath += Substr(cDesenho,3,2) + "\"
					   Else
					      _cPath += Substr(cDesenho,1,2) + "\"
					   EndIf
					ElseIf SubStr(cNumEmp,1,2) == "10"   
							_cPath += Substr(cDesenho,1,3) + "\"
					EndIf
		         If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) .And. (!("PINTURA INICIADA") $ ALLTRIM(SC2->C2_MSPOSIC))
						If DtoS(SC2->C2_DATRF) <= DtoS(MV_PAR16) .AND. cCcustoD $ SC2->C2_MSPOSIC .OR. Empty(cCcustoD)
							If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
								AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
								AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
								AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
							Endif
						Endif
					EndIf
					RestArea(aAreaSB1)
				EndIf									   
			Endif
			If mv_par09 > 1
				IF !EMPTY(sc2->c2_obs)
					ChecaLinha()
					@ Li,020 PSAY "Obs.: " + ALLTRIM(sc2->c2_obs)
				Endif
				
				cNrDtCI := ""
				IF !EMPTY(sc2->c2_msci)
					cNrDtCI := " CI: "+ Alltrim(sc2->c2_msci) + " - Data da CI: " + DTOC(sc2->c2_msdtci)
					ChecaLinha()
					@ Li,020 PSAY "CI: " + Alltrim(sc2->c2_msci) + " - Data da CI: " + DTOC(sc2->c2_msdtci)
				Else
					cNrDtCI := ""
				EndIf
			EndIf
		EndIf 
			
		//	avaliar se existe falta de componentes para as ops.
		AAREASD4 := SD4->(GETAREA())
		AAREASC2 := SC2->(GETAREA())
		cNumopSc2 := ALLTRIM(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
		
		dbSelectArea("SD4")
		SD4->(dbSetOrder(2))
		SD4->(dbGoTop())

		If SD4->(DBSEEK(XFILIAL("SD4") + cNumopSc2)) .AND. MV_PAR05 == 1 .AND. "FALTA COMPONENTE" $ SC2->C2_MSPOSIC	 //Somente se na op - campo SC2->C2_MSPOSIC contem a observacao "Falta componente"
			Do While ALLTRIM(SD4->D4_OP) == cNumopSc2 .AND. !SD4->(EOF())
				SB1->(dbSeek(xFilial("SB1") + SD4->D4_COD))
				// ALTERAÇÃO FEITA EM 24/06/14 A PEDIDO DO PCP FABRIMA
				IF MV_PAR18 == 2 .AND. SUBSTR(SB1->B1_PROCED,1,1) <> '1'
					SD4->(dbSkip())
					LOOP
				ELSEIF MV_PAR18 == 3 .AND. SUBSTR(SB1->B1_PROCED,1,1) == '1'
					SD4->(dbSkip())
					LOOP
				ENDIF	
				// FIM DA ALTERAÇÃO
				If SD4->D4_QUANT > 0		// Saldo de Empenho > 0
					SC2->(DBGOTOP())
					SC2->(dbSetOrder(2))
					If SC2->(DBSEEK(XFILIAL("SC2") + SD4->D4_COD))
						Do While SC2->C2_PRODUTO == SD4->D4_COD .AND. !SC2->(EOF())
							If SC2->C2_PRODUTO == SD4->D4_COD .AND. !Empty(SC2->C2_MSPOSIC) .AND. Empty(SC2->C2_DATRF)
							   SB1->(DBSEEK(xFilial("SB1") + SC2->C2_PRODUTO)) 
							   If mv_par09 > 1
							   	  ChecaLinha()
								  @Li,023 PSAY "Componente: " + SC2->C2_PRODUTO
								  @Li,PCOL()+1 PSAY SubStr(SB1->B1_DESC,1,30)
								  @Li,PCOL()+1 PSAY "Qtd: " + STR(SC2->C2_QUANT,4,0)
								  @Li,PCOL()+1 PSAY "Data Inicio: " + DTOC(SC2->C2_DATPRI)
								  ChecaLinha()
								EndIf  
								bAreaSC2 := SC2->(GETAREA())
								_cProd := SC2->C2_PRODUTO
								
								//*****************************************************
									SB1->(DbSetOrder(1))				
									If SB1->(dbSeek(xFilial("SB1") + _cProd ))
										cDescri := SB1->B1_DESC
									Else
										cDescri := ""
									EndIf
								//*****************************************************					
								
								SC2->(DbSetOrder(2))
								SC2->(DbSeek(xFilial("SC2")+_cProd))
								Do While SC2->C2_PRODUTO == _cProd .And. SC2->(!Eof())
									If SC2->(!Empty(SC2->C2_DATRF)) .Or. SC2->(EMPTY(SC2->C2_MSPOSIC))
										SC2->(DBSKIP())
										Loop
									Endif
									////////////////////// Alterado em 31/05/2012
									cNrDtCI := ""
									If !EMPTY(sc2->c2_msci)
										cNrDtCI := " CI: "+ Alltrim(sc2->c2_msci) + " - Data da CI: " + DTOC(sc2->c2_msdtci)
									Else
										cNrDtCI := ""
									EndIf
									/////////////////////////						
									If "(" $ ALLTRIM(SC2->C2_MSPOSIC)
										nPosic := At("(",ALLTRIM(SC2->C2_MSPOSIC)) + 1
										cCCusto := substr(SC2->C2_MSPOSIC,nPosic,3)
									Else
										cCCusto := " "
									EndIf
									If MV_PAR14 = 2 
									    If aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO}) == 0
								    		If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
												// adiciono conteudo no array para impressao no final do relatorio
											   Aadd(aPosicSc2,{SC2->C2_PRODUTO,""," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,strzero(day(SC2->C2_EMISSAO),2)+"/"+strzero(month(SC2->C2_EMISSAO),2),strzero(day(SC2->C2_DATPRF),2)+"/"+strzero(month(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+AllTrim(cNrDtCI), cCCusto, cDescri })	// adiciono conteudo no array para impressao no final do relatorio
											Endif
									    EndIf
									Else
										If Dtos(sc2->c2_datprf) <= Dtos(MV_PAR16)
						                // Alteração Efetuada em 16-11-2011 em conversa com José Roberto
											nPos := aScan(aPosicSC2,{|x| x[1] == SC2->C2_PRODUTO})
											If nPos > 0
												cCodOP := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
												nPos1 := aScan(aPosicSC2,{|x| x[2] == cCodOP })
												If nPos1 = 0
													If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
														// adiciona conteudo no array para impressao no final do relatorio
														Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,strzero(day(SC2->C2_EMISSAO),2)+"/"+strzero(month(SC2->C2_EMISSAO),2),strzero(day(SC2->C2_DATPRF),2)+"/"+strzero(month(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+AllTrim(cNrDtCI), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
													EndIf				  	
												EndIf
											Else
												If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) 
													// adiciona conteudo no array para impressao no final do relatorio
													Aadd(aPosicSc2,{SC2->C2_PRODUTO,(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)," - OP: " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,strzero(day(SC2->C2_EMISSAO),2)+"/"+strzero(month(SC2->C2_EMISSAO),2),strzero(day(SC2->C2_DATPRF),2)+"/"+strzero(month(SC2->C2_DATPRF),2),ALLTRIM(SC2->C2_MSPOSIC)+AllTrim(cNrDtCI), cCCusto, cDescri })	// adiciona conteudo no array para impressao no final do relatorio
												EndIf
											Endif
										EndIf
										//////////////////////////////////
									EndIf
									SC2->(DBSKIP())
								EndDo
								RESTAREA(bAREASC2)
								If mv_par09 > 1
								   @Li,026 PSAY "OP: " + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
								   @Li,PCOL()+1 PSAY "Posicao em " + SC2->C2_MSPOSIC
								EndIf
								If (MV_PAR09 == 1 .And. MV_PAR17 == 1) .OR. (MV_PAR09 == 3 .And. MV_PAR17 == 1)
									cComponente := Alltrim(SC2->C2_PRODUTO) + Alltrim(SB1->B1_REVATU)
									_cPath := "H:\PLOTTER\"
									If SubStr(cNumEmp,1,2) == "01" 
									   If Substr(cComponente,1,2) == "CL" .or. Substr(cComponente,1,2) == "IM"
									      _cPath += Substr(cComponente,3,2) + "\"
									   Else
									      _cPath += Substr(cComponente,1,2) + "\"
									   EndIf
									ElseIf SubStr(cNumEmp,1,2) == "10"   
	                                   _cPath += Substr(cComponente,1,3) + "\"
	                                EndIf
	                                If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC)) .And. (!("PINTURA INICIADA") $ ALLTRIM(SC2->C2_MSPOSIC))
										If DtoS(SC2->C2_DATRF) <= DtoS(MV_PAR16) .AND. cCcustoD $ SC2->C2_MSPOSIC .OR. Empty(cCcustoD) 
											If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cComponente) + ".PLT") == 0
												AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cComponente) + ".PLT")
												AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cComponente) + ".PRI")
												AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cComponente) + ".PRN")
											EndIf
										Endif
									EndIf
								EndIf
								SC2->(DBSKIP())
								Loop
							Endif
							SC2->(DBSKIP())
						EndDo
					Endif
				Endif
				SD4->(DBSKIP())
			Enddo
		Endif
		ChecaLinha()
		RESTAREA(AAREASD4)
		RESTAREA(AAREASC2)
	Endif
	SC2->(DBSKIP())
Enddo
// Fim da impressão dos componentes da ops

// *** Imprime os Pedidos de Compras ***
If mv_par09 > 1
	dbSelectArea("SC7")
	SC7->(dbSetOrder(2))
	SC7->(DBSEEK(XFILIAL("SC7") + cProd))
	Do WHILE SC7->C7_PRODUTO == cProd .AND. !SC7->(EOF())
		IF SC7->C7_QUJE < SC7->C7_QUANT .AND. EMPTY(SC7->C7_RESIDUO)

			//******************************************
				SB1->(dbSetOrder(1))
				If SB1->(DBSEEK(XFILIAL("SB1") + cProd))
					cDescri := SB1->B1_DESC
				Else
				   cDescri := ""
				EndIf
			//******************************************			
			
			SA2->(DBSEEK(xFilial("SA2") + SC7->C7_FORNECE))
		   	IF ("*** PV" $ SC7->C7_OBS)
				SC7->(DBSKIP())
		 		Loop
		  	EndIF	
			@ Li,016      PSAY "PC: "+  SC7->C7_NUM + "/" + SUBSTR(SC7->C7_ITEM,3)
			@ Li,PCOL()+2 PSAY substr(SA2->A2_NREDUZ,1,15)
			@ Li,PCOL()+2 PSAY "Qde: "+ STR((SC7->C7_QUANT - SC7->C7_QUJE),4,0)
			@ Li,PCOL()+2 PSAY "Emissao: " + DTOC(SC7->C7_EMISSAO)
			@ Li,PCOL()+2 PSAY "Entrega: " + DTOC(SC7->C7_DATPRF)
			@ Li,PCOL()+2 PSAY substr(alltrim(SC7->C7_OBS),1,30)
			ChecaLinha()
			cNomusu := "               "
			PswOrder(1)
			If PswSeek(SC7->C7_USER,.T.)
				cNomusu  := UsrRetName(SC7->C7_USER)
			Else
				cNomusu  := 'Não Existe'
			EndIf
			@ Li,20 PSAY "Emitente: "+ cNomusu
			IF !(" NF " $ SC7->C7_OBS)
				IF !EMPTY(SC7->C7_QTDACLA)
					cPreNota := "P "
				ELSE
					cPrenota := "  "
				ENDIF
				cCCusto := "101"
				If aScan(aPosicSC2,{|x| x[1] == SC7->C7_PRODUTO}) == 0
					If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))  
						// adiciono conteudo no array para impressao no final do relatorio
						Aadd(aPosicSc2,{SC7->C7_PRODUTO,"", " - PC: " + SC7->C7_NUM+"/"+SC7->C7_ITEM,strzero(day(SC7->C7_EMISSAO),2)+"/"+strzero(month(SC7->C7_EMISSAO),2),strzero(day(SC7->C7_DATPRF),2)+"/"+strzero(month(SC7->C7_DATPRF),2),Alltrim(IF(!EMPTY(SC7->C7_MSREUNI),"R"," ") + cPreNota) +" (CC: 101) - Fornec.: " + SUBSTR(SA2->A2_NREDUZ,1,15), cCCusto, cDescri })	// adiciono conteudo no array para impressao no final do relatorio
					EndIf
				EndIf
			ENDIF
			@ Li,PCOL() PSAY "SC: "+  SC7->C7_NUMSC + "/" + substr(SC7->C7_ITEMSC,3)
			IF sc1->(DBSEEK(xFilial("SC1")+ SC7->C7_NUMSC + SC7->C7_ITEMSC))
				@ Li,PCOL()+1 PSAY "Emitente: " + ALLTRIM(SC1->C1_SOLICIT) + " - Emissao: " + DTOC(SC1->C1_EMISSAO)
				@ Li,PCOL()+1 PSAY "Aprop: "+ ALLTRIM(SUBSTR(SC1->C1_MSAPROP,1,30))
				IF SC1->C1_QUANT # SC7->C7_QUANT
					@ Li,PCOL()+1 PSAY "Qde_erro: "	+ Transform(SC1->C1_QUANT,"@E 9,999.99")
				Endif
				IF sc1->c1_datprf # SC7->C7_DATPRF
					@ Li,PCOL()+1 PSAY "Data_erro: "+ DTOC(SC1->C1_DATPRF)
				Endif
			Endif
			ChecaLinha()
		Endif
	   SC7->(DBSKIP())
	Enddo
EndIf

// *** Imprime as Solicitacoes de Compras ***
If mv_par09 > 1
   dbSelectArea("SC1")
   SC1->(dbSetOrder(2))
   SC1->(DBSEEK(XFILIAL("SC1") + cProd))
   Do WHILE SC1->C1_PRODUTO == cProd .AND. !SC1->(EOF())
	  IF SC1->C1_QUJE < SC1->C1_QUANT

 			//******************************************
				SB1->(dbSetOrder(1))
				If SB1->(DBSEEK(XFILIAL("SB1") + cProd))
					cDescri := SB1->B1_DESC
				Else
					cDescri := ""
				EndIf
			//******************************************			

			sa2->(DBSEEK(xfilial("SA2") + SC1->C1_FORNECE))
		 @ Li,016      PSAY "SC: "+ SC1->C1_NUM + "/" + SUBSTR(SC1->C1_ITEM,3)
		 @ Li,PCOL()+2 PSAY substr(SA2->A2_NREDUZ,1,15)                                                                                                      
		 @ Li,PCOL()+2 PSAY "Qtde: "+ STR((SC1->C1_QUANT - SC1->C1_QUJE),4,0)
		 @ Li,PCOL()+2 PSAY "Entrega: "
		 @ Li,PCOL()+2 PSAY SC1->C1_DATPRF        
		 //  @ Li,PCOL()+2 PSAY sc1->c1_msaprop
		 @ Li,PCOL()+2 PSAY substr(alltrim(SC1->C1_OBS),1,46)
		 ChecaLinha()
		 @ Li,020      PSAY "Emitente: " + SC1->C1_SOLICIT + " - Emissao: " + DTOC(SC1->C1_EMISSAO)
		 ChecaLinha()
         cCCusto := "101"
		 If aScan(aPosicSC2,{|x| x[1] == SC1->C1_PRODUTO}) == 0
	 		If (!("Fim do Processo") $ ALLTRIM(SC2->C2_MSPOSIC))
				// adiciono conteudo no array para impressao no final do relatorio		    
				Aadd(aPosicSc2,{SC1->C1_PRODUTO,"", " - SC: " + SC1->C1_NUM+"/"+SC1->C1_ITEM,strzero(day(SC1->C1_emissao),2)+"/"+strzero(month(SC1->C1_emissao),2),strzero(day(SC1->C1_DATPRF),2)+"/"+strzero(month(SC1->C1_DATPRF),2),"Emitente: " + Substr(Alltrim(sc1->c1_solicit),1,7) + " - Cotacao: " + SC1->C1_COTACAO + " - Obs: (CC: 101) " + Substr(Alltrim(SC1->C1_OBS),1,20), cCCusto, cDescri })	// adiciono conteudo no array para impressao no final do relatorio		    
			EndIf
		 Endif
	  Endif
	  SC1->(DBSKIP())
   Enddo
EndIf   

RESTAREA(aGravaSB1)
RESTAREA(aGravaSC2)
RESTAREA(aGravaSC6)
RESTAREA(aGravaSD4)

Return
                                      
*****************************
STATIC FUNCTION IMPAPONT()
*****************************

Local nX := 0
Local cCCMonta := '201'

If LEN(APOSICSC2) > 0

	ASORT(APOSICSC2,,,{ |X, Y| X[6] < Y[6] })	// ordena o array em ordem alfabetica conforme conteudo do SC2->C2_MSPOSIC

	If MV_PAR17 = 2					
		FOR nX := 1 TO LEN(APOSICSC2)
			If cCcustoD $ APOSICSC2[nX][6] .OR. Empty(cCcustoD)
 				cFilial := xFilial("SC2")
 				cCCusto := aPOSICSC2[nX][6]
	  			aAreaSZ0 := SZ0->(GetArea())					
				SZ0->(DbSetOrder(1))
				SZ0->(DbGoTop())
				If !("Fim do Processo") $ (aPOSICSC2[nX][6])
					If !SZ0->(dbSeek(xFilial("SZ0")+aPOSICSC2[nX][1]+cUsuario+cProgSZ0+cData))
						RECLOCK("SZ0",.T.)
						SZ0->Z0_FILIAL	:= cFilial
						SZ0->Z0_PRODUTO	:= aPOSICSC2[nX][1]
						SZ0->Z0_DOCUM	:= MV_PAR03
						SZ0->Z0_ROTINA	:= 'RPCPR006'
						SZ0->Z0_STATUS	:= 'G'
						SZ0->Z0_USUARIO	:= cUsuario
						SZ0->Z0_CCUSTO  := aPOSICSC2[nX][6]
						SZ0->Z0_DATA	:= date()
						SZ0->Z0_HORA	:= Time()
						SZ0->(MSUNLOCK())
					Else
						If !(MV_PAR03 $ SZ0->Z0_DOCUM)
							RECLOCK("SZ0",.F.)
							SZ0->Z0_DOCUM	:= AllTrim(SZ0->Z0_DOCUM)+"/"+MV_PAR03
							SZ0->(MSUNLOCK())
							If !(cCCusto $ SZ0->Z0_CCUSTO)
								RECLOCK("SZ0",.F.)
								SZ0->Z0_CCUSTO  := AllTrim(SZ0->Z0_CCUSTO)+"/"+cCcusto
								SZ0->(MSUNLOCK())
							EndIf
						EndIf						
					EndIf
				EndIf
				RestArea(aAreaSZ0)
			EndIf
		Next nX
	EndIf
EndIf

IF LEN(APOSICSC2) > 0
	
	ASORT(APOSICSC2,,,{ |X, Y| X[6] < Y[6] })	// ordena o array em ordem alfabetica conforme conteudo do SC2->C2_MSPOSIC
	
	IF LI > 68
		CABEC(TITULO,CABEC1,CABEC2,NOMEPROG,TAMANHO,18)
	ENDIF
	
	If !Empty(MV_PAR03)
		LI += 2
		@ LI,000 PSAY PADC("  Apontamentos - Pedido: " + ALLTRIM(MV_PAR03) + " - Cliente: " + ALLTRIM(SA1->A1_NREDUZ) + " - Entrega: " + cEntrega + " - Inicio Mont.: " + cMontagem + "  ",132,"*")
		LI += 2
	Else
		LI += 2
	EndIf		

	@ LI,00 PSAY "CODIGO            DOCUMENTO       EMIS. ENTR. POSICAO " 
   LI += 1
	@ LI,00 PSAY REPLICATE("=",132)
	LI += 1
	FOR nX := 1 TO LEN(APOSICSC2)
		
		IF LI > 68
			CABEC(TITULO,CABEC1,CABEC2,NOMEPROG,TAMANHO,18)
		ENDIF

		// Acrescentado If abaixo para filtrar cc do usuario. Solicitado por Jose Roberto em 09/03/12
		IF ALLTRIM(SUBSTR(_CDEPTOUSU,1,3)) $ "101_202_203_204_205_215"   	// Compras_Usinagem_Caldeiraria_Pintura_Almoxarifado_Maklaser
			IF ALLTRIM(SUBSTR(_CDEPTOUSU,1,3)) $ ALLTRIM((APOSICSC2[NX][6]))
				IF SUBSTR(cNumEmp,1,2) $ "10" // FABRIMA 
					@ LI,00 PSAY (APOSICSC2[NX][1])+(APOSICSC2[NX][3])+" "+(APOSICSC2[NX][4])+" "+(APOSICSC2[NX][5])+" "+ALLTRIM((APOSICSC2[NX][6]))
				ELSE	
					@ LI,00 PSAY ((APOSICSC2[NX][1])+" "+(APOSICSC2[NX][8]))
					LI++
					@ LI,00 PSAY ( (APOSICSC2[NX][3])+" "+(APOSICSC2[NX][4])+" "+(APOSICSC2[NX][5])+" "+ALLTRIM(APOSICSC2[NX][6]) )
					LI++
				ENDIF	
			ENDIF
		ELSE
			IF SUBSTR(cNumEmp,1,2) $ "10" // FABRIMA 
				@ LI,00 PSAY (APOSICSC2[NX][1])+(APOSICSC2[NX][3])+" "+(APOSICSC2[NX][4])+" "+(APOSICSC2[NX][5])+" "+ALLTRIM((APOSICSC2[NX][6]))
				LI ++
			ELSE	
				@ LI,00 PSAY ( (APOSICSC2[NX][1])+" "+(APOSICSC2[NX][8]) )
				LI++
				@ LI,00 PSAY ( (APOSICSC2[NX][3])+" "+(APOSICSC2[NX][4])+" "+(APOSICSC2[NX][5])+" "+ALLTRIM(APOSICSC2[NX][6]) )
				LI++
			ENDIF	
		ENDIF

   LI++
	NEXT NX
ENDIF

RETURN()                  
/*Static Function AcertaIMP() 
//////////////////////////////////////
//Eduardo Mantoan 05/11/2014///////////
//////////////////////////Substituição do arquivo .Bat////////////////////////////////////////////////////////////////////////
lOk:= .F.                                                                                                                   //
cIm := ""                                                                                                                   //
aIMP:= {}                                                                                                                   //
                                                                                                                	        //
_cEXE1  := "cmd /c NET USE LPT1: " //\\MSSRV-FSV01\LASER08                                                        		//
_cEXE2  := "cmd /c net use lpt1: /delete"                                                                            		//
_cEXE3  := "cmd /c copy c:\relato_microsiga\rpcpr001.prn prn"                                                        		//
_cEXE4  := "cmd /c del c:\relato_microsiga\rpcpr001.prn"                                                                    //
_cEXE5  := "cmd /c PRINT "                                                         		  	                                //
                                                                                                             								//
	aImps  := {}
	aImpsS := {}                                                                                                      								//
	aImps := GetImpWindows (.F.)
	aImpsS := GetImpWindows (.T.)
	
		                                                                                                                    //
	If SubStr(cNumEmp,1,2) == "01"                                                                                     								//
    	If (("PDF" $ aImps[1] ) .OR. ("XPS" $ aImps[1])) .OR. !("\\MSSRV-FSV01\" $ aImps[1])                       		    					//                                  		
    		cIm := Tela(aImps)                                                                                                 						//
    		cImps := SUBSTR(cIm,1,24)                                                                                                     			//
		Else                                                                                                           								//
			cImps := SUBSTR(aImps[1],1,24)                                                                                                          //
		EndIf                                                                                                                                       //
	ElseIf SubStr(cNumEmp,1,2) == "10"                                                                                                              //
		If (("PDF" $ aImps[1] ) .OR. ("XPS" $ aImps[1])) .OR. !("\\FMAVMW05\" $ aImps[1])                       		    						//                                  		
    		cIm := Tela(aImps)                                                                                                 						//
    		cImps := SUBSTR(cIm,1,19)                                                                                                     		    //
		Else                                                                                                           								//
			cImps := SUBSTR(aImps[1],1,19)                                                                                                          //
		EndIf                                                                                                                                       //
	Else                                                                                                                                            //
	                                                                                                                                                //
	EndIf  
	
	                                                                                                                                                //
	If SubStr(cNumEmp,1,2) == "10"                                                                                                                  //
																		                                                                            //////////////////////////////////////////////////////////////                                 
		If !(("PDF" $ SUBSTR(cImps,1,20)) .OR. ("XPS" $ SUBSTR(cImps,1,20))) .AND. ( ("\\FMAVMW05\" $ cImps) .OR. ("\\FMAVMW05\" $ cImps) .OR. ("\\MSSRV-FSV01\" $ cImps) .OR. ("\\MSSRV-FSV01\" $ cImps))//
	    	lOK := .T.
	    Else
	    	                                                                                                                                                                                        //
	 	EndIf	                                                                                                                                                                                                //
			                                                                                       													                                                            //
	ElseIf SubStr(cNumEmp,1,2) == "01"                                                                                                                                                                          //
		                                                                                                                                                                                                        //
		If !(("PDF" $ SUBSTR(cImps,1,24)) .OR. ("XPS" $ SUBSTR(cImps,1,24))) .AND. (("\\MSSRV-FSV01\" $ cImps) .OR. ("\\MSSRV-FSV01\" $ cImps) .OR. ("\\FMAVMW05\" $ cImps) .OR. ("\\FMAVMW05\" $ cImps)) //
	       	lOK := .T.
	    Else
	                                                                                                                                 //////////////////////////////////////////////////////////////
	   	EndIf                                                                                                                                       //
	    	                                                                                                                                        //
	EndIf                                                                                                                                           //
	If lOK                                                                                                                                          //
		cIMP := SUBSTR(cImps,1,24)                                                                                   								//
		//aIMP := StrToKArr( cImps, " - ")	                                                                         								//
		_cEXE1 += ALLTRIM(cIMP)                                                                                      								//
		WaitRun(_cEXE2)// Deleta mapeamento LPT1		                                                               		//////////////////////////
		WaitRun(_cEXE1)// Mapeia LPT1 com impressora padrão                                                                 //
		WaitRun(_cEXE3)// Imprime na LPT1 rpcpr001                                                                          //
		WaitRun(_cEXE4)// Exclui rpcpr001                                                                                   //
		WaitRun(_cEXE2)// Deleta mapeamento LPT1   
	Else
	   //	WaitRun("F:\BAT\ImpNec.bat")  
		WaitRun("cmd /c net use lpt1: /delete")
		WaitRun("cmd /c net use lpt1: \\MSSRV-FSV01\laser01")
	EndIf

Return    
Static Function Tela(aArray) 

Local oButton1
Local oComboBo1
Local nComboBo1 := aArray[1]
Local oSay1
Local oSay2
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Atenção, Impressora não atende os requisitos para essa impressão" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL

    @ 002, 012 SAY oSay1 PROMPT "Altere para uma impressora válida(Não pode ser gerador de PDF ou XPS e deve estar mapeada na rede)" SIZE 175, 022 OF oDlg COLORS 0, 16777215 PIXEL
    @ 040, 037 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS aArray SIZE 112, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 041, 005 SAY oSay2 PROMPT "Impressora :" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 075 BUTTON oButton1 PROMPT "OK" SIZE 070, 014 OF oDlg ACTION (oDlg:End())PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED


Return nComboBo1     

Static Function Vernome(cUserlog)
Local cNome    
Local aInfNo := {}

 
PswOrder(2)
If PswSeek(alltrim(cUserlog),.T.)
   aInfNo := PswRet()
EndIf
     
cNome := aInfNo[1][4]
Return cNome*/
