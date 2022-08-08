#include "PROTHEUS.CH"

STATIC cUseArq := ""

/*/
------------------------------------------------------------------------
{Protheus.doc} RCONA003()
Rotina para importacao de lancamento contabil, usando arquivo CSV.

@author  DS2U (THOMAS MORAES)
@since   Dez.2020
@version 1.0
@type    function
------------------------------------------------------------------------
/* Layout dos dados dentro do arquivo
Data;Tipo;Cta.Deb;Cta.Cred;Valor;Historico;C.C.Deb;C.C.Cred;IT Deb;IT Cred;CL Deb;CL Cred
21/08/2011;1;11101001;;123,45;Pagamento de juros;;;;;;
------------------------------------------------------------------------
*/

User Function RCONA003()
	Local aSays    := {}
	Local aButtons := {}
	Local nOpca    := {}
	Local aHelpPor := {}
	Local cTitoDlg := "Importacao de lancamentos contabeis"
	Local cPerg    := "RCON03"
	Local aLogAuto := {}
	Local cLogTxt  := ""
	Local cArquivo := "C:\Relato_Microsiga\ocorrencias_importa_lancamentos.txt"
	Local nAux     := 0
	
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
			Processa({||RCON03OK()},"Aguarde...","Processando arquivo...")
		Else
			Alert("ERRO: Nao foi informado o arquivo de origem.")
		Endif
	EndIf
	Return

Static Function RCON03OK()
	Local aCabecCT2 := {}
	Local aItensCT2 := {}
	Local aItens    := {}
	Local aDataImp  := {}
	Local cBuffer   := ""
	Local cQuery    := ""
	Local cNumDoc   := ""
	Local nLinha    := "000"
	
	Private lMsErroAuto := .F.
	Private lMSHelpAuto := .T.

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
		IncProc("Analisando registro " + nLinha + " de " + cValToChar(FT_FLastRec()) + "...")
		cBuffer := FT_FReadLn()
		aDataImp:= Separa(cBuffer, ';', .T.)
		cDtLote := aDataImp[1]

		While !FT_FEof()
			cBuffer := FT_FReadLn()
			aDataImp:= Separa(cBuffer, ";", .T.)
			nLinha  := Soma1(nLinha, 3)
			
			If Len(aDataImp) > 0
				If cDtLote == aDataImp[1]
					If nLinha <= "999"
						nValor := StrTran(aDataImp[5], ".","")
						nValor := Val(StrTran(nValor, ",","."))
						aAdd(aItensCT2,{{"CT2_FILIAL", xFilial("CT2"), Nil},;
									 	{"CT2_LINHA ", nLinha, Nil},;
										{"CT2_DC"    , Alltrim(aDataImp[2]), Nil},;
										{"CT2_DEBITO", Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[3])), Nil},;
										{"CT2_CREDIT", Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[4])), Nil},;
										{"CT2_VALOR" , Iif(Alltrim(aDataImp[2]) == "4", 0, nValor), Nil},;
										{"CT2_HIST"  , Alltrim(aDataImp[6]), Nil},;
										{"CT2_CCD"   , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[7])), Nil},;
										{"CT2_CCC"   , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[8])), Nil},;
										{"CT2_ITEMD" , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[9])), Nil},;
										{"CT2_ITEMC" , Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[10])), Nil},;
										{"CT2_CLVLDB", Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[11])), Nil},;
										{"CT2_CLVLCR", Iif(Alltrim(aDataImp[2]) == "4", "", Alltrim(aDataImp[12])), Nil},;
										{"CT2_TPSALD", "1", Nil},;
										{"CT2_ORIGEM", "RCONA003- " + cUserName, Nil},;
										{"CT2_MOEDLC", "01", Nil}})  //Sempre moeda 01-Real
										//{"CT2_CONVER", Iif(Alltrim(aDataImp[2]) == "4", "55555", "15555"), Nil},;  //Utilizando o default do plano de contas
						FT_FSkip()
						IncProc("Analisando registro " + nLinha + " de " + cValToChar(FT_FLastRec()) + "...")
					Else
						If Len(aItensCT2) > 0
							cQuery := "SELECT MAX(CT2_DOC) AS CT2_DOC"
							cQuery += " FROM " + RetSqlName("CT2") + " CT2"
							cQuery += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "'"
							cQuery += "   AND CT2_DATA   = '" + Dtos(Ctod(cDtLote)) + "'"
							cQuery += "   AND CT2_LOTE   = 'I00001'"
							cQuery += "   AND CT2.D_E_L_E_T_ <> '*'"
				
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRB1", .T., .T.)
							TcSetField("TRB1", "CT2_DOC", "C", 06, 0)
							TRB1->(DbGoTop())
							cNumDoc := StrZero(Val(TRB1->CT2_DOC) + 1, 6, 0)
							TRB1->(DbCloseArea())
				
							aCabecCT2:= {{"DDATALANC" , Ctod(cDtLote), Nil},;
										 {"CLOTE"     , "I00001", Nil},;
										 {"CSUBLOTE"  , "001", Nil},;
										 {"CDOC"      , cNumDoc, Nil},;
										 {"CPADRAO"   , "", Nil},;
										 {"NTOTINF"   , 0, Nil},;
										 {"NTOTINFLOT", 0, Nil}}
				
							MsExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCabecCT2 ,aItensCT2, 3)
							If lMsErroAuto
								aLogAuto := GetAutoGRLog()
								For nAux := 1 To Len(aLogAuto)
									cLogTxt += aLogAuto[nAux] +CRLF
								Next
								MEMOWRITE( cArquivo, cLogTxt )
							Endif
							aItensCT2 := {}
							aCabecCT2 := {}
							aItens    := {}
							cDtLote   := aDataImp[1]
							nLinha    := "000"
						EndIf
					EndIf
				Else
					If Len(aItensCT2) > 0
						cQuery := "SELECT MAX(CT2_DOC) AS CT2_DOC"
						cQuery += " FROM " + RetSqlName("CT2") + " CT2"
						cQuery += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "'"
						cQuery += "   AND CT2_DATA   = '" + Dtos(Ctod(cDtLote)) + "'"
						cQuery += "   AND CT2_LOTE   = 'I00001'"
						cQuery += "   AND CT2.D_E_L_E_T_ <> '*'"
			
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRB1", .T., .T.)
						TcSetField("TRB1", "CT2_DOC", "C", 06, 0)
						TRB1->(DbGoTop())
						cNumDoc := StrZero(Val(TRB1->CT2_DOC) + 1, 6, 0)
						TRB1->(DbCloseArea())
			
						aCabecCT2:= {{"DDATALANC" , Ctod(cDtLote), Nil},;
									 {"CLOTE"     , "I00001", Nil},;
									 {"CSUBLOTE"  , "001", Nil},;
									 {"CDOC"      , cNumDoc, Nil},;
									 {"CPADRAO"   , "", Nil},;
									 {"NTOTINF"   , 0, Nil},;
									 {"NTOTINFLOT", 0, Nil}}
			
						MsExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCabecCT2 ,aItensCT2, 3)
						If lMsErroAuto
							aLogAuto := GetAutoGRLog()
							For nAux := 1 To Len(aLogAuto)
								cLogTxt += aLogAuto[nAux] +CRLF
							Next
							MEMOWRITE( cArquivo, cLogTxt )
						Endif
						aItensCT2 := {}
						aCabecCT2 := {}
						aItens    := {}
						cDtLote   := aDataImp[1]
						nLinha    := "000"
					EndIf
				EndIf
			EndIf
		EndDo
		FT_FUse(cMVPAR)
