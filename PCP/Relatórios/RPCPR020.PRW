#Include "Rwmake.ch"
#Include "Topconn.CH"
#Include "Tbiconn.CH"                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RPCPR020 ³ Autor ³ Ana Paula QFaustino   ³ Data ³ 07.11.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao dos Desenhos  (Cadastrados na Tabela SZ0)           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function RPCPR020()

Local titulo 	  := "Relacao de Desenhos"  	
Local cString	  := "SZ0"
Local wnrel		  := "RPCPR020"
Local cDesc		  := "Este programa ira imprimir o Relatorio de Desenhos." //"Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o."
Local aUsuario    := {}
Local cNomusu     := " "
Local cQuery      := ""
Local nTReg       := 0

Private tamanho	    := "M"
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}  
Private cPerg		:= "PCPR20" + Space(4)
Private nLastKey    := 0
Private nLin        := 80
Private _cPath      := ""
Private cDesenho    := ""
Private fImp        := .F.
Private lPri        := .T.
Private _lParam     := .F.
Private _lRet       := .T.
Private _cUsuario   := ""
Private _cUsuSenha  := {}
Private _aUsuario   := {}
Private _cDeptoUsu  := {}
Private aAreaSZ0    := {}
Private nomeprog	:= "RPCPR020"
Private m_pag       := 01
Private aDesenhos   := {}
Private lAbortPrint := .F.
Private nTipo       := 18
Private cDrive      := ""
Private cabec1,cabec2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//³ MV_PAR01 Do Documento?                                       |
//³ MV_PAR02 Qual a Rotina?                                      |
//³ MV_PAR03 Data Geracao de?                                    |
//³ MV_PAR04 Data Geracao Ate?                                   |
//| MV_PAR05 Centro Custo?                                       |
//| MV_PAR06 Imprime? (Gerados/Impressos/Ambos)                  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cUsuario  := RetCodUsr()

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
EndIf

Do While _lParam == .F.

	If !Pergunte(cPerg,.T.)                                         
	   Return
	EndIf   
	
	MV_PAR01 := Alltrim(MV_PAR01)
	MV_PAR02 := Alltrim(MV_PAR02)
	
	If _lRet
		_lParam := .T.
	Else
		If ! MsgBox("*** Deseja corrigir os parametros ? ***","AVISO","YESNO")
			Return
		EndIf
		_lRet  := .T.
	EndIf
End

//Ativando Módulo Impressora
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

If lAbortPrint
	@ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	Return
Endif

RptStatus({|lEnd| RPCP20Imp(@lEnd,tamanho,wnrel,cString)},Titulo)

Return

//******************************************************
Static Function RPCP20Imp(lEnd,tamanho,wnrel,cString)
//******************************************************
Local aUsuario    := {}
Local cNomusu     := " "
Local cQuery      := "" 
Local nTReg       := 0
Local aDocs       := {}
Local cDoc        := ""
Local aAreaAtu    := GetArea()
Local aAreaSZ0    := SZ0->(GetArea())
Local cDoc1       := ""
Local cDoc2       := ""                              
Local cDoc3       := ""
Local cUsuario    := ""
Local aPosicSZ0   := {}
Local aPosicDoc   := {}
Local cStatus     := ""
Local aCusto      := {}
Local cCusto      := ""
Local nx := 0
Local ny := 0
Local na := 0

cUsuario := Alltrim(substr(cUserName,1,15))

titulo := "Resumo da Impressão dos Desenhos"
cabec1 := "Produto          Descricao                              Documento"
cabec2 := "" 

cabec(titulo,cabec1,cabec2,nomeprog,tamanho)

@ 008,000 PSAY "Documentos: "+Alltrim(MV_PAR01)
@ 010,000 PSAY "Data Geracao de: "+DtoC(MV_PAR03)
@ 010,030 PSAY "Ate "+Dtoc(MV_PAR04)
@ 010,045 PSAY "Rotina: "+MV_PAR02
@ 010,065 PSAY "C.Custo: "+MV_PAR05
@ 010,095 PSAY "Usuario: "+cUsuario
@ 011,000 PSAY REPLICATE("=",132)
nLin := 12

//***********************************************
// monta os array com os documentos do parametro
//***********************************************
If Len(Alltrim(MV_PAR01)) > 0 
	For nX:=1 To Len(Alltrim(MV_PAR01))
		cDoc := Substr(Alltrim(MV_PAR01),nX,6)
		If cDoc <> ""
			AAdd(aDocs, { cDoc } )
			nX += 6
		EndIf
	Next nX
EndIf

//***********************************************
// monta os array com o centro custo do parametro
//***********************************************
If Len(Alltrim(MV_PAR05)) > 0 
	For nX:=1 To Len(Alltrim(MV_PAR05))
		cCusto := Substr(Alltrim(MV_PAR05),nX,3)
		If cCusto <> ""
			AAdd(aCusto, { cCusto } )
			nX += 3
		EndIf
	Next nX
