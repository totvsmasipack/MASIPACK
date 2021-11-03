
#Include "Topconn.ch"
#Include "Rwmake.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ RCOMR009  ³ Autor ³ Aparecida F.Stevanato³ Data ³ 30/03/09 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Ã³Descri‡…o ³ Emissao da Analise de Fornecedores no Periodo             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ Masipack                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//Reescrito por Eduardo Mantoan 28/05/2014 - Otimizado Query e estrutura de trabalho - Não foi alterado os calculos IQF - Criado perguntas SX1
/ */
User Function RCOMR009()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private wnrel	  := "RCOMR009"


Private cDesc1	  	:= "Análise dos Fornecedores - Periodo: "
Private cDesc2    := "Este relatorio ira imprimir a Análise dos Fornecedores"
Private Cabec1    := "Tipo Documento    Pedido/Item  Produto         Descrição                            Q t d e.      Dt.Entregue  Prev.Entrega  Atraso"
Private Cabec2    := "" 
Private cDesc3    := "" 
Private aOrd      := ""
Private cArqTrab  := ""
Private cFilTrab  := ""
Private Titulo	  	:= "Análise dos Fornecedores - Periodo: "
Private aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private Tamanho   := "M"
Private Limite    := 132
Private nomeprog  := "RCOMR009"
Private nLastKey  := 0
Private cString   := "SD1"
Private m_pag	  	:= 1                                                                               
Private Li        := 80
Private cPerg	  	:= "XRCOMR009"
Private nAtrasoFor:= 0
Private nAtrasoTot:= 0
Private nRNCFor   := 0
Private nRNCTot   := 0
Private nQtdMat   := 0
Private nTotMat   := 0
Private nDevFor   := 0
Private nTotDev   := 0
Private nItensFor := 0
Private nItensTot := 0
Private cFornAnt  := ""
Private cLojaAnt  := ""
Private cTipoAnt  := ""
Private cNomeFor  := "" 
Private cNomeRdz  := ""
Private cRisco    := ""
Private cNat      := ""
PRIVATE cArqCSV   := ""
PRIVATE cRegCSV   := "" 
Private _lAchou   := .F.
Private nPontual  := 0                                                                	
Private nQualid   := 0 
Private nIQFEnt   := 0
Private nIQFQual  := 0
Private nIQFPont  := 0
Private nPontos   := 0 
Private _lAtuSZR  := .F.
Private MesIni    := 0
Private MesFin    := 0
Private cPeriodo  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Da data de digitação                             ³
//³ mv_par02    Ate a data de digitação                          ³
//³ mv_par03    Analitico ou Sintetico                           ³
//³             Analitico - Imprime os Itens e as RNC'S          ³  
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
If !Pergunte(cPerg,.T.)
   Return
EndIf   

wnrel :=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

If nLastKey==27
   Set Filter to
   Return
EndIf 

SA2->(DbSetOrder(1))
SZR->(DbSetOrder(2))

_lAtuSZR := .F.   // Não atualiza Tabela SZR - Avalização dos Fornecedores

If AnoMes(mv_par01) == AnoMes(mv_par02) .And. Day2Str(mv_par01) == "01" .And. Last_Day(mv_par02) == Day(mv_par02) 
   If MsgBox("*** ATENÇÃO, Deseja atualizar Avaliação dos Fornecedores? ***","AVISO","YESNO") 
      cPeriodo := AnoMes(mv_par01)
     _lAtuSZR := .T.
   EndIf
EndIf 

Titulo +=  " De " + DTOC(mv_par01)
If mv_par02 > mv_par01
   Titulo += " ate  " + DTOC(mv_par02)
EndIf 

If (cArqCSV := FCreate("C:\Relato_Microsiga\Analise_Fornecedor.csv")) == -1
   Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else 
   cRegCSV := ";" + Titulo  
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
   cRegCSV := ""
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
   cRegCSV := "CODIGO;FORNECEDOR;PONTUAÇÃO;NAT.;CLASSE;ITENS;NO PRAZO;INDICE;IQF;QTDE.MATERIAL;ITENS;INDICE;IQF;IQF;IQF TOTAL"
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := ";;;;;RECEBIDOS;;ENTREGA;ENTREGA;RECEBIDO;DEVOLVIDOS;CONFORMIDADE;CONFORMIDADE;PONTUAÇÃO"
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := ""
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf 

SetDefault(aReturn,cString)

