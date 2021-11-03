#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³QCPRO     ³ Autor ³  Cecilia              ³ Data ³ 15/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Importacao dos Componetes do QCPro.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Masipack - Alterado por Cida em 08/03/10                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RPCPA023()

Private _cArq    := Space(40)
Private _cProd   := Space(15)
Private cArquivo := ""

@ 089,177 To 330,588 Dialog _oDlg1 Title OemToAnsi("Importacao dos Componentes do QcPro.CSV")
@ 009,011 To 055,188
@ 063,011 To 100,188
@ 020,024 Say OemToAnsi("Esta rotina Importara o cadastro de Componentes") 	        Size 151,008
@ 034,024 Say OemToAnsi(" do QcPro do Excel extensao CSV para base Microsiga.") 	Size 151,008
@ 070,024 Say OemToAnsi("Arquivo para Importar:") 									Size 055,008
@ 085,024 Say OemToAnsi("Produto.................................:") 				Size 055,008
@ 070,084 Get _cArq Valid NaoVazio()   						                        Size 080,010
@ 085,084 Get _cProd F3 "SB1" Valid Existcpo("SB1") .And. NaoVazio()				Size 060,010
@ 105,110 BmpButton Type 1 Action Processa( { || OkProc() } )
@ 105,140 BmpButton Type 2 Action _oDlg1:End()

_oDlg1:lEscClose := .F.
Activate Dialog _oDlg1 Centered

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkProc    ºAutor  ³Cecilia	         º Data ³ 15/04/09    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OkProc()
Close (_oDlg1)

dDtIni:= dDataBase
dDtFim:= ctod("31/12/49")

DbSelectArea("SG1")
DbSetOrder(1)
If SG1->(dbSeek(xFilial("SG1")+_cProd))
	Do While !SG1->(Eof()) .And. Alltrim(SG1->G1_COD) == ALLTRIM(_cProd)
		RecLock("SG1", .F.,)
		SG1->(dbDelete())
		SG1->(MsUnlock())
		SG1->(DbSkip())
	EndDo
EndIf

cArquivo := U_LerCSV()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³LerCSV    ³ Autor ³  Cecilia              ³ Data ³ 15/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Abre arquivo .CSV                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"
#DEFINE OPEN_FILE_ERROR -1
User Function LerCSV()

Local cFile:= "C:\relato_microsiga\"+TRIM(_cArq)+".Csv"

If FT_FUSE( cFile ) = OPEN_FILE_ERROR
	MSGINFO("Arquivo " + cFile + " não encontrado!")
	Return
Endif

Processa({|lEnd| U_Leprod(@lEnd)},"Importação do Produto e Componentes")

Return

//***************************************************
User Function Leprod(lEnd)
Local aCab  :={}
Local nDivi := 0
Local cstring := ""

//variáveis da tabela csv
Local cComp 	:= ""
Local xGrupo	:= ""
Local cQtde 	:= ""
Local cObs		:= SPACE(50)
Local xComp1	:= ""
Local xCod1 	:= ""
Local lOK  		:= .T.
Local _nCont	:= 1
Local _nContG	:= 1
Private lMsHelpAuto := .F. // para mostrar os erro na tela
Private lMsErroAuto := .f.

ProcRegua( FT_FLASTREC() )

