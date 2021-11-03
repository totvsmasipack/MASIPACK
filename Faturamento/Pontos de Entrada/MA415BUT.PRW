#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA415BUT  บAutor ณEduardo Bego Mantoan	   Data ณ 15/04/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Adiciona bot๕es เ barra no topo da tela         			  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA415BUT()  

Local aAreaAtu	:= GetArea()
Local aBotao	:= {} 
Local _aUsuario	:= {}               
	
	If cEmpAnt $ '01|10'
	
		PswOrder(1)
		If PswSeek(RetCodUsr(),.T.)
			_aUsuario := PswRet()
			_cDeparUsu := Upper(Alltrim(_aUsuario[1][12]))
			_cCargoUsu := Upper(Alltrim(_aUsuario[1][13])) 
		Else
			Return(aBotao)
		EndIf
		
		AAdd(aBotao,{"USER"   ,{|| U_RFATG049() }, "Desbloquear Or็amento" })
		If _cDeparUsu $ "INFORMATICA" .OR. _cCargoUsu $ "GERENTE DE VENDAS"  
			AAdd(aBotao,{"USER"   ,{|| U_RFATG050() }, "Aprovar Or็amento" }) 
		EndIf

	Endif
	
	RestArea(aAreaAtu) 
	 
Return aBotao