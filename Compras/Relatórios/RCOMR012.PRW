#include "totvs.ch"
#include "protheus.ch"

DEFAULT cEmpAnt := ""

/*/{Protheus.doc} RCOMR012
	Relatório customizado para o pedido de compra na portaria.
	@type  Function
	@author user
	@since 18/10/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/

User Function RCOMR012()

Local cPerg		:= "RCOM012"
Local oReport
	
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cPerg)
	oReport:DisableOrientation()
	oReport:SetPortrait()
	oReport:PrintDialog()

	If MsgYesNo("Deseja imprimir novamente?")
		U_RCOMR012()
	ENDIF

Return

//Definição do layout do relatório
Static Function ReportDef(cPerg)

Local cDesc     := "Este relatório imprimirá os pedidos de compras com vinculos no NFeSync"
Local cTitulo   := "Pedido de Compras na Portaria"
Local oReport
Local oSection1
Local oSection2

	oReport := TReport():New("RCOMR012",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)
	oReport:oPage:setPaperSize(10)
	oReport:nFontBody := 7
	oReport:cFontBody := "Courier New"
    
	oSection1 := TRSection():New(oReport,"CABEC",{"SA2","SC7"})
	TRCell():New(oSection1,"C7_NUM","SC7","Pedido",/*Picture*/,TamSX3("C7_NUM")[1]+20)
	TRCell():New(oSection1,"C7_EMISSAO","SC7","Emissão",/*Picture*/,TamSX3("C7_EMISSAO")[1])
	TRCell():New(oSection1,"C7_FORNECE","SC7","Fornecedor",/*Picture*/,TamSX3("A2_NOME")[1])
	TRCell():New(oSection1,"ZN0_CNPJ","ZN0","CNPJ/CPF",/*Picture*/,TamSX3("ZN0_CNPJ")[1])
	TRCell():New(oSection1,"A2_MSPONT","SA2","Pontuação",/*Picture*/,4)
	TRCell():New(oSection1,"A2_RISCO","SA2","Classificação",/*Picture*/,TamSX3("A2_NOME")[1])
	TRCell():New(oSection1,"A2_MSDTCER","SA2","Valid. Certificado",/*Picture*/,TamSX3("A2_MSDTCER")[1])
	TRCell():New(oSection1,"A2_MSDTQUE","SA2","Valid. Questionário",/*Picture*/,TamSX3("A2_MSDTQUE")[1])
	
	oSection2 := TRSection():New(oSection1,"ITENS",{"SC7","SB1"})
	TRCell():New(oSection2,"ZN1_ITEMPC","ZN1","Item",/*Picture*/,6)
	TRCell():New(oSection2,"ZN1_COD","ZN1","Produto",/*Picture*/)
	TRCell():New(oSection2,"B1_TIPO","SB1","Tipo",/*Picture*/,4)
	TRCell():New(oSection2,"C7_LOCAL","SC7","Local",/*Picture*/,6)
	TRCell():New(oSection2,"C7_UM","SC7","UM.",/*Picture*/)
	TRCell():New(oSection2,"ZN1_QUANT","ZN1","Qtde",PesqPict("ZN1","ZN1_QUANT"))
	TRCell():New(oSection2,"ZN1_VUNIT","ZN1","Preço",PesqPict("ZN1","ZN1_VUNIT"))
	TRCell():New(oSection2,"ZN1_TOTAL","ZN1","Total",PesqPict("ZN1","ZN1_TOTAL"))
	TRCell():New(oSection2,"C7_VALIPI","SC7","% IPI",PesqPict("SC7","C7_VALIPI"))
	TRCell():New(oSection2,"C7_PICM","SC7","% ICMS",/*Picture*/)
	TRCell():New(oSection2,"C7_CONTA","SC7","Conta Ctb.",/*Picture*/,9)
	TRCell():New(oSection2,"C7_NUMSC","SC7","Sol.",/*Picture*/,8)
	TRCell():New(oSection2,"C7_ITEMSC","SC7","It Sol.",/*Picture*/,7)
	TRCell():New(oSection2,"B1_POSIPI","SB1","NCM",/*Picture*/,14)
	TRCell():New(oSection2,"B1_GRTRIB","SB1","G Trib.",/*Picture*/,3)

