#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG004 �Autor  �Aparecida F.Stevanato � Data �  31/10/07  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para acessar informa��es do arquivo de senhas      ���
���          �         Nome e Depto. do Usuario                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG004()

Local _cUsuario := RetCodUsr()
Local _aUsuario := {}
Local cUsuAnt   := M->ZM_MSUSER

SC5->(DbGoTop())
SC5->(DbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+M->ZM_PEDIDO))
   M->ZM_CODCLI  := SC5->C5_CLIENTE
   M->ZM_LOJACLI := SC5->C5_LOJACLI 
   SA1->(dbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
      M->ZM_CLIENTE := SA1->A1_NREDUZ
   EndIf
EndIf

If Empty(cUsuAnt)  
   M->ZM_MSUSER := UsrRetName(_cUsuario)
   PswOrder(1)
   If PswSeek(_cUsuario,.T.)
      _aUsuario   := PswRet()
      M->ZM_DEPTO := _aUsuario[1][12]
   EndIf      
EndIf   

Return  