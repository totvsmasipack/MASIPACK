#include "totvs.ch"

/*/{Protheus.doc} User Function M241BUT
    Ponto de Entrada para inclus�o de bot�es de usu�rio na barra de
    ferramentas da rotina de inclus�o em Movimentos Internos Modelo II.
    � chamado pela fun��o A241Inclui().
@type  User Function
@author EFD
@since 26/11/2019
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6087565
/*/
User Function M241BUT()

Local aRet  := {}

    AADD(aRet,{'',{|| U_RESTA029() }, 'Referencia'})

Return aRet
