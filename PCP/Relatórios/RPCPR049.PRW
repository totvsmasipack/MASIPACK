#include 'totvs.ch'
#include 'protheus.ch'


/*/{Protheus.doc} User Function RPCPR049
Impressão das referências para acompanhamento (FABRIMA)
@type  Function
@author Masipack
@since 13/08/2020
/*/
User Function RPCPR049()

Local cPerg	:= "XPCPR049"
Local oReport

	If Pergunte(cPerg,.T.)
        oReport := ReportDef(cPerg)
        oReport:PrintDialog()
    Endif

Return


/*/{Protheus.doc} ReportDef(cPerg)
Definição do layout do relatório
@type  Static Function
@author Masipack
@since 13/08/2020
/*/
Static Function ReportDef(cPerg)

Local cAlsTmp	:= GetNextAlias()
Local cDesc     := "Este relatório imprimirá as Ordens de Produções e Referências"
Local cTitulo   := "Ord. Producao x Referências"
Local oReport
Local oSection1
Local oSection2

    oReport := TReport():New("RPCPR049",cTitulo,cPerg,{|oReport| PrintReport(@cAlsTmp,oReport)},cDesc)

    oSection1 := TRSection():New(oReport,"CABEC")
	TRCell():New(oSection1,"D4_OP"      ,""	,RetTitle("D4_OP")		,PesqPict("SD4","D4_OP")		,TamSX3("D4_OP")[1],			.F., {||	(cAlsTmp)->D4_OP		})
	TRCell():New(oSection1,"C2_EMISSAO"	,""	,RetTitle("C2_EMISSAO")	,PesqPict("SC2","C2_EMISSAO")	,TamSX3("C2_EMISSAO")[1],		.F., {||	DTOC(STOD((cAlsTmp)->C2_EMISSAO))	})
    TRCell():New(oSection1,"C2_PRODUTO"	,""	,RetTitle("C2_PRODUTO")	,PesqPict("SC2","C2_PRODUTO")	,TamSX3("C2_PRODUTO")[1],		.F., {||	(cAlsTmp)->C2_PRODUTO	})
    TRCell():New(oSection1,"B1ADESC"    ,""	,RetTitle("B1_DESC")	,PesqPict("SB1","B1_DESC")		,TamSX3("B1_DESC")[1],			.F., {||	(cAlsTmp)->B1ADESC		})
	TRCell():New(oSection1,"C2_QUANT"	,""	,RetTitle("C2_QUANT")	,PesqPict("SC2","C2_QUANT")		,TamSX3("C2_QUANT")[1],			.F., {||	(cAlsTmp)->C2_QUANT		})
	TRCell():New(oSection1,"C2_UM"		,""	,RetTitle("C2_UM")		,PesqPict("SC2","C2_UM")		,TamSX3("C2_UM")[1],			.F., {||	(cAlsTmp)->C2_UM		})
	TRCell():New(oSection1,"C2_DATPRF"	,""	,RetTitle("C2_DATPRF")	,PesqPict("SC2","C2_DATPRF")	,TamSX3("C2_DATPRF")[1],		.F., {||	DTOC(STOD((cAlsTmp)->C2_DATPRF))	})

	oSection2 := TRSection():New(oReport,"COMPON")
	TRCell():New(oSection2,"D4_TRT"		,""	,RetTitle("D4_TRT")		,PesqPict("SD4","D4_TRT")		,TamSX3("D4_TRT")[1],			.F., {||	(cAlsTmp)->D4_TRT		})
	TRCell():New(oSection2,"D4_DATA"	,""	,RetTitle("D4_DATA")	,PesqPict("SD4","D4_DATA")		,TamSX3("D4_DATA")[1],			.F., {||	DTOC(STOD((cAlsTmp)->D4_DATA))		})
	TRCell():New(oSection2,"D4_COD"		,""	,RetTitle("D4_COD")		,PesqPict("SD4","D4_COD")		,TamSX3("D4_COD")[1],			.F., {||	(cAlsTmp)->D4_COD		})
	TRCell():New(oSection2,"B1BDESC"	,""	,RetTitle("B1_DESC")	,PesqPict("SB1","B1_DESC")		,TamSX3("B1_DESC")[1]+30,		.F., {||	(cAlsTmp)->B1BDESC		})
	TRCell():New(oSection2,"D4_LOCAL"	,""	,RetTitle("D4_LOCAL")	,PesqPict("SD4","D4_LOCAL")		,TamSX3("D4_LOCAL")[1],			.F., {||	(cAlsTmp)->D4_LOCAL		})
	TRCell():New(oSection2,"D4_QTDEORI"	,""	,RetTitle("D4_QTDEORI")	,PesqPict("SD4","D4_QTDEORI")	,TamSX3("D4_QTDEORI")[1],		.F., {||	(cAlsTmp)->D4_QTDEORI	})
	TRCell():New(oSection2,"D4_QUANT"	,""	,RetTitle("D4_QUANT")	,PesqPict("SD4","D4_QUANT")		,TamSX3("D4_QUANT")[1],			.F., {||	(cAlsTmp)->D4_QUANT		})
	TRCell():New(oSection2,"D4_MSREFER"	,""	,RetTitle("D4_MSREFER")	,PesqPict("SD4","D4_MSREFER")	,TamSX3("D4_MSREFER")[1]+5,		.F., {||	(cAlsTmp)->D4_MSREFER	})
	TRCell():New(oSection2,"D4_MSLF"	,""	,RetTitle("D4_MSLF")	,PesqPict("SD4","D4_MSLF")		,TamSX3("D4_MSLF")[1]+5,			.F., {||	(cAlsTmp)->D4_MSLF		})
	TRCell():New(oSection2,"D4_MSDTLF"	,""	,RetTitle("D4_MSDTLF")	,PesqPict("SD4","D4_MSDTLF")	,TamSX3("D4_MSDTLF")[1]	,		.F., {||	(cAlsTmp)->D4_MSDTLF	})

