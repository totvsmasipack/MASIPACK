/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRFATG036() บAutor ณ Eduardo Mantoan        บ Data ณ 23/05/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera grแfico gen้rico  									  ฐฑฑ
ฑฑบ               														  ฐฑฑ
ฑฑบ                                                               		  ฐฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FILEIO.CH"

#DEFINE PS_CREATE_EXCEL_FILE				1
#DEFINE PS_ADD_LINE_EXCEL_FILE			2
#DEFINE PS_SHOW_EXCEL_FILE					3
#DEFINE PS_COPY_EXCEL_SRV_LOCAL_FILE	4

#DEFINE MAX_TOP_SELECT					"50"

Static __cCRLF := CRLF


User Function RFATG036(aCam,_aTipC,aStr,lGraf)
	
	Local lSetCentury	:= .F.
	PARAMETERS _aCampo,_aTipC,aStr
	Private cPerg    	:= "XRFATG036" 
	Private _aCampo  	:= aCam
	Private _aTipCam 	:= _aTipC
	Private aStruct  	:= aStr
	Private lOk      	:= lGraf
	Private cCSVFileS
	
	SetsDefault()
	lSetCentury			:= __SetCentury( "ON" )
	If lOk
  		IF ! Pergunte(cPerg,.T.)
 	 		Return
  		ENDIF  
	
  		If MV_PAR01 == ""
	 		MV_PAR01 := "GRAFICO"
  		EndIf 
	EndIf
	MsgRun( "Aguarde...." , "Gerando Planilha Excel no Client" , { || RFATG36() } )
	__SetCentury( IF( lSetCentury , "ON" , "OFF" ) )

