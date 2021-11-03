#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

/*/{Protheus.doc} RESTR029
//TODO Descrição: Relatório para extrair as pré-notas lançadas pelo setor do almoxarifado baseado no usuï¿½rio.  
@author Felipe Freitas
@since 02/10/2019
@version 1.0
@return Nil
@type function
/*/

User Function RESTR029()

	If MsgYesNo("Iniciar o processamento do relatório?")
		MsAguarde({|| MSRE29QR() }, OemToAnsi("Analisando dados de Notas, Notas para Fiscal") )
		Processa( {|| MSRE29Pl() }, "Aguarde", OemToAnsi("Gerando arquivo XML das Notas, Planilha para Fiscal"),.F.)
	Endif

Return

// Monta a query para análise do relatório
Static Function MSRE29QR()

Static _cDaHoLan := GetMv("MS_DAHOLAN")
Static _cUsuario := GetMv("MS_USLANPN")
Static _cHora	 := TIME()


	If Select("QRN") > 0
		DbSelectArea("QRN")
		DbCloseArea()
	EndIf

	_cQuery := "SELECT "
	_cQuery += "CASE WHEN F1_ESPECIE = 'NFS' THEN 'NFS' ELSE 'COM' END TIPO, "
	_cQuery += "CASE WHEN F1_TIPO IN ('N','C','I','P') THEN A2_NOME ELSE A1_NOME END NOME, "
	_cQuery += "F1_USERLGI USUARIO, "
	_CQuery += "F1_DOC, "
	_CQuery += "F1_DTDIGIT, "
	_CQuery += "F1_HORA, "
	_CQuery += "COUNT(D1.R_E_C_N_O_) QT_ITENS "
	_cQuery += "FROM "+RetSqlName("SF1")+" F1 "
	_cQuery += "LEFT JOIN "+RetSqlName("SA2")+" A2 ON F1_FORNECE+F1_LOJA = A2_COD+A2_LOJA AND A2_MSBLQL <> '1' AND A2.D_E_L_E_T_ = '' AND F1_TIPO IN ('N','C','I','P') "
	_cQuery += "LEFT JOIN "+RetSqlName("SA1")+" A1 ON F1_FORNECE+F1_LOJA = A1_COD+A1_LOJA AND A1_MSBLQL <> '1' AND A1.D_E_L_E_T_ = '' AND F1_TIPO IN ('D','B') "
	_cQuery += "INNER JOIN "+RetSqlName("SD1")+" D1 ON D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE = F1_FORNECE+F1_LOJA+F1_DOC+F1_SERIE AND D1.D_E_L_E_T_ = '' "
	_cQuery += "WHERE "
	_cQuery += "F1_STATUS NOT IN ('A') "
	_cQuery += "AND F1.D_E_L_E_T_ = '' " 
	_cQuery += "AND F1_USERLGI <> '' "
	_cQuery += "AND D1_DTFISC+SUBSTRING(F1_HORA,1,2)+SUBSTRING(F1_HORA,4,2) > '"+_cDaHoLan+"' "
	_cQuery += "GROUP BY F1_ESPECIE, F1_TIPO, A2_NOME, A1_NOME, F1_USERLGI, F1_DOC, F1_DTDIGIT, F1_HORA "
	_cQuery += "ORDER BY F1.F1_DTDIGIT, F1.F1_HORA"
	MPSysOpenQuery(_cQuery,"QRN")

Return                  

// Gera planilha com os dados filtrados
Static Function MSRE29Pl()

Local oExcel	:= FWMSEXCEL():New()
Local _aNF		:= {}

	oExcel:AddWorkSheet("FISCAL")
	oExcel:AddTable ("FISCAL","CONTROLE DE NF'S QUE SUBIRAM PARA O FISCAL")
	oExcel:AddColumn("FISCAL","CONTROLE DE NF'S QUE SUBIRAM PARA O FISCAL","XML"	,2,1,.F.)
	oExcel:AddColumn("FISCAL","CONTROLE DE NF'S QUE SUBIRAM PARA O FISCAL","FORNECEDOR"		 ,2,1,.F.)
	oExcel:AddColumn("FISCAL","CONTROLE DE NF'S QUE SUBIRAM PARA O FISCAL","NOTA FISCAL"	 ,2,1,.F.)
	oExcel:AddColumn("FISCAL","CONTROLE DE NF'S QUE SUBIRAM PARA O FISCAL","ITENS",2,1,.F.)

	DbSelectArea("QRN")
	If Select("QRN") > 0
		QRN->(DBGotop())
		ProcRegua(QRN->(LASTREC()))
		While QRN->(!Eof())
			IncProc()
			_nRet := Ascan(_aNF,QRN->F1_DOC,1)
			If _nRet == 0
				AADD(_aNF,QRN->F1_DOC)
				If !Empty(Alltrim(QRN->USUARIO)) .AND. Alltrim(SUBSTR(EMBARALHA(QRN->USUARIO,1),3,6)) $ _cUsuario
					oExcel:AddRow("FISCAL","CONTROLE DE NF'S QUE SUBIRAM PARA O FISCAL" ,{	QRN->TIPO				,;
					QRN->NOME				,;
					QRN->F1_DOC				,;
					QRN->QT_ITENS})
				EndIf
			EndIf                      
			QRN->(dbSkip())
		End
		PutMv("MS_DAHOLAN",DtoS(Date())+Substr(_cHora,1,2)+Substr(_cHora,4,2))
	EndIf

	oExcel:Activate()
	oExcel:GetXMLFile("C:/RELATO_MICROSIGA/RESTR029.xml")

	If File("C:/RELATO_MICROSIGA/RESTR029.xml")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/RESTR029.xml")
		oExcelApp:SetVisible(.T.)
	EndIf

Return
