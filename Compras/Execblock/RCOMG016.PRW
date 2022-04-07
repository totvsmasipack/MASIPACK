#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'

/*/{Protheus.doc} User Function RCOMG016
	Gatilho utilizado no campo C7_PRODUTO para retornar o último preço de compra.
@type  Function
@author E.DINIZ - [ DS2U ]
@since 12/01/2022
/*/
User Function RCOMG016( uProd )

Local _cTRB		:= ''
Local _aArea	:= {SB1->(GetArea())}
Local _nRet		:= 0

Default uProd	:= M->C7_PRODUTO

	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(FWxFilial("SB1") + PadR(uProd, TamSX3('B1_COD')[1])))
	
	If SB1->(FOUND()) .And. SB1->B1_UPRC > 0
		_nRet := SB1->B1_UPRC
	Else
		_cTRB := GetNextAlias()
		BeginSQL Alias _cTRB
			SELECT TOP 1 COALESCE(C7_PRECO,0) [ULTPRC] FROM %Table:SC7% SC7 WHERE SC7.C7_FILIAL = %xFilial:SC7% AND SC7.C7_PRODUTO = %Exp:uProd% AND SC7.C7_RESIDUO = %Exp:''% AND SC7.%NOTDEL% ORDER BY R_E_C_N_O_ DESC
		EndSQL
		_nRet := (_cTRB)->ULTPRC
		(_cTRB)->(dbCloseArea())
	Endif

	AEval(_aArea,{|x| RestArea(x) })

Return _nRet
