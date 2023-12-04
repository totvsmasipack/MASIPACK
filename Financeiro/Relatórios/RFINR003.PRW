#include "Totvs.ch"
#include "parmtype.ch"
#include "topconn.ch"
#include "RWMAKE.CH"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : RFINR003  			  		| 	Outubro/2023			  		      			     	|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por: Elpídio Lima - DS2U																|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Relatório de faturamento por item da nota fiscal 										|
|-------------------------------------------------------------------------------------------------------|
*/

User Function PRFINR03()

	If !Pergunte("RFINR003",.T.)
		return
	endif


Processa({|| RFINR003() },"Exportando dados para o Excel. Aguarde...")

Return


Static Function RFINR003()
	Local aArea       := GetArea()
	Local oFWMsExcel
	Local oExcel
	Local cQueryA     := "" // Faturamento
    Local cNomearq    := "RFINR003_"+RetCodUsr()+strtran(strtran(DTOC(date()),"/","")+substr(time(),1,5),":","")
    Local cArquivo    := GetTempPath()+cNomearq+'.xml'
	Local cCond		  := ""
	Local cDup        := ""
	Local cLeg        := ""

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return Nil
	EndIf

//Verifica as CFOPs
	If EMPTY(MV_PAR05)
		cCond := "<> ' ' "
	else
		cCond := "IN "+FormatIn(ALLTRIM(MV_PAR05),",")+" "
	endif

//Verifica se as TES geram ou não financeiro
	If cValToChar(MV_PAR06) = "1"
		cDup := "F4.F4_DUPLIC = 'S'"
	Elseif cValToChar(MV_PAR06) = "2"
		cDup := "F4.F4_DUPLIC = 'N'"
	Else 
		cDup := "F4.F4_DUPLIC <> ' '"
	endif

//Complementa da informação dos parametros
	If cValToChar(MV_PAR06) = "1"
		cLeg := "Gera Financeiro"
	Elseif cValToChar(MV_PAR06) = "2"
		cLeg := "Não Gera Financeiro"
	Else 
		cLeg := "Considera Ambas"
	endif

//Imprime os parâmetros
	aParam2 := {"Emissão de: ",MV_PAR01}
	aParam3 := {"Emissão até: ",MV_PAR02}
	aParam4 := {"Cliente de: ",MV_PAR03}
	aParam5 := {"Cliente até: ",MV_PAR04}
	aParam6 := {"CFOPs separados por vírgula",MV_PAR05}
	aParam7 := {"TES gera Faturamento?",cLeg}

		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet("Parâmetros")
		oFWMsExcel:AddTable("Parâmetros","Parâmetros do relatório")
		oFWMsExcel:AddColumn("Parâmetros","Parâmetros do relatório","Parâmetros",1)
		oFWMsExcel:AddColumn("Parâmetros","Parâmetros do relatório","Conteúdo",1)

		If DTOC(aParam2[2]) <> " "
			oFWMsExcel:AddRow("Parâmetros","Parâmetros do relatório",{aParam2[1], aParam2[2]})
			oFWMsExcel:AddRow("Parâmetros","Parâmetros do relatório",{aParam3[1], aParam3[2]})
			oFWMsExcel:AddRow("Parâmetros","Parâmetros do relatório",{aParam4[1], aParam4[2]})
			oFWMsExcel:AddRow("Parâmetros","Parâmetros do relatório",{aParam5[1], aParam5[2]})
			oFWMsExcel:AddRow("Parâmetros","Parâmetros do relatório",{aParam6[1], aParam6[2]})
			oFWMsExcel:AddRow("Parâmetros","Parâmetros do relatório",{aParam7[1], aParam7[2]})
		EndIf

