#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ MA410DEL  ³ Autor ³ Cecilia              ³ Data ³ 02.06.08 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Pto Entrada antes da exclusao do Pedido Vendas             ³±±
±±³            So é permitido excluir, o usuario que a criou.             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

User Function MA410DEL()

Local _lRet	:= .T.

	If FWCodEmp() $ '01|10' .And. RetCodUsr(Alltrim(SC5->C5_MSUSER))
		Help(NIL, NIL, "MA410DEL_A", NIL, "Só é permitido liberação pelo usuário que incluiu o Pedido de Vendas.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o responsável pelo pedido: " + Alltrim( UsrRetName(SC5->C5_MSUSER) ) })
		_lRet= .F.
	EndIf

Return _lRet
