#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410LDEL  �Autor  �Ana Paula QFaustino � Data �15/01/2013   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para validacao do campo C5_MSCONCL, se o item        ���
���          �estiver preenchido n�o poder� ser excluido                  ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������

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
			ApmsgAlert("Pedido ja conclu�do, n�o pode ser deletado!")
			_lRet := .F.
		Else
			_lRet := .T.
		EndIf
	EndIf
ENDIF
Return _lRet
