#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR030  บAutor  ณVictor Dessunte     บ Data ณ  08/02/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio para conferencia mensal do fechamento de estoque  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RESTR030()

Private _lRet			:= .T.
Private _aDadRes		:= {}
Private _aDadROp		:= {}
Private _cMesAnt		:= ""
Private _cAnoMes		:= ""
Private _cAnoMesAnt	:= ""

If Pergunte("RESTR030",.T.)
	LjMsgRun("Filtrando dados...",,{||FilDados()})
	If _lRet
		LjMsgRun("Gerando Resumo por Produto..."			,,{||ResPro()	})
		LjMsgRun("Gerando Resumo por CFOP..."				,,{||ResCf()	})
		LjMsgRun("Gerando Resumo por OP..."					,,{||ResOP()	})
		LjMsgRun("Gerando Resumo Geral - Materiais..."	,,{||Res()		})
		LjMsgRun("Gerando Resumo Geral - Ops..."			,,{||ResOp2()	})
		LjMsgRun("Gerando Planilha..."						,,{||GeraPla()	})
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFilDados  บAutor  ณVictor Dessunte     บ Data ณ  08/02/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFiltra dados de acordo com parametros                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FilDados()

Local _aResult	:= {}
Local _cQry		:= ""
Local _cApaga	:= "0" //Define se apaga dados da tabela ZZ1
Local _cProc	:= ""
Local _cProcOp	:= ""

If SM0->M0_CODIGO == '01'
	_cProc 	:= "RESTR030_01"
	_cProcOp := "RESTR030B_01"
ElseIf SM0->M0_CODIGO == '10'
	_cProc	:= "RESTR030_10"
	_cProcOp	:= "RESTR030B_10"
EndIf

If !TCSPEXIST(_cProc)
	Alert("Stored Procedure de estoque (" + _cProc + ") nใo instalada na base de dados!")
	_lRet := .F.
	Return
EndIf

If !TCSPEXIST(_cProcOp)
	Alert("Stored Procedure de Op em processo (" + _cProcOp + ") nใo instalada na base de dados!")
	_lRet := .F.
	Return
EndIf

//Nome por extenso do mes anterior e ano anterior
_cMesAnt := STRZERO(VAL(SubStr(MV_PAR01,5,2))-1,2,0)
_cAnoAnt := SUBSTR(MV_PAR01,1,4)
If _cMesAnt == '00'
	_cMesAnt := '12'
	_cAnoAnt := ALLTRIM(STR(VAL(_cAnoAnt)-1))
EndIf
_cAnoMesAnt := MesExtenso(_cMesAnt) + "/" + _cAnoAnt

//Verifica se existe fechamento para o mes anterior
_cQry := " SELECT TOP 1 B9_COD FROM " + RetSqlName("SB9")
_cQry += " WHERE D_E_L_E_T_ = ' ' "
_cQry += " AND B9_FILIAL = '" + xFilial("SB9") + "' "
_cQry += " AND B9_DATA LIKE '" + _cAnoAnt+_cMesAnt + "%' "

If Select("TRBB9") > 0
	TRBB9->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBB9"

TRBB9->(dbGoTop())

If TRBB9->(EOF())
	If !MsgYesNo("Aten็ใo!!! Nใo existe fechamento do periodo anterior ao selecionado, deseja continuar?")
		If Select("TRBB9") > 0
			TRBB9->(dbCloseArea())
		EndIf
		_lRet := .F.
		Return
	EndIf
EndIf

If Select("TRBB9") > 0
	TRBB9->(dbCloseArea())
EndIf

_cQry := " SELECT TOP 1 ZZ1_PERIOD "
_cQry += " FROM " + RetSqlName("ZZ1") 
_cQry += " WHERE D_E_L_E_T_ = ' ' "
_cQry += " AND ZZ1_FILIAL = '" + xFilial("ZZ1") + "' "
_cQry += " AND ZZ1_PERIOD = '" + MV_PAR01 + "' "
_cQry += " AND ZZ1_OP	  = ''"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

TRB->(dbGoTop())
If TRB->(!EOF())
	If MsgYesNo("O periodo " + MV_PAR01 + " jแ existe na tabela de estoque, deseja sobrescrever os dados referente ao periodo digitado?")
		_cApaga := '1'
	EndIf
