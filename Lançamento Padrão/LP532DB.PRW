#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP532DB   ºAutor  ³Cida                º Data ³  11/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna Conta contabil em lancamento padrao 532/01          º±±
±±º          ³Baixa de titulos (Bordero)                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP532DB()
                       
_cPref  := Alltrim(SE2->E2_PREFIXO)
_cNat   := Alltrim(SE2->E2_NATUREZ)
_cTipo  := Alltrim(SE2->E2_TIPO)
_cConta := "" 
 
Do Case
	Case _cNat == "ISS"
	   If _cTipo == "ISS"         // Nota de entrada
    	  _cConta := "220400009"
	   ElseIf _cTipo == "TX"      // Nota de Saida de Servicos
	       _cConta := "220400003"
	   EndIf
	Case _cNat $ "PIS_COFINS_CSLL"
	   If _cTipo == "TX"          // Nota de Saida de Servicos
	      _cConta := "220400005"
	   EndIf
	Case _cNat == "IRF"
	   If _cTipo == "TX"         // Nota de Saida de Servicos
	      _cConta := "220300002"
	   EndIf
	Case _cNat == "B09"
		If _cPref = "885"
		   _cConta := SED->ED_CONTA
		ElseIf _cPref = "883"
			_cConta := "370010001"
		EndIf
	OtherWise
   		_cConta := SA2->A2_CONTA
EndCase
 
Return(_cConta)


// Contabiliza ISS 
/*If _cNat == "ISS"
   If _cTipo == "ISS"         // Nota de entrada
      _cConta := "220400009"
   ElseIf _cTipo == "TX"      // Nota de Saida de Servicos
       _cConta := "220400003"
   EndIf
ElseIf _cNat $ "PIS_COFINS_CSLL"
   If _cTipo == "TX"      // Nota de Saida de Servicos
      _cConta := "220400005"
   EndIf
ElseIf _cNat == "IRF"
   If _cTipo == "TX"      // Nota de Saida de Servicos
      _cConta := "220300002"
   EndIf
ElseIf _cNat == "B09"
   _cConta := SED->ED_CONTA
Else
   _cConta := SA2->A2_CONTA
EndIf   
*/


