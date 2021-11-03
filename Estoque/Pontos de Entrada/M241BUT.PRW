#include "totvs.ch"

/*/{Protheus.doc} User Function M241BUT
    Ponto de Entrada para inclusão de botões de usuário na barra de
    ferramentas da rotina de inclusão em Movimentos Internos Modelo II.
    É chamado pela função A241Inclui().
@type  User Function
@author EFD
@since 26/11/2019
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6087565
/*/
User Function M241BUT()

Local aRet  := {}

    AADD(aRet,{'',{|| U_RESTA029() }, 'Referencia'})

Return aRet
