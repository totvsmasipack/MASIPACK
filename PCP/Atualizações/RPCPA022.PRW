#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPA022³ Autor ³ Aparecida de F.Stevanato³Data ³ 24.11.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Reabre Ordem de Producao - Uso exclusivo do PCP         	  ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/

User Function RPCPA022()

Private _cUsuario := RetCodUsr()
Private _aUsuario := {}
Private _cDeptoUsu := ""
Private cNomeUsu  := ""    
Private nLastKey  := 0

_cMsg := "Este programa customizado interfere no valor financeiro do estoque, gerando divergências contábeis no fechamento mensal. " + CRLF
_cMsg += "Consulte TI para que a rotina padrão seja usada, dessa forma a informação será tratada de maneira padrão (e correta) pelo sistema." + CRLF
_cMsg += "Obrigado."

Alert(_cMsg)

Return


PswOrder(1)
If PswSeek(_cUsuario)
   _aUsuario := PswRet()
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
   cNomeUsu  := Alltrim(UsrRetName(_cUsuario))
EndIf 

If !("INFORMATICA" $ _cDeptoUsu .Or. "PCP" $ _cDeptoUsu)
   apmsgINFO("Usuário sem permissão para Executar esta Rotina")
   Return
EndIf   

cNumOP := Space(11)
aFalta := {"NAO","SIM"}
 cFalta := Space(3)
fRet   := .F.

SC2->(ORDSETFOCUS(1))
SC2->(DBGOTOP()) 
 
@ 089,155 To 450,550 Dialog _oDlg1 Title OemToAnsi("Planejamento e Controle da Produção")
@ 009,011 To 035,188
@ 030,011 To 150,188
@ 015,024 Say OemToAnsi("Esta rotina Reabre Ordem de Produção")     Size 151,010
@ 055,030 Say OemToAnsi("Numero da OP..........................:")  Size 080,008 
@ 077,030 Say OemToAnsi("Envia Itens para Lista de Falta?")         Size 150,008
@ 055,110 Get cNumOP F3 "SC2"                                       Size 050,008
@ 075,110 ComboBox cFalta Items aFalta                              Size 035,010  object oFalta        
@ 125,110 BmpButton Type 1 Action Processa( { || Atualiza() } )
@ 125,145 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1 Centered

Return

Static Function Atualiza()
   If SC2->(dbSeek(xFilial("SC2")+cNumOP))
      IF EMPTY(SC2->C2_DATRF)
         apmsgStop("OP ja esta aberta. Nao e necessario reabri-la")
         Return
      Else
         If !Empty(SC2->C2_MSPED)
            SC5->(DbSetOrder(1))
            If SC5->(DbSeek(xFilial("SC5")+Alltrim(SC2->C2_MSPED)))
               If !Empty(SC5->C5_NOTA)
                  apmsgStop("Já houve faturamento para esta OP - Reabertura invalida")
                  Return
               EndIf    
            EndIf
         EndIf
      EndIf
      If SC2->C2_MSLISTA == "N"
         apmsgStop("Nao é lista de separação!")
         Return
      Else                                                                            
         RecLock("SC2",.F.)
         SC2->C2_QUJE   := 0
         SC2->C2_DATRF  := CTOD(SPACE(8))
         SC2->C2_DATAJI := Date()
         //If cFalta == "NAO"
         //   SC2->C2_MSPOSIC := ""
         //EndIf
         SC2->C2_MSPOSIC := "OP Reaberta em " + DTOC(Date()) + " Por " + cNomeUsu
         SC2->(MsUnlock())
         apmsgAlert("Ok - Ordem de Produção Reaberta")
      EndIf 
   Else
      apmsgStop("Ordem de Produção não encontrada")   
   EndIf   
   cNumOP  := Space(11)
   cFalta  := Space(3)
   MS_FLUSH()  
Return