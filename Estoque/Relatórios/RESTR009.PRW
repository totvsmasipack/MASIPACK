#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RESTR009³ Autor ³ Aparecida de F.Stevanato³Data ³ 22.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emite Histórico do Produto/Fornecedor/Cliente   	        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// Alterado em 30/05/2013 por Ana Paula QFaustino
*/

User Function RESTR009()

Private titulo      := ""
Private cString     := "SD1"
Private wnrel       := "RESTR009"
Private aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }   
Private nomeprog    := "RESTR009"
Private cPerg       := "XRESTR009"
Private cArqTrab    := ""
Private cArqRes     := ""
Private cFilTrab    := ""
Private nLastKey    := 0
Private Li          := 99
Private CbTxt       := ""
Private cabec1      := ""
Private cabec2      := ""
Private tamanho     := "G"
Private limite      := 220
Private CbCont      := 0
Private nQtde       := 0
Private nValor      := 0
Private nCont       := 0
Private cDesc       := ""
Private cProdAnt    := ""
Private cFornAnt    := ""
Private nReg        := 0
Private nQtdEntProd := 0
Private nQtdSaiProd := 0
Private nVlrEntProd := 0
Private nVlrSaiProd := 0
Private nQtdEntPer  := 0
Private nQtdSaiPer  := 0
Private cPerAnt     := ""
Private nMedia      := 0
Private nQtdMes     := 0
Private nDet        := 0
Private lFirst      := .T.
Private dDtPer      := CTOD("")
Private cArqCSV     := "C:\Relato_Microsiga\Historico_Prod_Cli_Forn.csv"
Private cRegCSV     := ""
Private nTotEnt     := 0
Private nTotSai     := 0
Private nQtdEnt     := 0
Private nQtdSai     := 0
Private _cCliFor    := ""

	If Pergunte(cPerg,.T.)

		wnrel :=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

		If nLastKey==27
			Set Filter to
			Return
		Endif

		SetDefault(aReturn,cString)


		If !Empty(mv_par06) .And. !Empty(mv_par07)
			ApMsgStop("Pesquisa inválida, escolha Cliente ou Fornecedor")
			Return
		Else
			If !Empty(mv_par06) .And. SubStr(mv_par06,1,3) <> "ZZZ"
				_cCliFor := Alltrim(mv_par06)
			Else
				If !Empty(mv_par07) .And. SubStr(mv_par07,1,3) <> "ZZZ"
					_cCliFor := Alltrim(mv_par07)
				Else
					_cCliFor := ""
				EndIf
			EndIf
		EndIf

		If (cArqCSV := FCreate("C:\Relato_Microsiga\Historico_Prod_Cli_Forn.csv")) == -1
			Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
		Else
			cRegCSV := "DATA;CLIENTE/FORNECEDOR;PRODUTO;QTDE;"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		EndIf


		mv_par03 := Upper(Alltrim(mv_par03))
		mv_par11 := Upper(mv_par11)

		If Month(mv_par05) == Month(Date()) .And. Year(mv_par05) == Year(Date())
			dDtPer := CTOD("01/"+StrZero(Month(mv_par05),2)+"/"+Str(Year(mv_par05)))
			dDtPer := dDtPer - 1
		Else
			dDtPer := mv_par05
		EndIf

		nQtdMes  := Int((dDtPer - mv_par04) / 30)
		If nQtdMes == 0
			nQtdMes := 1
		EndIf

		Processa({ || GeraTrab() })

		RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},titulo)

	Endif

Return

//**********************************************
	Static Function ImpRel(lEnd,WnRel,cString)
//**********************************************

// Variaveis utilizadas para Impressao do Cabecalho e Rodape
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

If !Empty(mv_par06)
	titulo := "Histórico do Produto " + "/Cliente"
ElseIf !Empty(mv_par07)
	titulo := "Histórico do Produto " + "/Fornecedor"
EndIf

ImpParam()

