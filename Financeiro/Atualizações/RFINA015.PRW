#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³RFINA015  ³ Autor ³ Ana Paula QFaustino ³ Data ³ 18/11/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Importacao dos Finame Fabricante (Arq. CSV) - A Receber    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINA015()

Local oTable

Local aFiname := {}

// Cria array para gerar arquivo de trabalho
AADD(aFiname,{"TB_PARCP","C",02,00})
AADD(aFiname,{"TB_VENC" ,"D",08,00})
AADD(aFiname,{"TB_VALOR","N",14,02})                                                                                   
AADD(aFiname,{"TB_PARCJ","C",02,00})
AADD(aFiname,{"TB_JUROS","N",14,02})

// Cria arquivo de trabalho
If Select("TRB") > 0 
   DbSelectArea("TRB")
   DbCloseArea()
EndIf

oTable := FWTemporaryTable():New("TRB",aFiname)
oTable:Create()

cPerg := "XRFINA015 "

If !Pergunte(cPerg,.T.)
   Return
EndIf 

@ 000,000 TO 150,300 DIALOG oDlg1 TITLE "Importacao dos Titulos - Finame Fabricante "

@ 013,007 SAY "Esta rotina Importara o Titulos do Finame Fabricante"
@ 020,007 SAY " do Excel extensao CSV para base microsiga -"
@ 027,007 SAY " Titulos a Receber "
@ 005,004 TO 052,149 TITLE "Descricao do Programa: "

@ 060,020 BMPBUTTON TYPE 5 ACTION Pergunte("RFINA15")
@ 060,060 BMPBUTTON TYPE 1 ACTION OkProc1()
@ 060,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkProc    ºAutor  ³Ana Paula QFaustino  º Data ³ 18/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OkProc1()
Close (oDlg1)

cArq := U_LECSV15()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LECSV15   ³ Autor ³ Ana Paula QFaustino   ³ Data ³ 18/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Abre arquivo .CSV                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"
#DEFINE OPEN_FILE_ERROR -1

User Function LECSV15()

Local cFile:= "C:\RELATO_MICROSIGA\"+TRIM(MV_PAR01)+".CSV"

If FT_FUSE( cFile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " não encontrado!")
	Return
Endif

Processa({|lEnd| U_LeTit15(@lEnd)},"Importação Titulos Finame - Receber")

Return

//******************************
	User Function LeTit15(lEnd)
//******************************

Local aCab    := {}
Local nDivi   := 0
Local cstring := ""
Local nCols   := 0
Local nLinha  := 0

//variáveis da tabela CSV
Local cParc  := ""
Local cVenc  := ""
Local cValor := ""
Local cJuros := ""
Local lOK    := .T.
Local nValor := 0.00
Local nJuros := 0.00

Private lMsHelpAuto := .F. // para mostrar os erro na tela
Private lMsErroAuto := .f.

ProcRegua( FT_FLASTREC() )

While !FT_FEOF()
	
	cLinha := FT_FREADLN()

 	IncProc()

 	If (Substr(cLinha,1,1) >= 'A' .And. Substr(cLinha,1,1) <= 'Z') .Or. Substr(cLinha,1,1) = ';' 
	 	FT_FSKIP()
	 	Loop
 	EndIf

	nPos   := At(";",cLinha)
	//cParcP := Substr( cLinha , 1, nPos - 1)
	cParcP := Substr( cLinha , 1, nPos)
	cParcP := cParcP + space( 6-len(cParcP))
/*
	cLinha := Substr(cLinha , nPos+1)
	nPos   := At(";",cLinha)
	cEmis  := Substr(cLinha,1,  nPos - 1)
*/	
	If cParcP <> " "

		cLinha := Substr(cLinha , nPos+1)
		nPos   := At(";",cLinha)
		cVenc  := Substr(cLinha,1,  nPos - 1)
/*
		cLinha  := Substr(cLinha , nPos+1)
		nPos    := At(";",cLinha)
		cVenc  := Substr(cLinha,1,  nPos - 1)
*/		
		cLinha  := Substr(cLinha , nPos+1)
		nPos    := At(";",cLinha)
		cValor   := Substr(cLinha,1,  nPos - 1)
//		cJuros   := Substr(cLinha,1,  nPos - 1)
		
		cLinha := Substr(cLinha , nPos+1)
		nPos   := At(";",cLinha)
		cJuros  := Substr(cLinha,1,  nPos - 1)
//		cValor  := Substr(cLinha,1,  nPos - 1)
		
	Else
	
		cLinha  := Substr(cLinha , nPos +  2)
		nPos    := At(";",cLinha)
		//cParcJ  := Substr(cLinha,1, nPos - 1)
		cParcJ  := Substr(cLinha,1, nPos)		
		
		cLinha := Substr(cLinha , nPos+1)
		nPos   := At(";",cLinha)
		cJuros  := Substr(cLinha, nPos+1)
	
	Endif

   //	dEmis	:= ctod( Subst( cEmis,1,11),"ddmmyy" )
	dVenc	:= ctod( Subst( cVenc,1,11),"ddmmyy" )
	xValor  := StrTran(cValor,".","")
	xValor  := StrTran(xValor,",",".")
	xJuros  := StrTran(cJuros,".","")
	xJuros  := StrTran(xJuros,",",".")
	nValor  := Val(xValor)
	nJuros  := Val(xJuros)
	nTotal  := nValor +nJuros
	
	If cParcP <> " " .and. nTotal > 0

     	//cParcP  := StrZero( (Val(cParcP) + 1),2 ) 
     	cParcP  := StrZero((Val(cParcP)),2 ) 
     	
		RecLock("TRB",.T.)
		TRB->TB_PARCP  := cParcP
		TRB->TB_VENC   := dVenc
		TRB->TB_VALOR  := nValor
		TRB->TB_PARCJ  := cParcP
		TRB->TB_JUROS  := nJuros
		TRB->(MSUnlock())
	EndIf	

	FT_FSKIP()

