#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT440AT  ºAutor ³Aparecida de F.Stevanato Data ³ 15/09/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verifica se há Itens Separados para Faturamento           º±±
±±º23/03/12  ³  Alteração para deixar liberar de acordo com a categoria doº±±
±±º             pedido ( regras iguais ao M410ALOK)  - Lizandra           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT440AT()

Local _lGrp   := IIF(SC5->C5_CLIENTE$GetMv("MS_GRUPO"),.T.,.F.)

_aArea 	  := GetArea()
_cUsuario := RetCodUsr()
cDeptoUsu := ""
_lRet     := .F.
cNomeUsu := ""
_aUsuario := {}

If RetCodUsr() $ GetMv("MS_USRAPV")
	Return .T.
EndIf

If SubStr(cNumEmp,1,2) $ "40_45" 
	_lRet     := .T.
	Return(_lRet)
EndIf 

If SubStr(cNumEmp,1,2) <> "15"
	If SC5->C5_MSUSER = " "
		_lRet = .T.
		Return(_lRet)
	Endif
	
	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario := PswRet()
		cNomeUsu  := UsrRetName(_cUsuario)
		cNomeUsu  := Upper(Alltrim(cNomeUsu))
		cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
		If "ENG." $ cDeptoUsu
			cDeptoUsu := Substr(cDeptoUsu,1,12)
		EndIf
	EndIf

	If (SC5->C5_MSCATEG $ "0_1") .And. ("COMERCIAL" $ cDeptoUsu .OR. "ENG.MECANICA" $ cDeptoUsu .OR."ENG.ELETRICA" $ cDeptoUsu)      // $ "COMERCIAL|ENG.MECANICA|ENG.ELETRICA"
		_lRet = .T.
		Return(_lRet)
	EndIf
	If SubStr(cNumEmp,1,2) $ "01"
		If ((SC5->C5_MSCATEG $ "2") .AND.  (SUBSTR(cNumEmp,1,2) $ '01_10')).And. (cDeptoUsu $ "205-ALMOXARIFADO" .OR. cDeptoUsu $ "COMEX" .OR. cDeptoUsu $ "207-PCP")    //_VENDA DE PECAS"
			_lRet = .T.
			Return(_lRet)
		EndIf
		If (SC5->C5_MSCATEG $ "3" .AND.  (SUBSTR(cNumEmp,1,2) $ '01_10')) .And. (cDeptoUsu $ "205-ALMOXARIFADO" .OR. cDeptoUsu $ "VENDA DE PECAS" .OR. cDeptoUsu $ "207-PCP")
			_lRet = .T.
			Return(_lRet)
		Endif
	Else
		If (SC5->C5_MSCATEG $ "2_3" .AND.  (SUBSTR(cNumEmp,1,2) $ '01_10')) .And. (cDeptoUsu $ "COMEX" .OR. cDeptoUsu $ "VENDA DE PECAS" .OR. cDeptoUsu $ "207-PCP")
			_lRet = .T.
			Return(_lRet)
		EndIf
	Endif
	If (SC5->C5_MSCATEG == "5" .AND.  (SUBSTR(cNumEmp,1,2) $ '01_10')) .And. (cDeptoUsu $ "203-MAKLASER" .OR. cDeptoUsu $ "205-ALMOXARIFADO")
		_lRet = .T.
		Return(_lRet)
	EndIf
	If (SC5->C5_MSCATEG == "6" .AND.  (SUBSTR(cNumEmp,1,2) $ '01_10')) .And. (cDeptoUsu == "ASSIST.TECNICA" .OR. cDeptoUsu $ "207-PCP")
		_lRet = .T.
		Return(_lRet)
	EndIf
	
	If Alltrim(SC5->C5_MSUSER) <> _cUsuario
		Help(NIL, NIL, "MT440AT_A", NIL, "Só é permitido liberação pelo usuário que incluiu o Pedido de Vendas.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o responsável pelo pedido: " + Alltrim( UsrRetName(SC5->C5_MSUSER) ) })
		_lRet= .F.
	Else
		_lRet= .T.
	EndIf
	
Endif                               

IF SC5->C5_TIPO == "N"	.And. !_lGrp
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		If AllTrim(SA1->A1_RISCO) $ "C_D_E" .and. AllTrim(SA1->A1_MSBLQL)<> "1"
			ApMsgAlert("Cliente possui restrição financeira. Favor verificar com Depto. Financeiro!!!")
			_lRet := .F.
		Else
			_lRet = .T.
			Return(_lRet)
		EndIf
	EndIf
Else
	_lRet = .T.
EndIf

        
RestArea(_aArea)
Return(_lRet)