If mv_par09 == 1 .Or. mv_par09 == 3
	
	Cabec1 := "Fornecedor/Cliente         Produto       Tipo Descrição                           UM   Documento     Dt.Movto      Qtde  Vlr.Unit.  Valor Total  IPI   Vlr.ICMS  TES  Movimento"
	
	DbSelectArea("TRB")
	dbGoTop()
	
	SetRegua(RecCount())   // TOTAL DE ELEMENTOS DA REGUA
	
	Do While !EOF()
		
		If lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
			Exit
		Endif
	    _cMotivo := MV_PAR12 		
		IF UPPER(ALLTRIM(_cMotivo))$ TRB->DESCMOV  .OR. EMPTY(MV_PAR12)  // INICIO DA ALTERAÇÃO - FILTRA SOMENTE OS MOVIMENTOS DESEJADOS - 03/10/12
			If lFirst
				Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
				Li := 8
				cDesc := Alltrim(TRB->DESCPRO)
				@li, 000 Psay SubStr(TRB->CLIFOR,3,6) + "-" + SubStr(TRB->NREDUZ,1,18)
				@li, 026 Psay TRB->PRODUTO
				@li, 042 Psay TRB->TIPO
				@li, 046 Psay SubStr(cDesc,1,33)
				@li, 082 Psay TRB->UM
				cProdAnt := TRB->PRODUTO
				cFornAnt := TRB->CLIFOR
				nDet     := 0
				lFirst   := .F.
			EndIf
			
			If Li > 60
				If TRB->PRODUTO <> cProdAnt .And. Len(cDesc) > 35 .And. (nDet == 1 .Or. nDet == 2)
					If nDet == 1
						@Li, 046 Psay SubStr(cDesc,36,35)
						If Len(cDesc) > 70
							Li++
							@Li, 046 Psay SubStr(cDesc,71,35)
						EndIf
					Else
						If Len(cDesc) > 70
							@Li, 046 Psay SubStr(cDesc,71,35)
						EndIf
					EndIf
					nDet := 0
				EndIf
				Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
				Li := 8
			EndIf
			
			If TRB->PRODUTO <> cProdAnt
				If Len(cDesc) > 35 .And. (nDet == 1 .Or. nDet == 2)
					If nDet == 1
						@Li, 046 Psay SubStr(cDesc,36,35)
						Li++
						If Len(cDesc) > 70
							@Li, 046 Psay SubStr(cDesc,71,35)
							Li++
						EndIf
					Else
						If Len(cDesc) > 70
							@Li, 046 Psay SubStr(cDesc,71,35)
							Li++
						EndIf
					EndIf
				EndIf
				If Li > 8
					@li,000 Psay Replicate("-",220)
					Li++
				EndIf
				cDesc := Alltrim(TRB->DESCPRO)
				@li,000  Psay SubStr(TRB->CLIFOR,3,6) + "-" + SubStr(TRB->NREDUZ,1,18)
				cFornAnt := TRB->CLIFOR
				@li,026  Psay TRB->PRODUTO
				@li,042  Psay Alltrim(TRB->TIPO)
				@li,046  Psay SubStr(cDesc,1,35)
				@li,082  Psay TRB->UM
				cProdAnt := TRB->PRODUTO
				cFornAnt := TRB->CLIFOR
				nDet  := 0
			Else
				If TRB->CLIFOR <> cFornAnt
					@li,000 Psay SubStr(TRB->CLIFOR,3,6) + "-" + TRB->NREDUZ
					cFornAnt := TRB->CLIFOR
				EndIf
			EndIf
			If Len(cDesc) > 35 .And. (nDet == 1 .Or. nDet == 2)
				If nDet == 1
					@Li, 046 Psay SubStr(cDesc,36,35)
				Else
					If Len(cDesc) > 70
						@Li, 046 Psay SubStr(cDesc,71,35)
					EndIf
				EndIf
			EndIf
			@li,085 Psay Alltrim(TRB->DOCUM)
			@li,101 Psay TRB->DTMOV
			@li,110 Psay TRB->QTDE     Picture "@E 99,999.99"
			@li,119 Psay TRB->VLRUNIT  Picture "@E 999,999.99"
			@li,129 Psay TRB->VLRITEM  Picture "@E 99,999,999.99"
			@li,146 Psay TRB->IPI      Picture "@E 99"
			@li,149 Psay TRB->VLRICMS  Picture "@E 999,999.99"
			@li,161 Psay TRB->TES
			@li,166 Psay SubStr(TRB->DESCMOV,1,22)
			cRegCSV :=DTOC(TRB->DTMOV)+";"+TRB->NREDUZ+";"+Alltrim(TRB->PRODUTO)+"-"+TRB->DESCPRO+";"+STR(TRB->QTDE)+";"
			FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			nDet++
			Li++
			If TRB->TPMOV == "E"
				nTotEnt += TRB->VLRITEM
				nQtdEnt += TRB->QTDE
			Else
				nTotSai += TRB->VLRITEM
				nQtdSai += TRB->QTDE
			EndIf
		ENDIF  // FIM DA ALTERAÇCÃO
		dbSelectArea("TRB")
		IncRegua()
		TRB->(dbSkip())
		Loop
	End
	If Len(cDesc) > 35 .And. (nDet == 1 .Or. nDet == 2)
		If nDet == 1
			@Li, 046 Psay SubStr(cDesc,36,35)
			If Len(cDesc) > 70
				Li++
				@Li, 046 Psay SubStr(cDesc,71,35)
			EndIf
		Else
			If Len(cDesc) > 70
				@Li, 046 Psay SubStr(cDesc,71,35)
			EndIf
		EndIf
	EndIf
EndIf

dbSelectArea("TRB")
dbCloseArea()

