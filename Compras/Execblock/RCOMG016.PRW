#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} User Function RCOMG016
Gatilho utilizado no campo C7_PRODUTO para retornar o último preço de compra.
@type  Function
@author E.DINIZ - [ DS2U ]
@since 12/01/2022
/*/
User Function RCOMG016()

Local _cQry		:= ''
Local _cTRB		:= ''
Local _aArea	:= {SB1->(GetArea())}
Local _nRet		:= 0

	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(FWxFilial("SB1")+M->C7_PRODUTO))
	
	If SB1->(FOUND()) .And. SB1->B1_UPRC > 0
		
		_nRet := SB1->B1_UPRC

	Else

		_cTRB := GetNextAlias()
		_cQry := "SELECT " + CRLF 
		_cQry += "	COALESCE(( SELECT TOP 1 C7_PRECO " + CRLF
		_cQry += "		FROM	"+RetSQLName('SC7') +" C7 " + CRLF
		_cQry += "		WHERE	C7_FILIAL		= '"+FWxFilial('SC7')+"'" + CRLF
		_cQry += "				AND C7_PRODUTO	= '"+M->C7_PRODUTO+"'	" + CRLF
		_cQry += "				--AND C7_NUM	<> '"+cA120Num+"'		" + CRLF
		_cQry += "				AND C7_RESIDUO	= ' ' 	" + CRLF
		_cQry += "				AND D_E_L_E_T_	= ' '	" + CRLF
		_cQry += "		ORDER BY C7_EMISSAO DESC  " + CRLF
		_cQry += "	),0 ) [ULTPRC]  " + CRLF

		TCQuery _cQry New Alias (_cTRB)

		_nRet := (_cTRB)->ULTPRC

		(_cTRB)->(dbCloseArea())

	Endif

	AEval(_aArea,{|x| RestArea(x) })

Return _nRet
