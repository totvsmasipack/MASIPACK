
/*/{Protheus.doc} OS010BTN
(Ponto de entrada que permite incluir botУes na barra de botУes.) - ID CRM????

@author Anderson Alberto
@since 08/12/2015
@version 1.0
/*/

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VersЦo SPANISH			                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF SPANISH
		#DEFINE STR0001 ' Pulse aquМ para generar la hoja de cАlculo '
		#DEFINE STR0002 ' UsuАrio nao autorizado a gerar planilha '
		
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё VersЦo ENGLISH			                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 ' Click here to generate spreadsheet '
		#DEFINE STR0002 ' UsuАrio nao autorizado a gerar planilha '

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё VersЦo PORTUGUES 		                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	#ELSE
		#DEFINE STR0001 ' Clique aqui para gerar planilha '
		#DEFINE STR0002 ' UsuАrio nao autorizado a gerar planilha '
	#ENDIF
#ENDIF