
#Include "Protheus.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATG034  ºAutor  ³Lizandra Marques    º Data ³  09/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VERIIVA SE A MOEDA ULTILIZADA NO ORÇCAMENTO É A MESMA DA   º±±
±±º            TABELA                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG034()

_aArea  := GetArea()   
_nMoeda := 0

IF INCLUI
	Private _nMoeda := M->CJ_MOEDA
	Private _cTabela:= M->CJ_TABELA
//	Private _cVAR1  := M->CJ_ORCAM
ELSE	
	Private _nMoeda := SCJ->CJ_MOEDA
	Private _cTabela:= SCJ->CJ_TABELA
//	Private _cVAR1  := SCJ->CJ_ORCAM
ENDIF

DA1->(dbSetOrder(1))
IF DA1->(dbSeek(xFilial("DA1")+_cTabela))
	IF DA1->DA1_MOEDA <> _nMOEDA
		ApMsgAlert("Moeda do orçamento diferente da moeda da tabela de preço. Verifique.")
		_nMoeda := DA1->DA1_MOEDA
	ENDIF
ELSE		
	ApMsgAlert("Não existe itens para essa Tabela de Preço. Verifique.")
ENDIF	     

RestArea(_aArea)

Return(_nMoeda)