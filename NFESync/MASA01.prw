#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} MASA01
Programa para geração de produtos genéricos conforme o XML da NF posicionada no NfSync
@author DS2U (SDA)
@since 15/07/2019
@version 1.0

@type function
/*/
User Function MASA01( nOpc )

Local uRet
Default nOpc := 0

Do Case

	case nOpc == 1
		
		if ( msgYesNo( "Deseja vincular produtos genéricos CONSIDERANDO pedido de compras ?" ) )
			fwMsgRun(,	{|oSay| vinPrPC() }, "Aguarde...","Vinculando produto genérico e pedido de compras aos itens do XML..." )
		endif

	case nOpc == 2

		if ( msgYesNo( "Deseja vincular produtos para TESTE ?" ) )
			fwMsgRun(,	{|oSay| vinPrTst() }, "Aguarde...","Vinculando produto TESTE aos itens do XML..." )
		endif

	case nOpc == 3

		if ( msgYesNo( "Deseja vincular produtos para DEMONSTRAÇÃO ?" ) )
			fwMsgRun(,	{|oSay| vinPrDemo() }, "Aguarde...","Vinculando produto de DEMONSTRAÇÃO aos itens do XML..." )
		endif

EndCase

Return uRet

/*/{Protheus.doc} vinPrTst
Vincular produtos para teste
@type  Static Function
@author DS2U (SDA)
@since 02/10/2019
@version 1.0
/*/
Static Function vinPrTst()
Return viPrdOnXml( .F., .T. )

/*/{Protheus.doc} vinPrDemo
Vincular produtos para demonstração
@type  Static Function
@author DS2U (SDA)
@since 02/10/2019
@version 1.0
/*/
Static Function vinPrDemo()
Return viPrdOnXml( .F., .F., .T. )


/*/{Protheus.doc} vinPrPC
Vincular Produtos genéricos com pedido de compras
@type  Static FunctionS
@author  DS2U (SDA)
@since   17/07/2019
@version 1.0
/*/
Static Function vinPrPC()
Return viPrdOnXml( .T. )

/*/{Protheus.doc} viPrdOnXml
Vincular Produtos ao XML
@type  Static Function
@author  DS2U (SDA)
@since   17/07/2019
@version 1.0
@param lPedCom, logico, identifica se deve consultar pedidos de compras envolvidos
@param lPrdTest, logico, identifica se deve gerar produtos para teste
@param lPrdDemo, logico, identifica se deve gerar produtos para demonstracao
/*/
Static Function viPrdOnXml( lPedCom, lPrdTest, lPrdDemo )

Local aProdutos := {}
Local nlx
Local lContinue := .T.
Local cMsg      := ""
Local cKeyZN1   := ""
Local nPosPrd   := 0
Local nPosItem  := 0
Local oNfSync   := NfeSync():New( ZN0->ZN0_NFXML )
Local cPedCom   := ""
Local cProduto  := ""
Local aRet      := {}
Local aData     := {}
Local lComPC    := .F.
Local cErro     := ""

Default lPedCom  := .F.
Default lPrdTest := .F.
Default lPrdDemo := .F.

//---------------------------------------------------------
// Identifica em qual pedido sera alterado as informações -
//---------------------------------------------------------
if ( lPedCom )
	
	cPedCom := getPedCom( ZN0->ZN0_FORNEC, ZN0->ZN0_LOJA )
	
	if ( !empty( cPedCom ) )
		// Valida se o total do XML bate com o total do item de mercadoria do pedido de compras
		lComPC := isCanEdtPC( cPedCom, oNfSync:getFromXML( "F1_VALMERC" ), @cMsg )
	endif

endif

if ( !lPedCom .or. lComPC )

	aProdutos := getPrOnXml( lComPC, lPrdTest, lPrdDemo ) // Identificar produtos do XML

	if ( len( aProdutos ) > 0 )

		dbSelectArea( "ZN1" )
		ZN1->( dbSetOrder( 1 ) )
		
		//-------------------------------------------------------
		// Gerar produtos genericos conforme informações do XML -
		//-------------------------------------------------------
		for nlx := 1 to Len( aProdutos )
		
			nPosPrd  := aScan( aProdutos[nlx], {|x| allTrim( x[1] ) == "B1_COD" } )
			nPosItem := aScan( aProdutos[nlx], {|x| allTrim( x[1] ) == "D1_ITEMFOR" } )					
			
			cProduto := aProdutos[nlx][nPosPrd][2]
			
			aRet := createProd( aProdutos[nlx] )
			lContinue := aRet[1]
			
			if ( lContinue )
				cMsg := aRet[2]
			else			
				cMsg += "Não foi possível criar produto " + cProduto + " >>" + CRLF + CRLF + aRet[2] + CRLF
			endif

			//-------------------------------------------------
			// Vincula os produtos genericos aos itens do XML -
			//-------------------------------------------------
			if ( lContinue )
			
				if ( nPosPrd > 0 )
			
					// Monta chave para atualização do item da ZN1
					// ZN1_FILIAL, ZN1_DOC, ZN1_SERIE, ZN1_FORNEC, ZN1_LOJA, ZN1_TIPO, ZN1_ITEM, R_E_C_N_O_, D_E_L_E_T_
					cKeyZN1 := ZN0->ZN0_FILIAL + ZN0->ZN0_DOC + ZN0->ZN0_SERIE + ZN0->ZN0_FORNEC + ZN0->ZN0_LOJA + ZN0->ZN0_TIPO + PADR( aProdutos[nlx][nPosItem][2], tamSX3( "ZN1_ITEM" )[1] )

					if ( ZN1->( dbSeek( cKeyZN1 ) ) )

						AADD( aData, { "ZN1_COD", cProduto } )
						
						if ( lPedCom .and. lComPC )
							
							aRet := getPrxItPC( cPedCom, cProduto, ZN1->ZN1_QUANT, ZN1->ZN1_VUNIT, ZN1->ZN1_TOTAL, @cErro  )

							if ( len( aRet ) > 0 )

								AADD( aData, { "ZN1_PEDIDO", cPedCom } )
								AADD( aData, { "ZN1_ITEMPC", aRet[1] } )  
								AADD( aData, { "QATEND", aRet[2] } )
								AADD( aData, { "ZN1_VALPC", aRet[3] } )

							else
							
								lContinue := .F.
								cMsg += "Não foi possível realizar a alteração do pedido de compra " + cPedCom + " >> Produto Generico >> " + cProduto + CRLF + CRLF + cErro + CRLF

							endif

						endif

						if ( lContinue )

							cMsg := ""					
							aRet := oNfSync:vincDataOnZN1( aData, cKeyZN1, nlx )
							lContinue := aRet[1]
							cMsg      := aRet[2]

						else
							cMsg += "Não foi possível realizar o vínculo do produto [" + aProdutos[nlx][nPosPrd][2] + "]" + CRLF
						endif

					endif
				
				endif

			endif
				
			if !( lContinue )
				Exit
			endif
			
		next nlx

	endif

else
	lContinue := .F.
endif

if ( !lContinue .and. !empty( cMsg ) )
	oNfSync:addOcorrencia( cMsg )
endif

FreeObj( oNfSync )

Return

/*/{Protheus.doc} getPedCom
Funcao para buscar pedido de compras por fornecedor. Se encontrar mais de 1, mostra interface para seleção
@type  Static Function
@author DS2U (SDA)
@since 20/07/2019
@version 1.0
@param cFornec, caracter, codigo do fornecedor
@param cLoja, caracter, codigo da loja do fornecedor
@return cPedido, caracter, Codigo do pedido de compra
/*/
Static Function getPedCom( cFornec, cLoja )

Local cPedido  := ""
Local aPedidos := {}
Local cAlias   := getNextAlias()

BEGINSQL ALIAS cAlias

	SELECT 
		C7_EMISSAO EMISSAO
		, C7_NUM PEDIDO
		, C7_FORNECE COD_FORNEC	
		, C7_LOJA LOJA
		, A2_NOME NOME	
		, MAX( C7_DATPRF ) ENTREGA
		, COUNT(*) QTD_IT
		, A2_CGC CNPJ

	FROM 
		%TABLE:SC7% SC7

	INNER JOIN 
		%TABLE:SA2% SA2 ON
		A2_FILIAL = %XFILIAL:SA2%
		AND A2_COD = C7_FORNECE
		AND A2_LOJA = C7_LOJA
		AND SA2.%NOTDEL%

	WHERE 
		C7_FILIAL = %XFILIAL:SC7%
		AND C7_FORNECE = %EXP:cFornec%
		AND C7_LOJA = %EXP:cLoja%	
		AND ( C7_QUANT-C7_QUJE-C7_QTDACLA > 0 )
		AND C7_RESIDUO <> 'S'
		AND SC7.%NOTDEL%

	GROUP BY 
		C7_EMISSAO
		, C7_NUM
		, C7_FORNECE
		, C7_LOJA
		, A2_NOME
		, A2_CGC

	ORDER BY 
		C7_EMISSAO DESC

ENDSQL

while ( !( cAlias )->( eof() ) )

	AADD( aPedidos, {; 
		dToC( sToD( ( cAlias )->EMISSAO ) ),;
		( cAlias )->PEDIDO,;
		( cAlias )->COD_FORNEC,;
		( cAlias )->LOJA,;
		( cAlias )->NOME,;
		( cAlias )->ENTREGA,;
		( cAlias )->QTD_IT,;
		( cAlias )->CNPJ;
	})

	( cAlias )->( dbSkip() )
endDo
( cAlias )->( dbCloseArea() )

if ( len( aPedidos ) > 0 )

	//-----------------------------------------------------------------------------
	// Se houver mais de um pedido de compra, entao mostra interface para selecao -
	//-----------------------------------------------------------------------------
	if ( len( aPedidos ) > 1 )
		cPedido := setPedCom( aPedidos )
	else
		cPedido := aPedidos[1][2]
	endif

endif

Return cPedido

/*/{Protheus.doc} getPrOnXml
Funcao para identificar produtos conforme o XML posicionado
@author DS2U (SDA)
@since 16/07/2019
@version 1.0
@return aProdutos, Array de produtos, cada elemento tem outro array no formato a ser utilizado em execauto de produtos
@param lGeneric, logico, identifica deve gerar produtos para genéricos
@param lTest, logico, identifica se deve gerar produtos para teste
@param lDemonst, logico, identifica se deve gerar produtos para demonstracao
@param lProvi, logico, identifica se deve gerar produtos para provisao
@type function
/*/
Static Function getPrOnXml( lGeneric, lTest, lDemonst, lProvi )

Local aArea     := getArea()
Local oNfSync   := NfeSync():New( ZN0->ZN0_NFXML )
Local alItensXml:= oNfSync:getItensXML()
Local clProd    := ""
Local clProdFor := ""
Local cNCM      := ""
Local aProduto  := {}
Local aProdutos := {}
Local aPerIPI   := {}
Local cDescProd := ""
Local cUM       := ""
Local clCodPrd  := ""
Local nlx
Local nTamSufix := tamSX3( "B1_COD" )[1]
Local cPrefix
Local nSeqAtu

Default lGeneric := .F.
Default lTest    := .F.
Default lDemonst := .F.
Default lProvi   := .F.

for nlx := 1 to len( alItensXml )

	clCodPrd  := oNfSync:getFromXML( "D1_COD", nlx )

	// Somente cria produto generico se nao encontrar produto x fornecedor vinculado
	if ( empty( clCodPrd ) )

		if ( lGeneric )
			
			clProd := "XM" + subs(ZN0->ZN0_FORNEC,3,4) + PADL( RIGHT( alltrim( clProdFor),9),9,"0")
			
		elseif ( lTest )
						
			clProd := codPrdTst( clProd )
						
		elseif ( lDemonst )
			
			clProd := codPrdDemo( clProd )
				

		elseif ( lProvi )
			//TODO ANALISAR REGRA DE NEGOCIO			
		endif
		
	else
		clProd := clCodPrd
	endif

	if ( lGeneric )
		
		AADD( aProduto, { "B1_TIPO"   , getMv( "ES_TPRDGEN",,"MC" ), nil } )
		AADD( aProduto, { "B1_CC"     , getMv( "ES_CCPRDGE",,"101" ), nil } )

	elseif ( lTest )
				
		AADD( aProduto, { "B1_TIPO"   , getMv( "ES_TPRDTST",,"OI" ), nil } )
		AADD( aProduto, { "B1_CC"     , getMv( "ES_CCPRDTS",,"207" ), nil } )

	elseif ( lDemonst )
				
		AADD( aProduto, { "B1_TIPO"   , getMv( "ES_TPRDEMO",,"OI" ), nil } )
		AADD( aProduto, { "B1_CC"     , getMv( "ES_CCPRDDM",,"207" ), nil } )

	elseif ( lProvi )
		
		AADD( aProduto, { "B1_TIPO"   , getMv( "ES_TPRPROV",,"OI" ), nil } )
		AADD( aProduto, { "B1_CC"     , getMv( "ES_CCPRDPV",,"207" ), nil } )

	endif

	clProdFor := oNfSync:getFromXML( "D1_PRODFOR", nlx )
	cDescProd := oNfSync:getFromXML( "D1_DESCFOR", nlx )
	cItemFor  := oNfSync:getFromXML( "D1_ITEMFOR", nlx )
	cUM       := oNfSync:getFromXML( "D1_UMXML", nlx )
	cNCM      := oNfSync:getFromXML( "D1_NCM", nlx )
		
	dbSelectArea("SYD")
	aPerIPI := getAdvFVal("SYD",{"YD_PER_IPI","YD_ICMS_RE","YD_BICMS"}, FWxFilial("SYD")+cNCM,1,{0,0," "})
	
	AADD( aProduto, { "B1_COD"    , clProd, nil } )
	AADD( aProduto, { "B1_POSIPI" , cNCM, nil } )
	AADD( aProduto, { "B1_DESC"   , subs( cDescProd, 1, tamSX3("B1_DESC")[1] ), nil } )	
	AADD( aProduto, { "B1_UM"     , iif( cUM $ "MI|MLH", "MH", cUM ), nil } )	
	AADD( aProduto, { "B1_FILIAL" , FWxFilial("SB1"), nil } )
	AADD( aProduto, { "B1_PROCED" , getMv( "ES_PROPRDG",,"2N" ), nil } )
	AADD( aProduto, { "B1_ORIGEM" , getMv( "ES_ORIPRDG",,"0" ), nil } )
	AADD( aProduto, { "B1_IPI"    , aPerIPI[1], nil } )
	AADD( aProduto, { "B1_PICM"   , aPerIPI[2], nil } )
	AADD( aProduto, { "B1_MSCONF" , getMv( "ES_MCPRDGE",,"N" ), nil } )
	AADD( aProduto, { "B1_MSATOX" , getMv( "ES_MAPRDGE",,"N" ), nil } )
	AADD( aProduto, { "B1_GARANT" , getMv( "ES_GARPRDG",,"2" ), nil } )
	AADD( aProduto, { "B1_MSGRVEN", getMv( "ES_MGRPRDG",,"IN" ), nil } )
	AADD( aProduto, { "B1_LOCALIZ", "N", nil } )
	
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
	
	aProduto := fwVetByDic( aProduto, "SB1")
	
	AADD( aProduto, { "D1_ITEMFOR", cItemFor, nil } )
	
	AADD( aProdutos, aProduto )
	aProduto := {}
	
next nlx

FreeObj( oNfSync )

restArea( aArea )

Return aProdutos

/*/{Protheus.doc} codPrdDemo
Funcao para capturar o código de produto para demonstração
@type  Static Function
@author DS2U (SDA)
@since 02/10/2019
@version 1.0
@param clCodAnt, caracter, codigo anterior gerado
@return cCodPrd, caracter, Codigo do produto
/*/
Static Function codPrdDemo( cCodAnt )
Return identPrd( getMv( "ES_PFXPDEM",, "PDEM" ), cCodAnt )

/*/{Protheus.doc} codPrdTst
Funcao para capturar o código de produto para teste
@type  Static Function
@author DS2U (SDA)
@since 02/10/2019
@version 1.0
@param clCodAnt, caracter, codigo anterior gerado
@return cCodPrd, caracter, Codigo do produto
/*/
Static Function codPrdTst( cCodAnt )
Return identPrd( getMv( "ES_PFXPTST",, "PT8" ), cCodAnt )

/*/{Protheus.doc} identPrd
Funcao para capturar o código de produto conforme prefixo
@type  Static Function
@author DS2U (SDA)
@since 02/10/2019
@version 1.0
@param cPrefix, caracter, codigo do prefixo do produto a ser criado
@param clCodAnt, caracter, codigo anterior gerado
@return cCodPrd, caracter, Codigo do produto identificado
/*/
Static Function identPrd( cPrefix, cCodAnt )

Local cAlias    := ""
Local cCodPrd   := ""
Local nSeqAtu   := 1
Local nTamSufix := ( tamSX3( "B1_COD" )[1] - len( cPrefix ) )
Local cFiltro   := ""

if ( empty( cCodAnt ) )

	cAlias    := getNextAlias()
	cFiltro   := "% SUBSTRING(B1_COD,1," + allTrim( cValToChar(  len( cPrefix ) ) ) + ") = '" + cPrefix + "' %"

	BEGINSQL ALIAS cAlias

		SELECT
			TOP 1
			B1_COD AS CODIGO

		FROM 
			%TABLE:SB1% SB1
		
		WHERE 
			SB1.B1_FILIAL = %XFILIAL:SB1%
			AND %EXP:cFiltro%
			AND SB1.%NOTDEL%
		
		ORDER BY B1_COD DESC

	ENDSQL

	if ( !( cAlias )->( eof() ) )
		nSeqAtu := 	 val( subs( ( cAlias )->CODIGO, ( len( cPrefix ) + 1 ), nTamSufix ) ) + 1
	endif
	( cAlias )->( dbCloseArea() )

else	
	nSeqAtu   := val( subs( cCodAnt, ( len( cPrefix ) + 1 ), nTamSufix ) ) + 1	
endif

cCodPrd := cPrefix + strZero( nSeqAtu, nTamSufix )

Return cCodPrd

/*/{Protheus.doc} createProd
Funcao especifica para adicionar novo produto generico
@author DS2U (SDA)
@since 16/07/2019
@version 1.0
@return Array, onde: 
lRet, boolean, Se .T., adicionado com suceso. Se .F., foi gravado ocorrência no registro
cMsg, caracter, mensagem de erro caso aconteça
@param aProduto, array, description
@type function
/*/
Static Function createProd( aProduto )

Local oModel  := Nil
Local nlx
Local cMsg    := ""
Local cNotField := "D1_ITEMFOR"
Local nOperation
Local cProduto
Local nPosPrd
Local lRet := .T.

nPosPrd := aScan( aProduto, {|x| allTrim( x[1] ) == "B1_COD" } )
cProduto := aProduto[nPosPrd][2]

dbSelectArea( "SB1" )
SB1->( dbSetOrder( 1 ) )

// Se o produto não existir, então cria
if SB1->( dbSeek( FWxFilial( "SB1" ) + PADR( cProduto, tamSX3( "B1_COD" )[1] ) ) )
	nOperation := MODEL_OPERATION_UPDATE
else
	nOperation := MODEL_OPERATION_INSERT
endif
 
oModel  := FwLoadModel ("MATA010")	
oModel:SetOperation( nOperation )
oModel:Activate()

For nlx := 1 To Len( aProduto )

	if ( !( allTrim( aProduto[nlx][1] ) $ cNotField ) .and. !empty( tamSX3( aProduto[nlx][1] ) ) )

		if ( allTrim( aProduto[nlx][1] ) $ "B1_COD/B1_DESC/B1_PROCED/B1_POSIPI" )
			oModel:LoadValue("SB1MASTER", aProduto[nlx][1], aProduto[nlx][2] )
		else
			oModel:SetValue("SB1MASTER", aProduto[nlx][1], aProduto[nlx][2] )
		endif

	endif
	
Next nlx
 
If ( oModel:VldData() )
	oModel:CommitData()	
Else
	lRet := .F.
	aEval( oModel:getErrorMessage(), {|x| cMsg += iif( valType( x ) == "C", x + CRLF, "" ) } )
EndIf       
     
oModel:DeActivate()
oModel:Destroy()
 
oModel := NIL

Return { lRet, cMsg }

/*/{Protheus.doc} setPedCom
(long_description)
@type  Static Function
@author user
@since date
@version version
@param param, param_type, param_descr
@return return, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function setPedCom( aPedidos )

