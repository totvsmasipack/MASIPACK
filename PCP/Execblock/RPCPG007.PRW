#include "rwmake.ch"
#Include "Topconn.ch"


/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � RPCPG007   � Autor � Cecilia         �    Data  � 17/11/09 ���
��+----------+------------------------------------------------------------���
���Descricao � Acerta o Centro de Custo.        						  ���
��+----------+------------------------------------------------------------���
���Uso       � GENERICO													  ���
��+----------+------------------------------------------------------------���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RPCPG007()
Local cCC := M->D3_CC
Private _cUsuario := RetCodUsr()
Private _aUsuario := {}
Private cDeptoUsu := ""

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario := PswRet()
   cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf
     
IF cDeptoUsu == "CALDERARIA"      
   cCC := '203' 
Endif

Return(cCC)
