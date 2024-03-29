#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP610D7   �Autor  � Ana Paula QFaustino� Data �  18/07/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento       ���
���          �padronizado 610 - Debito                                    ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/    

User Function LP610D7()

Private _cTipoNF, _cClaFis, _cConta

// Contabilizacao Nota Fiscal for de Servico ou Devolucao
// Lancamento Padrao 610

_cTipoNF  := (SD2->D2_TIPO)
_cClaFis  := (SD2->D2_CF)
_cProduto := (SD2->D2_COD)
_cConta   := ""

If SUBSTR(_cClaFis,2,1) <> '9'
	If _cTipoNF <> 'D'
		_cConta := "380010002"  // ICMS
	Else
		_cConta := POSICIONE("SB1",1,xFilial("SB1")+_cProduto,"B1_CONTA")
	EndIf
Else
	_cConta := "360010014" // ICMS
EndIf

Return(_cConta)
