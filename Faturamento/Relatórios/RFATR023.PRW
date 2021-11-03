#Include "Rwmake.ch"      
#Include "Topconn.ch"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RFATR023³ Autor ³ Aparecida de F.Stevanato³Data ³ 16.05.07           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Orçamentos - (Nacional e Exportação)  	                  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
Reescrito em 26/07/2013 por Ana Paula QF - Acrescentada Query e junção do RDMAKE (RFATR023-Analitico/RFATR024-Sintetico) - Analitico/Sintetico
Reescrito em 03/06/2014 por Eduardo Mantoan	- Erro na lógica - os valores não batiam e não calculavam corretamente - problema com arquivos de trabalho - Sintetico
*/

User Function RFATR023()                                                                                             
                                                                                           
Private titulo    := ""
Private cString   := "SCJ"
Private wnrel     := "RFATR023"
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }      
Private nomeprog  := "RFATR023"
Private cPerg     := "XRFATR023 "
Private cArqCSV   := ""
Private cRegCSV   := ""
Private cArqTrab  := ""
Private cFilTrab  := ""
Private cArqTrab2 := ""
Private cFilTrab2 := ""
Private nLastKey  := 0
Private Li        := 99 
Private CbTxt     := ""
Private cabec1    := ""
Private cabec2    := ""
Private tamanho   := "G"
Private limite    := 220
Private CbCont    := 0
Private nCont     := 0
Private cSituacao := ""
Private cNomeVend := ""
Private cPaisReg  := ""
Private cProdCli  := ""
Private cSegmento := "" 
Private cOrcAnt   := ""
Private cNumCEAnt := ""
Private cExport   := ""
Private cCampo    := ""
Private nVlrReal  := 0
Private nVlrOrc   := 0
Private nQtde     := 0
Private nTotQtde  := 0
Private nTotValor := 0
Private nTotRev   := 0
Private nTotMoeda2:= 0
Private dDtAux    := CTOD("" )
Private nDia      := 0
Private nResto    := 0
Private nTaxa     := 1
Private cVenda    := ""
Private cMotPerda := ""
Private cSit      := ""
Private cRev      := ""
Private nTam      := 0
Private aSituacao := {}
Private cNumOC    := ""

Pergunte(cPerg,.F.)

MV_PAR05 := Upper(MV_PAR05)
If Alltrim(MV_PAR05) == "BR"
   MV_PAR06 := "BR"
EndIf   

MV_PAR06 := Upper(MV_PAR06)
MV_PAR07 := Upper(MV_PAR07)
MV_PAR08 := Upper(MV_PAR08)
MV_PAR09 := Upper(MV_PAR09)
MV_PAR10 := Upper(MV_PAR10)
MV_PAR11 := Upper(MV_PAR11)

If MV_PAR12 == 1  //Analitico

	aOrd     := {"Emissao+Orçamento"} 
	wnrel    := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,aOrd,,Tamanho)

	If MV_PAR06 == "BR"   // apenas Venda Nacional
		cExport := "N"
		titulo := "Relação de Orçamentos - " + "Nacional"
		cabec1 := "O R C A M E N T O         CLIENTE                REGIAO                  VENDEDOR          SETOR                       PRODUTO                     STATUS       REV NUMERO QTDE     EQUIPAMENTOS"
		cabec2 := " DATA     NUMERO  																																																				  OPICIONAL         "
	Else
		cExport := "S"
		titulo := "Relação de Orçamentos - " + "Exportação"
		cabec1 := "O R C A M E N T O         CLIENTE                PAIS                    VENDEDOR          SETOR                       PRODUTO                     STATUS       REV NUMERO QTDE     EQUIPAMENTOS"  
		cabec2 := " DATA     NUMERO                                                                                                                                                              OPICIONAL         "  
	EndIf                                                                                                                                                                                        

	//If (cArqCSV := FCreate("C:\Relato_Microsiga\Orçamentos_Pendentes.csv")) == -1
	   //Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
	//Else
	   //cRegCSV := "DATA;ORÇAMENTO;CLIENTE;PAIS;VENDEDOR;SETOR;PRODUTO DO CLIENTE;STATUS ATUAL;NUMERO;PRODUTO;NOVO STATUS"
	  // FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	  // cRegCSV := ""
	  // FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	//EndIf  

ElseIf MV_PAR12 == 2  // Sintetico

	aOrd     := {"Pais ou Região","Setor de Atividade","Equipamentos"} 
	wnrel    := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,aOrd,,Tamanho)

	If Alltrim(mv_par05) == "BR" .AND. Alltrim(mv_par06) == "BR"  
	   cExport := "N"   // Venda Nacional
    Else                
	   cExport := "S"   // Exportação
	EndIf
	
EndIf

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)

Return

//***********************************************
	Static Function ImpRel(lEnd,WnRel,cString)
//***********************************************

//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li      := 80

Processa({|lEnd| GeraTrab(@lEnd,wnRel,"TRB")}) //Cria a tabela Trabalho 

If MV_PAR12 == 2  // Sintetico

	nOrdem  := aReturn[8]
	
	If cExport == "N"    // Venda Nacional                                         
		titulo := "Resumo de Orçamentos - " + "Nacional" + " (" + aOrd[nOrdem] + ")"
		Do Case
			Case nOrdem == 1
				Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE               VALOR VENDA"
			Case  nOrdem == 2
				Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE               VALOR VENDA"
			Case nOrdem == 3 
				Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE               VALOR VENDA"
		EndCase          
	Else                                                        
		titulo := "Resumo de Orçamentos - " + "Exportação" + " (" + aOrd[nOrdem] + ")"   // Exportação
		Do Case
			Case nOrdem == 1
				Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE               VALOR VENDA"
			Case nOrdem == 2
				Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE               VALOR VENDA"
			Case nOrdem == 3  
				Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE               VALOR VENDA"
		EndCase   
	EndIf
ElseIf MV_PAR12 == 1  // Analitico
	nOrdem  := aReturn[8]
EndIf	

ImpParam()

If MV_PAR12 == 2  // Sintetico
	Do Case
	   Case nOrdem == 1
	      cQuebra := "Alltrim(TRB1->CODPAIS) == cPaisAnt"
	   Case nOrdem == 2
	      cQuebra := "Alltrim(TRB1->CODSETOR) == cSetorAnt" 
	   Case nOrdem == 3
	      cQuebra := "Alltrim(TRB1->TPVENDA) == cTpVenAnt"
	EndCase
	
	Do Case
		Case nOrdem == 1
			IndRegua("TRB1",cArqTrab2,"STR(TPVENDEDOR)+CODVEN+CODPAIS",,,"Selecionando Registros...")  
		Case nOrdem == 2
			IndRegua("TRB1",cArqTrab2,"STR(TPVENDEDOR)+CODVEN+CODSETOR",,,"Selecionando Registros...")  
		Case nOrdem == 3
			IndRegua("TRB1",cArqTrab2,"STR(TPVENDEDOR)+CODVEN+TPVENDA",,,"Selecionando Registros...")  
	EndCase	
