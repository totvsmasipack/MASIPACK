#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} RFATR075
//TODO Traz produtos do mês corrente que não tem conta contabil cadastrada
@author alison.goncalves
@since 21/05/2018
@version 1.0
@return NIL
@type function
/*/
User Function RFATR075()
	Local cAls075	:=	GetNextAlias()

	If Pergunte('RFATR075',.T.)
	
		If MV_PAR01 == 1
			LjMsgRun("Gerando dados aguarde..." ,,{||FilDados	( cAls075 )		})
			LjMsgRun("Gerando planilha..."		,,{||GeraPla	( cAls075 )		})
		ElseIf MV_PAR01 == 2
			If file(MV_PAR04)
				LjMsgRun("Atualizando dados..."	,,{||UpdF3Cont()		})
			EndIF
		EndIf	
	
	EndIf	
Return


/*/{Protheus.doc} FilDados
//TODO Responsavel por filtrar o dados.
@author alison.goncalves
@since 21/05/2018
@version 1.0
@return nil

@type function
/*/
Static Function FilDados(cAls)
	Default cAls := ''

	BeginSql Alias cAls
		SELECT	SFT.FT_PRODUTO,
				SFT.FT_NFISCAL,
				SFT.FT_SERIE,
				SFT.FT_ENTRADA,
				SFT.FT_EMISSAO,
				SFT.FT_CFOP,
				SFT.FT_CONTA,
				SB1.B1_COD,
				RTRIM(LTRIM(SB1.B1_DESC)) B1_DESC,
				SB1.B1_PROCED,
				SB1.B1_CONTA,
				SFT.FT_CLIEFOR,
				SFT.FT_LOJA, 
				SFT.R_E_C_N_O_ 'REGISTRO'
		FROM %Table:SFT% SFT
		INNER JOIN %Table:SB1% SB1 ON SB1.B1_COD = SFT.FT_PRODUTO AND SB1.B1_FILIAL = %xFilial:SB1% AND SB1.D_E_L_E_T_ = ''
		WHERE	SFT.FT_ENTRADA BETWEEN %Exp:MV_PAR02% AND  %Exp:MV_PAR03% 
		AND SFT.FT_EMISSAO <> SFT.FT_ENTRADA 
		AND SFT.FT_CONTA = '' 
		AND SUBSTRING(SB1.B1_PROCED,2,1) = 'P'
		AND SFT.FT_FILIAL = %xFilial:SFT% 
		AND SFT.D_E_L_E_T_ = ''
	EndSql 

Return

/*/{Protheus.doc} GeraPla
//TODO Responsavel por gerar a planilha no modelo XML.
@author alison.goncalves
@since 21/05/2018
@version 1.0
@return Nil