If mv_par09 > 1
	lFirst    := .T.
	cProdAnt := ""
	cPerAnt  := ""
	titulo += " - Resumo"
	Cabec1 := "Produto         Tipo Descrição                                UM   Local     Periodo            E n t r a d a s             M  e  d  i  a                      S  a  i  d  a  s             M  e  d  i  a "
	Cabec2 := "                                                                                             Qtde.          Valor       Qtde.           Valor               Qtde.           Valor       Qtde.           Valor"
	
	DbSelectArea("RES")
	dbGoTop()
	
	IndRegua("RES",cArqRes,"PRODUTO+PERIODO",,,"Selecionando Registros...")   
	
	SetRegua(RecCount())           	       // TOTAL DE ELEMENTOS DA REGUA
	
	While !EOF()
		
		If lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"      // CANCELADO PELO OPERADOR
			Exit
		Endif
		

		If lFirst
			Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
			Li := 9
			@li, 000 Psay RES->PRODUTO
			@li, 016 Psay RES->TIPO
			@li, 021 Psay SubStr(RES->DESCPRO,1,35)
			@li, 062 Psay RES->UM
			@li, 067 Psay RES->LOCALIZ
			Li		 := 12
			cProdAnt := RES->PRODUTO
			cPerAnt  := RES->PERIODO
			cDesc    := Alltrim(RES->DESCPRO)
			lFirst   := .F.
			nDet     := 1
		EndIf
		If Li > 60
			Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
			Li := 9
			@li, 000 Psay RES->PRODUTO
			@li, 016 Psay RES->TIPO
			@li, 021 Psay SubStr(RES->DESCPRO,1,35)
			@li, 062 Psay RES->UM
			@li, 067 Psay RES->LOCALIZ
			cDesc    := Alltrim(RES->DESCPRO)
			nDet     := 1
			Li		 := 12
		endif	
		
		If RES->PRODUTO <> cProdAnt
			@Li, 077 Psay SubStr(cPerAnt,5,2)
			@Li, 079 Psay "/"
			@Li, 080 Psay SubStr(cPerAnt,1,4)
			@Li,087 Psay nQtdEntPer Picture "@E 99,999.999"
			@Li,151 Psay nQtdSaiPer Picture "@E 99,999.999"
			Li++
			If Len(cDesc) > 35 .And. (nDet == 1 .Or. nDet == 2)
				If nDet == 1
					@Li, 021 Psay SubStr(cDesc,36,35)
					If Len(cDesc) > 70
						Li++
						@Li, 021 Psay SubStr(cDesc,71,35)
					EndIf
				Else
					If Len(cDesc) > 70
						@Li, 021 Psay SubStr(cDesc,71,35)
					EndIf
				EndIf
			EndIf
			@Li,077 Psay "Total => "
			@Li,087 Psay nQtdEntProd Picture "@E 99,999.999"
			@Li,100 Psay nVlrEntProd Picture "@E 99,999,999.99"
			nMedia := nQtdEntProd / nQtdMes
			If nMedia > 0 .And. nMedia < 0.5
				@Li,116 Psay nMedia Picture "@E 99,999.999"
			Else
				@Li,116 Psay Round(nMedia,0) Picture "@E 99,999,999"
			EndIf
			@Li,129 Psay nVlrEntProd / nQtdEntProd Picture "@E 99,999,999.99"
			@Li,151 Psay nQtdSaiProd Picture "@E 99,999.999"
			@Li,165 Psay nVlrSaiProd Picture "@E 99,999,999.99"
			nMedia := nQtdSaiProd / nQtdMes
			If nMedia > 0 .And. nMedia < 0.5
				@Li,179 Psay nMedia Picture "@E 99,999.999"
			Else
				@Li,179 Psay Round(nMedia,0) Picture "@E 99,999,999"
			EndIf
			@Li,192 Psay nVlrSaiProd / nQtdSaiProd Picture "@E 99,999,999.99"
			nQtdEntPer  := 0
			nQtdSaiPer  := 0
			nQtdEntProd := 0
			nQtdSaiProd := 0
			nVlrEntProd := 0
			nVlrSaiProd := 0
			If Li > 60
				Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
			Else               
  				_nEst := Posicione("SB2",1,xFilial("SB2")+cProdAnt,"B2_QATU")
				Li++
				@Li,077 Psay "Consumo => "
				@Li,087 Psay nQtdEntProd-_nEst Picture "@E 99,999.999"
				@Li,100 Psay "Media   => "
				@Li,116 Psay (nQtdEntProd-_nEst)/nQtdMes Picture "@E 99,999.999"
				@Li,130 Psay "Estoque => "
				@Li,142 Psay _nEst Picture "@E 999,999.99"
				Li++
				@li,000 Psay Replicate("-",220)
				Li++
			EndIf
			@Li, 000 Psay RES->PRODUTO
			@Li, 016 Psay RES->TIPO
			@Li, 021 Psay SubStr(RES->DESCPRO,1,35)
			@li, 062 Psay RES->UM
			@li, 067 Psay RES->LOCALIZ
			@Li, 077 Psay SubStr(cPerAnt,5,2)
			@Li, 079 Psay "/"
			@Li, 080 Psay SubStr(cPerAnt,1,4)
			cDesc    := Alltrim(RES->DESCPRO)
			cProdAnt := RES->PRODUTO
			cPerAnt  := RES->PERIODO
			nDet := 1
		Else
			If RES->PERIODO <> cPerAnt
				@Li, 077 Psay SubStr(cPerAnt,5,2)
				@Li, 079 Psay "/"
				@Li, 080 Psay SubStr(cPerAnt,1,4)
				@li,087 Psay nQtdEntPer Picture "@E 99,999.999"
				@li,151 Psay nQtdSaiPer Picture "@E 99,999.999"
				nQtdEntPer := 0
				nQtdSaiPer := 0
				Li++
				If Len(cDesc) > 35 .And. (nDet == 1 .Or. nDet == 2)
					If nDet == 1
						@Li, 021 Psay SubStr(cDesc,36,35)
					Else
						If Len(cDesc) > 70
							@Li, 021 Psay SubStr(cDesc,71,35)
						EndIf
					EndIf
				EndIf
				cPerAnt := RES->PERIODO
				nDet++
			EndIf
		EndIf
		If RES->TPMOV == "E"
			nVlrEntProd += RES->VLRITEM
			nQtdEntProd += RES->QTDE
			nQtdEntPer  += RES->QTDE
		Else
			nVlrSaiProd += RES->VLRITEM
			nQtdSaiProd += RES->QTDE
			nQtdSaiPer  += RES->QTDE
		EndIf
		IncRegua()
		RES->(dbSkip())
		Loop
	Enddo
	@Li, 077 Psay SubStr(cPerAnt,5,2)
	@Li, 079 Psay "/"
	@Li, 080 Psay SubStr(cPerAnt,1,4)
	@li,087 Psay nQtdEntPer Picture "@E 99,999.999"
	@li,151 Psay nQtdSaiPer Picture "@E 99,999.999"
	Li += 2
	If Len(cDesc) > 35 .And. (nDet == 1 .Or. nDet == 2)
		If nDet == 1
			@Li, 021 Psay SubStr(cDesc,36,35)
			If Len(cDesc) > 70
				Li++
				@Li, 021 Psay SubStr(cDesc,71,35)
			EndIf
		Else
			@Li, 021 Psay SubStr(cDesc,71,35)
		EndIf
	EndIf
	@Li,077 Psay "Total => "
	@Li,087 Psay nQtdEntProd Picture "@E 99,999,999"
	@Li,100 Psay nVlrEntProd Picture "@E 99,999,999.99"
	nMedia := nQtdEntProd / nQtdMes
	If nMedia > 0 .And. nMedia < 0.5
		@Li,116 Psay nMedia Picture "@E 99,999.999"
	Else
		@Li,116 Psay Round(nMedia,0) Picture "@E 99,999,999"
	EndIf
	@Li,129 Psay nVlrEntProd / nQtdEntProd Picture "@E 99,999,999.99"
	
	@Li,151 Psay nQtdSaiProd Picture "@E 99,999.999"
	@Li,165 Psay nVlrSaiProd Picture "@E 99,999,999.99"
	nMedia := nQtdSaiProd / nQtdMes
	If nMedia > 0 .And. nMedia < 0.5
		@Li,179 Psay nMedia Picture "@E 99,999.999"
	Else
		@Li,179 Psay Round(nMedia,0) Picture "@E 99,999,999"
	EndIf
	@Li,192 Psay nVlrSaiProd / nQtdSaiProd Picture "@E 99,999,999.99"
	Li++
	_nEst := Posicione("SB2",1,xFilial("SB2")+cProdAnt,"B2_QATU")
	Li++
	@Li,077 Psay "Consumo=> "
	@Li,087 Psay nQtdEntProd-_nEst Picture "@E 99,999.999"
	@Li,100 Psay "Media   => "
	@Li,116 Psay (nQtdEntProd-_nEst)/nQtdMes Picture "@E 99,999.999"
	@Li,130 Psay "Estoque => "
	@Li,142 Psay _nEst Picture "@E 999,999.99"
	Li++
	@li,000 Psay Replicate("-",220)
	Li++
