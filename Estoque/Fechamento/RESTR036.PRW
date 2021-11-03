#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} RESTR036
	//TODO relatório para comparativo e diferenças de estoque.
	@author alison.goncalves
	@since 30/04/2018
	@version 1.0
	@return Nil
	@type function
/*/
User Function RESTR036()
	Local aNextAls	:=	{}	
	Local aPerg		:=	{}
	
	Pergunte('RESTR036',.T.)
		
	aAdd(aNextAls,GetNextAlias()) //Primerio traz a query de fechamento
	aAdd(aNextAls,GetNextAlias()) //Segundo faz a comparação com o RESTR030 e traz as diferenças
	aAdd(aNextAls,GetNextAlias()) //Itens que entraram em outros
	
	aAdd(aPerg,MV_PAR01) //1 - Aberto / 2 - Fechado:
	aAdd(aPerg,MV_PAR02) //Ano e Mes: 
	aAdd(aPerg,MV_PAR03) //Local De:
	aAdd(aPerg,MV_PAR04) //Local até:
		
	LjMsgRun("Gerando dados aguarde..." ,,{||GeraDad(aNextAls,aPerg)})
	LjMsgRun("Gerando planilha..."		,,{||GeraPla(aNextAls,aPerg)})
	
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
Static Function GeraDad(aNextAls, aPerg)
	Default aNextAls	:=	{}
	Default aPerg		:=	{}
	
	
	If Len(aNextAls) > 0 .And. Len(aPerg) > 0
		If aPerg[1] == 1
			FEstOpen(aNextAls, aPerg)
			EstCompOpen(aNextAls, aPerg)
			VerOpenOut(aNextAls, aPerg)
		Else
			FestClose(aNextAls, aPerg)
			EstCompClose(aNextAls, aPerg)	
		EndIf	
	EndIF	
	
Return 


/*/{Protheus.doc} FEstOpen
	//TODO Busca informações do estoque em aberto
	@author alison.goncalves
	@since 30/04/2018
	@version 1.0
	@return Retorna o cursor com informações do estoque.
	@param aNextAls, array, Cursores
	@param aPerg, array, Perguntas
	@type function
/*/
Static Function	FEstOpen(aNextAls, aPerg)
	Local cNextAls	:= aNextAls[1]
	
	BeginSql Alias cNextAls

		SELECT
			CASE
				WHEN B1_TIPO = 'MP' THEN 'MATERIA PRIMA'
				WHEN B1_TIPO = 'ME' THEN 'MATERIAL DE EMBALAGEM'
				WHEN B1_TIPO IN('FE','MC','MI','MQ','OI','PI') THEN 'PRODUTOS INTERMEDIARIOS'
				WHEN B1_TIPO IN('AC','AD') THEN 'COMPONENTES ADQUIRIDOS DE TERCEIROS'
				WHEN B1_TIPO = 'PA' AND B1_COD LIKE 'MQ%' THEN 'PRODUTOS ACABADOS' 
				WHEN B1_TIPO = 'PA' AND B1_COD NOT LIKE 'MQ%' THEN 'COMPONENTES FABRICAÇÃO PRÓPRIA'
			ELSE
				'OUTROS'
			END 'TIPO',
	
			ROUND(SUM(B2_VFIM1),2) TOTAL
		FROM %Table:SB2% B2 
		INNER JOIN %Table:SB1% B1	ON	B1.B1_FILIAL		= %xFilial:SB1%
									AND B1.B1_COD			= B2.B2_COD
									AND (B1.B1_PROCED	LIKE '%P' OR B1.B1_PROCED     = '')
									AND B1.%NotDel%
		WHERE	B2_FILIAL		= %xFilial:SB2%
			AND B2.B2_LOCAL      >= %Exp:aPerg[3]%
			AND B2.B2_LOCAL      <= %Exp:aPerg[4]%
			AND B2_VFIM1		> 0
			AND	B2.%NotDel%
		GROUP BY 
			CASE
				WHEN B1_TIPO = 'MP' THEN 'MATERIA PRIMA'
				WHEN B1_TIPO = 'ME' THEN 'MATERIAL DE EMBALAGEM'
				WHEN B1_TIPO IN('FE','MC','MI','MQ','OI','PI') THEN 'PRODUTOS INTERMEDIARIOS'
				WHEN B1_TIPO IN('AC','AD') THEN 'COMPONENTES ADQUIRIDOS DE TERCEIROS'
				WHEN B1_TIPO = 'PA' AND B1_COD LIKE 'MQ%' THEN 'PRODUTOS ACABADOS' 
				WHEN B1_TIPO = 'PA' AND B1_COD NOT LIKE 'MQ%' THEN 'COMPONENTES FABRICAÇÃO PRÓPRIA'
			ELSE
				'OUTROS'
			END
		ORDER BY 1
	
	EndSql

Return


/*/{Protheus.doc} EstCompOpen
	//TODO Compara restr030 com a query de fechamento.
	@author alison.goncalves
	@since 30/04/2018
	@version 1.0
	@return Retorna o cursor com informações do estoque.
	@param aNextAls, array, Cursores
	@param aPerg, array, Perguntas
	@type function
