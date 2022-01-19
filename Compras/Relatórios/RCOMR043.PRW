#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RCOMR043
Relatório de Cotações
@type  Function
@author E.DINIZ - [ DS2U ]
@since 12/01/2022
/*/
User Function RCOMR043()

Local oReport

	Pergunte("MTR150",.F.)
	oReport:= ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()

Local oReport	:= Nil
Local oSection1	:= Nil
Local oSection2	:= Nil
Local cTitle	:= "Emissao das cotacoes de compras"
Local cPerg		:= "MTR150"
Local cDescPro	:= ""
Local nItem		:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01	     	  Do Numero                              ³
	//³ mv_par02	     	  Ate o Numero 		                     ³
	//³ mv_par03	     	  Do Fornecedor                          ³
	//³ mv_par04              Ate o Fornecedor            	     	 ³
	//³ mv_par05              Ate a data de validade      	   	     ³
	//³ mv_par06              Campo Descricao do Produto             ³
	//³ mv_par07              Endrre‡o Fiscal                        ³
	//³ mv_par08              Cidade - Estado                        ³
	//³ mv_par09              Fax                                    ³
	//³ mv_par10              Qual Unidade de Medida ?               ³
	//³ mv_par11              Telefone                               ³
	//³ mv_par12              Endereco de Entrega ?                  ³
	//³ mv_par13              Endereco de e-mail  ?                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport := TReport():New("MATR150",cTitle,cPerg,{|oReport| ReportPrint(oReport,@cDescPro,@nItem)},"Relacao de Cotacoes")
	oReport:SetPortrait()
	oReport:HideHeader()
	oReport:HideFooter()
	oReport:HideParamPage()
	oReport:SetTotalInLine(.F.)

	oSection1 := TRSection():New(oReport,"Emissao das cotacoes de compras",{"SC8","SM0","SA2"})

	oSection1:SetLineStyle()
	oSection1:SetReadOnly()
	oSection1:SetHeaderSection(.F.)
	oSection1:SetNoFilter("SM0")
	oSection1:SetNoFilter("SA2")
	oSection1:SetCharSeparator("")

	oSection2 := TRSection():New(oSection1,"Relacao de Cotacoes",{"SC8","SB1"})
	oSection2:SetNoFilter("SB1")

	TRCell():New(oSection2,"ITEM"		,"SC8","Item",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| StrZero(++nItem,4) })
	TRCell():New(oSection2,"C8_PRODUTO"	,"SC8","Produto",,,,) //"N/Vosso Codigo"
	TRCell():New(oSection2,"DESCPROD"	,"SB1",RetTitle("B1_DESC"),,40,, {|| cDescPro })
	TRCell():New(oSection2,"C8_QUANT"	,"SC8",,,,, {|| If(mv_par10==2 .And. !Empty(SC8->C8_QTSEGUM),SC8->C8_QTSEGUM,SC8->C8_QUANT) })
	TRCell():New(oSection2,"C8_UM"		,"SC8",,,,, {|| If(mv_par10==2 .And. !Empty(SC8->C8_QTSEGUM),SC8->C8_SEGUM,SC8->C8_UM) })
//	TRCell():New(oSection2,"CDADOS"		,"","Val.Unitario    Valor Total    IPI   Valor do IPI  Prz(dias)",,,,)
	TRCell():New(oSection2,"VLUNIT"		,"","Val.Unitario"	,,40,, {|| "|" + Replicate("_",20) + "|"})
	TRCell():New(oSection2,"VLTOTA"		,"","Val.Total"		,,40,, {|| "|" + Replicate("_",20) + "|"})
	TRCell():New(oSection2,"VLRIPI"		,"","Val.IPI"		,,40,, {|| "|" + Replicate("_",20) + "|"})
	TRCell():New(oSection2,"PRAZO"		,"","Prazo (Dias)"	,,40,, {|| "|" + Replicate("_",20) + "|"})
	TRCell():New(oSection2,"C8_DATPRF"	,"SC8",RetTitle("C8_DATPRF"),,,,)

	oSection2:Cell("DESCPROD"):SetLineBreak()

		
Return oReport



Static Function ReportPrint(oReport,cDescPro,cEmail,cEndEnt,cTel,nItem,cNumCota)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cCondicao	:= ""
Local cCotacao	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cContato	:= ""
Local cVar		:= ""
Local cObs01	:= ""
Local cObs02	:= ""
Local cObs03	:= ""
Local cObs04	:= ""
Local nLinObs	:= 0
Local nX		:= 0
Local cEnd		:= ""
Local dEmissao	:= CtoD("")
Local nPrinted	:= 0
Local nPagina	:= 0
Local nRegistro	:= 0  
Local nTamCdPrd	:= TamSX3("C7_PRODUTO")[1]
Local cFilEnt	:= ""

	dbSelectArea("SC8")
	SC8->(dbSetOrder(1))

	If oReport:nEnvironment == 2    
		oSection2:Cell("ITEM"):nSize 	    := 6
		oSection2:Cell("C8_PRODUTO"):nSize  := IIf(nTamCdPrd==15,22,50)
		oSection2:Cell("DESCPROD"):nSize    := IIf(nTamCdPrd==15,30,10)
		oSection2:Cell("C8_QUANT"):nSize    := 16
		oSection2:Cell("C8_UM"):nSize       := 2
//		oSection2:Cell("CDADOS"):nSize      := 55
		oSection2:Cell("C8_DATPRF"):nSize   := 18
	EndIf

	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'C8_FILIAL == "'+FWxFilial("SC8")+'" .And. '
	cCondicao += 'C8_NUM >= "'+mv_par01+'".And. C8_NUM <= "'+mv_par02+'" .And. '
	cCondicao += 'C8_FORNECE >= "'+mv_par03+'" .And. C8_FORNECE <= "'+mv_par04+'" .And. '	
	cCondicao += 'Empty(C8_NUMPED) '

	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
	TRPosition():New(oSection1,"SA2",1,{|| FWxFilial("SA2") + SC8->C8_FORNECE + SC8->C8_LOJA})

	oReport:onPageBreak( { || nPagina++ , nPrinted := 0 , CabecCT(oReport,oSection1,nPagina,cNumCota,cEmail,cTel) })

	oReport:SetMeter(SC8->(LastRec()))

	oSection2:Init()
	
	While !oReport:Cancel() .And. !SC8->(Eof())

		If oReport:Cancel()
			Exit
		EndIf
		
		cCotacao := SC8->C8_NUM  
		cFornece := SC8->C8_FORNECE
		cLoja    := SC8->C8_LOJA   

		cObs01   := " "
		cObs02   := " "
		cObs03   := " "
		cObs04   := " "
		nLinObs  := 0
		nItem    := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dispara a cabec especifica do relatorio.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:EndPage()

		nPagina  := 0
		nPrinted := 0
			
		While !oReport:Cancel() .And. !SC8->(Eof()) .And. SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA == xFilial("SC8")+cCotacao+cFornece+cLoja
			
			If oReport:Cancel()
				Exit
			EndIf

			cContato := SC8->C8_CONTATO
			dEmissao := SC8->C8_EMISSAO

			oReport:IncMeter() 
			If oReport:Row() > oReport:LineHeight() * 100
				oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, 2290 )
				oReport:SkipLine()
				oReport:PrintText("Continua ....",, 050 )
				oReport:EndPage()
			EndIf

			cDescPro := ""
			
			dbSelectArea("SA5")
			dbSetOrder(1)
			
			If dbSeek(xFilial("SA5") + SC8->C8_FORNECE + SC8->C8_LOJA + SC8->C8_PRODUTO ) ;
				.And. AllTrim(mv_par06) == "A5_NOMPROD"
				cDescPro := Alltrim(A5_NOMPROD)
			EndIf
			
			dbSelectArea("SC8")
			
			If Empty(cDescPro)
				ImpDescr(@cDescPro,.T.)
			EndIf
			
			cFilEnt := SC8->C8_FILENT
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao da Cotacao                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !EMPTY(SC8->C8_OBS) .And. nLinObs < 5
				nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC8->C8_OBS)
			Endif

			oSection2:PrintLine()
			nPrinted ++
/*			
			If !Empty(SA5->A5_CODPRF)
//				oReport:PrintText( Replicate("_",Len("Val.Unitario    Valor Total    IPI   Valor do IPI  Prz(dias)")), oReport:Row(), oSection2:Cell("CDADOS"):ColPos() ) 
//				oReport:PrintText( SA5->A5_CODPRF,oReport:Row(),oSection2:Cell("C8_PRODUTO"):ColPos() )
				oReport:PrintText("|" + Replicate("_",27), oReport:Row(), oSection2:Cell("VLUNIT"):ColPos() )
				oReport:PrintText("|" + Replicate("_",29), oReport:Row(), oSection2:Cell("VLTOTA"):ColPos()-30 )
				oReport:PrintText("|" + Replicate("_",29), oReport:Row(), oSection2:Cell("VLRIPI"):ColPos()-30 )
				oReport:PrintText("|" + Replicate("_",25) + "|", oReport:Row(), oSection2:Cell("PRAZO"):ColPos()-30	)
				oReport:SkipLine()
			Else
//				oReport:PrintText( Replicate("_",Len("Val.Unitario    Valor Total    IPI   Valor do IPI  Prz(dias)")),, oSection2:Cell("CDADOS"):ColPos() )
				oReport:PrintText("|" + Replicate("_",27), oReport:Row(), oSection2:Cell("VLUNIT"):ColPos() )
				oReport:PrintText("|" + Replicate("_",29), oReport:Row(), oSection2:Cell("VLTOTA"):ColPos()-30 )
				oReport:PrintText("|" + Replicate("_",29), oReport:Row(), oSection2:Cell("VLRIPI"):ColPos()-30 )
				oReport:PrintText("|" + Replicate("_",25) + "|", oReport:Row(), oSection2:Cell("PRAZO"):ColPos()-30	) 
			EndIf
*/			
			nPrinted ++

			dbSelectArea("SC8")
			SC8->(dbSkip())
		
		EndDo

		oReport:SkipLine()
		
		If nLinObs > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializar campos de Observacoes.                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(cObs02)
				If Len(cObs01) > 50
					cObs 	:= cObs01
					cObs01:= Substr(cObs,1,50)
					For nX := 2 To 4
						cVar  := "cObs"+StrZero(nX,2)
						&cVar := Substr(cObs,(50*(nX-1))+1,50)
					Next
				EndIf
			Else
				cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
				cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
				cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
				cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
			EndIf
		EndIf

		If oReport:Row() > oReport:LineHeight() * 70

			dbSelectArea("SC8")
			dbSkip(-1)  // condicao onde ja imprimiu tudo mas o rodape sera' impresso em nova pagina
				
			oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, 2290 )
			oReport:SkipLine()
			oReport:PrintText("Continua ....",, 050 )
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Dispara a cabec especifica do relatorio.                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oReport:EndPage()
				
			oSection2:Cell("ITEM"):Hide()
			oSection2:Cell("C8_PRODUTO"):Hide()
			oSection2:Cell("DESCPROD"):Hide()
			oSection2:Cell("C8_QUANT"):Hide()
			oSection2:Cell("C8_UM"):Hide()
			oSection2:Cell("CDADOS"):Hide()
			oSection2:Cell("C8_DATPRF"):Hide()
			oSection2:PrintLine()
			oSection2:Cell("ITEM"):Show()
			oSection2:Cell("C8_PRODUTO"):Show()
			oSection2:Cell("DESCPROD"):Show()
			oSection2:Cell("C8_QUANT"):Show()
			oSection2:Cell("C8_UM"):Show()
			oSection2:Cell("CDADOS"):Show()
			oSection2:Cell("C8_DATPRF"):Show()
			
			dbSelectArea("SC8")
			SC8->(dbSkip())
				
		EndIf
		
		if oReport:GetOrientation() == 1
			nPaisag := 0
		else
			nPaisag := 700
		endif

		oReport:Box( 2480-nPaisag ,  010 , 3012-nPaisag , 2290 ) // Box do rodape'

		oReport:Line( 2660-nPaisag,  010 , 2660-nPaisag , 2290 ) // Completa o Box Observacoes
		oReport:Line( 2660-nPaisag,  840 , 3012-nPaisag ,  840 ) // Completa o Box do Local de Entrega
		oReport:Line( 2660-nPaisag, 1600 , 3012-nPaisag , 1600 ) // Completa o Box do Sub Total

		oReport:Line( 2870-nPaisag , 010 , 2870-nPaisag , 2290 ) // Completa o Box da Alcada

		oReport:PrintText(" ",2490-nPaisag,020)	// Necessario para posicionar Row() para a impressao do Rodape
		
		oReport:PrintText("Observações",,020)  //Observacoes :
		oReport:PrintText(cObs01,,020 )
		oReport:PrintText(cObs02,,020 )
		oReport:PrintText(cObs03,,020 )
		oReport:PrintText(cObs04,,020 )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SM0")
		dbSetOrder(1)   // forca o indice na ordem certa
		nRegistro := Recno()
		MsSeek(SUBS(cNumEmp,1,2)+CFilEnt)

		oReport:SkipLine()
		oReport:PrintText( + "Local de Entrega:",oReport:Row(),  020 )
		oReport:PrintText( + "Sub Total",oReport:Row(),  850 )
		oReport:PrintText( + "Condicao de Pagamento",oReport:Row(), 1610 )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o End de Entrega do SM0 somente quando cEndEnt  == " "     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(cEndEnt)
			cEnd := If( Empty(SM0->M0_ENDENT), " O mesmo ", SM0->M0_ENDENT)
		Else
			cEnd := cEndEnt // imprime o endereco digitado na pergunte
		Endif
		
		Go nRegistro

		oReport:SkipLine()
		oReport:PrintText( + cEnd	,oReport:Row(), 020 )
		oReport:PrintText( + "Descontos ",oReport:Row(), 850 )

		oReport:SkipLine()
		oReport:PrintText( + "Local de Cobranca:",oReport:Row(), 020 )
		oReport:PrintText( + "Total do IPI",oReport:Row(), 850 )

		cEnd := If(Empty(SM0->M0_ENDCOB),Iif(Empty(SM0->M0_ENDENT),"O mesmo",SM0->M0_ENDENT),SM0->M0_ENDCOB)
		oReport:SkipLine()
		oReport:PrintText( + cEnd	,oReport:Row(),  020 )
		oReport:PrintText( + "Frete",oReport:Row(),  850 )
		oReport:PrintText( + "Condicao de Reajuste",oReport:Row(), 1610 )

		oReport:SkipLine()
		oReport:PrintText( + "Contato no Fornecedor",oReport:Row(),  020 )

		oReport:SkipLine()
		oReport:PrintText( + cContato ,oReport:Row(),  020 )
		oReport:PrintText( + "TOTAL DO PEDIDO" + Replicate(".",11)  ,oReport:Row(),  850 )
		oReport:Line( oReport:Row(), 840 , oReport:Row(), 1600 ) // Linha do Total do Pedido

		oReport:SkipLine()
		oReport:SkipLine()
		oReport:PrintText( + "Alcada 1",oReport:Row(),  020 )
		oReport:PrintText( + "Alcada 2",oReport:Row(),  850 )
		oReport:PrintText( + "Emitido em :" +" "+Dtoc(dEmissao) ,oReport:Row(), 1610)

		dbSelectArea("SC8")

	Enddo
	oSection2:Finish()

	dbSelectArea("SC8")
	Set Filter To
	
	SC8->(dbSetOrder(1))