EndIf

Li+=2
If nTotEnt > 0
	@Li,000 Psay "Total de Entradas => "
	@Li,022 Psay nQtdEnt Picture "@E 999,999,999"
	@Li,037 Psay nTotEnt Picture "@E 999,999,999.99"
	Li++
EndIf
If nTotSai > 0
	@Li,000 Psay "Total de Saidas => "
	@Li,022 Psay nQtdSai Picture "@E 999,999,999"
	@Li,037 Psay nTotSai Picture "@E 999,999,999.99"
EndIf

If li != 80
	Roda(cbcont,cbtxt)
Endif

FClose(cArqCSV)

dbSelectArea("RES")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())
Ferase(cArqRes+GetDBExtension())
Ferase(cArqRes+OrdBagExt())

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao	 ³ GeraTrab	³  Cria Arquivo de Trabalho             ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraTrab()

Local aCampos	:= {}
Local aResumo	:= {}
Local lExstDesc	:= !Empty(FWSX3Util():GetDescription( 'F4_DESCRIC' ))
Local oTable	:= Nil

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de Trabalho - Relatorio                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aCampos,{ "TPMOV"  ,"C",001,0 } )
	AADD(aCampos,{ "DESCMOV","C",025,0 } )
	AADD(aCampos,{ "PRODUTO","C",015,0 } )
	AADD(aCampos,{ "DESCPRO","C",105,0 } )
	AADD(aCampos,{ "UM"     ,"C",003,0 } )
	AADD(aCampos,{ "CLIFOR" ,"C",008,0 } )
	AADD(aCampos,{ "NREDUZ" ,"C",020,0 } )
	AADD(aCampos,{ "EST"    ,"C",002,0 } )
	AADD(aCampos,{ "DTMOV"  ,"D",008,0 } )
	AADD(aCampos,{ "DOCUM"  ,"C",014,0 } )
	AADD(aCampos,{ "PEDIDO" ,"C",006,0 } )
	AADD(aCampos,{ "QTDE"   ,"N",010,3 } )
	AADD(aCampos,{ "VLRUNIT","N",014,5 } )
	AADD(aCampos,{ "VLRITEM","N",014,2 } )
	AADD(aCampos,{ "VLRICMS","N",011,4 } )
	AADD(aCampos,{ "IPI"    ,"N",005,2 } )
	AADD(aCampos,{ "TES"    ,"C",003,0 } )
	AADD(aCampos,{ "TIPO"   ,"C",002,0 } )

	If Select("TRB") > 0
		DbSelectArea("TRB")
		TRB->(DbCloseArea())
	EndIf

	oTable := FWTemporaryTable():New("TRB",aCampos)
	oTable:AddIndex("IND1",{"PRODUTO","DTMOV","DOCUM"})
	oTable:Create()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de Trabalho - Resumo                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aResumo,{ "PERIODO","C",006,0 } )
	AADD(aResumo,{ "TPMOV"  ,"C",001,0 } )
	AADD(aResumo,{ "PRODUTO","C",015,0 } )
	AADD(aResumo,{ "DESCPRO","C",105,0 } )
	AADD(aResumo,{ "QTDE"   ,"N",014,3 } )
	AADD(aResumo,{ "TIPO"   ,"C",002,0 } )
	AADD(aResumo,{ "LOCALIZ","C",008,0 } )
	AADD(aResumo,{ "UM"     ,"C",003,0 } )
	AADD(aResumo,{ "VLRITEM","N",014,2 } )

	If Select("RES") > 0
		DbSelectArea("RES")
		RES->(DbCloseArea())
	EndIf

	oTable := FWTemporaryTable():New("RES",aResumo)
	oTable:Create()

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf

