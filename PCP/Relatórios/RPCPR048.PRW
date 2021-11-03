#include "protheus.ch"
#include "parmtype.ch" 
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPR048  ºAutor  ³Everton Diniz - DS2Uº Data ³  04/07/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório para contagem de OPs encerradas por posição      º±±
±±º          ³ Chamado: 20190319000148                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCPR048()
Local oReport := ReportDef()
	oReport:PrintDialog()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\¿
//³Função da definição do Relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\Ù
Static Function ReportDef()

Local cPerg		:= "RPCP048"
Local cTitle	:= "Contagem de OPs encerradas por posição"
Local oReport 	:= Nil
Local oSection1	:= Nil

    oReport := TReport():New("RPCPR048",cTitle,cPerg,{|oReport| ReportPrint(oReport)},"Relatório de OP's encerradas por posição.")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	Pergunte(cPerg,.F.)

    oSection1 := TRSection():New(oReport, "OP", , , , )
	TRCell():New(oSection1,"HB_COD"		, "SEC1", "Posição"     , , 20)
	TRCell():New(oSection1,"HB_NOME"	, "SEC1", "Localização" , , 60)
	TRCell():New(oSection1,"nTOTAL"	    , "SEC1", "Total OP's"  , , 10)
    TRCell():New(oSection1,"nTOTALPC"   , "SEC1", "Total PC's"  , , 10)

Return oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para imprimir os dados encontrados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportPrint(oReport)

Local cAlsOp	:= GetNextAlias()
Local dEmissao  := CToD("  /  /  ")
Local cPosic    := ""
Local cQuery	:= ""
Local n         := 0
Local oSection1 := oReport:Section(1)

    cPosic := f_AjParam()

    cQuery := " SELECT	MAX(ZS_DATA) ZS_DATA, HB_COD, HB_NOME, " + CRLF
    cQuery += " COUNT(ZS_OP) AS TOTALOP, SUM(ZS_QTDE) AS TOTALPC " + CRLF
    cQuery += " FROM " +RetSqlName("SZS")+ " ZS " + CRLF

    cQuery += "     INNER JOIN " +RetSqlName("SHB")+ " HB ON " + CRLF
    cQuery += "     HB_FILIAL = ZS_FILIAL " + CRLF
    cQuery += "     AND HB_COD = ZS_CC " + CRLF
    cQuery += "     AND HB.D_E_L_E_T_ = ' ' " + CRLF
        
    cQuery += " WHERE ZS_FILIAL = '"+xFilial("SZS")+"' " + CRLF
    cQuery += " AND ZS_DATA BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' " + CRLF
    If !Empty(cPosic)
        cQuery += " AND ZS_CC IN (" +cPosic+ ") " + CRLF
    Endif
    cQuery += " AND ZS.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += " GROUP BY ZS_DATA, HB_COD, HB_NOME " + CRLF
    cQuery += " ORDER BY ZS_DATA, HB_COD "
    cQuery := ChangeQuery(cQuery)

    TcQuery cQuery NEW ALIAS cAlsOp

    oReport:SetMeter(cAlsOp->(LastRec()))
    
    oSection1:Init()
   
    While !cAlsOp->(EOF()) .And. !oReport:Cancel()
        
        oReport:IncMeter()
        If oReport:Cancel()
            Exit
        Endif

        If dEmissao <> SToD(cAlsOp->ZS_DATA)
            dEmissao :=  SToD(cAlsOp->ZS_DATA)
            oSection1:Finish()
            oSection1:Init()
            oReport:SkipLine(2)
			oReport:PrintText("Data: " + DToC(dEmissao), oReport:Row(), 10 )
        Endif

        oSection1:CELL("HB_COD"):SetValue(cAlsOp->HB_COD)
        oSection1:CELL("HB_NOME"):SetValue(Alltrim(cAlsOp->HB_NOME))
        oSection1:CELL("nTOTAL"):SetValue(cAlsOp->TOTALOP)
        oSection1:CELL("nTOTALPC"):SetValue(cAlsOp->TOTALPC)
        oSection1:PrintLine()

        cAlsOp->(dbSkip())
    Enddo

    oSection1:Finish()
    cAlsOp->(dbCloseArea())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\¿
//³Função p/ concatenar parametros  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\Ù
Static Function f_AjParam()

Local aParam    := {}
Local cRet      := ""
Local n         := 0

    If !Empty(MV_PAR03)
        cRet := Alltrim(MV_PAR03)
    //    AADD(aParam, StrTokArr2( MV_PAR03, "," ))
    Endif

    If !Empty(MV_PAR04)
        If SubStr(cRet,Len(cRet),1) # ","
            cRet += ","
        Endif
        cRet += Alltrim(MV_PAR04)
    //     AADD(aParam, StrTokArr2( MV_PAR04, "," ))
    Endif

    aParam  := StrTokArr2( cRet, "," )
    cRet    := ""

    If Len(aParam) > 0
        For n:=1 To Len(aParam)
            cRet += If(n < Len(aParam), " '" +Alltrim(aParam[n])+ "', ", "'" +Alltrim(aParam[n])+ "'" )
        Next n
    Endif

    /*

    If !Empty(MV_PAR03)
        aParam := StrTokArr2( Alltrim(MV_PAR03), "," )

        For n:=1 To Len(aParam)
            cRet += If(n < Len(aParam), " '" +Alltrim(aParam[n])+ "', ", "'" +Alltrim(aParam[n])+ "'" )
        Next n
    Endif

    If !Empty(MV_PAR04)
        aParam := StrTokArr2( MV_PAR04, "," )

        For n:=1 To Len(aParam)
            cRet += If(n < Len(aParam), " '" +Alltrim(aParam[n])+ "', ", "'" +Alltrim(aParam[n])+ "'" )
        Next n
    Endif
    */

Return cRet