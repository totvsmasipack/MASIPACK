#Include "Rwmake.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} MT100GRV
//TODO Descrição: Não gravar a NFE se o campo F1_CHVNFE não estiver preenchido.
@author Lizandra
@since 07/04/14
@version 1.0
@return _lRet
@type function
/*/

User Function MT100GRV()
Local _aArea := GetArea()
Local lExp01 := PARAMIXB[1]

_lRet := .F.
If IsInCallStack("A103DEVOL") .OR. cFormul == "S" .OR. IsInCallStack("MATA140") .OR. lExp01;
.OR. (!EMPTY(M->F1_CHVNFE) .AND. ALLTRIM(CESPECIE) == "SPED") .OR. !(ALLTRIM(CESPECIE) == "SPED")
	_lRet := .T. 
ELSE
	_lRet := .F.
	apmsgAlert("Chave da NFE em branco. Por favor verifique")
ENDIF

RestArea(_aArea)

Return _lRet
