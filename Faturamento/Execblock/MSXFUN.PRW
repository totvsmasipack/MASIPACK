#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "Rwmake.ch"
#INCLUDE "MASI_EMP.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF  CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSEMPENHO บAutor  ณVictor Dessunte     บ Data ณ  03/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica quantidade de empenho + pedido                     บฑฑ
ฑฑบ          ณParametro1: Codigo do produto                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSEMPENHO(_cCod)

Local _aArea	:= GetArea()
Local _cQry		:= ""
Local _nTotal	:= 0

Default _cCod := ""

_cQry := " SELECT																" + CRLF
_cQry += "		(SELECT														" + CRLF
_cQry += "			ISNULL(SUM(D4_QUANT),0) AS 'QTDE'				" + CRLF
_cQry += "		FROM															" + CRLF
_cQry += 			RetSqlName("SD4")
_cQry += "		WHERE															" + CRLF
_cQry += "			D_E_L_E_T_		= ' '									" + CRLF
_cQry += "		AND D4_FILIAL		= '" + xFilial("SD4") + "'		" + CRLF
_cQry += "		AND D4_COD			= '" + _cCod + "'					" + CRLF
_cQry += "		AND D4_LOCAL		= '01'								" + CRLF
_cQry += "		AND D4_QUANT		> 0)									" + CRLF
_cQry += "		+																" + CRLF
_cQry += "		(SELECT														" + CRLF
_cQry += "			ISNULL(SUM(C6_QTDVEN),0) AS VEN					" + CRLF
_cQry += "		FROM															" + CRLF
_cQry += 			RetSqlName("SC6")
_cQry += "		WHERE															" + CRLF
_cQry += "			D_E_L_E_T_ 	= ' '										" + CRLF
_cQry += "		AND C6_FILIAL 	= '" + xFilial("SC6") + "'			" + CRLF
_cQry += "		AND C6_BLQ 		<> 'R'									" + CRLF
_cQry += "		AND C6_QTDENT 	<> C6_QTDVEN							" + CRLF
_cQry += "		AND C6_PRODUTO 	= '" + _cCod + "') AS TOTAL	"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

TRB->(dbGoTop())

If TRB->(!EOF())
	_nTotal := TRB->TOTAL
EndIf

If Select("TRB") > 0
	TRB->(dbCloseAreA())
EndIf

RestArea(_aArea)

Return _nTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSEMPEN2  บAutor  ณVictor Dessunte     บ Data ณ  03/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se existem empenhos ou requisicoes para a OP       บฑฑ
ฑฑบ          ณParametro 1:Codigo do produto                               บฑฑ
ฑฑบ          ณParametro 2:Codigo da OP                                    บฑฑ
ฑฑบ          ณParametro 3:Opcao de consulta                               บฑฑ
ฑฑบ          ณ            1 - Verifica itens no SD4                       บฑฑ
ฑฑบ          ณ            2 - Verifica requisicoes no SD3                 บฑฑ
ฑฑบ          ณ            3 - Verifica SD4 e SD3                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSEMPEN2(_cCod,_cOp,_nOpc)

Local _aArea := GetArea()
Local _cQry  := ""
Local _nTot	 := 0

If _nOpc == 1 .OR. _nOpc == 3
	_cQry := "		SELECT														" + CRLF
	_cQry += "			COUNT(*) AS TOT										" + CRLF
	_cQry += "		FROM															" + CRLF
	_cQry	+=				RetSqlName("SD4")
	_cQry += "		WHERE															" + CRLF
	_cQry += "				D_E_L_E_T_	=  ' '								" + CRLF
	_cQry += "		AND	D4_FILIAL	=  '" + xFilial("SD4") 	+ "'	" + CRLF
	_cQry += "		AND	D4_COD		<> '" + _cCod 				+ "'	" + CRLF
	_cQry += "		AND	D4_OP			=  '" + _cOp 				+ "'	" + CRLF
	_cQry += "		AND	D4_QUANT		>  0									" + CRLF
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY _cQry NEW ALIAS "TRB"
	
	TRB->(dbGotop())
	_nTot := TRB->TOT
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
EndIf

If _nOpc == 2 .OR. _nOpc == 3
	_cQry := "		SELECT														" + CRLF
	_cQry += "			COUNT(*) AS TOT										" + CRLF
	_cQry += "		FROM 															" + CRLF
	_cQry += 			RetSqlName("SD3")
	_cQry += "		WHERE															" + CRLF
	_cQry += "				D_E_L_E_T_	= ' '									" + CRLF
	_cQry += "		AND 	D3_FILIAL	= '" + xFilial("SD3")	+ "'	" + CRLF
	_cQry += "		AND 	D3_OP			= '" + _cOp					+ "'	" + CRLF
	_cQry += "		AND 	D3_ESTORNO	= ' '									" + CRLF
	_cQry += "		AND 	D3_CF			LIKE 'R%'							"
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY _cQry NEW ALIAS "TRB"
	
	TRB->(dbGotop())
	_nTot += TRB->TOT
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
EndIf

