#Include 'Protheus.ch'

/*------------------------------------------------------------------------------------------------------*
 | P.E.:  {Protheus.doc} MT131AI                                                                        |
 | Desc:  Adiciona campos no envio de email após gerar a cotação                                        |
 | Links: https://tdn.totvs.com/pages/releaseview.action?pageId=511549002								|
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Jun.2023																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function MT131AI()
Local aItem := {}

aADD(aItem,{'It.cCodPro'     ,Alltrim(SB1->B1_COD)})
aADD(aItem,{'It.cProDesc'    ,Posicione("SB5", 1, xFilial("SB5") + SB1->B1_COD, "B5_CEME")})
aADD(aItem,{'It.cUmMed'      ,SB1->B1_UM})
aADD(aItem,{'It.cMemo'       ,SC1->C1_OBS})

return aItem
