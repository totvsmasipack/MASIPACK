#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} RFATR004
//TODO Relacao de Pedidos a Faturar 
@author Aparecida de F.Stevanato
@since 15/03/2005
@version 1.0
@return nil
@type function
/*/
User Function RFATR004()

	Private _cUsuario   := RetCodUsr()
	Private titulo      := "Relacao de Pedidos a Faturar"
	Private cString     := "SC5"
	Private tamanho     := "G"
	Private wnrel       := "RFATR004"
	Private aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 } 
	Private nomeprog    := "RFATR004"
	Private cPerg       := "XRFATR004 "
	Private cArqTrab    := ""
	Private cArqTrab2	:= ""
	Private cFilTrab    := ""
	Private nLastKey    := 0 	
	Private cInd1       := ""
	Private cInd2       := ""
	Private cInd3       := ""
	Private cInd4       := ""
	Private cInd5       := ""
	Private cInd6       := ""
	Private cInd7       := ""

	Private CbTxt       := ""
	Private cabec1      := ""
	Private cabec2      := ""
	Private limite      := 220
	Private CbCont      := 0
	Private nOrdem      := 0	
	Private nTotQtde    := 0
	Private nTotValor   := 0
	Private nTotSaldo   := 0
	Private nValor      := 0
	Private nCont       := 0
	Private nGarant     := 0
	Private cVisita     := ""
	Private cMulta      := ""
	Private cNomeVend   := ""
	Private cNomePais   := ""
	Private cCondPgto   := ""
	Private cPais       := ""
	Private cPosPed     := ""
	Private cPend       := ""
	Private cLink       := ""
	Private cObs        := ""  
	Private lPrim       := .T.
	Private cPedAnt     := ""
	Private cCategAnt   := ""
	Private cProdAnt    := ""
	Private cCliAnt     := ""
	Private dDtMonta    := CTOD("") 
	Private dDtPecas    := CTOD("")
	Private dtEntr		  := CTOD("")
	Private dtEntrAnt   := CTOD("")
	Private cVendAnt    := ""
	Private dDtEmiAnt   := CTOD("")
	Private cNomCliAnt  := ""
	Private cNomVendAnt := ""
	Private cItemAnt    := ""
	Private cDescAnt    := ""
	Private nB2Qatu	  := 0
	Private nB2QatuAnt  := 0
	Private nItens      := 0
	Private nCol        := 0
	Private cArqCSV     := "C:\Relato_Microsiga\Pedidos_a_faturar.csv"
	Private cRegCSV     := ""
	Private cDeptoUsu   := ""
	Private aUsuario 	  := {}
	Private cPedCSV     := ""
	Private cNumOP      := ""  
	Private lEvento     := .F.
	Private nMontaPV    := 0
	Private lLogCom     := .F.
	Private lLogEng     := .F.
	Private lLogProd    := .F.
	Private lLogMont    := .F.
	Private lLogTest    := .F.
	Private _nLogs      := 0
	Private dDtAux		  := CTOD("")
	Private _nQtdMaq	  := 0
	Private	_cAno		  := ""
	Private _cMes	 	  := ""
	Private _cTipo		  := ""


	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		aUsuario  := PswRet()
		cDeptoUsu := Upper(Alltrim(aUsuario[1][12]))
	EndIf 

	//******************************************************************
	//³ Variaveis utilizadas para parametros
	//³ mv_par01				// Do Pedido
	//³ mv_par02				// Ate o Pedido
	//³ mv_par03				// Do Produto
	//³ mv_par04				// Ate o Produto
	//³ mv_par05				// Do Cliente
	//³ mv_par06				// Ate o cliente
	//³ mv_par07				// Da data de entrega
	//³ mv_par08				// Ate a data de entrega
	//³ mv_par09				// Imprime Concluidos - Sim, Não e Ambos
	//³ mv_par10				// Do vendedor
	//³ mv_par11				// Ate o vendedor
	//³ mv_par12				// Do Pais
	//³ mv_par13				// Ate Pais
	//³ mv_par14     			// Categoria do Pedido (12345)
	//³                        X-Imp. todos os itens da categoria 1
	//³ mv_par15     			// Todos, Em Montagem, Sem Montagem
	//³ mv_par16     			// Saldo, Data Lib.Engen.
	//³ mv_par17				// Gera Arq.p/Excel  1-Sim  2-Não
	//³ mv_par18				// Gera Itens p/Arq.CSV 1 - Sim  2- Não
	//³ mv_par19     			// Analise dos Vendedores
	//³                            1 - Somente o Vendedor 1 do pedido
	//³                            2 - Todos os Vendedores do pedido
	//³ mv_par20				// Produtos com etiqueta 1 - Sim 2- Nao
	//******************************************************************

	Pergunte(cPerg,.F.)

	aOrd :={"Por Pedido","Por Produto","Por Cliente","Por Data Entrega Prevista ","Por Vendedor","Por Inicio de Montagem","Por Data Entrega Real "}

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,aOrd,,Tamanho)

	If nLastKey == 27
		Set Filter to
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Set Filter to
		Return
	Endif   

	RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)})

Return


/*/{Protheus.doc} C680Imp
//TODO Efetua a impressão do relatório
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return Nil
@param lEnd, logical, Indica encerramento
@param WnRel, , objeto do relatório
@param cString, characters, Descrição do relatório
@type function
@obs adicionado apenas o cabeçalho
/*/
Static Function C680Imp(lEnd,WnRel,cString)

	nOrdem  := aReturn[8]

	// Variaveis utilizadas para Impressao do Cabecalho e Rodape
	cbtxt   := SPACE(10)
	cbcont  := 0
	m_pag   := 1
	li      := 80
	// Variaveis utilizadas para Impressao do Cabecalho e Rodape
	
	Processa({|lEnd| C680Trb()}) //Cria a tabela Trabalho

	// Prepara cabeçalhos
	titulo := "Relacao de Pedidos a Faturar"

	Do Case
		Case nOrdem = 1
		nCol    := 9
		titulo  := titulo +" - "+ "Por Pedido"
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If mv_par16 == 1  //Coluna   (Saldo / Data Lib.Engen)
				cabec1  := "CT PEDIDO LIB.DE  C L I E N T E          PAIS VENDEDOR      GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   SALDO "   
				cabec2  := "          VENDAS                                            (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  QTDE  "
			Else
				cabec1  := "CT PEDIDO LIB.DE  C L I E N T E          PAIS VENDEDOR      GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   LIB.DA"   
				cabec2  := "          VENDAS                                            (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  ENGEN."
			EndIf
		Else                                  
			cabec1  := "CT PEDIDO LIB.DE  C L I E N T E          PAIS VENDEDOR      GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + "VALOR   SALDO "
			cabec2  := "          VENDAS                                            (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "        QTDE  "
		EndIf

		Case nOrdem = 2
		nCol    := 18
		titulo  := titulo + " - "+"Por Produto"
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If mv_par16 == 1  //Coluna   (Saldo / Data Lib.Engen)
				cabec1  := "CT PRODUTO         DESCRICAO                        QTDE. PRAZO    PREVISAO  PEDIDO     LIB.DE   C L I E N T E            PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO  PED. DO   CONF. ENCOMENDA  DATA DE   " + " DIAS   SALDO "   
				cabec2  := "                                                          ORIGINAL ENTREGA              VENDAS                                            (meses) FATURAM.  MONTAGEM   CLIENTE   NUMERO     DATA  CONCL.    " + "ATRASO  QTDE  "
			Else
				cabec1  := "CT PRODUTO         DESCRICAO                        QTDE. PRAZO    PREVISAO  PEDIDO     LIB.DE   C L I E N T E            PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO  PED. DO   CONF. ENCOMENDA  DATA DE   " + " DIAS   LIB.DA"
				cabec2  := "                                                          ORIGINAL ENTREGA              VENDAS                                            (meses) FATURAM.  MONTAGEM   CLIENTE   NUMERO     DATA  CONCL.    " + "ATRASO  ENGEN."
			Endif
		Else
			cabec1  := "CT PRODUTO         DESCRICAO                        QTDE. PRAZO    PREVISAO  PEDIDO     LIB.DE   C L I E N T E            PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO  PED. DO   CONF. ENCOMENDA  DATA DE   " + "VALOR    SALDO"
			cabec2  := "                                                          ORIGINAL ENTREGA              VENDAS                                            (meses) FATURAM.  MONTAGEM   CLIENTE   NUMERO     DATA  CONCL.    " + "         QTDE"
		EndIf

		Case nOrdem = 3
		nCol    := 26
		titulo  := titulo + " - "+"Por Cliente"
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If mv_par16 == 1  //Coluna   (Saldo / Data Lib.Engen)
				cabec1  := "CT C L I E N T E          PAIS VENDEDOR    PEDIDO  LIB.DE   GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   SALDO "   
				cabec2  := "                                                   VENDAS   (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  QTDE  "
			Else
				cabec1  := "CT C L I E N T E          PAIS VENDEDOR    PEDIDO  LIB.DE   GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   LIB.DA"
				cabec2  := "                                                   VENDAS   (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  ENGEN."
			Endif
		Else
			cabec1  := "CT C L I E N T E          PAIS VENDEDOR    PEDIDO  LIB.DE   GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + "VALOR    SALDO"
			cabec2  := "                                                   VENDAS   (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "         QTDE"
		EndIf

		Case nOrdem = 4
		nCol    := 11
		titulo  := titulo + " - " + "Por Data Entrega Prevista "
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If mv_par16 == 1  //Coluna   (Saldo / Data Lib.Engen)
				cabec1  := "CT PREVISAO PRAZO     PEDIDO  LIB.DE    C L I E N T E          PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO   PED. DO   CONF. ENCOMENDA  DATA    IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   SALDO "   
				cabec2  := "   ENTREGA  ORIGINAL          VENDAS                                           (meses) FATURAM.  MONTAGEM    CLIENTE   NUMERO     DATA  CONCL.                                                               " + "ATRASO  QTDE  "
			Else
				cabec1  := "CT PREVISAO PRAZO     PEDIDO  LIB.DE    C L I E N T E          PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO   PED. DO   CONF. ENCOMENDA  DATA    IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   LIB.DA"
				cabec2  := "   ENTREGA  ORIGINAL          VENDAS                                           (meses) FATURAM.  MONTAGEM    CLIENTE   NUMERO     DATA  CONCL.                                                               " + "ATRASO  ENGEN."
			Endif
		Else
			cabec1  := "CT PREVISAO PRAZO     PEDIDO  LIB.DE    C L I E N T E          PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO   PED. DO   CONF. ENCOMENDA  DATA    IT PRODUTO         DESCRICAO                         QTDE.   " + "VALOR     SALDO"
			cabec2  := "   ENTREGA  ORIGINAL          VENDAS                                           (meses) FATURAM.  MONTAGEM    CLIENTE   NUMERO     DATA  CONCL.                                                               " + "          QTDE"
		EndIf

		Case nOrdem = 5
		nCol    := 14
		titulo  := titulo + " -  " + "Por Vendedor"
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If mv_par16 == 1   //Coluna   (Saldo / Data Lib.Engen)   
				cabec1  := "CT VENDEDOR    C L I E N T E          PAIS PEDIDO  LIB.DE   GARANT. PED. DO    CONF. ENCOMENDA  DATA    DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   SALDO "   
				cabec2  := "                                                   VENDAS   (meses) CLIENTE    NUMERO     DATA  CONCL.  FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  QTDE  "
			Else
				cabec1  := "CT VENDEDOR    C L I E N T E          PAIS PEDIDO  LIB.DE   GARANT. PED. DO    CONF. ENCOMENDA  DATA    DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   LIB.DA"
				cabec2  := "                                                   VENDAS   (meses) CLIENTE    NUMERO     DATA  CONCL.  FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  ENGEN."
			Endif
		Else
			cabec1  := "CT VENDEDOR    C L I E N T E          PAIS PEDIDO  LIB.DE   GARANT. PED. DO    CONF. ENCOMENDA  DATA    DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + "VALOR     SALDO"
			cabec2  := "                                                   VENDAS   (meses) CLIENTE    NUMERO     DATA  CONCL.  FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "          QTDE"
		EndIf

		Case nOrdem = 6
		nCol    := 9
		titulo  := titulo + " -  " + "Por Inicio de Montagem"
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If mv_par16 == 1  //Coluna   (Saldo / Data Lib.Engen)
				cabec1  := "CT PEDIDO LIB.DE  C L I E N T E          PAIS VENDEDOR      GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   SALDO "   
				cabec2  := "          VENDAS                                            (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  QTDE  "
			Else
				cabec1  := "CT PEDIDO LIB.DE  C L I E N T E          PAIS VENDEDOR      GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   LIB.DA"
				cabec2  := "          VENDAS                                            (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "ATRASO  ENGEN."
			Endif
		Else
			cabec1  := "CT PEDIDO LIB.DE  C L I E N T E          PAIS VENDEDOR      GARANT. PED. DO   CONF. ENCOMENDA  DATA     DT. LIB.  DT.INICIO   PRAZO    PREVISAO IT PRODUTO         DESCRICAO                         QTDE.   " + "VALOR     SALDO"
			cabec2  := "          VENDAS                                            (meses) CLIENTE   NUMERO     DATA  CONCL.   FATURAM.  MONTAGEM    ORIGINAL ENTREGA                                                               " + "          QTDE"
		EndIf

		Case nOrdem = 7
		nCol    := 11
		titulo  := titulo + " - " + "Por Data Entrega Real "
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If mv_par16 == 1   //Coluna   (Saldo / Data Lib.Engen)
				cabec1  := "CT PREVISAO PRAZO     PEDIDO  LIB.DE    C L I E N T E          PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO   PED. DO   CONF. ENCOMENDA  DATA    IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   SALDO "   
				cabec2  := "   ENTREGA  ORIGINAL          VENDAS                                           (meses) FATURAM.  MONTAGEM    CLIENTE   NUMERO     DATA  CONCL.                                                               " + "ATRASO  QTDE  "
			Else
				cabec1  := "CT PREVISAO PRAZO     PEDIDO  LIB.DE    C L I E N T E          PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO   PED. DO   CONF. ENCOMENDA  DATA    IT PRODUTO         DESCRICAO                         QTDE.   " + " DIAS   LIB.DA"
				cabec2  := "   ENTREGA  ORIGINAL          VENDAS                                           (meses) FATURAM.  MONTAGEM    CLIENTE   NUMERO     DATA  CONCL.                                                               " + "ATRASO  ENGEN."
			Endif
		Else
			cabec1  := "CT PREVISAO PRAZO     PEDIDO  LIB.DE    C L I E N T E          PAIS VENDEDOR   GARANT. DT. LIB.  DT.INICIO   PED. DO   CONF. ENCOMENDA  DATA    IT PRODUTO         DESCRICAO                         QTDE.   " + "VALOR     SALDO"
			cabec2  := "   ENTREGA  ORIGINAL          VENDAS                                           (meses) FATURAM.  MONTAGEM    CLIENTE   NUMERO     DATA  CONCL.                                                               " + "          QTDE"
		EndIf
	EndCase

	If mv_par17 == 1    // Gera Arq.p/Excel
		If (cArqCSV := FCreate("C:\Relato_Microsiga\Pedidos_a_faturar.csv")) == -1
			Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
		Else
			cRegCSV := "Relação dos Pedidos a Faturar - emitida em " + DTOC(Date()) + " - Periodo de: "+DTOC(mv_par07)+" à "+DTOC(mv_par08) 
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			cRegCSV := ""
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			cRegCSV := ";Pedidos atrasados"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			cRegCSV := ";Pedidos que merecem atenção (data de entrega próxima)"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			cRegCSV := ";Pedidos em processo"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			cRegCSV := ";Pedidos sem itens definidos pela Engenharia"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			cRegCSV := ""
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			If SUBSTR(cNumEmp,1,2) $ "01_10"
				//Ivandro Santos - 15/12/16
				//Ticket#2016121537000128 — Pedidos intercompany
				If Upper(cDeptoUsu) $ "CONTABILIDADE_INFORMATICA" 
					cRegCSV := "Pedido;Link;Cat;Natureza;Engenharia;Tipo Venda;Emissao PV;Contrato;Emissao Contrato;Garantia (meses);Visita?;Multa?;Cliente;Vendedor;País;Ent.Original;Ent.Prevista;Dias p/Montagem;Entregar Peças até;Inicio Montagem;Item;Produto;Descrição;Preço Unit.;Qde.Vendida;Qde.Entregue;Qtde.Empenhada;Estoque;Reserva para Vendas;Liberado pela Eng.;Num. Ped. Cli.;It.Ped.Cli.;Concluído pela Montagem;UM;Listas separadas;Faturado;Cond.Pagto;Bloqueio;"
				Else
					cRegCSV := "Pedido;Link;Cat;Natureza;Engenharia;Tipo Venda;Emissao PV;Contrato;Emissao Contrato;Garantia (meses);Visita?;Multa?;Cliente;Vendedor;País;Ent.Original;Ent.Prevista;Dias p/Montagem;Entregar Peças até;Inicio Montagem;Item;Produto;Descrição;Preço Unit.;Qde.Vendida;Qde.Entregue;Qtde.Empenhada;Estoque;Reserva para Vendas;Liberado pela Eng.;Num. Ped. Cli.;Concluído pela Montagem;UM;Listas separadas;Faturado;Cond.Pagto;Bloqueio;"
				Endif                      
				//Ticket#2016121537000128 — Fim da alteração
			ElseIf SUBSTR(cNumEmp,1,2) $ "15_40_45"
				cRegCSV := "Pedido;Link;Cat;Natureza;Engenharia;Tipo Venda;Emissao PV;Contrato;Emissao Contrato;Garantia (meses);Grupo;Multa?;Cliente;Vendedor;País;Ent. Original;Ent. Prevista;Dias p/ Montagem;Entregar Peças até;Inicio Montagem;Item;Produto;Descrição;Preço Unit.;Qde. Vendida;Qde. Entregue;Qtde. Empenhada;Estoque;Reserva para Vendas;Liberado pela Eng.;Num. Ped. Cli.;Concluído pela Montagem;UM;Listas separadas;Faturado;Cond. Pagto;Bloqueio;"
			EndIf	  	      
			cRegCSV += "Valor (R$);"
			cRegCSV += "Comercial;EngMC;PCP/Prod;Montagem;IPI;OP(Sim/Não)" // TROCADO DIA 09/05/12 - LIZANDRA   
			//Ivandro Santos - 21/07/17
			//Ticket#2017072137000035 — Relatorios de pedido por categoria
			If Upper(cDeptoUsu) $ "207-PCP_205-ALMOXARIFADO" 
				cRegCSV += ";Entr_ItemPV" 
			Endif
			//Ticket#2017072137000035 — Fim da alteração
			//Ivandro Santos - 15/12/16
			//Ticket#2016121537000128 — Pedidos intercompany
			If Upper(cDeptoUsu) $ "CONTABILIDADE_INFORMATICA" 
				cRegCSV += ";Preço Tabela"   
			Endif
			//Ticket#2016121537000128 — Fim da alteração

			cRegCSV += ";Procedencia"   

			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))	  
		EndIf
	EndIf 

	ImpParam()  // Imprime parâmetros solicitados pelo usuário

	dbSelectArea("TRB")
	TRB->(dbGoTop())
	SetRegua(RecCount())   // TOTAL DE ELEMENTOS DA REGUA

	While TRB->(!Eof())

		If lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
			Exit
		Endif

		If SUBSTR(cNumEmp,1,2) $ "01_10"
			If (mv_par09 == 2 .AND. !Empty(TRB->DTCONCL)) .Or. (mv_par09 == 1 .AND. Empty(TRB->DTCONCL))
				TRB->(dbSkip())
				Loop
			EndIf
		EndIf   

		If lPrim
			cPedAnt    := TRB->NUM
			cCategAnt  := TRB->CATEG
			cProdAnt   := TRB->PRODUTO
			cCliAnt	  := TRB->CLIENTE
			dtEntr	  := TRB->DATENTR
			dtEntrAnt  := TRB->DTPRVENT
			dDtPecas   := TRB->DTPECAS
			nMontaPV   := TRB->MONTAPV
			dDtEmiAnt  := TRB->EMISSAO
			cVendAnt   := TRB->VENDEDOR 
			cLink      := Alltrim(TRB->LINK) 
			cPosPed    := Alltrim(TRB->POSPED) 
			cPend      := Alltrim(TRB->PEND)
			cObs       := Alltrim(TRB->OBS)
			cCondPgto  := Alltrim(TRB->CONDPGTO)
			cVisita    := TRB->VISITA
			cMulta     := TRB->MULTA
			nB2QatuAnt := TRB->B2QATU
			lPrim      := .F.
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			ImpCabec1()
		EndIf 

		If Li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			Li := 9
		EndIf

		// Imprime a linha Conforme a ordem selecionada na setprint
		Do Case
			Case nOrdem == 1  // PEDIDO
			If TRB->NUM <> cPedAnt
				ImpTotal()
				Li++
				@ Li,0 Psay REPLICATE("-",220)
				Li++
				cPedAnt    := TRB->NUM
				cCategAnt  := TRB->CATEG
				dDtEmiAnt  := TRB->EMISSAO
				ImpCabec1()
			Else
				If Li == 9
					ImpCabec1()
				EndIf      
			EndIf
			ImpDet1()
			@ Li,126 Psay TRB->DATENTR 
			@ Li,135 Psay TRB->DTPRVENT
			@ Li,144 Psay TRB->ITEM
			@ Li,147 Psay TRB->PRODUTO
			@ Li,163 Psay Left(TRB->DESCRICAO, 28)
			If Substr(cNumEmp,1,2) $ "01_10"
				@ Li,192 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 99,999.999"
			ElseIf Substr(cNumEmp,1,2) $ "15_40_45"
				@ Li,190 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 999,999,999"
			EndIf			

			Case nOrdem == 2 // PRODUTO
			If TRB->PRODUTO <> cProdAnt
				ImpTotal()
				Li++
				@ Li,0 Psay REPLICATE("-",220)
				Li++
				cProdAnt := TRB->PRODUTO
				cItemAnt := TRB->ITEM 
				cDescAnt := TRB->DESCRICAO
				ImpCabec1()
			Else
				If Li == 9
					ImpCabec1()
				EndIf       
			EndIf
			@ Li,047 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 99,999.999"
			@ Li,058 Psay TRB->DATENTR
			@ Li,067 Psay TRB->DTPRVENT
			@ Li,077 Psay TRB->NUM + "/" + TRB->ITEM
			@ Li,088 Psay TRB->EMISSAO
			@ Li,097 Psay Left(TRB->CLIENTE+"-"+TRB->NOMECLI,22)
			@ Li,122 Psay TRB->PAIS
			@ Li,125 Psay SubStr(TRB->NOMEVEN,1,15)
			If !Empty(TRB->GARANTIA)
				@ Li,141 Psay TRB->GARANTIA
			EndIf
			If !Empty(TRB->DTLIBFAT)
				@ Li,146 Psay TRB->DTLIBFAT 
			EndIf
			If !Empty(TRB->DTMONTA)
				@ Li,156 Psay TRB->DTMONTA
			EndIf    
			@ Li,167 Psay SubStr(TRB->PEDCLI,1,10)
			@ Li,178 Psay SubStr(TRB->NUMCE,1,10)
			If !Empty(TRB->DATACE)
				@ Li,189 Psay StrZero(Day(TRB->DATACE),2)
				@ Li,191 Psay "/"
				@ Li,192 Psay StrZero(Month(TRB->DATACE),2)
			EndIf                          	        
			If !Empty(TRB->DTCONCL) 
				@ Li,195 Psay TRB->DTCONCL
			EndIf

			Case nOrdem == 3  // CLIENTE
			If TRB->CLIENTE <> cCliAnt 
				ImpTotal()
				Li++
				@ Li,000 Psay REPLICATE("-",220)
				Li++
				ImpCabec1()
				cCliAnt    := TRB->CLIENTE
				cNomCliAnt := TRB->NOMECLI
			Else
				If TRB->NUM <> cPedAnt
					ImpTotal()
					Li++
					@ Li,  0 Psay REPLICATE("-",220)
					Li++
					ImpCabec1()
				Else
					If Li == 9
						ImpCabec1()
					EndIf    
				EndIf   
			EndIf
			@ Li, 43 Psay TRB->NUM
			@ Li, 50 Psay TRB->EMISSAO
			ImpDet1()
			@ Li,126 Psay TRB->DATENTR
			@ Li,135 Psay TRB->DTPRVENT 
			@ Li,144 Psay TRB->ITEM
			@ Li,147 Psay TRB->PRODUTO
			@ Li,163 Psay SubStr(TRB->DESCRICAO,1,28)
			If Substr(cNumEmp,1,2) $ "01_10"
				@ Li,192 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 99,999.999"
			ElseIf Substr(cNumEmp,1,2) $ "15_40_45"
				@ Li,190 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 999,999,999"
			EndIf			

			Case nOrdem == 4  // DATA DE ENTREGA PREVISTA
			If TRB->DTPRVENT <> dtEntrAnt 
				ImpTotal()
				Li++
				@ Li,  0 Psay REPLICATE("-",220)
				Li++
				dtEntrAnt := TRB->DTPRVENT
				cPedAnt := TRB->NUM
				ImpCabec1()
			Else   
				If TRB->NUM <> cPedAnt
					ImpTotal()
					Li++
					@ Li,  0 Psay REPLICATE("-",220)
					Li++
					ImpCabec1()
					cPedAnt   := TRB->NUM
				Else
					If Li == 9
						ImpCabec1()
					EndIf    
				EndIf   
			EndIf
			@ Li,11 Psay TRB->DATENTR		                                                   
			@ Li,21 Psay TRB->NUM
			@ Li,29 Psay TRB->EMISSAO
			@ Li,38 Psay Left(TRB->CLIENTE+"-"+TRB->NOMECLI,22)
			@ Li,63 Psay TRB->PAIS
			@ Li,66 Psay SubStr(TRB->NOMEVEN,1,12)
			If !Empty(TRB->GARANTIA)
				@ Li, 81 Psay TRB->GARANTIA
			EndIf
			If !Empty(TRB->DTLIBFAT)
				@ Li, 86 Psay TRB->DTLIBFAT
			EndIf
			If !Empty(TRB->DTMONTA)
				@ Li,096 Psay TRB->DTMONTA
			EndIf   
			@ Li,108 Psay SubStr(TRB->PEDCLI,1,9)
			@ Li,118 Psay SubStr(TRB->NUMCE,1,10)
			If !Empty(TRB->DATACE)
				@ Li, 129 Psay StrZero(Day(TRB->DATACE),2)
				@ Li, 131 Psay "/"
				@ Li, 132 Psay StrZero(Month(TRB->DATACE),2)
			EndIf
			If !Empty(TRB->DTCONCL)
				@ Li, 135 Psay TRB->DTCONCL
			EndIf
			@ Li,144 Psay TRB->ITEM
			@ Li,147 Psay TRB->PRODUTO
			@ Li,163 Psay SubStr(TRB->DESCRICAO,1,28)
			If Substr(cNumEmp,1,2) $ "01_10"
				@ Li,192 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 99,999.999"
			ElseIf Substr(cNumEmp,1,2) $ "15_40_45"
				@ Li,190 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 999,999,999"
			EndIf			

			Case nOrdem == 5  // VENDEDOR
			If TRB->VENDEDOR <> cVendAnt 
				ImpTotal()
				Li++
				@ Li,  0 Psay REPLICATE("-",220)
				Li++
				cVendAnt    := TRB->VENDEDOR
				cNomVendAnt := TRB->NOMEVEN
				ImpCabec1()
			Else
				If TRB->NUM <> cPedAnt 
					ImpTotal()
					Li++
					@ Li,  0 Psay REPLICATE("-",220)
					Li++
					ImpCabec1()
				Else
					If Li == 9
						ImpCabec1()
					EndIf    
				EndIf
			EndIf   
			@ Li,014 Psay Left(TRB->CLIENTE+"-"+TRB->NOMECLI,22)
			@ Li,039 Psay TRB->PAIS 
			@ Li,043 Psay TRB->NUM
			@ Li,050 Psay TRB->EMISSAO  
			ImpDet1()
			@ Li,126 Psay TRB->DATENTR
			@ Li,135 Psay TRB->DTPRVENT 
			@ Li,144 Psay TRB->ITEM
			@ Li,147 Psay TRB->PRODUTO
			@ Li,163 Psay SubStr(TRB->DESCRICAO,1,28)
			If Substr(cNumEmp,1,2) $ "01_10"
				@ Li,192 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 99,999.999"
			ElseIf Substr(cNumEmp,1,2) $ "15_40_45"
				@ Li,190 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 999,999,999"
			EndIf			

			Case nOrdem == 6  // INICIO DE MONTAGEM
			If TRB->NUM <> cPedAnt
				ImpTotal()
				Li++
				@ Li,  0 Psay REPLICATE("-",220)
				Li++
				cPedAnt    := TRB->NUM
				cCategAnt  := TRB->CATEG
				dDtEmiAnt  := TRB->EMISSAO
				ImpCabec1()
			Else
				If Li == 9
					ImpCabec1()
				EndIf      
			EndIf
			ImpDet1()
			@ Li,126 Psay TRB->DATENTR 
			@ Li,135 Psay TRB->DTPRVENT
			@ Li,144 Psay TRB->ITEM
			@ Li,147 Psay TRB->PRODUTO
			@ Li,163 Psay Left(TRB->DESCRICAO, 28)
			If Substr(cNumEmp,1,2) $ "01_10"
				@ Li,192 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 99,999.999"
			ElseIf Substr(cNumEmp,1,2) $ "15_40_45"
				@ Li,190 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 999,999,999"
			EndIf			

			Case nOrdem == 7 // DATA DE ENTREGA REAL
			If TRB->DATENTR <> dtEntr
				ImpTotal()
				Li++
				@ Li,  0 Psay REPLICATE("-",220)
				Li++
				dtEntr := TRB->DATENTR
				cPedAnt := TRB->NUM
				ImpCabec1()
			Else   
				If TRB->NUM <> cPedAnt
					ImpTotal()
					Li++
					@ Li,  0 Psay REPLICATE("-",220)
					Li++
					ImpCabec1()
					cPedAnt   := TRB->NUM
				Else
					If Li == 9
						ImpCabec1()
					EndIf    
				EndIf   
			EndIf
			@ Li,11 Psay TRB->DATENTR		                                                   
			@ Li,21 Psay TRB->NUM
			@ Li,29 Psay TRB->EMISSAO
			@ Li,38 Psay Left(TRB->CLIENTE+"-"+TRB->NOMECLI,22)
			@ Li,63 Psay TRB->PAIS
			@ Li,66 Psay SubStr(TRB->NOMEVEN,1,12)
			If !Empty(TRB->GARANTIA)
				@ Li, 81 Psay TRB->GARANTIA
			EndIf
			If !Empty(TRB->DTLIBFAT)
				@ Li, 86 Psay TRB->DTLIBFAT
			EndIf
			If !Empty(TRB->DTMONTA)
				@ Li,096 Psay TRB->DTMONTA
			EndIf   
			@ Li,108 Psay SubStr(TRB->PEDCLI,1,9)
			@ Li,118 Psay SubStr(TRB->NUMCE,1,10)
			If !Empty(TRB->DATACE)
				@ Li,129 Psay StrZero(Day(TRB->DATACE),2)
				@ Li,131 Psay "/"
				@ Li,132 Psay StrZero(Month(TRB->DATACE),2)
			EndIf
			If !Empty(TRB->DTCONCL)
				@ Li, 135 Psay TRB->DTCONCL
			EndIf
			@ Li,144 Psay TRB->ITEM
			@ Li,147 Psay TRB->PRODUTO
			@ Li,163 Psay SubStr(TRB->DESCRICAO,1,28)
			If Substr(cNumEmp,1,2) $ "01_10"
				@ Li,192 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 99,999.999"
			ElseIf Substr(cNumEmp,1,2) $ "15_40_45"
				@ Li,190 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 999,999,999"
			EndIf			
		EndCase

		If SUBSTR(cNumEmp,1,2) $ "01_10"
			@ Li,203 Psay TRB->OP
			If (Date() - TRB->DTPRVENT) > 0
				@ Li,206 Psay (Date() - TRB->DTPRVENT) PICTURE "@E 999"
			EndIf
			If mv_par16 == 1  //Coluna   (Saldo / Data Lib.Engen)
				@ Li, 211 Psay Transform(TRB->B2QATU,"9,999.99")
			Else
				If !Empty(TRB->DTLIBERA)      
					@ Li,211 PSAY TRB->DTLIBERA
				EndIf                  
			Endif
		Else
			@ Li,202 Psay TRB->VALOR    PICTURE "@E 99,999.99"
			If Substr(cNumEmp,1,2) $ "01_10"	   
				@ Li,211 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 9,999.999"
			ElseIf Substr(cNumEmp,1,2) $ "40_45"
				@ Li,209 Psay (TRB->QTDVEN - TRB->QTDENT) PICTURE "@E 999,999,999"
			EndIf
		EndIf      
		Li++

		nTotQtde  += TRB->QTDVEN
		nTotValor += TRB->VALOR 
		nTotSaldo += TRB->QTDVEN - TRB->QTDENT
		nCont++

		If Substr(cNumEmp,1,2) $ "01_10"
			If mv_par17 == 1  //Gera Arq.p/Excel
				If TRB->NUM <> cPedCSV  .Or. mv_par18 == 1   //Grava Itens p/Excel
					If TRB->NUM <> cPedCSV
						If mv_par18 == 1   //Grava Itens p/Excel
							cRegCSV := ""
							FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
						EndIf   
						cPedCSV := TRB->NUM 
					EndIf
					cRegCSV := TRB->NUM+";"+TRB->LINK+";"+TRB->CATEG+";"+TRB->NATUREZ+";"+TRB->ENG+";"+TRB->TPVEN+";"+Dtoc(TRB->EMISSAO)+";"+TRB->NUMCE+";"+Dtoc(TRB->DATACE)+";"+Str(TRB->GARANTIA,3)+";"+TRB->VISITA+";"+TRB->MULTA+";"+TRB->CLIENTE+"-"+Alltrim(TRB->NOMECLI)+";"+Alltrim(TRB->VENDEDOR)+"-"+Alltrim(TRB->NOMEVEN)+";"+TRB->PAIS+"-"+Alltrim(TRB->NOMEPAIS)+";"+Dtoc(TRB->DATENTR)+";"+Dtoc(TRB->DTPRVENT)+";"+Str(TRB->MONTAPV,3,0)+";"+Dtoc(TRB->DTPECAS)+";"+Dtoc(TRB->DTMONTA)+";"+TRB->ITEM+";_"+Alltrim(TRB->PRODUTO)+";"+Alltrim(TRB->DESCRICAO)+";"+Transform(TRB->PRCVEN, "@E 999,999.99")+";"+Str(TRB->QTDVEN,8)+";"+Str(TRB->QTDENT,8)+";"+Str(TRB->QTDEMP,8)+";"+Str(TRB->ESTOQUE,8)+";"+STR(TRB->B2RESER,8)+";"+Dtoc(TRB->DTLIBERA)+";"+TRB->PEDCLII+";"
					//Ivandro Santos - 15/12/16
					//Ticket#2016121537000128 — Pedidos intercompany
					If Upper(cDeptoUsu) $ "CONTABILIDADE_INFORMATICA" 
						cRegCSV += TRB->ITEMPC+";"
					Endif
					//Ticket#2016121537000128 — Pedidos intercompany					
					cRegCSV += Dtoc(TRB->DTCONCL)+";"+TRB->UM+";"+Alltrim(TRB->POSPED)+";"+TRB->MSPAGO+";"+Alltrim(TRB->CONDPGTO)+";"+TRB->OP+";" // TIRADO INSTALA POR DATA DO FATURAMENTO - LIZANDRA 20/04/12
					If Upper(cDeptoUsu) $ "FINANCEIRO_INFORMATICA_COMERCIAL_INFORMATICA/QUALIDADE" 
						cRegCSV += TRANSFORM(TRB->VLRPED, "@E 999,999,999.99")+";"
					Else
						cRegCSV += TRANSFORM(0, "@E 999,999,999.99")+";"
					EndIf
					cRegCSV += TRB->COMERC+";"+TRB->ENGMC+";"+TRB->PCP+";"+TRB->MONTAG+";"+TRANSFORM(TRB->TESTES,"@E 99.99")+";"+TRB->NUMOP //  TORCADO DIA 09/05/12 - LIZANDRA
					//Ivandro Santos - 21/07/17
					//Ticket#2017072137000035 — Relatorios de pedido por categoria
					If Upper(cDeptoUsu) $ "207-PCP_205-ALMOXARIFADO"
						////Ivandro Santos - 14/09/17 - início da alteração - Ticket#2017091237000031 — prazo de entrega 
						cRegCSV += +";"+Dtoc(TRB->DTPRENITPV) //cRegCSV += +";"+Dtoc(TRB->DTPRVENT)    
						//Ticket#2017091237000031 — fim da alteração
					Endif
					//Ticket#2017072137000035 — Fim da alteração
					//Ivandro Santos - 15/12/16
					//Ticket#2016121537000128 — Pedidos intercompany
					If Upper(cDeptoUsu) $ "CONTABILIDADE_INFORMATICA" 
						cRegCSV += +";"+TRANSFORM(TRB->PRCTAB, "@E 999,999,999.99")   
					endif
					//Ticket#2016121537000128 — Pedidos intercompany					

					cRegCSV += +";" + TRB->PROCED1

					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
				EndIf   
			EndIf
		ElseIf Substr(cNumEmp,1,2) $ "15_40_45"
			_dDataFim := CTOD("")
			_dDataFim := Posicione("SC2",1,xFilial("SC2")+TRB->NUMOP,"C2_DATRF")
			If mv_par17 == 1  //Gera Arq.p/Excel
				If TRB->NUM <> cPedCSV  .Or. mv_par18 == 1   //Grava Itens p/Excel
					If TRB->NUM <> cPedCSV
						If mv_par18 == 1   //Grava Itens p/Excel
							cRegCSV := ""
							FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
						EndIf   
						cPedCSV := TRB->NUM 
					EndIf
					cRegCSV := TRB->NUM+";"+TRB->LINK+";"+TRB->CATEG+";"+TRB->NATUREZ+";"+TRB->ENG+";"+TRB->TPVEN+";"+Dtoc(TRB->EMISSAO)+";"+TRB->NUMCE+";"+Dtoc(TRB->DATACE)+";"+Str(TRB->GARANTIA,3)+";"+TRB->MSGRUPO+";"+TRB->MULTA+";"+TRB->CLIENTE+"-"+Alltrim(TRB->NOMECLI)+";"+Alltrim(TRB->VENDEDOR)+"-"+Alltrim(TRB->NOMEVEN)+";"+TRB->PAIS+"-"+Alltrim(TRB->NOMEPAIS)+";"+Dtoc(TRB->DATENTR)+";"+Dtoc(TRB->DTPRVENT)+";"+Str(TRB->MONTAPV,3,0)+";"+Dtoc(TRB->DTPECAS)+";"+Dtoc(TRB->DTMONTA)+";"+TRB->ITEM+";_"+Alltrim(TRB->PRODUTO)+";"+Alltrim(TRB->DESCRICAO)+";"+Transform(TRB->PRCVEN, "@E 999,999.99")+";"+Str(TRB->QTDVEN,8)+";"+Str(TRB->QTDENT,8)+";"+Str(TRB->QTDEMP,8)+";"+Str(TRB->ESTOQUE,8)+";"+STR(TRB->B2RESER,8)+";"+Dtoc(TRB->DTLIBERA)+";"+TRB->PEDCLII+";"+Dtoc(TRB->DTCONCL)+";"+TRB->UM+";"+Alltrim(TRB->POSPED)+";"+TRB->MSPAGO+";"+Alltrim(TRB->CONDPGTO)+";"+TRB->OP+";" // TIRADO INSTALA POR DATA DO FATURAMENTO - LIZANDRA 20/04/12
					If Upper(cDeptoUsu) $ "FINANCEIRO_INFORMATICA_COMERCIAL_INFORMATICA/QUALIDADE" 
						cRegCSV += TRANSFORM(TRB->VLRPED, "@E 999,999,999.99")+";"
					Else
						cRegCSV += TRANSFORM(0, "@E 999,999,999.99")+";"
					EndIf
					cRegCSV += TRB->COMERC+";"+TRB->ENGMC+";"+TRB->PCP+";"+TRB->MONTAG+";"+TRANSFORM(TRB->TESTES,"@E 99.99")+";"+TRB->NUMOP+IIF(!EMPTY(_dDataFim)," E","")
					cRegCSV += +";" + TRB->PROCED1
					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
				EndIf   
			EndIf
		EndIf
		TRB->(IncRegua())
		TRB->(dbSkip())
	EndDo

	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	cRegCSV := "Total de pedidos por Tipo de Engenharia no Periodo de: " + DTOC(mv_par07) + " à " + DTOC(mv_par08)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	//Impressao do totalizador novo - (criado por FMD em 11/07/11)
	DbSelectArea("TOT")
	TOT->(DbGoTop())

	If Substr(cNumEmp,1,2) == "01"

		Do While TOT->(!Eof())

			If Dtos(TOT->ENTREGA) < Dtos(mv_par07) .OR. Dtos(TOT->ENTREGA) > Dtos(mv_par08)
				TOT->(dbSkip())
				Loop
			EndIf

			_cAno	 := Year(TOT->ENTREGA)
			_cMes	 := Cmonth(TOT->ENTREGA)
			_cTipo	 := TOT->TIPO
			_nQtdMaq := 0

			Do While TOT->(!Eof()) .And. (_cTipo == TOT->TIPO).And. (_cAno == Year(TOT->ENTREGA)) .And. (_cMes == Cmonth(TOT->ENTREGA))
				_nQtdMaq ++
				TOT->(DbSkip())

				If (_cTipo <> TOT->TIPO) .Or. (_cAno <> Year(TOT->ENTREGA)) .Or. (_cMes <> Cmonth(TOT->ENTREGA))
					cRegCSV := CValToChar(_cAno)+";"+_cMes+";"
					Do Case
						Case Alltrim(_cTipo) == "E"
						cRegCSV += "Especial;" + cvaltochar(_nQtdMaq) + ";"
						Case Alltrim(_cTipo) == "H"
						cRegCSV += "Horizontal;" + cvaltochar(_nQtdMaq) + ";"
						Case Alltrim(_cTipo) == "V"
						cRegCSV += "Vertical;" + cvaltochar(_nQtdMaq) + ";"
						Case Alltrim(_cTipo) == "N" .Or. Alltrim(_cTipo) == ""
						cRegCSV += "Não Definido;" + cvaltochar(_nQtdMaq) + ";"
					End Case
					_nQtdMaq := 0
					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

					If _cTipo <> TOT->TIPO
						cRegCSV := ""
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					Endif
				Endif
			EndDo
		EndDo

	Elseif Substr(cNumEmp,1,2) == "10"

		Do While TOT->(!Eof())
			If Dtos(TOT->ENTREGA) < Dtos(mv_par07) .OR. Dtos(TOT->ENTREGA) > Dtos(mv_par08)
				TOT->(dbSkip())
				Loop
			EndIf

			_cAno	 := Year(TOT->ENTREGA)
			_cMes	 := Cmonth(TOT->ENTREGA)
			_cTipo	 := TOT->TIPO
			_nQtdMaq := 0

			Do While TOT->(!Eof()) .And. (_cTipo == TOT->TIPO).And. (_cAno == Year(TOT->ENTREGA)) .And. (_cMes == Cmonth(TOT->ENTREGA))
				_nQtdMaq ++
				TOT->(DbSkip())

				If (_cTipo <> TOT->TIPO) .Or. (_cAno <> Year(TOT->ENTREGA)) .Or. (_cMes <> Cmonth(TOT->ENTREGA))
					cRegCSV := CValToChar(_cAno) + ";" + _cMes + ";"
					Do Case
						Case Alltrim(_cTipo) == "A"
						cRegCSV += "Acessorios;" + CValToChar(_nQtdMaq) + ";"

						Case Alltrim(_cTipo) == "B"
						cRegCSV += "Emblistadora;" + CValToChar(_nQtdMaq) + ";"

						Case Alltrim(_cTipo) == "C"
						cRegCSV += "Encartuchadora;" + CValToChar(_nQtdMaq) + ";"

						Case Alltrim(_cTipo) == "E"
						cRegCSV += "Especiais;" + CValToChar(_nQtdMaq) + ";"

						Case Alltrim(_cTipo) == "G"
						cRegCSV += "Garvens;" + CValToChar(_nQtdMaq) + ";"

						Case Alltrim(_cTipo) == "P"
						cRegCSV += "Empacotadora;" + CValToChar(_nQtdMaq) + ";"

						Case Alltrim(_cTipo) == "N" .Or. Empty(Alltrim(_cTipo))
						cRegCSV += "Não Definido;" + CValToChar(_nQtdMaq) + ";"
					End Case
					_nQtdMaq := 0
					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

					If _cTipo <> TOT->TIPO
						cRegCSV := ""
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					Endif
				Endif
			EndDo
		EndDo
	Endif	

	FClose(cArqCSV)

	ImpTotal()

	If li != 80
		Roda(cbcont,cbtxt)
	Endif

	dbSelectArea("TRB")
	dbCloseArea()

	dbSelectArea("TOT")
	TOT->(dbCloseArea())                                               

	// Deleta arquivos de trabalho.
	Ferase(cArqTrab+GetDBExtension())
	Ferase(cArqTrab+OrdBagExt())
	Ferase(cFilTrab+OrdBagExt())

	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*/{Protheus.doc} ImpCabec1
