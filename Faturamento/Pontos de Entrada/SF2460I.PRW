#include "rwmake.ch"
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ SF2460I  ºAutor  ³Solange Aparecida Vezú       ³ 05/01/2007º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.    Grava SE1 para condicoes de pagamentos especiais    MSD2460    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function SF2460I()

Local _aPerTit  := {}
Local cNat      := ""

If SubStr(cNumEmp,1,2) $ "01_10_40_45_15"
	U_RFATG006(SF2->F2_DOC)
EndIf

Return