#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MT416FIM    ºAutor  ³                           05/04/2007 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.       Efetivação do Orçamento  (Atualiza Itens do PV)             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function MT416FIM()

If Empty(SC5->C5_NUM)
   Return
EndIf

If SubStr(cNumEmp,1,2) $ "01_10"            // apenas para empresa Masipack 
   //Atualiza Status do orçamento para vendido
   If SCJ->(DbSeek(xFilial("SCJ")+SCJ->CJ_NUM))   
      RecLock("SCJ",.F.)
      SCJ->CJ_MSSTAT := "V"
      SCJ->(MsUnlock())
   EndIf   
EndIf

Return()  