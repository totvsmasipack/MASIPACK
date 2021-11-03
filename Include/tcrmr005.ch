#ifdef SPANISH
	#define STR0001 "Login de usuário não possui permissão para exportar dados para Excel!"
	#define STR0002 "Data Check-Out de    "
	#define STR0003 "Data Check-Out de    "
	#define STR0004 "Data Check-Out de    "
	#define STR0005 "Data Cadastro Ate   "
	#define STR0006 "Data Check-Out Ate   "
	#define STR0007 "Data Check-Out Ate  "
	#define STR0008 "Data Expectativa de    "
	#define STR0009 "Data Expectativa de    "
	#define STR0010 "Data Expectativa de    "
	#define STR0011 "Data Expectativa Ate   "
	#define STR0012 "Data Expectativa Ate   "
	#define STR0013 "Data Expectativa Ate  "
	#define STR0014 "Levantamento de dados..."
	#define STR0015 "ID Atividade x Ofertas"
	#define STR0016 "Codigo GO"
	#define STR0017 "Nome GO"
	#define STR0018 "Codigo DAR"
	#define STR0019 "Nome DAR"
	#define STR0020 "Codigo GAR"
	#define STR0021 "Nome GAR"
	#define STR0022 "Código EAR"
	#define STR0023 "Nome EAR"
	#define STR0024 "Código"
	#define STR0025 "Nome"
	#define STR0026 "Tipo Entidade"
	#define STR0027 "Situação"
	#define STR0028 "Possíveis Negociações"
	#define STR0029 "Feeling"
	#define STR0030 "Valor"
	#define STR0031 "Observação"
	#define STR0032 "Data Expectativa"
	#define STR0033 "Data Check-Out"
	#define STR0034 "Aguarde..."
	#define STR0035 "Consultando Nivel de Acesso..."
	#define STR0036 "Por Favor, Indique uma data !"
	#define STR0037 "Por Favor, Indique uma data válida !"
	#define STR0038 "Levantamento de Possíveis Negócios...."
	#define STR0039 "Cliente"
	#define STR0040 "Prospect"
	#define STR0041 "Suspect"
	#define STR0042 "Possíveis Negociações"
	#define STR0043 "Deseja exportar novamente para excel?"
	#define STR0044 "Não há dados!"
	#define STR0045 "Ativo"
	#define STR0046 "Inativo"
	#define STR0047 "Lead"
#else
	#ifdef ENGLISH
		#define STR0001 "Login de usuário não possui permissão para exportar dados para Excel!"
		#define STR0002 "Data Check-Out de    "
		#define STR0003 "Data Check-Out de    "
		#define STR0004 "Data Check-Out de    "
		#define STR0005 "Data Cadastro Ate   "
		#define STR0006 "Data Check-Out Ate   "
		#define STR0007 "Data Check-Out Ate  "
		#define STR0008 "Data Expectativa de    "
		#define STR0009 "Data Expectativa de    "
		#define STR0010 "Data Expectativa de    "
		#define STR0011 "Data Expectativa Ate   "
		#define STR0012 "Data Expectativa Ate   "
		#define STR0013 "Data Expectativa Ate  "
		#define STR0014 "Levantamento de dados..."
		#define STR0015 "ID Atividade x Ofertas"
		#define STR0016 "Codigo GO"
		#define STR0017 "Nome GO"
		#define STR0018 "Codigo DAR"
		#define STR0019 "Nome DAR"
		#define STR0020 "Codigo GAR"
		#define STR0021 "Nome GAR"
		#define STR0022 "Código EAR"
		#define STR0023 "Nome EAR"
		#define STR0024 "Código"
		#define STR0025 "Nome"
		#define STR0026 "Tipo Entidade"
		#define STR0027 "Situação"
		#define STR0028 "Possíveis Negociações"
		#define STR0029 "Feeling"
		#define STR0030 "Valor"
		#define STR0031 "Observação"
		#define STR0032 "Data Expectativa"
		#define STR0033 "Data Check-Out"
		#define STR0034 "Aguarde..."
		#define STR0035 "Consultando Nivel de Acesso..."
		#define STR0036 "Por Favor, Indique uma data !"
		#define STR0037 "Por Favor, Indique uma data válida !"
		#define STR0038 "Levantamento de Possíveis Negócios...."
		#define STR0039 "Cliente"
		#define STR0040 "Prospect"
		#define STR0041 "Suspect"
		#define STR0042 "Possíveis Negociações"
		#define STR0043 "Deseja exportar novamente para excel?"
		#define STR0044 "Não há dados!"
		#define STR0045 "Ativo"
		#define STR0046 "Inativo"
		#define STR0047 "Lead"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", , "Login de usuário não possui permissão para exportar dados para Excel!" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", , "Data Check-Out de    " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", , "Data Check-Out de    " )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", , "Data Check-Out de    " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", , "Data Cadastro Ate   " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", , "Data Check-Out Ate   " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", , "Data Check-Out Ate  " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", , "Data Expectativa de    " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", , "Data Expectativa de    " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", , "Data Expectativa de    " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", , "Data Expectativa Ate   " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", , "Data Expectativa Ate   " )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", , "Data Expectativa Ate  " )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", , "Levantamento de dados..." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", , "ID Atividade x Ofertas" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", , "Codigo GO" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", , "Nome GO" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", , "Codigo DAR" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", , "Nome DAR" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", , "Codigo GAR" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", , "Nome GAR" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", , "Código EAR" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", , "Nome EAR" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", , "Código" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", , "Nome" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", , "Tipo Entidade" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", , "Situação" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", , "Feeling" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", , "Valor" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", , "Observação" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", , "Data Expectativa" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", , "Data Check-Out" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", , "Aguarde..." )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", , "Consultando Nivel de Acesso..." )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", , "Por Favor, Indique uma data !" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", , "Por Favor, Indique uma data válida !" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", , "Levantamento de Possíveis Negócios...." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", , "Cliente" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", , "Prospect" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", , "Suspect" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", , "Possíveis Negociações" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", , "Deseja exportar novamente para excel?" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", , "Não há dados!" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", , "Ativo" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", , "Inativo" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", , "Lead" )
	#endif
#endif
