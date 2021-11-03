#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³RFATC004 ºAutor ³ Eduardo Mantoan        º Data ³ 30/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RFATC004- Consulta de NF de venda conforme o Pedido do     °±±
±±º																			              °±±
±±º          ³ SC5º±±                                                     °±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATC004()

cPerg			:= "XRFATC004"
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

	AADD(aCampos,{ "D2_PEDIDO"    ,"C", 06,0,"@!" } )
	AADD(aCampos,{ "D2_COD"   		,"C", 45,0,"@!" } )
	AADD(aCampos,{ "D2_ITEM"   	,"C", 02,0,"@!" } )	
	AADD(aCampos,{ "D2_CLIENTE"   ,"C", 06,0,"@!" } )
	AADD(aCampos,{ "D2_LOJA"   	,"C", 02,0,"@!" } )
	AADD(aCampos,{ "A1_NREDUZ"    ,"C", 25,0,"@!" } )
	AADD(aCampos,{ "D2_EMISSAO" 	,"D", 08,0,"@!" } )
	AADD(aCampos,{ "D2_DOC" 		,"C", 20,0,"@!" } )
	
	//AADD(aCampos,{ "C5_PC"    ,"C", 30,0,"@!" } )
   //AADD(aCampos,{ "C6_QTDVEN"    ,"N", 9,0,"@E 99,999.999" } )
   //AADD(aCampos,{ "C6_PRCVEN"    ,"N", 14,0,"@E 9,999,999.999999" } )
   //AADD(aCampos,{ "C6_VALOR"    ,"N", 14,0,"@E 999,999,999.99" } ) 
	//AADD(aCampos,{ "B1_DESC"    ,"C", 35,0,"@!" } ) 

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:Create()

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF   

_cQuery := " SELECT D2_DOC,D2_PEDIDO,D2_ITEM,D2_CLIENTE,D2_LOJA,A1_NREDUZ,D2_EMISSAO,D2_COD,D2_LOJA  "
_cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = D2_CLIENTE AND D2_LOJA = A1_LOJA AND A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_='' "
_cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D_E_L_E_T_='' "
_cQuery += " AND D2_PEDIDO = '"+MV_PAR01+"' "
_cQuery += " ORDER BY D2_DOC,D2_ITEM  "


TcQuery _cQuery New Alias "QR1"
TcSetField("QR1","D2_EMISSAO"   ,"D",08,00)
	DO WHILE !QR1->(EOF())
		RecLock("TRB",.T.)
		TRB->D2_DOC			:= QR1->D2_DOC
		TRB->D2_PEDIDO		:= QR1->D2_PEDIDO
		TRB->D2_COD			:= QR1->D2_COD
		TRB->D2_ITEM		:= QR1->D2_ITEM
		TRB->D2_CLIENTE	:= QR1->D2_CLIENTE
		TRB->D2_LOJA		:= QR1->D2_LOJA
		TRB->A1_NREDUZ 	:= QR1->A1_NREDUZ 
		TRB->D2_EMISSAO	:= QR1->D2_EMISSAO
		
		
			
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
                  


	
   AAdd( aHead, { "Nota"        		   ,{|| TRB->D2_DOC 		}  ,"C", 20 , 0, "" } )
   AAdd( aHead, { "Produto"      		,{|| TRB->D2_COD 		}  ,"C", 45 , 0, "" } )
	AAdd( aHead, { "Item"           	   ,{|| TRB->D2_ITEM 	}  ,"C", 02 , 0, "" } )
	AAdd( aHead, { "Cod Cliente"      	,{|| TRB->D2_CLIENTE	} 	,"C", 06 , 0, "" } )
	AAdd( aHead, { "Loja"         		,{|| TRB->D2_LOJA 	}  ,"C", 02 , 0, "" } )
	AAdd( aHead, { "Nome Cliente"       ,{|| TRB->A1_NREDUZ 	}  ,"C", 25 , 0, "" } )
	AAdd( aHead, { "Emissão" 			   ,{|| TRB->D2_EMISSAO }  ,"D", 08 , 0, "" } )
	AAdd( aHead, { "Pedido de Venda" 	,{|| TRB->D2_PEDIDO 	}  ,"C", 06 , 0, "" } )



Return( aHead )