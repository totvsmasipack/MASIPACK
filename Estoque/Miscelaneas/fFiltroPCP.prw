#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} fFiltroPCP
(long_description)
@type user function
@author GABRIEL VEDOVATO
@since 08/04/2024
@version 1.0
/*/
User Function fFiltroPCP()
    Local lRet := .T.
    Local cUsuario := __cUserID 
    Local cGrupos := SuperGetMV("ES_GRPPCP",.F.,"000232")
    Local aGrupos := StrTokArr(cGrupos,";")
    Local aGrpUsr := FWSFUsrGrps(cUsuario)
    Local nX := 0
    Local nPos := 0

    FOR nX := 1 to LEN(aGrpUsr)
        nPos := aScan(aGrupos,{|x| x == aGrpUsr[nX]})

        IF nPos > 0
            EXIT
        ENDIF

    NEXT nX

    IF nPos == 0
        lRet := If(!ValType(_cDeptoUsu) == Nil ,SubStr(SHB->HB_COD,1,3) $ SubStr(_cDeptoUsu,1,3), )                                                                                                                                                                     
    ENDIF

Return lRet