Else
	_cApaga := '1'
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

If _cApaga == '1'
	_aResult := TCSPEXEC(_cProc,MV_PAR01)
EndIf

If _aResult == Nil .AND. _cApaga == '1'
	_lRet := .F.
	Alert("Nใo foi possํvel gerar os dados na tabela ZZ1 referente ao estoque: " + TcSqlError(),_cProc)
Else
	_cApaga	:= '0'
	_aResult	:= {}
	
	_cQry := " SELECT TOP 1 ZZ1_PERIOD "
	_cQry += " FROM " + RetSqlName("ZZ1") 
	_cQry += " WHERE D_E_L_E_T_ = ' ' "
	_cQry += " AND ZZ1_FILIAL = '" + xFilial("ZZ1") + "' "
	_cQry += " AND ZZ1_PERIOD = '" + MV_PAR01 + "' "
	_cQry += " AND ZZ1_OP	  <> '' "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY _cQry NEW ALIAS "TRB"
	
	TRB->(dbGoTop())
	If TRB->(!EOF())
		If MsgYesNo("O periodo " + MV_PAR01 + " jแ existe na tabela de Ops em processo, deseja sobrescrever os dados referente ao periodo digitado?")
			_cApaga := '1'
		EndIf
	Else
		_cApaga := '1'
	EndIf
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	If _cApaga == '1'
		_aResult := TCSPEXEC(_cProcOp,MV_PAR01)
	EndIf
	
	If _aResult == Nil .AND. _cApaga == '1'
		_lRet := .F.
		Alert("Nใo foi possํvel gerar os dados na tabela ZZ1 referente as ops em processo: " + TcSqlError(),_cProcOp)
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraPla   บAutor  ณVictor Dessunte     บ Data ณ  13/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera planilha com os dados filtrados                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraPla()

Local oExcel		:= FWMSEXCEL():New()
Local _nCalc		:= 0
Local _nDiv			:= 0
Local _nX			:= 0
Local _nAc			:= 0
Local _nBd			:= 0
Local _cTitRes		:= AllTrim(SM0->M0_NOME) + " - " + MesExtenso(SubStr(MV_PAR01,5,2)) + "/" + SubStr(MV_PAR01,1,4)
Local cNomeArq		:= Upper(AllTrim(SM0->M0_NOME)	+	'_'	+ AllTrim(MV_PAR01)	+ '_' +	AllTrim(DTOS(DATE()))	+	'_'	+	AllTrim(StrTran(TIME(),':',''))	+	'_'	+ 'RESTR030.xml')

oExcel:AddWorkSheet("Resumo")
oExcel:AddTable("Resumo",_cTitRes)
oExcel:AddColumn("Resumo",_cTitRes,"Descri็ใo"	,1,1,.F.)
oExcel:AddColumn("Resumo",_cTitRes,"Valores"		,3,2,.F.)

oExcel:AddWorkSheet("Resumo por Produto")
oExcel:AddTable("Resumo por Produto","Resumo por Produto")
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","Codigo"										,1,1,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","01 - Saldo Mes Anterior"				,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","02 - Entradas com NF"					,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","03 - Devolu็ใo de Vendas"				,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","04 - Entradas por OP"					,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","05 - Devolu็oes Internas"				,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","06 - Saidas com NF"						,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","07 - Devolu็ใo de Compras"				,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","08 - Requisicoes Internas para OPs"	,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","09 - Requisicoes Internas Avulsas"	,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","10 - Saldo Final"							,3,2,.F.)

oExcel:AddColumn("Resumo por Produto","Resumo por Produto","Saldo Calculado"							,3,2,.F.)
oExcel:AddColumn("Resumo por Produto","Resumo por Produto","Divergencia"								,3,2,.F.)

oExcel:AddWorkSheet("Resumo por CFOP")
oExcel:AddTable("Resumo por CFOP","Resumo por CFOP")
oExcel:AddColumn("Resumo por CFOP","Resumo por CFOP","Codigo"	,1,1,.F.)
oExcel:AddColumn("Resumo por CFOP","Resumo por CFOP","Valor"	,3,2,.F.)