//TODO Faz a impressão do cabeçalho
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return Nil
@obs adicionado apena o cabeçalho da rotina;

@type function
/*/
Static Function ImpCabec1() 

	If Li > 62
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf
	If nOrdem == 1 .Or. nOrdem == 6   // PEDIDO OU INICIO DE MONTAGEM
		@ li,00 Psay TRB->CATEG + " " + TRB->NUM
		@ li,09 Psay TRB->EMISSAO
		@ li,18 Psay Left(TRB->CLIENTE+"-"+TRB->NOMECLI,22)
		@ li,42 Psay TRB->PAIS
		@ li,46 Psay SubStr(TRB->NOMEVEN,1,12)
	ElseIf nOrdem == 2  // PRODUTO
		@ li,00 Psay TRB->CATEG + " " + TRB->PRODUTO
		@ li,18 Psay Left(TRB->DESCRICAO, 28)
	ElseIf nOrdem == 3  // CLIENTE
		@ li,00 Psay TRB->CATEG + " " + Left(TRB->CLIENTE+"-"+TRB->NOMECLI,22)
		@ li,26 Psay TRB->PAIS
		@ li,29 Psay SubStr(TRB->NOMEVEN,1,12)
	ElseIf nOrdem == 4  // DATA DE ENTREGA PREVISTA
		@ li,00 Psay TRB->CATEG + " " + DTOC(TRB->DTPRVENT)
	ElseIf nOrdem == 5  // VENDEDOR
		@ li,00 Psay TRB->CATEG + " " + SubStr(TRB->NOMEVEN,1,11)
	ElseIf nOrdem == 7  // DATA DE ENTREGA REAL
		@ li,00 Psay TRB->CATEG + " " + DTOC(TRB->DATENTR)
	EndIf

Return 


/*/{Protheus.doc} ImpDet1
//TODO Imprime o detalhe do relatório
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return nil
@obs adicionado o cabeçalho da rotina.

