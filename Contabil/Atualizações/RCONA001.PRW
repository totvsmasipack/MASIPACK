#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCONA001  ºAutor  ³Aparecida de F.StevanatoºData  ³ 11/05/06    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para alterar Aliquota de IPI no Produto                 º±±
±±º          ³ de acordo com a classificacao fiscal (SYD)                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCONA001()

Private cArqCSV  := "C:\Relato_Microsiga\Clas_Fiscal.csv"
Private cRegCSV  := ""
Private nCSV     := 0
Private nPercIPI := 0
Private nPercICM := 0
Private I        := 0
Private nAlter   := 0
Private aPosIPI  := {}

If !apMsgYesNo("Confirma Atualização de IPI/ICMS no Cadastro de Produtos?")
	Return
EndIf

MsgRun("Atualizando !!!!",, { || AlteraImp() })

If nCSV > 0
	apmsgAlert("Verifique o arquivo com as Alterações efetuadas => C:\Relato_Microsiga\Clas_Fiscal.csv Alterados: "+Str(nCSV))
Else
	apmsgInfo("OK - Atualizações efetuadas com sucesso => Produtos corrigidos: "+Str(nAlter))
EndIf

Return

Static Function AlteraImp()

If (cArqCSV := FCreate(cArqCSV)) == -1
	apmsgStop("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
	cRegCSV := "Alterações Efetuadas no Cadastro de Produtos - NCM"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	cRegCSV := "POSIPI;PRODUTO;%IPI;%ICMS;Novo %IPI;Novo %ICMS"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) // Grava arquivo com as classificacoes fiscais nao encontradas no SYD
EndIf

SB1->(DbSetOrder(1))
SB1->(DBGotop())
Do While ! SB1->(Eof())
	nPercIPI := 0
	nPercICM := 0
	IF SUBSTR(cNumEmp,1,2) <> "15"
		If !Empty(SB1->B1_POSIPI)
			SYD->(DbSetOrder(1))
			If SYD->(DbSeek(xFilial("SYD")+SB1->B1_POSIPI))
				nPercICM := SYD->YD_ICMS_RE
				nPercIPI := SYD->YD_PER_IPI
				If SB1->B1_IPI <> nPercIPI .Or. SB1->B1_PICM <> nPercICM
					cRegCSV := SB1->B1_POSIPI+";_"+Alltrim(SB1->B1_COD) + "-" + Alltrim(SB1->B1_DESC)+";"+Str(SB1->B1_IPI,2)+";"+Str(SB1->B1_PICM,2)+";"+Str(nPercIPI)+";"+Str(nPercICM)
					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					nAlter++
				EndIf     
				RecLock("SB1",.F.)
				SB1->B1_IPI   := nPercIPI
				SB1->B1_PICM  := nPercICM
				If SYD->YD_BICMS == "S"
					If nPercICM < 18
						SB1->B1_GRTRIB := "001"
					Else
						SB1->B1_GRTRIB := "002"
					EndIf
					If SubStr(SB1->B1_PROCED,1,1) == "1"
						SB1->B1_TS := "804"
					Else
						SB1->B1_TS := "809"
					EndIf
				Else
					SB1->B1_GRTRIB := ""
					If SB1->B1_PICM > 0
						If SB1->B1_IPI == 0
							If SubStr(SB1->B1_PROCED,1,1) == "1"
								SB1->B1_TS := "882"
							Else
								SB1->B1_TS := "810"
							EndIf
						Else
							If SubStr(SB1->B1_PROCED,1,1) == "1"
//								If Alltrim(SB1->B1_UM) == "CJ"
// 									SB1->B1_TS := "803"
//								Else
									SB1->B1_TS := "802"
//								EndIf
							Else
								SB1->B1_TS := "807"
							EndIf
						EndIf
					EndIf
				EndIf
				SB1->(MsUnLock()) 
			Else
				cRegCSV := SB1->B1_POSIPI+";_"+Alltrim(SB1->B1_COD) + " - NCM nao cadastrado;"+Str(SB1->B1_IPI,2)+";"+Str(SB1->B1_PICM,2)
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
				RecLock("SB1",.F.)
				SB1->B1_POSIPI := ""
				SB1->B1_IPI    := 0
				SB1->B1_PICM   := 18
				SB1->B1_GRTRIB := ""
				SB1->(MsUnLock())
				nCSV++
			EndIf
		EndIf
	ELSE
		IF !EMPTY(SB1->B1_POSIPI)
			SYD->(DbSetOrder(1))
			IF SYD->(DbSeek(xFilial("SYD")+SB1->B1_POSIPI))
				nPercICM := SYD->YD_ICMS_RE
				nPercIPI := SYD->YD_PER_IPI
				IF SB1->B1_IPI <> nPercIPI .Or. SB1->B1_PICM <> nPercICM
					cRegCSV := SB1->B1_POSIPI+";_"+Alltrim(SB1->B1_COD) + "-" + Alltrim(SB1->B1_DESC)+";"+Str(SB1->B1_IPI,2)+";"+Str(SB1->B1_PICM,2)+";"+Str(nPercIPI)+";"+Str(nPercICM)
					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					nAlter++
				ENDIF
				RecLock("SB1",.F.)
				SB1->B1_IPI   := nPercIPI
				SB1->B1_PICM  := nPercICM
			ENDIF	
		ENDIF	
	ENDIF
	SB1->(DbSkip())
	Loop
EndDo
FClose(cArqCSV)
Return
