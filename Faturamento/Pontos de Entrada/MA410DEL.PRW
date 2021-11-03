#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ MA410DEL  ³ Autor ³ Cecilia              ³ Data ³ 02.06.08 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Pto Entrada antes da exclusao do Pedido Vendas             ³±±
±±³            So é permitido excluir, o usuario que a criou.             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/

User Function MA410DEL()

Local _cUsuario := RetCodUsr()
Local _cNomusu  := UsrRetName(_cUsuario)
Local _lRet

IF SUBSTR(cNumEmp,1,2) <> "15"  /// ALTERADO LIZANDRA - 27/03/14 - TRATA HELSIMPLAST
	
	If Alltrim(SC5->C5_MSUSER)  <> _cUsuario
		Alert("Só é permitido liberação pelo usuário que incluiu o Pedido de Vendas.")
		_lRet= .F.
	Else
		_lRet= .T.
	EndIf
	
ENDIF
Return(_lRet)
