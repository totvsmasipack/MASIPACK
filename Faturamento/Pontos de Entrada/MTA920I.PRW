#include "rwmake.ch" 
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � MTA920I  篈utor  �   Cida                      � 14/06/2010罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.   Atualiza Estoque e Mov. Estoque (SZ8) NF de Saida (Manual)      北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/ 

User Function MTA920I() 

Private AtuEstoque := ""
Private cDescTes   := ""

If SubStr(cNumEmp,1,2) == "15"
   Return
EndIf 

SF4->(dbSetOrder(1))
SB1->(DbSetOrder(1))
DbSelectArea("SD2")
SD2->(DbSetOrder(3))
If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC)) 
   Do While ! SD2->(Eof()) .And. SD2->D2_DOC == SF2->F2_DOC 
      If SD2->D2_MSSZ8 <> "X"
         AtuEstoque := "N"      //   atualizar pela Tes.
         cDescTes   := ""
         If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
            AtuEstoque := SF4->F4_ESTOQUE
            cDescTes := SF4->F4_TEXTO
         Else
            ApMsgStop("TES n鉶 encontrada, Avise a Informatica: " + SD2->D2_DOC+SD2->D2_TES)      
         EndIf
         RecLock("SD2",.F.)
         SD2->D2_MSSZ8 := "X"
         SD2->(MsUnLock())
      EndIf
      SD2->(DbSkip())  
   EndDo
EndIf 
Return