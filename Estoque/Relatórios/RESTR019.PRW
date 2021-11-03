#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} User Function RESTR019
Relatório de requisição ao Armazém
@type  User Function
@author Masipack
@since 03/12/2019
/*/
User Function RESTR019()

Local cPerg	:= "XRESTR019"
Local oReport

	Pergunte(cPerg,.F.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
	
Return 


//Definição do layout do relatório
Static Function ReportDef(cPerg)

Local cDesc     := "Este relatório imprimirá as requisições ao Armazém"
Local cTitulo   := "Solicitação ao Armazém"
Local oReport
Local oSection
	
	oReport := TReport():New("RESTR019",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)
	oReport:DisableOrientation()
	oReport:SetLandscape() 
	oReport:oPage:setPaperSize(10)
	oReport:nFontBody := 7
	oReport:cFontBody := "Courier New"

	oSection := TRSection():New(oReport,"CABEC",{"SCP","SZP"})

	TRCell():New(oSection,"CP_NUM","SCP",RetTitle("CP_NUM"),PesqPict("SCP","CP_NUM"),TamSX3("CP_NUM")[1])
	TRCell():New(oSection,"CP_ITEM","SCP",RetTitle("CP_ITEM"),PesqPict("SCP","CP_ITEM"),TamSX3("CP_ITEM")[1])
	TRCell():New(oSection,"CP_PRODUTO","SCP",RetTitle("CP_PRODUTO"),PesqPict("SCP","CP_PRODUTO"),TamSX3("CP_PRODUTO")[1])
	TRCell():New(oSection,"B1_LOCAL","SB1",RetTitle("B1_LOCAL"),PesqPict("SB1","B1_LOCAL"),TamSX3("B1_LOCAL")[1])
	TRCell():New(oSection,"DESCRI"," ",RetTitle("CP_DESCRI"),PesqPict("SCP","CP_DESCRI"),TamSX3("B1_DESC")[1])
	TRCell():New(oSection,"CP_UM","SCP",RetTitle("CP_UM"),PesqPict("SCP","CP_UM"),TamSX3("CP_UM")[1])
	TRCell():New(oSection,"CP_CC","SCP",RetTitle("CP_CC"),PesqPict("SCP","CP_CC"),TamSX3("CP_CC")[1])
	TRCell():New(oSection,"CP_EMISSAO","SCP",RetTitle("CP_EMISSAO"),PesqPict("SCP","CP_EMISSAO"),TamSX3("CP_EMISSAO")[1])
	TRCell():New(oSection,"CP_OBS","SCP",RetTitle("CP_OBS"),PesqPict("SCP","CP_OBS"),TamSX3("CP_OBS")[1])
	TRCell():New(oSection,"CP_USER","SCP",RetTitle("CP_SOLICIT"),"@!",30, , {|| IF(MV_PAR05==2,Upper(Alltrim(UsrFullName(CP_USER))),"") })
	TRCell():New(oSection,"CP_QUANT","SCP",RetTitle("CP_QUANT"),PesqPict("SCP","CP_QUANT"),TamSX3("CP_QUANT")[1])

	TRCell():New(oSection,"ZP_NUM","SZP",RetTitle("ZP_NUM"),PesqPict("SZP","ZP_NUM"),TamSX3("ZP_NUM")[1])
	TRCell():New(oSection,"ZP_ITEM","SZP",RetTitle("ZP_ITEM"),PesqPict("SZP","CP_ITEM"),TamSX3("ZP_ITEM")[1])
	TRCell():New(oSection,"ZP_PRODUTO","SZP",RetTitle("ZP_PRODUTO"),PesqPict("SZP","ZP_PRODUTO"),TamSX3("ZP_PRODUTO")[1])
	TRCell():New(oSection,"ZP_UM","SZP",RetTitle("ZP_UM"),PesqPict("SZP","ZP_UM"),TamSX3("ZP_UM")[1])
	TRCell():New(oSection,"ZP_CC","SZP",RetTitle("ZP_CC"),PesqPict("SZP","ZP_CC"),TamSX3("ZP_CC")[1])
	TRCell():New(oSection,"ZP_EMISSAO","SZP",RetTitle("ZP_EMISSAO"),PesqPict("SZP","ZP_EMISSAO"),TamSX3("ZP_EMISSAO")[1])
	TRCell():New(oSection,"ZP_OBS","SZP",RetTitle("ZP_OBS"),PesqPict("SZP","ZP_OBS"),TamSX3("ZP_OBS")[1])
	TRCell():New(oSection,"ZP_USER","SZP",RetTitle("ZP_SOLICIT"),"@!",30, , {|| IF(MV_PAR05==1,Upper(Alltrim(UsrFullName(ZP_USER))),"") })
	TRCell():New(oSection,"ZP_QUANT","SZP",RetTitle("ZP_QUANT"),PesqPict("SZP","ZP_QUANT"),TamSX3("ZP_QUANT")[1])

	TRCell():New(oSection,"B2_QATU","SB2",RetTitle("B2_QATU"),PesqPict("SB2","B2_QATU"),TamSX3("B2_QATU")[1], ,{|| IF(MV_PAR05==2,SaldoAtu(CP_PRODUTO),SaldoAtu(ZP_PRODUTO)) })
	
Return oReport

//Impressão do relatório
Static Function PrintReport(oReport)

Local aDepto	:= FWSFALLUSERS({RetCodUsr()},{"USR_DEPTO"})
Local cSelect	:= ""
Local cFrom		:= ""
Local cWhere	:= ""
Local cOrder	:= ""
Local cAlias	:= GetNextAlias()
Local oSection := oReport:Section(1)

Default MV_PAR01 := CTOD("01/01/00")
Default MV_PAR02 := CTOD("31/12/49")
Default MV_PAR03 := ""
Default MV_PAR04 := ""
Default MV_PAR05 := 2
Default MV_PAR06 := 1
Default MV_PAR07 := ""
Default MV_PAR08 := ""
Default MV_PAR09 := 1

	oReport:SetTitle( IF(MV_PAR05 == 1,'Entrada de Materiais do armazém','Retirada de Materiais do Armazém') )
	
	IF MV_PAR05 == 1

		oSection:Cell("CP_NUM"):Disable()
		oSection:Cell("CP_ITEM"):Disable()
		oSection:Cell("CP_PRODUTO"):Disable()
		oSection:Cell("CP_UM"):Disable()
		oSection:Cell("CP_QUANT"):Disable()
		oSection:Cell("CP_CC"):Disable()
		oSection:Cell("CP_EMISSAO"):Disable()
		oSection:Cell("CP_OBS"):Disable()
		oSection:Cell("CP_USER"):Disable()

		cSelect := "%"
		cSelect	+= "ZP_NUM, ZP_ITEM, ZP_PRODUTO, (CASE WHEN ((SELECT B5_CEME FROM "+ RetSQLName("SB5") +" AA WHERE AA.B5_FILIAL = B1_FILIAL AND AA.B5_COD = B1_COD AND AA.D_E_L_E_T_ = ' ') != ' ') " 
		cSelect	+= "									THEN (SELECT B5_CEME FROM "+ RetSQLName("SB5") +" AA WHERE AA.B5_FILIAL = B1_FILIAL AND AA.B5_COD = B1_COD AND AA.D_E_L_E_T_ = ' ') "
		cSelect	+= "									ELSE ZP_DESCRI END) AS DESCRI, ZP_UM, ZP_QUANT, ZP_CC, ZP_USER, ZP_OBS, ZP_EMISSAO , ZP_HORAS, B1_LOCAL "
		cSelect += "%"

		cFrom	:= "%"
		cFrom	+= RetSQLName("SZP") + " SZP, " + RetSQLName("SB1") + " SB1 "
		cFrom	+= "%"

		cWhere	:= "%"
		cWhere	+= " ZP_FILIAL = '" + xFilial("SZP") + "' AND "
		IF !FwIsAdmin(RetCodUsr()) .And. !("ALMOX" $ UPPER(aDepto[1,3]))
			cWhere	+= " ZP_USER = '" + RetCodUsr() + "' AND "
		ENDIF
		cWhere	+= " ZP_QUJE < ZP_QUANT AND "
		cWhere	+= " ZP_STATUS NOT IN ('E') AND "
		cWhere	+= " ZP_EMISSAO BETWEEN '"  + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
		cWhere	+= " ZP_NUM BETWEEN '"  + MV_PAR07 + "' AND '" + MV_PAR08 + "' AND "
		cWhere	+= " SZP.D_E_L_E_T_ = ' ' AND "
		cWhere	+= " B1_COD = ZP_PRODUTO AND "
		cWhere	+= " SB1.D_E_L_E_T_ = ' ' "		
		cWhere	+= "%"

		cOrder := "%"
		cOrder += "ZP_NUM, ZP_ITEM"
		cOrder += "%"

	ELSE

		oSection:Cell("ZP_NUM"):Disable()
		oSection:Cell("ZP_ITEM"):Disable()
		oSection:Cell("ZP_PRODUTO"):Disable()
		oSection:Cell("ZP_UM"):Disable()
		oSection:Cell("ZP_CC"):Disable()
		oSection:Cell("ZP_EMISSAO"):Disable()
		oSection:Cell("ZP_OBS"):Disable()
		oSection:Cell("ZP_USER"):Disable()
		oSection:Cell("ZP_QUANT"):Disable()

		cSelect := "%"
		cSelect	+= "CP_NUM, CP_ITEM, CP_QUANT, CP_PRODUTO, CP_UM, CP_LOCAL, CP_CC, CP_EMISSAO, CP_HORAS, CP_OBS, CP_USER, B1_LOCAL, "
		cSelect += "( CASE WHEN B5_CEME IS NOT NULL THEN B5_CEME ELSE TRIM(CP_DESCRI) + ' - (PRODUTO S/ COMPLEMENTO) ' END ) AS DESCRI "
		cSelect += "%"

		cFrom	:= "%"
		cFrom	+= RetSQLName("SCP") + " SCP, " + RetSQLName("SB1") + " SB1 "
		cFrom	+= "LEFT JOIN "+ RetSQLName("SB5") + " SB5 ON "
		cFrom	+= "B5_FILIAL = B1_FILIAL AND "
		cFrom	+= "B5_COD = B1_COD AND "
		cFrom	+= "SB5.D_E_L_E_T_ = ' ' "
		cFrom	+= "%"

		cWhere	:= "%"
		cWhere	+= " CP_FILIAL = '"+xFilial("SCP")+"' AND CP_QUJE < CP_QUANT AND "
		cWhere	+= " CP_STATUS NOT IN ('E') AND "
		IF !FwIsAdmin(RetCodUsr()) .And. !("ALMOX" $ UPPER(aDepto[1,3]))
			cWhere	+= " CP_USER = '"+ RetCodUsr() +"' AND "
		ENDIF
		cWhere	+= " CP_EMISSAO BETWEEN '"  + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
		cWhere	+= " CP_NUM BETWEEN '"  + MV_PAR07 + "' AND '" + MV_PAR08 + "' AND "
		cWhere	+= " SCP.D_E_L_E_T_ = ' ' AND "
		cWhere	+= " B1_COD = CP_PRODUTO AND "
		cWhere	+= " SB1.D_E_L_E_T_ = ' ' "
		cWhere	+= "%"

		cOrder := "%"
		cOrder += "CP_NUM, CP_ITEM"
		cOrder += "%"
	ENDIF

	oSection:BeginQuery()
	BEGINSQL Alias cAlias
		SELECT  %Exp:cSelect%
        FROM    %Exp:cFrom%
        WHERE   %Exp:cWhere%
        ORDER BY %Exp:cOrder%
	ENDSQL
	oSection:EndQuery()
	oSection:Print()

	If MV_PAR09 == 2
		PrintEtiq(cAlias)
	Endif

	(cAlias)->(dbCloseArea())

Return


/*/{Protheus.doc} SaldoAtu
Verifica o saldo atual do produto para imprimir no relatório
@type  Static Function
@author Masipack
@since 08/01/2020
/*/
Static Function SaldoAtu(cProduto)

Local aAreaSB2		:= SB2->(GetArea())
Local nSaldoSB2		:= 0

Default cProduto	:= ""

	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(FWxFilial("SB2") + cProduto))
		nSaldoSB2 := SaldoSB2(,.F.)
	Endif

	RestArea(aAreaSB2)
	
Return nSaldoSB2


/*/{Protheus.doc} PrintEtiq
Imprime a etiqueta verde
@type  Static Function
@author Masipack
@since 08/01/2020
/*/
Static Function PrintEtiq(cAlias)

Local cExe1 := "cmd /c NET USE LPT1: \\masipack-dsk009\EtiqMont1"  
Local cExe2 := "cmd /c net use lpt1: /delete" 

	WaitRun(cExe2)
	If MsgYesNo("Imprime etiqueta na montagem?")
		WaitRun(cExe1)
	Endif

	If MsgYesNo("Impressora conectada na porta LPT1?")
		MSCBPRINTER("OS 214","LPT1",)
	Else
		MSCBPRINTER("OS 214","COM1",)
	Endif

	MSCBCHKSTATUS(.F.)

	(cAlias)->(dbGoTop())

	While !(cAlias)->(EOF())

		MSCBBEGIN(1,4)
		MSCBSAY(06,03,"DEVOLUCAO: " + If(MV_PAR05 == 1,(cAlias)->ZP_NUM,(cAlias)->CP_NUM)								,"B","3","01,01")
		MSCBSAY(10,03,"PRODUTO: " + If(MV_PAR05 == 1,(cAlias)->ZP_PRODUTO,(cAlias)->CP_PRODUTO)							,"B","3","01,01")
//		MSCBSAY(14,03,"DESCRI: " + If(MV_PAR05 == 1,SubStr((cAlias)->ZP_DESCRI,1,15),SubStr((cAlias)->CP_DESCRI,1,15))	,"B","3","01,01")
		MSCBSAY(14,03,"DESCRI: " + SubStr((cAlias)->DESCRI,1,15)														,"B","3","01,01")
		MSCBSAY(18,03,"LOCAL: " + (cAlias)->B1_LOCAL																	,"B","3","01,01")
		MSCBSAY(22,03,"EMISSAO: " + If(MV_PAR05 == 1,DTOC((cAlias)->ZP_EMISSAO),DTOC((cAlias)->CP_EMISSAO))				,"B","3","01,01")
		MSCBSAY(26,03,"QTDE: " + Transform( If(MV_PAR05 == 1,(cAlias)->ZP_QUANT,(cAlias)->CP_QUANT) ,"@E 9,999.99")		,"B","3","01,01")
		MSCBSAY(30,03, SubStr(Alltrim(UsrFullName(__cUserID)),1,15)														,"B","3","01,01")
		(cAlias)->(dbSkip())

		If !(cAlias)->(EOF())

			MSCBSAY(36,03,"DEVOLUCAO: " + If(MV_PAR05 == 1,(cAlias)->ZP_NUM,(cAlias)->CP_NUM)								,"B","3","01,01")
			MSCBSAY(40,03,"PRODUTO: " + If(MV_PAR05 == 1,(cAlias)->ZP_PRODUTO,(cAlias)->CP_PRODUTO)							,"B","3","01,01")
//			MSCBSAY(44,03,"DESCRI: " + If(MV_PAR05 == 1,SubStr((cAlias)->ZP_DESCRI,1,15),SubStr((cAlias)->CP_DESCRI,1,15))	,"B","3","01,01")
			MSCBSAY(44,03,"DESCRI: " + SubStr((cAlias)->DESCRI,1,15)														,"B","3","01,01")
			MSCBSAY(48,03,"LOCAL: " + (cAlias)->B1_LOCAL																	,"B","3","01,01")
			MSCBSAY(52,03,"EMISSAO: " + If(MV_PAR05 == 1,DTOC((cAlias)->ZP_EMISSAO),DTOC((cAlias)->CP_EMISSAO))				,"B","3","01,01")
			MSCBSAY(56,03,"QTDE: " + Transform( If(MV_PAR05 == 1,(cAlias)->ZP_QUANT,(cAlias)->CP_QUANT) ,"@E 9,999.99")		,"B","3","01,01")
			MSCBSAY(60,03, SubStr(Alltrim(UsrFullName(__cUserID)),1,15)														,"B","3","01,01")
			
			(cAlias)->(dbSkip())
			
		Endif

		If !(cAlias)->(EOF())

			MSCBSAY(66,03,"DEVOLUCAO: " + If(MV_PAR05 == 1,(cAlias)->ZP_NUM,(cAlias)->CP_NUM)								,"B","3","01,01")
			MSCBSAY(70,03,"PRODUTO: " + If(MV_PAR05 == 1,(cAlias)->ZP_PRODUTO,(cAlias)->CP_PRODUTO)							,"B","3","01,01")
//			MSCBSAY(74,03,"DESCRI: " + If(MV_PAR05 == 1,SubStr((cAlias)->ZP_DESCRI,1,15),SubStr((cAlias)->CP_DESCRI,1,15))	,"B","3","01,01")
			MSCBSAY(74,03,"DESCRI: " + SubStr((cAlias)->DESCRI,1,15)														,"B","3","01,01")
			MSCBSAY(78,03,"LOCAL: " + (cAlias)->B1_LOCAL																	,"B","3","01,01")
			MSCBSAY(82,03,"EMISSAO: " + If(MV_PAR05 == 1,DTOC((cAlias)->ZP_EMISSAO),DTOC((cAlias)->CP_EMISSAO))				,"B","3","01,01")
			MSCBSAY(86,03,"QTDE: " + Transform( If(MV_PAR05 == 1,(cAlias)->ZP_QUANT,(cAlias)->CP_QUANT) ,"@E 9,999.99")		,"B","3","01,01")
			MSCBSAY(90,03, SubStr(Alltrim(UsrFullName(__cUserID)),1,15)														,"B","3","01,01")
			
			(cAlias)->(dbSkip())

		Endif

		MSCBEND()

	Enddo	

	MSCBCLOSEPRINTER()

	WaitRun(cExe2)

Return
