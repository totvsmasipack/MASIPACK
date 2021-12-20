#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RPCPR051
Relatório de pedidos de compras em aberto
@type  Function
@author Masipack
@since 16.12.21
/*/
User Function RPCPR051()

Local oReport   := Nil

	oReport := ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()

Local cDesc     := 'Este relatório imprimirá os pedidos de compras em aberto'
Local cTitulo   := 'Pedidos de Compras Em Aberto'
Local oSection  := Nil

	oReport := TReport():New('RPCPR051', cTitulo, '', {|oReport| PrintReport(oReport)}, cDesc)
    oReport:SetLandscape()
	oReport:DisableOrientation()
	oReport:oPage:setPaperSize(10)

	oSection := TRSection():New(oReport,'CABORD',{})

    TRCell():New(oSection,"C7_NUM",     "SC7",  RetTitle("C7_NUM"),     PesqPict("SC7","C7_NUM"),       TamSX3("C7_NUM")[1])
    TRCell():New(oSection,"C7_ITEM",    "SC7",  RetTitle("C7_ITEM"),    PesqPict("SC7","C7_ITEM"),      TamSX3("C7_ITEM")[1])
    TRCell():New(oSection,"C7_COND",    "SC7",  RetTitle("C7_COND"),    PesqPict("SC7","C7_COND"),      TamSX3("C7_COND")[1])
    TRCell():New(oSection,"A2_COD",     "SA2",  RetTitle("A2_COD"),     PesqPict("SA2","A2_COD"),       TamSX3("A2_COD")[1])
    TRCell():New(oSection,"A2_LOJA",    "SA2",  RetTitle("A2_LOJA"),    PesqPict("SA2","A2_LOJA"),      TamSX3("A2_LOJA")[1])
    TRCell():New(oSection,"A2_NOME",    "SA2",  RetTitle("A2_NOME"),    PesqPict("SA2","A2_NOME"),      TamSX3("A2_NOME")[1])
    TRCell():New(oSection,"C7_PRODUTO", "SC7",  RetTitle("C7_PRODUTO"), PesqPict("SC7","C7_PRODUTO"),   TamSX3("C7_PRODUTO")[1])
    TRCell():New(oSection,"B1_DESC",    "SB1",  RetTitle("B1_DESC"),    PesqPict("SB1","B1_DESC"),      TamSX3("B1_DESC")[1])
    TRCell():New(oSection,"C7_QUANT",   "SC7",  RetTitle("C7_QUANT"),   PesqPict("SC7","C7_QUANT"),     TamSX3("C7_QUANT")[1])
    TRCell():New(oSection,"C7_QUJE",    "SC7",  RetTitle("C7_QUJE"),    PesqPict("SC7","C7_QUJE"),      TamSX3("C7_QUJE")[1])
    TRCell():New(oSection,"C7_PRECO",   "SC7",  RetTitle("C7_PRECO"),   PesqPict("SC7","C7_PRECO"),     TamSX3("C7_PRECO")[1])
    TRCell():New(oSection,"C7_TOTAL",   "SC7",  RetTitle("C7_TOTAL"),   PesqPict("SC7","C7_TOTAL"),     TamSX3("C7_TOTAL")[1])
    TRCell():New(oSection,"C7_NUMSC",   "SC7",  RetTitle("C7_NUMSC"),   PesqPict("SC7","C7_NUMSC"),     TamSX3("C7_NUMSC")[1])
    TRCell():New(oSection,"C7_ITEMSC",  "SC7",  RetTitle("C7_ITEMSC"),  PesqPict("SC7","C7_ITEMSC"),    TamSX3("C7_ITEMSC")[1])
    TRCell():New(oSection,"C7_DATPRF",  "SC7",  RetTitle("C7_DATPRF"),  PesqPict("SC7","C7_DATPRF"),    TamSX3("C7_DATPRF")[1])
    TRCell():New(oSection,"C7_RETFOR",  "SC7",  RetTitle("C7_RETFOR"),  PesqPict("SC7","C7_RETFOR"),    TamSX3("C7_RETFOR")[1])
    TRCell():New(oSection,"B2_QATU",    "SB2",  RetTitle("B2_QATU"),    PesqPict("SB2","B2_QATU"),      TamSX3("B2_QATU")[1])
    TRCell():New(oSection,"B2_QEMP",    "SB2",  RetTitle("B2_QEMP"),    PesqPict("SB2","B2_QEMP"),      TamSX3("B2_QEMP")[1])
    TRCell():New(oSection,"B2_RESERVA", "SB2",  RetTitle("B2_RESERVA"), PesqPict("SB2","B2_RESERVA"),   TamSX3("B2_RESERVA")[1])
    TRCell():New(oSection,"B2_QPEDVEN", "SB2",  RetTitle("B2_QPEDVEN"), PesqPict("SB2","B2_QPEDVEN"),   TamSX3("B2_QPEDVEN")[1])
    TRCell():New(oSection,"B2_SALPEDI", "SB2",  RetTitle("B2_SALPEDI"), PesqPict("SB2","B2_SALPEDI"),   TamSX3("B2_SALPEDI")[1])
    TRCell():New(oSection,"B2_NAOCLAS", "SB2",  RetTitle("B2_NAOCLAS"), PesqPict("SB2","B2_NAOCLAS"),   TamSX3("B2_NAOCLAS")[1])
    TRCell():New(oSection,"E4_CTRADT",  ""   ,  RetTitle("E4_CTRADT"),  PesqPict("SE4","E4_CTRADT"),    08)
    TRCell():New(oSection,"STATUSFIN",  ""   ,  'Status Fin.'        ,  "@!",                           10)
	
Return oReport



Static Function PrintReport(oReport)

Local cAlias	:= GetNextAlias()
Local oSection	:= oReport:Section(1)

    oSection:BeginQuery()
	
    BEGINSQL Alias cAlias
        SELECT  C7_NUM, C7_ITEM, A2_COD, A2_LOJA, A2_NOME, C7_PRODUTO, B1_DESC, C7_QUANT, C7_QUJE, C7_PRECO, C7_TOTAL, C7_COND, C7_NUMSC, C7_ITEMSC, C7_DATPRF, C7_RETFOR, 
                COALESCE(B2_QATU,0) [B2_QATU], COALESCE(B2_QEMP,0) [B2_QEMP], COALESCE(B2_RESERVA,0) [B2_RESERVA], COALESCE(B2_QPEDVEN,0) [B2_QPEDVEN], COALESCE(B2_SALPEDI,0) [B2_SALPEDI], COALESCE(B2_NAOCLAS,0) [B2_NAOCLAS], IIF(E4_CTRADT = '1','SIM','NAO') [E4_CTRADT], 
                CASE WHEN E4_CTRADT = '1' AND E2_VALOR = E2_SALDO THEN 'PENDENTE' ELSE  CASE WHEN E4_CTRADT != '1' THEN '-' ELSE 'PAGO' END END [STATUSFIN]
        FROM %Table:SC7% C7
	        INNER JOIN %Table:SB1% B1 ON B1_FILIAL = C7_FILIAL      AND B1_COD = C7_PRODUTO AND B1.D_E_L_E_T_ =  ' '
	        INNER JOIN %Table:SA2% A2 ON A2_FILIAL = %xFilial:SA2%  AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA   AND A2.D_E_L_E_T_ = ' '
            INNER JOIN %Table:SE4% E4 ON E4_FILIAL = %xFilial:SE4%  AND E4_CODIGO = C7_COND AND A2.D_E_L_E_T_ = ' '
            LEFT JOIN  %Table:SE2% E2 ON E2_NUM = C7_NUM AND E2_FORNECE = C7_FORNECE AND E2_LOJA = C7_LOJA AND E2_FILORIG = C7_FILIAL AND E2.D_E_L_E_T_ = ' '
	        LEFT  JOIN %Table:SB2% B2 ON B2_FILIAL = C7_FILIAL      AND B2_COD = C7_PRODUTO AND B2_LOCAL = C7_LOCAL AND B2.D_E_L_E_T_ = ' '
        WHERE C7_FILIAL = %xFilial:SC7% AND C7_RESIDUO = ' '    AND C7_QUANT > C7_QUJE AND C7.D_E_L_E_T_ = ' '
        ORDER BY C7_NUM, C7_ITEM	
    ENDSQL
    
    oSection:EndQuery()
	oSection:Print()

    (cAlias)->(dbCloseArea())

Return
