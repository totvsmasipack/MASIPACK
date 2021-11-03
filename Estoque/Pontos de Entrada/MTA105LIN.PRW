#include 'totvs.ch'

/*/{Protheus.doc} MTA105LIN
MTA105LIN - Valida os dados na linha da solicitação ao almoxarifado digitada
@type  User Function
@author Masipack
@since 17/02/2020
@return lRet, Logical, Se .T. continua o processo, se .F. bloqueia o processo.
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6087791
/*/
User Function MTA105LIN()

Local aAreaSB2  := SB2->(GetArea())
Local lRet      := .T. 
Local nPosArm   := aScan(aHeader,{|x| Alltrim(x[2]) == "CP_LOCAL"   })
Local nPosProd  := aScan(aHeader,{|x| Alltrim(x[2]) == "CP_PRODUTO" })
Local nPosQtde  := aScan(aHeader,{|x| Alltrim(x[2]) == "CP_QUANT"   })

DEFAULT INLCUI  := .T.
DEFAULT ALTERA  := .F.

    //Valida o saldo do produto informado no estoque
    SB2->(dbSetOrder(1))
    If SB2->(dbSeek(FWxFilial("SB2") + aCols[n][nPosProd] + aCols[n][nPosArm])) .And. aCols[n][nPosQtde] > SaldoSB2( ,.F.)
        Help(Nil, Nil, "NOSALDO", Nil, "Saldo Disponivel no Estoque inferior a quantidade solicitada.", 1, 0, Nil, Nil, Nil, Nil, Nil, {"Solicite a quantidade inferior ao saldo disponivel ou contate a equipe de Almoxarifado/Armazém."} )
        lRet := .F.
    Endif
    //Fim da validação

    RestArea(aAreaSB2)

Return lRet
