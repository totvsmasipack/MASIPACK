#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "AP5MAIL.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPA018³ Autor ³ Aparecida de F.Stevanato³Data ³ 26.01.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo de Ordens de Producao p/ Separacao no Almoxarifado  ³±±
±±³          ³ Programas do Integra MATP0915 e MATP0943   	              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function RPCPA018()

Private titulo      := ""
Private cString     := "SD4"
Private wnrel       := ""
Private aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }   
Private nomeprog    := "RPCPA018"
Private cPerg	     := "PCPA18" + Space(4)
Private cArqTrab    := ""
Private cFilTrab    := ""
Private nLastKey    := 0
Private I           := 0

Private Li          := 99
Private CbTxt       := ""
Private tamanho     := "M"
Private limite      := 132
Private _lProc      := .T.
Private _lAtu       := .T.
Private aDesenhos   := {}
Private cDesenho    := ""
Private _cPath      := ""
Private cLocal      := ""
Private cOpcao      := '1'
Private nItens      := 0
Private cabec1      := "  OP                    CLIENTE             PRODUTO            DESCRIÇÃO                               LOCAL       COR"
Private cabec2      := ""

Private _oDlg
Private oList1
Private nList1:= 1
Private aOPs:={}
Private nItem := 0
Private lProc := .T.

	If cEmpAnt $ '01|10'
		Help(NIL, NIL, "NOPERM", NIL, "Esta rotina foi descontinuada no sistema Protheus", 1, 0, NIL, NIL, NIL, NIL, NIL, {"A nova rotina encontra-se em 'PCP > Atualizações > Movimentos Producao > Ordens de Produção > Outras Ações > Especificos > Referencia'"})
		Return
	Endif

	aOpcao := {"1-Referencia Nova","2-Troca Referencia","3-Imprime Referencia"}

	Do While lProc

		cOpcao	:= '1'
		cRefer	:= Soma1(GetMv("MV_MSREFER"))
		cOP		:= Space(11)
		cGrupo	:= Space(4)
		cItRef	:= Space(10)

		@ 089,190 To 500,600 Dialog _oDlg1 Title OemToAnsi("PCP - Lançamento de Referencia")
		@ 030,011 To 190,200
		@ 015,045 Say OemToAnsi("Resumo de OP - Separação no Almoxarifado")        Size 151,010
		@ 040,030 Say OemToAnsi("Opção.......................................:")   Size 150,008
		@ 055,030 Say OemToAnsi("Referencia............................:")         Size 080,008
		
		@ 075,030 Say OemToAnsi("Item referencia........................:")			Size 080,008
		
		@ 090,030 Say OemToAnsi("Ordem de Produção......:")                        Size 080,008
		@ 105,030 Say OemToAnsi("Grupo.......................................:")   Size 080,008
		@ 037,090 ComboBox cOpcao Items aOpcao                                     Size 070,010  object oOpcao
		@ 055,090 Get cRefer Valid VeRefer()										Size 035,008  object oRefer
		
		If cEmpAnt == '10'
			@ 075,090 Get cItRef													Size 055,008 object oItRef
		EndIf
		
		@ 090,090 Get cOP F3 "SC2_1" Valid ValidaOP()                                Size 055,008  object oOP
		@ 105,090 Get cGrupo Valid VerGrupo()										Size 020,008
		@ 130,090 Button "Exibe OPs" Size 60,15 Action ExibeOP()
		@ 150,090 Button "Imprimir" Size 30,15 Action U_GeraRel()
		@ 150,125 Button "Sair" Size 25,15 Action _fFinaliza()
		
		_oDlg1:lEscClose := .F.
		
		Activate Dialog _oDlg1 CENTERED

	EndDo

Return

