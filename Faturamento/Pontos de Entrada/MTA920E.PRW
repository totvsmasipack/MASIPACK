#include "rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � MTA920E  篈utor  �  Cida                       � 14/06/2010罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.    Atualiza Estoques para Masipack (Cancelamento NF (Manual)      北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function MTA920E()

Private fRet       := .T.

If SubStr(cNumEmp,1,2) == "15"
	Return
EndIf

SZO->(DbSetOrder(1))
If SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+Alltrim(SF2->F2_DOC)))         // Exclui as mensagens da nota fiscal
	RecLock("SZO",.F.)
	SZO->(DbDelete())
	SZO->(MsUnLock())
EndIf

Return fRet