EndDo

//--  Adiciona Titulo no SE1
TRB->(DbGoTop())
Do While !TRB->(Eof())
	If TRB->TB_PARCP <> " "
		SE1->(DbSetOrder(1))
		SE1->(DbGoTop())
      If !SE1->(DbSeek(xFilial("SE1")+"PR "+MV_PAR03+TRB->TB_PARCP))
			IF TRB->TB_Valor > 0
				
				cCli  := Posicione("SF2",1,xFilial('SF2')+mv_par02+"   "+mv_par06,"F2_CLIENTE")
				cLoja := Posicione("SF2",1,xFilial('SF2')+mv_par02+"   "+mv_par06,"F2_LOJA")
				
				RecLock("SE1",.t.)
				SE1->E1_FILIAL  := xFilial("SE1")
				SE1->E1_PREFIXO := "PR "
				SE1->E1_NUM     := mv_par03
				SE1->E1_PARCELA := Alltrim(TRB->TB_PARCP)
				SE1->E1_TIPO    := "DP"
				SE1->E1_NATUREZA:= "V15"
				SE1->E1_CLIENTE := cCli
				SE1->E1_LOJA    := cLoja
				SE1->E1_EMISSAO := dDataBase
				SE1->E1_EMIS1   := dDataBase
				SE1->E1_SALDO   := TRB->TB_VALOR
				SE1->E1_VENCORI := TRB->TB_VENC
				SE1->E1_STATUS  := "A"
				SE1->E1_SITUACA := "0"
				SE1->E1_VENCTO  := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)// NAO GERA TITULO COM VENCIMENTO < QUE EMISSAO - LIZANDRA - 03/07/13
				SE1->E1_VENCREA := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)
				SE1->E1_VALOR   := TRB->TB_VALOR
				SE1->E1_HIST    := Alltrim(mv_par05)
				SE1->E1_MOEDA   := VAL(mv_par04)
				SE1->E1_VLCRUZ  := TRB->TB_VALOR
				SE1->E1_NOMCLI  := Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_NREDUZ")
				SE1->(MsUnLock())
			EndIf                                                          
		Endif
	EndIf
		
	If TRB->TB_PARCJ <> " "
		SE1->(DbSetOrder(1))
		SE1->(DbGoTop())
      If !SE1->(DbSeek(xFilial("SE1")+"JRS"+MV_PAR03+TRB->TB_PARCJ))
		//If !SE1->(dbSeek(xFilial("SE1")+"JRS"+mv_par02+TRB->TB_PARCJ))
			IF TRB->TB_JUROS > 0
				cCli  := Posicione("SF2",1,xFilial('SF2')+mv_par02+"   "+mv_par06,"F2_CLIENTE")
				cLoja := Posicione("SF2",1,xFilial('SF2')+mv_par02+"   "+mv_par06,"F2_LOJA")
				
				RecLock("SE1",.T.)
				SE1->E1_FILIAL  := xFilial("SE1")
				SE1->E1_PREFIXO := "JRS"
				SE1->E1_NUM     := mv_par03
				SE1->E1_PARCELA := Alltrim(TRB->TB_ParcJ)
				SE1->E1_TIPO    := "DP"
				SE1->E1_NATUREZA:= "V14"
				SE1->E1_CLIENTE := cCli
				SE1->E1_LOJA    := cLoja
				SE1->E1_EMISSAO := dDataBase
				SE1->E1_EMIS1   := dDataBase
				SE1->E1_SALDO   := TRB->TB_JUROS
				SE1->E1_VENCORI := TRB->TB_VENC
				SE1->E1_STATUS  := "A"
				SE1->E1_SITUACA := "0"
				SE1->E1_VENCTO  := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)  // NAO GERA TITULO COM VENCIMENTO < QUE EMISSAO - LIZANDRA - 03/07/13
				SE1->E1_VENCREA := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)
				SE1->E1_VALOR   := TRB->TB_JUROS
				SE1->E1_HIST    := Alltrim(mv_par05)
				SE1->E1_MOEDA   := VAL(mv_par04)
				SE1->E1_VLCRUZ  := TRB->TB_JUROS
				SE1->E1_NOMCLI  := Posicione("SA1",1,xFilial("SA1")+cCli+cLoja,"A1_NREDUZ")
				SE1->(MsUnLock())
			Endif
		EndIf
	EndIf
		   
	TRB->(DbSkip())
	
EndDo

If lOK
	MSGInfo("Processo de importação finalizado com Sucesso !!!")
Else
	MsgAlert("Problemas na importação, por favor, avise ao Administrador do Sistema...")
Endif

Return