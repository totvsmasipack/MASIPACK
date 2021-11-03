#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} RESTR038
	//TODO Ajusta valores na reabertura de estoque - C2_VINI1
	@author alison.goncalves
	@since 16/08/2018
	@version 1.0
	@return NilAA
	@type function
/*/
User Function RESTR039()
	Local cNextAls	:=	GetNextAlias()
	Local dDateUlmes	:= 	SuperGetMv('MV_ULMES',.F.)

	If Pergunte('RESTR030')
		LjMsgRun("Gerando dados aguarde..." ,,{||GeraDad(cNextAls)})
		LjMsgRun("Gerando planilha..."		,,{||GeraPla(cNextAls)})
	EndIf	
	
	IF MSGYESNO( 'Deseja ajustar os valores inicial do mês nas Ops?', 'Atenção!' ) 
		IF STOD(MV_PAR01+'01') > dDateUlmes
			ProcUpd()
		Else
			Alert('O mês que esta tentando ajustar já se encontra fechado!')
		EndIf
	EndIf
	
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
	Local 	cPar01		:=	AllTrim(MV_PAR01)
	Local 	cParIni		:=	AllTrim(MV_PAR01)+'01'
	Local 	cParFim		:=	Lastdate(stod(AllTrim(MV_PAR01)+'01'))
	Default cNextAls	:=	{}
	
		
	BeginSql Alias cNextAls

		SELECT *, C2_VINI1 - ROUND(CUSTO_INICIAL,2) AS DIF 
		FROM 	(
					SELECT	SC2.C2_NUM,
							SC2.C2_ITEM,
							SC2.C2_SEQUEN,
							SC2.C2_EMISSAO,
							SC2.C2_DATRF,
							SC2.C2_VINI1,
							/*trago os valores das requisições do mês anterior*/
							ISNULL(( SELECT SUM(D3_CUSTO1) 
									 FROM %TABLE:SD3% SD3 
									 WHERE 	D3_EMISSAO < %Exp:cParIni% AND 
									 		D3_CF LIKE 'RE%' AND 
									 		D3_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND
									 		D3_ESTORNO <> 'S' AND 
									 		SD3.%NOTDEL%),0
							) AS CUSTO_INICIAL,
							/*Trago os valores das requisições do mês*/
							ISNULL(( 	SELECT SUM(D3_CUSTO1) 
										FROM %TABLE:SD3% SD32 
										WHERE D3_EMISSAO BETWEEN %Exp:cParIni% AND %Exp:cParFim% AND 
										D3_CF LIKE 'RE%' AND 
										D3_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND
										D3_ESTORNO <> 'S' AND  
										SD32.%NOTDEL%),0
							) AS CUSTO_DO_MES

					FROM  %TABLE:SC2% SC2
					WHERE	C2_FILIAL = %XFILIAL:SC2% AND  
							C2_EMISSAO < %Exp:cParIni% AND 
							(	C2_DATRF = '' 
								OR 
								C2_DATRF LIKE %EXP:cPar01% + '%'
							) AND 
							SC2.%NOTDEL%

				)  T1

		ORDER BY C2_VINI1 - ROUND(CUSTO_INICIAL,2) DESC
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
	Local cFile 	:= 'C:/RELATO_MICROSIGA/' + Upper(AllTrim(SM0->M0_NOME)) + '_'	+ ALLTRIM(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_RESTR039.xml'
	Local oExcel 	:= FWMSEXCEL():New()

	oExcel:AddWorkSheet	("Divergencias"																)
	oExcel:AddTable		("Divergencias"	,"Valores de produtos"										)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Numero Op"				,1,1,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Item"						,1,1,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Sequencia"				,1,1,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Emissao"					,1,1,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Data Real Fim"			,1,1,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"C2_VINI1"					,1,2,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Valor calculado"			,1,2,.F.)
	oExcel:AddColumn	("Divergencias"	,"Valores de produtos"	,"Diferença"				,1,2,.F.)
	
	//Alimento a primeira Query
	(cNextAls)->(dbGoTop())
	While (cNextAls)->(!EOF())
		oExcel:AddRow("Divergencias","Valores de produtos",{		AllTrim((cNextAls)->C2_NUM)		,;
																	(cNextAls)->C2_ITEM				,;
																	(cNextAls)->C2_SEQUEN			,;
																	(cNextAls)->C2_EMISSAO			,;
																	(cNextAls)->C2_DATRF			,;
																	(cNextAls)->C2_VINI1			,;
																	(cNextAls)->CUSTO_INICIAL		,;
																	(cNextAls)->DIF			;
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

Static Function ProcUpd()
	Local 	cPar01		:=	AllTrim(MV_PAR01)
	Local 	cParIni		:=	AllTrim(MV_PAR01)+'01'
	Local 	cParFim		:=	Lastdate(stod(AllTrim(MV_PAR01)+'01'))
	Local 	nRet		:=  0
	Local 	cQuery		:=	''
	
	
	cQuery := "	UPDATE " + RetSqlName('SC2') + " SET C2_VINI1 = 						"
	cQuery += "	ISNULL(( SELECT SUM(D3_CUSTO1) 											" 
	cQuery += "			 FROM " +RetSqlName('SD3') + " SD3 								" 
	cQuery += "			 WHERE 	D3_EMISSAO < '" + cParIni + "' AND 						" 
	cQuery += "					D3_CF LIKE 'RE%' AND									" 
	cQuery += "			 		D3_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND 	"
	cQuery += "			 		D3_ESTORNO <> 'S' AND 									" 
	cQuery += "			 		SD3.D_E_L_E_T_ = ''),0									"
	cQuery += "			)																" 
	cQuery += "	FROM " + RetSqlName('SC2') + " SC2										"
	cQuery += "	WHERE	C2_FILIAL = '"	+	xFilial('SC2')	+	"' AND					"  
	cQuery += "			C2_EMISSAO < '"	+	cParIni	+	"' AND 							"
	cQuery += "			(	C2_DATRF = '' 												"
	cQuery += "				OR 															"
	cQuery += "				C2_DATRF LIKE '"	+ cPar01 +	"' + '%'					"
	cQuery += "			) AND 															"
	cQuery += "			SC2.D_E_L_E_T_ = ''												"

	
	nRet	:=	TcSqlExec(cQuery)	
	
	If nRet < 0
		Alert('Erro ao processar procure a TI ou tente novamente mais tarde!')
	EndIf	
	
Return 
