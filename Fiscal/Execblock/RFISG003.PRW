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
Local _cPOSIPI := ""
Local _cGrTrib := ""

_aArea := GetArea()

M->B1_MSNCM := "  "

//IF INCLUI
IF SUBSTR(M->B1_DESC,1,4) == "EIXO" .OR. SUBSTR(M->B1_DESC,1,7) == "REDUTOR"
	_cPOSIPI := "84834010"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,5) == "POLIA"
	_cPOSIPI := "84835010"
ELSEIF SUBSTR(M->B1_DESC,1,12) == "RODA DENTADA"
	_cPOSIPI := "84839000"		//Ticket#2018021437000118
ELSEIF SUBSTR(M->B1_DESC,1,3) == "ENG" .AND. SUBSTR(M->B1_DESC,1,6) <> "ENGATE"
	_cPOSIPI := "84834090"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,5) == "MANCA"
	_cPOSIPI := "84832000"
ELSEIF SUBSTR(M->B1_DESC,1,6) == "ROLETE"
	_cPOSIPI := "84829190"
ELSEIF SUBSTR(M->B1_DESC,1,7) == "DATADOR"
	_cPOSIPI := "84439192"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,8) == "OXICORTE" //.OR. SUBSTR(M->B1_COD,1,1) == "X" - SOLICITADO ALTERACAO POR GEGLIANE - FISCAL
	_cPOSIPI := "84543090"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "MOTOREDUTOR"
	_cPOSIPI := "85015210"
ELSEIF SUBSTR(M->B1_DESC,1,13) == "ANEL ELASTICO"
	_cPOSIPI := "40169300"
ELSEIF SUBSTR(M->B1_DESC,1,7) == "CORREIA"
	_cPOSIPI := "59100000"
ELSEIF SUBSTR(M->B1_DESC,1,9) == "ROLAMENTO"
	_cPOSIPI := "84821010"
ELSEIF SUBSTR(M->B1_COD,1,2) == "PA" .AND. SUBSTR(cNumEmp,1,2) == '40'
	_cPOSIPI := "76121000"
ELSEIF SUBSTR(M->B1_COD,1,2) == "PA" .AND. SUBSTR(cNumEmp,1,2) == '45'
	_cPOSIPI := "76129090"
ELSEIF SUBSTR(M->B1_COD,1,2) == "MQ"
	//Ivandro Santos - 11/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	IF SUBSTR(cNumEmp,1,2) == '01' //.AND. MV_PAR02 == 1	//MV_PAR02 Parâmetro F12 referente à aba Complemento junta ao Produto
		IF "BALANCA GARVENS" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))			//IF "BALANCA GARVENS" $ M->B1_DESCP
			_cPOSIPI := "84232000"
		ELSEIF "MULTIPLOS CABECOTES" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))	//ELSEIF "MULTIPLOS CABECOTES" $ M->B1_DESCP
			_cPOSIPI := "84233019"
			_cGrTrib := "002"
		ELSEIF "DOSADOR DE ROSCA" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))		//ELSEIF "DOSADOR DE ROSCA" $ M->B1_DESCP
			_cPOSIPI := "84233090"
			_cGrTrib := "002"
		ELSE
			_cPOSIPI := "8422IS4010"
		ENDIF
	ELSEIF SUBSTR(cNumEmp,1,2) == '10'
		_cPOSIPI := "84224090"
	ENDIF
	//Ticket#2017031037000107 — Fim da alteração
ELSEIF SUBSTR(M->B1_DESC,1,4) == "FACA"
	_cPOSIPI := "82089000"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "CONTRA FACA"
	_cPOSIPI := "82089000"
ELSEIF SUBSTR(M->B1_DESC,1,8) == "PARAFUSO"
	_cPOSIPI := "73181500"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "ACOPLAMENTO"
	_cPOSIPI := "84834090"
	_cGrTrib := "002"
ELSEIF SUBSTR(M->B1_DESC,1,8) == "ALAVANCA"
	_cPOSIPI := "84229090"
ELSEIF SUBSTR(M->B1_DESC,1,4) == "MOLA"
	_cPOSIPI := "73209000"
ELSEIF SUBSTR(M->B1_DESC,1,7) == "ARRUELA"
	_cPOSIPI := "73182200"
ELSEIF SUBSTR(M->B1_DESC,1,11) == "RESISTENCIA"
	_cPOSIPI := "85168090"
ELSEIF SUBSTR(M->B1_DESC,1,6) == "DIGITO"
	_cPOSIPI := "96110000"
ENDIF

SB5->(DbSetOrder(1))
IF SB5->(Dbseek(xFilial("SB5")+M->B1_COD))
	RecLock("SB5",.F.)
	SB5->B5_INSPAT  := SYD->YD_MSPORTA
	SB5->B5_CODATIV := SYD->YD_MSCATIV
	SB5->(MsUnlock())
ENDIF

RestArea(_aArea)

Return(_cGrTrib)
