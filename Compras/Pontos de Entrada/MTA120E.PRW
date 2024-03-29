#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function MTA120E
	P.E. para valida��o da exclus�o do pedido de compras
@type  Function
@author E.DINIZ - [ DS2U ]
@since 25/04/2022
@version version
@param param_name, param_type, param_descr
		ExpN1			Num�rico			Cont�m a op��o selecionada: 1 = OK ; 0 = CANCEL
		ExpC1			Caracter			Caractere com o n�mero do Pedido de Compras
@return return_var, return_type, return_description
		ExpL1			L�gico		.T. prossegue e exclui o PC / AE
									.F. aborta a Exclus�o
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
		Help(,,'HELP','Aten��o','O pedido de compras possui v�nculo com Adiantamentos!',1,0)
	Endif

	AEval(aArea,{|x| RestArea(x)})

Return lRet
