#include "protheus.ch"
#include "parmtype.ch"
#include "totvs.ch"

/*/
@Program: RESTR034
@Author: Everton Diniz - DS2U
@Version: 1.0
@type JOB
@Description: Relatório de produtos com saldo (B2_QATU) menor que zero
/*/
User Function RESTR034(aParam)

Local oReport
Private cAlsTmp := GetNextAlias()

    RpcSetEnv(aParam[01],aParam[02])
    oReport := ReportDef()

    oReport:nRemoteType := NO_REMOTE                                                     //Forma de geração do relatório
    oReport:SetDevice(3)                                                                 //Envio do PDF por e-mail
    oReport:cEmail  := SuperGetMV("MS_MSLDNEG", .F., "protheus@grupomasipack.com.br")    //E-mail do destinatário do relatório
    oReport:Print(.F., "", .T.)

    RpcClearEnv()

Return

Static Function ReportDef()

Local cTitulo := "Produtos com saldo negativo no Estoque"
Local oReport := TReport():New("RESTR034",cTitulo,,{|oReport| PrintReport(oReport)})
Local oSection

    oReport:SetLandScape()

    oSection := TRSection():New(oReport,"DIVERG",{"SB1","SB2"})
    
    TRCell():New(oSection,"B1_COD","SB1","Código",PesqPict("SB1","B1_COD"),TamSX3("B1_COD")[1])
    TRCell():New(oSection,"B1_DESC","SB1","Descrição",PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1])
    TRCell():New(oSection,"B2_LOCAL","SB2","Local",PesqPict("SB2","B2_LOCAL"),TamSX3("B2_LOCAL")[1])
    TRCell():New(oSection,"B2_QATU","SB2","Saldo Atual",PesqPict("SB2","B2_QATU"),TamSX3("B2_QATU")[1])
    
Return oReport

//Localiza os dados e imprime as informações
Static Function PrintReport(oReport)

Local cOrder    := ""
Local cSelect   := ""
Local cWhere    := ""
Local oSection  := oReport:Section(1)

    cSelect := "%"
    cSelect += " SB1.*, SB2.* "
    cSelect += "%"

    cWhere := "%"
    cWhere += " B1_FILIAL = '"+xFilial("SB1")+"' AND "
    cWhere += " B1_MSBLQL = '2' AND "
    cWhere += " B2_FILIAL = '"+xFilial("SB2")+"' AND "
    cWhere += " B2_COD = B1_COD AND "
    cWhere += " B2_QATU < 0 "
    cWhere += "%"

    cOrder := "%"
    cOrder += "B1_COD "
    cOrder += "%"

    oSection:BeginQuery()

    BeginSQL Alias cAlsTmp
        SELECT  %Exp:cSelect%
        FROM    %Table:SB1% SB1, %Table:SB2% SB2 
        WHERE   %Exp:cWhere%
        AND SB1.%NotDel%
        AND SB2.%NotDel%
        ORDER BY %Exp:cOrder%
    EndSql

    oSection:EndQuery()
    oSection:Print()

Return
