#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º   RFATA050      º AUTOR º FABIO MARCELO DIAS    º DATA º  07/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º DESCRICAO    º PROGRAMA PARA APRESENTAR O NOME DO CLIENTE NO PEDIDO DE VENDA        º±±
±±º              º NO MOMENTO DA VISUALIZACAO, ALTERACAO OU EXCLUSAO (CAMPO C5_MSCLIEN) º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º TABS.UTILIZ  º DESCRICAO                                                   º ACESSO º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÎÍÍÍÍÍÍÍÍÍÍ¹±±
±±º    SC5       º PEDIDO DE VENDA                                             º READ   º±±
±±º    SA1       º CADASTRO DE CLIENTES                                        º READ   º±±
±±º    SA2       º CADASTRO DE FORNECEDORES                                    º READ   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÎÍÍÍÍÍÍ¹±±
±±º HISTORICO    º 07/12/2010 CRIAÇÃO.                                                  º±±
±±º              º                                                                      º±±
±±º  		     º                                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍ¹±±
±±º USO          º MODULO FATURAMENTO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROPRIETARIO º CUSTOMIZADO PARA MASIPACK                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION RFATA050()

	LOCAL CCLIFOR := ""
	
	//IF !INCLUI
		IF SC5->C5_TIPO $ "NIPC"  // TRATA-SE DE CODIGO DE CLIENTE
		   IF SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
	    	  CCLIFOR := SA1->A1_NREDUZ
		   ENDIF
		ELSE
		   IF SA2->(DBSEEK(XFILIAL("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
		      CCLIFOR := SA2->A2_NREDUZ
		   ENDIF
		ENDIF
	//ENDIF

RETURN(CCLIFOR)