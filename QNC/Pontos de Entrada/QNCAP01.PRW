#include "totvs.ch"

/*/{Protheus.doc} User Function QNCAP01
P.E. para filtrar os dados da MBrowse das Fichas de N�o-Conformidade
@type  Function
@author Masipack
@since 25/02/2020
@return cRet, Char, Retorna o conte�do numa string para utiliza��o no filtro
/*/
User Function QNCAP01()

Local aArea := QAA->(GetArea())
Local cRet  := ""

    IF !FwIsAdmin(RetCodUsr()) .And. !(RetCodUsr() $ GetMv("MS_QNC0001"))
        QAA->(dbSetOrder(6))
        If QAA->( dbSeek( UPPER(Padr(UsrRetName(RetCodUsr()),TamSX3("QAA_LOGIN")[1])) ) )
            cRet := "QI2_MAT == '" + QAA->QAA_MAT + "'"
        Else
            Help(Nil, Nil, "NOCADUSU", Nil, "Usu�rio n�o autorizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {"Contate a Qualidade para permitir este usu�rio a visualizar/incluir FNC's."} )
            cRet := "QI2_MAT == 'XXXXXX'"
        Endif
    Endif

    RestArea(aArea)

Return cRet