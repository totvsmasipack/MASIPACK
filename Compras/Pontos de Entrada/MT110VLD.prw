#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function MT110VLD
P.E. para validar se a opção selecionada é permitida para o usuário
@type  Function
@author E. DINIZ [ DS2U ]
@since 02/11/2020
/*/
User Function MT110VLD()

Local _aArea	:= GetArea()
Local _cMsg     := 'Usuario nao permitido para alterar esta Solicitacao de Compras'
Local _lRet     := .T.
Local _nOpcx    := PARAMIXB[1]

    IF !(FwIsAdmin()) .And. ( _nOpcx == 4 .OR. _nOpcx == 6 )

        dbSelectArea("SY1")
        SY1->(dbSetOrder(3))
        SY1->(dbSeek(FWxFilial("SY1") + RetCodUsr()))

        If !(SY1->(FOUND())) .And. !(SC1->C1_USER == RetCodUsr())
            _lRet := .F.
            Help("",1,"ALTNOPERM",,_cMsg,1,0)
        Endif

    Endif

    RestArea(_aArea)

Return _lRet
