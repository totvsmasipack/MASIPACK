#include "rwmake.ch"    
#Include "RWMAKE.ch" 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RFATG024 � Autor � Cecilia               � Data � 21/01/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gatilho q verifica o pedido na Masipack para checar se     ���
���          � encontra em garantia                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Masipack                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
   //in�cio da altera��o: Ticket#2017111037000084 � SIX 
   _Garantia := Posicione("AA3",U_MSNICK('AA3','AA3_PEDPRO'),xFilial("AA3")+_fRet,"AA3_DTGAR")
   _Days:= DaySum( _Garantia, nDays ) 
   cNota := Posicione("AA3",U_MSNICK('AA3','AA3_PEDPRO'),xFilial("AA3")+_fRet,"AA3_NFVEND")
   //fim da altera��o: Ticket#2017111037000084
   If Dtos(_Garantia) > Dtos(dDatabase)
           MSGBOX("NOTA FISCAL - " + cNota + "  REFERENTE AO PEDIDO -  " +_fRet+;
                  "    ENCONTRA-SE ATE   "+Dtoc(_Garantia)+"  EM GARANTIA","ATENCAO","ALERT")
   Endif
Endif
Return(_fRet)