EndIf

If Select("TMP") > 0 
   DbSelectArea("TMP")
   DbCloseArea()
EndIf

cQuery := "SELECT SZ0.Z0_PRODUTO,SB1.B1_DESC, SZ0.Z0_DOCUM,SZ0.Z0_ROTINA, SZ0.Z0_STATUS, SZ0.Z0_CCUSTO, SZ0.Z0_USUARIO, SZ0.Z0_DATA, " 
cQuery += "       SZ0.Z0_HORA,   SB1.B1_REVATU " 
cQuery += "FROM "+RetSqlName("SZ0")+" SZ0 " 
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD = SZ0.Z0_PRODUTO " 
cQuery += "WHERE SZ0.D_E_L_E_T_ = ' ' " 
cQuery += "  AND SB1.D_E_L_E_T_ = ' ' " 
If MV_PAR06 == 1  // Somente Gerados
	cQuery += "  AND SZ0.Z0_STATUS = 'G' " 
ElseIf MV_PAR06 == 2 // Somente Impressos
	cQuery += "  AND SZ0.Z0_STATUS = 'I' " 
EndIf
// Caso o MV_PAR06 == 3 pegara todo o cadastro no periodo informado       
cQuery += "  AND SZ0.Z0_ROTINA = '"+MV_PAR02+"' " 
cQuery += "  AND SZ0.Z0_DATA BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' " 
cQuery += "  AND SZ0.Z0_USUARIO = '"+cUsuario+"' " 
cQuery += "ORDER BY SZ0.Z0_PRODUTO " 

//Executa Query
cQuery := ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery),"TMP",.T.,.T.)

dbSelectArea("TMP")
TMP->(dbGoTop())               
nTReg := TMP->(RecCount())
ProcRegua(nTReg)

// Cria Array com os desenhos a serem impressos
If !Empty(MV_PAR01)
	//Monta Array com os Dados do Pedido
	For nX:=1 To Len(aDocs)
		TMP->(dbGoTop())	
		While !Eof()
			If aDocs[nX][1] $ Alltrim(TMP->Z0_DOCUM)
   		 	    nPos := Ascan(aPosicDoc, {|x| Trim(x[1]) == Trim(TMP->Z0_PRODUTO) })
				If nPos = 0
					AAdd(aPosicDoc, {TMP->Z0_PRODUTO,TMP->B1_DESC,TMP->Z0_DOCUM,TMP->Z0_ROTINA,TMP->Z0_STATUS,TMP->Z0_CCUSTO,;
									 TMP->Z0_USUARIO,TMP->Z0_DATA,TMP->Z0_HORA,TMP->B1_REVATU })
				EndIf
			EndIf
			TMP->(DbSkip())
		EndDo
	Next nX
Else
	While !Eof()
		nPos := Ascan(aPosicDoc, {|x| Trim(x[1]) == Trim(TMP->Z0_PRODUTO) })
		If nPos = 0
			AAdd(aPosicDoc,{TMP->Z0_PRODUTO,TMP->B1_DESC,TMP->Z0_DOCUM,TMP->Z0_ROTINA,TMP->Z0_STATUS,TMP->Z0_CCUSTO,TMP->Z0_USUARIO,;
							TMP->Z0_DATA,TMP->Z0_HORA,TMP->B1_REVATU })
		EndIf
		TMP->(dbSkip())
	EndDo
EndIf
TMP->(dbCloseArea())

// Cria Array com os desenhos a serem impressos
If !Empty(MV_PAR05)
	//Monta Array com os Dados do Pedido
	For nX:=1 To Len(aCusto)
		For nY:=1 To Len(aPosicDoc)		
			If aCusto[nX][1] $ Alltrim(aPosicDoc[nY][6])
   		 	    nPos := Ascan(aPosicSZ0, {|x| Trim(x[1]) == Trim(aPosicDoc[nY][1]) })
				If nPos = 0
					AAdd(aPosicSZ0, {aPosicDoc[nY][1],aPosicDoc[nY][2],aPosicDoc[nY][3],aPosicDoc[nY][4],aPosicDoc[nY][5],aPosicDoc[nY][6],;
									 aPosicDoc[nY][7],aPosicDoc[nY][8],aPosicDoc[nY][9],aPosicDoc[nY][10] })
				EndIf
			EndIf
		Next nY
	Next nX
Else
	For nY:=1 To Len(aPosicDoc)
		nPos := Ascan(aPosicSZ0, {|x| Trim(x[1]) == Trim(aPosicDoc[nY][1]) })
		If nPos = 0
			AAdd(aPosicSZ0, {aPosicDoc[nY][1],aPosicDoc[nY][2],aPosicDoc[nY][3],aPosicDoc[nY][4],aPosicDoc[nY][5],aPosicDoc[nY][6],;
							 aPosicDoc[nY][7],aPosicDoc[nY][8],aPosicDoc[nY][9],aPosicDoc[nY][10] })
		EndIf
	Next nX