ElseIf MV_PAR12 == 1 // Analitico
	//nOrdem  := aReturn[8]
   Do Case 
   	Case nOrdem == 1
	   	IndRegua("TRB",cArqTrab,"DTOS(DTORCA)+NUMCE",,,"Selecionando Registros...")  
   EndCase
EndIf

           	           // TOTAL DE ELEMENTOS DA REGUA 

If MV_PAR12 == 1  // Analitico
	dbSelectArea("TRB")
	dbGoTop()
	SetRegua(RecCount())
	nVlrOrc := 0
	Do While TRB->(!Eof())
	
		If lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR" 
			Exit
		EndIf

		If Li > 62
		   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		EndIf 
		
		If TRB->NUMCE <> cNumCEAnt
	       If cNumCEAnt <> ""
	          Li++
	          If cSituacao == "P"
	             @li,000 Psay "Motivo da perda: " + cMotPerda
	          Endif   
	          @li,125 Psay "Total do Orçamento => "  + cVenda
	          If cExport == "S"
	             @li,162 Psay (nVlrOrc / nTaxa) PICTURE "@E 999,999,999.99"
	             @li,177 Psay "(US$)  X"
	             @li,185 Psay nTaxa  PICTURE "@E 999.9999" 
	          EndIf 
	          @ Li,194 Psay nVlrOrc    PICTURE "@E 999,999,999.99"
	          @ Li,209 Psay "(R$)"
	          @ Li,215 Psay nQtde PICTURE "@E 999"
	          nVlrOrc   := 0
	          nQtde     := 0
	          cVenda    := TRB->TPVENDA         
	          Li++
	          @ Li,000 Psay Replicate("-",220)                                                   
	       EndIf

	       //Cabeçalho Orçamento
	       Li++
	       @ Li,000 Psay TRB->DTORCA
	       @ Li,010 Psay SubStr(TRB->NUMCE,1,15)
		    @ Li,026 Psay TRB->NOMECLI
		    @ Li,049 Psay TRB->PAISREG 
		    @ Li,073 Psay TRB->NOMEVEN
		    @ Li,091 Psay TRB->SEGMENTO 
		    @ Li,120 Psay SubStr(TRB->PRODCLI,1,30)
		    @ Li,148 Psay Substr(TRB->DESCSIT,1,13)

			If !Empty(TRB->SITUACAO)		   
				cSit := AllTrim(TRB->SITUACAO)+"-"+Alltrim(TRB->DESCSIT)
		   Else
				cSit := Alltrim(TRB->DESCSIT)
		   EndIf
		   
		   If TRB->REVISAO == "S"
		      @ Li,163 Psay "Sim"
		   Else
		      @ Li,163 Psay "Não"
		   EndIf      
		   @ Li,167 Psay TRB->NUM 
		   	            
		   cNumCEAnt := TRB->NUMCE
		   cSituacao := TRB->SITUACAO
		   cMotPerda := TRB->MOTPERDA
		EndIf
	
	   Do While cNumCEAnt == TRB->NUMCE
	        
		If Li > 62
		   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		EndIf 
		If TRB->OPCIONAL == "S"
			
	  		@ Li,173 Psay TRB->QTDE Picture "@E 999" 
	  		@ Li,179 Psay "S"     
			@ Li,182 Psay SubStr(TRB->DESCRICAO,1,35)
		Else
			
			@ Li,173 Psay TRB->QTDE Picture "@E 999"
			@ Li,179 Psay "N"      
			@ Li,182 Psay SubStr(TRB->DESCRICAO,1,35)
		EndIF    
		nQtde    += TRB->QTDE
		nVlrReal := 0
		ConverteMoeda()
		nVlrOrc  += nVlrReal 
		If TRB->OPCIONAL <> "S"
		   If SubStr(mv_par10,1,1) <> "Z" .AND. MV_PAR10 <> " "
		      If TRB->SITUACAO <> "REV" 
		         nTotQtde  += TRB->QTDE
		         nTotValor += nVlrReal
		         If TRB->MOEDA > 1 
		         	nTotMoeda2 += TRB->VALOR 
		         EndIf    
		      EndIf
		   Else
		      If TRB->REVISAO <> "S"                         
		         nTotQtde  += TRB->QTDE
		         nTotValor += nVlrReal
		         If TRB->MOEDA > 1 
		         	nTotMoeda2 += TRB->VALOR 
		      	EndIf    
		   	EndIf 
			EndIf         
		EndIf   
		nCont++
		Li++
			
//		cRegCSV := DTOC(TRB->DTORCA)+";"+TRB->NUMCE+";"+TRB->NOMECLI+";"+TRB->PAISREG +";"+TRB->NOMEVEN+";"+TRB->SEGMENTO+";"+TRB->PRODCLI+";"+cSit+";"+TRB->NUM+";"+Alltrim(TRB->DESCRICAO)
//		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

	   dbSelectArea("TRB")
		IncRegua()
		TRB->(dbSkip())
		EndDo
		Loop
	EndDo

	//FClose(cArqCSV)
		
