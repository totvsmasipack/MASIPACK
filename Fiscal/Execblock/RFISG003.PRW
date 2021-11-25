#Include "Topconn.ch"
#include "totvs.ch"
#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFISG001  ºAutor  ³Lizandra	Marques    º Data ³  16/11/03/14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida TS no B1 de acordo com o NCM                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