//Função para atualizar o número da Referência e encerrar o programa
Static Function _fFinaliza()
/*
	SD4->(DbSetOrder(11))
	If SubStr(cOpcao,1,1) == "1" .And. SD4->(DbSeek(xFilial("SD4") + cRefer))
		cRefer := Soma1(GetMv("MV_MSREFER"))
		PutMV("MV_MSREFER",cRefer)
	EndIf
*/
	lProc := !lProc
	_oDlg1:End()

Return 

// Função para validar a Referêcia informada.
Static Function VeRefer()

Local lRet	:= .T.

	DO CASE

		CASE !Empty(cRefer) .And. SubStr(cOpcao,1,1) == "1"

			SD4->(DbSetOrder(11))
			If SD4->(DbSeek(xFilial("SD4") + cRefer))
				lRet := .F.
				Help(NIL, NIL, "REFEXIST", NIL, "Referência " + cRefer + " já utilizada.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Altere o campo para a próxima referência disponível: " + Soma1(GetMv("MV_MSREFER")) })
			Endif

		CASE !Empty(cRefer) .And. SubStr(cOpcao,1,1) == "2"

			SD4->(DbSetOrder(11))
			If !SD4->(DbSeek(xFilial("SD4") + cRefer))
				lRet := .F.
				Help(NIL, NIL, "REFNOTFOUND", NIL, "Referência " + cRefer + " não encontrada!", 1, 0)
			Endif

			While lRet .And. !SD4->(Eof()) .And. Alltrim(SD4->D4_MSREFER) == Alltrim(cRefer)
				If SD4->D4_QUANT > 0
					nItens++
				EndIf
				SD4->(DbSkip())
			EndDo

			If lRet .And. nItens == 0
				lRet := .F.
				Help(NIL, NIL, "REFSEPARA", NIL, "Referência " + cRefer + " já foi separada!", 1, 0, NIL, NIL, NIL, NIL, NIL, {'A substituição não ocorre para referências já separadas.'})
			EndIf

		CASE SubStr(cOpcao,1,1) == "3"
			U_GeraRel()

	ENDCASE

Return lRet

//Valida a Ordem de Produção
Static Function ValidaOP()

Local lRet	:= .T.
	
	If !Empty(cOP)
		
		SD4->(DbSetOrder(2))
		If SD4->(DbSeek(xFilial("SD4")+Alltrim(cOP)))
			
			SC2->(DbSetOrder(1))
			If SC2->(DbSeek(xFilial("SC2")+Alltrim(cOP)))
				
				If !Empty(SC2->C2_DATRF)
					lRet := .F.
					FwAlertError("Ordem de Produção já encerrada")
				Else
					If SC2->C2_MSLISTA <> "S" .And. Substr(cOpcao,1,1) == "1"
						If !FwAlertYesNo('Esta OP não é Lista - Aglutinar?')
							lRet := .F.
						EndIf
					Endif
					
					If SC2->C2_DATPRI - dDataBase > 4
						lRet := .F.
						FwAlertError("Inicio Previsto maior que 4 dias. Data Prevista: " + DTOC(SC2->C2_DATPRI))
					EndIf
				
				EndIf
			Else
				lRet := .F.
				FwAlertError("Ordem de Produção não encontrada")
			EndIf
		Else
			lRet := .F.
			FwAlertError("Empenhos da Ordem de Produção não encontrados")
		EndIf
		
		If lRet .And. Substr(cOpcao,1,1) == "1"
			
			Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_OP) == Alltrim(cOP)
				If SD4->D4_QUANT > 0 .And. !Empty(SD4->D4_MSREFER)
					lRet := .F.
					cOP  := Space(11)
					FwAlertError('Empenhos não encontrados OU Referência já existente para a OP ' + SD4->D4_OP)
					Exit
				EndIf
				SD4->(DbSkip())
			EndDo

		EndIf

		If lRet .And. SubStr(cOpcao,1,1) == '2' .And. Empty(cRefer) .And. !Empty(cOp)
			
			dbSelectArea('SC2')
			SC2->(dbSetOrder(1))
			
			dbSelectArea('SD4')
			SD4->(dbSetOrder(2))
			
			If SC2->(dbSeek( xFilial("SC2") + cOP )) .And. SD4->(dbSeek( xFilial("SD4") + cOP )) .And. !Empty(SC2->C2_MSREFER)
				If FwAlertYesNo('Remover a Referência '+SC2->C2_MSREFER+' da OP ' + ALLTRIM(cOP) + '?')
					
					While SC2->(!EOF()) .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) == cOP
						If Reclock('SC2',.F.)
							SC2->C2_MSREFER := SPACE(TamSx3('C2_MSREFER')[1])
							SC2->(MsUnlock())
						Endif
						SC2->(dbSkip())
					Enddo

					While SD4->(!EOF()) .And. SD4->D4_FILIAL == xFilial("SD4") .And. SD4->D4_OP == cOP
						If Reclock('SD4',.F.)
							SD4->D4_MSREFER := SPACE(TamSx3('D4_MSREFER')[1])
							SD4->(MsUnlock())
						Endif
						SD4->(dbSkip())
					Enddo

				EndIf
			Endif

		Endif
	
	EndIf
	
	cGrupo := Space(4)