RestArea(_aArea)

Return _nTot

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_FATF52QR()  บAutor  ณIvandro M P Santosบ Data ณ  08/04/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar para os gatilhos do c๓digo do municํpio e  บฑฑ
ฑฑบ          ณ Pais (A1_COD_MUN e A1_PAIS respectivamente).               บฑฑ
ฑฑบ          ณ Executa a query conforme parโmetro recebido                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

User Function FATG52QR(_cQuery)
Local _nRegiao := 0
	
IF !(IsInCallStack("U_MSARECLI") .OR. IsInCallStack("U_MSALTSA1") .OR. IsInCallStack("U_MSINCSA1"))
	If Select("QR1") > 0
		dbSelectArea("QR1")
		dbCloseArea()
	EndIf
	//-----------------------
	//| Cria uma view no banco
	//+-----------------------
	dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "QR1", .T., .F. )
	dbSelectArea("QR1")
	
	While QR1->(!Eof())
		_nRegiao ++
		
		aAdd(_aRegiao,QR1->REGIAO)
		
		QR1->(dbSkip())
	End
	
	If _nRegiao > 1
		_cReg := U_FATG52RE()
	Elseif _nRegiao == 1
		_cReg := Left(_aRegiao[1],5)
	EndIf
Endif

Return _cReg
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_FATG52RE()  บAutor  ณIvandro M P Santosบ Data ณ  08/04/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar para os gatilhos do c๓digo do municํpio e  บฑฑ
ฑฑบ          ณ Pais (A1_COD_MUN e A1_PAIS respectivamente).               บฑฑ
ฑฑบ          ณ Abre tela com o combo para selecionar as regi๕es corretas  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function FATG52RE()
	Static oDlg
	
	Local oRadio
	
	IF !(IsInCallStack("U_MSARECLI") .OR. IsInCallStack("U_MSALTSA1") .OR. IsInCallStack("U_MSINCSA1"))
	DEFINE MSDIALOG oDlg FROM  094,1 TO 230,300 TITLE "Informe a Regiao correta!" PIXEL

	@ 05,07 TO 45, 145 OF oDlg  PIXEL
	@ 10,10 SAY OemToAnsi("Qual Regiใo especํfica?") PIXEL 
	@ 20,10 COMBOBOX oRadio VAR _cEscolha ITEMS _aRegiao SIZE 130,130 PIXEL

	DEFINE SBUTTON FROM 048,055 TYPE 1 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
	
	_cReg := Left(_cEscolha,5)
	Endif
Return _cReg


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSACHAEM  บAutor  ณMicrosiga           บ Data ณ  05/20/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca as empresas do grupo diretamente no SIGAMAT para obterบฑฑ
ฑฑบ          ณinforma็๕es para implantar os pedidos intercompany          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณExp 1 - Array com os nomes das empresas intercompany        บฑฑ
ฑฑบ          ณExp 2 - Empresa atual logada pelo usuแrio                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณArray com informa็๕es do grupo, filial, nome e CNPJ    	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบUso       ณ MSXFUN                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MSACHAEM(aNomEmp,_cEmpresa)
Local _nEmp := 1
Local nI
Private  aDadosEmp 	:= {"","","",""}
Private _aItPed 	:= {}

//A fun็ใo FWLoadSM0 alimenta o array com dados das empresas do grupo
aSM0 := FWLoadSM0()
For nI := 1 To Len(aSM0)
	If Alltrim(aSM0[nI][6])==Alltrim(aNomEmp[1])
		_nEmp := 1
	ElseIf Alltrim(aSM0[nI][6])==Alltrim(aNomEmp[2])
		_nEmp := 2
	EndIf
    //Alimentando os dados da empresa 
	If _cEmpresa != aSM0[nI][1] .And. Alltrim(aSM0[nI][6]) == aNomEmp[_nEmp]
	   aDadosEmp[MS_GRUPO]  := aSM0[nI][1]
	   aDadosEmp[MS_FILIAL] := aSM0[nI][2]
	   aDadosEmp[MS_NOME]   := aSM0[nI][6]
	   aDadosEmp[MS_CNPJ]   := aSM0[nI][18]
	EndIf
Next nI

Return aDadosEmp


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSCODCLI  บAutor  ณIvandro Santos      บ Data ณ  05/24/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o cliente caseo nใo esteja bloqueado. Fun็ใo criada บฑฑ
ฑฑบ          ณ para trazer o c๓digo correto do cliente                    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบParametrosณ Exp1 : Array aDadosEmp cont๊m informa็๕es do Grupo, Filial,บฑฑ
ฑฑบ          ณ Nome e CNPJ.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MSXFUN                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSCODCLI(aDadosEmp)

