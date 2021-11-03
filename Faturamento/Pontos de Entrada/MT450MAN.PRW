#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

User Function MT450MAN()

Local lRet := .T.

Default cEmpAnt	:= "01"
 
	IF cEmpAnt $ "01|10"
        lRet :=  U_MUDACOR()
	Endif

Return lRet  
