#include "protheus.ch"
#Include "Topconn.ch"
#Include "Rwmake.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±³Funcao	   ³ RPCPR015³ Autor ³ Ana Paula QFaustino      ³Data ³  29.09.11 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Emite Resumo de OPs Finalizadas - SQL                        ³±± 
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 

User Function RPCPR015()                                                                                    

Local nLin    := 80
Local aOrd    := {}
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := ""
Local Titulo  := "Relatorio de OP´s Finalizada"
Local Cabec1  := "Produto/Descricao/Local/Qtde OP´s/Qtde Pcs"
Local Cabec2  := ""

Local cQuery  := ""
Local nTReg   := 0
Local aArea   := GetArea()
Local aCampos := {}
Local cLocal  := Space(01)

Private lAbortPrint := .F.
Private tamanho     := "M"
Private limite      := 80
Private nomeprog    := "RPCPR015"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}   
Private nLastKey    := 0
Private wnrel       := "RPCPR015"
Private cString     := "SC2"
Private cPerg		:= "PCPR15"
Private _aReg		:= {} 
Private m_pag       := 01
Private cLocal      := ""
Private nQtdOPDia   := 0 
Private nQtdFinDia  := 0
Private lFirst      := .T.
Private DTRESUMO
Private LOCALP
Private PRODUTO     

Private aCampos     := {}
Private cQuery      := ""
Private nQtde       := 1

If !Pergunte(cPerg,.T.)
   Return
EndIf   

