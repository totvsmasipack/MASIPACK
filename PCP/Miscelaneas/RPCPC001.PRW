#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPCPC001()  º Eduardo Bego Mantoan   º Data ³ 19/11/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Browse Calculo de tempo padrão da usinagem  			      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

User Function RPCPC001()  

Private cPerg := "XRPCPC001" 
                                                                
Pergunte(cPerg,.T.)

PROCESSA( {|| u_GeraBrow()}, "Aguarde...","Processando registros", .T. )
//MsgRun("Processando registros...",, {|| GeraBrow()}) // 
//Bloco:={|lEnd| GeraBrow() }
//MsAguarde(Bloco,"Aguarde","Processando...",.t.)
//RptStatus({|| u_GeraBrow() }, "Aguarde...", "Processando registros...", .T. )

Return


User Function GeraBrow()

Local aCampos		:= {} 
Local aHeadMBrow	:= {}

If Select("TRB") > 0 
   DbSelectArea("TRB")
   DbCloseArea()
EndIf  

AADD(aCampos,{ "G2_CODIGO"       ,"C", 02,0,"@!" } )
AADD(aCampos,{ "G2_PRODUTO"      ,"C", 15,0,"@!" } )
AADD(aCampos,{ "G2_RECURSO"      ,"C", 15,0,"@!" } )
AADD(aCampos,{ "H1_DESCRI"       ,"C", 30,0,"@!" } )
AADD(aCampos,{ "G2_LOTEPAD"      ,"N", 06,0,"@!" } )
AADD(aCampos,{ "TOTALH"          ,"N", 10,5,"@E 9999.99999" } )
AADD(aCampos,{ "TOTALM"          ,"N", 10,5,"@E 9999.99999" } )
AADD(aCampos,{ "TOTSH"           ,"N", 10,5,"@E 9999.99999" } )
AADD(aCampos,{ "TOTSM"           ,"N", 10,5,"@E 9999.99999" } )

oTable := FWTemporaryTable():New("TRB",aCampos)
oTable:AddIndex( "IND1", {"G2_PRODUTO"} )
oTable:Create()

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF   

//_cQuery := " SELECT G2_CODIGO,G2_PRODUTO,G2_LOTEPAD,SUM(G2_TEMPAD) AS TOTAL   "
_cQuery := " SELECT G2_CODIGO,G2_PRODUTO,G2_LOTEPAD,G2_RECURSO,G2_TEMPAD AS TOTAL,G2_SETUP   "
_cQuery += " FROM " + RetSqlName("SG2") + " G2  "
_cQuery += " WHERE G2_FILIAL = '" + xFilial("SG2") + "' AND G2.D_E_L_E_T_=''  "
_cQuery += " AND G2_RECURSO LIKE 'U%'  "
_cQuery += " AND G2_PRODUTO NOT LIKE '        '   " 
_cQuery += " AND G2_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
//_cQuery += " GROUP By G2_CODIGO,G2_PRODUTO,G2_LOTEPAD   "
_cQuery += " ORDER BY G2_PRODUTO, G2_CODIGO  "



TcQuery _cQuery New Alias "QR1"  
DBSELECTAREA("QR1")
QR1->(DBGOTOP())  
//cArqTrab := CriaTrab(,.F.)       
//IndRegua("QR1",cArqTrab,"G2_PRODUTO")  


ProcRegua(RECCOUNT())
cDesc:= "" 


DO WHILE !QR1->(EOF())
	IncProc()
	DBSELECTAREA("SH1")
	DBSETORDER(1)
	SH1->(DBSEEK(xFilial("SH1")+QR1->G2_RECURSO))
	cDesc := SH1->H1_DESCRI
	
	RecLock("TRB",.T.)  
		
	TRB->G2_CODIGO		:= QR1->G2_CODIGO
	TRB->G2_PRODUTO		:= QR1->G2_PRODUTO
	TRB->G2_LOTEPAD		:= QR1->G2_LOTEPAD
	TRB->G2_RECURSO		:= QR1->G2_RECURSO 
	TRB->H1_DESCRI      := cDesc
	TRB->TOTALH 		:= QR1->TOTAL             
	TRB->TOTALM		    := QR1->TOTAL * 60   
	TRB->TOTSH		    := QR1->G2_SETUP 
	TRB->TOTSM		    := QR1->G2_SETUP * 60
	TRB->(MSUnlock())
    
	QR1->(dbSKIP())
    
ENDDO   


      

MsgRun("Aguarde",,{|| aHeadMBrow := HeadBrow() } )

dbSelectArea("TRB")             
TRB->(dbGoTop()) 

mBrowse(6,1,22,75,"TRB",aHeadMBrow,,,,,,"","")

TRB->(dbCloseArea())

//dbSelectArea("QR1")             
//QR1->(dbGoTop()) 

//mBrowse(6,1,22,75,"QR1",aHeadMBrow,,,,,,"","")

QR1->(dbCloseArea())
Return            


Static Function HeadBrow()
Local aHead := {}         
                  
/*
	AAdd( aHead, { "Código"        		   			,{|| QR1->G2_CODIGO } ,"C", 02,0,"@!" 			} )
    AAdd( aHead, { "Produto"      		   			,{|| QR1->G2_PRODUTO} ,"C", 15,0,"@!" 			} )
	AAdd( aHead, { "Lote Padrão"           			,{|| QR1->G2_LOTEPAD} ,"N", 06,0,"@!" 			} )
	AAdd( aHead, { "Tempo total Usinagem - Horas"   ,{|| QR1->TOTAL  	} ,"N", 10,5,"@E 9999.99999"} )
	AAdd( aHead, { "Tempo total Usinagem - Minutos" ,{|| QR1->TOTAL * 60} ,"N", 10,5,"@E 9999.99999"} )
	*/
    AAdd( aHead, { "Código"        		   ,{|| TRB->G2_CODIGO 	} 		,"C", 02,0,"@!" } )
    AAdd( aHead, { "Produto"      		   ,{|| TRB->G2_PRODUTO } 		,"C", 15,0,"@!" } )
    AAdd( aHead, { "Recusro"      		   ,{|| TRB->G2_RECURSO}  	    ,"C", 15,0,"@!" } )
    AAdd( aHead, { "Descrição"      	   ,{|| TRB->H1_DESCRI } 		,"C", 30,0,"@!" } )
	//AAdd( aHead, { "Lote Padrão"           ,{|| TRB->G2_LOTEPAD } 		,"N", 06,0,"@!" } )
	AAdd( aHead, { "Tempo por peça Usinagem - Horas"   ,{|| TRB->TOTALH }  ,"N", 10,5,"@E 9999.99999" } )
	AAdd( aHead, { "Tempo por peça Usinagem - Minutos" ,{|| TRB->TOTALM }  ,"N", 10,5,"@E 9999.99999" } )
	AAdd( aHead, { "Tempo SETUP por peça Usinagem - Horas"   ,{|| TRB->TOTSH }  ,"N", 10,5,"@E 9999.99999" } )
	AAdd( aHead, { "Tempo SETUP por peça Usinagem - Minutos" ,{|| TRB->TOTSM }  ,"N", 10,5,"@E 9999.99999" } )
	

    

Return( aHead )