ElseIf MV_PAR12 == 2     // Sintetico
   dbSelectArea("TRB1")
	dbGoTop()
	SetRegua(RecCount())             
	lPrim      := .T.
	nValor     := 0
	nSubQtde   := 0
   nSubValor  := 0
   nTotQtde   := 0
   nTotValor  := 0
   nTotMoeda2 := 0
	
	Do While TRB1->(!EOF())
	    
		IF lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"        
			Exit
		Endif
		
		If Li > 62
		   Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
		   Li:= 8
		   @ Li,000 Psay  "Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)
		   Li+=2
		EndIf 
		
		If lPrim 
		   lPrim := .F.
		   nTpVendedor  := TRB1->TPVENDEDOR
		   cVendAnt     := Alltrim(TRB1->CODVEN)                 
		   cPaisAnt     := Alltrim(TRB1->CODPAIS)
		   cPaisReg     := TRB1->PAISREG
		   cTpVenAnt    := AllTrim(TRB1->TPVENDA)
		   cVenda       := Alltrim(TRB1->VENDA)
		   cSetorAnt    := Alltrim(TRB1->CODSETOR)
		   If SubStr(cSetorAnt,1,1) == "1" 
		      cSegmento := "Alimentício   " + " - " + Upper(TRB1->SEGMENTO)
		   Else                                                
		      cSegmento := "Outros Setores" + " - " + Upper(TRB1->SEGMENTO)
		   EndIf
		   SA3->(dbSetOrder(1))
			SA3->(dbSeek(xFilial("SA3")+TRB1->CODVEN))
			cVendedor := SA3->A3_NREDUZ
			If nTpVendedor == 1                                            
		      @ Li,005 Psay "Representante : " + Alltrim(TRB1->CODVEN) + "-" + cVendedor
		   Else
		      @ Li,005 Psay "Vendedor : " + Alltrim(TRB1->CODVEN) + "-" + cVendedor
		   EndIf   
		   Li++
		EndIf    
	
		If TRB1->TPVENDEDOR == nTpVendedor .AND. Alltrim(TRB1->CODVEN) == cVendAnt .AND. &cQuebra 
		   nQtde      += TRB1->QTDE
		   nVlrReal := 0
		   cItem := TRB1->ITEM
	  //If TRB1->NUMCE <> cNumOC
		   //If TRB1->MOEDA == 2
		   	ConverteMoeda()
			//EndIF
			nValor     += nVlrReal 
		//EndIF 
		
		Else
			Li++ 
			Do Case
				Case  nOrdem == 1  
					@ Li,000 Psay cPaisReg
		         cPaisAnt := Alltrim(TRB1->CODPAIS)
	            cPaisReg := TRB1->PAISREG
		      Case  nOrdem == 2
		         @ Li,000 Psay cSegmento
		         cSetorAnt := Alltrim(TRB1->CODSETOR)
		         If SubStr(cSetorAnt,1,1) == "1" 
		            cSegmento := "Alimentício   " + " - " + Upper(TRB1->SEGMENTO)
		         Else
		            cSegmento := "Outros Setores" + " - " + Upper(TRB1->SEGMENTO)
		         EndIf       
				Case  nOrdem == 3  
					@ Li,000 Psay cVenda
		         cTpVenAnt := Alltrim(TRB1->TPVENDA)
	            cVenda    := TRB1->VENDA
		   EndCase
		   @ Li,045 Psay nQtde  PICTURE "@E 99,999.9999"
	      @ Li,068 Psay nValor PICTURE "@E 999,999,999.99"
	      If cVendAnt <> Alltrim(TRB1->CODVEN) .OR. TRB1->TPVENDEDOR <> nTpVendedor
				Li++
				@ Li,005 Psay "SubTotal => "
				@ Li,045 Psay nSubQtde  PICTURE "@E 99,999.9999"
				@ Li,068 Psay nSubValor PICTURE "@E 999,999,999.99"
	         nSubQtde  := 0
	         nSubValor := 0
	         Li++
	         @ Li,000 Psay Replicate("-",132)
	         If TRB1->TPVENDEDOR <> nTpVendedor
	            If nTotValor > 0
	               Li++ 
	               ImpTotal()
	               nTotQtde   := 0
	               nTotValor  := 0
	               nTotMoeda2 := 0
	            EndIf
	            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	            Li:= 8
		         @ Li,000 Psay  "Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)
		         nTpVendedor := TRB1->TPVENDEDOR
		      EndIf   
				SA3->(dbSetOrder(1))
	         SA3->(dbSeek(xFilial("SA3")+TRB1->CODVEN))
	         cVendedor := SA3->A3_NREDUZ
	         Li+=2
	         Do Case
	            Case TRB1->TPVENDEDOR == 1
							@ Li,005 Psay "Representante : " + Alltrim(TRB1->CODVEN) + "-" + cVendedor
		         Case TRB1->TPVENDEDOR == 2
							@ Li,005 Psay "Vendedor : " + Alltrim(TRB1->CODVEN) + "-" + cVendedor
		         Case TRB1->TPVENDEDOR == 3
							@ Li,005 Psay "Gerente : " + Alltrim(TRB1->CODVEN) + "-" + cVendedor   
		      EndCase
		      Li++
		      cVendAnt := Alltrim(TRB1->CODVEN)
			EndIf
			nQtde    := TRB1->QTDE
			//If	TRB1->NUMCE <> cNumOC
			 //	If TRB1->MOEDA == 2
			nVlrReal := 0
			ConverteMoeda()
			//EndIF
			//	nValor := 0
			nValor   := nVlrReal 
			//EndIF
		EndIf
		nSubQtde   += TRB1->QTDE
		nTotQtde   += TRB1->QTDE
		//If	TRB1->NUMCE <> cNumOC 
	   	nSubValor  += nVlrReal
	   	nTotValor  += nVlrReal
	   	If TRB1->MOEDA == 2
	   		nTotMoeda2 += TRB1->VALOR
	   	EndIF 
	 	//EndIF
	   nCont++
	    
		dbSelectArea("TRB1")
		IncRegua()
		
		cNumOC := TRB1->NUMCE 
		TRB1->(dbSkip())
		Loop
	EndDo
	
EndIf		                                                                

If MV_PAR12 == 1  // Analitico
	Li++
	If Li > 62
	   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf

	If cSituacao == "P"
	   @ Li,000 Psay "Motivo da perda: " + cMotPerda
	Endif   
	 
	@ Li,125 Psay "Total do Orçamento => " + cVenda
	If cExport == "S"
	   @ Li,162 Psay (nVlrOrc / nTaxa)  PICTURE "@E 999,999,999.99"
	   @ Li,177 Psay "(US$)  X"
	   @ Li,185 Psay nTaxa  PICTURE "@E 999.9999"
	EndIf 
	@ Li,194 Psay nVlrOrc  PICTURE "@E 999,999,999.99" 
	@ Li,209 Psay "(R$)" 
	@ Li,215 Psay nQtde Picture "@E 999"    
	Li++
	@ Li,000 Psay Replicate("-",220)
	
	Li++
	If Li > 60
	   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIf 
	                                                                     	
	If cExport == "S"
	   @ Li,140 Psay "Total Exportação => "
	   @ Li,162 Psay nTotMoeda2 PICTURE "@E 999,999,999.99" 
	   @ Li,177 Psay "(US$)" 
	Else
	   @ Li,140 Psay "Total Nacional => "   
	EndIf
	
	@ Li,194 Psay nTotValor  PICTURE "@E 999,999,999.99"
	@ Li,209 Psay "(R$)" 
	@ Li,215 Psay nTotQtde PICTURE "@E 999"  
	
	MsgBox("A planilha foi gerada => c:\Relato_microsiga\Orcamentos_Pendentes") 
	
