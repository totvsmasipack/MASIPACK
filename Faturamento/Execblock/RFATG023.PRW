#Include "Rwmake.ch"
#Include "Topconn.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	 ³ RFATG023³ Autor ³ Aparecida de F.Stevanato ³Data ³  17.12.08 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Gera Planilha com pedidos Concluidos/Faturados             ³±± 
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 

User Function RFATG023()

PRIVATE titulo      := "" 
PRIVATE cString     := ""
PRIVATE cPerg	    := "FATG23"
PRIVATE nLastKey    := 0
PRIVATE cArqCSV     := ""
PRIVATE cRegCSV     := ""
Private cCliente    := ""
Private cVend       := ""
Private cNF         := ""
Private cPais       := ""
Private cTemOP      := ""
Private cAcomPV     := ""
Private cSerie      := ""
Private dDtFat      := CTOD("")
Private dDtEntrega  := CTOD("")
Private nAtraso1    := 0
Private nAtraso2    := 0
Private lGrava      := .F. 

If !Pergunte(cPerg,.T.)
   Return
EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    			 ³
//³ mv_par01	 -  Pedido de                                    ³
//³ mv_par02	 -  Pedido ate                                   ³
//³ mv_par03	 -  1-Concluidos   2-Faturados                   ³
//³ mv_par04	 -  Data de  (faturado ou concluido)             ³
//³ mv_par05	 -  Data ate	                                 ³
//³ mv_par06	 -  Maqs. com Serie (S=Sim, N=Nao)               ³ 
//³ mv_par07	 -  Categoria do Pedido (1,2,3,4,5)              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLastKey==27
	Set Filter to
	Return
Endif

MsgRun("Aguarde, Gerando Planilha!!!!",, { || GeraPlan() })

If mv_par03 == 1
   apMsgInfo("A planilha foi gerada => c:\Relato_microsiga\Pedidos_concluidos") 
Else
   apMsgInfo("A planilha foi gerada => c:\Relato_microsiga\Pedidos_faturados")
EndIf      

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	 ³ GeraPlan	³     Gera planilha Excel com as informacoes        ³±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function GeraPlan(lEnd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³                              
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par03 == 1
   If (cArqCSV := FCreate("C:\Relato_Microsiga\Pedidos_concluidos.csv")) == -1
      apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
   Else
      cRegCSV := "PEDIDO;ORÇAMENTO;CATEGORIA;TIPO DE VENDA;CLIENTE;NOTA FISCAL;EMISSÃO;ENTREGA;CONCLUSÃO;ATRASO REAL;ATRASO ENT.PREVISTA;POSIÇÃO;OPS ABERTAS;ACOMPANHAMENTO;EMITENTE"
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   EndIf   
Else
   If (cArqCSV := FCreate("C:\Relato_Microsiga\Pedidos_faturados.csv")) == -1
      apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
   Else
      cRegCSV := ";Pedidos Faturados no Periodo: " + DTOC(mv_par04) + " a " + DTOC(mv_par05)
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)+chr(13)+chr(10)) 
      cRegCSV := "PEDIDO/ITEM;PRODUTO;SERIE;FATURADO EM;VALOR;TIPO;CLIENTE;ENDEREÇO;BAIRRO;CIDADE;UF;PAIS;CEP;VENDEDOR;CONTATO;E_MAIL COMERCIAL;FONE;DT.EMISSAO;DT.CONCLUSAO;DT.PREVISTA"
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
      cRegCSV := ""
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   EndIf   	       	  
EndIf 

//Victor Dessunte
//Início da alteração: Ticket#2017111037000084 — SIX
//AA3->(DbSetOrder(8))
AA3->(DBORDERNICKNAME("AA3_PEDPRO"))                
//Fim da alteração: Ticket#2017111037000084
AA3->(DbGoTop())
SF2->(DbSetOrder(1))
SF2->(DbGoTop())
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+mv_par01))

IF EMPTY(mv_par01)
   SC5->(DBGOTOP())
ENDIF

Do While SC5->(!Eof()) .And. SC5->C5_NUM <= mv_par02

   If lEnd
      @PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
      Exit
   Endif
   
