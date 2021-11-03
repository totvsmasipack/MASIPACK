#include "protheus.ch"

/*/{Protheus.doc} User Function RFATA075
    (long_description)
    @type  Function
    @author user
    @since 09/04/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RFATA075(param_name)

Local aSays     := {}
Local aButton   := {}
Local cTitulo   := "TOTVS | Altera a Entrega Inicial do Pedido de Venda"
Local nOpca     := 0
Local lOk       := .T.

    Pergunte("RFAT075",.T.)

    AADD(aSays,"Este programa possui a finalidade de alterar a Data da Entrega Inicial")
    AADD(aSays,"do pedido de venda. Esta rotina deve ser executada APENAS pelo departamento")
    AADD(aSays,"Comercial. (Parâmetro de usuários permitidos: MS_ALTDINI)")

    AADD(aButton,{ 5, .T., {|o| Pergunte("RFAT075",.T.) }})
    AADD(aButton,{ 1, .T., {|o| nOpca := 1, FechaBatch() }})
    AADD(aButton,{ 2, .T., {|o| FechaBatch() }})

    FormBatch(cTitulo,aSays,aButton)

    If nOpca == 1
        FwMsgRun(, {|| lOk := ChgDtEnt() }, "","Atualizando Pedido " + MV_PAR01)
        If lOk
            MsgInfo("Atualização efetuada com sucesso!")
        Endif
    Endif

Return


/*/{Protheus.doc} ChgDtEnt()
Processa a troca da data da Entrega Inicial do Pedido
@type  Static Function
@author Masipack
@since 10/04/2020
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ChgDtEnt()

Local aCabPv    := GetDicSX3("SC5")
Local aItePv    := GetDicSX3("SC6")
Local aItens    := {}
Local lOk       := .T.
Local nx        := 0

Private lMsErroAuto := .F.

Default MV_PAR01 := ""      // Pedido de Venda
Default MV_PAR02 := ""      // Nova Data de Entrega
    
    ProcRegua(2) 
       
    dbSelectArea("SC5")
    SC5->(dbSetOrder(1))

    dbSelectArea("SC6")
    SC6->(dbSetOrder(1))
    

    IF !(SC5->(dbSeek( FWxFilial("SC5") + PadR(MV_PAR01,TamSX3("C5_NUM")[1]))) .And. SC6->(dbSeek( FWxFilial("SC6") + PadR(MV_PAR01,TamSX3("C6_NUM")[1]))))
        Help("", 1, "PEDNOFND", , "Pedido de Venda não encontrado",1,4)
        lOk := .F.
    ENDIF

    IF lOk   
/*        
        For nx := 1 To Len(aCabPv)
            aCabPv[nx,2] := IIF(ALLTRIM(aCabPv[nx,1]) == "C5_MSDTENT", MV_PAR02, SC5->&(aCabPv[nx,1]))
        Next nx

        While SC6->(!EOF()) .And. SC6->C6_FILIAL == FWxFilial("SC6") .And. SC6->C6_NUM == PadR(MV_PAR01,TamSX3("C6_NUM")[1])
            
            For nx := 1 To Len(aItePv)
                aItePv[nx,2] := SC6->&(aItePv[nx,1])
            Next nx
            
            AADD(aItens,aItePv)
            
            SC6->(dbSkip())
        Enddo

        MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItens,4)
        
        If lMsErroAuto
            lOk := .F.
            MostraErro()
            DisarmTransaction()
        Endif
*/  
        Reclock("SC5",.F.)
        SC5->C5_MSDTENT :=  MV_PAR02
        SC5->(MsUnlock())

    ENDIF

Return lOk

/*/{Protheus.doc} GetDicSX3
Retorna os campos do dicionário SX3 em Array
@type  Static Function
@author Masipack
@since 10/04/2020
/*/
Static Function GetDicSX3(cAlias)

Local aRet      := {}
Local aFldSX3   := {}

Default cAlias := ''

    If !Empty(cAlias)
        aFldSX3 := FWSX3Util():GetAllFields(cAlias,.F.)
        For nX := 1 To Len(aFldSX3)
             AADD(aRet,{ALLTRIM(aFldSX3[nX]), SPACE(TamSX3(aFldSX3[nX])[1]), Nil})
        Next nX
    Endif

Return aRet