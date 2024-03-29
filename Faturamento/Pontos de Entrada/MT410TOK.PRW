#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} User Function MT410TOK
Este ponto de entrada � executado ao clicar no bot�o OK e pode ser usado para validar a confirma��o das opera��es: incluir,  alterar, copiar 
e excluir.Se o ponto de entrada retorna o conte�do .T., o sistema continua a opera��o, caso contr�rio, volta para a tela do pedido.
@type  Function
@author Masipack
@since 17/12/2019
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784353
/*/
User Function MT410TOK()

Local aUsrInf	:= FWSFALLUSERS({__cUserId},{"USR_DEPTO"})
Local lRet 		:= .T.
Local _cConta	:= Posicione('SED',1,xFilial('SED')+M->C5_NATUREZ, 'ED_CONTA')
Local _nX		:= 0

	//*******************************
	//* Valida a tabela de pre�o	*
	//*******************************
	If !(M->C5_TABELA == "900") .And. ( (M->C5_CLIENTE == "006018" .And. cEmpAnt == "01") .OR. (M->C5_CLIENTE == "999999" .And. cEmpAnt == "10") )
		lRet := .F.
		Help(NIL, NIL, "TABERRO", NIL, "Tabela de pre�o divergente!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe a tabela 900 para opera��es Intercompany"})
	Endif

	//*******************************
	//* Valida o valor da multa		*
	//*******************************
	If lRet .And. cEmpAnt $ "01|10" .And. Empty(M->C5_MSMULTA) .And. M->C5_MSCATEG == "1"
		lRet := .F.
		Help(NIL, NIL, "VLMULTA", NIL, "Valor da multa n�o informado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Para a Categoria 'Comercial' � obrigat�rio informar o valor da multa."})
	Endif

	//*******************************
	//* Valida a garantia			*
	//*******************************
	If lRet .And. cEmpAnt == "01" .And. Empty(M->C5_MSINIGA) .And. M->C5_MSCATEG == "1"
		lRet := .F.
		Help(NIL, NIL, "INIGARAN", NIL, "In�cio da garantia n�o informado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Para a Categoria 'Comercial' � obrigat�rio informar o in�cio da garantia."})
	Endif

	//*******************************************
	//* Valida a data da conclus�o da montagem	*
	//*******************************************
	If lRet .And. cEmpAnt == "01" .And. !Empty(M->C5_MSCONCL) .And. !("FISCAL" $ Upper(Alltrim(aUsrInf[1][3])))
		lRet := .F.
		Help(NIL, NIL, "MONTENCER", NIL, "Pedido atendido pela montagem", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
	Endif


	//***********************************************************************************************************************************
	//* Valida a Conta Contabil dos itens, Mesmo que o Usu�rio tenha alterado somente a Natureza do Pedido, sem o  gatilho do Produto	*
	//***********************************************************************************************************************************
	If AllTrim(cNumEmp) = "1501"
		For _nX := 1 to Len(aCols)
			If AllTrim(aCols[_Nx,106]) <> AllTrim(_cConta)
				aCols[_Nx,106] := _cConta
			EndIf
		Next
	EndIf

	//*******************************************
	//* Valida��o da existencia de pedidos APV	*
	//*******************************************
	/*
	dbSelectArea("SZM")
	SZM->(DbSetOrder(1))
	If SZM->(dbSeek(xFilial("SZM") + M->C5_NUM))
		If !(M->C5_CLIENTE + M->C5_LOJACLI == SZM->ZM_CODCLI + SZM->ZM_LOJACLI)
			lRet := .F.
			Help(NIL, NIL, "ALTPEDAPV", NIL, "Altera��o n�o permitida, pois j� existe APV para este pedido.", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
		Endif
	Endif
	*/

Return lRet
