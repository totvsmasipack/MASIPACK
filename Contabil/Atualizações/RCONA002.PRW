#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCONA002  �Autor  � Lizandra Marques       �Data � 31/08/12 ���
�������������������������������������������������������������������������͹��
���Desc.     � atualiza codigo de atividade i inss patronal no b5         ���
���          � de acordo com a classificacao fiscal (SYD)                 ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

User Function RCONA002()

If apmsgYesNo("Confirma Atualiza��o da tabela Complemento de produtos?")
	
	MsgRun("Atualizando !!!!",, { || AlteraSB5() })
	
EndIf

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AlteraSB5  �Autor  � Lizandra marques  � Data �  31/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetiva altera��o no SB5                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AlteraSB5()

SB1->(DbSetOrder(1))
SB1->(DBGotop())
Do While ! SB1->(Eof())
	IF !EMPTY(SB1->B1_POSIPI)
		IF SB5->(dbSeek(xFilial("SB5") + SB1->B1_COD))
			SYD->(DbSetOrder(1))
			IF SYD->(DbSeek(xFilial("SYD")+SB1->B1_POSIPI))
				RecLock("SB5",.F.)
				SB5->B5_INSPAT := SYD->YD_MSPORTA
				SB5->B5_CODATIV:= SYD->YD_MSCATIV
			ENDIF
		ELSE
			SYD->(DbSetOrder(1))
			IF SYD->(DbSeek(xFilial("SYD")+SB1->B1_POSIPI))
				RecLock("SB5",.T.)
				SB5->B5_FILIAL  := xFilial("SB5")
				SB5->B5_COD     := SB1->B1_COD
				//Ivandro Santos - 12/04/17
				//Ticket#2017031037000107 � Equaliza��o dos campos de descri��o do produto (Masipack e Fabrima)
				SB5->B5_CEME    := SB1->B1_DESC
				//SB5->B5_CEME  := IIF(!Empty(SB1->B1_DESCP),SB1->B1_DESCP,SB1->B1_DESC)
				//Ticket#2017031037000107 � Fim da altera��o
				SB5->B5_INSPAT  := SYD->YD_MSPORTA
				SB5->B5_CODATIV := SYD->YD_MSCATIV
			ENDIF	
		ENDIF
		SB5->(MsUnlock())
	ENDIF
	SB1->(DbSetOrder(1))
	SB1->(dbSKip())
EndDo

Return
