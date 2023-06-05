#Include "Protheus.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATG041  ºAutor  ³Lizandra Marques    º Data ³  03/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera valor unitário de acordo com a condição de pagamentoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG041()

_aArea := GetArea()     

_nDias := 0                    
_nPrcV := 0

dbSelectArea("DA1")
DA1->(dbSetOrder(1))
IF dbSeek(xFilial("DA1")+M->CJ_TABELA+TMP1->CK_PRODUTO)
	//Ivandro Santos - 11/11/16 - Início da alteração
	//Ticket#2016111137000182 — PROBLEMAS P/ EFETIVAR O ORÇAMENTO_nDesc := M->CJ_DESC1+M->CJ_DESC2+M->CJ_DESC3+M->CJ_DESC4
	_nPrcTab := _nPrcV := DA1->DA1_PRCVEN
	_nDesc:=M->CJ_DESC1+M->CJ_DESC2+M->CJ_DESC3+M->CJ_DESC4
	IIF(_nDesc>0,_nPrcV:=DA1->DA1_PRCVEN-(DA1->DA1_PRCVEN*(_nDesc/100)),_nPrcV:=DA1->DA1_PRCVEN)
	//Ticket#2016111137000182 — Fim da alteração
ENDIF	

_nDias := Posicione("SE4",1,xFilial("SE4")+M->CJ_CONDPAG,"E4_DIASCOR")

IF DA1->DA1_MOEDA == 1
	//Ivandro Santos - 10/11/16 - Inicio da alteração
	//Ticket#2016110937000285 — Problemas para gerar orçamentos
	_nVlrAl := TMP1->CK_PRCVEN	
	IF _nDias == 45
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.05.Or._nVlrAl==_nPrcV,_nPrcV*1.05,TMP1->CK_PRCVEN)//_nPrcV  * 1.05
	ELSEIF _nDias == 60	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.10.Or._nVlrAl==_nPrcV,_nPrcV*1.10,TMP1->CK_PRCVEN)//_nPrcV  * 1.10
	ELSEIF _nDias == 70	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.15.Or._nVlrAl==_nPrcV,_nPrcV*1.15,TMP1->CK_PRCVEN)//_nPrcV  * 1.15
	ELSEIF _nDias == 90	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.20.Or._nVlrAl==_nPrcV,_nPrcV*1.20,TMP1->CK_PRCVEN)//_nPrcV  * 1.20
	ELSEIF _nDias == 120	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.25.Or._nVlrAl==_nPrcV,_nPrcV*1.25,TMP1->CK_PRCVEN)//_nPrcV  * 1.25
	ELSEIF _nDias == 180	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.35.Or._nVlrAl==_nPrcV,_nPrcV*1.35,TMP1->CK_PRCVEN)//_nPrcV  * 1.35
	ENDIF
	//Ticket#2016110937000285 — Fim da alteração
	//Ivandro Santos - 11/11/16 - Início da alteração
	//Ticket#2016111137000182 — PROBLEMAS P/ EFETIVAR O ORÇAMENTO
	If _nDias = 45 .Or. _nDias = 60 .Or. _nDias = 70 .Or. _nDias = 90 .Or. _nDias = 120 .Or. _nDias = 180
		TMP1->CK_PRUNIT := TMP1->CK_PRCVEN
	Else
		TMP1->CK_PRUNIT := _nPrcTab
	Endif
	//Ticket#2016111137000182 — Fim da alteração  
	TMP1->CK_VALOR	 := TMP1->CK_PRCVEN * TMP1->CK_QTDVEN
ENDIF

RestArea(_aArea)

Return(TMP1->CK_PRCVEN)