_cQuery := ""

// 01/03/2006 -> A partir desta data as Notas de Entradas já entraram no Microsiga (SF1)
// 01/04/2008 -> A partir desta data as Notas de Saidas já estraram no Microsiga (SF2)
// Tabela SZH -> Contem as Notas de Entradas e Saidas do Integra (Entradas até 28/02/2006, Saidas até 31/03/2008)

If mv_par08 == 1 .Or. mv_par08 == 3
	If Dtos(mv_par04) >= '20060301' .Or. Dtos(mv_par05) >= '20060301'
		_cQuery := "SELECT SD1.D1_FILIAL FILIAL, "
		_cQuery += "SD1.D1_COD PRODUTO, "
		_cQuery += "SD1.D1_DTDIGIT DTMOV, "
		_cQuery += "'E' TPMOV, "
		_cQuery += "SD1.D1_FORNECE FORCLI, "
		_cQuery += "SD1.D1_LOJA LOJA, "
		_cQuery += "' ' CLIFOR, "
		_cQuery += "SD1.D1_DOC DOC, "
		_cQuery += "SD1.D1_SERIE SERIE, "
		_cQuery += "SD1.D1_ITEM ITEM, "
		_cQuery += "SD1.D1_UM UM, "
		_cQuery += "SD1.D1_PEDIDO PEDIDO, "
		_cQuery += "SD1.D1_TES TES, "
		_cQuery += "SD1.D1_QUANT QUANT, "
		_cQuery += "SD1.D1_VUNIT VUNIT, "
		_cQuery += "SD1.D1_VALICM ICMS, "
		_cQuery += "SD1.D1_IPI IPI "
		_cQuery += "FROM " + RetSqlName("SD1") + " SD1 "
		_cQuery += "WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND SD1.D1_COD Between '" + mv_par01 + "' AND '" + mv_par02 + "'"
		If Dtos(mv_par04) >= '20060301'
			_cQuery += " AND SD1.D1_DTDIGIT Between '" + Dtos(mv_par04) + "' AND '" + Dtos(mv_par05) + "'"
		Else
			_cQuery += " AND SD1.D1_DTDIGIT Between '20060301' AND '" + Dtos(mv_par05) + "'"
		EndIf
		If Alltrim(mv_par11) <> ""
			_cQuery += " AND SD1.D1_COD Like '%" + Alltrim(mv_par11) + "%'"
		EndIf
		If !Empty(_cCliFor)
			_cQuery += " AND SD1.D1_FORNECE = '" + _cCliFor + "'"
		EndIf
		_cQuery += " AND SD1.D_E_L_E_T_ = ' ' "
	EndIf
	If Dtos(mv_par04) < '20060301'
		If !Empty(_cQuery)
			_cQuery += "UNION ALL "
		EndIf
		_cQuery += "SELECT SZH.ZH_FILIAL FILIAL, "
		_cQuery += "SZH.ZH_PRODUTO PRODUTO, "
		_cQuery += "SZH.ZH_DTMOV DTMOV, "
		_cQuery += "SZH.ZH_TIPO TPMOV, "
		_cQuery += "SZH.ZH_CODCF FORCLI, "
		_cQuery += "SZH.ZH_LOJA LOJA, "
		_cQuery += "SZH.ZH_CLIFOR CLIFOR, "
		_cQuery += "SZH.ZH_DOCUM DOC, "
		_cQuery += "' ' SERIE, "
		_cQuery += "SZH.ZH_ITEM ITEM, "
		_cQuery += "' ' UM, "
		_cQuery += "SZH.ZH_PEDIDO PEDIDO, "
		_cQuery += "SZH.ZH_TES TES, "
		_cQuery += "SZH.ZH_QTDE QUANT, "
		_cQuery += "SZH.ZH_VLRUNIT VUNIT, "
		_cQuery += "SZH.ZH_VLRICMS ICMS, "
		_cQuery += "SZH.ZH_IPI IPI "
		_cQuery += "FROM " + RetSqlName("SZH") + " SZH "
		_cQuery += "WHERE SZH.ZH_FILIAL = '" + xFilial("SZH") + "' AND SZH.ZH_PRODUTO Between '" + mv_par01 + "' AND '" + mv_par02 + "' "
		_cQuery += "AND SZH.ZH_DTMOV Between '" + Dtos(mv_par04) + "' AND '20060228'"
		If Alltrim(mv_par11) <> ""
			_cQuery += " AND SZH.ZH_PRODUTO Like '%" + Alltrim(mv_par11) + "%'"
		EndIf
		_cQuery += " AND SZH.ZH_TIPO = 'E'"
		If !Empty(_cCliFor)
			_cQuery += " AND SZH.ZH_CODCF = '" + _cCliFor + "'"
		EndIf
		_cQuery += " AND SZH.D_E_L_E_T_ = ' ' "
	EndIf
	If mv_par08 == 3
		_cQuery += "UNION ALL "
	EndIf
