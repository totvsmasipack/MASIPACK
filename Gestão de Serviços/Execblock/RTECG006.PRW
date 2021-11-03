#Include "Topconn.ch"
#Include "Rwmake.ch"
#Include "PROTHEUS.CH"
#define _CRLF CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTECG006  ºAutor  ³Eduardo Bego Mantoanº Data ³  15/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Help-Desk.     											  º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RTECG006()
  
LOCAL cMEMO := ""
Local cText := ""
If ABK->ABK_SITUAC == "1" 
	ALERT("Chamado "+ABK->ABK_NRCHAM+" já foi finalizado")
Else
	cText := Tela()
	_aArea 	  		:= GetArea()
   cMEMO +=  _CRLF
	cMEMO += ALLTRIM(DTOC(DATE()))+" - "+ALLTRIM(TIME())+" - Inclusão de LOG por: "+__CUSERID+" - "+ALLTRIM(SUBSTR(UsrFullName(__CUSERID),1,25)) +_CRLF  
	cMEMO += cText +_CRLF
	cMEMO += "----------------------------------------------------------" +_CRLF 
	If cText == ""
		Return
	Else
		M->ABK_MEMO +=  cMEMO  		
   EndIf
  
   	
 
	RestArea(_aArea) 
EndIf	
RETURN 

STATIC Function Tela()
Local Chamado
Local oButton1
Local oButton2
Local oGet1
Local cEmpy := ""
Local cGet1 := "Insira o LOG aqui!"
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "LOG" FROM 000, 000  TO 100, 500 COLORS 0, 16777215 PIXEL

    @ 000, 000 SAY Chamado PROMPT "                                                                 CHAMADO: "+ABK_NRCHAM SIZE 250, 009 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 009, 000 MSGET oGet1 VAR cGet1 SIZE 250, 024 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 012, 000 GET oGet1 VAR cGet1 OF oDlg MULTILINE SIZE 249, 019 COLORS 0, 16777215 HSCROLL PIXEL
    @ 033, 157 BUTTON oButton1 PROMPT "Confirma" SIZE 029, 010 OF oDlg ACTION ( cEmpy := cGet1 , oDlg:End() ) PIXEL
    @ 033, 205 BUTTON oButton2 PROMPT "Cancela" SIZE 029, 010 OF oDlg  ACTION ( oDlg:End())PIXEL

    // Don't change the Align Order 
    Chamado:Align := CONTROL_ALIGN_TOP

  ACTIVATE MSDIALOG oDlg CENTERED

Return cEmpy