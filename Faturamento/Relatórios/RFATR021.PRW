#Include "Rwmake.ch"      
#Include "Topconn.ch"

/*/{Protheus.doc} RFATR021
//TODO Descricao Relacao de Pedidos - (Nacional e Exportação) - (Analitico/Sintetico) 

@author Aparecida de F.Stevanato 
@since 16/05/2007
@version 1.0
@type user function

/*/

User Function RFATR021()                                                                                                

	Private titulo     := ""
	Private cString    := "SC5"
	Private wnrel      := "RFATR021"
	Private aReturn    := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
	Private nomeprog   := "RFATR021"
	Private cPerg	    := "XRFATR021"
	Private cArqTrab   := ""
	Private cFilTrab   := ""
	Private nLastKey   := 0
	Private Li         := 99 
	Private CbTxt      := ""
	Private cabec1     := ""
	Private cabec2     := ""
	Private tamanho    := "G"
	Private limite     := 220
	Private CbCont     := 0
	Private nCont      := 0
	Private nMQtde     := 0
	Private nMVlrMont  := 0
	Private nMVlrEmba  := 0
	Private nMComis    := 0
	Private nMTotMo2   := 0
	Private nMValor    := 0
	Private nMQtde     := 0
	Private cMPais     := ""
	Private nQtde      := 0
	Private nTotQtde   := 0
	Private nDia       := 0
	Private nTaxa      := 1
	Private cCampo     := ""
	Private cExport    := ""
	Private cSegmento  := "" 
	Private dDtAux     := CTOD("" )
	Private nTMontM2   := 0
	Private nTEmbaM2   := 0
	Private nTotMoeda2 := 0

	Private nVlrReal   := 0
	Private nVlrReaM   := 0
	Private nVlrReaE   := 0
	Private nTVlrMont  := 0
	Private nTVlrEmba  := 0

	Private nValor      := 0
	Private nVlrMont    := 0
	Private nVlrEmba    := 0
	Private nComisRep   := 0
	Private nComis      := 0

	Private nSubQtde    := 0
	Private nSubValor   := 0
	Private nSubVlrMo   := 0 
	Private nSubVlrEm   := 0
	Private nSubComis   := 0

	Private nTotQtde    := 0
	Private nTotValor   := 0
	Private nTotVlrM	  := 0
	Private nTotVlrE	  := 0
	Private nTotMoeda2  := 0
	Private nTotMontM2  := 0
	Private nTEmbaM2    := 0
	Private nTotEmbaM2  := 0
	Private nTotComis   := 0

	Private cQuebra     := ""
	Private lPrim       := .T.
	Private aVendedor   := {}
	Private I           := 0

	Private cNomeVend1  := ""
	Private cNomeVend2  := ""
	Private cPaisReg    := ""
	Private cMunicipio	:= ""
	Private cProdCli    := ""
	Private cPedAnt     := ""
	Private cNumCEAnt   := ""
	Private cChaveAnt   := ""
	Private nVlrPed     := 0
	Private nTQtde      := 0
	Private nTotComV    := 0
	Private nTotComS    := 0
	Private nResto      := 0
	Private nComVend    := 0
	Private nComSuper   := 0
	Private nOrdem      := 0

	Private _cUsuario   := RetCodUsr() 
	Private _cDeptoUsu  := ""
	Private _aUsuario   := {}

	PswOrder(1)
	If PswSeek(_cUsuario,.T.)                                                                  
		_aUsuario  := PswRet()
		_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
	EndIf

	Pergunte(cPerg,.F.)

	aOrd :={"Pais ou Região","Setor de Atividade","Equipamentos"}

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,aOrd,.F.,Tamanho)

	If nLastKey==27
		Set Filter to
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey==27
		Set Filter to
		Return
	Endif

	RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)

Return

/*/{Protheus.doc} ImpRel
//TODO Descrição auto-gerada.
@author Aparecida de F.Stevanato Data 
@version 1.0
/*/

