#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
                                                                                                              
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA064  �Autor  �Lizandra             � Data �  24/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Libera PV para almoxarifado separar.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA064()

Local I

Private fRet := .T. 
_cUsuario  := RetCodUsr()
_aUsuario  := {}
_cDeptoUsu := ""
_cGrupo    := ""
_aGrupos   := {}

          
_aArea := GetArea()       

PswOrder(1)
IF PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cDeptoUsu := UPPER(Alltrim(_aUsuario[1][12]))
	_aGrupos  := PswRet(1)[1][10]
	FOR I := 1 TO LEN(_aGrupos)
		_cGrupo += UPPER(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	NEXT I
	_cGrupo := SUBSTR(_cGrupo,1,LEN(_cGrupo)-1)
ENDIF

aOpcao   := {"Libera��o PV para almoxarifado"}
cOpcao   := Space(20)
cPedido  := Space(6)
cItem    := Space(2)
DEFINE MSDIALOG _oDlg1 FROM  090,1 TO 330,330 TITLE "Libera��o PV para almoxarifado" PIXEL  
@ 010,030 Say "Esta rotina libera PV para separa��o no estoque"      Size 151,010 OF _oDlg1 PIXEL
@ 020,000 Say Replicate("_",100)                                     Size 200,010 PIXEL COLOR CLR_HBLUE	
@ 055,024 Say "Pedido de Vendas : " 	  	    	               Size 055,006 PIXEL COLOR CLR_HBLUE	
@ 055,075 MsGet cPedido F3 "SC5"                                     Size 045,010 PIXEL OF _oDlg1
@ 095,080 BmpButton Type 1 Action Processa( { || AtuSC5() } )
@ 095,115 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1  Centered

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuSC5    �Autor  �Lizandra	           � Data �  10/24/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AtuSC5()

fInclui := .T.       
_cOBS   := ""
_cCOMENT:= ""
SC5->(DbSetOrder(1))

IF SC5->(dbSeek(xFilial("SC5")+cPedido))
	RecLock("SC5",.F.)
	SC5->C5_MSPRIOR := "2"    
	MsUnlock()                       

	IF SZM->(DbSeek(xFilial("SZM")+Alltrim(cPedido)))
		DO WHILE !SZM->(EOF()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(cPedido)
			cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
			IF "AUTORIZACAO P/ FABRICAR PV" $ cAux
				_cOBS   := SZM->ZM_OBS
				_cCOMENT:= SZM->ZM_COMENT
			ENDIF
			SZM->(dbSkip())
			Loop
		ENDDO
	ENDIF

	IF SZM->(DbSeek(xFilial("SZM")+Alltrim(cPedido)))
		DO WHILE !SZM->(EOF()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(cPedido)
			cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
			IF "LIBERACAO PV P/ FATURAMENTO" $ cAux
				_cOBS   := SZM->ZM_OBS
				_cCOMENT:= SZM->ZM_COMENT
				fInclui := .F.
			ENDIF
			SZM->(dbSkip())
			Loop
		ENDDO
	ENDIF         
	IF !fInclui  
		IF apmsgYesNo("J� existe um APV para esse pedido. Confirma inclus�o?")
			RecLock("SZM",.T.)
			SZM->ZM_FILIAL  := "01"
			SZM->ZM_PEDIDO  := SC5->C5_NUM
			SZM->ZM_MSCAT   := SC5->C5_MSCATEG
			SZM->ZM_CODCLI  := SC5->C5_CLIENTE
			SZM->ZM_LOJACLI := SC5->C5_LOJACLI
			SZM->ZM_CLIENTE := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
			SZM->ZM_DATA    := Date()
			SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
			SZM->ZM_DEPTO   := _cDeptoUsu
			SZM->ZM_ASSUNTO := "LIBPV"                   
			SX5->(DbGotop())
			If SX5->(DbSeek(xFilial("SX5")+"ZE"+SZM->ZM_ASSUNTO))
				SZM->ZM_NOASSUN := SubStr(X5DESCRI(),1,30)
			EndIf
			SZM->ZM_STATUS  := "A"
			SZM->ZM_EVENTO  := "LIBERACAO PV P/ FATURAMENTO."
			SZM->ZM_CODDEPT := "ALMOXI"
			SZM->ZM_DEPTDES := "205-ALMOXARIFADO"
			SZM->ZM_DTPREV  := Date() + 5
			SZM->ZM_INIMONT := SC5->C5_MSMONTA
			SZM->ZM_OBS	    := _cOBS +CHR(13)+CHR(10)+CHR(13)+CHR(10)+SC5->C5_MSOBSPN
			SZM->ZM_COMENT  := _cCOMENT
			SZM->(MsUnLock())
		ENDIF	
	ELSE	
		RecLock("SZM",.T.)
		SZM->ZM_FILIAL  := "01"
		SZM->ZM_PEDIDO  := SC5->C5_NUM
		SZM->ZM_MSCAT   := SC5->C5_MSCATEG
		SZM->ZM_CODCLI  := SC5->C5_CLIENTE
		SZM->ZM_LOJACLI := SC5->C5_LOJACLI
		SZM->ZM_CLIENTE := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
		SZM->ZM_DATA    := Date()
		SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
		SZM->ZM_DEPTO   := _cDeptoUsu
		SZM->ZM_ASSUNTO := "LIBPV"                   
		SX5->(DbGotop())
		If SX5->(DbSeek(xFilial("SX5")+"ZE"+SZM->ZM_ASSUNTO))
			SZM->ZM_NOASSUN := SubStr(X5DESCRI(),1,30)
		EndIf
		SZM->ZM_STATUS  := "A"
		SZM->ZM_EVENTO  := "LIBERACAO PV P/ FATURAMENTO."
		SZM->ZM_CODDEPT := "ALMOXI"
		SZM->ZM_DEPTDES := "205-ALMOXARIFADO"
		SZM->ZM_DTPREV  := Date() + 5
		SZM->ZM_INIMONT := SC5->C5_MSMONTA
		SZM->ZM_OBS	    := _cOBS+CHR(13)+CHR(10)+CHR(13)+CHR(10)+SC5->C5_MSOBSPN
		SZM->ZM_COMENT  := _cCOMENT
		SZM->(MsUnLock())
	ENDIF	
ELSE
	 apMsgStop("PV n�o encontrado")
ENDIF

Close(_oDlg1)

Return 