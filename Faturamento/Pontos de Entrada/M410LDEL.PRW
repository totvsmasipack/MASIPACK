#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM410LDEL  บAutor  ณAna Paula QFaustino บ Data ณ15/01/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para validacao do campo C5_MSCONCL, se o item        บฑฑ
ฑฑบ          ณestiver preenchido nใo poderแ ser excluido                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

User Function M410LDEL(nOpcx)


Private _nPosLoc , _nPosPrd , _nPosDel , _nPosTes , _nPosAlm, _nPosVlr, _nPosPCP, _nPosQtde, _nPosItem, _nPosLib
Private _cUsuario := RetCodUsr()
Private _aUsuario := {}
Private _aGrupos  := {}
Private cDeptoUsu := ""

Private _cGrupo   := ""
Private cProd     := ""
Private _nPos     := 0
Private _lRet     := .T.
Private _lDat	  := .F.

Private aAreaAtu  := GetArea()

IF SUBSTR(cNumEmp,1,2) <> "15"  /// ALTERADO LIZANDRA - 27/03/14 - TRATA HELSIMPLAST
	
	_cGrupoC	:= SPACE(06)
	
	IF ALTERA
		If SC5->C5_MSCONCL <> CTOD('  /  /  ')
			ApmsgAlert("Pedido ja concluํdo, nใo pode ser deletado!")
			_lRet := .F.
		Else
			_lRet := .T.
		EndIf
	EndIf
ENDIF
Return _lRet