RptStatus({|| Runreport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    			 ³
//³ mv_par01	 -  Data da Baixa de                             ³
//³ mv_par02	 -  Data da Baixa ate                            ³ 
//³ mv_par03	 -  1-OP 2-Lista 3-Ambos                         ³
//³ mv_par04	 -  Somente Resumo S=Sim  N=Nao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Runreport(Cabec1,Cabec2,Titulo,nLin,aCampos)

Local aCampos    := {}
Local aCampos1   := {}
Local aOrd       := {}
Local titulo     := "Relatorio de OP´s Finalizadas"
Local nLin       := 80                      
Local Cabec1     := ""
Local Cabec2     := ""
Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := ""
Local cQuery     := ""
Local nQtde      := 1
Local nTReg	     := 0 
Local nTReg1     := 0
Local cLocal     := Space(01)
Local nPerc      := 0
Local cEntrega   := ""
Local nLQTDOP    := 0
Local nLQTDPRD   := 0
Local nTQTDOP    := 0
Local nTQTDPRD   := 0
Local nQtdOPDia  := 0
Local nQtdOPFin  := 0
Local nTotOPPrv  := 0
Local nTotOPRea  := 0
Local nTTQTDOP   := 0
Local nTTQTDPRD  := 0
Local nTotPCPrv  := 0
Local nTotPCRea  := 0
Local nTotReaOP  := 0
Local nTotReaPC  := 0
Local nA		:= 0
Local nB		:= 0
Local nC		:= 0
		    
Private m_pag  := 01

If (mv_par03 == 1 .AND. mv_par04 == 2) .OR. (mv_par03 == 2 .AND. mv_par04 == 2) .OR. (mv_par03 == 3 .AND. mv_par04 == 2)   //Imprime Analitico
   Cabec1 := "Produto           Descricao                             Local             Qtde OP´s           Qtde Pcs"
ElseIf (mv_par03 == 1 .AND. mv_par04 == 1) .OR. (mv_par03 == 2 .AND. mv_par04 == 1) .OR. (mv_par03 == 3 .AND. mv_par04 == 1) //Imprime Resumo
   Cabec1 := "                                                        Local             Qtde OP´s           Qtde Pcs"
EndIf

If Select("TMP") > 0 
   DbSelectArea("TMP")
   DbCloseArea()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cQuery := "SELECT SC2.C2_DATRF, SB1.B1_LOCAL, SC2.C2_PRODUTO, SB1.B1_DESC, SC2.C2_QUJE, SC2.C2_PERDA, SC2.C2_QUANT  "
cQuery += "FROM "+RetSqlName("SC2")+" SC2 "
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SC2.C2_PRODUTO "
If !Empty(MV_PAR01) .OR. !Empty(MV_PAR02)
	cQuery += "WHERE SC2.C2_DATRF BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " 
EndIf
If (MV_PAR03==1)
	cQuery += "AND SC2.C2_MSLISTA = 'N' " 
ElseIf (MV_PAR03==2)
	cQuery += "AND SC2.C2_MSLISTA = 'S' " 
EndIf
cQuery += "AND SC2.D_E_L_E_T_ = '' " 
cQuery += "AND SB1.D_E_L_E_T_ = '' " 
cQuery += "ORDER BY SC2.C2_DATRF,SB1.B1_LOCAL,SC2.C2_PRODUTO " 
	
//Executa QUERY
//cQuery := ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery),"TMP",.T.,.T.)

dbSelectArea("TMP")
dbGoTop()
nTReg := TMP->(RecCount())
ProcRegua(nTReg)

//Monta Array com as Datas
While !Eof()                                                                                      
    nPosDat := Ascan(aCampos, {|x| Trim(x[1]) == Trim(TMP->C2_DATRF) })
	If nPosDat = 0
		AAdd(aCampos, {TMP->C2_DATRF,0,0,0,0, {} })
	EndIf
	TMP->(DbSkip())
EndDo

//Monta Array com os Locais
dbGotop()
While !Eof()                                                                                      
    nPosDat := Ascan(aCampos, {|x| Trim(x[1]) == Trim(TMP->C2_DATRF) })
    If nPosDat > 0
		cLocal := Substr(TMP->B1_LOCAL,1,1)
		nPosLoc := Ascan(aCampos[nPosDat][6], {|x| x[1] == cLocal} )
		If nPosLoc = 0
			AAdd(aCampos[nPosDat][6],{cLocal, {} } )
		EndIf
	EndIf
	TMP->(DbSkip())
EndDo

//Monta Array com os Produtos, Descricao, Qtde de Produtos e Qtde de OP´s
dbGotop()
While !Eof()
    nPosDat := Ascan(aCampos, {|x| Trim(x[1]) == Trim(TMP->C2_DATRF)})
	If nPosDat > 0
		cLocal := Substr(TMP->B1_LOCAL,1,1)
		nPosLoc := Ascan(aCampos[nPosDat][6], {|x| x[1] == cLocal} )
		If nPosLoc > 0
			nPosPrd := Ascan(aCampos[nPosDat][6][nPosLoc][2], {|x| x[1] == (TMP->C2_PRODUTO) } )	
			If nPosPrd > 0 
				aCampos[nPosDat][6][nPosLoc][2][nPosPrd][3] += 1
				aCampos[nPosDat][6][nPosLoc][2][nPosPrd][4] += TMP->C2_QUJE + TMP->C2_PERDA
			Else
				AAdd(aCampos[nPosDat][6][nPosLoc][2],{TMP->C2_PRODUTO,TMP->B1_DESC, 1, TMP->C2_QUJE + TMP->C2_PERDA, TMP->C2_QUANT, TMP->C2_QUJE + TMP->C2_PERDA } )
			EndIf
		Endif
	EndIf
	TMP->(DbSkip())
EndDo  

TMP->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho para OP´S PREVISTAS     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cQry := "SELECT SC2.C2_DATPRF, SC2.C2_DATRF, SB1.B1_LOCAL, SC2.C2_PRODUTO, SB1.B1_DESC, SC2.C2_QUJE, SC2.C2_PERDA, SC2.C2_QUANT  "
cQry += "FROM "+RetSqlName("SC2")+" SC2 " 
cQry += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SC2.C2_PRODUTO " 
If !Empty(MV_PAR01) .OR. !Empty(MV_PAR02)
	cQry += "WHERE SC2.C2_DATPRF BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " 
EndIf
If (MV_PAR03==1)
	cQry += "AND SC2.C2_MSLISTA = 'N' "
ElseIf (MV_PAR03==2)
	cQry += "AND SC2.C2_MSLISTA = 'S' " 
EndIf
cQry += "AND SC2.D_E_L_E_T_ = '' " 
cQry += "AND SB1.D_E_L_E_T_ = '' "  
cQry += "ORDER BY SC2.C2_DATPRF,SC2.C2_DATRF,SB1.B1_LOCAL,SC2.C2_PRODUTO " 
	                                             
//Executa QUERY
//cQry := ChangeQuery(cQry)

DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry),"TMP1",.T.,.T.)