Return lRet

//*******************************
	Static Function VerGrupo()
//*******************************
Local cLista := ""
If Alltrim(cGrupo) <> ""
	SBM->(DbSetOrder(1))
	If !SBM->(DbSeek(xFilial("SBM")+Alltrim(cGrupo)))
		ApMsgStop("Grupo invalido")
		Return .F.
	EndIf
EndIf
If Alltrim(cOP) <> ""
	If Alltrim(cGrupo) == ""
		cGrupo := "**" + Space(2)
	EndIf
	cLista := Alltrim(cOP) + " - " + Alltrim(cGrupo)
	If ASCAN(aOPs,cLista) == 0
		AADD(aOps,cLista)
	Else
		FwAlertWarning("Ordem de Produção/Grupo ja escolhida")
		oOP:SetFocus()
	EndIf
EndIf
oOP:SetFocus()
Return .T.

//*******************************
	Static Function ExibeOP()
//*******************************
If SubStr(cOpcao,1,1) <> "3"
	If Len(aOps) > 0
		DEFINE MSDIALOG _oDlg FROM 0,0 TO 550,240 PIXEL TITLE "Aglutina as Ops?"
		oList1:= tListBox():New(10,10,{|u|if(Pcount()>0,nList1:=u,nList1)},aOPs,060,240,,_oDlg,,,,.T.)
		@ 100,075 BUTTON "Remove OP" SIZE 35,12 ACTION U_DelOP()
		@ 120,075 BUTTON "Adiciona OP" SIZE 35,12 ACTION U_AddOP()
		@ 140,075 BUTTON "Grava Referencia" SIZE 45,12 ACTION U_AtuRefer()
		ACTIVATE MSDIALOG _oDlg
	Else
		FwAlertWarning("Não há OPs para Aglunitanação - Verifique")
	EndIf
EndIf
Return Nil

//*******************************
	User Function AddOP()
//*******************************

_oDlg:End()
oOP:SetFocus()
Return

User Function DelOP()
oList1:Del(nList1)
oList1:Refresh()
Return

//*******************************
	User Function AtuRefer()
//*******************************
Local cNumOP := ""
Local cGrp   := ""
Local I

_lAtu := .F.
For I := 1 To Len(aOps)
	cNumOP := SubStr(aOPs[I],1,11)
	cGrp   := SubStr(aOps[I],15,4)
	SD4->(DbSeek(xFilial("SD4")+cNumOP))
	nItens := 0
	Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_OP) == Alltrim(cNumOP)
		If SD4->D4_QUANT > 0
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+Alltrim(SD4->D4_COD)))
			If Alltrim(cGrp) == "**" .Or. Alltrim(SB1->B1_GRUPO) == Alltrim(cGrp)