MsgRun("Aguarde, Gerando Avaliação dos Fornecedores !!!!",, {|| GeraTrab(@lEnd,wnRel,"TRB")}) // Gera tabela trabalho com as informações  

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},titulo)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao	 ³ GeraTrab	³  Cria Arquivo de Trabalho             ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraTrab()

Local aCampos  := {}
Local oTable   := Nil

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Define array para arquivo de trabalho                        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
   AADD(aCampos,{ "NREDUZ"  ,"C",20,0 } )
   AADD(aCampos,{ "FORNECE" ,"C",6 ,0 } )
   AADD(aCampos,{ "LOJA"    ,"C",2 ,0 } )
   AADD(aCampos,{ "TIPO"    ,"C",1 ,0 } )
   AADD(aCampos,{ "DTMOV"   ,"D",8 ,0 } )
   AADD(aCampos,{ "DOCUM"   ,"C",11,0 } )
   AADD(aCampos,{ "PRODUTO" ,"C",15,0 } )
   AADD(aCampos,{ "PEDIDO"  ,"C",11,0 } )
   AADD(aCampos,{ "QTDE"    ,"N",11,3 } )
   AADD(aCampos,{ "DTENTR"  ,"D",8 ,0 } ) 
   AADD(aCampos,{ "PONTOS"  ,"N",3 ,0 } )
   AADD(aCampos,{ "RISCO"   ,"C",3 ,0 } )
   AADD(aCampos,{ "MSPONTI" ,"N",3 ,0 } )
   AADD(aCampos,{ "NATUREZ" ,"C",10,0 } )
   AADD(aCampos,{ "DESCRI"  ,"C",35,0 } )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Cria arquivo de Trabalho                                     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If Select("TRB") > 0 
      DbSelectArea("TRB")
      TRB->(dbCloseArea())
   EndIf
   
   oTable := FWTemporaryTable():New("TRB",aCampos)
   oTable:AddIndex("01", {"NREDUZ","FORNECE","LOJA","TIPO"} )
	oTable:Create()

   SC7->(DbSetOrder(1))  
   SD1->(DbSetOrder(10))
   SD1->(DBGOTOP())

   //If Alltrim(mv_par03) = ""
   //   mv_par03 := "ZZZZZZ"
   //EndIf

   IF Select("QR1") > 0
      DbSelectArea("QR1")
      DbCloseArea()
   ENDIF  
   _cQuery := " SELECT 'E' AS TIPO, SD1.D1_DOC AS NOTAS, SD1.D1_PEDIDO AS PEDIDO, F1_RECBMTO AS EMISSAO, SD1.D1_FORNECE AS CODFOR,"
   _cQuery += " SA2.A2_NREDUZ AS NOMFOR, SD1.D1_COD AS PROD, SB1.B1_DESC AS DESCRI, SD1.D1_QUANT AS QTDE , SD1.D1_UM AS UNID,SD1.D1_LOJA AS LOJA,"
   _cQuery += " D1_ITEM AS ITEM, D1_ITEMPC AS ITEMP,A2_NATUREZ,A2_RISCO,A2_MSPONTI"
   _cQuery += " FROM "+RetSqlName("SD1")+" SD1" 
   _cQuery += " INNER JOIN "+RetSqlName("SF1")+" SF1 ON SF1.F1_DOC = SD1.D1_DOC AND SD1.D1_FORNECE = SF1.F1_FORNECE"
   _cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = SD1.D1_FORNECE"
   _cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SD1.D1_COD"
   _cQuery += " WHERE SD1.D1_DTDIGIT BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"
   _cQuery += " AND SD1.D1_TIPO = 'N'"
   _cQuery += " AND SD1.D1_TES <> '   '"
   IF MV_PAR05 == 1                    
      _cQuery += " AND SA2.A2_RISCO = 'A' "
   ELSEIF MV_PAR05 ==2
      _cQuery += " AND SA2.A2_RISCO = 'B'"
   ELSE
      _cQuery += " AND (SA2.A2_RISCO = 'A' OR SA2.A2_RISCO = 'B')"
   ENDIF
   _cQuery += " AND (A2_NATUREZ = 'A01' OR A2_NATUREZ = 'A05')"
   _cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "' "
   _cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "' "
   _cQuery += " AND A2_FILIAL = '" + xFilial("SA2") + "' AND A2_MSBLQL <> '1' "
   _cQuery += " AND SD1.D_E_L_E_T_ = ''"
   _cQuery += " AND SA2.D_E_L_E_T_ = ''"
   _cQuery += " AND SB1.D_E_L_E_T_ = ''"

   _cQuery += "  UNION  ALL"

   _cQuery += " SELECT 'S' AS TIPO, SD2.D2_DOC AS NOTAS, SD2.D2_PEDIDO AS PEDIDO, SD2.D2_EMISSAO AS EMISSAO, SD2.D2_CLIENTE AS CODFOR,"
   _cQuery += " SA2.A2_NREDUZ AS NOMFOR, SD2.D2_COD AS PROD, SB1.B1_DESC AS DESCRI, SD2.D2_QUANT AS QTDE , SD2.D2_UM AS UNID,SD2.D2_LOJA AS LOJA,"
   _cQuery += " D2_ITEM AS ITEM, D2_ITEMPV AS ITEMP,A2_NATUREZ,A2_RISCO,A2_MSPONTI"
   _cQuery += " FROM "+RetSqlName("SD2")+" SD2"
   _cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = SD2.D2_CLIENTE"
   _cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SD2.D2_COD"
   _cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"
   _cQuery += " AND (SD2.D2_TIPO = 'D' OR SUBSTRING(SD2.D2_CF,2,1) = '2')	" 																									
   IF MV_PAR05 == 1                    
      _cQuery += " AND SA2.A2_RISCO = 'A' "
   ELSEIF MV_PAR05 ==2
      _cQuery += " AND SA2.A2_RISCO = 'B'"
   ELSE
      _cQuery += " AND (SA2.A2_RISCO = 'A' OR SA2.A2_RISCO = 'B')"
   ENDIF
   _cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' "
   _cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "' "
   _cQuery += " AND A2_FILIAL = '" + xFilial("SA2") + "' AND A2_MSBLQL <> '1' "
   _cQuery += " AND (A2_NATUREZ = 'A01' OR A2_NATUREZ = 'A05')"
   _cQuery += " AND SD2.D_E_L_E_T_ = ''"
   _cQuery += " AND SA2.D_E_L_E_T_ = ''"
   _cQuery += " AND SB1.D_E_L_E_T_ = ''" 

   _cQuery += " ORDER BY UNID"


   TcQuery _cQuery New Alias "QR1"

   TcSetField("QR1","EMISSAO","D",08,00)

   Do While !QR1->(Eof())
   
      dbSelectArea("TRB")
      RecLock("TRB",.T.)
      TRB->NREDUZ    := Alltrim(QR1->NOMFOR)
      TRB->FORNECE   := Alltrim(QR1->CODFOR)
      TRB->LOJA      := Alltrim(QR1->LOJA)
      TRB->TIPO      := QR1->TIPO
      TRB->DTMOV     :=	QR1->EMISSAO
      TRB->DOCUM     := QR1->NOTAS + "/" + QR1->ITEM
      TRB->PRODUTO   := QR1->PROD
      TRB->PEDIDO    := QR1->PEDIDO
      If TRB->PEDIDO <> "           "
         TRB->PEDIDO    := QR1->PEDIDO + "/" + QR1->ITEMP
      Else
         TRB->PEDIDO := "Sem Pedido"
      EndIF
      TRB->QTDE      := QR1->QTDE
      TRB->NATUREZ   := Alltrim(QR1->A2_NATUREZ)
      TRB->RISCO     := Alltrim(QR1->A2_RISCO)
      TRB->MSPONTI   := QR1->A2_MSPONTI
      TRB->DESCRI    := QR1->DESCRI 
      
      If QR1->TIPO == "E" 
      
         If SC7->(DbSeek(xFilial("SC7")+QR1->PEDIDO+QR1->ITEMP))
            If MV_PAR04 == 1
               If DTOS(SC7->C7_MSDTPE) == "" .OR. DTOS(SC7->C7_MSDTPE) == "        " .OR. DTOS(SC7->C7_MSDTPE) == "          "
                  TRB->DTENTR := SC7->C7_DATPRF			
               Else
                  TRB->DTENTR := SC7->C7_MSDTPE
               EndIf	 
            Else
               TRB->DTENTR := SC7->C7_DATPRF	
            EndIf
         EndIf  
         
      EndIF 
      
      TRB->(MsUnLock())
      QR1->(DbSkip())
   EndDo
   

   //dbCommitAll()
  
