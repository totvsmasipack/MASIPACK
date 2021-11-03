#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} RESTR031
//TODO Descrição: Relatorio de quantidade em estoque por produto ou local.
@author Victor Dessunte
@since 03/23/17
@version 1.0
@return Nil
@type function
/*/
User Function RESTR031()

Local _cQry := ""

If !Pergunte("RESTR031")
	Return
EndIf

LjMsgRun("Aguarde... Gerando planilha...",,{||RESTR31A()})

/*/{Protheus.doc} RESTR31A
//TODO Descrição: Geração do arquivo XML.
@author victor.dessunte
@since 03/23/2017
@version 1.0
@return Nil
@type function
/*/
Static Function RESTR31A()

Local oExcel		:= FWMSEXCEL():New()

oExcel:AddWorkSheet("Produtos")
oExcel:AddTable("Produtos","Produtos por Local")
oExcel:AddColumn("Produtos","Produtos por Local","Código"		,1,1,.F.)
oExcel:AddColumn("Produtos","Produtos por Local","Descrição"	,1,1,.F.)
oExcel:AddColumn("Produtos","Produtos por Local","Local"			,1,1,.F.)
oExcel:AddColumn("Produtos","Produtos por Local","Quantidade"	,3,2,.F.)

_cQry := " SELECT " + CRLF
_cQry += "		B1_COD, " + CRLF
_cQry += "		B1_DESC, " + CRLF
_cQry += "		B1_LOCAL, " + CRLF
_cQry += "		B2_QATU " + CRLF
_cQry += "	FROM " + CRLF
_cQry += 		RetSqlName("SB1") + " B1 INNER JOIN " + RetSqlName("SB2") + " B2 " + CRLF
_cQry += "		ON	B2.D_E_L_E_T_	= '' " + CRLF
_cQry += "		AND B2_FILIAL		= '" + xFilial("SB2") + "' " + CRLF
_cQry += "		AND B2_COD			= B1_COD " + CRLF
_cQry += "		AND B2_LOCAL		= B1_LOCPAD " + CRLF
_cQry += "	WHERE " + CRLF
_cQry += "			B1.D_E_L_E_T_	= ' ' " + CRLF
_cQry += "	AND 	B1_FILIAL		= '" + xFilial("SB1") + "' " + CRLF
_cQry += "	AND 	B1_COD			BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF
_cQry += "	AND 	B1_LOCAL			LIKE '" + AllTrim(MV_PAR03) + "%' " + CRLF
_cQry += "	ORDER BY 1"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

dbSelectArea("TRB")
TRB->(dbGoTop())
While TRB->(!EOF())
	oExcel:AddRow("Produtos","Produtos por Local",{	TRB->B1_COD		,;//01-CODIGO
																	TRB->B1_DESC	,;//02-DESCRICAO
																	TRB->B1_LOCAL	,;//03-LOCAL
																	TRB->B2_QATU	})//04-SALDO EM ESTOQUE
	TRB->(dbSkip())
End

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/RESTR031.xml")

If File("C:/RELATO_MICROSIGA/RESTR031.xml")
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/RESTR031.xml")
	oExcelApp:SetVisible(.T.)
EndIf

Return
