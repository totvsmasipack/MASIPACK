#Include "Topconn.ch"
#Include "Rwmake.ch"

#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ rfatr002 ³ Autor ³ Eduardo José Zanardo  ³ Data ³ 26.12.01 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³Emissao da Pre-Nota                                         ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
21/03/2012 - Alterado por Ana Paula QFaustino - Impressao de Quantas Vezes o Pedido foi Liberado
10/01/2013 - SUBSTITUIDO PESO BRUTO POR PESO LIQUIDO NA IMPRESSÃO DA PRÉ-NOTA (SOLICITAÇÃO FEITA PELO ALEXANDRE - FABRIMA)
/*/

User Function rfatr002(cNumPed)

//³Define Variaveis                                                        ³
Private Titulo   := "Emissao da Confirmacao do Pedido"
Private cDesc1   := "Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
Private cDesc2   := "intervalo informado na op‡„o Parƒmetros."
Private cDesc3   := " "
Private cString  := "SC5"  				// Alias utilizado na Filtragem
Private lDic     := .F. 					// Habilita/Desabilita Dicionario
Private lComp    := .T. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Private lFiltro  := .F. 					// Habilita/Desabilita o Filtro
Private wnrel    := "RFATR002" 			// Nome do Arquivo utilizado no Spool
Private nomeprog := "RFATR002"
Private Tamanho  := "G" 					// P/M/G
//Private cPerg    := "RFAT02" + Space(4)       //"MTR730"
Private cPerg    := "XRFATR002 "
Private nAliqIPI := 0
Private nBaseIPI := 0
Private nVlrIPI  := 0
Private nBaseICMS:= 0
Private nVlrICMS := 0
Private nBaseISS := 0
Private nVlrISS  := 0
Private aDesenhos:= {}
Private cDesenho := ""
Private _cPath   := ""
Private J        := 0

//If cNumPed == Nil
//   If !Pergunte(cPerg,.T.)
//      Return
//   EndIf   
//Else
//   mv_par01 := cNumPed
//   mv_par02 := cNumPed
//   mv_par03 := 2
//   mv_par04 := 2
//   cPerg    := ""   
//EndIf

Private Limite  := 220 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 } 
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.				// Controle de cancelamento do relatorio
Private m_pag   := 1  				// Contador de Paginas
Private nLastKey:= 0  				// Controla o cancelamento da SetPrint e SetDefault

//³Verifica as Perguntas Seleciondas
Pergunte(cPerg,.F.)

//³Envia para a SetPrinter                                                 ³
#IFDEF TOP
	lFiltro := .F.
#ENDIF	

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C730Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Program   ³ C730Imp   ³ Autor ³ Eduardo J. Zanardo   ³ Data ³26.12.2001³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function C730Imp(lEnd,wnrel,cString,nomeprog,Titulo)

Local nX, nSC5, nSC6, J

Private aStruSC5   := {}
Private aStruSC6   := {}
Private aC5Rodape  := {}                          
Private aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})

Private li         := 100 // Contador de Linhas
Private lImp       := .F. // Indica se algo foi impresso
Private lRodape    := .F.

Private cbCont     := 0   // Numero de Registros Processados
Private cbText     := ""  // Mensagem do Rodape
Private cKey 	     := ""
Private cFilter    := ""
Private cAliasSC5  := "SC5"
Private cAliasSC6  := "SC6"
Private cIndex     := CriaTrab(nil,.f.) 
Private cQuery     := ""
Private cQryAd     := ""     
Private cName      := ""
Private cPedido    := ""
Private cCliEnt	 := ""
Private cNfOri     := Nil
Private cSeriOri   := Nil

Private nItem      := 0 
Private nTotQtd    := 0
Private nTotVal    := 0
Private nDesconto  := 0
Private nPesLiq    := 0
Private nSC5       := 0
Private nSC6       := 0 
Private nX         := 0
Private nRecnoSD1  := Nil

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		cAliasSC5:= "C730Imp"
		cAliasSC6:= "C730Imp"
		lQuery    := .T.
		aStruSC5  := SC5->(dbStruct())		
		aStruSC6  := SC6->(dbStruct())		
		cQuery := "SELECT SC5.R_E_C_N_O_ SC5REC,SC6.R_E_C_N_O_ SC6REC,"
		cQuery += "SC5.C5_FILIAL,SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_TIPO,SC5.C5_PC,"
		cQuery += "SC5.C5_TIPOCLI,SC5.C5_TRANSP,SC5.C5_PBRUTO,SC5.C5_PESOL,SC5.C5_DESC1,"
		cQuery += "SC5.C5_DESC2,SC5.C5_DESC3,SC5.C5_DESC4,SC5.C5_MENNOTA,SC5.C5_EMISSAO,"
		cQuery += "SC5.C5_CONDPAG,SC5.C5_FRETE,SC5.C5_TPFRETE,SC5.C5_SEGURO,SC5.C5_TABELA,"
		cQuery += "SC5.C5_VOLUME1,SC5.C5_ESPECI1,SC5.C5_MOEDA,SC5.C5_REAJUST,SC5.C5_BANCO,"
		cQuery += "SC5.C5_ACRSFIN,SC5.C5_VEND1,SC5.C5_VEND2,SC5.C5_VEND3,SC5.C5_VEND4,SC5.C5_VEND5,"
		cQuery += "SC5.C5_COMIS1,SC5.C5_COMIS2,SC5.C5_COMIS3,SC5.C5_COMIS4,SC5.C5_COMIS5,SC5.C5_ORCAM,"
		If SC5->(FieldPos("C5_CLIENT"))>0
			cQuery += "SC5.C5_CLIENT,"			
		Endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³Esta rotina foi escrita para adicionar no select os campos         ³
      //³usados no filtro do usuario quando houver, a rotina acrecenta      ³
      //³somente os campos que forem adicionados ao filtro testando         ³
      //³se os mesmo já existem no select ou se forem definidos novamente   ³
      //³pelo o usuario no filtro                                           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	

      If !Empty(aReturn[7])
			For nX := 1 To SC5->(FCount())
				cName := SC5->(FieldName(nX))
				If AllTrim( cName ) $ aReturn[7]
					If aStruSC5[nX,2] <> "M"  
						If !cName $ cQuery .And. !cName $ cQryAd
							cQryAd += cName +","
						Endif 	
					EndIf
				EndIf 			       	
			Next nX
		Endif    
     
		cQuery += cQryAd		

		cQuery += "SC6.C6_FILIAL, SC6.C6_NUM,    SC6.C6_PEDCLI,  SC6.C6_PRODUTO, SC6.C6_MSSEP, SC6.C6_MSNRSEP, "
		cQuery += "SC6.C6_TES,    SC6.C6_QTDVEN, SC6.C6_PRUNIT,  SC6.C6_VALDESC, "
		cQuery += "SC6.C6_VALOR,  SC6.C6_ITEM,   SC6.C6_DESCRI,  SC6.C6_UM,  "
		cQuery += "SC6.C6_PRCVEN, SC6.C6_NOTA,   SC6.C6_SERIE,   SC6.C6_CLI, "
		cQuery += "SC6.C6_LOJA,   SC6.C6_ENTREG, SC6.C6_DESCONT, SC6.C6_LOCAL, "
		cQuery += "SC6.C6_QTDEMP, SC6.C6_QTDLIB, SC6.C6_QTDENT,  SC6.C6_NFORI, SC6.C6_SERIORI,SC6.C6_ITEMORI "
		cQuery += "FROM "
		cQuery += RetSqlName("SC5") + " SC5 ,"
		cQuery += RetSqlName("SC6") + " SC6 "		
		cQuery += "WHERE "
		cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "		
		cQuery += "SC5.C5_NUM >= '"+mv_par01+"' AND " 
		cQuery += "SC5.C5_NUM <= '"+mv_par02+"' AND " 
		cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "		 
		cQuery += "SC6.C6_NUM   = SC5.C5_NUM AND "
		cQuery += "SC6.D_E_L_E_T_ = ' ' "
		cQuery += "AND SC6.C6_QTDENT < SC6.C6_QTDVEN "
		//VICTOR DESSUNTE - 08/09/2016
		//INICIO: TICKET 2016090837000022
		cQuery += "AND SC6.C6_BLQ IN(' ','N') "
		//FIM: TICKET 2016090837000022
		cQuery += "ORDER BY SC5.C5_NUM"
		
		cQuery := ChangeQuery(cQuery)
		    	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC5,.T.,.T.)

		For nSC5 := 1 To Len(aStruSC5)
			If aStruSC5[nSC5][2] <> "C" .and.  FieldPos(aStruSC5[nSC5][1]) > 0
				TcSetField(cAliasSC5,aStruSC5[nSC5][1],aStruSC5[nSC5][2],aStruSC5[nSC5][3],aStruSC5[nSC5][4])
			EndIf
		Next nSC5
		For nSC6 := 1 To Len(aStruSC6) 
			If aStruSC6[nSC6][2] <> "C" .and. FieldPos(aStruSC6[nSC6][1]) > 0
				TcSetField(cAliasSC6,aStruSC6[nSC6][1],aStruSC6[nSC6][2],aStruSC6[nSC6][3],aStruSC6[nSC6][4])
			EndIf
		Next nSC6		    	
	Else
#ENDIF	 
		cAliasSC5 := cString
		dbSelectArea(cAliasSC5)
		cKey := IndexKey()	
		cFilter := dbFilter()
		cFilter += If( Empty( cFilter ),""," .And. " )
		cFilter += 'C5_FILIAL == "'+xFilial("SC5")+'" .And. (C5_NUM >= "'+mv_par01+'" .And. C5_NUM <= "'+mv_par02+'")'
		IndRegua(cAliasSC5,cIndex,cKey,,cFilter,"Selecionando Registros...")	 
		#IFNDEF TOP
			DbSetIndex(cIndex+OrdBagExt())
		#ENDIF                           
		SetRegua(RecCount())		// Total de Elementos da regua
		DbGoTop()
#IFDEF TOP
	Endif
#ENDIF
	
SC9->(DbSetOrder(1))
SC9->(DbGoTop())
While !((cAliasSC5)->(Eof())) .and. xFilial("SC5")==(cAliasSC5)->C5_FILIAL
	//³ Executa a validacao dos filtros do usuario           	     ³
	dbSelectArea(cAliasSC5)
	lFiltro := IIf((!Empty(aReturn[7]).And.!&(aReturn[7])),.F.,.T.)
	If lFiltro
		cCliEnt   := IIf(!Empty((cAliasSC5)->(FieldGet(FieldPos("C5_CLIENT")))),(cAliasSC5)->C5_CLIENT,(cAliasSC5)->C5_CLIENTE)
		MaFisIni(cCliEnt,;					// 1-Codigo Cliente/Fornecedor
		(cAliasSC5)->C5_LOJACLI,;			// 2-Loja do Cliente/Fornecedor
		If(SC5->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
			(cAliasSC5)->C5_TIPO,;			// 4-Tipo da NF
			(cAliasSC5)->C5_TIPOCLI,;	    // 5-Tipo do Cliente/Fornecedor
			aRelImp,;						// 6-Relacao de Impostos que suportados no arquivo
			,;						   		// 7-Tipo de complemento
			,;								// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;							// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461")						// 10-Nome da rotina que esta utilizando a funcao
			nTotQtd:=0
			nTotVal:=0
			nPesBru:=0
			nPesLiq:=0
			nBaseICMS:=0
			nVlrICMS:=0
			nBaseIPI:=0
			nVlrIPI:=0
			nBaseISS:=0
			nVlrISS:=0
			If !lQuery
				dbSelectArea(cAliasSC6)
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+(cAliasSC5)->C5_NUM)
			EndIf
			cPedido    := (cAliasSC5)->C5_NUM

			dbSelectArea("SC5")
			dbSetOrder(1)
			dbSeek(xFilial("SC5")+cPedido)
			_mOBS := SC5->C5_MSOBSPN 

			aC5Rodape  := {}
			aadd(aC5Rodape,{(cAliasSC5)->C5_PBRUTO,(cAliasSC5)->C5_PESOL,(cAliasSC5)->C5_DESC1,(cAliasSC5)->C5_DESC2,;
			(cAliasSC5)->C5_DESC3,(cAliasSC5)->C5_DESC4,(cAliasSC5)->C5_MENNOTA})
			Do While !((cAliasSC6)->(Eof())) .And. xFilial("SC6")==(cAliasSC6)->C6_FILIAL .And. (cAliasSC6)->C6_NUM == cPedido
				////bloco alterado para verificar bloqueio de estoque no sc9  - Lizandra 01/03/12
			    If mv_par04 == 1  			    //.And. (cAliasSC6)->C6_QTDEMP == 0
					dbSelectArea("SC9")
					dbSetOrder(1)
					If SC9->(dbSeek(xFilial("SC9")+(cAliasSC6)->C6_NUM+(cAliasSC6)->C6_ITEM))
						Do While !SC9->(EOF()) .AND. SC9->C9_PEDIDO+SC9->C9_ITEM == (cAliasSC6)->C6_NUM+(cAliasSC6)->C6_ITEM
							If SC9->C9_BLEST $ "02,10"
								SC9->(DbSkip())
							Else
								Exit
							ENDIF
						EndDo
					ELSE       
						dbSelectArea(cAliasSC6)
						IF (cAliasSC6)->C6_QTDEMP == 0
					       (cAliasSC6)->(DbSkip())
					       Loop
					    ENDIF
					ENDIF       
			    EndIf 
			    
			    If mv_par04 == 1
				    If SC9->C9_PEDIDO+SC9->C9_ITEM <> (cAliasSC6)->C6_NUM+(cAliasSC6)->C6_ITEM
				    	dbSelectArea(cAliasSC6)
				       (cAliasSC6)->(DbSkip())
				       loop
				    EndIf
				EndIf
				      
			    // Guarda os codigos dos desenhos para posterior impressao
			    cDesenho := (cAliasSC6)->C6_PRODUTO
			    If mv_par03 == 1
                   _cPath := "H:\PLOTTER\"
                   If SubStr(cNumEmp,1,2) == "01" 
                      If Substr(cDesenho,1,2) == "CL" .Or. Substr(cDesenho,1,2) == "TS"
                         If Substr(cDesenho,3,2) == "CL" 
                            _cPath += Substr(cDesenho,5,2) + "\"
                            cDesenho := SubStr(cDesenho,3,15)
                         Else
                            _cPath += Substr(cDesenho,3,2) + "\"
                            cDesenho := SubStr(cDesenho,3,15)
                         EndIf      
                      ELSE
                         _cPath += Substr(cDesenho,1,2) + "\"
                      ENDIF
                   ElseIf SubStr(cNumEmp,1,2) == "10"
                      _cPath := SubStr(cDesenho,1,3)
                   EndIf 
                   cDesenho := Alltrim(cDesenho)                     
                   J := Len(cDesenho)
                   If Val(SubStr(cDesenho,J,1)) == 0
                      cDesenho := SubStr(cDesenho,1,J-1)
                   EndIf   
                   IF SUBSTR(cDesenho,11,2) == "MP"
                      cDesenho := SUBSTR(cDesenho,1,10) + SUBSTR(cDesenho,13,1)
                   ENDIF
                   cDesenho := _cPath + Alltrim(cDesenho)
                   If Ascan(aDesenhos,cDesenho+".PRI") == 0
                      AADD(aDesenhos,cDesenho + ".PLT")
	                  AADD(aDesenhos,cDesenho + ".PRI") 
	                  AADD(aDesenhos,cDesenho + ".PRN")
	               EndIf   
                EndIf
                cNfOri     := Nil
				cSeriOri   := Nil
				nRecnoSD1  := Nil
				If !Empty((cAliasSC6)->C6_NFORI)
					dbSelectArea("SD1")
					dbSetOrder(1)
					dbSeek(xFilial("SC6")+(cAliasSC6)->C6_NFORI+(cAliasSC6)->C6_SERIORI+(cAliasSC6)->C6_CLI+(cAliasSC6)->C6_LOJA+;
					(cAliasSC6)->C6_PRODUTO+(cAliasSC6)->C6_ITEMORI)
					cNfOri     := (cAliasSC6)->C6_NFORI
					cSeriOri   := (cAliasSC6)->C6_SERIORI
					nRecnoSD1  := SD1->(RECNO())
				EndIf
				dbSelectArea(cAliasSC6)
				If lEnd
					@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				EndIf   
				If ((cAliasSC6)->C6_PRCVEN <> (cAliasSC6)->C6_PRUNIT) .Or. (cAliasSC6)->C6_VALDESC > 0
					nDesconto := (a410Arred((cAliasSC6)->C6_PRUNIT*(cAliasSC6)->C6_QTDVEN,"D2_DESCON")-(cAliasSC6)->C6_VALOR)
					nDesconto := If(nDesconto==0,(cAliasSC6)->C6_VALDESC,nDesconto)				
				Endif	
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial()+SC6->C6_TES)   
				cDescTes	:= Substr(SF4->F4_TEXTO,1,18)
				dbSelectArea(cAliasSC6)
				MaFisAdd((cAliasSC6)->C6_PRODUTO,; 	  	  // 1-Codigo do Produto ( Obrigatorio )
						(cAliasSC6)->C6_TES,;			  // 2-Codigo do TES ( Opcional )
						(cAliasSC6)->C6_QTDVEN,;		  // 3-Quantidade ( Obrigatorio )
						(cAliasSC6)->C6_PRUNIT,;		  // 4-Preco Unitario ( Obrigatorio )
						nDesconto,;       			      // 5-Valor do Desconto ( Opcional )
						cNfOri,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
						cSeriOri,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
						nRecnoSD1,;			          		// 8-RecNo da NF Original no arq SD1/SD2
						0,;							  		// 9-Valor do Frete do Item ( Opcional )
						0,;							  		// 10-Valor da Despesa do item ( Opcional )
						0,;            				  		// 11-Valor do Seguro do item ( Opcional )
						0,;							  		// 12-Valor do Frete Autonomo ( Opcional )
						((cAliasSC6)->C6_VALOR+nDesconto),;	// 13-Valor da Mercadoria ( Obrigatorio )
						0,;							  		// 14-Valor da Embalagem ( Opiconal )
						0,;		     				 		 // 15-RecNo do SB1
						0) 							 		 // 16-RecNo do SF4
				nItem += 1
				IF li > 48
					IF lRodape
						ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape)
					Endif
					li := 0
					lRodape := ImpCabec(@li,cAliasSC5)
				Endif
				ImpItem(nItem,@nPesLiq,@li,@nTotQtd,@nTotVal,@nPesBru,cAliasSC6)
				If !lQuery
					dbSelectArea(cAliasSC6)
				EndIf
			    (cAliasSC6)->(dbSkip())
				li++
			EndDo
			MaFisEnd()
			nItem := 0
			IF lRodape
				ImpRodape(nPesLiq,nTotQtd,nTotVal,@li,nPesBru,aC5Rodape)
				lRodape:=.F.
			Endif
			If !lQuery
				IncRegua()
				dbSelectArea(cAliasSC5)
				dbSkip()
			Endif
		Else
			dbSelectArea(cAliasSC5)
			dbSkip()
		EndIf
EndDo 

If lQuery   
    dbSelectArea(cAliasSC5)
	dbCloseArea()
Endif	

Set Device To Screen
Set Printer To

RetIndex("SC5")   
dbSelectArea("SC5")
Set Filter to

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
Set Filter To
dbSetOrder(1)
dbGotop()

// impressão dos desenhos
 	
If Len(aDesenhos) > 0 .And. aReturn[5] > 1 .And. mv_par03 == 1
   For J := 1 TO LEN(aDesenhos)
       WaitRun("H:\Plotter\Plot\plot3.bat "+aDesenhos[J])
   Next 
EndIf

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descricao ³ Emissao da Pre-Nota                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ rfatr002                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ImpItem(nItem,nPesLiq,li,nTotQtd,nTotVal,nPesBru,cAliasSC6)

Local nDesplaza:=0
Local nUltLib  := 0
Local cChaveD2 := ""

dbSelectArea("SB1")
dbSeek(xFilial("SB1")+(cAliasSC6)->C6_PRODUTO)

@li,000 psay (cAliasSC6)->C6_ITEM
@li,003 psay (cAliasSC6)->C6_PRODUTO
@li,020 psay SB1->B1_LOCAL
@li,029 psay SUBS(IIF(Empty((cAliasSC6)->C6_DESCRI),SB1->B1_DESC,(cAliasSC6)->C6_DESCRI),1,30)
@li,062 psay (cAliasSC6)->C6_UM
@li,065 psay (cAliasSC6)->C6_QTDEMP	Picture PesqPict("SC6","C6_QTDEMP",10)
@li,078 Psay (cAliasSC6)->C6_MSSEP
@li,080 psay (cAliasSC6)->C6_PRCVEN	Picture PesqPict("SC6","C6_PRCVEN",12)
@li,093 psay MaFisRet(nItem,"IT_ALIQIPI") Picture "@e 99.99"
nAliqIPI := MaFisRet(nItem,"IT_ALIQIPI")
If nAliqIPI > 0
   nBaseIPI += (cAliasSC6)->C6_VALOR
   nVlrIPI += ((cAliasSC6)->C6_VALOR * nAliqIPI) / 100
EndIf   

If ( cPaisLoc=="BRA" )
	@li,099 psay MaFisRet(nItem,"IT_ALIQICM") Picture "@e 99.99" //Aliq de ICMS
	If MaFisRet(nItem,"IT_ALIQICM") > 0
	   nBaseICMS += (cAliasSC6)->C6_VALOR
	   nVlrICMS += ((cAliasSC6)->C6_VALOR * MaFisRet(nItem,"IT_ALIQICM")) / 100
	EndIf   
	@li,105 psay SB1->B1_ALIQISS	Picture "@e 99.99"    //Aliq de ISS
	If SB1->B1_ALIQISS > 0 
	   nBaseISS += (cAliasSC6)->C6_VALOR
	   nVlrISS += ((cAliasSC6)->C6_VALOR * SB1->B1_ALIQISS) / 100
	EndIf   
	nDesplaza:=6
EndIf

@li,104+ndesplaza   psay (cAliasSC6)->C6_VALOR+MaFisRet(nItem,"IT_VALIPI") Picture PesqPict("SC6","C6_VALOR",14)
@li,120+ndesplaza   psay (cAliasSC6)->C6_ENTREG
@li,128+ndesplaza+2 psay (cAliasSC6)->C6_NOTA
If mv_par04 == 1
   @li,138+ndesplaza+2 psay SB1->B1_PESO * (cAliasSC6)->C6_QTDEMP Picture "9,999.999"
Else
   @li,138+ndesplaza+2 psay SB1->B1_PESO * (cAliasSC6)->C6_QTDVEN Picture "9,999.999"
EndIf      
@li,148+ndesplaza+2 psay (cAliasSC6)->C6_QTDVEN Picture PesqPict("SC6","C6_QTDVEN",10)
SF4->(dbSetOrder(1))
SF4->(DbGotop())
SF4->(dbSeek(xFilial()+(cAliasSC6)->C6_TES))   
cDescTes := Substr(SF4->F4_TEXTO,1,18)
cNrSep := Str((cAliasSC6)->C6_MSNRSEP,2)
@li,160+ndesplaza+2 psay (cAliasSC6)->C6_TES+"-"+Alltrim(cDescTes)+"-"+Alltrim(cNrSep)
li++  
@li,000 psay Replicate("-",limite-30) 

nTotQtd += (cAliasSC6)->C6_QTDVEN
nTotVal += (cAliasSC6)->C6_VALOR+MaFisRet(nItem,"IT_VALIPI") 
If mv_par04 == 1
   nPesLiq += SB1->B1_PESO * (cAliasSC6)->C6_QTDEMP
   nPesBru += SB1->B1_PESBRU * (cAliasSC6)->C6_QTDEMP
Else
   nPesLiq += SB1->B1_PESO * (cAliasSC6)->C6_QTDVEN
   nPesBru += SB1->B1_PESBRU * (cAliasSC6)->C6_QTDVEN
EndIf   

Return (Nil)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descricao ³ Emissao da Pre-Nota                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ rfatr002                                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ImpRodape(nPesLiq,nTotQtd,nTotVal,li,nPesBru,aC5Rodape)

Local X

@ li,000 psay Replicate("-",limite-30)
li++
@ li,000 psay " T O T A I S "	 
@ li,069 psay nTotQtd    Picture PesqPict("SC6","C6_QTDVEN",10)
If ( cPaisLoc=="BRA" )
	@ li,107 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
Else
	@ li,081 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
EndIf
li++
@ li,000 psay Replicate("-",limite-30)

li++
@ li,000 psay "I M P O S T O S ==>"  
@ li,030 psay "Base ICMS          Valor ICMS           Base IPI          Valor IPI            Base Retido           Valor Retido                   Valor Total"
li++
@li, 025 psay nBaseICMS PicTure "@E 999,999,999.99"
@li, 045 psay nVlrICMS PicTure "@E 999,999,999.99"
@li, 064 psay nBaseIPI PicTure "@E 999,999,999.99"
@li, 083 psay nVlrIPI PicTure "@E 999,999,999.99" 
@li, 159 psay nTotVal PicTure "@E 999,999,999.99"
li++
@ li,031 psay "Base ISS           Valor ISS"
li++
@li, 025 psay nBaseISS PicTure "@E 999,999,999.99"
@li, 045 psay nVlrISS PicTure "@E 999,999,999.99" 


IF !EMPTY(_mOBS)
	li:= li+7
	@ li,000 PSAY "OBSERVAÇÕES PRE-NOTA"
	li++
	For X := 1 TO MLCOUNT(_mOBS,80)
		Li++
		If Li > 55
			ImpCabec(@li,cAliasSC5)
		EndIf
		@li,005 PSay MEMOLINE(_mOBS,80,X)
	Next
EndIf

If Li > 55
   li := 0
   lRodape := ImpCabec(@li,cAliasSC5)
Endif


@ 57,005 psay "PESO BRUTO ------>"+STR(If(aC5Rodape[1][1] > 0,aC5Rodape[1][1],nPesBru)) 
@ 58,005 psay "PESO LIQUIDO ---->"+STR(If(aC5Rodape[1][2] > 0,aC5Rodape[1][2] ,nPesLiq)) 
@ 59,005 psay "VOLUMES --------->"
@ 60,005 psay "SEPARADO POR ---->"
@ 61,005 psay "CONFERIDO POR --->"
@ 62,005 psay "D A T A --------->"
@ 64,000 psay "MENSAGEM PARA NOTA FISCAL: " +AllTrim(aC5Rodape[1][7])		
@ 65,000 psay ""

li := 80

Return( NIL )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descricao ³ Emissao da Pre-Nota                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ rfatr002                                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function ImpCabec(li,cAliasSC5)

Local nPed		:= 0
Local cMoeda	:= ""
Local cCampo    := ""
Local cComis    := ""
Local cPictCgc  := ""
Local i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !((cAliasSC5)->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI)
    cPictCgc := PesqPict("SA1","A1_CGC")	
Else
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI)
    cPictCgc := PesqPict("SA2","A2_CGC")	
Endif

dbSelectArea("SA4")
dbSetOrder(1)
dbSeek(xFilial("SA4")+(cAliasSC5)->C5_TRANSP)
dbSelectArea("SE4") 
dbSetOrder(1)
dbSeek(xFilial("SE4")+(cAliasSC5)->C5_CONDPAG)
                                                                                        
@ 01,000 psay Replicate("-",limite-40)+ " Pag.: " + Str(m_pag,3)
@ 02,000 psay Alltrim(SM0->M0_NOME)
IF !((cAliasSC5)->C5_TIPO$"DB")
	@ 02,041 psay "|"+Left(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME, 56)      
	@ 02,100 psay "| RFATR002 - CONFIRMACAO DO PEDIDO"
	@ 03,000 psay Alltrim(SM0->M0_ENDCOB)
	@ 03,041 psay "|"+IF(!Empty(SA1->A1_ENDENT).And.SA1->A1_ENDENT#SA1->A1_END,Substr(SA1->A1_ENDENT,1,45),Substr(SA1->A1_END,1,45))
	@ 03,100 psay "|"+" FONE: " + SA1->A1_TEL + "Falar com: " + SA1->A1_CONTATO
	If SubStr(cNumEmp,1,2) == "01"
	   @ 04,000 psay "TEL: "+"(11) 3246-3666,4178-8099"
	Else   
	   @ 04,000 psay "TEL: "+SM0->M0_TEL																	//"TEL: "
	EndIf   
	@ 04,041 psay "|"
	@ 04,043 psay IF( !Empty(SA1->A1_CEPE) .And. SA1->A1_CEPE # SA1->A1_CEP,SA1->A1_CEPE, SA1->A1_CEP )
	@ 04,053 psay IF( !Empty(SA1->A1_MUNE) .And. SA1->A1_MUNE # SA1->A1_MUN,SA1->A1_MUNE, SA1->A1_MUN )
	@ 04,077 psay IF( !Empty(SA1->A1_ESTE) .And. SA1->A1_ESTE # SA1->A1_EST,SA1->A1_ESTE, SA1->A1_EST )
	@ 04,100 psay "| EMISSAO: "	   																		//"| EMISSAO: "
	@ 04,111 psay Date() //(cAliasSC5)->C5_EMISSAO
	@ 05,000 psay "CGC: "
	@ 05,005 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
    @ 05,043 psay subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
	@ 05,062 psay "IE: "+SA1->A1_INSCR			//"IE: "
	@ 05,100 psay "| Pedido do Cliente: " + (cAliasSC5)->C5_PC 
	If SA1->A1_RISCO $ "D_E"
	   @ 06,041 psay "| Email: " + Alltrim(SA1->A1_EMAIL) + "   Risco do Cliente: " + SA1->A1_RISCO 
	Else
	   @ 06,041 psay "| Email: " + Alltrim(SA1->A1_EMAIL) 
	EndIf   
Else  
	@ 02,041 psay "| "+Left(SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME, 56)
	@ 02,100 psay "| RFATR002 - CONFIRMACAO DO PEDIDO"
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "|"+Substr(SA2->A2_END,1,45)
	@ 03,100 psay "|"
	If SubStr(cNumEmp,1,2) == "01"
	   @ 04,000 psay "TEL: "+"(11) 3246-3666,4178-8099"
	Else
	   @ 04,000 psay "TEL: "+SM0->M0_TEL			//"TEL: "
	EndIf   
	@ 04,041 psay "|"+SA2->A2_CEP
	@ 04,053 psay SA2->A2_MUN
	@ 04,077 psay SA2->A2_EST
	@ 04,100 psay "| EMISSAO: "
	@ 04,111 psay (cAliasSC5)->C5_EMISSAO
	@ 05,000 psay "CGC: "
	@ 05,005 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
	@ 05,043 psay SA2->A2_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,062 psay "IE: "+SA2->A2_INSCR			//"IE: "
    @ 06,041 psay "| E-mail: " + SA2->A2_EMAIL2
Endif
li:= 7
If mv_par04 == 1 
   If (SC9->(DbSeek(xFilial()+(cAliasSC5)->C5_NUM)))
      Do While SC9->(!Eof()) .And. SC9->C9_PEDIDO == (cAliasSC5)->C5_NUM
         If !Empty(SC9->C9_BLCRED) .And. Alltrim(SC9->C9_BLCRED) <> "10" .Or. Alltrim(SA1->A1_RISCO) $ "D_E" 
            Li++
            @ Li,005 Psay "***  ATENÇÃO, CLIENTE COM BLOQUEIO DE CREDITO FALE COM DEPTO.FINANCEIRO ANTES DE ENVIAR ESTE PEDIDO PARA ALMOXARIFADO  ***" 
            Li+=2
            Exit
         EndIf
         SC9->(DbSkip())
      EndDo      
   EndIf
Else
   Li++
   @ Li,005 Psay "***  ATENÇÃO, PEDIDO EMITIDO APENAS PARA CONFERENCIA - NÃO FOI ANALISADO O CREDITO DO CLIENTE  ***" 
   Li+=2   
EndIf      

@ li,000 psay Replicate("-",81) + "  P E D I D O   N. " + (cAliasSC5)->C5_NUM + "   " +Replicate("-",81)
li++
@ li,000 psay "TRANSP...: "+(cAliasSC5)->C5_TRANSP+" - "+SA4->A4_NOME			//"TRANSP...: "
li++
For i := 1 to 5
	cCampo := "C5_VEND" + Str(i,1,0)
	cComis := "C5_COMIS" + Str(i,1,0)
	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3")+(cAliasSC5)->(FieldGet(FieldPos(cCampo))))
		If i == 1
			@ li,000 psay "VENDEDOR.: "
		EndIf
		@ li,013 psay (cAliasSC5)->(FieldGet(FieldPos(cCampo))) + " - "+SA3->A3_NOME
		If i == 1
			@ li,065 psay "COMISSAO: "
		EndIf
		@ li,075 psay (cAliasSC5)->(FieldGet(FieldPos(cComis))) Picture "99.99"
		li++
	EndIf	
Next
@ li,000 psay "COND.PGTO: "+(cAliasSC5)->C5_CONDPAG+" - "+SE4->E4_DESCRI			//"COND.PGTO: "
@ li,065 psay "FRETE...: "
@ li,075 psay (cAliasSC5)->C5_FRETE  Picture "@EZ 999,999,999.99"
If (cAliasSC5)->C5_FRETE > 0
	@ li,090 psay IIF((cAliasSC5)->C5_TPFRETE="C","(CIF)","(FOB)")
Endif
@ li,100 psay "SEGURO: "
@ li,108 psay (cAliasSC5)->C5_SEGURO Picture "@EZ 999,999,999.99"
li++
@ li,000 psay "TABELA...: "+(cAliasSC5)->C5_TABELA		//"TABELA...: "
@ li,065 psay "VOLUMES.: "
@ li,075 psay (cAliasSC5)->C5_VOLUME1    Picture "@EZ 999,999"
@ li,100 psay "ESPECIE: "+(cAliasSC5)->C5_ESPECI1		//"ESPECIE: "
li++
cMoeda:=Strzero((cAliasSC5)->C5_MOEDA,1,0)
@ li,000 psay "REAJUSTE.: "+(cAliasSC5)->C5_REAJUST+"   Moeda : " +IIF(cMoeda < "2","1",cMoeda)	
@ li,065 psay "BANCO: " + (cAliasSC5)->C5_BANCO				
@ li,100 psay "ACRES.FIN.: "+Str((cAliasSC5)->C5_ACRSFIN,6,2)	
If SA1->A1_EST == "EX"
   li++
   @ li,000 psay "C.E. No..: " + (cAliasSC5)->C5_ORCAM
EndIf   
If mv_par04 == 1
   li+=2
   @li,000 psay Replicate("-",66) + "   SEPARAR OS ITENS ABAIXO PARA EMISSÃO DA NOTA FISCAL   " + Replicate("-",67)
Else   
   li++  
   @ li,000 psay Replicate("-",limite-30)
EndIf   
li++
@ li,000 psay "It Codigo           Local    Desc. do Material                UM    Qtde.A   SEP          V   A   L   O   R   E   S           Data de   NFiscal       Peso      Qtde.do TES"
li++
@ li,000 psay "                                                                    Separar         Unitario   IPI   ICM   ISS   Total C/IPI  Entrega                 Liq.       Pedido"
li++
@ li,000 psay Replicate("-",limite-30)
li++
m_pag++

Return( .T. )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³Mtr730Cli ³ Autor ³ Henry Fila            ³ Data ³ 26.08.02 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descricao ³ Função que retorna os pedidos do cliente                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Sintaxe e ³ Mtr730Cli(cPedido)                                         ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Parametros³ ExpC1: Numero do pedido                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ rfatr002                                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function Mtr730Cli(cPedido)

Local aPedidos := {}
Local aArea    := GetArea()
Local aAreaSC6 := SC6->(GetArea())

SC6->(dbSetOrder(1))
SC6->(MsSeek(xFilial("SC6")+cPedido))

While !(SC6->(Eof())) .And. xFilial("SC6")==SC6->C6_FILIAL .And.;
	SC6->C6_NUM == cPedido                                                    
	If !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedidos,SC6->C6_PEDCLI) = 0
		Aadd(aPedidos, SC6->C6_PEDCLI )
	Endif		
	SC6->(dbSkip())                                   
Enddo              

RestArea(aAreaSC6)
RestArea(aArea)

Return(aPedidos)