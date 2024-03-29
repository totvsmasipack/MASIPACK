#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� PROGRAMA     �   RFATA050      � AUTOR � FABIO MARCELO DIAS    � DATA �  07/12/10   ���
���������������������������������������������������������������������������������������͹��
��� DESCRICAO    � PROGRAMA PARA APRESENTAR O NOME DO CLIENTE NO PEDIDO DE VENDA        ���
���              � NO MOMENTO DA VISUALIZACAO, ALTERACAO OU EXCLUSAO (CAMPO C5_MSCLIEN) ���
���������������������������������������������������������������������������������������͹��
��� TABS.UTILIZ  � DESCRICAO                                                   � ACESSO ���
���������������������������������������������������������������������������������������͹��
���    SC5       � PEDIDO DE VENDA                                             � READ   ���
���    SA1       � CADASTRO DE CLIENTES                                        � READ   ���
���    SA2       � CADASTRO DE FORNECEDORES                                    � READ   ���
���������������������������������������������������������������������������������������͹��
��� HISTORICO    � 07/12/2010 CRIA��O.                                                  ���
���              �                                                                      ���
���  		     �                                                                      ���
���������������������������������������������������������������������������������������͹��
��� USO          � MODULO FATURAMENTO                                                   ���
���������������������������������������������������������������������������������������͹��
��� PROPRIETARIO � CUSTOMIZADO PARA MASIPACK                                            ���
���������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
/*/

USER FUNCTION RFATA050()

	LOCAL CCLIFOR := ""
	
	//IF !INCLUI
		IF SC5->C5_TIPO $ "NIPC"  // TRATA-SE DE CODIGO DE CLIENTE
		   IF SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
	    	  CCLIFOR := SA1->A1_NREDUZ
		   ENDIF
		ELSE
		   IF SA2->(DBSEEK(XFILIAL("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJAENT))
		      CCLIFOR := SA2->A2_NREDUZ
		   ENDIF
		ENDIF
	//ENDIF

RETURN(CCLIFOR)