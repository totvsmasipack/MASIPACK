#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º   F240FIL        º AUTOR º FABIO MARCELO DIAS    º DATA º  07/01/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º DESCRICAO    º PROGRAMA PARA FILTRAR TITULOS NA GERAÇÃO DO BORDERO A PAGAR          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º TABS.UTILIZ  º DESCRICAO                                                   º ACESSO º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÎÍÍÍÍÍÍÍÍÍÍ¹±±
±±º    SE2       º CONTAS A PAGAR                                              º READ   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÎÍÍÍÍÍÍ¹±±
±±º HISTORICO    º 07/01/2011 CRIAÇÃO.                                                  º±±
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

USER FUNCTION F240FIL()

	LOCAL AAREASEA	:= SEA->(GETAREA())
	LOCAL CMV_PAR01 := MV_PAR01		//ARMAZENO O CONTEUDO DOS PARAMETROS DA PERGUNTA FA100E PARA NAO PERDER O CONTEUDO
	LOCAL CMV_PAR02 := MV_PAR02
	LOCAL CMV_PAR03 := MV_PAR03
	LOCAL CMV_PAR04 := MV_PAR04
	LOCAL CMV_PAR05 := MV_PAR05
	LOCAL CMV_PAR06 := MV_PAR06
	LOCAL CMV_PAR07 := MV_PAR07
	LOCAL CMV_PAR08 := MV_PAR08
	LOCAL CMV_PAR09 := MV_PAR09
	LOCAL CPERG		:= "F240FIL"
	LOCAL CFILTRO	:= ""

	IF PERGUNTE(CPERG, .T., "Filtro por Fornecedor")
		CFILTRO += ' E2_FORNECE >= "'+ALLTRIM(MV_PAR01)+'" .AND. E2_LOJA >= "'+ALLTRIM(MV_PAR02)+'" .AND. E2_FORNECE <= "'+ALLTRIM(MV_PAR03)+'" .AND. E2_LOJA <= "'+ALLTRIM(MV_PAR04)+'" '
	ENDIF

	MV_PAR01 := CMV_PAR01		//RETORNO O CONTEUDO AOS PARAMETROS
	MV_PAR02 := CMV_PAR02
	MV_PAR03 := CMV_PAR03
	MV_PAR04 := CMV_PAR04
	MV_PAR05 := CMV_PAR05
	MV_PAR06 := CMV_PAR06
	MV_PAR07 := CMV_PAR07
	MV_PAR08 := CMV_PAR08
	MV_PAR09 := CMV_PAR09

	RESTAREA(AAREASEA)
	
RETURN(CFILTRO)