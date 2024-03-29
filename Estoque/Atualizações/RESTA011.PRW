#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTA011  �Autor  �Aparecida F.Stevanato� Data �  16/02/10  ���
�������������������������������������������������������������������������͹��
���Desc.     �Menu principal Tabela SZS - Log de Apontamento de Producao  ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������                       
�����������������������������������������������������������������������������
*/

User Function RESTA011()

Private _cUsuario  := RetCodUsr() 
Private _aUsuario  := {}
Private _cUsuSenha := ""
Private _cDeptoUsu := ""
Private _lRet      := .T. 

Private cVldOK  := "" // Validacao da tela (botao OK) - Inclusao e alteracao. Pode-se utilizar ExecBlock.
Private cVldExc := "" // Validacao para permitir a exclusao.  Pode-se utilizar ExecBlock. 
   
Private aRotina   := {{"Pesquisa" ,"AxPesqui"      ,0,1} ,;   // Pesquisa
				      {"Visualiza","AxVisual"      ,0,2} ,;   // Visualiza
                      {"Inclui"   ,"AxInclui"      ,0,3} ,;   // Inclui
                      {"Altera"   ,"AxAltera"      ,0,4} ,;   // Altera 
                      {"Exclui"   ,"AxDeleta"      ,0,5}}     // Exclui

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario  := PswRet()
   _cUsuSenha := Alltrim(UsrFullName(_cUsuario))
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf
                             
cVldOK  := "U_ValidaZS(nOpc)"
cVldExc := "U_ValExclusao(5)"

Private cString := "SZS"

dbSelectArea("SZS")
dbSetOrder(1)

AxCadastro("SZS","Exibe Log - Apontamento de Produ��o","U_ValExclusao(5)","U_ValidaZS(nOpc)")

Return

User Function ValidaZS(nOpc)
   If Inclui 
      M->ZS_OP      := "RESTA011" 
      M->ZS_PRODUTO := "OCORRENCIA"
      M->ZS_POSICAO := M->ZS_POSICAO
      M->ZS_DATA    := Date()
      M->ZS_HORA    := Time()
      M->ZS_USUARIO := UPPER(_cUsuSenha)
      M->ZS_DEPTO   := _cDeptoUsu
      _lRet := .T.
   Else    
      If Alltrim(SZS->ZS_OP)  == "RESTA011" 
         If Alltrim(SZS->ZS_USUARIO) == _cUsuSenha
            _lRet := .T.
         Else    
            ApMsgSTOP("Somente quem Incluiu a Informa��o poder� Alter�-la")
            _lRet := .F.
         EndIf   
      Else
         ApMsgSTOP("Altera��o Invalida - Informa��es s�mente para Visualiza��o")
         _lRet := .F.
      EndIf   
   EndIf 
Return _lRet

User Function ValExclusao()
   If Alltrim(SZS->ZS_OP)  == "RESTA011"
      If Alltrim(SZS->ZS_USUARIO) == _cUsuSenha
         _lRet := .T.
      Else    
         ApMsgSTOP("Somente quem Incluiu a Informa��o poder� Exclui-la")
         _lRet := .F.
      EndIf   
   Else
      ApMsgSTOP("Exclus�o Invalida - Informa��es s�mente para Visualiza��o")
      _lRet := .F.
   EndIf
Return (_lRet)
