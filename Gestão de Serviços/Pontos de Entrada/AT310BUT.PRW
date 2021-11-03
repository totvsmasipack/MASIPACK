#Include "Rwmake.ch"
#Include "Topconn.ch"
#define _CRLF CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   AT310BUT()      บ AUTOR บ Eduardo Bego Mantoan  บ DATA บ  26/01/15 บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ DESCRICAO    บ Adiciona botoes do usuario na EnchoiceBar  				            บฑฑ
ฑฑบ              บ 				   		    				   							บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER FUNCTION AT310BUT()      
	
	Local aBut:= {}
	AAdd(aBut,{"LOG"    		   ,{|| u_RTECG006() }, "LOG", "LOG" })  //"Gera LOG..."
	AAdd(aBut,{"Visualiza LOG" ,{|| u_RTECG007() }, "VisualizaLOG", "VisualizaLOG" })  //"Visualiza..."
	
	
	
  /*	LOCAL cRET := .T.  
	LOCAL cMEMO := ""

	//cMEMO := ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+"Inclusใo do Help-Desk por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
	cMEMO += "----------------------------------------------------------" +_CRLF
	cMEMO += ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+"Inclusใo de LOG por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
	cMEMO += ABK_MEMO +_CRLF
	cMEMO += "----------------------------------------------------------" +_CRLF 		
   
    */

		
RETURN(aBut)