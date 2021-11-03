#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º   F080EST2       º AUTOR º FABIO MARCELO DIAS    º DATA º  06/01/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º DESCRICAO    º PROGRAMA PARA TRATAR VALORES NO CANCELAMENTO DA BAIXA A PAGAR MANUAL º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º TABS.UTILIZ  º DESCRICAO                                                   º ACESSO º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÎÍÍÍÍÍÍÍÍÍÍ¹±±
±±º    SE2       º CONTAS A PAGAR                                              º READ   º±±
±±º    SM2       º CADASTRO DE MOEDAS                                          º READ   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÎÍÍÍÍÍÍ¹±±
±±º HISTORICO    º 05/01/2011 CRIAÇÃO.                                                  º±±
±±º              º                                                                      º±±
±±º  		     º                                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍ¹±±
±±º USO          º MODULO FINANCEIRO                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROPRIETARIO º CUSTOMIZADO PARA MASIPACK                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION F080EST2()

	LOCAL AAREASE2	:= {}
	LOCAL AAREASEA	:= {}  

	AAREASE2 := SE2->(GETAREA())
	AAREASEA := SEA->(GETAREA())

	IF SE2->E2_MSMOEFI > 1
		RECLOCK("SE2",.F.)
		DO CASE
			CASE SE2->E2_MSMOEFI == 2
				SE2->E2_MOEDA	:= 2
				SE2->E2_MSMOEFI := 1
			
			CASE SE2->E2_MSMOEFI == 3
				SE2->E2_MOEDA	:= 3
				SE2->E2_MSMOEFI := 1
				
			CASE SE2->E2_MSMOEFI == 4
				SE2->E2_MOEDA	:= 4
				SE2->E2_MSMOEFI := 1
				
			CASE SE2->E2_MSMOEFI == 5
				SE2->E2_MOEDA	:= 5
				SE2->E2_MSMOEFI := 1
		END CASE

		IF SE2->E2_ACRESC == ROUND(NOROUND(SE2->E2_VLCRUZ - SE2->E2_VALOR,3),2)
			SE2->E2_ACRESC := 0
		ELSE
			SE2->E2_ACRESC -= ROUND(NOROUND(SE2->E2_VLCRUZ - SE2->E2_VALOR,3),2)
		ENDIF

		SE2->E2_SALDO	:= SE2->E2_VALOR
		SE2->E2_VLCRUZ	:= SE2->E2_VALOR
		SE2->(MSUNLOCK())

	ENDIF

	RESTAREA(AAREASE2)
	RESTAREA(AAREASEA)

RETURN()