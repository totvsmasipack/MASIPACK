#include 'totvs.ch'
#include 'protheus.ch'
#include 'msole.ch'
#include 'fileio.ch'


User Function RFATR080()

Local aParam	:= {}

	aAdd(aParam,{1,	"Pedido Venda Inicial",	SPACE(TamSX3('C5_NUM')[1]),"","","","",50,.T.}) 
	aAdd(aParam,{1,	"Pedido Venda Final",	SPACE(TamSX3('C5_NUM')[1]),"","","","",50,.T.}) 
	
	If ParamBox(aParam,"Parâmetros",,,,,,,,.T.,.T.)

		FwMsgRun(,{|oSay| IntMsWord(oSay) }, 'Aguarde', 'Processando..')

    Endif

Return


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

	While SC5->(!EOF()) .And. SC5->C5_NUM <= MV_PAR02

		oSay:SetText('Imprimindo o pedido ' + SC5->C5_NUM )

		oWord := OLE_CreateLink(,,.T.)
		OLE_SetProperty(oWord, oleWdVisible, .F.)

		If SC5->C5_MSTPVEN $ 'AC|'
			cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_checklist_pecas_acessorios.dotm'
		ElseIf SC5->C5_MSTPVEN $ 'BL|'
			cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_checklist_balanca.dotm'
		ElseIf SC5->C5_MSTPVEN $ 'MV|'
			cDocFile := GetSrvProfString('Startpath','') + 'modelos\pcp\'+FWCodEmp()+'_checklist_maq_verticais.dotm'
		Endif

		If !FwIsAdmin()

			CpyS2T(cDocFile, "C:\relato_microsiga\")

			FRename( AllTrim(GetTempPath()) + If(Right(AllTrim(GetTempPath()), 1) == '\', '', '\') + SubStr(cDocFile,RAT('\',cDocFile)+1,Len(cDocFile)),;
					"C:\relato_microsiga\" + SC5->C5_NUM + '.dotm')

			cModFile := "C:\relato_microsiga\" + SC5->C5_NUM + '.dotm'
		
		Else

			CpyS2T(cDocFile, AllTrim(GetTempPath()))
			
			FRename( AllTrim(GetTempPath()) + If(Right(AllTrim(GetTempPath()), 1) == '\', '', '\') + SubStr(cDocFile,RAT('\',cDocFile)+1,Len(cDocFile)),;
					AllTrim(GetTempPath()) + If(Right(AllTrim(GetTempPath()), 1) == '\', '', '\') + SC5->C5_NUM + '.dotm')

			cModFile := AllTrim(GetTempPath()) + If(Right(AllTrim(GetTempPath()), 1) == '\', '', '\') + SC5->C5_NUM + '.dotm'

		Endif
		
		OLE_NewFile(oWord, Alltrim(cModFile))

		OLE_SetDocumentVar(oWord, 'cNumero',	ALLTRIM(SC5->C5_NUM)	)
		OLE_SetDocumentVar(oWord, 'cCliente',	ALLTRIM(SA1->A1_NREDUZ)	)
		
		OLE_UpdateFields(oWord)

		OLE_PrintFile(oWord, cModFile,,, 1)
		Sleep(7000)

		OLE_CloseFile(oWord)
		OLE_CloseLink(oWord)

		FErase(cModFile)

		SC5->(DbSkip())
	
	Enddo

Return
