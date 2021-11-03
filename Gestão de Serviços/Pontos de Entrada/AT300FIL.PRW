#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAT300FIL  บAutor  ณLizandra Marques    บ Data ณ  30/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra chamados por usuแrio                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                               

User Function AT300FIL()

_cRet			:= ""   
_cNomeUs		:= SPACE(14)

If SubStr(cNumEmp,1,2) $ "01" // MASIPACK 
	
	_cUsuario	:= RetCodUsr()
	_cUsuSenha	:= ""
	_cDeptoUsu	:= ""
	_cCargoUsu	:= ""
	_aUsuario	:= {}           
	_cUser		:= UPPER(cUserName)
	
	PswOrder(1)
	If PswSeek(_cUsuario,.T.)
		_aUsuario	:= PswRet()
		_cUsuSenha	:= UsrRetName(_cUsuario)
		_cDeptoUsu	:= Upper(_aUsuario[1][12])
		_cCargoUsu  := Upper(_aUsuario[1][13])
	Endif
//	_cNomeUs := UPPER(SUBSTR(UsrFullName(__CUSERID),1,14))
	If !(_cDeptoUsu $ ALLTRIM(GETMV('MS_AT300')))
		IF "ASSIST. TECNICA"  $ _cDeptoUsu
			_cRet += "'OLIVIA' $ AB1_ATEND .OR. 'JESSICA' $ AB1_ATEND .OR. 'ANUNES' $ AB1_ATEND .OR. 'FSSILVA' $ AB1_ATEND" 
		ELSE	
			_cRet += "'" + _cUser + "' $ AB1_ATEND " 
		ENDIF	
	Endif
Endif

Return _cRet
