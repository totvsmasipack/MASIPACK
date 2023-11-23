#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

User Function uRFINA21()
    StartJob("u_RFINA021",GetEnvServer(),.T.,{"15","01"})
return
/*/{Protheus.doc} HELSP006
Função a ser executada por um schedule
@type  Function
@author DS2U(FC)
@since 20/11/2023
@version 1.0
/*/
User Function RFINA021(aParam)
    Local lRet := .T.
    Default aParam := NIL

    If aParam <> Nil
        Reset Environment
        RPCSETTYPE(3)
        RpcSetEnv(aParam[1] ,aParam[2])
        
        //CHECA PROPOSTAS IMPLANTADAS PARA GERAR PROVISÕES
        BAIXADAC()

        RpcClearEnv()
    elseif (!IsBlind())
        BAIXADAC()
	EndIf

Return lRet


/*/{Protheus.doc} User Function BTitAu
    (long_description)
    @type  Function - Faz a baixa de titulo automatica das lojas com Prfixo LJ
    @author Raphael
    @since 18/09/2023
 /*/
Static Function BAIXADAC()
    Local _cAlias   := GetNextAlias()
    Local cQuery    := ""
    Local cPrefixo  := SUPERGETMV("ES_RFIN21P",, "LJ")
    Local aBaixa    := {}
    Local cAUTHIST  := SUPERGETMV("ES_RFIN21H",, "BAIXA AUTOMATICA DACAO") 
    Local nX        := 0
    Local aLog 	    := {}
    Local lTeste    := SUPERGETMV("ES_RFIN21T",, .F.)
    Local nHandle  
    
    PRIVATE lMsErroAuto 	:= .F.
    PRIVATE lMsHelpAuto		:= .T.
    PRIVATE lAutoErrNoFile 	:= .T. 


    IF SUPERGETMV("ES_RFINA21",,.T.)

        cQuery := " SELECT "
        If lTeste
            cQuery += " TOP 1 "
        EndIf 
        cQuery += " SE1.E1_PREFIXO as E1_PREFIXO, "
        cQuery += " SE1.E1_NUM as E1_NUM, "
        cQuery += " SE1.E1_PARCELA as E1_PARCELA, "
        cQuery += " SE1.E1_TIPO as E1_TIPO, "
        cQuery += " SE1.E1_JUROS as E1_JUROS, "
        cQuery += " SE1.E1_SALDO as E1_SALDO,"
        cQuery += " SE1.E1_TITPAI as E1_TITPAI,"
        cQuery += " SE1.E1_DESCONT as E1_DESCONT,"
        cQuery += " SE1.E1_MULTA as E1_MULTA,"
        cQuery += " SE1.E1_ACRESC as E1_ACRESC,"
        cQuery += " SE1.E1_DECRESC as E1_DECRESC,"
        cQuery += " SE1.E1_FILIAL as E1_FILIAL"
        cQuery += " FROM " + RetSqlName("SE1") + " SE1 "
        cQuery += " WHERE SE1.E1_PREFIXO = '"+ cPrefixo +"'" 
        cQuery += " AND SE1.E1_SALDO > 0"
        cQuery += " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
        cQuery += " AND SE1.D_E_L_E_T_ <> '*'"
        

        cQuery := ChangeQuery(cQuery) 
        TcQuery cQuery New Alias (_cAlias )
        DbSelectArea(_cAlias)
        (_cAlias)->(DbGoTop())
        
        While(_cAlias)->(!EOF())
            IF(Empty((_cAlias)->E1_TITPAI)) 

                aBaixa := { {"E1_PREFIXO"   , (_cAlias)->E1_PREFIXO     ,Nil    },;
                            {"E1_NUM"       , (_cAlias)->E1_NUM         ,Nil    },;
                            {"E1_PARCELA"   , (_cAlias)->E1_PARCELA     ,Nil    },;
                            {"E1_TIPO"      , (_cAlias)->E1_TIPO        ,Nil    },;
                            {"AUTMOTBX"     , "DAC"                     ,Nil    },;                        
                            {"AUTDTBAIXA"   , dDataBase                 ,Nil    },;
                            {"AUTDTCREDITO" , dDataBase                 ,Nil    },;
                            {"AUTHIST"      , cAUTHIST                  ,Nil    },;
                            {"AUTJUROS"     , (_cAlias)->E1_JUROS       ,Nil,.T.},;
                            {"AUTDESCONT"   , (_cAlias)->E1_DESCONT     ,nIL,.T.},;
                            {"AUTMULTA"     , (_cAlias)->E1_MULTA       ,Nil,.T.},;
                            {"AUTACRESC"    , (_cAlias)->E1_ACRESC      ,Nil,.T.},;
                            {"AUTDECRESC"   , (_cAlias)->E1_DECRESC     ,Nil,.T.},;
                            {"AUTVALREC"    , (_cAlias)->E1_SALDO       ,Nil,   } }

                lMsErroAuto := .F.
                    
                MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
                
                If lMsErroAuto	
                    AutoGrLog("Geração do arquivo de log - E1_NUM = " + (_cAlias)->E1_NUM)	
                    AutoGrLog("")	
                    AutoGrLog(Replicate("-", 20))	 
                    nHandle   := FCREATE(GetSrvProfString("StartPath","")+"log_"+;
                                         AllTrim((_cAlias)->E1_FILIAL)+;
                                         AllTrim((_cAlias)->E1_PREFIXO)+;
                                         AllTrim((_cAlias)->E1_NUM)+;
                                         AllTrim((_cAlias)->E1_PARCELA)+;
                                         AllTrim((_cAlias)->E1_TIPO)+;
                                         ".txt")	
                    
                    aLog := GetAutoGRLog()
                    For nX := 1 To Len(aLog)				
                        FWrite(nHandle,aLog[nX]+CHR(13)+CHR(10))			
                    Next nX			
                    FClose(nHandle) 
                EndIF
            ENDIF
            
            (_cAlias)->(dbSkip())
        ENDDO
        (_cAlias)->(DbCloseArea())
    EndIF
RETURN NIL