//Monta a consulta
cQueryA 	:= "SELECT	D2.D2_COD PRODUTO, B1.B1_DESC DESCPROD, D2.D2_QUANT QUANT, "
cQueryA 	+= "		D2.D2_VALBRUT VLRBRUTO, D2.D2_CF CFOP, D2.D2_CLIENTE CODCLI,  "
cQueryA 	+= "		D2.D2_LOJA LOJA, A1.A1_NREDUZ NOMCLI, D2.D2_PEDIDO NRPEDIDO,  "
cQueryA 	+= "		D2.D2_DOC NFISCAL, D2.D2_EMISSAO EMISSAO, D2.D2_EST ESTADO,  "
cQueryA 	+= "		C5.C5_NATUREZ CODNAT,ED.ED_DESCRIC DESCNAT "
cQueryA 	+= "	FROM "+RetSQLName("SD2")+" D2 "
cQueryA 	+= "	LEFT JOIN "+RetSQLName("SC5")+" C5 ON C5.C5_NUM = D2.D2_PEDIDO AND C5.D_E_L_E_T_ = ' ' "
cQueryA 	+= "	LEFT JOIN "+RetSQLName("SA1")+" A1 ON 	A1.A1_COD = D2.D2_CLIENTE AND A1.A1_LOJA = D2.D2_LOJA AND A1.D_E_L_E_T_ = ' ' "
cQueryA 	+= "	LEFT JOIN "+RetSQLName("SED")+" ED ON ED.ED_CODIGO = C5.C5_NATUREZ AND ED.D_E_L_E_T_ = ' ' "
cQueryA 	+= "	LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1.B1_COD = D2.D2_COD AND B1.D_E_L_E_T_ = ' ' "
cQueryA 	+= "	INNER JOIN "+RetSQLName("SF4")+" F4 ON F4.F4_CODIGO = D2.D2_TES AND F4.D_E_L_E_T_ = ' ' "	
cQueryA 	+= "WHERE D2.D_E_L_E_T_ = ' ' "
cQueryA 	+= "AND D2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " 
cQueryA 	+= "AND D2.D2_CF "+cCond+" AND "+cDup+" "
cQueryA 	+= "ORDER BY D2.D2_EMISSAO, C5.C5_NATUREZ, A1.A1_COD "

TCQuery cQueryA New Alias "QRYA"

	DbSelectArea("QRYA")
	DBgotop()

//Imprime a consulta
	oFWMsExcel:AddworkSheet("Faturamento")
	oFWMsExcel:AddTable("Faturamento","Faturamento")
	oFWMsExcel:AddColumn("Faturamento","Faturamento","PRODUTO",1)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","DESCRICAO DO PRODUTO",1)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","QUANTIDADE",3)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","VALOR BRUTO",2,3)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","CFOP",1)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","COD DO CLIENTE",3)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","LOJA",3)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","NOME DO CLIENTE",1)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","No. DO PEDIDO",3)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","NOTA FISCAL",3)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","DT EMISSAO",1)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","ESTADO",1)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","COD NATUREZA",3)
	oFWMsExcel:AddColumn("Faturamento","Faturamento","DESCR NATUREZA",1)

	While !(QRYA->(EoF()))

		oFWMsExcel:AddRow("Faturamento","Faturamento",{;
			QRYA->PRODUTO,;
			QRYA->DESCPROD,;
			QRYA->QUANT,;
			QRYA->VLRBRUTO,; 
			QRYA->CFOP,;
            QRYA->CODCLI,;
			QRYA->LOJA,;
			QRYA->NOMCLI,; 
			QRYA->NRPEDIDO,;
            QRYA->NFISCAL,;
			STOD(QRYA->EMISSAO),;
			QRYA->ESTADO,;
			QRYA->CODNAT,;
			QRYA->DESCNAT})

		QRYA->(DbSkip())

    EndDo

		QRYA->(DbCloseArea())
	
//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()             //Abre uma nova conexÃ£o com Excel
		oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
		oExcel:SetVisible(.T.)              //Visualiza a planilha
		oExcel:Destroy()                     //Encerra o processo do gerenciador de tarefas

		RestArea(aArea)
		Return
