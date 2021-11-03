#Include "Topconn.ch"
#include "totvs.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFISG002  ºAutor  ³Ivandro Marcio      º Data ³  10/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³NCM                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFISG002()

_aArea := GetArea()

M->B1_MSNCM := "  "
//Ivandro Santos - 16/01/2018 - início da alteração: Ticket#2018011037000216 — Cadastro de produtos - rotina de cópia
IF INCLUI
	_cNCM := ""
Endif
//Ticket#2018011037000216 — Fim da alteração
IF SUBSTR(M->B1_DESC,1,4) == "EIXO" .OR. SUBSTR(M->B1_DESC,1,7) == "REDUTOR"
	_cNCM := "84834010"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,5) == "POLIA"
	_cNCM := "84835010"
ELSEIF SUBSTR(M->B1_DESC,1,12) == "RODA DENTADA"
	_cNCM := "84839000"		//Ticket#2018021437000118
ELSEIF SUBSTR(M->B1_DESC,1,3) == "ENG" .AND. SUBSTR(M->B1_DESC,1,6) <> "ENGATE"
	_cNCM := "84834090"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,5) == "MANCA"
	_cNCM := "84832000"
ELSEIF SUBSTR(M->B1_DESC,1,6) == "ROLETE"
	_cNCM := "84829190"
ELSEIF SUBSTR(M->B1_DESC,1,7) == "DATADOR"
	_cNCM := "84439192"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,8) == "OXICORTE" //.OR. SUBSTR(M->B1_COD,1,1) == "X" - SOLICITADO ALTERACAO POR GEGLIANE - FISCAL
	_cNCM := "84543090"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "MOTOREDUTOR"
	_cNCM := "85015210"
ELSEIF SUBSTR(M->B1_DESC,1,13) == "ANEL ELASTICO"
	_cNCM := "40169300"
ELSEIF SUBSTR(M->B1_DESC,1,7) == "CORREIA"
	_cNCM := "59100000"
ELSEIF SUBSTR(M->B1_DESC,1,7) == "DATADOR"
	_cNCM := "84439192"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,9) == "ROLAMENTO"
	_cNCM := "84821010"
ELSEIF SUBSTR(M->B1_COD,1,2) == "PA" .AND. SUBSTR(cNumEmp,1,2) == '40'
	_cNCM := "76121000"
ELSEIF SUBSTR(M->B1_COD,1,2) == "PA" .AND. SUBSTR(cNumEmp,1,2) == '45'
	_cNCM := "76129090"
ELSEIF SUBSTR(M->B1_COD,1,2) == "MQ"
	//Ivandro Santos - 11/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	IF SUBSTR(cNumEmp,1,2) == '01' //.AND. MV_PAR02 == 1	//MV_PAR02 Parâmetro F12 referente à aba Complemento junta ao Produto
		IF "BALANCA GARVENS" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))			//IF "BALANCA GARVENS" $ M->B1_DESCP
			_cNCM := "84232000"
		ELSEIF "MULTIPLOS CABECOTES" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))	//ELSEIF "MULTIPLOS CABECOTES" $ M->B1_DESCP
			_cNCM := "84233019"
			_cGrTrib := "002"
		ELSEIF "DOSADOR DE ROSCA" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))		//ELSEIF "DOSADOR DE ROSCA" $ M->B1_DESCP
			_cNCM := "84233090"
			_cGrTrib := "002"
		ELSE
			_cNCM := "84224010"
		ENDIF
	ELSEIF SUBSTR(cNumEmp,1,2) == '10'
		_cNCM := "84224090"
	ENDIF
	//Ticket#2017031037000107 — Fim da alteração
ELSEIF SUBSTR(M->B1_DESC,1,4) == "FACA"
	_cNCM := "82089000"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "CONTRA FACA"
	_cNCM := "82089000"
ELSEIF SUBSTR(M->B1_DESC,1,8) == "PARAFUSO"
	_cNCM := "73181500"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "ACOPLAMENTO"
	_cNCM := "84834090"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,8) == "ALAVANCA"
	_cNCM := "84229090"
ELSEIF SUBSTR(M->B1_DESC,1,4) == "MOLA"
	_cNCM := "73209000"
ELSEIF SUBSTR(M->B1_DESC,1,7) == "ARRUELA"
	_cNCM := "73182200"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "RESISTENCIA"
	_cNCM := "85168090"
ELSEIF SUBSTR(M->B1_DESC,1,6) == "DIGITO"
	_cNCM := "96110000"
ENDIF


RestArea(_aArea)

Return(_cNCM)
