#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RQNCA001  �Autor  �Aparecida de F.Stevanato  Data �27/07/10 ���
�������������������������������������������������������������������������͹��
���          | Recupera Campos Memo da NConformidade - tabela SYP         ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                        
*/                                                                                                          
User Function RQNCA001()

Private nAlt := 0 

Private cPerg    := "QNCA01" + Space(4) 

If !Pergunte(cPerg,.T.)
   Return
EndIf 

If Empty(mv_par01)
   apMsgAlert("Por Favor, Informe o Numero da n�o Conformidade")
   If !Pergunte(cPerg,.T.)
      Return 
   EndIf   
EndIf

Set Delete Off

SYP->(DbSetOrder(1)) 
QI2->(DbSetOrder(2)) 

If QI2->(DbSeek(xFilial()+mv_par01))
   If !QI2->(Deleted())
      If !Empty(QI2->QI2_COMEN)
         If SYP->(DbSeek(xFilial()+QI2->QI2_COMEN))
            Do While SYP->(!EOf()) .And. QI2->QI2_COMEN == SYP->YP_CHAVE
               If SYP->(Deleted())
                  RecLock("SYP",.F.)
                  SYP->(DbReCall())
                  SYP->(MsUnlock())
                  nAlt++
                EndIf
               SYP->(DbSkip())
             EndDo      
         EndIf
      EndIf
      If !Empty(QI2->QI2_DDETA)
         If SYP->(DbSeek(xFilial()+QI2->QI2_DDETA))
            Do While SYP->(!EOf()) .And. QI2->QI2_DDETA == SYP->YP_CHAVE
               If SYP->(Deleted())
                  RecLock("SYP",.F.)
                  SYP->(DbReCall())
                  SYP->(MsUnlock())
                  nAlt++
                EndIf
                SYP->(DbSkip())
             EndDo      
         EndIf
      EndIf   
      If !Empty(QI2->QI2_DISPOS)
         If SYP->(DbSeek(xFilial()+QI2->QI2_DISPOS))
            Do While SYP->(!EOf()) .And. QI2->QI2_DISPOS == SYP->YP_CHAVE
               If SYP->(Deleted())
                  RecLock("SYP",.F.)
                  SYP->(DbReCall())
                  SYP->(MsUnlock())
                  nAlt++
                EndIf
                SYP->(DbSkip())
             EndDo      
         EndIf
      EndIf      
   EndIf
Else
   apMsgStop("FNC n�o cadastrada - Verifique")    
EndIf
   
If nAlt > 0
   apMsgInfo("OK - Registros recuperados: " + Str(nAlt,6))
Else
   apMsgInfo("N�o houve registros recuperados - Verifique")   
EndIf

Set Delete On

Return