Return( NIL )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRFATG036() บAutor ณ Eduardo Mantoan        บ Data ณ 23/05/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera grแfico gen้rico  											     ฐฑฑ
ฑฑบ               																		  ฐฑฑ
ฑฑบ                                                               		  ฐฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RFATG36()
	
	Local aDbStruct
	Local cSrvPath			:= "C:\relato_microsiga"
	Local cLocalPath		:= "C:\relato_microsiga"
	Local cCSVFile
	Local cExcelFile
	Local cFields       	:= ""
	Local cHeaderFormat 	:= ""
	Local cDetailFormat 	:= ""
	Local cLine          := ""
	Local nField         := 0
	Local nCountX        := 1
	Local nCountY        := 1
	Local nfhCSVFile
	
	IF !( SubStr( cSrvPath , -1 ) == "\" )
		cSrvPath += "\"
	EndIF

	IF !( SubStr( cLocalPath , -1 ) == "\" )
		cLocalPath += "\"
	EndIF

	cExcelFile		:= PsNewExcelFile( @cSrvPath , @cLocalPath , @cCSVFile , @nfhCSVFile )
	IF !( "ERROR" $ ( cExcelFile + cCSVFile ) )

		
				
			For nCountx := 1 To Len( _aCampo )
			
				cFields			+= '"'
				cFields 			+=	_aCampo[nCountx]
				cFields			+= '"' 
				cLine				+=	_aCampo[nCountx]
				cHeaderFormat 	+= '"'
				cHeaderFormat 	+= _aTipCam[nCountx]
				cHeaderFormat 	+= '"'	
				cDetailFormat 	+= '"'
				cDetailFormat 	+=	_aTipCam[nCountx]
				cDetailFormat 	+= '"'
				IF  nCountx < (Len( _aCampo ))
					cFields			+= ","
					cLine 			+= "|"
					cDetailFormat	+= ","
					cHeaderFormat	+= ","
				EndIF 
				
			Next nCountx
	
		cLine   += __cCRLF
		
  		fWrite( nfhCSVFile , cLine )   
  		
  		
		For nCountX := 1 To Len(aStruct)
	  		cLine := ""
			For nCountY := 1 To Len( _aCampo )
			 
				cLine += aStruct[nCountX,nCountY]+  "|"
				
			Next nCountY
			cLine += __cCRLF
			fWrite( nfhCSVFile , cLine )
		Next nCountX
	  		
	   			        
		

		fClose( nfhCSVFile )
		nfhCSVFile	:= fOpen( cCSVFile , FO_SHARED )

		IF PsExecute( PS_COPY_EXCEL_SRV_LOCAL_FILE , @cExcelFile , @cSrvPath , @cLocalPath , @cCSVFile )

			IF PsExecute( PS_ADD_LINE_EXCEL_FILE , @cExcelFile , @cSrvPath , @cLocalPath , @cCSVFile , @cFields , @cHeaderFormat , @cDetailFormat )
	
				PsExecute( PS_SHOW_EXCEL_FILE , @cExcelFile , @cSrvPath , @cLocalPath )
	
			EndIF

		EndIF
	
		fClose( nfhCSVFile )
		
		If fErase( cCSVFile ) == -1
			MsgStop('Falha ao excluir arquivo de parametros local, chame o TI')
		Else
		
		EndIf
		
	 		 
	EndIF

	dbSelectArea( "SC5" )

Return( NIL )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณPsNewExcelFile บAutor ณ Eduardo Mantoan  บ Data ณ 19/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PsNewExcelFile- Cria uma Nova Planilha Excel					  ฐฑฑ
ฑฑบ               																		  ฐฑฑ
ฑฑบ                                                               		  ฐฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PsNewExcelFile( cSrvPath , cLocalPath , cCSVFile , nfhCSVFile )

	Local cExcelFile		:= Lower( CriaTrab( NIL , .F. ) )
	
	Local cFullCSVFile
	Local cFullExcelFile

	cCSVFile					:= ( cExcelFile +  ".csv" )
	cExcelFile				+= ".xlsx"
	cFullExcelFile			:= ( cLocalPath + cExcelFile )
	While File( cFullExcelFile )
		cExcelFile			:= Lower( CriaTrab( NIL , .F. ) )
		cCSVFile				:= ( cExcelFile +  ".csv" )
		cExcelFile			+= ".xlsx"
		cFullExcelFile		:= ( cLocalPath + cExcelFile )
	End While

	IF PsExecute( PS_CREATE_EXCEL_FILE  , @cFullExcelFile , @cSrvPath , @cLocalPath )

		IF !( File( cFullExcelFile ) )
			cFullExcelFile		:= "ERROR"
			cCSVFile			:= ""
		Else
			cFullCSVFile		:= ( cSrvPath + cCSVFile )
			While File( cFullCSVFile )
				cCSVFile		:= Lower( CriaTrab( NIL , .F. ) )
				cCSVFile		+= ".csv"
				cFullCSVFile	+= ( cSrvPath + cCSVFile )
			End While
			cCSVFile		:= cFullCSVFile 
			nfhCSVFile			:= fCreate( cCSVFile , FC_NORMAL )
			IF !( File( cFullCSVFile ) )
				cCSVFile		:= "ERROR"
			Else
				cCSVFile		:= cFullCSVFile
				cCSVFileS	:= cFullCSVFile
			EndIF
			fClose( nfhCSVFile )
			nfhCSVFile			:= fOpen( cCSVFile , FO_READWRITE )
		EndIF
	
	Else

		cCSVFile				:= ""
		cFullExcelFile			:= "ERROR"

	EndIF

Return( cFullExcelFile )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณPsExecute บAutor ณ Eduardo Mantoan  บ Data ณ 19/05/14   	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณ PsExecute - Cria e Executa, via WaitRun, os Scripts 		  ฐฑฑ
ฑฑบ               em PowerShell														  ฐฑฑ
ฑฑบ                                                               		  ฐฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PsExecute( nScript , cExcelFile , cSrvPath , cLocalPath , cCSVFile , cFields , cHeaderFormat , cDetailFormat )
	
	Local nX
	Local aDel
	Local aFields
	Local aSelectObj
	Local aHeaderFormat
	Local aDetailFormat

	Local cPsScript		:= ""
	Local cNewPsFile	:= ""
	Local cWaitRunCmd	:= ""
	
	Local cCharType
	Local cSelectObj
	Local cWorkSheetName
	
	Local cLocalCSV

	Local lStatus		:= .F.
	Local lWriteOk
	
	Local nBL
	Local nEL
	Local nAT

	Static __cPsFile

	cPsScript 		+= '# -----------------------------------------------------------------------------------------------'+ __cCRLF
	cPsScript 		+= 'function Release-Ref ($ref){' + __cCRLF
	cPsScript 		+= '	([System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$ref) -gt 0);' + __cCRLF
	cPsScript 		+= '	[System.GC]::Collect();' + __cCRLF
	cPsScript 		+= '	[System.GC]::WaitForPendingFinalizers();' + __cCRLF
	cPsScript 		+= '}' + __cCRLF 
	cPsScript 		+= '# -----------------------------------------------------------------------------------------------'+ __cCRLF
	IF ( nScript == PS_ADD_LINE_EXCEL_FILE )
		cPsScript 	+= PsExportXls()
		cPsScript 	+= '# -----------------------------------------------------------------------------------------------'+ __cCRLF 
	  //***************************************
		nY :=Len(_aCampo)                    //*
		cSelectObj :=""                      //*
      For nX=1 to nY                       //*
      	cSelectObj += _aCampo[nX]         //*  Indica quais campos irใo para o excel/grแfico
      	If nX < nY                        //*
      		cSelectObj +=","               //*
      	EndIf                             //*
      Next nX                              //*
		//**************************************

		aDel			:= {}
		aFields			:= StrToKArr( cFields 		 , "," 		) 
		aSelectObj		:= StrTokArr( cSelectObj 	 , ","		)
		aHeaderFormat	:= StrTokArr( cHeaderFormat  , ","		)
		aDetailFormat	:= StrToArray( cDetailFormat , '","'	)

		nEL				:= Len( aFields ) 
		For nBL := 1 To nEL
			IF ( ( aScan( aSelectObj , { |cField| cField $ aFields[ nBL ] } ) ) > 0 )
				Loop
			EndIF
			aAdd( aDel , aFields[ nBL ] )
		Next nBL

		nEL				:= Len( aDel )
		For nBL := 1 To nEL
			nAT := aScan( aFields , { |cField| cField == aDel[ nBL ] } )
			aDel( aFields , nAT )
			aDel( aHeaderFormat , nAT )
			aDel( aDetailFormat , nAT )
		Next nBL

		aSize( aFields 		 , ( Len( aFields )       - nEL  ) )
		aSize( aHeaderFormat , ( Len( aHeaderFormat ) - nEL  ) )
		aSize( aDetailFormat , ( Len( aDetailFormat ) - nEL  ) )

		cFields					:= ""
		cHeaderFormat			:= ""
		cDetailFormat			:= ""

		nEL				:= Len( aFields )
		For nBL := 1 To nEL
			cFields				+= aFields[ nBL ]
			cHeaderFormat		+= aHeaderFormat[ nBL ]
			cDetailFormat		+= aDetailFormat[ nBL ]
			IF ( nBL < nEL )
				cFields			+= ","
				cHeaderFormat	+= ","
				cDetailFormat	+= '","'
			EndIF
		Next nBL

		IF !( SubStr( cDetailFormat , 1 , 1 ) == '"' )
			cDetailFormat		:= ( '"' + cDetailFormat )
		EndIF	

		IF !( SubStr( cDetailFormat , -1 ) == '"' )
			cDetailFormat		+= '"'
		EndIF	

		cCharType				:= "xlColumnClustered"
		If lOk
			cWorkSheetName			:= MV_PAR01
		Else
			cWorkSheetName 		:= ""
      EndIf
	Else

		cPsScript 	+= '$objExcel					= New-Object -Com Excel.Application;' + __cCRLF

	EndIF	
	DO CASE
	CASE ( nScript == PS_CREATE_EXCEL_FILE )
		cPsScript 	+= '$objExcel.Visible			= $False;' + __cCRLF 
		cPsScript 	+= '$objExcel.DisplayAlerts		= $False;' + __cCRLF
		cPsScript 	+= '$objWorkBook = $objExcel.Workbooks.Add();' + __cCRLF
		cPsScript 	+= '$objWorkBook.SaveAs("'+cExcelFile+'");' + __cCRLF
		cPsScript 	+= '$objExcel.Quit();' + __cCRLF
	  	cPsScript 	+= '$dummy = Release-Ref($objWorkBook)	| Out-Null;' + __cCRLF
	CASE ( nScript == PS_ADD_LINE_EXCEL_FILE )
		cPsScript 	+= '$CSVFile					= "' + cCSVFile   + '";' + __cCRLF
		cPsScript 	+= '$ExcelFile					= "' + cExcelFile + '";' + __cCRLF
		cPsScript 	+= '' + __cCRLF 
		cPsScript 	+= '$objCSV			        	= @(Import-Csv -Path $CSVFile -Delimiter "|" | Select-Object ' + cSelectObj + ');' + __cCRLF
		cPsScript 	+= 'Export-Xls $objCSV $ExcelFile -WorksheetName "' + cWorkSheetName + '" -ChartType "' + cCharType + '";' + __cCRLF
		cPsScript 	+= '' + __cCRLF
		cPsScript 	+= '$objExcel					= New-Object -Com Excel.Application;' + __cCRLF
		cPsScript 	+= '$objExcel.Visible 			= $False;' + __cCRLF
		cPsScript 	+= '$objExcel.DisplayAlerts		= $False;' + __cCRLF
		cPsScript 	+= '$objWorkBook  				= $objExcel.Workbooks.Open($ExcelFile);' + __cCRLF
		cPsScript 	+= '$objWorksheet 				= $objWorkBook.Worksheets.Item(1);' + __cCRLF
		cPsScript 	+= '' + __cCRLF
		cPsScript 	+= '[int]$nLine					= 0;' + __cCRLF
		cPsScript 	+= '[int]$nColNum				= 0;' + __cCRLF
		cPsScript 	+= '[int]$nObjCol				= 0;' + __cCRLF
		cPsScript 	+= '[int]$nColFormat			= 0;' + __cCRLF
		cPsScript 	+= '' + __cCRLF		
		cPsScript 	+= '[Array]$Fields 				= ' + cFields + ';' + __cCRLF
		cPsScript 	+= '[Array]$HeaderFormat		= ' + cHeaderFormat + ';' + __cCRLF
		cPsScript 	+= '[Array]$DetailFormat		= ' + cDetailFormat + ';' + __cCRLF
		cPsScript 	+= '' + __cCRLF		
		cPsScript 	+= '[String]$sColValue			= "";' + __cCRLF
		cPsScript 	+= '[String]$sColFormat			= "";' + __cCRLF
		cPsScript 	+= '' + __cCRLF		
		cPsScript 	+= '[boolean]$bHeader			= $False;' + __cCRLF
		cPsScript 	+= '[boolean]$bChangeColor		= $False;' + __cCRLF
		
		If !lOk
			// *************** INICIO FORMATAวยO - DEIXA MAIS LENTO	!!
		
			cPsScript 	+= 'for ( $Row = 0 ; $Row -lt ($objCSV.Length +1)  ; ++$Row )' + __cCRLF
			cPsScript 	+= '{' + __cCRLF
	 		cPsScript 	+= '	++$nLine' + __cCRLF
	 		cPsScript 	+= '	$bHeader																= ( $nLine -eq 1 );' + __cCRLF
	 		cPsScript 	+= '	$nColNum																= 0;' + __cCRLF
	 		cPsScript 	+= '	$nObjCol																= 0;' + __cCRLF
	 		cPsScript 	+= '	$nColFormat																= 0;' + __cCRLF
			cPsScript 	+= '	$bChangeColor															= ( ( ( $nLine ) % 2 ) -eq 0 );' + __cCRLF
			cPsScript 	+= '	For ( $Field = 0 ; $Field -lt $Fields.Length ; ++$Field )' + __cCRLF
  			cPsScript 	+= '	{' + __cCRLF
  			cPsScript 	+= '		++$nColNum;' + __cCRLF
  			cPsScript 	+= '		$sColValue															= $objCSV.Get($Row).($Fields[$nObjCol++]);' + __cCRLF
  			cPsScript 	+= '		if ( $bHeader  ){' + __cCRLF
  			cPsScript 	+= '			$sColFormat														= $HeaderFormat[$nColFormat++];' + __cCRLF
  			cPsScript 	+= '		}' + __cCRLF
  			cPsScript 	+= '		else{' + __cCRLF
  			cPsScript 	+= '			$sColFormat														= $DetailFormat[$nColFormat++];' + __cCRLF
  			cPsScript 	+= '		}' + __cCRLF
  			cPsScript 	+= '		$objWorksheet.Cells.Item($nLine,$nColNum).NumberFormat				= $sColFormat;' + __cCRLF
 			cPsScript 	+= '		if ( $bChangeColor ){' + __cCRLF
			cPsScript 	+= '			$objWorksheet.Cells.Item($nLine,$nColNum).Interior.ColorIndex	= 15;' + __cCRLF
			cPsScript 	+= '		}' + __cCRLF
			cPsScript 	+= '		else {' + __cCRLF
  			cPsScript 	+= '			$objWorksheet.Cells.Item($nLine,$nColNum).Interior.ColorIndex	= 16;' + __cCRLF
			cPsScript 	+= '		}' + __cCRLF
	 		cPsScript 	+= '	}' + __cCRLF
	 		cPsScript 	+= '}' + __cCRLF
			cPsScript 	+= '$objRange 					= $objWorksheet.UsedRange;' + __cCRLF
			cPsScript 	+= '$objRange.Font.ColorIndex	= 11;' + __cCRLF
			cPsScript 	+= '$objRange.Font.Bold			= $True;' + __cCRLF
			cPsScript 	+= '$objRange.Borders.Color		= 0;' + __cCRLF
			cPsScript 	+= '$objRange.Borders.Weight	= 2;' + __cCRLF
			cPsScript 	+= '[void] $objRange.EntireColumn.Autofit();' + __cCRLF
			cPsScript 	+= '$objRange.EntireColumn.AutoFilter();' + __cCRLF
	
    	
    	  	// *************** FIM FORMATAวยO - DEIXA MAIS LENTO	!!
    	EndIf
    	cPsScript 	+= '$objWorksheet.Protect("teste");'+ __cCRLF //PROTEGE A PLANILHA, SENHA "teste"
		cPsScript 	+= '$objWorkBook.Save();' + __cCRLF
		cPsScript 	+= '$objExcel.Quit();' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorksheet) | Out-Null;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorkbook)  | Out-Null;' + __cCRLF
	CASE ( nScript == PS_SHOW_EXCEL_FILE )
		cPsScript 	+= '$objWorkBook				= $objExcel.Workbooks.Open("'+cExcelFile+'");' + __cCRLF
		cPsScript 	+= '$objExcel.Visible			= $True;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorksheet) | Out-Null;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorkbook)  | Out-Null;' + __cCRLF
	CASE ( nScript == PS_COPY_EXCEL_SRV_LOCAL_FILE )
		cPsScript 	+= '$objExcel.Visible			= $False;' + __cCRLF
		cPsScript 	+= '$objWorkBook				= $objExcel.Workbooks.Open("'+cExcelFile+'");' + __cCRLF
		cPsScript 	+= '$objWorksheet 				= $objWorkBook.Worksheets.Item(1);' + __cCRLF
		cPsScript 	+= '$objWorksheet.Cells.Item(1,1).Activate() | Out-Null;' + __cCRLF
		cPsScript 	+= '$objExcel.DisplayAlerts		= $True;' + __cCRLF
		cPsScript 	+= '$objWorkBook.Save();' + __cCRLF
		cPsScript 	+= '$objExcel.Quit();' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorksheet) | Out-Null;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorkbook)	 | Out-Null;' + __cCRLF
	END CASE
	cPsScript 		+= '$dummy 						= Release-Ref($objExcel)	 | Out-Null;' + __cCRLF

	DEFAULT __cPsFile	:= Lower( ( CriaTrab( NIL , .F. ) + ".ps1" ) )

	cNewPsFile			:= ( cLocalPath + __cPsFile )
	While File( cNewPsFile )
		__cPsFile		:= Lower( CriaTrab( NIL , .F. ) + ".ps1" )
		cNewPsFile		:= ( cLocalPath + __cPsFile )
	End While

	lWriteOk 			:= MemoWrite( cNewPsFile , cPsScript )

	IF ( lWriteOk .and. File( cNewPsFile ) )

		cWaitRunCmd	:= "PowerShell -NonInteractive -WindowStyle Hidden -File " + cNewPsFile + ""
		
		lStatus		:= ( WaitRun( cWaitRunCmd , SW_HIDE ) == 0 )

		IF ( ( lStatus ) .and. ( nScript == PS_COPY_EXCEL_SRV_LOCAL_FILE ) )
		
			cLocalCSV	:= StrTran( cCSVFile   , cSrvPath , cLocalPath )
		
			//lStatus		:= __CopyFile( cCSVFile , cLocalCSV )
		
			fErase( cCSVFile )
		
			IF ( lStatus )

				IF File( cLocalCSV )
					cCSVFile	:= cLocalCSV
				Else	
					lStatus		:= .F.
				EndIF
			
			EndIF

		EndIF

	EndIF

	fErase( cNewPsFile )

