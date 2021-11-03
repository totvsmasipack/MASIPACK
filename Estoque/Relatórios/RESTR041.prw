#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RESTR041
Relatório de Saldo de Produtos x Locais (Será descontinuado quando o sistema possuir controle de endereçamento)
@type  Function
@author Masipack
@since 13/08/2020
/*/
User Function RESTR041()

Local cPerg	:= "XRESTR041"
Local oReport

	Pergunte(cPerg,.F.)
    oReport := ReportDef(cPerg)
	oReport:PrintDialog()
    
Return


/*/{Protheus.doc} ReportDef(cPerg)
Definição do layout do relatório
@type  Static Function
@author Masipack
@since 13/08/2020
/*/
Static Function ReportDef(cPerg)

Local cDesc     := "Este relatório imprimirá os produtos com saldos por Local do Estoque"
Local cTitulo   := "Saldos por Local"
Local oReport
Local oSection

    oReport := TReport():New("RESTR041",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)
	oReport:DisableOrientation()
	oReport:SetLandscape() 
	oReport:oPage:setPaperSize(10)
	oReport:nFontBody := 7
	oReport:cFontBody := "Courier New"

    oSection := TRSection():New(oReport,"CABEC",{"SB1"})
    TRCell():New(oSection,"B1_LOCAL"    ,""      ,RetTitle("B1_LOCAL")       ,PesqPict("SB1","B1_LOCAL")         ,TamSX3("B1_LOCAL")[1]  )
    TRCell():New(oSection,"B1_COD"      ,""      ,RetTitle("B1_COD")         ,PesqPict("SB1","B1_COD")           ,TamSX3("B1_COD")[1]    )
    TRCell():New(oSection,"B1_DESC"     ,""      ,RetTitle("B1_DESC")        ,PesqPict("SB1","B1_DESC")          ,TamSX3("B1_DESC")[1]    )
    TRCell():New(oSection,"B1_UM"       ,""      ,RetTitle("B1_UM")          ,PesqPict("SB1","B1_UM")            ,TamSX3("B1_UM")[1]     )
    TRCell():New(oSection,"B1_LOCPAD"   ,""      ,"Armazém"                  ,PesqPict("SB1","B1_LOCPAD")        ,TamSX3("B1_LOCPAD")[1] )
    TRCell():New(oSection,"B2_QATU"     ,""      ,RetTitle("B2_QATU")        ,PesqPict("SB2","B2_QATU")          ,TamSX3("B2_QATU")[1]   )

Return oReport



/*/{Protheus.doc} PrintReport
Impressão dos dados no relatório
@type  Static Function
@author Masipack
@since 13/08/2020
/*/
Static Function PrintReport(oReport)

Local cTMP		:= GetNextAlias()
Local lContinua	:= .F.
Local lNoSB2	:= .F.
Local nSaldo	:= 0
Local nQtdReg	:= 0
Local oSection  := oReport:Section(1)

Default MV_PAR01 := ''              // Produto de
Default MV_PAR02 := 'ZZZZZZ'        // Produto até
Default MV_PAR03 := ''              // Tipo de Produto de
Default MV_PAR04 := 'ZZ'            // Tipo de Produto até
Default MV_PAR05 := ''              // Local de
Default MV_PAR06 := 'ZZZZZZ'        // Local até
Default MV_PAR07 := 2				// Lista Produto sem Saldo? 1=Sim; 2=Não
/*
    cFilter := "SB1->B1_COD >= '" + MV_PAR01 + "' .AND. SB1->B1_COD <= '" + MV_PAR02 + "' "
    cFilter += ".AND. SB1->B1_TIPO >= '" + MV_PAR03 + "' .AND. SB1->B1_TIPO <= '" + MV_PAR04 + "' "
    cFilter += ".AND. SB1->B1_LOCAL >= '" + MV_PAR05 + "' .AND. SB1->B1_LOCAL <= '" + MV_PAR06 + "' "
    cFilter += IIF(MV_PAR07 == 2, ".AND. !EMPTY(MV_PAR07) ", "")
    

    dbSelectArea('SB1')
    SB1->(dbOrderNickName("MASSB1LOC"))
    SB1->(dbSetFilter({|| &(cFilter) }, cFilter))
    SB1->(dbGoTop())

	dbSelectArea('SB2')
    SB2->(dbSetOrder(1))
*/
	lNoSB2	:= MV_PAR07 == 1

	BEGINSQL ALIAS cTMP
		SELECT	B1_COD, B1_DESC, B1_LOCPAD, B1_LOCAL, B1_UM
		FROM	%Table:SB1% B1
		WHERE	B1_FILIAL = %xFilial:SB1%	AND
				B1_COD	BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%	AND
				B1_TIPO	BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%	AND
				B1_LOCAL BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%	AND
				B1.%NOTDEL%
		ORDER BY B1_LOCAL, B1_COD
	ENDSQL

    If (cTMP)->(EOF())
        
        oSection:Cell("B1_LOCAL"):Disable()
        oSection:Cell("B1_COD"):Disable()
        oSection:Cell("B1_DESC"):Disable()
        oSection:Cell("B1_UM"):Disable()
        oSection:Cell("B1_LOCPAD"):Disable()
        oSection:Cell("B2_QATU"):Disable()

        oReport:PrintText( "Não há dados, verifique os parametros informados" )
        oSection:Finish() 	
        oReport:EndPage()

    Else

		(cTMP)->(dbEval({|| ++nQtdReg }))
		(cTMP)->(dbGoTop())

		oReport:SetMeter( nQtdReg )

		dbSelectArea('SB2')
		SB2->(dbSetOrder(1))

        oSection:Init()

        While (cTMP)->(!EOF()) .And. !(oReport:Cancel())

			If oReport:Cancel()
				Exit
			Endif

			oReport:IncMeter()

			SB2->(dbSeek( FWxFilial("SB2") + (cTMP)->B1_COD + (cTMP)->B1_LOCPAD ))
			nSaldo := IIF( SB2->(FOUND()), SaldoSB2(,.F.), 0 )

			lContinua := .T.
			If nSaldo == 0 .And. !lNoSB2
				lContinua := .F.
			Endif

            If lContinua
				oSection:Cell("B1_LOCAL"):SetValue( (cTMP)->B1_LOCAL )
				oSection:Cell("B1_COD"):SetValue( (cTMP)->B1_COD )
				oSection:Cell("B1_DESC"):SetValue( (cTMP)->B1_DESC )
				oSection:Cell("B1_UM"):SetValue( (cTMP)->B1_UM )
				oSection:Cell("B1_LOCPAD"):SetValue( (cTMP)->B1_LOCPAD )
				oSection:Cell("B2_QATU"):SetValue( nSaldo )
				oSection:PrintLine()
			Endif

            (cTMP)->(dbSkip())
		Enddo
        oSection:Finish()

    Endif
	(cTMP)->(dbCloseArea())

Return 
