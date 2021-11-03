/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RPCPA012  ºAutor  ³Aparecida de F.Stevanatoº Data  01/06/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao na tabela SZK - Dados Adicionais do Produto      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "Rwmake.ch"
User Function RPCPA012()

Private _fRet   := .T.
Private cVldOK  := "" // Validacao da tela (botao OK) - Inclusao e alteracao. Pode-se utilizar ExecBlock.
                       
cVldOK  := "U_ValIncAlt(nOpc)"
             
AxCadastro("SZK","Dados Adicionais do Produto",,cVldOK)

Return  

User Function ValIncAlt(nOpc)
   _fRet := .T.     
   If Inclui
      If SZK->(DbSeek(xFilial("SZK")+M->ZK_COD))
	     apmsgStop("Código já cadastrado - Entre na Opção ALTERAR!!!")
	     _fRet := .F.
	  EndIf    
   EndIf
Return(_fRet)