Return oReport



/*/{Protheus.doc} PrintReport
Impressão dos dados no relatório
@type  Static Function
@author Masipack
@since 13/08/2020
/*/
Static Function PrintReport(cAlsTmp, oReport)

Local cNumOP	:= ''
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)

Default MV_PAR01 := ''              // Ordem de Producao de
Default MV_PAR02 := 'ZZZZZZ'        // Ordem de Producao até
Default MV_PAR03 := ''              // Nº Referencia de
Default MV_PAR04 := 'ZZ'            // Nº Referencia até

	BEGINSQL ALIAS cAlsTmp
		
		SELECT	
				D4_OP, C2_PRODUTO, B1A.B1_DESC AS B1ADESC, C2_QUANT, C2_UM, C2_EMISSAO, C2_DATPRF, D4_DATA,
				D4_COD, B1B.B1_DESC AS B1BDESC, D4_LOCAL, D4_TRT, D4_QTDEORI, D4_QUANT, D4_MSREFER, D4_MSDTLF, D4_MSLF

		FROM %Table:SD4% D4
			
			LEFT JOIN %Table:SC2% C2 ON
			C2_FILIAL = D4_FILIAL AND
			C2_NUM + C2_ITEM + C2_SEQUEN = D4_OP AND
			C2.%NOTDEL%

			LEFT JOIN %Table:SB1% B1A ON
			B1A.B1_COD = C2_PRODUTO AND
			B1A.%NOTDEL%

			LEFT JOIN %Table:SB1% B1B ON
			B1B.B1_COD = D4_COD AND
			B1B.%NOTDEL%

		WHERE
			D4_FILIAL = %Exp:xFilial('SD4')% AND
			D4_OP BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
			D4_MSREFER BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% AND
			D4.%NOTDEL%

		ORDER BY D4_OP, D4_TRT

	ENDSQL

    If (cAlsTmp)->(EOF())
        
        oReport:PrintText( "Não encontramos informações com os parâmetros informados. Revise os parâmetros e reprocesse novamente." )
        oReport:EndPage()

    Else

        oReport:SetMeter( (cAlsTmp)->(LastRec()) )
        
		While (cAlsTmp)->(!EOF())

			oReport:IncMeter()

			If !( cNumOP == (cAlsTMP)->D4_OP )
				oSection1:Init()
				oSection1:PrintLine()
				oSection1:Finish()
			Endif

			If !( cNumOP == (cAlsTMP)->D4_OP ) .And. !Empty(cNumOP)
				oSection2:Finish()
				oSection2:Init()
				oSection2:PrintLine()
			
			ElseIf Empty(cNumOP)
				oSection2:Init()
				oSection2:PrintLine()
			
			Else
				oSection2:PrintLine()
			Endif

			cNumOP := (cAlsTMP)->D4_OP

			(cAlsTmp)->(dbSkip())
        Enddo
		oSection2:Finish()

    Endif

	(cAlsTmp)->(dbCloseArea())

Return
