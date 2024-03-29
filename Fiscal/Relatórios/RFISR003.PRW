#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

#define FROMF3   "FROM "+RetSQLName("SF3")+" "
#define WHEREF31 "WHERE F3_ENTRADA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_ = '' "
#define WHEREF32 "AND F3_FILIAL = '"+xFilial("SF3")+"' AND SUBSTRING(F3_CFO,2,2) <> '99' AND F3_CFO = FT_CFOP " 
#define WHEREF33 "AND F3_OBSERV NOT LIKE ('%NF CANCELADA%') "

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFISR003  �Autor  �Ivandro Santos      � Data �  12/07/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Lista os valores gravados nas tabelas dos livros fiscais e  ���
���          �notas fiscais entrada e sa�da para comparar os lan�amentos. ���
�������������������������������������������������������������������������͹��
���Uso       � Setor Fiscal -                                             ���
���          � Ticket#2017091337000145									  ���
���          � Conferencia SPED e Registro de apuracao 					  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFISR003()
Local nLastKey 	:= 0
Static cPerg 	:= "ATC010    "
Static _cQuery  := ""

Pergunte(cPerg,.T.)

If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif

MsAguarde({|| MSREFIS3QR() }, OemToAnsi("Somando valores CFOP, Confer�ncia") )
MsAguarde({|| MSREFIS3Pl() }, OemToAnsi("Gerando arquivo de valores CFOP, Confer�ncia") )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSREFIS003QR�Autor  �Microsiga         � Data �  06/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query para an�lise do relat�rio                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RFISR003                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MSREFIS3QR()
                                                                              
If Select("QRN") > 0
	DbSelectArea("QRN")
	DbCloseArea()
EndIf

_cQuery := "SELECT ID3.CFOP,ROUND(ID3.[F3 VALOR CONTABIL],2) 'F3_VALOR',ROUND(ID3.[FT VALOR CONTABIL],2) 'FT_VALOR', "+CRLF
_cQuery += "ROUND(ID3.[DIFEREN�A CONTABIL],2) 'DIF_VALOR', ROUND(ID3.[F3 TOTAL ICM],2) 'F3_ICM', "+CRLF
_cQuery += "CASE WHEN ID3.CFOP < 5000 THEN ("+CRLF
_cQuery += "	SELECT ROUND(SUM(ISNULL(D1_VALICM,0)),2) 'ICM' FROM "+RetSQLName("SD1")+" "+CRLF
_cQuery += "	WHERE D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_ = '' "+CRLF
_cQuery += "		AND D1_FILIAL = '"+xFilial("SD1")+"' AND SUBSTRING(D1_CF,2,2) <> '99' "+CRLF
_cQuery += "		AND D1_CF = ID3.CFOP) ELSE "+CRLF
_cQuery += "	(SELECT ROUND(SUM(ISNULL(D2_VALICM,0)),2) 'ICM' FROM "+RetSQLName("SD2")+" "+CRLF 
_cQuery += "	WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_ = '' "+CRLF
_cQuery += "		AND D2_FILIAL = '"+xFilial("SD2")+"' AND SUBSTRING(D2_CF,2,2) <> '99' "+CRLF
_cQuery += "		AND D2_CF = ID3.CFOP "+CRLF
_cQuery += "GROUP BY D2_CF) END 'D1D2_ICM', "+CRLF
_cQuery += "ROUND(ID3.[FT TOTAL ICM],2) 'FT_ICM',ROUND(ID3.[DIFEREN�A ICM],2) 'DIF_ICM', "+CRLF
_cQuery += "ROUND(ID3.[F3 SOMA IPI],2) 'F3_IPI',ROUND(ID3.[FT SOMA IPI],2) 'FT_IPI', "+CRLF
_cQuery += "CASE WHEN ID3.CFOP < 5000 THEN ("+CRLF
_cQuery += "	SELECT SUM(ISNULL(D1_VALIPI,0)) 'IPI' FROM "+RetSQLName("SD1")+" "+CRLF
_cQuery += "	WHERE D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_ = '' "+CRLF
_cQuery += "		AND D1_FILIAL = '"+xFilial("SD1")+"' AND SUBSTRING(D1_CF,2,2) <> '99' "+CRLF
_cQuery += "		AND D1_CF = ID3.CFOP) ELSE "+CRLF
_cQuery += "	(SELECT SUM(ISNULL(D2_VALIPI,0)) 'IPI' FROM "+RetSQLName("SD2")+" "+CRLF 
_cQuery += "	WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_ = '' "+CRLF
_cQuery += "		AND D2_FILIAL = '"+xFilial("SD2")+"' AND SUBSTRING(D2_CF,2,2) <> '99' "+CRLF
_cQuery += "		AND D2_CF = ID3.CFOP "+CRLF
_cQuery += "GROUP BY D2_CF) END 'D1D2_IPI', "+CRLF
_cQuery += "ROUND(ID3.[DIF_IPI],2) 'DIF_IPI' "+CRLF
_cQuery += "FROM (SELECT FT_CFOP 'CFOP' ,SUM(FT_VALCONT) 'FT VALOR CONTABIL',(SELECT SUM(F3_VALCONT) 'F3 VALOR CONTABIL' "+CRLF
_cQuery += FROMF3+CRLF+WHEREF31+CRLF+WHEREF32+CRLF+WHEREF33+CRLF
_cQuery += "GROUP BY F3_CFO) 'F3 VALOR CONTABIL' , "+CRLF
_cQuery += "ROUND(SUM(FT_VALCONT),2) - ROUND((SELECT SUM(F3_VALCONT) 'F3 VALOR CONTABIL' "+CRLF
_cQuery += FROMF3+CRLF+WHEREF31+CRLF+WHEREF32+CRLF+WHEREF33+CRLF
_cQuery += "GROUP BY F3_CFO),2) 'DIFEREN�A CONTABIL' , "+CRLF
_cQuery += "SUM(FT_VALICM) 'FT TOTAL ICM',(SELECT SUM(F3_VALICM) 'TOTAL ICM' "+CRLF
_cQuery += FROMF3+CRLF+WHEREF31+CRLF+WHEREF32+CRLF+WHEREF33+CRLF
_cQuery += "GROUP BY F3_CFO) 'F3 TOTAL ICM', "+CRLF
_cQuery += "ROUND(SUM(FT_VALICM),2) - ROUND(("+CRLF
_cQuery += "SELECT SUM(F3_VALICM) 'TOTAL ICM' "+CRLF
_cQuery += FROMF3+CRLF+WHEREF31+CRLF+WHEREF32+CRLF+WHEREF33+CRLF
_cQuery += "GROUP BY F3_CFO),2) 'DIFEREN�A ICM', "+CRLF
_cQuery += "SUM(FT_VALIPI) 'FT SOMA IPI', "+CRLF
_cQuery += "(SELECT SUM(F3_VALIPI) "+CRLF
_cQuery += FROMF3+CRLF+WHEREF31+CRLF+WHEREF32+CRLF+WHEREF33+CRLF
_cQuery += "GROUP BY F3_CFO) 'F3 SOMA IPI', "+CRLF
_cQuery += "ROUND(SUM(FT_VALIPI),2) - "+CRLF
_cQuery += "ROUND((SELECT SUM(F3_VALIPI) "+CRLF
_cQuery += FROMF3+CRLF+WHEREF31+CRLF+WHEREF32+CRLF+WHEREF33+CRLF
_cQuery += "GROUP BY F3_CFO),2) 'DIF_IPI' "+CRLF
_cQuery += "FROM "+RetSQLName("SFT")+" "+CRLF
_cQuery += "WHERE FT_ENTRADA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D_E_L_E_T_ = '' "+CRLF
_cQuery += "AND FT_FILIAL = '"+xFilial("SFT")+"' AND SUBSTRING(FT_CFOP,2,2) <> '99' "+CRLF
_cQuery += "AND FT_OBSERV NOT LIKE ('%NF CANCELADA%') "+CRLF
_cQuery += "GROUP BY FT_CFOP) AS ID3 "+CRLF
_cQuery += "ORDER BY ID3.CFOP


DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "QRN", .T., .F. )


Return                  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSRE34Pl  �Autor  �Ivandro Santos      � Data �  06/07/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera planilha com os dados filtrados                       ���
�������������������������������������������������������������������������͹��
���Uso       � RCOMR034                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MSREFIS3Pl()

Local oExcel	:= FWMSEXCEL():New()

oExcel:AddWorkSheet("COMPARA��O")
oExcel:AddTable ("COMPARA��O","VALORES")
oExcel:AddColumn("COMPARA��O","VALORES","CFOP"		 	 ,1,1,.F.)
oExcel:AddColumn("COMPARA��O","VALORES","F3_VALOR"	 	 ,3,2,.T.)
oExcel:AddColumn("COMPARA��O","VALORES","FT_VALOR"	 	 ,3,2,.T.)
oExcel:AddColumn("COMPARA��O","VALORES","DIFERENCA_VALOR",3,2,.F.)
oExcel:AddColumn("COMPARA��O","VALORES","F3_ICM"		 ,3,2,.T.)
oExcel:AddColumn("COMPARA��O","VALORES","FT_ICM"		 ,3,2,.T.)
oExcel:AddColumn("COMPARA��O","VALORES","D1D2_ICM"		 ,3,2,.T.)
oExcel:AddColumn("COMPARA��O","VALORES","DIFEREN�A_ICM"	 ,3,2,.F.)
oExcel:AddColumn("COMPARA��O","VALORES","F3_IPI"		 ,3,2,.T.)
oExcel:AddColumn("COMPARA��O","VALORES","FT_IPI"		 ,3,2,.T.)
oExcel:AddColumn("COMPARA��O","VALORES","D1D2_IPI"		 ,3,2,.F.)
oExcel:AddColumn("COMPARA��O","VALORES","DIFEREN�A_IPI"	 ,3,2,.F.)

DbSelectArea("QRN")
If Select("QRN") > 0
	QRN->(DBGotop())
	While QRN->(!Eof())
		oExcel:AddRow("COMPARA��O","VALORES" ,{	QRN->CFOP	,;
		QRN->F3_VALOR										,;
		QRN->FT_VALOR										,;
		QRN->DIF_VALOR										,;
		QRN->F3_ICM											,;
		QRN->FT_ICM											,;
		QRN->D1D2_ICM										,;
		QRN->DIF_ICM										,;
		QRN->F3_IPI											,;
		QRN->FT_IPI											,;
		QRN->D1D2_IPI										,;
		QRN->DIF_IPI})
		QRN->(dbSkip())
	End
EndIf



oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/RFISR003.xml")

If File("C:/RELATO_MICROSIGA/RFISR003.xml")
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/RFISR003.xml")
	oExcelApp:SetVisible(.T.)
EndIf

Return
