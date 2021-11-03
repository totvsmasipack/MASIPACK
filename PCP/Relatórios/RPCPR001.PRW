#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPR001³ Autor ³ Jose Roberto Funari    ³Data  ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emite Relacao de Necessidades  (MATP0956)                  ³±±
±±³          | 11/05/10 - Versao utilizando comandos SQL - Em Teste   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
// Alterado 26/03/2012 - por Ana Paula QF - Acrescentado campo de monitoramento C7_MSREUNI
// Alterado 26/07/2012 - por Ana Paula QF - Quando a Escolha dos Produtos for Comprados ele vai filtrar 2P ou 3P na Query
// Alterado 15/01/2013 - por Lizandra Marques - Inclusão da tabela SZP - DEVOLUÇÃO AO ALMOXARIFADO
// Alterado 29/07/2013 - por Ana Paula QF - Acrescentada a empresa 40 - Labortube
// Alteração da máscara para Labortube - 16/08/13 - Lizandra	
// Troca do B1_MSQUANT POR B2_QATU - 28/08/13 - Lizandra
// Acrescentado os campos C1_MSDTCHK e C1_MSQTCHK para controle das solicitações
// Alterado 11/11/2013 - por Lizandra Marques - Inclusão da tabela SCP - REQUISIÇAO AO ALMOXARIFADO
*/


/*
Relação dos parametros:

mv_par01: 1=Vídeo / 2=Impressora
mv_par02: Duas folhas em 1? -> 1=Sim / 2=Nao    ** Melhor assumir 2 pois algumas impressoras não tem esse recurso!
mv_par03: Imprime 1 código por página? -> 1=Sim / 2=Nao
mv_par04: Imprime Desenhos? 1=Sim / 2=Nao
mv_par05: Quantos Desenhos?
mv_par06: Drive para desenhos -> H / P / T
mv_par07: Tipo de Produtos -> 1=Peças / 2=Conjuntos / 3=Ambos
mv_par08: Quais Produtos? -> 1=Todos os produtos
                             2=Estrutura
                             3=Importar dados
                             4=Referencia
                             5=OP
                             6=Pedido
                             7=Orcamento
mv_par09: Qual Necessidades? 1=Empenho > Estoque
                             2=Geral
                             3=Saldo 0
                             4=Empenho <> 0
                             5=Estoque Minimo
                             6=Saldo > Empenho
                             7=Empenho > Estoque + OP + SC + PC
                             8=Empenho < Estoque + OP + SC + PC
                             9=Empenho > Estoque
mv_par10: Código/Arquivo/Referencia/OP/Pedido De
mv_par11: Código Até
mv_par12: Data da Estrutura
mv_par13: Com suas estruturas 1=Sim / 2=Nao
mv_par14: Procedencia 1=Fabricados / 2=Comprados / 3=Geral
mv_par15: Local
mv_par16: Grupo
mv_par17: Centro de Custo
mv_par18: Data de (empenhos)
mv_par19: Data ate (empenhos) 
mv_par20: Cliente
mv_par21: Imprime MP,TS e MOD?
mv_par22: Imprime Fornecedores? 1=Sim / 2=Nao
mv_par23: Fornecedor
mv_par24: Imprime Operacoes 1=Sim / 2=Nao
mv_par25: Gera Planilha 1=Sim / 2=Nao
mv_par26: Posicao Lista 1=Sim / 2=Nao
mv_par27: Quais Materiais? 1=Produtivos / 2=Improdutivos / 3=Ambos
mv_par28: Considera estoque de seguranca? 1=Sim / 2=Nao
mv_par29: Categoria Desenho    

*/


//****************************
	User Function RPCPR001()
//****************************

Local nQtdN			:= 0
Private _cUsuario   := RetCodUsr()
Private _cNomeUsu   := UsrRetName(_cUsuario)
Private _aUsuario   := {}
Private _cDeptoUsu  := ""
Private titulo      := "N e c e s s i d a d e s"
Private cString     := "SB1"
Private wnrel       := ""
Private nomeprog    := "RPCPR001"
Private Cabec1      := ""
Private cPerg	     := "PCPR01"
Private cNomeArq    := ""
Private cArqTrab    := ""
Private cFilTrab    := ""
Private cArqTrab2   := ""
Private cFilTrab2   := ""
Private nLastKey    := 0
Private Li          := 0
Private nQtdLin     := 50
Private cAux        := ""
Private cDrive      := ""
Private cPasta      := ""
Private aDesenhos   := {}
Private cDesenho    := ""
Private I           := 0
Private cAmbien     := ""
Private cFornec     := ""
Private cLoja       := ""
Private nTotReg     := 0
Private cCliente    := ""
Private cArqDBF     := ""
Private nRegTotal   := 0
Private nEmpenho    := 0
Private nEmpResumo  := 0
Private nFalta      := 0
Private nSaldoPrev  := 0
Private nSaldo      := 0
Private dDataSG1    := CTOD("01/01/1900")
Private dDtEntrega  := CTOD(Space(8))
Private dDtMov      := CTOD(Space(8))
Private _lRet       := .T.
Private _lParam     := .F.
Private _lFirst     := .T.
Private _lOutro     := .T.
Private nEstru      := 0   // variavel utilizada na explosao da estrutura
Private cProduto    := ""  // sera utilizado na explosao da estrutura
Private cArqTxt     := "c:\relato_microsiga\RPCPR001.prn"
Private cRegTxt     := ""
Private cRegCab     := ""
Private nBrancos    := 0
Private _nPag       := 0
Private cTpCabec    := ""
Private cLocais     := ""
Private nPos        := 0
Private cMovim      := ""
Private cDesc       := ""
Private cBloq       := ""
Private cHora       := Time()
Private _lGera      := .F.
Private nCustoD     := 0
Private _nQLoc01	:= 0
Private _nQLoc10	:= 0

// Variaveis utilizadas para geracao do Resumo em planilha Excel
Private cArqCSV     := ""
Private cRegCSV     := ""
Private dDataNec    := CTOD(Space(8))
Private dDataRem    := CTOD(Space(8))
Private cLF         := ""
Private cLF_SD4     := ""
Private nSaldoOP    := 0
Private nSaldoOPP   := 0
Private nSaldoSC    := 0
Private nSaldoDV    := 0  // TOTALIZA QUANTIDADE DE PEÇAS A SEREM DEVOLVIDAS AO ALMOXARIFADO.
Private nSaldoPC    := 0
Private nTenho      := 0
Private nPreciso    := 0
Private _cUsers     := SUPERGETMV("MS_0000001",," ")

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

SX5->(DbGotop())
If SX5->(DbSeek(xFilial("SX5")+"ZDLOCAIS"))
	cLocais := " " + Alltrim(SX5->X5_DESCRI)
EndIf

Do While _lOutro == .T.       // Permite executar o relatorio de necessidades diversas vezes
	
	_lGera := .F.              // Utilizado para geração da tabela SZU -> Geracao automatica das OPs
	
	Do While _lParam == .F.    // Para verificar consistencia dos parametros
		
		If !(Pergunte(cPerg,.T.))
			Return
		EndIf
		
		If SubStr(cNumEmp,1,2) $ "01_10" .And. ("INFORMATICA"$ _cDeptoUsu .Or. "PCP"$ _cDeptoUsu) .And. mv_par08$ "1_2_3" .And. mv_par09 == "7"
			If MsgBox("*** ATENÇÃO, Deseja gerar Arquivo p/ geraçao Automatica das OPs? ***","AVISO","YESNO")
				SZU->(DbSetOrder(1))
				_lGera := .T.
			EndIf
		EndIf
		
		If mv_par04 == 1
			If mv_par05 == 0 .Or. mv_par05 > 2
				mv_par05 := 1
			EndIf
			If Empty(mv_par06)
				mv_par06 := "H"
			EndIf
		EndIf
		
		cDrive := MV_PAR06
		
		If Empty(mv_par12)
			mv_par12 := dDataSG1
		Else
			dDataSG1 := mv_par12
		EndIf
		
		cProduto := UPPER(Substr(mv_par10,1,15)) // ATENCAO, a rotina de explosao utiliza o codigo com exatamente 15 caracteres
		
		mv_par02 := 2
		mv_par10 := UPPER(Alltrim(mv_par10))
		mv_par11 := UPPER(Alltrim(mv_par11))
		mv_par16 := Alltrim(mv_par16)
		mv_par17 := Alltrim(mv_par17)
		mv_par20 := Alltrim(mv_par20)
		mv_par23 := Alltrim(mv_par23)
		
		If !Empty(mv_par16) .And. Substr(mv_par16,1,2) <> "ZZ"
			SBM->(DbSetOrder(1))
			If !SBM->(DbSeek(xFilial("SBM")+mv_par16))
				ApMsgStop("Grupo nao cadastrado")
				_lRet := .F.
			EndIf
		EndIf
		
		If !Empty(mv_par17) .And. Substr(mv_par17,1,2) <> "ZZ"
			CTT->(DbSetOrder(1))
			If !CTT->(DbSeek(xFilial("CTT")+mv_par17))
				ApMsgStop("Centro de Custo nao cadastrado")
				_lRet := .F.
			EndIf
		EndIf
		
		If Empty(Alltrim(mv_par15))
			mv_par15 := cLocais
		Else
			mv_par15 := Rtrim(mv_par15)
			If mv_par15 == "."
				mv_par15 := ""
			EndIf
		EndIf
		
		If !Empty(mv_par23)
			SA2->(DbSetOrder(1))
			If SA2->(DbSeek(xFilial("SA2")+mv_par23))
				cFornec := SA2->A2_COD+" - "+SA2->A2_NOME
				cLoja   := SA2->A2_LOJA
			Else
				cFornec := mv_par23 + " - Fornecedor nao cadastrado"
			EndIf
		EndIf
		
		If mv_par08 == "1"
			If Empty(mv_par10) .And. Empty(mv_par11)
				ApMsgStop("Informe o Intervalo de codigos")
				_lRet := .F.
			Else
				If Empty(mv_par11)
					mv_par11 := ALLTRIM(mv_par10) + "ZZZZ"
				EndIf
				If mv_par11 < mv_par10
					ApMsgStop("Intervalo de codigos invalido - Verifique")
					_lRet := .F.
				EndIf
			EndIf
		Else
			If Empty(mv_par10)
				If mv_par08 == "2"
					ApMsgStop("Informe a Estrutura")
				ElseIf mv_par08 $ "3_8"
					ApMsgStop("Informe o Nome do arquivo")
				ElseIf mv_par08 == "4"
					ApMsgStop("Informe a Referência")
				ElseIf mv_par08 == "5"
					ApMsgStop("Informe a OP")
				ElseIf mv_par08 == "6"
					ApMsgStop("Informe o(s) Pedido(s)")
				ElseIf mv_par08 == "7"
					ApMsgStop("Informe o(s) Orçamento(s)")
				EndIf
				_lRet := .F.
			EndIf
		EndIf
		
		If Empty(mv_par18)
			mv_par18 := Date() - 180
		EndIf
		
		If Empty(mv_par19)
			mv_par19 := Date() + 90
		EndIf
		
		If mv_par19 < mv_par18
			ApMsgStop("Incoerencia nas datas - Data Final não pode ser menor que Data Inicial")
			_lRet := .F.
		EndIf
		
		If _lRet
			_lParam := .T.
		Else
			If ! apmsgYesNo("*** Deseja corrigir os parametros ? ***")
				Return
			EndIf
			_lRet  := .T.
		EndIf
		
		If mv_par08 $ "6_7" .And. !Empty(Alltrim(mv_par11))  // Caso utilize os dois parametros para informar os pedidos ou orcamentos
			mv_par10 += "_" + mv_par11
		EndIf
	EndDo
	
	cHora := Time()
	
	If mv_par01 == 2
		If mv_par02 == 1
			nQtdLin := 50
		Else
			nQtdLin := 62
		EndIf
	Else
		nQtdLin := 50
	EndIf
	//Ivandro Santos - 09/01/2017 - Início da alteração
	//Ticket#2016111637000146 — Impressões múltiplas Necessidades	
	If MV_PAR08 == "8"
		Private _aPrd := {}
		If !File("C:\RELATO_MICROSIGA\"+MV_PAR10+".csv")
			cArq := MV_PAR10
			MsgStop("O arquivo " +cArq + " não foi encontrado."," - ATENCAO")
			Return
		EndIf
		FT_FUSE("C:\RELATO_MICROSIGA\"+MV_PAR10+".csv")
		//ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		_nReg := 0
		While !FT_FEOF()
			cLinha := FT_FREADLN()
			If cLinha == "        " .OR. cLinha = NIL
				ALERT("Fim de arquivo!")
				FT_FUSE()
				Return
			EndIf
			
			AADD(_aPrd,cLinha)
			FT_FSKIP()
		EndDo
		FT_FUSE()	
		For nQtdN := 1 to len(_aPrd)
			Private _cCodPod := _aPrd[nQtdN]
			MsgRun("Aguarde, Gerando Necessidades !!!!",, {|| GeraTrab()}) //Gera tabela trabalho com os codigos para gerar Necessidades
			If !_lRet
				ApMsgStop("Processamento será cancelado - Verifique as informações")
				Ferase(cArqTrab+GetDBExtension())
				Ferase(cArqTrab+OrdBagExt())
				Ferase(cFilTrab+OrdBagExt())
				
				If Select("TRB") > 0
					dbSelectArea("TRB")
					dbCloseArea()
				EndIf
				
				FClose(cArqTxt)
				FClose(cArqCSV)
				Return
			EndIf
			
			If nLastKey==27
				Set Filter to
				Return
			EndIf
			
			If mv_par25 == 1
				
				If SubStr(cNumEmp,1,2) == "01"
					If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_Masipack.csv")) == -1
						apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
						//mv_par25 := 2
					Endif
				ElseIf SubStr(cNumEmp,1,2) == "10"
					If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_Fabrima.csv")) == -1
						apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
						//mv_par25 := 2
					Endif
				ElseIf SubStr(cNumEmp,1,2) == "40"
					If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_Labortube.csv")) == -1
						apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
						//mv_par25 := 2
					Endif
				ElseIf SubStr(cNumEmp,1,2) == "45"
					If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_MEMB.csv")) == -1
						apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
						//mv_par25 := 2
					EndIf
				ElseIf SubStr(cNumEmp,1,2) == "15"
					If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_HelSimplast.csv")) == -1
						apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
						//mv_par25 := 2
					EndIf
				EndIf
				
			EndIf
			
			RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},titulo)
			If nQtdN == len(_aPrd)
			    lOutro := .F.
			Else
				lOutro := .T.
			Endif
		Next
	Else
		MsgRun("Aguarde, Gerando Necessidades !!!!",, {|| GeraTrab()}) //Gera tabela trabalho com os codigos para gerar Necessidades
		If !_lRet
			ApMsgStop("Processamento será cancelado - Verifique as informações")
			Ferase(cArqTrab+GetDBExtension())
			Ferase(cArqTrab+OrdBagExt())
			Ferase(cFilTrab+OrdBagExt())
			
			If Select("TRB") > 0
				dbSelectArea("TRB")
				dbCloseArea()
			EndIf
			
			FClose(cArqTxt)
			FClose(cArqCSV)
			Return
		EndIf
		
		If nLastKey==27
			Set Filter to
			Return
		EndIf
		
		If mv_par25 == 1
			
			If SubStr(cNumEmp,1,2) == "01"
				If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_Masipack.csv")) == -1
					apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
					//mv_par25 := 2
				Endif
			ElseIf SubStr(cNumEmp,1,2) == "10"
				If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_Fabrima.csv")) == -1
					apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
					//mv_par25 := 2
				Endif
			ElseIf SubStr(cNumEmp,1,2) == "40"
				If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_Labortube.csv")) == -1
					apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
					//mv_par25 := 2
				Endif
			ElseIf SubStr(cNumEmp,1,2) == "45"
				If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_MEMB.csv")) == -1
					apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
					//mv_par25 := 2
				EndIf
			ElseIf SubStr(cNumEmp,1,2) == "15"
				If (cArqCsv := FCreate("C:\Relato_Microsiga\Resumo_HelSimplast.csv")) == -1
					apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
					//mv_par25 := 2
				EndIf
			EndIf
			
		EndIf
		
		RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},titulo)
		
	Endif
	//Ticket#2016111637000146 — Fim da alteração
	
	Ferase(cArqTrab+GetDBExtension())
	Ferase(cArqTrab+OrdBagExt())
	Ferase(cFilTrab+OrdBagExt())
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	
	Ferase(cArqTrab2+GetDBExtension())
	Ferase(cArqTrab2+OrdBagExt())
	Ferase(cFilTrab2+OrdBagExt())
	
	If Select("EXT") > 0
		dbSelectArea("EXT")
		dbCloseArea()
	EndIf
	
	dbCommitAll()
	
	MS_FLUSH()
