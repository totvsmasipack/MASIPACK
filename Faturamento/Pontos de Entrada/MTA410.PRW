#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MTA410  บAutor ณAparecida de F.Stevanato Data ณ 15/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Verifica se hแ Itens Separados para Faturamento           บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA410()

_fRet := .T.

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
	Do While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
		If SC6->C6_QTDEMP > 0 .And. SC6->C6_MSSEP == "S"
			_fRet := .F.
		EndIf
		SC6->(DbSkip())
	EndDo
	If !_fRet
		Alert("Altera็ใo Invalida, Pedido com Itens Separados no Estoque - Fale com Almoxarifado")
	EndIf
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณMTA410    บAutor  ณLizandra            บ Data ณ  30/04/13   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Consiste as condi็๕es do tipo 9                            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	//Ivandro Santos - 16/11/16
	//Ticket#2016111537000317 — COND PAGTO V91
	//lRet := .t.
	//Ivandro Santos - 21/11/16
	//Ticket#2016112137000083 — PROBLEMAS COM COND PGTO V91
	/*
	If Posicione("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_TIPO") == "9"
	   	//_nTotal := M->C5_PARC1+M->C5_PARC2+M->C5_PARC3+M->C5_PARC4+M->C5_PARC5+M->C5_PARC6+M->C5_PARC7+M->C5_PARC8
	   	_nTotal := M->C5_PARC1+M->C5_PARC2+M->C5_PARC3+M->C5_PARC4+M->C5_PARC5+M->C5_PARC6+M->C5_PARC7+M->C5_PARC8+;
				   M->C5_PARC9+M->C5_PARCA+M->C5_PARCB+M->C5_PARCC+M->C5_PARCD+M->C5_PARCE+M->C5_PARCF
		If (_nTotal/M->C5_MSVLPED*100 <> 100) //If _nTotal < 100
		//Ticket#2016111537000317 — Fim da altera็ใo
			APMSGSTOP("PREENCHER OS VALORES DAS PARCELAS TIPO 9 CORRETAMENTE !!!","BLOQUEIO")
			_fRet := .F.
		EndIf
	EndIf    */
	//Ticket#2016112137000083 — Fim da altera็ใo
ENDIF
Return _fRet
