#include "totvs.ch"
#include "parmtype.ch"


User Function NFSER01()

Local cPerg     := "NFSYR01"
Local oReport

Private cAliasOP  := GetNextAlias()

    Pergunte(cPerg,.F.)
    oReport := ReportDef()
    oReport:PrintDialog()

Return

//******************************************************************|
//* Definição do Relatório                                          |
//******************************************************************|
Static Function ReportDef()

Local cDesc     := "Este relatório imprimirá os pedidos de compras encontrados no XML."
Local cTitulo   := "Relação dos pedidos de compras"
Local oReport 
Local oSection1, oCabec

    oReport := TReport():New("NFSER01",cTitulo,"NFSYR01",{|oReport| PrintReport(oReport)},cDesc)

    oSection1 := TRSection():New(oReport,"PEDIDO",{"SC7","SB1"})
    oSection1:SetHeaderPage()

    TRCell():New(oSection1,"C7_ITEM","SC7","Item",PesqPict("SC7","C7_ITEM"),TamSX3("C7_ITEM")[1],,{ || SC7->C7_ITEM })
    TRCell():New(oSection1,"C7_PRODUTO","SC7","Produto",PesqPict("SC7","C7_PRODUTO"),TamSX3("C7_PRODUTO")[1],,{ || SC7->C7_PRODUTO })
    TRCell():New(oSection1,"B1_DESC","SB1","Descrição",PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],,{ || SB1->B1_DESC })
    TRCell():New(oSection1,"C7_UM","SC7","Unid ",PesqPict("SC7","C7_UM"),TamSX3("C7_UM")[1],,{ || SC7->C7_UM })
    TRCell():New(oSection1,"C7_LOCAL","SC7","Local ",PesqPict("SC7","C7_LOCAL"),TamSX3("C7_LOCAL")[1],,{ || SC7->C7_LOCAL })
    TRCell():New(oSection1,"C7_QUANT","SC7","Qtde ",PesqPict("SC7","C7_QUANT"),TamSX3("C7_QUANT")[1],,{ || SC7->C7_QUANT })
    TRCell():New(oSection1,"C7_PRECO","SC7","Vl Unit. ",PesqPict("SC7","C7_PRECO"),TamSX3("C7_PRECO")[1],,{ || SC7->C7_PRECO })
    TRCell():New(oSection1,"C7_TOTAL","SC7","Vl Total ",PesqPict("SC7","C7_TOTAL"),TamSX3("C7_TOTAL")[1]+3,,{ || SC7->C7_TOTAL })
    TRCell():New(oSection1,"C7_DATPRF","SC7","Dt Entr ",PesqPict("SC7","C7_DATPRF"),TamSX3("C7_DATPRF")[1]+3,,{ || SC7->C7_DATPRF })
    
 //   TRFunction():New(oSection1:Cell("C7_TOTAL"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)

    oCabec := TRSection():New(oSection1,"CABEC",{"SC7","SA2"})
    oCabec:SetHeaderSection(.T.)
    TRCell():New(oCabec,"C7_NUM","SC7","Pedido",PesqPict("SC7","C7_NUM"),TamSX3("C7_NUM")[1]+5,,{ || SC7->C7_NUM })
    TRCell():New(oCabec,"C7_EMISSAO","SC7","Emissão",PesqPict("SC7","C7_EMISSAO"),TamSX3("C7_EMISSAO")[1]+3,,{ || SC7->C7_EMISSAO })
    TRCell():New(oCabec,"C7_FORNECE","SC7","Fornecedor",PesqPict("SC7","C7_FORNECE"),TamSX3("C7_FORNECE")[1],,{ || SC7->C7_FORNECE })
    TRCell():New(oCabec,"C7_LOJA","SC7","Loja",PesqPict("SC7","C7_LOJA"),TamSX3("C7_LOJA")[1]+3,,{ || SC7->C7_LOJA })
    TRCell():New(oCabec,"A2_NOME","SC7","Razão Social",PesqPict("SA2","A2_NOME"),TamSX3("A2_NOME")[1],,{ || Alltrim(SA2->A2_NOME) })
    
Return oReport


Static Function PrintReport(oReport)

Local aItXml        := {}
Local aItPedXml     := {}
Local aItPedido     := {}
Local cPedido       := ""
Local cTypeXml      := ""
Local cXmlFull      := ""
Local nPos          := 0
Local oNfSync, oXml
Local oSection1     := oReport:Section(1)
Local oCabec        := oReport:Section(1):Section(1)

    dbSelectArea("ZN0")
    ZN0->(dbSetOrder(1))
    ZN0->(dbSeek(xFilial("ZN0") + PADR( MV_PAR01, tamSX3("ZN0_DOC")[1] ) + PADR( MV_PAR02, tamSX3("ZN0_SERIE")[1] ) + PADR( MV_PAR03, tamSX3("ZN0_FORNEC")[1] ) + PADR( MV_PAR04, tamSX3("ZN0_LOJA")[1] ) ))
    
    While !ZN0->(EOF()) .And.  ZN0->ZN0_DOC == PADR( MV_PAR01, tamSX3("ZN0_DOC")[1] ) .And. ZN0->ZN0_SERIE == PADR( MV_PAR02, tamSX3("ZN0_SERIE")[1] ) .And. ZN0->ZN0_FORNEC == PADR( MV_PAR03, tamSX3("ZN0_FORNEC")[1] ) .And. ZN0->ZN0_LOJA == PADR( MV_PAR04, tamSX3("ZN0_LOJA")[1] )
        
        oNfSync := NfeSync():New()
	    
        cXmlFull := oNfSync:unGzip( ZN0->ZN0_NFXML ) 

        If !Empty(cXmlFull)
            cTypeXml	:= oNfSync:getXmlType( cXmlFull )
            oXml		:= oNfSync:cleanXml( cXmlFull )
            aItXml  	:= oNfSync:getXMLInfo( cTypeXml, oXml,, "SD1" )
        Else
            Help("XMLNOTEXIST", NIL, "XML Inexistente", NIL, "A Nota Fiscal informada não possui o XML importado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique com a área de recebimento a ausência do XML."})
            Return
        Endif

        For nPos := 1 To Len(aItXml)

            aItPedXml	:= oNfSync:getXMLInfo( cTypeXml, oXml, aItXml[nPos], "SD1", "D1_PEDIDO" )

            If ValType(aItPedXml) == "A"
                SC7->(dbSetOrder(1))
                If SC7->(dbSeek(xFilial("SC7") + aItPedXml[1] + aItPedXml[2]))
                    AADD(aItPedido,{SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->(RECNO())})
                Endif
            Endif
			
        Next nPos

        If Len(aItPedido) > 0
            
            aSort(aItPedido,,,{ |x,y| x[1] + x[2] < y[1] + y[2] })

            oReport:SetMeter(Len(aItPedido))

            nPos := 1
            While nPos <= Len(aItPedido) .And. !oReport:Cancel()

                If oReport:Cancel()
                    Exit
                Endif

                SC7->(dbGoTo(aItPedido[nPos,5]))

                If cPedido <> aItPedido[nPos,1]
                    SA2->(dbSetOrder(1))
                    SA2->(dbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))

                    oReport:SkipLine()
                    oCabec:Init(.F.)
                    oCabec:PrintLine()
                    oCabec:Finish()
                    oReport:ThinLine()

                    cPedido := aItPedido[nPos,1]
                Endif

                oSection1:Init()
                oSection1:PrintLine()
                oSection1:Finish()

                oReport:IncMeter()

                nPos++
            
            Enddo

        Endif

        ZN0->(dbSkip())
    Enddo
    
Return