oExcel:AddWorkSheet("Resumo por OP")
oExcel:AddTable("Resumo por OP","Resumo por OP")
oExcel:AddColumn("Resumo por OP","Resumo por OP","OP"											,1,1,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","01 - OPs Periodo anterior"			,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","02 - MOD - Mใo de obra"				,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","03 - Requisicoes para OPs"			,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","04 - OPs 	Refugadas"					,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","05 - OPs Apontadas Parcialmente"	,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","06 - Entradas por OP"					,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","07 - OPs em Processo (Final)"		,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","Saldo Calculo"							,3,2,.F.)
oExcel:AddColumn("Resumo por OP","Resumo por OP","Divergencia"								,3,2,.F.)

oExcel:AddWorkSheet("Resumo por Tipo")
oExcel:AddTable("Resumo por Tipo","Resumo por Tipo")
oExcel:AddColumn("Resumo por Tipo","Resumo por Tipo","Tipo"		,1,1,.F.)
oExcel:AddColumn("Resumo por Tipo","Resumo por Tipo","Valor"	,3,2,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera Resumo de Materiaisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(_aDadRes) > 0
	For _nX:=1 To 10
		If aScan(_aDadRes,{|x| x[1] == AllTrim(STRZERO(_nX,2))}) > 0
			&('_n0'+AllTrim(STR(_nX))) := _aDadRes[aScan(_aDadRes,{|x| x[1] == AllTrim(STRZERO(_nX,2))}),2]
		Else
			&('_n0'+AllTrim(STR(_nX))) := 0
		EndIf
	Next _nX
	
	oExcel:AddRow("Resumo",_cTitRes,{"Materiais"											,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Saldo anterior em " + _cAnoMesAnt			,&('_n01')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Compras do M๊s"									,&('_n02')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Devolu็๕es de Compras"							,&('_n07')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Produ็ใo"											,&('_n04')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Devolu็๕es Avulsas"								,&('_n05')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Requisi็๕es Produ็ใo (Ops Produtivas)"	,&('_n08')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Requisi็๕es Avulsas"							,&('_n09')	})
	oExcel:AddRow("Resumo",_cTitRes,{"CPV"													,&('_n06')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Devolu็๕es de Vendas (Custo)"				,&('_n03')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Total Materiais (a)"							,&('_n01')+&('_n02')+&('_n03')+&('_n04')+&('_n05')+&('_n06')+&('_n07')+&('_n08')+&('_n09')})
	oExcel:AddRow("Resumo",_cTitRes,{"Total Materiais (Aba Estoque Atual)(b)"	,&('_n010')	})
	oExcel:AddRow("Resumo",_cTitRes,{"Diverg๊ncia"										,&('_n010')-(&('_n01')+&('_n02')+&('_n03')+&('_n04')+&('_n05')+&('_n06')+&('_n07')+&('_n08')+&('_n09'))})
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera Resumo de Ops em processoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(_aDadROp) > 0
	For _nX:=1 To 7
		If aScan(_aDadROp,{|x| SubStr(x[1],2,1)==AllTrim(STR(_nX))}) > 0
			&('_nP0'+AllTrim(STR(_nX))) := _aDadROp[aScan(_aDadROp,{|x| SubStr(x[1],2,1)==AllTrim(STR(_nX))}),2]
		Else
			&('_nP0'+AllTrim(STR(_nX))) := 0
		EndIf
	Next _nX
	
	oExcel:AddRow("Resumo",_cTitRes,{""														,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Ops em Processo"										,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Saldo anterior em " + _cAnoMesAnt						,&('_nP01')		})
	oExcel:AddRow("Resumo",_cTitRes,{"Mใo de Obra"											,&('_nP02')		})
	oExcel:AddRow("Resumo",_cTitRes,{"Produ็ใo"												,&('_nP06')		})
	oExcel:AddRow("Resumo",_cTitRes,{"Requisi็๕es para produ็ใo"							,&('_nP03')		})
	oExcel:AddRow("Resumo",_cTitRes,{"Ops refugadas"										,&('_nP04')		})
	oExcel:AddRow("Resumo",_cTitRes,{"Ops parciais"											,&('_nP05')		})
	oExcel:AddRow("Resumo",_cTitRes,{"Total Ops em Processo (c)"							,&('_nP01')+&('_nP02')+&('_nP03')+&('_nP04')+&('_nP05')+&('_nP06')})
	oExcel:AddRow("Resumo",_cTitRes,{"Total de Ops em Processo (Aba Ops em processo) (d)"	,&('_nP07')		})
	oExcel:AddRow("Resumo",_cTitRes,{"Diverg๊ncia"											,&('_nP07')-(&('_nP01')+&('_nP02')+&('_nP03')+&('_nP04')+&('_nP05')+&('_nP06'))})
Else
	//Tratamento para o error log, pois quando nใo tem informa็๕es no array da pal, entใo cai no IF e trata, para nใo apresentar o erro.
	_nP01 := 0
	_nP02 := 0
	_nP03 := 0
	_nP04 := 0
	_nP05 := 0
	_nP06 := 0
	_nP07 := 0
	oExcel:AddRow("Resumo",_cTitRes,{""														,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Ops em Processo"										,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Saldo anterior em " + _cAnoMesAnt						,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Mใo de Obra"											,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Produ็ใo"												,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Requisi็๕es para produ็ใo"							,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Ops refugadas"										,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Ops parciais"											,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Total Ops em Processo (c)"							,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Total de Ops em Processo (Aba Ops em processo) (d)"	,0				})
	oExcel:AddRow("Resumo",_cTitRes,{"Diverg๊ncia"											,0				})
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTotal Geral do Estoque ณ
//ณ(a) + (c)              ณ
//ณ(b) + (d)              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nAc := (&('_n01')+&('_n02')+&('_n03')+&('_n04')+&('_n05')+&('_n06')+&('_n07')+&('_n08')+&('_n09')) + (&('_nP01')+&('_nP02')+&('_nP03')+&('_nP04')+&('_nP05')+&('_nP06'))
_nBd := &('_n010')+&('_nP07')

oExcel:AddRow("Resumo",_cTitRes,{""																	,0		})
oExcel:AddRow("Resumo",_cTitRes,{""																	,0		})
oExcel:AddRow("Resumo",_cTitRes,{"Total ( a ) + ( c )"										,_nAc	})
oExcel:AddRow("Resumo",_cTitRes,{"Estoque projetado no final do m๊s ( b ) + ( d )"	,_nBd	})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera dados do resumo por Produtoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRBPRO")
TRBPRO->(dbGoTop())
While TRBPRO->(!EOF())
	//Saldo Calculado
   _nCalc := TRBPRO->COL01+TRBPRO->COL02+TRBPRO->COL03+TRBPRO->COL04+TRBPRO->COL05+TRBPRO->COL06+TRBPRO->COL07+TRBPRO->COL08+TRBPRO->COL09
   
   //Divergencia
   _nDiv := _nCalc - TRBPRO->COL10
   
	oExcel:AddRow("Resumo por Produto","Resumo por Produto"	,{ TRBPRO->CODIGO	,;//01-Codigo
																					TRBPRO->COL01	,;//02-01 - Saldo Mes Anterior
																					TRBPRO->COL02	,;//03-02 - Entradas com NF
																					TRBPRO->COL03	,;//04
																					TRBPRO->COL04	,;//05
																					TRBPRO->COL05	,;//06
																					TRBPRO->COL06	,;//07
																					TRBPRO->COL07	,;//08
																					TRBPRO->COL08	,;//09
																					TRBPRO->COL09	,;//10
																					TRBPRO->COL10	,;//11
																					_nCalc			,;//12-Saldo Calculado
																					_nDiv				})//13-Divergencia
	TRBPRO->(dbSkip())
End

If Select("TRBPRO") > 0
	TRBPRO->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera dados do resumo por CFOPณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRBCF")
TRBCF->(dbGoTop())
While TRBCF->(!EOF())
	oExcel:AddRow("Resumo por CFOP","Resumo por CFOP"	,{	TRBCF->CF		,;//01-Codigo do CFOP
																			TRBCF->VALOR	})//02-Valor
	TRBCF->(dbSkip())
End

If Select("TRBCF") > 0
	TRBCF->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera dados do resumo por OPณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRBOP")
TRBOP->(dbGotop())
While TRBOP->(!EOF())
	//Saldo Calculado
   _nCalc := TRBOP->COL01+TRBOP->COL02+TRBOP->COL03+TRBOP->COL04+TRBOP->COL05+TRBOP->COL06
   
   //Divergencia
   _nDiv := _nCalc - TRBOP->COL07
	
	oExcel:AddRow("Resumo por OP","Resumo por OP",{	TRBOP->OP		,;//01-OP
																	TRBOP->COL01	,;//02-01 - OPs Periodo anterior
																	TRBOP->COL02	,;//03-02 - MOD - Mใo de obra
																	TRBOP->COL03	,;//04-03 - Requisicoes para OPs
																	TRBOP->COL04	,;//05-04 - OPs Refugadas
																	TRBOP->COL05	,;//06-05 - OPs Apontadas Parcialmente
																	TRBOP->COL06	,;//07-06 - Entradas por OP
																	TRBOP->COL07	,;//08-07 - OPs em Processo (Final)
																	_nCalc			,;//09-Saldo Calculado
																	_nDiv				})//10-Divergencia
	
	TRBOP->(dbSkip())
End

If Select("TRBOP") > 0
	TRBOP->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera dados do resumo por Tipo de Produtoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRBGTP")
TRBGTP->(dbGotop())
While TRBGTP->(!EOF())
	oExcel:AddRow("Resumo por Tipo","Resumo por Tipo",{	TRBGTP->TIPO	,;//01-TIPO
																			TRBGTP->VALOR	})//10-VALOR
	
	TRBGTP->(dbSkip())
End

If Select("TRBGTP") > 0
	TRBGTP->(dbCloseArea())
EndIf

oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/" + cNomeArq)

If File("C:/RELATO_MICROSIGA/" + cNomeArq)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/" + cNomeArq)
	oExcelApp:SetVisible(.T.)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR030  บAutor  ณVictor Dessunte     บ Data ณ  02/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dados para adicionar na aba Resumo por Produto             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ResPro()

Local _cQry := ""

_cQry := " SELECT " + CRLF
_cQry += "		ZZ1_COD														 AS 'CODIGO', " + CRLF
_cQry += "		ISNULL([01 - Saldo Mes Anterior]					,0) AS 'COL01',	" + CRLF
_cQry += "		ISNULL([02 - Entradas com NF]						,0) AS 'COL02',	" + CRLF
_cQry += "		ISNULL([03 - Devolu็ใo de Vendas]				,0) AS 'COL03',	" + CRLF
_cQry += "		ISNULL([04 - Entradas por OP]						,0) AS 'COL04',	" + CRLF
_cQry += "		ISNULL([05 - Devolu็oes Internas]				,0) AS 'COL05',	" + CRLF
_cQry += "		ISNULL([06 - Saidas com NF]						,0) AS 'COL06',	" + CRLF
_cQry += "		ISNULL([07 - Devolu็ใo de Compras]				,0) AS 'COL07',	" + CRLF
_cQry += "		ISNULL([08 - Requisicoes Internas para OPs]	,0) AS 'COL08',	" + CRLF
_cQry += "		ISNULL([09 - Requisicoes Internas Avulsas]	,0) AS 'COL09',	" + CRLF
_cQry += "		ISNULL([10 - Saldo Final]							,0) AS 'COL10'		" + CRLF
_cQry += "	FROM " + CRLF
_cQry += "		( " + CRLF
_cQry += "			SELECT ZZ1_COD,ZZ1_TIPO,ZZ1_VALOR FROM " + RetSqlName("ZZ1")
_cQry += "			WHERE  " + CRLF
_cQry += "				D_E_L_E_T_	= ' ' " + CRLF
_cQry += "			AND ZZ1_FILIAL	= '" + xFilial("ZZ1") + "' " + CRLF
_cQry += "			AND ZZ1_PERIOD	= '" + MV_PAR01 + "' " + CRLF
_cQry += "			AND ZZ1_OP		= '' " + CRLF
_cQry += "		) A " + CRLF
_cQry += "		PIVOT " + CRLF
_cQry += "		( " + CRLF
_cQry += "			SUM(ZZ1_VALOR) " + CRLF
_cQry += "		FOR ZZ1_TIPO IN(	[01 - Saldo Mes Anterior]					,	" + CRLF
_cQry += "								[02 - Entradas com NF]						,	" + CRLF
_cQry += "								[03 - Devolu็ใo de Vendas]					,	" + CRLF
_cQry += "								[04 - Entradas por OP]						,	" + CRLF
_cQry += "								[05 - Devolu็oes Internas]					,	" + CRLF
_cQry += "								[06 - Saidas com NF]							,	" + CRLF
_cQry += "								[07 - Devolu็ใo de Compras]				,	" + CRLF
_cQry += "								[08 - Requisicoes Internas para OPs]	,	" + CRLF
_cQry += "								[09 - Requisicoes Internas Avulsas]		,	" + CRLF
_cQry += "								[10 - Saldo Final])	" + CRLF
_cQry += "		) AS B " + CRLF
_cQry += "	ORDER BY ZZ1_COD "

If Select("TRBPRO") > 0
	TRBPRO->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBPRO"

TRBPRO->(dbGotop())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR030  บAutor  ณVictor Dessunte     บ Data ณ  02/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dados para adicionar na aba Resumo por CFOP                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ResCf()

Local _cQry := ""

_cQry := " SELECT " + CRLF
_cQry += "		CASE " + CRLF
_cQry += "			WHEN SUBSTRING(ZZ1_CF,1,3) = 'RE0' THEN " + CRLF
_cQry += "				SUBSTRING(ZZ1_CF,1,3) " + CRLF
_cQry += "			ELSE " + CRLF
_cQry += "				ZZ1_CF " + CRLF
_cQry += "		END AS CF, " + CRLF
_cQry += "		SUM(ZZ1_VALOR) VALOR " + CRLF
_cQry += "	FROM " + CRLF
_cQry += 		RetSqlName("ZZ1") 
_cQry += "	WHERE " + CRLF
_cQry += "		D_E_L_E_T_ = ' ' " + CRLF
_cQry += "	AND ZZ1_FILIAL = '" + xFilial("ZZ1") + "' " + CRLF
_cQry += "	AND ZZ1_PERIOD = '" + MV_PAR01 + "' " + CRLF
_cQry += "	AND ZZ1_OP		= '' " + CRLF
_cQry += "	GROUP BY " + CRLF
_cQry += "		CASE " + CRLF
_cQry += "			WHEN SUBSTRING(ZZ1_CF,1,3) = 'RE0' THEN " + CRLF
_cQry += "				SUBSTRING(ZZ1_CF,1,3) " + CRLF
_cQry += "			ELSE " + CRLF
_cQry += "				ZZ1_CF " + CRLF
_cQry += "		END "

If Select("TRBCF") > 0
	TRBCF->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBCF"

TRBCF->(dbGoTop())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR030  บAutor  ณVictor Dessunte     บ Data ณ  02/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dados para adicionar na aba Resumo por OP                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ResOP()

Local _cQry := ""

_cQry := " SELECT " + CRLF
_cQry += "		ZZ1_OP										    		 AS 'OP', " + CRLF
_cQry += "		ISNULL([01 - OPs Periodo anterior]			,0) AS 'COL01', " + CRLF
_cQry += "		ISNULL([02 - MOD - Mใo de obra]				,0) AS 'COL02', " + CRLF
_cQry += "		ISNULL([03 - Requisicoes para OPs]			,0) AS 'COL03', " + CRLF
_cQry += "		ISNULL([04 - OPs Refugadas]					,0) AS 'COL04', " + CRLF
_cQry += "		ISNULL([05 - OPs Apontadas Parcialmente]	,0) AS 'COL05', " + CRLF
_cQry += "		ISNULL([06 - Entradas por OP]					,0) AS 'COL06', " + CRLF
_cQry += "		ISNULL([07 - OPs em Processo (Final)]		,0) AS 'COL07' " + CRLF
_cQry += "	FROM " + CRLF
_cQry += "		( " + CRLF
_cQry += "			SELECT ZZ1_OP,ZZ1_TIPO,ZZ1_VALOR FROM " + RetSqlName("ZZ1") + CRLF
_cQry += "			WHERE " + CRLF
_cQry += "				D_E_L_E_T_	= ' ' " + CRLF
_cQry += "			AND ZZ1_FILIAL	= '" + xFilial("ZZ1") + "' " + CRLF
_cQry += "			AND ZZ1_PERIOD	= '" + MV_PAR01 + "' " + CRLF
_cQry += "			AND ZZ1_OP		<> '' " + CRLF
_cQry += "		) A " + CRLF
_cQry += "		PIVOT " + CRLF
_cQry += "		( " + CRLF
_cQry += "			SUM(ZZ1_VALOR)  " + CRLF
_cQry += "			FOR ZZ1_TIPO IN(	[01 - OPs Periodo anterior]			, " + CRLF
_cQry += "									[02 - MOD - Mใo de obra]				, " + CRLF
_cQry += "									[03 - Requisicoes para OPs]			, " + CRLF
_cQry += "									[04 - OPs Refugadas]						, " + CRLF
_cQry += "									[05 - OPs Apontadas Parcialmente]	, " + CRLF
_cQry += "									[06 - Entradas por OP]					, " + CRLF
_cQry += "									[07 - OPs em Processo (Final)]		) " + CRLF
_cQry += "		) AS B " + CRLF
_cQry += "	ORDER BY ZZ1_OP "

If Select("TRBOP") > 0
	TRBOP->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBOP"

TRBOP->(dbGoTop())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR030  บAutor  ณVictor Dessunte     บ Data ณ  15/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dados para adicionar na aba Resumo - Materiais             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Res()

Local _cQry := ""

_cQry := " SELECT " + CRLF
_cQry += "		SUBSTRING(ZZ1_TIPO,1,2) TIPO, " + CRLF
_cQry += "		ROUND(SUM(ZZ1_VALOR),2) VALOR " + CRLF
_cQry += " FROM " + CRLF
_cQry +=			RetSqlName("ZZ1")
_cQry += " WHERE " + CRLF
_cQry += "		D_E_L_E_T_	= '' " + CRLF
_cQry += " AND ZZ1_FILIAL	= '" + xFilial("ZZ1") + "' " + CRLF
_cQry += " AND ZZ1_OP		= '' " + CRLF
_cQry += " AND ZZ1_PERIOD	= '" + MV_PAR01 + "' " + CRLF
_cQry += " GROUP BY ZZ1_TIPO "

If Select("TRBRES") > 0
	TRBRES->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBRES"

TRBRES->(dbGotop())
While TRBRES->(!EOF())
	AADD(_aDadRes,{TRBRES->TIPO,TRBRES->VALOR})
	TRBRES->(dbSkip())
End

If Select("TRBRES") > 0
	TRBRES->(dbCloseArea())
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR030  บAutor  ณVictor Dessunte     บ Data ณ  16/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Dados para adicionar na aba Resumo - OPs em processo       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ResOp2()

Local _cQry := ""

_cQry := " SELECT " + CRLF
_cQry += "		SUBSTRING(ZZ1_TIPO,1,2) TIPO, " + CRLF
_cQry += "		ROUND(SUM(ZZ1_VALOR),2) VALOR " + CRLF
_cQry += " FROM " + CRLF
_cQry +=			RetSqlName("ZZ1")
_cQry += " WHERE " + CRLF
_cQry += "		D_E_L_E_T_	= '' " + CRLF
_cQry += " AND ZZ1_FILIAL	= '" + xFilial("ZZ1") + "' " + CRLF
_cQry += " AND ZZ1_OP		<> '' " + CRLF
_cQry += " AND ZZ1_PERIOD	= '" + MV_PAR01 + "' " + CRLF
_cQry += " GROUP BY ZZ1_TIPO "

If Select("TRBGTP") > 0
	TRBGTP->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBGTP"

TRBGTP->(dbGotop())
While TRBGTP->(!EOF())
	AADD(_aDadROp,{TRBGTP->TIPO,TRBGTP->VALOR})
	TRBGTP->(dbSkip())
End

TRBGTP->(dbGoTop())

Return
