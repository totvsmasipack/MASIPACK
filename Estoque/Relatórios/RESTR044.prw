#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} User Function RESTR044
Relatório de Movimentos de Estoque (substituir o RESTR018)
@type  Function
@author E.DINIZ - [DS2U]
@since 08/09/2021
/*/
User Function RESTR044()

Local cPerg := "XRESTR018"

	Pergunte(cPerg,.F.)
	oReport := ReportDef(cPerg)
	oReport:PrintDialog()

Return

/*/{Protheus.doc} ReportDef
Definição do layout do relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 08/09/2021
@version version
/*/
Static Function ReportDef(cPerg)

Local cDesc     := "Este relatório imprimirá as informações de movimentos do estoque "
Local cTitulo   := "Movimentações de Estoque"
Local oReport	:= Nil
Local oSection1	:= Nil

    oReport := TReport():New("RESTR044", cTitulo, cPerg, {|oReport| PrintReport(oReport) }, cDesc)
	oReport:SetLandscape()
	oReport:oPage:setPaperSize(10)
	oReport:cFontBody := "Courier New"

	oSection1 := TRSection():New(oReport,"CABEC",{"SB9","SB2","SB1","SB2"})
	TRCell():New(oSection1,"D3_DOC"		,""	,"Documento",	PesqPict("SD3","D3_DOC"),		TamSX3("D3_DOC")[1]		)
	TRCell():New(oSection1,"D3_NUMSEQ"	,""	,"Sequencial",	PesqPict("SD3","D3_NUMSEQ"),	TamSX3("D3_NUMSEQ")[1]	)
	TRCell():New(oSection1,"D3_EMISSAO"	,""	,"Data",		PesqPict("SD3","D3_EMISSAO"),	12						)
	TRCell():New(oSection1,"D3_HORAS"	,""	,"Hora",		PesqPict("SD3","D3_HORAS"),		TamSX3("D3_HORAS")[1]	)
	TRCell():New(oSection1,"D3_LOCAL"	,""	,"Armazem",		PesqPict("SD3","D3_LOCAL"),		10						)
	TRCell():New(oSection1,"D3_COD"		,""	,"Produto",		PesqPict("SD3","D3_COD"),		TamSX3("D3_COD")[1]		)
	TRCell():New(oSection1,"B1_DESC"	,""	,"Descricao",	PesqPict("SB1","B1_DESC"),		TamSX3("B1_DESC")[1]	)
	TRCell():New(oSection1,"B1_LOCAL"	,""	,"Local",		PesqPict("SB1","B1_LOCAL"),		TamSX3("B1_LOCAL")[1]	)
	TRCell():New(oSection1,"D3_UM"		,""	,"Un. Med.",	PesqPict("SD3","D3_UM"),		TamSX3("D3_UM")[1]		)
	TRCell():New(oSection1,"B1_PROCED"	,""	,"Proced.",		PesqPict("SB1","B1_PROCED"),	TamSX3("B1_PROCED")[1]	)
	TRCell():New(oSection1,"D3_QUANT"	,""	,"Quantidade",	PesqPict("SD3","D3_QUANT"),		TamSX3("D3_QUANT")[1]	)
	TRCell():New(oSection1,"D3_ESTORNO"	,""	,"Estornado?",	PesqPict("SD3","D3_ESTORNO"),	10						)
	TRCell():New(oSection1,"D3_CC"		,""	,"C. Custo",	PesqPict("SD3","D3_CC"),		TamSX3("D3_CC")[1]		)
	TRCell():New(oSection1,"D3_USUARIO"	,""	,"Usuario",		PesqPict("SD3","D3_USUARIO"),	TamSX3("D3_USUARIO")[1]	)
	TRCell():New(oSection1,"D3_MSOBS"	,""	,"Observ.",		PesqPict("SD3","D3_MSOBS"),		TamSX3("D3_MSOBS")[1]	)

Return oReport

/*/{Protheus.doc} PrintReport
Realiza a impressão do relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 08/09/2021
@version version
/*/
Static Function PrintReport(oReport)

Local cAlias	:= ''
Local nCount	:= 0
Local oSection1	:= oReport:Section(1)

	cAlias := GetMovStock()

	(cAlias)->(dbEval({|| nCount++ },, { || (cAlias)->(!EOF()) } ) )
	(cAlias)->(dbGoTop())

	oReport:SetMeter(nCount)

	If !(cAlias)->(EOF())

		oSection1:Init()

		While !(cAlias)->(EOF())

			oReport:IncMeter()

			If (oReport:Cancel())
				Exit
			Endif
			
			oSection1:Cell("D3_DOC"):SetValue( (cAlias)->D3_DOC )
			oSection1:Cell("D3_NUMSEQ"):SetValue( (cAlias)->D3_NUMSEQ )
			oSection1:Cell("D3_EMISSAO"):SetValue( DTOC(STOD((cAlias)->D3_EMISSAO)) )
			oSection1:Cell("D3_HORAS"):SetValue( (cAlias)->D3_HORAS )
			oSection1:Cell("D3_LOCAL"):SetValue( (cAlias)->D3_LOCAL )
			oSection1:Cell("D3_COD"):SetValue( (cAlias)->D3_COD )
			oSection1:Cell("B1_DESC"):SetValue( Alltrim((cAlias)->B1_DESC) )
			oSection1:Cell("B1_LOCAL"):SetValue( (cAlias)->B1_LOCAL )
			oSection1:Cell("D3_UM"):SetValue( (cAlias)->D3_UM )
			oSection1:Cell("B1_PROCED"):SetValue( (cAlias)->B1_PROCED )
			oSection1:Cell("D3_QUANT"):SetValue( IIF((cAlias)->D3_ESTORNO == 'S', ((cAlias)->D3_QUANT * -1), (cAlias)->D3_QUANT) )
			oSection1:Cell("D3_ESTORNO"):SetValue( IIF((cAlias)->D3_ESTORNO == 'S', 'Sim' , 'Não') )
			oSection1:Cell("D3_CC"):SetValue( (cAlias)->D3_CC )
			oSection1:Cell("D3_USUARIO"):SetValue( (cAlias)->D3_USUARIO )
			oSection1:Cell("D3_MSOBS"):SetValue( (cAlias)->D3_MSOBS )
			oSection1:PrintLine()
					
			(cAlias)->(dbSkip())		
		Enddo

		oSection1:Finish()

	Endif

	(cAlias)->(dbCloseArea())

Return

/*/{Protheus.doc} GetMovStock
Query para consultar e retornar os movimentos de estoque de acordo com parâmetros
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 08/09/2021
@version version
/*/
Static Function GetMovStock()

Local _cQry	:= ''
Local xRet	:= GetNextAlias()

	_cQry := "SELECT  D3_DOC, D3_LOCAL, D3_COD, B1_DESC, B1_PROCED, B1_LOCAL, " + CRLF
	_cQry += "         D3_TM, D3_USUARIO, D3_UM,  D3_CC,  D3_QUANT, D3_MSOBS, D3_EMISSAO, D3_HORAS, D3_ESTORNO, D3_NUMSEQ " + CRLF
	_cQry += "FROM "+RetSqlName("SD3")+" SD3 " + CRLF
	_cQry += "		INNER JOIN "+RetSqlName("SB1")+" SB1 ON " + CRLF
	_cQry += "		B1_FILIAL='"+xFilial("SB1")+"' AND " + CRLF
	_cQry += "		B1_COD = D3_COD AND " + CRLF
	_cQry += "		SB1.D_E_L_E_T_ = ' ' " + CRLF

	_cQry += "WHERE	D3_FILIAL = '"+FWxFilial("SD3")+"'" + CRLF
	_cQry += "		AND SD3.D_E_L_E_T_ = ' ' " + CRLF
	_cQry += "		AND D3_EMISSAO	BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " + CRLF
	_cQry += "		AND D3_DOC		BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CRLF
	_cQry += "		AND D3_COD		BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + CRLF
	_cQry += "		AND D3_TM		BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + CRLF
	_cQry += "		AND LEFT(D3_MSOBS,8) <> 'RFATG005'  " + CRLF
	
	IF MV_PAR09 == 1 
		_cQry += "		AND SUBSTRING(B1_PROCED,2,1) = 'P'" + CRLF  // PRODUTIVO
	ELSEIF MV_PAR09 == 2
		_cQry += "		AND SUBSTRING(B1_PROCED,2,1) <> 'P'" + CRLF // NAO PRODUTIVO
	ENDIF

	IF MV_PAR10 == 1
		_cQry += "		AND LEFT(B1_PROCED,1) = '1'" + CRLF   // PRODUZIDO
	ELSEIF MV_PAR10 = 2	
		_cQry += "		AND LEFT(B1_PROCED,1) = '2'" + CRLF   // COMPRADO
	ELSEIF MV_PAR10 = 3	
		_cQry += "		AND LEFT(B1_PROCED,1) = '3'" + CRLF   // IMPORTADO
	ENDIF	
	
	_cQry += "ORDER BY D3_NUMSEQ" 

	_cQry := ChangeQuery(_cQry)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),xRet,.T.,.T.)

Return xRet