Return oReport

//Impressão do Relatório
Static Function PrintReport(oReport)

Local aProced	:= {"1P-FABRICADO PRODUTIVO","1N-FABRICADO IMPRODUTIVO","2P-COMPRADO PRODUTIVO","2N-COMPRADO IMPRODUTIVO","3P-IMPORTADO PRODUTIVO","3N-IMPORTADO IMPRODUTIVO"}
Local cAlias	:= GetNextAlias()
Local cPedItem	:= ""
Local cWhere	:= ""
Local lContinua	:= .F.
Local nCopias	:= 0
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local oFunction

Default MV_PAR01 := ""
Default MV_PAR02 := ""
Default MV_PAR03 := ""
Default MV_PAR04 := 0

	oFunction := TRFunction():New(oSection2:Cell("ZN1_ITEMPC"),NIL,"COUNT",Nil,"Total de Itens ",/*Picture*/,{|| ZN1->ZN1_ITEM },.F.,.T.)
	oFunction := TRFunction():New(oSection2:Cell("C7_VALIPI"),NIL,"SUM",Nil,"Valor Total IPI ",PesqPict("SC7","C7_VALIPI"),{|| (ZN1->ZN1_TOTAL * SC7->C7_IPI) / 100 },.F.,.T.)
	oFunction := TRFunction():New(oSection2:Cell("ZN1_TOTAL"),NIL,"SUM",Nil,"Valor Total ",/*Picture*/,{|| ZN1->ZN1_TOTAL },.F.,.T.)

	cWhere := "%"
	cWhere += " ZN0_FILIAL = '"+FWxFilial("ZN0")+"' "
	cWhere += " AND ZN0_DOC = '"+MV_PAR01+"' "
	cWhere += " AND ZN0_SERIE = '"+MV_PAR02+"' "
	If !Empty(MV_PAR03)
		cWhere += " ZN1_PEDIDO = '"+MV_PAR03+"' "
	Endif
	cWhere += "%" 

	BEGINSQL Alias cAlias

		SELECT	ZN0.R_E_C_N_O_ AS RECNOZN0, 
				ZN1.R_E_C_N_O_ AS RECNOZN1,
				SC1.R_E_C_N_O_ AS RECNOSC1,
				ZN1_ITEM, ZN1_PEDIDO, ZN1_ITEMPC
		FROM %Table:ZN0% ZN0
		
		INNER JOIN %Table:ZN1% ZN1 ON
		ZN1_FILIAL = %Exp:FWxFilial("ZN1")%
		AND ZN1_DOC = ZN0_DOC
		AND ZN1_SERIE = ZN0_SERIE
		AND ZN1_TIPO = ZN0_TIPO
		AND ZN1_FORNEC = ZN0_FORNEC
		AND ZN1_LOJA = ZN0_LOJA
		AND ZN1_PEDIDO <> %Exp:' '%
		AND ZN1_ITEMPC <> %Exp:' '%
		AND ZN1.%NOTDEL%
		
		LEFT JOIN %Table:SC1% SC1 ON
		C1_FILIAL = %Exp:FWxFilial("SC1")%
		AND C1_PEDIDO = ZN1_PEDIDO 
		AND C1_ITEMPED = ZN1_ITEMPC
		AND SC1.%NOTDEL%

		WHERE %Exp:cWhere%
		AND ZN0.%NOTDEL%
		GROUP BY ZN0.R_E_C_N_O_, ZN1.R_E_C_N_O_, SC1.R_E_C_N_O_, ZN1_ITEM, ZN1_PEDIDO, ZN1_ITEMPC
