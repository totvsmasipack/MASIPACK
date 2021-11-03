#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSCHG002  บAutor  ณVictor Dessunte     บ Data ณ  05/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ - Envia relatorio de op's em aberto referente ao           บฑฑ
ฑฑบ          ณ   almoxarifado.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSCHG002(aParam)

Local lContinua := .T.

	CONOUT('=========================|RSCHG002|==========================')
    CONOUT('= INICIADO EM: ' + DTOC(DATE()) + ' - ' + TIME())
	
	//Valida se hแ o c๓digo da empresa configurado no parโmetro do Schedule
    Do Case
    Case Empty(aParam[1]) 
        lContinua := .F.
        CONOUT('= AVISO: CODIGO DA EMPRESA NAO INFORMADO PARA PROCESSAMENTO =')
        
    Case Empty(aParam[2]) 
        lContinua := .F.
        CONOUT('= AVISO: CODIGO DA FILIAL NAO INFORMADO PARA PROCESSAMENTO  =')
    EndCase

	If lContinua
        CONOUT('= EMPRESA: ' + aParam[1] + ' | FILIAL: ' + aParam[2])
        RPCSetType(3)
        RPCSetEnv(aParam[1],aParam[2])
        SCH02PROC()
        RPCClearEnv()
    Endif

    CONOUT('= FINALIZADO EM: ' + DTOC(DATE()) + ' - ' + TIME())
    CONOUT('=============================================================')

Return

Static Function SCH02PROC()

Local _cCor2	:= ""
Local _cQry		:= ""
Local _cHtml1	:= ""
Local _cHtml2	:= ""
Local _cHtml3	:= ""
Local _cTo		:= ""

	_cQry := " SELECT " + CRLF
	_cQry += "		C2_NUM+C2_ITEM+C2_SEQUEN 'OP', " + CRLF
	_cQry += "		C2_PRODUTO, " + CRLF
	_cQry += "		B1_DESC, " + CRLF
	_cQry += "		B1_UM, " + CRLF
	_cQry += "		C2_MSPOSIC " + CRLF
	_cQry += "	FROM " + CRLF
	_cQry += 		RetSqlName("SC2") + " C2 INNER JOIN " + RetSqlName("SB1") + " B1 " + CRLF
	_cQry += "		ON		B1.D_E_L_E_T_	= '' " + CRLF
	_cQry += "		AND 	B1_FILIAL		= '" + xFilial("SB1") + "' " + CRLF
	_cQry += "		AND 	B1_COD			= C2_PRODUTO " + CRLF
	_cQry += "	WHERE " + CRLF
	_cQry += "			C2.D_E_L_E_T_			= '' " + CRLF
	_cQry += "	AND 	C2_FILIAL				= '" + xFilial("SC2") + "' " + CRLF
	_cQry += "	AND 	C2_DATRF					= '' " + CRLF
	_cQry += "	AND 	(C2_QUJE + C2_PERDA)	< C2_QUANT " + CRLF
	_cQry += "	AND 	C2_MSLISTA				<> 'S' " + CRLF
	_cQry += "	AND (		UPPER(C2_MSPOSIC) LIKE '%ALMOXARIFADO%' " + CRLF
	_cQry += "			OR	UPPER(C2_MSPOSIC) LIKE '%FIM DO PROCESSO%' " + CRLF
	_cQry += "			OR	UPPER(C2_MSPOSIC) LIKE '%CONFERENCIA ESTOCAGEM%') " + CRLF
	_cQry += "	ORDER BY 5 "

	TCQUERY _cQry NEW ALIAS "TRB"

	TRB->(dbGoTop())
	
	IF TRB->(!EOF())

		_cHtml1 := "<html>"
		_cHtml1 += "	<body>"
		_cHtml1 += "		<center><font color='#000000' size=3 face='Calibri'><b>OP's em aberto em " + DToC(DATE()) + "</b></font>"
		_cHtml1 += "		<br><br><table cellspacing=0 cellpadding=2 bordercolor='ffffff' border='1' style='border-collapse: collapse;' >"
		_cHtml1 += "			<tr>"
		_cHtml1 += "				<td bgcolor='#696969' align='center'><b><font color='#FFFFFF' size=2 face='Calibri'>Ordem de Produ็ใo</font></b></td>"
		_cHtml1 += "				<td bgcolor='#696969' align='center'><b><font color='#FFFFFF' size=2 face='Calibri'>Produto</font></b></td>"
		_cHtml1 += "				<td bgcolor='#696969' align='center'><b><font color='#FFFFFF' size=2 face='Calibri'>Descri็ใo</font></b></td>"
		_cHtml1 += "				<td bgcolor='#696969' align='center'><b><font color='#FFFFFF' size=2 face='Calibri'>UM</font></b></td>"
		_cHtml1 += "				<td bgcolor='#696969' align='center'><b><font color='#FFFFFF' size=2 face='Calibri'>Posi็ใo</font></b></td>"
		_cHtml1 += "			</tr>"

		_cHtml3 := "		</table>"
		_cHtml3 += "		</center>"
		_cHtml3 += "	</body>"
		_cHtml3 += "</html>"

		While !TRB->(EOF())
			
			If _cCor2 == "#FFFFFF"
				_cCor2 := "#E0FFFF"
			Else
				_cCor2 := "#FFFFFF"
			EndIf
			
			_cHtml2 += "<tr>"
			_cHtml2 += "	<td bgcolor='" + _cCor2 + "' align='left'><font color='#000000' size=2 face='Calibri'>" 	+ TRB->OP			+ "</font></td>"
			_cHtml2 += "	<td bgcolor='" + _cCor2 + "' align='left'><font color='#000000' size=2 face='Calibri'>" 	+ TRB->C2_PRODUTO	+ "</font></td>"
			_cHtml2 += "	<td bgcolor='" + _cCor2 + "' align='left'><font color='#000000' size=2 face='Calibri'>" 	+ TRB->B1_DESC		+ "</font></td>"
			_cHtml2 += "	<td bgcolor='" + _cCor2 + "' align='left'><font color='#000000' size=2 face='Calibri'>" 	+ TRB->B1_UM		+ "</font></td>"
			_cHtml2 += "	<td bgcolor='" + _cCor2 + "' align='left'><font color='#000000' size=2 face='Calibri'>" 	+ TRB->C2_MSPOSIC	+ "</font></td>"
			_cHtml2 += "</tr>"
			
			TRB->(dbSkip())
			
		Enddo

	Endif

	TRB->(dbCloseArea())

	_cTo := GETMV("MS_RSCHG02")

	oMail:= EnvMail():New(.T.)
	If oMail:ConnMail()
		oMail:SendMail("MASIPACK | OPs EM ABERTO",_cTo,,,_cHtml1+_cHtml2+_cHtml3)
	EndIf
	oMail:DConnMail()

Return