dbSelectArea("TMP1")
dbGoTop()
nTReg1 := TMP1->(RecCount())
ProcRegua(nTReg1)

//Monta Array com as Datas
While !Eof()

	nPosDat := Len(aCampos)
	If nPosDat = 0
		nPosDat := Ascan(aCampos, {|x| Trim(x[1]) == Trim(TMP1->C2_DATPRF) })
	    If nPosDat > 0
			If TMP1->C2_DATRF == "        "
				aCampos[nPosDat][2] += 1
				aCampos[nPosDat][5] += TMP1->C2_QUANT
			Else
				AAdd(aCampos,{TMP1->C2_DATRF,0,0,0,0, {} })	 
				aCampos[nPosDat][2] += 1
				aCampos[nPosDat][3] += 1
				aCampos[nPosDat][4] += TMP1->C2_QUJE + TMP1->C2_PERDA
				aCampos[nPosDat][5] += TMP1->C2_QUANT
			EndIf
		Else
			If TMP1->C2_DATRF == "        "
				AAdd(aCampos, {TMP1->C2_DATPRF,1,0,0,TMP1->C2_QUANT, {} })	
			Else 
				AAdd(aCampos, {TMP1->C2_DATPRF,1,1,TMP1->C2_QUJE+TMP1->C2_PERDA,TMP1->C2_QUANT, {} })	
			EndIf 
		Endif
	Else
		cData   := aCampos[nPosDat][1]
		nPosDat := Ascan(aCampos, {|x| Trim(x[1]) == Trim(TMP1->C2_DATPRF) })
	    If nPosDat > 0
			If TMP1->C2_DATRF == "        "
				aCampos[nPosDat][2] += 1
				aCampos[nPosDat][5] += TMP1->C2_QUANT
			Else 
				aCampos[nPosDat][2] += 1
				aCampos[nPosDat][3] += 1
				aCampos[nPosDat][4] += TMP1->C2_QUJE+TMP1->C2_PERDA
				aCampos[nPosDat][5] += TMP1->C2_QUANT
			EndIf
		Else
			If TMP1->C2_DATPRF > cData
				If TMP1->C2_DATRF == "        "
					AAdd(aCampos, {TMP1->C2_DATPRF,1,0,0,TMP1->C2_QUANT, {} })	
				Else 
					AAdd(aCampos, {TMP1->C2_DATPRF,1,1,TMP1->C2_QUJE+TMP1->C2_PERDA,TMP1->C2_QUANT, {} })	
				EndIf 
			EndIf
		Endif
	Endif
 	TMP1->(DbSkip())
EndDo

TMP1->(DbCloseArea())

//Ativando Módulo Impressora
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()
If lAbortPrint
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	Return
Endif

If nLin > 70 // Salto de Página. Neste caso o formulario tem 60 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif     