ElseIf MV_PAR12 == 2  // Sintetico

	Li++
	If Li > 62
	   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	   Li:= 8
	   @ Li,000 Psay  DTOC(mv_par01) + " a " + DTOC(mv_par02)
	   Li+=2
	EndIf 
	
	Do Case
	   Case nOrdem == 1
	      @ Li,000 Psay cPaisReg
	   Case nOrdem == 2
	      @ Li,000 Psay cSegmento
	   Case nOrdem == 3
	      @ Li,000 Psay cVenda
	EndCase           
	@ Li,045 Psay nQtde  PICTURE "@E 99,999.9999"
	@ Li,068 Psay nValor PICTURE "@E 999,999,999.99"
	Li++
	@ Li,005 Psay "SubTotal => "
	@ Li,045 Psay nSubQtde  PICTURE "@E 99,999.9999"
	@ Li,068 Psay nSubValor PICTURE "@E 999,999,999.99" 
	li++
	@ Li,000 Psay Replicate("-",132)
	Li++    
	
	ImpTotal()
	
	Li := 99
	
	ImpResumo()
	
	Li := 80
	
	If li != 80
		Roda(cbcont,cbtxt)
	Endif

EndIf

dbSelectArea("TRB")
dbCloseArea()

// Deleta arquivos de trabalho
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

Ferase(cArqTrab2+GetDBExtension())
Ferase(cArqTrab2+OrdBagExt())
Ferase(cFilTrab2+OrdBagExt())

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o	 ³ GeraTrab	³   Cria Arquivo de Trabalho                      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GeraTrab()

// Define Variaveis
Local aSX512	:= {}
Local aSX5Z8	:= {}
Local aSX5T3	:= {}
Local aSX5Z5	:= {}
LOCAL aCampos	:= {}
Local aCampos2	:= {}
Local oTable
Local nX, nY, I

// Define array para arquivo de trabalho
AADD(aCampos,{ "NUM"       ,"C",06,0 } )
AADD(aCampos,{ "NUMCE"     ,"C",15,0} )
AADD(aCampos,{ "ITEM"     ,"C",2,0} )
AADD(aCampos,{ "REVISAO"   ,"C",1,0 } )
AADD(aCampos,{ "NOMECLI"   ,"C",20,0} )
AADD(aCampos,{ "PAISREG"   ,"C",20,0} )
AADD(aCampos,{ "PRODUTO"   ,"C",15,0} )
AADD(aCampos,{ "DESCRICAO" ,"C",35,0 } )
AADD(aCampos,{ "PRODCLI"   ,"C",30,0 } )
AADD(aCampos,{ "CODSETOR"  ,"C",10,0 } )
AADD(aCampos,{ "SEGMENTO"  ,"C",25,0 } )
AADD(aCampos,{ "CODVEN"    ,"C",06,0 } )
AADD(aCampos,{ "NOMEVEN"   ,"C",15,0 } ) 
AADD(aCampos,{ "QTDE"      ,"N",12,0 } )
AADD(aCampos,{ "VALOR"     ,"N",15,2 } )
AADD(aCampos,{ "DTORCA"    ,"D",08,0 } )
AADD(aCampos,{ "PRAZO"     ,"D",08,0 } )
AADD(aCampos,{ "MOEDA"     ,"N",11,4 } )
AADD(aCampos,{ "SITUACAO"  ,"C",03,0 } )
AADD(aCampos,{ "DESCSIT"   ,"C",55,0 } )
AADD(aCampos,{ "OPCIONAL"  ,"C",01,0 } )
AADD(aCampos,{ "TPVENDA"   ,"C",02,0 } ) 
AADD(aCampos,{ "VENDA"     ,"C",25,0 } )
AADD(aCampos,{ "MOTPERDA"  ,"C",40,0 } )   
AADD(aCampos,{ "DTEMI"     ,"D",08,0 } )
AADD(aCampos,{ "CODPAIS"   ,"C",03,0 } )

If MV_PAR12 == 2  // Sintetico

	AADD(aCampos2,{ "TPVENDEDOR","N",01,0 } )
	AADD(aCampos2,{ "CODVEN"    ,"C",06,0 } )
	AADD(aCampos2,{ "NUMCE"     ,"C",15,0} )
	AADD(aCampos2,{ "ITEM"     ,"C",2,0} )
	AADD(aCampos2,{ "CODPAIS"   ,"C",03,0 } )
	AADD(aCampos2,{ "PAISREG"   ,"C",25,0 } )
	AADD(aCampos2,{ "CODSETOR"  ,"C",10,0 } )
	AADD(aCampos2,{ "SEGMENTO"  ,"C",25,0 } )
	AADD(aCampos2,{ "TPVENDA"   ,"C",02,0 } )
	AADD(aCampos2,{ "VENDA"     ,"C",25,0 } )
	AADD(aCampos2,{ "QTDE"      ,"N",12,3 } )
	AADD(aCampos2,{ "VALOR"     ,"N",15,2 } )
	AADD(aCampos2,{ "DTEMI"     ,"D",08,0 } )
	AADD(aCampos2,{ "MOEDA"     ,"N",11,4 } )
	AADD(aCampos2,{ "OPCIONAL"  ,"C",01,0 } )
	AADD(aCampos2,{ "REVISAO"   ,"C",01,0 } )
	AADD(aCampos2,{ "SITUACAO"  ,"C",03,0 } )
	AADD(aCampos2,{ "DESCSIT"   ,"C",55,0 } )
EndIf*/

// Cria arquivo de Trabalho
If Select("TRB") > 0 
   DbSelectArea("TRB")
   DbCloseArea()
EndIf

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:Create()

If MV_PAR12 == 2  // Sintetico
	oTable := FWTemporaryTable():New("TRB1",aCampos2)
	oTable:Create()
	nOrdem := aReturn[8]
Else
	nOrdem := aReturn[8]
EndIf

If Alltrim(MV_PAR10) <> '  ' .AND. SUBSTR(MV_PAR10,1,3) <> 'ZZZ'
	nTam := Len(Alltrim(MV_PAR10))
	For nX := 1  to nTam
		If SubStr(MV_PAR10,nX,1) <> "R"
			AAdd(aSituacao,{SubStr(MV_PAR10,nX,1)})
		Else
			AAdd(aSituacao,{SubStr(MV_PAR10,nX,3)})
			nX += 2
	    Endif
	Next nX
