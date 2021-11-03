#include "rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MTA920E  ºAutor  ³  Cida                       ³ 14/06/2010º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.    Atualiza Estoques para Masipack (Cancelamento NF (Manual)      ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

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