Static Function ImpRel(lEnd,WnRel,cString)

	// Variaveis utilizadas para Impressao do Cabecalho e Rodape
	cbtxt   := SPACE(10)
	cbcont  := 0
	m_pag   := 1
	Li 	    := 80
	cExport := ""
	//If mv_par14 == 1   // Analitico
	nOrdem := aReturn[8]
	//EndIf

	If Alltrim(mv_par05) == "BR" .AND. Alltrim(mv_par06) == "BR"  // Venda Nacional
		cExport := "N"
	Else                                                          // Exportação
		cExport := "S"
	EndIf

	If MV_PAR14 == 1   // Analitico
		If cExport == "S"
			titulo := "Relacao de Pedidos - " + "Exportação"
			cabec1 := "CONFIRM. ENCOMENDA    CLIENTE          PAIS             VENDEDOR/SUPERVISOR             SETOR                   PRODUTO                               S  T  A  T  U  S     PEDIDO QTD EQUIPAMENTOS"
			cabec2  := " DATA      NUMERO                                                                                                                                   LIBERADO ENG.  PRAZO"
		ElseIf cExport == "N"
			titulo := "Relacao de Pedidos - " + "Nacional"
			cabec1 := "CONFIRM. ENCOMENDA    CLIENTE          REGIAO           VENDEDOR/SUPERVISOR             SETOR                   PRODUTO                               S  T  A  T  U  S     PEDIDO QTD EQUIPAMENTOS"
			cabec2  := " DATA      NUMERO                                                                                                                                   LIBERADO ENG.  PRAZO"
		EndIf
	ElseIf MV_PAR14 == 2  // Sintetico

		If cExport == "N"                                             // Venda Nacional
			Titulo := "Resumo de Pedidos - "+"Nacional"                
			If MV_PAR13 == 1  // Todos 
				Do Case
					Case nOrdem == 1
					Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE         VALOR VENDA       VALOR COMISSAO   VALOR MONTAGEM   VALOR EMBALAGEM"  
					Case  nOrdem == 2
					Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE         VALOR VENDA       VALOR COMISSAO   VALOR MONTAGEM   VALOR EMBALAGEM"  
					Case nOrdem == 3
					Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE         VALOR VENDA       VALOR COMISSAO   VALOR MONTAGEM   VALOR EMBALAGEM"  
				EndCase	
			ElseIf MV_PAR13 == 2 // Montagem
				Do Case
					Case nOrdem == 1
					Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE         VALOR MONTAGEM"  
					Case  nOrdem == 2
					Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE         VALOR MONTAGEM"  
					Case nOrdem == 3
					Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE         VALOR MONTAGEM"  
				EndCase
			ElseIf MV_PAR13 == 3 // Embalagem
				Do Case
					Case nOrdem == 1
					Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE         VALOR EMBALAGEM"  
					Case  nOrdem == 2
					Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE         VALOR EMBALAGEM"  
					Case nOrdem == 3
					Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE         VALOR EMBALAGEM"  
				EndCase
			EndIf
		ElseIf cExport == 'S'
			Titulo := "Resumo de Pedidos - "+"Exportação"     
			If MV_PAR13 == 1   // Todos
				Do Case
					Case nOrdem == 1
					Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE         VALOR VENDA       VALOR COMISSAO   VALOR MONTAGEM   VALOR EMBALAGEM"   
					Case nOrdem == 2
					Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE         VALOR VENDA       VALOR COMISSAO   VALOR MONTAGEM   VALOR EMBALAGEM"   
					Case nOrdem == 3
					Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE         VALOR VENDA       VALOR COMISSAO   VALOR MONTAGEM   VALOR EMBALAGEM"   
				EndCase
			ElseIf MV_PAR13 == 2  // Montagem
				Do Case
					Case nOrdem == 1
					Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE         VALOR MONTAGEM"   
					Case nOrdem == 2
					Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE         VALOR MONTAGEM"   
					Case nOrdem == 3
					Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE         VALOR MONTAGEM"   
				EndCase
			ElseIf MV_PAR13 == 3   // Embalagem
				Do Case
					Case nOrdem == 1
					Cabec1 := "REGIAO"   + Space(40) + "QUANTIDADE         VALOR EMBALAGEM"   
					Case nOrdem == 2
					Cabec1 := "SETOR"    + Space(42) + "QUANTIDADE         VALOR EMBALAGEM"   
					Case nOrdem == 3
					Cabec1 := "MAQUINAS" + Space(38) + "QUANTIDADE         VALOR EMBALAGEM"   
				EndCase
			EndIf
		EndIf
	EndIf			

	If MV_PAR14 == 1  //Analitico

		nVlrPed   := 0
		nVlrMont  := 0
		nVlrEmba  := 0 
		nTotQtde  := 0  
		nTotValor := 0

		Processa({|lEnd| GeraTrab(@lEnd,wnRel,"TRB")})   //Cria a tabela Trabalho 

		ImpParam()

		dbSelectArea("TRB")
		dbGoTop()
		SetRegua(RecCount())  // TOTAL DE ELEMENTOS DA REGUA 
	
	ElseIf MV_PAR14 == 2 // Sintetico

		nQtde     := 0
		nTotQtde  := 0  
		nValor    := 0
		nTotValor := 0
		nVlrMont  := 0
		nTVlrMont := 0
		nVlrEmba  := 0 
		nTVlrEmba := 0
		nVlrPed   := 0

		Processa({|lEnd| GeraTrab(@lEnd,wnRel,"TRB")})                //Cria a tabela Trabalho

		ImpParam()

		dbSelectArea("TRB")
		dbGoTop()
		SetRegua(RecCount())  // TOTAL DE ELEMENTOS DA REGUA 

	EndIf
	
	If MV_PAR14 == 1 // Analitico

		nVlrPed   := 0
		nVlrMont  := 0
		nQtde     := 0
		nTVlrMont := 0
	
		Do While TRB->(!Eof())
			If lEnd
				@ PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
				Exit                     
			Endif

			If Li > 62
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf 

			If TRB->NUMCE+NUM+CODCLI+LOJACLI <> cChaveAnt
				If cChaveAnt <> ""
					Li++
					If MV_PAR13 = 1  // Todos
						If nComVend > 0
							@ Li,000 Psay "Comissões =>  Vendedor/Representante: " 
							@ Li,039 Psay (nVlrPed * nComVend / 100) PICTURE "@E 999,999,999.99
							nTotComV += (nVlrPed * nComVend / 100) 
							If nComSuper > 0 
								@ Li,057 Psay "Supervisor: "
								@ Li,069 Psay (nVlrPed * nComSuper /100) PICTURE "@E 9,999,999.99
								nTotComS += (nVlrPed * nComSuper / 100)
							EndIf   
						EndIf
					EndIf
					If MV_PAR13 = 1 .OR.MV_PAR13 = 3  // Todos  // Embalagem
						If nVlrEmba > 0
							@ Li,080 PSAY "Embalagem: "
							@ Li,090 PSAY nVlrEmba       PICTURE "@E 9,999,999.99
						EndIf
					ElseIf MV_PAR13 = 1 .OR.MV_PAR13 = 2  // Todos  // Montagem
						If nVlrMont > 0
							@ Li,115 PSAY "Montagem: "
							@ Li,125 PSAY nVlrMont       PICTURE "@E 9,999,999.99
						EndIf
					EndIf

					If MV_PAR13 = 1  // Todos
						@ Li,140 Psay "Total da Encomenda =>" 
					EndIf

					If MV_PAR13 = 1  // Todos 

						If cExport == "S"
							@ Li,162 Psay (nVlrPed / nTaxa) PICTURE "@E 999,999,999.99"
							@ Li,177 Psay "(US$)  X"
							@ Li,185 Psay nTaxa  PICTURE "@E 999.9999" 
						EndIf                              

						@ Li,194 Psay nVlrPed    PICTURE "@E 999,999,999.99"
						@ Li,209 Psay "(R$)"
						@ Li,215 Psay nQtde PICTURE "@E 999"

					ElseIf MV_PAR13 = 2 // Montagem

						If cExport == "S"
							@ Li,162 Psay nVlrMont PICTURE "@E 999,999,999.99"
							@ Li,177 Psay "(US$)  X"
							@ Li,185 Psay nTaxa  PICTURE "@E 999.9999" 
						EndIf                 

						@ Li,194 Psay nVlrMont    PICTURE "@E 999,999,999.99"
						@ Li,209 Psay "(R$)"
						@ Li,215 Psay nQtde PICTURE "@E 999"

					ElseIf MV_PAR13 = 3 // Embalagem

						If cExport == "S"
							@ Li,162 Psay nVlrEmba PICTURE "@E 999,999,999.99"
							@ Li,177 Psay "(US$)  X"
							@ Li,185 Psay nTaxa  PICTURE "@E 999.9999" 
						EndIf            

						@ Li,194 Psay nVlrEmba    PICTURE "@E 999,999,999.99"
						@ Li,209 Psay "(R$)"
						@ Li,215 Psay nQtde PICTURE "@E 999"

					EndIf

					If MV_PAR13 = 2 .OR. MV_PAR13 = 3  // Montagem  // Embalagem
						nTotQtde += nQtde
					EndIf

					If MV_PAR13 = 3 // Embalagem
						nTVlrEmba := 0      
					ElseIf MV_PAR13 = 2 // Montagem   
						nTVlrMont := 0
					EndIf

					nVlrPed   := 0

					If MV_PAR13 = 1 .OR. MV_PAR13 = 2  // Todos  // Montagem
						nVlrMont  := 0
					ElseIf MV_PAR13 = 1 .OR. MV_PAR13 = 3  // Todos  // Embalagem
						nVlrEmba  := 0
					EndIf

					nQtde     := 0

					If MV_PAR13 = 1 // Todos
						nTotQtde  := 0 
					EndIf     

					Li++
					@ Li,000 Psay Replicate("-",220)
				EndIf
				Li++
				@ Li,000 Psay TRB->DATACE
				@ Li,010 Psay SubStr(TRB->NUMCE,1,10)
				@ Li,022 Psay SubStr(TRB->NOMECLI,1,15)
				@ Li,039 Psay SubStr(TRB->PAISREG,1,15)
				If Empty(TRB->NOMEVEN2) 
					@ Li,056 Psay TRB->NOMEVEN1
				Else
					@ Li,056 Psay Alltrim(TRB->NOMEVEN1) + "/" +  Alltrim(TRB->NOMEVEN2)
				EndIf     
				@ Li,088 Psay SubStr(TRB->SEGMENTO,1,23) 
				@ Li,112 Psay SubStr(TRB->PRODCLI,1,30)
				@ Li,150 Psay TRB->DTLIBERA
				@ Li,161 Psay TRB->PRAZO

				cChaveAnt := TRB->NUMCE + TRB->NUM + TRB->CODCLI+LOJACLI
				nComVend  := TRB->COMVEND
				nComSuper := TRB->COMSUPER

				ConverteMoeda() 

				nVlrPed  += nVlrReal
				nVlrMont += nVlrReaM
				nVlrEmba += nVlrReaE

				If MV_PAR13 = 3  // Embalagem 
					nTVlrEmba += nVlrEmba     
				ElseIf MV_PAR13 = 2  // Montagem 
					nTVlrMont += nVlrMont   
				EndIf 
			EndIf
			nQtde += TRB->QTDE

			If cPedAnt <> TRB->NUM
				@ Li,171 Psay TRB->NUM
				cPedAnt := TRB->NUM
			EndIf
			@ Li,178 Psay TRB->QTDE Picture "@E 999"      
			@ Li,182 Psay SubStr(TRB->DESCRICAO,1,35)

			nCont++
			Li++
			IncRegua()
			TRB->(dbSkip())	     
		End

		If MV_PAR13 = 2  // Montagem

			Li++
			If Li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf 

			@ Li,140 Psay "Total da Montagem =>"
			If cExport == "S"
				@ Li,162 Psay (nVlrMont / nTaxa)  PICTURE "@E 999,999,999.99"
				@ Li,177 Psay "(US$)  X"
				@ Li,185 Psay nTaxa  PICTURE "@E 999.9999"
			EndIf 

			@ Li,194 Psay nVlrMont  PICTURE "@E 999,999,999.99" 
			@ Li,209 Psay "(R$)" 
			@ Li,215 Psay nQtde Picture "@E 999"    
			Li++
			@ Li,000 Psay Replicate("-",220)

			Li++
			If Li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf 

			If cExport == "S"
				@ Li,140 Psay "Total Exportação => "
				@ Li,162 Psay nTotMoeda2 PICTURE "@E 999,999,999.99" 
				@ Li,177 Psay "(US$)" 
			Else
				@ Li,140 Psay "Total Nacional => "   
			EndIf

			nTotQtde += nQtde

			@ Li,194 Psay nTVlrMont  PICTURE "@E 999,999,999.99"
			@ Li,209 Psay "(R$)" 
			@ Li,215 Psay nTotQtde PICTURE "@E 999"    
		ElseIf MV_PAR13 = 1 	// Todos
			Li++
			If Li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf 

			nTotComS += (nVlrPed * nComSuper / 100)
			nTotComV += (nVlrPed * nComVend / 100)

			If nComVend > 0
				@ Li,000 Psay "Comissões =>  Vendedor/Representante: " 
				@ Li,039 Psay (nVlrPed * nComVend / 100) PICTURE "@E 999,999,999.99
				If nComSuper > 0 
					@ Li,057 Psay "Supervisor: "
					@ Li,069 Psay (nVlrPed * nComSuper /100) PICTURE "@E 9,999,999.99
				EndIf   
			EndIf

			If nVlrEmba > 0
				@ Li,080 PSAY "Embalagem: "
				@ Li,090 PSAY nVlrEmba   PICTURE "@E 999,999,999.99"
			EndIf

			If nVlrMont > 0
				@ Li,105 PSAY "Montagem: "
				@ Li,115 PSAY nVlrMont   PICTURE "@E 999,999,999.99"
			EndIf

			@ Li,140 Psay "Total da Encomenda =>"
			If cExport == "S"
				@ Li,162 Psay (nVlrPed / nTaxa)  PICTURE "@E 999,999,999.99"
				@ Li,177 Psay "(US$)  X"
				@ Li,185 Psay nTaxa  PICTURE "@E 999.9999"
			EndIf 
			@ Li,194 Psay nVlrPed  PICTURE "@E 999,999,999.99" 
			@ Li,209 Psay "(R$)" 
			@ Li,215 Psay nQtde Picture "@E 999"    
			Li++
			@ Li,000 Psay Replicate("-",220)

			Li++
			If Li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf 
			@ Li,000 Psay "Comissões =>  Vendedor/Representante: " 
			@ Li,039 Psay nTotComV PICTURE "@E 999,999,999.99
			@ Li,057 Psay "Supervisor: "
			@ Li,069 Psay nTotComS PICTURE "@E 9,999,999.99

			If cExport == "S"
				@ Li,140 Psay "Total Exportação => "
				@ Li,162 Psay nTotMoeda2 PICTURE "@E 999,999,999.99" 
				@ Li,177 Psay "(US$)" 
			Else
				@ Li,140 Psay "Total Nacional => "   
			EndIf

			@ Li,194 Psay nTotValor  PICTURE "@E 999,999,999.99"
			@ Li,209 Psay "(R$)" 
			@ Li,215 Psay nTotQtde PICTURE "@E 999"
		ElseIf MV_PAR13 = 3  // Embalagem

			Li++
			If Li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf 

			@ Li,140 Psay "Total da Embalagem =>"
			If cExport == "S"
				@ Li,162 Psay (nVlrEmba / nTaxa)  PICTURE "@E 999,999,999.99"
				@ Li,177 Psay "(US$)  X"
				@ Li,185 Psay nTaxa  PICTURE "@E 999.9999"
			EndIf 

			@ Li,194 Psay nVlrEmba  PICTURE "@E 999,999,999.99" 
			@ Li,209 Psay "(R$)" 
			@ Li,215 Psay nQtde Picture "@E 999"    
			Li++
			@ Li,000 Psay Replicate("-",220)

			Li++
			If Li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			EndIf 

			If cExport == "S"
				@ Li,140 Psay "Total Exportação => "
				@ Li,162 Psay nTotMoeda2 PICTURE "@E 999,999,999.99" 
				@ Li,177 Psay "(US$)" 
			Else
				@ Li,140 Psay "Total Nacional => "   
			EndIf

			nTotQtde += nQtde

			@ Li,194 Psay nTVlrEmba  PICTURE "@E 999,999,999.99"
			@ Li,209 Psay "(R$)" 
			@ Li,215 Psay nTotQtde PICTURE "@E 999"    

		EndIf
	ElseIf MV_PAR14 == 2  // Sintetico

		Do Case
			Case nOrdem == 1
			cQuebra := "Alltrim(TRB->CODPAIS)  == cPaisAnt"
			Case nOrdem == 2
			cQuebra := "Alltrim(TRB->CODSETOR) == cSetorAnt"
			Case nOrdem == 3
			cQuebra := "Alltrim(TRB->TPVENDA)  == cTpVenAnt"
		EndCase

		SetRegua(RecCount()) // TOTAL DE ELEMENTOS DA REGUA
		SA3->(dbSetOrder(1))

		Do While TRB->(!Eof())

			IF lEnd
				@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"        
				Exit
			Endif

			If Li > 62
				Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
				Li:= 8
				@li,000 Psay  "Periodo: "+ DTOC(mv_par01) + " a " + DTOC(mv_par02)      
				Li+=2
			EndIf

			If lPrim
				lPrim := .F.
				nTpVendedor  := TRB->TPVENDEDOR
				cVendAnt     := Alltrim(TRB->CODVEN)
				cSuperAnt    := Alltrim(TRB->CODSUPER)
				cPaisAnt     := Alltrim(TRB->CODPAIS)
				cPaisReg     := TRB->PAISREG
				cMunicipio	 := Alltrim(TRB->MUNICIPIO) 
				cTpVenAnt    := AllTrim(TRB->TPVENDA)
				cVenda       := Alltrim(TRB->VENDA)
				cSetorAnt    := Alltrim(TRB->CODSETOR)
				If SubStr(cSetorAnt,1,1) == "1"
					cSegmento := "Alimentício   " + " - " + Upper(TRB->SEGMENTO)  
				Else
					cSegmento := "Outros Setores" + " - " + Upper(TRB->SEGMENTO) 
				EndIf
				cVendedor := ""
				If SA3->(dbSeek(xFilial("SA3")+TRB->CODVEN))
					cVendedor := Alltrim(SA3->A3_NREDUZ)
				EndIf
				If !Empty(Alltrim(TRB->CODSUPER)) .And. TRB->CODVEN <> TRB->CODSUPER
					If SA3->(dbSeek(xFilial("SA3")+TRB->CODSUPER))
						cVendedor += " / " + Alltrim(SA3->A3_NREDUZ)
					EndIf
				EndIf
				If nTpVendedor == 1
					@li,005 Psay "Vendedor : "     + Alltrim(TRB->CODVEN) + "-" + cVendedor   
				Else
					@li,005 Psay "Representante : "+ Alltrim(TRB->CODVEN) + "-" + cVendedor   
				EndIf

				Li++
			EndIf

			If TRB->TPVENDEDOR == nTpVendedor .AND. Alltrim(TRB->CODVEN) == cVendAnt .AND. Alltrim(TRB->CODSUPER) == cSuperAnt .AND. &cQuebra
				nQtde   += TRB->QTDE
				ConverteMoeda()
				nValor  += nVlrReal
				nComis  += nVlrReal * TRB->COMIS / 100

				If nVlrReal > 0
					nVlrMont   += nVlrReaM
					nVlrEmba   += nVlrReaE
				Endif
				If nMValor <= nValor
					If TRB->TPVENDEDOR = 1 .OR. TRB->TPVENDEDOR = 2
						If	cMPais 	<>  cPaisReg		   
							nMTotMo2  := TRB->VALOR
							nMVlrMont := nVlrMont
							nMVlrEmba := nVlrEmba
							nMValor   := nValor
							nMQtde 	 := nQtde
							cMPais 	 := cPaisReg
							If nComis <> nMComis
								nMComis   := nComis
							EndIf 
						Else
							nMTotMo2  += TRB->VALOR
							nMVlrMont := nVlrMont
							nMVlrEmba := nVlrEmba
							nMValor   := nValor
							nMQtde 	 := nQtde
							cMPais 	 := cPaisReg
							If nComis <> nMComis
								nMComis   := nComis
							EndIf 
						EndIf
					EndIf	
				EndIf
			Else 
				Li++
				Do Case
					Case  nOrdem == 1
					@li,000 Psay cPaisReg
					cPaisAnt := Alltrim(TRB->CODPAIS)
					cPaisReg := TRB->PAISREG
					Case  nOrdem == 2
					@li,000 Psay cSegmento
					cSetorAnt := Alltrim(TRB->CODSETOR)
					If SubStr(cSetorAnt,1,1) == "1"
						cSegmento := "Alimentício   "+ " - " + Upper(TRB->SEGMENTO)   
					Else
						cSegmento := "Outros Setores"+ " - " + Upper(TRB->SEGMENTO)  
					EndIf
					Case  nOrdem == 3
					@li,000 Psay cVenda
					cTpVenAnt := Alltrim(TRB->TPVENDA)
					cVenda    := TRB->VENDA
				EndCase
				@ Li,045 Psay nQtde     PICTURE "@E 99,999.9999"

				If MV_PAR13 = 1  // Todos
					@ Li,063 Psay nValor    PICTURE "@E 999,999,999.99"
					@ Li,083 Psay nComis    PICTURE "@E 999,999,999.99"
				EndIF
				If MV_PAR13 = 1 .OR. MV_PAR13 = 2   // Todos // Montagem
					If nVlrMont > 0
						@ Li,100 Psay nVlrMont  PICTURE "@E 999,999,999.99"
					EndIf
				ElseIF MV_PAR13 = 1 .OR. MV_PAR13 = 3   // Todos // Embalagem	
					If nVlrEmba > 0
						@ Li,118 Psay nVlrEmba PICTURE "@E 999,999,999.99"
					EndIf
				EndIF 

				If cVendAnt <> Alltrim(TRB->CODVEN) .OR. cSuperAnt <> Alltrim(TRB->CODSUPER) .OR. TRB->TPVENDEDOR <> nTpVendedor
					Li++
					@ Li,005 Psay "SubTotal => "
					@ Li,045 Psay nSubQtde  PICTURE "@E 99,999.9999"

					If MV_PAR13 = 1  // TODOS
						@ Li,063 Psay nSubValor PICTURE "@E 999,999,999.99"
						@ Li,083 Psay nSubComis PICTURE "@E 999,999,999.99"
						If nSubVlrMo > 0
							@ Li,100 Psay nSubVlrMo PICTURE "@E 999,999,999.99"
						EndIf
						If nSubVlrEm > 0
							@ Li,118 Psay nSubVlrEm PICTURE "@E 999,999,999.99"
						EndIf
					EndIF

					If MV_PAR13 = 2  // Montagem
						If nSubVlrMo > 0
							@ Li,063 Psay nSubVlrMo PICTURE "@E 999,999,999.99"
						EndIf
					ElseIf MV_PAR13 = 3  // Embalagem
						If nSubVlrEm > 0
							@ Li,063 Psay nSubVlrEm PICTURE "@E 999,999,999.99"
						EndIf
					EndIf
					nSubQtde  := 0
					nSubValor := 0
					nSubComis := 0
					nSubVlrMo := 0
					nSubVlrEm := 0
					Li++
					@ Li,000 Psay Replicate("-",132)

					If TRB->TPVENDEDOR <> nTpVendedor

						If nTotValor > 0
							Li++
							@ Li,005 Psay "Total R$"
							@ Li,045 Psay nTotQtde 	PICTURE "@E 99,999.9999" 
							@ Li,063 Psay nTotValor PICTURE "@E 999,999,999.99"
							@ Li,083 Psay nTotComis PICTURE "@E 999,999,999.99"
							@ Li,100 Psay nTotVlrM PICTURE "@E 999,999,999.99"
							@ Li,118 Psay nTotVlrE PICTURE "@E 999,999,999.99"
							Li++
							@ Li,005 Psay "Total US$"
							@ Li,063 Psay nTotMoeda2 PICTURE "@E 999,999,999.99"
							nTotQtde   := 0
							nTotValor  := 0
							nTotMoeda2 := 0
							nTotComis  := 0
							nTotVlrM   := 0
							nTotVlrE   := 0
						EndIf
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
						Li:= 8
						@ Li,000 Psay  "Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)  
						nTpVendedor := TRB->TPVENDEDOR
					EndIf
					SA3->(dbSetOrder(1))
					SA3->(dbSeek(xFilial("SA3")+TRB->CODVEN))
					cVendedor := Alltrim(SA3->A3_NREDUZ)
					If !Empty(Alltrim(TRB->CODSUPER)) .And. TRB->CODVEN <> TRB->CODSUPER
						SA3->(dbSetOrder(1))
						If SA3->(dbSeek(xFilial("SA3")+TRB->CODSUPER))
							cVendedor += " / " + Alltrim(SA3->A3_NREDUZ)
						EndIf
					EndIf
					Li+=2
					Do Case
						Case TRB->TPVENDEDOR == 1
						@ Li,005 Psay "Representante : "+ Alltrim(TRB->CODVEN) + "-" + cVendedor    
						Case TRB->TPVENDEDOR == 2
						@ Li,005 Psay "Vendedor : "     + Alltrim(TRB->CODVEN) + "-" + cVendedor    
						Case TRB->TPVENDEDOR == 3
						@ Li,005 Psay "Gerente : "      + Alltrim(TRB->CODVEN) + "-" + cVendedor    
					EndCase
					Li++
					cVendAnt  := Alltrim(TRB->CODVEN)
					cSuperAnt := Alltrim(TRB->CODSUPER)
				EndIf

				nQtde    := TRB->QTDE
				ConverteMoeda()
				nValor   := nVlrReal
				nComis   := nVlrReal * TRB->COMIS / 100
				If TRB->VALOR > 0
					nVlrMont   := nVlrReaM
					nVlrEmba   := nVlrReaE
				Else
					nVlrMont   := 0
					nVlrEmba   := 0
				Endif
			EndIf
			nSubQtde   += TRB->QTDE
			nSubValor  += nVlrReal
			nSubComis  += nVlrReal * TRB->COMIS / 100
			nSubVlrMo  += nVlrReaM
			nSubVlrEm  += nVlrReaE
			nTotValor  += nVlrReal
			nTotComis  += nVlrReal * TRB->COMIS / 100
			If nSubValor > 0 
				nTotQtde   += TRB->QTDE
			EndIf
			nTotVlrM   += nVlrReaM
			nTotVlrE   += nVlrReaE
			//EndIF
			If TRB->MOEDA == 2 	
				nTotMoeda2 += TRB->VALOR
			EndIf

			If TRB->VALOR > 0 
				nTotMontM2 += TRB->VLRMONT
				nTotEmbaM2 += TRB->VLREMBA
			Else
				nTotMontM2 += 0
				nTotEmbaM2 += 0
			EndIf 	 	
			nCont++

			dbSelectArea("TRB")
			IncRegua()
			TRB->(dbSkip())
			Loop
		End

		Li++
		If Li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			Li:= 8
			@ Li,000 Psay  "Periodo: "+ DTOC(mv_par01) + " a " + DTOC(mv_par02) 
			Li+=2
		EndIf
		@ Li,045 Psay nQtde    PICTURE "@E 99,999.9999"
		If MV_PAR13 = 1  // Todos
			@ Li,063 Psay nValor   PICTURE "@E 999,999,999.99"
			@ Li,083 Psay nComis   PICTURE "@E 999,999,999.99"
		EndIF
		If MV_PAR13 = 1 .OR. MV_PAR13 = 2  // Todos  // Montagem
			If nVlrMont > 0
				@ Li,100 Psay nVlrMont  PICTURE "@E 999,999,999.99"
			EndIf
		ElseIf MV_PAR13 = 1 .OR. MV_PAR13 = 3  // Todos  // Embalagem
			If nVlrEmba > 0
				@ Li,118 Psay nVlrEmba PICTURE "@E 999,999,999.99"
			EndIf	
		EndIf
		Li++
		@ Li,005 Psay "SubTotal => "
		@ Li,045 Psay nSubQtde  PICTURE "@E 99,999.9999"
		If MV_PAR13 = 1  // Todos
			@ Li,063 Psay nSubValor PICTURE "@E 999,999,999.99"
			@ Li,083 Psay nSubComis PICTURE "@E 999,999,999.99"
		EndIF
		If MV_PAR13 = 1 .OR. MV_PAR13 = 2  // Todos  // Montagem
			If nSubVlrMo > 0 
				@ Li,100 Psay nSubVlrMo PICTURE "@E 999,999,999.99"
			EndIf
		ElseIf MV_PAR13 = 1 .OR. MV_PAR13 = 3  // Todos  // Embalagem
			If nSubVlrEm > 0 
				@ Li,118 Psay nSubVlrEm PICTURE "@E 999,999,999.99"
			EndIf
		EndIf
		Li++
		@ Li,000 Psay Replicate("-",132)
		Li++

		ImpTotal()

		Li := 99

		ImpResumo()

		Li := 80

		If li != 80
			Roda(cbcont,cbtxt)
		Endif

	EndIf

	dbSelectArea("TRB")
	dbCloseArea()

	QR1->(dbCloseArea())	

	// Deleta arquivos de trabalho.
	Ferase(cArqTrab+GetDBExtension())
	Ferase(cArqTrab+OrdBagExt())
	Ferase(cFilTrab+OrdBagExt())

	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*/{Protheus.doc} ImpResumo