@type function
/*/
Static Function GeraPla(cAls)
	Local oExcel := FWMSEXCEL():New()

	Default cAls := ''

	If !Empty(cAls)
		oExcel:AddWorkSheet("Notas")
		oExcel:AddTable ("Notas","Sem Conta Contabil")
		oExcel:AddColumn("Notas","Sem Conta Contabil","Filial"				,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Empresa"				,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Produto"				,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Nota Fiscal"			,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Serie"				,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Entrada"				,1,4,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Emissao"				,1,4,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","CFOP"				,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Livro Conta Cont."	,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Codigo"				,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Descricao"			,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Procedencia"			,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Prod. Conta Cont."	,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Client / Fornec"		,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Loja"				,1,1,.F.)
		oExcel:AddColumn("Notas","Sem Conta Contabil","Registro"			,1,1,.F.)

		(cAls)->(dbGoTop())
		While (cAls)->(!EOF())

			oExcel:AddRow("Notas","Sem Conta Contabil",{ cFilAnt		,;
													SM0->M0_NOME		,;
													(cAls)->FT_PRODUTO 	,;	//03
													(cAls)->FT_NFISCAL	,;	//04
													(cAls)->FT_SERIE	,;	//05
													(cAls)->FT_ENTRADA	,;	//06
													(cAls)->FT_EMISSAO	,;	//07
													(cAls)->FT_CFOP		,;	//08
													(cAls)->FT_CONTA	,;	//09
													(cAls)->B1_COD		,;	//10
													(cAls)->B1_DESC		,;	//11
													(cAls)->B1_PROCED	,;	//12
													(cAls)->B1_CONTA	,;	//13
													(cAls)->FT_CLIEFOR	,;	//14
													(cAls)->FT_LOJA		,;	//15
													(cAls)->REGISTRO	})	//16

			(cAls)->(dbSkip())
		End	

		If Select(cAls) > 0
			(cAls)->(dbCloseArea())
		EndIf

		oExcel:Activate()
		oExcel:GetXMLFile("C:/RELATO_MICROSIGA/RFATR075.xml")

		If File("C:/RELATO_MICROSIGA/RFATR075.xml")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/REFATR075.xml")
			oExcelApp:SetVisible(.T.)
		EndIf
	EndIf
Return

/*/{Protheus.doc} UpdF3Cont
//TODO faço a leitura da planilha gerada neste relatório, para correção da conta contabil
@author alison.goncalves
@since 21/05/2018
@version 1.0
@return Logico, .T. Verdadeiro , .F. Falso
@param cArq, characters, descricao
@type function
/*/
Static Function UpdF3Cont(cArq)
	Local 	cError		:=	''
	Local	cErro		:=	''
	Local 	cWarning	:=	''		
	Local 	cDir		:=  '\xml\atualizacoes\'
	Local 	aFile		:=  StrToKarr(AllTrim(MV_PAR04),'\')
	Local 	lRet		:= 	.T.
	Local 	cXml		:= 	AllTrim(cDir+aFile[len(aFile)])
	Local 	aDados		:=	{}
	Local	nI			:= 	0
	
	Private oXml		:=	nil
	
	//Crio um dicionário dentro da pasta XML, para mover o arquivo
	If Existdir(cDir)
		IF MakeDir(cDir) == 0
			lRet := .F.
		EndIf	
	EndIf	
	
	If lRet	
		//Faço a cópia para o servidor 
		If CpyT2S( MV_PAR04, cDir, .T., .T. ) 
			oXml :=	XmlParserFile(cXml,'_',@cError,@cWarning)
			IF Type('oXml') == 'O'
				For nI:= 3 to Len(oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW)
					If Type('oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW['+Str(nI)+']:_CELL') != 'U'
						If Len(oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL) == 16
							aAdd(aDados, {	oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[1]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[2]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[3]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[4]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[5]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[6]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[7]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[8]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[9]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[10]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[11]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[12]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[13]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[14]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[15]:_DATA:TEXT,;
									oXml:_WORKBOOK:_WORKSHEET:_TABLE:_ROW[nI]:_CELL[16]:_DATA:TEXT;
								})
						EndIF
					EndIF
				Next nI	
				oXml := nil
			EndIf
		EndIf		
	EndIf	
	
	If Len(aDados) > 0
		aRet :=	UpdB1F3(aDados)
		
		If !aRet[1] 
			cErro := 'Não foram encontradas as contas abaixo : ' + chr(20) + chr(10)
			For nI:=1 to len(aRet[2])
				
				cErro += aRet[2][nI] + chr(20) + chr(10)
		
			Next nI
		EndIf
		
		If	!Empty(cErro) 
			Alert(cErro)
		EndIf
	EndIf
	
	FERASE(cXml) 
	

Return aRet[1]

/*/{Protheus.doc} UpdB1F3
//TODO Atualização nas tabelas conforme planilha importada.
@author alison.goncalves
@since 21/05/2018
@version 1.0
@return ${return}, ${return_description}
@param aDados, array, descricao
@type function
/*/
Static Function UpdB1F3(aDados)
	Local nI	:= 0 
	Local aRet	:= {.T., {}}
	
	DbSelectArea('SB1')
	SB1->(DbSetOrder(1))
	
	DbSelectArea('SFT')
	
	DbSelectArea('CT1')
	CT1->(DbSetorder(1))

	For nI:=1 to len(aDados)
	
		If !Empty(aDados[nI][9]) .AND. UPPER(AllTrim(aDados[nI][2])) == UPPER(AllTrim(SM0->M0_NOME)) 
			If CT1->(DbSeek( xFilial('CT1') + aDados[nI][9] ))

				SFT->(DbGoto(Val(aDados[nI][16])))
				Reclock('SFT',.F.)
					SFT->FT_CONTA := CT1->CT1_CONTA
				SFT->(MsUnlock())
			
				If SB1->(MsSeek(xFilial('SB1')+aDados[nI][10]))
					Reclock('SB1',.F.)
						SB1->B1_CONTA := CT1->CT1_CONTA
					SB1->(MsUnlock())
				EndIF
			Else
				aAdd(aRet[2] , aDados[nI][9])
				aRet[1] := .F.
			EndIf
		EndIf	

	Next nI

Return aRet