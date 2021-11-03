#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} RFATA015
//TODO Descrição auto-gerada.
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
		Alert("ATENÇÃO, Produto Fabricado não pode ser Comprado - Verifique Procedencia")
		_lRet := .F.
	ElseIf SB1->B1_FANTASM == "S"
	    Alert("ATENÇÃO, Produto Fantasma não pode ser Comprado - Solicitar alteração")
	    _lRet := .F.
	EndIf 
EndIf
         
Return _lRet
