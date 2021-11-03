#Include "Rwmake.ch"
#Include "Topconn.ch"                    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³MS520VLD  ºAutor  ³Aparecida F.Stevanato º Data ³  02/10/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se a Nota Fiscal pode ser cancelada                º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MS520VLD()                                                                   

Private lRet := .T.
 
//Alert("MS520VLD "+SF2->F2_DOC)  

If SF2->F2_EMISSAO <= GetMV("MV_DATAFIS")  // ESte parametro contem Data Limite p/ realizacao de Operacoes Fiscais
	ApMsgStop("Nota não poderá ser cancelada - Periodo Encerrado")
	lRet := .F.
Else
	If SubStr(cNumEmp,1,2) $ "10" .AND. !EMPTY(SF2->F2_CHVNFE)
		If MONTH(SF2->F2_EMISSAO) <> MONTH(dDatabase)
			ApMsgStop("Nota não poderá ser cancelada - Cancelamento fora do mês de emissão." )
			lRet := .F.
		EndIf
	ElseIf SubStr(cNumEmp,1,2) $ "01_40"
		If SF2->F2_EMISSAO < Date() - 1 .AND. !EMPTY(SF2->F2_CHVNFE)
			ApMsgStop("Nota não poderá ser cancelada - Prazo para cancelamento (1 dia)" )
			lRet := .F.
		EndIf
	EndIf
EndIf

Return lRet