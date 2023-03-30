#INCLUDE "PROTHEUS.CH"

STATIC cUseArq := ""

/*--------------------------------------------------------------------------------------------|
| {Protheus.doc} RCONA003()                                                                   |
| Rotina para importacao de lancamento contabil, usando arquivo CSV.                          |
|                                                                                             |
| @author  DS2U (THOMAS MORAES)                                                               |
| @since   Mar.2023                                                                           |
| @version 2.0                                                                                |
| @type    function                                                                           |
| ------------------------------------------------------------------------                    |
| /* Layout dos dados dentro do arquivo                                                       |
| Data;Tipo;Cta.Deb;Cta.Cred;Valor;Historico;C.C.Deb;C.C.Cred;IT Deb;IT Cred;CL Deb;CL Cred   |
| 21/08/2011;1;11101001;;123,45;Pagamento de juros;;;;;;                                      |
|---------------------------------------------------------------------------------------------*/

User Function RCONA003()
	Local aSays    := {}
	Local aButtons := {}
	Local nOpca    := {}
	Local aHelpPor := {}
	Local cTitoDlg := "Importacao de lancamentos contabeis"
	Local cPerg    := "RCON03"
	Local aMvPar := {}
	Local nX

	//Guarda parametros do padrao para manipular MV_PAR
	For nX := 1 To 40
 		aAdd( aMvPar, &( "MV_PAR" + StrZero( nX, 2, 0 ) ) )
	Next nX
	
	//Pergunta 01
	aHelpPor := {}
	aAdd(aHelpPor, "Informe o arquivo .CSV a ser importado")

	aAdd(aSays, "Esta rotina tem por objetivo importar as informacoes para o sistema Protheus, das")
	aAdd(aSays, "seguintes tabelas:")
	aAdd(aSays, "")
	aAdd(aSays, "LANCAMENTOS CONTABEIS")
	aAdd(aSays, "")
	aAdd(aSays, "")
	aAdd(aSays, "O arquivo deve seguir o layout padrao definido pela DS2U.")
	
	Aadd(aButtons,{5, .T., {|o| Pergunte(cPerg, .T.)}})
	Aadd(aButtons,{1, .T., {|o| nOpca := 1, FechaBatch()}})
	Aadd(aButtons,{2, .T., {|o| nOpca := 2, FechaBatch()}})
	
	FormBatch(cTitoDlg, aSays, aButtons)

	If nOpca == 1
		Pergunte(cPerg, .F.)
		If !Empty(MV_PAR01)
			Processa({||MyCTBA102Inc()},"Aguarde...","Processando arquivo...")
		Else
			Alert("ERRO: Nao foi informado o arquivo de origem.")
		Endif
	EndIf

	// Retorna parametros do padrao
	For nX := 1 To Len( aMvPar )
 		&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aMvPar[ nX ]
	Next nX

Return
  
/*-------------------------------------------------------------------------------|
| {Protheus.doc} MyCTBA102Inc                                                    |
|                                                                                |
| Inclusao de Lançamento Automático CTBA102                                      |
| Documentacao: https://tdn.totvs.com/pages/releaseview.action?pageId=107381546  |
|                                                                                |
| @author Totvs                                                                  |
| @since 23/06/2022                                                              |
| @version 2.0                                                                   |
|--------------------------------------------------------------------------------*/
 
