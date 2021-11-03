#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} User Function MT410TOK
Este ponto de entrada é executado ao clicar no botão OK e pode ser usado para validar a confirmação das operações: incluir,  alterar, copiar 
e excluir.Se o ponto de entrada retorna o conteúdo .T., o sistema continua a operação, caso contrário, volta para a tela do pedido.
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

	//*******************************
	//* Valida a tabela de preço	*
	//*******************************
	If !(M->C5_TABELA == "900") .And. ( (M->C5_CLIENTE == "006018" .And. cEmpAnt == "01") .OR. (M->C5_CLIENTE == "999999" .And. cEmpAnt == "10") )
		lRet := .F.
		Help(NIL, NIL, "TABERRO", NIL, "Tabela de preço divergente!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe a tabela 900 para operações Intercompany"})
	Endif

	//*******************************
	//* Valida o valor da multa		*
	//*******************************
	If lRet .And. cEmpAnt $ "01|10" .And. Empty(M->C5_MSMULTA) .And. M->C5_MSCATEG == "1"
		lRet := .F.
		Help(NIL, NIL, "VLMULTA", NIL, "Valor da multa não informado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Para a Categoria 'Comercial' é obrigatório informar o valor da multa."})
	Endif

	//*******************************
	//* Valida a garantia			*
	//*******************************
	If lRet .And. cEmpAnt == "01" .And. Empty(M->C5_MSINIGA) .And. M->C5_MSCATEG == "1"
		lRet := .F.
		Help(NIL, NIL, "INIGARAN", NIL, "Início da garantia não informado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Para a Categoria 'Comercial' é obrigatório informar o início da garantia."})
	Endif

	//*******************************************
	//* Valida a data da conclusão da montagem	*
	//*******************************************
	If lRet .And. cEmpAnt == "01" .And. !Empty(M->C5_MSCONCL) .And. !("FISCAL" $ Upper(Alltrim(aUsrInf[1][3])))
		lRet := .F.
		Help(NIL, NIL, "MONTENCER", NIL, "Pedido atendido pela montagem", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
	Endif

	//*******************************************
	//* Validação da existencia de pedidos APV	*
	//*******************************************
	/*
	dbSelectArea("SZM")
	SZM->(DbSetOrder(1))
	If SZM->(dbSeek(xFilial("SZM") + M->C5_NUM))
		If !(M->C5_CLIENTE + M->C5_LOJACLI == SZM->ZM_CODCLI + SZM->ZM_LOJACLI)
			lRet := .F.
			Help(NIL, NIL, "ALTPEDAPV", NIL, "Alteração não permitida, pois já existe APV para este pedido.", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
		Endif
	Endif
	*/

Return lRet