Return( lStatus )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณPsExportXls บAutor ณ Eduardo Mantoan  บ Data ณ 19/05/14   	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณ PsExportXls - Retorna o Script em PS desenvolvido por 		  ฐฑฑ
ฑฑบ           Luc Dekens    														     ฐฑฑ
ฑฑบ                                                               		  ฐฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PsExportXls()

	Local cPsScript 	:= ""

	cPsScript 			+= 'function Export-Xls{' + __cCRLF
	cPsScript 			+= '	<#' + __cCRLF
	cPsScript 			+= '.SYNOPSIS' + __cCRLF
	cPsScript 			+= '	Saves Microsoft .NET Framework objects to a worksheet in an XLS file' + __cCRLF
	cPsScript 			+= '.DESCRIPTION' + __cCRLF
	cPsScript 			+= '	The Export-Xls function allows you to save Microsoft .NET Framework objects' + __cCRLF
	cPsScript 			+= '	to a named worksheet in an Excel file (type XLS). The position of the' + __cCRLF
	cPsScript 			+= '	worksheet can be specified.' + __cCRLF
	cPsScript 			+= '.NOTES' + __cCRLF
	cPsScript 			+= '	Author:  Luc Dekens' + __cCRLF
	cPsScript 			+= '.PARAMETER InputObject' + __cCRLF
	cPsScript 			+= '	Specifies the objects to be written to the worksheet. The parameter accepts' + __cCRLF
	cPsScript 			+= '	objects through the pipeline.' + __cCRLF
	cPsScript 			+= '.PARAMETER Path' + __cCRLF
	cPsScript 			+= '	Specifies the path to the XLS file.' + __cCRLF
	cPsScript 			+= '.PARAMETER WorksheetName' + __cCRLF
	cPsScript 			+= '	The name for the new worksheet. If not specified the name will' + __cCRLF
	cPsScript 			+= '	be "Sheet" followed by the "Ticks" value' + __cCRLF
	cPsScript 			+= '.PARAMETER SheetPosition' + __cCRLF
	cPsScript 			+= '	Specifies where the new worksheet will be inserted in the series of' + __cCRLF
	cPsScript 			+= '	existing worksheets. You can specify "begin" or "end". The default' + __cCRLF
	cPsScript 			+= '	is "begin".' + __cCRLF
	cPsScript 			+= '.PARAMETER ChartType' + __cCRLF
	cPsScript 			+= '	Specifies the type of chart you want add to the worksheet.' + __cCRLF
	cPsScript 			+= '	All types in the [microsoft.Office.Interop.Excel.XlChartType]' + __cCRLF
	cPsScript 			+= '	enumeration are accepted.' + __cCRLF
	cPsScript 			+= '.PARAMETER NoTypeInformation' + __cCRLF
	cPsScript 			+= '	Omits the type information from the worksheet. The default is to' + __cCRLF
	cPsScript 			+= '	include the "#TYPE" line.' + __cCRLF
	cPsScript 			+= '.PARAMETER AppendWorksheet' + __cCRLF
	cPsScript 			+= '	Specifies if the worksheet should keep or remove the existing' + __cCRLF
	cPsScript 			+= '	worksheet in the spreadsheet. The default is to append.' + __cCRLF
	cPsScript 			+= '.EXAMPLE' + __cCRLF
	cPsScript 			+= '	PS> $data = Get-Process | Select-Object Name, Id, WS' + __cCRLF
	cPsScript 			+= '	PS> Export-Xls $data C:\Reports\MyWkb.xlsx -WorksheetName "WS" -AppendWorksheet:$false' + __cCRLF
	cPsScript 			+= '.EXAMPLE' + __cCRLF
	cPsScript 			+= '	PS> $data = Get-Process | Select-Object Name, Id, WS' + __cCRLF
	cPsScript 			+= '	PS> Export-Xls $data C:\Reports\MyWkb.xlsx -SheetPosition "end"' + __cCRLF
	cPsScript 			+= '.EXAMPLE' + __cCRLF
	cPsScript 			+= '	PS> $data = Get-Process | Select-Object Name, Id, WS' + __cCRLF
	cPsScript 			+= '	PS> Export-Xls $data C:\Reports\MyWkb.xlsx -WorksheetName "WS" -ChartType "xlColumnClustered"' + __cCRLF
	cPsScript 			+= '#>' + __cCRLF
	cPsScript 			+= '	param(' + __cCRLF
	cPsScript 			+= '	[parameter(ValueFromPipeline = $true,Position=1)]' + __cCRLF
	cPsScript 			+= '	[ValidateNotNullOrEmpty()]' + __cCRLF
	cPsScript 			+= '	$InputObject,' + __cCRLF
	cPsScript 			+= '	[parameter(Position=2)]' + __cCRLF
	cPsScript 			+= '	[ValidateNotNullOrEmpty()]' + __cCRLF
	cPsScript 			+= '	[string]$Path,' + __cCRLF
	cPsScript 			+= '	[string]$WorksheetName = ("Sheet " + (Get-Date).Ticks),' + __cCRLF
	cPsScript 			+= '	[string]$SheetPosition = "begin",' + __cCRLF
	cPsScript 			+= '	[PSObject]$ChartType,' + __cCRLF
	cPsScript 			+= '	[switch]$NoTypeInformation = $true,' + __cCRLF
	cPsScript 			+= '	[switch]$AppendWorksheet = $true' + __cCRLF
	cPsScript 			+= '	)' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '	begin{' + __cCRLF
	cPsScript 			+= '		[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Office.Interop.Excel")' + __cCRLF
	cPsScript 			+= '		if($ChartType){' + __cCRLF
	cPsScript 			+= '			[microsoft.Office.Interop.Excel.XlChartType]$ChartType = $ChartType' + __cCRLF
	cPsScript 			+= '		}' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '		function Set-ClipBoard{' + __cCRLF
	cPsScript 			+= '			param(' + __cCRLF
	cPsScript 			+= '				[string]$text' + __cCRLF
	cPsScript 			+= '			)' + __cCRLF
	cPsScript 			+= '			process{' + __cCRLF
	cPsScript 			+= '				Add-Type -AssemblyName System.Windows.Forms' + __cCRLF
	cPsScript 			+= '				$tb = New-Object System.Windows.Forms.TextBox' + __cCRLF
	cPsScript 			+= '				$tb.Multiline = $true' + __cCRLF
	cPsScript 			+= '				$tb.Text = $text' + __cCRLF
	cPsScript 			+= '				$tb.SelectAll()' + __cCRLF
	cPsScript 			+= '				$tb.Copy()' + __cCRLF
	cPsScript 			+= '			}' + __cCRLF
	cPsScript 			+= '		}' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '		function Add-Array2Clipboard {' + __cCRLF
	cPsScript 			+= '			param (' + __cCRLF
	cPsScript 			+= '				[PSObject[]]$ConvertObject,' + __cCRLF
	cPsScript 			+= '				[switch]$Header' + __cCRLF
	cPsScript 			+= '			)' + __cCRLF
	cPsScript 			+= '			process{' + __cCRLF
	cPsScript 			+= '				$array = @()' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '				if ($Header) {' + __cCRLF
	cPsScript 			+= '					$line =""' + __cCRLF
	cPsScript 			+= '					$ConvertObject | Get-Member -MemberType Property,NoteProperty,CodeProperty | Select -Property Name | %{' + __cCRLF
	cPsScript 			+= '						$line += ($_.Name.tostring() + "`t")' + __cCRLF
	cPsScript 			+= '					}' + __cCRLF
	cPsScript 			+= '					$array += ($line.TrimEnd("`t") + "`r")' + __cCRLF
	cPsScript 			+= '				}' + __cCRLF
	cPsScript 			+= '				else {' + __cCRLF
	cPsScript 			+= '					foreach($row in $ConvertObject){' + __cCRLF
	cPsScript 			+= '						$line =""' + __cCRLF
	cPsScript 			+= '						$row | Get-Member -MemberType Property,NoteProperty | %{' + __cCRLF
	cPsScript 			+= '							$Name = $_.Name' + __cCRLF
	cPsScript 			+= '							if(!$Row.$Name){$Row.$Name = ""}' + __cCRLF
	cPsScript 			+= '							$line += ([string]$Row.$Name + "`t")' + __cCRLF
	cPsScript 			+= '						}' + __cCRLF
	cPsScript 			+= '						$array += ($line.TrimEnd("`t") + "`r")' + __cCRLF
	cPsScript 			+= '					}' + __cCRLF
	cPsScript 			+= '				}' + __cCRLF
	cPsScript 			+= '				Set-ClipBoard $array' + __cCRLF
	cPsScript 			+= '			}' + __cCRLF
	cPsScript 			+= '		}' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '		$excelApp = New-Object -ComObject "Excel.Application"' + __cCRLF
	cPsScript 			+= '		$originalAlerts = $excelApp.DisplayAlerts' + __cCRLF
	cPsScript 			+= '		$excelApp.DisplayAlerts = $false' + __cCRLF
	cPsScript 			+= '		if(Test-Path -Path $Path -PathType "Leaf"){' + __cCRLF
	cPsScript 			+= '			$workBook = $excelApp.Workbooks.Open($Path)' + __cCRLF
	cPsScript 			+= '		}' + __cCRLF
	cPsScript 			+= '		else{' + __cCRLF
	cPsScript 			+= '			$workBook = $excelApp.Workbooks.Add()' + __cCRLF
	cPsScript 			+= '		}' + __cCRLF
	cPsScript 			+= '		$sheet = $excelApp.Worksheets.Add($workBook.Worksheets.Item(1))' + __cCRLF
	cPsScript 			+= '		if(!$AppendWorksheet){' + __cCRLF
	cPsScript 			+= '			$workBook.Sheets | where {$_ -ne $sheet} | %{$_.Delete()}' + __cCRLF
	cPsScript 			+= '		}' + __cCRLF
	cPsScript 			+= '		$sheet.Name = $WorksheetName' + __cCRLF
	cPsScript 			+= '		if($SheetPosition -eq "end"){' + __cCRLF
	cPsScript 			+= '			$nrSheets = $workBook.Sheets.Count' + __cCRLF
	cPsScript 			+= '			2..($nrSheets) |%{' + __cCRLF
	cPsScript 			+= '				$workbook.Sheets.Item($_).Move($workbook.Sheets.Item($_ - 1))' + __cCRLF
	cPsScript 			+= '			}' + __cCRLF
	cPsScript 			+= '		}' + __cCRLF
	cPsScript 			+= '		$sheet.Activate()' + __cCRLF
	cPsScript 			+= '		$array = @()' + __cCRLF
	cPsScript 			+= '	}' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '	process{' + __cCRLF
	cPsScript 			+= '		$array += $InputObject' + __cCRLF
	cPsScript 			+= '	}' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '	end{' + __cCRLF
	cPsScript 			+= '		Add-Array2Clipboard $array -Header:$True' + __cCRLF
	cPsScript 			+= '		$selection = $sheet.Range("A1")' + __cCRLF
	cPsScript 			+= '		$selection.Select() | Out-Null' + __cCRLF
	cPsScript 			+= '		$sheet.Paste()' + __cCRLF
	cPsScript 			+= '		$Sheet.UsedRange.HorizontalAlignment = [microsoft.Office.Interop.Excel.XlHAlign]::xlHAlignCenter' + __cCRLF
	cPsScript 			+= '		Add-Array2Clipboard $array' + __cCRLF
	cPsScript 			+= '		$selection = $sheet.Range("A2")' + __cCRLF
	cPsScript 			+= '		$selection.Select() | Out-Null' + __cCRLF
	cPsScript 			+= '		$sheet.Paste() | Out-Null' + __cCRLF
	cPsScript 			+= '		$selection = $sheet.Range("A1")' + __cCRLF
	cPsScript 			+= '		$selection.Select() | Out-Null' + __cCRLF
	cPsScript 			+= '' + __cCRLF
	cPsScript 			+= '		$sheet.UsedRange.EntireColumn.AutoFit() | Out-Null' + __cCRLF
	cPsScript 			+= '		$workbook.Sheets.Item(1).Select()' + __cCRLF   
	If lOk
		cPsScript 			+= '		if($ChartType){' + __cCRLF
   	cPsScript 		   += '			$workBook.Charts.Add() | out-null' + __cCRLF             		 		//Gera uma nova planilha somente para o grแfico 
   	cPsScript 		   += '			$workBook.ActiveChart.ChartType = "xlPie"' + __cCRLF    		//Muda o tipo do grแfico
		cPsScript 		   += '			$workBook.ActiveChart.SetSourceData($sheet)' + __cCRLF   		 		//Seleciona os dados para o grแfico
		cPsScript 		   += '			$workBook.ActiveChart.ApplyLayout("'+MV_PAR02+'")' + __cCRLF    		//Muda o layout do grแfico 
		cPsScript 		   += '			$workBook.ActiveChart.ChartStyle = "'+MV_PAR04+'"' + __cCRLF    		//Muda o Estilo do grแfico
		cPsScript 		   += '			$workBook.ActiveChart.Axes(2).Select' + __cCRLF        			 		// Seleciona Axes 2
		cPsScript 		   += '			$workBook.ActiveChart.Axes(2).MajorUnit = "'+MV_PAR03+'" ' + __cCRLF // Pula de 1 em 1//padrใo ้ 2 em 2
		cPsScript 		   += '			$workBook.ActiveChart.ChartTitle.Text = "'+MV_PAR05+'"' + __cCRLF    // Tํtulo do Grแfico 
		cPsScript 		   += '			$workBook.ActiveChart.Protect("TESTE")' + __cCRLF       					//Protege Grแfico, senha "TESTE"
		cPsScript 			+= '		}' + __cCRLF      
	EndIf
	cPsScript 			+= '		$workbook.SaveAs($Path)' + __cCRLF
	cPsScript 			+= '		$excelApp.DisplayAlerts = $originalAlerts' + __cCRLF
	cPsScript 			+= '		$excelApp.Quit()' + __cCRLF
	cPsScript 			+= '		$dummy = Release-Ref($sheet)	 | Out-Null' + __cCRLF
	cPsScript 			+= '		$dummy = Release-Ref($workbook)  | Out-Null' + __cCRLF
	cPsScript 			+= '		$dummy = Release-Ref($excelApp)  | Out-Null' + __cCRLF
	cPsScript 			+= '	}' + __cCRLF
	cPsScript 			+= '}' + __cCRLF

