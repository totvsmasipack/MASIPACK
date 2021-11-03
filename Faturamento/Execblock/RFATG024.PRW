#include "rwmake.ch"    
#Include "RWMAKE.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATG024 ³ Autor ³ Cecilia               ³ Data ³ 21/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gatilho q verifica o pedido na Masipack para checar se     ³±±
±±³          ³ encontra em garantia                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATG024()    

cNum      := M->C5_NUM
_fRet     := M->C5_MSLINK 
_Garantia := ctod("  /  /  ")  
_Days     := ctod("  /  /  ")
nDays     := 1  
cNota     := ""

// Gatilho da Masiteck   
If !Empty(_fRet)    

   //Victor Dessunte
   //início da alteração: Ticket#2017111037000084 — SIX 
   _Garantia := Posicione("AA3",U_MSNICK('AA3','AA3_PEDPRO'),xFilial("AA3")+_fRet,"AA3_DTGAR")
   _Days:= DaySum( _Garantia, nDays ) 
   cNota := Posicione("AA3",U_MSNICK('AA3','AA3_PEDPRO'),xFilial("AA3")+_fRet,"AA3_NFVEND")
   //fim da alteração: Ticket#2017111037000084
   If Dtos(_Garantia) > Dtos(dDatabase)
           MSGBOX("NOTA FISCAL - " + cNota + "  REFERENTE AO PEDIDO -  " +_fRet+;
                  "    ENCONTRA-SE ATE   "+Dtoc(_Garantia)+"  EM GARANTIA","ATENCAO","ALERT")
   Endif
Endif
Return(_fRet)
