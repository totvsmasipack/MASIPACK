#Include "Rwmake.ch"   
#Include "Topconn.ch"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPG009³ Autor ³ Aparecida de F.Stevanato³Data ³ 23.04.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina chamada no campo SB1->B1_PROCED                     ³±± 
±±³          |                                                            ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/

User Function RPCPG009()

Local _aArea      := GetArea()
Local _cCod 	  := M->B1_COD
Local _cEstrut	  := GetAdvFVal("SG1","G1_COMP",xFilial("SG1")+_cCod,1," ")
Local _cQry  	  := ""
Private _fRet     := .T.

If !(M->B1_PROCED $ "1P_1N_2P_2N_3P_3N")
   _fRet := .F.
EndIf

If SubStr(cNumEmp,1,2) == "01"
	If !(Empty(Alltrim(_cEstrut))) .And. !(SubStr(M->B1_PROCED,1,1)=='1')
		apmsgStop("Produto com Estrutura não pode ser alterado a procedência!"+chr(13)+chr(10)+"Favor excluir a estrutura antes de alterar")
		_fRet := .F.
	EndIf
EndIf

//VICTOR DESSUNTE - 17/02/2017
//INICIO - TICKET:2017021637000091
If _fRet .AND. SM0->M0_CODIGO $ "01*10"
	_cQry := " SELECT TOP 1 B9_XPROCED "
	_cQry += " FROM " + RetSqlName("SB9")
	_cQry += " WHERE "
	_cQry += " 		D_E_L_E_T_ 	= ' ' "
	_cQry += " AND 	B9_FILIAL 	= '" + xFilial("SB9") + "' "
	_cQry += " AND 	B9_LOCAL 	IN ('01','10') "
	_cQry += " AND 	B9_COD 		= '" + _cCod + "' "
	_cQry += " AND	B9_DATA		= (SELECT MAX(B9_DATA) FROM " + RetSqlName("SB9")
	_cQry += "						WHERE "
	_cQry += "							D_E_L_E_T_	= ' ' "
	_cQry += "						AND B9_FILIAL	= '" + xFilial("SB9") + "' "
	_cQry += "						AND B9_LOCAL	IN ('01','10') "
	_cQry += "						AND B9_COD		= '" + _cCod + "') "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY _cQry NEW ALIAS "TRB"
	
	TRB->(dbGoTop())
	
	If !Empty(TRB->B9_XPROCED) .AND. SubStr(TRB->B9_XPROCED,2,1) <>  SubStr(M->B1_PROCED,2,1)
		Alert("Produto já fechado em meses anteriores com procedencia diferente. Favor procurar TI.")
		_fRet := .F.
	EndIf
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
EndIf
//FIM - TICKET:2017021637000091

RestArea(_aArea)

Return _fRet
