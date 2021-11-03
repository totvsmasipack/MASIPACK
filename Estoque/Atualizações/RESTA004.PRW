#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±≥Funcao	 ≥ RESTA004≥ Autor ≥ Aparecida de F.Stevanato≥Data ≥ 23.02.09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ-ƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Atualiza Status da OP/Finaliza OP (OPPronta)           	  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
*/

User Function RESTA004()

Private _cUsuario   := ""
Private cUsuarioSZS := ""
Private _cUsuSenha  := ""
Private _cDeptoUsu  := ""
Private _aUsuario   := {}
Private titulo      := ""
Private cString     := "SC2"
Private nomeprog    := "RESTA004"
Private cRegTXT     := ""
Private _lProc      := .T.
Private cProduto    := ""

// Variaveis utilizadas para impressao de etiquetas
Private cArqPRN    := "c:\relato_microsiga\EtiqPecas.PRN"
Private cRegPRN    := ""
Private _cNumOp    := ""
Private cProd      := ""
Private cLocal     := ""
Private cRev       := ""
Private nEtiq      := 0
Private nQtdEtiq   := 0
Private _nLin      := 0
Private _nCol      := 0
Private cMens      := ""

_cUsuario  := RetCodUsr()
_cUsuSenha := UsrRetname(_cUsuario)
PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
	cUsuarioSZS	:= Upper(Alltrim(_aUsuario[1][4]))
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
EndIf

If "ALMOXARIFADO" $ _cDeptoUsu
	_cDeptoUsu := "ALMOXARIFADO"
EndIf

Do While _lProc
	nQtdEtiq	:= 0
	_cNumOp	:= Space(11)
	fRet		:= .F.
	
	@ 089,175 To 430,530 Dialog _oDlg1 Title OemToAnsi("PCP - PeÁas Destinadas ao Almoxarifado")
	@ 009,011 To 035,163
	@ 030,011 To 150,163
	@ 015,054 Say OemToAnsi("Finaliza Ordem de ProduÁ„o")        Size 151,010
	@ 065,020 Say OemToAnsi("Ordem de produÁ„o.:")               Size 070,008
	@ 065,075 Get _cNumOp F3 "SC2" Valid ValidaOP()                  Size 055,008
	@ 100,080 BmpButton Type 1 Action Processa( { || StatusOP() })
	@ 100,115 BmpButton Type 2 Action _fFinaliza()
	
	Activate Dialog _oDlg1 Centered
EndDo

Return

****************************
Static Function _fFinaliza()
****************************

_lProc := .F.
_oDlg1:End()

Return

**************************
Static Function ValidaOP()
**************************
fRet := .T.
If Alltrim(_cNumOp) <> ""
	If Len(Alltrim(_cNumOp)) < 11
		_cNumOp := SUBSTR(_cNumOp,1,6) + "01001"
	EndIf
	SC2->(DbSetOrder(1))
	If SC2->(DbSeek(xFilial("SC2")+_cNumOp))
		cProduto := Alltrim(SC2->C2_PRODUTO)
		If SC2->C2_MSLISTA == "S"
			cMens := "OP em Lista de separacao! Use o programa apropriado..."
			ApMsgInfo(cMens)
			fRet := .F.
		Else
			If !Empty(SC2->C2_DATRF) .Or. ((SC2->C2_QUJE+SC2->C2_PERDA) >= SC2->C2_QUANT)
				cMens := "Ordem de produÁ„o j· concluida"
				ApMsgInfo(cMens)
				fRet := .F.
			EndIf
		EndIf
		sd4->(DBSETORDER(2))
		sd4->(DBGOTOP())
		IF sd4->(DBSEEK(xFilial("SD4") + _cNumOp))
			WHILE ALLTRIM(sd4->d4_op) == ALLTRIM(_cNumOp) .AND. !sd4->(EOF())
				IF sd4->d4_quant > 0
					SB1->(DBSEEK(xFilial("SB1") + sd4->d4_cod))
					cMens := "Componente: " + ALLTRIM(sd4->d4_cod) + " - " + ALLTRIM(sb1->b1_desc) + " nao apontado. Aponte na operacao anterior."
					ApMsgInfo(cMens)
					fRet := .F.
				ENDIF
				sd4->(DBSKIP())
			ENDDO
		ENDIF
	Else
		cMens := "Ordem de produÁ„o n„o encontrada!"
		ApMsgInfo(cMens + _cNumOp)
		cMens := ""
		fRet := .F.
	EndIf
	If !fRet
		IF !EMPTY(cMens)
			GravaSZS()
		ENDIF
	EndIf
