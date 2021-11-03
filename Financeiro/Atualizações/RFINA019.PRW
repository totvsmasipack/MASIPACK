#include "protheus.ch"

/*/{Protheus.doc} RFINA019
// Atualização Automática das Moedas Financeiras
@author E.DINIZ - [ DS2U ]
@since 24/07/2019
@version 1.0
/*/
User Function RFINA019(aParam)

Local lContinua := .T.

    CONOUT('=========================|RFINA019|==========================')
    CONOUT('= INICIADO EM: ' + DTOC(DATE()) + ' - ' + TIME())
    
    //Valida se há o código da empresa configurado no parâmetro do Schedule
    Do Case
    Case Empty(aParam[1]) 
        lContinua := .F.
        CONOUT('= AVISO: CODIGO DA EMPRESA NAO INFORMADO PARA PROCESSAMENTO =')
        
    Case Empty(aParam[2]) 
        lContinua := .F.
        CONOUT('= AVISO: CODIGO DA FILIAL NAO INFORMADO PARA PROCESSAMENTO  =')
    EndCase

    If lContinua
        CONOUT('= EMPRESA: ' + aParam[1] + ' | FILIAL: ' + aParam[2])
        RPCSetType(3)
        RPCSetEnv(aParam[1],aParam[2])
        GetBacenCSV()
        RPCClearEnv()
    Endif

    CONOUT('= FINALIZADO EM: ' + DTOC(DATE()) + ' - ' + TIME())
    CONOUT('=============================================================')

Return


/*/{Protheus.doc} GetBacenCSV()
Realiza o download da planilha no BACEN para atualização
@type  Static Function
@author E.DINIZ = [ DS2U ]
@since 28/02/2021
/*/
Static Function GetBacenCSV()

Local aData     := {}
Local aMoeda    := {}
Local aPTax     := {}
Local aRet      := {}
Local cMsgErr   := SuperGetMV('MS_BCNERR', .F., 'Error 404')
Local cUrlBCN   := SuperGetMV('MS_BCNURL', .F., 'https://www4.bcb.gov.br/Download/fechamento/')
Local cExtFile  := SuperGetMV('MS_BCNEXT', .F., '.csv')
Local nX        := 0
Local nY        := 0

    //IDENTIFICACAO DAS MOEDAS PARAMETRIZADAS POR EMPRESA
    For nX := 1 To 99
        If FWSX6Util():ExistsParam( 'MV_MOEDA' + cValToChar(nX) )
            AADD(aMoeda,{'M2_MOEDA' + cValToChar(nX), UPPER(ALLTRIM(GetMV('MV_SIMB' + cValToChar(nX)))), 0 })
        Else
            Exit   
        Endif
    Next nX

    //OBTÉM A PLANILHA DE ACORDO COM A DATA DO SISTEMA
    For nX := 0 To 365
        cRet := HttpGet( cUrlBCN + DToS(DaySub(DATE(),nX)) + cExtFile )
        AADD(aData,DToS(DaySub(DATE(),nX)))
        
        If !(cMsgErr $ cRet)
            aRet := STRTOKARR2(cRet,Chr(13)+Chr(10))
            For nY := 1 To Len(aRet)
                AADD(aPTax, STRTOKARR2(aRet[nY],";"))
            Next nY
            CONOUT('= PLANILHA BACEN: ' + DToS(DaySub(DATE(),nX)) + cExtFile )
            Exit
        Endif
    Next nX

    //OBTÉM O VALOR POR MOEDA PARAMETRIZADAS
    For nX := 1 To Len(aPTax)
        For nY := 1 To Len(aMoeda)
            If aPTax[nX,4] == aMoeda[nY,2]
                CONOUT('= MOEDA: ' + aMoeda[nY,2] + ' | Valor R$: ' + StrTran(aPTax[nX,5],",",".") )
                aMoeda[nY,3] := Val(StrTran(aPTax[nX,5],",","."))
            Endif
        Next nY
    Next nX

    //GRAVA MOEDAS NA SM2
    dbSelectArea('SM2')
    SM2->(dbSetOrder(1))

    For nX := 1 To Len(aData)
        If !(SM2->( dbSeek( aData[nX] ) ))
            BEGIN TRANSACTION
            If Reclock('SM2',.T.)
                SM2->M2_DATA := STOD(aData[nX])
                For nY := 1 To Len(aMoeda)
                    SM2->&(aMoeda[nY,1]) := aMoeda[nY,3]
                Next nY
                SM2->M2_INFORM := 'S'
            Endif
            SM2->(MsUnlock())
            END TRANSACTION
        Endif
    Next nX

Return
