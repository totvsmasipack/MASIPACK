#INCLUDE "RPCPR010.CH" 
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
 
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	 ³ RPCPR010³ Autor ³ Aparecida de F.Stevanato ³Data ³  17.10.07 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Emite Resumo de Componentes por Estrutura     	            ³±± 
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 

#Include "Rwmake.ch"

User Function RPCPR010()

PRIVATE cFiltro     := SubStr(cUserName,1,TamSX3('Z3_USUARIO')[1])
PRIVATE titulo      := STR0001 
PRIVATE cString     := ""
PRIVATE wnrel       := "RPCPR010"
Private _aOrd       := {"Produto","Data de Revisão"}
Private nOrdem      := 1
PRIVATE aReturn     := { STR0005, 1,STR0006, 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
PRIVATE nomeprog    := "RPCPR010"
PRIVATE cPerg	    := "RPCP10"
PRIVATE cArqTrab    := ""
PRIVATE cCopia      := ""
PRIVATE cFilTrab    := ""
PRIVATE nLastKey    := 0
PRIVATE m_pag       := 0
PRIVATE Li          := 99 
PRIVATE cabec1      := ""
PRIVATE cabec2      := ""
PRIVATE tamanho     := "M"
PRIVATE limite      := 132
PRIVATE CbCont      := 0
PRIVATE cProd       := ""
PRIVATE cConsulta   := ""
PRIVATE cSeqSZ3    := ""
PRIVATE cNomeCons   := ""
PRIVATE nEstru      := 0
PRIVATE aStru       := {}
PRIVATE aConjuntos  := {}
PRIVATE NumCons     := 0
PRIVATE nFalta      := 0
PRIVATE I           := 0
PRIVATE J           := 0
PRIVATE _cPath      := ""
PRIVATE cDesenho    := ""
PRIVATE aDesenhos   := {} 
PRIVATE aOPeracoes  := {}
PRIVATE FAchou      := .F. 
PRIVATE nHor        := 0
PRIVATE nMin        := 0
PRIVATE nTotHor     := 0
PRIVATE nTotSetup   := 0
PRIVATE nTotOper    := 0
PRIVATE nLote       := 0
PRIVATE nDias       := 0
PRIVATE _nOpc       := 0
PRIVATE nCustoHH    := 0
PRIVATE nVlrMObra   := 0
PRIVATE nTotMObra   := 0
PRIVATE nTotMPrima  := 0
PRIVATE nTotAcess   := 0 
Private cArqCSV     := "C:\Relato_Microsiga\Resumo_Componentes.csv"
Private cRegCSV     := ""

cPedido := Space(06)

@ 089,177 To 450,588 Dialog _oDlg1 Title OemToAnsi("Resumo de Componente por Estrutura")
@ 009,011 To 045,188
@ 063,011 To 140,188
@ 020,024 Say OemToAnsi("Esta rotina gera Resumo de Componentes por Estrutura")  Size 151,010
@ 034,024 Say OemToAnsi("de Produtos ou Pedido de Vendas.") 					 Size 151,010
@ 085,024 Say OemToAnsi("Digite o Pedido de Vendas ou Tecle <ENTER>")			 Size 151,010 
@ 100,024 Say OemToAnsi("para Entrar com o Produto ou Escolher uma Consulta")    Size 151,010
@ 082,140 Get cPedido  Valid ChecaPedido()   	                     			 Size 030,010 
@ 160,095 BmpButton Type 1 Action Processa( { || ExibeTabela() } )
@ 160,142 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1 

Return

Static Function ExibeTabela()

cCadastro := "Resumo de Componentes"
Private aRotina := {{"Pesquisar"		,"AxPesqui"	   ,0,1} ,;    // Pesquisa na tabela SZ3
                    {"Visualizar"		,"U_RPCPA005()",0,2} ,;	    // Visualizacao Modelo 2
      		       	{"Incluir"			,"U_RPCPA002()",0,3} ,;		// Inclusao Modelo 2 
            		{"Alterar"			,"U_RPCPA003()",0,4} ,;		// Alteracao Modelo 2
		            {"Excluir"			,"U_RPCPA004()",0,5} ,;		// Exclusao Modelo 2
		            {"Gera Resumo"	    ,"U_OpcResumo()",0,6},;    // Relatorio com Resumo dos Componentes
		            {"Gera Custo"	    ,"U_OpcCusto()",0,7} }     // Relatorio com Custo dos Componentes
cString := "SZ3"

dbSelectArea("SZ3")
SZ3->(dbSetOrder(1))
SZ3->(DbGotop())

If !Empty(cPedido)
   SET FILTER TO Alltrim(SZ3->Z3_CONSULT) == Alltrim(cConsulta)
Else
   SET FILTER TO Alltrim(SZ3->Z3_USUARIO) == cFiltro
EndIf      

mBrowse( 6,1,22,75,"SZ3")

Return

User Function OpcResumo()
   _nOpc := 6 
   GeraResumo()
Return

User Function OpcCusto()
   _nOpc := 7
   GeraResumo()
Return

Static Function GeraResumo()      

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    			 ³
//³ mv_par01	 -  Consulta Material   1-Sim 2-Não              ³
//³ mv_par02	 -  Lista Conjuntos     1-Sim 2-Não              ³
//³ mv_par03	 -  Quais:  1-Fabricado 2-Comprado 3-Ambos       ³ 
//³ mv_par04	 -  Produto de                                   ³
//³ mv_par05	 -  Produto ate                                  ³
//³ mv_par06	 -  Imprime Desenhos  1-Não 2-Drive H  3-Drive P ³ 
//³ mv_par07	 -  Imprime Operações 1-Sim 2-Não                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aStru      := {}
aConjuntos := {}
aDesenhos  := {}
aOperacoes := {}
nTotMPrima := 0
nTotMObra  := 0
nTotAcess  := 0
nTotSetup  := 0
nTotOper   := 0  

If _nOpc == 6
   titulo   := STR0001
Else   
   titulo   := STR0001 + " Com Custo"
   mv_par01 := 2
   mv_par02 := 1
   mv_par03 := 3
   mv_par07 := 1
EndIf

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,_aOrd,,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

GeraTrab()       //Gera tabela trabalho com a explosão dos produtos

SetDefault(aReturn,cString) 

If (cArqCSV := FCreate("C:\Relato_Microsiga\Resumo_Componentes.csv")) == -1
   apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
   cRegCSV := "Relação do Resumo de Componentes - emitida em " + DTOC(Date()) 
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := "Codigo;Rev;Descrição;Grupo;UM;Necessidade;Saldo;Empenhos;Falta;Local;Fabricante;Descrição Prolongada"   
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := ""
EndIf

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},titulo)

