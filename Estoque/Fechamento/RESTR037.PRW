#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} RESTR036
//TODO Relatório de divergencia de conta contabil e local produtivo e improdutivo
@author alison.goncalves
@since 13/08/2018
@version 1.0
@return Nil
@type function
/*/

User Function RESTR037()
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
	
	SELECT	B1_COD,
	B1_DESC,
	B1_LOCPAD,
	B1_LOCAL,
	B1_PROCED,
	B1_CONTA,
	ISNULL((SELECT B2_QATU FROM %TABLE:SB2% SB2  (NOLOCK) WHERE  SB2.B2_COD = SB1.B1_COD AND  SB2.B2_LOCAL = '01' AND  SB2.%NOTDEL%),0) AS QUANT_01,
	ISNULL((SELECT B2_QATU FROM %TABLE:SB2% SB22 (NOLOCK) WHERE SB22.B2_COD = SB1.B1_COD AND SB22.B2_LOCAL = '10' AND SB22.%NOTDEL%),0) AS QUANT_10
	FROM %TABLE:SB1% SB1 (NOLOCK)
	WHERE	B1_FILIAL = '01' AND
	(	(B1_PROCED LIKE '%P' AND B1_LOCPAD <> '01' )
	OR
	(B1_PROCED LIKE '%N' AND B1_LOCPAD <> '10' )
	OR
	(B1_CONTA LIKE '330%'  AND B1_LOCPAD <> '01')
	OR
	(B1_CONTA LIKE '112%'  AND B1_LOCPAD <> '01')
	OR
	(B1_CONTA NOT LIKE '112%' AND B1_CONTA NOT LIKE '330%' AND B1_LOCPAD <> '10')
	)
	AND
	SB1.%NOTDEL%
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
Static Function GeraPla(cNextAls)
Local cFile 	:= 'C:/RELATO_MICROSIGA/' + Upper(AllTrim(SM0->M0_NOME))	+	'_'	+ ALLTRIM(DTOS(DATE())) + '_' + AllTrim(StrTran(TIME(),':','')) + '_RESTR037.xml'
Local oExcel 	:= FWMSEXCEL():New()

oExcel:AddWorkSheet	("Divergencias"																)
oExcel:AddTable		("Divergencias"	,"Conta Contabil x locais"									)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Codigo"				,1,1,.F.)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Descrição"			,1,1,.F.)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Local padrão"			,1,1,.F.)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Local especifico"		,1,1,.F.)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Procedencia"			,1,1,.F.)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Conta contabil"		,1,1,.F.)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Quant local 01"		,1,2,.F.)
oExcel:AddColumn	("Divergencias"	,"Conta Contabil x locais"	,"Quant local 10"		,1,2,.F.)

//Alimento a primeira Query
(cNextAls)->(dbGoTop())
While (cNextAls)->(!EOF())
	oExcel:AddRow("Divergencias","Conta Contabil x locais",{	AllTrim((cNextAls)->B1_COD)		,;
	AllTrim((cNextAls)->B1_DESC)	,;
	AllTrim((cNextAls)->B1_LOCPAD)	,;
	AllTrim((cNextAls)->B1_LOCAL)	,;
	AllTrim((cNextAls)->B1_PROCED)	,;
	AllTrim((cNextAls)->B1_CONTA)	,;
	(cNextAls)->QUANT_01			,;
	(cNextAls)->QUANT_10			;
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
