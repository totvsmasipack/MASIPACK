#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� PROGRAMA     �   A200BOK       � AUTOR � FABIO MARCELO DIAS    � DATA �  06/04/11   ���
���������������������������������������������������������������������������������������͹��
��� DESCRICAO    � PONTO DE ENTRADA QUE VALIDA TODAS ALTERACOES NA ESTRUTURA DO PRODUTO ���
���������������������������������������������������������������������������������������͹��
��� TABS.UTILIZ  � DESCRICAO                                              �   ACESSO    ���
���������������������������������������������������������������������������������������͹��
���    SG1       � CADASTRO DE ESTRUTURAS                                 � READ/WRITE  ���
���������������������������������������������������������������������������������������͹��
��� HISTORICO    � 06/04/2011 CRIACAO.                                                  ���
���              � RESPONSAVEL POR ACIONAR O BOT�O DE CONFIRMA��O DA ESTRUTURA          ���
���              � QUANDO EXCLUIR COMPONENTE DA ESTRUTURA.                              ���
���              � SERA ALTERADO O CAMPO G1_MSDTINI GRAVANDO A DATA ATUAL DO SISTEMA    ���
���              �                                                                      ���
���              � Observa��es:                                                         ���
���              � Sao passados 2 parametros (2 elementos no array PARAMIXB).           ���
���              � Para obter seus conteudos:                                           ���
���              � aRegs:= PARAMIXB[1]                                                  ���
���              � cCod := PARAMIXB[2]                                                  ���
���              �                                                                      ���
���              � aRegs: Array de uma dimensao contendo os numeros dos registros que   ���
���              � foram incluidos ou excluidos. Este array tem utilidade apenas        ���
���              � informativa e nao devera o Ponto de Entrada, deletar ou efetua recall���
���              � nos registros deste array.                                           ���
���              � Isto sera feito automatico, de acordo com o retorno do PE:           ���
���              � .T. Assume as alteracoes, mantendo as alteracoes no SG1;             ���
���              � .F. Desfaz todas as alteracoes efetuadas no SG1 (semelhante ao teclar���
���              � botao cancela, presente na mesma tela);                              ���
���              � Qualquer retorno nao-logico, sera ignorado pelo programa.            ���
���              �                                                                      ���
���              � PS: Cada registro do array pode estar deletado ou nao. Se estiver    ���
���              � deletado, foi deletado durante a alteracao atual, se nao estiver     ���
���              � deletado foi incluido.                                               ���
���              � O Array podera tambem estar vazio (Len(aRegs)=0), o que significa    ���
���              � que nenhuma inclusao ou alteracao foi realizada no SG1 na estrutura  ���
���              � do produto.                                                          ���
���������������������������������������������������������������������������������������͹��
��� USO          � MODULO ESTOQUE/CUSTOS                                                ���
���������������������������������������������������������������������������������������͹��
��� PROPRIETARIO � CUSTOMIZADO PARA MASIPACK                                            ���
���������������������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
/*/

USER FUNCTION A200BOK()

LOCAL AAREASG1	:= {}
LOCAL AREGS 	:= ParamIxb[1]
LOCAL NX		:= 0
LOCAL NRECNO	:= 0
LOCAL LRET		:= .T.

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	IF LEN(AREGS) <> 0
		AAREASG1 := SG1->(GETAREA())        // GRAVO A POSICAO DA TABELA
		FOR NX :=1 TO LEN(AREGS)
			IF AREGS[NX][2] == 2			// OPCAO 2 = EXCLUIR
				NRECNO := AREGS[NX][1]  	// ATRIBUO O NUMERO DO RECNO DO REGISTRO DELETADO
				SG1->(DBGOTO(NRECNO))		// POSICIONO NO REGISTRO DELETADO
				RECLOCK("SG1",.F.)			// RESERVO O REGISTRO
				SG1->G1_MSDTINI	:= DATE()	// ATUALIZO O CAMPO
				SG1->(MSUNLOCK())			// LIBERA O REGISTRO
			ENDIF
		NEXT
		RESTAREA(AAREASG1)                  // RESTAURO A POSICAO DA TABELA
	ELSE
		RETURN(LRET)
	ENDIF
ENDIF
RETURN(LRET)                               // RETORNO VERDADEIRO PARA A ROTINA