//		ORDER BY ZN1_PEDIDO, ZN1_ITEMPC
		ORDER BY ZN1_ITEMPC

	ENDSQL
	
	ZN0->(dbGoTo((cAlias)->RECNOZN0))

	oReport:SetMeter((cAlias)->(LastRec()))

	For nCopias := 1 To MV_PAR04
		
		(cAlias)->(dbGoTop())
		
		lContinua := .F.

		While !(cAlias)->(EOF()) .And. !oReport:Cancel()

			oReport:onPageBreak({ || PrintCabec(oReport,oSection1) })
			
			If !Empty((cAlias)->ZN1_PEDIDO) .And. !Empty((cAlias)->ZN1_ITEMPC)

				ZN1->(dbGoTo((cAlias)->RECNOZN1))

				SC1->(dbGoTo((cAlias)->RECNOSC1))

				If Alltrim(cPedItem) == Alltrim(ZN1->ZN1_PEDIDO + ZN1->ZN1_ITEMPC)
					(cAlias)->(dbSkip())
				Endif

				If oReport:Row() == 0
					oReport:EndPage()
				
				ElseIf oReport:Row() > oReport:LineHeight() * 100
					oReport:SkipLine()
					oReport:EndPage()
				
				ElseIf SubStr(cPedItem,1,6) <> ZN1->ZN1_PEDIDO
					oReport:FatLine()
					PrintCabec(oReport,oSection1)

				Endif
				
				SC7->(dbSetOrder(1))
				If SC7->(dbSeek(FWxFilial("SC7") + (cAlias)->ZN1_PEDIDO + (cAlias)->ZN1_ITEMPC ))

					lContinua := .T.

					TRPosition():New(oSection2,"SB1", 1, {|| FWxFilial("SB1") + ZN1->ZN1_COD})
					oSection2:Init()
					oSection2:PrintLine()
					
					oReport:SkipLine()
					oReport:PrintText("Desc. Específica: " + Alltrim(POSICIONE("SB5",1,FWxFilial("SB5") + ZN1->ZN1_COD, "B5_CEME")), oReport:Row(), oSection2:Cell("ZN1_ITEMPC"):ColPos()+10)
					oReport:SkipLine(2)
					oReport:PrintText("OBS: " + Alltrim(SC7->C7_OBS), oReport:Row(), oSection2:Cell("ZN1_ITEMPC"):ColPos()+10)
					oReport:PrintText("Apropriação: " + Alltrim(Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,"C1_MSAPROP")), oReport:Row(), oSection2:Cell("ZN1_TOTAL"):ColPos())
					oReport:SkipLine(2)
					oReport:PrintText("Responsável: " + UPPER(Alltrim(UsrFullName(SC1->C1_USER))), oReport:Row(), oSection2:Cell("ZN1_ITEMPC"):ColPos()+10)

					oReport:SkipLine(2)
					oReport:PrintText("Procedência: " + aProced[aScan(aProced,POSICIONE("SB1",1,FWxFilial("SB1") + ZN1->ZN1_COD, "B1_PROCED"))], oReport:Row(), oSection2:Cell("ZN1_ITEMPC"):ColPos()+10)

					If cEmpAnt == "01"
						oReport:SkipLine(2)
						oReport:PrintText("Certificado Qualidade: " + IF(POSICIONE("SB1",1,FWxFilial("SB1") + ZN1->ZN1_COD, "B1_MSCERT") == "S", "SIM" , "NÃO" ), oReport:Row(), oSection2:Cell("ZN1_ITEMPC"):ColPos()+10)
						oReport:PrintText("Certificado CE: " + IF(POSICIONE("SB1",1,FWxFilial("SB1") + ZN1->ZN1_COD, "B1_MSCONF") == "S", "SIM" , "NÃO" ), oReport:Row(), oSection2:Cell("C7_LOCAL"):ColPos())
						oReport:PrintText("Certificado Atoxidade: " + IF(POSICIONE("SB1",1,FWxFilial("SB1") + ZN1->ZN1_COD, "B1_MSATOX") == "S", "SIM" , "NÃO" ), oReport:Row(), oSection2:Cell("ZN1_TOTAL"):ColPos())
					Endif
					
					oReport:SkipLine(4)

					oSection2:Finish()
					
				Endif
				
				cPedItem := (cAlias)->ZN1_PEDIDO + (cAlias)->ZN1_ITEMPC

				If oReport:Cancel()
					Exit
				Endif
				
			Endif

			(cAlias)->(dbSkip())
		Enddo
		
		If lContinua
			oReport:SkipLine()
			oReport:PrintText("Emitido por: " + Alltrim(UsrFullName(RetCodUsr())) + " em " + DTOC(DATE()) + " as " + SUBSTR(TIME(),1,5) + "   Visto do Responsável pelo Recebimento e Liberacao: _____________",oReport:Row(), oSection2:Cell("ZN1_ITEMPC"):ColPos()+10)
			oReport:SkipLine(3)
		Endif
		
	Next nCopias

	(cAlias)->(dbCloseArea())