EndIf

If mv_par08 == 2 .Or. mv_par08 == 3
	If Dtos(mv_par04) >= '20080401' .Or. Dtos(mv_par05) >= '20080401'
		_cQuery += "SELECT SD2.D2_FILIAL FILIAL, "
		_cQuery += "SD2.D2_COD PRODUTO, "
		_cQuery += "SD2.D2_EMISSAO DTMOV, "
		_cQuery += "'S' TPMOV, "
		_cQuery += "SD2.D2_CLIENTE FORCLI, "
		_cQuery += "SD2.D2_LOJA LOJA, "
		_cQuery += "' ' CLIFOR, "
		_cQuery += "SD2.D2_DOC DOC, "
		_cQuery += "SD2.D2_SERIE SERIE,
		_cQuery += "SD2.D2_ITEM ITEM, "
		_cQuery += "SD2.D2_UM UM, "
		_cQuery += "SD2.D2_PEDIDO PEDIDO, "                                      
		_cQuery += "SD2.D2_TES TES, "
		_cQuery += "SD2.D2_QUANT QUANT, "
		_cQuery += "SD2.D2_PRCVEN VUNIT, "
		_cQuery += "SD2.D2_VALICM ICMS, "
		_cQuery += "SD2.D2_IPI IPI "
		_cQuery += "FROM " + RetSqlName("SD2") + " SD2 "
		_cQuery += "WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D2_COD Between '" + mv_par01 +"' AND '" + mv_par02 + "'"
		If Dtos(mv_par04) >= '20080401'
			_cQuery += " AND SD2.D2_EMISSAO Between '" + Dtos(mv_par04) + "' AND '" + Dtos(mv_par05) + "'"
		Else
			_cQuery += " AND SD2.D2_EMISSAO Between '20080401' AND '" + Dtos(mv_par05) + "'"
		EndIf
		If Alltrim(mv_par11) <> ""
			_cQuery += " AND SD2.D2_COD Like '%" + Alltrim(mv_par11) + "%'"
		EndIf
		If !Empty(_cCliFor)
			_cQuery += " AND SD2.D2_CLIENTE = '" + _cCliFor + "'"
		EndIf
		_cQuery += " AND SD2.D_E_L_E_T_ =  ' ' "
	EndIf
	If Dtos(mv_par04) < '20080401'
		If !Empty(_cQuery)
			_cQuery += "UNION ALL "
		EndIf
		_cQuery += "SELECT SZH.ZH_FILIAL FILIAL, "
		_cQuery += "SZH.ZH_PRODUTO PRODUTO, "
		_cQuery += "SZH.ZH_DTMOV DTMOV, "
		_cQuery += "SZH.ZH_TIPO TPMOV, "
		_cQuery += "SZH.ZH_CODCF FORCLI, "
		_cQuery += "SZH.ZH_LOJA LOJA, "
		_cQuery += "SZH.ZH_CLIFOR CLIFOR, "
		_cQuery += "SZH.ZH_DOCUM DOC, "
		_cQuery += "' ' SERIE, "
		_cQuery += "SZH.ZH_ITEM ITEM, "
		_cQuery += "' ' UM, "
		_cQuery += "SZH.ZH_PEDIDO PEDIDO, "
		_cQuery += "SZH.ZH_TES TES, "
		_cQuery += "SZH.ZH_QTDE QUANT, "
		_cQuery += "SZH.ZH_VLRUNIT VUNIT, "
		_cQuery += "SZH.ZH_VLRICMS ICMS, "
		_cQuery += "SZH.ZH_IPI IPI "
		_cQuery += "FROM " + RetSqlName("SZH") + " SZH "
		_cQuery += "WHERE SZH.ZH_FILIAL = '" + xFilial("SZH") + "' AND SZH.ZH_PRODUTO Between '" + mv_par01 + "' AND '" + mv_par02 + "' AND SZH.ZH_DTMOV Between '" + Dtos(mv_par04) + "' AND '20080331'"
		If Alltrim(mv_par11) <> ""
			_cQuery += " AND SZH.ZH_PRODUTO Like '%" + Alltrim(mv_par11) + "%'"
		EndIf
		_cQuery += " AND SZH.ZH_TIPO = 'S'"
		If !Empty(_cCliFor)
			_cQuery += " AND SZH.ZH_CODCF = '" + _cCliFor + "'"
		EndIf
		_cQuery += " AND SZH.D_E_L_E_T_ = ' ' "
	EndIf
