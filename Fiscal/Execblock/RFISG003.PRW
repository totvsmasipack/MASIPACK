#Include "Topconn.ch"
#include "totvs.ch"
#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFISG001  �Autor  �Lizandra	Marques    � Data �  16/11/03/14���
�������������������������������������������������������������������������͹��
���Desc.     �Valida TS no B1 de acordo com o NCM                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFISG003()

Local _aArea	:= GetArea()
Local _cGrTrib	:= SPACE(TamSX3("B1_GRTRIB")[1])

	IF SUBSTR(M->B1_DESC,1,4) == "EIXO" .OR. SUBSTR(M->B1_DESC,1,7) == "REDUTOR"
		_cGrTrib := "002"
	ELSEIF SUBSTR(M->B1_DESC,1,3) == "ENG" .AND. SUBSTR(M->B1_DESC,1,6) <> "ENGATE"
		_cGrTrib := "002"
	ELSEIF SUBSTR(M->B1_DESC,1,7) == "DATADOR"
		_cGrTrib := "002"
	ELSEIF SUBSTR(M->B1_DESC,1,3) == "OXI" .OR. SUBSTR(M->B1_COD,1,1) == "X"
		_cGrTrib := "002"
	ELSEIF LEFT(M->B1_COD,2) == "MQ" .And. FWCodEmp() $ '01|10'
		_cGrTrib := "002"
	ELSEIF SUBSTR(M->B1_DESC,1,11) == "ACOPLAMENTO"
		_cGrTrib := "002"
	ENDIF

	RestArea(_aArea)

Return _cGrTrib
