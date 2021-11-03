#include "totvs.ch"

/*/{Protheus.doc} RFATG062
(long_description)
@type  Function
@author user
@since 18/10/2019
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function RFATG062()

Local cOrdPrd   := ""
Local cPedido   := SC5->C5_NUM
Local lRet      := .T.

    dbSelectArea("SC6")
    SC6->(dbSetOrder(1))
    dbSelectArea("SF4")
    SF4->(DbSetOrder(1))

    dbSelectArea("SZ1")
    SZ1->(dbSetOrder(1))

    dbSelectArea("SZM")
    SZM->(DbSetOrder(1))

    SC6->(dbSeek(FWxFilial("SC6") + cPedido))
    While !SC6->(EOF()) .And. SC6->C6_FILIAL + SC6->C6_NUM == FWxFilial("SC6") + cPedido .And. lRet

        If SC6->C6_QTDVEN - SC6->C6_QTDENT > 0

            SF4->(dbSeek( FWxFilial("SF4") + Alltrim(SC6->C6_TES) ))
            If SF4->F4_ESTOQUE == "S" .And. SC5->C5_TIPO == "N" .And. cEmpAnt == "01" .And. !Empty(SC6->C6_MSPCP) .And. DTOC(SC6->C6_MSPCP) <> "31/12/49" .AND. SC5->C5_MSCATEG $ "2|3"
                Help(NIL, NIL, "NEGEXC1", NIL, "Pedido de venda não pode ser excluído!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Fale com PCP: Este Item já foi Analisado"})
                lRet := .F.
            EndIf  

            If SZ1->(dbSeek( FWxFilial("SZ1") + cPedido)) .Or. SZM->(dbSeek( FWxFilial("SZM") + cPedido))
                Help(NIL, NIL, "NEGEXC2", NIL, "Pedido de venda não pode ser excluído!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Elimine o resíduo deste pedido"})
                lRet := .F.
            EndIf

            cOrdPrd := SrcSC2(cPedido,SC6->C6_PRODUTO)
            If !Empty(cOrdPrd)
                Help(NIL, NIL, "NEGEXC3", NIL, "Pedido de venda não pode ser excluído!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"O pedido de venda possui vínculo com a OP " + cOrdPrd})
                lRet := .F.
            EndIf

        Endif

        SC6->(dbSkip())
        
    Enddo

Return lRet

/*/{Protheus.doc} SrcSC2
Valida se há ordem de produção para o pedido de venda
@type  Function
@author user
@since 18/10/2019
@version version
@param cPedido,cProduto
@return cRet, Character, Retorna o número da OP vinculada ao pedido de venda
@example
(examples)
@see (links_or_references)
/*/
Static Function SrcSC2(cPedido , cProduto)

Local cRet      := ""
Local cAlsSC2   := GetNextAlias()

    BEGINSQL ALIAS cAlsSC2

        SELECT C2_NUM, C2_ITEM, C2_SEQUEN 
        FROM %Table:SC2% SC2
        WHERE C2_FILIAL = %Exp:xFilial("SC2")% AND
        C2_MSPED = %Exp:cPedido% AND
        C2_PRODUTO = %Exp:cProduto% AND
        SC2.%NOTDEL%
        ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN

    ENDSQL

    If Select(cAlsSC2) > 0
        cRet := (cAlsSC2)->C2_NUM + (cAlsSC2)->C2_ITEM + (cAlsSC2)->C2_SEQUEN
    Endif

Return cRet