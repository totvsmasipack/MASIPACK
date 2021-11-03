#include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160FIL  ºAutor  ³Microsiga           º Data ³  04/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Customiza tecla F11 do PC                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
                                                     