/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RPCPA027  ºAutor  ³Aparecida F. Stevanatoº    Data 03/03/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica Status e Observações - SZU                        º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCPA027()                                                                   

Private lRet := .T.
Private _cUsuSenha := UsrRetName(RetCodUsr())

If Altera
   If SZU->ZU_STATUS <> M->ZU_STATUS .And. M->ZU_STATUS <> "C"
      ApMsgInfo("Alteração de Status Invalida - Atualizado no Programa *") 
      lRet := .F.
   EndIf
   If SZU->ZU_STATUS <> M->ZU_STATUS .And. (SZU->ZU_STATUS == "G" .Or. SZU->ZU_STATUS == "R")
      ApMsgInfo("Alteração de Status Invalida - Atualizado no Programa **") 
      lRet := .F.
   EndIf
   If SZU->ZU_OBS <> M->ZU_OBS .And. (SZU->ZU_STATUS == "G" .Or. SZU->ZU_STATUS == "R")
      ApMsgInfo("Não é possivel alterar Observações para este Status") 
      lRet := .F.
   EndIf
   If SZU->ZU_OBS <> M->ZU_OBS .And. SZU->ZU_OBS $ "DATA DA NECESSIDADE"
      ApMsgInfo("Não é possivel alterar este Campo de Observações") 
      lRet := .F.
   EndIf 
   If _lRet
      M->ZU_DTGERA := Date()
      M->ZU_USUGERA := _cUsuSenha
   EndIf
EndIf      

Return lRet