/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650I   ºAutor  ³Adriano Luis Brandaoº Data ³  15/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para gravacao dos novos campos nas OPs    º±±
±±º          ³ filhas.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "Rwmake.ch"

User Function MTA650I()
            
IF cEmpAnt $ '01|10'

	If ! Empty(SC2->C2_SEQPAI)
		_cNum		:= SC2->C2_NUM
		_cItem		:= SC2->C2_ITEM
		_cSeq		:= SC2->C2_SEQPAI
		_cMsPed		:= ""
		_cMsLista    := ""
		_cMsObs      := ""
		_cMsReduz    := ""
		_cMsCI       := ""
		_CMsDtCI     := CTOD(SPACE(8))
		_cMsUser     := ""
		
		_aArea := GetArea()
		
		DbSelectArea("SC2")
		_aAreaC2 := GetArea()
		DbSetOrder(1)
		If DbSeek(xFilial("SC2")+_cNum+_cItem+_cSeq,.t.)
			// Atualizar as variaveis com os campos novos
			_cMsPed		:= SC2->C2_MSPED
			_cMsLista	:= SC2->C2_MSLISTA
			_cMsObs     := SC2->C2_OBS
			_cMsReduz   := SC2->C2_MSREDUZ
			_cMsCI      := sc2->c2_msci
			_cMsDtCI    := sc2->c2_msdtci
			_cMsUser    := sc2->c2_msuser
		EndIf
		RestArea(_aAreaC2)
		RecLock("SC2",.f.)
		SC2->C2_MSPED 	:= _cMsPed
		SC2->C2_MSLISTA 	:= iif(SC2->C2_UM == "CJ",_cMsLista,"N")
		SC2->C2_OBS       := _cMsObs
		SC2->C2_MSREDUZ   := _cMsReduz
		SC2->C2_MSCI      := _cMsCI
		SC2->C2_MSDTCI    := _cMsDtCI
		SC2->C2_MSUSER    := _cMsUser
		IF EMPTY(sc2->c2_mslista)
			sc2->c2_mslista := "S"
		ENDIF
		IF EMPTY(SC2->C2_MSPED)
			//       IF SC2->C2_MSLISTA == "S"
			SC2->C2_MSPED := SC2->C2_PEDIDO
			//       ELSE
			//           SC2->C2_MSPED := "."
			//       ENDIF
		ENDIF
		IF EMPTY(sc2->c2_msreduz)
			sc5->(DBSEEK(xFilial("SC5") + sc2->c2_pedido))
			sa1->(DBSEEK(xFilial("SA1") + sc5->c5_cliente))
			sc2->c2_msreduz := sa1->a1_nreduz
		ENDIF
		SC2->(MsUnLock())
		RestArea(_aArea)
		
	EndIf

Endif

Return