/*/
Static Function EstCompOpen(aNextAls, aPerg)	
	Local cNextAls	:= aNextAls[2]
	
	BeginSql Alias cNextAls

		SELECT B1_COD, SUM(TOTAL) VALOR , SUM(Z1) Z1 , (SUM(TOTAL) - SUM(Z1)) AS DIF
		FROM (
				SELECT	'B1' AS COL,
						B1.B1_COD,
						Round(B2.B2_VFIM1,2)    'TOTAL',
						0 AS Z1
				FROM %Table:SB2% B2      
				INNER JOIN %Table:SB1% B1 ON    B1.B1_FILIAL	= %xFilial:SB1%
											AND B1.B1_COD		= B2.B2_COD
											AND (B1.B1_PROCED	LIKE '%P' OR B1.B1_PROCED     = '')
											AND B1.%NotDel%
				WHERE	B2.B2_FILIAL     = %xFilial:SB2%
					AND B2.B2_LOCAL      >= %Exp:aPerg[3]%
					AND B2.B2_LOCAL      <= %Exp:aPerg[4]%
					AND B2.B2_VFIM1      > 0
					AND B2.%NotDel%

				UNION ALL

				SELECT 'Z1' AS COL,
						ZZ1.ZZ1_COD COD,
						0,
						ROUND(SUM(ZZ1.ZZ1_VALOR),2) VALOR
				FROM %Table:ZZ1% ZZ1
				WHERE	ZZ1.ZZ1_FILIAL     = %xFilial:ZZ1%
					AND ZZ1.ZZ1_OP         = '' 
					AND ZZ1.ZZ1_PERIOD     = %Exp:aPerg[2]%  
					AND ZZ1.ZZ1_TIPO LIKE '10%' 
					AND ZZ1.%NotDel%
				GROUP BY ZZ1_COD
 
			) T1
		GROUP BY B1_COD

		HAVING SUM(TOTAL) <> SUM(Z1)
 
		ORDER BY B1_COD
	
	EndSql

return 

/*/{Protheus.doc} VerOpenOut
//TODO Descrição auto-gerada.
@author alison.goncalves
@since 13/08/2018
@version 1.0
@return NIL
@param aNextAls, array, descricao
@param aPerg, array, descricao
@type function
/*/
Static Function VerOpenOut(aNextAls, aPerg) 
	Local cAls
	
	default aPerg := {}
	default aNextAls := {}
	
	cAls	:=	aNextAls[3]
	
	BeginSql Alias cAls 
		SELECT
				B1_TIPO               'TIPO'     ,
				B1_COD                'CODIGO'   ,
				B1_DESC               'DESCRICAO',
				ROUND(B2_VFIM1,2)     'VALOR'
		FROM %TABLE:SB2% B2 
		INNER JOIN %TABLE:SB1% B1 ON   	B1.%NOTDEL%
									AND B1_FILIAL        = %XFILIAL:SB1%
									AND B1_COD           = B2_COD
									AND B1_PROCED        LIKE '%P'
									AND B1_TIPO NOT IN ('MP','ME','FE','MC','MI','MQ','OI','PI','AC','AD','PA')
		WHERE	B2.%NOTDEL%
				AND B2_FILIAL        = %XFILIAL:SB2%
				AND B2.B2_LOCAL      >= %Exp:aPerg[3]%
				AND B2.B2_LOCAL      <= %Exp:aPerg[4]%
				AND B2_VFIM1        > 0
		ORDER BY 1
	EndSql			

Return

/*/{Protheus.doc} FestClose
	//TODO Busca posição de estoque fechado
	@author alison.goncalves
	@since 30/04/2018
	@version 1.0
	@return Retorna o cursor com informações do estoque.
	@param aNextAls, array, Cursores
	@param aPerg, array, Perguntas
	@type function
