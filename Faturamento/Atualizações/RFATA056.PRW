#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
���Funcao	 � RFATA056 � Autor � Aparecida de F.Stevanato�Data � 01.09.11���
�������������������������������������������������������������������������Ĵ��
���Descricao � Volta Informa��es do DAN - emitido indevidamente   	   	  ���
��������������������������������������������������������������������������ٱ�
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
      If apMsgYESNO("*** ATEN��O, Confirma Altera��o do DAN ***")   
      
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
               apmsgInfo("OK - Limpou Informa��es de DAN")
	        Else
	           apmsgStop("Nota Fiscal/Serie n�o encontrada: "+ mv_par01)   
	        EndIf
         EndIf   	   
      EndIf
   EndIf      
EndDo

Return