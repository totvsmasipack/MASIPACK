#Include "Rwmake.ch"
#Include "Topconn.ch"
#define _CRLF CHR(13)+CHR(10)
/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� PROGRAMA     �   AT310BUT()      � AUTOR � Eduardo Bego Mantoan  � DATA �  26/01/15 ���
���������������������������������������������������������������������������������������͹��
��� DESCRICAO    � Adiciona botoes do usuario na EnchoiceBar  				            ���
���              � 				   		    				   							���
���������������������������������������������������������������������������������������͹��
��� PROPRIETARIO � CUSTOMIZADO PARA MASIPACK                                            ���
���������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
/*/

USER FUNCTION AT310BUT()      
	
	Local aBut:= {}
	AAdd(aBut,{"LOG"    		   ,{|| u_RTECG006() }, "LOG", "LOG" })  //"Gera LOG..."
	AAdd(aBut,{"Visualiza LOG" ,{|| u_RTECG007() }, "VisualizaLOG", "VisualizaLOG" })  //"Visualiza..."
	
	
	
  /*	LOCAL cRET := .T.  
	LOCAL cMEMO := ""

	//cMEMO := ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+"Inclus�o do Help-Desk por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
	cMEMO += "----------------------------------------------------------" +_CRLF
	cMEMO += ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+"Inclus�o de LOG por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
	cMEMO += ABK_MEMO +_CRLF
	cMEMO += "----------------------------------------------------------" +_CRLF 		
   
    */

		
RETURN(aBut)