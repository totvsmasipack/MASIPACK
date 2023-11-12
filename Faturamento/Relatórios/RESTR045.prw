#include "Totvs.ch"
#include "parmtype.ch"
#include "topconn.ch"
#include "RWMAKE.CH"


/*
|-------------------------------------------------------------------------------------------------------|
|	Programa :  RESTR045	  		| 	 Outubro/2023			  		      			     			|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por: Elp�dio Lima      										                        |
|-------------------------------------------------------------------------------------------------------|
|	Descri��o : Relat�rio reposi��o da Loja	- USO EXCLUSIVO HELSIM										|
|-------------------------------------------------------------------------------------------------------|
*/

User Function PRESTR45()

If !Pergunte("RESTR045",.T.)
	return
endif

Processa({|| RESTR045() },"Exportando dados para o Excel. Aguarde...")

Return


Static Function RESTR045()
	Local aArea       := GetArea()
	Local oFWMsExcel
	Local oExcel
	Local cQueryA     := "" 
    Local cNomearq    := "RESTR045_"+RetCodUsr()+strtran(strtran(DTOC(date()),"/","")+substr(time(),1,5),":","")
    Local cArquivo    := GetTempPath()+cNomearq+'.xml'


	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel n�o instalado!")
		Return Nil
	EndIf

/*
If !Pergunte("RESTR045",.T.)
	return
endif
*/

//Imprime os par�metros
	aParam1 := {"Filial de: ",MV_PAR01}
	aParam2 := {"Filial at�: ",MV_PAR02}
	aParam3 := {"Armaz�m de: ",MV_PAR03}
	aParam4 := {"Armaz�m at�: ",MV_PAR04}
	aParam5 := {"Produto de: ",MV_PAR05}
	aParam6 := {"Produto at�: ",MV_PAR06}
	aParam7 := {"Grupo de: ",MV_PAR07}
	aParam8 := {"Grupo at�: ",MV_PAR08}


		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet("Par�metros")
		oFWMsExcel:AddTable("Par�metros","Par�metros do relat�rio")
		oFWMsExcel:AddColumn("Par�metros","Par�metros do relat�rio","PERGUNTA",1)
		oFWMsExcel:AddColumn("Par�metros","Par�metros do relat�rio","CONTE�DO",1)

		If aParam6[2] <> " "
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam1[1], aParam1[2]})
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam2[1], aParam2[2]})
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam3[1], aParam3[2]})
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam4[1], aParam4[2]})
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam5[1], aParam5[2]})
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam6[1], aParam6[2]})
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam7[1], aParam7[2]})
			oFWMsExcel:AddRow("Par�metros","Par�metros do relat�rio",{aParam8[1], aParam8[2]})
		EndIf

//Monta a consulta

cQueryA 	:= "SELECT 	B2.B2_FILIAL, B2.B2_COD, " 
cQueryA 	+= "		B1.B1_DESC, B2.B2_LOCAL, B1.B1_GRUPO, "
cQueryA 	+= "		NR.NNR_DESCRI, B2.B2_QATU, BZ.BZ_EMIN, "
cQueryA 	+= "		B2.B2_QATU-BZ.BZ_EMIN AS DIFERENCA "
cQueryA 	+= "	FROM "+RetSQLName("SB2")+" B2 "
cQueryA 	+= "    LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1.B1_COD = B2.B2_COD AND B1.D_E_L_E_T_ = ' ' "
cQueryA 	+= "    LEFT JOIN "+RetSQLName("NNR")+" NR ON NNR_CODIGO = B2.B2_LOCAL AND NR.D_E_L_E_T_ = ' ' "
cQueryA 	+= "    INNER JOIN "+RetSQLName("SBZ")+" BZ ON BZ.BZ_COD = B2.B2_COD AND BZ.D_E_L_E_T_ = ' ' "
cQueryA 	+= "    WHERE B2.D_E_L_E_T_ = ' ' "
cQueryA 	+= "    AND B2.B2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQueryA 	+= "    AND B2.B2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQueryA 	+= "    AND B2.B2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQueryA 	+= "    AND B1.B1_GRUPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "

TCQuery cQueryA New Alias "QRYA"

	DbSelectArea("QRYA")
	DBgotop()

	oFWMsExcel:AddworkSheet("Produtos")
	oFWMsExcel:AddTable("Produtos","Produtos")
	oFWMsExcel:AddColumn("Produtos","Produtos","FILIAL",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","C�DIGO DO PRODUTO",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","DESCRI��O",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","GRUPO",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","ARMAZ�M",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","NOME DO ARMAZ�M",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","QTDE. ATUAL",3)
	oFWMsExcel:AddColumn("Produtos","Produtos","PONTO DE PEDIDO",3)
	oFWMsExcel:AddColumn("Produtos","Produtos","DIFEREN�A",3)
	oFWMsExcel:AddColumn("Produtos","Produtos","DATA",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","HORA",1)
	oFWMsExcel:AddColumn("Produtos","Produtos","USU�RIO",1)

	While !(QRYA->(EoF()))

		oFWMsExcel:AddRow("Produtos","Produtos",{;
			QRYA->B2_FILIAL,;
			QRYA->B2_COD,;
			QRYA->B1_DESC,;
			QRYA->B1_GRUPO,;
			QRYA->B2_LOCAL,; 
			QRYA->NNR_DESCRI,;
            QRYA->B2_QATU,;
			QRYA->BZ_EMIN,;
			QRYA->DIFERENCA,; 
			DTOC(DATE()),;
			TIME(),;
			UPPER(UsrRetName(RetCodUsr()))})


			

		QRYA->(DbSkip())

    EndDo

		QRYA->(DbCloseArea())


		
//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
		oExcel:SetVisible(.T.)              //Visualiza a planilha
		oExcel:Destroy()                     //Encerra o processo do gerenciador de tarefas

		RestArea(aArea)
		Return
