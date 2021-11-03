#Include "Topconn.ch"
#Include "Rwmake.ch"
#Include "PROTHEUS.CH"
#define _CRLF CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTECG007  ºAutor  ³Eduardo Bego Mantoanº Data ³  15/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Help-Desk.     											  º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RTECG007()
  

	Tela(M->ABK_MEMO)

	 		

 

RETURN 

STATIC Function Tela(_MEMO)
Local Chamado
Local oButton1
Local oButton2
Local oGet1
Local nEmpy := ""
Local cGet1 := _MEMO
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "LOG" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

    @ 000, 000 SAY Chamado PROMPT "                                                                 CHAMADO: "+ABK_NRCHAM SIZE 250, 009 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 009, 000 MSGET oGet1 VAR cGet1 SIZE 250, 024 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 028, 001 GET oGet1 VAR cGet1 OF oDlg MULTILINE SIZE 247, 196 COLORS 0, 16777215 HSCROLL PIXEL
    @ 230, 185 BUTTON oButton1 PROMPT "OK" SIZE 051, 014 OF oDlg ACTION ( oDlg:End() ) PIXEL
  //  @ 033, 205 BUTTON oButton2 PROMPT "Cancela" SIZE 029, 010 OF oDlg  ACTION ( oDlg:End())PIXEL
    
	   


    // Don't change the Align Order 
    Chamado:Align := CONTROL_ALIGN_TOP

  ACTIVATE MSDIALOG oDlg CENTERED

Return