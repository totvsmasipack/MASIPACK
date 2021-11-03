#include "protheus.ch"

/*/ {Protheus}
@Description: Validação de acessos à alteração do pedido de venda
@Date: 25.09.2019
@Author: Específicos Masipack
/*/

User Function RFATG061()

Local _aUsuario     := {}
Local cNomeUsu      := ""
Local cDeptoUsu     := ""

    If RetCodUsr() $ GetMv("MS_USRAPV")
        Return .T.
    EndIf

    DO CASE

        CASE !cEmpAnt == "15"

            PswOrder(1)
            If PswSeek(__cUserID,.T.)
                _aUsuario := PswRet()
                cNomeUsu  := UsrRetName(__cUserID)
                cNomeUsu  := Upper(Alltrim(cNomeUsu))
                cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
                If "ENG." $ cDeptoUsu
                    cDeptoUsu := Substr(cDeptoUsu,1,12)
                EndIf
            EndIf

            //**********************************************
            //* Validações específicas por empresas        *
            //**********************************************
            If cEmpAnt == "01"  // Masipack
                
                If SC5->C5_MSCATEG $ "2" .And. (cDeptoUsu $ "COMEX" .OR. cDeptoUsu $ "COMEX/COMERCIAL")
                    Return .T.
                EndIf
                
            Endif
            
            //**********************************************
            //* Validações para demais as empresas         *
            //**********************************************
            If SC5->C5_MSCATEG $ "0_1" .AND. ("COMERCIAL" $ cDeptoUsu .OR. "ENG" $ cDeptoUsu)
                Return .T.
            EndIf

            If SC5->C5_MSCATEG $ "2_3" .AND. ("COMEX" $ cDeptoUsu .OR. cDeptoUsu $ "VENDA DE PECAS")
                Return .T.
            EndIf

            If SC5->C5_MSCATEG $ "4_6" .AND. (cDeptoUsu $ "AT" .OR. cDeptoUsu $ "ASSIST. TECNICA")
                Return .T.
            Endif

            If SC5->C5_MSCATEG == "5" .AND. cDeptoUsu $ "203-MAKLASER"
                Return .T.
            Endif

            If SC5->C5_MSCATEG $ "4_6" .AND. ( !RetCodUsr() $ Alltrim(SC5->C5_MSUSER) .And. !Left(cDeptoUsu,3) == '207')
                Alert("Só é permitido alteração pelo usuário que incluiu o Pedido de Vendas.")
                Return .F.
            EndIf
/*
            If RetCodUsr() $ Alltrim(SC5->C5_MSUSER)
                Return .T.
            Else
                Help(NIL, NIL, "A410NEG", NIL, "Usuário não autorizado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite o acesso ao administrador do sistema. (Parâmetro: MS_USRAPV)"})
                Return .F.
            EndIf
*/                      
    ENDCASE

Return .T.