Local cPedido := ""
Local oDialog
Local oBrowse
Local oPanelBrw
Local oColumn
Local bBlockOk := {|| llConfirma := .T., cPedido := aPedidos[oBrowse:nAt][2],oDialog:End() }

DEFINE MSDIALOG oDialog TITLE "Selecione o Pedido de Compras" FROM 268,260 TO 642,1196 PIXEL
	
oPanelBrw:= tPanel():New(005,005,"",oDialog,,,,,,467, 150 )

DEFINE FWBROWSE oBrowse DATA ARRAY ARRAY aPedidos NO REPORT Of oPanelBrw

	ADD COLUMN oColumn DATA {|| aPedidos[oBrowse:nAt][1] }	Title "Emissão"		PICTURE PesqPict("SC7","C7_EMISSAO")	DOUBLECLICK bBlockOk 	SIZE 5 Of oBrowse
	
	ADD COLUMN oColumn DATA {|| aPedidos[oBrowse:nAt][2] }	Title "Pedido" 		PICTURE PesqPict("SC7","C7_NUM")	DOUBLECLICK bBlockOk 	SIZE 8 Of oBrowse
	
	ADD COLUMN oColumn DATA {|| aPedidos[oBrowse:nAt][5] }	Title "Fornecedor"	PICTURE PesqPict("SA2","A2_NOME")	DOUBLECLICK bBlockOk 	SIZE 20 Of oBrowse
	
	ADD COLUMN oColumn DATA {|| aPedidos[oBrowse:nAt][8] }	Title "CNPJ"		PICTURE PesqPict("SA2","A2_CGC")	DOUBLECLICK bBlockOk 	SIZE 10 Of oBrowse
	
	ADD COLUMN oColumn DATA {|| aPedidos[oBrowse:nAt][3] }	Title "Cod. Fornecedor"		PICTURE PesqPict("SA2","A2_COD")	DOUBLECLICK bBlockOk 	SIZE 8 Of oBrowse
	
	ADD COLUMN oColumn DATA {|| aPedidos[oBrowse:nAt][4] }	Title "Loja"		PICTURE PesqPict("SA2","A2_LOJA")	DOUBLECLICK bBlockOk 	SIZE 5 Of oBrowse
	
