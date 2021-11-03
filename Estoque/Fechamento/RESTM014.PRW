#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTM014  บAutor  ณVictor Dessunte     บ Data ณ  09/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a procedencia no fechamento mensal (SB9)          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RESTM014()

Local _cQry 	:= ""
Local _cVer		:= ""
Local	_cDia		:= ""
Local _nStatus	:= 0

If Pergunte("RESTR030",.T.)
	
	 //_cDia := DTOS(LASTDAY(STOD(MV_PAR01+'01'),IIF(SUBST(MV_PAR01,5,2)=="12",0,2)))
	_cDia := DTOS(LASTDAY(STOD(MV_PAR01+'01'),0))
	
	_cQry := " UPDATE " + RetSqlName("SB9")
	_cQry += " SET B9_XPROCED	= ISNULL((SELECT ISNULL(B1_PROCED,'') FROM " + RetSqlName("SB1") + " WHERE D_E_L_E_T_ = ' ' AND B1_COD = B9_COD AND B1_FILIAL = '" + xFilial("SB1") + "'),'') "
	_cQry += " WHERE "
	_cQry += "		D_E_L_E_T_	= ' ' "
	_cQry += "	AND B9_FILIAL	= '" + xFilial("SB1") + "' "
	_cQry += "	AND B9_DATA		= '" + _cDia + "' "
	
	_nStatus := TCSQLEXEC(_cQry)
	
	If _nStatus < 0
		Alert("Aten็ใo, rotina nใo executada. " +  CRLF + "Erro: " + TCSQLERROR())
	Else
		_cVer := " SELECT COUNT(*) TOT FROM " + RetSqlName("SB9")
		_cVer += " WHERE "
		_cVer += " 			D_E_L_E_T_ 	= '' "
		_cVer += "	AND 	B9_FILIAL 	= '" + xFilial("SB9") + "' "
		_cVer += "	AND	B9_LOCAL		= '01' "
		_cVer += "	AND	B9_DATA		= '" + _cDia + "' "
		_cVer += "	AND	B9_XPROCED	LIKE '%P' "
		
		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf
		
		TCQUERY _cVer NEW ALIAS "TRB"
		
		TRB->(dbGoTop())
		If TRB->TOT > 0
			Alert("Procedencia atualizada com sucesso.")	
		Else
			Alert("Procedencia nใo atualizada com sucesso.")
		EndIf
		
		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf		
	EndIf
EndIf

Return
