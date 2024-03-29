#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� PROGRAMA     �   F240FIL        � AUTOR � FABIO MARCELO DIAS    � DATA �  07/01/11  ���
���������������������������������������������������������������������������������������͹��
��� DESCRICAO    � PROGRAMA PARA FILTRAR TITULOS NA GERA��O DO BORDERO A PAGAR          ���
���������������������������������������������������������������������������������������͹��
��� TABS.UTILIZ  � DESCRICAO                                                   � ACESSO ���
���������������������������������������������������������������������������������������͹��
���    SE2       � CONTAS A PAGAR                                              � READ   ���
���������������������������������������������������������������������������������������͹��
��� HISTORICO    � 07/01/2011 CRIA��O.                                                  ���
���              �                                                                      ���
���  		     �                                                                      ���
���������������������������������������������������������������������������������������͹��
��� USO          � MODULO FINANCEIRO                                                    ���
���������������������������������������������������������������������������������������͹��
��� PROPRIETARIO � CUSTOMIZADO PARA MASIPACK                                            ���
���������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
/*/

USER FUNCTION F240FIL()

	LOCAL AAREASEA	:= SEA->(GETAREA())
	LOCAL CMV_PAR01 := MV_PAR01		//ARMAZENO O CONTEUDO DOS PARAMETROS DA PERGUNTA FA100E PARA NAO PERDER O CONTEUDO
	LOCAL CMV_PAR02 := MV_PAR02
	LOCAL CMV_PAR03 := MV_PAR03
	LOCAL CMV_PAR04 := MV_PAR04
	LOCAL CMV_PAR05 := MV_PAR05
	LOCAL CMV_PAR06 := MV_PAR06
	LOCAL CMV_PAR07 := MV_PAR07
	LOCAL CMV_PAR08 := MV_PAR08
	LOCAL CMV_PAR09 := MV_PAR09
	LOCAL CPERG		:= "F240FIL"
	LOCAL CFILTRO	:= ""

	IF PERGUNTE(CPERG, .T., "Filtro por Fornecedor")
		CFILTRO += ' E2_FORNECE >= "'+ALLTRIM(MV_PAR01)+'" .AND. E2_LOJA >= "'+ALLTRIM(MV_PAR02)+'" .AND. E2_FORNECE <= "'+ALLTRIM(MV_PAR03)+'" .AND. E2_LOJA <= "'+ALLTRIM(MV_PAR04)+'" '
	ENDIF

	MV_PAR01 := CMV_PAR01		//RETORNO O CONTEUDO AOS PARAMETROS
	MV_PAR02 := CMV_PAR02
	MV_PAR03 := CMV_PAR03
	MV_PAR04 := CMV_PAR04
	MV_PAR05 := CMV_PAR05
	MV_PAR06 := CMV_PAR06
	MV_PAR07 := CMV_PAR07
	MV_PAR08 := CMV_PAR08
	MV_PAR09 := CMV_PAR09

	RESTAREA(AAREASEA)
	
RETURN(CFILTRO)