Return

Static Function GeraTrab()

Local aCampos  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"CODIG"  ,"C",15,0})
AADD(aCampos,{"NECES"  ,"N",14,3})
AADD(aCampos,{"UREV"   ,"D",08,0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRB") > 0 
   DbSelectArea("TRB")
   DbCloseArea()
EndIf

cArqTrab := CriaTrab(aCampos,.T.)

dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

dbSelectArea("TRB")

IndRegua("TRB",cArqTrab,"CODIG",,,STR0015) //"Selecionando Registros..." 

cConsulta      := SZ3->Z3_CONSULT
cNomeCons      := SZ3->Z3_NOMCONS 
aDesenhos      := {} 

SZ3->(DbSetOrder(1))
SZ3->(DbSeek(xFilial("SZ3")+cConsulta))
Do While SZ3->(!Eof()) .And. Alltrim(SZ3->Z3_CONSULT) == cConsulta 
	If Select("MASI") > 0
		MASI->(dbclosearea())
	EndIf
   nEstru  := 0
   cProd   := SZ3->Z3_PRODUTO
   AADD(aConjuntos,{cProd,SZ3->Z3_QUANT})     
   SG1->(DbSetOrder(1))
   If SG1->(dbSeek(xFilial("SG1")+cProd))
      cNomeArq := Estrut2(cProd,1,"MASI") 
      MASI->(DbGotop())
      Do While !MASI->(Eof())
         If ALLTRIM(MASI->COMP) >= ALLTRIM(mv_par04) .AND. ALLTRIM(MASI->COMP) <= ALLTRIM(mv_par05)
            If !TRB->(Dbseek(MASI->COMP))
               RecLock("TRB",.T.)
               TRB->CODIG := MASI->COMP
               TRB->NECES := MASI->QUANT * SZ3->Z3_QUANT
               SB1->(DbSeek(xFilial("SB1")+TRB->CODIG))
               TRB->UREV  := SB1->B1_UREV
            Else
               RecLock("TRB",.F.)
               TRB->NECES  += MASI->QUANT * SZ3->Z3_QUANT
            EndIf   
            TRB->(MsUnlock()) 
         EndIf   
         MASI->(DbSkip())
         Loop
      EndDo
   Else
      apmsgStop("Produto sem Estrutura => "+SZ3->Z3_PRODUTO)       
   EndIf
     
   SZ3->(DbSkip())
   Loop
EndDo   

dbCommitAll() 

If Select("MASI") > 0
   FIMESTRUT2("MASI")
Endif

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	 ³ ImpRel	³     Impressao do Relatorio                        ³±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function ImpRel(lEnd,WnRel,cString)

Local J := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³                              
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Li := 80 
m_pag := 1
   
ImpParam()

If _nOpc == 6       
	Cabec1 := "Codigo          Rev Descrição                         UM Grp. Necessid.     Saldo  Empenhos     Falta  Invent.    Local Ult.Rev.    Grp.Masipack  "
///////////////999999999999999 XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXX 9.999,999 9.999,999 9.999,999 9,999.999 99/99/99 99999999 99/99/99 999999999999999
///////////////0123456789d123456789v123456789t123456789q123456789c123456789s123456789s123456789o123456789n123456789C123456789D123456789V123456789T123456789Q123456
//   Cabec1 := STR0014
Else
   Cabec1 := STR0013
EndIf      

nOrdem := aReturn[8]

If nOrdem == 1
   IndRegua("TRB",cArqTrab,"CODIG",,,STR0015) //"Selecionando Registros..."
ElseIf nOrdem == 2
   IndRegua("TRB",cArqTrab,"DTOS(UREV)+CODIG",,,STR0015) //"Selecionando Registros..."
EndIf

TRB->(dbGoTop())

SetRegua(RecCount())           	           // TOTAL DE ELEMENTOS DA REGUA 

Do While TRB->(!EOF())
    
   If lEnd
  	  @PROW()+1,001 Psay STR0016         // CANCELADO PELO OPERADOR
	  Exit
   Endif
	
   If Alltrim(TRB->CODIG) < Alltrim(mv_par04) .Or. Alltrim(TRB->CODIG) > Alltrim(mv_par05)
	   TRB->(DbSkip())
	   Loop
   EndIf
		
    SB1->(DBSetorder(1))
    If SB1->(DbSeek(xFilial("SB1")+TRB->CODIG))
	   SB2->(DbSeek(xFilial("SB2")+TRB->CODIG+"01"))
	   If (Val(SubStr(SB1->B1_PROCED,1,1)) == 1 .And. mv_par03  == 2) .Or. (Val(SubStr(SB1->B1_PROCED,1,1)) == 2 .And. mv_par03  == 1)
	   	   TRB->(DbSkip())
	       Loop
	   EndIf             
	   /*
		IF  SB1->B1_UPRC = 0  //ALTERADO - LIZANDRA 04/02/14 - TIRAR OS ZERADOS PARA APRESENTAR AO FISCAL	   
   	   TRB->(DbSkip())
	       Loop
	   ENDIF    
	   */
	   If _nOpc == 6
	      If mv_par02 == 1 .And. Alltrim(SB1->B1_UM) == "CJ"
	         TRB->(DbSkip())
	         Loop
	      EndIf


	   
	      nFalta := SB2->B2_QATU - TRB->NECES - SB2->B2_QEMP
	      
	      If mv_par01 == 1 .And. nFalta >= 0
	         TRB->(DbSkip())
	         Loop
	      EndIf
	   EndIf   
	Else
	   apmsgAlert("Componente não cadastrado - " + TRB->CODIG)
	   TRB->(DbSkip())
	   Loop   
	EndIf   
	Li++
	If Li > 60
	   Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
    EndIf   
	@li,000 Psay Alltrim(TRB->CODIG)
	@li,016 Psay SB1->B1_REVATU
	@li,020 Psay SubStr(SB1->B1_DESC,1,33)
	@li,054 Psay SB1->B1_UM
	@li,057 Psay SB1->B1_GRUPO
    @li,062 Psay TRB->NECES  Picture "@E 9,999.999"
    If _nOpc == 6
       @li,072 Psay SB2->B2_QATU  Picture "@E 9,999.999"
       @li,082 Psay SB2->B2_QEMP  Picture "@E 9,999.999"
	   If nFalta < 0
	      nFalta := nFalta * -1
	   Else
	      nFalta := 0
	   EndIf      
	   @li,092	Psay nFalta  Picture "@E 9,999.999"
	   If !Empty(SB2->B2_DINVENT)
	      @li,102 Psay SB2->B2_DINVENT
	   EndIf   
	   @li,112 Psay SB1->B1_LOCAL 
	   If !Empty(TRB->UREV)
	      @li,121 Psay TRB->UREV
	   EndIf                    
	   If !Empty(SB1->B1_MSGRPMA)
	      @li,130 Psay ALLTRIM(SB1->B1_MSGRPMA)
	   EndIf                    
	   
    EndIf
    //Ivandro Santos - 29/03/17
    //Ticket#2017011637000191 — NOME CIENTIFICO DIVERGENTE DA DESCRICAO
    _cDesP	 := GetAdvFval("SB5","B5_CEME",xFilial("SB5")+TRB->CODIG,1," ")
    cRegCSV := TRB->CODIG+";"+SB1->B1_REVATU+";"+SB1->B1_DESC+";"+SB1->B1_GRUPO+";"+SB1->B1_UM+";"+Str(TRB->NECES,5)+";"+Str(SB2->B2_QATU,6)+";"+Str(SB2->B2_QEMP,6)+";"+Str(nFalta,6)+";_"+SB1->B1_LOCAL+";"+SB1->B1_FABRIC+";"+_cDesP+";"+SB1->B1_MSGRPMA
    //cRegCSV := TRB->CODIG+";"+SB1->B1_REVATU+";"+SB1->B1_DESC+";"+SB1->B1_GRUPO+";"+SB1->B1_UM+";"+Str(TRB->NECES,5)+";"+Str(SB2->B2_QATU,6)+";"+Str(SB2->B2_QEMP,6)+";"+Str(nFalta,6)+";_"+SB1->B1_LOCAL+";"+SB1->B1_FABRIC+";"+SB1->B1_DESCP+";"+SB1->B1_MSGRPMA
    //Ticket#2017011637000191 — NOME CIENTIFICO DIVERGENTE DA DESCRICAO
    FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
       
    If mv_par07 == 1 .Or. _nOpc == 7         // Imprime o Roteiro de Operações
       SG2->(DbSetOrder(1))
       If SG2->(DbSeek(xFilial("SG2")+TRB->CODIG))
          Li+=2
          If Li > 58
	         Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
	      EndIf   
	      @Li,004 Psay "Operações:"
	      If _nOpc == 6
		     @Li,078 Psay "Setup             Operação            Total" 
		  Else
		     @Li,078 Psay "Setup     R$      Operação   R$       Total       R$"
		  EndIf   
		  Do While SG2->G2_PRODUTO == TRB->CODIG .AND. !SG2->(EOF())
		     If Li > 60
	            Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
	            @Li,004 Psay "Operações:"
	            If _nOpc == 6
		           @Li,078 Psay "Setup             Operação            Total" 
		        Else
		           @Li,078 Psay "Setup     R$      Operação   R$       Total       R$"
		        EndIf   
		     EndIf 
		     Li++
             @Li,004 Psay SG2->G2_OPERAC
    		 SH1->(DbSetOrder(1))
        	 If SH1->(DbSeek(xFilial("SH1")+SG2->G2_RECURSO))  
        	    @Li,008 Psay SG2->G2_RECURSO 
    		    @Li,024 Psay Alltrim(SH1->H1_DESCRI)
    		    nCustoHH := SH1->H1_MSCUSHH
    		 EndIf
    		 nTotHor := SG2->G2_SETUP
    		 nMin    := SG2->G2_SETUP * 60
    		 nSeg    := Int((nMin  - Int(nMin)) * 60)
    		 If nSeg > 55
    		    nSeg := 0
    		    nMin++
    		 EndIf   
    		 @Li,073 Psay Int(nMin) Picture "@E 99,999"
             @Li,079 Psay "m" 
             @Li,081 Psay StrZero(nSeg,2,0)
             @Li,083 Psay "s"
             If _nOpc == 7     
                @Li,085 Psay (nCustoHH * 0) Picture "@E 999.99"   // Substituir 0 (zero) p/Custo do Setup, quando Setup estiver OK
                nVlrMObra += (nCustoHH * 0)
             EndIf    
             nLote := SG2->G2_LOTEPAD
             If nLote == 0
                nLote := 1
             EndIf   
    		 nMin    := SG2->G2_TEMPAD / nLote * 60
    		 nTotHor += SG2->G2_TEMPAD / nLote * TRB->NECES
    		 nSeg := Int((nMin - Int(nMin)) * 60)
    		 If nSeg > 55
    		    nSeg := 0
    		    nMin++
    		 EndIf 
    		 @Li,091 Psay Int(nMin) Picture "@E 99,999"
             @Li,097 Psay "m" 
             @Li,099 Psay StrZero(nSeg,2,0)
             @Li,101 Psay "s" 
    		 nMin := nTotHor * 60
             nSeg := Int((nMin - Int(nMin)) * 60)
             If nSeg > 55
                nSeg := 0
                nMin++
             EndIf
             If _nOpc == 7
                @Li,102 Psay (nCustoHH * (SG2->G2_TEMPAD / nLote) * TRB->NECES) Picture "@E 9,999.99"
                nVlrMOBra  +=(nCustoHH * (SG2->G2_TEMPAD / nLote) * TRB->NECES)
             EndIf   
             @Li,111 Psay Int(nMin) Picture "@E 99,999"
             @Li,117 Psay "m" 
             @Li,119 Psay StrZero(nSeg,2,0)
             @Li,121 Psay "s"
             If _nOpc == 7
                @Li,122 Psay (nCustoHH * (SG2->G2_TEMPAD / nLote) * TRB->NECES) Picture "@E 99,999.99"
             EndIf   
             If !Empty(SG2->G2_MSPROG)
    		     Li++
	   		     @Li,008 Psay "Progs.: " + Alltrim(SG2->G2_MSPROG)
        	 EndIf
        	  If !Empty(SG2->G2_MSOBS)
        	    Li++
	  		    @Li,008 Psay "Obs....: " + ALLTRIM(SG2->G2_MSOBS)
        	 EndIf
        	 FAchou := .F.
        	 For J := 1 TO Len(aOperacoes)
	             If aOperacoes[j][1] == SG2->G2_RECURSO
	                aOperacoes[J][2] := aOperacoes [J][2] + (SG2->G2_TEMPAD / nLote * TRB->NECES)
	                aOperacoes[J][3] := aOperacoes [J][3] + SG2->G2_SETUP
	                FAchou := .T.
	                Exit
	             EndIf    
             Next
             If !FAchou
                AADD(aOperacoes,{SG2->G2_RECURSO,(SG2->G2_TEMPAD / nLote * TRB->NECES),SG2->G2_SETUP,SH1->H1_DESCRI})
             EndIf    
        	 SG2->(DbSkip())
          EndDo
          If nVlrMOBra > 0 .And. _nOpc == 7
             Li++
             @Li,096 Psay "Total de Mão de Obra: "
             @Li,121 Psay nVlrMObra Picture "@E 999,999.99"
             nVlrMObra := 0
          EndIf   
       Else
          If _nOpc == 7  
             @Li,100 Psay SB1->B1_UPRC Picture "@E 999,999.99"
             @Li,121 Psay (SB1->B1_UPRC * TRB->NECES) Picture "@E 999,999.99"
             If SubStr(SB1->B1_COD,1,2) == "MP"
                nTotMPrima += (SB1->B1_UPRC * TRB->NECES)
             Else
                nTotACess += (SB1->B1_UPRC * TRB->NECES)
             EndIf         
          EndIf   
       EndIf
       Li++
       @Li,000 PSay Replicate("-",132)
       Li++ 
    EndIf
       
	//**********************************************
	// Será utilizado para impressão dos desenhos                       
	//**********************************************
	If mv_par06 > 1
	   If mv_par06 == 2
          _cPath := "H:\PLOTTER\"
       ElseIf mv_par06 == 3
          _cPath := "P:\PLOTTER\"  
       EndIf   
     
	   SB1->(DbSetOrder(1))
       If SB1->(dbSeek(xFilial("SB1")+TRB->CODIG))
          cDesenho := Alltrim(TRB->CODIG) + Alltrim(SB1->B1_REVATU)
       EndIf
       If SubStr(cNumEmp,1,2) == "01" 
	      If Substr(cDesenho,1,2) == "CL"
   	         _cPath += Substr(cDesenho,3,2) + "\"
	      Else
   	         _cPath += Substr(cDesenho,1,2) + "\"
	      EndIf
	   ElseIf SubStr(cNumEmp,1,2) == "10"
	      _cPath += Substr(cDesenho,1,3) + "\"
	   EndIf    
	   If mv_par06 == 2
	      If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
	         AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
	         AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
	         AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
	      EndIf   
       ElseIf mv_par06 == 3
          If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
	         AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
	         AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI") 
	         AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
	      EndIf   
	   EndIf         
	EndIf   
     
    dbSelectArea("TRB")
	IncRegua()
	TRB->(dbSkip())
	Loop
EndDo

FClose(cArqCSV)	

Li:= 80
If mv_par07 == 1 .Or. _nOpc == 7
   ImpResumo()
EndIf   

// impressão dos desenhos
 	
If aReturn[5] > 1 .And. mv_par06 > 1
   For J := 1 TO LEN(aDesenhos)
	  WaitRun(aDesenhos[j])
   Next 
EndIf

dbSelectArea("SZ3")
TRB->(dbCloseArea())

// Copia do Arquivo para importação
//cCopia := cArqTrab + ".dbf"
//CPYS2T(cCopia," C:\LIXO\")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Ferase(cArqTrab+GetDBExtension())
//Ferase(cArqTrab+OrdBagExt())
//Ferase(cFilTrab+OrdBagExt())                                                                    

If aReturn[5] == 1
   Set Printer To
   dbCommitAll()
   OurSpool(wnrel)
Endif

_oDlg1:End()
MS_FLUSH()

Return

Static Function ChecaPedido()     // Verifica a Existência do Pedido e acessa seus Itens
Local lRet  := .T.
Local nItem := 0 

   dbSelectArea("SZ3")
   SZ3->(dbSetOrder(1))
   
   dbSelectArea("SC5")
   SC5->(DbSetOrder(1))
   
   dbSelectArea("SC6")
   SC6->(DbSetOrder(1)) 
   
   SB1->(DbSetOrder(1))
   
   If !Empty(cPedido)

      If ! SC5->(DBSeek(xFilial("SC5")+cPedido)) 
         Alert("Pedido não Encontrado !!!")
         lRet := .F.
      Else
        
         If SC6->(DBSeek(xFilial("SC6")+cPedido))
            
            cConsulta := GetSXENum("SZ3", "Z3_CONSULT")
            
            Do While SC6->(!Eof()) .AND. Alltrim(cPedido) == SC6->C6_NUM 
               
               nItem++
               
               If SB1->(DBSeek(xFilial("SB1")+SC6->C6_PRODUTO))
                  cDesc := SB1->B1_DESC
               Else
                  cDesc := "Produto não cadastrado"
               EndIf

               RecLock("SZ3",.T.)
               SZ3->Z3_FILIAL   := xFilial("SZ3") 
               SZ3->Z3_CONSULT  := cConsulta
               SZ3->Z3_PRODUTO  := SC6->C6_PRODUTO
               SZ3->Z3_ITEM     := StrZero(nItem,3)
               SZ3->Z3_QUANT    := SC6->C6_QTDVEN
               SZ3->Z3_USUARIO  := cUserName
               SZ3->Z3_NOMCONS  := "RC-PV " + cPedido
               SZ3->(MsUnLock())
  
               SC6->(DbSkip())
            
            EndDo

            ConfirmSX8()

         EndIf      
      
      EndIf
   
   EndIf

Return lRet

Static Function ImpParam()

Local J := 0
Local I := 0

    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
    Li:= 7
    @Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
    Li+=3   
    @Li,000 Psay "Somente Material Faltante...: "
    If mv_par01 == 1
       @li,030 Psay  "Sim"
    Else 
       @li,030 Psay "Não"
    EndIf      
    Li++
    @Li,000 Psay "Lista Conjuntos.............: "
    If mv_par02 == 1
       @li,030 Psay  "Sim"
    Else 
       @li,030 Psay "Não"
    EndIf
    Li++
    @Li,000 Psay "Quais.......................: "
    If mv_par03 == 1
       @li,030 Psay  "Fabricado"
    ElseIf mv_par03 == 2 
       @li,030 Psay "Comprado"
    Else
       @li,030 Psay "Comprado e Fabricado"
    EndIf 
    Li++
    @Li,000 Psay "Produto de..................: "  + mv_par04 + " ate: " + Alltrim(mv_par05)
    Li++
    @Li,000 Psay "Imprime Desenhos............: "
    If aReturn[5] > 1 .And. mv_par06 > 1
       If mv_par06 == 2
          @li,030 Psay "Sim - Drive H"
       Else 
          @li,030 Psay "Sim - Drive P"
       EndIf
    Else
       @li,030 Psay "Não"
    EndIf       
    Li++
    @Li,000 Psay "Imprime Operações...........: "
    If mv_par07 == 1
       @li,030 Psay  "Sim"
    Else 
       @li,030 Psay "Não"
    EndIf 
    Li+=2
    @li,000 Psay "Consulta....................: " + cConsulta + " - " + cNomeCons
    Li++
    @Li,000 Psay "Arquivo p/Importação........: " + cArqTrab
    Li+=2
    @Li,000 PSay Replicate("*",61)+" OPERAÇÕES "+Replicate("*",60)
    Li++
    nTotSetup := 0
    nTotOper  := 0
    For I = 1 to Len(aConjuntos)
        Li++
        If Li > 60
           Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
        EndIf
       	SB1->(DbSetOrder(1))
        If SB1->(dbSeek(xFilial("SB1")+aConjuntos[I][1]))
           @Li,000 Psay Alltrim(aConjuntos[I][1]) + " - " + SB1->B1_DESC
        Else
           @Li,000 Psay Alltrim(aConjuntos[I][1]) + " - Produto não cadastrado"
        EndIf         
        @Li,058 Psay "Qtde.: "
        @Li,065 Psay aConjuntos[I][2]  Picture "@E 999.999"
        @Li,080 Psay "Setup    Operação       Total"
        If mv_par07 == 1               // Imprime o Roteiro de Operações
           SG2->(DbSetOrder(1))
           If SG2->(DbSeek(xFilial("SG2")+aConjuntos[I][1]))
   			  Do While SG2->G2_PRODUTO == aConjuntos[I][1] .AND. !SG2->(EOF())
   		     Li++
   	     If Li > 60
              Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
              @Li,080 Psay "Setup    Operação       Total"
              EndIf 
 		      	 @Li,004 Psay SG2->G2_OPERAC
    			 SH1->(DbSetOrder(1))
        		 If SH1->(DbSeek(xFilial("SH1")+SG2->G2_RECURSO))  
        		    @Li,008 Psay SG2->G2_RECURSO 
 	    		    @Li,020 Psay Alltrim(SH1->H1_DESCRI)
  		   	 EndIf
    			 nTotHor := SG2->G2_SETUP
    		     nMin    := SG2->G2_SETUP * 60
    		     nSeg    := Int(nMin - Int(nMin)) * 100
    		     @Li,075 Psay Int(nMin) Picture "@E 99,999"
    		     @Li,081 Psay "m" 
    		     @Li,083 Psay StrZero(nSeg,2,0)
    		     @Li,085 Psay "s" 
                 nLote := SG2->G2_LOTEPAD
                 If nLote == 0
                    nLote := 1
                 EndIf    
                 nMin    := SG2->G2_TEMPAD / nLote * 60
    		     nTotHor += SG2->G2_TEMPAD / nLote * aConjuntos[I][2]
    		     nSeg    := (nMin - Int(nMin)) * 100
    		     @Li,087 Psay Int(nMin) Picture "@E 99,999"
    		     @Li,093 Psay "m" 
    		     @Li,095 Psay StrZero(nSeg,2,0)
    		     @Li,097 Psay "s" 
    		     nMin := nTotHor * 60
                 nSeg := (nMin - Int(nMin)) * 100
                 If nSeg > 58
                    nSeg := 0
                    nMin++
                 EndIf
                 @Li,099 Psay Int(nMin) Picture "@E 99,999"
    		     @Li,105 Psay "m" 
    		     @Li,107 Psay StrZero(nSeg,2,0)
    		     @Li,109 Psay "s" 
                 If !Empty(SG2->G2_MSPROG)
    			     Li++
	   			     @Li,008 Psay "Progs.: " + Alltrim(SG2->G2_MSPROG)
        		 EndIf
        	     If !Empty(SG2->G2_MSOBS)
        	        Li++
	  			    @Li,008 Psay "Obs.: " + ALLTRIM(SG2->G2_MSOBS)
        		 EndIf
        		 FAchou := .F.
        	     For J := 1 TO LEN(aOperacoes)
	                 If aOperacoes[j][1] == SG2->G2_RECURSO
	                    aOperacoes[J][2] := aOperacoes [J][2] + (SG2->G2_TEMPAD / nLote * aConjuntos[I][2])
	                    aOperacoes[J][3] := aOperacoes [J][3] + SG2->G2_SETUP
	                    FAchou := .T.
	                    Exit
	                 EndIf    
                 Next J
                 If !FAchou
                    AADD(aOperacoes,{SG2->G2_RECURSO,(SG2->G2_TEMPAD / nLote * aConjuntos[I][2]),SG2->G2_SETUP,SH1->H1_DESCRI})
                 EndIf    
        	  	 SG2->(DbSkip())
        	  Enddo
    	   EndIf
    	   Li++
    	   @Li,000 PSay Replicate("-",132)
    	   Li++ 
	    Endif
    Next I
    If mv_par07 == 1 .Or. _nOpc == 7
       ImpResumo()
    EndIf   
    aConjuntos  := {}
    Li:=80  
Return

Static Function ImpResumo()

Local J := 0

   Cabec1 := ""
   Li++    
    If Li > 58
       Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
    EndIf
    nTotSetup := 0
    nTotOper  := 0
    Li++   
    If Len(aOperacoes) > 0
       @Li,000 Psay Replicate("*",54)+" Resumo  das  Operações "+Replicate("*",54)
       Li+=2
       @Li,008 Psay "Operações                                                               Setup    Operação       Total"
       If _nOpc == 7 
          @Li,118 Psay "Custo"
       EndIf  
       aSort(aOperacoes,,,{ |x, y| x[1] < y[1] })
       For J := 1 TO LEN(aOperacoes)
           Li++
           If Li > 58
              Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
              @Li,000 Psay Replicate("*",54)+" Resumo  das  Operações "+Replicate("*",54)
              Li+=2
              @Li,008 Psay "Operações                                                             Setup    Operação       Total"
              If _nOpc == 7 
                 @Li,118 Psay "Custo"
              EndIf 
              Li+=2
           EndIf
           @li,008 Psay aOperacoes[J][1]
           @li,020 Psay aOperacoes[J][4]
           nHor := Int(aOperacoes[J][3])
           nMin := (aOperacoes[J][3] - nHor) * 60
           If nMin > 58
              nMin := 0
              nHor++
           EndIf
           @Li,075 Psay nHor Picture "@E 99,999"
    	   @Li,081 Psay "h" 
    	   @Li,083 Psay StrZero(nMin,2,0)
    	   @Li,085 Psay "m" 
           nHor  := Int(aOperacoes[J][2])
           nMin := (aOperacoes[J][2] - nHor) * 60
           If nMin > 58
              nMin := 0
              nHor++
           EndIf
           @Li,087 Psay nHor Picture "@E 99,999"
    	   @Li,093 Psay "h" 
    	   @Li,095 Psay StrZero(nMin,2,0)
    	   @Li,097 Psay "m"
    	   nHor := Int(aOperacoes[J][2] + aOperacoes[J][3])
           nMin := (aOperacoes[J][2] + aOperacoes[J][3] - nHor) * 60
           If nMin > 58
              nMin := 0
              nHor++
           EndIf
           @Li,099 Psay nHor Picture "@E 99,999"
    	   @Li,105 Psay "h" 
    	   @Li,107 Psay StrZero(nMin,2,0)
    	   @Li,109 Psay "m"  
    	   If _nOpc == 7 
    	      SH1->(DbSetOrder(1))
              If SH1->(DbSeek(xFilial("SH1")+aOperacoes[J][1]))  
                 @Li,114 Psay (SH1->H1_MSCUSHH * aOperacoes[J][2]) Picture "@E 99,999.99"
                 nTotMObra  +=(SH1->H1_MSCUSHH * aOperacoes[J][2])
    	      EndIf
    	   EndIf   
    	   nTotSetup += aOperacoes[J][3]
           nTotOper  += aOperacoes[J][2] 
       Next J
    EndIf
    If nTotOper > 0
       Li+=2
       @Li, 020 Psay "T o t a l  ==> "
       nHor  := Int(nTotSetup)
       nMin  := (nTotSetup - nHor) * 60
       If nMin > 58
          nMin := 0
          nHor++
       EndIf 
       @Li,075 Psay nHor Picture "@E 99,999"
       @Li,081 Psay "h" 
       @Li,083 Psay StrZero(nMin,2,0)
       @Li,085 Psay "m" 
       nHor := Int(nTotOper)
       nMin := (nTotOper - nHor) * 60
       If nMin > 58
          nMin := 0
          nHor++
       EndIf
       @Li,087 Psay nHor Picture "@E 99,999"
       @Li,093 Psay "h" 
       @Li,095 Psay StrZero(nMin,2,0)
       @Li,097 Psay "m" 
       nHor := Int(nTotSetup + nTotOper)
       nMin := (nTotSetup + nTotOper - nHor) * 60
       If nMin > 58
          nMin := 0
          nHor++
       EndIf
       @Li,099 Psay nHor Picture "@E 99,999"
       @Li,105 Psay "h" 
       @Li,107 Psay StrZero(nMin,2,0)
       @Li,109 Psay "m"
       If nHor > 24
          nDias := Int(nHor / 24)
          @Li,112 Psay "==> "
          @Li,117 Psay nDias Picture "@E 999"
          @Li,120 Psay "d "
          nHor  := nHor - (nDias * 24)
          @Li,122 Psay Int(nHor) Picture "@E 99"
          @Li,124 Psay "h "
          @Li,126 Psay StrZero(nMin,2,0) + "m"  
       EndIf
    EndIf  
    If _nOpc == 7 .And. (nTotMOBra > 0 .Or. nTotMPrima > 0 .Or. nTotAcess > 0)
       If Li + 7 > 60
          Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
       EndIf
       Li+=3
       @Li,050 Psay "***   R E S U M O   D O S   C U S T O S   ***"
       Li+=2
       @Li,054 Psay "Total de Mão de Obra..: "
       @Li,078 Psay nTotMOBra Picture "@E 99,999,999.99"
       Li++
       @Li,054 Psay "Total de Materia Prima: "
       @Li,078 Psay nTotMPrima Picture "@E 99,999,999.99"
       Li++
       @Li,054 Psay "Total de Acessorios...: "
       @Li,078 Psay nTotAcess Picture "@E 99,999,999.99" 
       Li++
       @Li,054 Psay "Total dos Custos......: "
       @Li,078 Psay (nTotMOBRA + nTotMPrima + nTotAcess) Picture "@E 99,999,999.99" 
    EndIf        
    nTotSetup  := 0
    nTotOper   := 0    
    aOperacoes := {}
    aConjuntos := {}  
Return