EndIf	

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := "SELECT SCJ.CJ_FILIAL,  SCJ.CJ_NUM,     SCJ.CJ_EMISSAO, SCJ.CJ_ORCAM,   SCJ.CJ_CLIENTE, SCJ.CJ_LOJA,    SCJ.CJ_MSSTAT, SCJ.CJ_MSALIM, "
_cQuery += "       SCJ.CJ_MSVEND,  SCJ.CJ_MSVLORC, SCJ.CJ_MOEDA,   SCJ.CJ_MSTPVEN, SCJ.CJ_MSMOTPE, SA1.A1_PAIS,    SA1.A1_EST,    SA1.A1_REGIAO, "
_cQuery += "       SA1.A1_SATIV1,  SCK.CK_FILIAL,  SCK.CK_NUM,     SCK.CK_ITEM,    SCK.CK_PRODUTO, SCK.CK_QTDVEN,  SCK.CK_VALOR,  SCK.CK_MSITOPC, "
_cQuery += "       SCK.CK_ENTREG, SA1.A1_NREDUZ,   SA3.A3_NREDUZ,  SB1.B1_DESC,    SYA.YA_DESCR    "
_cQuery += "FROM "+RetSqlName("SCJ")+" SCJ "
_cQuery += "INNER JOIN "+RetSqlName("SCK")+" SCK ON SCK.CK_FILIAL = '"+xFilial("SCK")+"' AND SCK.CK_NUM = SCJ.CJ_NUM AND SCK.D_E_L_E_T_ = ' ' "
_cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SCJ.CJ_CLIENTE AND SA1.A1_LOJA = SCJ.CJ_LOJA AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SCJ.CJ_MSVEND AND SA3.D_E_L_E_T_ = ' '  "
_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SCK.CK_PRODUTO AND SB1.D_E_L_E_T_ = ' '   "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SYA")+" SYA ON SYA.YA_FILIAL = '"+xFilial("SYA")+"' AND SYA.YA_CODGI = SA1.A1_PAIS AND SYA.D_E_L_E_T_ = ' '    "
_cQuery += "WHERE SCJ.CJ_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
IF SUBSTR(cNumEmp,1,2) = "01"
	_cQuery += " AND SUBSTRING(SCJ.CJ_ORCAM,1,1) = 'M' "    
	_cQuery += " AND CJ_MSTPVEN <> 'RE' AND CJ_MSTPVEN <> 'OU' AND CJ_MSTPVEN <> 'TE' AND CJ_MSTPVEN <> 'VT' AND CJ_MSTPVEN <> 'AT'"

ENDIF	
_cQuery += "  AND SCJ.CJ_MSVEND BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "
If Empty(MV_PAR05) .AND. Alltrim(MV_PAR06) == 'ZZZ'
	_cQuery += "  AND SA1.A1_PAIS <> 'BR'
Else
	_cQuery += "  AND SA1.A1_PAIS BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
EndIf
_cQuery += "  AND SA1.A1_EST  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
If !Empty(MV_PAR09)
	_cQuery += "  AND SCJ.CJ_CLIENTE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR09+"'  "
Else
	_cQuery += "  AND SCJ.CJ_CLIENTE BETWEEN '      ' AND 'ZZZZZZ'  "
EndIf
If !Empty(MV_PAR11)
	_cQuery += "  AND SCJ.CJ_MSALIM = '"+MV_PAR11+"'  "
EndIf

// TRATA A SITUAÇÃO DOS ORÇAMENTOS 
If !Empty(MV_PAR10)
	If Len(aSituacao) > 0
		_cQuery += " AND "
		For nY := 1 to Len(aSituacao)                             
			If nY == 1 .and. Len(aSituacao) == 1 
				_cQuery += "  SCJ.CJ_MSSTAT IN ('"+aSituacao[nY][1]+"')
			ElseIf nY == 1 
			 	_cQuery += "  SCJ.CJ_MSSTAT IN ('"+aSituacao[nY][1]+"',"
			ElseIf nY < Len(aSituacao) 
			   _cQuery += "'"+aSituacao[nY][1]+"',"
			ElseIf nY == Len(aSituacao)
			   _cQuery += "'"+aSituacao[nY][1]+"')"
			EndIf
		Next nY
	EndIf
EndIf
_cQuery += "  AND SCJ.CJ_FILIAL = '"+xFilial("SCJ")+"' AND SCJ.D_E_L_E_T_ = ' '  "
_cQuery += "ORDER BY SCJ.CJ_ORCAM DESC "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","CJ_EMISSAO","D",08,00)
TcSetField("QR1","CK_ENTREG" ,"D",08,00)

ProcRegua(RecCount())   // Total de Elementos da Regua  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 	
cNumce := ""
Do While !QR1->(EOF())

	cOrcam  := QR1->CJ_ORCAM
	cNumOrc := QR1->CK_NUM

   cPaisReg := "Em Branco" 
   If Alltrim(QR1->A1_PAIS) <> "BR"  
	  cPaisReg := QR1->YA_DESCR
   Else
/*   
	   SX5->(DbSetOrder(1))
	   SX5->(DbGotop())
	   If Alltrim(QR1->A1_EST) == "SP"
	      If SX5->(DbSeek(xFilial("SX5")+"R6"+QR1->A1_REGIAO))
	         cPaisReg := SX5->X5_DESCRI
	      Else
	         cPaisReg := "SÃO PAULO"   
	      EndIf   
	   Else
	      SX5->(DbSeek(xFilial("SX5")+"12"+QR1->A1_EST))
	      cPaisReg := SX5->X5_DESCRI                               
	   EndIf
*/
		aSX512 := FwGetSX5('12',QR1->A1_EST)
		If Len(aSX512) > 0
			cPaisReg := Alltrim(aSX512[1,4])
		Endif

	EndIf
		   
	If !Empty(QR1->A3_NREDUZ)
		cNomeVend  := QR1->A3_NREDUZ
	Else
		cNomeVend := "Em Branco"
	EndIf
	
	If QR1->A1_PAIS <> "BR"
		cCODPAIS := QR1->A1_PAIS
	Else
		cCODPAIS := QR1->A1_EST
	EndIf      

	cVenda := "Sem Tipo de Venda"
/*
	If !Empty(QR1->CJ_MSTPVEN)     
		SX5->(DbSeek(xFilial("SX5")+"Z8"+QR1->CJ_MSTPVEN))
		cVenda := SX5->X5_DESCRI
	EndIf
*/
	aSX5Z8 := FwGetSX5('Z8',QR1->CJ_MSTPVEN)
	If Len(aSX5Z8) > 0
		cPaisReg := Alltrim(aSX5Z8[1,4])
	Endif

	cSegmento := "Sem segmento"
	cCodSetor := "2"
