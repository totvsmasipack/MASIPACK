#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矲un噮o    � RFATG011    Autor � Solange Ap.Vezu      � Data � 18.12.07 潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北矰escri噮o � Gatilho p/ gravar autom.o campo PRAZO ENTREGA no Or鏰mento 潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北/*/ 

User Function RFATG011()       

Local cUsuario 	:= RetCodUsr()
Local cNomusu  	:= UsrRetName(cUsuario)     
Local aUsuario 	:= {}
Local cDeptoUsu := ""

aUsuario  		:= PswRet()
cDeptoUsu 		:= Upper(Alltrim(aUsuario[1][12]))

SA3->(dbSetOrder(7))
SA3->(dbSeek(xFilial("SA3")+cUsuario))

If Alltrim(cDeptoUsu) $ Upper("Venda de Pecas")
	M->CJ_MSPRZEN	:= "1 DIA"
	Return(M->CJ_MSPRZEN)
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