Local _aArea	:= { SA1->(GetArea()) }
Local _aCli	:= {}

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))

	If SA1->(DbSeek( FWxFilial("SA1") + aDadosEmp[MS_CNPJ] ))
	
		While SA1->(!EOF()) .and. SA1->A1_CGC == aDadosEmp[MS_CNPJ]
			If SA1->A1_MSBLQL <> '1'
				AADD(_aCli,SA1->A1_COD+SA1->A1_LOJA)
			Endif
			SA1->(DbSkip())
		Enddo
		
	Endif
	
	AEval(_aArea,{|x| RestArea(x) })

Return _aCli


/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณMSVALPRO  		ณ Autor ณIvandro Santos      ณData ณ13.04.2016   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณConsulta Produto para validar a exist๊ncia e o NCM			   	 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ	Exp1 : Codigo do Produto a ser validado/criado                  ณฑฑ
ฑฑณ          ณ	Exp2 : Array com retorno dos dados para preenchimento do produtoณฑฑ
ฑฑณ          ณ	Exp3 : Mensagem de retorno                                      ณฑฑ
ฑฑณ          ณ	Exp4 : Quantidade a retornar para abertura de PV                ณฑฑ
ฑฑณ          ณ	Exp5 : Pre็o de Venda a retornar para abertura do PV      	    ณฑฑ
ฑฑณ          ณ	Exp6 : Grupo de Vendas do Produto                          	    ณฑฑ
ฑฑณ          ณ	Exp7 : Grupo de Maquinas que o produto pertence            	    ณฑฑ
ฑฑณ          ณ	Exp8 : Descri็ใo do Produto                                	    ณฑฑ
ฑฑณ          ณ	Exp9 : Proced๊ncia do Produto                              	    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Array com informa็๕es do produto e TES cadastrada no produto	 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                      	
User Function MSVALPRO(CodigoProd,aProd,cMsg,nQuant,_nPreco,_cGrVen,_GrMaq,_Desc,_Proced,_cNCM,_cDepImp)

Local lRet		:= .T.        
Local aArea		:= SB1->(GetArea())          
Local _nPosic	:= 0
Local _nTam		:= 0
Local _lAchouF	:= IsInCallStack("cadtest")
Local _dData	:= dDataBase
Local _cBaseR	:= ""

Default _cNCM  := ""
Default _cDepImp  := ""
Default aProd	:= Array(12)

SB1->(dbSetOrder(1)) 
If _cDepImp == "C" .Or. _lAchouF             	
	_nPosic := AT("MB",_Desc)
	_nTam   := Len(Alltrim(_Desc))
	_DescN	:= SUBSTR(Alltrim(_Desc),_nPosic,_nTam-_nPosic+1)
	If !_lAchouF
		//_cNCM	:= IIF(Empty(_cNCM),GetAdvFval("SX5","X5_DESCRI",xFilial("SX5")+"Z9"+Alltrim(_GrMaq),1," "),_cNCM)
		_cBaseR	:= GetAdvFval("SYD","YD_BICMS",xFilial("SYD")+Alltrim(_cNCM),1," ")
	Endif
	//aaDD(aProd,CodigoProd,'PC',CodigoProd,"84224010",_dData,SB1->B1_TS,nQuant,_nPreco,'','1P',_cGrVen,_DescN)
	aProd[01] := CODIGOPROD
	aProd[02] := 'PC'
	aProd[03] := CodigoProd
	aProd[04] := IIf(Empty(_cNCM),"84224010",_cNCM)
	aProd[05] := _dData
	aProd[06] := nQuant
	aProd[07] := "804"
	aProd[08] := _nPreco
	aProd[09] := IIf(Empty(_cBaseR).Or._cBaseR=="N","","002")
	aProd[10] := _Proced 
	aProd[11] := _cGrVen
	aProd[12] := IIF(_lAchouF,_Desc,_DescN )
ElseIf SB1->(dbSeek(xFilial("SB1")+Alltrim(CODIGOPROD)))
	_nNCM := SB1->B1_POSIPI
	If Empty(Alltrim(_nNCM))
		lRet := .F.
		cMsg := "Produto "  + CODIGOPROD + " sem NCM"
	Else
		//aaDD(aProd,{CODIGOPROD,B1_UM,SB1->B1_MSGRPMA,_nNCM,_dData,SB1->B1_TS,_nPreco,SB1->B1_GRTRIB,SB1->B1_PROCED,_cGrVen,_Desc})
		aProd[01] := CODIGOPROD
		aProd[02] := B1_UM
		aProd[03] := SB1->B1_MSGRPMA
		aProd[04] := _nNCM
		aProd[05] := _dData
		aProd[06] := nQuant
		aProd[07] := SB1->B1_TS
		aProd[08] := _nPreco
		aProd[09] := SB1->B1_GRTRIB
		aProd[10] := SB1->B1_PROCED
		aProd[11] := _cGrVen
		aProd[12] := _Desc
	EndIf
	
