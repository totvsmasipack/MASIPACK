#INCLUDE 'TOTVS.CH'

/*/
------------------------------------------------------------------------
{Protheus.doc} MA410MNU()
Adicao de opcao no menu de acoes relacionadas do Pedido de Vendas
https://tdn.totvs.com/display/public/PROT/MA410MNU

@author  DS2U (THOMAS MORAES)
@since   Out.2021
@version 1.0
@type    function
------------------------------------------------------------------------
/*/
  
User Function MA410MNU()
Local aArea := GetArea()
     
//Adicionando funcao de gerar PRE-DANFE
aAdd(aRotina,{"PRE-DANFE","U_PREDNFLOAD('S')",0, 4, 0 , Nil})    
     
RestArea(aArea)
Return