//				If (SubStr(cOpcao,1,1) == "1" .And. Empty(SD4->D4_MSREFER)) .Or. SubStr(cOpcao,1,1) == "2"
				If SubStr(cOpcao,1,1) $ "1|2"
					RecLock("SD4",.F.)
					//VICTOR DESSUNTE - 06/03/2017
					//INICIO - TICKET:2017020737000133
					If SM0->M0_CODIGO == '10'
						SD4->D4_XITREFE	:= cItRef
					EndIf
					//FIM - TICKET:2017020737000133
					SD4->D4_MSREFER := cRefer
					SD4->(MsUnlock())
					nItens++
					_lAtu := .T.
				EndIf
			EndIf
		EndIf
		SD4->(DbSkip())
	EndDo
	If nItens > 0
		SC2->(DbSetOrder(1))
		If SC2->(DbSeek(xFilial("SC2")+cNumOP))
			If SubStr(cOpcao,1,1) == "1" .And. Empty(SC2->C2_MSREFER)
				RecLock("SC2",.F.)
				SC2->C2_MSREFER := cRefer
				SC2->(MsUnlock())
			EndIf
		EndIf
	Else
		FwAlertError("Itens da OP (EMPENHO) " + cNumOP + " nao satisfazem o criterio para aglutinacao.")
	EndIf
Next I
If _lAtu
	FwAlertSuccess("Referencia OK")
	PutMV("MV_MSREFER",cRefer)
Else
//	cRefer := StrZero( Val(cRefer) - 1, 6 )
//	PutMV("MV_MSREFER",cRefer)
	FwAlertError("Não gravou Referencia - Verifique as OPs")
EndIf
aOps := {}
_oDlg:End()
Return

// Imprime a lista de referência
User Function GeraRel()

Local aCampos := {}
Local I 
Local oTable  := Nil

If Empty(cRefer)
	FwAlertError("Processamento será cancelado - Verifique as informações")
	Return
EndIf

If !Pergunte(cPerg,.T.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{ "OP"        ,"C",13,0} )
If cEmpAnt == '10'
	AADD(aCampos,{ "ITEM"      ,"C",10,0})
EndIf
AADD(aCampos,{ "CLIENTE"   ,"C",15,0} )
AADD(aCampos,{ "PRODUTO"   ,"C",15,0} )
AADD(aCampos,{ "MODIF"     ,"C",02,0} )
AADD(aCampos,{ "LOCALP"    ,"C",08,0} )
AADD(aCampos,{ "DESCRI"      ,"C",35,0} )
AADD(aCampos,{ "COR"       ,"C",3,0} )

oTable  := FwTemporaryTable():New("TRB")
oTable:SetFields(aCampos)
oTable:AddIndex( "IND1", {"OP"} )
oTable:Create()