//TODO Imprime o resumo apenas do relatório
@author Aparecida de F.Stevanato Data
@since ????????
@version 1.0
@type function
/*/

Static Function ImpResumo()

	lPrim      := .T.
	Li         := 99
	tamanho    := "G"
	limite     := 132

	nQtde      := 0
	nValor     := 0
	nTotQtde   := 0
	nTotValor  := 0
	nTotMoeda2 := 0
	nComisRep  := 0

	nVlrMont   := 0
	nTotVlrM   := 0
	nTotMontM2 := 0

	nVlrEmba   := 0
	nTotVlrE   := 0
	nTotEmbaM2 := 0

	dbSelectArea("TRB")
	dbGoTop()

	SetRegua(RecCount())        // TOTAL DE ELEMENTOS DA REGUA 

	Do While TRB->(!EOF())

		If lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"   
			Exit
		Endif 

		If TRB->TPVENDEDOR == 1 .AND. TRB->CODSUPER <> "000001"
			ConverteMoeda()
			nComisRep += nVlrReal * TRB->COMIS / 100
			TRB->(DbSkip())
			Loop
		Else
			If TRB->TPVENDEDOR <> 2 .AND. TRB->CODSUPER <> "000001"
				TRB->(DbSkip())
				Loop
			EndIf
		EndIf

		If Li > 62
			cabec1 := ""
			cabec2 := ""
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			Li:= 8
			@ Li,000 Psay "Periodo: "+ DTOC(mv_par01) + " a " + DTOC(mv_par02)   
			Li+=2
			@ Li,096 Psay "R  E  S  U  M  O"   
			Li++                              
			@ Li,000 PSAY __PrtFatLine()
		EndIf

		If lPrim
			lPrim := .F.
			cPaisAnt   := Alltrim(TRB->CODPAIS)
			cPaisReg   := TRB->PAISREG
			cMunicipio := AllTrim(TRB->MUNICIPIO)
			cTpVenAnt  := AllTrim(TRB->TPVENDA)
			cVenda     := Alltrim(TRB->VENDA)
			cSetorAnt  := Alltrim(TRB->CODSETOR)
			If SubStr(cSetorAnt,1,1) == "1"
				cSegmento := "Alimentício   "+ " - " + Upper(TRB->SEGMENTO)   
			Else
				cSegmento := "Outros Setores"+ " - " + Upper(TRB->SEGMENTO)  
			EndIf
		EndIf

		If &cQuebra
			nQtde      += TRB->QTDE
			ConverteMoeda()
			nValor     += nVlrReal
			nComis     += nVlrReal * TRB->COMIS / 100
			nVlrMont   += nVlrReaM
			nVlrEmba   += nVlrReaE
		Else
			Li++
			Do Case
				Case  nOrdem == 1  
				@ Li,000 Psay cPaisReg
				cPaisAnt := Alltrim(TRB->CODPAIS)
				cPaisReg := TRB->PAISREG
				Case  nOrdem == 2
				@ Li,000 Psay cSegmento
				cSetorAnt := Alltrim(TRB->CODSETOR)
				If SubStr(cSetorAnt,1,1) == "1"
					cSegmento := "Alimentício   "+ " - " + Upper(TRB->SEGMENTO)   
				Else
					cSegmento := "Outros Setores"+ " - " + Upper(TRB->SEGMENTO)   
				EndIf
				Case  nOrdem == 3
				@ Li,000 Psay cVenda
				cTpVenAnt := Alltrim(TRB->TPVENDA)
				cVenda    := TRB->VENDA
			EndCase

			@ Li,045 Psay nQtde    PICTURE "@E 99,999.9999"

			If MV_PAR13 = 1 // Todos
				@ Li,063 Psay nValor   PICTURE "@E 999,999,999.99"
				@ Li,083 Psay nComis   PICTURE "@E 999,999,999.99"
			EndIf

			If MV_PAR13 = 1 .OR. MV_PAR13 = 2  // Todos  // Montagem
				If nVlrMont > 0 			
					@ Li,100 Psay nVlrMont PICTURE "@E 999,999,999.99"
				EndIf
			ElseIf MV_PAR13 = 1 .OR. MV_PAR13 = 3  // Todos  // Embalagem	
				If nVlrEmba > 0 
					@ Li,118 Psay nVlrEmba PICTURE "@E 999,999,999.99"
				EndIf
			EndIF

			nQtde      := TRB->QTDE
			ConverteMoeda()
			nValor     := nVlrReal
			nComis     := nVlrReal * TRB->COMIS / 100
			nVlrMont   := nVlrReaM
			nVlrEmba   := nVlrReaE

		EndIf
		nTotQtde   += TRB->QTDE
		nTotValor  += nVlrReal
		nTotComis  += nVlrReal * TRB->COMIS / 100
		nTotMoeda2 += TRB->VALOR
		nTotVlrM   += nVlrReaM
		nTotVlrE   += nVlrReaE
		If TRB->VALOR > 0 
			nTotMontM2 += TRB->VLRMONT
			nTotEmbaM2 += TRB->VLREMBA
		Else
			nTotMontM2 += 0
			nTotEmbaM2 += 0
		EndIf

		nCont++
		dbSelectArea("TRB")
		IncRegua()
		TRB->(dbSkip())
		Loop
	End
	IF MV_PAR13 = 1  // Todos 
		If nOrdem == 1 .and. Alltrim(TRB->CODPAIS) == ""
			Li++
			@ Li,010 Psay    "PAIS COM MAIOR VALOR DE ITENS VENDIDOS : "
			@ Li,060 Psay cMPais
			Li+=2
			@ Li,010 Psay    "Quantidade         : "
			@ Li,035 Psay nMQtde    PICTURE "@E 999,999,999.99"
			@ Li,070 Psay    "Valor R$           : "
			@ Li,095 Psay nMValor   PICTURE "@E 999,999,999.99"
			Li++
			@ Li,010 Psay    "Comissão           : "
			@ Li,035 Psay nMComis   PICTURE "@E 999,999,999.99"
			@ Li,070 Psay    "Valor US$          : "
			@ Li,095 Psay nMTotMo2   PICTURE "@E 999,999,999.99"
			Li++
			If	nVlrMont > 0 
				@ Li,010 Psay "Valor montagem R$  : "		
				@ Li,35 Psay nMVlrMont PICTURE "@E 999,999,999.99"
			EndIf
			If nVlrEmba > 0
				@ Li,070 Psay "Valor embalagem R$ : " 
				@ Li,095 Psay nMVlrEmba PICTURE "@E 999,999,999.99"
				Li++
			EndIf
		EndIf
	EndIf
	Li++
	If Li > 62
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		Li:= 8
		@ Li,000 Psay  "Periodo: " + DTOC(mv_par01) + " a " + DTOC(mv_par02)  
		Li+=2
	EndIf
	nLin := 0
	If MV_PAR13 = 1  // Todos
		If cExport == "S"
			Li++										
			@ Li,000 PSAY __PrtFatLine()
			Li++                                
			@ Li,010 Psay   "|TOTAL  R$ =>                                     |         TOTAL US$ =>      "
			Li++
			@ Li,010 Psay   "|                                                 |"
			Li++
			@ Li,010 Psay   "|Total Quantidade   : "
			@ Li,035 Psay nTotQtde  PICTURE  "@E 999,999,999.99"
			@ Li,060 Psay   "|"
			@ Li,070 Psay 	  "Valor Total        : "
			@ Li,095 Psay nTotMoeda2 PICTURE "@E 999,999,999.99"
			Li++
			@ Li,010 Psay   "|Valor Total        : "
			@ Li,035 Psay nTotValor PICTURE "@E 999,999,999.99"
			@ Li,060 Psay   "|"
			@ Li,070 Psay    "Valor Total Mont.  : "
			@ Li,095 Psay nTotMontM2 PICTURE "@E 999,999,999.99"
			Li++
			@ Li,010 Psay   "|Comissão Total     : "
			@ Li,035 Psay nTotComis PICTURE "@E 999,999,999.99"
			@ Li,060 Psay   "|"
			@ Li,070 Psay    "Valor Total Emba.  : "
			@ Li,095 Psay nTotEmbaM2 PICTURE "@E 999,999,999.99"
			Li++
			@ Li,010 Psay   "|Valor Total Mont.  : "
			@ Li,035 Psay nTotVlrM  PICTURE "@E 999,999,999.99"
			@ Li,060 Psay   "|"
			Li++
			@ Li,010 Psay   "|Valor Total Emba.  : "
			@ Li,035 Psay nTotVlrE  PICTURE "@E 999,999,999.99"
			@ Li,060 Psay   "|"
			Li++
			@ Li,010 Psay   "|Comis. Resp.       : "
			@ Li,035 Psay nComisRep PICTURE "@E 999,999,999.99"
			@ Li,060 Psay   "|"
			Li++
			@ Li,010 Psay   "|Comis + Comis Resp.: "
			@ Li,035 Psay nTotComis + nComisRep PICTURE "@E 999,999,999.99"
			@ Li,060 Psay   "|"
			Li+=2
			@ Li,000 PSAY __PrtFatLine()
			Li++
		Else
			Li++
			@ Li,000 Psay Replicate("-",132)
			Li++
			@ Li,005 Psay "TOTAL ===>"
			@ Li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
			@ Li,063 Psay nTotValor PICTURE "@E 999,999,999.99"
			@ Li,083 Psay nTotComis PICTURE "@E 999,999,999.99"
			@ Li,103 Psay nTotVlrM  PICTURE "@E 999,999,999.99"
			@ Li,123 Psay nTotVlrE  PICTURE "@E 999,999,999.99"
			@ Li,133 Psay nComisRep PICTURE "@E 999,999,999.99"
			@ Li,148 Psay nTotComis + nComisRep PICTURE "@E 999,999,999.99"
		EndIf
	ElseIf MV_PAR13 = 2  // Montagem 
		If cExport == "S"
			Li++
			@ Li,005 Psay "TOTAL  R$ =>"
			@ Li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
			@ Li,063 Psay nTotVlrM  PICTURE "@E 999,999,999.99"
			Li++
			@ Li,005 Psay "TOTAL US$ =>"
			@ Li,063 Psay nTotMontM2 PICTURE "@E 999,999,999.99"
		Else
			Li++
			@ Li,000 Psay Replicate("-",132)
			Li++

			//Li++
			@ Li,005 Psay "TOTAL ===>"
			@ Li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
			@ Li,063 Psay nTotVlrM  PICTURE "@E 999,999,999.99"
		EndIf
	ElseIf MV_PAR13 = 3  // Embalagem
		If cExport == "S"
			Li++
			@ Li,005 Psay "TOTAL  R$ =>"
			@ Li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
			@ Li,063 Psay nTotVlrE  PICTURE "@E 999,999,999.99"
			Li++
			@ Li,005 Psay "TOTAL US$ =>"
			@ Li,063 Psay nTotEmbaM2 PICTURE "@E 999,999,999.99"
		Else
			Li++
			@ Li,000 Psay Replicate("-",132)
			Li++
			@ Li,005 Psay "TOTAL ===>"
			@ Li,045 Psay nTotQtde  PICTURE "@E 99,999.9999"
			@ Li,063 Psay nTotVlrE  PICTURE "@E 999,999,999.99"
		EndIf
	EndIf

Return


/*/{Protheus.doc} GeraTrab
//TODO Cria Arquivo de Trabalho
@author Aparecida
@since ???????
@version 1.0
@type function
/*/

Static Function GeraTrab()

// Define Variaveis
Local aSX5T3	:= {}
Local aCampos	:= {}
Local aTam		:= {}
Local _aValor	:= {}
Local nVlrPed	:= 0
Local _nValor	:= 0
Local I
Local oTable

	If MV_PAR14 == 1  // Analitico

		// Define array para arquivo de trabalho
		aTam:=TamSX3("C5_FILIAL")
		AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
		AADD(aCampos,{ "DATACE"    ,"D",8,0 } )
		AADD(aCampos,{ "NUM"       ,"C",6,0 } )
		AADD(aCampos,{ "NUMCE"     ,"C",15,0 } )
		AADD(aCampos,{ "CODCLI"    ,"C",6,0 } )
		AADD(aCampos,{ "LOJACLI"   ,"C",2,0 } )
		AADD(aCampos,{ "NOMECLI"   ,"C",20,0 } )
		AADD(aCampos,{ "PAISREG"   ,"C",20,0 } )
		AADD(aCampos,{ "MUNICIPIO" ,"C",40,0 } )
		AADD(aCampos,{ "PRODUTO"   ,"C",15,0 } )
		AADD(aCampos,{ "DESCRICAO" ,"C",35,0 } )
		AADD(aCampos,{ "PRODCLI"   ,"C",30,0 } )
		AADD(aCampos,{ "SEGMENTO"  ,"C",25,0 } )
		AADD(aCampos,{ "CODVEND1"  ,"C",3,0 } )
		AADD(aCampos,{ "CODVEND2"  ,"C",3,0 } )
		AADD(aCampos,{ "NOMEVEN1"  ,"C",15,0 } ) 
		AADD(aCampos,{ "NOMEVEN2"  ,"C",15,0 } ) 
		AADD(aCampos,{ "QTDE"      ,"N",10,0 } )
		AADD(aCampos,{ "VALOR"     ,"N",15,2 } )
		AADD(aCampos,{ "VLRMONT"   ,"N",15,2 } )
		AADD(aCampos,{ "VLREMBA"   ,"N",15,2 } )
		AADD(aCampos,{ "DTLIBERA"  ,"D",8,0 } )
		AADD(aCampos,{ "PRAZO"     ,"D",8,0 } )
		AADD(aCampos,{ "MOEDA"     ,"N",11,4 } ) 
		AADD(aCampos,{ "COMVEND"   ,"N",5,2 } )
		AADD(aCampos,{ "COMSUPER"  ,"N",5,2 } )

		// Cria arquivo de Trabalho
		If Select("TRB") > 0 
			DbSelectArea("TRB")
			DbCloseArea()
		EndIf                               

		oTable := FWTemporaryTable():New("TRB",aCampos)
		oTable:AddIndex( "IND1", {'FILIAL','DTLIBERA','NUMCE','NUM','CODCLI','LOJACLI'} )
		oTable:Create()

		If Select("QR1") > 0 
			DbSelectArea("QR1")
			DbCloseArea()
		EndIf

		cQuery := "SELECT SC6.C6_VALOR, SC5.C5_VEND1,   SC5.C5_VEND2,   SC5.C5_NUM,     SC5.C5_MSALIM,  SC5.C5_MSVLPED, SC5.C5_MSVLMON, SC5.C5_MSVLEMB, SC5.C5_MSDTCE, "
		cQuery += "       SC5.C5_ORCAM,   SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_MSDTENT, SC5.C5_MOEDA,   SC5.C5_COMIS1,  SC5.C5_COMIS2, "
		If Substr(cNumEmp,1,2) $ "01_10"
			cQuery += "       CASE WHEN SC5.C5_DTEFVEN <> SC5.C5_EMISSAO AND SC5.C5_DTEFVEN <> '' Then SC5.C5_DTEFVEN ELSE SC5.C5_EMISSAO END AS 'C5_EMISSAO', "
		Else
			cQuery += "       SC5.C5_EMISSAO, "
		Endif
		cQuery += "       SC5.C5_MSTPVEN, SA1.A1_PAIS,SA1.A1_MUN,    SA1.A1_EST,     SA1.A1_REGIAO,  SA1.A1_SATIV1,  SA1.A1_NREDUZ,  SC6.C6_FILIAL, SC6.C6_NUM,     "
		cQuery += "       SC6.C6_PRODUTO, SC6.C6_DESCRI,  SC6.C6_QTDVEN,  SA3.A3_NREDUZ,  SYA.YA_DESCR "
		cQuery += "FROM "+RetSqlName("SC5")+" SC5 "  
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = '' "
		cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' "
		cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = '' "
		cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = '' "
		cQuery += "INNER JOIN "+RetSqlName("SYA")+" SYA ON SYA.YA_FILIAL = '"+xFilial("SYA")+"' AND SYA.YA_CODGI = SA1.A1_PAIS AND SYA.D_E_L_E_T_ = '' "
		cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SC6.C6_TES AND SF4.D_E_L_E_T_ = '' "
		If Substr(cNumEmp,1,2) $ "01_10" 
			cQuery += "WHERE (SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
			cQuery += "       OR SC5.C5_DTEFVEN BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"') "
		Else
			cQuery += "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
		Endif
		cQuery += "  AND SC5.C5_VEND1   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQuery += "  AND SF4.F4_DUPLIC = 'S' "
		
		If Empty(MV_PAR05) .AND. MV_PAR06 = 'ZZZ'
			cQuery += "  AND SA1.A1_PAIS  <> 'BR' "
		Else
			cQuery += "  AND SA1.A1_PAIS BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		EndIf
		
		If !Empty(MV_PAR05) .AND. MV_PAR06 <> 'ZZZ'
			cQuery += "  AND SA1.A1_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
		Else
			cQuery += "  AND SA1.A1_EST = 'EX' "
		EndIf
		
		If Empty(MV_PAR09) .OR. MV_PAR09 = 'ZZZZZZ'
			cQuery += "  AND SC5.C5_CLIENTE BETWEEN '      ' AND 'ZZZZZZ' " 
		Else
			cQuery += "  AND SC5.C5_CLIENTE = '"+MV_PAR09+"' "
		EndIf
		
		If Empty(MV_PAR10) .OR. MV_PAR10 = 'ZZ'
			cQuery += "  AND SC5.C5_LOJACLI BETWEEN '  ' AND 'ZZ' " 
		Else
			cQuery += "  AND SC5.C5_LOJACLI = '"+MV_PAR10+"' "
		EndIf
		
		If MV_PAR12 = 'ZZZZZZ' .OR. Empty(MV_PAR12)
			cQuery += " AND SC5.C5_MSALIM BETWEEN '      ' AND 'ZZZZZZ' "
		Else
			cQuery += " AND SC5.C5_MSALIM = '"+MV_PAR12+"' " 
		EndIf
		
		If MV_PAR15 = 1 .AND. SubStr(cNumEmp,1,2) $ "01_10" 
			cQuery += "  AND SC5.C5_MSVLPED > 0 "
			cQuery += "  AND SC5.C5_MSCATEG = '1' " 
			cQuery += "  AND SC5.C5_MSTPVEN <> 'CP' "  
		ElseIf MV_PAR15 = 1 .AND. SubStr(cNumEmp,1,2) $ "15_40_45"	
			cQuery += "  AND SC5.C5_MSTPVEN <> 'CP' " 
		ElseIf MV_PAR15 = 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"	
			cQuery += "  AND SC5.C5_MSCATEG = '3' " 
			cQuery += "  AND SC5.C5_MSTPVEN = 'RE' "
			cQuery += "  AND SC5.C5_COMIS1 > 0 "
		ElseIf MV_PAR15 = 2 .AND. SubStr(cNumEmp,1,2) $ "15_40_45"	
			cQuery += "  AND SC5.C5_MSTPVEN <> 'RE' "
		EndIf 
		
		If Empty(MV_PAR16) .And. Empty(MV_PAR17) 
			cQuery += "  AND SA1.A1_MSAREA >= '"+AllTrim(MV_PAR16)+"'"
			cQuery += "  AND SA1.A1_MSAREA <= 'ZZZZZZZZZZ'"
		Else 
			cQuery += "  AND SA1.A1_MSAREA >= '"+AllTrim(MV_PAR16)+"'"
			cQuery += "  AND SA1.A1_MSAREA <= '"+AllTrim(MV_PAR17)+"'"		
		EndIF
		
		If Empty(MV_PAR18) .And. Empty(MV_PAR19) 
			cQuery += "  AND SA1.A1_COD_MUN >= '"+AllTrim(MV_PAR18)+"'"
			cQuery += "  AND SA1.A1_COD_MUN <= 'ZZZZZZZZZZ'"
		Else 
			cQuery += "  AND SA1.A1_COD_MUN >= '"+AllTrim(MV_PAR18)+"'"
			cQuery += "  AND SA1.A1_COD_MUN <= '"+AllTrim(MV_PAR19)+"'"		
		EndIF
		
		
		cQuery += "  AND SC6.C6_BLQ <> 'R' "
		cQuery += "  AND SC5.D_E_L_E_T_ = '' "
		cQuery += "ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM "

		//Executa QUERY
		cQuery := ChangeQuery(cQuery)

		DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery),"QR1",.T.,.T.)

		dbSelectArea("QR1")
		dbGoTop()
		nTReg := QR1->(RecCount())
		ProcRegua(nTReg)		

		If MV_PAR15 == 2
			_cNum := QR1->C6_NUM
			While !QR1->(EOF())
				If QR1->C6_NUM <> _cNum
					AADD(_aValor,{_cNum,_nValor})
					_cNum   := QR1->C6_NUM
					_nValor := 0
				EndIf

				_nValor += QR1->C6_VALOR

				QR1->(dbSkip())
			End

			AADD(_aValor,{_cNum,_nValor})

			dbSelectArea("QR1")
			dbGoTop()
			nTReg := QR1->(RecCount())
			ProcRegua(nTReg)
		EndIf


		Do While !QR1->(Eof())
			IF SUBSTR(cNumEmp,1,2) $ '01_10'                      
				IF !EMPTY(QR1->C5_EMISSAO) .AND. (STOD(QR1->C5_EMISSAO) < MV_PAR01 .OR. STOD(QR1->C5_EMISSAO) > MV_PAR02)
					QR1->(dbSkip())
					LOOP
				ENDIF	
			ENDIF

			cPaisReg := "Em Branco"
			If Alltrim(QR1->A1_PAIS) <> "BR"
				cPaisReg := QR1->YA_DESCR
			Else
				SX5->(DbSetOrder(1))
				SX5->(DbGotop())
				If Alltrim(QR1->A1_EST) == "SP"
					If SX5->(DbSeek(xFilial("SX5")+"R6"+QR1->A1_REGIAO))
						cPaisReg := X5DESCRI()
					Else
						cPaisReg := "SÃO PAULO"
					EndIf
				Else
					SX5->(DbSeek(xFilial("SX5")+"12"+QR1->A1_EST))
					cPaisReg := X5DESCRI()
				EndIf
			EndIf

			cNomeVend1 := "Em Branco"
			cNomeVend2 := ""
			nComSuper  := 0
			nComVend   := 0

			If SUBSTR(cNumEmp,1,2) $ "01_10"
				SA3->(dbSetOrder(1))
				SA3->(dbSeek(xFilial("SA3")+QR1->C5_VEND1))
				cNomeVend1  := SA3->A3_NREDUZ
				If !Empty(QR1->C5_VEND2)
					If SA3->(dbSeek(xFilial("SA3")+QR1->C5_VEND2))
						cNomeVend2  := SA3->A3_NREDUZ
					EndIf
				EndIf
			EndIf

			cProdCli := "Sem produto"
			SZ4->(DbSetOrder(1))
			If SZ4->(DbSeek(xFilial("SZ4")+QR1->C5_NUM))
				cProdCli := SZ4->Z4_PRODUTO
			EndIf

			cSegmento := "Sem segmento"
			SX5->(DbSetOrder(1))
			SX5->(DbGotop())

			If !Empty(QR1->C5_MSALIM)
				SX5->(DbSeek(xFilial("SX5")+"T3"+QR1->C5_MSALIM))
				cSegmento := X5DESCRI()
			Else
				If !Empty(QR1->A1_SATIV1)
					SX5->(DbSeek(xFilial("SX5")+"T3"+QR1->A1_SATIV1))
					cSegmento := X5DESCRI()
				EndIf
			EndIf

			If MV_PAR15 <> 2
				nVlrPed  := QR1->C5_MSVLPED
			Else
				If aScan(_aValor,{|x|x[1] == QR1->C6_NUM}) > 0
					nVlrPed := _aValor[aScan(_aValor,{|x|x[1] == QR1->C6_NUM})][2]
				Else
					nVlrPed := 0
				EndIf
			EndIf

			nVlrMont := QR1->C5_MSVLMON
			nVlrEmba := QR1->C5_MSVLEMB

			nItem := 0
			If SUBSTR(cNumEmp,1,2) $ "01_10"
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->FILIAL   := QR1->C6_FILIAL
				TRB->NUM      := QR1->C6_NUM
				TRB->DATACE   := STOD(QR1->C5_MSDTCE)
				TRB->NUMCE    := QR1->C5_ORCAM
				TRB->CODCLI   := QR1->C5_CLIENTE
				TRB->LOJACLI  := QR1->C5_LOJACLI
				TRB->NOMECLI  := QR1->A1_NREDUZ
				TRB->PAISREG  := cPaisReg
				TRB->MUNICIPIO:= cMunicipio
				TRB->PRODUTO  := QR1->C6_PRODUTO
				TRB->DESCRICAO:= QR1->C6_DESCRI
				TRB->PRODCLI  := cProdCli
				TRB->SEGMENTO := cSegmento
				TRB->CODVEND1 := QR1->C5_VEND1
				TRB->CODVEND2 := QR1->C5_VEND2
				TRB->NOMEVEN1 := cNomeVend1
				TRB->NOMEVEN2 := cNomeVend2
				TRB->QTDE     := QR1->C6_QTDVEN
				TRB->VALOR    := nVlrPed
				TRB->VLRMONT  := nVlrMont
				TRB->VLREMBA  := nVlrEmba
				TRB->DTLIBERA := stod(QR1->C5_EMISSAO)
				TRB->PRAZO    := stod(QR1->C5_MSDTENT)
				TRB->MOEDA    := QR1->C5_MOEDA
				TRB->COMVEND  := QR1->C5_COMIS1
				TRB->COMSUPER := QR1->C5_COMIS2
				MsUnLock()

			EndIf	
			If !Empty(QR1->C5_MSTPVEN) .AND. QR1->C5_MSTPVEN $ "RE" .AND. nItem == 0
			EndIf
			IncProc()
			QR1->(dbSkip())
		End
	ElseIf MV_PAR14 == 2  // Sintetico

		// Define array para arquivo de trabalho
		AADD(aCampos,{ "FILIAL"    ,"C",2,0})
		AADD(aCampos,{ "TPVENDEDOR","N",1,0 } )
		AADD(aCampos,{ "CODVEN"    ,"C",6,0 } )
		AADD(aCampos,{ "CODSUPER"  ,"C",6,0 } )
		AADD(aCampos,{ "CODPAIS"   ,"C",3,0 } )
		AADD(aCampos,{ "PAISREG"   ,"C",25,0 } )
		AADD(aCampos,{ "MUNICIPIO" ,"C",40,0 } )
		AADD(aCampos,{ "CODSETOR"  ,"C",10,0 } )
		AADD(aCampos,{ "SEGMENTO"  ,"C",25,0 } )
		AADD(aCampos,{ "TPVENDA"   ,"C",2,0 } )
		AADD(aCampos,{ "VENDA"     ,"C",25,0 } )
		AADD(aCampos,{ "QTDE"      ,"N",10,3 } )
		AADD(aCampos,{ "VALOR"     ,"N",15,2 } )
		AADD(aCampos,{ "VLRMONT"   ,"N",15,2 } )
		AADD(aCampos,{ "VLREMBA"   ,"N",15,2 } )
		AADD(aCampos,{ "DTEMI"     ,"D",8,0 } )
		AADD(aCampos,{ "MOEDA"     ,"N",11,4 } )
		AADD(aCampos,{ "COMIS"     ,"N",5,2 } )

		// Cria arquivo de Trabalho
		If Select("TRB") > 0 
			DbSelectArea("TRB")
			TRB->(DbCloseArea())
		EndIf

		oTable := FWTemporaryTable():New("TRB",aCampos)

		nOrdem  := aReturn[8]

		Do Case
			Case nOrdem == 1
				oTable:AddIndex( "01", {'FILIAL','TPVENDEDOR','CODVEN','CODSUPER','CODPAIS'} )
				oTable:AddIndex( "02", {'FILIAL','CODPAIS'} )
			Case nOrdem == 2
				oTable:AddIndex( "01", {'FILIAL','TPVENDEDOR','CODVEN','CODSUPER','CODSETOR'} )
				oTable:AddIndex( "02", {'FILIAL','CODSETOR'} )
			Case nOrdem == 3
				oTable:AddIndex( "01", {'FILIAL','TPVENDEDOR','CODVEN','CODSUPER','TPVENDA'} )
				oTable:AddIndex( "02", {'FILIAL','TPVENDA'} )
		EndCase

		oTable:Create()

		dbSelectArea("TRB")
		TRB->(dbGoTop())

		If Select("QR1") > 0 
			DbSelectArea("QR1")
			DbCloseArea()
		EndIf

		cQuery := "SELECT SC5.C5_VEND1,   SC5.C5_VEND2,   SC5.C5_NUM,     SC5.C5_MSALIM,  SC5.C5_MSVLPED, SC5.C5_MSVLMON, SC5.C5_MSVLEMB, SC5.C5_MSDTCE, "
		cQuery += "       SC5.C5_ORCAM,   SC5.C5_CLIENTE, SC5.C5_LOJACLI,  SC5.C5_MSDTENT, SC5.C5_MOEDA,   SC5.C5_COMIS1,  SC5.C5_COMIS2, "
		If Substr(cNumEmp,1,2) $ "01_10"
			cQuery += "       CASE WHEN SC5.C5_DTEFVEN <> SC5.C5_EMISSAO AND SC5.C5_DTEFVEN <> '' Then SC5.C5_DTEFVEN ELSE SC5.C5_EMISSAO END AS 'C5_EMISSAO', "
		Else
			cQuery += "       SC5.C5_EMISSAO, "
		Endif
		cQuery += "       SC5.C5_MSTPVEN,SA1.A1_MUN, SA1.A1_PAIS,    SA1.A1_EST,     SA1.A1_REGIAO,  SA1.A1_SATIV1,  SYA.YA_DESCR,    " 
		cQuery += "       SC6.C6_PRODUTO, SC6.C6_DESCRI,  SC6.C6_QTDVEN,  SC6.C6_FILIAL,  SC6.C6_BLQ      "
		cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = '' "
		cQuery += "INNER JOIN "+RetSqlName("SYA")+" SYA ON SYA.YA_FILIAL = '"+xFilial("SYA")+"' AND SYA.YA_CODGI = SA1.A1_PAIS AND SYA.D_E_L_E_T_ = '' "
		cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' "
		If Substr(cNumEmp,1,2) $ "01_10" 
			cQuery += "WHERE (SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
			cQuery += "       OR SC5.C5_DTEFVEN BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"') "
		Else
			cQuery += "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
		Endif

		cQuery += "  AND SC5.C5_VEND1   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "

		If MV_PAR09 = '     ' .OR. MV_PAR09 = 'ZZZZZZ'
			cQuery += "  AND SC5.C5_CLIENTE BETWEEN '      ' AND 'ZZZZZZ' " 
		Else
			cQuery += "  AND SC5.C5_CLIENTE = '"+MV_PAR09+"' "
		EndIf
		If MV_PAR10 = '  ' .OR. MV_PAR10 = 'ZZ'
			cQuery += "  AND SC5.C5_LOJACLI BETWEEN '  ' AND 'ZZ' " 
		Else
			cQuery += "  AND SC5.C5_LOJACLI = '"+MV_PAR10+"' "
		EndIf

		If MV_PAR12 = 'ZZZZZZ' .OR. MV_PAR12 = '      '
			cQuery += " AND SC5.C5_MSALIM BETWEEN '      ' AND 'ZZZZZZ' "
		Else
			cQuery += " AND SC5.C5_MSALIM = '"+MV_PAR12+"' " 
		EndIf
		cQuery += "  AND SA1.A1_PAIS    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		If MV_PAR05 <> '   ' .AND. MV_PAR06 <> 'ZZZ'
			cQuery += "  AND SA1.A1_EST     BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
		Else
			cQuery += "  AND SA1.A1_EST = 'EX' "
		EndIf
		If MV_PAR15 = 1 .AND. SubStr(cNumEmp,1,2) $ "01_10"  

			cQuery += "  AND SC5.C5_MSCATEG = '1' " 
			cQuery += "  AND SC5.C5_MSTPVEN <> 'CP' "             

		ElseIf MV_PAR15 = 1 .AND. SubStr(cNumEmp,1,2) $ "15_40_45" 

			cQuery += "  AND SC5.C5_MSTPVEN <> 'CP' " 

		ElseIf MV_PAR15 = 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"	

			cQuery += "  AND SC5.C5_MSCATEG = '3' " 
			cQuery += "  AND SC5.C5_MSTPVEN <> 'RE' "   
		ElseIf MV_PAR15 = 2 .AND. SubStr(cNumEmp,1,2) $ "15_40_45"	

			cQuery += "  AND SC5.C5_MSTPVEN <> 'RE' " 	
		EndIf
		cQuery += "  AND SC5.C5_MSVLPED > 0 "
		cQuery += "  AND SC5.D_E_L_E_T_ = '' "
		cQuery += "  AND SC6.C6_BLQ <> 'R' "
		cQuery += "ORDER BY SC5.C5_VEND1 "

		//Executa QUERY
		cQuery := ChangeQuery(cQuery)

		DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery),"QR1",.T.,.T.)

		TcSetField("QR1","C5_EMISSAO" ,"D",08,00)

		ProcRegua(RecCount())                          // Total de Elementos da Regua

		Do While QR1->(!Eof()) 
			cPaisReg := "Sem Pais"
			If Alltrim(QR1->A1_PAIS) <> "BR"
				cPaisReg := QR1->YA_DESCR
			Else
				SX5->(DbSetOrder(1))
				SX5->(DbGotop())
				If Alltrim(QR1->A1_EST) == "SP"
					If SX5->(DbSeek(xFilial("SX5")+"R6"+QR1->A1_REGIAO))
						cPaisReg := X5DESCRI()
					Else
						cPaisReg := "SÃO PAULO"
					EndIf
				Else
					SX5->(DbSeek(xFilial("SX5")+"12"+QR1->A1_EST))
					cPaisReg := X5DESCRI()
				EndIf
			EndIf

			aVendedor := {}
			If SUBSTR(cNumEmp,1,2) $ "01_10"
				SA3->(dbSeek(xFilial("SA3")+QR1->C5_VEND1))
				If SA3->A3_TIPVEND == "2"               // O Vendedor e funcionario, se diferente e representante
					AADD(aVendedor,{"",0.00})
					AADD(aVendedor,{Alltrim(QR1->C5_VEND1),QR1->C5_COMIS1})
					If !Empty(QR1->C5_VEND2)
						AADD(aVendedor,{Alltrim(QR1->C5_VEND2),QR1->C5_COMIS2})
					Else
						If Empty(Alltrim(SA3->A3_GEREN))
							AADD(aVendedor,{Alltrim(QR1->C5_VEND1),0.00})
						Else
							AADD(aVendedor,{Alltrim(SA3->A3_GEREN),0.00})
						EndIf
					EndIf
				Else
					AADD(aVendedor,{Alltrim(QR1->C5_VEND1),QR1->C5_COMIS1})
					If !Empty(QR1->C5_VEND2)
						AADD(aVendedor,{Alltrim(QR1->C5_VEND2),QR1->C5_COMIS2})
					Else
						If Empty(Alltrim(SA3->A3_SUPER))
							AADD(aVendedor,{Alltrim(SA3->A3_GEREN),QR1->C5_COMIS2})
						Else
							AADD(aVendedor,{Alltrim(SA3->A3_SUPER),QR1->C5_COMIS2})
						EndIf
					EndIf
					AADD(aVendedor,{Alltrim(SA3->A3_GEREN),0.00})
				EndIf
			EndIf

			cSegmento := "Sem Segmento"
			SX5->(DbSetOrder(1))
			SX5->(DbGotop())

			cCodSetor := "2"
/*			If !Empty(QR1->C5_MSALIM)
				SX5->(DbSeek(xFilial("SX5")+"T3"+QR1->C5_MSALIM))
				cCodSetor := "1" + SX5->X5_CHAVE
				cSegmento := X5DESCRI()
			Else
				If !Empty(SA1->A1_SATIV1)
					SX5->(DbSeek(xFilial("SX5")+"T3"+QR1->A1_SATIV1))
					cSegmento := X5DESCRI()
					If Alltrim(SX5->X5_CHAVE) == "9" .OR. Alltrim(SX5->X5_CHAVE) == "10" .OR. Alltrim(SX5->X5_CHAVE) == "11" .OR. Alltrim(SX5->X5_CHAVE) == "12"
						cCodSetor := "1" + SX5->X5_CHAVE
					Else
						cCodSetor := "2" + SX5->X5_CHAVE
					EndIf
				EndIf
			EndIf
*/
			If !Empty(QR1->C5_MSALIM)
				aSX5T3 := FwGetSX5('T3',QR1->C5_MSALIM)
				cCodSetor := "1" + aSX5T3[1,3] 
				cSegmento := aSX5T3[1,4]
			
			ElseIf !Empty(QR1->A1_SATIV1)
				aSX5T3 := FwGetSX5('T3',QR1->A1_SATIV1)
				cSegmento := aSX5T3[1,4]
				If aSX5T3[1,3] $ '9|10|11|12'
					cCodSetor := "1" + aSX5T3[1,3]
				Else
					cCodSetor := "2" + aSX5T3[1,3]
				Endif
			Endif

			cVenda := "Sem Tipo de Venda"
			If !Empty(QR1->C5_MSTPVEN)
				SX5->(DbSeek(xFilial("SX5")+"Z8"+QR1->C5_MSTPVEN))
				cVenda := X5DESCRI()
			EndIf

			nVlrPed  := QR1->C5_MSVLPED
			nVlrMont := QR1->C5_MSVLMON
			nVlrEmba := QR1->C5_MSVLEMB

			cNum := QR1->C5_NUM

			Do While cNum == QR1->C5_NUM
				dbSelectArea("TRB")
				For I = 1 to 3
					If !Empty(aVendedor[I][1]) 

						RecLock("TRB",.T.)
						TRB->FILIAL     := QR1->C6_FILIAL
						TRB->TPVENDEDOR := I
						TRB->CODVEN     := aVendedor[I][1]
						If SA1->A1_PAIS <> "BR"
							TRB->CODPAIS := QR1->A1_PAIS
						Else
							TRB->CODPAIS := QR1->A1_EST
						EndIf
						TRB->PAISREG    := cPaisReg
						TRB->MUNICIPIO  := AllTrim(cMunicipio)
						TRB->CODSETOR   := cCodSetor
						TRB->SEGMENTO   := cSegmento
						TRB->TPVENDA    := QR1->C5_MSTPVEN
						TRB->VENDA      := cVenda
						TRB->QTDE       := QR1->C6_QTDVEN
						TRB->VALOR      := nVlrPed
						TRB->VLRMONT    := nVlrMont
						TRB->VLREMBA    := nVlrEmba
						TRB->DTEMI      := QR1->C5_EMISSAO
						TRB->MOEDA      := QR1->C5_MOEDA
						TRB->COMIS      := aVendedor[I][2]
						If I < 3
							If !Empty(QR1->C5_VEND2)
								TRB->CODSUPER := QR1->C5_VEND2     // usado para exibir o nome do supervisor na venda
							Else
								TRB->CODSUPER := QR1->C5_VEND1
							EndIf
						EndIf
						MsUnLock()
					EndIf
				Next I
				nVlrPed := 0
				QR1->(dbSkip())
			End
			IncProc()
			Loop
		End
	EndIf	

