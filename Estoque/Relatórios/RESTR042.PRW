#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RESTR042
Relatório de Movimentos de Estoque (Kardex)
@type  Function
@author E.DINIZ [ DS2U ]
@since 03/06/2021
@version 2.0
/*/
User Function RESTR042()
    
Local cPerg	:= "XRESTR042"
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

Local cDesc     := "Este relatório imprimirá os movimentos do produto no estoque"
Local cTitulo   := "Movimentação de Produtos"
Local oReport
Local oSection1

    oReport := TReport():New("RESTR042",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)
	oReport:oPage:setPaperSize(10)
	oReport:nFontBody := 7
	oReport:cFontBody := "Courier New"

    oSection1 := TRSection():New(oReport,"CABEC",{"SB1","SD3","SB9","SB2"})
    TRCell():New(oSection1,"D3_COD"			,"SD3"	,RetTitle("D3_COD")		,PesqPict("SD3","D3_COD")		,TamSX3("D3_COD")[1]		)
    TRCell():New(oSection1,"D3_LOCAL"		,"SD3"	,RetTitle("D3_LOCAL")	,PesqPict("SD3","D3_LOCAL")		,TamSX3("D3_LOCAL")[1]		)
    TRCell():New(oSection1,"B1_DESC"		,"SB1"	,RetTitle("B1_DESC")	,PesqPict("SB1","B1_DESC")		,TamSX3("B1_DESC")[1]		)
    TRCell():New(oSection1,"B1_UM"			,"SB1"	,RetTitle("B1_UM")		,PesqPict("SB1","B1_UM")		,TamSX3("B1_UM")[1]			)
    TRCell():New(oSection1,"B9_DATA"		,"SB9"	,RetTitle("B9_DATA")	,PesqPict("SB9","B9_DATA")		,TamSX3("B9_DATA")[1]		)
    TRCell():New(oSection1,"B9_QINI"		,"SB9"	,RetTitle("B9_QINI")	,PesqPict("SB9","B9_QINI")		,TamSX3("B9_QINI")[1]		)
    TRCell():New(oSection1,"B2_QATU"		,"SB2"	,RetTitle("B2_QATU")	,PesqPict("SB2","B2_QATU")		,TamSX3("B2_QATU")[1]		)
    TRCell():New(oSection1,"B2_RESERVA"		,"SB2"	,RetTitle("B2_RESERVA")	,PesqPict("SB2","B2_RESERVA")	,TamSX3("B2_RESERVA")[1]	)
    TRCell():New(oSection1,"B2_QEMP"		,"SB2"	,RetTitle("B2_QEMP")	,PesqPict("SB2","B2_QEMP")		,TamSX3("B2_QEMP")[1]   	)
    TRCell():New(oSection1,"B2_QACLASS"		,"SB2"	,RetTitle("B2_QACLASS")	,PesqPict("SB2","B2_QACLASS")	,TamSX3("B2_QACLASS")[1]	)
    TRCell():New(oSection1,"SLDISP"			,""		,'Saldo Disponivel'		,PesqPict("SB2","B2_QATU")		,TamSX3("B2_QATU")[1]		)

	oSection2 := TRSection():New(oReport,"MOVIM",{"SD3"})
    TRCell():New(oSection2,"D3_NUMSEQ"		,"SD3"	,RetTitle("D3_NUMSEQ")	,PesqPict("SD3","D3_NUMSEQ")	,TamSX3("D3_NUMSEQ")[1]		)
	TRCell():New(oSection2,"D3_EMISSAO"		,"SD3"	,RetTitle("D3_EMISSAO")	,PesqPict("SD3","D3_EMISSAO")	,TamSX3("D3_EMISSAO")[1]	)
	TRCell():New(oSection2,"D3_DOC"			,"SD3"	,RetTitle("D3_DOC")		,PesqPict("SD3","D3_DOC")		,TamSX3("D3_DOC")[1]		)
	TRCell():New(oSection2,"D3_TM"			,"SD3"	,RetTitle("D3_TM")		,PesqPict("SD3","D3_TM")		,TamSX3("D3_TM")[1]			)
	TRCell():New(oSection2,"D3_CF"			,"SD3"	,RetTitle("D3_CF")		,PesqPict("SD3","D3_CF")		,TamSX3("D3_CF")[1]			)
	TRCell():New(oSection2,"D3_QUANT"		,"SD3"	,RetTitle("D3_QUANT")	,PesqPict("SD3","D3_QUANT")		,TamSX3("D3_QUANT")[1]		)
	TRCell():New(oSection2,"D3_ESTORNO"		,"SD3"	,RetTitle("D3_ESTORNO")	,PesqPict("SD3","D3_ESTORNO")	,TamSX3("D3_ESTORNO")[1]	)
	TRCell():New(oSection2,"D3_CC"			,"SD3"	,RetTitle("D3_CC")		,PesqPict("SD3","D3_CC")		,TamSX3("D3_CC")[1]			)
	TRCell():New(oSection2,"D3_MSOBS"		,"SD3"	,RetTitle("D3_MSOBS")	,PesqPict("SD3","D3_MSOBS")		,TamSX3("D3_MSOBS")[1]		)

Return oReport


/*/{Protheus.doc} PrintReport
Impressão dos dados no relatório
@type  Static Function
@author Masipack
@since 13/08/2020
/*/
Static Function PrintReport(oReport)

Local cTRB		:= GetNextAlias()
Local cProduto	:= ''
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)

	BeginSQL Alias cTRB

		SELECT	
				D3_COD,
				D3_LOCAL,
				B1_DESC,
				B1_UM,
				B9_DATA,
				B9_QINI,
				( CASE WHEN D3_ESTORNO = 'S' THEN (B2_QATU * (-1)) ELSE B2_QATU END) AS B2QATU,
				B2_RESERVA,
				B2_QEMP,
				B2_QACLASS,
				B2_QATU - B2_RESERVA - B2_QEMP AS 'SLDISP',
				D3_NUMSEQ,
				D3_EMISSAO,
				D3_DOC,
				D3_TM,
				D3_CF,
				D3_QUANT,
				D3_ESTORNO,
				D3_CC,
				D3_MSOBS

		FROM %Table:SD3% D3
			
			INNER JOIN  %Table:SB1% B1 ON
			B1_FILIAL = %Exp:xFilial('SB1')% AND
			B1_COD = D3_COD AND
			B1.%NOTDEL%

			LEFT JOIN  %Table:SB9% B9 ON
			B9_FILIAL = %Exp:xFilial('SB9')% AND
			B9_COD = D3_COD AND
			B9_LOCAL = D3_LOCAL AND
			B9_DATA = ( SELECT MAX(B9_DATA) FROM  %Table:SB9% SB9 WHERE B9_FILIAL =  %Exp:xFilial('SB9')% AND SB9.%NOTDEL% ) AND
			B9.%NOTDEL%

			LEFT JOIN  %Table:SB2% B2 ON
			B2_FILIAL = %Exp:xFilial('SB2')% AND
			B2_COD = D3_COD AND
			B2_LOCAL = D3_LOCAL AND
			B2.%NOTDEL%

		WHERE 
			
			D3_FILIAL	= %Exp:xFilial('SD3')%	AND
			D3_COD BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% AND
			D3_EMISSAO BETWEEN ( SELECT MAX(B9_DATA) FROM %Table:SB9% SB9 WHERE B9_FILIAL = %Exp:xFilial('SB9')% AND SB9.%NOTDEL% ) AND %Exp:DTOS(MV_PAR01)% AND
			D3.%NOTDEL%

		ORDER BY D3_FILIAL, D3_NUMSEQ

	EndSQL

	If (cTRB)->(!EOF())

		oReport:SetMeter(0)

		While (cTRB)->(!EOF())

			If !( cProduto == (cTRB)->D3_COD )
				
				oSection1:Init()
				oSection1:Cell("D3_COD"):SetValue((cTRB)->D3_COD)
				oSection1:Cell("B1_DESC"):SetValue((cTRB)->B1_DESC)
				oSection1:Cell("D3_LOCAL"):SetValue((cTRB)->D3_LOCAL)
				oSection1:Cell("B1_UM"):SetValue((cTRB)->B1_UM)
				oSection1:Cell("B9_DATA"):SetValue(STOD((cTRB)->B9_DATA))
				oSection1:Cell("B9_QINI"):SetValue((cTRB)->B9_QINI)
				oSection1:Cell("B2_QATU"):SetValue((cTRB)->B2QATU)
				oSection1:Cell("B2_RESERVA"):SetValue((cTRB)->B2_RESERVA)
				oSection1:Cell("B2_QEMP"):SetValue((cTRB)->B2_QEMP)
				oSection1:Cell("B2_QACLASS"):SetValue((cTRB)->B2_QACLASS)
				oSection1:Cell("SLDISP"):SetValue((cTRB)->SLDISP)
				oSection1:PrintLine()
				oSection1:Finish()

				If !Empty(cProduto)
					oSection2:Finish()
				Endif
				oSection2:Init()

				cProduto := (cTRB)->D3_COD

			Endif

			oSection2:Cell("D3_NUMSEQ"):SetValue( (cTRB)->D3_NUMSEQ )
			oSection2:Cell("D3_EMISSAO"):SetValue( (cTRB)->D3_EMISSAO )
			oSection2:Cell("D3_DOC"):SetValue( (cTRB)->D3_DOC )
			oSection2:Cell("D3_TM"):SetValue( (cTRB)->D3_TM )
			oSection2:Cell("D3_CF"):SetValue( (cTRB)->D3_CF )
			oSection2:Cell("D3_QUANT"):SetValue( (cTRB)->D3_QUANT )
			oSection2:Cell("D3_ESTORNO"):SetValue( (cTRB)->D3_ESTORNO )
			oSection2:Cell("D3_CC"):SetValue( (cTRB)->D3_CC	)
			oSection2:Cell("D3_MSOBS"):SetValue( (cTRB)->D3_MSOBS )
			oSection2:PrintLine()
			
			(cTRB)->(dbSkip())

		Enddo

		oSection2:Finish()

	Endif

	(cTRB)->(dbCloseArea())

Return
