#include "totvs.ch"

/*/{Protheus.doc} User Function MT120ALT
Fun��o para verificar se continua a altera��o ou n�o
@type  User Function
@author Masipack
@since 25/02/2020
@return lRet, Logial, .T. = Continua o processo, se n�o, bloqueio
/*/
User Function MT120ALT()

Local aArea     := { SC7->(GetArea()), SE4->(GetArea())}
Local lRet      := .T.

    If cEmpAnt $ '01|10'
        FwMsgRun(,{|oSay| lRet := CheckGrpUsr(oSay), 'Aguarde', '' })
    Endif
    
    AEval(aArea, {|x| RestArea(x)})

Return lRet


Static Function CheckGrpUsr(oSay)

Local _aGrpUsr  := FWSFUsrGrps( RetCodUsr() )
Local _cNumPC    := SC7->C7_NUM

    oSay:SetText( 'Verificando privil�gios de acesso do seu usu�rio ' )
    
    If aScan(_aGrpUsr, '000157' ) > 0
        Return .T.
    Endif

    oSay:SetText( 'Identificando exist�ncia de pr�-nota' )
    
    If ALTERA
        While SC7->(!EOF()) .And. SC7->C7_NUM == _cNumPC
            If !SC7->C7_QTDACLA == 0
                Help(Nil, Nil, "NOALTPC", Nil, "Este pedido de compra possui v�nculo com Pr�-Nota.", 1, 0, Nil, Nil, Nil, Nil, Nil, {"Exclua a Pr�-Nota de Entrada para alterar o pedido."} )
                Return .F.
            Endif
            SC7->(dbSkip())
        Enddo
    Endif

Return .T.