EndIf

// Imprime o Array de Desenhos
For nX:=1 To Len(aPosicSZ0)
	cDesenho := AllTrim(aPosicSZ0[nX][1]) + aPosicSZ0[nX][10]   
	_cPath := "H:\PLOTTER\"
	If SubStr(cNumEmp,1,2) == "01"
		If Substr(cDesenho,1,2) == "CL"
			_cPath += Substr(cDesenho,3,2) + "\"
		Else
			_cPath += Substr(cDesenho,1,2) + "\"
		EndIf
	ElseIf SubStr(cNumEmp,1,2) == "10"   
		_cPath += Substr(cDesenho,1,3) + "\"
	EndIf
	If ASCAN(aDesenhos, _cPath + Alltrim(cDesenho) + ".PLT") == 0
		AADD(aDesenhos, _cPath + Alltrim(cDesenho) + ".PLT")
		AADD(aDesenhos, _cPath + Alltrim(cDesenho) + ".PRI")
		AADD(aDesenhos, _cPath + Alltrim(cDesenho) + ".PRN")
	EndIf
Next nX	

//Imprime Resume dos Desenhos Impressos
For nX:=1 To Len(aPosicSZ0)
    cDoc1   := substr(aPosicSZ0[nX][3],1,70)
    cDoc2   := substr(aPosicSZ0[nX][3],71,70)
    cDoc3   := substr(aPosicSZ0[nX][3],141,70)

    nLin += 1
    @ nLin,000 PSAY aPosicSZ0[nX][1]
	@ nLin,017 PSAY SUBSTR(aPosicSZ0[nX][2],1,35)
	If Alltrim(cDoc1) <> ""
		@ nLin,055 PSAY cDoc1
	Endif

	IF nLin >= 70
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		@ 008,000 PSAY "Documentos: "+Alltrim(MV_PAR01)
		@ 010,000 PSAY "Data Geracao de: "+DtoC(MV_PAR03)
		@ 010,030 PSAY "Ate "+Dtoc(MV_PAR04)
		@ 010,045 PSAY "Rotina: "+MV_PAR02
		@ 010,065 PSAY "C.Custo: "+MV_PAR05
		@ 010,095 PSAY "Usuario: "+cUsuario
		@ 011,000 PSAY REPLICATE("=",132)
		nLin := 12
	ENDIF

	If Alltrim(cDoc2) <> ""
		nLin += 1	
		@ nLin,055 PSAY cDoc2
	Endif

	IF nLin >= 70
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		@ 008,000 PSAY "Documentos: "+Alltrim(MV_PAR01)
		@ 010,000 PSAY "Data Geracao de: "+DtoC(MV_PAR03)
		@ 010,030 PSAY "Ate "+Dtoc(MV_PAR04)
		@ 010,045 PSAY "Rotina: "+MV_PAR02
		@ 010,065 PSAY "C.Custo: "+MV_PAR05
		@ 010,095 PSAY "Usuario: "+cUsuario
		@ 011,000 PSAY REPLICATE("=",132)
		nLin := 12
	ENDIF

	If Alltrim(cDoc3) <> ""
		nLin += 1
		@ nLin,055 PSAY cDoc3
		nLin+=1
	Endif

	IF nLin >= 70
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		@ 008,000 PSAY "Documentos: "+Alltrim(MV_PAR01)
		@ 010,000 PSAY "Data Geracao de: "+DtoC(MV_PAR03)
		@ 010,030 PSAY "Ate "+Dtoc(MV_PAR04)
		@ 010,045 PSAY "Rotina: "+MV_PAR02
		@ 010,065 PSAY "C.Custo: "+MV_PAR05
		@ 010,095 PSAY "Usuario: "+cUsuario
		@ 011,000 PSAY REPLICATE("=",132)
		nLin := 12
	ENDIF
	
Next nX

nLin+=1

//Muda o STATUS do Desenho de (G)erado para (I)mpresso
For nX:=1 To Len(aPosicSZ0)
	SZ0->(DbSetOrder(1))
	SZ0->(DbGoTop())
	If SZ0->(dbSeek(xFilial("SZ0")+(aPosicSZ0[nX][1])+(aPosicSZ0[nX][7])+(aPosicSZ0[nX][4])+(aPosicSZ0[nX][8]) ))
		RECLOCK("SZ0",.F.)
		SZ0->Z0_STATUS := "I"
		SZ0->(MSUNLOCK())							
	EndIf
Next nX	

//Finaliza a execução do relatorio
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	OurSpool(wnrel)
EndIf

// Impressao dos Desenhos 
If Len(aDesenhos) > 0
	Set Printer To
	If aReturn[5] > 1
		For nA := 1 TO Len(aDesenhos)
			WaitRun("H:\Plotter\Plot\plot3.bat "+aDesenhos[nA])   
		Next 
	EndIf
EndIf

MS_FLUSH() 

RestArea(aAreaSZ0)
RestArea(aAreaAtu)

Return