#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矲un噮o    � MT235G2  � Autor � Lizandra              � Data � 15/03/12 潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矰escri噮o � Pto Entrada antes da elimina玢o por res韉uo da SC          潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北/*/ 

User Function MT235G2()

_aArea 	:= GetArea()
_lRet := .T.

IF MV_PAR04 <> MV_PAR05
	ApMsgInfo("Verifique par鈓etros.'Pedido de: ' deve ser igual ao 'Pedido at�: '.")
	_lRet := .F.     
ENDIF	

RestArea(_aArea)
Return
	