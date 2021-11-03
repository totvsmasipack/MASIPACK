#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   A200BOK       บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  06/04/11   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ DESCRICAO    บ PONTO DE ENTRADA QUE VALIDA TODAS ALTERACOES NA ESTRUTURA DO PRODUTO บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ TABS.UTILIZ  บ DESCRICAO                                              บ   ACESSO    บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮอฮออออออออออนฑฑ
ฑฑบ    SG1       บ CADASTRO DE ESTRUTURAS                                 บ READ/WRITE  บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฮออออออนฑฑ
ฑฑบ HISTORICO    บ 06/04/2011 CRIACAO.                                                  บฑฑ
ฑฑบ              บ RESPONSAVEL POR ACIONAR O BOTรO DE CONFIRMAวรO DA ESTRUTURA          บฑฑ
ฑฑบ              บ QUANDO EXCLUIR COMPONENTE DA ESTRUTURA.                              บฑฑ
ฑฑบ              บ SERA ALTERADO O CAMPO G1_MSDTINI GRAVANDO A DATA ATUAL DO SISTEMA    บฑฑ
ฑฑบ              บ                                                                      บฑฑ
ฑฑบ              บ Observa็๕es:                                                         บฑฑ
ฑฑบ              บ Sao passados 2 parametros (2 elementos no array PARAMIXB).           บฑฑ
ฑฑบ              บ Para obter seus conteudos:                                           บฑฑ
ฑฑบ              บ aRegs:= PARAMIXB[1]                                                  บฑฑ
ฑฑบ              บ cCod := PARAMIXB[2]                                                  บฑฑ
ฑฑบ              บ                                                                      บฑฑ
ฑฑบ              บ aRegs: Array de uma dimensao contendo os numeros dos registros que   บฑฑ
ฑฑบ              บ foram incluidos ou excluidos. Este array tem utilidade apenas        บฑฑ
ฑฑบ              บ informativa e nao devera o Ponto de Entrada, deletar ou efetua recallบฑฑ
ฑฑบ              บ nos registros deste array.                                           บฑฑ
ฑฑบ              บ Isto sera feito automatico, de acordo com o retorno do PE:           บฑฑ
ฑฑบ              บ .T. Assume as alteracoes, mantendo as alteracoes no SG1;             บฑฑ
ฑฑบ              บ .F. Desfaz todas as alteracoes efetuadas no SG1 (semelhante ao teclarบฑฑ
ฑฑบ              บ botao cancela, presente na mesma tela);                              บฑฑ
ฑฑบ              บ Qualquer retorno nao-logico, sera ignorado pelo programa.            บฑฑ
ฑฑบ              บ                                                                      บฑฑ
ฑฑบ              บ PS: Cada registro do array pode estar deletado ou nao. Se estiver    บฑฑ
ฑฑบ              บ deletado, foi deletado durante a alteracao atual, se nao estiver     บฑฑ
ฑฑบ              บ deletado foi incluido.                                               บฑฑ
ฑฑบ              บ O Array podera tambem estar vazio (Len(aRegs)=0), o que significa    บฑฑ
ฑฑบ              บ que nenhuma inclusao ou alteracao foi realizada no SG1 na estrutura  บฑฑ
ฑฑบ              บ do produto.                                                          บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ USO          บ MODULO ESTOQUE/CUSTOS                                                บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
