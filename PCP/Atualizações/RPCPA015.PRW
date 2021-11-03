#include "protheus.ch"
#Include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPA015 º Autor ³ Aparecida de F.Stevanato Data ³ 12/11/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ENCERRA ORDEM DE PRODUCAO                                  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RPCPA015()

Private cPerg		:= "PCPA15"
Private nAlterados	:= 0
Private nQtdEmp		:= 0
Private _nSalPed		:= 0
Private _cUsuario	:= RetCodUsr()
Private _cUsuSenha	:= UsrRetname(_cUsuario)

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
	cUsuarioSZS	:= Upper(Alltrim(_aUsuario[1][4]))
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
EndIf

// Num. da OP   := (mv_par01)
// Motivo		:= (mv_par02)
If !(Pergunte (cPerg,.T.))
	Return
EndIf

DbSelectArea("SC2")
SC2->(DbSetOrder(1))
SC2->(DBGotop())

DbSelectArea("SD4")
SD4->(DbSetOrder(2))
SD4->(DBGotop())

DbSelectArea("SZS")
SZS->(DBGotop())

DbSelectArea("SB2")
SB2->(DbSetOrder(1))
SB2->(DBGotop())

If SC2->(DbSeek(xFilial("SC2")+Alltrim(MV_PAR01)))
	If !Empty(SC2->C2_DATRF)
		apMsgStop("Ordem de produção já encerrada","OP Encerrada")
		Return
	Endif
	If MsgYesNo("Deseja realmente encerrar a OP: "+Alltrim(MV_PAR01),"Confirmar Encerramento")
		If SD4->(DbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))	// Verificar se existe empenho para esta OP
			nQtdEmp := 0
			Do While Alltrim(SD4->D4_OP) == (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) .And. SD4->(!Eof())
				nQtdEmp += SD4->D4_QUANT
				If nQtdEmp > 0
					apMsgStop("Esta OP contém empenhos. Favor zera-los antes de encerrar","Zerar empenho")
					Return
				EndIf 
				SD4->(DbSkip())
			End Do
		Endif
		RecLock("SC2",.F.)
		SC2->C2_DATRF	:= Date()
		SC2->C2_MSPOSIC := "OP ENCERRADA PELO PCP. USUARIO: " +Alltrim(_cUsuSenha)
		SC2->(MsUnlock())
			
		RecLock("SZS",.T.)
		SZS->ZS_FILIAL	:= xFilial("SZS")
		SZS->ZS_OP		:= Alltrim(MV_PAR01)
		SZS->ZS_PRODUTO := SC2->C2_PRODUTO
		SZS->ZS_QTDE	:= SC2->C2_QUANT
		If Empty(Alltrim(MV_PAR02))
			SZS->ZS_POSICAO := "RPCPA015 - " + SC2->C2_MSPOSIC
		Else
			SZS->ZS_POSICAO := "RPCPA015 - " + Upper(Alltrim(MV_PAR02))
		Endif
		SZS->ZS_DATA	:= DATE()
		SZS->ZS_HORA	:= TIME()
		SZS->ZS_USUARIO := UPPER(cUsuarioSZS)
		SZS->ZS_DEPTO   := _cDeptoUsu
		SZS->(MsUnlock())
		
		SB2->(DbSeek(xFilial("SB2")+SC2->C2_PRODUTO+"01"))
		_nSalPed := SB2->B2_SALPEDI
		RecLock("SB2",.F.)
		SB2->B2_SALPEDI	:= _nSalPed - SC2->C2_QUANT
		SB2->(MsUnlock())
		
		
		MsgInfo("OK - Ordem de Produção encerrada")
	Endif
Else
	MsgStop("Ordem de Produção digita não existe !!!","OP Não Existe")
Endif

DbSelectArea("SC2")
SC2->(DbCloseArea())

DbSelectArea("SD4")
SD4->(DbCloseArea())

DbSelectArea("SZS")
SZS->(DbCloseArea())

Return()