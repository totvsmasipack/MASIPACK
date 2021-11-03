#INCLUDE "PROTHEUS.CH"
//#INCLUDE "SHELL.CH"

/*/{Protheus.doc} JOBNFESY
Funcao criada para utilizar apenas 1 licença pelo schedule processando os dados de importacao XML
@author DS2U (SDA)
@since 23/08/2018
@version 1.0
@param alParam, array of logical, Parametro contendo empresa e filial a ser executada
@type function
/*/
User Function JOBNFESY( alParam )

	local alFiliais	:= {}
	local nlx
	local olNfeSync
	local llProcSync	:= .F.
	local llProcEven	:= .F.
	local llProcCien	:= .F.

	private cpTimeIni	:= ""
	private cpDelay		:= ""

	default alParam	:= PARAMIXB
	
	conOut( ":: JOB NFESYNC :: - Inicio em " + time(), .T., .T. )
	
	if ( valType( alParam ) == "A" .and. len( alParam ) > 0 )
	
		llProcSync := iif( len( alParam ) > 2 .and. valType( alParam[3] ) == "L", alParam[3], .T. )
		llProcEven := iif( len( alParam ) > 3 .and. valType( alParam[4] ) == "L", alParam[4], .T. )
		llProcCien := iif( len( alParam ) > 4 .and. valType( alParam[5] ) == "L", alParam[5], .T. )
	
		RpcSetType(3)
		RpcSetEnv(alParam[1],alParam[2])
		
		//------------------------------------------------------------------
		// Busca no parametro as filiais a serem consideradas pelo NfeSync -
		//------------------------------------------------------------------
		alFiliais := separa( allTrim( getMv("NS_FILIAIS",,"0101") ), ";" )
//		alFiliais := separa( allTrim( getMv("NS_FILIAIS",,"01") ), ";" )

		olNfeSync	:= NfeSync():new()
		
		RpcClearEnv()
		
		if ( len( alFiliais ) > 0 )
		
			for nlx := 1 to len( alFiliais )
			
				if ( .not. empty( alFiliais[nlx] ) )
			
					alParam[2] := alFiliais[nlx]
					
					RpcSetType(3)
					RpcSetEnv(alParam[1],alParam[2])
					
					// Checa licenças
					if ( canUseNfSy( SM0->M0_CGC ) )
						
						conOut( ":: JOB NFESYNC :: - Processando empresa: " + cEmpAnt + " filial: " + alFiliais[nlx] + " - " + time(), .T., .T. )
						
						if ( llProcEven )
							chkDelay()
							olNfeSync:getEvents()
						endif
						
						if ( llProcCien )
							chkDelay()
							olNfeSync:setCiencia()
						endif
						
						if ( llProcSync )
							chkDelay()
							olNfeSync:syncNfe()
						endif
													
						// Envia volume de notas a cada processamento
						sendBillin()
						
					endif
					
					RpcClearEnv()
					
				else
					conOut( ":: JOB NFESYNC :: - Licenca do NfSync NEGADA!" , .T., .T.)
				endif
				
			next nlx
			
		else
			conOut( ":: JOB NFESYNC :: - Parametro NS_FILIAIS nao esta configurado com as filiais a serem consideradas pelo NFESYNC" , .T., .T.)
		endif
		
		// Limpeza de objeto da memoria
		FreeObj( olNfeSync )

	else
		conOut( ":: JOB NFESYNC :: - Parametro de empresa e filial nao configurado corretamente no schedule.")
	endif
	
	conOut( ":: JOB NFESYNC :: - Finalizado em " + time(), .T., .T. )

Return

/*/{Protheus.doc} JOB2NFSY
Chamada para ser utilizada quando o job for configurado no ini. Exemplo:

[OnStart]
jobs=JOB_NFESYNC
RefreshRate=60

[JOB_NFESYNC]
Main=U_JOB2NFSY
Environment=JOB
nParms=2
Parm1=99
Parm2=01

@author DS2U (SDA)
@since 30/08/2018
@version 1.0
@param clEmp, characters, Codigo da empresa a ser considerada para abrir o ambiente
@param clFil, characters, Codigo da filial a ser considerada para abrir o ambiente
@type function
/*/
User Function JOB1NFSY( clEmp, clFil )
	U_JOBNFESY( { clEmp, clFil, .T., .F., .F. } )