While !FT_FEOF()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ linha do arquivo retorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer := FT_FREADLN()
	
	IncProc()
	
	IF SubStr(cNumEmp,1,2)=="10"
		cNivel	:= "1"
		
		nDivi   := At(";",xBuffer)
		cComp   := Substr( xBuffer , 1, nDivi - 1)
		cComp   := cComp + space( 6-len(cComp))
		
		xBuffer := Substr(xBuffer , nDivi+1)
		nDivi   := At(";",xBuffer)
		//	cQtde   := xBuffer
		cQtde   := Substr(xBuffer,1,  nDivi - 1)
		nQtde   := Val(cQtde)
		
		xBuffer  := Substr(xBuffer , nDivi+1)
		nDivi    := At(";",xBuffer)
		cObs	 := xBuffer
	ELSE
		nDivi   := At(";",xBuffer)
		cNivel  := Substr( xBuffer , 1, nDivi - 1)
		
		xBuffer := Substr(xBuffer , nDivi+1)
		cComp   := Substr( xBuffer , 1, nDivi - 1)
		cComp   := cComp + space( 6-len(cComp))
		
		xBuffer := Substr(xBuffer , nDivi+1)
		nDivi   := At(";",xBuffer)
		cQtde   := xBuffer
		//		cQtde   := Substr(xBuffer,1,  nDivi - 1)
		nQtde   := Val(cQtde)
	ENDIF
	IF Alltrim(cNivel)=="1"
		xCod  := Alltrim(_cProd)+"-"
		DbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+xCod))
			xCod1 := B1_COD
			nAch    := At("-",xCod1)
			xComp   := Substr(xCod1 , nAch+1)
			xComp1  := xComp
		EndIf
		//-- Se o Componente for Pai, Adiciona sua Estrutura
		SG1->(dbSetOrder(1))
		If !SG1->(dbSeek(xFilial('SG1')+Alltrim(_cProd)+Alltrim(cComp),.F.))
			
			cComp1 := ""
			DbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+cComp))
				If Trim(SB1->B1_GRUPO) == Alltrim(xComp1)
					cComp1 := Alltrim(cComp)+"-"+Alltrim(xComp1)
					if xGrupo = ""
						RecLock("SG1",.t.)
						SG1->G1_FILIAL  := xFilial("SG1")
						SG1->G1_COD     := _cProd
						SG1->G1_COMP    := xCod1
						SG1->G1_TRT     := IIF(SubStr(cNumEmp,1,2)=="01","001",STRZERO(_nCont,3))
						SG1->G1_QUANT   := 1
						SG1->G1_INI     := dDtIni - 365
						SG1->G1_MSDTINI := dDtIni
						SG1->G1_FIM     := dDtFim
						SG1->G1_OBSERV  := cObs
						SG1->(MsUnLock())
						xGrupo := "S"
						_nCont++
					endif
				endif
			Else
				Alert("Componente não Cadastrado,não foi importado para Estrutura "+cComp,NIL)
				FT_FSKIP()
				Loop
			EndIf
			
			If !Empty(xCod1) .and. !Empty(cComp1)
				
				RecLock("SG1",.t.)
				SG1->G1_FILIAL  := xFilial("SG1")
				SG1->G1_COD     := xCod1
				SG1->G1_COMP    := Alltrim(cComp)
				SG1->G1_TRT     := IIF(SubStr(cNumEmp,1,2)=="01","001",STRZERO(_nContG,3))
				SG1->G1_QUANT   := nQtde
				SG1->G1_INI     := dDtIni - 365
				SG1->G1_MSDTINI := dDtIni
				SG1->G1_FIM     := dDtFim
				SG1->G1_OBSERV  := cObs
				SG1->(MsUnLock())
				cComp1 := ""
				_nContG++
			Else
				
				RecLock("SG1",.t.)
				SG1->G1_FILIAL  := xFilial("SG1")
				SG1->G1_COD     := _cProd
				SG1->G1_COMP    := Alltrim(cComp)
				SG1->G1_TRT     := IIF(SubStr(cNumEmp,1,2)=="01","001",STRZERO(_nContG,3))
				SG1->G1_QUANT   := nQtde
				SG1->G1_INI     := dDtIni - 365
				SG1->G1_MSDTINI := dDtIni
				SG1->G1_FIM     := dDtFim
				SG1->G1_OBSERV  := cObs
				SG1->(MsUnLock())
				_nContG++
			endif
		endif
	ENDIF
	FT_FSKIP()
EndDo
If lOK
	MSGInfo("Processo de importação finalizado com Sucesso !!!")
Else
	MsgAlert("Problemas na importação, por favor, avise ao Administrador do Sistema...")
Endif

Return
