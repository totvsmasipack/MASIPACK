#Include "Rwmake.ch"      
#Include "Topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³NFSAIDA2  ºAutor  ³Paulo Moreto                                º Data ³28/12/2001   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³Programa para impressao de notas fiscais de saida apenas para Masipack              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 22/01/08  Solange Ap Vezú      Insere Mensagens do SYD-Classif.Fiscais                         º±±
±± 04/02/08                       Gera Matriz das Cond.de Pagamento conforme campo MSCONDS do SE4 º±±
±± 26/02/08  Aparecida Stevanato  Chamada da rotina de atualização dos pedidos de maquinas        º±±
±± 20/05/08                       Mensagens gravadas no arquivo SZO                               º±±
±± 04/11/08                       Formulario novo                                                 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function NFSAIDA2() 

Private fRet    := .T.
Private cTpOper := ""
Private cNat    := ""
Private Tamanho := "G"                                                                                                 

Private _cPC    := ""
Private dDtEmi  := CTOD("")      // Para verificar a data de emissão
Private cNFIni  := ""

nLastKey    := 0                       
aReturn     := { "Especial", 1,"Administracao", 1, 2, 2,"",1 }
_cNomeProg  := "NFSAIDA2" 
_cString    := ""
_cPerg      := "NFSAID" + Space(4)
_cTitulo    := "IMPRESSAO DE NOTA FISCAL DE SAIDA"
_cDesc1     := "Este programa tem por objetivo a impressao das notas fiscais"
_cDesc2     := "de saida da empresa Masipack, conforme os parametros  infor-"
_cDesc3     := "mados pelo usuario.

If !Pergunte(_cPerg)
   Return
EndIf 

// If !(SubStr(cNumEmp,1,2) $ "01_10_40")
//    apmsgStop("Emissão somente para Masipack, Fabrima e Labortube - Fale com Depto. Fiscal")
//    Return
// EndIf
                          
//wnrel := SetPrint(_cString,_cNomeProg,_cPerg,@_cTitulo,_cDesc1,_cDesc2,_cDesc3,.f.,,.f.,,,.f.)
wnrel := SetPrint(_cString,_cNomeProg,_cPerg,@_cTitulo,_cDesc1,_cDesc2,_cDesc3,.F.,,.F.,Tamanho)

If nLastKey == 27                       
   Return
Endif

WaitRun("net use lpt1: /delete")

SetDefault(aReturn,_cString)

If nLastKey == 27                                
   Return
Endif

RptStatus({|| ImpNota()})                      

Set Device To Screen

If aReturn[5] == 1
   Set Printer To
   DbcommitAll()
   OurSpool(wnrel)
Endif

Ms_Flush()

Return

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±    ³Montagem de Lay-Out e impressao da nota fiscal              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

Static Function ImpNota()

Local _aCab   , _aItens , _aCliFor, _aDup   , _aLetIpi , _lDevben 
Local _nI     , _nTotDev, _nExt   , _nIOld  , _nTamdesc, _nDesc   , _lDispo
Local _cCfo   , _cTexto , _cNotDev, _cDatDev, _cDescPro, _cMatFalt ,_aDup2,cCfo
Local nValor 	  := 0.00
Local _cDesNeg	  := ""
Local cMenNota    := "" 
Local _aLetIpi    := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R"}
Local _cFrete     := ""
Local cProd       := ""
Local cUF         := ""
Local cNumNF      := ""
Local cSerieNF    := ""
Local cEndEntrega := ""
Local cEndCob     := ""
Local cMensRetMat := ""
Local cCodMens    := ""
Local cMensSZO    := ""
Local cFoneFax    := ""
Local cAux        := ""
Local cChar       := ""
Local cItemAnt    := 0
Local nTamMens    := 0
Local nItem       := 0 
Local I           := 0
Local nMens       := 0
Local aMens       := {}
Local _aPedVen    := {} 

mv_par01 := mv_par01 + Space(3)
mv_par02 := mv_par02 + Space(3) 

cNFIni := StrZero(Val(mv_par01) - 10,6) + Space(3)

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf 

_cQuery := "SELECT F3_EMISSAO, F3_NFISCAL, F3_SERIE, F3_CFO, F3_SERIE, F3_FORMUL "
_cQuery += "FROM " + RetSqlName("SF3") + " F3 "
_cQuery += "WHERE F3_FILIAL = '" + xFilial("SF3") + "' AND F3_SERIE = '" + mv_par03 + "' AND F3_NFISCAL > '" + cNFIni + "' AND F3_NFISCAL < '" + mv_par01 + "' AND (F3_FORMUL = 'S' OR F3_CFO > 500)"  
_cQuery += " AND D_E_L_E_T_ = ' ' "
_cQuery += "ORDER BY F3_NFISCAL " 

//Alert(_cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)

Do While ! QR1->(Eof()) 
   dDtEmi := STOD(QR1->F3_EMISSAO) 
   QR1->(DbSkip())
EndDo 

QR1->(dbCloseArea())

SA1->(DbSetOrder(1))
SA2->(DbSetOrder(1))
DbSelectArea("SF2")               
SF2->(DbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+mv_par01+mv_par03))

SetRegua(Val(mv_par02)-Val(mv_par01))