ACTIVATE FWBrowse oBrowse

DEFINE SBUTTON FROM 172,002 TYPE 2	ENABLE OF oDialog Action( llConfirma := .F., cPedido := "", oDialog:End() )

ACTIVATE MSDIALOG oDialog CENTERED

Return cPedido

/*/{Protheus.doc} getPrxItPC
Funcao para alterar o item geral e incluir os produtos genericos conforme forem criados
@type  Static Function
@author DS2U (SDA)
@since 21/07/2019
@version 1.0
@param cPedCom, caracter, pedido de compra	
@param cProduto, caracter, codigo do produto
@param nQtdXML, numeric, quantidade do item no XML
@param nVUnitXML, numeric, valor do item no XML
@param nTotalXML, numeric, total do item no XML
@param cErro, caracter, Erro retornado da execauto
/*/
Static Function getPrxItPC( cPedCom, cProduto, nQtdXML, nVUnitXML, nTotalXML, cErro )

Local nQtdPC  := 0
Local aCabec  := {}
Local aItens  := {}
Local aItem   := {}
Local cItemPC := ""
Local aRetSB1 := {}
Local aRet    := {}
Local cItem   := ""
Local nItem   := 0
Local nTipo   := 0
Local cUser   := ""

Private lMsErroAuto := .F.
Private lAutoErrNoFile	:= .T.