Return


Static Function ImpValores()

	dbSelectArea("SC8")

	If mv_par10 == 2 .And. !Empty(SC8->C8_QTSEGUM)
		@li, 52 PSAY  SC8->C8_QTSEGUM Picture "99999999.99"
		@li, 64 PSAY  SC8->C8_SEGUM
	Else
		@li, 52 PSAY  SC8->C8_QUANT Picture "99999999.99"
		@li, 64 PSAY  SC8->C8_UM
	Endif

	@li,119 PSAY  "dias"
	@li,124 PSAY  SC8->C8_DATPRF
	li++

	dbSelectArea("SC8")

Return


Static Function ImpDescr(cDescri,lTReport)

Local nBegin  := 0
Local nLinha  := 0

DEFAULT cDescri   := ""
DEFAULT lTReport  := .F.

	If Empty(mv_par06)
		mv_par06 := "B1_DESC"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao cientifica do Produto.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(mv_par06) == "B5_CEME"
		dbSelectArea("SB5")
		SB5->(dbSetOrder(1))
		If SB5->(dbSeek(xFilial("SB5")+SC8->C8_PRODUTO))
			cDescri := Alltrim(SB5->B5_CEME)
		EndIf
	ElseIf AllTrim(mv_par06) == "A5_NOMPROD" .And. !lTReport
		dbSelectArea("SA5")
		SA5->(dbSetOrder(1))
		If SA5->(dbSeek(xFilial("SA5")+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO))
			cDescri := Alltrim(SA5->A5_NOMPROD)
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao do produto do arquivo de Cotacoes.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(mv_par06) == "C1_DESCRI"
		dbSelectArea("SC1")
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(FWxFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC))
			cDescri := Alltrim(SC1->C1_DESCRI)
		Endif
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao do Produto SB1.		         		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	SB1->(dbSeek(FWxFilial("SB1")+SC8->C8_PRODUTO))
	If Empty(cDescri)
		cDescri := Alltrim(SB1->B1_DESC)
	EndIf

	dbSelectArea("SC8")

	If !lTReport
		
		nLinha:= MLCount(cDescri,30)
		@ li,021 PSAY MemoLine(cDescri,30,1)
		ImpValores()
		
		For nBegin := 2 To nLinha
			@ li,021 PSAY Memoline(cDescri,30,nBegin)
			If nBegin == 2
				@ li,067 PSAY Replicate("-",51)
			EndIf
			li++
		Next nBegin

		dbSelectArea("SA5")
		SA5->(dbSetOrder(2))
		If SA5->(dbSeek(FWxFilial("SA5")+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA))
			If !Empty(SA5->A5_CODPRF)
				@li,3 PSAY Alltrim(SA5->A5_CODPRF)
			EndIf
		Endif
		
		If nLinha < 2
			@ li,067 PSAY Replicate("-",51)
		EndIf

	EndIf

