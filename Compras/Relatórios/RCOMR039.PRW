#include "protheus.ch"
#include "parmtype.ch"
#include "totvs.ch"

/*/
@Program: RCOMR039
@Author: Everton Diniz - DS2U
@Version: 1.0
@Description: Relatório das divergências de entrada de NF x Pedido de Compras
/*/
User Function RCOMR039()

Local oReport
Private cAliasTMP

    Pergunte("RCOM039",.F.)
    
    oReport := ReportDef()
    oReport:PrintDialog()
    
Return

//****************************************
//* Definição do relatório               *
//****************************************
Static Function ReportDef()

Local cDesc     := "Este relatório imprimirá a relação de divergências entre Notas Fiscais e Pedidos de Compras"
Local cTitulo   := "Divergências N. Fiscal x Ped. Compras"
Local oReport
Local oSection

    oReport := TReport():New("RCOMR039",cTitulo,"RCOM039",{|oReport| PrintReport(oReport)},cDesc)

    oSection := TRSection():New(oReport,"DIVERG",{"SD1","SC7","SA2","SB1"})
    
    TRCell():New(oSection,"D1_DTDIGIT","SD1","Dt. Entrada",PesqPict("SD1","D1_DTDIGIT"),TamSX3("D1_DTDIGIT")[1])
    TRCell():New(oSection,"A2_NOME","SA2","Fornecedor",PesqPict("SA2","A2_NOME"),25)
    TRCell():New(oSection,"D1_DOC","SD1","N. Fiscal",PesqPict("SD1","D1_DOC"),TamSX3("D1_DOC")[1])
    TRCell():New(oSection,"D1_SERIE","SD1","Serie",PesqPict("SD1","D1_SERIE"),TamSX3("D1_SERIE")[1])
    TRCell():New(oSection,"D1_PEDIDO","SD1","Pedido",PesqPict("SD1","D1_PEDIDO"),TamSX3("D1_PEDIDO")[1])
    TRCell():New(oSection,"D1_ITEMPC","SD1","It. Ped",PesqPict("SD1","D1_ITEMPC"),TamSX3("D1_ITEMPC")[1])
    TRCell():New(oSection,"D1_COD","SD1","Produto",PesqPict("SD1","D1_COD"),TamSX3("D1_COD")[1])
    TRCell():New(oSection,"B1_DESC","SB1","Descrição",PesqPict("SD1","B1_DESC"),15)
    TRCell():New(oSection,"D1_UM","SD1","UM",PesqPict("SD1","D1_UM"),TamSX3("D1_UM")[1])
    TRCell():New(oSection,"D1QUANT","SD1","Qtd NF.",PesqPict("SC7","C7_QUANT"),TamSX3("C7_QUANT")[1])
    TRCell():New(oSection,"C7_QUANT","SC7","Qtd PC.",PesqPict("SC7","C7_QUANT"),TamSX3("C7_QUANT")[1])
    TRCell():New(oSection,"PERCDIF",,"% Dif.","@E 9999.99",12)
    TRCell():New(oSection,"C7_NUMSC","SC7","Nº SC",PesqPict("SC7","C7_NUMSC"),TamSX3("C7_NUMSC")[1])
    TRCell():New(oSection,"C7_ITEMSC","SC7","Item SC",PesqPict("SC7","C7_ITEMSC"),TamSX3("C7_ITEMSC")[1])
    TRCell():New(oSection,"CUSER","","Solic.","@!",20,,{ || UPPER(Alltrim(UsrFullName((cAliasTMP)->C1_USER)))})

Return oReport

//****************************************
//* Impressão do relatório               *
//****************************************
Static Function PrintReport(oReport)

Local cOrder    := ""
Local cSelect   := ""
Local cWhere    := ""
Local oSection  := oReport:Section(1)

DEFAULT MV_PAR01 := ""
DEFAULT MV_PAR02 := ""
DEFAULT MV_PAR03 := ""
DEFAULT MV_PAR04 := ""
DEFAULT MV_PAR05 := ""

    //Definição dos campos do Select
    cSelect := "%"
    cSelect += " D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, A2_NOME, D1_DTDIGIT, D1_PEDIDO, D1_ITEMPC, D1_COD, B1_DESC, "
    cSelect += " C1_USER, D1_UM, C7_NUMSC, C7_ITEMSC, SUM(D1_QUANT) AS D1QUANT, C7_QUANT "
    cSelect += "%"
    
    //Definição das condições do Where
    cWhere := "%"
    cWhere += " D1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
    cWhere += " D1_DTDIGIT BETWEEN '" + DToS(MV_PAR03) + "' AND '" + DToS(MV_PAR04) + "' AND "
    cWhere += " D1_TIPO IN ('N') AND "
    cWhere += " B1_COD = D1_COD AND "
    cWhere += " A2_COD + A2_LOJA = D1_FORNECE + D1_LOJA AND "
    cWhere += " C7_FILIAL = D1_FILIAL AND "
    cWhere += " C7_ITEM = D1_ITEMPC AND "
    cWhere += " C7_NUM = D1_PEDIDO AND "
    cWhere += " C1_FILIAL = C7_FILIAL AND "
    cWhere += " C1_PEDIDO = C7_NUM AND "
    cWhere += " C1_ITEMPED = C7_ITEM "
    cWhere += "%"

    //Definição da ordem do relatório
    cOrder := "%"
    cOrder += " D1_DTDIGIT, D1_DOC, D1_PEDIDO, D1_ITEMPC "
    cOrder += "%"

    cAliasTMP := GetNextAlias()

    MakeSqlExpr("RCOM039")

    oSection:BeginQuery()

    BeginSQL Alias cAliasTMP

        SELECT *, (((D1QUANT / C7_QUANT)-1)*100) AS PERCDIF  
        FROM (
                    SELECT  %Exp:cSelect%
                    FROM    %Table:SD1% SD1, %Table:SB1% SB1, %Table:SA2% SA2, 
                            %Table:SC7% SC7, %Table:SC1% SC1
                    WHERE   D1_FILIAL = %xFilial:SD1% 
                    AND %Exp:cWhere%
                    AND SD1.%NotDel% 
                    AND SB1.%NotDel%
                    AND SA2.%NotDel%
                    AND SC7.%NotDel%
                    AND SC1.%NotDel%
                    GROUP   BY D1_DOC, D1_SERIE, D1_FORNECE, 
                            D1_LOJA, A2_NOME, D1_DTDIGIT, 
                            D1_PEDIDO, D1_ITEMPC, D1_COD, B1_DESC,
                            C1_USER, D1_UM, C7_NUMSC, C7_ITEMSC, C7_QUANT
            ) AS TMP1
        
        WHERE (((D1QUANT / C7_QUANT)-1)*100) > 0
        ORDER BY %Exp:cOrder%

    EndSql

    oSection:EndQuery({MV_PAR05})
    oSection:Print()
    
Return
