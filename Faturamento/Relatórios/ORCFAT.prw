#include 'totvs.ch'


/*/{Protheus.doc} User Function ORCFAT
Impressão do Orçamento
@type User Function
@author Masipack
@since 08/06/2020
/*/
User Function ORCFAT()
    
Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return

//Definição do layout do relatório
Static Function ReportDef()

Local cDesc     := "Este relatório Imprime o Orçamento"
Local cTitulo   := ""
Local oReport
Local oSection1, oSection2

    oReport := TReport():New("ORCFAT",cTitulo,/*cPerg*/,{|oReport| PrintReport(oReport)},cDesc)
    oReport:ShowHeader(.F.)
    oReport:nFontBody := 7
	oReport:cFontBody := "Courier New"

    oSection1 := TRSection():New(oReport, "Capa",   {"SCJ"})

    oSection2 := TRSection():New(oReport, "Produtos", {"SCK"}, NIL, .F., .T.)

    TRCell():New(oSection1,  "CJ_NUM",   "SCJ",  RetTitle("CJ_NUM"), PesqPict("SCJ","CJ_NUM"),   TamSX3("CJ_NUM")[1] )

Return oReport


//Impressão do relatório
Static Function PrintReport(oReport)

Local aArea     := GetArea()
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)

//    oReport:SetTitle("Orçamento " + SCJ->CJ_NUM)
    
    //+++++++++++++++++++++++++++++++
    //+ Cabeçalho do Orçamento      +
    //+++++++++++++++++++++++++++++++
    oReport:Box(246,10,600,2545)
    oReport:SkipLine()
    oReport:PrtCenter( 'Orçamento ' + SCJ->CJ_NUM )
    oReport:SkipLine()
    oReport:PrintText( SM0->M0_NOME )


    //+++++++++++++++++++++++++++++++
    //+ Itens do Orçamento          +
    //+++++++++++++++++++++++++++++++
    dbSelectArea("SCK")
    SCK->(dbSetOrder(1))
    SCK->(dbSeek(FWxFilial("SCK") + SCJ->CJ_NUM))  //CK_FILIAL, CK_NUM, CK_ITEM, CK_PRODUTO
    
    oReport:SetMeter(SCK->(LastRec()))

    While SCK->(!Eof()) .And. SCK->CK_FILIAL == FWxFilial("SCK") .And. SCK->CK_NUM == SCJ->CJ_NUM
        
        oReport:IncMeter() 

        If oReport:Cancel()
            Exit
        EndIf

        SCK->(dbSkip())
    Enddo

    RestArea(aArea)

Return