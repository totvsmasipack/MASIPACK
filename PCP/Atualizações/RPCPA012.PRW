/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �RPCPA012  �Autor  �Aparecida de F.Stevanato� Data  01/06/09 ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao na tabela SZK - Dados Adicionais do Produto      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	     apmsgStop("C�digo j� cadastrado - Entre na Op��o ALTERAR!!!")
	     _fRet := .F.
	  EndIf    
   EndIf
Return(_fRet)