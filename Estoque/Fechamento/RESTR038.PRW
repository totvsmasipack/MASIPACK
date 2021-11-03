#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} RESTR038
	//TODO TESTES DE VALORES APÓS CUSTO MEDIO
	@author alison.goncalves
	@since 13/08/2018
	@version 1.0
	@return Nil
	@type function
/*/
User Function RESTR038()
	Local cNextAls	:=	GetNextAlias()	
	
	LjMsgRun("Gerando dados aguarde..." ,,{||GeraDad(cNextAls)})
	LjMsgRun("Gerando planilha..."		,,{||GeraPla(cNextAls)})
	
Return

/*/{Protheus.doc} GeraDad
	//TODO Busca os dados de estoque para geração de planilha
	@author alison.goncalves
	@since 12/03/2018
	@version 1.0
	@return Retorna o cursor com informações do estoque.
	@param aNextAls, array, Cursores
	@param aPerg, array, Perguntas
	@type function
/*/
Static Function GeraDad(cNextAls)
	Default cNextAls	:=	{}
		
	BeginSql Alias cNextAls

		SELECT
		B2_COD 'CODIGO'	,
		B2_QFIM			,
		B2_VFIM1
		FROM	%TABLE:SB2% B2 
		INNER JOIN %TABLE:SB1% B1 ON 	B1_FILIAL		= 		%XFILIAL:SB1%
										AND B1_COD		= 		B2_COD
										AND B1_PROCED 	LIKE  	'%P'	
										AND B1.%NOTDEL% 
										
		WHERE	B2_FILIAL		= '01'
				AND B2_LOCAL		= '01'
				//--B2_QFIM = 0 AND B2_VFIM1 <> 0
				//--B2_QFIM < 0
				//--B2_QFIM > 0 AND B2_VFIM1 < 0
				AND (B2_QFIM < 0 OR B2_VFIM1 < 0 OR (B2_QFIM = 0 AND B2_VFIM1 > 0))
				AND B2.%NOTDEL%
		ORDER BY 1

	
	EndSql

Return

/*/{Protheus.doc} GeraPla
	//TODO Gera planilha com as informações do cursor gerado.
	@author alison.goncalves
	@since 12/03/2018
	@version 1.0
	@return Gera um relatório em XML e abre no excel em colunas.
	@param cNextAls, characters, descricao
	@type function
/*/
Static Function GeraPla(cNextAls)
	Local cFile 	:= 'C:/RELATO_MICROSIGA/' + Upper(AllTrim(SM0->M0_NOME)) + '_'	+ ALLTRIM(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_RESTR038.xml'
	Local oExcel 	:= FWMSEXCEL():New()

	oExcel:AddWorkSheet	("Divergencias"																)
	oExcel:AddTable		("Divergencias"	,"Valores de produtos"									)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Codigo"				,1,1,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Quant Fim"			,1,2,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Valor Fim"			,1,2,.F.)
	

	//Alimento a primeira Query
	(cNextAls)->(dbGoTop())
	While (cNextAls)->(!EOF())
		oExcel:AddRow("Divergencias","Valores de produtos",{		AllTrim((cNextAls)->CODIGO)		,;
																	(cNextAls)->B2_QFIM				,;
																	(cNextAls)->B2_VFIM1			;
																},;
					 )

		(cNextAls)->(dbSkip())
	End

	If Select(cNextAls) > 0
		(cNextAls)->(dbCloseArea())
	EndIf

	oExcel:Activate()
	oExcel:GetXMLFile(cFile)

	If File(cFile)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cFile)
		oExcelApp:SetVisible(.T.)
	EndIf

Return