@type function
/*/
Static Function ImpDet1()                                                                          


	If !Empty(TRB->GARANTIA)
		@ li, 62 Psay TRB->GARANTIA
	EndIf
	@ li, 67 Psay SubStr(TRB->PEDCLI,1,10)
	@ li, 78 Psay SubStr(TRB->NUMCE,1,10)
	If !Empty(TRB->DATACE)
		@ li, 089 Psay StrZero(Day(TRB->DATACE),2)
		@ li, 091 Psay "/"
		@ li, 092 Psay StrZero(Month(TRB->DATACE),2)
	EndIf
	If !Empty(TRB->DTCONCL)
		@ li,095 Psay TRB->DTCONCL 
	EndIf
	If !Empty(TRB->DTLIBFAT)
		@ li,104 Psay TRB->DTLIBFAT 
	EndIf
	If !Empty(TRB->DTMONTA)
		@ li,114 Psay TRB->DTMONTA
	EndIf    

Return	   


/*/{Protheus.doc} ImpTotal
//TODO Impressão dos totalizadores do relatório
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return nil
@obs adicionado cabeçalho da rotina
@type function
/*/
Static Function ImpTotal()

Local X

	If Li == 9                                                                                         
		ImpAnterior()
	EndIf   

	If nTotQtde > 0 
		If nOrdem == 2  //PRODUTO
			@ li, 40 Psay "TOTAL --> "
			@ li, 48 Psay nTotQtde  PICTURE "@E 999,999.999"
		Else
			If SubStr(cNumEmp,1,2) $ "01_10"
				If !Empty(cLink) .And. cLink <> cPedAnt
					nColAnt := nCol
					Li++
					@ li,nCol Psay "Pedido Original.....: " + cLink 
					If dDtEmiAnt >= CTOD("15/05/2009")
						AA3->(DbOrderNickName("AA3_PEDPRO"))
						AA3->(DbGotoP())
						If AA3->(DbSeek(xFilial("AA3")+cPedAnt))
							nCol+=30
							@ Li,nCol Psay "Garantia do Pedido: " + DTOC(AA3->AA3_DTGAR) 
							If AA3->AA3_DTGAR <= dDtEmiAnt
								nCol+=35
								@ Li,nCol Psay "Atenção, Pedido não está em garantia"
							EndIf
						EndIf      
						cLink := ""
					EndIf
					nCol := nColAnt	
				EndIf   
			EndIf

			If !Empty(cPosPed)
				Li++
				@ li,nCol Psay "Posição do Pedido...: " + cPosPed
				cPosPed := ""
			EndIf	     
			@ li,174 Psay "TOTAL --> "
			@ li,192 Psay nTotQtde  PICTURE "@E 999,999.999"
			If !(SubStr(cNumEmp,1,2) $ "01_10")  
				@ li,210 Psay nTotSaldo PICTURE "@E 99,999.999"
			EndIf
			Li++
			@ li,nCol Psay "Condição de Pgto....: " + cCondPgto
			If !Empty(cVisita) .AND. cVisita == "S" 
				Li++  
				@ li,nCol Psay "Visita..............: SIM"
			EndIf      
			If !Empty(cMulta) .AND. cMulta == "S"
				Li++
				@ li,nCol Psay "Multa...............: SIM"
			EndIf
			If !Empty(dDtPecas)
				Li++
				@ li,nCol Psay "Entregar Peças até..: " + DTOC(dDtPecas)  + "  ==> Qtde. de dias p/montagem: " + Str(nMontaPV,3,0)
			EndIf

			Li++ 
			If !Empty(cPend)
				If Li > 62
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
					ImpAnterior()
				EndIf
				Li++ 
				@ Li,nCol Psay "Pendências.......: " 
				For X := 1 TO MLCOUNT(cPend,80)
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						ImpAnterior()
						@ Li,nCol Psay "Pendências.......: " 
					EndIf
					@ Li,nCol + 19 PSAY MEMOLINE(cPend,80,X)
					Li++
				Next
			EndIf

			If !Empty(cObs)
				If Li > 62
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
					ImpAnterior()
				EndIf
				Li++
				@ Li,nCol Psay "Observações......: " 
				For X := 1 TO MLCOUNT(cObs,80)
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) 
						ImpAnterior()
						@ Li,nCol Psay "Observações......: " 
					EndIf
					@ Li,nCol + 19 PSAY MEMOLINE(cObs,80,X)
					Li++
				Next
			EndIf

			If MV_PAR21 < 3 
				If !EMPTY(cPedAnt)
					If Li > 62
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						ImpAnterior()
					EndIf
					lEvento := .F.
					Do While Alltrim(QR1->ZM_PEDIDO) == cPedAnt
						If !Empty(QR1->ZM_EVENTO) .And. (mv_par21 == 2 .Or. (mv_par21 == 1 .And. QR1->ZM_STATUS <> "E"))
							If lEvenAo
								Li++
								@ Li,008 PSAY Replicate("-",124)
								Li++
							Else
								Li++
								@ Li,008 Psay Replicate("*",47)
								@ Li,058 Psay "Acompanhamento do Pedido"
								@ Li,085 Psay Replicate("*",47)
								Li+=2   
							EndIf 
							@ Li,008 Psay "De....: " + QR1->ZM_DEPTO
							@ Li,040 Psay "Emitente...: " + SubStr(QR1->ZM_MSUSER,1,13)
							@ Li,067 Psay "Emissão: " + DTOC(QR1->ZM_DATA)
							@ Li,086 Psay "Ult.Atualização: " + DTOC(QR1->ZM_ULTALT)
							@ Li,113 Psay "Status.:"
							If QR1->ZM_STATUS == "A"
								@ Li,121 Psay "Aberto"
							ElseIf QR1->ZM_STATUS == "P"
								@ Li,121 Psay "Em Processo"
							ElseIf QR1->ZM_STATUS == "E"
								@ Li,121 Psay "Encerrado"
							ElseIf QR1->ZM_STATUS == "R"
								@ Li,121 Psay "Reavaliar"         
							EndIf 
							Li+=2
							@ Li,008 Psay "Para..: " + QR1->ZM_DEPTDES
							@ Li,040 Psay "Resposta p/: " + DTOC(QR1->ZM_DTPREV)
							If QR1->ZM_STATUS == "E"
								@ Li,066 Psay "Tarefa realizada: "
								If (QR1->ZM_DTPREV - QR1->ZM_ULTALT) >= 0 
									@ Li,084 Psay "No prazo"
								Else
									@ Li,084 Psay "com "
									@ Li,088 Psay Abs(QR1->ZM_DTPREV - QR1->ZM_ULTALT) Picture "@E 99"
									@ Li,091 Psay "dia(s) de atraso"
								EndIf
							EndIf
							Li+=2
							If Li > 60
								cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
								@ Li, 000 Psay QR1->ZM_PEDIDO       
							EndIf   
							@ Li, 008 Psay "Tarefa: "
							For X := 1 TO MLCOUNT(Alltrim(QR1->ZM_EVENTO),80)
								If Li > 60
									cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
									@ Li, 000 Psay QR1->ZM_PEDIDO
									@ Li, 008 Psay "Tarefa: "
								EndIf   
								@ Li,016 PSAY MEMOLINE(Alltrim(QR1->ZM_EVENTO),80,X)
								Li++
							Next

							If !Empty(Alltrim(QR1->ZM_COMENT))
								If Li > 60
									cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
									@ Li, 000 Psay QR1->ZM_PEDIDO
									@ Li, 008 Psay "Comentario do Destino: "
								Else
									@ Li, 008 Psay "Comentario do Destino: "
								EndIf   
								For X := 1 TO MLCOUNT(Alltrim(QR1->ZM_COMENT),80)
									If Li > 60
										cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
										@ Li, 000 Psay QR1->ZM_PEDIDO
										@ Li, 008 Psay "Comentario do Destino: "
									EndIf
									@ Li,031 PSAY MEMOLINE(Alltrim(QR1->ZM_COMENT),80,X)
									Li++
								Next
								If !Empty(QR1->ZM_DTACEIT)
									@ Li,008 PSAY "Concluido em: "+ DTOC(QR1->ZM_DTACEIT)  + "  Usuario: "+ QR1->ZM_USUACEI
									Li++
								EndIf   
							EndIf

							lEvento := .T.
						EndIf

						QR1->(DbSkip())
						Loop      
					Enddo
				EndIf   
			EndIf  
		EndIf
	EndIf
	nTotQtde   := 0
	nTotSaldo  := 0
	nTotValor  := 0
	cLink      := Alltrim(TRB->LINK)
	cPosPed    := Alltrim(TRB->POSPED)
	cPend      := Alltrim(TRB->PEND)
	cObs       := Alltrim(TRB->OBS)
	cCondPgto  := Alltrim(TRB->CONDPGTO)
	cVisita    := TRB->VISITA
	cMulta     := TRB->MULTA
	dDtPecas   := TRB->DTPECAS
	nMontaPV   := TRB->MONTAPV

Return   


/*/{Protheus.doc} ImpAnterior
//TODO ?????????????? a definir
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return ${return}, ${return_description}
@obs colocado o cabeçalho da rotina.
@type function
/*/
Static Function ImpAnterior() 


	Do Case
		Case nOrdem == 1  // PEDIDO
		@ li,00 Psay cCategAnt + " " + cPedAnt
		Case nOrdem == 2  // PRODUTO
		@ li,00 Psay cCategAnt + " " + cProdAnt
		Case nOrdem == 3  // CLIENTE
		@ li,00 Psay cCategAnt + " " + Left(cCliAnt+"-"+cNomCliAnt,22)
		Case nOrdem == 4 // DATA DE ENTREGA PREVISTA
		@ li,00 Psay cCategAnt + " " + DTOC(dtEntrAnt)
		Case nOrdem == 5 // VENDEDOR
		@ li,00 Psay cCategAnt + " " + SubStr(cNomVendAnt,1,11)
		Case nOrdem == 6 // INICIO DE MONTAGEM
		@ li,00 Psay cCategAnt + " " + cPedAnt
		Case nOrdem == 7 // DATA DE ENTREGA REAL
		@ li,00 Psay cCategAnt + " " + DTOC(dtEntr)
	EndCase

Return 


/*/{Protheus.doc} C680TRB
//TODO Cria a tabela temporaria e traz as informações
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return nil
@param nOrdem, numeric, descricao
@type function
/*/
Static Function C680TRB()
	
Local oTable

// Define Variaveis
Local aCampos  := {}
Local aTam     := {}
Local aItemTmp	:= {}

	// Define array para arquivo de trabalho

	//AADD(aCampos,{ "FILIAL"   ,"C",02,0 } )
	AADD(aCampos,{ "NUM"      ,"C",06,0 } )
	AADD(aCampos,{ "CATEG"    ,"C",01,0 } ) 
	AADD(aCampos,{ "NATUREZ"  ,"C",10,0 } ) 
	AADD(aCampos,{ "LINK"     ,"C",06,0 } )
	AADD(aCampos,{ "EMISSAO"  ,"D",08,0 } )
	AADD(aCampos,{ "NUMCE"    ,"C",15,0 } )
	AADD(aCampos,{ "DATACE"   ,"D",08,0 } )
	AADD(aCampos,{ "GARANTIA" ,"N",02,0 } )
	AADD(aCampos,{ "VISITA"   ,"C",01,0 } )
	AADD(aCampos,{ "MULTA"    ,"C",01,0 } )
	AADD(aCampos,{ "CLIENTE"  ,"C",06,0 } )
	AADD(aCampos,{ "NOMECLI"  ,"C",15,0 } )
	AADD(aCampos,{ "LOJA"     ,"C",02,0 } )
	AADD(aCampos,{ "VENDEDOR" ,"C",06,0 } )
	AADD(aCampos,{ "NOMEVEN"  ,"C",15,0 } )
	AADD(aCampos,{ "PAIS"     ,"C",03,0 } )
	AADD(aCampos,{ "NOMEPAIS" ,"C",15,0 } )
	AADD(aCampos,{ "DATENTR"  ,"D",08,0 } )
	AADD(aCampos,{ "ALTENTR"  ,"C",01,0 } )
	AADD(aCampos,{ "DTPRVENT" ,"D",08,0 } )
	AADD(aCampos,{ "DTPRENITPV" ,"D",08,0 } )	//Ivandro Santos - 14/09/17 - Ticket#2017091237000031 — prazo de entrega
	AADD(aCampos,{ "DTMONTA"  ,"D",08,0 } )
	AADD(aCampos,{ "ITEM"     ,"C",02,0 } )
	AADD(aCampos,{ "PRODUTO"  ,"C",15,0 } )
	AADD(aCampos,{ "DESCRICAO","C",35,0 } )

	aTam:=TamSX3("C6_QTDVEN")
	AADD(aCampos,{ "QTDVEN"    ,"N",aTam[1],aTam[2] } )

	aTam:=TamSX3("C6_QTDEMP")
	AADD(aCampos,{ "QTDEMP"    ,"N",aTam[1],aTam[2] } )

	aTam:=TamSX3("C6_QTDENT")
	AADD(aCampos,{ "QTDENT"    ,"N",aTam[1],aTam[2] } )  

	aTam:=TamSX3("C6_VALOR")
	AADD(aCampos,{ "VALOR"     ,"N",aTam[1],aTam[2] } )

	AADD(aCampos,{ "PEDCLI"   ,"C",30,0 } )
	AADD(aCampos,{ "DTLIBERA" ,"D",08,0 } )
	AADD(aCampos,{ "DTINSTAL" ,"D",08,0 } )
	AADD(aCampos,{ "DTFAT"    ,"D",08,0 } )
	AADD(aCampos,{ "PEDCLII"  ,"C",15,0 } )  // INCLUIDO POR LIZANDRA 20/04/12
	AADD(aCampos,{ "NUMOP"    ,"C",08,0 } )  // INCLUIDO POR LIZANDRA 20/04/12
	AADD(aCampos,{ "PRIORI"   ,"C",08,0 } )  // INCLUIDO POR LIZANDRA 09/05/12
	AADD(aCampos,{ "MSPAGO"   ,"C",01,0 } )  // INCLUIDO POR LIZANDRA 25/09/12
	AADD(aCampos,{ "DTCONCL"  ,"D",08,0 } )
	AADD(aCampos,{ "UM"       ,"C",02,0 } )
	AADD(aCampos,{ "POSPED"   ,"C",50,0 } )

	aTam:=TamSX3("C5_MSPEND")
	AADD(aCampos,{ "PEND"      ,"M",aTam[1],aTam[2] } )

	aTam:=TamSX3("C5_OBS")
	AADD(aCampos,{ "OBS"       ,"M",aTam[1],aTam[2] } )

	AADD(aCampos,{ "CONDPGTO"  ,"C",15,0 } )  
	AADD(aCampos,{ "OP"        ,"C",25,0 } )
	AADD(aCampos,{ "DTLIBFAT"  ,"D",08,0 } )                       
	AADD(aCampos,{ "B2QATU"    ,"N",12,3 } ) 	//Incluido por Solange Vezú - 19/10/07
	AADD(aCampos,{ "B2RESER"   ,"N",12,3 } )  //Incluido por LIZANDRA - 28/03/12 
	AADD(aCampos,{ "ENG"       ,"C",01,0 } )
	AADD(aCampos,{ "COMERC"    ,"C",01,0 } )
	AADD(aCampos,{ "ENGMC"     ,"C",01,0 } )
	AADD(aCampos,{ "PCP"       ,"C",01,0 } )
	AADD(aCampos,{ "MONTAG"    ,"C",01,0 } )
	AADD(aCampos,{ "TESTES"    ,"N",05,2 } )  // TROCADO POR %IPI - LIZANDRA 10/05/12
	AADD(aCampos,{ "DTPECAS"   ,"D",08,0 } )
	AADD(aCampos,{ "MONTAPV"   ,"N",03,0 } )
	AADD(aCampos,{ "VLRPED"    ,"N",15,2 } ) 
	AADD(aCampos,{ "TPVEN"     ,"C",02,0 } )
	AADD(aCampos,{ "POSIPI"    ,"C",10,0 } )
	AADD(aCampos,{ "ESTOQUE"   ,"N",15,3 } )
	AADD(aCampos,{ "PRCVEN"    ,"N",10,2 } )
	AADD(aCampos,{ "MSGRUPO"   ,"C",30,0 } )
	//Ivandro Santos - 15/12/16
	//Ticket#2016121537000128 — Pedidos intercompany
	AADD(aCampos,{ "PRCTAB"    ,"N",10,2 } )
	AADD(aCampos,{ "ITEMPC"    ,"C",04,0 } )
	AADD(aCampos,{ "PROCED1"    ,"C",02,0 } )
	//Ticket#2016121537000128 — Fim da alteração

	// Cria arquivo de Trabalho
	If Select("TRB") > 0 
		DbSelectArea("TRB")
		TRB->(DbCloseArea())
	EndIf

	oTable := FWTemporaryTable():New("TRB",aCampos)

	Do Case
		Case nOrdem == 1  // PEDIDO
			oTable:AddIndex( "IND1", {'NUM','ITEM','PRODUTO'} )
		Case nOrdem == 2  // PRODUTO
			oTable:AddIndex( "IND1", {'PRODUTO','NUM','ITEM'} )
		Case nOrdem == 3  // CLIENTE
			oTable:AddIndex( "IND1", {'NOMECLI','NUM','ITEM'} )
		Case nOrdem == 4  // DATA DE ENTREGA PREVISTA
			oTable:AddIndex( "IND1", {'DTPRVENT','NUM','ITEM'} )
		Case nOrdem == 5 // VENDEDOR
			oTable:AddIndex( "IND1", {'NOMEVEN','NUM','ITEM'} )
		Case nOrdem == 6  // INICIO DE MONTAGEM
			oTable:AddIndex( "IND1", {'DTMONTA','NUM','ITEM'} )
		Case nOrdem == 7  // DATA DE ENTREGA REAL
			oTable:AddIndex( "IND1", {'DATENTR','NUM','ITEM'} )
	EndCase

	oTable:Create()

	dbSelectArea("TRB")
	TRB->(dbGoTop())

	mv_par14 := Alltrim(mv_par14)

	/*
	nOrdem  := aReturn[8]
	Do Case
	Case nOrdem = 1  // PEDIDO
	IndRegua("TRB",cArqTrab,"NUM+ITEM+PRODUTO",,,"Selecionando Registros...")        
	Case nOrdem = 2  // PRODUTO
	IndRegua("TRB",cArqTrab,"PRODUTO+NUM+ITEM",,,"Selecionando Registros...")        
	Case nOrdem = 3  // CLIENTE
	IndRegua("TRB",cArqTrab,"NOMECLI+NUM+ITEM",,,"Selecionando Registros...")        
	Case nOrdem = 4  // DATA DE ENTREGA PREVISTA
	IndRegua("TRB",cArqTrab,"DTOS(DTPRVENT)+NUM+ITEM",,,"Selecionando Registros...") 
	Case nOrdem = 5 // VENDEDOR
	IndRegua("TRB",cArqTrab,"NOMEVEN+NUM+ITEM",,,"Selecionando Registros...")        
	Case nOrdem = 6  // INICIO DE MONTAGEM
	IndRegua("TRB",cArqTrab,"DTOS(DTMONTA)+NUM+ITEM",,,"Selecionando Registros...") 
	Case nOrdem = 7  // DATA DE ENTREGA REAL
	IndRegua("TRB",cArqTrab,"DTOS(DATENTR)+NUM+ITEM",,,"Selecionando Registros...") 
	EndCase
	*/

	//Cria arquivo de Trabalho para totalizador de tipo de pedido e data de entrega (FMD - 06/07/11)
	If Select("TOT") > 0 
		DbSelectArea("TOT")
		TOT->(DbCloseArea())
	Endif

	AADD(aItemTmp,{ "ENTREGA","D",08,0 } )
	AADD(aItemTmp,{ "TIPO"   ,"C",01,0 } )

	oTable := FWTemporaryTable():New("TOT",aItemTmp)
	oTable:AddIndex( "IND1", {'TIPO','ENTREGA'} )
	oTable:Create()

	If Select("QR1") > 0 
		DbSelectArea("QR1") 
		QR1->(DbCloseArea())
	Endif

	If Substr(cNumEmp,1,2) $ "15_40"  // Labortub

		_cQuery := "SELECT  SC5.C5_NUM,     SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_MSCATEG, SC5.C5_MSPOSIC, SC5.C5_CONDPAG, SC5.C5_VEND1,  SC5.C5_VEND2,   "
		_cQuery += "        SC5.C5_VEND3,   SC5.C5_PC,      SC5.C5_MSVLPED, SC5.C5_MOEDA,   SC5.C5_FILIAL,  SC5.C5_MSLINK, SC5.C5_EMISSAO, "
		_cQuery += "        SC5.C5_ORCAM,   SC5.C5_MSDTCE,  SC5.C5_MSVISIT, SC5.C5_MSDTPEN, SC5.C5_MSDTENT, SC5.C5_MSCONCL, SC5.C5_MSDTCE, SC5.C5_MSMONT,  "
		_cQuery += "        SC5.C5_MSDTLBF, SC5.C5_MSPAGO,  SC5.C5_MSGARAN, SC5.C5_MSMULTA, SC5.C5_TIPO,    SC5.C5_MSMONTA, SC5.C5_MSENG,  SC5.C5_MSTPVEN, "
		_cQuery += "        SC5.C5_NOTA, C5_NATUREZ,   "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),SC5.C5_MSPEND)),' ' ) AS C5_MSPEND,  "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),SC5.C5_OBS)),' ' ) AS C5_OBS,  "
		_cQuery += "        SC6.C6_NUM,     SC6.C6_ITEM,    SC6.C6_PRODUTO, SC6.C6_QTDVEN,  SC6.C6_QTDENT,  SC6.C6_DESCRI,  SC6.C6_NUMOP,  "
		_cQuery += "        SC6.C6_QTDEMP,  SC6.C6_ITEMOP,  SC6.C6_PEDCLI,  SC6.C6_VALOR,   SC6.C6_PRCVEN,  SC6.C6_MSDTLIB, SC6.C6_DATFAT, "
		_cQuery += "        SC6.C6_ENTREG,  SA1.A1_PAIS,    SA1.A1_NREDUZ,  SYA.YA_DESCR,   SE4.E4_DESCRI,  SA3.A3_NREDUZ,   "
		_cQuery += "        SB1.B1_GRUPO,   SB1.B1_ETIQUET, SB1.B1_MSMAQUI, SB1.B1_POSIPI,  SB1.B1_IPI, SB1.B1_UM,B1_PROCED, "
		_cQuery += "        SB2.B2_QATU,    SB2.B2_RESERVA, SC9.C9_PEDIDO,  SC9.C9_ITEM,    SC9.C9_BLCRED,  SC9.C9_BLEST,    "
		_cQuery += "        SZM.ZM_PEDIDO,  SZM.ZM_ASSUNTO, SZM.ZM_STATUS,  SBM.BM_DESC,    "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGCOM)),' ' ) AS ZM_LOGCOM,    "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGENG)),' ' ) AS ZM_LOGENG,    "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGPROD)),' ' ) AS ZM_LOGPROD,  "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGMONT)),' ' ) AS ZM_LOGMONT,  "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGTEST)),' ' ) AS ZM_LOGTEST   "
		_cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
		_cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' "
		_cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND "
		_cQuery += "                                 SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  "
		_cQuery += "INNER JOIN "+RetSqlName("SYA")+" SYA ON SYA.YA_FILIAL = '"+xFilial("SYA")+"' AND SYA.YA_CODGI = SA1.A1_PAIS AND SYA.D_E_L_E_T_ = ' ' "
		_cQuery += "INNER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' AND SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
		_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SBM")+" SBM ON SBM.BM_FILIAL = '"+xFilial("SBM")+"' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ' ' "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SB2")+" SB2 ON SB2.B2_FILIAL = '"+xFilial("SB2")+"' AND SB2.B2_COD = SC6.C6_PRODUTO AND "
		_cQuery += "                                      SB2.D_E_L_E_T_ = ' '  "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SC9")+" SC9 ON SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND SC9.C9_PEDIDO = SC6.C6_NUM "
		_cQuery += "                                      AND SC9.C9_ITEM = SC6.C6_ITEM AND SC9.C9_NFISCAL = ' ' AND SC9.D_E_L_E_T_ = ' '  "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SZM")+" SZM ON SZM.ZM_FILIAL = '"+xFilial("SZM")+"' AND SZM.ZM_ASSUNTO = 'LOGAPV' AND  "
		_cQuery += "                                      SZM.ZM_PEDIDO = SC5.C5_NUM AND SZM.D_E_L_E_T_ = ' ' "
		_cQuery += "WHERE SC5.C5_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
		_cQuery += "  AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND C6_BLQ = ' '   "  // alterado lizandra (não estava tratando resíduo - 26/03/14
		_cQuery += "  AND SC5.C5_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		_cQuery += "  AND SC5.C5_MSDTENT BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "

		If mv_par19 == 1         
			_cQuery += " AND SC5.C5_VEND1 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
		Else
			_cQuery += " AND SC5.C5_VEND1 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
			_cQuery += " AND SC5.C5_VEND2 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
			_cQuery += " AND SC5.C5_VEND3 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
		EndIf

		If SubStr(cNumEmp,1,2) == "01"  .OR. Substr(cNumEmp,1,2) == "10"
			If MV_PAR20 == 1 
				_cQuery += " AND SB1.B1_ETIQUET = 'S' "
			EndIf
			If MV_PAR15 == 2
				_cQuery += " AND SC5.C5_MSPOSIC <> ' ' "
			ElseIf MV_PAR15 == 3
				_cQuery += " AND SC5.C5_MSPOSIC = ' ' "
			EndIf
		EndIf

		_cQuery += "  AND SA1.A1_PAIS BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
		_cQuery += "  AND SC5.C5_TIPO = 'N' "                  
		_cQuery += "  AND SC5.C5_NOTA = ' ' "
		_cQuery += "  AND SC6.C6_QTDENT < SC6.C6_QTDVEN  "
		_cQuery += "  AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' ' "
		_cQuery += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO  "

	Else

		_cQuery := "SELECT  SC5.C5_NUM,     SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_MSCATEG, SC5.C5_MSPOSIC, SC5.C5_CONDPAG, SC5.C5_VEND1,  SC5.C5_VEND2,   "
		_cQuery += "        SC5.C5_VEND3,   SC5.C5_PC,      SC5.C5_MSVLPED, SC5.C5_MOEDA,   SC5.C5_FILIAL,  SC5.C5_MSLINK, SC5.C5_EMISSAO, "
		_cQuery += "        SC5.C5_ORCAM,   SC5.C5_MSDTCE,  SC5.C5_MSVISIT, SC5.C5_MSDTPEN, SC5.C5_MSDTENT, SC5.C5_MSCONCL, SC5.C5_MSDTCE, SC5.C5_MSMONT,  "
		_cQuery += "        SC5.C5_MSDTLBF, SC5.C5_MSPAGO,  SC5.C5_MSGARAN, SC5.C5_MSMULTA, SC5.C5_TIPO,    SC5.C5_MSMONTA, SC5.C5_MSENG,  SC5.C5_MSTPVEN, "
		_cQuery += "        SC5.C5_NOTA,  C5_NATUREZ,  "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),SC5.C5_MSPEND)),' ' ) AS C5_MSPEND,  "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),SC5.C5_OBS)),' ' ) AS C5_OBS,  "
		_cQuery += "        SC6.C6_NUM,     SC6.C6_ITEM,    SC6.C6_PRODUTO, SC6.C6_QTDVEN,  SC6.C6_QTDENT,  SC6.C6_DESCRI,  SC6.C6_NUMOP,  "
		_cQuery += "        SC6.C6_QTDEMP,  SC6.C6_ITEMOP,  SC6.C6_PEDCLI,  SC6.C6_VALOR,   SC6.C6_PRCVEN,  SC6.C6_MSDTLIB, SC6.C6_DATFAT, "
		//Ivandro Santos - 15/12/16
		//Ticket#2016121537000128 — Pedidos intercompany
		_cQuery += "        SC6.C6_ENTREG,  SC6.C6_MSITPEC,	SA1.A1_PAIS,    SA1.A1_NREDUZ,  SYA.YA_DESCR,   SE4.E4_DESCRI,  SA3.A3_NREDUZ,  "
		//Ticket#2016121537000128 — Fim da alteração
		_cQuery += "        SB1.B1_GRUPO,   SB1.B1_ETIQUET, SB1.B1_MSMAQUI, SB1.B1_POSIPI,  SB1.B1_IPI, SB1.B1_UM,B1_PROCED, "
		_cQuery += "        SB2.B2_QATU,    SB2.B2_RESERVA, SC9.C9_PEDIDO,  SC9.C9_ITEM,    SC9.C9_BLCRED,  SC9.C9_BLEST,   "
		_cQuery += "        SZM.ZM_PEDIDO,  SZM.ZM_ASSUNTO, SZM.ZM_STATUS,  SBM.BM_DESC,    "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGCOM)),' ' ) AS ZM_LOGCOM,    "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGENG)),' ' ) AS ZM_LOGENG,    "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGPROD)),' ' ) AS ZM_LOGPROD,  "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGMONT)),' ' ) AS ZM_LOGMONT,  "
		_cQuery += "        ISNULL(CONVERT(VARCHAR(5000),CONVERT(VARBINARY(5000),SZM.ZM_LOGTEST)),' ' ) AS ZM_LOGTEST,   "
		//Ivandro Santos - 15/12/16
		//Ticket#2016121537000128 — Pedidos intercompany
		_cQuery += "        ISNULL(DA1_PRCVEN,0 ) AS DA1_PRCVEN   "
		_cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
		_cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' "
		_cQuery += "LEFT  JOIN "+RetSqlName("DA1")+" DA1 ON DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND SC6.C6_PRODUTO = DA1.DA1_CODPRO AND "
		_cQuery += "                                 DA1.D_E_L_E_T_ = ' ' AND DA1.DA1_CODTAB = '"+Alltrim(GetMv("MS_CODTABI"))+"' "	
		//Ticket#2016121537000128 — Fim da Alteração
		_cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND "
		_cQuery += "                                 SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  "
		_cQuery += "INNER JOIN "+RetSqlName("SYA")+" SYA ON SYA.YA_FILIAL = '"+xFilial("SYA")+"' AND SYA.YA_CODGI = SA1.A1_PAIS AND SYA.D_E_L_E_T_ = ' ' "
		_cQuery += "INNER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' AND SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
		_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SBM")+" SBM ON SBM.BM_FILIAL = '"+xFilial("SBM")+"' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ' ' "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SB2")+" SB2 ON SB2.B2_FILIAL = '"+xFilial("SB2")+"' AND SB2.B2_COD = SC6.C6_PRODUTO AND "
		_cQuery += "                                      SB2.B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = ' '  "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SC9")+" SC9 ON SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND SC9.C9_PEDIDO = SC6.C6_NUM "
		_cQuery += "                                      AND SC9.C9_ITEM = SC6.C6_ITEM AND SC9.C9_NFISCAL = ' ' AND SC9.D_E_L_E_T_ = ' '  "
		_cQuery += "LEFT OUTER JOIN "+RetSqlName("SZM")+" SZM ON SZM.ZM_FILIAL = '"+xFilial("SZM")+"' AND SZM.ZM_ASSUNTO = 'LOGAPV' AND  "
		_cQuery += "                                      SZM.ZM_PEDIDO = SC5.C5_NUM AND SZM.D_E_L_E_T_ = ' ' "
		_cQuery += "WHERE SC5.C5_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
		_cQuery += "  AND SC6.C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "
		_cQuery += "  AND SC5.C5_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		_cQuery += "  AND SC5.C5_MSDTENT BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "

		If mv_par19 == 1         
			_cQuery += " AND SC5.C5_VEND1 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
		Else
			_cQuery += " AND SC5.C5_VEND1 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
			_cQuery += " AND SC5.C5_VEND2 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
			_cQuery += " AND SC5.C5_VEND3 BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
		EndIf

		If SubStr(cNumEmp,1,2) == "01"  .OR. Substr(cNumEmp,1,2) == "10"
			If MV_PAR20 == 1 
				_cQuery += " AND SB1.B1_ETIQUET = 'S' "
			EndIf
			If MV_PAR15 == 2
				_cQuery += " AND SC5.C5_MSPOSIC <> ' ' "
			ElseIf MV_PAR15 == 3
				_cQuery += " AND SC5.C5_MSPOSIC = ' ' "
			EndIf
		EndIf
		_cQuery += "  AND SA1.A1_PAIS BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
		_cQuery += "  AND SC5.C5_TIPO = 'N' "                  
		_cQuery += "  AND SC5.C5_NOTA = ' ' "
		_cQuery += "  AND SC6.C6_QTDENT < SC6.C6_QTDVEN  "
		_cQuery += "  AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' ' "
		_cQuery += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO  "

	EndIf	

	TcQuery _cQuery New Alias "QR1"

	TcSetField("QR1","C5_EMISSAO","D",08,00)
	TcSetField("QR1","C5_MSDTPEN","D",08,00)
	TcSetField("QR1","C5_MSDTENT","D",08,00)
	TcSetField("QR1","C5_MSDTLBF","D",08,00)
	TcSetField("QR1","C5_MSDTCE" ,"D",08,00)
	TcSetField("QR1","C5_MSCONCL","D",08,00)
	TcSetField("QR1","C6_MSDTLIB","D",08,00)
	TcSetField("QR1","C5_MSMONTA","D",08,00)
	TcSetField("QR1","C6_DATFAT" ,"D",08,00)
	TcSetField("QR1","C6_ENTREG" ,"D",08,00)

	SetRegua(QR1->(RecCount() ))

	Do While !QR1->(Eof()) 
		If QR1->C6_NUM == '574692'
			ALERT("ACHEI")
		EndIf                                   
		If SubStr(cNumEmp,1,2) $ "01_10"
			If !Empty(mv_par14) .And. !(QR1->C5_MSCATEG $ mv_par14)
				QR1->(dbSkip())
				Loop
			EndIf
		EndIf  

		cPais     := QR1->A1_PAIS
		cNomePais := QR1->YA_DESCR 

		If !Empty(QR1->E4_DESCRI)
			cCondPgto := QR1->E4_DESCRI
		Else
			cCondPgto := QR1->C5_CONDPAG
		EndIf         

		If !Empty(QR1->A3_NREDUZ)
			cNomeVend  := QR1->A3_NREDUZ
		Else
			cNomeVend := ""
		EndIf

		nItens  := 0
		cPedido := QR1->C5_NUM

		Do While cPedido == QR1->C6_NUM

			If SubStr(cNumEmp,1,2) $ "15_40_45"
				cGrupo   := QR1->B1_GRUPO
				cGrpDesc := QR1->BM_DESC
			EndIf

			//GravaCabPed()

			If TRB->(dbSeek(QR1->C5_NUM+QR1->C6_ITEM+QR1->C6_PRODUTO))
				RecLock("TRB",.F.)
				TRB->ESTOQUE  += QR1->B2_QATU   
				TRB->(MsUnLock())

			Else
				RecLock("TRB",.T.)
				TRB->NUM     := QR1->C5_NUM
				TRB->LINK    := QR1->C5_MSLINK
				TRB->CATEG   := QR1->C5_MSCATEG
				TRB->NATUREZ := QR1->C5_NATUREZ
				TRB->EMISSAO := QR1->C5_EMISSAO
				TRB->NUMCE   := QR1->C5_ORCAM
				TRB->DATACE  := QR1->C5_MSDTCE
				TRB->GARANTIA:= QR1->C5_MSGARANT
				TRB->VISITA  := QR1->C5_MSVISIT
				TRB->MULTA   := QR1->C5_MSMULTA
				TRB->CLIENTE := QR1->C5_CLIENTE
				TRB->NOMECLI := QR1->A1_NREDUZ
				TRB->LOJA    := QR1->C5_LOJACLI					
				TRB->VENDEDOR:= QR1->C5_VEND1
				TRB->NOMEVEN := cNomeVend 
				TRB->PAIS    := cPais                                  
				TRB->NOMEPAIS:= cNomePais 
				TRB->DATENTR := QR1->C5_MSDTENT
				If !Empty(QR1->C5_MSDTPEN)
					TRB->DTPRVENT := QR1->C5_MSDTPEN
				Else
					TRB->DTPRVENT := QR1->C5_MSDTENT					
				EndIf		
				If SubStr(cNumEmp,1,2) $ "01_10" 
					If QR1->C5_MSMONT > 0
						TRB->MONTAPV := QR1->C5_MSMONT
						TRB->DTPECAS := DTPRVENT - QR1->C5_MSMONT
					Else
						TRB->MONTAPV := 0   
					EndIf   
					TRB->DTMONTA := QR1->C5_MSMONTA 
					TRB->ENG     := QR1->C5_MSENG
					TRB->TPVEN   := QR1->C5_MSTPVEN    
				ELSEIF SubStr(cNumEmp,1,2) $ "15_40_45"	
					TRB->ENG     := QR1->C5_MSENG
				EndIf

				TRB->POSPED  := Alltrim(QR1->C5_MSPOSIC)
				TRB->PEND    := Alltrim(QR1->C5_MSPEND)
				TRB->OBS     := Alltrim(QR1->C5_OBS)
				TRB->DTCONCL := QR1->C5_MSCONCL
				TRB->DTLIBFAT:= QR1->C5_MSDTLBF
				TRB->MSPAGO  := QR1->C5_MSPAGO
				TRB->CONDPGTO:= cCondPgto
				//dbSelectArea("TRB")

				TRB->ITEM    := QR1->C6_ITEM
				TRB->PRODUTO := QR1->C6_PRODUTO
				If !(SubStr(cNumEmp,1,2) $ "01_10")
					TRB->DESCRICAO := QR1->C6_DESCRI
				Else   
					If mv_par20 == 2
						TRB->DESCRICAO := QR1->C6_DESCRI
					Else
						TRB->DESCRICAO := Alltrim(QR1->B1_MSMAQUI)
					EndIf   
				EndIf
				TRB->POSIPI   := QR1->B1_POSIPI   
				TRB->TESTES   := QR1->B1_IPI
				TRB->QTDVEN   := QR1->C6_QTDVEN 
				TRB->PEDCLII  := IIF(EMPTY(QR1->C6_PEDCLI),QR1->C5_PC,QR1->C6_PEDCLI)
				IF SubStr(cNumEmp,1,2) $ "01_10"	
					TRB->ITEMPC	  := QR1->C6_MSITPEC
				Endif
				TRB->NUMOP	  := QR1->C6_NUMOP+QR1->C6_ITEMOP	 
				TRB->PRCVEN   := QR1->C6_PRCVEN 
				TRB->QTDEMP   := QR1->C6_QTDEMP 
				TRB->QTDENT   := QR1->C6_QTDENT
				TRB->ESTOQUE  := QR1->B2_QATU   
				TRB->UM  	  := QR1->B1_UM
				TRB->VALOR    := QR1->C6_VALOR
				TRB->PEDCLI   := QR1->C5_PC
				//			TRB->PRIORI   := QR1->C5_MSPRIOR
				TRB->DTLIBERA := QR1->C6_MSDTLIB
				TRB->DTFAT    := QR1->C6_DATFAT

				If SubStr(cNumEmp,1,2) $ "15_40_45"
					TRB->MSGRUPO := cGrpDesc
				EndIf

				TRB->B2QATU   := QR1->B2_QATU
				TRB->B2RESER  := QR1->B2_RESERVA
				//Ivandro Santos
				//Ticket#2017072137000035 — Relatorios de pedido por categoria
				//Ivandro Santos - 14/09/17 - Ticket#2017091237000031 — prazo de entrega
				If Upper(cDeptoUsu) $ "207-PCP_205-ALMOXARIFADO"					
					TRB->DTPRENITPV:= QR1->C6_ENTREG				//TRB->DTPRVENT:= QR1->C6_ENTREG 
				Endif
				If SubStr(cNumEmp,1,2) $ "01_10"                    //If !(SubStr(cNumEmp,1,2) $ "01_10")
					//Ticket#2017072137000035 — Fim da alteração
					IF !EMPTY(QR1->C5_MSDTPEN)						//IF !EMPTY(SC5->C5_MSDTPEN)
						//Ticket#2017091237000031 — fim da alteração                
						TRB->DTPRVENT := QR1->C5_MSDTPEN
					ELSE
						TRB->DTPRVENT := QR1->C5_MSDTENT
					ENDIF      
				EndIf

				If SUBSTR(cNumEmp,1,2) $ "01_10"
					dbSelectArea("AA3")
					AA3->(DBORDERNICKNAME("AA3_PEDPRO"))
					If AA3->(dbSeek(xFilial("AA3")+QR1->C6_NUM))
						If !Empty(AA3->AA3_DTINST)
							TRB->DTINSTAL := AA3->AA3_DTINSTAL
						EndIf
					EndIf                                                                                         
				EndIf

				TRB->OP := ""    // Situação no SC9  
				_cNum:=""
				_cItem:=""
				If !EMPTY(QR1->C9_PEDIDO)	
					_cNum  := QR1->C6_NUM
					_cItem := QR1->C6_ITEM
					If (QR1->C9_PEDIDO+QR1->C9_ITEM ) == ( _cNum + _cItem )
						If QR1->C9_BLEST == "02" .AND. QR1->C9_BLCRED == "01"
							TRB->OP := "CREDITO/ESTOQUE"
						ElseIf	QR1->C9_BLEST == "  " .AND. QR1->C9_BLCRED == "01"
							TRB->OP := "CREDITO" 
						ElseIf 	QR1->C9_BLEST == "02" .AND. QR1->C9_BLCRED == "  "
							TRB->OP := "ESTOQUE" 
						ElseIf 	QR1->C9_BLEST == "  " .AND. QR1->C9_BLCRED == "  "
							TRB->OP := "LIBERADO P/FATURAMENTO"
						EndIf	 
					EndIf
				Else
					TRB->OP := ""
				EndIf

				_cBloq := ""
				If QR1->C6_QTDENT == QR1->C6_QTDVEN
					TRB->OP := "TOTALMENTE FATURADO"
				ElseIf QR1->C6_QTDEMP > 0 .AND. QR1->C6_QTDEMP < QR1->C6_QTDVEN 	
					If Empty(TRB->OP)
						TRB->OP := "PARCIALMENTE FATURADO"
					EndIf
				EndIf	

				nItens++
				If nItens == 1
					// Grava os Logs da Reuniao do PV
					lLogCom   := .F.
					lLogEng   := .F.
					lLogProd  := .F. 
					lLogMont  := .F.
					lLogTest  := .F.
					If QR1->ZM_PEDIDO == QR1->C5_NUM .And. QR1->ZM_ASSUNTO == "LOGAPV"
						If QR1->ZM_STATUS <> "E"
							If !Empty(QR1->ZM_LOGCOM)
								lLogCom := .T.
							EndIf
							If !Empty(QR1->ZM_LOGENG)
								lLogEng := .T.
							EndIf
							If !Empty(QR1->ZM_LOGPROD)
								lLogProd := .T.
							EndIf 
							If !Empty(QR1->ZM_LOGMONT)
								lLogMont := .T.
							EndIf
							If !Empty(QR1->ZM_LOGTEST)
								lLogTest := .T.
							EndIf         
						EndIf   
					EndIf
					If lLogCom
						TRB->COMERC := "1"
					EndIf
					If lLogEng
						TRB->ENGMC := "1"
					EndIf
					If lLogProd
						TRB->PCP := "1"
					EndIf
					If lLogMont
						TRB->MONTAG := "1"
					EndIf        
					nValorPed := QR1->C5_MSVLPED
					cMoeda := "SM2->M2_MOEDA" + STR(QR1->C5_MOEDA,1,0)
					nMoeda := 0
					If SM2->(DBSEEK(DATE()))
						nMoeda := &cMoeda
					EndIf
					If Empty(nMoeda)
						nMoeda := 1
					EndIf   
					TRB->VLRPED := QR1->C5_MSVLPED * nMoeda
				Else
					TRB->VLRPED := 0   
				EndIf
				IF SubStr(cNumEmp,1,2) $ "01_10"
					TRB->PRCTAB := QR1->DA1_PRCVEN  
				Endif

				TRB->PROCED1 := QR1->B1_PROCED

				MsUnLock()

			EndIf

			QR1->(IncProc())
			QR1->(dbSkip())

		EndDo

		If nItens == 0
			GravaCabPed()

			dbSelectArea("TRB")
			TRB->ITEM      := ""
			TRB->PRODUTO   := "" 
			TRB->DESCRICAO := "Verificar Itens do Pedido"
			TRB->QTDVEN    := 0
			TRB->QTDEMP    := 0
			TRB->QTDENT    := 0
			TRB->(MsUnLock())
		EndIf

		GravaTot()		// Funcao que cria arquivo temporario para totalizar pedidos

		Loop
	EndDo