Else
	lRet := .F.                
	cMsg := "Produto " + CODIGOPROD + " nใo cadastrado."
EndIf

RestArea(aArea)		
Return lRet

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณMSGERAB1  		ณ Autor ณIvandro Santos      ณData ณ13.04.2016   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณConsulta Produto para validar a exist๊ncia e o NCM			   	 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ	Exp1 : Codigo do Produto a ser validado/criado                  ณฑฑ
ฑฑณ          ณ	Exp2 : Array com informa็๕es de Proced๊ncia,Gr Vendas, UM, Desc ณฑฑ
ฑฑณ          ณ	Exp3 : Array com informa็๕es fiscais: ICM, IPI, Grupo Tributa็ใoณฑฑ
ฑฑณ          ณ	Exp4 : Array com informa็๕es tipo produto, CC, Conferencia,Tipo ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ C๓digo do produto criado                                    	 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 

User Function MSGERAB1(cprod,_aProdIn,_aFisProd,_aDadoAdi)

Local aProduto := {}

Private lMsErroAuto := .F.

	Begin Transaction
	
	aProduto := {{"B1_CONTRAT"		,"N"             												,Nil},;
				{"B1_LOCALIZ"		,"N"             												,Nil},;
				{"B1_PROCED"		,_aProdIn[10]				  									,Nil},;
				{"B1_MSGRVEN"		,_aProdIn[11]				  									,NIL},;
				{"B1_COD"			,cprod	        												,NIL},;
				{"B1_DESC"			,_aProdIn[12]   		  										,NIL},;
				{"B1_TIPO"			,_aDadoAdi[1]	 	  											,NIL},;
				{"B1_UM"			,_aProdIn[02]				  									,NIL},;
				{"B1_GRTRIB"		,IIF(!(_aFisProd[3]=="S"),"",IIF(_aFisProd[2]<18,"001","002"))	,NIL},;
				{"B1_CC"			,_aDadoAdi[2]       											,NIL},;
				{"B1_LOCPAD"		,IIF(SUBSTR(_aProdIn[10],2,1)=="N","10","01")					,NIL},;
				{"B1_ORIGEM"		,"0" 	          												,NIL},;
				{"B1_MSATOX"		,"N" 	         												,NIL},;
				{"B1_GARANT"		,_aDadoAdi[5] 	  												,NIL},;
				{"B1_POSIPI"		,_aProdIn[04] 		  											,NIL},;
				{"B1_PICM"			,_aFisProd[2]      												,NIL},;
				{"B1_IPI"			,_aFisProd[1]      												,NIL}}

	If !(Substr(cNumEmp,1,2) $ "15")
		AADD(aProduto,{"B1_MSCONF",_aDadoAdi[4],NIL})
		AADD(aProduto,{"B1_MSHEX",""			,NIL})
		AADD(aProduto,{"B1_MSCERT","N"	      	,NIL})
		AADD(aProduto,{"B1_REVATU","001"        ,NIL})
	Else
		AADD(aProduto,{"B1_GRUPO",_aDadoAdi[6] 	,NIL})
	Endif
	MSExecAuto({|x,y| Mata010(x,y)},aProduto,3)

	If lMsErroAuto
		DisarmTransaction()
		//MostraErro()
		Break              
		cProd := ""
	Endif
	End Transaction

Return(cProd)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMUDACOR  บAutor  ณMicrosiga            บ Data ณ  04/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO COMUM PARA OS PONTOS DE ENTRADA M440STTS, MTA455I   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10 - MASIPACK                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MUDACOR()

Local _aAreaSC9 := SC9->(GetArea())
Local lRet		:= .T.

	SC9->(dbSetOrder(1))
	SC9->(dbSeek(FWxFilial("SC9") + SC5->C5_NUM))

	If SC9->(FOUND())
		
		While !SC9->(EOF()) .AND. SC9->(C9_FILIAL + C9_PEDIDO) == FWxFilial("SC9") + SC5->C5_NUM
			
			If !(SC9->C9_BLEST $ '  |10|ZZ')
				lRet := .F.
				IF RecLock("SC5",.F.)
					SC5->C5_MSLIBPV := Padr('E',TamSX3("C5_MSLIBPV")[1])
					SC5->(MsUnlock())
				Endif
				Exit
			
			
			ElseIf !(SC9->C9_BLCRED $ '  |10|ZZ')
				lRet := .F.
				If RecLock("SC5",.F.)
					SC5->C5_MSLIBPV := Padr('C',TamSX3("C5_MSLIBPV")[1])
					SC5->(MsUnlock())
				Endif
				Exit
			
			Else
				IF RecLock("SC5",.F.)
					SC5->C5_MSLIBPV := SPACE(TamSX3("C5_MSLIBPV")[1])
					SC5->(MsUnlock())
				Endif
			
			Endif

			SC9->(dbSkip())
		Enddo

	Endif

	RestArea(_aAreaSC9)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSLEGPED  บAutor  ณIvandro Santos      บ Data ณ  06/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para colocar no browse a cor da libera็ใo do pedido บฑฑ
