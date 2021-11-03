#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA027  ºAutor  ³Victor Dessunte     º Data ³  01/17/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para informar numero de serie do produto no SD3     º±±
±±º          ³ para a op                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTA027()

Local _oDlg 	:= Nil
Local _oSay1	:= Nil
Local _oSay2	:= Nil
Local _oSay3	:= Nil
Local _lSair	:= .F.
Private _oOp	:= Nil
Private _oProd	:= Nil
Private _oSerie	:= Nil
Private _cOp	:= SPACE(11)
Private _cProd	:= SPACE(15)
Private _cSerie	:= SPACE(20)
Private _nRec	:= 0
Private _lWhen	:= .F.
Private _lWhenB	:= .F.

While .T.
	
	_cOp	:= SPACE(11)
	_cProd	:= SPACE(15)
	_cSerie	:= SPACE(20)
	_nRec	:= 0
	_lWhen	:= .F.
	_lWhenB	:= .F.
	
	DEFINE MSDIALOG _oDlg TITLE "Número de Série" FROM 000,000 TO 185,320 PIXEL
	
	@ 005,005 To 073,158 PIXEL OF _oDlg
	
	@ 015,010 SAY _oSay1 PROMPT "OP:"		OF _oDlg PIXEL
	@ 035,010 SAY _oSay2 PROMPT "Produto:"	OF _oDlg PIXEL
	@ 055,010 SAY _oSay3 PROMPT "Nº Série:"	OF _oDlg PIXEL
	                                                                                                       	
	@ 013,042 MSGET _oOp	VAR _cOp		SIZE 050,010 PIXEL OF _oDlg F3 'SC2' VALID IIF(!Empty(_cOp),	VALIDA027('1'),.T.)
	@ 033,042 MSGET _oProd	VAR _cProd		SIZE 070,010 PIXEL OF _oDlg F3 'SB1' VALID IIF(!Empty(_cProd),	VALIDA027('2'),.T.)
	@ 053,042 MSGET _oSerie	VAR _cSerie		SIZE 090,010 PIXEL OF _oDlg WHEN _lWhen
	
	DEFINE SBUTTON FROM 077,100 TYPE 1 ENABLE OF _oDlg ACTION {||RESTA27B(),_oDlg:End()} WHEN _lWhenB
	DEFINE SBUTTON FROM 077,132 TYPE 2 ENABLE OF _oDlg ACTION {||_oDlg:End(),_lSair:=.T.}
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
	If _lSair
		Exit
	EndIf
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA027  ºAutor  ³Victor Dessunte     º Data ³  01/17/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao dos dados digitados                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALIDA027(_cVld)

Local _lRet := .T.
Local _cQry := ""

If _cVld == '1'
	_lRet := EXISTCPO('SC2',_cOp)
Else
	_lRet := EXISTCPO('SB1',_cProd)	
EndIf

If !Empty(_cOp) .AND. !Empty(_cProd) .AND. _lRet
	_cQry := " SELECT D3_COD,D3_X_SERIE,R_E_C_N_O_ " + CRLF
	_cQry += " FROM " + RetSqlName("SD3")
	_cQry += " WHERE " + CRLF
	_cQry += " 		D_E_L_E_T_ 	= ' ' " + CRLF
	_cQry += " AND	D3_FILIAL	= '" + xFilial("SD3") + "'	" + CRLF
	_cQry += " AND	D3_ESTORNO	= '' " + CRLF
	_cQry += " AND	D3_OP		= '" + _cOp + "' " + CRLF
	_cQry += " AND	D3_COD		= '" + _cProd + "' " + CRLF
	_cQry += " AND	D3_CF	LIKE 'RE%' "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY _cQry NEW ALIAS "TRB"
	
	TRB->(dbGoTop())
	If TRB->(!EOF())
		If !Empty(TRB->D3_X_SERIE)
			_cSerie := TRB->D3_X_SERIE
			_oSerie:Refresh()
	
			If MsgYesNo("Já existe número de série para a OP e Produto preenchido, deseja alterar?")
				_nRec	:= TRB->R_E_C_N_O_
				_lWhenB	:= .T.
				_lWhen	:= .T.
				_oSerie:SetFocus()
			EndIf
		Else
			_nRec	:= TRB->R_E_C_N_O_
			_lWhenB	:= .T.
			_lWhen 	:= .T.
			_oSerie:SetFocus()	
		EndIf
	Else
		Alert("Produto não requisitado para a OP preenchida!")
		_lRet := .F.
	EndIf
EndIf

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA027  ºAutor  ³Victor Dessunte     º Data ³  06/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a gravacao do numero de serie na tabela SD3         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RESTA27B()

dbSelectArea("SD3")
SD3->(dbGoTo(_nRec))

RecLock("SD3",.F.)
SD3->D3_X_SERIE := _cSerie
SD3->(MsUnlock())

Return
