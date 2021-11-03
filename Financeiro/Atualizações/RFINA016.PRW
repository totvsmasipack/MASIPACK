#Include "Rwmake.ch"
#Include "TopConn.ch"
#DEFINE OPEN_FILE_ERROR -1

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³RFINA016  ³ Autor ³  Ana Paula QFaustino  ³ Data ³ 22/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Importacao dos Finame Fabricante (Arq. CSV) - A Pagar      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFINA016()

Local aFiname := {}
Local oTable

// Cria array para gerar arquivo de trabalho
AADD(aFiname,{"TB_PARCP","C",02,00})
AADD(aFiname,{"TB_VENC" ,"D",08,00})
AADD(aFiname,{"TB_VALOR","N",14,02})                                                                                   
AADD(aFiname,{"TB_PARCJ","C",02,00})
AADD(aFiname,{"TB_JUROS","N",14,02})

// Cria arquivo de trabalho
If Select("TRB") > 0 
   DbSelectArea("TRB")
   TRB->(DbCloseArea())
EndIf

oTable := FWTemporaryTable():New("TRB",aFiname)
oTable:Create()

cPerg := "XRFINA016 "

If !Pergunte(cPerg,.T.)
   Return
EndIf 

@ 000,000 TO 150,300 DIALOG oDlg1 TITLE "Importacao dos Titulos - Finame Fabricante "

@ 013,007 SAY "Esta rotina Importara o Titulos do Finame Fabricante"
@ 020,007 SAY " do Excel extensao CSV para base microsiga -"
@ 027,007 SAY " Titulos a Pagar "
@ 005,004 TO 052,149 TITLE "Descricao do Programa: "

@ 060,020 BMPBUTTON TYPE 5 ACTION Pergunte("RFINA16") 
@ 060,060 BMPBUTTON TYPE 1 ACTION OkProc()
@ 060,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTERED

Return

//*******************************
	Static Function OkProc()         
//*******************************
Close (oDlg1)

cArq := U_LCSV16()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LCSV16   ³ Autor ³ Ana Paula QFaustino   ³ Data ³ 22/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Abre arquivo .CSV                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//#include "rwmake.ch"
//#DEFINE OPEN_FILE_ERROR -1

User Function LCSV16()

Local cFile:= "C:\RELATO_MICROSIGA\"+TRIM(MV_PAR01)+".CSV"

If FT_FUSE( cFile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " não encontrado!")
	Return
Endif

Processa({|lEnd| U_LETIT16(@lEnd)},"Importação Titulos Finame - Pagar")

Return

//*****************************
	User Function LETIT16(lEnd)
//*****************************	

Local aCab  :={}
Local nDivi := 0
Local cstring := ""

//variáveis da tabela csv
Local cParc  := ""
Local cVenc  := ""
Local cValor := ""
Local cJuros := ""
Local lOK    := .T.
Local nValor := 0.00
Local nJuros := 0.00

Private lMsHelpAuto := .F. // para mostrar os erro na tela
Private lMsErroAuto := .F.

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

	cEmis  := DtoC(dDataBase)
	
	If cParcP <> " "
		cLinha  := Substr(cLinha , nPos+1)
		nPos    := At(";",cLinha)
		cVenc  := Substr(cLinha,1,  nPos - 1)
		
		cLinha  := Substr(cLinha , nPos+1)
		nPos    := At(";",cLinha)
		cValor   := Substr(cLinha,1,  nPos - 1)
		
		cLinha := Substr(cLinha , nPos+1)
		nPos   := At(";",cLinha)
		cJuros  := Substr(cLinha,1,  nPos - 1)
		
	Else
	
		cLinha  := Substr(cLinha , nPos +  2)
		nPos    := At(";",cLinha)
		//cParcJ  := Substr(cLinha,1, nPos - 1)
		cParcJ  := Substr(cLinha,1, nPos)
		
		cLinha := Substr(cLinha , nPos+1)
		nPos   := At(";",cLinha)
		cJuros  := Substr(cLinha, nPos+1)
	
	Endif

	dEmis	:= ctod( Subst( cEmis,1,11),"ddmmyy" )
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
     	cParcP  := StrZero( (Val(cParcP)),2 ) 
     	
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

