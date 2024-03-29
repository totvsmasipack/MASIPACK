#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� PROGRAMA     �   F240CAN       � AUTOR � FABIO MARCELO DIAS    � DATA �  05/01/11   ���
���������������������������������������������������������������������������������������͹��
��� DESCRICAO    � PROGRAMA PARA TRATAR VALORES NO CANCELAMENTO DO BORDERO              ���
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

USER FUNCTION F240CAN()

	LOCAL AAREASE2	:= {}
	LOCAL AAREASEA	:= {}  

	AAREASE2 := SE2->(GETAREA())
	AAREASEA := SEA->(GETAREA())

	DO WHILE SEA->(!EOF()) .AND. SEA->EA_PREFIXO == SE2->E2_PREFIXO .AND. SEA->EA_NUM == SE2->E2_NUM .AND. SEA->EA_PARCELA == SE2->E2_PARCELA .AND. SEA->EA_FORNECE == SE2->E2_FORNECE .AND. SEA->EA_LOJA == SE2->E2_LOJA
		IF SE2->E2_MSMOEFI > 1
			RECLOCK("SE2",.F.)
			DO CASE
				CASE SE2->E2_MSMOEFI == 2
					SE2->E2_MOEDA	:= 2
					SE2->E2_MSMOEFI := 1
			
				CASE SE2->E2_MSMOEFI == 3
					SE2->E2_MOEDA	:= 3
					SE2->E2_MSMOEFI := 1
				
				CASE SE2->E2_MSMOEFI == 4
					SE2->E2_MOEDA	:= 4
					SE2->E2_MSMOEFI := 1
				
				CASE SE2->E2_MSMOEFI == 5
					SE2->E2_MOEDA	:= 5
					SE2->E2_MSMOEFI := 1
			END CASE
	
			IF SE2->E2_ACRESC == ROUND(NOROUND(SE2->E2_VLCRUZ - SE2->E2_VALOR,3),2)
				SE2->E2_ACRESC := 0
			ELSE
				SE2->E2_ACRESC -= ROUND(NOROUND(SE2->E2_VLCRUZ - SE2->E2_VALOR,3),2)
			ENDIF

			SE2->E2_SALDO	:= SE2->E2_VALOR
			SE2->E2_VLCRUZ	:= SE2->E2_VALOR
			SE2->(MSUNLOCK())
				
		ENDIF

		SE2->(DBSKIP())
	    SEA->(DBSKIP())
		
	END DO

	RESTAREA(AAREASE2)
	RESTAREA(AAREASEA)

RETURN()