Return

/*/{Protheus.doc} JOB2NFSY
Processa somente eventos da Sefaz
@author DS2U (SDA)
@since 20/02/2019
@version 1.0
@return ${return}, ${return_description}
@param clEmp, characters, description
@param clFil, characters, description
@type function
/*/
User Function JOB2NFSY( clEmp, clFil )
	U_JOBNFESY( { clEmp, clFil, .F., .T., .F. } )
Return

/*/{Protheus.doc} JOB3NFSY
Processa somente ciencia da operacao
@author DS2U (SDA)
@since 20/02/2019
@version 1.0
@param clEmp, characters, description
@param clFil, characters, description
@type function
/*/
User Function JOB3NFSY( clEmp, clFil )
	U_JOBNFESY( { clEmp, clFil, .F., .F., .T. } )
Return

/*/{Protheus.doc} JOBANFSY
Processa todos os passos de integração 
@author DS2U (SDA)
@since 20/02/2019
@version 1.0
@param clEmp, characters, description
@param clFil, characters, description
@type function
/*/
User Function JOBANFSY( clEmp, clFil )
	U_JOBNFESY( { clEmp, clFil, .T., .T., .T. } )
Return

User Function JOBTNFSY( clEmp, clFil )
	U_JOBNFESY( { "01", "01", .T., .T., .T. } )
Return

/*/{Protheus.doc} JOBENFSY
Processa somente eventos e ciencia da operacao via JOB
@author DS2U (SSA)
@since 20/02/2019
@version 1.0
@return ${return}, ${return_description}
@param clEmp, characters, description
@param clFil, characters, description
@type function
/*/
User Function JOBENFSY( clEmp, clFil )
	U_JOBNFESY( { clEmp, clFil, .F., .T., .T. } )
Return

/*/{Protheus.doc} chkDelay
Funcao para controle de delay de execução das rotinas de consumo de web services para evitar rejeição 656
@author sergi
@since 23/08/2018
@version 1.0

@type function
/*/
Static Function chkDelay()

	if ( .not. empty( cpTimeIni ) )
		cpDelay := elapTime(cpTimeIni, time() )
	else
		cpTimeIni := time()
		cpDelay := ""
	endif
	
	/**
	  * Tratativa de delay para evitar rejeição 656 
	  * MOTIVO: Rejeicao: Consumo Indevido 
	  * (Deve ser aguardado 1 hora para efetuar nova solicitacao caso nao existam mais documentos a serem pesquisados. Tente apos 1 hora)
	  */
	if ( .not. empty( cpDelay ) .and. val( subs( cpDelay, 4, 2 ) ) < 1 )
		conOut(":: JOB NFESYNC :: Aguardando 5 segundos para evitar rejeicao 656: " + time() )
		sleep( 5000 ) // 5 segundos
		cpTimeIni := ""
		cpDelay := ""
		conOut(":: JOB NFESYNC :: Continuando processamento " + time() )
	endif
	
Return

/*/{Protheus.doc} canUseNfSy
Checa as licenças
@author DS2U (SDA)
@since 11/07/2019
@version 1.0
@return lRet, Se .T., então pode usar a ferramenta. Caso o servidor esteja inativo, ficará liberado
@param cCnpj, characters, CNPJ permitido
@type function
/*/
Static Function canUseNfSy( cCnpj )

Local lRet		:= .T.

conOut( ":: JOB NFESYNC :: canUseNfSy >> Checando licencas..." )

/*Local cToken   := "NFESYNC"
Local oLicence := LicenceDS2U():new()

lRet := oLicence:isLicenceValid( cCnpj, cToken )*/

Return lRet

/*/{Protheus.doc} sendBillin
Envia contagem das notas importadas para o NfSync
@author DS2U (SDA)
@since 25/07/2019
@version 1.0
@param cCnpj, characters, CNPJ
@type function
/*/
Static Function sendBillin( cCNPJ )

