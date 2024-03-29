#ifdef SPANISH
	#define STR0001 "Liquidaciones Financieras"
	#define STR0002 "Este informe imprimira el extracto de Liquidaciones "
	#define STR0003 "Financieras."
	#define STR0004 "LIQUIDACION: "
	#define STR0005 "N� de la Liquidacion"
	#define STR0006 "Titulos Liquidados"
	#define STR0007 "PRF"
	#define STR0008 "NUMERO"
	#define STR0009 "CUOTA"
	#define STR0010 "TIPO"
	#define STR0011 "EMISION"
	#define STR0012 "EMITENTE"
	#define STR0013 "VALOR"
	#define STR0014 "INTERESES"
	#define STR0015 "DESCUENTOS"
	#define STR0016 "BANCO"
	#define STR0017 "AGENCIA"
	#define STR0018 "CUENTA"
	#define STR0019 "Seleccionando Registros..."
	#define STR0020 "Por Cobrar"
	#define STR0021 "Baja Parc. "
	#define STR0022 "Dado de baja"
	#define STR0023 "Generado"
	#define STR0024 "Total Liq. "
	#define STR0025 "Totales "
	#define STR0026 "Observaciones: "
	#define STR0027 "- Los titulos dados de baja se imprimen con el valor original, independientemente de la forma de la baja. "
	#define STR0028 "- Los totalizadores consideran el valor total de la liquidaci�n o de los t�tulos generados/dados de baja."
	#define STR0029 "ESTATUS"
	#define STR0030 "Codigo"
	#define STR0031 "Empresa"
	#define STR0032 "Unidad de negocio"
	#define STR0033 "Sucursal"
	#define STR0034 "Sucursales seleccionadas para el informe"
#else
	#ifdef ENGLISH
		#define STR0001 "Financial Settlements is not chosen"
		#define STR0002 "This report prints the statement of Financial Settlements. "
		#define STR0003 ""
		#define STR0004 "SETTLEMENT: "
		#define STR0005 "Settlement Number"
		#define STR0006 "Bills Settled"
		#define STR0007 "PRF"
		#define STR0008 "NUMBER"
		#define STR0009 "INSTALLMENT"
		#define STR0010 "TYPE"
		#define STR0011 "ISSUE"
		#define STR0012 "ISSUER"
		#define STR0013 "AMOUNT"
		#define STR0014 "INTEREST"
		#define STR0015 "DISCOUNTS"
		#define STR0016 "BANK"
		#define STR0017 "AGENCY"
		#define STR0018 "ACCOUNT"
		#define STR0019 "Selecting records..."
		#define STR0020 "Receivable"
		#define STR0021 "Installment Write-off "
		#define STR0022 "Written-off"
		#define STR0023 "Generated"
		#define STR0024 "Net Tot. "
		#define STR0025 "Totals "
		#define STR0026 "Notes: "
		#define STR0027 "- Written-off bills are printed with original value, regardless of the write-off type. "
		#define STR0028 "- Totalizers consider the settlement total value or value of generated/written-off bills."
		#define STR0029 "STATUS"
		#define STR0030 "Code"
		#define STR0031 "Company"
		#define STR0032 "Business Unit"
		#define STR0033 "Branch"
		#define STR0034 "Branches selected for the report"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Liquida��es Financeiras", "Liquidacoes Financeiras" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este relat�rio imprimir� o extrato de Liquida��es ", "Este relatorio ir� imprimir o extrato de Liquidacoes " )
		#define STR0003 "Financeiras."
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "LIQUIDA��O : ", "LIQUIDACAO : " )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Nr. da Liquida��o", "No. da Liquida��o" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "T�tulos Liquidados", "Titulos Liquidados" )
		#define STR0007 "PRF"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "N�MERO", "NUMERO" )
		#define STR0009 "PARCELA"
		#define STR0010 "TIPO"
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "EMISS�O", "EMISSAO" )
		#define STR0012 "EMITENTE"
		#define STR0013 "VALOR"
		#define STR0014 "JUROS"
		#define STR0015 "DESCONTOS"
		#define STR0016 "BANCO"
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "AG�NCIA", "AGENCIA" )
		#define STR0018 "CONTA"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "A seleccionar registos...", "Selecionando Registros..." )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "A receber", "A Receber" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Liquida Parc. ", "Baixa Parc. " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Liquidado", "Baixado" )
		#define STR0023 "Gerado"
		#define STR0024 "Total Liq. "
		#define STR0025 "Totais "
		#define STR0026 "Observa��es: "
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "- Os t�tulos liquidados s�o impressos com o valor original, independente da forma da liquida��o. ", "- Os t�tulos baixados s�o impressos com o valor original, independente da forma da baixa. " )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "- Os totalizadores consideram o valor total da liquida��o ou dos t�tulos gerados/liquidados.", "- Os totalizadores consideram o valor total da liquida��o ou dos t�tulos gerados/baixados." )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "ESTADO", "STATUS" )
		#define STR0030 "C�digo"
		#define STR0031 "Empresa"
		#define STR0032 "Unidade de neg�cio"
		#define STR0033 "Filial"
		#define STR0034 "Filiais selecionadas para o relatorio"
	#endif
	
#endif