While SF2->F2_FILIAL == xFilial("SF2") .And. SF2->F2_DOC <= mv_par02 .And. !Eof()
	
	//  If Alltrim(SF2->F2_ESPECIE) <> "SPED"
	//     apmsgStop("*** Especie da Nota Fiscal incoerente (SPED)***")
	//     Return
	//  EndIf
	
	If SF2->F2_MSIMPR == "S" .And. (aReturn[5] == 2 .OR. aReturn[5] == 3)
		If ! apMsgYESNO("N.Fiscal/Espelho já impressa. Deseja reimprimír ?")
			Return
		EndIf
	EndIf
	
	If SF2->F2_SERIE <> mv_par03
		SF2->(DbSkip())
		IncRegua()
		Loop
	Endif
	
	//    If SF2->F2_TIPO == "N" .And. SubStr(Upper(SF2->F2_ESPECI1),1,4) <> "VIDE" .And. SubStr(Upper(SF2->F2_ESPECI1),1,7) <> "CACAMBA" .And. (Empty(SF2->F2_ESPECI1) .Or. SF2->F2_PLIQUI == 0 .Or. SF2->F2_PBRUTO == 0)
	
	If SF2->F2_TIPO == "N" .And. Empty(SF2->F2_ESPECI1) .AND. SF2->F2_PLIQUI == 0 .AND. SF2->F2_PBRUTO == 0
		apmsgStop("Informações de Peso e Volume Incoerentes, Espelho da N.Fiscal não será emitido.")
		Return
	EndIf
	
	If SF2->F2_EMISSAO < dDtEmi
		apmsgStop("Data de Emissão incoerente com Ultima Nota Emitida, Espelho da N.Fiscal não será emitido.")
		Return
	EndIf
	/*  TIRADO NO DIA 17/09/13 - FAZ CONCISTÊNCIA NO B1, SE A NOTA ESTÁ GERADA, ELA JÁ DEU BAIXZA NO B2 - LIZANDRA
	If SF2->F2_TIPO == "N"
	If !VerEstoque()
	Return
	EndIf
	EndIf
	*/
	_cPC   := ""
	cUF := ""    // para impressão de notas de exportação
	If SF2->F2_TIPO == "B" .OR. SF2->F2_TIPO == "D"    	//Verifica se a nota e para cliente
		SA2->(DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		cUF := Alltrim(SA2->A2_EST)
	Else
		SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		cUF := Alltrim(SA1->A1_EST)
	EndIf
	
	SD2->(DbSetOrder(3))
	If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
		cProd := SubStr(Alltrim(SD2->D2_COD),1,2)
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			cNat    := Alltrim(SC5->C5_NATUREZ)
		EndIf
	EndIf
	
	_aCab    := {}				  		   			 		//Inicia Matriz com dados do cabecalho da nota
	Aadd(_aCab,SF2->F2_DOC     ) 		   			 		//Numero da nota     [01]
	Aadd(_aCab,SF2->F2_EMISSAO ) 					 		//Emissao da nota    [02]
	Aadd(_aCab,SF2->F2_BASEICM )  		    		 		//Valor base do ICMS [03]
	Aadd(_aCab,SF2->F2_VALICM  )  							//Valor do ICMS      [04]
	Aadd(_aCab,SF2->F2_VALIPI  )  					 		//Valor do IPI       [05]
	Aadd(_aCab,SF2->F2_FRETE   )  					 		//Valor do frete     [06]
	Aadd(_aCab,SF2->F2_SEGURO  )  							//Valor do Seguro    [07]
	
	If SF2->F2_TIPO == "P"
		nValor := 0.00
	Else
		nValor := SF2->F2_VALMERC
	EndIf
	Aadd(_aCab,nValor)  				   					//Total dos produtos [08]
	If SF2->F2_TIPO == "P"
		nValor := SF2->F2_VALIPI
	Else
		nValor := SF2->F2_VALMERC + SF2->F2_SEGURO + SF2->F2_FRETE + SF2->F2_VALIPI + SF2->F2_DESPESA  //Total da nota
	EndIf
	
	If SF2->F2_ICMSRET > 0
		nValor := SF2->F2_VALMERC + SF2->F2_SEGURO + SF2->F2_FRETE + SF2->F2_VALIPI + SF2->F2_ICMSRET  //Total da nota com ICMS RET
	Endif
	
	Aadd(_aCab,nValor)           							//Total da Nota       [09]
	Aadd(_aCab,SF2->F2_PBRUTO )  		   					//Peso Bruto na nota  [10]
	Aadd(_aCab,SF2->F2_PLIQUI )  		   					//Peso Liq. na nota   [11]
	Aadd(_aCab,SF2->F2_ESPECI1)  		   					//Especie na nota     [12]
	Aadd(_aCab,SF2->F2_VOLUME1)  		   					//Volume na nota      [13]
	Aadd(_aCab,SF2->F2_BRICMS  )  					 		//Valor Base ICMS Ret [14]
	Aadd(_aCab,SF2->F2_ICMSRET )  							//Valor ICMS Retido   [15]
	Aadd(_aCab,SF2->F2_DESPESA ) 							//Valor das Despesas  [16]
	Aadd(_aCab,SF2->F2_DESCONT )
	
	_aItens  := {}						   					//Inicia Matriz com dados dos itens da nota
	
	_aCfo    := {}
	_aMsgCla := {}
	
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4")+ SF2->F2_COND))
	
	//Variaveis acumuladoras para retorno de mercadoria
	_nTotDev	:= 0
	_cNotDev	:= ""
	_cMatFalt	:= ""
	_cDatDev	:= ""
	_lDevBen	:= .f.
	_cNumPed 	:= ""
	_cNum		:= Alltrim(SC5->C5_NUM)
	IF SUBSTR(cNumEmp,1,2) <> '15'
		_cCont    	:= Alltrim(SC5->C5_MSCONT)
		_cOrcam		:= Alltrim(SC5->C5_ORCAM)
	ELSE
		_cCont    	:= ""
		_cOrcam		:= ""
	ENDIF
	_cVend		:= Alltrim(SC5->C5_VEND1)
	_cFrete     := Alltrim(SC5->C5_TPFRETE)
	_cCfo       := ""
	cCfo        := ""
	_cTexto     := ""
	cEndCob     := ""
	cMenNota    := ""
	cMensRetMat := ""
	cMensSZO    := ""
	nItem       := 0
	aMens       := {}
	
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
	While SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And. SD2->(!Eof())
		
		nItem++ // utilizado para armazenar as mensagens no SZO
		/*
		If Substr(Alltrim(SD2->D2_TES),1,3) $ "639_502"           					//MATERIAL FALTANTE
		_cMatFalt 	:= ". " + SD2->D2_NFORI + " DE " + Dtoc(SD2->D2_EMISSAO)
		Endif
		*/
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+ SD2->D2_PEDIDO))
			If !Empty(Alltrim(SC5->C5_MENNOTA))
				If cMenNota == ""
					cMenNota := Alltrim(SC5->C5_MENNOTA)
				Else
					If !Alltrim(SC5->C5_MENNOTA) $ ALLTRIM(cMenNota)
						cMenNota += Alltrim(SC5->C5_MENNOTA)
					Endif
				EndIf
			EndIf
			/* - tirado 07/10/13 - o programa NFESEFAZ já trata o campo - estava saindo duplicado na DANFE - Lizandra
			If !Empty(Alltrim(SC5->C5_MENPAD))
			AADD(aMens,{Alltrim(SC5->C5_MENPAD),StrZero(nItem,2)})
			EndIf
			*/
			If _cNumPed == ""
				_cNumPed := SD2->D2_PEDIDO
			Else
				If ! Alltrim(SD2->D2_PEDIDO) $ _cNumPed
					_cNumPed := _cNumPed+"/"+SD2->D2_PEDIDO
				EndIf
			EndIf
			IF SUBSTR(cNumEmp,1,2) <> '15'   // tirar depois - Lizandra
				If Alltrim(SC5->C5_PC) <> ""
					If _cPC == ""
						_cPC  := Alltrim(SC5->C5_PC)
					Else
						If !Alltrim(SC5->C5_PC) $ _cPC
							_cPC += "/" + Alltrim(SC5->C5_PC)
						EndIf
					EndIf
				EndIf
			ENDIF
		EndIf
		
		// Verifica incoerencia na CFOP e UF do Cliente
		/*
		If (SubStr(SD2->D2_CF,1,1) == "5" .And. cUF <> "SP") .Or. (SubStr(SD2->D2_CF,1,1) == "7" .And. cUF <> "EX") .Or. (SubStr(SD2->D2_CF,1,1) == "6" .And. (cUF == "SP" .Or. cUF == "EX"))
		apmsgStop("CFOP da Nota Fiscal Incoerente com a UF do Cliente - Emissão será cancelada.")
		Return
		Endif
		*/
		//Tratamento para mais de um cfop na mesma nota
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
		If  _cCfo == ""
			_cCfo   := Alltrim(SD2->D2_CF)
			_cTexto := Alltrim(SF4->F4_TEXTO)
			cTpOper := SubStr(SD2->D2_CF,2,1)
		Else
			If ! Alltrim(SD2->D2_CF) $ _cCfo
				_cCfo   := _cCfo+"/"+Alltrim(SD2->D2_CF)
				_cTexto := _cTexto+"/"+Alltrim(SF4->F4_TEXTO)
			Endif
		EndIf
		
		IF SUBSTR(cNumEmp,1,2) <> '15'       	   // TIRAR DEPOIS - LIZANDRA
			If !Empty(SF4->F4_MEN)
				AADD(aMens,{Alltrim(SF4->F4_MEN),StrZero(nItem,2)})
			EndIf
		ENDIF
		
		SB1->(DbSetorder(1))
		SB1->(DbSeek(xFilial("SB1")+ SD2->D2_COD))
		
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+ SD2->D2_PEDIDO + SD2->D2_ITEMPV))
		
		_lNotDev  := .t.
		_cDescPro := ""
		//Ivandro Santos - 06/04/17 - início da alteração
		//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
		//If (SubStr(cNumEmp,1,2) == "01" .Or. SubStr(cNumEmp,1,2) == "10" .Or. SubStr(cNumEmp,1,2) == "40")
		If SubStr(cNumEmp,1,2) $ "01_10_40"
			SZB->(DbSetorder(1))
			If SZB->(DbSeek(xFilial("SZB")+SD2->D2_COD+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
				_cDescPro := Alltrim(SZB->ZB_DESC01)
			EndIf
		EndIf
		/*IF SUBSTR(cNumEmp,1,2) <> '15'
			If Alltrim(_cDescPro) == ""
				If Alltrim(SB1->B1_DESCP) <> "" 		//Se existir descricao estendida no cadastro
					_cDescPro := ALLTRIM(SB1->B1_DESCP)
				Else
					_cDescPro := ALLTRIM(SB1->B1_DESC)
				Endif
			EndIf
		ELSE */
		If Empty(Alltrim(_cDescPro))
			SB5->(DbSetorder(1))
			IF SB5->(DbSeek(xFilial("SB5")+ SD2->D2_COD))
				_cDescPro := ALLTRIM(SB5->B5_CEME)
			Else
				_cDescPro := ALLTRIM(SB1->B1_DESC)
			Endif
		Endif
		//ENDIF
		//Ticket#2017031037000107 — Fim da alteração
		_cDescPro += "(N/Ped.: " + ALLTRIM(SD2->D2_PEDIDO) + "/" + SD2->D2_ITEMPV+")"
		
		If !Empty(SC6->C6_PEDCLI)
			
			IF SC6->C6_CLI + SC6->C6_LOJA  == "00601800" // ALTERADO PARA ATUALIZAR OS PC´S DA FABRIMA COM O NUMERO E DATA DA NFS
				//				DBUSEAREA(.T.,"TOPCONN","SC7100","SC7_", .F., .F.)
				dbSelectArea("SC7")                   // SOLICITACAO FEITA PELO KLASNER - ALTERAÇÃO FEITA PELA LIZANDRA - 31/01/13
				SC7->(dbSetOrder(4))
				IF SC7->(dbSeek(xFilial("SC7")+SUBSTR(SC6->C6_PRODUTO,1,15) + SUBSTR(SC6->C6_PEDCLI,1,6)))
					RecLock("SC7",.F.)
					SC7->C7_OBS  := RTRIM(SC7->C7_OBS) + " " + SD2->D2_DOC + "  " + DTOC(SF2->F2_EMISSAO)
					SC7->(MsUnlock())
				ENDIF
				//DBCLOSEAREA("SC7100")
			ENDIF
			IF !(SubStr(SD2->D2_CF,2,3)  $ "902_925")
				_cDescPro += " - S/Ped.: " + ALLTRIM(SC6->C6_PEDCLI) + ")"
			ENDIF
		EndIf
		
		If !Empty(SD2->D2_NFORI)
			_cDescPro += " - S/NF.:" + ALLTRIM(SD2->D2_NFORI) + ")"
		EndIf
		If SF2->F2_TIPO == "P"
			nValor := 0
		Else
			nValor := SD2->D2_TOTAL
		EndIf
		Aadd(_aItens,{SD2->D2_COD  ,_cDescPro ,SB1->B1_POSIPI ,SD2->D2_CLASFIS,;   // O D2_CLASFIS corresponde ao B1_ORIGEM (Tab."S0" do SX5) + F4_SITTRIB (Tab."S2" do SX5)
		SD2->D2_UM   ,SD2->D2_QUANT,SD2->D2_PRCVEN ,nValor ,;
		SD2->D2_PICM ,SD2->D2_IPI  ,SD2->D2_VALIPI ,Alltrim(SD2->D2_CF),;
		SD2->D2_NFORI,SD2->D2_SERIORI,SC6->C6_PEDCLI})
		
		// Grava tabela com as mensagens que deverão ser impressas
		
		If Alltrim(cUF) <> "EX"
			SB1->(DbSetorder(1))
			SB1->(DbSeek(xFilial("SB1")+ SD2->D2_COD))
			SYD->(dbSetOrder(1))
			If SYD->(dbSeek(xFilial("SYD")+SB1->B1_POSIPI))
				If !Empty(SYD->YD_MENS1)
					cCodMens := Alltrim(SYD->YD_MENS1)
					AADD(aMens,{cCodMens,StrZero(nItem,2)})
				EndIf
				If !Empty(SYD->YD_MENS2)
					cCodMens := Alltrim(SYD->YD_MENS2)
					If cCodMens $ "102|166" .And. (cUF <> "SP" .Or. SD2->D2_PICM == 0)
						cCodMens := ""
					Else
						//If cCodMens <> "102" .Or. (cCodMens == "102" .And. cUF == "SP" .And. SF2->F2_TIPO == "N") // .And. cTpOper <> "9")
						AADD(aMens,{cCodMens,StrZero(nItem,2)})
						//EndIf
					EndIf
				EndIf
				If !Empty(SYD->YD_MENS3)
					cCodMens := Alltrim(SYD->YD_MENS3)
					If cCodMens == "103" .And. SD2->D2_PICM == 0
						cCodMens := ""
					Else
						AADD(aMens,{cCodMens,StrZero(nItem,2)})
					EndIf
				EndIf
			EndIf
		EndIf
		
		//Tratamento para notas de devolucao de material beneficiado da Maklaser
		If SubStr(cNumEmp,1,2) == "03"
			If !Empty(SD2->D2_NFORI)
				SD1->(DbSetOrder(1))
				If !SD1->(DbSeek(xFilial("SD1") + SD2->D2_NFORI + SD2->D2_SERIORI + SF2->F2_CLIENTE + SF2->F2_LOJA))
					_lNotDev := .f.
				Endif
				If Substr(Alltrim(SD2->D2_CF),2,3) $ "902_925"
					_nTotDev+=SD2->D2_TOTAL
					If Len(_cCfo) > 4
						_aCab[08]-=SD2->D2_TOTAL
						_aCab[09]-=SD2->D2_TOTAL
					EndIf
					_lDevBen := .t.
					If _cNotDev == ""
						_cNotDev := SD2->D2_NFORI
						If _lNotDev
							_cNotdev := _cNotDev + "-" + Dtoc(SD1->D1_EMISSAO)
						Endif
					Else
						If !(SD2->D2_NFORI $(_cNotDev))
							_cNotDev :=_cNotDev + "-" + SD2->D2_NFORI
							If _lNotDev
								_cNotDev += "-" + Dtoc(SD1->D1_EMISSAO)
							Endif
						Endif
					Endif
					cMensRetMat := "Retorno de material beneficiado no valor de R$ " + Alltrim(Str(_nTotDev,14,2)) + ", ref. a(s) nota(s) "+Alltrim(_cNotDev)
				Endif
			EndIf
		EndIf
		SD2->(DbSetOrder(3))
		SD2->(DbSkip())
	EndDo
	//==============================================================================================================
	_aCliFor := {}    									//Inicia matriz com dados do cliente / fornecedor
	cEndEntrega := ""
	If SF2->F2_TIPO == "B" .OR. SF2->F2_TIPO == "D"    	//Verifica se a nota e para cliente ou fornecedor
		SA2->(DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Aadd(_aCliFor,SA2->A2_NOME + " (" + sa2->a2_cod + ")"   )  //Nome do fornec.   [01]
		Aadd(_aCliFor,SA2->A2_CGC    			)  //CNPJ/CPF          [02]
		Aadd(_aCliFor,SA2->A2_END    			)  //Endereco          [03]
		Aadd(_aCliFor,SA2->A2_BAIRRO 			)  //Bairro            [04]
		Aadd(_aCliFor,SA2->A2_CEP   			)  //CEP               [05]
		Aadd(_aCliFor,SA2->A2_MUN				)  //Municipio         [06]
		Aadd(_aCliFor,Alltrim(SA2->A2_TEL)     )  //Telefone          [07]
		Aadd(_aCliFor,Alltrim(SA2->A2_FAX)     	)  //FAX               [08]
		Aadd(_aCliFor,SA2->A2_EST    			)  //Estado            [09]
		Aadd(_aCliFor,SA2->A2_INSCR  			)  //Incricao Estadual [10]
		If SA2->A2_EST == "EX"
			SYA->(DbSetOrder(1))
			If SYA->(DbSeek(xFilial("SYA")+SA2->A2_PAIS))
				Aadd(_aCliFor,Alltrim(SYA->YA_DESCR)) //Nome Pais      [11]
			Else
				Aadd(_aCliFor," ")
			Endif
		Else
			Aadd(_aCliFor," ")
		Endif
	Else
		SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Aadd(_aCliFor,SA1->A1_NOME + " (" + sa1->a1_cod + "/" + sa1->a1_loja + ")")   //Nome do cliente   [01]
		Aadd(_aCliFor,SA1->A1_CGC)                               //CNPJ/CPF          [02]
		Aadd(_aCliFor,SA1->A1_END)                               //Endereco          [03]
		Aadd(_aCliFor,SA1->A1_BAIRRO)                            //Bairro            [04]
		Aadd(_aCliFor,SA1->A1_CEP)                               //CEP               [05]
		Aadd(_aCliFor,SA1->A1_MUN)                               //Municipio         [06]
		Aadd(_aCliFor,Alltrim(SA1->A1_TEL))                      //Telefone          [07]
		Aadd(_aCliFor,Alltrim(SA1->A1_FAX))                      //FAX               [08]
		Aadd(_aCliFor,SA1->A1_EST)                               //Estado            [09]
		Aadd(_aCliFor,SA1->A1_INSCR)                             //Incricao Estadual [10]
		If SA1->A1_EST == "EX"
			SYA->(DbSetOrder(1))
			If SYA->(DbSeek(xFilial("SYA")+SA1->A1_PAIS))
				Aadd(_aCliFor,Alltrim(SYA->YA_DESCR))            //Nome Pais         [11]
			Else
				Aadd(_aCliFor," ")
			Endif
		Else
			Aadd(_aCliFor," ")
		Endif
		cEndCob := ""
		If SA1->A1_ENDCOB <> ""
			cEndCob := Alltrim(SA1->A1_ENDCOB) + " " + Alltrim(SA1->A1_MUNC)
			If Alltrim(SA1->A1_ESTC) <> ""
				cEndCob += "-" + Alltrim(SA1->A1_ESTC)
			EndIf
			If Alltrim(SA1->A1_CEPC) <> ""
				cEndCob += " CEP: " + Alltrim(SA1->A1_CEPC)
			EndIf
		EndIf
		If !Empty(SA1->A1_ENDENT)
			cEndEntrega := "End.Entrega: " + Alltrim(SA1->A1_ENDENT) + " " + Alltrim(SA1->A1_BAIRROE) + " " + Alltrim(SA1->A1_MUNE)
			If !Empty(Alltrim(SA1->A1_ESTE))
				cEndEntrega := Alltrim(cEndEntrega) + " - " + Alltrim(SA1->A1_ESTE)
			EndIf
		EndIf
	Endif
	//==========================Inicia matriz com dados das duplicatas================================
	_aDup    := {}
	_aDup2   := {}    // utilizado para qtde. de duplicatas > 10
	If !Empty(SF2->F2_DUPL)               						//Se a nota possuir duplicatas
		SE1->(DbSetOrder(1))
		SE1->(DBGOTOP())
		SE1->(DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DUPL))
		Do While xFilial("SE1") == SE1->E1_FILIAL .And. SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DUPL .And. !SE1->(Eof())
			If Alltrim(SE1->E1_TIPO) <> "NF"
				SE1->(dbSkip())
				Loop
			Endif
			//========================================================================================
			//  Gera Matriz das Condiçoes de Pagamento conforme campo MSCONDS do SE4
			//========================================================================================
			_cDesNeg	:= ""
			//If SE1->E1_VENCTO < SF2->F2_EMISSAO .Or. SE1->E1_MOTNEG == "SIN"
			If SE1->E1_VENCTO < SF2->F2_EMISSAO .Or. !Empty(SE1->E1_MOTNEG)
				If SX5->(DbSeek(xFilial("SX5")+"FU"+SE1->E1_MOTNEG))		//Verif.Motivo de Negociação - Tabela FU
					_cDesNeg	:= Substr(X5DESCRI(),1,19)
					//If SE1->E1_MOTNEG == "SIN"
					_cDesNeg := Alltrim(_cDesNeg) + "-" + DTOC(SE1->E1_VENCTO)
					//EndIf
					If Len(_aDup) < 10
						Aadd(_aDup,{(Alltrim(SE1->E1_NUM)+"/"+SE1->E1_PARCELA),_cDesNeg,SE1->E1_VALOR})
					Else
						Aadd(_aDup2,{(Alltrim(SE1->E1_NUM)+"/"+SE1->E1_PARCELA),_cDesNeg,SE1->E1_VALOR})
					EndIf
				Endif
			Else
				IF SUBSTR(cNumEmp,1,2) <> '15'
					If Empty(SE4->E4_MSCOND)
						If Len(_aDup) < 10
							Aadd(_aDup,{(Alltrim(SE1->E1_NUM)+"/"+SE1->E1_PARCELA),DTOC(SE1->E1_VENCTO),SE1->E1_VALOR})
						Else
							Aadd(_aDup2,{(Alltrim(SE1->E1_NUM)+"/"+SE1->E1_PARCELA),DTOC(SE1->E1_VENCTO),SE1->E1_VALOR})
						EndIf
					Else
						If Len(_aDup) < 10
							Aadd(_aDup,{(Alltrim(SE1->E1_NUM)+"/"+SE1->E1_PARCELA),(Alltrim(SE4->E4_MSCOND)+"-"+DTOC(SE1->E1_VENCTO)),SE1->E1_VALOR})
							// Else
							//    Aadd(_aDup2,{(Alltrim(SE1->E1_NUM)+"/"+SE1->E1_PARCELA),(Alltrim(SE4->E4_MSCOND)+"-"+DTOC(SE1->E1_VENCTO)),SE1->E1_VALOR})
						Endif
					EndIf
				ELSE
					If Len(_aDup) < 10
						Aadd(_aDup,{(Alltrim(SE1->E1_NUM)+"/"+SE1->E1_PARCELA),"-"+DTOC(SE1->E1_VENCTO),SE1->E1_VALOR})
					Endif
				ENDIF
			Endif
			SE1->(dbSkip())
		EndDo
	Endif
	
	If !Empty(cMenNota)           // Elimina possiveis carateres que desposiciona a emissao das mensagens
		cAux := Alltrim(cMenNota)
		cMenNota := ""
		For I := 1 to Len(cAux)
			cChar := MsAscII(SubStr(cAux,I,1))
			If cChar >= 32 .Or. cChar <= 255
				cMenNota += SubStr(cAux,I,1)
			EndIf
		Next I
	EndIf
	
	IF SUBSTR(cNumEmp,1,2) <> '15'
		
		//Grava arquivo (SZO) com as mensagens da nota fiscal
		
		cCodMens := ""
		cMensSZO := ""
		SZO->(DbSetOrder(1))
		If !SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
			If SUBSTR(cNumEmp,1,2) = '01' //MASIPACK - Obrigatoriedade de informar exclusão do PIS/COFINS da base do ICMS
				cMensSZO :="PROCESSO - Num. 5002468-80.2021.4.03.6114 - Exclusao do ICMS na Base de Calculo do PIS e COFINS. - "
			Else //FABRIMA - Obrigatoriedade de informar exclusão do PIS/COFINS da base do ICMS
				cMensSZO := "PROCESSO - Num. 0009214-25.2007.4.03.6119 - Exclusao do ICMS na Base de Calculo do PIS e COFINS. - "
			EndIf

			If Alltrim(_cPC) <> ""
				cMensSZO += "S/ Pedido: " + Alltrim(_cPC) + " - "
			EndIf
			
			If Alltrim(_cOrcam) <> ""
				cMensSZO += "Orcamento: " + Alltrim(_cOrcam) + " - "
			EndIf
			cMensSZO += Alltrim(_cMatFalt)
			cMensSZO += Alltrim(cMenNota) + " " + Alltrim(cMensRetMat) + " " + Alltrim(_cMatFalt)
			cMensSZO += Alltrim(cMensRetMat) + " " + Alltrim(_cMatFalt)
			RecLock("SZO",.T.)
			SZO->ZO_FILIAL  := "01"
			SZO->ZO_SERIE   := SF2->F2_SERIE
			SZO->ZO_NFISCAL := SF2->F2_DOC
			SZO->ZO_MENS    := Alltrim(cMensSZO)
			SZO->ZO_DATA    := SF2->F2_EMISSAO
			SZO->ZO_IMPR    := "N"
			SZO->(MsUnlock())
			
			If Len(aMens) > 0
				ASORT(aMens,,,{ |x, y| x[1]+x[2] < y[1]+y[2] })
				cCodMens := ""
				For I := 1 to Len(aMens)
					If aMens[I][1] <> cCodMens
						cCodMens := Alltrim(aMens[I][1])
						SM4->(dbSetOrder(1))
						If SM4->(dbSeek(xFilial("SM4")+cCodMens))
							cMensSZO := " " + Alltrim(SM4->M4_FORMULA) + "-Item(s):" + aMens[I][2]
							SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
							RecLock("SZO",.F.)
							SZO->ZO_MENS := Alltrim(SZO->ZO_MENS) + cMensSZO
							SZO->(MsUnlock())
						EndIf
						cItemAnt := Alltrim(aMens[I][2])
						apmsgAlert("Mensagem: "+ cCodMens+ "-"+cMensSZO)
					Else
						If cItemAnt <> aMens[I][2]
							SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
							RecLock("SZO",.F.)
							SZO->ZO_MENS := SZO->ZO_MENS + "/" + aMens[I][2]
							SZO->(MsUnlock())
							cItemAnt := aMens[I][2]
						EndIf
					EndIf
				Next
				SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
				nTamMens := Len(Alltrim(SZO->ZO_MENS))
				If !Empty(cEndEntrega)
					nTamMens += 130
				EndIf
				
				If nTamMens > 990
					apmsgAlert("Mensagens da Nota Fiscal ultrapassa o limite de impressão ("+Str(nTamMens,5)+"(, Corrija e re-imprima")
					//If aReturn[5] == 2 .OR. aReturn[5] == 3
					RecLock("SF2",.F.)
					SF2->F2_MSIMPR := "S"
					SF2->(MsUnLock())
					//EndIf
					Return
				EndIf
				
			EndIf
			//Informar aqui o número do Pedido de Venda se a natureza do PV for V02 e o TES gerar duplicata
			IF !Empty(Alltrim(SF2->F2_DUPL))
				_aPedVen := GetAdvFval("SC5",{"C5_NUM","C5_NATUREZ"},xFilial("SC5")+SF2->F2_DOC+SF2->F2_SERIE,6," ")
				If Alltrim(SUBSTR(_aPedVen[2],1,3)) = "V02"
					SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
					RecLock("SZO",.F.)
					SZO->ZO_MENS := SZO->ZO_MENS + " *** N/NF REF PV: "+_aPedVen[1]+" ***"
					SZO->(MsUnlock())
				Endif
			EndIf
			//
		ENDIF
		IF !Empty(Alltrim(SF2->F2_DUPL))
			If Alltrim(SUBSTR(cNat,1,3)) = "V02"
				SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
				If !("N/NF REF PV" $ SZO->ZO_MENS)
					RecLock("SZO",.F.)
					SZO->ZO_MENS := SZO->ZO_MENS + " *** N/NF REF PV: "+_cNum+" ***"
					SZO->(MsUnlock())
				EndIf
			Endif
		EndIf
	Else 
		//HELSIMPLAST - Obrigatoriedade de informar exclusão do PIS/COFINS da base do ICMS
		cMensSZO := " Em 01/07/2022, iniciamos a Exclusão do ICMS na Base de Cálculo do PIS e COFINS - IN 1.911/2019 (RFB) - "
		If Len(aMens) > 0
			ASORT(aMens,,,{ |x, y| x[1]+x[2] < y[1]+y[2] })
			cCodMens := ""
			For I := 1 to Len(aMens)
				If aMens[I][1] <> cCodMens
					cCodMens := Alltrim(aMens[I][1])
					SM4->(dbSetOrder(1))
					If SM4->(dbSeek(xFilial("SM4")+cCodMens))
						cMensSZO += " " + Alltrim(SM4->M4_FORMULA) + "-Item(s):" + aMens[I][2]
					Endif
				Endif
			next
		Endif
		RecLock("SZO",.T.)
		SZO->ZO_FILIAL  := xFilial("SF2")
		SZO->ZO_SERIE   := SF2->F2_SERIE
		 := SF2->F2_DOC
		SZO->ZO_MENS    := Alltrim(cMensSZO)
		SZO->ZO_DATA    := SF2->F2_EMISSAO
		SZO->ZO_IMPR    := "N"
		SZO->(MsUnlock())
	EndIf
	// Verifica se o tamanho das mensagens para não ultrapassar a qtde. de linhas disponíveis
	IF SUBSTR(cNumEmp,1,2) <> '15'
		SZO->(DbSetOrder(1))
		SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
		nTamMens := Len(Alltrim(SZO->ZO_MENS))
		If !Empty(cEndEntrega)
			nTamMens += 130
		EndIf
		/*
		If nTamMens > 990
		apmsgStop("Mensagens da Nota Fiscal ultrapassa o limite de impressão ("+Str(nTamMens,5)+"(, Corrija e re-imprima")
		Return
		EndIf
		*/
	ENDIF
	//Inicia a Impressao da nota atual==========================================================================
	_nLi := 003
	@ _nLi , 083 Psay "X"
	_nLi+=5
	@_nLi , 000 Psay Chr(15)					//Compressao de caractere de impressao
	@ _nLi , 002 Psay _cTexto
	@ _nLi , 097 Psay _cCfo
	@ _nLi , 000 Psay Chr(18)			    // Descompressao de caractere de impressao
	_nLi+=3
	@ _nLi , 002 Psay _aCliFor[01]
	@ _nLi , 082 Psay _aCliFor[02] Picture "@R 99.999.999/9999-99"
	@ _nLi , 104 Psay _aCab[02]
	_nLi+=2
	@ _nLi , 002 Psay _aCliFor[03]
	@ _nLi , 062 Psay _aCliFor[04]
	@ _nLi , 091 Psay _aCliFor[05] Picture "@R 99999-999"
	_nLi+=2
	@ _nLi , 002 Psay Alltrim(_aCliFor[06]) + " - " + Alltrim(_aCliFor[11])
	cFoneFax := _aCliFor[07]
	If !Empty(_aCliFor[08])
		cFoneFax += " / " + _aCliFor[08]
	EndIf
	If !Empty(cFoneFax)
		@ _nLi , 035 Psay SubStr(cFoneFax,1,50)
	EndIf
	@ _nLi , 079 Psay _aCliFor[09]
	@ _nLi , 082 Psay _aCliFor[10]
	_nLi+=3
	@ _nLi , 000 Psay Chr(15)					   		 				// Compressao de caractere de impressao
	// Imprime extenso e pedido (nosso e cliente) e duplicata (se houver)
	_nExt := 1
	For _nI := 1 to 5
		If Len(_aDup) >= _nI
			If _aDup[_nI][1] <> ""
				@ _nLi , 002 Psay _aDup[_nI,01]
				@ _nLi , 013 Psay _aDup[_nI,02]
				@ _nLi , 042 Psay _aDup[_nI,03] Picture "@E 99,999,999.99"
			EndIf
		EndIf
		If Len(_aDup) >= _nI + 5
			If _aDup[_nI+5][1] <> ""
				@ _nLi , 055 Psay _aDup[_nI+5,01]
				@ _nLi , 065 Psay _aDup[_nI+5,02]
				@ _nLi , 084 Psay _aDup[_nI+5,03] Picture "@E 99,999,999.99"
			EndIf
		EndIf
		If SubStr(cNumEmp,1,2) == "03"
			nPos  := AT("/",_cCfo)
			If nPos > 0
				cCfo := alltrim(Substr(_cCfo,nPOS-4,4))
			Endif
		Endif
		If cCfo $ "5902"
			If Len(_cCfo) > 4
				@ _nLi , 098 Psay Substr(Rtrim(Substr(Extenso(_aCab[09]-_nTotDev),_nExt,040)) + Replicate("*",40),1,40)
			Endif
		Else
			@ _nLi , 098 Psay Substr(Rtrim(Substr(Extenso(_aCab[09]),_nExt,040)) + Replicate("*",40),1,40)
		Endif
		If cEndCob <> ""
			If _nI == 1 .And. SubStr(cEndCob,1,27) <> ""
				@ _nLi , 138 Psay Substr(cEndCob,1,27)
			ElseIf _nI == 2 .And. SubStr(cEndCob,31,27) <> ""
				@ _nLi , 138 Psay Substr(cEndCob,31,27)
			ElseIf _nI == 3 .And. SubStr(cEndCob,61,27) <> ""
				@ _nLi , 138 Psay Substr(cEndCob,61,27)
			EndIf
		Endif
		If _nI == 1
			@ _nLi , 176 Psay _cPC 						   				//Alltrim(SC5->C5_COTACAO)
		Endif
		If _nI == 3
			@ _nLi , 176 Psay _cCont        							// SC5->C5_MSCONT
		Endif
		If _nI == 5
			@ _nLi , 176 Psay _cVend+" / "+_cOrcam      				// SC5->C5_VEND1 + SC5->C5_ORCAM
		Endif
		_nExt+=42
		_nLi++
	Next _nI
	
	// Imprime Itens da nota
	_nLi := 25
	@ _nLi , 000 Psay Chr(15)
	// Compressao de caractere de impressao
	
	//	_nLi++
	
	_nImp := .t.
	_cDescPro := ""
	For _nI := 1 to Len(_aItens)
		If Substr(Alltrim(_aItens[_nI,12]),2,3) $ "902_925" .And. _nImp
			@ _nLi , 024 Psay "****** R E T O R N O   D E   B E N E F I C I A M E N T O ******"
			_nLi++
			_nImp := .f.
		EndIf
		@ _nLi , 002 Psay Alltrim(_aItens[_nI,01])   			       // Cód.Produto
		@ _nLi , 018 Psay Substr(_aItens[_nI,02],1,90)
		
		//SC5->(DbSetOrder(6))
		SC5->(DBORDERNICKNAME("NOTASERIE"))
		SC5->(DbSeek(xFilial("SC5")+ SF2->F2_DOC))
		@ _nLi , 109 Psay _aItens[_nI,12]
		@ _nLi , 114 Psay _aItens[_nI,03]                                                   // Class.Fiscal
		@ _nLi , 124 Psay _aItens[_nI,04]													// Sit.Tributária
		@ _nLi , 129 Psay _aItens[_nI,05]
		// Unid.Medida
		@ _nLi , 132 Psay _aItens[_nI,06] Picture "@E 999,999.99"							// Quantidade
		@ _nLi , 142 Psay _aItens[_nI,07] Picture "@E 99,999,999.9999"						// Valor Unitário
		@ _nLi , 160 Psay _aItens[_nI,08] Picture "@E 999,999,999.99"						// Valor Total
		@ _nLi , 176 Psay _aItens[_nI,09] Picture "99"										// Perc. Icms
		@ _nLi , 180 Psay _aItens[_nI,10] Picture "99.99"									// Perc. Ipi
		@ _nLi , 184 Psay _aItens[_nI,11] Picture "@E 9,999,999.99"							// Valor do Ipi
		_nLi++
		IF SUBSTR(cNumEmp,1,2) <> '15'
			If !Empty(SE4->E4_MSCOND)
				If !Empty(SB1->B1_ISBN)
					@ _nLi , 020 Psay "COD.FINAME: "+Alltrim(SB1->B1_ISBN)+"  ////  "+"N.SERIE: "+Alltrim(SC6->C6_MSSERIE)
					_nLi++
				Endif
				If !Empty(SC5->C5_MSCONT)
					@ _nLi , 020 Psay "CONTRATO: " + Alltrim(SC5->C5_MSCONT)
					_nLi++
				Endif
				If !Empty(SC5->C5_MSFAVOR)
					@ _nLi , 020 Psay Alltrim(SC5->C5_MSFAVOR)
					_nLi++
				Endif
				//			_nLi++
				If !Empty(SC6->C6_MSOBS)
					@ _nLi , 020 Psay Alltrim(SC6->C6_MSOBS)
					_nLi++
				Endif
			Endif
		EndIf
		_nTamdesc := Len(_aItens[_nI,02])
		If _nTamdesc > 90
			_nDesc := 91
			While .t.
				If _nTamDesc > _nDesc
					@ _nLi , 020 Psay Substr(_aItens[_nI,02],_nDesc,90)
					_nLi++
					_nDesc+=90
				Else
					Exit
				Endif
			EndDo
		Endif
		If _nLi > 44
			_nLi := 3
			@ _nLi , 000 Psay Chr(18)
		EndIf
	Next _nI
	_nLi++
	If _lDevBen
		@ _nLi, 145 Psay "-------------"
		_nLi++
		@ _nLi, 124 Psay "Total do Retorno => "
		@ _nLi, 145 Psay _nTotDev Picture "@E 99,999,999.99"
	EndIf
	_nLi := 45
	@ _nLi , 000 Psay Chr(18)								    			// Descompressao de caractere de impressao
	_nLi++
	@ _nLi , 007 Psay _aCab[03] Picture "@E 999,999,999.99"                 // Base ICMS
	@ _nLi , 030 Psay _aCab[04] Picture "@E 999,999,999.99"                 // Valor ICMS
	@ _nLi , 053 Psay _aCab[14] Picture "@E 999,999,999.99"                 // Base ICMS Ret
	@ _nLi , 075 Psay _aCab[15] Picture "@E 999,999,999.99"                 // Valor ICMS Ret
	If cCfo $ "5902"
		If Len(_cCfo) > 4
			@ _nLi , 098 Psay _aCab[08]- _nTotDev Picture "@E 999,999,999.99"    // Val.Mercadoria (NF Normal)
		Endif
	Else
		@ _nLi , 098 Psay _aCab[08] Picture "@E 999,999,999.99"		         // Val.Mercadoria (NF Normal)
	Endif
	_nLi+=2
	@ _nLi , 007 Psay _aCab[06] Picture "@E 999,999,999.99"
	@ _nLi , 030 Psay _aCab[07] Picture "@E 999,999,999.99"
	@ _nLi , 050 Psay _aCab[16] Picture "@E 999,999,999.99"
	@ _nLi , 075 Psay _aCab[05] Picture "@E 999,999,999.99"
	If cCfo $ "5902"
		If Len(_cCfo) > 4
			@ _nLi , 098 Psay _aCab[09]- _nTotDev Picture "@E 999,999,999.99"    // Val.Mercadoria (NF Normal)
		Endif
	Else
		@ _nLi , 098 Psay _aCab[09] Picture "@E 999,999,999.99"		         // Val.Mercadoria (NF Normal)
	Endif
	_nLi+=3
	
	If !Empty(SF2->F2_TRANSP)                  					 			//Se a nota possuir transportadora
		SA4->(DbSetOrder(1))
		If SA4->(DbSeek(xFilial("SA4")+SF2->F2_TRANSP))
			@ _nLi , 002 Psay SA4->A4_NOME
			If _cFrete == "F"
				@ _nLi , 075 Psay "2"
			ElseIf _cFrete == "C"
				@ _nLi , 075 Psay "1"
			EndIf
			If !Empty(SA4->A4_CGC)
				@ _nLi , 093 Psay SA4->A4_CGC Picture "@R 99.999.999/9999-99"
			EndIf
			_nLi+=2
			@ _nLi , 002 Psay SA4->A4_END
			@ _nLi , 062 Psay SA4->A4_MUN
			@ _nLi , 088 Psay SA4->A4_EST
			@ _nLi , 093 Psay SA4->A4_INSEST
		EndIf
	EndIf
	_nLi := 55
	If _aCab[13] > 0
		@ _nLi , 002 Psay _aCab[13]
	Endif
	@ _nLi , 012 Psay _aCab[12]
	@ _nLi , 084 Psay _aCab[10] Picture "@E 99,999,999.999"
	@ _nLi , 100 Psay _aCab[11] Picture "@E 99,999,999.999"
	
	_nLi++
	@ _nLi , 000 Psay Chr(15)						    					// Compressao de caractere de impressao
	_nLi  := 57
	nMens := 0
	If !Empty(cEndEntrega)
		@ _nLi,002 Psay SubStr(cEndEntrega,1,124)
		nMens := 1
		_nLi++
	Else
		If !Empty(Alltrim(MEMOLINE(SZO->ZO_MENS,130,1)))
			cMensSZO := Alltrim(MEMOLINE(SZO->ZO_MENS,130,1))
			@ _nLi,002 Psay cMensSZO
		Else
			If !Empty(cMensSZO)
				@ _nLi,002 Psay cMensSZO
			Endif
		EndIf
		_nLi++
	EndIf
	For I := 2 to 7
		If !Empty(Alltrim(MEMOLINE(SZO->ZO_MENS,130,I-nMens)))
			cMensSZO := Alltrim(MEMOLINE(SZO->ZO_MENS,130,I-nMens))
			@ _nLi,002 Psay cMensSZO
		Endif
		_nLi++
	Next I
	@ _nLi,002 Psay "Atenção, Nota com desconto: "
	@ _nLi,030 Psay SF2->F2_DESCONT Picture "@E 999,999,999.99"
	_nLi++
	//============================================================================================
	@ _nLi , 000 Psay Chr(18)							    // Descompressao de caractere de impressao
	_nLi := 68
	_nLi+=4
	@ _nLi , 001 Psay ""     								//Finaliza a impressao da nota atual
	SetPrc(0,0)    											//Zera o formulario
	DbSelectArea("SF2")										//Atualiza flag de impressão da NF se opção for impressora
	//If aReturn[5] == 2 .OR. aReturn[5] == 3
	RecLock("SF2",.F.)
	SF2->F2_MSIMPR := "S"
	SF2->(MsUnLock())
	RecLock("SZO",.F.)
	SZO->ZO_IMPR := "S"
	SZO->(MsUnLock())
	//EndIf
	SF2->(DbSkip())    										//Avanca para a proxima nota
	IncRegua()
EndDo



Return
