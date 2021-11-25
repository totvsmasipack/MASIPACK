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
Local _aArea	:= GetArea()
Local _cTS		:= ""
Local _oModel	:= FWModelActive()

	dbSelectArea("SYD")
	SYD->(dbSetOrder(1))
	IF SYD->(dbSeek(FWxFilial("SYD") + Padr(M->B1_POSIPI,TamSX3("YD_TEC")[1]))) .And. _oModel:isActive()

		IF FWCodEmp() $ '01|10'
			
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

			SB5->(DbSetOrder(1))
			IF SB5->(Dbseek(xFilial("SB5")+M->B1_COD))
				RecLock("SB5",.F.)
				SB5->B5_INSPAT  := SYD->YD_MSPORTA
				SB5->B5_CODATIV := SYD->YD_MSCATIV
				SB5->(MsUnlock())
			ENDIF
		
		ENDIF
	
	ENDIF

	RestArea(_aArea)

Return _cTS
