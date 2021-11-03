#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³RFATC003 ºAutor ³ Eduardo Mantoan        º Data ³ 30/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RFATC003- Consulta de pedidos de venda conforme o Pedido do°±±
±±ºcliente ou o nome do cliente / Tabelas SC5/SC6/SA1/SB1.                °±±
±±ºÉ filtrado por uma expressão que contem no campo C6_PC ou no campo     °±±
±±ºA1_NREDUZ, ele traz o  pedido e todos os itens contidos nele           °±±
±±º          ³ SC5º±±                                                     °±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATC003()

Local oTable  := Nil

cPerg			:= "XRFATC003"
aCampos		:= {}        
aHeadMBrow	:= {}

IF ! Pergunte(cPerg,.T.)
 	Return
ENDIF
cExpre := UPPER(Alltrim(MV_PAR01))
If Select("TRB") > 0 
   DbSelectArea("TRB")
   DbCloseArea()
EndIf
	AADD(aCampos,{ "C5_NUM"    ,"C", 06,0,"@!" } )
	AADD(aCampos,{ "C6_ITEM"   ,"C", 02,0,"@!" } )	
	AADD(aCampos,{ "C5_CLIENTE"   ,"C", 45,0,"@!" } )
	AADD(aCampos,{ "A1_NREDUZ"    ,"C", 15,0,"@!" } )
	AADD(aCampos,{ "C6_PRODUTO" ,"C", 15,0,"@!" } )
	AADD(aCampos,{ "C5_NOTA" ,"C", 20,0,"@!" } )
	AADD(aCampos,{ "C5_PC"    ,"C", 30,0,"@!" } )
	AADD(aCampos,{ "C6_QTDVEN"    ,"N", 9,0,"@E 99,999.999" } )
	AADD(aCampos,{ "C6_PRCVEN"    ,"N", 14,0,"@E 9,999,999.999999" } )
	AADD(aCampos,{ "C6_VALOR"    ,"N", 14,0,"@E 999,999,999.99" } ) 
	AADD(aCampos,{ "B1_DESC"    ,"C", 35,0,"@!" } ) 

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:Create()

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF   

_cQuery :=" SELECT SC5.C5_NUM, "
_cQuery +=" SC5.C5_CLIENTE, "								
_cQuery +=" SA1.A1_NREDUZ,   "
_cQuery +=" SB1.B1_DESC,   "
_cQuery +=" SC5.C5_NOTA,  "
_cQuery +=" SC5.C5_PC,   "
_cQuery +=" SC6.C6_ITEM, "
_cQuery +=" SC6.C6_PRODUTO, "
_cQuery +=" SC6.C6_QTDVEN, "
_cQuery +=" SC6.C6_PRCVEN, "
_cQuery +=" SC6.C6_VALOR "
_cQuery +=" FROM " + RetSqlName("SC5") + " SC5 "
_cQuery +=" INNER JOIN " + RetSqlName("SA1") + " SA1 "
_cQuery +=" ON SA1.A1_COD = SC5.C5_CLIENTE "
_cQuery +=" INNER JOIN " + RetSqlName("SC6") + " SC6 "
_cQuery +=" ON SC6.C6_NUM = SC5.C5_NUM "
_cQuery +=" INNER JOIN " + RetSqlName("SB1") + " SB1 "
_cQuery +=" ON SB1.B1_COD = SC6.C6_PRODUTO "  
IF MV_PAR02 == 2 
	_cQuery +=" WHERE SA1.A1_NREDUZ LIKE '%" + cExpre + "%' "
Else	
	_cQuery +=" WHERE SC5.C5_PC LIKE '%" + cExpre + "%' "
EndIF	
	_cQuery +=" AND SC5.D_E_L_E_T_ = ''  "
	_cQuery +=" AND SA1.D_E_L_E_T_ = ''  "
	_cQuery +=" AND SB1.D_E_L_E_T_ = ''  "
	_cQuery +=" AND SC6.D_E_L_E_T_ = ''  "
	_cQuery +=" ORDER BY SC5.C5_NUM, SC6.C6_ITEM 

	TcQuery _cQuery New Alias "QR1"

	DO WHILE !QR1->(EOF())
		RecLock("TRB",.T.)
		TRB->C5_NUM			:= QR1->C5_NUM
		TRB->C6_ITEM		:= QR1->C6_ITEM
		TRB->C5_CLIENTE	:= QR1->C5_CLIENTE
		TRB->A1_NREDUZ 	:= QR1->A1_NREDUZ 
		TRB->C5_NOTA		:= QR1->C5_NOTA
		TRB->C5_PC			:= QR1->C5_PC
		TRB->C6_PRODUTO	:= QR1->C6_PRODUTO
		TRB->C6_QTDVEN		:= QR1->C6_QTDVEN
		TRB->C6_PRCVEN		:= QR1->C6_PRCVEN
		TRB->C6_VALOR		:= QR1->C6_VALOR
		TRB->B1_DESC		:= QR1->B1_DESC
		
		TRB->(MSUnlock())
	    
		QR1->(dbSKIP())
    
	ENDDO


QR1->(dbCloseArea())      

MsgRun("Aguarde",,{|| aHeadMBrow := HeadBrow() } )

dbSelectArea("TRB")             
TRB->(dbGoTop())
mBrowse(6,1,22,75,"TRB",aHeadMBrow,,,,,,"","")

TRB->(dbCloseArea())

Ferase(cArqTrab+".DBF")

Return            


Static Function HeadBrow()
Local aHead := {}         

   AAdd( aHead, { "Numero"        		    ,{|| TRB->C5_NUM }      ,"C", 06 , 0, "" } )
   AAdd( aHead, { "Pedido do Cliente"      ,{|| TRB->C5_PC }       ,"C", 30 , 0, "" } )
	AAdd( aHead, { "Cliente"           	    ,{|| TRB->C5_CLIENTE }  ,"C", 06 , 0, "" } )
	AAdd( aHead, { "Nome Fantasia"      	 ,{|| TRB->A1_NREDUZ  }  ,"C", 15 , 0, "" } )
	AAdd( aHead, { "Nota"         			 ,{|| TRB->C5_NOTA }     ,"C", 15 , 0, "" } )
	AAdd( aHead, { "Item"          		    ,{|| TRB->C6_ITEM }     ,"C", 02 , 0, "" } )
	AAdd( aHead, { "Produto" 			       ,{|| TRB->C6_PRODUTO }  ,"C", 20 , 0, "" } )
	AAdd( aHead, { "Desc Produto" 			 ,{|| TRB->B1_DESC }     ,"C", 35 , 0, "" } )
	AAdd( aHead, { "Quantidade"         	 ,{|| TRB->C6_QTDVEN }   ,"N", 09 , 0, "" } )
   AAdd( aHead, { "Preço Unid."         	 ,{|| TRB->C6_PRCVEN }   ,"N", 14 , 0, "" } )
	AAdd( aHead, { "Valor Total"         	 ,{|| TRB->C6_VALOR }    ,"N", 14 , 0, "" } )


Return( aHead )