#include 'totvs.ch'

/*/{Protheus.doc} User Function M410LIOK
Validação de linha no pedido de venda.
@type  Function
@author Masipack
@since 13/08/2020
@return lRet, Logical
@see https://tdn.totvs.com.br/pages/releaseview.action?pageId=6784149
/*/
User Function M410LIOK()
    
Local aAreaSB1  := SB1->(GetArea())
Local lRet      := .T.

    dbSelectArea('SB1')
    SB1->(dbSetOrder(1))
    
    SB1->(dbSeek(FWxFilial('SB1') + aCols[n,aScan(aHeader,{|x| Alltrim(x[2]) == 'C6_PRODUTO'})] ))

    If SB1->(FOUND()) .And. EMPTY(SB1->B1_POSIPI)
        lRet := .F.
        Help(Nil, Nil, 'SEMNCM', Nil, 'O produto ' + ALLTRIM(aCols[n,aScan(aHeader,{|x| Alltrim(x[2]) == 'C6_PRODUTO'})]) + ' não possui o código da NCM informado', 1, 0)
    Endif

    RestArea(aAreaSB1)

Return lRet