ฑฑบ          ณ de Venda                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rotinas que envolvem a legenda do Pedido de Venda          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSLEGPED()

Local _aRet := {}

Local lFldAprov	:= !Empty(FWSX3Util():GetFieldType( "C5_MSAPROV" ))
Local lFldPrior	:= !Empty(FWSX3Util():GetFieldType( "C5_MSPRIOR" ))
Local lFldLibPv	:= !Empty(FWSX3Util():GetFieldType( "C5_MSLIBPV" ))
Local lFldCateg	:= !Empty(FWSX3Util():GetFieldType( "C5_MSCATEG" ))

    If lFldAprov .And. lFldPrior .And. lFldLibPv
        AADD(_aRet,{"Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !(Alltrim(C5_MSLIBPV) $ 'E|C') .AND. C5_MSAPROV <> 'N' .AND. EMPTY(C5_MSPRIOR)",'ENABLE','Pedido em aberto'})
    Else
        AADD(_aRet,{"Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ)","ENABLE","Pedido em aberto"})
    Endif

    If lFldAprov
         AADD(_aRet,{"Empty(C5_LIBEROK) .And. C5_MSAPROV =='N'",'BR_CINZA','Pedido aguardando libera็ใo Fiscal'})
    Endif
    
    AADD(_aRet,{"(!Empty(C5_NOTA) .Or. C5_LIBEROK=='E')",'DISABLE','Pedido Encerrado '})                                  
    
    If lFldLibPv
       AADD(_aRet,{"!Empty(C5_LIBEROK) .And. Empty(C5_NOTA).And. Empty(C5_BLQ) .And. !(Alltrim(C5_MSLIBPV) $ 'E|C')",'BR_AMARELO','Pedido Liberado'})
       AADD(_aRet,{"!Empty(C5_LIBEROK) .And. Empty(C5_BLQ) .And. Alltrim(C5_MSLIBPV) == 'E'",'BR_LARANJA','Pedido Bloqueado por Estoque'})      // BLOQUEADO POR ESTOQUE  
       AADD(_aRet,{"!Empty(C5_LIBEROK) .And. Empty(C5_BLQ) .And. Alltrim(C5_MSLIBPV) == 'C'",'BR_AZUL','Pedido Bloqueado por Regra'})	        //Pedido EM ANALISE DE CREDITO
    Else
       AADD(_aRet,{"!Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ)","BR_AMARELO",'Pedido Liberado'})
       AADD(_aRet,{"C5_BLQ  == '1'",'BR_AZUL','Pedido Bloqueado por Estoque'})
       AADD(_aRet,{"C5_BLQ  == '2'",'BR_LARANJA','Pedido Bloqueado por Regra'})
    Endif

    If lFldLibPv .And. lFldCateg .And. lFldPrior
       AADD(_aRet,{"Empty(C5_LIBEROK) .And. Empty(C5_BLQ) .And. C5_MSPRIOR =='1' .and. !(Alltrim(C5_MSLIBPV) $ 'E|C') .and. (C5_MSCATEG ='2' .OR. C5_MSCATEG ='3')",'BR_BRANCO','Pedido Aguardando libera็ใo PCP CATEG 2/3'})     //Pedido Aguardando libera็ใo PCP CATEG 2/3
       AADD(_aRet,{"Empty(C5_LIBEROK) .And. Empty(C5_BLQ) .And. C5_MSPRIOR =='1' .and. !(Alltrim(C5_MSLIBPV) $ 'E|C') .and. C5_MSCATEG = '0'",'BR_PRETO','Pedido Aguardando libera็ใo PCP CATEG 0'})                            //Pedido Aguardando libera็ใo PCP CATEG 0
       AADD(_aRet,{"Empty(C5_LIBEROK) .And. Empty(C5_BLQ) .And. C5_MSPRIOR =='2' .and. !(Alltrim(C5_MSLIBPV) $ 'E|C') .and. (C5_MSCATEG ='2' .OR. C5_MSCATEG ='3')",'BR_MARROM','Pedido Aguardando libera็ใo ALMOXARIFADO CATEG 2/3'})     //Pedido Aguardando libera็ใo ALMOXARIFADO CATEG 2/3
       AADD(_aRet,{"Empty(C5_LIBEROK) .And. Empty(C5_BLQ) .And. C5_MSPRIOR =='2' .and. !(Alltrim(C5_MSLIBPV) $ 'E|C') .and. C5_MSCATEG = '0'",'BR_VERDE_ESCURO','Pedido Aguardando libera็ใo ALMOXARIFADO CATEG 0'})                     //Pedido Aguardando libera็ใo ALMOXARIFADO CATEG 0
    Endif

