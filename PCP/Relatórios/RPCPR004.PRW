#include "totvs.ch"
#include "protheus.ch"
#include "matr225.ch"

STATIC lPCPREVATU	:= FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)

/*/{Protheus.doc} User Function RPCPR004
Relatório de estruturas simples de produtos
@type  User Function
@author Masipack
@since 03/12/2019
/*/
User Function RPCPR004()

Local oReport

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*/{Protheus.doc} Static Function ReportDef
Definição do relatório
@type  User Function
@author Masipack
@since 03/12/2019
/*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2

    oReport:= TReport():New("RPCPR004",OemToAnsi(STR0001),"MTR225", {|oReport| ReportPrint(oReport)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004))  //"Este programa emite a relacao de estrutura de um determinado produto"##"selecionado pelo usuario. Esta relacao nao demonstra custos. Caso o"##"produto use opcionais, sera listada a estrutura com os opcionais padrao."
    oReport:SetLandscape()

    Pergunte(oReport:uParam,.F.)

    oSection1 := TRSection():New(oReport,STR0036,{"SG1","SB1"}) //"Detalhes do produto Pai"
    oSection1:SetLineStyle()

    TRCell():New(oSection1,'G1_COD'	    ,'SG1',/*Titulo*/,/*Picture*/,TamSX3('B1_COD')[1] + 1,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection1,'B1_DESC'   	,'SB1',/*Titulo*/,/*Picture*/,TamSX3('B1_DESC')[1] + 1,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection1,'B1_TIPO'   	,'SB1',/*Titulo*/,/*Picture*/,TamSX3('B1_TIPO')[1] + 1,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection1,'B1_GRUPO'  	,'SB1',/*Titulo*/,/*Picture*/,TamSX3('B1_GRUPO')[1] + 1,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection1,'B1_UM'	    ,'SB1',/*Titulo*/,/*Picture*/,TamSX3('B1_UM')[1] + 1,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection1,'B1_QB'		,'SB1',/*Titulo*/,/*Picture*/,TamSX3('B1_QB')[1] + 1,/*lPixel*/, {|| IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
    TRCell():New(oSection1,'B1_OPC'		,'SB1',/*Titulo*/,/*Picture*/,TamSX3('B1_OPC')[1] + 1,/*lPixel*/, {|| RetFldProd(SB1->B1_COD,"B1_OPC")})

    oSection1:SetNoFilter("SB1")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Sessao 2                                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oSection2 := TRSection():New(oSection1,STR0037,{'SG1','SB1'}) // "Estruturas"

    TRCell():New(oSection2,'NIVEL'		,'   ',STR0019	    ,/*Picture*/					,10			,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection2,'G1_COMP'	,'SG1',STR0020	    ,/*Picture*/					,TamSX3('B1_COD')[1] + 1,/*lPixel*/,/*{|| code-block de impressao }*/) //B1_COD deve ter o mesmo tamanho que G1_COMP, por isso usei a variável que já tinha a informação na memória, sem realizar a busca novamente na tabela 
    TRCell():New(oSection2,'G1_TRT'	    ,'SG1',STR0021	    ,/*Picture*/					,TamSX3('B1_COD')[1] + 1,/*lPixel*/,/*{|| code-block de impressao }*/) //B1_COD deve ter o mesmo tamanho que G1_COMP, por isso usei a variável que já tinha a informação na memória, sem realizar a busca novamente na tabela 
    TRCell():New(oSection2,'B1_REVATU'	,'SB1',"Rev. Atual"	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection2,'QUANTITEM'	,'   ',STR0026	    ,PesqPict('SG1','G1_QUANT',14)	,14	   		,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection2,'B1_TIPO'	,'SB1',STR0022	    ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection2,'B1_UM'		,'SB1',STR0027	    ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//  TRCell():New(oSection2,'B1_GRUPO'	,'SB1',STR0023  	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oSection2,'B5_CEME'	,'SB5',STR0024	    ,"@!"					        ,100,/*lPixel*/,{|| POSICIONE("SB5",1,xFilial("SB5")+SG1->G1_COMP,"B5_CEME") }, ,.T.  )
    TRCell():New(oSection2,'G1_OBSERV'	,'SG1',STR0025	    ,/*Picture*/					,50,/*lPixel*/,/*{|| code-block de impressao }*/, ,.T.)

//    TRCell():New(oSection2,'G1_PERDA'	,'SG1',STR0028	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//    TRCell():New(oSection2,'G1_QUANT'	,'SG1',STR0029	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//    TRCell():New(oSection2,'B1_QB'		,'SB1',STR0030	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,{||If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))})
//    TRCell():New(oSection2,'G1_FIXVAR'	,'SG1',STR0031	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//    TRCell():New(oSection2,'G1_INI'		,'SG1',STR0032	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//    TRCell():New(oSection2,'G1_FIM'		,'SG1',STR0033	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//    TRCell():New(oSection2,'G1_GROPC'	,'SG1',STR0034	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//    TRCell():New(oSection2,'G1_OPC'		,'SG1',STR0035	,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

    oSection2:SetHeaderPage()
    oSection2:SetNoFilter("SB1")

Return oReport


/*/{Protheus.doc} Static Function ReportPrint
Definição do relatório
@type  User Function
@author Masipack
@since 03/12/2019
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cProduto 	:= ""
Local nNivel   	:= 0
Local lContinua := .T.
Local lDatRef   := !Empty(mv_par10)

Private lNegEstr:=GETMV("MV_NEGESTR")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³	Processando a Sessao 1                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea('SG1')
    SG1->(dbSetOrder(6))
    MsSeek(xFilial('SG1')+mv_par01,.T.)
    oReport:SetMeter(SG1->(LastRec()))
    oSection1:Init(.F.)

    While !oReport:Cancel() .And. !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD <= xFilial('SG1')+mv_par02

        oReport:IncMeter()

        If lDatRef .And. (SG1->G1_INI > mv_par10 .Or. SG1->G1_FIM < mv_par10)
            SG1->(dbSkip())
            Loop
        EndIf

        cProduto := SG1->G1_COD
        nNivel   := 2
        lContinua:=.T.
        
        dbSelectArea('SB1')
        MsSeek(xFilial('SB1')+cProduto)
            
        If Eof() .Or. SB1->B1_TIPO < mv_par03 .Or. SB1->B1_TIPO > mv_par04 .Or. SB1->B1_GRUPO < mv_par05 .Or. SB1->B1_GRUPO > mv_par06
            dbSelectArea('SG1')
            While !oReport:Cancel() .And. !Eof() .And. xFilial('SG1')+cProduto == SG1->G1_FILIAL+SG1->G1_COD
                dbSkip()
                oReport:IncMeter()
            EndDo
            lContinua := .F.
        EndIf

        If lContinua	
            
            oSection1:Init(.F.)
            oReport:SkipLine()     

            //--  Imprime grupo de opcionais.
            If !Empty(RetFldProd(SB1->B1_COD,"B1_OPC"))
                oSection1:Cell('B1_OPC'):Show()
            Else
                oSection1:Cell('B1_OPC'):Hide()
            EndIf                

            oSection1:PrintLine()
            oReport:SkipLine()     
            oSection1:Finish()

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³	Impressao da Sessao 2                                        ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            oSection2:Init()
            
            //-- Explode Estrutura
            MR225ExplG(oReport,oSection2,cProduto,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),nNivel,RetFldProd(SB1->B1_COD,"B1_OPC"),IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB"))	,IIf(Empty(mv_par08),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU ),mv_par08))

            oSection2:Finish()
            
            //-- Verifica se salta ou nao pagina
            If mv_par07 == 1
                oSection1:SetPageBreak(.T.)
            Else    
                oReport:ThinLine() //-- Impressao de Linha Simples
            EndIf	 
        
        EndIf

    EndDo

Return

/*/{Protheus.doc} Static Function MR225ExplG
Definição do relatório
@type  User Function
@author Masipack
@since 03/12/2019
/*/
Static Function MR225ExplG(oReport,oSection2,cProduto,nQuantPai,nNivel,cOpcionais,nQtdBase,cRevisao)
Local nReg 		  := 0
Local nQuantItem  := 0
Local nPrintNivel := 0
Local cAteNiv     := If(mv_par09=Space(3),"999",mv_par09)
Local cRevEst	  := ''
Local lDatRef     := !Empty(mv_par10)

    dbSelectArea('SG1')
    While !oReport:Cancel() .And. !Eof() .And. G1_FILIAL+G1_COD == xFilial('SG1')+cProduto
        oSection2:IncMeter()
        nReg       := Recno()
        nQuantItem := ExplEstr(nQuantPai,Iif(lDatRef,mv_par10,Nil),cOpcionais,cRevisao)
        dbSelectArea('SG1')
        If nNivel <= Val(cAteNiv) // Verifica ate qual Nivel devera ser impresso
            If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
            
                dbSelectArea('SB1')
                SB1->(dbSetOrder(1))
                SB1->(MsSeek(xFilial('SB1')+SG1->G1_COMP))
            
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Impressao da Sessao 2			                ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                nPrintNivel:=IIf(nNivel>17,17,nNivel-2)
                oSection2:Cell('NIVEL'		):SetValue(Space(nPrintNivel)+StrZero(nNivel,3))
                oSection2:Cell('QUANTITEM'	):SetValue(nQuantItem)
                oSection2:PrintLine()
            
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Verifica se existe sub-estrutura                ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                dbSelectArea('SG1')
                MsSeek(xFilial('SG1')+G1_COMP)
                cRevEst := IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )
                If Found()
                    MR225ExplG(oReport,oSection2,G1_COD,nQuantItem,nNivel+1,cOpcionais,IIf(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),If(!Empty(cRevEst),cRevEst,mv_par08))
                EndIf

                dbGoto(nReg)

            EndIf
        EndIf
        dbSkip()
    EndDo

Return