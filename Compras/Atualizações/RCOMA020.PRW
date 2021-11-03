#Include "Rwmake.ch"
#Include "Topconn.ch" 
#Include "PROTHEUS.CH"

#define _CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMA020  ºAutor  ³Eduardo Mantoan º Data ³  14/05/15      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza pré-nota			  											  º±±
±±º          ³    							                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function RCOMA020()     
Local lOk := .T.
		
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf 
  	       
	cQuery := " SELECT R_E_C_N_O_ AS REC, D1_MSOBS"
	cQuery += " FROM " + RetSqlName("SD1") + "  SD1 "
	//cQuery += " INNER JOIN " + RetSqlName("SB1") + "  SB1 ON  B1_COD = G1_COMP AND SB1.D_E_L_E_T_='' AND B1_FILIAL='" + xFilial("SB1") + "' "
	cQuery += " WHERE D1_DOC = '"+alltrim(SF1->F1_DOC)+"' " 
	cQuery += " AND D1_FORNECE = '"+ALLTRIM(SF1->F1_FORNECE)+"' "
	cQuery += " AND SD1.D_E_L_E_T_='' "
	cQuery += " AND D1_FILIAL='" + xFilial("SD1") + "' "
	cQuery += " ORDER BY D1_DOC, D1_ITEM  " 
	 
	TcQuery cQuery New Alias "QR1" 
	                                
	    
	DbSelectArea("QR1")
	QR1->(DBGOTOP()) 
   If SUBSTR(QR1->D1_MSOBS,1,1) <> "S"
   	If apMsgYesNo("Material chegou?")	
   		DBSELECTAREA("SD1") 
   		DBSETORDER(1)
   	
   		Do While QR1->(!Eof())  
				SD1->(DBGOTO(QR1->REC))
				If ALLTRIM(SD1->D1_DOC) == ALLTRIM(SF1->F1_DOC) .AND. ALLTRIM(SD1->D1_FORNECE) == ALLTRIM(SF1->F1_FORNECE) 
					RecLock("SD1",.F.)
   					SD1->D1_MSOBS := "S"+SUBSTR(SD1->D1_MSOBS,2,49) 
   				SD1->(MsUnlock())
   			Else
   				ALERT("ERRO NA OPERAÇÂO")
   			EndIf  
   			QR1->(DBSKIP())
   		EndDo 
   		
   	ELSE
   		lOk := .F.
   	EndIf
   Else      
   	Alert("Material já chegou!")
   EndIf
  
	
   
   DbSelectArea("QR1")
	DbCloseArea()
Return  


