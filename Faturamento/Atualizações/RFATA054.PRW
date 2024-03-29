#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� PROGRAMA     �   RFATA054      � AUTOR � FABIO MARCELO DIAS    � DATA �  24/08/11   ���
���������������������������������������������������������������������������������������͹��
��� DESCRICAO    � PROGRAMA PARA APRESENTAR A DATA DE VIGENCIA DA TABELA DE PRECOS      ���
���              � NO CAMPO CK_MSDTVIG (INCLUSAO/ALTERACAO ORCAMENTOS)                  ���
���              � IRA ATUAR EM CONJUNTO COM O GATILHO CK_PRODUTO SEQUENCIA 012         ���
���������������������������������������������������������������������������������������͹��
��� TABS.UTILIZ  � DESCRICAO                                                   � ACESSO ���
���������������������������������������������������������������������������������������͹��
���    SCJ       � CABECALHO ORCAMENTO                                         � READ   ���
���    SCK       � ITENS ORCAMENTO                                             � READ   ���
���    DA0       � TABELA DE PRECOS                                            � READ   ���
���    DA1       � ITENS DA TABELA DE PRECOS                                   � READ   ���
���������������������������������������������������������������������������������������͹��
��� HISTORICO    � 24/08/2011 CRIA��O ESPECIFICA P/ FABRIMA (EMPRESA 10).               ���
���              �                                                                      ���
���������������������������������������������������������������������������������������͹��
��� USO          � MODULO FATURAMENTO                                                   ���
���������������������������������������������������������������������������������������͹��
��� PROPRIETARIO � CUSTOMIZADO PARA MASIPACK                                            ���
���������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
/*/

USER FUNCTION RFATA054()

	LOCAL CTABELA	:= M->CJ_TABELA
	LOCAL CPRODUTO	:= M->CK_PRODUTO
	LOCAL AAREADA0	:= DA0->(GETAREA())
	LOCAL AAREADA1	:= DA1->(GETAREA())
	LOCAL DDTVIG
	
	DBSELECTAREA("DA1")
	DA1->(DBSETORDER(1))
	DA1->(DBGOTOP())

	IF DA1->(DBSEEK(XFILIAL("DA1")+CTABELA+CPRODUTO))
		DDTVIG := DA1->DA1_DATVIG
	ELSE
		DDTVIG := CTOD("  /  /  ")
	ENDIF

	RESTAREA(AAREADA0)
	RESTAREA(AAREADA1)

RETURN(DDTVIG)