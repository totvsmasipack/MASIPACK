#Include "Rwmake.ch"
#Include "Topconn.ch"
#define _CRLF CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º   AT310GRV()      º AUTOR º Eduardo Bego Mantoan  º DATA º  21/10/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º DESCRICAO    º 	  Após gravar o chamado    													 º±±
±±º																												 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROPRIETARIO º CUSTOMIZADO PARA MASIPACK                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION AT310GRV()      

LOCAL cRET := .T.  
LOCAL cMEMO := "" 
DBSELECTAREA("ABK")
DBSETORDER(1)
If DBSEEK(xFilial("ABK")+ABK_NRCHAM)
	_aArea 	  		:= GetArea()		
	If INCLUI
		cMEMO := ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+" - Help-Desk aberto por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
		cMEMO += "----------------------------------------------------------" +_CRLF
		//cMEMO += ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+" - LOG por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
		cMEMO += M->ABK_MEMO +_CRLF
		//cMEMO += "----------------------------------------------------------" +_CRLF 
		
		RecLock("ABK",.F.)
		MSMM( ABK->ABK_CODMEM, , , cMEMO, 1, , , "ABK","ABK_CODMEM" )
		ABK->ABK_MSDINC := DTOC(DATE())+" - "+ALLTRIM(TIME())
		ABK->ABK_MSDUAL := DTOC(DATE())+" - "+ALLTRIM(TIME())
		ABK->(MsUnLock())
  		If ABK->ABK_SITUAC == "1"                                                                                              
   	   cMEMO += M->ABK_MEMO
   		cMEMO += _CRLF+"**********************************************************" +_CRLF
   		cMEMO += ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+" - Encerramento do Help-Desk por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
			cMEMO += 		"**********************************************************" +_CRLF  
			RecLock("ABK",.F.)
		  	MSMM( ABK->ABK_CODMEM, , , cMEMO, 1, , , "ABK","ABK_CODMEM" )
		  	ABK->ABK_MSDEND := DTOC(DATE())+" - "+ALLTRIM(TIME())
			ABK->(MsUnLock())
		EndIf
   ElseIf ALTERA                             
    
     /*	If ABK->ABK_SITUAC == "1" 
    		
    		
    	Else
    		RecLock("ABK",.F.)
	   		MSMM( ABK->ABK_CODMEM, , , cMEMO, 1, , , "ABK","ABK_CODMEM" )
			ABK->(MsUnLock())
    	EndIf   */
    	
   ELSE
    	If ABK->ABK_SITUAC == "1" 
    	    cMEMO += ABK_MEMO
    		cMEMO += _CRLF+"**********************************************************" +_CRLF
    		cMEMO += ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+" - Encerramento do Help-Desk por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
			cMEMO += 		"**********************************************************" +_CRLF  
			RecLock("ABK",.F.)
	   	MSMM( ABK->ABK_CODMEM, , , cMEMO, 1, , , "ABK","ABK_CODMEM" )
	   	ABK->ABK_MSDEND := DTOC(DATE())+" - "+ALLTRIM(TIME())
			ABK->(MsUnLock())
  	   Else
  	   	RecLock("ABK",.F.)
  	   	ABK->ABK_MSDUAL := DTOC(DATE())+" - "+ALLTRIM(TIME())  
  	   	ABK->(MsUnLock())
  	   EndIf	   	  			
   EndIf 
      
	DBSELECTAREA("SA1")
	DBSETORDER(1)
	SA1->(DBSEEK(XFILIAL("SA1")+ABK->ABK_CODCLI+ABK->ABK_LOJA))
	RecLock("ABK",.F.)
	ABK->ABK_MSNCLI := SA1->A1_NOME
	ABK->(MsUnLock())
	RestArea(_aArea)
EndIf	
RETURN(cRET)