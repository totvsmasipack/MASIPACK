#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �MSD2520   �Autor  �Aparecida F.Stevanato � Data �  06/12/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Retorna Separa��o p/Almoxarifado - Cancelamento NFiscal   ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSD2520()                                                                   
 
//Alert("MSD2520 "+SD2->D2_DOC+"/"+ SD2->D2_SERIE) 

If SubStr(cNumEmp,1,2) == "10"     // Apenas para Fabrima
   SC6->(DbSetOrder(1)) 
   If SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)) 
      If !Empty(SC6->C6_MSSEP)         // Se este campo estiver em branco n�o foi enviado para o Almoxariado
         RecLock("SC6",.F.)
         SC6->C6_MSSEP := "S"
         SC6->(MsUnLock())
      EndIf   
   EndIf   
EndIf   

Return