#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
Ььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььььь
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±йннннннннннннннлннннннннннннннннлнннннннлнннннннннннннннннннннннлннннннлнннннннннннннн»±±
±±є Programa     є    ValidMsg    є Autor є Fabio Marcelo Dias    є Data є   05/09/11   є±±
±±мнннннннннннннноннннннннннннннннкнннннннкнннннннннннннннннннннннкннннннкнннннннннннннн№±±
±±є Descricao    є Rotina criada para substituiзгo de Alertas, forзando o usuario a ler є±±
±±є              є o conteudo exibido na tela e digitar a chave de validaзгo para       є±±
±±є              є prosseguir na utilizaзгo da rotina.                                   є±±
±±мннннннннннннннонннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн№±±
±±є Historico    є 05/09/2011 - Criaзгo                                                 є±±
±±є              є                                                                      є±±
±±мннннннннннннннонннннннннннннннннннннннннннннннннннннннннннннннннннннннннннонннннннннн№±±
±±є Uso          є Modulo Estoque / Custos                                              є±±
±±мннннннннннннннонннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн№±±
±±є Proprietario є Customizado Para Masipack                                            є±±
±±иннннннннннннннкннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннј±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯ
/*/

User Function ValidMsg(cUsuarioSZS, cCodSetor, cValidMsg, cSetor, _cNumOP, nQtde, cConteudo)

	Local	lIf		:=.T.
	Private cValid	:= Substr(Time(),5,1) + Substr(Time(),7,2)
	Private cGet1	:= Space(11)
	Private _CRLF	:= CHR(13) + CHR(10)
	Private cTexto	:= ""
	Private oFont0  := TFONT():NEW('Arial',,-14,.T.,.T.)
	Private oFont1	:= TFONT():NEW('Arial',,-14,.T.,.T.)
	Private oFont2  := TFONT():NEW('Arial',,-14,.T.,.F.)
	Private oFont3  := TFONT():NEW('Arial',,-14,.T.,.F.)
	
	
	Private oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oGet1, oSButton1
	Static oDlg
	
	cTexto := Alltrim(cConteudo)

	Do While cValid <> Alltrim(cGet1)

		DEFINE MSDIALOG oDlg TITLE "Mensagem" FROM 000, 000 TO 500, 700 COLORS 0, 16777215 PIXEL 

		@ 003, 016 SAY oSay1 PROMPT "Setor: " + cCodSetor + " - " + cSetor Size 320, 100 OF oDlg FONT oFont1 COLORS CLR_BLUE, 16777215 PIXEL
		@ 013, 016 SAY oSay2 PROMPT "OP: " + _cNumOP Size 320, 100 OF oDlg FONT oFont1 COLORS CLR_BLUE, 16777215 PIXEL
		@ 023, 016 SAY oSay3 PROMPT "Quantidade: " + cValtochar(nQtde) Size 320, 100 OF oDlg FONT oFont1 COLORS CLR_BLUE, 16777215 PIXEL

		@ 043, 016 SAY oSay4 PROMPT cTexto SIZE 320, 120 OF oDlg FONT oFont0 COLORS CLR_BLACK, 16777215 PIXEL
// SUBSTITIDO PELA LINHA ABAIXO A PEDIDO DO PCP (JOMAR) - LIZANDRA - 23/04/15
//		If Alltrim(cCodSetor) == "203500" .OR. cValidMsg = 'N'		// Se operacao for Verificar Componentes nao e necessario digitar a Validacao.
		If Alltrim(cCodSetor) == "203964" .OR. cValidMsg = 'N'		// Se operacao for Verificar Componentes nao e necessario digitar a Validacao.
			cValid := ""
			@ 200, 016 SAY oSay5 PROMPT "Sr. " + Substr(cUsuarioSZS,1,15) + ". Para prosseguir aperte a tecla ENTER:" SIZE 280, 100 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
			@ 200, 260 MSGET oGet1 VAR cGet1 SIZE 050, 010 OF oDlg FONT oFont3 COLORS 0, 16777215 ON CHANGE .T. PIXEL
		//Ivandro Santos - inнcio da alteraзгo: Ticket#2018020737000051 — chave de seguranзa
		/*Else
			@ 185, 016 SAY oSay5 PROMPT "Chave de Validaзгo: " +cValid SIZE 280, 100 OF oDlg FONT oFont0 COLORS CLR_BLACK, 16777215 PIXEL
			@ 200, 016 SAY oSay6 PROMPT "Sr. " + Substr(cUsuarioSZS,1,15) + ". Para prosseguir digite aqui a Chave de Validaзгo:" SIZE 280, 100 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
			@ 200, 260 MSGET oGet1 VAR cGet1 SIZE 050, 010 OF oDlg FONT oFont3 COLORS 0, 16777215 ON CHANGE .T. PIXEL*/
		//Ticket#2018020737000051 — tйrmino da validaзгo
			lIf :=.F.
		Endif

		DEFINE SBUTTON oSButton1 FROM 220, 155 TYPE 01 OF oDlg ENABLE ACTION oDlg: End()

		ACTIVATE MSDIALOG oDlg CENTERED

		If lIF
			cGet1		:=	cValid 
		EndIF

	End Do


Return()
