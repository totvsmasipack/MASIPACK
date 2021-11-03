#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP510CR   ºAutor  ³Cecilia             º Data ³  08/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para retorno de conta contabil em lancamento padro-º±±
±±º          ³nizado 510. CT.PG.-IMPLANT.TITULO.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP510cr()

Private _cRet

_cRet := ""

If SE2->E2_PREFIXO == "885" .OR. SE2->E2_PREFIXO = "883"		//acrescentado clausula .or. em 04/11/10 por FMD para atender situacoes do fornecedor Banco Industrial
	If SE2->E2_TIPO= "DP"
		DO CASE
			CASE SE2->E2_FORNECE = '004201'
				_cRet := "221400001"
			CASE SE2->E2_FORNECE = '004208'
				_cRet := "221400004"
			CASE SE2->E2_FORNECE = '004196'
				_cRet := "221400005"
			CASE SE2->E2_FORNECE = '004195'
				_cRet := "221400003"
			CASE SE2->E2_FORNECE = '004115'
				_cRet := "221400002"
			CASE SE2->E2_FORNECE = '003686'
				_cRet := "221400004"
			CASE SE2->E2_FORNECE = '004198'
				_cRet := "221400006"
			CASE SE2->E2_FORNECE = '004682'
				_cRet := "221400009"
			CASE SE2->E2_FORNECE = '004764'
				_cRet := "221400008"
			CASE SE2->E2_FORNECE = '004197'
				_cRet := "221400011"
		ENDCASE
	Endif
Endif

Return(_cRet)