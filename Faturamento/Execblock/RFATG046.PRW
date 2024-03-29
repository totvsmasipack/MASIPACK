#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG046  �Autor  �Eduardo Bego Mantoan	 Data �  29/10/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida TS no B1 de acordo com o NCM                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG046()

Local _aAreaSA1 := SA1->(GetArea())
Local _lRet		:= .T.

	SA1->(DbSetOrder(1))
	IF SA1->(dbSeek(xFilial("SA1")+M->C5_CLIENTE))   
		If SA1->A1_EST $ 'AM/RR/RO/AC/AP' .And. !Empty(SA1->A1_SUFRAMA)
			Help(" ",1,"",,"Cliente possui benef�cio SUFRAMA.",4,5) 
		Endif

		If !Empty(SA1->A1_PRF_OBS)
			Aviso("Obs. Cliente",SA1->A1_PRF_OBS,{"Fechar"})
		Endif

		If !Empty(SA1->A1_MS_INF)
			Aviso("Inf. Cliente",SA1->A1_MS_INF,{"Fechar"})
		Endif
	ENDIF

	RestArea(_aAreaSA1)

Return _lRet