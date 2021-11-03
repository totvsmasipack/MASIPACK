/*/{Protheus.doc} TCRMA072
Wizard de transferência de Propostas

@author Ivan de Oliveira
@since 16/02/2016
@version 1.0
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Versão SPANISH			                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
#IFDEF SPANISH
	
	#DEFINE STR0001 'Proposta '
	#DEFINE STR0002 'Cod. cliente '
	#DEFINE STR0003 'Oportunidade '
	#DEFINE STR0004 'Descrição '
	#DEFINE STR0005 'Total da Proposta '
	#DEFINE STR0006 'Emissão '
	#DEFINE STR0007 'Upload '
	#DEFINE STR0008 'Combo '
	#DEFINE STR0009 'Usuário '
	#DEFINE STR0010 'Site de Faturamento '
	#DEFINE STR0011 'Linha de receita '
	#DEFINE STR0012 'Código '
	#DEFINE STR0013 'Nome '
	#DEFINE STR0014 'Quantidade Propostas '
	#DEFINE STR0015 'Selecione um período válido! '
	#DEFINE STR0016 'Este wizard irá auxiliar na transferencia de propostas '
	#DEFINE STR0017 'que estão pendentes no CST para usuários específicos '
	#DEFINE STR0018 'que serão responsáveis pelo desenrolar das mesmas. '
	#DEFINE STR0019 'Não existem propostas com upload no período pendentes no CST! '
	#DEFINE STR0020 'Wizard de Transferência de Propostas - CST '
	#DEFINE STR0021 'Transferencias de Propostas - CST '
	#DEFINE STR0022 'Selecione o usuário origem da transferencia : '
	#DEFINE STR0023 'Selecione o Site de Faturamento '
	#DEFINE STR0024 'Selecione as oportunidades a serem transferidas : '
	#DEFINE STR0025 'Confirmação dos dados e início de processamento. '
	#DEFINE STR0026 'Clique em FINALIZAR para conclui a transferencia! '
	#DEFINE STR0027 'Nenhum usuário selecionado! '
	#DEFINE STR0028 'Nenhum Site de Faturamento Selecionado! '
	#DEFINE STR0029 'Não foram encontradas propostas com estes parâmetros '
	#DEFINE STR0030 'Selecione ao menos uma proposta! '
	#DEFINE STR0031 'Sem Distrutuição! '
	#DEFINE STR0032 'Não foram encontrados Sites de Faturamento para estes usuarios!'
	 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Versão ENGLISH			                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#ELSE
	#IFDEF ENGLISH
	
		#DEFINE STR0001 'Proposta '
		#DEFINE STR0002 'Cod. cliente '
		#DEFINE STR0003 'Oportunidade '
		#DEFINE STR0004 'Descrição '
		#DEFINE STR0005 'Total da Proposta '
		#DEFINE STR0006 'Emissão '
		#DEFINE STR0007 'Upload '
		#DEFINE STR0008 'Combo '
		#DEFINE STR0009 'Usuário '
		#DEFINE STR0010 'Site de Faturamento '
		#DEFINE STR0011 'Linha de receita '
		#DEFINE STR0012 'Código '
		#DEFINE STR0013 'Nome '
		#DEFINE STR0014 'Quantidade Propostas '
		#DEFINE STR0015 'Selecione um período válido! '
		#DEFINE STR0016 'Este wizard irá auxiliar na transferencia de propostas '
		#DEFINE STR0017 'que estão pendentes no CST para usuários específicos '
	 	#DEFINE STR0018 'que serão responsáveis pelo desenrolar das mesmas. '
		#DEFINE STR0019 'Não existem propostas com upload no período pendentes no CST! '
		#DEFINE STR0020 'Wizard de Transferência de Propostas - CST '
		#DEFINE STR0021 'Transferencias de Propostas - CST '
		#DEFINE STR0022 'Selecione o usuário origem da transferencia : '
		#DEFINE STR0023 'Selecione o Site de Faturamento '
		#DEFINE STR0024 'Selecione as oportunidades a serem transferidas : '
		#DEFINE STR0025 'Confirmação dos dados e início de processamento. '
		#DEFINE STR0026 'Clique em FINALIZAR para conclui a transferencia! '
		#DEFINE STR0027 'Nenhum usuário selecionado! '
		#DEFINE STR0028 'Nenhum Site de Faturamento Selecionado! '
		#DEFINE STR0029 'Não foram encontradas propostas com estes parâmetros '
		#DEFINE STR0030 'Selecione ao menos uma proposta! '
		#DEFINE STR0031 'Sem Distrutuição! '
		#DEFINE STR0032 'Não foram encontrados Sites de Faturamento para estes usuarios!'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Versão PORTUGUES 		                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#ELSE
	
		#DEFINE STR0001 'Proposta '
		#DEFINE STR0002 'Cod. cliente '
		#DEFINE STR0003 'Oportunidade '
		#DEFINE STR0004 'Descrição '
		#DEFINE STR0005 'Total da Proposta '
		#DEFINE STR0006 'Emissão '
		#DEFINE STR0007 'Upload '
		#DEFINE STR0008 'Combo '
		#DEFINE STR0009 'Usuário '
		#DEFINE STR0010 'Site de Faturamento '
		#DEFINE STR0011 'Linha de receita '
		#DEFINE STR0012 'Código '
		#DEFINE STR0013 'Nome '
		#DEFINE STR0014 'Quantidade Propostas '
		#DEFINE STR0015 'Selecione um período válido! '
		#DEFINE STR0016 'Este wizard irá auxiliar na transferencia de propostas '
		#DEFINE STR0017 'que estão pendentes no CST para usuários específicos '
	 	#DEFINE STR0018 'que serão responsáveis pelo desenrolar das mesmas. '
		#DEFINE STR0019 'Não existem propostas com upload no período pendentes no CST! '
		#DEFINE STR0020 'Wizard de Transferência de Propostas - CST '
		#DEFINE STR0021 'Transferencias de Propostas - CST '
		#DEFINE STR0022 'Selecione o usuário origem da transferencia : '
		#DEFINE STR0023 'Selecione o Site de Faturamento '
		#DEFINE STR0024 'Selecione as oportunidades a serem transferidas : '
		#DEFINE STR0025 'Confirmação dos dados e início de processamento. '
		#DEFINE STR0026 'Clique em FINALIZAR para conclui a transferencia! '
		#DEFINE STR0027 'Nenhum usuário selecionado! '
		#DEFINE STR0028 'Nenhum Site de Faturamento Selecionado! '
		#DEFINE STR0029 'Não foram encontradas propostas com estes parâmetros '
		#DEFINE STR0030 'Selecione ao menos uma proposta! '
		#DEFINE STR0031 'Sem Distrutuição! '
		#DEFINE STR0032 'Não foram encontrados Sites de Faturamento para estes usuarios!'

 
	#ENDIF
	
#ENDIF

