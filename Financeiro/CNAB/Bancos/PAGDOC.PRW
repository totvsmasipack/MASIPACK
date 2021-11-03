*******************************************************************************
* Programa...: PAGDOC.PRX
* Finalidade.: Extrair o campo livre do Codigo de Barras ou da Linha Digitavel  
*              Obs.: excluir todos os digitos de verificacao do campo livre.
*******************************************************************************
            
USER FUNCTION PAGDOC(_DOC)

cALIAS  :=  Alias()

_Doc  := Space(25)

If Substr(SEA->EA_MODELO,1,2) $ "01/02/05"
   _Doc   :=  SPACE(40)
ElseIf SubStr(SEA->EA_MODELO,1,2) $ "03"
   _Doc   :=  "C00000003"+Space(31)
ElseIf SubStr(SEA->EA_MODELO,1,2) $ "30" .OR. SubStr(SEA->EA_MODELO,1,2) $ "31"
    If !Empty(SE2->E2_CODBAR)
       _Doc  :=  SUBSTR(SE2->E2_CODBAR,20,25)
    ElseIf !Empty(SE2->E2_LINDIG)
       _Doc := SubStr(SE2->E2_LINDIG,05,05)+SubStr(SE2->E2_LINDIG,11,10)+SubStr(SE2->E2_LINDIG,22,10)
    EndIf
EndIf

Return(_DOC)