Return



Static Function CabecCT(oReport,oSection1,nPagina,cNumCota,cEmail,cTel)

Local cLogo			:= ''
Local nTpImp	  	:= IIF(ValType(oReport:nDevice)!=Nil,oReport:nDevice,0) // Tipo de Impressao
Local nPageWidth	:= IIF(nTpImp==1.Or.nTpImp==6,2435,2435)

Default cNumCota := ""

	oSection1:Init()

	If cPaisLoc == "BRA"
		cCGC := Transform(SA2->A2_CGC, Iif(SA2->A2_TIPO == 'F', Substr(PICPES(SA2->A2_TIPO),1,17), Substr(PICPES(SA2->A2_TIPO),1,21))) 
	Else  
		cCGC := SA2->A2_CGC
	EndIf 

	oReport:Box( 010 , 010 ,  260 , 1000 )
	oReport:Box( 010 , 1010,  260 , nPageWidth-2 )

	cLogo := GetSrvProfString('Startpath','') + R110Logo()
	oReport:SayBitmap(25,25,cLogo,080,080)

	oReport:SkipLine()
	oReport:PrintText( PadR("C O T A Ç Ã O  D E  C O M P R A S - " + GetMV("MV_MOEDA" + Alltrim(Str(SC8->C8_MOEDA))),64), oReport:Row(), 1030 )
	oReport:PrintText( "Nº: " + SC8->C8_NUM + " - Página: " + Ltrim(Str(nPagina,2)) , oReport:Row(), 1920 )

	oReport:SkipLine(2)
	oReport:PrintText("Empresa: " + SM0->M0_NOMECOM, oReport:Row(), 15)
	oReport:PrintText(PadR("Empresa: " + ALLTRIM(SA2->A2_NOME),64) + "Código: "  + SA2->(A2_COD + "/" + A2_LOJA), oReport:Row(), 1025)
	oReport:SkipLine()

	oReport:PrintText("Endereço: " + SM0->M0_ENDENT,oReport:Row(), 15)
	oReport:PrintText(PadR("Endereço: " + ALLTRIM(SA2->A2_END),64) + "Bairro: " + Substr(SA2->A2_BAIRRO,1,25), oReport:Row(), 1025)
	oReport:SkipLine()

	oReport:PrintText("Município: " + RTRIM(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT + " - CEP: " + Trans(SM0->M0_CEPENT,PesqPict("SA2","A2_CEP")), oReport:Row(), 15)
	oReport:PrintText(PadR("Município: " + Alltrim(SA2->A2_MUN) + " - " + SA2->A2_EST + " - CEP: " + SA2->A2_CEP, 64) + "CNPJ/CPF: " + cCGC, oReport:Row(), 1025)
	oReport:SkipLine()

	oReport:PrintText("Telefone: " + SM0->M0_TEL + Space(2) + "FAX: " + SM0->M0_FAX ,oReport:Row(), 15)
	oReport:PrintText(PadR("Telefone: " + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) + "FAX: ("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15),64) + If( cPaisLoc$"ARG|POR|EUA",space(11) , "Inscr. Estadual: " ) + " " + If( cPaisLoc$"ARG|POR|EUA",space(18), SA2->A2_INSCR ), oReport:Row(), 1025)
	oReport:SkipLine()

	oReport:PrintText("E-Mail: " + ALLTRIM(SA2->A2_EMAIL2), oReport:Row(), 1025)

	oReport:SkipLine(2)

