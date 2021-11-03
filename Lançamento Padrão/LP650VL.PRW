#Include "rwmake.ch"
#Include "Topconn.ch"
/*/
------------------------------------------------------------------------
{Protheus.doc} LP650VL()
Programa Retorna Valor em lancamento padrao (650 e 640)
Sequencias 1 a 13

@author  DS2U (THOMAS MORAES)
@since   Fev.2021
@version 1.0
@type    function
------------------------------------------------------------------------
/*/

User Function LP650VL(_nSeq)

Private _nValor := 0

SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))       

If SF4->F4_CONTAB == "1"
   If _nSeq == 1      
      _nValor := (SD1->D1_TOTAL-SD1->D1_VALDESC)      
   ElseIf _nSeq == 2
      _nValor := SD1->D1_TOTAL+SD1->D1_DESPESA+SD1->D1_VALFRE+SD1->D1_SEGURO-SD1->D1_VALDESC-SD1->D1_VALISS-SD1->D1_VALIRR-SD1->D1_VALINS-SD1->D1_VALPIS-SD1->D1_VALCOF-IIF(SUBSTR(cNumEmp,1,2) == '15',0,SD1->D1_VALCLS) 	
   ElseIf _nSeq == 4
      _nValor := SD1->D1_VALCOF+SD1->D1_VALCLS+SD1->D1_VALPIS
   ElseIf _nSeq == 5
       _nValor := SD1->D1_VALISS 
   ElseIf _nSeq == 6
      _nValor := SD1->D1_VALINS
   ElseIf _nSeq == 7
      _nValor := SD1->D1_VALIRR 
   ElseIf _nSeq == 8
      _nValor := SD1->D1_VALFRE
   ElseIf _nSeq == 9
      _nValor := SD1->D1_SEGURO
   ElseIf _nSeq == 10
      _nValor := SD1->D1_DESPESA
   ElseIf _nSeq == 11        
      _nValor := SD1->D1_VALICM          
   ElseIf _nSeq == 12
      _nValor := SD1->D1_VALIPI
   ElseIf _nSeq == 13
      _nValor := SD1->D1_VALIMP6    // Valor do PIS
   ElseIf _nSeq == 14
      _nValor :=  SD1->D1_VALIMP5   // Valor do Cofins            
   EndIf
   If _nSeq == 1 .Or. _nSeq == 2 
	  If SF4->F4_IPI <> "R" // R -> Comercio nao atacadista, aproveitamento de 50% do Valor de IPI, este valor não vem destacado na Nota é informado no momento da Entrada.
         _nValor += SD1->D1_VALIPI
	  EndIf
      If SF1->F1_FORMUL == "S" .AND. SF1->F1_EST  == "EX"    // Valor de ICMS - Nota de Importação
         _nValor += SD1->D1_VALICM
      EndIf
      If SUBSTR(SF4->F4_CF,2,3) == "604"
         _nValor := 0
      EndIf
   EndIf
   If _nSeq == 11
      If SUBSTR(SF4->F4_CF,2,3) == "556" .OR. SUBSTR(SF4->F4_CF,2,3) == "407" .OR. SUBSTR(SF4->F4_CF,2,3) == "302"
         _nValor := 0
      EndIf
   EndIf
EndIf   

Return(_nValor)