EndIf

DbUseArea( .T., 'TOPCONN',TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)

dbSelectArea('SB1')
SB1->(DbSetOrder(1))

dbSelectArea('SF4')
SF4->(DbSetOrder(1))

Do While !QR1->(Eof())
	If !SB1->(DbSeek(xFilial("SB1")+QR1->PRODUTO))
		QR1->(DbSkip())
		Loop
	EndIf

	SF4->(dbSeek(xFilial("SF4") + QR1->TES))
	
	If !Empty(mv_par10) .And. SubStr(mv_par10,1,2) <> "ZZ"      // Filtra tipo do produto
		If Alltrim(SB1->B1_TIPO) <> Alltrim(mv_par10)
			QR1->(DbSkip())
			Loop
		EndIf
	EndIf
	//Ivandro Santos - 04/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	cDesc := Alltrim(GetAdvFval("SB5","B5_CEME",xFilial("SB5")+QR1->PRODUTO,1," ")) //cDesc := ""
	/*If !Empty(SB1->B1_DESCP)
		cDesc := Alltrim(SB1->B1_DESCP)
	Else*/
	If Empty(cDesc)
	//Ticket#2017031037000107 — Fim da alteração
		cDesc := Alltrim(SB1->B1_DESC)
	EndIf
	If !Empty(mv_par03) .AND. SubStr(mv_par03,1,3) <> "ZZZ"     // Filtra parte de nome na descrição do produto
		If !mv_par03 $ Upper(cDesc)
			QR1->(DbSkip())
			Loop
		Endif
	EndIf
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->TPMOV   := QR1->TPMOV
	TRB->PRODUTO := QR1->PRODUTO
	TRB->DTMOV   := STOD(QR1->DTMOV)
	TRB->DESCPRO := cDesc
	TRB->UM      := QR1->UM
	TRB->DOCUM   := Alltrim(QR1->DOC) + "/" + QR1->ITEM
	TRB->PEDIDO  := QR1->PEDIDO
	TRB->QTDE    := QR1->QUANT
	TRB->VLRUNIT := QR1->VUNIT
	TRB->VLRITEM := QR1->VUNIT * QR1->QUANT
	TRB->VLRICMS := QR1->ICMS
	TRB->IPI     := QR1->IPI
	TRB->TES     := QR1->TES
	TRB->TIPO    :=  SB1->B1_TIPO
	If SF4->(FOUND()) .And. lExstDesc
		TRB->DESCMOV := TRB->TPMOV + "-"+ SubStr(SF4->F4_DESCRIC,1,23)
	EndIf
	cTipoCF := Alltrim(QR1->CLIFOR)
	If Empty(cTipoCF)
		If TRB->TPMOV == "E"
			If SF1->(DbSeek(xFilial("SF1")+QR1->DOC+QR1->SERIE+QR1->FORCLI+QR1->LOJA))
				If SF1->F1_TIPO $ "NIPC"
					cTipoCF := "F"
				Else
					cTipoCF := "C"
				EndIf
			EndIf
		ElseIf TRB->TPMOV == "S"
			If SF2->(DbSeek(xFilial("SF2")+QR1->DOC+QR1->SERIE+QR1->FORCLI+QR1->LOJA))
				If SF2->F2_TIPO $ "NIPC"
					cTipoCF := "C"
				Else
					cTipoCF := "F"
				EndIf
			EndIf
		EndIf
	EndIf
	If cTipoCF == "C"
		If SA1->(dbSeek(xFilial("SA1")+QR1->FORCLI+QR1->LOJA))
			TRB->NREDUZ := SA1->A1_NREDUZ
			TRB->EST    := SA1->A1_EST
		EndIf
	ElseIf cTipoCF == "F"
		If SA2->(dbSeek(xFilial("SA2")+QR1->FORCLI+QR1->LOJA))
			TRB->NREDUZ := SA2->A2_NREDUZ
			TRB->EST    := SA2->A2_EST
		EndIf
	EndIf
	TRB->CLIFOR := cTipoCF + "-" + QR1->FORCLI
	TRB->(MsUnLock())
	nReg++
	If QR1->DTMOV <= Dtos(dDtPer)
		dbSelectArea("RES")
		RecLock("RES",.T.)
		RES->PERIODO := SubStr(QR1->DTMOV,1,6)
		RES->TPMOV   := TRB->TPMOV
		RES->PRODUTO := QR1->PRODUTO
		RES->DESCPRO := cDesc
		RES->QTDE    := QR1->QUANT
		RES->TIPO    := SB1->B1_TIPO
		RES->LOCALIZ := SB1->B1_LOCAL
		RES->UM      := QR1->UM
		RES->VLRITEM := QR1->QUANT * QR1->VUNIT
		RES->(MsUnLock())
	EndIf
	QR1->(dbSkip())