Return


/*/{Protheus.doc} GravaCabPed
//TODO Grava o cabeçalho do pedido de venda na temporaria
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return nil

@type function
/*/
Static Function GravaCabPed()


	dbSelectArea("TRB")
	RecLock("TRB",.T.)

	//TRB->FILIAL  := QR1->C5_FILIAL
	TRB->NUM     := QR1->C5_NUM
	TRB->LINK    := QR1->C5_MSLINK
	TRB->CATEG   := QR1->C5_MSCATEG
	TRB->NATUREZ := QR1->C5_NATUREZ
	TRB->EMISSAO := QR1->C5_EMISSAO
	TRB->NUMCE   := QR1->C5_ORCAM
	TRB->DATACE  := QR1->C5_MSDTCE
	TRB->GARANTIA:= QR1->C5_MSGARANT
	TRB->VISITA  := QR1->C5_MSVISIT
	TRB->MULTA   := QR1->C5_MSMULTA
	TRB->CLIENTE := QR1->C5_CLIENTE
	TRB->NOMECLI := QR1->A1_NREDUZ
	TRB->LOJA    := QR1->C5_LOJACLI					
	TRB->VENDEDOR:= QR1->C5_VEND1
	TRB->NOMEVEN := cNomeVend 
	TRB->PAIS    := cPais                                  
	TRB->NOMEPAIS:= cNomePais 
	TRB->DATENTR := QR1->C5_MSDTENT
	If !Empty(QR1->C5_MSDTPEN)
		TRB->DTPRVENT := QR1->C5_MSDTPEN
	Else
		TRB->DTPRVENT := QR1->C5_MSDTENT
	EndIf   

	If SubStr(cNumEmp,1,2) $ "01_10" 
		If QR1->C5_MSMONT > 0
			TRB->MONTAPV := QR1->C5_MSMONT
			TRB->DTPECAS := DTPRVENT - QR1->C5_MSMONT
		Else
			TRB->MONTAPV := 0   
		EndIf   
		TRB->DTMONTA := QR1->C5_MSMONTA 
		TRB->ENG     := QR1->C5_MSENG
		TRB->TPVEN   := QR1->C5_MSTPVEN    
	EndIf

	TRB->POSPED  := Alltrim(QR1->C5_MSPOSIC)
	TRB->PEND    := Alltrim(QR1->C5_MSPEND)
	TRB->OBS     := Alltrim(QR1->C5_OBS)
	TRB->DTCONCL := QR1->C5_MSCONCL
	TRB->DTLIBFAT:= QR1->C5_MSDTLBF
	TRB->MSPAGO  := QR1->C5_MSPAGO
	TRB->CONDPGTO:= cCondPgto