//		FT_FUse(MV_PAR01)
		
		If Len(aItensCT2) > 0
			cQuery := "SELECT MAX(CT2_DOC) AS CT2_DOC"
			cQuery += " FROM " + RetSqlName("CT2") + " CT2"
			cQuery += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "'"
			cQuery += "   AND CT2_DATA   = '" + Dtos(Ctod(cDtLote)) + "'"
			cQuery += "   AND CT2_LOTE   = 'I00001'"
			cQuery += "   AND CT2.D_E_L_E_T_ <> '*'"

			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRB1", .T., .T.)
			TcSetField("TRB1", "CT2_DOC", "C", 06, 0)
			TRB1->(DbGoTop())
			cNumDoc := StrZero(Val(TRB1->CT2_DOC) + 1, 6, 0)
			TRB1->(DbCloseArea())

			aCabecCT2:= {{"DDATALANC" , Ctod(cDtLote), Nil},;
						 {"CLOTE"     , "I00001", Nil},;
						 {"CSUBLOTE"  , "001", Nil},;
						 {"CDOC"      , cNumDoc, Nil},;
						 {"CPADRAO"   , "", Nil},;
						 {"NTOTINF"   , 0, Nil},;
						 {"NTOTINFLOT", 0, Nil}}

			MsExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCabecCT2 ,aItensCT2, 3)
			If lMsErroAuto
				aLogAuto := GetAutoGRLog()
				For nAux := 1 To Len(aLogAuto)
					cLogTxt += aLogAuto[nAux] +CRLF
				Next
				MEMOWRITE( cArquivo, cLogTxt )
			Endif
			aItensCT2 := {}
			aCabecCT2 := {}
			aItens    := {}
		EndIf
	EndIf
	Return

/*/
------------------------------------------------------------------------------------------
{Protheus.doc} UsePath() / UseArq()
Funcoes para utilizacao em consulta especifica (SXB > DIRCSV), com o objetivo de filtrar
arquivos que contenham extensao .CSV e facilite a busca do usuario em customs
que precisam selecionar arquivos.

@author  DS2U (THOMAS MORAES)
@since   Dez.2020
@version 1.0
@type    function
-----------------------------------------------------------------------------------------
*/

User Function UsePath()
Local cType   := "Arquivos CSV (.CSV) | *.CSV"

	cUseArq := cGetFile(cType,"Arquivos", 1, "C:\", .T.,  nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE), .T., .T.) // "Selecione arquivo "

Return !Empty(cUseArq)


User Function UseArq()

Return(cUseArq)
