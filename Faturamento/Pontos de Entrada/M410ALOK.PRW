#Include "Protheus.ch"
#Include "Topconn.ch"
#include "rwmake.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矲uncao    � M410ALOK  � Autor � Cecilia              � Data � 02.06.08 潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矰escri嘺o � Pto Entrada antes da alteracao do Pedido Vendas            潮�
北�          | So � permitido alterar, o usuario que a criou.             潮�
北�          | Verifica Itens transferidos da Makpe鏰s                    潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北/*/

User Function M410ALOK()

Local lRet := .T.

Default INCLUI		:= .F.
Default ALTERA		:= .F.

	If ALTERA
		lRet := U_RFATG061()
	Endif

Return lRet