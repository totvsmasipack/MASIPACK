#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ SF1100I  ºAutor  ³                                                          ³ 15/01/2001 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc:     Cadastra o nome reduzido do fornecedor/cliente no cabecalho da NF de Entrada                ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±                                           ALTERAÇÕES                                                  ±±
±± Data        Autor                 Descrição                                                           ±±
±± 18/02/2008  Aparecida Stevanato   Atualização dos Estoques (SB1,SB2) - Geração SZ8 -NFEntrada         ±±
±± 27/03/2008  Solange Vezú          Lanctos C.de Credito (Alimenta SE2 para NF c/Serie=ND e Doc="CC")   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function SF1100I

Local AtuEstoque := ""
Local cNatur     := ""
Local cDescTes   := ""

IF !(SUBSTR(cNumEmp,1,2) $ "15_04")
	RecLock("SF1")
	IF sf1->f1_tipo $ "NIPC"
		sf1->f1_nreduz := sa2->a2_nreduz
		cNatur         := sa2->a2_naturez
	ELSE
		sf1->f1_nreduz := sa1->a1_nreduz
		cNatur         := sa1->a1_naturez
	ENDIF
	SF1->(MsUnlock())
	
	// ************** Atualização dos Estoques (SB1, SB2, SZ8) **************
	If  SubStr(cNumEmp,1,2) <> "15"
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		If SubStr(SD1->D1_DOC,1,2) <> "CC"      // CC - entradas das despesas com cartão de credito
			Do While ! SD1->(Eof()) .And. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA
				If SD1->D1_MSSZ8 <> "X"
					SF4->(DbSetOrder(1))
					cDescTes := ""
					If SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))
						cDescTes := SF4->F4_DESCRIC
						AtuEstoque := SF4->F4_ESTOQUE
					EndIf  
					
					dbselectarea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD+"01"))
					RecLock("SB1",.F.)
					SB1->B1_CUSTD := (SD1->D1_CUSTO/SD1->D1_QUANT)
					If AtuEstoque == "S"  .AND. SD1->D1_LOCAL <> '10' .AND. SD1->D1_LOCAL <> '95'   // LABORTUBE 26/03/14

					Else
						AtuEstoque := "N"
					EndIf
					SB1->(MsUnLock()) 
				EndIf
				RecLock("SD1",.F.)
				SD1->D1_MSSZ8  := "X"
				SD1->D1_MSUSER := UsrRetName(RetCodUsr())
				SD1->D1_MSOBS  := SUBSTR(SD1->D1_MSOBS,1,1)+"SF1100I - ENTRADA POR NF - " + cDescTes
				SD1->(MsUnLock())
				SD1->(dbSkip())
			EndDo
		EndIf
	EndIf
ENDIF 
RecLock("SF1",.F.)
	SF1->F1_HORA  := TIME()
SF1->(MsUnLock())
Return