EndDo

Return

//******************************
	Static Function GeraTrab()     // Gera trabalho com os produtos
//******************************

Local aCampos := {}
Local _cOPFin := ""

AADD(aCampos,{ "CODIG"  ,"C",15,0 } )
AADD(aCampos,{ "NECES"  ,"N",14,3 } )
AADD(aCampos,{ "UREV"   ,"D",8,0 } )

// Cria arquivo de Trabalho  - Produtos

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf

If !(mv_par08 $ "1_8")
	cArqTrab := CriaTrab(aCampos,.T.)
	dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)
	IndRegua("TRB",cArqTrab,"CODIG",,,,)
EndIf

If mv_par08 == "1"
	
	_cQuery := "SELECT B1_COD AS CODIG, B1_GRUPO, B1_CC, B1_PROCED "
	_cQuery += "FROM " + RetSqlName("SB1") + " B1 "
	_cQuery += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND B1_COD Between '" + mv_par10 +"' AND '" + mv_par11 + "'"
	If !Empty(mv_par16)
		_cQuery += " AND B1_GRUPO = '" + mv_par16 + "'"
	EndIf
	If !Empty(mv_par17)
		_cQuery += " AND B1_CC = '" + mv_par17 + "'"
	EndIf
	If mv_par14 = 1
		_cQuery += " AND SubString(B1_PROCED,1,1) = '" + Str(mv_par14,1) + "'"
	ElseIf mv_par14 = 2
		_cQuery += " AND SubString(B1_PROCED,1,1) in ('3','2') "	
	EndIf
	If mv_par27 == 1
		_cQuery += " AND SubString(B1_PROCED,2,1) = 'P'"
	ElseIf mv_par27 == 2
		_cQuery += " AND SubString(B1_PROCED,2,1) = 'N'"
	EndIf
	_cQuery += "  AND D_E_L_E_T_ = ' ' "
	_cQuery += "ORDER BY B1_COD "
	
	TcQuery _cQuery New Alias "TRB"

ElseIf mv_par08 == "2"
	SG1->(dbSetOrder(1))
	If !SG1->(DbSeek(xFilial("SG1")+cProduto))
		_lRet := .F.
		ApMsgStop("Estrutura nao cadastrada - " + cProduto)
	EndIf
	If _lRet
		SG1->(DbGotop())
		_fExplode()
		If Substr(cProduto,1,2) <> "P1"
			RecLock("TRB",.T.)
			
			TRB->CODIG := cProduto
			TRB->(MsUnlock())
		EndIf
	EndIf
ElseIf mv_par08 == "3"
	cArqDBF := "\system\"+mv_par10+".dtc"
	If File(cArqDBF)
		DbSelectArea("TRB")
		MSAppend(,cArqDBF)
		IndRegua("TRB",cArqTrab,"CODIG",,,,)
	Else
		_lRet := .F.
		ApMsgStop("Arquivo para importação nao encontrado - " + cArqDBF)
	EndIf
ElseIf mv_par08 == "4" .And. cEmpAnt $ "01|10"
	SD4->(DbSetOrder(11))
	If SD4->(DbSeek(xFilial("SD4")+mv_par10))
		Do While ! SD4->(Eof()) .And. Alltrim(SD4->D4_MSREFER) == mv_par10
			_cOPFin := DTOS(GetAdvFVal("SC2","C2_DATRF",xFilial("SD4")+SD4->D4_OP,1," "))
			If SD4->D4_QUANT > 0 .And. Empty(_cOPFin) 
				If !TRB->(DbSeek(SD4->D4_COD))
					RecLock("TRB",.T.)
					TRB->CODIG :=  Alltrim(SD4->D4_COD)
					TRB->(MsUnlock())
				EndIf
			EndIf
			SD4->(DbSkip())
			Loop
		EndDo
	Else
		_lRet := .F.
		ApMsgStop("Referencia nao encontrada - " + mv_par10)
	EndIf
ElseIf mv_par08 == "5"
	SD4->(DbSetOrder(2))
	If SD4->(DbSeek(xFilial("SD4")+mv_par10))
		Do While ! SD4->(Eof()) .And. Alltrim(SD4->D4_OP) == mv_par10
			_cOPFin := DTOS(GetAdvFVal("SC2","C2_DATRF",xFilial("SD4")+SD4->D4_OP,1," "))
			If !Empty(SD4->D4_QUANT) .And. Empty(_cOPFin)
				If !TRB->(DbSeek(SD4->D4_COD))
					RecLock("TRB",.T.)
					TRB->CODIG :=  Alltrim(SD4->D4_COD)
					TRB->(MsUnlock())
				EndIf
			EndIf
			SD4->(DbSkip())
			Loop
		EndDo
	Else
		_lRet := .F.
		ApMsgStop("Ordem de Produção nao encontrada - " + mv_par10)
	EndIf
ElseIf mv_par08 == "6" .And. cEmpAnt $ "01|10"
	SD4->(DbSetOrder(2))
	SC2->(DbSetOrder(1))
	SC2->(DbGoTop())
	Do While ! SC2->(Eof())
		If Alltrim(SC2->C2_MSPED) $ mv_par10
			If SD4->(DbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))
				Do While ! SD4->(Eof()) .And. Alltrim(SD4->D4_OP) == (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					If !TRB->(Dbseek(SD4->D4_COD))
						RecLock("TRB",.T.)
						TRB->CODIG :=  Alltrim(SD4->D4_COD)
						TRB->(MsUnlock())
					EndIf
					SD4->(DbSkip())
					Loop
				EndDo
			EndIf
		EndIf
		SC2->(DbSkip())
	EndDo
	nPos := 1
	cAux  := SubStr(mv_par10,nPos,6)
	SC6->(DbSetOrder(1))
	Do While cAux <> ""
		SC6->(DbGoTop())
		If SC6->(DbSeek(xFilial("SC6")+cAux))
			Do While ! SC6->(Eof()) .And. SC6->C6_NUM == cAux
				IF SC6->C6_BLQ <> 'R' // NÃO CONSIDERA RESÍDUO - LIZANDRA - 09/04/15
					If !TRB->(Dbseek(SC6->C6_PRODUTO))
						RecLock("TRB",.T.)
						TRB->CODIG :=  Alltrim(SC6->C6_PRODUTO)
						TRB->(MsUnlock())
					EndIf
				ENDIF
				
				SC6->(DbSkip())
				Loop
			EndDo
		EndIf
		nPos+=7
		cAux := SubStr(mv_par10,nPos,6)
	EndDo
ElseIf mv_par08 == "7"
	nPos := 1
	cAux  := SubStr(mv_par10,nPos,6)
	SCK->(DbSetOrder(1))
	Do While cAux <> ""
		SCK->(DbGoTop())
		If SCK->(DbSeek(xFilial("SCK")+cAux))
			Do While ! SCK->(Eof()) .And. SCK->CK_NUM == cAux
				If !TRB->(Dbseek(SCK->CK_PRODUTO))
					RecLock("TRB",.T.)
					TRB->CODIG :=  Alltrim(SCK->CK_PRODUTO)
					TRB->(MsUnlock())
				EndIf
				SCK->(DbSkip())
			EndDo
		EndIf
		nPos+=7
		cAux := SubStr(mv_par10,nPos,6)
	EndDo
Elseif MV_PAR08 == "8"
	//Ivandro Santos - 06/01/2017
	//Ticket#2016111637000146 — Impressões múltiplas Necessidades
	_cQuery := "SELECT B1_COD AS CODIG, B1_GRUPO, B1_CC, B1_PROCED "
	_cQuery += "FROM " + RetSqlName("SB1") + " B1 "
	_cQuery += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND B1_COD = '"+_cCodPod+"' "
	If !Empty(mv_par16)
		_cQuery += " AND B1_GRUPO = '" + mv_par16 + "'"
	EndIf
	If !Empty(mv_par17)
		_cQuery += " AND B1_CC = '" + mv_par17 + "'"
	EndIf
	If mv_par14 = 1
		_cQuery += " AND SubString(B1_PROCED,1,1) = '" + Str(mv_par14,1) + "'"
	ElseIf mv_par14 = 2
		_cQuery += " AND SubString(B1_PROCED,1,1) in ('3','2') "
	EndIf
	If mv_par27 == 1
		_cQuery += " AND SubString(B1_PROCED,2,1) = 'P'"
	ElseIf mv_par27 == 2
		_cQuery += " AND SubString(B1_PROCED,2,1) = 'N'"
	EndIf
	_cQuery += "  AND D_E_L_E_T_ = ' ' "
	
	TcQuery _cQuery New Alias "TRB"
	//Ticket#2016111637000146 - Fim da alteração
EndIf

dbCommitAll()
TRB->(DbGotop())
nTotReg := TRB->(LastRec())

Return

// Funcao ImpRel - Impressao do Relatorio

//**********************************************
	Static Function ImpRel(lEnd,WnRel,cString)
//**********************************************

Local nFornecedor	:= 0
Local nD	  := 0
Local I		  := 0
Local aCampos := {}
Local aExtDes := {{".PRI",.T.},{".PRN",.T.},{".PDF",.T.},{".PLT",.T.}}
Local aFiles  := {}

AADD(aCampos,{ "DOCUM"      ,"C",11,0})
AADD(aCampos,{ "ITEM"       ,"C",3,0})
AADD(aCampos,{ "TIPO"       ,"C",1,0} )
AADD(aCampos,{ "CODIG"      ,"C",15,0})
AADD(aCampos,{ "MODIF"      ,"C",2,0})
AADD(aCampos,{ "DESCR"      ,"C",30,0})
AADD(aCampos,{ "QUANT"      ,"N",12,3})
AADD(aCampos,{ "MOVIM"      ,"C",1,0})
AADD(aCampos,{ "PESSOA"     ,"C",15,0})
AADD(aCampos,{ "ENTREGA"    ,"D",8})
AADD(aCampos,{ "PV"         ,"C",6,0})
AADD(aCampos,{ "ENTPV"      ,"D",8})
AADD(aCampos,{ "COTACAO"    ,"C",6,0})
AADD(aCampos,{ "FALTA"      ,"C",2,0})
AADD(aCampos,{ "APROP"      ,"C",50,0})
AADD(aCampos,{ "POSIC"      ,"C",80,0})
AADD(aCampos,{ "OBS"        ,"C",100,0})
AADD(aCampos,{ "NUMSC"      ,"C",6,0})
AADD(aCampos,{ "ITEMSC"     ,"C",4,0})
AADD(aCampos,{ "EMIS_SC"    ,"D",8,0})
AADD(aCampos,{ "ENTR_SC"    ,"D",8,0})
AADD(aCampos,{ "RETFOR"     ,"C",1,0})
AADD(aCampos,{ "QDE_ERRO"   ,"N",10,3})
AADD(aCampos,{ "EMITENTE"   ,"C",14,0})
AADD(aCampos,{ "REFER"      ,"C",6,0})
AADD(aCampos,{ "DATA_PCP"   ,"D",8})
AADD(aCampos,{ "DATA_CI"    ,"D",8})
AADD(aCampos,{ "CI"         ,"C",12})
AADD(aCampos,{ "PRE_NOTA"   ,"C",2})
AADD(aCampos,{ "INICIO"     ,"D",8})
AADD(aCampos,{ "FIM   "     ,"D",8})
AADD(aCampos,{ "IMPRES"     ,"D",8})
AADD(aCampos,{ "EMISSAO"    ,"D",8})
AADD(aCampos,{ "GRPMASI"    ,"C",20})
AADD(aCampos,{ "RESERVA"    ,"N",12,3})
AADD(aCampos,{ "ITEMSEP"    ,"C",1})
AADD(aCampos,{ "MSREUNI"    ,"D",8})
AADD(aCampos,{ "BLOQUEIO"   ,"C",4})
AADD(aCampos,{ "CATEG"      ,"C",1})
//Ivandro Santos - 18/08/17
//Ticket#2017062837000141 — Novos campos no SC7 para aparecer no Necessidades
AADD(aCampos,{ "PAGAM"      ,"C",1})
AADD(aCampos,{ "DATA_PAG"   ,"D",8})
//Ticket#2017062837000141 — Fim da alteração

// Cria arquivo de Trabalho - Extrato das necessidades
If Select("EXT") > 0
	DbSelectArea("EXT")
	DbCloseArea()
EndIf

cArqTrab2 := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab2,"EXT",.F.,.F.)
IndRegua("EXT",cArqTrab2,"Dtos(ENTREGA)+MOVIM",,,,)

ProcRegua(RecCount())           // Total de Elementos da Regua

If (cArqTxt := FCreate("C:\Relato_Microsiga\RPCPR001.PRN")) == -1
	apmsgStop("Arquivo Texto nao pode ser criado - Avise o Depto. de Informática")
	Return
EndIf

ImpParam()          // Imprime parametros selecionados pelo usuario

aDesenhos:= {}
_nQuant	:= 0               