EndDo

dbCommitAll()

Return

//******************************
	Static Function ImpParam()
//******************************
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
Li:= 10
@Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
Li+=3
@Li,000 Psay "Produto de...............: " + mv_par01
@li,045 Psay  "ate: " + mv_par02
Li+=2
@Li,000 Psay "Que contenham a expressão: " + mv_par03
Li+=2
@Li,000 Psay "Data Movimento de........: " + DTOC(mv_par04)
@li,045 Psay  "ate: " + DTOC(mv_par05)
If mv_par09 > 1
	Li+=2
	@Li,000 Psay "Periodo do Resumo de .: " + DTOC(mv_par04)
	@li,045 Psay  "ate: " + DTOC(dDtPer) + " ==> "  + Str(nQtdMes,3) + " mes(es)"
EndIf
Li+=2
@Li,000 Psay "Cliente..................: " + mv_par06
Li+=2
@Li,000 Psay "Fornecedor...............: " + mv_par07
Li+=2
@Li,000 Psay "Movimento................: "
Do Case
	Case mv_par08 == 1
		@Li,028 Psay "Entrada"
	Case mv_par08 == 2
		@Li,028 Psay "Saida"
	Case mv_par08 == 3
		@Li,028 Psay "Entrada e Saida"
End
Li+=2
@Li,000 Psay "Imprime..................: "
Do Case
	Case mv_par09 == 1
		@Li,028 Psay "Somente Itens"
	Case mv_par09 == 2
		@Li,028 Psay "Somente Resumo"
	Case mv_par09 == 3
		@Li,028 Psay "Itens + Resumo"
End

Li+=2
@Li,000 Psay "Tipo de Material.........: " + mv_par10
Li:=80

Return
