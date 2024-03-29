#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP820     �Autor  �Victor Dessunte     � Data �  12/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Lancamento padrao para permitir somente integracao dos     ���
���          � valores da depreciacao gerencial tipo 10                   ���
���          � Calculo e Descalculo do Ativo                              ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP820(_cTp,_cCd)

Local _xRet

If SN3->N3_TIPO <> '10' //GERENCIAL
	Return
EndIf

If _cCd == '1' //CALCULO
	If _cTp == '1' //DEBITO
		_xRet := SN3->N3_CDEPREC
	ElseIf _cTp == '2' //CREDITO
		_xRet := SN3->N3_CCDEPR
	Else //VALOR
		_xRet := SN4->N4_VLROC1
	EndIf
Else //DESCALCULO
	If _cTp == '1' //DEBITO
		_xRet := SN3->N3_CCDEPR
	ElseIf _cTp == '2' //CREDITO
		_xRet := SN3->N3_CDEPREC
	Else //VALOR
		_xRet := SN4->N4_VLROC1
	EndIf
EndIf

Return _xRet