#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ RFATG009    Autor ³ Solange Ap.Vezu      ³ Data ³ 22.10.07 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Gatilho para gravar automatic. o VENDEDOR no Orçamento     ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/ 

User Function RFATG009()       

Local cUsuario 	:= RetCodUsr()
Local cNomusu  	:= UsrRetName(cUsuario)     
Local aUsuario 	:= {}
Local cDeptoUsu := ""

aUsuario  		:= PswRet()
cDeptoUsu 		:= Upper(Alltrim(aUsuario[1][12]))

SA3->(dbSetOrder(7))
SA3->(dbSeek(xFilial("SA3")+cUsuario))

If Alltrim(cDeptoUsu) $ Upper("Venda de Pecas")
	M->CJ_MSVEND 	:= SA3->A3_COD
	Return(M->CJ_MSVEND)
Else
	Return
Endif

/*
User Function RFATG009()       

Local _cUsuario := RetCodUsr()
Local _cNomusu  := UsrRetName(_cUsuario)

If _cUsuario == "000118" .or. _cUsuario == "000165"             // Jair ou Helio
	SA3->(dbSetOrder(7))
	SA3->(dbSeek(xFilial()+_cUsuario))

	M->CJ_MSVEND 	:= SA3->A3_COD
	M->CJ_MSGARAN   := "1"
	M->CJ_MSPRZEN	:= "1 DIA"

	Return(M->CJ_MSVEND)
Else
	Return
Endif