Do While TRB->(!Eof())

	_nQuant	:= 0               

	SB2->(DbSetOrder(1))
	IF SUBSTR(cNumEmp,1,2) == "40"
		If SB2->(DbSeek(xFilial("SB2")+TRB->CODIG+"01"))
			_cProd:= SB2->B2_COD
			DO WHILE !SB2->(EOF()) .AND. _cProd == SB2->B2_COD
				_nQuant	+= SB2->B2_QATU
				SB2->(dbSkip())
			ENDDO	
		ELSE	
			_nQuant	:= 0
		EndIf
	ELSE
		If SB2->(DbSeek(xFilial("SB2")+TRB->CODIG))
			_nQLoc01 := GetAdvFVal("SB2","B2_QATU",xFilial("SB2")+TRB->CODIG+"01",1," ")
			_nQLoc10 := GetAdvFVal("SB2","B2_QATU",xFilial("SB2")+TRB->CODIG+"10",1," ")
			_nQuant	 := _nQLoc01+_nQLoc10
		ELSE	
			_nQuant	:= 0
		EndIf
	ENDIF
	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+TRB->CODIG))
		TRB->(DbSkip())
		Loop
	EndIf
	
	If (mv_par07 == 1 .And. Alltrim(SB1->B1_UM) == "CJ") .Or. (mv_par07 == 2 .And. Alltrim(SB1->B1_UM) <> "CJ")
		TRB->(DbSkip())
		Loop
	EndIf
	
	If mv_par09 == "5" .AND. Str(SB1->B1_ESTSEG,10,4) <= Str(_nQuant,10,4)
		TRB->(DbSkip())
		Loop
	EndIf
	
	If mv_par21 == 2 .And. (SubStr(SB1->B1_COD,1,2) $ "MP_TS" .Or. SubStr(SB1->B1_COD,1,3) == "MOD")
		TRB->(DbSkip())
		Loop
	EndIf
	
	If !SubStr(SB1->B1_LOCAL,1,1) $ mv_par15
		TRB->(DbSkip())
		Loop
	EndIf
	
	If !(mv_par08 $ "1_8") //mv_par08 <> "1"
		If !Empty(mv_par16) .And. Alltrim(SB1->B1_GRUPO) <> mv_par16
			TRB->(DbSkip())
			Loop
		EndIf
		
		If !Empty(mv_par17) .And. Alltrim(SB1->B1_CC) <> mv_par17
			TRB->(DbSkip())
			Loop
		EndIf
		
		If (mv_par14 == 1 .And. SubStr(SB1->B1_PROCED,1,1) <> "1") .Or. (mv_par14 == 2 .And. SubStr(SB1->B1_PROCED,1,1) == "1")
			TRB->(DbSkip())
			Loop
		EndIf
		
		If (mv_par27 == 1 .And. SubStr(SB1->B1_PROCED,2,1) == "N") .Or. (mv_par27 == 2 .And. SubStr(SB1->B1_PROCED,2,1) == "P")
			TRB->(DbSkip())
			Loop
		EndIf
	EndIf
	
	If !Empty(mv_par23)
		SA5->(DbSetOrder(1))
		If ! SA5->(DbSeek(xFilial("SA5")+mv_par23+cLoja+TRB->CODIG))
			TRB->(DbSkip())
			Loop
		EndIf
	EndIf
	
	// Verifica empenho
	nEmpenho := 0
	SC2->(DbSetOrder(1))
	SD4->(DbSetOrder(1))
	If SD4->(DbSeek(xFilial("SD4")+Alltrim(TRB->CODIG)))
		Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_COD) == Alltrim(TRB->CODIG)
			_cOPFin := DTOS(GetAdvFVal("SC2","C2_DATRF",xFilial("SD4")+SD4->D4_OP,1," "))
			If SD4->D4_QUANT > 0 .And. Empty(_cOPFin)
				If Intervalo()
					nEmpenho += SD4->D4_QUANT
				EndIf
			EndIf
			SD4->(DbSkip())
			Loop
		EndDo
	EndIf
	
	SF4->(DbSetOrder(1))
	SF4->(DbGoTop())
	SC6->(DbSetOrder(2))
	SC5->(DbSetOrder(1))
	SC9->(DbSetOrder(1)) // LIZANDRA 13/03/12
	If SC6->(DbSeek(xFilial("SC6")+Alltrim(TRB->CODIG))) .And. cEmpAnt $ '01|10'
		Do While !SC6->(EOF()) .And. Alltrim(SC6->C6_PRODUTO) == Alltrim(TRB->CODIG) 
			IF SC6->C6_BLQ <> 'R' // NÃO CONSIDERA RESIDUO - LIZANDRA - 09/04/15
				//SC5->(DbSetOrder(1))
				SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))
				If SubStr(SC5->C5_NOTA,1,3) <> "XXX" .And. (Empty(SC5->C5_NOTA) .Or. (SC5->C5_MSCATEG > "1" .OR. SubStr(cNumEmp,1,2) $ "15_40_45"))
					If (SC6->C6_QTDVEN > SC6->C6_QTDENT .And. !Empty(SC6->C6_MSPCP) .And. SC6->C6_MSPCP <> CTOD("31/12/49")) //.Or. SC6->C6_QTDEMP > 0
						dDtEntrega := CTOD(Space(8))
						If !Empty(SC5->C5_MSDTPEN)
							dDtEntrega := SC5->C5_MSDTPEN
						Else
							dDtEntrega := SC5->C5_MSDTENT
						EndIf
						If dDtEntrega >= mv_par18 .And. dDtEntrega <= mv_par19
							If SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
								If SF4->F4_ESTOQUE == "S"
									nEmpenho += (SC6->C6_QTDVEN - SC6->C6_QTDENT)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			ENDIF	
			SC6->(DbSkip())
			Loop
		EndDo
	EndIf

  // Verifica Requisições em aberto  - Lizandra 11/11/13
	SCP->(DbSetOrder(2))
	If SCP->(DbSeek(xFilial("SCP")+TRB->CODIG))
		Do While !SCP->(EOF()) .And. Alltrim(SCP->CP_PRODUTO) == Alltrim(TRB->CODIG) .AND. SCP->CP_EMISSAO >= MV_PAR18 .AND. SCP->CP_EMISSAO <= MV_PAR19
			If SCP->CP_QUJE < SCP->CP_QUANT .AND. SCP->CP_STATUS == " "
				nEmpenho += SCP->CP_QUANT - SCP->CP_QUJE
			ENDIF	
			SCP->(DbSkip())
		EndDo
	EndIf

	If mv_par09 == "4" .And. nEmpenho == 0
		TRB->(DbSkip())
		Loop
	EndIf
	
	If (mv_par09 == "1" .And. _nQuant >= nEmpenho) .Or. (mv_par09 == "3" .And. (_nQuant > 0 .Or. SB1->B1_UM == "CJ"))
		TRB->(DbSkip())
		Loop
	EndIf
	
	If mv_par09 == "6" .And. _nQuant <= nEmpenho
		TRB->(DbSkip())
		Loop
	EndIf
	
	nSaldoPrev := 0
	nSaldoOP   := 0
	nSaldoOPP  := 0
	nSaldoSC   := 0
	nSaldoDV   := 0	
	nSaldoPC   := 0
	dMSDTCHK   := CTOD('  /  /  ')
	nMSQTCHK   := 0
	
	If mv_par09 == "7" .Or. mv_par09 == "8" .Or. mv_par25 == 1
		// Verifica OP's abertas
		SC2->(DbSetOrder(2))
		If SC2->(DbSeek(xFilial("SC2")+TRB->CODIG))
			Do While !SC2->(Eof()) .And. Alltrim(SC2->C2_PRODUTO) == Alltrim(TRB->CODIG)
				If Empty(SC2->C2_DATRF)
					If SC2->C2_DATPRI >= mv_par18 .And. SC2->C2_DATPRI <= mv_par19
						nSaldoPrev += SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA) 
						// só considera op prevista se posic em branco.
						If cEmpAnt $ "01|10"
							If !Empty(SC2->C2_MSPOSIC)
								nSaldoOP += SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
							Else
								nSaldoOPP += SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
							Endif
						Else
							nSaldoOPP += SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
						EndIf
					EndIf
				EndIf
				SC2->(DbSkip())
			EndDo
		EndIf
		
		// Verifica Solicitacao de Compras abertas
		SC1->(DbSetOrder(2))
		If SC1->(DbSeek(xFilial("SC1")+Alltrim(TRB->CODIG)))
			Do While !SC1->(EOF()) .And. Alltrim(SC1->C1_PRODUTO) == Alltrim(TRB->CODIG)
				If SC1->C1_QUJE < SC1->C1_QUANT
					If SC1->C1_DATPRF >= mv_par18 .And. SC1->C1_DATPRF <= mv_par19
						If AT("SNF",Upper(SC1->C1_OBS)) == 0 .And. AT("COTA",Upper(SC1->C1_MSAPROP)) == 0 .And. AT("VALE",Upper(SC1->C1_OBS)) == 0
							IF EMPTY(SC1->C1_RESIDUO)   // VERIFICA SE O ITEM NÃO FOI ELIMINADO POR RESÍDUO - LIZANDRA 26/11/12
								nSaldoPrev += SC1->C1_QUANT - SC1->C1_QUJE
								nSaldoSC   += SC1->C1_QUANT - SC1->C1_QUJE
								If SubStr(cNumEmp,1,2) == "01"
									dMSDTCHK   := SC1->C1_MSDTCHK
									nMSQTCHK   := SC1->C1_MSQTCHK
								EndIf
							ENDIF	
						EndIf
					EndIf
				EndIf
				SC1->(DbSkip())
			EndDo
		EndIf

		// Verifica Devoluções em aberto  - Lizandra 15/01/13
		SZP->(DbSetOrder(2))
		If SZP->(DbSeek(xFilial("SZP")+Alltrim(TRB->CODIG)))
			Do While !SZP->(EOF()) .And. Alltrim(SZP->ZP_PRODUTO) == Alltrim(TRB->CODIG)
				If SZP->ZP_QUJE < SZP->ZP_QUANT
					nSaldoPrev += SZP->ZP_QUANT - SZP->ZP_QUJE
					nSaldoDV   += SZP->ZP_QUANT - SZP->ZP_QUJE
				ENDIF	
				SZP->(DbSkip())
			EndDo
		EndIf
		
		// Verifica Pedido de Compras abertos
		SC7->(DbSetOrder(2))
		If SC7->(DbSeek(xFilial("SC7")+Alltrim(TRB->CODIG)))
			Do While ! SC7->(Eof()) . And. Alltrim(SC7->C7_PRODUTO) == Alltrim(TRB->CODIG)
				If SC7->C7_QUJE < SC7->C7_QUANT .And. SC7->C7_RESIDUO <> "S"
					If SC7->C7_DATPRF >= mv_par18 .And. SC7->C7_DATPRF <= mv_par19
						If AT("SNF",Upper(SC7->C7_OBS)) == 0 .And. AT("VALE",Upper(SC7->C7_OBS)) == 0 .And. Empty(SC7->C7_MSNF)
							nSaldoPrev += SC7->C7_QUANT - SC7->C7_QUJE
							nSaldoPC   += SC7->C7_QUANT - SC7->C7_QUJE
						EndIf
					EndIf
				EndIf
				SC7->(DbSkip())
			EndDo
		EndIf
		
		If mv_par09 == "7"                    
			IF MV_PAR28 == 1  // ALTERADO 24/05/13 A PEDIDO DO FRANCISCO - CONSIDERAR OU NAO ESTOQUE DE SEGURANÇA - LIZANDRA
				If _nQuant + nSaldoOP + nSaldoOPP + nSaldoSC + nSaldoPC + nSaldoDV - SB1->B1_ESTSEG >= nEmpenho
					TRB->(DbSkip())
					Loop
				EndIf
			ELSE	
				If _nQuant + nSaldoOP + nSaldoOPP + nSaldoSC + nSaldoPC + nSaldoDV  >= nEmpenho
					TRB->(DbSkip())
					Loop
				EndIf
			ENDIF	
		EndIf
		
		If mv_par09 == "8"
			IF MV_PAR28 == 1  // ALTERADO 24/05/13 A PEDIDO DO FRANCISCO - CONSIDERAR OU NAO ESTOQUE DE SEGURANÇA - LIZANDRA
				If _nQuant + nSaldoOP + nSaldoOPP + nSaldoSC + nSaldoPC + nSaldoDV - SB1->B1_ESTSEG <= nEmpenho
					TRB->(DbSkip())
					Loop
				EndIf
			ELSE
				If _nQuant + nSaldoOP + nSaldoOPP + nSaldoSC + nSaldoPC + nSaldoDV  <= nEmpenho
					TRB->(DbSkip())
					Loop
				EndIf
			ENDIF	
		EndIf

		If mv_par09 == "9"
			If nEmpenho <= _nQuant 
				TRB->(DbSkip())
				Loop
			ENDIF	
		EndIf
	EndIf
	
	If mv_par04 == 1
		If MV_PAR29 == 3
		//	cDrive := "H"
			If SubStr(SB1->B1_COD,1,2) == "CL"
				cPasta := SubStr(SB1->B1_COD,3,2)
			Else
				cPasta := SubStr(SB1->B1_COD,1,2)
			EndIf
			cDesenho := cDrive + ":\PLOTTER\" + cPasta + "\" + Alltrim(SB1->B1_COD) + Alltrim(SB1->B1_REVATU)
			For nD:=1 to 4
				ADir(cDesenho+aExtDes[nD][1], aFiles)
				If len (aFiles) > 0
					aExtDes[nD][2] := .T.
					AADD(aDesenhos,"cmd /c COPY /B " + cDesenho + aExtDes[nD][1] + " LPT1" )
				Else
					aExtDes[nD][2] := .F.
				Endif
			Next
			IF !(aExtDes[1][2]) .And. !(aExtDes[2][2]) .And. !(aExtDes[3][2]) .And. !(aExtDes[4][2])
		//		cDrive := "P"
				If Substr(SB1->B1_COD,1,1) == "X"
					If ExistDir(cDrive+":\PLOTTER\"+Substr(SB1->B1_COD,1,3))
						cPasta := SubStr(SB1->B1_COD,1,3) //Substr(cDesenho,1,3) + "\"
					Else
						cPasta := SubStr(SB1->B1_COD,2,3) //Substr(cDesenho,2,3) + "\"
					Endif
				ElseIf Substr(SB1->B1_COD,1,2) == "70"
					cPasta := Substr(SB1->B1_COD,1,2)
				Else
					cPasta := Substr(SB1->B1_COD,1,3)
				Endif
				cDesenho := cDrive + ":\PLOTTER\" + cPasta + "\" + Alltrim(SB1->B1_COD) + Alltrim(SB1->B1_REVATU)
				For nD:=1 to 4
					ADir(cDesenho+aExtDes[nD][1], aFiles)
					If len (aFiles) > 0
						aExtDes[nD][2] := .T.
						AADD(aDesenhos,"cmd /c COPY /B " + cDesenho + aExtDes[nD][1] + " LPT1" )
					Else
						aExtDes[nD][2] := .F.
					Endif
				Next
			Endif
		Else
			If MV_PAR29 == 1 .And. SubStr(cNumEmp,1,2) $ "01_40_45"
				If SubStr(SB1->B1_COD,1,2) == "CL"
					cPasta := SubStr(SB1->B1_COD,3,2)
				ElseIf SubStr(SB1->B1_COD,1,1) == 'H' .Or. SubStr(SB1->B1_COD,1,2) == 'MD'
					cPasta := 'MD'
				Else
					cPasta := SubStr(SB1->B1_COD,1,2)
				EndIf
				cDesenho := cDrive + ":\PLOTTER\" + cPasta + "\" + Alltrim(SB1->B1_COD) + Alltrim(SB1->B1_REVATU)
			Elseif MV_PAR29 == 2
				cPasta := SubStr(SB1->B1_COD,1,3)
				cDesenho := cDrive + ":\PLOTTER\" + cPasta + "\" + Alltrim(SB1->B1_COD) + Alltrim(SB1->B1_REVATU)
			EndIf
			If Ascan(aDesenhos,cDesenho+".PRI") == 0
				For I := 1 To mv_par05
					AADD(aDesenhos,"cmd /c COPY /B " + cDesenho + ".PLT LPT1")
					AADD(aDesenhos,"cmd /c COPY /B " + cDesenho + ".PRI LPT1")
					AADD(aDesenhos,"cmd /c COPY /B " + cDesenho + ".PRN LPT1")
				Next
			Endif
		EndIf
	EndIf
	
	// Grava Extrato
	dbSelectArea("EXT")
	If RecCount() > 0
		Zap
	EndIf
	
	SC2->(DbSetOrder(1))
	SD4->(DBSetOrder(1))
	SD4->(DbGoTop())
	SC5->(DBSetOrder(1))
	If SD4->(DbSeek(xFilial("SD4")+Alltrim(TRB->CODIG)))
		Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_COD) == Alltrim(TRB->CODIG)
			_cOPFin := DTOS(GetAdvFVal("SC2","C2_DATRF",xFilial("SD4")+SD4->D4_OP,1," "))
			If SD4->D4_QUANT > 0 .And. Empty(_cOPFin)
				If Intervalo()
					EXT->(DbAppend())
					SC2->(DbSeek(xFilial("SC2")+Alltrim(SD4->D4_OP)))
					SB1->(DbSeek(xFilial("SB1")+Alltrim(SC2->C2_PRODUTO)))
					EXT->DOCUM    := Alltrim(SD4->D4_OP)
					EXT->CODIG    := SC2->C2_PRODUTO
					EXT->MODIF    := Alltrim(SC2->C2_REVISAO)
					EXT->DESCR    := SB1->B1_DESC
					EXT->QUANT    := SD4->D4_QUANT * -1
					EXT->ITEM	  := SD4->D4_TRT
					EXT->MOVIM    := "S"
					If cEmpAnt $ "01|10"
						EXT->PESSOA   := SC2->C2_MSREDUZ
					Endif
					If mv_par26 == 1 .And. cEmpAnt $ "01|10"
						EXT->POSIC := Alltrim(SC2->C2_MSPOSIC)
					EndIf
					EXT->ENTREGA  := SD4->D4_DATA

					If cEmpAnt $ "01|10"
						EXT->PV       := SC2->C2_MSPED
					Endif

					If cEmpAnt $ "01|10"
						If SC5->(DbSeek(xFilial("SC5")+SC2->C2_MSPED))
							EXT->ENTPV := SC5->C5_MSDTENT
							If !Empty(SC5->C5_MSDTPEN)
								EXT->ENTPV := SC5->C5_MSDTPEN
							EndIf
							IF (SC5->C5_MSCATEG == "2" .OR. SC5->C5_MSCATEG == "3" .OR. SC5->C5_MSCATEG == "5" .OR. SC5->C5_MSCATEG == "6") .AND. SubStr(cNumEmp,1,2) $ "01_10"    // Comex, Venda de Pecas ou Terceiros
							EXT->CATEG := SC5->C5_MSCATEG
							ENDIF
						EndIf
					Endif

					If cEmpAnt $ "01|10"
						EXT->REFER   := SD4->D4_MSREFER
						EXT->FALTA   := SD4->D4_MSLF + If(SD4->D4_MSIMPRE == "X","I","")
						EXT->CI      := SC2->C2_MSCI
						EXT->DATA_CI := SC2->C2_MSDTCI
					Endif
					//EXT->CI      := SD4->D4_MSCI
					//EXT->DATA_CI := SD4->D4_MSDTCI
				EndIf
			EndIf
			SD4->(DbSkip())
			Loop
		EndDo
	EndIf
	
	SC2->(DbSetOrder(2))
	SC2->(DbGotop())
	If SC2->(DbSeek(xFilial("SC2")+Alltrim(TRB->CODIG)))
		Do While !SC2->(Eof()) .And. Alltrim(SC2->C2_PRODUTO) == Alltrim(TRB->CODIG)
			If Empty(SC2->C2_DATRF)
				EXT->(DbAppend())
				EXT->DOCUM   := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
				EXT->CODIG   := SC2->C2_PRODUTO
				SB1->(DbSeek(xFilial("SB1")+Alltrim(SC2->C2_PRODUTO)))
				EXT->MODIF   := Alltrim(SC2->C2_REVISAO)
				EXT->QUANT   := SC2->C2_QUANT - (SC2->C2_QUJE+SC2->C2_PERDA)
				EXT->MOVIM   := "E"
				EXT->OBS     := SC2->C2_OBS
				EXT->DESCR   := "*** ORDEM DE PRODUCAO ***"
				EXT->ENTREGA := SC2->C2_DATPRF
				EXT->INICIO  := SC2->C2_DATPRI
				EXT->FIM     := SC2->C2_DATPRF
				EXT->EMISSAO := SC2->C2_EMISSAO

				If cEmpAnt $ "01|10"
					EXT->PESSOA  := SC2->C2_MSREDUZ
					EXT->PV      := SC2->C2_MSPED
					EXT->POSIC   := ALLTRIM(SC2->C2_MSPOSIC)
					EXT->EMITENTE:= SC2->C2_MSUSER
					EXT->FALTA   := " " + If(Empty(SC2->C2_MSIMPR),SPACE(1),"I")
					EXT->CI      := SC2->C2_MSCI
					EXT->DATA_CI := SC2->C2_MSDTCI
					EXT->IMPRES  := SC2->C2_MSIMPR
					EXT->GRPMASI := SC2->C2_MSGRPMA
				Endif
			EndIf
			SC2->(DbSkip())
		EndDo
	EndIf
	
	SC1->(DbSetOrder(2))
	If SC1->(DbSeek(xFilial("SC1")+Alltrim(TRB->CODIG)))
		Do While !SC1->(Eof()) .And. Alltrim(SC1->C1_PRODUTO) == Alltrim(TRB->CODIG)
			If SC1->C1_QUJE < SC1->C1_QUANT .AND. EMPTY(SC1->C1_RESIDUO)
				EXT->(DbAppend())
				EXT->DOCUM   := SC1->C1_NUM
				EXT->CODIG   := SC1->C1_PRODUTO
				SB1->(DbSeek(xFilial("SB1")+Alltrim(SC1->C1_PRODUTO)))
				EXT->MODIF   := Alltrim(SB1->B1_REVATU)
				EXT->QUANT   := SC1->C1_QUANT - SC1->C1_QUJE
				EXT->MOVIM   := "E"
				EXT->ITEM    := SubStr(SC1->C1_ITEM,2)
				EXT->DESCR   := "*** SOLICITACAO DE COMPRA ***"
				EXT->ENTREGA := SC1->C1_DATPRF
				EXT->EMISSAO := SC1->C1_EMISSAO
				EXT->APROP   := SUBSTR(SC1->C1_MSAPROP,1,30)
				EXT->OBS     := SC1->C1_OBS
				EXT->COTACAO := SC1->C1_COTACAO
				EXT->EMITENTE:= SC1->C1_SOLICIT
				EXT->MSREUNI := SC1->C1_MSREUNI
			EndIf
			SC1->(DbSkip())
		EndDo
	EndIf
	
	SC7->(DbSetOrder(2))
	If SC7->(DbSeek(xFilial("SC7")+Alltrim(TRB->CODIG)))
		Do While !SC7->(Eof()) .And. Alltrim(SC7->C7_PRODUTO) == Alltrim(TRB->CODIG)
			If SC7->C7_QUJE < SC7->C7_QUANT .And. Empty(SC7->C7_RESIDUO)
				EXT->(DbAppend())
				SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE))
				EXT->PESSOA := SA2->A2_NREDUZ
				EXT->DOCUM  := SC7->C7_NUM
				EXT->CODIG  := SC7->C7_PRODUTO
				SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
				EXT->MODIF  := Alltrim(SB1->B1_REVATU)
				EXT->QUANT  := SC7->C7_QUANT - SC7->C7_QUJE
				If Empty(SC7->C7_MSNF)
					EXT->MOVIM  := "E"
				Else
					EXT->MOVIM  := "X"
				EndIf
				EXT->ITEM    := SUBSTR(SC7->C7_ITEM,2,3)
				EXT->DESCR   := "*** PEDIDO DE COMPRA ***"
				EXT->EMISSAO := SC7->C7_EMISSAO
				EXT->ENTREGA := SC7->C7_DATPRF
