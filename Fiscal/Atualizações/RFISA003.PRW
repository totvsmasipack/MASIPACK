#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFISA003  �Autor  �Lizandra Marques    � Data �  13/08/14   ���
�������������������������������������������������������������������������͹��
���Desc. � Altera NCM do produto (no x3 campo est-a para visualizar).      ��
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFISA003()

cCadastro := ""
aRotina   := { {"Pesquisa",     "AxPesqui",           0, 1 },;
{"Visualiza",    "AxVisual",           0, 2 },;
{"Altera",  "U_TelaSB1()", 0, 3 } }


mBrowse(8,03,20,75,"SB1",,,,)
return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fAlteraB1�Autor  �Lizandra Marques    � Data �   13/08/14  ���
�������������������������������������������������������������������������͹��
���Desc. Altera NCM e atualiza IPI e ICMS no cadastro do produto.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TelaSB1()


_cProd := SB1->B1_COD     //Space(15)
_cNCM  := SB1->B1_POSIPI  //Space(08)
_cGRT  := SB1->B1_GRTRIB

@ 080,153 To 352,584 Dialog _oDlg1 Title OemToAnsi("Alterar��o de NCM - SB1.")
@ 012,016 To 103,198 Title OemToAnsi("Alterar")
@ 032,034 Say OemToAnsi("Produto")		 		Size 60,8
@ 051,035 Say OemToAnsi("NCM"    )		 		Size 59,8
@ 070,035 Say OemToAnsi("Grupo Tributario" )	Size 59,8
@ 032,105 Get _cProd F3 "SB1" 					Size 50,10
@ 051,105 Get _cNCM  F3 "SYD" 					Size 37,10
@ 070,105 Get _cGRT  F3 "21"  					Size 37,10
@ 115,090 BmpButton Type 1 Action U_fGravaB1()
@ 115,157 BmpButton Type 2 Action Close(_oDlg1)
Activate Dialog _oDlg1

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fAlteraB1�Autor  �Lizandra Marques    � Data �   13/08/14  ���
�������������������������������������������������������������������������͹��
���Desc. Altera NCM e atualiza IPI e ICMS no cadastro do produto.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function _fAlteraB1()


MsgRun("Atualizando!",, { || _fGravaB1() })

Return
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_fGravaB1 �Autor  �Lizandra Marques    � Data �  13/08/14   ���
�������������������������������������������������������������������������͹��
���Desc. Funcao para gravar NCM, IPI e ICMS.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fGravaB1()


If !apmsgYESNO("Confirma a alteracao ?")
	Return
EndIf

SYD->(DbSetOrder(1))
IF SYD->(DbSeek(xFilial("SYD")+_cNCM))
	nPercICM := SYD->YD_ICMS_RE
	nPercIPI := SYD->YD_PER_IPI
	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	IF SB1->(DbSeek(xFilial("SB1")+_cProd))
		IF SUBSTR(cNumEmp,1,2) <> '15'
			IF !EMPTY(SB1->B1_POSIPI)
				apmsgAlert("Produto j� atualizado anteriormente.")
			ENDIF
			RecLock("SB1",.F.)
			SB1->B1_IPI   := nPercIPI
			SB1->B1_PICM  := nPercICM
			SB1->B1_POSIPI:= _cNCM
			SB1->B1_GRTRIB:= _cGRT
			SB1->B1_MSNCM := "SIM"
			SB1->(MsUnLock())

			RecLock("SB5",.F.)
			SB5->B5_INSPAT := SYD->YD_MSPORTA
			SB5->B5_CODATIV:= SYD->YD_MSCATIV
			SB1->(MsUnLock())
		ELSE
			RecLock("SB1",.F.)
			SB1->B1_IPI   := nPercIPI
			SB1->B1_PICM  := nPercICM
			SB1->B1_POSIPI:= _cNCM
			SB1->B1_GRTRIB:= _cGRT
			SB1->(MsUnLock())

			RecLock("SB5",.F.)
			SB5->B5_INSPAT := SYD->YD_MSPORTA
			SB5->B5_CODATIV:= SYD->YD_MSCATIV
			SB1->(MsUnLock())
		ENDIF
	ELSE
		apMsgYesNo("Produto n�o existe.")
	ENDIF
ELSE
	apMsgYesNo("NCM n�o existe.")
ENDIF


Close(_oDlg1)

Return
