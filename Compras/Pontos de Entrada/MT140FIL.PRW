#Include "Rwmake.ch"
#Include "Topconn.ch"  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110FIL  �Autor  �Microsiga           � Data �  05/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Customiza tecla F11 do PC                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110FIL()

Local I 

	cFiltro := ".T."
	_cUsuario := RetCodUsr()
	cNomeUsu  := ""
	cDeptoUsu := ""
	_aUsuario := {}
	_aGrupos  := {}
	_cGrupo   := ""
	_lRet     := .T.
	I         := 0
	PswOrder(1)
	IF PswSeek(_cUsuario,.T.)
		_aUsuario := PswRet()
		cNomeUsu  := UsrRetName(_cUsuario)
		cNomeUsu  := Upper(Alltrim(cNomeUsu))
		cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
		_aGrupos  := PswRet(1)[1][10]
		For I := 1 to Len(_aGrupos)
			_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
		Next I
		_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)
	ENDIF
	DBSELECTAREA("SC1")
	If "Comex" $ ALLTRIM(_cGrupo) 
		cFiltro := "SC1->C1_USER == '001121' .OR. SC1->C1_USER == '001122'"   
	EndIf              
	
RETURN cFiltro
