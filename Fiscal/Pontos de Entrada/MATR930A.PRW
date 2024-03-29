
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATR930A  �Autor  �Ivandro Santos      � Data �  03/09/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para registra no relat�rio Registro de     ���
���          �Processamento de dados o valor do ICMS Simples Nacional     ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack - Fiscal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
//���������������������������������������������������������������������P�
//�Ponto de entrada criado para atender ao Fiscal                      �
//�Ticket#2017011937000256 � Campo para Lan�ar ICMS de Simples Nacional�
//���������������������������������������������������������������������P�
*/
User Function MATR930A
Local _aArea 	:= GetArea()
Local aOBSERV := ParamIXB[1]  //Array contendo as observa��es geradas no sistema                                                            
//aOBSERV[1][1] => Observa��o a ser impressa                                                            
//aOBSERV[1][2] => .T.  - Imprime no Relat�rio   e .F. - N�o Imprime no Relat�rio 
cAlias := Alias()
dbSelectArea("SF1")
dbSetOrder(1)
If dbSeek( xFilial("SF1") + (cAlias)->F3_NFISCAL + (cAlias)->F3_SERIE + (cAlias)->F3_CLIEFOR + (cAlias)->F3_LOJA ) .And. (cAlias)->F3_OBSICM > 0 .And. (cAlias)->F3_ESTADO <> "EX"
	aOBSERV := {}
	AADD(aOBSERV,{"CREDITO ICMS",.T.})
	AADD(aOBSERV,{"SIMPLES",.T.})
	AADD(aOBSERV,{"NACIONAL:",.T.})
	cRet := Alltrim(TransForm(SF1->F1_VALICM,PesqPict("SF1","F1_VALICM")))
	AADD(aOBSERV,{cRet,.T.})
EndIf 
RestArea(_aArea)
Return aOBSERV