//   If SC5->C5_TIPO <> "N" .Or. SC5->C5_MSTPVEN == "OU"
//   Alterado por José Roberto em 11/01/2013: quando se escolhe Concluido, o tipo de venda deve ser desprezado

   If SC5->C5_TIPO <> "N" .Or. (SC5->C5_MSTPVEN == "OU" .AND. mv_par03 == 2)
      SC5->(DbSkip())
      Loop
   EndIf
   
   If SubStr(SC5->C5_NOTA,1,4) == "XXXX"  // Pedidos eliminados por residuo/cancelado
      SC5->(DbSkip())
      Loop
   EndIf 
   If !Empty(mv_par07) .And. !(SC5->C5_MSCATEG $ RTRIM(mv_par07)) .AND. (SUBSTR(cNumEmp,1,2) $ '01_10')   // Masipack/Fabrima 
      SC5->(DbSkip())
      Loop
   EndIf
   cNF    := ""
   dDtFat := DATE()
   If !Empty(SC5->C5_NOTA)
      If SF2->(DbSeek(xFilial("SF2")+SC5->C5_NOTA+SC5->C5_SERIE))
         dDtFat := SF2->F2_EMISSAO
      Else
         If AA3->(DbSeek(xFilial("AA3")+SC5->C5_NUM))
            dDtFat := AA3->AA3_DTVEND
            If SC5->C5_NOTA == "999999"
               cNF = AA3->AA3_NFVEND
            EndIf   
         Else
            IF !EMPTY(sc5->c5_msconcl)
               dDtFat := sc5->c5_msconcl
            ENDIF   
         EndIf   
      EndIf
      If Empty(SC5->C5_MSCONCL) .Or. (SC5->C5_NOTA  == "999999" .And. cNF <> "")
         RecLock("SC5",.F.)
         If Empty(SC5->C5_MSCONCL)
 //           SC5->C5_MSCONCL := dDtFat
         EndIf   
         If SC5->C5_NOTA  == "999999" .And. cNF <> ""
            SC5->C5_NOTA := cNF
         EndIf   
         SC5->(MsUnlock())
      EndIf
   EndIf
   
   If mv_par03 == 2 .And. Empty(SC5->C5_NOTA)   // Pedidos faturados
      SC5->(DbSkip())
      Loop
   EndIf
   
   If mv_par03 == 1    // Pedidos concluidos
      If Dtos(SC5->C5_MSCONCL) < Dtos(mv_par04) .Or. Dtos(SC5->C5_MSCONCL) > Dtos(mv_par05)
         SC5->(DbSkip())
         Loop
      EndIf
   ElseIf mv_par03 == 2   // Pedidos faturados
      If Dtos(dDtFat) < Dtos(mv_par04) .Or. Dtos(dDtFat) > Dtos(mv_par05)
         SC5->(DbSkip())
         Loop
      EndIf
   EndIf
      
   If mv_par03 == 1
      cTemOP := ""
      SC2->(DbSetOrder(1))
      If SC2->(DbSeek(xFilial("SC2")+SC5->C5_NUM))
         Do While SC2->(!Eof()) .And. SC5->C5_NUM == SC2->C2_NUM
            If Empty(SC2->C2_DATRF)
               cTemOP := "X"
            Endif
            SC2->(DbSkip())
            Loop
         EndDo      
      EndIf
      cAcomPV := ""
      SZM->(DbSetOrder(1))
      If SZM->(DbSeek(xFilial("SZM")+SC5->C5_NUM))
         Do While SZM->(!Eof()) .And. SC5->C5_NUM == SZM->ZM_PEDIDO
            If SZM->ZM_STATUS <> "S"
               If !Alltrim(SZM->ZM_DEPTDES) $ cAcomPV
                  cAcomPV += Alltrim(SZM->ZM_DEPTDES) + ","
               EndIf   
            Endif
            SZM->(DbSkip())
            Loop
         EndDo      
      EndIf
      If SubStr(cAcomPV,Len(cAcomPV),1) == ","
         cAcomPV := SubStr(cAcomPV,1,Len(cAcomPV)-1)
      EndIf   
      nAtraso1 := 0
      nAtraso2 := 0
      nAtraso1 := SC5->C5_MSCONCL - SC5->C5_MSDTENT
      If nAtraso1 < 0
         nAtraso1 := 0
      EndIf
      If !Empty(SC5->C5_MSDTPEN)
         nAtraso2 := SC5->C5_MSCONCL - SC5->C5_MSDTPEN
      Else      
         nAtraso2 := SC5->C5_MSCONCL - SC5->C5_MSDTENT
      EndIf
      If nAtraso2 < 0
         nAtraso2 := 0 
      EndIf
   EndIf
   
   cCliente := ""
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
      If mv_par03 == 1
         cCliente := SA1->A1_NREDUZ
      ElseIf mv_par03 == 2
         cCliente := SC5->C5_CLIENTE + "-" + SA1->A1_NOME
         cPais := ""
         SYA->(dbSetOrder(1))
	     If SYA->(dbSeek(xFilial("SYA")+SA1->A1_PAIS))
	        cPais := SYA->YA_DESCR 
	     EndIf         
      EndIf
   EndIf
   
   cVend    := ""
   SA3->(DbSetOrder(1))
   If SA3->(DbSeek(xFilial("SA3")+SC5->C5_VEND1))
      cVend := SA3->A3_NREDUZ
   EndIf
   
   nValor := SC5->C5_MSVLPED
    
   If mv_par03 == 1
      cRegCSV := SC5->C5_NUM+";_"+SC5->C5_ORCAM+";_"+SC5->C5_MSCATEG+";"+SC5->C5_MSTPVEN+";"+cCliente+";"+SC5->C5_NOTA+";"+DTOC(SC5->C5_EMISSAO)+";"
      cRegCSV += DTOC(dDtEntrega)+";"+DTOC(SC5->C5_MSCONCL)+";"+Str(nAtraso1,5,0)+";"+Str(nAtraso2,5,0)+";"+SC5->C5_MSPOSIC+";"+cTemOP+";"+cAcomPV+";"+SC5->C5_MSNOUSU+";"
      cRegCSV += cVend+";"+IF(EMPTY(SC5->C5_MSDTPEN),DTOC(SC5->C5_MSDTENT),DTOC(SC5->C5_MSDTPEN))
      FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))	 
   ElseIf mv_par03 == 2
      SC6->(DbSetOrder(1))
      If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
         Do While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
            If !Empty(SC6->C6_NOTA)
               If SC6->C6_VALOR > 1 .And. SC5->C5_MSVLPED == 0
                  nValor += SC6->C6_VALOR
               EndIf   
            EndIf
            nValor := 0    // Para exibir valor acumulado acima nesta planilha sera necessario autorizacao do Comercial
            lGrava := .T.
            //Início da alteração: Ticket#2017111037000084 — SIX
            //AA3->(DbSetOrder(9))
            AA3->(DBORDERNICKNAME("AA3_PROPED"))
            //Fim da alteração: Ticket#2017111037000084 — SIX
            AA3->(DbGoTop())
            If AA3->(DbSeek(xFilial("AA3")+SC6->C6_PRODUTO+SC6->C6_NUM))
               cSerie := AA3->AA3_NUMSER
            Else
               cSerie := ""   
               If mv_par06 == 1
                 lGrava := .F. 
               EndIf
            EndIf
            If lGrava   
               cRegCSV := SC6->C6_NUM+"/"+SC6->C6_ITEM+";"+Alltrim(SC6->C6_PRODUTO)+" - "+Alltrim(SC6->C6_DESCRI)+";"+cSerie+";"+DTOC(dDtFat)+";"+Str(nValor,10,2)+";"+SC5->C5_MSTPVEN+";"+cCliente+";"
               cRegCSV += SA1->A1_END+";"+SA1->A1_BAIRRO+";"+SA1->A1_MUN+";"+SA1->A1_EST+";"+cPais+";"+SA1->A1_CEP+";"+cVend+";"+SA1->A1_CONTATO+";"+SA1->A1_EMAIL2+";"+SA1->A1_TEL+";"
               cRegCSV += DTOC(SC5->C5_EMISSAO)+";"+DTOC(SC5->C5_MSCONCL)+";"+IF(EMPTY(SC5->C5_MSDTPEN),DTOC(SC5->C5_MSDTENT),DTOC(SC5->C5_MSDTPEN))
               FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
            EndIf
            SC6->(DbSkip())
            Loop
         EndDo      
      EndIf   
   EndIf        
   SC5->(DbSkip())
   Loop
EndDo

FClose(cArqCSV)  

dbCommitAll()

MS_FLUSH()

Return
