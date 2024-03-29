#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� PROGRAMA     �   F240TBOR      � AUTOR � FABIO MARCELO DIAS    � DATA �  05/01/11   ���
���������������������������������������������������������������������������������������͹��
��� DESCRICAO    � CALCULO DO VALOR QUANDO E2_MOEDA <> 1 NA GERACAO DO BORDERO A PAGAR  ���
���������������������������������������������������������������������������������������͹��
��� TABS.UTILIZ  � DESCRICAO                                                   � ACESSO ���
���������������������������������������������������������������������������������������͹��
���    SE2       � CONTAS A PAGAR                                              � READ   ���
���    SM2       � CADASTRO DE MOEDAS                                          � READ   ���
���������������������������������������������������������������������������������������͹��
��� HISTORICO    � 05/01/2011 CRIA��O.                                                  ���
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

USER FUNCTION F240TBOR()

	LOCAL AAREASE2	:= {}
	LOCAL AAREASEA	:= {}  
	LOCAL NVALATU	:= 0

	AAREASE2 := SE2->(GETAREA())
	AAREASEA := SEA->(GETAREA())

	DO WHILE SEA->(!EOF()) .AND. SEA->EA_PREFIXO == SE2->E2_PREFIXO .AND. SEA->EA_NUM == SE2->E2_NUM .AND. SEA->EA_PARCELA == SE2->E2_PARCELA .AND. SEA->EA_NUMBOR == SE2->E2_NUMBOR
		IF SE2->E2_MOEDA > 1
			RECLOCK("SE2",.F.)
			DO CASE
				CASE SE2->E2_MOEDA == 2
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 2
				
				CASE SE2->E2_MOEDA == 3
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 3
					
				CASE SE2->E2_MOEDA == 4
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 4
					
				CASE SE2->E2_MOEDA == 5
					SE2->E2_MOEDA	:= 1
					SE2->E2_MSMOEFI := 5
			END CASE

			NVALATU := ROUND(NOROUND(XMOEDA(SE2->E2_VALOR,SE2->E2_MSMOEFI,1,SE2->E2_VENCREA,3,SE2->E2_TXMOEDA),3),2)
			SE2->E2_ACRESC	+= ROUND(NOROUND(NVALATU - SE2->E2_VALOR,3),2)
			SE2->E2_SALDO	:= NVALATU
			SE2->E2_VLCRUZ	:= NVALATU
			SE2->(MSUNLOCK())
	    ENDIF
		SE2->(DBSKIP())
	    SEA->(DBSKIP())
	    NVALATU := 0
	
	END DO

	RESTAREA(AAREASE2)
	RESTAREA(AAREASEA)

RETURN()