Default cErro   := ""

//---------------------------------------------------------------------
// Checa se existe produto Geral, para alteracao do pedido de compras -
//---------------------------------------------------------------------
cItemPC := getPrdGer( cPedCom )

dbSelectArea( "SC7" )
SC7->( dbSetOrder( 1 ) ) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN                                                                                                                              

if ( SC7->( dbSeek( fwxFilial( "SC7" ) + cPedCom + cItemPC ) ) )

	//---------------------------------------------
	// Cria cabeçalho para alteração via execauto -
	//---------------------------------------------
	AADD( aCabec, { "C7_NUM"     , SC7->C7_NUM } )
	AADD( aCabec, { "C7_EMISSAO" , SC7->C7_EMISSAO } )
	AADD( aCabec, { "C7_FORNECE" , SC7->C7_FORNECE } )
	AADD( aCabec, { "C7_LOJA"    , SC7->C7_LOJA } )
	AADD( aCabec, { "C7_COND"    , SC7->C7_COND } )
	AADD( aCabec, { "C7_CONTATO" , SC7->C7_CONTATO  } )
	AADD( aCabec, { "C7_FILENT"  , cFilAnt } )

	//------------------------------------------------------------------------------------------
	// Se nao tem item preenchido, então trata-se de uma inclusao de item no pedido de compras -
	//------------------------------------------------------------------------------------------
	if ( empty( cItemPC ) )

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Se nao foi encontrado item do PC para alteracao, entao identifica a proxima sequencia para inclusao de item no pedido de compras -
		//-----------------------------------------------------------------------------------------------------------------------------------
		while ( !SC7->( eof() ) )

			if ( SC7->C7_ITEM > nItem )
				nItem := val( SC7->C7_ITEM )
			endif

			SC7->( dbSkip() )
		endDo

		cItem := strZero( nItem++, tamSX3( "C7_ITEM" )[1] )
		nTipo := 1
		cUser := "XML"

	else
						
		cItem := SC7->C7_ITEM
		nTipo := SC7->C7_TIPO
		cUser := __CUSERID

	endif

	nQtdPC := nQtdXML

	dbSelectArea( "SB1" )
	aRetSB1 := getAdvFVal( "SB1", {"B1_UM", "B1_DESC"}, fwxFilial( "SB1" ) + cProduto, 1, {"",""} )		

	//---------------------------------------------------------------------------------------
	// Se tem item preenchido, então trata-se de uma alteração de item do pedido de compras -
	//---------------------------------------------------------------------------------------
	aItem := {}
	AADD( aItem, { "C7_ITEM"    , cItem, nil } )
	AADD( aItem, { "C7_PRODUTO" , cProduto, nil } )
	AADD( aItem, { "C7_UM"      , aRetSB1[1], nil } )
	AADD( aItem, { "C7_DESCRI"  , aRetSB1[2], nil } )
	AADD( aItem, { "C7_QUANT"   , nQtdPC, nil } )
	AADD( aItem, { "C7_PRECO"   , nVUnitXML, nil } )
	AADD( aItem, { "C7_TOTAL"   , nTotalXML, nil } )
	AADD( aItem, { "C7_TIPO"    , nTipo, nil } )
	AADD( aItem, { "C7_DATPRF"  , date(), nil } )
	AADD( aItem, { "C7_IPIBRUT" , "B", nil } )
	AADD( aItem, { "C7_FLUXO"   , "S", nil } )
	AADD( aItem, { "C7_USER"    , cUser, nil } )
	AADD( aItem, { "C7_TPOP"    , "F", nil } )
	AADD( aItem, { "C7_CONAPRO" , "L", nil } )
	AADD( aItem, { "C7_MOEDA"   , 1, nil } )
	AADD( aItem, { "C7_TPFRETE" , "C", nil } )
	AADD( aItem, { "C7_OBS"     , "INCLUIDO NF-ELETRONICA", nil } )
	AADD( aItem, { "C7_PENDEN"  , "N", nil } )
	AADD( aItem, { "C7_POLREPR" , "N", nil } )
	AADD( aItem, { "C7_LOCAL "  , "01", nil } )

	AADD( aItem,{"C7_REC_WT" , SC7->( recno() ), nil } )

	AADD( aItens, aItem )
	
	MATA120( 1, aCabec, aItens, 4 )

	if ( lMsErroAuto )
		aRet := {}
		aEval( getAutoGRLog(), {|x| cErro += x + CRLF } )
	else
		aRet := { cItem, nQtdPC, nTotalXML }
	endif

