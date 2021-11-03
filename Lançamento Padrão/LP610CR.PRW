#Include "rwmake.ch"   
#Include "Topconn.ch"

/*/
------------------------------------------------------------------------
{Protheus.doc} LP610CR()
Programa para retorno de conta contabil em lancamento padronizado (610)
Sequencia 001 - Credito

@author  DS2U (THOMAS MORAES)
@since   Fev.2021
@version 1.0
@type    function
------------------------------------------------------------------------
/*/

User Function LP610CR()

_cConta  := ""

SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))

// MERCADORIA EM PODER DE TERCEIROS

If SUBSTR(SD2->D2_CF,2,3)$"901"
	_cConta :="222000001"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"915"
	_cConta :="222000002"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"912"
	_cConta :="222000003"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"949" .AND. (ALLTRIM(SC5->C5_NATUREZ)$"T03|T09|T15|T04.3|V04.2|T04|T09.1|X04|T17.1|T10")
	_cConta :="440410001"

// INTERCOMPANY
ElseIf SUBSTR(cNumEmp,1,2)=="01" .AND. (ALLTRIM(SD2->D2_CLIENTE)$"006018|008352");
	.OR. (SUBSTR(cNumEmp,1,2))=="10" .AND. (ALLTRIM(SD2->D2_CLIENTE)$"999999|008352");
	.OR. (SUBSTR(cNumEmp,1,2))=="15" .AND. (ALLTRIM(SD2->D2_CLIENTE)$"000002|000013")
	_cConta :="440410001"

// MERCADORIA DE TERCEIROS
ElseIf SUBSTR(SD2->D2_CF,2,3)$"902"
	_cConta :="115000001"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"916"
	_cConta :="115000002"
ElseIf SUBSTR(SD2->D2_CF,2,3)$"913"
	_cConta :="115000003"
Else
	_cConta :=SD2->D2_CONTA
EndIf

Return(_cConta)