/*	
	SX5->(DbSetOrder(1))
	SX5->(DbGotop())         
	If !Empty(QR1->CJ_MSALIM)
		SX5->(DbSeek(xFilial("SX5")+"T3"+QR1->CJ_MSALIM))
		cCodSetor := "1" + SX5->X5_CHAVE 
		cSegmento := SX5->X5_DESCRI
	Else
		If !Empty(QR1->A1_SATIV1)     
			SX5->(DbSeek(xFilial("SX5")+"T3"+QR1->A1_SATIV1))
			cSegmento := SX5->X5_DESCRI
			If Alltrim(SX5->X5_CHAVE) == "9" .OR. Alltrim(SX5->X5_CHAVE) == "10" .OR. Alltrim(SX5->X5_CHAVE) == "11" .OR. Alltrim(SX5->X5_CHAVE) == "12"
				cCodSetor := "1" + SX5->X5_CHAVE 
			Else
				cCodSetor := "2" + SX5->X5_CHAVE
			EndIf
		EndIf   
	EndIf
*/
	If !Empty(QR1->CJ_MSALIM)
		aSX5T3 := FwGetSX5('T3',QR1->CJ_MSALIM)
		cCodSetor := "1" + aSX5T3[1,3] 
		cSegmento := aSX5T3[1,4]
	
	ElseIf !Empty(QR1->A1_SATIV1)
		aSX5T3 := FwGetSX5('T3',QR1->A1_SATIV1)
		cSegmento := aSX5T3[1,4]
		If aSX5T3[1,3] $ '9|10|11|12'
			cCodSetor := "1" + aSX5T3[1,3]
		Else
			cCodSetor := "2" + aSX5T3[1,3]
		Endif
	Endif

/*
	SX5->(DbSetOrder(1))
	SX5->(DbGotop())
	If !Empty(QR1->CJ_MSSTAT)
		SX5->(DbSeek(xFilial("SX5")+"Z5"+QR1->CJ_MSSTAT))
		cDescSit := SX5->X5_DESCRI
	Else
		cDescSit := "Nao tem Situacao"
	EndIf
*/

	If !Empty(QR1->CJ_MSSTAT)
		aSX5Z5 := FwGetSX5('Z5',QR1->CJ_MSSTAT)
		cDescSit := aSX5Z5[1,3]
	Else
		cDescSit := "Nao tem Situacao"
	EndIf

	cProdCli := "Sem produto"
	SZJ->(DbSetOrder(1))
	If SZJ->(DbSeek(xFilial("SZJ")+QR1->CJ_NUM+QR1->CK_ITEM ))
	   cProdCli := SZJ->ZJ_PRODUTO
	EndIf

	If QR1->CJ_MSVLORC > 0 	     
		nVlrOrc := QR1->CJ_MSVLORC
	EndIf

	nItem := 0
	lPrim := .T.
	Do While cNumOrc == QR1->CK_NUM
	    
	   If SUBSTR(TRB->NUMCE,1,9) $ Alltrim(cOrcam) .and. lPrim
	      QR1->(dbSkip())
	      Loop
	   Else
	   	lPrim := .F.
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			NUM     := QR1->CK_NUM
			NUMCE   := QR1->CJ_ORCAM
			
			ITEM	  := QR1->CK_ITEM
			REVISAO := cRev
			NOMECLI := QR1->A1_NREDUZ
			PAISREG := cPaisReg
			PRODUTO := QR1->CK_PRODUTO
			If !Empty(QR1->B1_DESC)
				 DESCRICAO := QR1->B1_DESC
			Else
				 DESCRICAO := "Produto não cadastrado"	  
			EndIf
			PRODCLI  := cProdCli
			CODSETOR := cCodSetor
			SEGMENTO := cSegmento
			VENDA    := cVenda
			CODVEN   := QR1->CJ_MSVEND
			NOMEVEN  := cNomeVend
			QTDE     := QR1->CK_QTDVEN
			
				If QR1->CJ_MSVLORC == 0 
					If QR1->CK_VALOR > 1.00 .And. QR1->CK_MSITOPC <> "S"
						 VALOR := QR1->CK_VALOR
					Else
						 VALOR := 0
					EndIf       
				Else
					 VALOR := nVlrOrc
				EndIf
		
			cNumce   :=	QR1->CJ_ORCAM         
			DTORCA   := QR1->CJ_EMISSAO
			PRAZO    := QR1->CK_ENTREG
			MOEDA    := QR1->CJ_MOEDA
			SITUACAO := QR1->CJ_MSSTAT     
			DESCSIT  := Alltrim(cDescSit)
			OPCIONAL := QR1->CK_MSITOPC
			TPVENDA  := QR1->CJ_MSTPVEN
			MOTPERDA := Alltrim(QR1->CJ_MSMOTPE)
			DTEMI    := QR1->CJ_EMISSAO 
			CODPAIS  := cCODPAIS
			MsUnLock()
		  
			nItem++
			If QR1->CK_MSITOPC <> "S"
				nVLrOrc := 0
			EndIf
		EndIf	     
		QR1->(dbSkip()) 
	EndDo

	IncProc()
	Loop
	
EndDo

If MV_PAR12 == 2 //Sintetico

	dbSelectArea("TRB")
	dbGoTop()
	Do While !TRB->(EOF())
	
		aVendedor := {}
		If SUBSTR(cNumEmp,1,2) $ "01_10"
			SA3->(dbSetOrder(1))
			If SA3->(dbSeek(xFilial("SA3")+TRB->CODVEN))
				If Alltrim(SA3->A3_TIPVEND) == "2" 
					AADD(aVendedor,"")
					AADD(aVendedor,Alltrim(TRB->CODVEN))                        
					If Empty(Alltrim(SA3->A3_GEREN))
						AADD(aVendedor,Alltrim(TRB->CODVEN))
					Else   
						AADD(aVendedor,Alltrim(SA3->A3_GEREN))
					EndIf   
				Else
					AADD(aVendedor,Alltrim(TRB->CODVEN))
					If Empty(Alltrim(SA3->A3_SUPER))
						AADD(aVendedor,Alltrim(SA3->A3_GEREN))
					Else   
						AADD(aVendedor,Alltrim(SA3->A3_SUPER))
					EndIf
					AADD(aVendedor,Alltrim(SA3->A3_GEREN)) 
				EndIf   
			Else
				Alert("Vendedor não cadastrado => "+ TRB->CODVEN)
			EndIf      
		EndIf
	   
		cNumOrc:= TRB->NUM
	 
		Do While cNumOrc == TRB->NUM 
		
			If TRB->OPCIONAL == "S"
				TRB->(DbSkip())
				Loop
			EndIf   
			   
			dbSelectArea("TRB1")
			For I = 1 to 3  
				If !Empty(aVendedor[I])
					RecLock("TRB1",.T.)
					TRB1->TPVENDEDOR := I
					TRB1->CODVEN     := aVendedor[I]
					TRB1->NUMCE      := TRB->NUMCE
					TRB1->ITEM      := TRB->ITEM
					TRB1->CODPAIS    := TRB->CODPAIS
  					TRB1->PAISREG    := TRB->PAISREG
 					TRB1->CODSETOR   := TRB->CODSETOR
					TRB1->SEGMENTO   := TRB->SEGMENTO
					TRB1->TPVENDA    := TRB->TPVENDA
 					TRB1->VENDA      := TRB->VENDA
					TRB1->QTDE       := TRB->QTDE
					TRB1->VALOR      := TRB->VALOR
					TRB1->DTEMI      := TRB->DTEMI 
					TRB1->MOEDA      := TRB->MOEDA
					TRB1->OPCIONAL   := TRB->OPCIONAL
 					TRB1->REVISAO    := TRB->REVISAO
 					TRB1->SITUACAO   := TRB->SITUACAO
					TRB1->DESCSIT    := TRB->DESCSIT
					nVlrOrc := 0 
					MsUnLock()
				EndIf
			Next I
			nVlrOrc := 0
			TRB->(dbSkip()) 
			Loop
		EndDo

		IncProc()
		Loop

	EndDo

