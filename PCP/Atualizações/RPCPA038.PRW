#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPA038	º Autor ³Victor Dessunte     ºData  ³ 15/02/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³TROCA DE CLIENTE PARA ORDENS DE PRODUCAO                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RPCPA038()

Local _cPerg	:= "PCPA38"
 
If !(Pergunte (_cPerg,.T.))
   Return
EndIf

If !MsgYesNo("Confirma alteração nas OP's ??","CONFIRMAR")
   Return
EndIf

MsgRun("Gravando Dados nas OP's...",,{||GravaDad()})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPA038  ºAutor  ³Microsiga           º Data ³  02/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaDad()

Local _cQry		:= ""
Local _cArq		:= "C:\relato_microsiga\RPCPA038.TXT"
Local cNomTrb	:= FCreate(_cArq,0)
Local _nX		:= 1


FERASE(_cArq)

_cQuery := " SELECT 																											" + CRLF
_cQuery += "	TOP 50 R_E_C_N_O_ AS REC,C2_NUM+C2_ITEM+C2_SEQUEN AS OP										" + CRLF
_cQuery += " FROM 																											" + CRLF
_cQuery += 		RetSqlName("SC2") + " C2 																				" + CRLF
_cQuery += " WHERE 																											" + CRLF
_cQuery += " 		C2_FILIAL 	= '" + xFilial("SC2") + "' 														" + CRLF
_cQuery += " AND 	C2_NUM + C2_ITEM + C2_SEQUEN Between '" + MV_PAR01 +"' AND '" + MV_PAR02 + "' 	" + CRLF
_cQuery += " AND 	D_E_L_E_T_ 	= ' ' 																					" + CRLF
_cQuery += " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN																	"

If Select("TRB") > 0
	TRB->(dbcloseArea())
EndIf

TCQUERY _cQuery NEW ALIAS "TRB"

TRB->(dbGoTop())
dbSelectArea("SC2")
While !TRB->(Eof())
	SC2->(dbGoto(TRB->REC))
	If AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) == AllTrim(TRB->OP)
		If _nX==1
			
			fWrite(cNomTrb,"       ...::: OP'S ALTERADAS :::...        "+CRLF)
			fWrite(cNomTrb,"                                           "+CRLF)
			fWrite(cNomTrb,"OP          ANTERIOR        ATUAL          "+CRLF)
			fWrite(cNomTrb,"-------------------------------------------"+CRLF)
			/*ACALOG(_cArq,"       ...::: OP'S ALTERADAS :::...        "	)
			ACALOG(_cArq,"                                           "	)
			ACALOG(_cArq,"OP          ANTERIOR        ATUAL          "	)
			ACALOG(_cArq,"-------------------------------------------"	)*/
			_nX++
		EndIf
		cLinha := TRB->OP+" "+SC2->C2_MSREDUZ+" "+MV_PAR03
		fWrite(cNomTrb,cLinha+CRLF)
		//ACALOG(_cArq,TRB->OP+" "+SC2->C2_MSREDUZ+" "+MV_PAR03)
		RecLock("SC2",.F.)
		SC2->C2_MSREDUZ := MV_PAR03
		SC2->(MsUnlock())
	EndIf
	TRB->(DbSkip())
EndDo

If Select("TRB") > 0
	TRB->(dbcloseArea())
EndIf

fClose(cNomTrb)

ShowMemo(_cArq,"OP's")

Return
