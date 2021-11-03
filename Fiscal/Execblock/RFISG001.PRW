#Include "Topconn.ch"
#include "totvs.ch"
#include "protheus.ch"

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

User Function RFISG001()
Local aArea		:= GetArea()
Local _cGrTrib	:= ""
Local _cPOSIPI	:= ""
Local _cTS		:= ""
Local oModel	:= FWModelActive()

	Do Case

		Case SUBSTR(M->B1_DESC,1,4) == "EIXO" .OR. SUBSTR(M->B1_DESC,1,7) == "REDUTOR"
			_cPOSIPI := "84834010"
			_cGrTrib := "002"
		
		Case SUBSTR(M->B1_DESC,1,5) $ "POLIA"
			_cPOSIPI := "84835010"
		
		Case SUBSTR(M->B1_DESC,1,12) $ "RODA DENTADA"
			_cPOSIPI := "84839000"
		
		Case SUBSTR(M->B1_DESC,1,3) $ "ENG" .And. SUBSTR(M->B1_DESC,1,6) <> "ENGATE"
			_cPOSIPI := "84834090"
			_cGrTrib := "002"

		Case SUBSTR(M->B1_DESC,1,5) $ "MANCA"
			_cPOSIPI := "84832000"
		
		Case SUBSTR(M->B1_DESC,1,6) $ "ROLETE"
			_cPOSIPI := "84829190"
		
		Case SUBSTR(M->B1_DESC,1,7) $ "DATADOR"
			_cPOSIPI := "84439192"
			_cGrTrib := "002"
		
		Case (SUBSTR(M->B1_DESC,1,8) $ "OXICORTE" .And. SUBSTR(M->B1_COD,1,1) $ "X") .Or. ; 
			 (SUBSTR(M->B1_DESC,1,8) $ "OXICORTE" .And. SUBSTR(M->B1_COD,1,1) # "X")
			
			_cPOSIPI := "84543090"
			_cGrTrib := "002"

		Case SUBSTR(M->B1_DESC,1,11) $ "MOTOREDUTOR"
			_cPOSIPI := "85015210"
		
		Case SUBSTR(M->B1_DESC,1,13) $ "ANEL ELASTICO"
			_cPOSIPI := "40169300"
		
		Case SUBSTR(M->B1_DESC,1,7) $ "CORREIA"
			_cPOSIPI := "59100000"
		
		Case SUBSTR(M->B1_DESC,1,9) $ "ROLAMENTO"
			_cPOSIPI := "84821010"

		Case SUBSTR(M->B1_DESC,1,4) $ "FACA" .Or. SUBSTR(M->B1_DESC,1,11) $ "CONTRA FACA"
			_cPOSIPI := "82089000"

		Case SUBSTR(M->B1_DESC,1,8) $ "PARAFUSO"
			_cPOSIPI := "73181500"
		
		Case SUBSTR(M->B1_DESC,1,11) $ "ACOPLAMENTO"
			_cPOSIPI := "84834090"
			_cGrTrib := "002"
		
		Case SUBSTR(M->B1_DESC,1,8) $ "ALAVANCA"
			_cPOSIPI := "84229090"
		
		Case SUBSTR(M->B1_DESC,1,4) $ "MOLA"
			_cPOSIPI := "73209000"
		
		Case SUBSTR(M->B1_DESC,1,7) $ "ARRUELA"
			_cPOSIPI := "73182200"

		Case  SUBSTR(M->B1_DESC,1,11) $ "RESISTENCIA"
			_cPOSIPI := "85168090"
		
		Case SUBSTR(M->B1_DESC,1,6) $ "DIGITO"
			_cPOSIPI := "96110000"

		Case SUBSTR(M->B1_COD,1,2) == "MQ"
			
			IF SUBSTR(cNumEmp,1,2) == '01'	//Masipack
				
				IF "BALANCA GARVENS" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))
					_cPOSIPI := "84232000"
				
				ELSEIF "MULTIPLOS CABECOTES" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))
					_cPOSIPI := "84233019"
					_cGrTrib := "002"
				
				ELSEIF "DOSADOR DE ROSCA" $ IIF(IsInCallStack("MATA410"),M->B1_DESC,IIF(!EMPTY(ALLTRIM(M->B5_CEME)),M->B5_CEME,M->B1_DESC))
					_cPOSIPI := "84233090"
					_cGrTrib := "002"
				
				ELSE
					_cPOSIPI := "84224010"
				
				ENDIF
		
			ELSEIF SUBSTR(cNumEmp,1,2) == '10'	//Fabrima
				_cPOSIPI := "84224090"
				_cGrTrib := "002"
			
			ENDIF

	End Case
	
	dbSelectArea("SYD")
	SYD->(dbSetOrder(1))
	IF SYD->(dbSeek(FWxFilial("SYD") + Padr(_cPOSIPI,TamSX3("YD_TEC")[1]))) .And. oModel:isActive()

		FwFldPut("B1_POSIPI", _cPOSIPI, ,oModel)
		FwFldPut("B1_IPI", SYD->YD_PER_IPI, ,oModel)
		FwFldPut("B1_PICM", SYD->YD_ICMS_RE, ,oModel)
		FwFldPut("B1_GRTRIB", _cGrTrib, ,oModel)

		IF SUBSTR(cNumEmp,1,2) $ '01|10'
			
			IF SYD->YD_BICMS == 'S'
				IF SYD->YD_PER_IPI == 0
					IF M->B1_PROCED == '1P'
						_cTS := '804'
					ELSEIF M->B1_PROCED == '2P'
						_cTS := '809'
					ENDIF
				ELSE
					IF M->B1_PROCED == '1P'
						_cTS := '910'
					ELSEIF M->B1_PROCED == '2P'
						_cTS := '912'
					ENDIF
				ENDIF
		
			ELSE
				
				IF SYD->YD_PER_IPI == 0
					IF M->B1_PROCED == '1P'
						_cTS := '806'
					ELSEIF M->B1_PROCED == '2P'
						_cTS := '810'
					ENDIF
				ELSE
					IF M->B1_PROCED == '1P'
						_cTS := '802'
					ELSEIF M->B1_PROCED == '2P'
						_cTS := '807'
					ENDIF
				ENDIF
			
			ENDIF
		
		ENDIF

		SB5->(DbSetOrder(1))
		IF SB5->(Dbseek(xFilial("SB5")+M->B1_COD))
			RecLock("SB5",.F.)
			SB5->B5_INSPAT  := SYD->YD_MSPORTA
			SB5->B5_CODATIV := SYD->YD_MSCATIV
			SB5->(MsUnlock())
		ENDIF

	ELSE
	
		FwFldPut("B1_POSIPI", SPACE(TamSX3("B1_POSIPI")[1]), ,oModel)
		FwFldPut("B1_IPI", 0, ,oModel)
		FwFldPut("B1_PICM", 0, ,oModel)
		FwFldPut("B1_GRTRIB", SPACE(TamSX3("B1_GRTRIB")[1]), ,oModel)
	
	ENDIF

	RestArea(aArea)

Return _cTS
