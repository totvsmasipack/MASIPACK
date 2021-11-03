#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa: RPCPR032
Autor: Ivandro Santos 
Data: 26/11/15
Alterado por Proativa Molina
Data: 12/02/19
Gera arquivo de estruturas para o Catalogo Eletronico
*/ 

User Function RPCPR032() 
	Local _cNomArq	:= "Estruturas_versao" + DTOS(dDatabase)
	Local _cArqSG1 	:= "C:\relato_microsiga\" + _cNomArq + ".CSV"
	Local _cQuery  	:= ""
	Local _cQuer1  	:= ""
	Local _cQuer2  	:= ""

	// Cria arquivo de Trabalho 
	_cQuer1 := 	"SELECT CASE WHEN RTRIM(LTRIM(G1_COD)) = 'MAQUINAS' THEN '' ELSE G1_COD END G1_COD, " +;
					"CASE WHEN RTRIM(LTRIM(G1_COD)) = 'MAQUINAS' THEN '' ELSE " +;
						"CASE WHEN RTRIM(LTRIM(SB5.B5_CEME)) = '' THEN RTRIM(LTRIM(SB1.B1_DESC)) ELSE RTRIM(LTRIM(SB5.B5_CEME)) END END B1_DESC, " +;
					"RTRIM(LTRIM(G1_COMP)) G1_COMP, " +;
					"CASE WHEN RTRIM(LTRIM(SB5C.B5_CEME)) = '' THEN RTRIM(LTRIM(SB1C.B1_DESC)) ELSE RTRIM(LTRIM(SB5C.B5_CEME)) END DESC_COMP, " +;
					"CASE WHEN RTRIM(LTRIM(SB1.B1_MSESCOL)) = '' THEN 'N' ELSE SB1.B1_MSESCOL END B1_MSESCOL, " +;
					"'MASIPACK' AS EMPRESA " +;
				"FROM SG1010 SG1 " +;
				"INNER JOIN SB1010 SB1 ON SG1.G1_COD = SB1.B1_COD " +;
					"AND SB1.D_E_L_E_T_ = '' " +;
				"LEFT JOIN SB5010 SB5 ON SB1.B1_COD = SB5.B5_COD " +;
					"AND SB5.D_E_L_E_T_ = '' " +;
				"INNER JOIN SB1010 SB1C ON SG1.G1_COMP = SB1C.B1_COD " +;
					"AND SB1C.D_E_L_E_T_ = '' " +;				
				"LEFT JOIN SB5010 SB5C ON SB1C.B1_COD = SB5C.B5_COD " +;
					"AND SB5C.D_E_L_E_T_ = '' " +;
				"WHERE SB1.B1_MSNCONS = 'S' AND SB1C.B1_MSNCONS = 'S' " +;
					"AND SG1.D_E_L_E_T_ = '' "
									
	_cQuer2 := 	"SELECT CASE WHEN RTRIM(LTRIM(G1_COD)) = 'MAQUINAS' THEN '' ELSE G1_COD END G1_COD, " +;
					"CASE WHEN RTRIM(LTRIM(G1_COD)) = 'MAQUINAS' THEN '' ELSE " +;
					"CASE WHEN RTRIM(LTRIM(SB5.B5_CEME)) = '' THEN RTRIM(LTRIM(SB1.B1_DESC)) ELSE RTRIM(LTRIM(SB5.B5_CEME)) END END B1_DESC, " +;
					"RTRIM(LTRIM(G1_COMP)) G1_COMP, " +;
					"CASE WHEN RTRIM(LTRIM(SB5C.B5_CEME)) = '' THEN RTRIM(LTRIM(SB1C.B1_DESC)) ELSE RTRIM(LTRIM(SB5C.B5_CEME)) END DESC_COMP, " +;
					"CASE WHEN RTRIM(LTRIM(SB1.B1_MSESCOL)) = '' THEN 'N' ELSE SB1.B1_MSESCOL END B1_MSESCOL, " +;
					"'FABRIMA' AS EMPRESA " +;
				"FROM SG1100 SG1 " +;
				"INNER JOIN SB1100 SB1 ON SG1.G1_COD = SB1.B1_COD " +;
					"AND SB1.D_E_L_E_T_ = '' " +;
				"LEFT JOIN SB5100 SB5 ON SB1.B1_COD = SB5.B5_COD " +;
					"AND SB5.D_E_L_E_T_ = '' " +;
				"INNER JOIN SB1100 SB1C ON SG1.G1_COMP = SB1C.B1_COD " +;
					"AND SB1C.D_E_L_E_T_ = '' " +;			
				"LEFT JOIN SB5100 SB5C ON SB5C.B5_COD = SB1C.B1_COD " +;
					"AND SB5C.D_E_L_E_T_ = '' " +;
				"WHERE SB1.B1_MSNCONS = 'S' AND SB1C.B1_MSNCONS = 'S' " +;
					"AND SG1.D_E_L_E_T_ = '' "
				
	_cQuery := _cQuer1 + " UNION ALL " + _cQuer2 + " ORDER BY EMPRESA DESC, G1_COD, G1_COMP"

	// Executa QUERY
	_cQuery := ChangeQuery(_cQuery)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), "TMP", .T., .T.)

	// Arquivo
	_cArqSG1 := FCreate("C:\relato_microsiga\" + _cNomArq + ".Csv")

	If (_cArqSG1 == -1)
		Alert("Arquivo nao pode ser criado")
		Break
	Else
		//Exportacao de dados para app da OiC
		FWrite(_cArqSG1, "Produto_ID;Desc_Produto;Componente;Desc_Componente;Permite Múltipla Escolha;Origem")
		
		TMP->(DBGOTOP())	
			Do While !TMP->(Eof())
				_cArqLinha := Chr(13) + Chr(10) +;
					OemToAnsi(AllTrim(TMP->G1_COD)) + ";" +;
					AllTrim(TMP->B1_DESC) + ";" +;
					OemToAnsi(AllTrim(TMP->G1_COMP)) + ";" +;
					AllTrim(TMP->DESC_COMP) + ";" +;
					AllTrim(TMP->B1_MSESCOL) + ";" +;
					AllTrim(TMP->EMPRESA)
			  
				FWrite(_cArqSG1, _cArqLinha)   
				TMP->(DbSkip())
			EndDo
			
			FClose(_cArqSG1) 
		TMP->(dbCloseArea())

	Endif

Return
