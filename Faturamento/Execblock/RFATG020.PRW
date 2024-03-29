#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG020  �Autor  �Lizandra Marques      Data �  16/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica tabela de pre�os (Fabrima/Masipack                ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RFATG020(_cTabel)

_aArea 		:= GetArea()
_aAreaSA1	:= SA1->(GetArea())

_cNumTab:="   "

dbSelectArea("SA1")
SA1->(dbSetOrder(1))

IF _cTabel == "SCJ"
	If SubStr(cNumEmp,1,2) == "01"// MASIPACK
		IF dbSeek(xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA)
			IF EMPTY(SA1->A1_TABELA)
				M->CJ_TABELA := SUPERGETMV("MV_TABPAD",,"001")
			ELSE
				M->CJ_TABELA := SA1->A1_TABELA
			ENDIF
		EndIf
	ElseIF SubStr(cNumEmp,1,2) == "10"
			IF EMPTY(SA1->A1_MSTABFA)
				M->CJ_TABELA := IIF(SA1->A1_EST=="EX",SUBSTR(GetMv("MV_TABPAD"),4,3),SUBSTR(GetMv("MV_TABPAD"),1,3)) //"400"
			ELSE
				M->CJ_TABELA := SA1->A1_MSTABFA
			ENDIF
	ENDIF
	_cNumTab := M->CJ_TABELA 
ELSE
	IF dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT)
		If SubStr(cNumEmp,1,2) == "01"// MASIPACK
			IF EMPTY(SA1->A1_TABELA)
				M->C5_TABELA := SuperGetMv("MV_TABPAD",,"001")
			ELSE
				M->C5_TABELA := SA1->A1_TABELA
			ENDIF
		ElseiF SubStr(cNumEmp,1,2) == "10"
			IF EMPTY(SA1->A1_MSTABFA) // FABRIMA
				M->C5_TABELA := IIF(SA1->A1_EST=="EX",SUBSTR(GetMv("MV_TABPAD"),4,3),SUBSTR(GetMv("MV_TABPAD"),1,3)) //"400"
			ELSE
				M->C5_TABELA := SA1->A1_MSTABFA
			ENDIF
		Endif   // MASIPACK
	ENDIF
	_cNumTab := M->C5_TABELA 
ENDIF

RestArea(_aAreaSA1)
RestArea(_aArea)

Return(_cNumTab)
