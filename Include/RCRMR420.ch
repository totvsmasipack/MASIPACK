
/*/{Protheus.doc} CA290FUNC
(Ponto de Entrada) - ID CRM1041

@author Anderson Alberto
@since 25/06/2015
@version 1.0
/*/

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VersЦo SPANISH			                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF SPANISH
		#DEFINE STR0001 'Adicionado pela FunГЦo CA290FUNC'

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё VersЦo ENGLISH			                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 'Adicionado pela FunГЦo CA290FUNC'

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё VersЦo PORTUGUES 		                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	#ELSE
		#DEFINE STR0001 'Adicionado pela FunГЦo CA290FUNC'
		#DEFINE STR0113 'Nao foi possivel estabelecer conexao com servidor do Ssim : "###'
		#DEFINE STR0114 'Cockpit Faturamento de ManutenГЦo'
		#DEFINE STR0115 'Erro na conexao com o SSIM no servidor '
		#DEFINE STR0116 'NЦo foi possМvel a abertura das tabelas de chamados do SSim!'
		#DEFINE STR0003 'Cockpit Faturamento de ManutenГЦo'
	#ENDIF
#ENDIF