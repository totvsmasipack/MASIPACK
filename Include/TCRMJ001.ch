
/*/{Protheus.doc} TCRMJ001
(JOB para envio de processos para Fluig em lote) - ID CRM0143

@author Anderson Alberto
@since 25/06/2015
@version 1.0
/*/

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VersЦo SPANISH			                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF SPANISH
		#DEFINE STR0001 ' TCRMJ001 ( TCRMJ001 ) - CONSULTA FLUIG - HOME '
		#DEFINE STR0002 'TCRMJ001 ( TCRMJ001 ) - CONSULTA FLUIG - FIN :'
		#DEFINE STR0003 'Si' 
		#DEFINE STR0004 'No'
		#DEFINE STR0005 'Consulta - IntegraciСn Iniciar Fluig'
		#DEFINE STR0006 'Mantenimiento Objetivos'
		#DEFINE STR0007 'Processo nЦo localizado no Gerador de Processos'


	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё VersЦo ENGLISH			                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR0001 ' TCRMJ001 ( TCRMJ001 ) - FLUIG CONSULTATION - HOME '
		#DEFINE STR0002 'TCRMJ001 ( TCRMJ001 ) - FLUIG CONSULTATION - END :'
		#DEFINE STR0003 'Yes' 
		#DEFINE STR0004 'No'
		#DEFINE STR0005 'Consultation - Log Fluig Integration'
		#DEFINE STR0006 'Maintenance Goals'
		#DEFINE STR0007 'Processo nЦo localizado no Gerador de Processos'

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё VersЦo PORTUGUES 		                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	#ELSE
		#DEFINE STR0001 'TCRMJ001 (TCRMJ001) - CONSULTA FLUIG - INICIO: '
		#DEFINE STR0002 'TCRMJ001 (TCRMJ001) - CONSULTA FLUIG - TERMINO: '
		#DEFINE STR0003 'Sim' 
		#DEFINE STR0004 'NЦo'
		#DEFINE STR0005 'Consulta - Log de IntegraГЦo Fluig'
		#DEFINE STR0006 'ManutenГЦo de Metas'
		#DEFINE STR0007 'Processo nЦo localizado no Gerador de Processos'
	#ENDIF
#ENDIF