#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function A410RNF
Função para aplicar um filtro na query utilizada para identificar NFs de Entrada
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/11/2021
@version version
@param param_name, param_type, param_descr
@return 
		cRet,	VarChar,	Retorna o filtro específico para ser utilizado na query
@see https://tdn.totvs.com/pages/releaseview.action?pageId=623896913
/*/
User Function A410RNF()

	Local cRet		:= ""

	Local dDataDe	:= PARAMIXB[1]	//Data Inicial - Tipo: Data - Formato: dd/mm/aaaa
	Local dDataAte	:= PARAMIXB[2]	//Data Final - Tipo: Data - Formato: dd/mm/aaaa
	Local lForn		:= PARAMIXB[3]	//Fornecedor (.T.) ou Cliente (.F.) - Tipo: Lógico
//	Local lFornece	:= PARAMIXB[4]	//Fornecedor (.T.) ou Documento (.F.) - Tipo: Lógico

	lMantemQry := .T.

	cRet := " SF1->F1_FILIAL == '" + xFilial("SF1") + "' .And. "
	cRet += "SF1->F1_FORNECE == '" + cFornece + "' .And. "
	cRet += "SF1->F1_LOJA == '" + cLoja + "' .And. "
	cRet += "DtoS(SF1->F1_DTDIGIT) >= '" + DtoS(dDataDe) + "' .And."
	cRet += "DtoS(SF1->F1_DTDIGIT) <= '" + DtoS(dDataAte) + "' .And. "
	cRet += "!(SF1->F1_STATUS  == '" + Space(Len(SF1->F1_STATUS)) + "' ) .And. "
	
	If lForn
		cRet += "!(SF1->F1_TIPO $ 'DB') "
	Else
		cRet += "SF1->F1_TIPO $ 'DB' "
	EndIf
		
Return cRet