// Coloque aqui a logica da impressao do seu programa...
// Utilize PSAY para saida na impressora. Por exemplo:
// @nLin,00 PSAY SA1->A1_COD
DbGotop()
For nA := 1 To Len(aCampos)

	If nLin > 66 // Salto de Página. Neste caso o formulario tem 70 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIf

	@ nlin,000 psay "Dia: "
	@ nlin,008 psay StoD(aCampos[nA][1])  // DTRESUMO
	nlin += 2
	
	For nB := 1 To Len(aCampos[nA][6]) 
	
   		For nC := 1 To Len(aCampos[nA][6][nB][2])

	        If (MV_PAR03 == 1 .AND. MV_PAR04 == 2) .OR. (MV_PAR03 == 2 .AND. MV_PAR04 == 2)  .OR. (MV_PAR03 == 3 .AND. MV_PAR04 == 2)
				@ nlin,000 psay aCampos[nA][6][nB][2][nC][1]  					    	// PRODUTO
				@ nlin,018 psay aCampos[nA][6][nB][2][nC][2]  					    	// DESC
				@ nlin,058 psay aCampos[nA][6][nB][1]        				    		// LOCAL 
				@ nlin,070 psay aCampos[nA][6][nB][2][nC][3]   Picture "@E 999,999,999" // QTDOP
				@ nlin,090 psay aCampos[nA][6][nB][2][nC][4]   Picture "@E 999,999,999" // QTDPRD	
			    nLin += 1
			EndIf
			    	    
		    nLQTDOP    += aCampos[nA][6][nB][2][nC][3]
		    nLQTDPRD   += aCampos[nA][6][nB][2][nC][4] 
		    
		    nTQTDOP  += aCampos[nA][6][nB][2][nC][3]
		    nTQTDPRD += aCampos[nA][6][nB][2][nC][4]
		    
		    nQtdOPDia += 1 
		    nQtdOPFin += 1 
		    
			If nLin > 70 // Salto de Página. Neste caso o formulario tem 70 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
    
    	Next nC
    	
		If (MV_PAR03==1 .and. MV_PAR04==2) .OR. (MV_PAR03==2 .and. MV_PAR04==2) .or. (MV_PAR03==3 .and. MV_PAR04==2) 
	    	nLin += 2   	 
			@ nLin,000 psay "Total no Local "+ (aCampos[nA][6][nB][1])
			@ nLin,070 psay nLQTDOP   Picture "@E 999,999,999"
			@ nLin,090 psay nLQTDPRD  Picture "@E 999,999,999"
			nLin += 1
		ElseIf (MV_PAR03==1 .and. MV_PAR04==1) .OR. (MV_PAR03==2 .and. MV_PAR04==1).OR. (MV_PAR03==3 .and. MV_PAR04==1)
			nLin +=1
			@ nLin,058 psay (aCampos[nA][6][nB][1])
			@ nLin,070 psay nLQTDOP   Picture "@E 999,999,999"
			@ nLin,090 psay nLQTDPRD  Picture "@E 999,999,999"
        EndIf

		nLQTDOP   := 0
		nLQTDPRD  := 0
		
	Next nB
	
	If (MV_PAR03==1 .and. MV_PAR04==2) .OR. (MV_PAR03==2 .and. MV_PAR04==2) .OR. (MV_PAR03==3 .and. MV_PAR04==2)
	   If nTQTDOP > 0 .and. nTQTDPRD > 0 
			nLin += 1 	 
			@ nLin,000 psay "Total de OP´s Finalizadas no Dia "
			@ nLin,035 psay StoD(aCampos[nA][1])
			@ nLin,070 psay nTQTDOP    Picture "@E 999,999,999"
			@ nLin,090 psay nTQTDPRD   Picture "@E 999,999,999"
		EndIf
	ElseIf (MV_PAR03==1 .and. MV_PAR04==1) .OR. (MV_PAR03==2 .and. MV_PAR04==1) .OR. (MV_PAR03==3 .and. MV_PAR04==1)
		If nTQTDOP > 0 .and. nTQTDPRD > 0 
		   	nLin += 2 	 
			@ nLin,000 psay "Total de OP´s Finalizadas no Dia "
			@ nLin,035 psay StoD(aCampos[nA][1])
			@ nLin,070 psay nTQTDOP    Picture "@E 999,999,999"
			@ nLin,090 psay nTQTDPRD   Picture "@E 999,999,999"
		EndIf
	EndIf	
	
	nTTQTDOP  += nTQTDOP
	nTTQTDPRD += nTQTDPRD
			
	nTQTDOP  := 0
	nTQTDPRD := 0	    
	
	If (MV_PAR03==1 .and. MV_PAR04==2) .OR. (MV_PAR03==2 .and. MV_PAR04==2).OR. (MV_PAR03==3 .and. MV_PAR04==2)
		nLin += 2
		nPerc := (aCampos[nA][3] * 100) / (aCampos[nA][2])
		@ nLin,000 Psay "Total de OPs Previstas: "
		@ nLin,027 Psay aCampos[nA][2] Picture "@E 999,999" 
		@ nLin,040 psay "Realizadas: "
		@ nLin,056 psay aCampos[nA][3] Picture "@E 999,999"
		@ nLin,065 psay "==> "
		@ nLin,070 psay nPerc          Picture "@E 999,99"
		@ nLin,077 psay "%"
		nLin +=1
		@ nLin,000 psay replicate("-",110)
		nLin +=2
	ElseIf (MV_PAR03==1 .and. MV_PAR04==1) .OR. (MV_PAR03==2 .and. MV_PAR04==1).OR. (MV_PAR03==3 .and. MV_PAR04==1)
		nPerc := (aCampos[nA][3] * 100) / (aCampos[nA][2])
	    nLin += 2
		@ nLin,000 Psay "Total de OPs Previstas: "
		@ nLin,027 Psay aCampos[nA][2] Picture "@E 999,999"  
		@ nLin,040 psay "Realizadas: "
		@ nLin,056 psay aCampos[nA][3] Picture "@E 999,999"
		@ nLin,065 psay "==> "
		@ nLin,070 psay nPerc          Picture "@E 999.99"
		@ nLin,077 psay "%"
		nLin +=1
		@ nLin,000 psay replicate("-",110)
		nLin +=2
	EndIf

    nQtdOPDia := 0 
    nQtdOPFin := 0
    
    nTotOPPrv += aCampos[nA][2]
    nTotPCPrv += aCampos[nA][5]
    
    nTotOPRea += aCampos[nA][3]
    nTotPCRea += aCampos[nA][4]
    
	If (mv_par03==1) .and. (mv_par04==2) .or. (mv_par03==2) .and. (mv_par04==2) .or. (mv_par03==3) .and. (mv_par04==2)
		If nTQTDOP > 0 .and. nTQTDPRD > 0 .or. nLin > 70
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf
	ElseIf (mv_par03==1) .and. (mv_par04==1) .or. (mv_par03==2) .and. (mv_par04==1) .or. (mv_par03==3) .and. (mv_par04==1)
			If nLin > 70
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			EndIf
	EndIf
	