Return
 
Static Function ImpRel() 

DbSelectArea("TRB")
TRB->(dbGoTop())

SetRegua(RecCount())

Do While ! TRB->(EOF()) 

   IncRegua()
           
   If lEnd
	  @PROW()+1,001 Psay "Cancelado Pelo Operador"         // CANCELADO PELO OPERADOR
	  Exit
   Endif 
   
   If TRB->FORNECE+TRB->LOJA <> cFornAnt+cLojaAnt
      If cFornAnt <> ""
         ImpFornec()
      EndIf
      nAtrasoFor 	:= 0
      nItensFor  	:= 0
      nQtdMat    	:= 0
      nRNCFor    	:= 0
      nDevFor    	:= 0
      cTipoAnt   	:= ""
      cRisco     	:= ""
      cNat       	:= "" 
      nPontos    	:= 0  
      cFornAnt   	:= TRB->FORNECE
      cLojaAnt   	:= TRB->LOJA
      cNomeFor 	:= TRB->NREDUZ
      cNomeRdz 	:= TRB->NREDUZ
      cNat     	:= TRB->NATUREZ
      cRisco   	:= TRB->RISCO
      nPontos  	:= TRB->MSPONTI
     
      Li++
      If Li > 65
         cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
      Endif    
      @ Li,000 Psay "Fornecedor: " + Alltrim(TRB->NREDUZ) + " => " + TRB->FORNECE + "/" + TRB->LOJA + " - " + cNomeFor + "   Natureza: " + cNat +  "    Classificação: " + cRisco + "   Pontuação: " + Str(nPontos,3)
      Li++  
   EndIf   
   If mv_par03 == 2           // analitico 
     If Li > 65
        cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
        @ Li,000 Psay "Fornecedor: " + Alltrim(TRB->NREDUZ) + " => " + TRB->FORNECE + "/" + TRB->LOJA + " - " + cNomeFor + "   Natureza: " + cNat +  "     Classificação: " + cRisco + "   Pontuação: " + Str(nPontos,3)
        Li++
     EndIf
     Li++
     If TRB->TIPO <> cTipoAnt
         If cTipoAnt <> ""
            @ Li,000 Psay Replicate("-",132)
            Li++ 
         EndIf     
	     	@ Li,000 Psay SubStr(TRB->TIPO,2,3)
	     	cTipoAnt := TRB->TIPO
	  EndIf
	  If TRB->TIPO == "E"
	  	//	@ Li,000 Psay "NFE"
	  ElseIf TRB->TIPO == "S"	
	  		@ Li,000 Psay "DEV"
	  EndIf   
	  @ Li,005 Psay TRB->DOCUM
	  
	  If TRB->PEDIDO == ""
	  		@ Li,000 Psay "Sem Pedido"	
	  Else
	  		@ Li,018 Psay TRB->PEDIDO
     EndIF
     
     @ Li,031 Psay TRB->PRODUTO 
	  @ Li,047 Psay Substr(TRB->DESCRI,1,35)
	  @ Li,086  Psay TRB->QTDE    Picture "@E 99,999.999"
	  @ Li,100  Psay DTOC(TRB->DTMOV) 
   EndIf   
   If TRB->TIPO == "R"
      nRNCFor   += TRB->QTDE
      nRNCTot   += TRB->QTDE
   ElseIf TRB->TIPO == "S"
      nDevFor   += TRB->QTDE
      nTotDev   += TRB->QTDE
   ElseIf TRB->TIPO == "E"
    	If TRB->PEDIDO == "Sem Pedido "     
      	
      Else
      	
      	nDias := TRB->DTMOV - TRB->DTENTR    // Verifica Dias de atraso na entrega
      	If Alltrim(DiaSemana(TRB->DTENTR)) = "Sexta"
         	nDias-=2
      	EndIf   
      	If cNat == "A05" .Or. SubStr(TRB->PRODUTO,1,2) == "TS"
         	nDias := 0
      	EndIf   
      	If nDias > 4      
         	nAtrasoFor++
         	nAtrasoTot++
      	EndIf
      	
      	If mv_par03 == 2
      		IF nDias < 0
      			nDias := 0 // Mesmo dia ou quando a entrega foi feita antes da data prevista
      		EndIf
         	@ Li,113 Psay DTOC(TRB->DTENTR)
         	@ Li,127 Psay nDias Picture "@E 999" 
         	If nDias > 4
           		@ Li,131 Psay "*"
         	EndIf
      	EndIf
      	
      EndIF
      
      nItensFor++ 
      nQtdMat += TRB->QTDE
      nItensTot++ 
      nTotMat += TRB->QTDE
   EndIf
   TRB->(DbSkip())
   Loop