Return _aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSPEDCON  บAutor  ณIvandro Santos      บ Data ณ  06/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma tem o objetivo de nใo permitir as altera็๕es em es-บฑฑ
ฑฑบ          ณtruturas, OPs, empenhos que teve o PV concluํdo na montagem บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบParโmetrosณEXP1 - C๓digo do Pedido ou Ordem de produ็ใo                บฑฑ
ฑฑบ          ณEXP2 - Origem da altera็ใo: Pode ser Estrutura, OP, empenho บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSPEDCON(_cCodAlt,_cOriAlt)
Local _cQry 	:= ""
Local _aInfo 	:= {}
Local _nQtOP 	:= 0
Local _nQtPVCon:= 0
Local _cPedCon := ""
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso a inclusใo ou altera็ใo vier da Estrutura do produto o  ณ
//ณPE MT200ALT exige que a variแvel seja negativa para permitir ณ
//ณa altera็ใo                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _lRet := IIF(IsInCallStack("U_MT200ALT"),.F.,.T.)

_TipoAlt := IIF(INCLUI,"Inclusใo",IIF(ALTERA,"Altera็ใo","Exclusใo"))
If _cOriAlt = "EMP"
	_aInfo 	:= {" do empenho nใo pode ser realizado, pois Pedido "," estแ concluํdo"}
Elseif _cOriAlt = "OP"
	_aInfo 	:= {" da OP nใo pode ser realizada, pois Pedido "," estแ concluํdo"}
Else
	_aInfo 	:= {" da Estrutura nใo pode ser realizada, pois o Produto "," teve o pedido "," teve os pedidos "," concluํdo"," concluํdos"}
Endif

_cQry := "SELECT C2_MSPED,C2_PRODUTO,C5_MSCONCL, C5_NOTA "
//Ivandro Santos - 16/01/2017
//Ticket#2017011337000178 — Ajuste de empenho
_cQry += "FROM "+RetSQLName("SC2")+" C2 "
_cQry += "INNER JOIN "+RetSQLName("SC5")+" C5 ON C2_MSPED = C5_NUM AND C5.D_E_L_E_T_ = '' "
//Ticket#2017011337000178 — Fim da altera็ใo
_cQry += "WHERE C2.D_E_L_E_T_ = '' "
_cQry += "	AND C5_LIBEROK = '' "
_cQry += "	AND C5_NOTA = '' "

If _cOriAlt == "EST"
	_cQry += "	AND C2_PRODUTO = '"+_cCodAlt+"' "
Elseif _cOriAlt == "OP"
	_cQry += "	AND C5_MSCONCL <> '' "
	_cQry += "	AND C2_MSPED = '"+_cCodAlt+"' "	
	_cQry += "	AND C2_DATRF = '' "
Else
	_cQry += "	AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+_cCodAlt+"' "
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

TRB->(dbGoTop())
While TRB->(!EOF())
	_nQtOP ++
	If !Empty(Alltrim(TRB->C5_MSCONCL)) .And. !(Alltrim(TRB->C2_MSPED) $ _cPedCon)
		_nQtPVCon ++
		_cPedCon += IIf(_nQtPVCon>1," | "+TRB->C2_MSPED, TRB->C2_MSPED)
	ENDIF
	TRB->(dbSkip())
End
If _nQtOP == _nQtPVCon .And. _nQtPVCon > 0 .And. _cOriAlt == "EST"
	MSGINFO(IIf(_nQtPVCon>1,_TipoAlt+_aInfo[1]+CHR(10)+CHR(13)+Alltrim(_cCodAlt)+_aInfo[3]+_cPedCon+_aInfo[5],_TipoAlt+_aInfo[1]+CHR(10)+CHR(13)+Alltrim(_cCodAlt)+_aInfo[2]+_cPedCon+_aInfo[4]))
	//Aqui hแ a inversใo da variแvel para nใo permitir a altera็ใo do produto .T. nใo permite a altera็ใo e .F. permite
	_lRet := IIF(IsInCallStack("U_MT200ALT"),.T.,.F.)
Elseif _cOriAlt $ "OP_EMP" .And. _nQtPVCon > 0
	MSGINFO(_TipoAlt+_aInfo[1]+CHR(10)+CHR(13)+_cPedCon+_aInfo[2])
	_lRet := .F.
