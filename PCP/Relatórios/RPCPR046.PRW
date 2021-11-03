#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RPCPR046
//TODO Descrição: Extrair e comparar o valor das Ordens de produção de um determinado período.
@author ivandro.santos
@since 07/08/2018
@version 1.0
@return NIL
@type function
/*/
User function RPCPR046()
Local cPerg		:= "RPCPR46"
Local nLastKey	:= 0
Local _lRet		:= .F.
Local cAliasD3	:= GetNextAlias()

_lRet := Pergunte(cPerg)

If nLastKey == 27 .Or. !_lRet
	ApMsgAlert("Cancelado pelo usuário")
	Return
Endif

MsAguarde({||RPCPR46QRY(cAliasD3)}, OemToAnsi("Gerando Dados") )
MsAguarde({||RPCPR46PLA(cAliasD3)}, OemToAnsi("Gerando Planilha") )	

Return

/*/{Protheus.doc} RPCPR46QRY
//TODO Descrição: Gerar a query conforme os parâmetros selecionado.
@author ivandro.santos
@since 07/08/2018
@version 1.0
@return NIL
@param cAliasD3, characters, descricao: Nome da tabela temporária criada 
@type function
/*/
Static Function RPCPR46QRY(cAliasD3)

BeginSQL Alias cAliasD3
	Column C2_DATRF as Date
	SELECT TRB.* FROM
	(SELECT 
		D3.D3_OP,
		C2_PRODUTO,
		B1_DESC, 
		C2_DATRF,
		ISNULL(D3PRO.D3_CUSTO1,0) 'VALOR_PROD', 
		SUM(D3.D3_CUSTO1) 'SOMA_REQ',
		CASE WHEN D3PRO.D3_CUSTO1 > 0 AND SUM(D3.D3_CUSTO1) > 0 
			THEN ROUND(((D3PRO.D3_CUSTO1/SUM(D3.D3_CUSTO1))-1)*100,2) 
			ELSE 0 END 'MARGEM',
		D3PRO.D3_CUSTO1-SUM(D3.D3_CUSTO1) 'DIFERENCA'
	FROM %table:SD3% D3 
	LEFT JOIN %table:SD3% D3PRO ON 
			D3PRO.D3_FILIAL = %xFilial:SD3% 
		AND D3.D3_OP = D3PRO.D3_OP 
		AND D3PRO.D3_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		AND D3PRO.D3_ESTORNO = ''
		AND SUBSTRING(D3PRO.D3_CF,1,2) = 'PR'
		AND D3PRO.%notdel%
	INNER JOIN %table:SC2% C2 ON 
			C2_FILIAL = %xFilial:SC2% 
		AND SUBSTRING(D3.D3_OP,1,6) = C2.C2_NUM 
		AND SUBSTRING(D3.D3_OP,7,2) = C2.C2_ITEM 
		AND SUBSTRING(D3.D3_OP,9,3) = C2.C2_SEQUEN 
		AND C2.%notdel%
	INNER JOIN %table:SB1% B1 ON
			B1_FILIAL = %xFilial:SB1%
		AND B1_COD = C2_PRODUTO
		AND B1.%notdel%
	WHERE 
		D3.D3_FILIAL = %xFilial:SD3% 
	AND  D3.D3_ESTORNO = '' 
	AND SUBSTRING(D3.D3_CF,1,2) = 'RE' 
	AND C2_DATRF BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% 
	AND D3.%notdel%
	GROUP BY D3.D3_OP,C2_PRODUTO,B1_DESC,C2_DATRF,D3PRO.D3_CUSTO1) AS TRB
	WHERE TRB.MARGEM <= - %exp:MV_PAR03% OR TRB.MARGEM >= %exp:MV_PAR03%
EndSQL	

Return

/*/{Protheus.doc} RPCPR46PLA
//TODO Descrição: gera planilha com as informações da Query.
@author ivandro.santos
@since 07/08/2018
@version 1.0
@return NIL
@param cAliasD3, characters, descricao: Nome da tabela temporária
@type function
/*/
Static Function RPCPR46PLA(cAliasD3)
	Local cFile 	:= 'C:/RELATO_MICROSIGA/' + Upper(AllTrim(SM0->M0_NOME)) + '_' + ALLTRIM(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_RPCPR046.xml'
	Local oExcel := FWMSEXCEL():New()

	oExcel:AddWorkSheet	("OP"													 )
	oExcel:AddTable		("OP","OPs Finalizadas"							 		 )
	oExcel:AddColumn	("OP","OPs Finalizadas","Ordem Prod"			,1,1,.F. )
	oExcel:AddColumn	("OP","OPs Finalizadas","Produto"				,1,1,.F. )
	oExcel:AddColumn	("OP","OPs Finalizadas","Descrição Produto"		,1,2,.F. )
	oExcel:AddColumn	("OP","OPs Finalizadas","Data"					,3,4,.F. )
	oExcel:AddColumn	("OP","OPs Finalizadas","Valor Produto"			,3,3,.T. )
	oExcel:AddColumn	("OP","OPs Finalizadas","Soma Requisição"		,3,3,.T. )
	oExcel:AddColumn	("OP","OPs Finalizadas","Perc Divergente (%)"	,3,2,.F. )
	oExcel:AddColumn	("OP","OPs Finalizadas","Valor Divergente"		,3,3,.T. )

	(cAliasD3)->(dbGoTop())
	While (cAliasD3)->(!EOF())
		oExcel:AddRow 	("OP","OPs Finalizadas",{(cAliasD3)->D3_OP 		,; 
												 (cAliasD3)->C2_PRODUTO	,;
												 (cAliasD3)->B1_DESC 	,;
												 (cAliasD3)->C2_DATRF	,;
												 (cAliasD3)->VALOR_PROD	,;
												 (cAliasD3)->SOMA_REQ	,;
												 (cAliasD3)->MARGEM		,;
												 (cAliasD3)->DIFERENCA})

		(cAliasD3)->(dbSkip())
	EndDo

	If Select(cAliasD3) > 0
		(cAliasD3)->(dbCloseArea())
	EndIf

	oExcel:Activate()
	oExcel:GetXMLFile(cFile)

	If File(cFile)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cFile)
		oExcelApp:SetVisible(.T.)
	EndIf
	
	FreeObj(oExcel)
	
Return