Return


/*/{Protheus.doc} ImpTotal
//TODO Impressão do Total
@author ??????
@since ??????
@version 1.0
@type function
/*/

Static Function ImpTotal()

	If MV_PAR13 = 1  // Todos
		If cExport == "S"
			Li++
			@ Li,005 Psay "TOTAL  R$ =>"
			@ Li,045 Psay nTotQtde     Picture "@E 99,999.9999"
			@ Li,063 Psay nTotValor    Picture "@E 999,999,999.99"
			@ Li,083 Psay nTotComis    Picture "@E 999,999,999.99"
			@ Li,100 Psay nTotVlrM     Picture "@E 999,999,999.99"
			@ Li,118 Psay nTotVlrE     Picture "@E 999,999,999.99"
			Li++
			@ Li,005 Psay "TOTAL US$ =>"
			@ Li,063 Psay nTotMoeda2 Picture "@E 999,999,999.99"
			//@ Li,100 Psay nTotMontM2 Picture "@E 999,999,999.99"
			//@ Li,118 Psay nTotEmbaM2 Picture "@E 999,999,999.99"
		Else

			Li++
			@ Li,000 Psay Replicate("-",132)
			Li++
			@ Li,005 Psay "TOTAL ===>"
			@ Li,045 Psay nTotQtde    Picture "@E 99,999.9999"
			@ Li,063 Psay nTotValor   Picture "@E 999,999,999.99"
			@ Li,083 Psay nTotComis   Picture "@E 999,999,999.99"
			@ Li,100 Psay nTotVlrM    Picture "@E 999,999,999.99"          
			@ Li,118 Psay nTotVlrE    Picture "@E 999,999,999.99"
		EndIf
	ElseIf MV_PAR13 = 2  // Montagem
		If cExport == "S"
			Li++
			@ Li,005 Psay "TOTAL  R$ =>"
			@ Li,045 Psay nTotQtde     Picture "@E 99,999.9999"
			@ Li,063 Psay nTotVlrM     Picture "@E 999,999,999.99"
			Li++
			@ Li,005 Psay "TOTAL US$ =>"
			@ Li,063 Psay nTotMontM2 Picture "@E 999,999,999.99"
		Else
			Li++
			@ Li,000 Psay Replicate("-",132)
			Li++
			@ Li,005 Psay "TOTAL ===>"
			@ Li,045 Psay nTotQtde    Picture "@E 99,999.9999"
			@ Li,063 Psay nTotVlrM    Picture "@E 999,999,999.99"
		EndIf
	ElseIf MV_PAR13 = 3  // Embalagem
		If cExport == "S"
			Li++
			@ Li,005 Psay "TOTAL  R$ =>"
			@ Li,045 Psay nTotQtde     Picture "@E 99,999.9999"
			@ Li,063 Psay nTotVlrE     Picture "@E 999,999,999.99"
			Li++
			@ Li,005 Psay "TOTAL US$ =>"
			@ Li,063 Psay nTotEmbaM2 Picture "@E 999,999,999.99"
		Else
			Li++
			@ Li,000 Psay Replicate("-",132)
			Li++
			@ Li,005 Psay "TOTAL ===>"
			@ Li,045 Psay nTotQtde    Picture "@E 99,999.9999"
			@ Li,063 Psay nTotVlrE    Picture "@E 999,999,999.99"
		EndIf
	EndIf

	nTotQtde  := 0
	nTotValor := 0
	nTotComis := 0
	nTotVlrM  := 0		
	nTotVlrE  := 0

	//QR1->(dbCloseArea())	