Return


/*/{Protheus.doc} GravaTot
//TODO Executa a gravação do total na temporaria
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return nil

@type function
/*/
Static Function GravaTot()


	dbSelectArea("TOT")

	If (QR1->C5_MSCATEG == "1" .OR. (SUBSTR(cNumEmp,1,2) $ '15_40_45')) .And. Empty(QR1->C5_MSCONCL) .And. Empty(QR1->C5_NOTA)

		If Substr(cNumEmp,1,2) == "01"
			Do Case
				Case QR1->C5_MSENG == "E"		// Especial
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "E"
				TOT->(MsUnlock())
				Case QR1->C5_MSENG == "H"		// Horizontal
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "H"
				TOT->(MsUnlock())
				Case QR1->C5_MSENG == "A"		// Acessorios
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "A"
				TOT->(MsUnlock())
				Case Empty(QR1->C5_MSENG) .Or. QR1->C5_MSENG == "N"		// Não definido
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "N"
				TOT->(MsUnlock())
				Case QR1->C5_MSENG == "V"		// Vertical
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "V"
				TOT->(MsUnlock())
			End Case
		Elseif Substr(cNumEmp,1,2) == "10"
			Do Case
				Case QR1->C5_MSENG == "A"	// Acessorios
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "A"
				TOT->(MsUnlock())

				Case QR1->C5_MSENG == "B"	// Emblistadora
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "B"
				TOT->(MsUnlock())

				Case QR1->C5_MSENG == "C"	// Encartuchadora
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "C"
				TOT->(MsUnlock())

				Case QR1->C5_MSENG == "E"	// Especiais
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "E"
				TOT->(MsUnlock())

				Case QR1->C5_MSENG == "G"	// Garvens
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "G"
				TOT->(MsUnlock())

				Case QR1->C5_MSENG == "P"	// Empacotadora
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "P"
				TOT->(MsUnlock())

				Case Empty(QR1->C5_MSENG) .Or. QR1->C5_MSENG == "N"		// Nao definido
				RecLock("TOT",.T.)
				TOT->ENTREGA	:= QR1->C5_MSDTENT
				TOT->TIPO		:= "N"
				TOT->(MsUnlock())
			EndCase
		Endif
	Endif