endif

Return aRet

/*/{Protheus.doc} getPrdGer
Funcao que checa os itens do pedido de compra que podem ser alterados.
No processo, é incluido um item generico com o valor total das mercadorias. Este item deve ser removido e posteriosmente o pedido de compras deve ser
acrescentado de produtos genericos conforme o desmembramento do XML, por tanto, deve ser mantido no pedido de compra somente o produto de serviços, que atualmente esta
mapeado com o código GERAL0000003 e os itens de mercadoria, criado conforme o XML
@type  Static Function
@author DS2U (SDA)
@since 22/07/2019
@version 1.0
@param cPedCom, caracter, Codigo do pedido de compras
@return cItem, caracter, item do pedido de compras que não é generico e nem geram (item de serviço)
/*/
Static Function getPrdGer( cPedCom )

Local cItem      := ""
Local cPrdGer    := allTrim( getMv( "MA_PRDGER",,"GERAL0000003" ) )
Local cAlias     := getNextAlias()
Local cPrfixPrGe := "XM" // Prefixo do produto generico criado

BEGINSQL ALIAS cAlias

	SELECT
		C7_ITEM

	FROM
		%TABLE:SC7% SC7

	WHERE
		SC7.C7_FILIAL = %XFILIAL:SC7%
		AND SC7.C7_NUM = %EXP:cPedCom%
		AND SC7.C7_PRODUTO <> %EXP:cPrdGer%
		AND SUBSTRING( SC7.C7_PRODUTO, 1, 2) <> %EXP:cPrfixPrGe%
		AND ( SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA ) > 0
		AND SC7.%NOTDEL%

