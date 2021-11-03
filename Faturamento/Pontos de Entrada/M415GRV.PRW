#include "rwmake.ch"
#include "Topconn.ch"
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ M415GRV    ºAutor  ³Aparecida F.Stevanato        10/03/2007º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.       Exclui Caracteristicas produto (SZJ)-Exclusão do Orcamento  ±±
±±º            Atualiza CJ_MSSTAT (Inclusão e Alteração)                   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function M415GRV()

Local I
Local cOrcam := ""
Local cNum   := ""
Local nTam   := 0
Local cRev   := ""
Local _lRet  := .t.

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	If !(Inclui .Or. Altera)    // Exclusão do orçamento
		SZJ->(dbSetOrder(1))
		If SZJ->(dbSeek(xFilial("SZJ")+SCJ->CJ_NUM))
			Do While ! SZJ->(Eof()) .And. SZJ->ZJ_NUM == SCJ->CJ_NUM
				RecLock("SZJ",.F.)
				SZJ->(DBDELETE())
				SZJ->(MsUnLock())
				SZJ->(DbSkip())
			Enddo
			_lRet:= .F.
		EndIf
	Else
		If ALTERA 
			RecLock("SCJ",.F.)
				SCJ->CJ_STATUS  := "A" 
				SCJ->CJ_MSLIBER := "N" 
				SCJ->CJ_MSUSULI := ""
				SCJ->CJ_MSDTLIB := CTOD("00/00/00")
		      SCJ->CJ_MSHOLIB := ""	
			SCJ->(MsUnLock())
		ElseIf INCLUI
			RecLock("SCJ",.F.)
				SCJ->CJ_STATUS	 := "A" 
				SCJ->CJ_MSLIBER := "N"
				IF M->CJ_MSTPVEN == 'RE'
					SCJ->CJ_MSBLQ   := 2 
				ELSE		
					SCJ->CJ_MSBLQ   := 1 	
				ENDIF	
			SCJ->(MsUnLock())
		EndIf
	EndIf
	
	If SubStr(cNumEmp,1,2) $ "01_10_11" .AND. _lRet
		
		If SubStr(SCJ->CJ_ORCAM,1,2) == "MB"   // Sómente para orçamento de máquinas
			// Necessario atualizar CJ_MSSTAT = "REV" p/ não Totalizar em duplicidade
			nTam := Len(Alltrim(SCJ->CJ_ORCAM))
			For I := 1 to nTam
				If SubStr(SCJ->CJ_ORCAM,I,1) == "/"
					cOrcam := SubStr(SCJ->CJ_ORCAM,1,I+2)
					Exit
				EndIf
			Next I
			If Select("QR1") > 0
				DbSelectArea("QR1")
				DbCloseArea()
			EndIf
			
			_cQuery := "SELECT CJ_ORCAM, CJ_NUM, CJ_MSSTAT "
			_cQuery += "FROM " + RetSqlName("SCJ") + " CJ "
			_cQuery += "WHERE CJ_FILIAL = '" + xFilial("SCJ") + "' AND CJ_ORCAM Like '%" + cOrcam + "%'"
			_cQuery += " AND D_E_L_E_T_ = ' ' "
			_cQuery += " ORDER BY CJ_NUM"
			
			DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
			
			Do While QR1->(!Eof())
				_cNum := QR1->CJ_NUM
				If QR1->CJ_MSSTAT <> "REV"
					cRev := QR1->CJ_MSSTAT
				EndIf
				QR1->(DbSkip())
			EndDo
			
			SCJ->(DbSetOrder(1))
			QR1->(DbGoTop())
			Do While QR1->(!Eof())
				If SCJ->(DbSeek(xFilial("SCJ")+QR1->CJ_NUM))
					Reclock("SCJ",.F.)
					If QR1->CJ_NUM <> _cNum
						If SCJ->CJ_MSSTAT <> "REV"
							SCJ->CJ_MSSTAT := "REV"
						EndIf
					Else
						SCJ->CJ_MSSTAT := cRev
					EndIf
					SCJ->(MsUnLock())
				EndIf
				QR1->(DbSkip())
			EndDo
		EndIf
	EndIf
ENDIF
Return