EndIf 

Return

//**********************************
  Static Function ConverteMoeda()
//**********************************

If MV_PAR12 == 1  // Analitico

	If TRB->OPCIONAL <> "S"
		nVlrReal := TRB->VALOR
		nTaxa    := 1
		If TRB->MOEDA > 1
			nDia := 31
			If Month(TRB->DTORCA) == 2
				nResto := Year(TRB->DTORCA) / 4
				If nResto > 0
					nDia := 28
				Else
					nDia := 29
				EndIf
			Else
				If Month(TRB->DTORCA) == 4 .OR. Month(TRB->DTORCA) == 6 .OR. Month(TRB->DTORCA) == 9 .OR. Month(TRB->DTORCA) == 11
					nDia := 30
				EndIf
			EndIf
			DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTORCA),5,2) + "/" + SubStr(Dtos(TRB->DTORCA),1,4))
			If DtAux  > Date()
				DtAux := Date()
			End
			If DOW(DtAux) == 1
				nDia-=2
				DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTORCA),5,2) + "/" + SubStr(Dtos(TRB->DTORCA),1,4))
			ElseIf DOW(DtAux) == 7
				nDia--
				DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTORCA),5,2) + "/" + SubStr(Dtos(TRB->DTORCA),1,4))
			EndIf
			cCampo := "SM2->M2_MOEDA"+Alltrim(STR(TRB->MOEDA))
			SM2->(DBSetOrder(1))
			IF SM2->(DBSeek(DtAux))
				nTaxa := &cCampo
			EndIf
			nVlrReal := TRB->VALOR * nTaxa
		EndIf
	EndIf

ElseIf MV_PAR12 == 2  // Sintetico

	   If TRB1->OPCIONAL == "S"
	      nVlrReal := 0
	   Else   
	      nVlrReal := TRB1->VALOR
	      nTaxa    := 1
	      If TRB1->MOEDA > 1                                                   
	         nDia := 31
	         If Month(TRB1->DTEMI) == 2
	            nResto := Year(TRB1->DTEMI) / 4
	            If nResto > 0
	               nDia := 28
	            Else
	               nDia := 29
	            EndIf  
	         Else
	            If Month(TRB1->DTEMI) == 4 .OR. Month(TRB1->DTEMI) == 6 .OR. Month(TRB1->DTEMI) == 9 .OR. Month(TRB1->DTEMI) == 11
	               nDia := 30
	            EndIf
	         EndIf
	         DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB1->DTEMI),5,2) + "/" + SubStr(Dtos(TRB1->DTEMI),1,4))
	         If DtAux  > Date()
	            DtAux := Date()
	         End 
	         If DOW(DtAux) == 1
	            nDia-=2
	            DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB1->DTEMI),5,2) + "/" + SubStr(Dtos(TRB1->DTEMI),1,4))
	         ElseIf DOW(DtAux) == 7
	            nDia--
	            DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB1->DTEMI),5,2) + "/" + SubStr(Dtos(TRB1->DTEMI),1,4))
	         EndIf     
	         cCampo := "SM2->M2_MOEDA"+Alltrim(STR(TRB1->MOEDA))
	         SM2->(DBSetOrder(1))
	         IF SM2->(DBSeek(DtAux))
	            nTaxa := &cCampo
	         EndIf
	         nVlrReal := TRB1->VALOR * nTaxa
			EndIf
		EndIf
EndIf
	
Return

//*******************************
  Static Function ImpTotal()
//*******************************

If cExport == "S"
   @li,005 Psay "TOTAL  R$ =>"
   @li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
   @li,068 Psay nTotValor PICTURE "@E 999,999,999.99"
   Li++
   @li,005 Psay "TOTAL US$ =>"
   @li,068 Psay nTotMoeda2 PICTURE "@E 999,999,999.99"
Else
   @li,005 Psay "TOTAL ===>"
   @li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
   @li,068 Psay nTotValor PICTURE "@E 999,999,999.99"
EndIf 
nTotQtde  := 0
nTotValor := 0

Return

//*******************************
  Static Function ImpResumo()
//*******************************

Ferase(cArqTrab2+OrdBagExt())      // Apaga o índice para recriá-lo em outra ordem                       

lPrim      := .T. 
Li         := 99
nQtde      := 0
nValor     := 0
nTotQtde   := 0
nTotValor  := 0 
nTotMoeda2 := 0 

dbSelectArea("TRB1")
dbGoTop()

Do Case
   Case nOrdem == 1
        IndRegua("TRB1",cArqTrab2,"CODPAIS",,,"Selecionando Registros...")  
   Case nOrdem == 2
        IndRegua("TRB1",cArqTrab2,"CODSETOR",,,"Selecionando Registros...") 
   Case nOrdem == 3
        IndRegua("TRB1",cArqTrab2,"TPVENDA",,,"Selecionando Registros...")         
EndCase

SetRegua(RecCount())  // TOTAL DE ELEMENTOS DA REGUA 

