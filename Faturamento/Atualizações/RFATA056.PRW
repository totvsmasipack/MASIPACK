#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RFATA056 ³ Autor ³ Aparecida de F.Stevanato³Data ³ 01.09.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Volta Informações do DAN - emitido indevidamente   	   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function RFATA056()

Private _lAtu     := .T.

Do While _lAtu
	
   If !Pergunte("FATA56",.T.)
      _lAtu := .F.
	  Return
   EndIf 
	
   If Empty(mv_par01) .Or. Empty(mv_par02)
      apmsgStop("Informe Numero da Nota Fiscal e Serie")
   Else
      If apMsgYESNO("*** ATENÇÃO, Confirma Alteração do DAN ***")   
      
         SF2->(dbSetOrder(1))
         SF2->(DbGoTop())
 
         If !Empty(mv_par01)
            If SF2->(DbSeek(xFilial("SF2")+mv_par01+mv_par02))
               RecLock("SF2",.F.)
               SF2->F2_VEICUL1 := ""
               SF2->F2_MSCOLET := ""
               SF2->F2_MSDTCOL := CTOD("")
               SF2->F2_MSMOTOR := ""
               SF2->F2_MSOBDAN := ""
               SF2->F2_MSCANH  := ""
               SF2->F2_MSDAN   := ""
               SF2->F2_MSORDEM := ""
               SF2->F2_MSDANDT := CTOD("")
               SF2->F2_MSDANHR := ""
               SF2->F2_MSDANUS := ""
               SF2->F2_MSRETDA := CTOD("") 
               SF2->(MsUnlock())
               apmsgInfo("OK - Limpou Informações de DAN")
	        Else
	           apmsgStop("Nota Fiscal/Serie não encontrada: "+ mv_par01)   
	        EndIf
         EndIf   	   
      EndIf
   EndIf      
EndDo

Return