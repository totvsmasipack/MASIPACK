#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矲un噮o    � MA410DEL  � Autor � Cecilia              � Data � 02.06.08 潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矰escri噮o � Pto Entrada antes da exclusao do Pedido Vendas             潮�
北�            So � permitido excluir, o usuario que a criou.             潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北/*/

User Function MA410DEL()

Local _cUsr	:= GetMv("MS_USRAPV")
Local _lRet	:= .T.

	If FWCodEmp() $ '01|10' .And. !(SC5->C5_MSUSER == RetCodUsr()) .And. !(RetCodUsr() $ _cUsr) .And. !(FwIsAdmin())
		Help(NIL, NIL, "MA410DEL_A", NIL, "S� � permitido libera玢o pelo usu醨io que incluiu o Pedido de Vendas.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o respons醰el pelo pedido: " + Alltrim( UsrFullName(SC5->C5_MSUSER) ) })
		_lRet := .F.
	EndIf

Return _lRet
