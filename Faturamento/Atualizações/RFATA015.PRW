#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} RFATA015
//TODO Descri��o auto-gerada.
@author Aparecida de F.Stevanato
@since 05/05/2006
@version 1.0
@return NIL
@type function
/*/
User Function RFATA015()

Private _lRet := .T.
Private cCod  := IIF(FUNNAME()=="MATA110",M->C1_PRODUTO,M->C7_PRODUTO)

SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+cCod))
	If Substr(SB1->B1_PROCED,1,1) == "1"
		Alert("ATEN��O, Produto Fabricado n�o pode ser Comprado - Verifique Procedencia")
		_lRet := .F.
	ElseIf SB1->B1_FANTASM == "S"
	    Alert("ATEN��O, Produto Fantasma n�o pode ser Comprado - Solicitar altera��o")
	    _lRet := .F.
	EndIf 
EndIf
         
Return _lRet
