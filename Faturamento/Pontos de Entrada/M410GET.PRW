
/*
�����������������������������������������������������������������������������
���Programa  � M410GET  �Autor  �  Cida                     � 18/06/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     | Gera Array com os Conjuntos do Pedidos de Venda            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Masipack                                         ���
�����������������������������������������������������������������������������
*/
#include "rwmake.ch" 

User Function M410GET()

Local I

IF SUBSTR(cNumEmp,1,2) <> "15"
   _aItensPV := {}
   _aItensGE := {} // Ser� usado para deixar a data do PCP em branco na inclus�o de um novo Item no PV
   
   
   If SubStr(cNumEmp,1,2) $ "01_10_11"
      For I := 1 to Len(aCols)
          nPosUM   := Ascan(aHeader, { |x| Upper(Alltrim(x[2])) == "C6_UM"})
          nPosProd := Ascan(aHeader, { |x| Upper(Alltrim(x[2])) == "C6_PRODUTO"})    
          If Altera 
             If Alltrim(aCols[I][nPosUM]) == "CJ"
                AADD(_aItensPV,aCols[I][nPosProd])
             EndIf
          EndIf   
      Next I    
   EndIf 
ENDIF   
Return()