Local cParams    := ""
Local cRootPath := allTrim( getSrvProfString("RootPath", "\undefined") )
Local cStartPath := allTrim( getSrvProfString("StartPath", "\undefined") )
Local cAlias     := getNextAlias()
Local nVolume    := 0
Local cStartDate := allTrim( getMv( "NS_BLINIDT",, "20190724" ) ) // BILLING START DATE... PODE HAVER NOTAS ANTIGAS, ENTAO PARA TER DATA DE CORTE, UTILIZAMOS ESTE PARAMETRO
Local cNameBat   := allTrim( getMv( "NS_BLBAT",, "billing.bat" ) )
Local cCommand      := "" 
Local cPath      := "" 
Local lWait      := .T.

Default cCNPJ := SM0->M0_CGC

conOut( ":: JOB NFESYNC :: Billing Start Date: " + cStartDate  )

//---------------------------------------------------------
// Checa configuracao de billing  e se deve coletar dados -
//---------------------------------------------------------
if ( cfgBilling() )

	//------------------------------------------------------------------------------
	// Trata startDate                                                             -
	//------------------------------------------------------------------------------
	// Se o mes de inicio do billing for diferente do mes atual, entao configura o -
	// Start Date para apurar a partir do primeiro dia do mes                      -
	//------------------------------------------------------------------------------
	if !( month( sToD( cStartDate ) ) == month( date() ) )
		cStartDate := dToS( firstDate( date() ) )
	endif

	BEGINSQL ALIAS cAlias

		SELECT 
			COUNT(*) AS VOLUME WITH (NOLOCK)

		FROM 
			%TABLE:ZN0% ZN0

		WHERE
			ZN0.ZN0_FILIAL = %XFILIAL:ZN0%
			AND ZN0.ZN0_EMISSA >= %EXP:cStartDate%
			AND ZN0.ZN0_DATAIM >= %EXP:cStartDate%
			AND ZN0.%NOTDEL%

	ENDSQL

	if ( !( cAlias )->( eof() ) )
		nVolume := ( cAlias )->VOLUME
	endif
	( cAlias )->( dbCloseArea() )

	//-----------------------------------------
	// Configurando parametros para o billing -ds
	//-----------------------------------------
	cParams += cCNPJ + " " // CNPJ
	cParams += allTrim( getMv( "NS_IDNFSYN",, "1" ) ) + " " // ID DO PRODUTO NFSYNC NO CADASTRO DE TEMPLATE
	cParams += allTrim( cValToChar( nVolume ) ) + " " // VOLUME DE NOTAS

	if ( ( !empty( cRootPath ) .and. !( cRootPath == "\undefined" ) ) .and. ( !empty( cStartPath ) .and. !( cStartPath == "\undefined" ) ) )

		if ( subs( cRootPath, len( cRootPath ), 1 ) $ "\/" )
			cRootPath := subs( cRootPath, 1, len( cRootPath ) -1 )
		endif

		if !( subs( cStartPath, len( cStartPath ), 1 ) $ "\/" )
			cStartPath += "/"
		endif

		if ( batCreate( cRootPath + cStartPath, cNameBat, cParams ) )

			cCommand := cRootPath + cStartPath + cNameBat
			cPath     := cRootPath + cStartPath

			conOut( ":: JOB NFESYNC :: Executando billing >> Volume de notas: " + allTrim( cValToChar( nVolume ) )  )
			WaitRunSrv( @cCommand , @lWait , @cPath )

			batDelete( cRootPath + cStartPath, cNameBat )

		else
			conOut( ":: JOB NFESYNC :: NAO FOI POSSIVEL CRIAR O ARQUIVO .BAT PARA PROCESSAMENTO DO BILLING" )
		endif

	else
		conOut( ":: JOB NFESYNC :: NAO FOI ENCONTRADO O BILLING" )
	endif
	
endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} cfgBilling
Funcao para checar se deve coletar dados para billing
@author  DS2U (SDA)
@since   26/07/2019
@return  lCheck, boolean, Se .T., deve coletar billing
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function cfgBilling()

