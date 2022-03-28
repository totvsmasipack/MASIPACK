#include 'protheus.ch'
#include 'totvs.ch'

/*/{Protheus.doc} User Function MT120BRW
	P.E. para inclusão de botões customizados na rotina
    de Pedido de Compras.
@type  Function
@author E.DINIZ - [ DS2U ]
@since 29/09/2021
@version version
/*/
User Function MT120BRW()

Local aEspecifico	:= {}
Local aGroup		:= UsrRetGrp(UsrRetName( RetCodUsr()),RetCodUsr())
Local cGrpCom		:= '000157'

    If FWIsAdmin() .Or. aScan(aGroup,cGrpCom) > 0
		AADD(aEspecifico, {"Altera Entrega","U_RCOMA023()", 0 , 9, 0, Nil})
		AADD(aRotina, {"Específicos",aEspecifico, 0 , 9, Nil})
	Endif

Return