Return



/*/{Protheus.doc} ImpParam
//TODO Faz a impressão dos parametros
@author alison.goncalves
@since 30/04/2018
@version 1.0
@return nil

@type function
/*/
Static Function ImpParam()


	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	Li:= 10
	@ Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
	Li+=2
	@ Li,000 Psay "Pedido de..........: " + mv_par01
	@ Li,037 Psay "ate: " + mv_par02
	Li++
	@ Li,000 Psay "Produto de.........: " + mv_par03
	@ Li,037 Psay "ate: " + mv_par04
	Li++
	@ Li,000 Psay "Cliente de.........: " + mv_par05
	@ Li,037 Psay "ate: " + mv_par06
	Li++
	@ Li,000 Psay "Data de Entrega de.: " + DTOC(mv_par07)
	@ Li,037 Psay  "ate: " + DTOC(mv_par08)
	Li++
	@ Li,000 Psay "Imprime Pedidos....: "
	If mv_par09 == 1
		@ Li,021 Psay "Concluidos"
	ElseIf mv_par09 == 2 
		@ Li,021 Psay "Não Concluidos"
	Else
		@ Li,021 Psay "Todos"
	Endif 
	Li++
	@ Li,000 Psay "Vendedor de........: " + mv_par10
	@ Li,037 Psay "ate: " + mv_par11
	Li++
	@ Li,000 Psay "Pais de............: " + mv_par12
	@ Li,037 Psay "ate: " + mv_par13
	Li++
	@ Li,000 Psay "Categoria..........: " + mv_par14
	Li++
	@ Li,000 Psay "Situação do Pedido.: "
	Do Case
		Case  mv_par15 == 1
		@ Li,021 Psay "Todos"
		Case mv_par15 == 2 
		@ Li,021 Psay "Em Montagem"
		Case mv_par15 == 3
		@ Li,021 Psay "Sem Montagem" 
	EndCase
	Li++
	@ Li,000 Psay "Imprime............: " 
	If mv_par16 == 1  //Coluna   (Saldo / Data Lib.Engen)
		@ Li,021 Psay "Saldo"
	Else
		@ Li,021 Psay "Data de Liberação"
	EndIf
	Li++
	@ Li,000 Psay "Gera Arq. p/ Excel.: " 
	If mv_par17 == 1  //Gera Arq.p/Excel
		@ Li,021 Psay "Sim   =>  Arquivo:  C:\Relato_Microsiga\Pedidos_a_faturar.csv"
	Else
		@ Li,021 Psay "Não"
	EndIf
	Li++
	@ Li,000 Psay "Grava Itens p/Excel.: " 
	If mv_par18 == 1  //Grava Itens p/Excel
		@ Li,021 Psay "Sim"
	Else
		@ Li,021 Psay "Não"
	EndIf
	Li++
	@ Li,000 Psay "Analise Vendedores.: " 
	If mv_par19 == 1  
		@ Li,021 Psay "Somente o Vendedor 1"
	Else
		@ Li,021 Psay "Todos os Vendedores do Pedido"
	EndIf
	Li++
	@ Li,000 Psay "Apenas Etiqueta....: " 
	If mv_par20 == 1  
		@ Li,021 Psay "Sim"
	Else
		@ Li,021 Psay "Não"
	EndIf
	Li++
	@ Li,000 Psay "Acompanhamento PV..: " 
	If mv_par21 == 1  
		@ Li,021 Psay "Em Aberto"
	ElseIf mv_par21 == 2
		@ Li,021 Psay "Todos"
	Else
		@ Li,021 Psay "Nenhum"   
	EndIf
	Li:=80      

Return