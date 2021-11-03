#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPG010³ Autor ³ Aparecida de F.Stevanato³Data ³ 19.02.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina chamada no campo SD3->D3_TRT (Mov.Interno/Producao) ³±±
±±³          | Tipo 602 - Baixa Itens da OP e  Tipo 100 - MATP0127        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function RPCPG010()

Local aSX5ZD	:= {}
Local I

Private cLocais    := ""
Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cDeptoUsu := ""
Private _cUsuSenha := ""
Private _aGrupos   := {}
Private _cGrupo    := ""
Private nLastKey   := 0
Private cLocal     := ""
Private _cRotina   := ""
Private _fRet      := .T.

_cRotina := FunName()

If _cRotina == "MATA240"
	_cTpMov := M->D3_TM
ElseIf _cRotina == "MATA241"
	_cTpMov := cTM
Else
	Return _fRet
EndIf

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_cUsuSenha := UsrRetName(_cUsuario)
	_cUsuSenha := Alltrim(Upper(SubStr(_cUsuSenha,1,6)))
	_aUsuario  := PswRet()
	_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
	_aGrupos  := PswRet(1)[1][10]
	For I := 1 to Len(_aGrupos)
		_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	Next I
	_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)
EndIf
/*
SX5->(DbGotop())
If _cGrupo $ "ADMINISTRADORES|INFORMATICA"
	If SX5->(DbSeek(xFilial("SX5")+"ZD"+"LOCAIS")) // Contem todos os locais possiveis de armazenamento
		cLocais := RTRIM(SX5->X5_DESCRI)
	EndIf
ElseIf SX5->(DbSeek(xFilial("SX5")+"ZD"+_cUsuSenha))
	cLocais := RTRIM(SX5->X5_DESCRI)
*/
If !(FwIsAdmin())
	aSX5ZD := FwGetSX5('ZD',_cUsuSenha)
	If Len(aSX5ZD) > 0 .And. !Empty(aSX5ZD[1,4])
		cLocais := aSX5ZD[1,4]
	Else
		FwAlertError("Usuário sem permissão para esta Rotina - Entre em contato com Informatica e informe que necessita de acesso a Tabela ZD ")
		Return .F.
	Endif
EndIf

If Val(_cTpMov) == 602
	If _cRotina == "MATA240"
		VerSD4()
	EndIf
ElseIf Val(_cTpMov) == 100
	VerSC2()
EndIf

Return _fRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerSD4    ºAutor  ³Microsiga           º Data ³  04/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerSD4()

SD4->(dbSetOrder(1))
If SD4->(dbSeek(xFilial("SD4")+M->D3_COD+M->D3_OP+M->D3_TRT))
	If SD4->D4_QUANT > 0
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+M->D3_COD))
			cLocal := SubStr(SB1->B1_LOCAL,1,1)
			If ! cLocal $ cLocais
				ApMsgStop("Usuário sem permissão para Baixar este Item do local => "+cLocal)
				_fRet := .F.
			EndIf
			If M->D3_QUANT > SD4->D4_QUANT
				ApMsgStop("Qtde incoerente com a Qtde. da OP!!!!")
				_fRet  := .F.
			EndIf
		EndIf
	Else
		ApMsgStop("Produto: " +Alltrim(M->D3_COD)+ " e Item: " +M->D3_TRT+ " já pago para esta Lista" +CHR(13)+ "Ou verifique a quantidade digitada se é valida")
		_fRet := .F.
	EndIf
Else
	ApMsgStop("Produto: "+ Alltrim(M->D3_COD) + " e Item: " + M->D3_TRT + " não cadastrado para esta OP!!!!")
	_fRet  := .F.
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerSC2    ºAutor  ³Microsiga           º Data ³  04/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerSC2()

If Alltrim(M->D3_COD) <> Alltrim(SC2->C2_PRODUTO)
	ApMsgStop("Produto Diferente da OP ou OP Em Branco!!!!")
	_fRet := .F.
EndIf
Return
