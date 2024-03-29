#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �RFATA045  �Autor  �Aparecida F.Stevanato � Data �  08/07/10 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza Situa��o do Or�amento de Maquinas (CJ_MSSTAT)      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA045()

cOrcam    := Space(20)
cStatus   := Space(1)
cStaAtu   := Space(1)
cMotPerda := Space(60)
_fRet     := .F.

@ 089,195 To 380,600 Dialog _oDlg1 Title OemToAnsi("Vendas - Status do Or�amento")
@ 009,011 To 035,198
@ 030,011 To 135,198
@ 015,024 Say OemToAnsi("Esta rotina Atualiza Status do Or�amento")   Size 151,010
@ 050,024 Say OemToAnsi("Or�amento.............: ") 				  Size 055,006
@ 065,024 Say OemToAnsi("Status Atual...........:")   				  Size 055,006
@ 080,024 Say OemToAnsi("Novo Status............:")          	      Size 055,006
@ 095,024 Say OemToAnsi("Motivo da Perda..:")   				      Size 055,006
@ 050,066 Get cOrcam  Valid ValidaOrcam()                              Size 055,008 OBJECT oOrcam
@ 065,066 Get cStaAtu Valid ValidaAtu()                               Size 020,008
@ 080,066 Get cStatus F3 "Z5" Valid ValidaStatus()                   Size 020,008 OBJECT oStatus
@ 095,066 Get cMotPerda Valid ValMotivo()                             Size 130,008 OBJECT oMotPerda
@ 115,110 BmpButton Type 1 Action Processa( { || AtuOrcam() } )
@ 115,140 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1 centered

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �AtuOrcam     �  Atualiza Status do Orcamento                ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuOrcam()

If !Empty(cStatus)
	If Alltrim(cStatus) == "P" .And. Alltrim(cMotPerda) == ""
		ApMsgAlert("Informe o Motivo da Perda !!!")
		oMotPerda:SetFocus()
	Else
		If ! apMsgYesNo("Confirma Atualiza��o do Or�amento?")
			Return
		EndIf
		RecLock("SCJ",.F.)
		SCJ->CJ_MSMOTPE := Alltrim(cMotPerda)
		SCJ->CJ_STATUS  := cStatus
		SCJ->(MsUnlock())
	EndIf
Else
	ApMsgStop("Status n�o pode estar em branco!!!")
EndIf
_fRet     := .T.
cOrcam    := Space(20)
cStatus   := Space(6)
cStaAtu   := Space(6)
cMotPerda := Space(60)
oOrcam:SetFocus()
Return

Static Function ValidaOrcam()
SCJ->(DbSetOrder(1))
If SCJ->(DbSeek(xFilial("SCJ")+ALLTRIM(cOrcam)))
	If Alltrim(SCJ->CJ_STATUS) == "B"
		ApMsgStop("Or�amento j� concretizado !!!")
		_fRet := .F.
	Else
		cStaAtu := SCJ->CJ_STATUS
		cMotPerda := SCJ->CJ_MSMOTPE
		_fRet := .T.
	EndIf
Else
	SCJ->(DbSetOrder(6))
	If SCJ->(DbSeek(xFilial("SCJ")+ALLTRIM(cOrcam)))
		If Alltrim(SCJ->CJ_STATUS) == "B"
			ApMsgStop("Or�amento j� concretizado !!!")
			_fRet := .F.
		Else
			cStaAtu := SCJ->CJ_STATUS
			cMotPerda := SCJ->CJ_MSMOTPE
			_fRet := .T.
		EndIf
	ELSE	
		ApMsgStop("Or�amento n�o encontrado !!!")
		_fRet := .F.
	ENDIF	
EndIf
If _fRet
	oStatus:SetFocus()
Endif
Return _fRet

Static Function ValidaStatus()
cStatus := Upper(cStatus)
If !(Alltrim(cStatus) $ " _C_F_X_D_P")
	ApMsgStop("Status do or�amento invalido  !!!")
	_fRet := .F.
Else
	_fRet := .T.
EndIf
cMotPerda := Space(60)
Return _fRet

Static Function ValMotivo()
If Alltrim(cStatus) == "P"
	If Alltrim(cMotPerda) == ""
		ApMsgStop("Informe o Motivo da Perda !!!")
		_fRet := .F.
	EndIf
Else
	cMotPerda := Space(60)
EndIf
Return _fRet      	   
