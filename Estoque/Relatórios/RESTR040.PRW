#include "totvs.ch"


/*/{Protheus.doc} User Function RESTR040()
Relaório de Ranking de Cadastro de Produtos (Desenhos)
@type  Function
@author Masipack
@since 19/03/2020
/*/
User Function RESTR040()

Local cPerg := "RESTR040"

    Pergunte(cPerg,.F.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()

Return


/*/{Protheus.doc} ReportDef()
Função para definição do relaório
@type  Static Function
@author Masipack
@since 19/03/2020
@version version
@param cPerg, VarChar, Repassa para a função o nome do grupo de perguntas do relaório
@return oReport, Object, Retorna o objeto do relaório para exibição ao usuário
/*/
Static Function ReportDef(cPerg)

Local aRet      := Array(13)
Local cAlsQry   := GetNextAlias()
Local cDesc     := "Este relaório imprimirá o ranking de colaboradores que incluÃ­ram o produto no sistema."
Local cTitulo   := "Ranking de Cadastros de Produtos/Desenhos"
Local oReport, oSection

    oReport := TReport():New("RESTR040",cTitulo,cPerg,{|oReport| PrintReport(oReport,cAlsQry,@aRet)},cDesc)
    oReport:DisableOrientation()
	oReport:SetLandscape()

    oSection := TRSection():New(oReport,"",{"SB1"})
	TRCell():New( oSection,  "USER",  "", "Usuario"         , , 15, , {||aRet[1]})
    TRCell():New( oSection,  "MES01",  "", "Jan/"+MV_PAR01  , , 15, , {||aRet[2]})
    TRCell():New( oSection,  "MES02",  "", "Fev/"+MV_PAR01  , , 15, , {||aRet[3]})
    TRCell():New( oSection,  "MES03",  "", "Mar/"+MV_PAR01  , , 15, , {||aRet[4]})
    TRCell():New( oSection,  "MES04",  "", "Abr/"+MV_PAR01  , , 15, , {||aRet[5]})
    TRCell():New( oSection,  "MES05",  "", "Mai/"+MV_PAR01  , , 15, , {||aRet[6]})
    TRCell():New( oSection,  "MES06",  "", "Jun/"+MV_PAR01  , , 15, , {||aRet[7]})
    TRCell():New( oSection,  "MES07",  "", "Jul/"+MV_PAR01  , , 15, , {||aRet[8]})
    TRCell():New( oSection,  "MES08",  "", "Ago/"+MV_PAR01  , , 15, , {||aRet[9]})
    TRCell():New( oSection,  "MES09",  "", "Set/"+MV_PAR01  , , 15, , {||aRet[10]})
    TRCell():New( oSection,  "MES10",  "", "Out/"+MV_PAR01  , , 15, , {||aRet[11]})
    TRCell():New( oSection,  "MES11",  "", "Nov/"+MV_PAR01  , , 15, , {||aRet[12]})
    TRCell():New( oSection,  "MES12",  "", "Dez/"+MV_PAR01  , , 15, , {||aRet[13]})
    oSection:SetTotalInLine(.T.)

    TRFunction():New(oSection:Cell("MES01"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES02"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES03"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES04"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES05"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES06"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES07"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES08"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES09"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES10"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES11"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    TRFunction():New(oSection:Cell("MES12"),,"SUM",,"",,/*uFormula*/,.F.,.T.,.F.,oSection)
    
Return oReport



/*/{Protheus.doc} PrintReport
Função para imprimir o relatório
@type  Static Function
@author Masipack
@since 19/03/2020
@version version
@param oReport, Object, Envia o objeto do relatório para montagem
/*/
Static Function PrintReport(oReport,cAlsQry,aRet)

Local aDados    := {}
Local aGroup    := {}
Local cSelect   := ""
Local cUsrName  := ""
Local cWhere    := ""
Local nPosUsr   := 0
Local nX        := 0

    cSelect := "%"
//  cSelect += "SUBSTRING(B1_DATAC,5,2) AS MES, B1_USERLGI AS USERLGI, COUNT(B1_COD) AS TOTAL"
    cSelect += "SUBSTRING(B1_DATAC,5,2) AS MES, B1.R_E_C_N_O_ AS RECNO"
    cSelect += "%"

    cWhere  := "%"
//  cWhere  += "B1_TIPO IN ('PA') AND "
    cWhere  += "SUBSTRING(B1_DATAC,1,4) = '" + MV_PAR01 + "' AND "
    cWhere  += "B1_USERLGI != ' ' AND "
    cWhere  += "%"

    BEGINSQL Alias cAlsQry
        SELECT %Exp:cSelect%
        FROM %Table:SB1% B1
        WHERE %Exp:cWhere%
        B1.%NOTDEL%
        ORDER BY 1
    ENDSQL

    dbSelectArea("SB1")

    While (cAlsQry)->(!EOF())
        
        SB1->(dbGoTo((cAlsQry)->RECNO))
        
        cUsrName := SB1->(FWLeUserlg("B1_USERLGI",1))
        
        aGroup := UsrRetGrp( cUsrName ) 
        
        If aScan(aGroup,"000214") > 0
        
            nPosUsr := aScan(aDados,{ |x| x[1] == cUsrName })
            If nPosUsr == 0
                AADD(aDados,{ cUsrName, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 })
                aDados[Len(aDados)][VAL((cAlsQry)->MES)+1] += 1
            Else
                aDados[nPosUsr][VAL((cAlsQry)->MES)+1] += 1
            Endif

        Endif

        (cAlsQry)->(dbSkip())

    Enddo
    
    ASORT(aDados,,,{|x,y| x[1] < y[1]})

    oReport:SetMeter(Len(aDados))
    oReport:Section(1):Init()
    
    For nX := 1 To Len(aDados)

        oReport:IncMeter()

        If oReport:Cancel()
            Exit
        Endif

        aRet[01] := aDados[nX,1]
        aRet[02] := aDados[nX,2]
        aRet[03] := aDados[nX,3]
        aRet[04] := aDados[nX,4]
        aRet[05] := aDados[nX,5]
        aRet[06] := aDados[nX,6]
        aRet[07] := aDados[nX,7]
        aRet[08] := aDados[nX,8]
        aRet[09] := aDados[nX,9]
        aRet[10] := aDados[nX,10]
        aRet[11] := aDados[nX,11]
        aRet[12] := aDados[nX,12]
        aRet[13] := aDados[nX,13]
        
        oReport:Section(1):PrintLine()
    
    Next nX

    (cAlsQry)->( dbCloseArea() )

Return