EndIf

Return fRet

**************************
Static Function StatusOP()
**************************

cMens := ""

If Alltrim(_cNumOp) == ""
	apmsgAlert("Escolha uma Ordem de ProduÁ„o")
	_oDlg1:End()
	Return
EndIf

SD4->(DBSetOrder(1))
SD4->(DBGoTop())
SD4->(DbSeek(xFilial("SD4")+cProduto))
Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_COD) == cProduto
	If SD4->D4_QUANT > 0 .And. SD4->D4_MSLF == "X"
		ApMsgInfo("Esta peÁa est· em Lista de Falta, Favor colocar Etiqueta ou Mencionar na OP")
		cProduto := ""
	EndIf
	SD4->(DbSkip())
EndDo

SC2->(DbSetOrder(1))
SC2->(DbSeek(xFilial("SC2")+_cNumOp))
SB1->(DbSetOrder(1))

If SB1->(DbSeek(xFilial("SB1")+Alltrim(SC2->C2_PRODUTO)))
	cLocal := SB1->B1_LOCAL
	If !Empty(SB1->B1_REVATU)
		cRev := "-" + Alltrim(SB1->B1_REVATU)
	Else
		cRev := ""
	EndIf
	
	If !Empty(SC2->C2_DATAJI)
		RecLock("SC2",.F.)
		SC2->C2_MSPOSIC := "(205XXX) - RESTA004 - Fim do Processo: (" + SubStr(_cDeptoUsu,1,3) + ")-" + SubStr(_cDeptoUsu,5,Len(_cDeptoUsu)) + " em " + DTOC(Date())
		SC2->C2_DATAJF  := Date()
		cMens := SC2->C2_MSPOSIC
		SC2->(MsUnlock())
		GravaSZS()
		Alert("PosiÁ„o da OP: "+SC2->C2_MSPOSIC)
		
		If MsgBox("Imprime Etiquetas?","AVISO","YESNO")
		
			_cQry := " SELECT TOP 1 H6_QTDPROD FROM " + RetSqlName("SH6")
			_cQry += " WHERE D_E_L_E_T_ = ' ' AND H6_OP = '" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN + "' ORDER BY H6_OPERAC DESC "
			
			If Select("TRB1") > 0
				TRB1->(dbCloseArea())
			EndIf
			
			TCQUERY _cQry NEW ALIAS "TRB1"
			
			TRB1->(dbGoTop())
			If TRB1->(!EOF())
				cMens := "Etiquetas de IdentificaÁ„o impressas"
				GravaSZS()
				ImpEtiq()
			Else
				Alert("AtenÁ„o!!! n„o ser· possÌvel imprimir a etiqueta, esta OP n„o possui apontamento!")
				If Select("TRB1") > 0
					TRB1->(dbCloseArea())
				EndIf
			EndIf
		EndIf
	Else
		Alert("Op ainda n„o foi iniciada")
	Endif
EndIf

_oDlg1:End()

Return

**************************
Static Function GravaSZS()
**************************

Local _cQry		:= ""
Local _nQuant	:= 0

IF !Empty(Alltrim(cMens))
	If Select("TRB1") > 0
		_nQuant  := TRB1->H6_QTDPROD
		nQtdEtiq := TRB1->H6_QTDPROD
	EndIf
	
	DbSelectArea("SZS")
	RecLock("SZS",.T.)
	SZS->ZS_FILIAL  := "01"
	SZS->ZS_OP      := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	SZS->ZS_PRODUTO := SC2->C2_PRODUTO
	SZS->ZS_QTDE    := _nQuant //SC2->C2_QUANT-(SC2->C2_QUJE+SC2->C2_PERDA)
