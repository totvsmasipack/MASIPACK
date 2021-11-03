#Include "Rwmake.ch"
#Include "Topconn.ch"
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPA019³ Autor ³ Aparecida de F.Stevanato³Data ³ 06.07.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza Campo G1_MSATUOP dos Componentes na Estrutura     ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/

User Function RPCPA019()

Private _cUsuario := RetCodUsr()
Private _aUsuario := {}
Private _cDeptoUsu := ""  
Private cUsuSenha := ""
Private nLastKey  := 0
Private fRet      := .T. 

SET DELETED ON

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   cUsuSenha := UsrRetName(_cUsuario)
   cUsuSenha := Upper(SubStr(cUsuSenha,1,6))
   cUsuSenha := Alltrim(cUsuSenha)
   _aUsuario := PswRet()                                                
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

If !("INFORMATICA" $ _cDeptoUsu .Or. "PCP" $ _cDeptoUsu .Or. "DOCUMENTA" $ _cDeptoUsu)
   apmsgStop("Usuário sem permissão para esta Rotina")
   Return
EndIf   

cEstru  := Space(15)
cComp   := Space(15)
fRet    := .F.
_lOutro := .T. 

@ 089,185 To 400,550 Dialog _oDlg1 Title OemToAnsi("Planejamento e Controle da Produção")
@ 009,011 To 035,165
@ 030,011 To 135,165
@ 015,024 Say OemToAnsi("Esta Rotina Atualiza Estrutura X OPs") Size 151,010
@ 050,025 Say OemToAnsi("Codigo da Estrutura.............:")      Size 080,008 
@ 070,025 Say OemToAnsi("Codigo do Componente....:")            Size 080,008
@ 050,090 Get cEstru F3 "SB1"                                   Size 050,008         
@ 070,090 Get cComp F3 "SB1" Valid ValidaSG1()                          Size 050,008 
@ 100,090 BmpButton Type 1 Action Processa( { || Atualiza() } )
@ 100,125 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1 Centered  
                                                                                           

SET DELETED ON

Return

Static Function ValidaSG1()  
   SET DELETED OFF
   fRet := .F.
   If Alltrim(cEstru) <> ""
      SG1->(dbSetOrder(1))
      If SG1->(dbSeek(xFilial("SG1")+cEstru+cComp))
         fRet := .T.
      Else   
         ApMsgStop("Estrutura/Componente não cadastrado !!!!")
      EndIf
   EndIf   
Return fRet

Static Function Atualiza()
   If fRet 
      If !apmsgYesNo("Confirma Alteração?")
         cEstru := Space(15)
         cComp  := Space(15) 
         Return
      EndIf
      Do While SG1->(!Eof()) .And. SG1->G1_COD+SG1->G1_COMP == cEstru+cComp
         If SG1->G1_MSATUOP == "S"
            RecLock("SG1",.F.) 
            SG1->G1_MSATUOP := "N"
            SG1->(MsUnlock())
         EndIf
         SG1->(DbSkip())
      EndDo    
   EndIf
   cEstru := Space(15)
   cComp  := Space(15) 
Return