ENDSQL

if ( !( cAlias )->( eof() ) )
	cItem := ( cAlias )->C7_ITEM
endif
( cAlias )->( dbCloseArea() )

Return cItem

/*/{Protheus.doc} isCanEdtPC
Funcao para checar se pode vincular o pedido de compras para desmembramento com o XML posicionado (ZN0)
@type  Static Function
@author DS2U (SDA)
@since 22/07/2019
@version 1.0
@param cPedCom, caracter, Codigo do pedido de compras
@return nTotXML, numeric, total dos itens do XML
/*/
Static Function isCanEdtPC( cPedCom, nTotXML, cErro )

Local lRet       := .F.
Local cAlias     := getNextAlias()
Local cPrdGer    := allTrim( getMv( "MA_PRDGER",,"GERAL0000003" ) )

Default cPedCom := ""
Default nTotXML := 0
Default cErro   := ""

BEGINSQL ALIAS cAlias

	SELECT
		SUM( C7_TOTAL ) AS TOTAL

	FROM
		%TABLE:SC7% SC7

	WHERE
		SC7.C7_FILIAL = %XFILIAL:SC7%
		AND SC7.C7_NUM = %EXP:cPedCom%
		AND SC7.C7_PRODUTO <> %EXP:cPrdGer%		
		AND SC7.%NOTDEL%

ENDSQL

if ( !( cAlias )->( eof() ) )
	
	lRet := ( ( cAlias )->TOTAL == nTotXML )

	if ( !lRet )
		cErro += "Total do item de mercadoria do pedido de compra " + allTrim( cValToChar( ( cAlias )->TOTAL ) ) + " está divergente do total dos itens do XML " + allTrim( cValToChar( nTotXML ) ) + CRLF
	endif

endif
( cAlias )->( dbCloseArea() )

Return lRet
