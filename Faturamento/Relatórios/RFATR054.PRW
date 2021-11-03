#include 'totvs.ch'
#include 'protheus.ch'


/*/{Protheus.doc} User Function RFATR054
Relatório de Pedidos a Faturar - Gerencia
@type  Function
@author Masipack
@since 23/07/2020
/*/
User Function RFATR054()

Local cPerg	:= "XRFATR054"
Local oReport

	If Pergunte(cPerg,.T.)
		oReport := ReportDef(cPerg)
		oReport:PrintDialog()
	Endif

Return


//Definição do layout do relatório
Static Function ReportDef(cPerg)

Local cDesc     := "Esse programa tem por finalidade imprimir o relatorio de acordo com os parametrosdo usuário"
Local cTitulo   := "Pedidos a Faturar (Gerencial)"
Local oReport
Local oSection
	
	oReport := TReport():New("RFATR054",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)

	oSection := TRSection():New(oReport,"CABEC")
	TRCell():New(oSection,"C5_NUM","SC5",'Pedido',PesqPict("SC5","C5_NUM"),TamSX3("C5_NUM")[1])
	TRCell():New(oSection,"C5_CLIENTE","SC5",RetTitle("C5_CLIENTE"),PesqPict("SC5","C5_CLIENTE"),TamSX3("C5_CLIENTE")[1])
	TRCell():New(oSection,"C5_LOJACLI","SC5",RetTitle("C5_LOJACLI"),PesqPict("SC5","C5_LOJACLI"),TamSX3("C5_LOJACLI")[1])
	TRCell():New(oSection,"A1_NREDUZ","SA1",RetTitle("A1_NREDUZ"),PesqPict("SA1","A1_NREDUZ"),TamSX3("A1_NREDUZ")[1])
	TRCell():New(oSection,"C5_COTACAO","SC5",RetTitle("C5_COTACAO"),PesqPict("SC5","C5_COTACAO"),TamSX3("C5_COTACAO")[1])
	TRCell():New(oSection,"C5_MSVLPED","SC5",RetTitle("C5_MSVLPED"),PesqPict("SC5","C5_MSVLPED"),TamSX3("C5_MSVLPED")[1])
	TRCell():New(oSection,"C5_MSCONCL","SC5",RetTitle("C5_MSCONCL"),PesqPict("SC5","C5_MSCONCL"),TamSX3("C5_MSCONCL")[1])
	TRCell():New(oSection,"C5_EMISSAO","SC5",RetTitle("C5_EMISSAO"),PesqPict("SC5","C5_EMISSAO"),TamSX3("C5_EMISSAO")[1])
	TRCell():New(oSection,"C5_MSDTENT","SC5",RetTitle("C5_MSDTENT"),PesqPict("SC5","C5_MSDTENT"),TamSX3("C5_MSDTENT")[1])
	TRCell():New(oSection,"C5_MSDTPEN","SC5",RetTitle("C5_MSDTPEN"),PesqPict("SC5","C5_MSDTPEN"),TamSX3("C5_MSDTPEN")[1])
	TRCell():New(oSection,"C5_NOTA","SC5",RetTitle("C5_NOTA"),PesqPict("SC5","C5_NOTA"),TamSX3("C5_NOTA")[1])
	TRCell():New(oSection,"C5_SERIE","SC5",RetTitle("C5_SERIE"),PesqPict("SC5","C5_SERIE"),TamSX3("C5_SERIE")[1])
	TRCell():New(oSection,"C5_MOEDA","SC5",RetTitle("C5_MOEDA"),PesqPict("SC5","C5_MOEDA"),TamSX3("C5_MOEDA")[1])
	
	If cEmpAnt $ '01|10'
		TRCell():New(oSection,"C5_DTEFVEN","SC5",RetTitle("C5_DTEFVEN"),PesqPict("SC5","C5_DTEFVEN"),TamSX3("C5_DTEFVEN")[1])
	Endif
	
Return oReport


//Impressão do relatório
Static Function PrintReport(oReport)

Local cSelect	:= ""
Local cFrom		:= ""
Local cWhere	:= ""
Local cOrder	:= ""
Local cAlias	:= GetNextAlias()
Local oSection	:= oReport:Section(1)

Default MV_PAR01 := CTOD("01/01/00")
Default MV_PAR02 := CTOD("31/12/49")
Default MV_PAR03 := 1

	oReport:SetTitle( 'PV a Faturar - ' + DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02) )

	cSelect := "%"
	cSelect	+= "DISTINCT C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_MSVLPED, C5_COTACAO, C5_MSCONCL, A1_NREDUZ, C5_MSCATEG, C5_EMISSAO, C5_MSDTENT, C5_MSDTPEN, C5_NOTA, C5_SERIE, C5_MOEDA"
	If cEmpAnt $ '01|10'
		cSelect	+= ", C5_DTEFVEN"
	Endif
	cSelect += "%"

	cFrom	:= "%"
	cFrom	+= RetSqlName("SC5") + " SC5, " + RetSQLName("SA1") + " SA1 "
	cFrom	+= "%"

	cWhere	:= "%"
	cWhere	+= " C5_FILIAL = '"+xFilial("SC5")+"' AND"
	cWhere	+= " (C5_NOTA = '' OR C5_NOTA <> 'XXXXXXXXX') AND"
	
	If cEmpAnt $ '01|10'
		cWhere	+= " C5_MSCATEG = '1' AND "
	Endif
	
	cWhere	+= " C5_EMISSAO BETWEEN '"  + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
	cWhere	+= " C5_CLIENT != '999999' AND "
	cWhere	+= " SC5.D_E_L_E_T_ = ' '  AND "
	
	IF MV_PAR03 == 2
		cWhere += "  C5_MSCONCL != '' AND " 
	ELSEIF MV_PAR03 == 3
		cWhere += "  C5_MSCONCL = '' AND " 
	ENDIF

	cWhere	+= " A1_COD = C5_CLIENTE AND 
	cWhere	+= " A1_LOJA = C5_LOJACLI AND"
	cWhere	+= " SA1.D_E_L_E_T_ = ' ' "
	cWhere	+= "%"
	
	cOrder := "%"
	cOrder += "C5_MSDTENT, C5_COTACAO"
	cOrder += "%"

	oSection:BeginQuery()
	BEGINSQL Alias cAlias
		SELECT  %Exp:cSelect%
        FROM    %Exp:cFrom%
        WHERE   %Exp:cWhere%
        ORDER BY %Exp:cOrder%
	ENDSQL
	oSection:EndQuery()
	oSection:Print()

	(cAlias)->(dbCloseArea())

Return
