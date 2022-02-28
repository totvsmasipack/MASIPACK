#Include "rwmake.ch"
#Include "Topconn.ch"
/*/
------------------------------------------------------------------------
{Protheus.doc} LP610VL()
Programa Retorna Valor em lancamento padrao (610)

@author  DS2U (THOMAS MORAES)
@since   Fev.2021
@version 1.0
@type    function
------------------------------------------------------------------------
/*/

User Function LP610VL(_nSeq)

Private _nValor := 0

SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))

// ANULACAO DA SIMPLES REMESSA
If SF4->F4_CONTAB == "1" .AND. ALLTRIM(SC5->C5_NATUREZ) $ "T04|T09.1|X04|T17.1" .AND. SUBSTR(SD2->D2_CF,2,3)=="949"
    If _nSeq == 1      
      _nValor := (SD2->D2_VALBRUT)
    EndIf
EndIf   

Return(_nValor)
