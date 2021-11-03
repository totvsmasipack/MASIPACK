#include "protheus.ch"
#Include "Topconn.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	 ³ RPCPG003  ³Autor ³ Aparecida de F.Stevanato ³Data ³ 17.09.08 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ   ÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Corrige Cadastro de operacoes Produto x Recurso            ³±± 
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 

#Include "Rwmake.ch"

User Function RPCPG003()

PRIVATE cString     := ""
PRIVATE nLastKey    := 0
PRIVATE cProdAnt    := ""
PRIVATE nErrProd    := 0
PRIVATE I           := 0
PRIVATE aProdutos   := {}
PRIVATE aRecurso    := {}
PRIVATE cArqCSVU    := "C:\Relato_Microsiga\Correcao_SG2_Usinagem.csv"
PRIVATE cArqCSVP    := "C:\Relato_Microsiga\Correcao_SG2_PCP.csv"
PRIVATE cRegCSV     := ""

If nLastKey==27
	Set Filter to
	Return
Endif

MsgRun("Aguarde, Corrigindo!!!!",, {|| CorrigeSG2()}) // Corrige o arquivo de operacoes 

Return

Static Function CorrigeSG2()

If (cArqCSVU := FCreate("C:\Relato_Microsiga\Correcao_SG2_Usinagem.csv")) == -1
   apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
   cRegCSV := "PRODUTO;RECURSO;"
   FWrite(cArqCSVU,cRegCSV+chr(13)+chr(10))	  
EndIf

If (cArqCSVP := FCreate("C:\Relato_Microsiga\Correcao_SG2_PCP.csv")) == -1
   apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
   cRegCSV := "PRODUTO;RECURSO;"
   FWrite(cArqCSVP,cRegCSV+chr(13)+chr(10))	  
EndIf  

SG2->(DbSetOrder(3))
Do While SG2->(!EOF())
   If SG2->G2_PRODUTO <> cProdAnt
      aRecurso := {}
      cProdAnt := SG2->G2_PRODUTO
   EndIf 
   If SubStr(Alltrim(SG2->G2_RECURSO),1,1) $ "A_L_P" 
      If ASCAN(aRecurso,{|x| x[1] == SG2->G2_RECURSO}) == 0
         AADD(aRecurso,{SG2->G2_RECURSO,SG2->G2_OPERAC})
      Else
         cRegCSV := "_"+SG2->G2_PRODUTO+";"+SG2->G2_RECURSO+";"
         FWrite(cArqCSVP,cRegCSV+chr(13)+chr(10))
         nErrProd++
         RecLock("SG2",.F.)
         SG2->(DBDelete())
         SG2->(MsUnLock())
      EndIf                       
   Else
      If ASCAN(aRecurso,{|x| x[1]+x[2] == SG2->G2_RECURSO+SG2->G2_OPERAC}) == 0
         AADD(aRecurso,{SG2->G2_RECURSO,SG2->G2_OPERAC})
      Else
         cRegCSV := "_"+SG2->G2_PRODUTO+";"+SG2->G2_RECURSO+";"
         If SubStr(SG2->G2_RECURSO,1,1) == "U"      
            FWrite(cArqCSVU,cRegCSV+chr(13)+chr(10))
         Else     
            FWrite(cArqCSVP,cRegCSV+chr(13)+chr(10))
         EndIf         
         nErrProd++
         RecLock("SG2",.F.)
         SG2->(DBDelete())
         SG2->(MsUnLock())     
      EndIf   
   EndIf     
   SG2->(DbSkip())
   Loop
EndDo 

FClose(cArqCSVU)
FClose(cArqCSVP)    

If nErrProd > 0 
   apmsgAlert("Produtos com Operações duplicadas => " + Str(nErrProd)) 
Else
   apmsgStop("Operações OK - não há produtos com operações duplicadas!!!")   
EndIf

dbCommitAll()

Return