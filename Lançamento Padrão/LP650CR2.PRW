#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP650CR2 ºAutor  ³ Ana Paula QFaustinoº Data ³  01/03/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno de conta contabil em lancamento       º±±
±±º          ³padronizado 650 - credito - sequencia 002                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

User Function LP650CR2(_nSeq)

Private _cTipoNF, _cSerie, _cClaFis, _cConta, _cSeq

// Contabilizacao Nota Fiscal for de Servico ou Devolucao
// Lancamento Padrao 650 sequencia 002

_cTipoNF := (SD1->D1_TIPO)
_cSerie  := (SD1->D1_SERIE)
_cClaFis := (SD1->D1_CF)

_cConta  := ""

If Substr(_cClaFis,2,3)<>"556" .OR. Substr(_cClaFis,2,3)<>"407" .OR. Substr(_cClaFis,2,3)<>"653" .OR. Substr(_cClaFis,2,3)<>"406" .OR. Substr(_cClaFis,2,3)<>"551"
	
	If Substr(_cClaFis,2,3) = "910"
		_cConta := "450010004"
	Else	
		If _cSerie <> "A1"
			If SUBSTR(_cClaFis,2,3)="201" .OR. SUBSTR(_cClaFis,2,3)="202" .OR. SUBSTR(_cClaFis,2,3)="949" .OR. SUBSTR(_cClaFis,2,3)="913" 
				If _cTipoNF == "D" 
					If SubStr(cNumEmp,1,2) == "01"
						If _nSeq == 11
							_cConta := "380010002"
						ElseIf _nSeq == 12
							_cConta := "380010003"
						ElseIf _nSeq == 13
							_cConta := "380010004"
						ElseIf _nSeq == 14
							_cConta := "380010007"
						EndIf			
					ElseIf SubStr(cNumEmp,1,2) == "10"
						If _nSeq == 11
							_cConta := "380010009"
						ElseIf _nSeq == 12
							_cConta := "380010010"
						ElseIf _nSeq == 13
							_cConta := "380010012"
						ElseIf _nSeq == 14
							_cConta := "380010011"
						EndIf			
					EndIf
				Else
					If _nSeq = 11
						_cConta := "360010014"
					ElseIf _nSeq = 12
						_cConta := "360010015"
					EndIf			
				EndIf					
			Else
   		    	_cConta := POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_CONTA")
			EndIf
		Else
	    	_cConta := POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_CONTA")
		Endif 
	EndIf
EndIf

Return(_cConta)
