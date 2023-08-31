#include 'totvs.ch'
#include 'protheus.ch'
#include 'msole.ch'
#include 'fileio.ch'


/*/{Protheus.doc} User Function RFATR080
Relatório de Check-Lista da montagem (Nova Versão)
@type  Function
@author E.DINIZ - [ DS2U ]
@since 01/02/2022
/*/
User Function RFATR080()

Local aOption	:= {"1=Peças/Acessórios", "2=Balança - Montagem", "3=Balança - Teste" , "4=Vertical - Montagem", "5=Vertical - Teste", "6=Montagem Horizontal", "7=Horizontal Teste", "10=Eletrica Montagem"}
Local aParam	:= {}

	AADD(aParam,{1,	"Nº Pedido",		SPACE(TamSX3('C5_NUM')[1]),"","","","",050,	.T.}) 
	AADD(aParam,{2,	"Modelo Docto.",	"1",	aOption,	090,	"",		.T.})
	
	If ParamBox(aParam,"Parâmetros",,,,,,,,.T.,.T.)
		FwMsgRun(,{|oSay| IntMsWord(oSay) }, 'Aguarde', 'Processando..')
    Endif

Return


/*/{Protheus.doc} User Function IntMsWord
Atualiza o documento word conforme informações
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 01/02/2022
/*/
Static Function IntMsWord(oSay)

Local cDocFile	:= ''
Local cModFile	:= ''
Local oWord		:= Nil

	DbSelectArea('SC5')
	SC5->( DbSetOrder(1) )
	SC5->( DbSeek( FWxFilial('SC5') + PadR(MV_PAR01,TamSX3('C5_NUM')[1]) ) )

	DbSelectArea('SA1')
	SA1->( DbSetOrder(1) )
	SA1->( DbSeek( FWxFilial('SA1') + PadR(SC5->C5_CLIENTE,TamSX3('C5_CLIENTE')[1]) + PadR(SC5->C5_LOJACLI,TamSX3('C5_LOJACLI')[1]) ))

	If SC5->(!FOUND())
		FwAlertError( "Pedido " + MV_PAR01 + " não localizado." + CRLF + "Impressão do relatório abortada.", "A T E N Ç Ã O" )
		Return
	Endif

	oSay:SetText('Imprimindo o pedido ' + SC5->C5_NUM )

	oWord := OLE_CreateLink(,,.T.)
	OLE_SetProperty(oWord, oleWdVisible, .F.)

	If MV_PAR02 == '1'
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_01_Pecas_e_Acessorios.dotm'
	ElseIf MV_PAR02 == '2'
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_02_Balanca_Montagem.dotm'
	ElseIf MV_PAR02 == '3'
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_03_Balanca_Teste.dotm'
	ElseIf MV_PAR02 == '4'
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_04_Vertical_Montagem.dotm'
	ElseIf MV_PAR02 == '5'
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_05_Maq_Vertical_Teste.dotm'
	ElseIf MV_PAR02 == '6'
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_06_Horizontal_Montagem.dotm'
	ElseIf MV_PAR02 == '7'
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_07_Horizontal_Teste.dotm'
	Else
		cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_10_Eletrica_Montagem_2.dotm'
	Endif

	If !FwIsAdmin() 

		CpyS2T(cDocFile, "C:\relato_microsiga\")

		FRename( "C:\relato_microsiga\" + SubStr(cDocFile,RAT('\',cDocFile)+1,Len(cDocFile)),;
				"C:\relato_microsiga\" + SC5->C5_NUM + '.dotm')

		cModFile := "C:\relato_microsiga\" + SC5->C5_NUM + '.dotm'
	
	Else

		CpyS2T(cDocFile, AllTrim(GetTempPath()))
		
		FRename( AllTrim(GetTempPath()) + If(Right(AllTrim(GetTempPath()), 1) == '\', '', '\') + SubStr(cDocFile,RAT('\',cDocFile)+1,Len(cDocFile)),;
				AllTrim(GetTempPath()) + If(Right(AllTrim(GetTempPath()), 1) == '\', '', '\') + SC5->C5_NUM + '.dotm')

		cModFile := AllTrim(GetTempPath()) + If(Right(AllTrim(GetTempPath()), 1) == '\', '', '\') + SC5->C5_NUM + '.dotm'

	Endif
	
	OLE_NewFile(oWord, Alltrim(cModFile))

	OLE_SetDocumentVar(oWord, 'cNumero' ,	ALLTRIM(SC5->C5_NUM)	)
	OLE_SetDocumentVar(oWord, 'cCliente',	ALLTRIM(SA1->A1_NREDUZ)	)
	OLE_SetDocumentVar(oWord, 'cData'   ,	dToc(Date())			)
	
	OLE_UpdateFields(oWord)

	OLE_PrintFile(oWord, cModFile,,, 1)
	Sleep(7000)

	OLE_CloseFile(oWord)
	OLE_CloseLink(oWord)

	FErase(cModFile)

Return
