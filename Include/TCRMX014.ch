
/*/{Protheus.doc} TCRMX014
(Cancelamento de Processos no Fluig) - ID CRM0143

@author Anderson Alberto
@since 25/06/2015
@version 1.0
/*/

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VersЦo SPANISH			                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF SPANISH
		#DEFINE STR0001 ' TCRMX014 ( TCRMX014 ) - CONSULTA FLUIG - HOME '
		#DEFINE STR0002 'Proceso que no se encuentra'
		#DEFINE STR0003 ' Proceso capturado por otra ejecuciСn de TRABAJO'
		#DEFINE STR0004 'TCRMX014 ( TCRMX014 ) - CONSULTA FLUIG - FIN :'

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё VersЦo ENGLISH			                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 ' TCRMX014 ( TCRMX014 ) - FLUIG CONSULTATION - HOME '
		#DEFINE STR0002 'Process not found'
		#DEFINE STR0003 ' Process caught by another execution of JOB '
		#DEFINE STR0004 'TCRMX014 ( TCRMX014 ) - FLUIG CONSULTATION - END :'

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё VersЦo PORTUGUES 		                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	#ELSE
		#DEFINE STR0001 'TCRMX014 (TCRMX014) - CONSULTA FLUIG - INICIO: '
		#DEFINE STR0002 'Processo nЦo localizado'
		#DEFINE STR0003 'Processo travado por outra execuГЦo do JOB'
		#DEFINE STR0004 'TCRMX014 (TCRMX014) - CONSULTA FLUIG - TERMINO: '
	#ENDIF
#ENDIF