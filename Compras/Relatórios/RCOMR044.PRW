#include 'totvs.ch'
#include 'protheus.ch'


/*/{Protheus.doc} User Function RCOMR044
(long_description)
@type  Function
@author user
@since 14/02/2022
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function RCOMR044()

Local oReport
Local cTRB

	If !(FwCodEmp() $ '01|10')
		Help(" ",1,"RCOMR044_1",, "Este relatório é de uso exclusivo das empresas 01-Masipack e 10-Fabrima",1,0)
		Return
	Endif

	Pergunte("RCOMR044",.F.)
	oReport:= ReportDef(@cTRB)
	oReport:PrintDialog()

Return



Static Function ReportDef(cTRB)

Local oReport	:= Nil
Local oSection1	:= Nil
Local cTitle	:= "Relação de Pedidos de Compras"
Local cPerg		:= "RCOMR044"

	oReport := TReport():New("RCOMR044",cTitle,cPerg,{|oReport| ReportPrint(oReport,@cTRB)},"Relacao de Pedidos de Compras")
	
	oSection1 := TRSection():New(oReport,"Listagem dos Pedidos",{})

	TRCell():New(oSection1,	"C7_NUM",		"",	RetTitle('C7_NUM'),			PesqPict("SC7","C7_NUM"),		TamSX3("C7_NUM")[1])
	TRCell():New(oSection1,	"C7_ITEM",		"",	RetTitle('C7_ITEM'),		PesqPict("SC7","C7_ITEM"),		TamSX3("C7_ITEM")[1])
	TRCell():New(oSection1,	"C7_FORNECE",	"",	RetTitle('C7_FORNECE'),		PesqPict("SC7","C7_FORNECE"),	TamSX3("C7_FORNECE")[1])
	TRCell():New(oSection1,	"C7_LOJA",		"",	RetTitle('C7_LOJA'),		PesqPict("SC7","C7_LOJA"),		TamSX3("C7_LOJA")[1])
	TRCell():New(oSection1,	"A2_NREDUZ",	"",	RetTitle('A2_NREDUZ'),		PesqPict("SA2","A2_NREDUZ"),	TamSX3("A2_NREDUZ")[1])
	TRCell():New(oSection1,	"C7_PRODUTO",	"",	RetTitle('C7_PRODUTO'),		PesqPict("SC7","C7_PRODUTO"),	TamSX3("C7_PRODUTO")[1])
	TRCell():New(oSection1,	"B1_DESC",		"",	RetTitle('B1_DESC'),		PesqPict("SB1","B1_DESC"),		TamSX3("B1_DESC")[1])
	TRCell():New(oSection1,	"C7_UM",		"",	RetTitle('C7_UM'),			PesqPict("SC7","C7_UM"),		TamSX3("C7_UM")[1])

	TRCell():New(oSection1,	"C7_QUANT",		"",	RetTitle('C7_QUANT'),		PesqPict("SC7","C7_QUANT"),		TamSX3("C7_QUANT")[1])
	TRCell():New(oSection1,	"C7_QUJE",		"",	RetTitle('C7_QUJE'),		PesqPict("SC7","C7_QUJE"),		TamSX3("C7_QUJE")[1])
	TRCell():New(oSection1,	"C7_PRECO",		"",	RetTitle('C7_PRECO'),		PesqPict("SC7","C7_PRECO"),		TamSX3("C7_PRECO")[1])
	TRCell():New(oSection1,	"C7_TOTAL",		"",	RetTitle('C7_TOTAL'),		PesqPict("SC7","C7_TOTAL"),		TamSX3("C7_TOTAL")[1])
	TRCell():New(oSection1,	"C7QTDRES",		"",	"Qtd Pendente",				PesqPict("SC7","C7_QUANT"),		TamSX3("C7_QUANT")[1],	.F.,	{ || (cTRB)->(C7_QUANT - C7_QUJE)   })
	TRCell():New(oSection1,	"C7TOTRES",		"",	"Vlr Pendente",				PesqPict("SC7","C7_TOTAL"),		TamSX3("C7_TOTAL")[1],	.F.,	{ || (cTRB)->((C7_QUANT - C7_QUJE) * C7_PRECO)  })
	TRCell():New(oSection1,	"C7_USER",		"",	RetTitle('C7_USER'),		"@!",							30,						.F.,	{ || Alltrim(UsrRetName((cTRB)->C7_USER))  })

	TRCell():New(oSection1,	"E4_CODIGO",	"",	RetTitle('E4_CODIGO'),		PesqPict("SE4","E4_CODIGO"),	TamSX3("E4_CODIGO")[1])
	TRCell():New(oSection1,	"E4_DESCRI",	"",	RetTitle('E4_DESCRI'),		PesqPict("SE4","E4_DESCRI"),	TamSX3("E4_DESCRI")[1])

	TRCell():New(oSection1,	"B1_PE",		"",	RetTitle('B1_PE'),			PesqPict("SB1","B1_PE"),		TamSX3("B1_PE")[1])
	TRCell():New(oSection1,	"B1_TIPE",		"",	RetTitle('B1_TIPE'),		PesqPict("SB1","B1_TIPE"),		TamSX3("B1_TIPE")[1])
	TRCell():New(oSection1,	"B1_PROCED",	"",	RetTitle('B1_PROCED'),		PesqPict("SB1","B1_PROCED"),	TamSX3("B1_PROCED")[1])
	TRCell():New(oSection1,	"C7_EMISSAO",	"",	RetTitle('C7_EMISSAO'),		PesqPict("SC7","C7_EMISSAO"),	TamSX3("C7_EMISSAO")[1], .F.,	{ || DTOC(STOD((cTRB)->C7_EMISSAO))  })
	TRCell():New(oSection1,	"C7_DATPRF",	"",	RetTitle('C7_DATPRF'),		PesqPict("SC7","C7_EMISSAO"),	TamSX3("C7_DATPRF")[1], .F.,	{ || DTOC(STOD((cTRB)->C7_DATPRF))  })
	TRCell():New(oSection1,	"C7_OBS",		"",	RetTitle('C7_OBS'),			PesqPict("SC7","C7_OBS"),		TamSX3("C7_OBS")[1])
	TRCell():New(oSection1,	"C7_RETFOR",	"",	RetTitle('C7_RETFOR'),		PesqPict("SC7","C7_RETFOR"),	TamSX3("C7_RETFOR")[1])

	TRCell():New(oSection1,	"C1_NUM",		"",	RetTitle('C1_NUM'),			PesqPict("SC1","C1_NUM"),		TamSX3("C1_NUM")[1])
	TRCell():New(oSection1,	"C1_EMISSAO",	"",	RetTitle('C1_EMISSAO'),		PesqPict("SC7","C7_EMISSAO"),	TamSX3("C1_EMISSAO")[1], .F.,	{ || DTOC(STOD((cTRB)->C1_EMISSAO))  })
	TRCell():New(oSection1,	"C1_DATPRF",	"",	RetTitle('C1_DATPRF'),		PesqPict("SC7","C7_EMISSAO"),	TamSX3("C1_DATPRF")[1], .F.,	{ || DTOC(STOD((cTRB)->C1_DATPRF))  })
	TRCell():New(oSection1,	"C1_USER",		"",	RetTitle('C1_USER'),		PesqPict("SC1","C1_USER"),		TamSX3("C1_USER")[1],	.F.,	{ || Alltrim(UsrRetName((cTRB)->C1_USER))  })
	TRCell():New(oSection1,	"C1_MSAPROP",	"",	RetTitle('C1_MSAPROP'),		PesqPict("SC1","C1_MSAPROP"),	TamSX3("C1_MSAPROP")[1])

	TRCell():New(oSection1,	"C8_NUM",		"",	RetTitle('C8_NUM'),			PesqPict("SC8","C8_NUM"),		TamSX3("C8_NUM")[1])
	TRCell():New(oSection1,	"C8_EMISSAO",	"",	RetTitle('C8_EMISSAO'),		PesqPict("SC7","C7_EMISSAO"),	TamSX3("C8_EMISSAO")[1], .F.,	{ || DTOC(STOD((cTRB)->C8_EMISSAO))  })

	TRCell():New(oSection1,	"SALDO_ATU",	"",	RetTitle('B2_QATU'),		PesqPict("SB2","B2_QATU"),		TamSX3("B2_QATU")[1])
	TRCell():New(oSection1,	"EMP_OP",		"",	RetTitle('B2_QEMP'),		PesqPict("SB2","B2_QATU"),		TamSX3("B2_QATU")[1])
	TRCell():New(oSection1,	"EMP_PV",		"",	RetTitle('B2_QPEDVEN'),		PesqPict("SB2","B2_QATU"),		TamSX3("B2_QATU")[1])
	TRCell():New(oSection1,	"RESERVA",		"",	RetTitle('B2_RESERVA'),		PesqPict("SB2","B2_QATU"),		TamSX3("B2_QATU")[1])
	TRCell():New(oSection1,	"EMP_SA",		"",	RetTitle('B2_QEMPSA'),		PesqPict("SB2","B2_QATU"),		TamSX3("B2_QATU")[1])
	TRCell():New(oSection1,	"PRENOTA",		"",	RetTitle('B2_NAOCLAS'),		PesqPict("SB2","B2_QATU"),		TamSX3("B2_QATU")[1])
	TRCell():New(oSection1,	"SALDO_DIS",	"",	"Saldo Dispon.",			PesqPict("SB2","B2_QATU"),		TamSX3("B2_QATU")[1])

Return oReport


Static Function ReportPrint(oReport, cTRB)

Local cWhere	:= ''
Local oSection  := oReport:Section(1)

	cWhere := "%"
	IF MV_PAR11 == 1	//Pendentes
		cWhere += " C7_QUANT > C7_QUJE AND " + CRLF
		cWhere += " C7_RESIDUO != 'S' " + CRLF
	ElseIf MV_PAR11 == 2	//Encerrados
		cWhere += " C7_QUANT <= C7_QUJE AND " + CRLF
		cWhere += " C7_RESIDUO != 'S' " + CRLF
	Elseif MV_PAR11 == 3	//Elim. Resíduo
		cWhere += " C7_RESIDUO = 'S' " + CRLF
	Endif
	cWhere += "%"

	cTRB := GetNextAlias()

	BEGINSQL ALIAS cTRB

		SELECT	
			
			C7_NUM, C7_ITEM, C7_FORNECE, C7_LOJA, A2_NREDUZ, C7_PRODUTO, B1_DESC, C7_UM, C7_QUANT, C7_QUJE, C7_PRECO, C7_TOTAL, 
			(C7_QUANT - C7_QUJE) [C7QTDRES],
			ROUND((C7_QUANT - C7_QUJE) * C7_PRECO,2) [C7TOTRES], C7_USER,
			E4_CODIGO, E4_DESCRI,
			B1_PE, B1_TIPE, B1_PROCED, C7_EMISSAO, C7_DATPRF, C7_OBS, 
			CASE WHEN C7_RETFOR = 'S' THEN 'SIM' ELSE 'NAO' END [C7_RETFOR],
			C1_NUM, C1_EMISSAO, C1_DATPRF, C1_USER, C1_MSAPROP,

			COALESCE(C8_NUM,'-')		[C8_NUM], 
			COALESCE(C8_EMISSAO,'-')	[C8_EMISSAO],

			COALESCE(B2_QATU,0)		[SALDO_ATU], 
			COALESCE(B2_QEMP,0)		[EMP_OP], 
			COALESCE(B2_QPEDVEN,0)	[EMP_PV],
			COALESCE(B2_RESERVA,0)	[RESERVA],
			COALESCE(B2_QEMPSA,0)	[EMP_SA],
			COALESCE(CASE WHEN COALESCE(D1_TIPO,'') IN ('N') THEN B2_NAOCLAS ELSE B2_NAOCLAS - COALESCE(D1_QUANT,0) END, 0) [PRENOTA],
			COALESCE(B2_QATU - B2_QEMP - B2_QPEDVEN - B2_RESERVA - B2_QEMPSA, 0)	[SALDO_DIS]

		FROM	%Table:SC7% C7
					
			INNER JOIN %Table:SA2% A2 ON
			A2_FILIAL		= %xFilial:SA2%	AND
			A2_COD			= C7_FORNECE	AND
			A2_LOJA			= C7_LOJA		AND
			A2.%NOTDEL%
				
			INNER JOIN %Table:SB1% B1 ON
			B1_FILIAL		= %xFilial:SB1%	AND
			B1_COD			= C7_PRODUTO	AND
			B1.%NOTDEL%

			LEFT JOIN %Table:SD1% D1 ON
			D1_FILIAL		= %xFilial:SD1%	AND
			D1_COD			= C7_PRODUTO	AND
			D1_PEDIDO		= C7_NUM		AND
			D1_ITEMPC		= C7_ITEM		AND
			D1_TES			= %Exp:''%		AND
			D1.%NOTDEL%

			LEFT JOIN %Table:SB2% B2 ON
			B2_FILIAL		= C7_FILIAL		AND
			B2_COD			= C7_PRODUTO	AND
			B2_LOCAL		= C7_LOCAL		AND
			B2.%NOTDEL%

			LEFT JOIN %Table:SC1% C1 ON
			C1_FILIAL		= C7_FILIAL		AND
			C1_ITEM			= C7_ITEMSC		AND
			C1_NUM			= C7_NUMSC		AND
			C1.%NOTDEL%

			LEFT JOIN %Table:SC8% C8 ON
			C8_FILIAL		= C1_FILIAL		AND
			C8_PRODUTO		= C1_PRODUTO	AND
			C8_NUMSC		= C1_NUM		AND
			C8_ITEMSC		= C1_ITEM		AND
			C8.%NOTDEL%

			LEFT JOIN %Table:SE4% E4 ON
			E4_FILIAL		= %xFilial:SE4%	AND
			E4_CODIGO 		= C7_COND		AND
			E4.%NOTDEL%

		WHERE
			C7_FILIAL		= %xFilial:SC7%	AND
			C7_TIPO			= %Exp:'1'%		AND
			C7_DATPRF		BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)%	AND
			C7_EMISSAO		BETWEEN %Exp:DTOS(MV_PAR03)% AND %Exp:DTOS(MV_PAR04)%	AND
			C7_FORNECE		BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%	AND
			C7_NUM			BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%	AND
			C7_PRODUTO		BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%	AND
			%Exp:cWhere%	AND
			C7.%NOTDEL%

		GROUP BY	C7_NUM, C7_ITEM, C7_FORNECE, C7_LOJA, A2_NREDUZ, C7_PRODUTO, B1_DESC, C7_UM, C7_QUANT, C7_QUJE, C7_PRECO,
			C7_TOTAL, C7_QUANT, C7_QUJE, C7_USER, E4_CODIGO, E4_DESCRI, B1_PE, B1_TIPE, B1_PROCED, C7_EMISSAO, C7_DATPRF, 
			C7_OBS, C7_RETFOR, C1_NUM, C1_EMISSAO, C1_DATPRF, C1_USER, C1_MSAPROP, C8_NUM, C8_EMISSAO, D1_TIPO, D1_QUANT,
			B2_NAOCLAS, B2_QATU, B2_QEMP, B2_RESERVA, B2_QPEDVEN, B2_QEMPSA

		ORDER BY C7_NUM, C7_ITEM

	ENDSQL	

	oSection:EndQuery()
	oSection:Print()

Return
