#Include "Topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"
#DEFINE OPEN_FILE_ERROR -1

/*               
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPA029  ºAutor  ³Lizandra Marques    º Data ³  23/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para selecao de componentes para importacao de       º±±
±±º          ³estrutura.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RPCPA029()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Private oLeTxt
Private _cArq    := Space(08)
Private _cProd   := Space(15)
Private cString := ""

SG1->(dbSetOrder(1)) // ESTRUTURA
SB1->(dbSetOrder(1)) // PRODUTOS


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 089,177 To 330,588 Dialog oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 009,011 To 055,188
@ 063,011 To 100,188
@ 020,024 Say OemToAnsi("Esta rotina Importara o cadastro de Componentes")	Size 151,008
@ 034,024 Say OemToAnsi("do Solid Edge (arquivo txt) para base Microsiga.")	Size 151,008
@ 070,024 Say OemToAnsi("Arquivo para Importar:") 							Size 055,008
@ 085,024 Say OemToAnsi("Produto.................................:") 		Size 055,008
@ 070,084 Get _cArq Valid NaoVazio()   						                Size 080,010
@ 085,084 Get _cProd F3 "SB1" Valid Existcpo("SB1") .And. NaoVazio()		Size 060,010

@ 105,110 BMPBUTTON TYPE 01 ACTION Processa( { || OkLeTxt()})
@ 105,140 BMPBUTTON TYPE 02 ACTION oLeTxt:End()

oLeTxt:lEscClose := .F.

Activate Dialog oLeTxt Centered

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkLeTxt   ºAutor  ³Lizandra Marques    º Data ³  23/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para montar arquivo temporario e atualiza-lo.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkLeTxt()

Local _aCampos := {}
Local oTable

Close (oLeTxt)

_aCampos := {	{ "TM_OK","C",02,00},;
{ "TM_LINHA" ,"C",03,00	},;
{ "TM_NIV"   ,"C",02,00	},;
{ "TM_CODIGO","C",15,00	},;
{ "TM_COMPON","C",15,00	},;
{ "TM_DESCRI","C",35,00	},;
{ "TM_QUANT" ,"N",12,02 }}

oTable := FWTemporaryTable():New("TMP",_aCampos)
oTable:AddIndex( "IND1", {'TM_CODIGO','TM_COMPON'} )
oTable:AddIndex( "IND2", {'TM_LINHA','TM_CODIGO'} )
oTable:Create()

TMP->(DbSetOrder(1))
TMP->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cArqTxt := "c:\relato_microsiga\"+TRIM(_cArq)+".TXT"

//Verifica se arquivo tem conteúdo
If FT_FUSE( _cArqTxt ) = OPEN_FILE_ERROR
	MsgAlert( _cArqTxt + " nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
EndIf       

//Posiciona no primeiro registro
FT_FGOTOP()


dDtIni:= dDataBase                            
dDtFim:= ctod("31/12/49")

//Deleta estrutura antiga
If SG1->(dbSeek(xFilial("SG1")+_cProd))
	Do While !SG1->(Eof()) .And. Alltrim(SG1->G1_COD) == ALLTRIM(_cProd)
		RecLock("SG1", .F.,)
		SG1->(dbDelete())
		SG1->(MsUnlock())
		SG1->(DbSkip())
	EndDo
EndIf

_nLinha:=1
//Le arquivo linha a linha         
                 
Do While !FT_FEOF()
	
	//Carrega uma linha do arquivo
	cLinha := FT_FREADLN()             
	
	_cNIVEL 	:= Substr(cLinha,01,20)
	_cCODIGO	:= Substr(cLinha,22,20)
	_cCODIGO	:= STRTRAN(_cCODIGO,".","")
	_nQTDE 		:= Substr(cLinha,45,06)
	_cDESCR		:= SPACE(35)         
	
	IF Substr(cLinha,01,01) <>"B" .AND. Substr(cLinha,01,01) <> "L"    // IGNORA AS DUAS PRIMEIRAS LINHAS

		If !SB1->(dbSeek(xFilial("SB1")+ALLTRIM(SUBSTR(_cCODIGO,1,15)))) // VERIFICA EXISTENCIA DO COMPONENTE NO CADASTRO DE PRODUTOS
			_cDESCR		:= "*********************************"
		ELSE
			_cDESCR		:= SB1->B1_DESC
		Endif	

		If TMP->(dbSeek(_cProd+ALLTRIM(SUBSTR(_cCODIGO,1,15))))
				
				RecLock("TMP",.F.)
				TMP->TM_QUANT   += VAL(_nQtde)      
				TMP->(MsUnLock())
        Else     
        	RecLock("TMP",.t.)
			TMP->TM_LINHA	:= STRZERO(_nLinha,3)
			TMP->TM_NIV		:= ALLTRIM(_cNIVEL)
			TMP->TM_CODIGO	:= _cProd
			TMP->TM_COMPON	:= SUBSTR(_cCODIGO,1,15)
			TMP->TM_QUANT	:= VAL(_nQtde)
			TMP->TM_DESCRI	:= _cDESCR   
			_nLinha++
			TMP->(MsUnLock())
		Endif	

	Endif
	//Proxima linha
	FT_FSKIP()

EndDo

fEscolha()

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEscolha  ºAutor  ³Lizandra Marques    º Data ³  23/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para selecionar componentes da estrutura            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fEscolha()


Private _oDlg1
Private aBut311 	:= {}
Private nOpca 		:= 0
Private lInverte	:= .T.
//Private _nOpc		:= 1
//Private aCols		:= {}
//Private aRotina 	:= {"Componentes","fEscolha",0,4,0,nil}
//Private _cCampos 	:= {}
//_nOpc	:= aRotina
aCampos := {}

AADD(aCampos,{"TM_OK"    ,"","OK",})
AADD(aCampos,{"TM_LINHA" ,"","Linha",})
AADD(aCampos,{"TM_NIV"   ,"","Nivel",""})
AADD(aCampos,{"TM_CODIGO","","Codigo",""})
AADD(aCampos,{"TM_COMPON","","Componente",""})
AADD(aCampos,{"TM_QUANT" ,"","Quantidade",""})
AADD(aCampos,{"TM_DESCRI","","Descricao",""})

//aSize := MSADVSIZE()


aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 030 , .T., .F. } )
AAdd( aObjects, { 100, 070 , .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj 	:= MsObjSize( aInfo, aObjects,.T.)

DbSelectArea("TMP")
TMP->(DbSetOrder(2))
TMP->(DbGoTop())

cMarca := GetMark()

DEFINE MSDIALOG _oDlg1 TITLE "Selecione as componentes para gerar a estrutura." From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
//³ arquivo de trabalho "TMP".                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If FlatMode()
	aCoors := GetScreenRes()
	nHeight	:= aCoors[2]
	nWidth	:= aCoors[1]
Else
	nHeight	:= 143
	nWidth	:= 315
Endif
                
//_cCampos :={"TM_QUANT"}
// Monta folder  



oFld := TFolder():New(15,1,{"Componentes"},;
{"TMP"},_oDlg1,,,,.T.,.F.,aPosObj[1,4],aPosObj[1,3]-10)
aFld := oFld:aDialogs
aEval(aFld,{|x| x:SetFont(_oDlg1:oFont) })
//oGetd   :=  MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpc,,,_cCampos,,,,,,,,,,,)	


oMark := MsSelect():New("TMP","TM_OK",,aCampos,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})

//	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT // Somente Interface MDI
  

//oMark:oBrowse:lhasMark = .t.
//oMark:oBrowse:lCanAllmark := .t.

ACTIVATE MSDIALOG _oDlg1 ON INIT  (EnchoiceBar(_oDlg1,{|| (nOpca := 1,_oDlg1:End()) },;
{|| nOpca := 2,_oDlg1:End()},,aBut311),oMark:oBrowse:Refresh()) CENTERED

If nOpca == 1
	TMP->(DbGoTop())
	If ApMsgYesNo("Confirma a Inclusao da estrutura ??","Confirmar")
		fGera()	// chamada da inclusao da estrutura
	EndIf
EndIf

TMP->(DbCloseArea())
Ferase(_cArqTmp+".DBF")
Ferase(_cIndTmp+OrdBagExt())
Ferase(_cIndTmp2+OrdBagExt())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGera     ºAutor  ³Lizandra Marques    º Data ³  23/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para incluir estruturas                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGera() 


TMP->(DbGoTop())
SG1->(DbSetOrder(1))

Do While ! TMP->(Eof())

	If TMP->TM_OK <> cMarca .AND. SUBSTR(TMP->TM_DESCRI,1,7) <> "*******"

		RecLock("SG1",.T.)
	
		SG1->G1_FILIAL  := xFilial("SG1")
		SG1->G1_COD     := TMP->TM_CODIGO
		SG1->G1_COMP    := TMP->TM_COMPON
		SG1->G1_TRT     := "001"
		SG1->G1_QUANT   := TMP->TM_QUANT
		SG1->G1_INI     := dDtIni - 365
		SG1->G1_MSDTINI := dDtIni
		SG1->G1_FIM     := dDtFim
		SG1->G1_NIV		:= "01"
		SG1->(MsUnLock())
		MSUnLock()
	Endif	

	TMP->(dbSkip())
EndDo

Return
