#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MyATFA030 � Autor � Eduardo F. Lima       � Data � 01/12/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exemplo de chamada do ATFA030 pela MSExecAuto() para        ���
���          �Baixa de ativos			                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       �SIGAATF                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RATFA002()
	Processa({|| RAT002B()},"Aguarde...","Efetuando Baixa...",.F.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RATFA002  �Autor  �Microsiga           � Data �  12/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RAT002B()

Local	_nX			:= 0
Local 	_cArq  		:= "C:\ATF\sobra_contabil.csv"
Local 	cLinha 		:= ""
Local	aAreaSN1	:= {}
Local	aAreaSN3	:= {}
Local	aDadosAuto	:= {}	// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
Private	lMsHelpAuto	:= .F.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log
Private	lMsErroAuto	:= .F.	// Determina se houve alguma inconsistencia na execucao da rotina em relacao aos

If !File(_cArq)
	MsgStop("O arquivo " + _cArq + " n�o foi encontrado. A importa��o ser� abortada!"," - ATENCAO")
	Return
EndIf

FT_FUSE(_cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	
	cLinha := FT_FREADLN()
	If cLinha == "        " .OR. cLinha = NIL
		ALERT("Fim de arquivo!")
		FT_FUSE()
		Return
	EndIf

	dbSelectArea("SN1")
	SN1->(dbSetOrder(1))
	SN1->(dbSeek(xFilial("SN1")+cLinha))
	
	aDadosAuto:= {	{'N3_CBASE'		,SubStr(cLinha,1,10)	, Nil},;// Codigo base do ativo
					{'N3_ITEM'		,SubStr(cLinha,11,4)	, Nil},;// Item sequencial do codigo base do ativo
					{'AUTDTBX'		,DDATABASE				, Nil},;// Dever� ser informada a data efetiva da baixa do Bem.
					{'AUTMOTBX'		,"06"					, Nil},;// Dever� ser informado o motivo da baixa. A tabela de motivos poder� ser alterado na rotina Tabela no m�dulo Configurador (tabela 16).
					{'AUTQUANT'		,SN1->N1_QUANTD			, Nil},;// Quantidade da baixa. Caso a baixa seja por valor, dever� ser informado 0(zero).Se for pela quantidade, o valor ser�    proporcionalizado pela quantidade baixa-da.
					{'AUTPERCBX'	,100					, Nil},;// Percentual do bem a ser baixado.
					{'AUTBXFILHOS'	,.F.					, Nil} }// Indica se deve ser efetuada a baixa dos filhos 
	
	lMsErroAuto := .F.
	MSExecAuto({|x, y, z| ATFA030(x, y, z)},aDadosAuto, 4)
	
	_nX++
	If lMsErroAuto
		_cErro := 'ERRO'+ALLTRIM(STR(_nX))+".txt"
		MostraErro("C:\ATF\ERROS BAIXAS\",_cErro)
	Else
		aAreaSN1 := SN1->(GetArea())
		aAreaSN3 := SN3->(GetArea())
		RecLock("SN1",.F.)
		SN1->N1_XFDC := "BAIXADO PELA FDC"
		SN1->(MsUnlock())

		dbSelectArea("SN3")
		SN3->(dbSetOrder(1))
		If SN3->(dbSeek(xFilial("SN3")+cLinha))
			RecLock("SN3",.F.)
			SN3->N3_XFDC := "BAIXADO PELA FDC"
			SN3->(MsUnlock())
		EndIf
		RestArea(aAreaSN1)
		RestArea(aAreaSN3)
	EndIf
	
	FT_FSKIP()
EndDo

FT_FUSE()

ApMsgInfo("Importa��o conclu�da!")

Return
