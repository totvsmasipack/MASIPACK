#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} RSCHJB1
description function chamada atraves de jobs (schedule)
@type function
@version  
DS2U(R.Garcia)
@since 19/04/2024
/*/
User Function RSCHJB1()
    StartJob("u_RSCHG007",GetEnvServer(),.T.,{cEmpAnt, cFilAnt})
Return NIL

/*/{Protheus.doc} RSCHMEN1
description function chamada atraves de menu (para testes)
@type function
@version  
DS2U(R.Garcia)
@since 19/04/2024
/*/
User Function RSCHMEN1()
   Processa( {|| U_RSCHG007() }, "Aguarde...", "Realizando movimentação...",.T.) 
Return NIL

/*/{Protheus.doc} RSCHG007
description
@type function
@version  
DS2U(R.Garcia)
@since 19/04/2024
@param aParam quando for Schedule traz Emp e Filial 
/*/

User Function RSCHG007(aParam)
    Local lRet      := .T.
    Default aParam  := NIL

    If aParam <> Nil
        Reset Environment
        RPCSETTYPE(3)
        RpcSetEnv(aParam[1] ,aParam[2])
        
        fAjuCus()

        RpcClearEnv()
    elseif (!IsBlind())
        fAjuCus()
	EndIf

Return lRet
/*/{Protheus.doc} fAjuCus
description function faz a rotina de trazer via query, registros que o campo B2_VATU1 está proximo para estourar 
(verificando atraves do paramentro ES_VATUMAX)
@type function
@version  
DS2U(R.Garcia)
@since 19/04/2024
/*/
Static Function fAjuCus()
Local cAlias        := GetNextAlias()
Local cQuery        := ""
Local _aCab         := {}
Local _aItem        := {}
Local _atotitem     := {}
Local aLogAuto      := {}
Local nAux          := 0
Local nPos          := 0
Local nCusto        := 0
Local cCodTM        := ""
Local cLogTxt       := ""
Local cVlrFim       := ""
Local cCusto        := ""
Local cArquivo      := SuperGetMV("ES_VATULOG", .F., "C:\temp\logvatu.txt")
Local cCodTmDi      := SuperGetMV("ES_AJCUSP", .F., "700")
Local cCodTmAu      := SuperGetMV("ES_AJCUSN", .F., "050")
Local cQtdLen       := SuperGetMV("ES_VATUMAX", .F., 1000000)

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

cQuery := " SELECT "
cQuery += "  B2_COD "
cQuery += ", B2_FILIAL "
cQuery += ", B2_VATU1 "
cQuery += ", B2_LOCAL "
cQuery += ", B1_UM "
cQuery += ", B2_LOCALIZ "
cQuery += ", B2_QATU "
cQuery += " FROM " + RetSqlName("SB2") + " SB2 "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SB2.B2_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " WHERE (  B2_VATU1 > " + cValToChar(cQtdLen) + " OR B2_VATU1 < -" + cValToChar(cQtdLen) + " ) "
cQuery += " AND B2_FILIAL = '" + xFilial("SB2") + "'"
cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias (cAlias) 
DbSelectArea(cAlias)
 
While (cAlias)->(!EOF())  
        nCusto  := ((cAlias)->B2_VATU1 * 80) / 100
        nPos    := At(".", cValToChar((cAlias)->B2_VATU1))

        IF(nPos > 0 )
            cVlrFim := SUBSTR(cValToChar((cAlias)->B2_VATU1),nPos,Len(cValToChar((cAlias)->B2_VATU1)))
            cCusto  := cValToChar(Round(nCusto , 0)) + cVlrFim
            nCusto  := Val(cCusto)
        ELSE    
            nPosCus    := At(".", cValToChar(nCusto))
            IF( nPosCus > 0 )
               nCusto := VAL(SUBSTR(cValToChar(nCusto),1,nPosCus))
            ENDIF
        ENDIF

        IF((cAlias)->B2_VATU1 < 0)
            cCodTM := cCodTmAu
            nCusto := VAL(SUBSTR(cValToChar(nCusto),2,Len(cValToChar(nCusto))))
        ELSE
            cCodTM   := cCodTmDi
        ENDIF 
        
        _aCab := {{"D3_DOC"    ,NextNumero("SD3",2,"D3_DOC",.T.)   , NIL},;
                {"D3_TM"      ,cCodTM                             , NIL},;
                {"D3_CC"      ,"        "                         , NIL},;
                {"D3_EMISSAO" ,ddatabase                          , NIL}}

        _aItem  :=  {{"D3_COD"     , (cAlias)->B2_COD      ,NIL},;
                    {"D3_UM"       , (cAlias)->B1_UM       ,NIL},;
                    {"D3_QUANT"    , (cAlias)->B2_QATU     ,NIL},;
                    {"D3_LOCAL"    , (cAlias)->B2_LOCAL    ,NIL},;
                    {"D3_LOTECTL"  , ""                    ,NIL},;
                    {"D3_LOCALIZ"  , (cAlias)->B2_LOCALIZ  ,NIL},;
                    {"D3_CUSTO1"   , nCusto                ,NIL}}

        aadd(_atotitem,_aitem)
        MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_atotitem,3)

        //Se houve erro
        If lMsErroAuto
            //Pegando log do ExecAuto
            aLogAuto := GetAutoGRLog()
            //Percorrendo o Log e incrementando o texto (para usar o CRLF você deve usar a include "Protheus.ch")
            For nAux := 1 To Len(aLogAuto)
                cLogTxt += aLogAuto[nAux] + CRLF
            Next
        EndIf
    (cAlias)->(DbSkip())
EndDo
    IF !Empty(cLogTxt)
        //Criando o arquivo txt
        MemoWrite(cArquivo, cLogTxt)
    ENDIF
RETURN
