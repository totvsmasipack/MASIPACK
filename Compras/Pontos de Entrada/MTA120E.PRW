#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function MTA120E
	P.E. para validação da exclusão do pedido de compras
@type  Function
@author E.DINIZ - [ DS2U ]
@since 25/04/2022
@version version
@param param_name, param_type, param_descr
		ExpN1			Numérico			Contém a opção selecionada: 1 = OK ; 0 = CANCEL
		ExpC1			Caracter			Caractere com o número do Pedido de Compras
@return return_var, return_type, return_description
		ExpL1			Lógico		.T. prossegue e exclui o PC / AE
									.F. aborta a Exclusão
@example
(examples)
@see https://tdn.engpro.totvs.com.br/pages/releaseview.action?pageId=6085570
/*/
User Function MTA120E()

Local aArea	:= { FIE->(GetArea()) }
Local lRet	:= .T.

	DbSelectArea('FIE')
	FIE->(DbSetOrder(1))
	If FIE->(DbSeek( FWxFilial('FIE') + 'P' + Paramixb[2] )) .And. Paramixb[1] == 1
		lRet := .F.
		Help(,,'HELP','Atenção','O pedido de compras possui vínculo com Adiantamentos!',1,0)
	Endif

	AEval(aArea,{|x| RestArea(x)})

Return lRet
