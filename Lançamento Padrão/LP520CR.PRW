#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP520CR   ºAutor  ³ Cecilia            º Data ³  18/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno de conta contabil em lancamento padro-º±±
±±º          ³nizado 520 - sequencia 05 - Credito                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

User Function LP520CR(_nSeq)

Private  _cCli,_cHist,_nValor,_cTpDoc

//_cContaCr,_cContaDb,
//_cHist     := "" 

_cAliasold:= alias()
_cConta    := ""
_cTpDoc    := SE1->E1_TIPO
_cSeq      := Alltrim(CT5->CT5_SEQUEN)
_cCli      := SE1->E1_CLIENTE
_cLoja     := SE1->E1_LOJA 
_cTpCli    := " "

// Contabiliza se for Cliente de exportacao com variacao cambial
If _nSeq == 5
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
	  _cTpCli := SA1->A1_EST
   EndIf  
   
   If _cTpDoc = "RA" .and. _cTpCli = "EX"
    If SE1->E1_ACRESC > 0
       _cConta := "110400002"
    ElseIf SE1->E1_DECRESC > 0
       _cConta := "440310001"
    Endif
   Endif

ElseIf _nSeq == 1
		If (SE5->E5_NATUREZ) = "V14" 
			//If (SE5->E5_HISTOR) $ "Bx.Emis.Fat."
			If (Substr(SE5->E5_FATURA,7,1) == "B"  )
				_cConta := "110400001"
			Else				
				_cConta := SED->ED_CONTA
			EndIf
      ElseIf (SE5->E5_NATUREZ) = "V15"
				If (Substr(SE5->E5_FATURA,7,1) == "A"  )
			      _cConta := "110400001"
			   Else
					_cConta := SED->ED_CONTA
				EndIf
		ElseIf (SE5->E5_NATUREZ) <> "V14" .AND. (SE5->E5_NATUREZ) <> "V15"
			//VICTOR DESSUNTE - 07/10/2016
			//INICIO - TICKET: 2016091937000074
			If SE5->E5_MOTBX == 'DEB' //.AND. ALLTRIM(SE5->E5_NATUREZ) == 'L01'
				_cConta := SA6->A6_CONTA
			Else
				//VICTOR DESSUNTE - 24/04/2017
				//INICIO - TICKET: 2017040437000046 
				If SE5->E5_PREFIXO == 'JRS' //JUROS
					_cConta := '440210001'
				Else
					SA1->(DbSetOrder(1))
					If SA1->(DbSeek(xFilial("SA1")+SE5->E5_CLIENTE+SE5->E5_LOJA))
						_cConta := SA1->A1_CONTA
					EndIf
				EndIf
				//FIM - TICKET: 2017040437000046
		 	EndIf
		 	//FIM - TICKET: 2016091937000074
		EndIf
ElseIf _nSeq == 4
	//VICTOR DESSUNTE - 17/10/2016
	//INICIO - TICKET: 2016091937000074
	If SE5->E5_MOTBX == 'DEB' .OR. SE5->E5_PREFIXO == 'JRS' //.AND. ALLTRIM(SE5->E5_NATUREZ) == 'L01'
		_cConta := ''
	Else
		_cConta := 'C'+_cCli
 	EndIf
 	//FIM - TICKET: 2016091937000074
Endif 

Return(_cConta)
