#INCLUDE 'PROTHEUS.CH'
#Include "topconn.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP650DB   ºAutor  ³ Ana Paula QFaustinoº Data ³  01/05/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno de conta contabil em lancamento       º±±
±±º          ³padronizado 650 - DEBITO - sequencia 001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

User Function LP650DB()


Private cSerie, cClaFis, cConta,cTes,cCodigo,cFornece

// Contabilizacao Nota Fiscal se for de Servico ou Devolucao
// Lancamento Padrao 650 sequencia 001
cSerie   := (SD1->D1_SERIE)
cClaFis  := (SD1->D1_CF)
cTes     := (SD1->D1_TES)
cCodigo  := (SD1->D1_COD)
cTipo    := (SD1->D1_TIPO)
cFornece := (SD1->D1_FORNECE)

_cConta  := ""
_cTipo   := ""

Do Case
	Case SUBSTR(cClaFis,2,3) = "201" .OR. SUBSTR(cClaFis,2,3) = "202"
		_cConta := "380010001"

	Case SUBSTR(cClaFis,2,3) = "101"
		_cTipo := POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_TIPO")
		If _cTipo == "ME"
			_cConta := "112000006"
         	//_cConta := "330200004"
		ElseIf _cTipo == "FE"
			_cConta := POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_CONTA")
			//_cConta := "112000005"
		Else
			_cConta := "112000010"
		EndIf

	Case SUBSTR(cClaFis,2,3) = "949"
		If cTipo == "D"
			_cConta := "380010001"
		ElseIf cTipo == "N" .and. cSerie == "A1"
			_cConta := POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_CONTA")
		ElseIf cTipo == "B"
			_cConta := "222000006"
		//INTERCOMPANY - COMPLEMENTO DE MAQUINAS
		ElseIf cTipo == "N" .AND. cFornece == "005144"
			_cConta := "222000006"
		EndIf

	// MERCADORIA EM PODER DE TERCEIROS
	Case SUBSTR(cClaFis,2,3) = "902"
		_cConta := "222000001"
	Case SUBSTR(cClaFis,2,3) = "916"
		_cConta := "222000002"
	Case SUBSTR(cClaFis,2,3) = "913"
		_cConta := "222000003"

	// MERCADORIA DE TERCEIROS
	Case SUBSTR(cClaFis,2,3) = "901"
		_cConta := "115000001"
	Case SUBSTR(cClaFis,2,3) = "915"
		_cConta := "115000002"
	Case SUBSTR(cClaFis,2,3) = "911"
		_cConta := "115000003"	

	OtherWise
	    _cConta := POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_CONTA")

EndCase
 
Return(_cConta)
