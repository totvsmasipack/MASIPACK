#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP650CR   ºAutor  ³ Ana Paula QFaustinoº Data ³  01/03/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno de conta contabil em lancamento       º±±
±±º          ³padronizado 650 - credito - sequencia 002                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
// Alterado em 29/07/2013 por Ana Paula QF - modificação nas regras do lançamento padrão
*/    

User Function LP650CR()

Private _cSerie, _cClaFis, _cConta, _cTipoNF,_cFornece

// Contabilizacao Nota Fiscal for de Servico ou Devolucao
// Lancamento Padrao 650 sequencia 002

_cTipoNF := (SF1->F1_TIPO)
_cSerie  := (SD1->D1_SERIE)
_cClaFis := (SD1->D1_CF)
_cConta  := ""
_cFornece:= (SD1->D1_FORNECE)

If SUBSTR(_cClaFis,2,3)="910"
	_cConta := "450010004"

//MERCADORIA EM PODER DE TERCEIROS
ElseIf SUBSTR(_cClaFis,2,3) = "902"
	_cConta := "114000001"
ElseIf SUBSTR(_cClaFis,2,3) = "916"
	_cConta := "114000002"
ElseIf SUBSTR(_cClaFis,2,3) = "913"
	_cConta := "114000003"

// MERCADORIA EM TERCEIROS
ElseIf SUBSTR(_cClaFis,2,3) = "901"
	_cConta := "223000001"
ElseIf SUBSTR(_cClaFis,2,3) = "915"
	_cConta := "223000002"
ElseIf SUBSTR(_cClaFis,2,3) = "912"
	_cConta := "223000003"
	Else
		If _cSerie <> "A1"
			If SUBSTR(_cClaFis,2,3)="201" .OR. SUBSTR(_cClaFis,2,3)="949" .OR. SUBSTR(_cClaFis,2,3)="202"
				If _cTipoNF == 'D'
					_cConta := "220900009"
				ElseIf _cTipoNF =='B'
					_cConta := "114000001"
				//INTERCOMPANY - COMPLEMENTO DE MAQUINAS
				ElseIf _cTipoNF =='N' .AND. _cFornece == "005144"
					_cConta := "114000006"
				EndIf
			Else
	    		_cConta := POSICIONE("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_CONTA")
			EndIf
		Else
    		_cConta := POSICIONE("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_CONTA")
	Endif 
EndIf
 
Return(_cConta)