Elseif _cOriAlt == "EMP2" .And. _nQtPVCon > 0
   _lRet := .F.
   _cMsgBloq := _TipoAlt+_aInfo[1]+CHR(10)+CHR(13)+_cPedCon+_aInfo[2]
Endif       

Return _lRet
//Ivandro Santos - 01/03/17
//Transfer๊ncia do fonte VALIDANF (retirado do RFATG042) p/ MS_VALNF - passou a ser User Function
//Ticket#2017022837000031 — Natureza T03 - Garantia
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaNF   บAutor  ณLizandra	        บ Data ณ  08/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Monta tela para valida็ใo da nfiscal de origem            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Alterado o nome da Fun็ใo, pois estแ duplicada (RFATA010)  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION MS_VALNF()

//@ 080,153 To 352,584 Dialog _oDlg1 Title OemToAnsi("Nota Fiscal de Origem") Style DS_MODALFRAME

_cNFiscal := SPACE(09)
_cSerie   := SPACE(03)
Define MsDialog _oDlg1 From 080,153 To 352,584 Title "Nota Fiscal de Origem" Pixel Style 128
_oDlg1:lEscClose := .F.
@ 012,016 To 103,198 Title OemToAnsi("Nota fiscal que gerou a garantia.")
@ 032,034 Say OemToAnsi("NFiscal")	Size 60,8
@ 051,035 Say OemToAnsi("Serie"  )	Size 59,8
@ 032,105 Get _cNFiscal F3 "SF2" 	Size 50,10
@ 051,105 Get _cSerie  					Size 37,10
@ 115,090 BmpButton Type 1 Action _fValidaF2()
@ 115,157 BmpButton Type 2 Action _fFim()
Activate Dialog _oDlg1


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fValidaf2 Autor  ณLizandra Marques    บ Data ณ   08/09/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. Valida TES															           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MS_VALNF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fValidaF2()

IF ! apmsgYESNO("Confirma NF?")
	Return
ENDIF

dbSelectArea("SF2")

IF !SF2->(dbSeek(xFilial("SF2")+_cNFiscal+_cSerie))
	apMsgStop("NFiscal nใo encontrada.")
	Acols[n,_nPosTes] := "   "
ELSE
	IF SF2->F2_CLIENTE + SF2->F2_LOJA <> M->C5_CLIENTE + M->C5_LOJAENT
		apMsgStop("Cliente do PV diferente da NFiscal.")
		Acols[n,_nPosTes] := "   "
	ENDIF
	IF SF2->F2_EMISSAO+365 < dDataBase
		IF _nGrpFis == "000503"
			apMsgStop("Garantia vencida.")
		ELSEIF _nGrpFis == "000509"
			apMsgStop("NFiscal emitida ha mais de um ano.")
		ENDIF
		Acols[n,_nPosTes] := "   "
	ENDIF
	IF EMPTY(SF2->F2_DUPL)
		apMsgStop("NFiscal de origem nใo ้ venda.")
		Acols[n,_nPosTes] := "   "
	ENDIF
ENDIF