Return

/*/{Protheus.doc} ConverteMoeda
//TODO Converte moeda
@author ??????????
@since ??????????
@version 1.0
@type function
/*/

Static Function ConverteMoeda()


	If MV_PAR14 == 1  //Analitico

		nVlrReal := TRB->VALOR
		nVlrReaM := TRB->VLRMONT
		nVlrReaE := TRB->VLREMBA

		nTaxa    := 1
		If TRB->MOEDA > 1
			nDia := 31
			If Month(TRB->DTLIBERA) == 2
				nResto := Year(TRB->DTLIBERA) / 4
				If nResto > 0
					nDia := 28
				Else
					nDia := 29
				EndIf
			Else
				If Month(TRB->DTLIBERA) == 4 .OR. Month(TRB->DTLIBERA) == 6 .OR. Month(TRB->DTLIBERA) == 9 .OR. Month(TRB->DTLIBERA) == 11
					nDia := 30
				EndIf
			EndIf
			DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTLIBERA),5,2) + "/" + SubStr(Dtos(TRB->DTLIBERA),1,4))
			If DtAux  > Date()
				DtAux := Date()
			End
			If DOW(DtAux) == 1
				nDia-=2
				DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTLIBERA),5,2) + "/" + SubStr(Dtos(TRB->DTLIBERA),1,4))
			ElseIf DOW(DtAux) == 7
				nDia--
				DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTLIBERA),5,2) + "/" + SubStr(Dtos(TRB->DTLIBERA),1,4))
			EndIf
			cCampo := "SM2->M2_MOEDA"+Alltrim(STR(TRB->MOEDA))
			SM2->(DBSetOrder(1))
			IF SM2->(DBSeek(DtAux))
				nTaxa := &cCampo
			EndIf
			nVlrReal := TRB->VALOR * nTaxa
			nVlrReaM := TRB->VLRMONT * nTaxa
			nVlrReaE := TRB->VLREMBA * nTaxa
		EndIf

		nTotMoeda2 += TRB->VALOR
		nTotValor  += nVlrReal

		nTMontM2  += TRB->VLRMONT
		nTVlrMont += nVlrReaM

		nTEmbaM2  += TRB->VLREMBA
		nTVlrEmba += nVlrReaE

	ElseIf MV_PAR14 == 2  // Sintetico

		nVlrReal := TRB->VALOR
		If TRB->VALOR > 0
			nVlrReaM := TRB->VLRMONT
			nVlrReaE := TRB->VLREMBA
		Else
			nVlrReaM := 0
			nVlrReaE := 0
		EndIf	

		nTaxa    := 1
		If TRB->MOEDA > 1
			nDia := 31
			If Month(TRB->DTEMI) == 2
				nResto := Year(TRB->DTEMI) / 4
				If nResto > 0
					nDia := 28
				Else
					nDia := 29
				EndIf
			Else
				If Month(TRB->DTEMI) == 4 .OR. Month(TRB->DTEMI) == 6 .OR. Month(TRB->DTEMI) == 9 .OR. Month(TRB->DTEMI) == 11
					nDia := 30
				EndIf
			EndIf
			DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTEMI),5,2) + "/" + SubStr(Dtos(TRB->DTEMI),1,4))
			If DtAux  > Date()
				DtAux := Date()
			End
			If DOW(DtAux) == 1
				nDia-=2
				DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTEMI),5,2) + "/" + SubStr(Dtos(TRB->DTEMI),1,4))
			ElseIf DOW(DtAux) == 7
				nDia--
				DtAux := CTOD(Str(nDia) + "/" + SubStr(Dtos(TRB->DTEMI),5,2) + "/" + SubStr(Dtos(TRB->DTEMI),1,4))
			EndIf
			cCampo := "SM2->M2_MOEDA"+Alltrim(STR(TRB->MOEDA))
			SM2->(DBSetOrder(1))
			IF SM2->(DBSeek(DtAux))
				nTaxa := &cCampo
			EndIf
			nVlrReal := TRB->VALOR   * nTaxa

			If TRB->VALOR > 0
				nVlrReaM := TRB->VLRMONT * nTaxa
				nVlrReaE := TRB->VLREMBA * nTaxa
			Else
				nVlrReaM := 0
				nVlrReaE := 0
			EndIf	
		EndIf
	EndIf

