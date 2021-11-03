/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMG010  ºAutor  ³Eduardo Bego Mantoanº Data ³  17/07/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Funcao para Atualizar Campo C7_MSPREC2								  .±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
#Include "Rwmake.ch"
#Include "Topconn.ch"    
#INCLUDE "PROTHEUS.CH"

User Function RCOMG010(cProd,_nPreco1,nItem1) 
//Ivandro Santos - 18/11/16 - Início da alteração
//Ticket#2016111637000182 — Pedido de Compras na Helsimplast
DEFAULT _nPreco1  := 0                                      
//Ticket#2016111637000182 — Fim da alteração

Private aAreaAtu := GetArea()
Private cCampo   := READVAR()
Private nValor   := 0  
Private nValida  := 0 

DbSelectArea("SC7")  
/*While nValida = 0 

	If	 cProd == SC7->C7_PRODUTO .AND. nItem1 = SC7->C7_ITEM 
		
		
   	nValida  := 1
	Else
	 
		SC7->(DbSkip())
		
	EndIf
EndDo   */
				  
DbSelectArea("SB1")   	           
dbSeek(xFilial("SB1")+cProd,.t.) 

If "PRECO" $ cCampo  

	If SB1->B1_CONV > 0
		If SB1->B1_TIPCONV == "M"
			nValor := _nPreco1 * SB1->B1_CONV   	
		ElseIf SB1->B1_TIPCONV == "D"
			nValor := _nPreco1 / SB1->B1_CONV 
		EndIf 
	EndIf  
	DbSelectArea("SC7")
	
	If !Empty(SB1->B1_SEGUM)
		M->C7_MSPREC2 := nValor
	EndIf
ElseIf "MSPREC2" $ cCampo   
	If SB1->B1_CONV > 0
		If SB1->B1_TIPCONV == "M"
			nValor := _nPreco1 / SB1->B1_CONV   	
		ElseIf SB1->B1_TIPCONV == "D"
			nValor := _nPreco1 * SB1->B1_CONV 
			
		EndIf 
	EndIf 
	DbSelectArea("SC7")
	
	If !Empty(SB1->B1_SEGUM)
		M->C7_PRECO := nValor 
    Endif
//Ivandro Santos - 29/09/16 - Inicio da alteração
//Ticket#2016092937000304 — intercompany
ElseIf "C7_IPI" $ cCampo .Or. "C7_QUANT" $ cCampo .Or. "C7_PRODUTO" $ cCampo
//ElseIf "C7_IPI" $ cCampo .Or. "C7_QUANT" $ cCampo
//Ticket#2016092937000304 — fim da alteração
	//Ivandro Santos - 23/05/2017
	//Ticket#2016120937000032 — Pedidos intercompany
	/*CCODTAB	 := GetMv("MS_CODTABI")
	CFORNECE := cA120Forn		// CODIGO DO FORNECEDOR
	CLOJAFOR := cA120Loj		// LOJA DO FORNECEDOR
 	_CCGC 	 := GetAdvFval("SA2","A2_CGC",xFilial("SA2")+CFORNECE+CLOJAFOR,1," ")
    IF _CCGC $ "58071614000144_43222439000171_51317402000155"
		nValor := Posicione('DA1',1,xFilial('DA1')+Alltrim(CCODTAB)+cProd,'DA1_PRCVEN'," ")	*/
	//IVANDRO SANTOS - 27/09/16 - Inicio da alteração
	//Ticket#2016092737000148 — PEDIDO DE COMPRA MASI E FABRIMA
	//ELSE
	nValor := _nPreco1
	//Ticket#2016092737000148 — Fim da alteração
	//EndIf
	DbSelectArea("SC7")
	nValor := IIF(nValor==0,1,nValor)
	//Ticket#2016120937000032 — Fim da alteração
EndIf 

RestArea(aAreaAtu)  

Return nValor
