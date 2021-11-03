#Include "Protheus.ch"
#Include "Topconn.ch"
#include "rwmake.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ M410ALOK  ³ Autor ³ Cecilia              ³ Data ³ 02.06.08 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡ao ³ Pto Entrada antes da alteracao do Pedido Vendas            ³±±
±±³          | So é permitido alterar, o usuario que a criou.             ³±±
±±³          | Verifica Itens transferidos da Makpeças                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

User Function M410ALOK()

Local lRet := .T.

Default INCLUI		:= .F.
Default ALTERA		:= .F.

	If ALTERA
		lRet := U_RFATG061()
	Endif

Return lRet