Return   

Static Function ImpParam()

	//******************************************************************
	//  Variaveis utilizadas para parametros		    			 ***
	//  mv_par01			// Da data (emissão) 	    		     ***
	//  mv_par02			// Ate a data (emissão) 			     ***
	//  mv_par03			// Do vendedor                  		 ***
	//  mv_par04			// Ate o vendedor                        ***                                   
	//  mv_par05			// Do Pais                    	  	     ***
	//  mv_par06			// Ate Pais                    		     ***
	//  mv_par07			// Da UF                     	  	     ***
	//  mv_par08			// Ate UF                    		     ***
	//  mv_par09			// Cliente                               ***
	//  mv_par10			// Loja                      	  	     ***
	//  mv_par11			// Situacao                    		     ***                    		     
	//  mv_par12			// Segmento - Branco p /todos  		     ***
	//  mv_par13			// Filtro (Todos/Montagem/Embalagem)     ***
	//  mv_par14			// Analitico / Sintetico    		     ***
	//  mv_par15			// Categoria			    		     ***
	//  mv_par16			// Região de?						     ***
	//  mv_par17			// Região até			    		     ***
	//  mv_par18			// Cod. Mun	de?			    		     ***
	//  mv_par19			// Cod. Mun até?		    		     ***
	//******************************************************************  

	If MV_PAR14 == 1  // Analitico
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		Li:= 10
		@ Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"
		Li+=3
		@ Li,000 Psay "Data Liberação de.: " + DTOC(mv_par01)
		@li,037 Psay  "ate: " + DTOC(mv_par02)
		Li++
		@ Li,000 Psay "Vendedor de.......: " + mv_par03
		@ Li,037 Psay "ate: " + mv_par04
		Li++
		@ Li,000 Psay "Pais de...........: " + mv_par05
		@ Li,037 Psay "ate: " + mv_par06
		Li++
		@ Li,000 Psay "UF de.............: " + mv_par07
		@ Li,037 Psay "ate: " + mv_par08
		Li++
		If SubStr(mv_par09,1,3) = "ZZZ".Or. Alltrim(mv_par09) = ""
			@ Li,000 Psay "Cliente...........: Todos"
		Else
			@ Li,000 Psay "Cliente...........: " + mv_par09
		EndIf
		Li++
		If SubStr(mv_par11,1,2) = "ZZ" .Or. Alltrim(mv_par11) = "" 
			@Li,000 Psay "Situação..........: Todos"
		Else
			@Li,000 Psay "Situação..........: " + mv_par11
		EndIf             
		Li++
		If SubStr(mv_par12,1,2) = "ZZ" .Or. Alltrim(mv_par12) = "" 
			@Li,000 Psay "Segmento..........: Todos"
		Else
			@Li,000 Psay "Segmento..........: " + mv_par12
		EndIf
		Li++
		If mv_par13 = 1
			@Li,000 Psay "Filtro............: Todos"
		ElseIf mv_par13 = 2 
			@Li,000 Psay "Filtro............: Montagem"
		ElseIf mv_apr13 = 3
			@Li,000 Psay "Filtro............: Embalagem"
		EndIf             
		Li:=80
	ElseIf MV_PAR14 == 2  // Sintetico
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		Li:= 10
		@ Li,000 Psay "***  PARÂMETROS SOLICITADOS PELO USUÁRIO  ***"

		Li+=3
		@ Li,000 Psay "Ordem.............:"

		Do Case
			Case nOrdem == 1
			@ Li,020 Psay "PAIS ou REGIÃO"
			Case nOrdem == 2
			@ Li,020 Psay "SETOR DE ATIVIDADE"
			Case nOrdem == 3
			@ Li,020 Psay "EQUIPAMENTOS"
		End

		Li+=2
		@ Li,000 Psay "Data Liberação de.: " + DTOC(mv_par01)
		@ Li,037 Psay  "ate: " + DTOC(mv_par02)

		Li++
		@ Li,000 Psay "Vendedor de.......: " + mv_par03
		@ Li,037 Psay "ate: " + mv_par04

		Li++
		@ Li,000 Psay "Pais de...........: " + mv_par05
		@ Li,037 Psay "ate: " + mv_par06

		Li++
		@ Li,000 Psay "UF de.............: " + mv_par07
		@ Li,037 Psay "ate: " + mv_par08

		Li++
		If SubStr(mv_par09,1,3) = "ZZZ"
			@ Li,000 Psay "Cliente...........: Todos"
		Else
			@ Li,000 Psay "Cliente...........: " + mv_par09
		EndIf

		Li := 80
	EndIf

Return