/*/
Static Function FestClose(aNextAls, aPerg)
	Local cNextAls	:= aNextAls[1]
	Local cData 	:= Lastdate(stod(aPerg[2]+'01')) //Trago a ultima data

	BeginSql Alias cNextAls
	
		SELECT
	
			CASE
				WHEN B1.B1_TIPO = 'MP' THEN 'MATERIA PRIMA'
				WHEN B1.B1_TIPO = 'ME' THEN 'MATERIAL DE EMBALAGEM'
				WHEN B1.B1_TIPO IN('FE','MC','MI','MQ','OI','PI') THEN 'PRODUTOS INTERMEDIARIOS'
				WHEN B1.B1_TIPO IN('AC','AD') THEN 'COMPONENTES ADQUIRIDOS DE TERCEIROS'
				WHEN B1.B1_TIPO = 'PA' AND B1.B1_COD LIKE 'MQ%' THEN 'PRODUTOS ACABADOS' 
				WHEN B1.B1_TIPO = 'PA' AND B1.B1_COD NOT LIKE 'MQ%' THEN 'COMPONENTES FABRICAÇÃO PRÓPRIA'
			ELSE
				'OUTROS'
			END 'TIPO',
	
			SUM(B9_VINI1) AS TOTAL
		FROM %Table:SB9% B9 
		INNER JOIN %Table:SB1% B1	ON	B1_FILIAL		= %xFilial:SB1%
									AND B1_COD			= B9.B9_COD
									AND B1.%NotDel%
		WHERE	B9.B9_FILIAL		= %xFilial:SB9%
			AND B9.B9_LOCAL		>=	%Exp:aPerg[3]%
			AND B9.B9_LOCAL		<=	%Exp:aPerg[4]%
			AND (B9.B9_XPROCED	LIKE '%P' OR B9.B9_XPROCED	= '')
			AND B9.B9_DATA		=	%Exp:cData%
			AND B9.B9_VINI1		> 0
			AND B9.%NotDel%
		GROUP BY 
			CASE
				WHEN B1.B1_TIPO = 'MP' THEN 'MATERIA PRIMA'
				WHEN B1.B1_TIPO = 'ME' THEN 'MATERIAL DE EMBALAGEM'
				WHEN B1.B1_TIPO IN('FE','MC','MI','MQ','OI','PI') THEN 'PRODUTOS INTERMEDIARIOS'
				WHEN B1.B1_TIPO IN('AC','AD') THEN 'COMPONENTES ADQUIRIDOS DE TERCEIROS'
				WHEN B1.B1_TIPO = 'PA' AND B1.B1_COD LIKE 'MQ%' THEN 'PRODUTOS ACABADOS' 
				WHEN B1.B1_TIPO = 'PA' AND B1.B1_COD NOT LIKE 'MQ%' THEN 'COMPONENTES FABRICAÇÃO PRÓPRIA'
			ELSE
				'OUTROS'
			END
		ORDER BY 1
	
	EndSql
		
Return

/*/{Protheus.doc} EstCompClose
	//TODO Busca posição de estoque fechado e compara com restr030
	@author alison.goncalves
	@since 30/04/2018
	@version 1.0
	@return Retorna o cursor com informações do estoque.
	@param aNextAls, array, Cursores
	@param aPerg, array, Perguntas
	@type function