Return


//Imprime o cabeçalho do relatório
Static Function PrintCabec(oReport,oSection1)

Local aParcela	:= {}
Local cCNPJ		:= ""
Local nX		:= 0

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(FWxFilial("SA2") + ZN0->ZN0_FORNEC + ZN0->ZN0_LOJA))

	oSection1:Init()

	oReport:PrintText("Nº PEDIDO: " + ZN1->ZN1_PEDIDO, oReport:Row(), oSection1:Cell("C7_NUM"):ColPos()+10)
	oReport:PrintText("RECEBIMENTO: " + DTOC(DATE()), oReport:Row(), oSection1:Cell("ZN0_CNPJ"):ColPos())
	oReport:SkipLine()
	oReport:PrintText("FORNECEDOR: " + SA2->A2_COD + "-" + SA2->A2_LOJA + SPACE(02) +Alltrim(SA2->A2_NOME), oReport:Row(),oSection1:Cell("C7_NUM"):ColPos()+10)

	cCNPJ := Transform(ZN0->ZN0_CNPJ, If(SA2->A2_TIPO == "F", SubStr(PICPES(SA2->A2_TIPO),1,17), SubStr(PICPES(SA2->A2_TIPO),1,21)))
	oReport:PrintText("CNPJ/CPF: " + cCNPJ, oReport:Row(),oSection1:Cell("ZN0_CNPJ"):ColPos())
	oReport:SkipLine()
	oReport:PrintText("PONTUAÇÃO: " + Str(SA2->A2_MSPONT), oReport:Row(),oSection1:Cell("C7_NUM"):ColPos()+10)
	oReport:PrintText("CLASSIFICAÇÃO: " + SA2->A2_RISCO, oReport:Row(),oSection1:Cell("ZN0_CNPJ"):ColPos())
	oReport:SkipLine(2)
	oReport:PrintText("COND. PAGTO: " + SC7->C7_COND + " - " + Alltrim(POSICIONE("SE4",1,FWxFilial("SE4") + SC7->C7_COND, "E4_DESCRI")), oReport:Row(),oSection1:Cell("C7_NUM"):ColPos()+10)
	oReport:SkipLine()

	aParcela := Condicao(ZN0->ZN0_VALMER,SC7->C7_COND,,ZN0->ZN0_EMISSA)
	For nX := 1 To Len(aParcela)
		oReport:PrintText("Vencto " + StrZero(nX,2) + ": " + DTOC(aParcela[nX,1]) + " - " + TRANSFORM(aParcela[nX,2], "@E 999,999,999.99"), oReport:Row(),oSection1:Cell("C7_NUM"):ColPos()+10)
		oReport:SkipLine()
	Next nX

	If Empty(SA2->A2_MSDTQUE) .Or. Empty(SA2->A2_MSDTCER)
		oReport:SkipLine()
		oReport:PrintText("* ATENCAO! Fornecedor com Certificado ou Questinario fora do prazo de validade! Contate o departamento de Compras. *", oReport:Row(),oSection1:Cell("C7_NUM"):ColPos()+10)
		oReport:SkipLine()
	Endif
	
	oReport:FatLine()
	oReport:SkipLine()

	oSection1:Finish()

Return
