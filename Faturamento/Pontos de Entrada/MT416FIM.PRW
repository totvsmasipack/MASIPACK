#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � MT416FIM    篈utor  �                           05/04/2007 罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.       Efetiva玢o do Or鏰mento  (Atualiza Itens do PV)             北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function MT416FIM()

If Empty(SC5->C5_NUM)
   Return
EndIf

If SubStr(cNumEmp,1,2) $ "01_10"            // apenas para empresa Masipack 
   //Atualiza Status do or鏰mento para vendido
   If SCJ->(DbSeek(xFilial("SCJ")+SCJ->CJ_NUM))   
      RecLock("SCJ",.F.)
      SCJ->CJ_MSSTAT := "V"
      SCJ->(MsUnlock())
   EndIf   
EndIf

Return()  