//				EXT->MSREUNI := SC7->C7_MSREUNI
				EXT->OBS     := ALLTRIM(SC7->C7_OBS) 
				EXT->NUMSC   := SC7->C7_NUMSC
				EXT->ITEMSC  := SC7->C7_ITEMSC
				IF !EMPTY(SC7->C7_QTDACLA)
					EXT->PRE_NOTA := "PN"
				ENDIF
				If !Empty(SC7->C7_RETFOR)
					EXT->RETFOR := SC7->C7_RETFOR
				Else
					EXT->RETFOR := "N"
				EndIf
				//Ticket#2017062837000141 — Novos campos no SC7 para aparecer no Necessidades
				EXT->PAGAM 	 := SC7->C7_MSPAGVI
				EXT->DATA_PAG:= SC7->C7_MSDTPAG
				//Ticket#2017062837000141 — Fim da alteração
				SC1->(DbSetOrder(1))
				If SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
					EXT->EMITENTE := SC1->C1_SOLICIT
					EXT->APROP := SUBSTR(SC1->C1_MSAPROP,1,30)
					EXT->EMIS_SC := SC1->C1_EMISSAO
					EXT->ENTR_SC := SC1->C1_DATPRF
					If SC1->C1_QUANT <> SC7->C7_QUANT
						EXT->QDE_ERRO  := SC1->C1_QUANT
					EndIf
				EndIf
			EndIf
			SC7->(DbSkip())
		EndDo
	EndIf
	
	SC6->(DbSetOrder(2))
	SC5->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+Alltrim(TRB->CODIG)))
		Do While !SC6->(Eof()) .And. Alltrim(SC6->C6_PRODUTO) == Alltrim(TRB->CODIG)
			IF SC6->C6_BLQ <> 'R' // NAO CONSIDERA RESIDUO - LIZANDRA - 09/04/15
				SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))
				If SubStr(SC5->C5_NOTA,1,3) <> "XXX" .And. (Empty(SC5->C5_NOTA) .Or. (SC5->C5_MSCATEG > "1" .OR. SubStr(cNumEmp,1,2) $ "15_40_45"))
					If SC6->C6_QTDVEN > SC6->C6_QTDENT // .And. !Empty(SC6->C6_MSPCP) .And. SC6->C6_MSPCP <> CTOD("31/12/49"))
						dDtEntrega := CTOD(Space(8))
						If !Empty(SC5->C5_MSDTPEN)
							dDtEntrega := SC5->C5_MSDTPEN
						Else
							dDtEntrega := SC5->C5_MSDTENT
						EndIf
						cMovim := "X"
						If dDtEntrega >= mv_par18 .And. dDtEntrega <= mv_par19
							If (SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))) .AND. (!Empty(SC6->C6_MSPCP) .And. SC6->C6_MSPCP <> CTOD("31/12/49"))
								If SF4->F4_ESTOQUE == "S"
									cMovim := "S"
								EndIf
							EndIf
							EXT->(DbAppend())
							If SC5->C5_TIPO $ "B_D"
							If SA2->(DbSeek(xFilial("SA2")+SC5->C5_CLIENTE))
									EXT->PESSOA := SA2->A2_NREDUZ
								EndIf
							Else
								If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE))
									EXT->PESSOA := SA1->A1_NREDUZ
								EndIf
							EndIf
							EXT->DOCUM := SC6->C6_NUM
							EXT->CODIG := SC6->C6_PRODUTO
							EXT->MODIF := Alltrim(SC6->C6_REVISAO)
							EXT->QUANT := (SC6->C6_QTDVEN - SC6->C6_QTDENT) * -1
							// LIZANDRA    05/03/12
							SC9->(DbSetOrder(1))
							IF SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
								EXT->BLOQUEIO := SC9->C9_BLEST + SC9->C9_BLCRED
								EXT->RESERVA  := SC9->C9_QTDLIB
							ENDIF	
							EXT->ITEMSEP := SC6->C6_MSSEP
							EXT->MOVIM := cMovim
							EXT->ITEM := SC6->C6_ITEM
							EXT->DESCR := "*** PEDIDO DE VENDA ***"
							EXT->POSIC := ALLTRIM(SC5->C5_MSPOSIC)
							EXT->ENTREGA := dDtEntrega
							EXT->OBS := "TES: " + SC6->C6_TES + " - " + ALLTRIM(SF4->F4_FINALID) + " - Emit.: " + ALLTRIM(SC5->C5_MSNOUSU)
							IF Empty(SC6->C6_MSPCP) .OR. DTOS(SC6->C6_MSPCP) == "20491231"
							   EXT->OBS := ALLTRIM(EXT->OBS) + " - Pedido nao analisado pelo PCP"
							ENDIF
							EXT->EMISSAO := SC5->C5_EMISSAO
						EndIf
					EndIf
				EndIf
			ENDIF	
			SC6->(DbSkip())
		EndDo
	EndIf
	
	SZP->(DbSetOrder(2))
	If SZP->(DbSeek(xFilial("SZP")+Alltrim(TRB->CODIG)))
		Do While !SZP->(Eof()) .And. Alltrim(SZP->ZP_PRODUTO) == Alltrim(TRB->CODIG)
			If SZP->ZP_QUJE < SZP->ZP_QUANT
///				EXT->(DbAppend())
				RecLock("EXT",.T.)
				EXT->DOCUM   := SZP->ZP_NUM
				EXT->CODIG   := SZP->ZP_PRODUTO
				SB1->(DbSeek(xFilial("SB1")+Alltrim(SZP->ZP_PRODUTO)))
				EXT->MODIF   := Alltrim(SB1->B1_REVATU)
				EXT->QUANT   := SZP->ZP_QUANT - SZP->ZP_QUJE
				EXT->MOVIM   := "E"
				EXT->ITEM    := SubStr(SZP->ZP_ITEM,2)
				EXT->DESCR   := "***DEV. ALMOXARIFADO***"
				EXT->ENTREGA := SZP->ZP_EMISSAO
				EXT->EMISSAO := SZP->ZP_EMISSAO
				EXT->APROP   := ""
				EXT->OBS     := SZP->ZP_OBS
				EXT->COTACAO := ""
				EXT->EMITENTE:= Alltrim(SZP->ZP_SOLICIT)
				EXT->MSREUNI := CTOD("")
				MsUnlock()
			EndIf
			SZP->(DbSkip())
		EndDo
	EndIf

	SCP->(DbSetOrder(2))
	If SCP->(DbSeek(xFilial("SCP")+Alltrim(TRB->CODIG)))
		Do While !SCP->(Eof()) .And. Alltrim(SCP->CP_PRODUTO) == Alltrim(TRB->CODIG) .AND. SCP->CP_EMISSAO >= MV_PAR18 .AND. SCP->CP_EMISSAO <= MV_PAR19
			If SCP->CP_QUJE < SCP->CP_QUANT .AND. SCP->CP_STATUS == " "
				RecLock("EXT",.T.)
				EXT->DOCUM   := SCP->CP_NUM
				EXT->CODIG   := SCP->CP_PRODUTO
				SB1->(DbSeek(xFilial("SB1")+Alltrim(SCP->CP_PRODUTO)))
				EXT->MODIF   := Alltrim(SB1->B1_REVATU)
				EXT->QUANT   := (SCP->CP_QUANT - SCP->CP_QUJE) * -1
				EXT->MOVIM   := "E"
				EXT->ITEM    := SubStr(SCP->CP_ITEM,2)
				EXT->DESCR   := "***REQ. ALMOXARIFADO***"
				EXT->ENTREGA := SCP->CP_EMISSAO
				EXT->EMISSAO := SCP->CP_EMISSAO
				EXT->APROP   := ""
				EXT->OBS     := SCP->CP_OBS
				EXT->COTACAO := ""                
				cUsr := SCP->CP_SOLICIT 
				PswOrder(2) // Pesquisa por usuario
                PswSeek(cUsr,.T.)
				aUser := PswRet(1)
				cIDUsr := aUser[1][1] // ID do usuario.
				EXT->EMITENTE:= Alltrim(UsrFullName(cIDUsr))  //SCP->CP_SOLICIT
				EXT->MSREUNI := CTOD("")
				MsUnlock()
			EndIf
			SCP->(DbSkip())
		EndDo
	EndIf
