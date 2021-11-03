#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMG007  ºAutor  ³Lizandra Marques    º Data ³  24/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VERIFICA QUANTIDADE A SER COMPRADA - C1_QUANT              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMG007()

_aArea  := GetArea()  

_nEstSeg := 0
_nLM	 := 0
_nLE	 := 0
_nQE	 := 0

_nQuant	:= Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C1_QUANT"})
_nQtde	:= acols[n,_nQuant]
_cCod	:= Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C1_PRODUTO"})
_cCod1	:= acols[n,_cCod]   

dbSelectArea("SB1")	
SB1->(dbSetOrder(1))  
IF SB1->(dbSeek(xFilial("SB1")+_cCod1))
	_nEstSeg := SB1->B1_ESTSEG
	_nLM	 := SB1->B1_LM
	_nLE	 := SB1->B1_LE
ENDIF	

dbSelectArea("SB2")	
SB2->(dbSetOrder(1))
IF SB2->(dbSeek(xFilial("SB2")+_cCod1+"01"))
	IF _nQtde + (SB2->B2_QATU - _nEstSeg) > (SB2->B2_QEMP + SB2->B2_RESERVA + SB2->B2_QPEDVEN)
		apmsgAlert("Quantidade maior que empenhos." +  CHR(13) + CHR(10) + ;
		"Saldo Atual        : " + TRANSFORM(SB2->B2_QATU    ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Estoq.Seg.         : " + TRANSFORM(_nEstSeg        ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Empenho            : " + TRANSFORM(SB2->B2_QEMP    ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Pedido de Venda: " + TRANSFORM(SB2->B2_QPEDVEN ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Reserva             : " + TRANSFORM(SB2->B2_RESERVA ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Qtde.Solicitada   : " + TRANSFORM(_nQtde          ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Lote Minimo       : " + TRANSFORM(_nLM            ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Lote Economico    : " + TRANSFORM(_nLE            ,"@E 9,999,999.99")+  CHR(13) + CHR(10) + ;
		"Qtde. Embalagem   : " + TRANSFORM(_nQE            ,"@E 9,999,999.99"))
    ENDIF
ENDIF  

RestArea(_aArea)

Return(_nQtde)
