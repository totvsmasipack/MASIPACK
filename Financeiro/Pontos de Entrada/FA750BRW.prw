#Include "Rwmake.ch"
#Include "Topconn.ch"

/*------------------------------------------------------------------------------------------------------*
 | P.E (Ponto de Entrada):  FA750BRW                                                                                  |
 | Desc:  O ponto de entrada FA750BRW foi desenvolvido para adicionar itens no menu da mBrowse.         |
 |        Retorna array com as opções e manda como parâmetro o array com as opções padrão.              |
 | Links: http://tdn.totvs.com/pages/releaseview.actionçpageId=6071251                                  |
 |                                                                      								|
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Jul.2022																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function FA750BRW()
Local aRotina:={}

aAdd(aRotina, {"Ped. Compra Vinc.", "U_RFING002", 0, 4, 0, NIL})

Return aRotina