//Adiciona Titulo no SE2
TRB->(DbGoTop())
Do While !TRB->(Eof())
	If TRB->TB_PARCP <> " "
		If !SE2->(dbSeek(xFilial("SE2")+"883"+mv_par03+TRB->TB_ParcJ))
			IF TRB->TB_JUROS > 0	

				cLoja := Posicione("SA2",1,xFilial('SA2')+alltrim(mv_par06),"A2_LOJA")

				RecLock("SE2",.t.)
				SE2->E2_FILIAL  := xFilial("SE2")
				SE2->E2_PREFIXO := "883"
				SE2->E2_NUM     := mv_par03
				SE2->E2_PARCELA := Alltrim(TRB->TB_PARCJ)
				SE2->E2_TIPO    := "DP"
				SE2->E2_NATUREZA:= "B09"
				SE2->E2_FORNECE := Alltrim(mv_par06)
				SE2->E2_LOJA    := cLoja
				SE2->E2_EMISSAO := dDataBase
				SE2->E2_EMIS1   := dDataBase
				SE2->E2_SALDO   := TRB->TB_JUROS
				SE2->E2_VENCORI := dVenc
				SE2->E2_VENCTO  := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)
				SE2->E2_VENCREA := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)
				SE2->E2_VALOR   := TRB->TB_JUROS
				SE2->E2_HIST    := Alltrim(mv_par05)
				SE2->E2_MOEDA   := val(mv_par04)
				SE2->E2_MSMOEFI := 1
				If mv_par04 <> '01'
					SE2->E2_VLCRUZ  := Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_VENCREA,3,SE2->E2_TXMOEDA),3),2)
				Else
					SE2->E2_VLCRUZ  := TRB->TB_JUROS
				Endif
				SE2->E2_NOMFOR  := Posicione("SA2",1,xFilial("SA2")+Alltrim(mv_par06)+cLoja,"A2_NREDUZ")
				SE2->(MsUnLock())
			EndIf
		EndIf

		SE2->(dbSetOrder(1))
		If !SE2->(dbSeek(xFilial("SE2")+"885"+mv_par03+TRB->TB_ParcP))
			IF TRB->TB_VALOR > 0
				cLoja := Posicione("SA2",1,xFilial('SA2')+Alltrim(mv_par06),"A2_LOJA")
				
				RecLock("SE2",.t.)
				SE2->E2_FILIAL  := xFilial("SE2")
				SE2->E2_PREFIXO := "885"
				SE2->E2_NUM     := mv_par03
				SE2->E2_PARCELA := Alltrim(TRB->TB_PARCP)
				SE2->E2_TIPO    := "DP"
				SE2->E2_NATUREZA:= "B08"
				SE2->E2_FORNECE := Alltrim(mv_par06)
				SE2->E2_LOJA    := cLoja
				SE2->E2_EMISSAO := dDataBase
				SE2->E2_EMIS1   := dDataBase
				SE2->E2_SALDO   := nValor
				SE2->E2_VENCORI := dVenc
				SE2->E2_VENCTO  := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)
				SE2->E2_VENCREA := IIF(dVenc<dDataBase,dDataBase+2,TRB->TB_VENC)
				SE2->E2_VALOR   := nValor
				SE2->E2_HIST    := Alltrim(mv_par05)
				SE2->E2_MOEDA	 := Val(mv_par04)
				SE2->E2_MSMOEFI := 1
				If mv_par04 <> '01'
					SE2->E2_VLCRUZ  := Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_VENCREA,3,SE2->E2_TXMOEDA),3),2)
				Else
					SE2->E2_VLCRUZ  := nValor
				Endif
				SE2->E2_NOMFOR  := Posicione("SA2",1,xFilial("SA2")+Alltrim(mv_par06)+cLoja,"A2_NREDUZ")
				SE2->(MsUnLock())
			ENDIF
		Endif
	Endif
	
	TRB->(DbSkip())
	
EndDo

If lOK
	MSGInfo("Processo de importação finalizado com Sucesso !!!")
Else
	MsgAlert("Problemas na importação, por favor, avise ao Administrador do Sistema...")
Endif

Return