/*/
Static Function EstCompClose(aNextAls, aPerg)	
	Local cNextAls	:= aNextAls[2]
	Local cData 	:= Lastdate(stod(aPerg[2]+'01')) //Trago a ultima data
	
	BeginSql Alias cNextAls
	
		SELECT B1_COD, SUM(Round(VALOR,2)) VALOR , SUM(Round(Z1,2)) Z1, (SUM(VALOR) - SUM(Z1)) AS DIF
		FROM (
				SELECT
						'B9' COL ,
						B1_COD,   
						SUM(B9_VINI1) AS VALOR ,
						0 Z1
				FROM  %Table:SB9% B9 
				INNER JOIN %Table:SB1% B1 ON    B1.B1_FILIAL	= %xFilial:SB1%
											AND B1.B1_COD   	= B9.B9_COD 
											AND B1.%NotDel%
				WHERE	B9.B9_FILIAL	= %xFilial:SB9%
					AND B9.B9_LOCAL		>=	%Exp:aPerg[3]%
					AND B9.B9_LOCAL		<=	%Exp:aPerg[4]%
					AND (B9.B9_XPROCED	LIKE '%P' OR B9.B9_XPROCED	= '')
					AND B9.B9_DATA		=	%Exp:cData%
					AND B9.B9_VINI1		>	0
					AND B9.%NotDel%
				GROUP BY B1_COD


			UNION ALL

				SELECT 'Z1' AS COL,
						ZZ1_COD COD,
						0,
						ROUND(SUM(ZZ1.ZZ1_VALOR),2) VALOR
				FROM %TABLE:ZZ1% ZZ1 
				WHERE	ZZ1.ZZ1_FILIAL	=	%xFilial:ZZ1%
					AND ZZ1.ZZ1_OP      =	'' 
					AND ZZ1.ZZ1_PERIOD  =	%Exp:aPerg[2]%
					AND ZZ1.ZZ1_TIPO	LIKE	'10%' 
				GROUP BY ZZ1_COD
 
			) T1

		GROUP BY B1_COD

		HAVING (SUM(VALOR) - SUM(Z1)) > 0 or (SUM(VALOR) - SUM(Z1)) < 0
 
		ORDER BY B1_COD

	
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
Static Function GeraPla(aNextAls)
	Local cFile 	:= 'C:/RELATO_MICROSIGA/' + Upper(AllTrim(SM0->M0_NOME))	+	'_'	+ ALLTRIM(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_RESTR036.xml'
	Local oExcel 	:= FWMSEXCEL():New()

	oExcel:AddWorkSheet	("Comparativo"																)
	oExcel:AddTable		("Comparativo"	,"Comparativo de Estoque"									)
	oExcel:AddColumn	("Comparativo"	,"Comparativo de Estoque"	,"Tipo"					,1,1,.F.)
	oExcel:AddColumn	("Comparativo"	,"Comparativo de Estoque"	,"Valor"				,1,2,.F.)

	//Alimento a primeira Query
	(aNextAls[1])->(dbGoTop())
	While (aNextAls[1])->(!EOF())
		oExcel:AddRow 	("Comparativo","Comparativo de Estoque",{	(aNextAls[1])->TIPO,;
																	(aNextAls[1])->TOTAL; 
																},;
						)

		(aNextAls[1])->(dbSkip())
	End

	If Select(aNextAls[1]) > 0
		(aNextAls[1])->(dbCloseArea())
	EndIf

	
	If Select(aNextAls[3]) > 0
		
		oExcel:AddWorkSheet	("PRODUTOS QUE ENTRARAM EM OUTROS"																)
		oExcel:AddTable		("PRODUTOS QUE ENTRARAM EM OUTROS","OUTROS"									)
		oExcel:AddColumn	("PRODUTOS QUE ENTRARAM EM OUTROS","OUTROS"	,"Tipo"					,1,1,.F.)
		oExcel:AddColumn	("PRODUTOS QUE ENTRARAM EM OUTROS","OUTROS"	,"Codigo"				,1,1,.F.)
		oExcel:AddColumn	("PRODUTOS QUE ENTRARAM EM OUTROS","OUTROS"	,"Descrição"			,1,1,.F.)
		oExcel:AddColumn	("PRODUTOS QUE ENTRARAM EM OUTROS","OUTROS"	,"Valor"				,1,2,.F.)
		
		(aNextAls[3])->(dbGoTop())
		While (aNextAls[3])->(!EOF())
				oExcel:AddRow("PRODUTOS QUE ENTRARAM EM OUTROS"	,"OUTROS",{	(aNextAls[3])->TIPO,;
																					(aNextAls[3])->CODIGO,; 
																					(aNextAls[3])->DESCRICAO,; 
																					(aNextAls[3])->VALOR; 
																			 },;
							 )
				(aNextAls[3])->(dbSkip())
		End

		If Select(aNextAls[3]) > 0
			(aNextAls[3])->(dbCloseArea())
		EndIf
	EndIf	
		
	
	oExcel:AddWorkSheet	("ZZ1 X Iventario"																)
	oExcel:AddTable		("ZZ1 X Iventario","Comparativo de diferencas"									)
	oExcel:AddColumn	("ZZ1 X Iventario","Comparativo de diferencas"	,"Tipo"					,1,1,.F.)
	oExcel:AddColumn	("ZZ1 X Iventario","Comparativo de diferencas"	,"Valor"				,1,2,.F.)
	oExcel:AddColumn	("ZZ1 X Iventario","Comparativo de diferencas"	,"VALOR Z1"				,1,2,.F.)
	oExcel:AddColumn	("ZZ1 X Iventario","Comparativo de diferencas"	,"Diferenca"			,1,2,.F.)
	//Alimento a segunda Query
	(aNextAls[2])->(dbGoTop())
	While (aNextAls[2])->(!EOF())
		oExcel:AddRow 	("ZZ1 X Iventario"	,"Comparativo de diferencas",{	(aNextAls[2])->B1_COD,;
																			(aNextAls[2])->VALOR,; 
																			(aNextAls[2])->Z1,; 
																			(aNextAls[2])->DIF; 
																		},;
						)

		(aNextAls[2])->(dbSkip())
	End

	If Select(aNextAls[2]) > 0
		(aNextAls[2])->(dbCloseArea())
	EndIf

	oExcel:Activate()
	oExcel:GetXMLFile(cFile)

	If File(cFile)
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cFile)
		oExcelApp:SetVisible(.T.)
	EndIf

Return
