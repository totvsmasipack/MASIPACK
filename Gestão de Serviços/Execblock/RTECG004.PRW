#Include "Rwmake.ch"
#Include "Topconn.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RTECG004  ºAutor  ³Aparecida de F.StevanatoºData ³ 06/05/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para atualizar Data de Garantia na Base Instalada   º±±
±±º          ³   apenas quando a garantia for pelo Startup                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function RTECG004()

Private nMes    := 0
Private nAno    := 0
Private nQtdAno := 0

If M->AA3_DTINST <> AA3->AA3_DTINST
   SC5->(DbSetOrder(1))
   If DbSeek(xFilial()+M->AA3_MSPED) 
      If SC5->C5_MSINIGA == "S"
         nMes    := Month(M->AA3_DTINST)
         nAno    := Year(M->AA3_DTINST)
         nQtdAno := Int(SC5->C5_MSGARANT / 12)
         nMes    := nMes + SC5->C5_MSGARANT - (nQtdAno * 12)
         If nMes > 12
            nMes := nMes - 12
            nQtdAno += 1
         EndIf   
         nAno    += nQtdAno
         RecLock("AA3",.F.)
         M->AA3_DTGAR  := CTOD(Str(Day(M->AA3_DTINST)) + "/" + Str(nMes) + "/" + Str(nAno))
         AA3->(MsUnLock()) 
      EndIf
   EndIf   
EndIf

Return(.T.)