EndDo

ImpFornec() 

Li++
@ Li,000 Psay "Observações: Os Itens TS não são considerados na pontualidade do Fornecedor"
Li++
@ Li,000 Psay Replicate("-",132)

FClose(cArqCSV)  
dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())    

If aReturn[5] = 1
   	Set Printer TO
   	Commit
   	OurSpool(wnrel)
EndIf
                                                                                       
MS_FLUSH()

Return  .T.

Static Function ImpFornec()
	Li+=2
    @ Li,000 Psay "Qtde. Materiais Recebidos: "
    @ Li,027 Psay nQtdMat Picture "@E 999,999.999"
    @ Li,045 Psay "Itens Recebidos fora do prazo: " 
    @ Li,076 Psay nAtrasoFor Picture "@E 99,999"
    @ Li,098 Psay "Qtde. Devolvida: "
    @ Li,119 Psay nDevFor Picture "@E 999,999.999"
    Li++
    @ Li,000 Psay "Total de Itens Recebidos.: "
    @ Li,028 Psay nItensFor Picture "@E 99,999"
    @ Li,045 Psay "Pontualidade: "
    If cNat == "A05"
       @ Li,060 Psay "Não Aplica"
       nPontual := 100
       nIQFEnt  := 20
    Else
       If nItensFor > 0
          nPontual := 100 - (nAtrasoFor * 100 / nItensFor)
       Else
          nPontual := 0
       EndIf      
       nIQFEnt  := nPontual * 0.2 
       @ Li,060 Psay nPontual Picture "@E 999.9999"
       @ Li,069 Psay "%"
    EndIf   
    @ Li,098 Psay "Conformidade: "
    If nQtdMat > 0
       nQualid := 100 - (nDevFor * 100 / nQtdMat)
    Else
       nQualid := 0   
    EndIf   
    nIQFQual := nQualid * 0.75
    @ Li,113 Psay nQualid Picture "@E 999.9999"
    @ Li,122 Psay "%"
    Li+=2
    @ Li,000 Psay "IQF - Entrega: "
    @ Li,016 Psay nIQFEnt Picture "@E 999.9999"
    @ Li,025 Psay "%" 
    @ Li,033 Psay "IQF - Conformidade: "
    @ Li,053 Psay nIQFQual Picture "@E 999.9999"
    @ Li,062 Psay "%"
    nIQFPont := nPontos * 0.05
    @ Li,071 Psay "IQF - Pontuação: "
    @ Li,088 Psay nIQFPont Picture "@E 999.9999"
    @ Li,097 Psay "%"  
    @ Li,105 Psay "IQF - Total: "
    @ Li,119 Psay nIQFEnt+nIQFQual+nIQFPont  Picture "@E 999.9999"
    @ Li,128 Psay "%"      
    Li++
    @ Li,000 Psay Replicate("=",132)
    Li++
    cRegCSV := "_"+cFornAnt+"/"+cLojaAnt+";"+cNomeFor+";"+Str(nPontos,3)+";"+cNat+";"+cRisco+";"+TRANSFORM(nItensFor,"@E 999,999.999")+";"+TRANSFORM((nItensFor-nAtrasoFor),"@E 999,999.999")+";"+TRANSFORM(nPontual,"@E 999.9999")+";"+TRANSFORM(nIQFEnt,"@E 999.9999")+";"+TRANSFORM(nQtdMat,"@E 999,999.999")+";"+TRANSFORM(nDevFor,"@E 999,999.999")+";"+TRANSFORM(nQualid,"@E 999.999")+";"+TRANSFORM(nIQFQual,"@E 999.999")+";"+TRANSFORM(nIQFPont,"@E 999.999")+";"+TRANSFORM(nIQFEnt+nIQFQual+nIQFPont,"@E 999.999")+" %"  
    FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
    If _lAtuSZR
       GravaSZR()
    EndIf   
Return

Static Function GravaSZR()
   If !SZR->(DbSeek(xFilial("SZR")+cPeriodo+cFornAnt+cLojaAnt)) 
      RecLock("SZR",.T.)
      SZR->ZR_FILIAL  := "01"
      SZR->ZR_FORNEC  := cFornAnt
      SZR->ZR_LOJA    := cLojaAnt
      SZR->ZR_PERIODO := cPeriodo
   Else
      RecLock("SZR",.F.)
   EndIf   
   SZR->ZR_IQFENT  := nIQFEnt
   SZR->ZR_IQFCONF := nIQFQual
   SZR->ZR_IQFPONT := nIQFPont
   SZR->ZR_IQFTOT  := nIQFEnt+nIQFQual+nIQFPont
   SZR->(MsUnlock())

Return