Static Function MyCTBA102Inc()
 
 
Local aArea    := GetArea()
Local aCab     := {}
Local aItens   := {}
Local cLinha   := "000"
Local nAux	   := 0
Local aLogAuto :={}
  
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private CTF_LOCK    := 0
Private lSubLote    := .T.

    cMVPAR:= MV_PAR01 
	If File(MV_PAR01)
		FT_FUse(MV_PAR01)
		ProcRegua(FT_FLastRec())

		cBuffer := FT_FReadLn()
		aDataImp:= Separa(cBuffer, ';', .T.)
		If Alltrim(Upper(aDataImp[1])) != "DATA"  //Primeira linha do arquivo, caso nao seja aborta a importacao
			Alert("O arquivo nao esta no padrao, nao sera realizada a importacao", "ERRO")
			FT_FUse(MV_PAR01)
			Return
		EndIf
		FT_FSkip()
		IncProc("Analisando registro " + cLinha + " de " + cValToChar(FT_FLastRec()) + "...")
		cBuffer := FT_FReadLn()
		aDataImp:= Separa(cBuffer, ';', .T.)
		cDtLote := aDataImp[1]

		// Montagem do cabecalho de lote
		aAdd(aCab, {'DDATALANC' ,Ctod(cDtLote) ,NIL} )
		aAdd(aCab, {'CLOTE' ,'I00001' ,NIL} )
		aAdd(aCab, {'CSUBLOTE' ,'001' ,NIL} )
		aAdd(aCab, {'CPADRAO' ,'' ,NIL} )
		aAdd(aCab, {'NTOTINF' ,0 ,NIL} )
		aAdd(aCab, {'NTOTINFLOT' ,0 ,NIL} )

		While !FT_FEof()
			cBuffer := FT_FReadLn()
			aDataImp:= Separa(cBuffer, ";", .T.)
			cLinha  := Soma1(cLinha)
  
            If Len(aDataImp) > 0
				If cDtLote == aDataImp[1]
					If FT_FLastRec() <= 999
						nValor := StrTran(aDataImp[5], ".","")
						nValor := Val(StrTran(nValor, ",","."))					
						
						//Composicao da linha de lancamento
						aAdd(aItens,  {;
							{'CT2_FILIAL' , xFilial('CT2')                                                      , NIL},;
							{'CT2_LINHA'  , cLinha			                                                    , NIL},;
							{'CT2_MOEDLC' ,'01'                                                                 , NIL},;
							{'CT2_DC'     ,Alltrim(aDataImp[2])                                                 , NIL},;
							{'CT2_DEBITO' ,Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[3]))           , NIL},;
							{'CT2_CREDIT' ,Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[4]))           , NIL},;
							{"CT2_CCD"   , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[7]))           , Nil},;
							{"CT2_CCC"   , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[8]))           , Nil},;
							{"CT2_ITEMD" , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[9]))           , Nil},;
							{"CT2_ITEMC" , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[10]))          , Nil},;
							{"CT2_CLVLDB", Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[11]))          , Nil},;
							{"CT2_CLVLCR", Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[12]))          , Nil},;
							{"CT2_TPSALD", "1"                                                                  , Nil},;
							{'CT2_VALOR'  , Iif(Alltrim(aDataImp[2]) == "4", 0, nValor)                         , NIL},;
							{'CT2_ORIGEM' ,"RCONA003 - " + cUserName                                            , NIL},;
							{'CT2_HP'     ,''                                                                   , NIL},;
							{'CT2_CONVER' ,'1'                                                                 , NIL},;
							{'CT2_HIST'   ,Alltrim(aDataImp[6])                                                 , NIL} })
						
						IncProc("Analisando registro " + cLinha + " de " + cValToChar(FT_FLastRec()) + "...")
						
						
					Else
						MsgInfo("Processo abortado devido o arquivo CSV possuir mais de 999 linhas","Fim")
          				Exit
					EndIf
                    
                EndIf
            EndIf
		FT_FSkip()
        EndDo

		MSExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aItens, 3)

		If lMsErroAuto
			aLogAuto := GetAutoGRLog()
			For nAux := 1 To Len(aLogAuto)
				cLogTxt += aLogAuto[nAux] +CRLF
			Next
			
            lMsErroAuto := .F.
            MostraErro()
        Else
			MsgInfo("Importação finalizada com "+cLinha+" Lancamentos","Fim")
		EndIf

        FT_FUse(cMVPAR)
    EndIf
 
RestArea(aArea)
  
Return


/*------------------------------------------------------------------------------------------|
| {Protheus.doc} UsePath() / UseArq()                                                       |
| Funcoes para utilizacao em consulta especifica (SXB > DIRCSV), com o objetivo de filtrar  |
| arquivos que contenham extensao .CSV e facilite a busca do usuario em customs             |
| que precisam selecionar arquivos.                                                         |
|                                                                                           |
| @author  DS2U (THOMAS MORAES)                                                             |
| @since   Dez.2020                                                                         |
| @version 1.0                                                                              |
| @type    function                                                                         |
| -----------------------------------------------------------------------------------------*/

User Function UsePath()
Local cType   := "Arquivos CSV (.CSV) | *.CSV"

	cUseArq := cGetFile(cType,"Arquivos", 1, "C:\", .T.,  nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE), .T., .T.) // "Selecione arquivo "

Return !Empty(cUseArq)


User Function UseArq()

Return(cUseArq)
