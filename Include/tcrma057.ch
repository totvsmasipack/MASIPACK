#ifdef SPANISH
	#define STR0001 "Métricas"
	#define STR0002 "Courier New"
	#define STR0003 "Total:"
	#define STR0004 "EXISTE"
	#define STR0005 "¡Ya existe un archivo con esta información!"
	#define STR0006 "O Ano informado deverá estar entre o ano anterior e o próximo ano, com base na data atual!"
	#define STR0007 "¡El código del segmento debe comenzar con 'C' !"
	#define STR0008 "SEGMENTO"
	#define STR0009 "¡El RFC informado debe ser el mismo del Cliente!"
	#define STR0010 "RFC INVÁLIDO"
	#define STR0011 "¡El RFC informado debe ser el mismo del Prospect!"
	#define STR0012 "Creando indice temporal..."
	#define STR0013 "¡Modificaciones realizadas con éxito!"
	#define STR0014 "¡Confirmado!"
	#define STR0015 "AÑO INVÁLIDO"
	#define STR0016 "Salvando Informações de Métricas..."
	#define STR0017 "Cancel"
	#define STR0018 "There are empty fields in one line at corporative metrics!"
	#define STR0019 "Mod. Corp."
	#define STR0020 "Tabela"
#else
	#ifdef ENGLISH
		#define STR0001 "Metrics"
		#define STR0002 "Courier new"
		#define STR0003 "Total:"
		#define STR0004 "THERE IS"
		#define STR0005 "There is already a record with this information!"
		#define STR0006 "The Year must be between last year and next year!"
		#define STR0007 "The Segment code must start with 'C' !"
		#define STR0008 "SEGMENT"
		#define STR0009 "The CNPJ entered must be the same as Customer!"
		#define STR0010 "INVALID CNPJ"
		#define STR0011 "The CNPJ entered must be the same as Prospect!"
		#define STR0012 "Creating Temporary Index..."
		#define STR0013 "Changes successfully Executed!"
		#define STR0014 "Confirmed!"
		#define STR0015 "INVALID YEAR"
		#define STR0016 "Salvando Informações de Métricas..."
		#define STR0017 "Cancelar"
		#define STR0018 "Existem campos não preenchidos na tela de Métricas do corporativo!"
		#define STR0019 "Mod. Corp."
		#define STR0020 "Tabela"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG","" , "Métricas" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG","" , "Courier new" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG","" , "Total:" )
		#define STR0004 If( cPaisLoc $ "ANG|PTG","" , "EXISTE" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG","" , "Já existe um registro com esta informação!" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG","" , "O Ano informado deverá estar entre o ano anterior e o próximo ano, com base na data atual!" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG","" , "O código do Segmento precisa começar com 'C' !" )
		#define STR0008 If( cPaisLoc $ "ANG|PTG","" , "SEGMENTO" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG","" , "O CNPJ informado precisa ser o mesmo do Cliente!" )
		#define STR0010 If( cPaisLoc $ "ANG|PTG","" , "CNPJ INVALIDO" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG","" , "O CNPJ informado precisa ser o mesmo do Prospect!" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG","" , "Criando Índice Temporário..." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG","" , "Alterações efetuadas com Sucesso!" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG","" , "Confirmado!" )
		#define STR0015 "ANO INVÁLIDO"
		#define STR0016 "Salvando Informações de Métricas..."
		#define STR0017 "Cancelar"
		#define STR0018 "Existem campos não preenchidos na tela de Métricas do corporativo!"
		#define STR0019 "Mod. Corp."
		#define STR0020 "Tabela"
	#endif
#endif