/*
	SB6->(DbSetOrder(1))
	If SB6->(DbSeek(xFilial("SB6")+Alltrim(TRB->CODIG)))
		Do While !SB6->(Eof()) .And. Alltrim(SB6->B6_PRODUTO) == Alltrim(TRB->CODIG)
			If SB6->B6_SALDO > 0 .And. SB6->B6_TIPO == "E" .And. Dtos(SB6->B6_EMISSAO) > "20081231"
				EXT->(DbAppend())
				If SA2->(DbSeek(Space(2)+SB6->B6_CLIFOR))
					EXT->PESSOA := SA2->A2_NREDUZ
				EndIf
				EXT->DOCUM := SB6->B6_DOC
				EXT->CODIG := SB6->B6_PRODUTO
				EXT->MODIF := Alltrim(SB1->B1_REVATU)
				EXT->QUANT := SB6->B6_SALDO
				EXT->MOVIM := "X"
				EXT->DESCR := "*** NOTA FISCAL ***"
				If SF4->(DbSeek(xFilial("SF4")+SB6->B6_TES))
					EXT->OBS := SB6->B6_TES + " - " + SF4->F4_DESCRIC
				EndIf
				EXT->ENTREGA := SB6->B6_EMISSAO
			EndIf
			SB6->(DbSkip())
		EndDo
	EndIf
	dbCommitAll()
*/	

	/// TOTALIZA SAIDAS - 10/07/14
	
	IF Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	ENDIF

	_nCons := 0 
	_cQuery1 := " SELECT D3_COD, SUM(D3_QUANT) AS QUANT "
	_cQuery1 += " FROM " + RetSqlName("SD3") + " D3 "
	_cQuery1 += " WHERE D3_FILIAL = '" + xFilial("SD3") + "' AND D3.D_E_L_E_T_ = ' ' "
	_cQuery1 += "       AND SUBSTRING(D3_CF,1,2) = 'RE' "
	_cQuery1 += "       AND D3_EMISSAO BETWEEN '" + DTOS(MV_PAR18) + "' AND '" + DTOS(MV_PAR19) + "' " 
	_cQuery1 += "       AND D3_COD = '" + TRB->CODIG + "' "
	_cQuery1 += " GROUP BY D3_COD  "  

	TcQuery _cQuery1 New Alias "QR1"
	TcSetField ("QR1","QUANT","N",12,2)
	
	_nCons := QR1->QUANT
	
	QR1->(dbCloseArea())
	/// FIM DA ALTERAÇÃO
	
	dDataNec  := CTOD("30/11/29")
	dDataRem  := CTOD("30/11/29")
	cLF       := ""
	
	ImpNecessidade()
	
	If DTOC(dDataRem) == "30/11/29" .Or. dDataRem >= dDataNec
		dDataRem := CTOD(Space(8))
	EndIf
	
	If DTOC(dDataNec) == "30/11/29"
		dDataNec := CTOD(Space(8))
	Else
		dDataNec := dDataNec - 3
		If Dow(dDataNec) == 1
			dDataNec += 1
		Else
			If Dow(dDataNec) == 7
				dDataNec += 2
			EndIf
		EndIf
	EndIf
	
	cBloq := ""
	
	If SB1->B1_MSBLQL == "1"
		cBloq := "S"
	EndIf
	IF MV_PAR28 == 1  // ALTERADO 24/05/13 A PEDIDO DO FRANCISCO - CONSIDERAR OU NAO ESTOQUE DE SEGURANÇA - LIZANDRA
		nTenho := _nQuant - SB1->B1_ESTSEG + nSaldoOP + nSaldoOPP + nSaldoSC + nSaldoPC + nSaldoDV
	ELSE
		nTenho := _nQuant + nSaldoOP + nSaldoOPP + nSaldoSC + nSaldoPC + nSaldoDV
	ENDIF	
	nPreciso := nEmpenho - nTenho
	If nPreciso < 0
		nPreciso := 0
	EndIf
	
	If mv_par25 == 1
		aProd_Forn := {}
		cProd_Forn := ""
		SA5->(DbSetOrder(2))
		If SA5->(DbSeek(xFilial("SA5")+TRB->CODIG))
			Do While !SA5->(EOF()) .And. SA5->A5_PRODUTO == TRB->CODIG
				If SA2->(DbSeek(xFilial("SA2")+SA5->A5_FORNECE))
					AADD(aProd_Forn,STR(SA5->A5_NOTA,1,0)+"-"+Alltrim(SA2->A2_NREDUZ))
				ENDIF
				SA5->(DbSkip())
			EndDo
			// organiza da maior para a menor nota, ou seja, classifica o fornecedor do produto
			ASORT(aProd_Forn,,,{ | x, y| x > y })
			FOR nFornecedor := 1 TO LEN(aProd_Forn)
				cProd_Forn += aProd_Forn[nFornecedor] + ";"
			NEXT
		EndIf
		
		If "FISCAL" $ _cDeptoUsu .Or. "COMPRAS" $ _cDeptoUsu .Or. "CONTABILIDADE" $ _cDeptoUsu .Or. "COMERCIAL" $ _cDeptoUsu ;
			.Or. "VENDA DE PECAS" $ _cDeptoUsu .Or. "INFORMATICA" $ _cDeptoUsu .Or. "PCP" $ _cDeptoUsu ;
			.Or. _cNomeUsu $ _cUsers
			cRegCSV := "_"+TRB->CODIG+";"+Alltrim(SB1->B1_REVATU)+";"+SB1->B1_MSGRVEN+";"+cLF+";"+cBloq+";"+SB1->B1_DESC+";"+SB1->B1_UM+";"+Transform(SB1->B1_CUSTD,"@E 999,999.999")+";"+DTOC(SB2->B2_DINVENT)+";"
		Else
			//VICTOR DESSUNTE - 19/04/16
			//INICIO - TICKET: 2017041737000085
			If _cNomeUsu == "RWada"
				cRegCSV := "_"+TRB->CODIG+";"+Alltrim(SB1->B1_REVATU)+";"+SB1->B1_MSGRVEN+";"+cLF+";"+cBloq+";"+SB1->B1_DESC+";"+SB1->B1_UM+";"+Transform(SB1->B1_UPRC,"@E 999,999.999")+";"+Transform(TRB->NECES, "@E 999,999.999")+";"+DTOC(SB2->B2_DINVENT)+";"
			Else
				cRegCSV := "_"+TRB->CODIG+";"+Alltrim(SB1->B1_REVATU)+";"+SB1->B1_MSGRVEN+";"+cLF+";"+cBloq+";"+SB1->B1_DESC+";"+SB1->B1_UM+";"+Transform(0,"@E 999,999.999")+";"+DTOC(SB2->B2_DINVENT)+";"
			EndIf
		EndIf
		If SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+"01"))
			If _cNomeUsu == "RWada"
				cRegCSV += DTOC(SB1->B1_UCOM)	 + ";"			
			EndIf
			cRegCSV += DTOC(SB2->B2_MSMOVIM)
			//FIM - TICKET: 2017041737000085
		Else
			cRegCSV += Space(10)
		EndIf
		cRegCSV += ";"+TRANSFORM(_nCons,"@E 999999")+";_"+SB1->B1_LOCAL+";"+SB1->B1_FANTASM+";"+SB1->B1_CC+";"+SB1->B1_PROCED+";"+SB1->B1_GRUPO+";"+Transform(SB1->B1_PE,"@E 999")
		cRegCSV += ";"+Transform(SB1->B1_ESTSEG,"@E 999999.999")+";"+Transform(_nQuant,"@E 999999.999")+";"+Transform(nEmpenho, "@E 999999.999")
		cRegCSV += ";"+Transform(nSaldoOP, "@E 999999.999")+";"+Transform(nSaldoOPP,"@E 999999.999")+";"+Transform(nSaldoSC,"@E 999999.999")+";"+ Transform(nSaldoPC,"@E 999999.999")+";"+ Transform(nSaldoDV,"@E 999999.999")
		//Ivandro Santos - 06/04/17 - Início da alteração
		//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
		cDescr := Alltrim(GetAdvFval("SB5","B5_CEME",xFilial("SB5")+SB1->B1_COD,1," "))
		cRegCSV += ";"+Transform(nTenho,"@E 999999.999")+";"+Transform(nPreciso, "@E 999999.999")+";"+Transform(SB1->B1_LM,"@E 999999")+";"+Transform(SB1->B1_LE,"@E 999999")+";"+DTOC(dDataNec)+";"+DTOC(dDataRem)+";"+SB1->B1_MSAMBIE+";"+Transform(SB1->B1_PESO,"@E 999999.9999")+";"+cDescr
		//cRegCSV += ";"+Transform(nTenho,"@E 999999.999")+";"+Transform(nPreciso, "@E 999999.999")+";"+Transform(SB1->B1_LM,"@E 999999")+";"+Transform(SB1->B1_LE,"@E 999999")+";"+DTOC(dDataNec)+";"+DTOC(dDataRem)+";"+SB1->B1_MSAMBIE+";"+Transform(SB1->B1_PESO,"@E 999999.9999")+";"+SB1->B1_DESCP
		//Ticket#2017031037000107 — Fim da alteração
		cRegCSV += ";"+DTOC(SB1->B1_MSDTLOT)
		If mv_par08 == "3"
			cRegCSV += ";"+Transform(TRB->NECES, "@E 999,999.999")
		else
			cRegCSV += ";"+"//"
		EndIf
		cRegCSV += ";"+SB1->B1_FABRIC
		If SubStr(cNumEmp,1,2) == "01"
			cRegCSV += ";"+DTOC(dMSDTCHK)
			cRegCSV += ";"+Transform(nMSQTCHK,"@E 999")
			cRegCSV += ";"+cProd_Forn
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		Else
			cRegCSV += ";"+cProd_Forn
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		EndIf

		If _lGera .And. nPreciso > 0
			RecLock("SZU",.T.)
			SZU->ZU_FILIAL  := "01"
			SZU->ZU_DATA    := Date()
			SZU->ZU_HORA    := cHora
			SZU->ZU_USUARIO := _cNomeUsu
			SZU->ZU_PRODUTO := TRB->CODIG
			If SG2->(DbSeek(xFilial("SG2")+TRB->CODIG))
				SZU->ZU_ROTEIRO := "X"
			EndIf
			SZU->ZU_PROCED  := SB1->B1_PROCED
			SZU->ZU_UM      := SB1->B1_UM
			SZU->ZU_GRUPO   := SB1->B1_GRUPO
			SZU->ZU_LOTEECO := SB1->B1_LE
			SZU->ZU_LOTEMIN := SB1->B1_LM
			SZU->ZU_QTDNEC  := nPreciso
			SZU->ZU_DTNECES := dDataNec
			SZU->ZU_DTREMAN := dDataRem
			SZU->ZU_DATAOP  := dDataNec
			SZU->ZU_OBS     := ""
			SZU->ZU_STATUS  := "A"
			If SB1->B1_LE > 0
				If SB1->B1_LM > 0 .And. Mod(SB1->B1_LE,SB1->B1_LM) == 0
					SZU->ZU_QTDPOP := SB1->B1_LM
					If nPreciso < SB1->B1_LE
						If (SB1->B1_LE / SB1->B1_LM) < 100
							SZU->ZU_QTDEOP := SB1->B1_LE / SB1->B1_LM
						Else
							SZU->ZU_QTDEOP := 0   // Quantidades LE e LM incoerentes
						EndIf
					Else
						SZU->ZU_QTDEOP := Int(nPreciso / SB1->B1_LM)
						If nPreciso < (SZU->ZU_QTDPOP * SZU->ZU_QTDEOP)
							SZU->ZU_QTDEOP++
						EndIf
					EndIf
				Else
					SZU->ZU_QTDEOP := 1
					If nPreciso < SB1->B1_LE
						SZU->ZU_QTDPOP  := SB1->B1_LE
					Else
						SZU->ZU_QTDPOP  := nPreciso
					EndIf
				EndIf
			Else
				SZU->ZU_QTDPOP := nPreciso
				SZU->ZU_QTDEOP := 1
			EndIf
			SZU->(MsUnlock())
		EndIf
	EndIf
	TRB->(DbSkip())
	Loop
EndDo

If mv_par25 == 1
	cRegCSV := "Inicio do processo: "+ cHora
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	cHora   := Time()
	cRegCSV := "Fim do processo: "+ cHora
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf

cRegTxt := Replicate("*",132)
ImpLinha()

FClose(cArqTxt)
FClose(cArqCSV) 

         
If mv_par01 = 1
	WinExec("NOTEPAD "+ "C:\relato_microsiga\RPCPR001.PRN")
Else
   If MV_PAR08 <> "8"
	   WinExec('cmd /c COPY c:\relato_microsiga\rpcpr001.prn LPT1')  //
   Else
	   WaitRun('cmd /c COPY c:\relato_microsiga\rpcpr001.prn LPT1')
   Endif
//	WinExec('DEL c:\relato_microsiga\rpcpr001.prn')    //WaitRun("DEL c:\relato_microsiga\rpcpr001.prn")

	If mv_par01 = 2 .And. mv_par04 = 1      // Impressao dos Desenhos 
		If Len(aDesenhos) > 0
			For I := 1 TO Len(aDesenhos)
				If MV_PAR08 <> "8"
					WinExec(aDesenhos[I]) //WaitRun(cDrive + ":\Plotter\Plot\plot3.bat "+aDesenhos[I])
				Else
					WaitRun(aDesenhos[I])
				Endif
			Next
		EndIf
	EndIf

EndIf


MS_FLUSH()
If MV_PAR08 <> "8"
	_lOutro   := .F.

	// Inicializa variaveis para impressao de uma nova necessidade
	
	If apmsgYesNo("*** ATENÇÃO, Deseja Imprimir Outro ***")
		Ferase("C:\Relato_Microsiga\RPCPR001.PRN")
		//***************************************
		//Ferase(cArqTrab+GetDBExtension())
		//Ferase(cArqTrab+OrdBagExt())
		//Ferase(cFilTrab+OrdBagExt())
		//Ferase(cArqTrab2+GetDBExtension())
		//Ferase(cArqTrab2+OrdBagExt())
		//***************************************
		Ferase(cFilTrab2+OrdBagExt())
		aDesenhos := {}
		_lOutro   := .T.
		_lParam   := .F.
		_lRet     := .T.
	EndIf
	If SubStr(mv_par11,1,3) == "ZZZ" .Or. SubStr(mv_par11,1,3) == "999"
		mv_par11 := Space(40)
		//	U_GravaSX1 (cPerg,"11", mv_par11)
	EndIf
Else
	Ferase("C:\Relato_Microsiga\RPCPR001.PRN")
	aDesenhos := {}
	_lOutro := .F.
Endif  

Return

//************************************
	Static Function ImpNecessidade()
//************************************

Local nTamDesc := 0

cTpCabec := "NEC"
If Li + 6 > nQtdLin
	ImpCabec()
