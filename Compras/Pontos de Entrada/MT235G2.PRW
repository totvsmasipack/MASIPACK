#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ MT235G2  ³ Autor ³ Lizandra              ³ Data ³ 15/03/12 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Pto Entrada antes da eliminação por resíduo da SC          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/ 

User Function MT235G2()

_aArea 	:= GetArea()
_lRet := .T.

IF MV_PAR04 <> MV_PAR05
	ApMsgInfo("Verifique parâmetros.'Pedido de: ' deve ser igual ao 'Pedido até: '.")
	_lRet := .F.     
ENDIF	

RestArea(_aArea)
Return
	