#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA010E �Autor �Aparecida de F.Stevanato Data � 13/07/2006 ���
�������������������������������������������������������������������������͹��
���Desc.     �ATUALIZA DATA DE EXCLUS�O e Exclui SZB(Descricao prolongada)���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Masipack                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA010E()  

   If cEmpAnt $ "01" 
      
      SB1->B1_DATAC  := Date()
      
      // Verifica Descri��o Prolongada da NF   
      dbSelectArea("SZB")
      SZB->(DbSetOrder(1))
      SZB->(DBSeek(xFilial("SZB")+SB1->B1_COD))
      
      If SZB->(FOUND()) .And. RecLock("SZB",.F.)
         SZB->(DBDELETE())
         SZB->(MsUnLock())
      EndIf
   
   EndIf
   
Return
