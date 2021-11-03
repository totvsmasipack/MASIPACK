#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "rwmake.ch"
#include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_RFATG052()  บAutor  ณIvandro M P Santosบ Data ณ  08/04/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho que preenche o campo A1_MSAREA quando preenche os  บฑฑ
ฑฑบ          ณ campo municํpio quando o Estado for diferente de "EX"      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function RFATG052(cEstMun)

Local _cQuery     := ""

Private _cReg  	  := ""
Private _cEscolha := ""
Private _aRegiao  := {}

IF IsInCallStack("U_MSARECLI")
	_cReg := Alltrim(aCampos[14])
Else
	If Alltrim(cEstMun) == "EX99999"
		_cRet := ""
	Else
		_cQuery := "Select ZW_REGIAO+' - '+RTRIM(LTRIM(X5_DESCRI)) REGIAO FROM "+ RetSqlName("SZW") +" SZW "
		_cQuery += "	INNER JOIN "+ RetSqlName("SX5") +" SX5 ON X5_TABELA = 'RC' AND X5_CHAVE = ZW_REGIAO "
		_cQuery += "	WHERE ZW_EST+ZW_CODMUN = '"+cEstMun+"' AND SZW.D_E_L_E_T_ = '' "
		
		U_FATG52QR(_cQuery)
		If Empty(Alltrim(_cReg))
			Alert("Nใo existe Regiใo cadastrada da cidade,estado ou pais")
		EndIf
	EndIf
Endif

Return(_cReg)