Else
	If _lFirst
		_lFirst := .F.
	Else
		cRegTxt := Replicate("*",132)
		ImpLinha()
	EndIf
EndIf

SB1->(DbSeek(xFilial("SB1")+Alltrim(TRB->CODIG)))
//Ivandro Santos - 06/04/17 - Início da alteração
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
cDesc := Alltrim(GetAdvFval("SB5","B5_CEME",xFilial("SB5")+TRB->CODIG,1," "))
If Empty(Alltrim(cDesc))
	cDesc := Alltrim(SB1->B1_DESC)
Endif
/*If !Empty(SB1->B1_DESCP)
	cDesc := Alltrim(SB1->B1_DESCP)
Else
	cDesc := Alltrim(SB1->B1_DESC)
EndIf*/
//Ticket#2017031037000107 — Fim da alteração
cRegTxt := Alltrim(TRB->CODIG)
nBrancos := 15 - Len(cRegTxt)
If Alltrim(SB1->B1_REVATU) <> ""
	cRegTxt += Space(nBrancos) + "-  " + Alltrim(SB1->B1_REVATU)
	cRegTxt += Space(nBrancos) + "-  "
EndIf
nBrancos := 20 - Len(cRegTxt)                       
cRegTxt += Space(nBrancos) + Substr(cDesc,1,35)
nBrancos := 58 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + SB1->B1_UM

nBrancos := 62 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + SB1->B1_TIPO
nBrancos := 68 - Len(cRegTxt)
cAux :=  Transform(_nQuant,IIF(SUBSTR(cNumEmp,1,2) $ "15_40_45","@E 9,999,999.99","@E 99,999.999"))
cRegTxt += Space(nBrancos) + cAux
nBrancos := 80 - Len(cRegTxt)
cAux :=  Transform(nEmpenho,IIF(SUBSTR(cNumEmp,1,2) $ "15_40_45","@E 9,999,999.99","@E 9,999.999")) //Transform(nEmpenho,"@E 9,999.999")
cRegTxt += Space(nBrancos) + cAux

//SB2->(DbSeek(xFilial("SB2")+TRB->CODIG+"01"))
_nQLoc01 := GetAdvFVal("SB2","B2_QATU",xFilial("SB2")+TRB->CODIG+"01",1," ")
_nQLoc10 := GetAdvFVal("SB2","B2_QATU",xFilial("SB2")+TRB->CODIG+"10",1," ")
If nEmpenho > _nQuant
	nFalta := nEmpenho - _nQLoc10 - _nQLoc01
Else
	nFalta := 0
EndIf                                
// FIM DA ALTERAÇÃO - LIZANDRA -  03/09/13
nBrancos := 90 - Len(cRegTxt)
cAux :=  Transform(nFalta,IIF(SUBSTR(cNumEmp,1,2) $ "15_40_45","@E 999,999.99","@E 999,999.999")) //Transform(nFalta,"@E 9,999.999")
cRegTxt += Space(nBrancos) + cAux
cRegTxt += Space(4) + SubStr(SB1->B1_CC,1,3)
cRegTxt += Space(5) + SB1->B1_GRUPO
cRegTxt += Space(1) + Str(SB1->B1_PE,4)
If mv_par08 == "3"
	nBrancos := 121 - Len(cRegTxt)
	cAux := Transform(TRB->NECES,IIF(SUBSTR(cNumEmp,1,2) $ "15_40_45","@E 999,999.99","@E 999,999.999")) //Transform(TRB->NECES, "@E 999,999.999")
	cRegTxt += Space(nBrancos) + cAux
EndIf
If Li + 6 > nQtdLin
	ImpCabec()
EndIf
ImpLinha()
//Ivandro Santos - 23/10/17 - início da alteração: Ticket#2017102337000178 — Descrição científica no Necessidades (RPCPR001)
//Ivandro Santos - 07/11/17 - início da alteração: Ticket#2017110737000045 — RELATÓRIO NECESSIDADE
If Len(cDesc) > 35
	For nTamDesc := 36 to len(cDesc) Step 35
		If Li + 6 > nQtdLin
			ImpCabec()
		EndIf     
		cRegTxt := Space(20) + Substr(Alltrim(cDesc),nTamDesc,35)    
		ImpLinha()
	Next
Endif
//Ticket#2017110737000045 — fim da alteração
//Ticket#2017102337000178 — fim da alteração
cRegTxt := ""
ImpLinha()          


cRegTxt := ""
ImpLinha()          

If SubStr(SB1->B1_PROCED,1,1) > "1"
	If "FISCAL" $ _cDeptoUsu .Or. "COMPRAS" $ _cDeptoUsu .Or. "CONTABILIDADE" $ _cDeptoUsu .Or. "COMERCIAL" $ _cDeptoUsu ;
			.Or. "VENDA DE PECAS" $ _cDeptoUsu .Or. "INFORMATICA" $ _cDeptoUsu .Or. "PCP" $ _cDeptoUsu ;
			.Or. _cNomeUsu = "_DAmancio" .Or. _cNomeUsu == "_ADantas" .Or. _cNomeUsu = "_RSa" .Or. _cNomeUsu = "_BSilva" .Or. _cNomeUsu = "_CBarros" .Or. _cNomeUsu = "_CRabelo" // acrescentado _BSilva a pedido do Gimenes através de e-mail -  22/07/13 - Lizandra
		cRegTxt := "Ult.Compra: " + Dtoc(SB1->B1_UCOM)
		cAux    :=  Transform(SB1->B1_UPRC,"@E 999,999.99")
		cRegTxt += "    Valor: R$ "+ cAux + "  Cond. de Pagto: " + SB1->B1_CONDPG
	Else
		nCustoD := 0
		cRegTxt := "Ult.Compra: " + Dtoc(SB1->B1_UCOM)
		cAux    :=  Transform(nCustoD,"@E 999,999.99")
		cRegTxt += "    Valor: R$ "+ cAux + "  Cond. de Pagto: " + SB1->B1_CONDPG
	Endif
Else
	If "FISCAL" $ _cDeptoUsu .Or. "COMPRAS" $ _cDeptoUsu .Or. "CONTABILIDADE" $ _cDeptoUsu .Or. "COMERCIAL" $ _cDeptoUsu ;
			.Or. "VENDA DE PECAS" $ _cDeptoUsu .Or. "INFORMATICA" $ _cDeptoUsu .Or. "PCP" $ _cDeptoUsu ;
			.Or. _cNomeUsu ="_DAmancio" .Or. _cNomeUsu = "_RSa" .Or. _cNomeUsu = "_BSilva" .Or. _cNomeUsu = "_CBarros" .Or. _cNomeUsu = "_CRabelo"
		cAux    :=  Transform(SB1->B1_CUSTD,"@E 99,999.999")
		cRegTxt := "Custo de Reposicao: R$ " + cAux
	Else
		nCustoD := 0
		cAux    :=  Transform(nCustoD,"@E 99,999.999")
		cRegTxt := "Custo de Reposicao: R$ " + cAux
	EndIf
EndIf

If !Empty(SB2->B2_DINVENT)
	nBrancos := 75 - Len(cRegTxt) - 5
	cRegTxt += Space(nBrancos) + "Inventario: " + Dtoc(SB2->B2_DINVENT)
EndIf
                                 
If !Empty(SB1->B1_LOCAL)
	cRegTxt += "  Local: " + SB1->B1_LOCAL
EndIf

cRegTxt += "  Proced.: " + sb1->b1_proced

If SB1->B1_MSBLQL == "1"
	cRegTxt += "  Bloqueado"
EndIf
ImpLinha()

If !Empty(SB1->B1_ALTER)
	cRegTxt := ""
	ImpLinha()
	If SB1->(DbSeek(xFilial("SB1")+Alltrim(SB1->B1_ALTER)))
		cRegTxt := "Codigo Alternativo: " + SB1->B1_COD + " - " + SB1->B1_DESC
	Else
		cRegTxt := "Codigo Alternativo: " + SB1->B1_COD + " - Produto nao cadastrado"
	EndIf
	ImpLinha()
	SB1->(DbSeek(xFilial("SB1")+Alltrim(TRB->CODIG)))
EndIf

cRegTxt := ""                       
ImpLinha()
If (SB1->B1_ESTSEG + SB1->B1_LM + SB1->B1_LE) > 0
	cRegTxt := "Seg.: " + Str(SB1->B1_ESTSEG,6,0)
	If !Empty(SB1->B1_EMAX)
		cRegTxt += "   Max.: " + Str(SB1->B1_EMAX,6,0)
	EndIf
	If !Empty(SB1->B1_LM)
		cRegTxt += "  Lote Min.: " + Str(SB1->B1_LM,6,0)
	EndIf
	If !Empty(SB1->B1_LE)
		cRegTxt += "  Lote Econ.: " + Str(SB1->B1_LE,6,0)
	EndIf
EndIf

If !Empty(SB1->B1_FANTASM)
	If cRegTxt <> ""
		cRegTxt += Space(2)
	EndIf
	cRegTxt += "Item Fantasma? " + SB1->B1_FANTASM
Else
	cRegTxt += "Item Fantasma? N" 
EndIf

If !Empty(SB1->B1_MSAMBIE) .OR. !Empty(SB1->B1_MSGRVEN)
	If cRegTxt <> ""
		cRegTxt += Space(2)
	EndIf
	cRegTxt += "Grupo de Vendas: " + SB1->B1_MSGRVEN + "   Ambiente de Manufatura: " + SB1->B1_MSAMBIE
EndIf
ImpLinha()

If SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+"01"))
	cRegTXT := ""
	ImpLinha()
	cRegTXT := "Ultima Movimentacao: " + DTOC(SB2->B2_MSMOVIM) + "   RESERVADO PARA VENDAS: " + STR(SB2->B2_RESERVA,10,3)
	IF SB2->B2_RESERVA > 0
	   nDisponivel := _nQuant - SB2->B2_RESERVA
	   IF nDisponivel < 0
	      nDisponivel := 0
	   ENDIF
	   cRegTXT += "  *** DISPONIVEL P/SEPARACOES: " + STR(nDisponivel,10,3) + " ***"
	ENDIF   
	ImpLinha()
Endif

If !Empty(SB1->B1_MSGRPMA)
	cRegTXT := ""
	ImpLinha()
	cRegTXT := "Codigo Grupo Masipack: " + Alltrim(SB1->B1_MSGRPMA)
	ImpLinha()
EndIf

If !Empty(SB1->B1_FABRIC)
	cRegTxt := ""
	ImpLinha()
	cRegTxt := "Fabricante: "+ SB1->B1_FABRIC
	ImpLinha()
EndIf

SG1->(DbSetOrder(1))
If mv_par13 == 1 .And. SG1->(DbSeek(xFilial("SG1")+Alltrim(TRB->CODIG)))
	cTpCabec := "EST"
	If Li + 3 > nQtdLin
		ImpCabec()
	Else
		cRegCab := PADC(" E S T R U T U R A ",132,"=")
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
      IF SB1->B1_QB > 1
	      cRegTxt := ""
	      ImpLinha()
	      cRegTxt := ""
	      ImpLinha()
	      cRegTxt := PADC("Quantidade Basica: " + STR(SB1->B1_QB,6,0),132)
         ImpLinha()
	      cRegTxt := ""
	      ImpLinha()
		ENDIF   
		cRegCab := "Codigo            Descricao                       Local          Qtde.  Um  Ult.Mov.  Medidas"
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		cRegCab := Replicate("-",132)
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		Li+=3
	EndIf
	Do While !SG1->(Eof()) .And. Alltrim(SG1->G1_COD) == Alltrim(TRB->CODIG)
		cLF_SD4 := ""
		SD4->(DBSetOrder(1))
		SD4->(DBGoTop())
		SD4->(DbSeek(xFilial("SD4")+Alltrim(SG1->G1_COMP)))
		Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_COD) == Alltrim(SG1->G1_COMP) .And. cEmpAnt $ "01|10"
			_cOPFin := DTOS(GetAdvFVal("SC2","C2_DATRF",xFilial("SD4")+SD4->D4_OP,1," "))
			If SD4->D4_QUANT > 0 .And. SD4->D4_MSLF == "X" .And. Empty(_cOPFin)
				cLF_SD4 := "X"
			EndIf
			SD4->(DbSkip())
		EndDo
		If SB1->(DbSeek(xFilial("SB1")+Alltrim(SG1->G1_COMP)))
			cRegTxt  := SG1->G1_COMP
			nBrancos := 15 - Len(cRegTxt)
			If SB1->B1_FANTASM == "S"
				cRegTxt += Space(nBrancos) + "F "
			Else
				cRegTxt += Space(nBrancos + 2)
			EndIf
			If Alltrim(SB1->B1_REVATU) <> ""
				cRegTxt += "-" + Alltrim(SB1->B1_REVATU)+ Space(1) + SubStr(SB1->B1_DESC,1,27)
			Else
				cRegTxt += Space(3) + SubStr(SB1->B1_DESC,1,27)
			EndIf
			cRegTxt += Space(2) + SB1->B1_LOCAL
			nBrancos := 60 - Len(cRegTxt)
			cAux     := Transform(SG1->G1_QUANT,"@E 999,999.999")
			cRegTxt  += Space(nBrancos) + cAux
			cRegTxt  += Space(2) + SB1->B1_UM
			dDtMov := CTOD(Space(8))
			SB2->(DbSetOrder(1))
			If SB2->(DbSeek(xFilial("SB2")+SG1->G1_COMP+"01"))
				dDtMov := SB2->B2_MSMOVIM
			EndIf
			If !Empty(dDtMov)
				cRegTxt += Space(1) + DTOC(dDtMov)
			Else
				cRegTxt += Space(9)
			EndIf
			cRegTxt  += Space(1) + SubStr(SG1->G1_OBSERV,1,28)
			nBrancos := 115 - Len(cRegTxt)
			cRegTxt  += Space(nBrancos) + "Est.: "
			cAux     :=  Transform(SB2->B2_QATU,IIF(SUBSTR(cNumEmp,1,2) $ "15_40_45","@E 9,999,999.99","@E 99,999.999"))
			cRegTxt  += cAux + " " + cLF_SD4
			If Li > nQtdLin
				ImpCabec()
			EndIf
			ImpLinha()
		EndIf
		SG1->(DbSkip())
		Loop
	EndDo
	SB1->(DbSeek(xFilial("SB1")+Alltrim(TRB->CODIG)))
EndIf

Cabec1 := ""
SG2->(DbSetOrder(1))
SH1->(DbSetOrder(1))
If mv_par24 == 1 .And. SG2->(DbSeek(xFilial("SG2")+TRB->CODIG))
	cTpCabec := "OPER"
	If Li + 3 > nQtdLin
		ImpCabec()
	Else
		cRegCab := PADC(" O P E R A C O E S ",132,"=")
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		cRegCab := "Recurso   Descricao                       Programa / Obs."
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		cRegCab := Replicate("-",132)
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		Li+=3
	EndIf
	Do While ! SG2->(Eof()) .And. SG2->G2_PRODUTO == TRB->CODIG
		cRegTxt := SG2->G2_RECURSO
		If SH1->(DbSeek(xFilial("SH1")+SG2->G2_RECURSO))
			nBrancos := 10 - Len(cRegTxt)
			cRegTxt += Space(nBrancos) + SH1->H1_DESCRI
			nBrancos := 42 - Len(cRegTxt)
			cRegTxt += Space(nBrancos) + Alltrim(SG2->G2_MSPROG) + If(!Empty(SG2->G2_MSOBS)," / " + Alltrim(SG2->G2_MSOBS),"")
		EndIf
		If Li > nQtdLin
			ImpCabec()
		EndIf
		ImpLinha()
		SG2->(DbSkip())
		Loop
	EndDo
