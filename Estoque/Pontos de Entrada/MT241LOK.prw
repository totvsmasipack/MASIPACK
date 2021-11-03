#include 'protheus.ch'

/*/{Protheus.doc} User Function MT241LOK
(long_description)
@type  Function
@author E.DINIZ - [ DS2U ]
@since 05/02/2021
@version version
/*/
User Function MT241LOK()

Local _aArea    := {SD3->(GetArea()), SD4->(GetArea())}
Local _cLF      := ''
Local _nPos     := PARAMIXB[1]
Local _nPosOP  := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_OP"})
Local _nPosPrd  := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_COD"})
Local _lDeleta  := aCols[_nPos,Len(aCols[_nPos])]
Local _lRet     := .T.
    
    If cEmpAnt $ '01|10'
        SD4->(dbSetOrder(2)) //D4_FILIAL, D4_OP, D4_COD, D4_LOCAL, R_E_C_N_O_, D_E_L_E_T_
        If SD4->(dbSeek(FWxFilial('SD4') + aCols[_nPos,_nPosOP] + aCols[_nPos,_nPosPrd]))
            _cLF := IIF(_lDeleta,'X',SPACE(TamSX3('D4_MSLF')[1]))
            If !(SD4->D4_MSLF == _cLF)
                Reclock('SD4',.F.)
                SD4->D4_MSLF := _cLF
                SD4->(MsUnlock())
            Endif
        EndIf
    Endif

    AEval(_aArea, {|x| RestArea(x)})

Return _lRet
