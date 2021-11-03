#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} User Function MA410COR
 Este ponto de entrada pertence à rotina de pedidos de venda, MATA410(). Usado, em conjunto com o ponto MA410LEG, para alterar cores do “browse” do cadastro, que representam o “status” do pedido.
@type  Function
@author Masipack
@since 17/12/2019
@see https://tdn.totvs.com/display/public/PROT/MA410COR+-+Alterar+cores+do+cadastro+do+status+do+pedido
/*/
User Function MA410COR()

Local _aRet := U_MSLEGPED()

Return _aRet