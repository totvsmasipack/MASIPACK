#include "rwmake.ch"
/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � SF2460I  篈utor  砈olange Aparecida Vez�       � 05/01/2007罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.    Grava SE1 para condicoes de pagamentos especiais    MSD2460    北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function SF2460I()

Local _aPerTit  := {}
Local cNat      := ""

If SubStr(cNumEmp,1,2) $ "01_10_40_45_15"
	U_RFATG006(SF2->F2_DOC)
EndIf

Return