#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650E   ºAutor  ³Victor Dessunte     º Data ³  07/29/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validacao da exclusao da ordem de    º±±
±±º          ³ producao                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA650E()

Local _aArea 	:= GetArea()
Local _aUsuer	:= ""
Local _cName	:= ""
Local _cDepto	:= ""

If cEmpAnt $ '01|10'

	PswOrder(1)
	If PswSeek(RetCodUsr(),.T.)
		_aUser	:= PswRet()
		_cName	:= _aUser[1][4]  
		_cDepto	:= Upper(Alltrim(_aUser[1][12]))
	EndIf

	//VICTOR DESSUNTE - 29/07/2016
	//INICIO - TICKET: 2016021637000332
	If SM0->M0_CODIGO <> '15'
		RecLock("SZS",.T.)
		SZS->ZS_FILIAL  := "01"
		SZS->ZS_OP      := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		SZS->ZS_PRODUTO := SC2->C2_PRODUTO
		SZS->ZS_QTDE    := SC2->C2_QUANT
		SZS->ZS_POSICAO := "Exclusão da OP"
		SZS->ZS_CC      := "XXXXXX"
		SZS->ZS_DATA    := Date()
		SZS->ZS_HORA    := Time()
		SZS->ZS_USUARIO := UPPER(_cName)
		SZS->ZS_DEPTO   := _cDepto
		SZS->(MsUnlock())
	EndIf
	//FIM - TICKET: 2016021637000332

Endif

RestArea(_aArea)

Return .T.