Do While TRB1->(!EOF())
    
	If lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
   If TRB1->TPVENDEDOR <> 2
	   DbSkip()
	   Loop
	EndIf    
	
    If Li > 62
	   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	   Li:= 8
	   @li,000 Psay  "Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)
	   Li+=2
       @li,000 Psay Replicate("*",56)
       @li,058 Psay "R  E  S  U  M  O"
       @li,076 Psay Replicate("*",56)
       Li++
	EndIf 
	
	If lPrim 
	   lPrim := .F.
	   cPaisAnt     := Alltrim(TRB1->CODPAIS)
	   cPaisReg     := TRB1->PAISREG
	   cTpVenAnt    := Alltrim(TRB1->TPVENDA)   
	   cVenda       := Alltrim(TRB1->VENDA)
	   cSetorAnt    := Alltrim(TRB1->CODSETOR)
	   If SubStr(cSetorAnt,1,1) == "1" 
	      cSegmento := "Alimentício   " + " - " + Upper(TRB1->SEGMENTO)
       Else
	      cSegmento :=  "Outros Setores" + " - " + Upper(TRB1->SEGMENTO)
	   EndIf
	EndIf    
    
  	If &cQuebra 
		nQtde     += TRB1->QTDE
	   ConverteMoeda()
		nValor     += nVlrReal
	Else
		Li++ 
		Do Case
			Case  nOrdem == 1  
					@li,000 Psay cPaisReg
					cPaisAnt := Alltrim(TRB1->CODPAIS)
					cPaisReg := TRB1->PAISREG
	      Case  nOrdem == 2
		         @li,000 Psay cSegmento
		         cSetorAnt := Alltrim(TRB1->CODSETOR)
		         If SubStr(cSetorAnt,1,1) == "1" 
		            cSegmento := "Alimentício   " + " - " + Upper(TRB1->SEGMENTO)
		         Else
		            cSegmento := "Outros Setores" + " - " + Upper(TRB1->SEGMENTO)
		         EndIf       
			Case  nOrdem == 3  
					@li,000 Psay cVenda
		         cTpVenAnt := Alltrim(TRB1->TPVENDA)
					cVenda   := TRB1->VENDA
		EndCase
	   @li,045 Psay nQtde  PICTURE "@E 99,999.9999"
		@li,068 Psay nValor PICTURE "@E 999,999,999.99"
		nQtde   := TRB1->QTDE
		ConverteMoeda()
		nValor  := nVlrReal
	EndIf
   nTotQtde   += TRB1->QTDE
   nTotValor  += nVlrReal
   If TRB1->MOEDA == 2
   	nTotMoeda2 += TRB1->VALOR
   EndIf 
   nCont++
    
	dbSelectArea("TRB1")
	IncRegua()
	TRB1->(dbSkip())
	Loop
EndDo                                                                                              

Li++
If Li > 62
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
   Li:= 8
   @li,000 Psay   "Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)
   Li+=2
EndIf 

Do Case
   Case nOrdem == 1
      @li,000 Psay cPaisReg
   Case nOrdem == 2
      @li,000 Psay cSegmento
   Case nOrdem == 3
      @li,000 Psay cVenda
EndCase 
@li,045 Psay nQtde  PICTURE "@E 99,999.9999"
@li,068 Psay nValor PICTURE "@E 999,999,999.99"

li++
@li,000 Psay Replicate("-",132)
Li++ 
 
If cExport == "S"
   @li,005 Psay "TOTAL  R$ =>"
   @li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
   @li,068 Psay nTotValor PICTURE "@E 999,999,999.99"
   Li++
   @li,005 Psay "TOTAL US$ =>"
   @li,068 Psay nTotMoeda2 PICTURE "@E 999,999,999.99"
Else
   @li,005 Psay "TOTAL ===>"
   @li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
   @li,068 Psay nTotValor PICTURE "@E 999,999,999.99"
EndIf 

Return 
   
//**********************************
  Static Function ImpParam()         
//**********************************
         
If MV_PAR12 == 1  // Analitico

	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	Li:= 10
	@Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
	Li+=3
	@Li,000 Psay "Data Orçamento de.: " + DTOC(mv_par01)
	@li,037 Psay  "ate: " + DTOC(mv_par02)
	Li++
	@Li,000 Psay "Vendedor de.......: " + mv_par03
	@li,037 Psay "ate: " + mv_par04
	Li++
	@Li,000 Psay "Pais de...........: " + mv_par05
	@li,037 Psay "ate: " + mv_par06
	Li++
	@Li,000 Psay "UF de.............: " + mv_par07
	@li,037 Psay "ate: " + mv_par08
	Li++
	If SubStr(mv_par09,1,3) = "ZZZ".Or. Alltrim(mv_par09) = ""
		@Li,000 Psay "Cliente...........: Todos"
	Else
		@Li,000 Psay "Cliente...........: " + mv_par09
	EndIf
	Li++
	If SubStr(mv_par10,1,2) = "ZZ" .Or. Alltrim(mv_par10) = ""
		@Li,000 Psay "Situação..........: Todos"
	Else
		@Li,000 Psay "Situação..........: " + mv_par10
	EndIf
	Li++
    If SubStr(mv_par11,1,2) = "ZZ" .Or. Alltrim(mv_par11) = "" 
       @Li,000 Psay "Segmento...........: Todos"
    Else
       @Li,000 Psay "Segmento...........: " + mv_par11
    EndIf    
	Li++
	If MV_PAR12 == 1
		cTpRel := 'Analitico'
		@Li,000 Psay "Tipo Relatorio....: " + cTpRel
	Else
		cTpRel := 'Sintetico'
		@Li,000 Psay "Tipo Relatorio....: " + cTpRel
	EndIf
	Li:=80
	
ElseIf MV_PAR12 == 2  // Sintetico
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
    Li:= 10
    @Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
    Li+=3
    @Li,000 Psay "Ordem.............:"
    Do Case
       Case nOrdem == 1
         @Li,020 Psay "PAIS ou REGIÃO"
       Case nOrdem == 2
         @Li,020 Psay "SETOR DE ATIVIDADE"
       Case nOrdem == 3
         @Li,020 Psay "EQUIPAMENTOS"
    End
    Li+=2         
    @Li,000 Psay "Data Orçamento de.: " + DTOC(mv_par01)
    @li,037 Psay  "ate: " + DTOC(mv_par02)
    Li++
    @Li,000 Psay "Vendedor de.......: " + mv_par03
    @li,037 Psay "ate: " + mv_par04
    Li++
    @Li,000 Psay "Pais de...........: " + mv_par05
    @li,037 Psay "ate: " + mv_par06
    Li++
    @Li,000 Psay "UF de.............: " + mv_par07
    @li,037 Psay "ate: " + mv_par08
    Li++
    If SubStr(mv_par09,1,3) = "ZZZ".Or. Alltrim(mv_par09) = "" 
       @Li,000 Psay "Cliente...........: Todos"
    Else
       @Li,000 Psay "Cliente...........: " + mv_par09
    EndIf
    Li++
    If SubStr(mv_par10,1,2) = "ZZ" .Or. Alltrim(mv_par10) = "" 
       @Li,000 Psay "Situação..........: Todos"
    Else
       @Li,000 Psay "Situação..........: " + mv_par10
    EndIf
    Li++
    If SubStr(mv_par11,1,2) = "ZZ" .Or. Alltrim(mv_par11) = "" 
       @Li,000 Psay "Segmento..........: Todos"
    Else
       @Li,000 Psay "Segmento..........: " + mv_par11
    EndIf    
    Li++
	If MV_PAR12 == 1
		cTpRel := 'Analitico'
		@Li,000 Psay "Tipo Relatorio....: " + cTpRel
	Else
		cTpRel := 'Sintetico'
		@Li,000 Psay "Tipo Relatorio....: " + cTpRel
	EndIf
	Li:=80      

EndIf
	
Return
