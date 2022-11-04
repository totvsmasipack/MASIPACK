/*/{Protheus.doc} NSB1GEN
Ponto de entrada para mudar a forma de gerar os produtos genericos do NfSync
@author DS2U (SDA)
@since 16/07/2019
@version 1.0
@return aProdutos, Array de produtos, cada elemento tem outro array no formato a ser utilizado em execauto de produtos

@type function
/*/
User Function NSB1GEN()

Local oNfSync := PARAMIXB[1]
Local nLin    := PARAMIXB[2]
Local clProdFor := oNfSync:getFromXML( "D1_PRODFOR", nLin )
Local cDescProd := oNfSync:getFromXML( "D1_DESCFOR", nLin )
Local cUM       := oNfSync:getFromXML( "D1_UMXML", nLin )
Local cNCM      := oNfSync:getFromXML( "D1_NCM", nLin )
Local aPerIPI   := {}
Local aProduto  := {}

dbSelectArea("SYD")
aPerIPI := getAdvFVal("SYD",{"YD_PER_IPI","YD_ICMS_RE","YD_BICMS"}, FWxFilial("SYD")+cNCM,1,{0,0," "})

AADD( aProduto, { "B1_COD"    , "XM" + subs(ZN0->ZN0_FORNEC,3,4) + PADL( RIGHT( alltrim( clProdFor),9),9,"0"), nil } )
AADD( aProduto, { "B1_DESC"   , subs( cDescProd, 1, tamSX3("B1_DESC")[1] ), nil } )
AADD( aProduto, { "B1_TIPO"   , getMv( "ES_TPRDGEN",,"MC" ), nil } )
AADD( aProduto, { "B1_UM"     , iif( Alltrim(cUM) == "MI", "MH", cUM ), nil } )
AADD( aProduto, { "B1_CC"     , getMv( "ES_CCPRDGE",,"101" ), nil } )
AADD( aProduto, { "B1_POSIPI" , cNCM, nil } )
AADD( aProduto, { "B1_FILIAL" , FWxFilial("SB1"), nil } )
AADD( aProduto, { "B1_PROCED" , getMv( "ES_PROPRDG",,"2N" ), nil } )
AADD( aProduto, { "B1_ORIGEM" , getMv( "ES_ORIPRDG",,"0" ), nil } )
AADD( aProduto, { "B1_IPI"    , aPerIPI[1], nil } )
AADD( aProduto, { "B1_PICM"   , aPerIPI[2], nil } )
AADD( aProduto, { "B1_MSCONF" , getMv( "ES_MCPRDGE",,"N" ), nil } )
AADD( aProduto, { "B1_GARANT" , getMv( "ES_GARPRDG",,"2" ), nil } )
AADD( aProduto, { "B1_MSGRVEN", getMv( "ES_MGRPRDG",,"IN" ), nil } )

If aPerIPI[3] == "S"
    If aPerIPI[2] < 18
        AADD( aProduto, { "B1_GRTRIB", getMv( "ES_GTPME18",,"001" ), nil } )
    Else
        AADD( aProduto, { "B1_GRTRIB", getMv( "ES_GTPMA18",,"002" ), nil } )
    EndIf					
EndIf

// PARAMETRO DA EMPRESA 01 DEVE SER 10
// PARAMETRO DA EMPRESA DIFERENTE DE 01 DEVE SER 01
AADD( aProduto, { "B1_LOCPAD", getMv( "ES_LCPRDGE",,"10" ), nil } )

Return aProduto
