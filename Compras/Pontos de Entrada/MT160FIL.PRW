#include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT160FIL  �Autor  �Microsiga           � Data �  04/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Customiza tecla F11 do PC                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


USER FUNCTION MT160FIL()   

Local I  

	_cUsuario := RetCodUsr()
	cFiltro := ".t."
	cNomeUsu  := ""
	cDeptoUsu := ""
	_aUsuario := {}
	_aGrupos  := {}
	_cGrupo   := ""
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


DBSELECTAREA("SC8")
If "Comex" $ ALLTRIM(cDeptoUsu) .OR. "COMEX" $ ALLTRIM(cDeptoUsu)  
	cFiltro := "SC8->C8_MSCOMEX == 'S'" 
EndIf

   
RETURN cFiltro
                                                     