Close(_oDlg1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fFim      Autor  ณLizandra Marques    บ Data ณ   08/09/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. Valida TES															           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MS_VALNF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fFim()

Acols[n,_nPosTes] := "   "

Close(_oDlg1)

Return
//Ticket#2017022837000031 — Fim da altera็ใo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSXFUN    บAutor  ณVictor Dessunte     บ Data ณ  03/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida forncedor digitado no processo de compras           บฑฑ
ฑฑบ          ณ CRIACAO - TICKET:2017022337000077                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSVLFOR(_cCodFor)

Local _lRet := .T.

If _cCodFor == '005922'
	If !MsgYesNo("ATENวรO: Nใo comprar resist๊ncias do fornecedor AGN por problemas t้cnicos reincidentes!"+CRLF+"Solicita็ใo feita: quinta-feira, 23 de fevereiro de 2017 10:26 por Vagner Minatto."+CRLF+CRLF+"Deseja continuar?")
		_lRet := .F.
	EndIf
EndIf

Return _lRet


User Function MSATUPEV(_aMSPV,_cNomEmp)
Local aNomEmp    := {"",""}          
Local _nEmp, nI
Local aEmpGru    := {"MASIPACK","FABRIMA","HELSIMPLAST"}

Default _aMSPV := {}
Private _cEmpresa  	:=SM0->M0_CODIGO

aNomEmp[1] := Alltrim(SM0->M0_NOME)
For _nEmp := 1 to Len(aEmpGru)
	If aEmpGru[_nEmp] == _cNomEmp
		aNomEmp[2] := aEmpGru[_nEmp]
	Endif
Next

aDadosEmp := U_MSACHAEM(aNomEmp,_cEmpresa)

If len(_aMSPV) > 0
	For nI := 1 to len (_aMSPV)
		cQueryM	:= "UPDATE SC6"+aDadosEmp[MS_GRUPO]+"0 SET C6_PEDCLI = '"+Substr(_aMSPV[nI][2],1,6)+"',C6_MSITPEC = '"+Substr(_aMSPV[nI][2],7,4)+"' "
		cQueryM	+=  " FROM SC6"+aDadosEmp[MS_GRUPO]+"0 C6 "
		cQueryM	+=  " WHERE C6_FILIAL='"+aDadosEmp[MS_FILIAL]+"' AND C6.D_E_L_E_T_<>'*' "
		cQueryM	+=  " AND C6_NUM = '"+Substr(_aMSPV[nI][1],1,6)+"' AND C6_ITEM = '"+Substr(_aMSPV[nI][1],7,2)+"' "
		TCSQLEXEC(cQuerYM)
	Next
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSXFUN    บAutor  ณVictor Dessunte     บ Data ณ  07/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Considera Cliente ou Fornecedor para preencher o campo     บฑฑ
ฑฑบ          ณ Nome Fantasia no documento de entrada.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSNOMEDOC()

Local _cNome := ""

If SF1->F1_TIPO $ "D*B"
	_cNome := POSICIONE("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NREDUZ")
Else
	_cNome := POSICIONE("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NREDUZ")
EndIf

Return _cNome


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSCODCLI  บAutor  ณIvandro Santos      บ Data ณ  05/24/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o cliente caseo nใo esteja bloqueado. Fun็ใo criada บฑฑ
ฑฑบ          ณ para trazer o c๓digo correto do cliente                    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบParametrosณ Exp1 : Array aDadosEmp cont๊m informa็๕es do Grupo, Filial,บฑฑ
ฑฑบ          ณ Nome e CNPJ.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MSXFUN                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSCODFOR(aDadosEmp)
Local _aFor := {}
// Valida cadastro de Cliente
DbSelectArea("SA2")
DbSetOrder(3)
IF !DbSeek(xFilial("SA2")+aDadosEmp[MS_CNPJ])
	alert("Fornecedor Inexistente")
Else
	While !EOF() .and. SA2->A2_CGC == aDadosEmp[MS_CNPJ]
		If SA2->A2_MSBLQL <> '1'
			aAdd(_aFor,SA2->A2_COD+SA2->A2_LOJA)
		Endif
		SA2->(dbSkip())
	Enddo
Endif
SA2->(dBCloseArea())
Return _aFor
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSNICK    บAutor  ณVictor Dessunte     บ Data ณ  11/10/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ - Retorna o numero da ordem do SIX                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSNICK(_cTab,_cNick)

Local _aArea   := SIX->(GetArea())
Local _nIndice := 0

dbSelectArea("SIX")
SIX->(dbSetOrder(1))
SIX->(dbSeek(_cTab))

While SIX->(!EOF()) .AND. SIX->INDICE == _cTab
	If AllTrim(SIX->NICKNAME) == AllTrim(_cNick)
		_nIndice := SIX->ORDEM
		EXIT
	EndIf
	SIX->(dbSkip())
End

RestArea(_aArea)

Return VAL(_nIndice)


/*/{Protheus.doc} User Function nomeFunction
(long_description)
@type  Function
@author Masipack
@since 21/04/2020
/*/
User Function SndLibCred(cNumPed)

Local cDestina  := "pecas.grupo@masipack.com.br"
Local cTitulo	:= Alltrim(SM0->M0_NOME) + " | Libera็ใo de Credito Automatico | Pedido de Venda: " + cNumPed
Local cCco		:= ""  
Local cMensagem	:= ""

Default cNumPed := "#N/D"
	
	cMensagem := "PV liberado:       " + cNumPed + CRLF
	cMensagem += "Data de libera็ao: " + DTOC(dDataBase) + CRLF
	
	oMail:= EnvMail():NEW(.F.)
		If oMail:ConnMail()
			oMail:SendMail(cTitulo,cDestina,cCco,,cMensagem)
		EndIf
	oMail:DConnMail()

Return


/*/{Protheus.doc} User Function A415ENTREG
Permite que o usuแrio altere a data da entrega para todos os itens do Or็amento
@type  Function
@author Masipack
@date 05/06/2020
/*/
User Function A415ENTREG()

Local aArea	 := GetArea()
Local nPos	 := 0

Default ALTERA := .F.

	If ALTERA .And. FwAlertYesNo('Deseja substituir a Data de Entrega para todos os itens?')
		TMP1->(dbGoTop())
		While !TMP1->(EOF())
			nPos++
			If !(nPos == oGetDad:oBrowse:nAt)
				Reclock('TMP1',.F.)
				TMP1->CK_ENTREG := M->CK_ENTREG
				TMP1->(MsUnlock())
			Endif
			TMP1->(dbSkip())
		Enddo
	Endif
	RestArea(aArea)
	
Return .T.
