#include "protheus.ch"
#include "parmtype.ch"
#include "totvs.ch"

/*/
@Program: RESTR035
@Author: Everton Diniz - DS2U
@Version: 1.0
@type JOB
@Description: Relatório de produtos com custo médio (B2_CM1) menor que zero
/*/
User Function RESTR035()

    //Masipack
    ProcRel({"01","01"})

    //Fabrima
    ProcRel({"10","01"})

Return

Static Function ProcRel(aParam)

Local oReport
Private cAlsTmp := GetNextAlias()

    RpcSetEnv(aParam[01],aParam[02])
    
    oReport := ReportDef()

        oReport:nRemoteType := NO_REMOTE                                                    //Forma de geração do relatório
        oReport:SetDevice(3)                                                                //Envio do PDF por e-mail
        oReport:cEmail  := SuperGetMV("MS_MCMNEG", .F., "protheus@grupomasipack.com.br")    //E-mail do destinatário do relatório
        oReport:Print(.F., "", .T.)

    RpcClearEnv()

Return

Static Function ReportDef()

Local cTitulo := "Produtos com Custo Médio Negativo"
Local oReport := TReport():New("RESTR035",cTitulo,,{|oReport| PrintReport(oReport)})
Local oSection

    oReport:SetLandScape()

    oSection := TRSection():New(oReport,"DIVERG",{"SB1","SB2"})
    
    TRCell():New(oSection,"B1_COD","SB1","Código",PesqPict("SB1","B1_COD"),TamSX3("B1_COD")[1])
    TRCell():New(oSection,"B1_DESC","SB1","Descrição",PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1])
    TRCell():New(oSection,"B2_CM1","SB2","Custo Médio",PesqPict("SB2","B2_CM1"),TamSX3("B2_CM1")[1])
    
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
    cWhere += " B2_CM1 < 0 "
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
