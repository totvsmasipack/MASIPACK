#Include "Rwmake.ch"
#Include "Topconn.ch" 
#Include "PROTHEUS.CH"
/*
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณSD3240E   บ Autor ณ Eduardo Bego Mantoan Data ณ  27/11/14   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Filtro Gera pr้-requisi็ใo uniformes somente Seila         บฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M106FIL() 

Local cRet:= ""

_cUsuario  := RetCodUsr()

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12])) 
	
EndIf
If Upper(_cDeptoUsu) $ "ALMOXARIFADO" 
	cRet += " SUBSTR(CP_PRODUTO,1,2) <> 'UN' "
ElseIf Upper(_cDeptoUsu) $ "RESTAURANTE" 
	cRet += " SUBSTR(CP_PRODUTO,1,2) == 'UN' .OR. SUBSTR(CP_PRODUTO,1,2) == 'ML'  .OR. SUBSTR(CP_PRODUTO,1,10) =='MI01000002'     "
Else 
	cRet += "CP_PRODUTO <> '000000000000000'"
EndIf
Return cRet
