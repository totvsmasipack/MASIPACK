#Include "rwmake.ch"   
#Include "Topconn.ch"

/*/
------------------------------------------------------------------------
{Protheus.doc} LP610DB()
Programa para retorno de conta contabil em lancamento padronizado (610)
Sequencia 002 - Debito

@author  DS2U (THOMAS MORAES)
@since   Fev.2021
@version 1.0
@type    function
------------------------------------------------------------------------
/*/

User Function LP610DB()


_cConta  := ""

SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))

// MERCADORIA EM PODER DE TERCEIROS

If SUBSTR(SD2->D2_CF,2,3)$"901"
	_cConta :="114000001"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"915"
	_cConta :="114000002"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"912"
	_cConta :="114000003"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"949" .AND. (ALLTRIM(SC5->C5_NATUREZ) $ "T03|T09|T15|T04.3|V04.2|T04|T09.1|X04|T17.1|T10")
	_cConta :="110400001"

// INTERCOMPANY
ElseIf ALLTRIM(SD2->D2_CLIENTE)$"006018_008352"
	_cConta :=SA1->A1_CONTA

// MERCADORIA DE TERCEIROS
ElseIf SUBSTR(SD2->D2_CF,2,3)$"902"
	_cConta :="223000001"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"916"
	_cConta :="223000002"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"913"
	_cConta :="223000003"
//REMESSA FABRIMA/MASIPACK FAT ANTECIPADO E ENTR FUTURA
ElseIf (SUBSTR(cNumEmp,1,2))$"01|10" .and. SUBSTR(SD2->D2_CF,2,3)$"116" .AND. (ALLTRIM(SC5->C5_NATUREZ)$"V05.7|")
	_cConta :="220900004"
Else
	_cConta :=SA1->A1_CONTA
EndIf

Return(_cConta)