Return( cPsScript )
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณStrToArray บAutor ณ Eduardo Mantoan  บ Data ณ 19/05/14   	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณ StrToArray - Retorna Array baseado em string "Tokenizada"	  ฐฑฑ
ฑฑบ           				    														     ฐฑฑ
ฑฑบ                                                               		  ฐฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Masipack                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StrToArray( cString , cConcat , bAddParser )

	Local aParser	:= {}
	
	Local cParser
	
	Local nSize
	Local nParser
	Local nRealSize
	
	DEFAULT cConcat		:= "+"
	DEFAULT bAddParser	:= { || .T. }
	
	IF ( ( nParser := At( cConcat , cString ) ) > 0 )
		nRealSize	:= Len( cConcat )
		nSize 		:= Max( ( nRealSize - 1  ) , 0 )
		While ( ( nParser := At( cConcat , cString ) ) > 0 )
			IF ( nParser > 1 )
				cParser := AllTrim( SubStr( cString , 1 , ( nParser - 1 ) ) )
				cString := SubStr( cString , ( nParser + nRealSize ) )
			Else
				cParser := ""
				cString := SubStr( cString , ( nParser + nRealSize ) )
			EndIF
			IF Eval( bAddParser , @cParser )
				aAdd( aParser , cParser )
			EndIF
		End While
		IF ( !Empty( cString ) )
			cParser := AllTrim( cString )
			IF Eval( bAddParser , @cParser )
				aAdd( aParser , cParser ) 
			EndIF
		EndIF
	Else
		cParser := AllTrim( cString )
		IF Eval( bAddParser , @cParser )
			aAdd( aParser , cParser )
		EndIF
	EndIF

Return( aParser )