EndIf

IF MV_PAR28 == 1 // ALTERADO 24/05/13 - LIZANDRA
	nSaldo  := _nQuant - SB1->B1_ESTSEG
ELSE	
	nSaldo  := _nQuant
ENDIF	
cRegTxt := ""
ImpLinha()
EXT->(dbGoTop())
If EXT->(RecCount()) > 0
	cTpCabec := "EXT"
	If Li + 5 > nQtdLin
		ImpCabec()
	Else
		cRegCab := PADC(" E X T R A T O    D O S    M O V I M E N T O S ",132,"=")
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		cRegCab := "Documento        Codigo              Descricao                      Qtde. Cliente/Forn.   Pedido Entrega Prev. Refer.       Saldo F"
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		cRegCab := Replicate("-",132)
		FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
		Li+=3
	EndIf
	dDataNec := CTOD("30/11/29")
	dDataRem := CTOD("30/11/29")
	cLF      := ""
	Do While ! EXT->(EOF())                             
		ImpExtrato()
		EXT->(DbSkip())
		Loop
	EndDo
EndIf

cRegTxt := ""
ImpLinha()
SA5->(DbSetOrder(2))
If mv_par22 == 1 .And. SA5->(DbSeek(xFilial("SA5")+TRB->CODIG))
	cTpCabec := ""
	If Li + 3 > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := PADC(" F O R N E C E D O R E S ",132,"=")
	ImpLinha()
	Do While !SA5->(EOF()) .And. SA5->A5_PRODUTO == TRB->CODIG
		cRegTxt := SA5->A5_FORNECE + "/" + SA5->A5_LOJA
		If SA2->(DbSeek(xFilial("SA2")+SA5->A5_FORNECE))
			nBrancos := 12 - Len(cRegTxt)
			cRegTxt += Space(nBrancos) + Alltrim(SA2->A2_NREDUZ) + " - " + Alltrim(SA2->A2_NOME) + " - Fone: " + Alltrim(SA2->A2_TEL) + " - Contato: " + Alltrim(SA2->A2_CONTATO)
		Else
			cRegTxt += Space(nBrancos) + "Fornecedor nao cadastrado"
		EndIf
		ImpLinha()
		If Li > nQtdLin
			ImpCabec()
			cRegTxt := PADC(" F O R N E C E D O R E S ",132,"=")
			ImpLinha()
		EndIf
		SA5->(DbSkip())
		Loop
	EndDo
EndIf
Return

//********************************
	Static Function ImpExtrato()
//********************************

SZS->(DbSetOrder(2))
SZS->(DbGoTop())

cTpCabec := "EXT"
If EXT->MOVIM <> "X"
	nSaldo := nSaldo + EXT->QUANT
EndIf
cRegTxt := EXT->DOCUM + If(Empty(EXT->ITEM),Space(4),"/" + EXT->ITEM)
nBrancos := 17 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + EXT->CODIG
If !Empty(EXT->MODIF)
	cRegTxt += Space(1) + "-" + EXT->MODIF
Else
	cRegTxt += Space(4)
EndIf

cRegTxt += Space(1) + SubStr(EXT->DESCR,1,21)
cAux :=  Transform(EXT->QUANT,IIF(SB1->B1_UM <> "PC","@E 999,999.999","@E 9,999,999"))
cRegTxt += Space(4) + cAux	//2
cRegTxt += Space(1) + Substr(EXT->PESSOA,1,15)
If !Empty(EXT->PV)
	cRegTxt += Space(1) + EXT->PV
	cRegTxt += Space(1) + "(" + SubStr(Dtoc(EXT->ENTPV),1,5) + ")"
Else
	cRegTxt += Space(15)
EndIf
cRegTxt += Space(1) + SubStr(Dtoc(EXT->ENTREGA),1,5)
cRegTxt += Space(1) + SubStr(EXT->REFER,1,6)
cAux :=  Transform(nSaldo,"@E 9,999,999.999")
cRegTxt += Space(1) + cAux
cRegTxt += Space(1) + EXT->FALTA
If EXT->MOVIM <> "X"
	If nSaldo < 0
		If dDataNec > EXT->ENTREGA
			dDataNec := EXT->ENTREGA
		EndIf
		If dDataRem > EXT->ENTREGA
			dDataRem := EXT->ENTREGA
		EndIf
	Else
		If EXT->ENTREGA > dDataNec
			dDataNec := CTOD("30/11/29")
		EndIf
	EndIf
EndIf

If SubStr(EXT->FALTA,1,1) == "X"
	cLF := "X"
EndIf
If Li > nQtdLin
	ImpCabec()
EndIf
ImpLinha()
_cDescBl:=""
If !Empty(EXT->RESERVA)
	If Li > nQtdLin
		ImpCabec()
	EndIf   
	IF EMPTY(ext->Bloqueio)
		_cDescBl:= "LIBERADO PARA FATURAMENTO"
	ELSEIF ext->Bloqueio == "02  "	 
		_cDescBl:= "BLOQUEIO DE ESTOQUE"
	ELSEIF ext->Bloqueio == "  01"	 
		_cDescBl:= "BLOQUEIO DE CREDITO"
	ELSEIF ext->Bloqueio == "0201"	 
		_cDescBl:= "BLOQUEIO DE ESTOQUE/CREDITO"    
	ENDIF
		
	cRegTxt := Space(37) + "Status: " + _cDescBl
	
	If EXT->ITEMSEP == "S"
		cRegTxt := ALLTRIM(cRegTxt) + " - item já Separado"
	EndIf
	ImpLinha()
EndIf

If !Empty(EXT->CATEG)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "Categoria: " + Alltrim(EXT->CATEG)
	IF EXT->CATEG == "2"
	   cRegTxt += " - Empenho para pedido do COMEX"
	ELSEIF EXT->CATEG == "3"
	   cRegTxt += " - Empenho para pedido de VENDA DE PECAS"
	ELSEIF EXT->CATEG == "5"
	   cRegTxt += " - Empenho para pedido de TERCEIROS"
	ELSEIF EXT->CATEG == "6"
	   cRegTxt += " - Empenho para pedido de ASSITÊNCIA TÉCNICA"
	ENDIF	   
	ImpLinha()
EndIf




If !Empty(EXT->OBS)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "Obs.: " + Alltrim(EXT->OBS)
	ImpLinha()
EndIf

If !Empty(EXT->NUMSC)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "SC: " + EXT->NUMSC + "/" + EXT->ITEMSC + " - Emitente: " + ALLTRIM(EXT->EMITENTE)
	ImpLinha()
	cRegTxt := Space(37) + "Emissao da SC: " + DTOC(EXT->EMIS_SC) + " - Entrega da SC: " + DTOC(EXT->ENTR_SC) + " - Retorno do Fornecedor: " + EXT->RETFOR
	ImpLinha()
Else
	If !Empty(EXT->EMITENTE)
		If Li > nQtdLin
			ImpCabec()
		EndIf
		cRegTxt := Space(37) + "Emitente: " + EXT->EMITENTE
		ImpLinha()
	EndIf
EndIf

If !Empty(EXT->APROP)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "Aprop.: " + EXT->APROP
	ImpLinha()
EndIf
//Ticket#2017062837000141 — Novos campos no SC7 para aparecer no Necessidades
If !Empty(EXT->PAGAM)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "Pagar a vista: " + IIF(EXT->PAGAM=="S","Sim","Não") +IIF(EXT->PAGAM=="S"," - Pago em: "+ DTOC(EXT->DATA_PAG),"")
	ImpLinha()
Endif
//Ticket#2017062837000141 — Fim da alteração
If !Empty(EXT->COTACAO)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "Cotacao: " + EXT->COTACAO
	sc8->(DBSetOrder(3))
	sc8->(DBGOTOP())
	IF sc8->(DBSEEK(xFilial("SC8") + ALLTRIM(ext->cotacao) + ext->codig))
		cRegTxt += " - Gerada em: " + DTOC(sc8->c8_emissao)
	ENDIF
	ImpLinha()
EndIf

If !Empty(EXT->QDE_ERRO)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "Divergencia(s) com a SC ->"
	If !Empty(EXT->QDE_ERRO)
		cAux :=  Transform(EXT->QDE_ERRO,"@E 9999.9999")
		cRegTxt += "   Qtde: " + cAux
	EndIf
	ImpLinha()                                          
EndIf

IF !EMPTY(EXT->CI) .OR. !EMPTY(EXT->DATA_CI)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "CI: " + EXT->CI + " de " + DTOC(EXT->DATA_CI)
	Implinha()
ENDIF

If !Empty(EXT->EMISSAO) .OR. !Empty(EXT->IMPRES) .OR. !Empty(EXT->INICIO) .OR. !Empty(EXT->MSREUNI)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	cRegTxt := Space(37) + "Emissao OP: " + DTOC(EXT->EMISSAO) + IF(!EMPTY(EXT->IMPRES)," - Impressao: " + DTOC(EXT->IMPRES),"") + IF(!EMPTY(EXT->INICIO)," - Inicio Efet.: " + DTOC(EXT->INICIO),"") +  IF(!EMPTY(EXT->IMPRES)," - Fim Efet.: " + DTOC(EXT->FIM),"")
//	cRegTxt := Space(37) + "Emissao OP: " + DTOC(EXT->EMISSAO) + IF(!EMPTY(EXT->MSREUNI),"   Monitorado em: " + DTOC(EXT->MSREUNI), "") +IF(!EMPTY(EXT->INICIO)," - Inicio Efet.: " + DTOC(EXT->INICIO),"") + IF(!EMPTY(EXT->IMPRES)," - Impressao: " + DTOC(EXT->IMPRES),"") + IF(!EMPTY(EXT->IMPRES)," - Fim Efet.: " + DTOC(EXT->FIM),"")
	ImpLinha()
EndIf

IF !EMPTY(EXT->PRE_NOTA)
	If Li > nQtdLin
		ImpCabec()
	EndIf                 
	dbSelectArea("SD1")
	SD1->(dbSetOrder(22))	//D1_FILIAL+D1_PEDIDO+D1_ITEMPC
	
		If SD1->(DbSeek(xFilial("SD1")+SubStr(EXT->DOCUM,1,6)+"0"+EXT->ITEM))  

			DO WHILE SD1->D1_PEDIDO + SD1->D1_ITEMPC == SubStr(EXT->DOCUM,1,6)+"0"+EXT->ITEM .AND. !SD1->(EOF())
				IF EMPTY(SD1->D1_TES)
					EXIT
				ENDIF
				SD1->(dbSkip())
			ENDDO
					
			If SUBSTR(SD1->D1_MSOBS,1,1)=="S"
				cRegTxt := Space(37) + "*** PRE-NOTA LANCADA EM: " + DTOC(SD1->D1_DTDIGIT) + " - AGUARDANDO LANCAMENTO DA NF ***"
		   Else
		   	cRegTxt := Space(37) + "*** XML LANÇADO em " + DTOC(SD1->D1_DTDIGIT) 
		   EndIf
		Else
			cRegTxt := Space(37) + "*** PRE-NOTA LANCADA EM: " + DTOC(Date()) + " - AGUARDANDO LANCAMENTO DA NF ***"
		EndIf
	
	Implinha()
ENDIF

If !Empty(EXT->GRPMASI)
	cRegTxt := Space(37) + "Codigo Grupo Masipack: " + EXT->GRPMASI
	ImpLinha()
EndIf

If !Empty(EXT->POSIC)
	If Li > nQtdLin
		ImpCabec()
	EndIf
	
	cRegTxt := Space(37) + "Posicao: " + EXT->POSIC
	ImpLinha()
	cAux := ""
	If SZS->(DbSeek(xFilial("SZS")+Alltrim(EXT->DOCUM)))
		Do While SZS->(!Eof()) .And. Alltrim(SZS->ZS_OP) == Alltrim(EXT->DOCUM)
			cAux := DTOC(SZS->ZS_DATA) + " - Hora: " + SZS->ZS_HORA + " Por: " + Alltrim(SZS->ZS_USUARIO)
			SZS->(DbSkip())
		EndDo
	EndIf
	If !Empty(cAux)
		cRegTxt := Space(37) + "Ultimo Apontamento: " + cAux
		ImpLinha()
	EndIf
EndIf

Return

//*******************************
	Static Function Intervalo()
//*******************************

Local lRetorno  := .T.

If mv_par08 == "4" .And. cEmpAnt $ "01|10"
	If Alltrim(SD4->D4_MSREFER) <> mv_par10
		lRetorno := .F.
	Endif
Else
	If SD4->D4_DATA >= mv_par18 .And. SD4->D4_DATA <= mv_par19 .And. cEmpAnt $ '01|10'
		SC2->(DbSeek(xFilial("SC2")+Alltrim(SD4->D4_OP)))
		If !Empty(mv_par20) .And. ! (Alltrim(mv_par20) $ Alltrim(SC2->C2_MSREDUZ))
			lRetorno := .F.
		EndIf
	Else
		lRetorno := .F.
	EndIf
EndIf
Return lRetorno

//******************************
	Static Function ImpParam()
//******************************
_nPag := 0
Li := 0
cTpCabec := "PAR"

If mv_par01 == 2 .And. mv_par02 == 1
  	cRegTxt :=  "@PJL SET LMULTIPAGEPRINT =  2UP"+CHR(10)
  	FWrite(cArqTxt,cRegTxt)
EndIf

If mv_par25 == 1
	//cRegCSV := ";;;;;Emissão: " + DTOC(Date())
	If SubStr(cNumEmp,1,2) == "01"
		cRegCSV := ";;;;;Emissão: " + DTOC(Date())+ " - Masipack"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	ElseIf SubStr(cNumEmp,1,2) == "10"
		cRegCSV := ";;;;;Emissão: " + DTOC(Date())+ " - Fabrima"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	ElseIf SubStr(cNumEmp,1,2) == "40"
		cRegCSV := ";;;;;Emissão: " + DTOC(Date())+ " - Labortube"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	ElseIf SubStr(cNumEmp,1,2) == "45" 
		cRegCSV := ";;;;;Emissão: " + DTOC(Date())+ "  - MEMB "
		//cRegCSV += " - MEMB "
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	EndIf
	
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	cRegCSV := ";;;;;Periodo: " + DTOC(mv_par18) + " a " + DTOC(mv_par19)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

EndIf

ImpCabec()
cRegTxt := "***  PARAMETROS SOLICITADOS PELO USUARIO  ***"
ImpLinha()
cRegTxt := ""
ImpLinha()
cRegTxt := "Imprime 2 folhas em 1: "
cRegCSV := ";;;;;Imprime 2 folhas em 1: "
If mv_par02 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt += "Nao"
	cRegCSV += "Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
cRegTxt += "   Imprime 1 codigo por pagina: "
cRegCSV := ";;;;;Imprime 1 codigo por pagina: "
If mv_par03 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt += "Nao"
	cRegCSV += "Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + "Imprime desenhos: "
cRegCSV := ";;;;;Imprime desenhos: "
If mv_par04 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt += "Nao"
	cRegCSV += "Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
