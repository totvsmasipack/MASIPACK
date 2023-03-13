

/*---------------------------------------------------------------------------------------------------*
| {Protheus.doc}  P.E CT102BUT                                                                      |
|  Permite adicionar novos botões para o array arotina, no menu da mbrowse em lançamentos           |
|  contábeis automáticos.                                                                           |
|  https://tdn.totvs.com/pages/releaseview.action?pageId=6068683                                    |
|                                                                                                   |
| @author  DS2U (THOMAS MORAES)																		|
| @since   Mar.2023																					|
| @version 1.0																					    |
| @type    function                                  												|
*---------------------------------------------------------------------------------------------------*/

User Function CT102BUT()
Local aBotao := {}

aAdd(aBotao, {'Import. Lctos. CSV',"U_RCONA003",   0 , 3    })

Return(aBotao)