/*
	oReport:Box(  010 , 010 , 380 , 2290 )  // Boxes do cabecalho
	oReport:Line( 010 , 840 , 380 , 0840 )

	cLogo := GetSrvProfString('Startpath','') + R110Logo()
	oReport:SayBitmap(25,25,cLogo,150,60) // insere o logo no relatorio

	oReport:PrintText( If(nPagina > 1,("- "+"Continuacao")," "),,020 )
	oReport:PrintText( + "COTACAO N. " + SC8->C8_NUM + Space(20) + ;
		" Vencimento " + DTOC(SC8->C8_VALIDA) + Space(20) + "Pagina  " + StrZero(nPagina,4),,940)

	oSection1:PrintLine()

	oReport:PrintText("PREZADOS SENHORES.",120,020)

	If !Empty(SA2->A2_NOME)
//		oReport:PrintText(SubStr(SA2->A2_NOME,1,If(aTamSXG[1] != aTamSXG[3],25,40))+" ("+SA2->A2_COD+" - "+SA2->A2_LOJA+")",120,020)
//		oReport:PrintText("Por favor queira referenciar este numero para quaisquer troca de",120,890)
		
		oReport:PrintText(SA2->A2_END,150,020)
//		oReport:PrintText("informacoes referentes a esta cotacao.",150,890)
		
		cStrlin := AllTrim(SA2->A2_BAIRRO) + "  " + Alltrim(SA2->A2_MUN) + " - " + AllTrim(SA2->A2_EST)
		oReport:PrintText(Alltrim(Substr(cStrlin,1,57)),180,020)
//		oReport:PrintText(Space(30) + "Atenciosamente.",180,890)
		
//		oReport:PrintText(Alltrim(Substr(cStrlin,58,57)),210,020)
		oReport:PrintText("FONE: " + SA2->A2_DDD+" " + SA2->A2_TEL,210,020)
		oReport:PrintText(SM0->M0_NOMECOM,150,890)
		
//		oReport:PrintText("Fone: " + SA2->A2_DDD+" " + SA2->A2_TEL,240,020)
		oReport:PrintText(If(Empty(MV_PAR07), If(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT),MV_PAR07),180,890)
		
		aDest	:= STRTOKARR(ALLTRIM(SA2->A2_EMAIL2),";")

		For nD := 1 To 3
			If nD == 1
				oReport:PrintText("EMAIL : " + ALLTRIM(aDest[nD]),nLin,020)
			ElseIf nD <= Len(aDest)
				nLin += 30
				oReport:PrintText(SPACE(8) + ALLTRIM(aDest[nD]),nLin,020)
			else
				Exit
			Endif
		Next nD
		oReport:PrintText(If(Empty(MV_PAR08), If(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), SM0->M0_CIDCOB + " " + SM0->M0_ESTCOB,  SM0->M0_CIDENT + " " + SM0->M0_ESTENT),MV_PAR08),210,890)
	Else
		oReport:PrintText(SubStr(SC8->C8_FORNOME,1,If(aTamSXG[1] != aTamSXG[3],25,40)),120,020)
//		oReport:PrintText("Por favor queira referenciar este numero para quaisquer troca de",120,890)
		
		oReport:PrintText("C8_FORMAIL" + SC8->C8_FORMAIL,150,020)
			
//		oReport:PrintText("informacoes referentes a esta cotacao.",150,890)
		
		oReport:PrintText(Alltrim(Substr(cStrlin,1,57)),180,020)
		oReport:PrintText(Space(30) + "Atenciosamente.",180,890)
		
		oReport:PrintText(Alltrim(Substr(cStrlin,58,57)),210,020)
		oReport:PrintText(SM0->M0_NOMECOM,210,890)
			
		oReport:PrintText(If(Empty(MV_PAR07), If(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT),MV_PAR07),240,890)
		
		oReport:PrintText(If(Empty(MV_PAR08), If(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), ALLTRIM(SM0->M0_CIDCOB) + " - " + ALLTRIM(SM0->M0_ESTCOB),  ALLTRIM(SM0->M0_CIDENT) + " - " + ALLTRIM(SM0->M0_ESTENT)), MV_PAR08),270,890)

	EndIf
//	oReport:PrintText("Solicitamos de V Sas. cotacao de precos para os produtos",300,020)
	oReport:PrintText("FONE: " + If(Empty(cTel), SM0->M0_TEL, cTel),240,890)

//	oReport:PrintText("discriminados conforme os padroes abaixo estabelecidos:",330,020)
	oReport:PrintText("E-MAIL: "  + Alltrim(mv_par13),270,890)

	oReport:PrintText(Space(10),360,020)

	oSection1:PrintLine()
	oReport:SkipLine()
*/
	oSection1:Finish()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R110Logo  ³ Autor ³ Materiais             ³ Data ³07/01/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna string com o nome do arquivo bitmap de logotipo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R110Logo()

Local cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo com o codigo do grupo de empresas ³
//³ completo, retira os espacos em branco do codigo da empresa   ³
//³ para nova tentativa.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cBitmap )
	cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo com o codigo da filial completo,  ³
//³ retira os espacos em branco do codigo da filial para nova    ³
//³ tentativa.                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se ainda nao encontrar, retira os espacos em branco do codigo³
//³ da empresa e da filial simultaneamente para nova tentativa.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cBitmap )
	cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar o arquivo por filial, usa o logo padrao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

Return cBitmap
