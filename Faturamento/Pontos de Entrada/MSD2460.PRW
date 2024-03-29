#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � MSD2460  篈utor  �                            � 04/12/2006 罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     | Atualiza Conta contabil                                     北
北�                                                                        北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function MSD2460()

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4")+SD2->D2_TES)
	RecLock("SD2",.F.)
	If SF4->F4_CONTAB == "1"     
		IF SUBSTR(SED->ED_CODIGO,1,3) = 'V02'
	       IF SUBSTR(SD2->D2_CF,2,3) $ '101,107' 
				SD2->D2_CONTA := '440010001'
			ELSEIF SUBSTR(SD2->D2_CF,2,3) $ '102,108,403' 	
				SD2->D2_CONTA := '440010002'
			ENDIF	
		ELSE
			SD2->D2_CONTA := SED->ED_CONTA
		ENDIF	
	Else
		SD2->D2_CONTA := ""
	EndIf
	SD2->(MsUnLock())
ENDIF
Return()
