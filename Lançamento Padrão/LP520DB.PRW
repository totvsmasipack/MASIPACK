#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP520DB   ºAutor  ³ Cecilia            º Data ³  18/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno de conta contabil em lancamento padro-º±±
±±º          ³nizado 520 - sequencia 05  - Debito                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

User Function LP520DB(_nSeq)

Private  _cCli,_cContaCr,_cContaDb,_cHist,_nValor,_cTpDoc

_cAliasold:= alias()
_cConta   := ""
_cTpDoc   := SE1->E1_TIPO
_cSeq     := Alltrim(CT5->CT5_SEQUEN)
_cCli     := SE1->E1_CLIENTE
_cLoja    := SE1->E1_LOJA 
_cTpCli   := " "
_cTpLanc   := Alltrim(CT5->CT5_DC)

// Contabiliza se for Cliente de exportacao com variacao cambial

If _nSeq == 5
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
	  _cTpCli := SA1->A1_EST
   EndIf  
   
	If _cTpDoc = "RA" .and. _cTpCli = "EX"
		If SE1->E1_ACRESC > 0
			_cConta := "370010014"
		ElseIf SE1->E1_DECRESC > 0
			_cConta := "110400002"
		Endif
	Endif
	   
ElseIf _nSeq == 4

	If (SE5->E5_MOTBX) == "FAT"
		_cConta := "110400008"

	ElseIf SE5->E5_MOTBX == 'DEB' .AND. SE5->E5_TIPO = "NCC"
		_cConta := "220900009"

	ElseIf SE5->E5_MOTBX == 'DEB'
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SE5->E5_CLIENTE+SE5->E5_LOJA))
		If ALLTRIM(SE5->E5_NATUREZ) == 'L01'
			If SA1->A1_EST == 'EX'
				_cConta := "220900003"
			Else
				_cConta := "220900001"
			EndIf
		Else
			_cConta := SA6->A6_CONTA
		EndIf

	ElseIf SE5->E5_MOTBX == 'LIQ'
		_cConta := "220900001"
	Else
		_cConta := SA6->A6_CONTA	
 	EndIf
	 
ElseIf _nSeq == 3

	If SE5->E5_MOTBX == 'DEB' .AND. ALLTRIM(SE5->E5_NATUREZ) == 'L01'
		_cConta := 'C'+_cCli
	ElseIf SE5->E5_MOTBX == 'DEB' .AND. SE5->E5_TIPO = "NCC"
		_cConta := 'C'+_cCli
 	EndIf

Endif 
 
Return(_cConta)