//	SZS->ZS_QTDE    := SC2->C2_MSULTQT    - LIZANDRA 02/04/13
	SZS->ZS_POSICAO := cMens
	SZS->ZS_DATA    := Date()
	SZS->ZS_HORA    := Time() 
	SZS->ZS_CC      := "205XXX"
	SZS->ZS_USUARIO := UPPER(cUsuarioSZS)
	SZS->ZS_DEPTO   := _cDeptoUsu
	SZS->(MsUnlock())
ENDIF 

If Select("TRB1") > 0
	TRB1->(dbCloseArea())
EndIf

Return

*************************
Static Function ImpEtiq()                   
*************************
cProd    := Upper(SC2->C2_PRODUTO)
//nQtdEtiq := SC2->C2_QUANT-(SC2->C2_QUJE+SC2->C2_PERDA)
//nQtdEtiq := SC2->C2_MSULTQT - LIZANDRA 02/04/13
nEtiq    := 5
IniEtiq()      // Grava as informacoes iniciais no arquivo

MontaEtiq()    // Monta etiqueta

If _nCol > 0
	cRegPRN := "^" + StrZero(nEtiq,2,0)
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN := "Q0001"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	cRegPRN :=  "E"
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
EndIf

// As linhas abaixo salta uma fileira de etiqueta, para evitar o uso da tecla FEED

cRegPRN := CHR(2) + "c0000"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KI503"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "o0220"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "f220"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KW0400"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KI7" + CHR(1)
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "V0"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "L"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "H13"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "PC"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "A2"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "D11"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := ""
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "^" + StrZero(nEtiq,2,0)
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "Q0001"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN :=  "E"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))

cRegPRN := CHR(2) + "Q"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
FClose(cArqPRN)

//VICTOR DESSUNTE - 28/02/2017
//INICIO - TICKET:2016122137000411
WaitRun("cmd /c copy c:\relato_microsiga\EtiqPecas.prn prn")
WaitRun("cmd /c del c:\relato_microsiga\EtiqPecas.prn")

/*If _cDeptoUsu $ "RECEBIMENTO_ALMOXARIFADO"
	WaitRun("F:\BAT\ImpEtiqAlm.bat")
Else
	WaitRun("F:\BAT\ImpEtiqFab.bat")
EndIf*/
//FIM - TICKET:2016122137000411

FErase("c:\relato_microsiga\EtiqPecas.prn")
Return

*************************
Static Function IniEtiq()
*************************
_nLin := 13
If (cArqPRN := FCreate("C:\Relato_Microsiga\EtiqPecas.prn")) == -1
	Alert("Arquivo de Etiquetas n„o pode ser criado - Avise o Depto. de Inform·tica")
	Return
EndIf

cRegPRN := CHR(2) + "c0000"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KI503"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "o0220"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "f220"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KW0400"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "KI7" + CHR(1)
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "V0"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := CHR(2) + "L"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "H13"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "PC"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN := "A2"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
cRegPRN :=  "D11"
FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
Return

***************************
Static Function MontaEtiq()
***************************
Local I       := 0
Local nSalto  := 28

For I := 1 to nQtdEtiq
	cRegPRN := "221100000990" + StrZero(_nLin,3) + "OP.: " + Alltrim(_cNumOp)
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	_nLin+=13
	cRegPRN := "221100000990" + StrZero(_nLin,3) + "LOCAL: " + SUBSTR(cLocal,1,1) + "-" + SUBSTR(cLocal,2,3) + "-" + SUBSTR(cLocal,5)
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	_nLin+=13
	cRegPRN := "221100000990" + StrZero(_nLin,3) + Alltrim(cProd) + cRev
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	_nLin+=13
	cRegPRN := "221100000990" + StrZero(_nLin,3) + "FAB: " + DTOC(Date())
	FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
	_nLin+=nSalto
	_nCol++
	If _nCol == nEtiq
		cRegPRN := "^" + StrZero(nEtiq,2,0)
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN := "Q0001"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		cRegPRN :=  "E"
		FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		If I < nQtdEtiq
			cRegPRN := CHR(2) + "L"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "A2"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
			cRegPRN := "D11"
			FWrite(cArqPRN,cRegPRN+chr(13)+chr(10))
		EndIf
		_nCol := 0
		_nLin := 13
	EndIf
Next I
Return
