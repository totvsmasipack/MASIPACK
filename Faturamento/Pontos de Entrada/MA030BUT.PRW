#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA030BUT  บAutor ณEduardo Bego Mantoan	   Data ณ 20/04/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Adiciona bot๕es เ barra no topo da tela         			  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA030BUT()  

	Local aAreaAtu     := GetArea()
	Local aBotao    := {} 
	Local _aUsuario  	:= {}               
	Local _cUsuario   := RetCodUsr()
	Local _cUser		:= cUserName
	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario := PswRet()
		_cDeparUsu := Upper(Alltrim(_aUsuario[1][12]))
		_cCargoUsu := Upper(Alltrim(_aUsuario[1][13])) 
	Else
		Return(aBotao)
	EndIf
	
	
	If SUBSTR(cNumEmp,1,2) $ "10"  // FABRIMA         
		AAdd(aBotao,{"USER"   ,{|| U_RFATA066() }, "Prospect" })
	EndIf 
	//Ivandro Santos - 23/03/17
	//Ticket#2017031637000151 — Cadastro de clientes / Lojas
	AAdd(aBotao,{"COPIA"   ,{|| U_RFATG058() }, "Copia" })
	//Ticket#2017031637000151 — Fim da altera็ใo	
	RestArea(aAreaAtu) 
	 
Return(aBotao)
