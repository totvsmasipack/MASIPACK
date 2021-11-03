#include "topconn.ch"
#include "tbiconn.ch"
#Include "Rwmake.ch"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RESTA007³ Autor ³ Aparecida de F.Stevanato³Data ³ 25.04.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Função para alterar local do produto (Estoque) 	      	  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/


User Function RESTA007() 

Private fRet    := .T.
Private nTam    := 0
Private cLocais := "" 
Private cLocal  := ""
Private nEmpVD  := 0
Private nEstq   := 0

cProd    := Space(15)
cLocAtu  := Space(8) 
cLocNovo := Space(8)

SX5->(DbGotop())
If SX5->(DbSeek(xFilial("SX5")+"ZD"+"LOCAIS")) // Contem todos os locais possiveis de armazenamento 
   cLocais := RTRIM(X5DESCRI())
EndIf


@ 089,185 To 350,500 Dialog _oDlg1 Title OemToAnsi("Altera Local do Produto")
@ 009,011 To 035,148
@ 030,011 To 120,148
@ 015,024 Say OemToAnsi("Esta rotina Altera Local do Produto")    Size 151,010
@ 050,024 Say OemToAnsi("Produto..............: ")                Size 150,006
@ 065,024 Say OemToAnsi("Local Atual.......: ") 			   	  Size 055,006
@ 080,024 Say OemToAnsi("Novo Local.......: ") 			   	   	  Size 055,006 
@ 050,064 Get cProd  Valid ValidaProd() F3 "SB1"                  Size 065,008 
@ 065,064 Get cLocAtu  Valid ValLocal()                           Size 040,008
@ 080,064 Get cLocNovo Valid VerLocal()                           Size 040,008 object oLocNovo
@ 100,070 BmpButton Type 1 Action Processa( { || AtuLocal() } )
@ 100,110 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1 Centered

Return

Static Function ValLocal()
    SB1->(DbSetOrder(1))
    SB1->(DbSeek(xFilial("SB1")+cProd))
    If Alltrim(SB1->B1_LOCAL) <> Alltrim(cLocAtu)
       ApMsgInfo("Este campo não pode ser alterado !!!") 
       cLocAtu := Alltrim(SB1->B1_LOCAL)
    EndIf   
    oLocNovo:SetFocus() 
Return

Static Function ValidaProd()
    fRet := .T.
    SB1->(DbSetOrder(1))
    If !SB1->(DbSeek(xFilial("SB1")+cProd))
       ApMsgInfo("Produto nao cadastrado !!!")
       fRet := .F.
    Else
       cLocAtu := Alltrim(SB1->B1_LOCAL)
       oLocNovo:SetFocus() 
    EndIf  
Return fRet

Static Function VerLocal()
   fRet   := .T.
   cLocal := Upper(Alltrim(cLocNovo))
   nTam   := Len(cLocal)
   If ! SubStr(cLocal,1,1) $ cLocais
      ApMsgAlert("Local inválido")
      fRet := .F.
   Else
      If nTam <> 1 .And. nTam <> 4 .And. nTam <> 7 .And. nTam <> 8
         ApMsgAlert("Local inválido")
         fRet := .F.
      Else   
         If SubStr(cLocal,1,1) == "1" .And. nTam <> 7
            ApMsgAlert("Local inválido para o VS")
            fRet := .F.
         Else
            If cLocAtu == cLocal
               ApMsgAlert("Produto já está no Local informado")
               fRet := .F.
            Else
               If SB1->B1_UM == "CJ" .And. !(SubStr(cLocal,1,1) == "M" .Or. SubStr(cLocal,1,1) == "D")
                  ApMsgAlert("Local Invalido para Conjunto (M ou D)")
                  fRet := .F.
               EndIf
            EndIf   
         EndIf
      EndIf   
   EndIf   
   
   If fRet .And. Len(cLocal) >= 7 .And. (SubStr(cLocal,1,1) == "4" .OR. SubStr(cLocal,1,1) == "1")
      SB1->(DbSetOrder(16))
      SB2->(DbSetOrder(1))
      If SB1->(DbSeek(xFilial("SB1")+cLocal))
         If Substr(SB1->B1_LOCAL,1,1) = "4"
            If (SubStr(SB1->B1_LOCAL,2,3) >= "001" .And. SubStr(SB1->B1_LOCAL,2,3) <= "999") // local 4 aceita varios produtos no mesmo local
               fRet := .T.
            Else   
               Do While Alltrim(SB1->B1_LOCAL) == cLocal .AND. !SB1->(EOF())
                  nEmpVD := 0
                  If SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+"01"))
                     nEmpVD := SB2->B2_RESERVA
	             nEstq  := SB2->B2_QATU
                  EndIf    
                  If nEstq == 0
                     ApMsgInfo("Local sendo Reutilizado Produto => "+SB1->B1_COD+ " " + SB1->B1_DESC) 
                     RecLock("SB1",.F.)
                     SB1->B1_LOCAL  :=  ""                                                   
                     SB1->(MsUnLock())
                  Else  // Ver com Jose Roberto
                     If SubStr(cNumEmp,1,2) == "01"        // Provisorio até organizar o Almoxarifado da Fabrima
                        fRet := .F. 
                        ApMsgInfo("Local sendo utilizado para o Produto => "+SB1->B1_COD+ " " + SB1->B1_DESC)
                     EndIf      
                  EndIf
                  SB1->(DbSkip())
               EndDo        
            EndIf   
         Else
            If SubStr(cNumEmp,1,2) == "01"        // Provisorio até organizar o Almoxarifado da Fabrima
               fRet := .F. 
               ApMsgInfo("Local sendo utilizado para o Produto => "+SB1->B1_COD+ " " + SB1->B1_DESC)
            EndIf   
         EndIf   
      EndIf
   EndIf
Return

**************************
Static Function AtuLocal()
**************************
If fRet               
   If apMsgYesNo("Confirma Alteração do Local ?")
      SB1->(DbSetOrder(1))
      SB1->(DbSeek(xFilial("SB1")+Alltrim(cProd)))
      RecLock("SB1",.F.)                                                  
      SB1->B1_LOCAL := cLocal
      SB1->(MsUnLock())
   EndIf
   cProd    := Space(15) 
   cLocAtu  := Space(8) 
   cLocNovo := Space(8) 
Else
   cLocNovo := Space(8)
EndIf   
Return