If mv_par04 == 1
	cRegTxt += "  Qtde.: " + Str(mv_par05,1)
	cRegCSV := ";;;;;Qtde.Desenhos: " + Str(mv_par05,1)
	cRegTxt += "  Drive: " + MV_PAR06
	cRegCSV += "  -  Drive: " + MV_PAR06

	If mv_par25 == 1
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	EndIf

EndIf
ImpLinha()
Do Case
	Case mv_par08 == "1"
		cRegTxt := "Codigo: " + mv_par10 + " ao " + mv_par11
		cRegCSV := ";;;;;Codigo: " + mv_par10 + " ao " + mv_par11
	Case mv_par08 == "2"
		SB1->(DbSeek(xFilial("SB1")+mv_par10))
		cRegTxt := "Estrutura: "  + mv_par10 + "- "+ SB1->B1_DESC + "  Data: "+Substr(DTOS(mv_par12),7,2)+"/"+Substr(DTOS(mv_par12),5,2)+"/"+Substr(DTOS(mv_par12),1,4)+ " "
		cRegCSV := cRegTxt := ";;;;;Estrutura: "  + mv_par10 + "- "+ SB1->B1_DESC
	Case mv_par08 $ "3_8"
		cRegTxt := "Arquivo: " + mv_par10
		cRegCSV := ";;;;;Arquivo: " + mv_par10
	Case mv_par08 == "4"
		cRegTxt := "Referencia: " + mv_par10
		cRegCSV := ";;;;;Referencia: " + mv_par10
	Case mv_par08 == "5"
		cRegTxt := "OP: " + mv_par10
		cRegCSV := ";;;;;OP: " + mv_par10
	Case mv_par08 == "6"
		cRegTxt := "Pedido(s):" + mv_par10
		cRegCSV := ";;;;;Pedido(s):" + mv_par10
	Case mv_par08 == "7"
		cRegTxt := "Orçamento(s):" + mv_par10
		cRegCSV := ";;;;;Orçamento(s):" + mv_par10
EndCase
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + "Periodo: " + DTOC(mv_par18) + " a " + DTOC(mv_par19)
ImpLinha()
cRegTxt := "Necessidade: "
cRegCSV := ";;;;;Necessidade: "
Do Case
	Case mv_par09 == "1"
		cRegTxt += "Empenho > Estoque"
		cRegCSV += "Empenho > Estoque"
	Case mv_par09 == "2"
		cRegTxt += "Geral"
		cRegCSV += "Geral"
	Case mv_par09 == "3"
		cRegTxt += "Saldo = 0"
		cRegCSV += "Saldo = 0"
	Case mv_par09 == "4"
		cRegTxt += "Empenho <> 0"
		cRegCSV += "Empenho <> 0"
	Case mv_par09 == "5"
		cRegTxt += "Est.Segurança"
		cRegCSV += "Est.Segurança"
	Case mv_par09 == "6"
		cRegTxt += "Saldo > Empenho"
		cRegCSV += "Saldo > Empenho"
	Case mv_par09 == "7"
		cRegTxt += "Empenho > Estoque+OP+SC+PC"
		cRegCSV += "Empenho > Estoque+OP+SC+PC"
	Case mv_par09 == "8"
		cRegTxt += "Empenho < Estoque+OP+SC+PC"
		cRegCSV += "Empenho < Estoque+OP+SC+PC"
	Case mv_par09 == "8"
		cRegTxt += "Empenho > Estoque
		cRegCSV += "Empenho > Estoque
EndCase
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + "Quais Itens: "
cRegCSV := Space(nBrancos) + ";;;;;Quais Itens: "
Do Case
	Case mv_par07 == 1
		cRegTxt += "Pecas"
		cRegCSV += "Pecas"
	Case mv_par07 == 2
		cRegTxt += "Conjuntos"
		cRegCSV += "Conjuntos"
	Case mv_par07 == 3
		cRegTxt += "Pecas e Conjuntos"
		cRegCSV += "Pecas e Conjuntos"
EndCase
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
ImpLinha()
cRegTxt :=  "Local: " + mv_par15
cRegCSV :=  ";;;;;Local: " + mv_par15
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + "Com suas Estruturas: "
cRegCSV := ";;;;;Com suas Estruturas: "
If mv_par13 == 1
	cRegTxt += "Sim  - Data: " + DTOC(mv_par12)
	cRegCSV += "Sim  - Data: " + DTOC(mv_par12)
Else
	cRegTxt += "Nao"
	cRegCSV += "Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
ImpLinha()
cRegTxt := "Procedencia: "
cRegCSV := ";;;;;Procedencia: "
Do Case
	Case mv_par14 == 1
		cRegTxt += "Fabricados"
		cRegCSV += "Fabricados"
	Case mv_par14 == 2
		cRegTxt += "Comprados "
		cRegCSV += "Comprados "
	Case mv_par14 == 3
		cRegTxt += "Geral     "
		cRegCSV += "Geral     "
EndCase
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
cRegTxt += Space(15) + "Grupo: " + mv_par16
cRegCSV := ";;;;;Grupo: " + mv_par16
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + "Centro de Custo: " + mv_par17
cRegCSV := Space(nBrancos) + ";;;;;Centro de Custo: " + mv_par17
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
cRegTxt += "Imprime codigos MP,TS e MOD: "
cRegCSV := ";;;;;Imprime codigos MP,TS e MOD: "
If mv_par21 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt += "Nao"
	cRegCSV += "Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
ImpLinha()
cRegTxt := "Imprime fornecedores.: "
cRegCSV := ";;;;;Imprime fornecedores: "
If mv_par22 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt +="Nao"
	cRegCSV +="Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) + "Imprime operacoes: "
cRegCSV := ";;;;;Imprime operações: "
If mv_par24 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt += "Nao"
	cRegCSV += "Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
ImpLinha()
cRegTxt := "Fornecedor especifico: " + cFornec
cRegCSV := ";;;;;Fornecedor especifico: " + cFornec
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) +  "Quais Materiais: "
cRegCSV := ";;;;;Quais Materiais: "
If mv_par27 == 1
	cRegTxt += "Produtivos"
	cRegCSV += "Produtivos"
ElseIf mv_par27 == 2
	cRegTxt +="Nao Produtivos"
	cRegCSV +="Não Produtivos"
Else
	cRegTxt += "Ambos"
	cRegCSV += "Ambos"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
ImpLinha()
If mv_par01 == 1
	cRegTxt := "Imprime: Video"
	cRegCSV := ";;;;;Imprime: Video"
Else
	cRegTxt := "Imprime: Impressora"
	cRegCSV := ";;;;;Imprime: Impressora"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
cRegTxt += Space(24)+"Gera planilha: "
cRegCSV := ";;;;;Gera planilha: "
If mv_par25 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt +="Nao"
	cRegCSV +="Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
nBrancos := 68 - Len(cRegTxt)
cRegTxt += Space(nBrancos) +  "Posicao de Lista: "
cRegCSV := ";;;;;Posição de Lista: "
If mv_par26 == 1
	cRegTxt += "Sim"
	cRegCSV += "Sim"
Else
	cRegTxt += "Nao"
	cRegCSV += "Nao"
EndIf
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
ImpLinha()
cRegTxt := "Cliente: " + mv_par20
cRegCSV := ";;;;;Cliente: " + mv_par20
If mv_par25 == 1
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf
ImpLinha()
cRegTxt := Replicate("=",132)
ImpLinha()
cRegTxt := "Codigo              Descricao                             UM  TM      Estoque        N.B.      N.L. CCusto  Grupo  Prazo     Real"
ImpLinha()
cRegTxt := Replicate("=",132)
ImpLinha()
If mv_par25 == 1
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	If SubStr(cNumEmp,1,2) == "01"

		//VICTOR DESSUNTE - 19/04/16
		//INICIO - TICKET: 2017041737000085
		If _cNomeUsu == "RWada"
			cRegCSV := "Codigo;Rev.;Gr.Vendas;LF;Bloq.;Descrição;UM;Custo;Quantidade;Inventario;Ult.Compra;Ult.Movim.;Consumo;Local;Fantasma;CC;Procedencia;Grupo;Prazo Entrega;Est. Segurança;Estoque;Empenho;OP Efetiva;OP Prevista;SC;PC;Devolução;Tenho;Preciso;Lote Mínimo;Lote Economico;Até;Remanejar;Amb. Manufatura;Peso;Descrição Prolongada;Dt.Lote;Res.Comp.;Analisado;Qtas.Vezes;Fabricante;Forn.01;Forn.02;Forn.03;Forn.04;Forn.05;Forn.06;Forn.07;Forn.08;Forn.09;Forn.10"
		Else
			cRegCSV := "Codigo;Rev.;Gr.Vendas;LF;Bloq.;Descrição;UM;Custo;Inventario;Ult.Movim.;Consumo;Local;Fantasma;CC;Procedencia;Grupo;Prazo Entrega;Est. Segurança;Estoque;Empenho;OP Efetiva;OP Prevista;SC;PC;Devolução;Tenho;Preciso;Lote Mínimo;Lote Economico;Até;Remanejar;Amb. Manufatura;Peso;Descrição Prolongada;Dt.Lote;Res.Comp.;Analisado;Qtas.Vezes;Fabricante;Forn.01;Forn.02;Forn.03;Forn.04;Forn.05;Forn.06;Forn.07;Forn.08;Forn.09;Forn.10"
		EndIf
		//FIM - TICKET: 2017041737000085
		
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	Else
		cRegCSV := "Codigo;Rev.;Gr.Vendas;LF;Bloq.;Descrição;UM;Custo;Inventario;Ult.Movim.;Consumo;Local;Fantasma;CC;Procedencia;Grupo;Prazo Entrega;Est. Segurança;Estoque;Empenho;OP Efetiva;OP Prevista;SC;PC;Devolução;Tenho;Preciso;Lote Mínimo;Lote Economico;Até;Remanejar;Amb. Manufatura;Peso;Descrição Prolongada;Dt.Lote;Res.Comp.;Fabricante;Forn.01;Forn.02;Forn.03;Forn.04;Forn.05;Forn.06;Forn.07;Forn.08;Forn.09;Forn.10"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	EndIf	
EndIf
_lFirst := .T.
If _lGera
	SZA->(DbSetOrder(1))
	RecLock("SZA",.T.)
	SZA->ZA_FILIAL  := "01"
	SZA->ZA_DATA    := Date()
	SZA->ZA_HORA    := cHora
	SZA->ZA_USUARIO := _cNomeUsu
	SZA->ZA_OPCOES  := mv_par08 + "/" + mv_par09
	If mv_par07 == 1
		SZA->ZA_TIPO := "PC"
	ElseIf mv_par07 == 2
		SZA->ZA_TIPO = "CJ"
	ElseIf mv_par07 == 3
		SZA->ZA_TIPO := "PC/CJ"
	EndIf
	SZA->ZA_COD_DE  := Alltrim(mv_par10)
	SZA->ZA_COD_ATE := Alltrim(mv_par11)
	SZA->ZA_DTESTRU := mv_par12
	If mv_par13 == 1
		SZA->ZA_ESTRUT  := "S"
	ElseIf mv_par13 == 2
		SZA->ZA_ESTRUT  := "N"
	EndIf
	If mv_par14 == 1
		SZA->ZA_PROCED := "Fabricados"
	Elseif mv_par14 == 2
		SZA->ZA_PROCED := "Comprados"
	ElseIf mv_par14 == 3
		SZA->ZA_PROCED := "Geral"
	EndIf
	SZA->ZA_LOCAL     := mv_par15
	SZA->ZA_GRUPO     := mv_par16
	SZA->ZA_CCUSTO    := mv_par17
	SZA->ZA_DATADE    := mv_par18
	SZA->ZA_DATAATE   := mv_par19
	SZA->ZA_CLIENTE   := mv_par20
	If mv_par21 == 1
		SZA->ZA_MPTSMOD  := "S"
	ElseIf mv_par21 == 2
		SZA->ZA_MPTSMOD  := "N"
	EndIf
	If mv_par27 == 1
		SZA->ZA_QUAIS    :=  "Produtivos"
	ElseIf mv_par27 == 2
		SZA->ZA_QUAIS    := "Nao Produtivos"
	ElseIf mv_par27 == 3
		SZA->ZA_QUAIS    := "Ambos"
	EndIf
	SZA->(MsUnlock())
EndIf
Return

//********************************
	Static Function _fExplode()
//********************************

cNomeArq := Estrut2(cProduto,1)
ESTRUT->(DbGotop())

Do While !ESTRUT->(Eof())
	If !TRB->(Dbseek(ESTRUT->COMP))
		RecLock("TRB",.T.)
		TRB->CODIG := ESTRUT->COMP
		TRB->NECES := ESTRUT->QUANT
	Else
		RecLock("TRB",.F.)
		TRB->NECES  += ESTRUT->QUANT
	EndIf
	TRB->(MsUnlock())
	ESTRUT->(DbSkip())
EndDo

dbSelectArea("ESTRUT")
If RecCount() > 0
	Zap
EndIf

Return

//********************************
	Static Function ImpCabec()
//********************************

_nPag++
Li := 0
cRegCab := chr(12)
FWrite(cArqTxt,cRegCab)
cRegCab := Replicate("=",132)
FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
SM0->(DbSetOrder(1))
SM0->(DbSeek(SubStr(cNumEmp,1,2)))
cRegCab := Alltrim(SM0->M0_NOMECOM)
nBrancos := 112 - Len(cRegCab)
cRegCab += Space(nBrancos) + "Data: "+DTOC(Date())
FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
cRegCab := NomeProg + Space(44) + titulo
nBrancos := 112 - Len(cRegCab)
cRegCab += Space(nBrancos) + "Pag.: "+ Str(_nPag,4)
FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
cRegCab := Replicate("=",132)
FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
cRegCab := ""
FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
Li+=5
If cTpCabec == "NEC"
	cRegCab := "Codigo              Descricao                             UM  TM      Estoque        N.B.      N.L. CCusto  Grupo  Prazo     Real"
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	cRegCab := Replicate("=",132)
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	Li+=2
ElseIf cTpCabec == "EST"
	cRegCab := PADC(" E S T R U T U R A ",132,"=")
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
   IF SB1->B1_QB > 1
      cRegTxt := ""
      ImpLinha()
      cRegTxt := ""
      ImpLinha()
      cRegTxt := PADC("Quantidade Basica: " + STR(SB1->B1_QB,6,0),132)
      ImpLinha()
      cRegTxt := ""
      ImpLinha()
	ENDIF   
	cRegCab := "Codigo            Descricao                       Local          Qtde.  Um  Ult.Mov.  Medidas"
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	cRegCab := Replicate("-",132)
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	Li+=3
ElseIf cTpCabec == "EXT"
	cRegCab := PADC(" E X T R A T O    D O S    M O V I M E N T O S ",132,"=")
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	cRegCab := "Documento        Codigo              Descricao                      Qtde. Cliente/Forn.   Pedido Entrega Prev. Refer.       Saldo F"
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	cRegCab := Replicate("-",132)
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	Li+=3
ElseIf cTpCabec == "OPER"
	cRegCab := PADC(" O P E R A C O E S ",132,"=")
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	cRegCab := "Recurso   Descricao                       Programa / Obs."
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	cRegCab := Replicate("-",132)
	FWrite(cArqTxt,cRegCab+chr(13)+chr(10))
	Li+=3
EndIf
Return

//*****************************
	Static Function ImpLinha()
//*****************************
FWrite(cArqTxt,cRegTxt+chr(13)+chr(10))
Li++
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

Return cNome
 