Next nA

If nLin > 65
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
EndIf

nTotReaOP  := nTotOPPrv - nTotOPRea
nTotReaPC  := nTotPCPrv - nTotPCRea

nLin += 1
@ nLin,000 psay replicate("-",110)
nLin += 2
@ nLin,000 Psay "Total de OPs Finalizadas no Periodo ...................: "
@ nLin,070 Psay nTTQTDOP       Picture "@E 999,999,999"
@ nLin,090 Psay nTTQTDPRD      Picture "@E 999,999,999"
nLin += 2  
@ nLin,000 psay "Total de OPs Previstas no Periodo .....................: "
@ nLin,070 psay nTotOPPrv      Picture "@E 999,999,999"
@ nLin,090 psay nTotPCPrv      Picture "@E 999,999,999"
nLin += 2  
@ nLin,000 psay "Do Total Previsto no Periodo, foram Realizadas ........: "
@ nLin,070 psay nTotOPRea      Picture "@E 999,999,999"
@ nLin,090 psay nTotPCRea      Picture "@E 999,999,999"

nLin += 2  
@ nLin,000 psay "Ainda faltam para que o Previsto se iguale ao Realizado: "
@ nLin,070 psay nTotReaOP      Picture "@E 999,999,999"
@ nLin,090 psay nTotReaPC      Picture "@E 999,999,999"

dHoje := DATE()
nDiasUteis := 0
IF mv_par01 > dHoje
   dHoje := mv_par01
ENDIF   
WHILE dHoje < mv_par02
   IF DOW(dHoje) > 1 .AND. DOW(dHoje) < 7
      nDiasUteis++
   ENDIF
   dHoje++
ENDDO
IF nDiasUteis > 0
   nLin+=2
   @ nLin,000 Psay "Dias uteis para completar o periodo....................: "  
   @ nLin,070 Psay nDiasUteis Picture "@E 999,999,999"
   nLin+=2
   @ nLin,000 Psay "Média a cumprir diariamente............................: "  
   @ nLin,070 Psay (nTotOPPrv - nTotOPRea) / nDiasUteis Picture "@E 999,999,999"
   @ nLin,090 Psay (nTotPCPrv - nTotPCRea) / nDiasUteis Picture "@E 999,999,999"
ENDIF   
nLin +=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return