#include "totvs.ch"

/*/{Protheus.doc} User Function MTA410T
P.E. PARA TODOS OS ITENS DO PEDIDO 
Ponto de entrada para todos os itens do pedido.
@type  Function
@author E.DINIZ [ DS2U ]
@since 21/04/2020
@version version
@Link https://tdn.totvs.com/display/public/PROT/MTA410T
/*/
User Function MTA410T()

    If cEmpAnt $ '01|10'
        
        //Troca a legenda do pedido de venda (SC5)
        U_MUDACOR()
    
    Endif

Return