nItens := 0
SC5->(DbSetOrder(1))
SD4->(DbSetOrder(11))
If SD4->(DbSeek(xFilial("SD4")+cRefer))
	Do While !SD4->(Eof()) .And. Alltrim(SD4->D4_MSREFER) == Alltrim(cRefer)
		If SD4->D4_QUANT > 0
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+Alltrim(SD4->D4_COD)))
			cLocal := Rtrim(SB1->B1_LOCAL)
			If !(Substr(cLocal,1,1) $ "0_1") .Or. (SubStr(cLocal,1,1) == "0" .AND. Len(cLocal) <= 4)
				If Len(cLocal) < 7 .Or. SubStr(cLocal,1,1) == "G"
					cDesenho := Alltrim(SD4->D4_COD) + Alltrim(SB1->B1_REVATU)
					_cPath := "H:\PLOTTER\"
					If Substr(cNumEmp,1,2) == "01"
						If Substr(cDesenho,1,2) == "CL"
							_cPath += Substr(cDesenho,3,2) + "\"
						Else
							_cPath += Substr(cDesenho,1,2) + "\"
						EndIf
					ElseIf Substr(cNumEmp,1,2) == "10"
						_cPath += Substr(cDesenho,1,3) + "\"
					EndIf
					If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
						AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
						AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
						AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
					EndIf
				EndIf
			EndIf
			SC2->(DbSetOrder(1))
			If SC2->(DbSeek(xFilial("SC2")+SD4->D4_OP))
				If !(TRB->(DbSeek(SD4->D4_OP)))
					RecLock("TRB",.T.)
					TRB->OP     := SD4->D4_OP

					//VICTOR DESSUNTE - 06/03/2017
					//INICIO - TICKET:2017020737000133
					If SM0->M0_CODIGO == '10'
						TRB->ITEM	:= SD4->D4_XITREFE
					EndIf
					//FIM - TICKET:2017020737000133
					
					TRB->CLIENTE := SC2->C2_MSREDUZ
					TRB->PRODUTO := SC2->C2_PRODUTO
					If SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
						TRB->MODIF  := SB1->B1_REVATU
						TRB->DESCRI   := SB1->B1_DESC
						TRB->LOCALP := SB1->B1_LOCAL
					EndIf
					If SC5->(DbSeek(xFilial("SC5")+SC2->C2_MSPED))
						TRB->COR := SC5->C5_COR
					EndIf
					RecLock("SD4",.F.)
					SD4->D4_MSIMPRE := "X"
					SD4->(MsUnlock())
					TRB->(MSUnLock())
					nItens++
				EndIf
			EndIf
		EndIf
		SD4->(DbSkip())
	EndDo
EndIf

If nItens == 0
	ApMsgStop("Referencia nao encontrada ou ja baixada!")
EndIf

dbCommitAll()

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,,,,.F.,,,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
Li 	     := 80

Titulo  := "Resumo de OP p/Separação no Almoxarifado - Ref. "

cabec1  := "  OP                    CLIENTE             PRODUTO            DESCRIÇÃO                               LOCAL       COR"

DbSelectArea("TRB")
dbGoTop()

Do While !TRB->(EOF())
	
	If Li > 60
		Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,15)
		Li++
		@Li,040 Psay "*****  REFERENCIA: "+ cRefer + '-' + cItRef + "  *****"
		Li+=2
		@ Li,020 Psay "*** ORDENS DE PRODUÇÃO DIGITADAS - ITENS A SEPARAR NO ALMOXARIFADO ***"
		Li+=2
	EndIf
	
	@ Li,001 Psay TRB->OP
	@ Li,024 Psay TRB->CLIENTE
	@ Li,044 Psay TRB->PRODUTO
	@ Li,063 Psay TRB->DESCRI
	@ Li,104 Psay TRB->LOCALP

	If TRB->COR == "TIT"
		@ Li,115 Psay "TITANIO"
	ElseIf TRB->COR == "BCO"
		@ Li,115 Psay  "BRANCO"
	ElseIf TRB->COR == "PRE"
		@ Li,115 Psay "PRETO"
	ElseIf TRB->COR == "AMA"
		@ Li,115 Psay "AMARELO"
	ElseIf TRB->COR == "AZU"
		@ Li,115 Psay "AZUL"
	ElseIf TRB->COR == "VRD"
		@ Li,115 Psay "VERDE"
	EndIf
	Li++

	dbSelectArea("TRB")
	TRB->(dbSkip())

EndDo

If Li >= 54
	Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,15)
ENDIF

@ 055,040 Psay "Data da Separacao: ____/____/____."
@ 057,040 Psay "Hora da Separacao: ____:____"
@ 059,040 Psay "      Responsavel: ________________________________"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

If aReturn[5] > 1 .And. mv_par01 == 1
	For I := 1 TO Len(aDesenhos)
		WaitRun(aDesenhos[I])
	Next I
EndIf

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return