Local lCheck := .T.
/*Local cSecao := "BILLING-NFSYNC"  
Local cUltDate := ""
Local cUltHour := ""
Local nHorasBil := getMv( "NS_FRQBILL",, 4 )
Local cHoras   := strZero( nHorasBil, 2 ) + ":00:00"
Local cNameArqIni := "nfsync.ini"

cUltDate := GetPvProfString(cSecao, "DATE_CHECK", "undefined") 
cUltHour := GetPvProfString(cSecao, "HOUR_CHECK", "undefined") 

conOut( ":: JOB NFESYNC :: cfgBilling >> Checando se deve coletar dados para o billing")

if ( ( cUltDate == "undefined" ) .or. ( cUltHour == "undefined" ) )
	writePProfString(cSecao, "DATE_CHECK", dToS( date() ) ) 
	writePProfString(cSecao, "HOUR_CHECK", time() )
	lCheck := .T.
	conOut( ":: JOB NFESYNC :: cfgBilling >> .T.")
else

	if !( sToD( cUltDate ) == date() ) .or. ( elapTime( cUltHour, time() ) > cHoras ) // Checa billing a cada NS_FRQBILL horas
		conOut( ":: JOB NFESYNC :: cfgBilling >> .T.")
		lCheck := .T.
	endif

endif */

Return lCheck

//-------------------------------------------------------------------
/*/{Protheus.doc} batDelete
Funcao para exclusao do arquivo .bat de processamento do billing
@author  DS2U (SDA)
@since   26/07/2019
@param  cDir, caracter, Diretorio do arquivo .bat
@param  cNameBat, caracter, Nome do arquivo .bat
@param  cParams, caracter, String com os parametros a serem passado ao programa java billing.jar
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function batCreate( cDir, cNameBat, cParams )

Local lCreated  := .F.
Local cFullName := cDir + cNameBat
Local cNameJar   := allTrim( getMv( "NS_BLJAR",, "billing.jar" ) )
Local cStartPath := allTrim( getSrvProfString("StartPath", "\undefined") )
local nHandle := 0

conOut( ":: JOB NFESYNC :: batCreate >> Criando arquivo .bat" )

if ( file( cStartPath + cNameJar ) ) // checa se o arquivo java para processamento do billing existe

	nHandle := fCreate( cStartPath + cNameBat)

	if nHandle = -1	
		conOut( ":: JOB NFESYNC :: Nao foi possivel criar arquivo " + cFullName + " >> " + Str(Ferror()) )
	else
		
		conOut( ":: JOB NFESYNC :: Escrevendo arquivo .bat" )
		//------------------------------------------------------------------
		// Escreve o script do arquivo .bat para execução do programa java -
		//------------------------------------------------------------------
		FWrite(nHandle, "@ECHO OFF " + CRLF )
		FWrite(nHandle, "@ECHO OFF " + CRLF )
		FWrite(nHandle, "java -jar " + cDir + cNameJar + " " + cParams +  CRLF )
		FWrite(nHandle, "exit" )
		FClose(nHandle)
		
		lCreated := .T.

	endif

else
	conOut( ":: JOB NFESYNC :: Arquivo " + cStartPath + cNameJar + " nao existe!" )
endif

conOut( ":: JOB NFESYNC :: batCreate >> Fim da criacao do arquivo .bat" )

Return lCreated

//-------------------------------------------------------------------
/*/{Protheus.doc} batDelete
Funcao para exclusao do arquivo .bat de processamento do billing
@author  DS2U (SDA)
@since   26/07/2019
@param  cDir, caracter, Diretorio de onde esta o arquivo .bat a ser excluido
@param  cNameBat, caracter, Nome do arquivo .bat a ser excluido
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function batDelete( cDir, cNameBat )

Local cStartPath := allTrim( getSrvProfString("StartPath", "\undefined") )

conOut( ":: JOB NFESYNC :: batDelete >> INICIO" )

if ( file( cStartPath + cNameBat ) )
	conOut( ":: JOB NFESYNC :: batDelete >> Excluindo arquivo .bat" )
	fErase( cStartPath + cNameBat )
endif

if ( file( cStartPath + cNameBat ) )
	conOut( ":: JOB NFESYNC :: Arquivo .bat não pode ser excluido!" )
else
	conOut( ":: JOB NFESYNC :: Arquivo .bat excluido com sucesso!" )
endif

Return