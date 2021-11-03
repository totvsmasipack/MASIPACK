#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSD3240I   บ Autor ณ Cecilia            บ Data ณ  03/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida e acerta Req.e Dev. para SZ8 (D/R/E)                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function SD3240I()

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	//VICTOR DESSUNTE - 05/12/2016
	//INICIO: Ticket#2016111037000497
	Private _cObs		:= ""
	//FIM: Ticket#2016111037000497
	
	Private _cRotina  := ""
	Private _cTpMov   := ""
	Private _cTipoMov := ""
	
	wArea:= GetArea()
	
	_cRotina := FunName()
	
	
	If _cRotina == "MATA240"
		_cTpMov := SD3->D3_TM
	ElseIf _cRotina == "MATA241"
		_cTpMov := cTM
	ElseIf _cRotina == "MATA185"
		_cTpMov := SD3->D3_TM
	Else
		Return
	EndIf
	
	//alert("SD3240I " + _cTpMov + " Cod."+ SD3->D3_COD)
	
	If VAL(_cTpMov) > 499 //Requisicao
		
		If Val(_cTpMov) == 601
			SD4->(DbSetOrder(1))
			If SD4->(dbSeek(xFilial("SD4")+SD3->D3_COD+SD3->D3_OP+SD3->D3_TRT))
				RecLock("SD4",.F.)
				SD4->D4_MSSEPAR := SD3->D3_EMISSAO
				SD4->(MsUnlock())
				SC2->(DbSetOrder(1))
			ENDIF
		EndIf
		If Alltrim(SD3->D3_MSOBS) <> ""
			//VICTOR DESSUNTE - 02/03/2017
			//INICIO - TICKET: 2017030237000097 
			_cObs := "REQUISICAO - " + SD3->D3_MSOBS
			//FIM - TICKET: 2017030237000097 
		Else
			If Val(_cTpMov) == 602
				_cObs := "REQUISICAO - BAIXA DA LISTA (" + _cRotina  + ")"
			Else
				_cObs := "REQUISICAO - MATERIAL CONSUMO (" + _cRotina + ")"
			EndIf
		EndIf
	ElseIf VAL(_cTpMov) < 500 //Devolucao
		If Alltrim(SD3->D3_MSOBS) <> ""
			//VICTOR DESSUNTE - 02/03/2017
			//INICIO - TICKET: 2017030237000097 
			//Ivandro Santos - inํcio da altera็ใo: Ticket#2017030237000097 — Movimenta็ใo sem informa็๕es
			If Alltrim(SD3->D3_ESTORNO) = ''	//SD3->D3_ESTORNO = ''
			//Ticket#2017030237000097 — Fim da altera็ใo
				_cObs := "DEVOLUวรO - " + Alltrim(SD3->D3_MSOBS)
			Else
				_cObs := "ESTORNO - " + Alltrim(SD3->D3_MSOBS)
			EndIf				
			//FIM - TICKET: 2017030237000097
		Else
			_cObs := "DEVOLUวรO - MATERIAL DE CONSUMO (" + _cRotina + ")"
		EndIf
	EndIf
	RecLock("SD3",.F.)
	SD3->D3_HORAS := TIME()
	SD3->D3_MSOBS := _cObs
	MSUnlock()

	RestArea(wArea)
ENDIF

Return
