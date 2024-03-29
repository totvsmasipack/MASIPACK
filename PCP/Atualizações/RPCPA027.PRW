/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �RPCPA027  �Autor  �Aparecida F. Stevanato�    Data 03/03/11 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica Status e Observa��es - SZU                        ���
�����������������������������������������������������������������������������
*/

User Function RPCPA027()                                                                   

Private lRet := .T.
Private _cUsuSenha := UsrRetName(RetCodUsr())

If Altera
   If SZU->ZU_STATUS <> M->ZU_STATUS .And. M->ZU_STATUS <> "C"
      ApMsgInfo("Altera��o de Status Invalida - Atualizado no Programa *") 
      lRet := .F.
   EndIf
   If SZU->ZU_STATUS <> M->ZU_STATUS .And. (SZU->ZU_STATUS == "G" .Or. SZU->ZU_STATUS == "R")
      ApMsgInfo("Altera��o de Status Invalida - Atualizado no Programa **") 
      lRet := .F.
   EndIf
   If SZU->ZU_OBS <> M->ZU_OBS .And. (SZU->ZU_STATUS == "G" .Or. SZU->ZU_STATUS == "R")
      ApMsgInfo("N�o � possivel alterar Observa��es para este Status") 
      lRet := .F.
   EndIf
   If SZU->ZU_OBS <> M->ZU_OBS .And. SZU->ZU_OBS $ "DATA DA NECESSIDADE"
      ApMsgInfo("N�o � possivel alterar este Campo de Observa��es") 
      lRet := .F.
   EndIf 
   If _lRet
      M->ZU_DTGERA := Date()
      M->ZU_USUGERA := _cUsuSenha
   EndIf
EndIf      

Return lRet