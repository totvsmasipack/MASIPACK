#INCLUDE "TOTVS.CH"
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#Include "Xmlxfun.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "shell.ch"     
#include "apwizard.ch"
#include "TBICONN.CH"

#IFDEF WINDOWS
#ENDIF

/*/{Protheus.doc} lerxml
//TODO DescriГЦo: Importacao arquivo xml nota eletronica.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type function
/*/
User Function lerxml()

Local i		:= 0
Local nXml := 0

	Private cHtmlQbr := '<br />' /*AGoncalves - ticket 2018020737000257 - Ajuste de layout de e-mail / correГЦo qtd SC*/
	Private cXml     := '',oXml
	Private XCODFOR  := ""
	Private cProdAnt := ""
	Private _cMsgCab := ""
	Private _cMsgItem:= ""
	Private lAtuA5   := .T.
	Private nTMoeda  := 1
	Private lVerPCS  := .F.  
	Private lAlteraPc:= .F.   
	Private aC7Itens := {}
	Private _aSolic  := {}
	Private XCFOP    := ""       
	Private cTipoCte := ''

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Fontes do windows usadas															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды     

	DEFINE FONT oFont1 NAME "Arial Black" SIZE 6,17
	DEFINE FONT oFont2 NAME "Courier New" SIZE 8,14
	DEFINE FONT oFont3 NAME "Arial Black" SIZE 13,20
	DEFINE FONT oFont4 NAME "Arial Black" SIZE 13,15
	DEFINE FONT oFont5 NAME "Arial Black" SIZE 7,17
	DEFINE FONT oFont6 NAME "Courier New" SIZE 6,20
	DEFINE FONT oFont7 NAME "Courier New" SIZE 7,20

	cIniFile 		:= GetADV97()
	cStartPath 	:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'XML\ENTRADA\'+DTOC(DDATABASE)+'\'

	//CRIA DIRETORIOS
	MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'XML\ENTRADA\'+DTOC(DDATABASE)+'\')
	MakeDir(Trim(cStartPath)) //CRIA DIRETсRIO


	_cUsuario:=ALLTRIM(UPPER(SUBSTR(CUSUARIO,7,15)))
	_cEmpresa:=SM0->M0_CODIGO
	_CNUMEMP := _cEmpresa
	_cCorrente:=Alltrim(SM0->M0_CODFIL)
	_cCNPJ := SM0->M0_CGC
	cArqTxt := "\xml\config\cfgxml.txt"
//	cArqTxt := "\\10.45.10.8\Totvs\Fabrica\Data\xml\config\cfgxml.txt"
	lCheck2:=.F.
	cNCM:=''  
	cCST:=""
	cDecQtd:=2
	cDecUni:=7

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Criando parametro do programa												   Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("SX6")
	DbSetorder(1)
	DbgoTop()
	Dbseek(xFilial("SD1")+"MV_GRVPEDI")
	If !Found()
		Reclock("SX6",.T.)
		SX6->X6_FIL:=xFilial("SD1")
		SX6->X6_VAR:="MV_GRVPEDI"
		SX6->X6_TIPO:="C"
		SX6->X6_DESCRIC:="Controle de gravacao pedidos de compras"
		MsUnlock()
	Endif

	Private _cFrete := 0
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando se o usuario ficou preco na ultima gravacao do pedido	Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_lGrava:=ALLTRIM(UPPER(Getmv("MV_GRVPEDI")))
	If _lGrava==_cUsuario
		DbSelectArea("SX6")
		DbgoTop()
		While ! eof()
			If Alltrim(SX6->X6_VAR)=="MV_GRVPEDI" .and. SX6->X6_FIL==xFilial("SC7")
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD:=""
				MsUnlock()
			Endif
			DbSkip()
		End
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Manipulando arquivo de configuracao			 3						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If File(cArqTxt) .and. (Upper(_cUsuario)=="ADMINISTRADOR")
		CONFARQ()
	Endif

	xxpedcom:=msgbox("Deseja Processar com Pedido de Compras ?","AtenГЦo...","YESNO")       

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Filial e empresa atual												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("SM0")
	Dbsetorder(1)
	Dbgotop()
	Dbseek(_cEmpresa+_cCorrente)

	_cEmpresa:=SM0->M0_CODIGO
	_cCorrente:=Alltrim(SM0->M0_CODFIL)
	_cCNPJ := SM0->M0_CGC

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Lendo o arquivo de configuracao										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cBuffer   := ""

	IF !File("\xml")
		msgbox("NЦo existe o diretСrio XML no ROOTPATH")
		Return
	Endif

	IF !File("\xml\config")
		msgbox("NЦo existe o diretСrio CONFIG no diretСrio \XML")
		Return
	Endif

	// tratamento de empresas
	IF _CNUMEMP=="01"
		IF !File("\xml\ArquivaMasipack")
			msgbox("NЦo existe o diretСrio ArquivaMasipack no diretСrio \XML")
			Return
		Endif
	ENDIF

	IF _CNUMEMP=="10"
		IF !File("\xml\ArquivaFabrima")
			msgbox("NЦo existe o diretСrio ArquivaFabrima no diretСrio \XML")
			Return
		Endif
	ENDIF

	IF _CNUMEMP=="15"
		IF !File("\xml\ArquivaHelsimplast")
			msgbox("NЦo existe o diretСrio ArquivaHelsimplast no diretСrio \XML")
			Return
		Endif
	ENDIF

	IF _CNUMEMP=="40"
		IF !File("\xml\ArquivaLabortube")
			msgbox("NЦo existe o diretСrio ArquivaLabortube no diretСrio \XML")
			Return
		Endif
	ENDIF

	IF _CNUMEMP=="45"
		IF !File("\xml\ArquivaMemb")
			msgbox("NЦo existe o diretСrio ArquivaMemb no diretСrio \XML")
			Return
		Endif
	ENDIF


	//IF !File("\xml\arquivados")
	//	msgbox("NЦo existe o diretСrio Arquivados no diretСrio \XML")
	//	Return
	//Endif

	IF !File("\xml\importados")
		msgbox("NЦo existe o diretСrio IMPORTADOS no diretСrio \XML")
		Return
	Endif
	IF !File("\xml\duplicados")
		msgbox("NЦo existe o diretСrio DUPLICADOS no diretСrio \XML")
		Return
	Endif
	IF !File("\xml\recusadas")
		msgbox("NЦo existe o diretСrio RECUSADAS no diretСrio \XML")
		Return
	Endif
	IF !File("\xml\corrompidos")
		msgbox("NЦo existe o diretСrio CORROMPIDOS no diretСrio \XML")
		Return
	Endif

	cSerie:=''
	cEspecie:=''
	cAlmox:=''
	cUnidades:=''
	cPedCom:=.F.
	cNDF:=.F.
	cAlmoPed:=space(02)
	cZeros:=.F.
	cDecUni:=7
	cDecQtd:=4

	xEMAILREC:=""//"horacio_laterza@yahoo.com.br"
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Analisando configuracoes da rotina									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If File(cArqTxt)
		FT_FUSE(cArqTxt)
		FT_FGOTOP()
		ProcRegua(FT_FLASTREC())

		While !FT_FEOF()
			cBuffer := FT_FREADLN()

			If UPPER(SUBSTR(cBuffer,1,9))=="EMAIL"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
				xEMAILREC:=lower(ALLTRIM(SUBSTR(cBuffer,11,400)))
			Endif
			If UPPER(SUBSTR(cBuffer,1,3))=="POP"
				xPOP:=lower(ALLTRIM(SUBSTR(cBuffer,5,400)))
			Endif
			If UPPER(SUBSTR(cBuffer,1,5))=="CONTA"
				xCONTA:=lower(ALLTRIM(SUBSTR(cBuffer,7,400)))
			Endif
			If UPPER(SUBSTR(cBuffer,1,5))=="SENHA"
				xSENHA:=ALLTRIM(SUBSTR(cBuffer,7,400))
			Endif
			If UPPER(SUBSTR(cBuffer,1,4))==SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
				cSerie:=UPPER(SUBSTR(cBuffer,6,3))
			Endif
			If UPPER(SUBSTR(cBuffer,1,7))=="ESP"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
				cEspecie:= "SPED" //UPPER(SUBSTR(cBuffer,9,5))
			Endif
			If UPPER(SUBSTR(cBuffer,1,10))=="DECQTD0101" //"DECQTD"+SM0->M0_CODIGO+SM0->M0_CODFIL
				cDecQtd:=UPPER(SUBSTR(cBuffer,12,2))
			Endif
			If UPPER(SUBSTR(cBuffer,1,10))=="DECUNI0101"//"DECUNI"+SM0->M0_CODIGO+SM0->M0_CODFIL
				cDecUni:=UPPER(SUBSTR(cBuffer,12,2))
			Endif
			If UPPER(SUBSTR(cBuffer,1,2))=="UM"
				cUnidades:=ALLTRIM(UPPER(SUBSTR(cBuffer,4,400)))
			Endif
			If UPPER(SUBSTR(cBuffer,1,4))=="LOGO"
				cLogo:=ALLTRIM(UPPER(SUBSTR(cBuffer,6,200)))+space(200)
			Endif
			If UPPER(SUBSTR(cBuffer,1,6))=="PEDIDO"
				cPedCom:=.T.
			Endif
			If UPPER(SUBSTR(cBuffer,1,3))=="NDF"
				cNDF:=.T.
			Endif
			If UPPER(SUBSTR(cBuffer,1,7))=="NFZEROS"
				cZeros:=.T.
			Endif
			If UPPER(SUBSTR(cBuffer,1,11))=="PEDPROD=SIM"
				lCheck2:=.T.
			Endif
			if !xxpedcom
				cPedCom:=.f. 
				lCheck2:=.f.
			endif
			FT_FSKIP()
		EndDo
		FT_FUSE()
	Else
		Msgbox("Arquivo de configuracao CFGXML.TXT nЦo encontrado no diretСrio \XML\CONFIG")
		Return
	Endif

	cSerieNF:=cSerie

	If Empty(cUnidades)
		Msgbox("Favor informar as Unidades de medidas fracionadas!")
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Recebendo emails dos fornecedores									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	MsgRun("Recebendo XML "+xCONTA,,{||POPEMAIL()})

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando arquivos diferentes de XML									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aXML	:={}
	_aCpyxml:={}

	_cLogin:= LogUserName()
		
	ADir("C:\Users\"+Alltrim(_cLogin)+"\Downloads\*.xml",_aCpyxml)
	For nXml := 1 to len(_aCpyxml)
		lRetCpy := CpyT2S( "C:\Users\"+_cLogin+"\Downloads\"+_aCpyxml[nXml], "\xml", .F. )
		If lRetCpy
			WaitRun("cmd /c del "+"C:\Users\"+_cLogin+"\Downloads\"+_aCpyxml[nXml],0)
		Else
			ApMsgAlert("Erro ao copiar arquivo"+_aCpyxml[nXml])
			Return
		Endif
	Next

	ADir("\xml\*.*",aXML)
	_cCNPJ2:=""

	For i:=1 to len(aXML)
		If "XML" $ UPPER(ALLTRIM(aXML[i]))
			XMLCGC(i)
		endif

		If !"XML" $ UPPER(ALLTRIM(aXML[i]))
			ferase("\xml\"+lower(ALLTRIM(aXML[i])))
		Endif

	Next

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Resolucao da tela													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aSize := MsAdvSize()
	IF aSize[5] >=1220
		_nTop:=760
		_nRight:=1225
		_nSize:=590
	Else
		@ 120,040 TO 750,1010 DIALOG oTela TITLE "ImportaГЦo nota fiscal eletrТnica - "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+"-"+SM0->M0_FILIAL
		_nTop:=750
		_nRight:=1010
		_nSize:=485
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Lista dos XML dos fornecedores										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aXML:={}
	ADir("\xml\*.xml",aXML)

	If Len(aXml)==0
		Msgbox("NЦo existem arquivos para serem importados no momento...","AtenГЦo...","INFO")
		Return
	Endif

	IF SELECT("LS5") > 0
		DBSELECTAREA("LS5")
		DBCLOSEAREA()
	ENDIF
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Produto alterados													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aCampos5:= {{"PRODUTO","C",15,0 }}

	cArqTrab5  := CriaTrab(aCampos5)
	dbUseArea( .T.,, cArqTrab5, "LS5", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS5",cArqTrab5,"PRODUTO",,,)
	dbSetIndex( cArqTrab5 +OrdBagExt())
	dbSelectArea("LS5")

	cDecUni:=val(cDecUni)
	cDecQtd:=val(cDecQtd)

	aCampos	:= {{"SEQ","N",5,0 },;
	{"OK","C",1,0 },;
	{"CODBAR","C",15,0 },;
	{"PRODUTO","C",15,0 },;
	{"PRODFOR","C",15,0 },;
	{"CERTIF","C",20,0 },;
	{"DESCRICAO","C",50,0 },;
	{"DESCORI","C",50,0 },;
	{"UM","C",2,0 },;
	{"QE","N",12,5 },;
	{"CAIXAS","N",18,6 },;
	{"NCM","C",10,0 },;
	{"CST","C",3,0 },;
	{"QUANTIDADE","N",18,6},;
	{"PRECO","N",18,7 },;
	{"CUSTO","N",18,7 },;
	{"PRECOFOR","N",18,7},;
	{"TOTAL","N",18,7 },;
	{"DESCONTO","N",12,2 },;
	{"EMISSAO","C",8,0 },;
	{"PEDIDO","C",6,0 },;
	{"ITEM","C",4,0 },;
	{"TES","C",3,0 },;
	{"ALMOX","C",2,0 },;
	{"ALTERADO","C",1,0 },;
	{"NOME","C",35,0 },;
	{"NOTA","C",9,0 } ,;
	{"CFOP","C",4,0 }}

	IF SELECT("LS1") > 0
		DBSELECTAREA("LS1")
		DBCLOSEAREA()
	ENDIF
	cArqTrab  := CriaTrab(aCampos)
	dbUseArea( .T.,, cArqTrab, "LS1", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS1",cArqTrab,"SEQ",,,)
	dbSetIndex( cArqTrab +OrdBagExt())
	dbSelectArea("LS1")

	aCampos3:= {{"EMISSAO","D",8,0 },;
	{"FORNEC","C",6,0 },;
	{"LOJA","C",2,0 },;
	{"NOTA","C",9,0 },;
	{"NOME","C",35,0 },;
	{"VENDEDOR","C",30,0 },;
	{"TELEFONE","C",20,0 },;
	{"XML","C",150,0 },;
	{"CHAVE","C",60,0 },;
	{"FRETE","N",14,0 }}

	cArqTrab3  := CriaTrab(aCampos3)
	dbUseArea( .T.,, cArqTrab3, "LS3", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS3",cArqTrab3,"NOME+NOTA",,,)
	dbSetIndex( cArqTrab3 +OrdBagExt())
	dbSelectArea("LS3")

	_cCNPJ:=''
	lAchou:=.f.

	#IFDEF WINDOWS
	Processa({|| XMLFOUND()})
Return

/*/{Protheus.doc} XMLFOUND
//TODO DescriГЦo: Localiza e processa o XML.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function XMLFOUND()

Local i := 0
Local w := 0

	#ENDIF

	aCampos4:= {{"NOTA","C",9,0 },;
	{"FORNECEDOR","C",6,0 },;
	{"CERTIF","C",20,0 },;
	{"LOJA","C",2,0 }}

	cArqTrab4  := CriaTrab(aCampos4)
	dbUseArea( .T.,, cArqTrab4, "LS4", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS4",cArqTrab4,"FORNECEDOR+LOJA+NOTA",,,)
	dbSetIndex( cArqTrab4 +OrdBagExt())
	dbSelectArea("LS4")

	cNota:=''
	cEmissao:=''
	cChave:=''
	_cOpcao:=''

	Procregua(len(aXML))
	For i:=1 to len(aXML)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Dados do XML														Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		XML(i)
		IF SELECT("MTMP") > 0
			DBSELECTAREA("MTMP")
			DBCLOSEAREA()
		ENDIF
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Fornecedor															Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !Empty(_cCNPJ)

			cQueryM	:= "UPDATE " + RetSqlName("SC7") + " SET C7_MSCGC = A2_CGC FROM " + RetSqlName("SC7") + " C7 , " + RetSqlName("SA2") +" A2 "
			cQueryM	+=  " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND A2_FILIAL ='"+xFilial("SA2")+"' AND A2.D_E_L_E_T_<>'*' AND C7.D_E_L_E_T_<>'*' "
			cQueryM	+=  " AND C7_MSCGC=''  "
			TCSQLEXEC(cQuerYM)

			cQueryM	:= "SELECT * "
			cQueryM	+= " FROM " + RetSqlName("SA2") 
			cQueryM	+= " WHERE D_E_L_E_T_ <> '*' "
			cQueryM	+= " AND A2_MSBLQL<>1  AND A2_CGC= '" + _cCNPJ + "' "
			cQueryM	+= " AND A2_COD NOT LIKE 'IMP%'"
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQueryM) , 'MTMP', .T., .F.)

			XCODFOR := ""
			XLOJAFO := 0
			DBSELECTAREA("MTMP")
			DBGOTOP()
			WHILE !EOF()
				XCODFOR := MTMP->A2_COD
				XLOJAFO := MTMP->A2_LOJA
				DBSKIP()
			END

			If XCODFOR == ""  .or. empty(XCODFOR)
				Msgbox("Fornecedor nao Cadastrado !!! XML serА excluМdo"+ _cCNPJ)
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Nomeclatura dos arquivos											Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_cFileOri:="\xml\"+lower(ALLTRIM(aXML[i]))

				_cFileNew:="\xml\"+ALLTRIM(_cCNPJ)+"-nf"+ALLTRIM(cNota)+"-"+alltrim(cChave)+".xml.dup"

				FRename(_cFileOri,_cFileNew)
				ferase(_cFileNew)   
				loop 
			Endif

			DbSelectarea("SA2")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA2")+XCODFOR+XLOJAFO)
			If Found()
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verificando grupo													Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				lFornec:=.T.
				If !Empty(_cOpcao) .and. alltrim(_cOpcao)<>"TODOS"
					If ALLTRIM(SA2->A2_GRPCOM)==_cOpcao
						lFornec:=.T.
					Else
						lFornec:=.F.
					Endif

					If Empty(SA2->A2_GRPCOM)
						Msgbox("Fornecedor "+SA2->A2_COD+"/"+ALLTRIM(SA2->A2_NREDUZ)+" estА sem o grupo de compras informado!","AtenГЦo...","ALERT")
					Endif



				Endif

				If lFornec
					Incproc(SA2->A2_NREDUZ)



					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Verifico arquivos XML duplicados									Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectarea("LS4")
					DbSetorder(1)
					Dbgotop()
					dbseek(SA2->A2_COD+SA2->A2_LOJA+cNota)
					If !Found()
						Reclock("LS4",.T.)
						LS4->NOTA:=cNota
						LS4->FORNECEDOR:=SA2->A2_COD
						LS4->LOJA:=SA2->A2_LOJA
						MsUnlock()



						Reclock("LS3",.T.)
						LS3->EMISSAO:=STOD(cEmissao)
						LS3->FORNEC:=SA2->A2_COD
						LS3->LOJA:=SA2->A2_LOJA
						LS3->VENDEDOR:=SUBSTR(SA2->A2_REPRES,1,30)
						LS3->TELEFONE:=alltrim(SA2->A2_DDD)+" "+alltrim(SUBSTR(SA2->A2_TEL,1,20))
						LS3->NOME:=SA2->A2_NREDUZ
						LS3->XML:=UPPER(aXML[i])
						LS3->NOTA:=cNota
						LS3->CHAVE:=cChave
						LS3->FRETE:=_cFrete
						MsUnlock()
						lAchou:=.T.
					Endif
				Endif
			Else
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Nomeclatura dos arquivos											Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_cFileOri:="\xml\"+lower(ALLTRIM(aXML[i]))

				_cFileNew:="\xml\"+ALLTRIM(_cCNPJ)+"-nf"+ALLTRIM(cNota)+"-"+alltrim(cChave)+".xml.dup"

				FRename(_cFileOri,_cFileNew)
				__CopyFile("\xml\*.dup","\xml\duplicados\")
				ferase(_cFileNew)
			Endif
		Endif
	Next

	Dbselectarea("LS4")
	dbCloseArea("LS4")
	fErase( cArqTrab4+ ".DBF" )
	fErase( cArqTrab4+ OrdBagExt() )

	If lAchou==.F.
		Msgbox("NЦo existem arquivos para serem importados no momento...","AtenГЦo...","ALERT")
		Dbselectarea("LS1")
		dbCloseArea("LS1")
		fErase( cArqTrab+ ".DBF" )
		fErase( cArqTrab+ OrdBagExt() )

		Dbselectarea("LS5")
		dbCloseArea("LS5")
		fErase( cArqTrab5+ ".DBF" )
		fErase( cArqTrab5+ OrdBagExt() )

		Dbselectarea("LS3")
		dbCloseArea("LS3")
		fErase( cArqTrab3+ ".DBF" )
		fErase( cArqTrab3+ OrdBagExt() )
		Return
	Endif

	cNota:=space(09)
	cNatOp:=''
	_cCNPJ:=space(18)
	_cMensag:=''
	nTotalNF:=0
	nTotIt:=0
	_cFornecedor:=''
	_cTelefone:=''
	_cInscr:=''
	_cEnd:=''
	_cCidade:=''
	_cEmissao:=''
	cUm:=''
	nDescont:=0

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё aHeaders 															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cPict1:="@E 999,999."
	For w:=1 to cDecQtd
		cPict1:=alltrim(cPict1)+"9"
	Next
	cPict2:="@E 999,999."
	For w:=1 to cDecUni
		cPict2:=alltrim(cPict2)+"9"
	Next

	DbSelectarea("LS3")
	Dbgotop()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё legenda de cores													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aCores := {{ 'LS1->OK=="X" ', 'BR_VERMELHO'  },;
	{ 'EMPTY(LS1->OK) ', 'BR_VERDE'  },;
	{ 'LS1->OK=="D" ', 'BR_PINK'  },;
	{ 'LS1->OK=="O" ', 'BR_AZUL'  }}

	cMarca := GetMark()
	linverte:=.f.
	aTitulo := {}
	aTituloX := {}

	bColor := &("{||IIF(LS1->OK=='O',"+Str(CLR_HBLUE)+","+Str(CLR_BLACK)+")}")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Tela principal da rotina											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	@ 120,040 TO _nTop,_nRight DIALOG oTela TITLE "ImportaГЦo nota fiscal eletrТnica - "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+"-"+SM0->M0_FILIAL
	@ 004,005 BITMAP ResName "OPEN" OF oTela Size 15,15 ON CLICK (MsgRun("Verificando pedidos em aberto...",,{||IMPORTA()})) NoBorder  Pixel
	@ 005,025 BUTTON "Recusar Recebimento" SIZE 65,10 ACTION RECUSAR()
	@ 005,095 BUTTON "Re_fazer Nota Fiscal" SIZE 65,10 ACTION MsgRun("Restaurando informaГУes originais...",,{||REFAZER()})
	@ 005,165 BUTTON "Excluir IdentificaГЦo" SIZE 65,10 ACTION EXCAMA()
	@ 005,235 BUTTON "Cons_ultar SEFAZ" SIZE 65,10 ACTION MsgRun("Processando NFE no site da SEFAZ...",,{||SEFAZ()})
	@ 005,390 say "NOTA FISCAL ELETRтNICA" FONT oFont5 OF oTela PIXEL COLOR CLR_HRED

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Principal 															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	@ 020,005 TO 110,_nSize BROWSE "LS3" OBJECT OBRWP FIELDS aTituloX
	OBRWP:oBrowse:BCHANGE := {||PROCESS()}
	OBRWP:oBrowse:oFont := TFont():New ("Arial", 05, 18)

	OBRWP:oBrowse:AddColumn(TCColumn():New("EmissЦo",   {||LS3->EMISSAO},"@D 99/99/99",,,"LEFT",10))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Fornecedor",{||LS3->FORNEC},,,,"LEFT",10))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Loja",      {||LS3->LOJA},,,,"LEFT",15))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Nome",      {||LS3->NOME},,,,"LEFT",60))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Vendedor",  {||LS3->VENDEDOR},"@!",,,"LEFT",90))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Telefone",  {||LS3->TELEFONE},"@!",,,"LEFT",60))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Nota Fiscal EletrТnica",{||LS3->CHAVE},"@!",,,"LEFT",10))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Arquivo XML",{||LS3->XML},"@!",,,"LEFT",10))

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Secundaria															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	OBRWI:=MsSelect():New("LS1","","",aTitulo,@lInverte,@cMarca,{125,005,220,_nSize},,,,,aCores)
	OBRWI:oBrowse:bLDblClick := {||CORRIGE()}
	OBRWI:oBrowse:oFont := TFont():New ("Arial", 05, 18)

	OBRWI:oBrowse:AddColumn(TCColumn():New("CСd.For." ,{||LS1->PRODFOR},,,,"LEFT", 25))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Produto"  ,{||LS1->PRODUTO},,,,"LEFT", 25))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Certif"   ,{||LS1->CERTIF},,,,"LEFT", 20))
	OBRWI:oBrowse:AddColumn(TCColumn():New("DescriГЦo",{||LS1->DESCRICAO},,,,"LEFT",150))
	OBRWI:oBrowse:AddColumn(TCColumn():New("UM"       ,{||LS1->UM},,,,"LEFT", 25))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Emb."     ,{||LS1->QE},"@E 99999,999",,,"LEFT", 25))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Caixas"   ,{||LS1->CAIXAS},cPict1,,,"RIGHT", 25))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Quant."   ,{||LS1->QUANTIDADE},cPict1,,,"RIGHT", 45))
	OBRWI:oBrowse:AddColumn(TCColumn():New("PreГo R$" ,{||LS1->PRECO},cPict2,,,"RIGHT", 45))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Custo R$" ,{||LS1->CUSTO},cPict2,,,"RIGHT", 45))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Desc.R$"  ,{||LS1->DESCONTO},cPict2,,,"RIGHT", 45))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Total R$" ,{||LS1->TOTAL},cPict2,,,"RIGHT", 45))
	OBRWI:oBrowse:AddColumn(TCColumn():New("CFOP."    ,{||LS1->CFOP},"@E 9999",,,"LEFT", 25))
	OBRWI:oBrowse:SetBlkColor(bColor)

	If lCheck2
		OBRWI:oBrowse:AddColumn(TCColumn():New("Pedido",{||LS1->PEDIDO},,,,"LEFT", 30))
		OBRWI:oBrowse:AddColumn(TCColumn():New("Item",{||LS1->ITEM},,,,"LEFT", 30))
	Endif

	@ 225,003 TO 315,200 //@ 245,003 TO 315,235
	@ 230,005 say "FORNECEDOR" SIZE 150,40 FONT oFont4 OF oTela PIXEL COLOR CLR_GREEN
	@ 240,005 say _cFornecedor size 200,20 FONT oFont3 OF oTela PIXEL COLOR CLR_HBLUE
	@ 250,005 say "CNPJ" FONT oFont1 OF oTela PIXEL
	@ 250,040 say _cCNPJ size 80,20 size 50,20 FONT oFont2 OF oTela PIXEL
	@ 260,005 say "EndereГo" FONT oFont1 OF oTela PIXEL
	@ 260,040 say _cEnd size 170,20 FONT oFont2 OF oTela PIXEL
	@ 270,005 say "Cidade/UF" FONT oFont1 OF oTela PIXEL
	@ 270,040 say _cCidade size 150,20 size 100,20 FONT oFont2 OF oTela PIXEL

	@ 225,210 TO 315,435 //@ 245,240 TO 315,435
	@ 230,250 say "NOTA FISCAL" FONT oFont4 OF oTela PIXEL COLOR CLR_GREEN
	@ 240,250 say "EmissЦo" FONT oFont1 OF oTela PIXEL
	@ 240,290 say _cEmissao size 80,40 picture "@D 99/99/99" FONT oFont3 OF oTela PIXEL
	@ 250,250 say "Total R$" FONT oFont1 OF oTela PIXEL
	@ 250,290 say nTotalNF size 80,40 picture "@E 999,999.99" FONT oFont3 OF oTela PIXEL
	@ 260,250 say "Qtd.Itens" FONT oFont1 OF oTela PIXEL
	@ 260,290 say nTotIt size 40,40 picture "@E 9999" FONT oFont3 OF oTela PIXEL
	@ 270,250 say "Nat.OperaГЦo" FONT oFont1 OF oTela PIXEL
	@ 270,290 say SUBSTR(alltrim(cNatOP),1,32) size 180,40 picture "@!" FONT oFont2 OF oTela PIXEL COLOR CLR_HRED
	@ 280,250 say "SИrie/Nota Fiscal" FONT oFont1 OF oTela PIXEL
	@ 280,310 say ALLTRIM(cSerie)+"-"+cNota size 80,40 picture "@!" FONT oFont3 OF oTela PIXEL COLOR CLR_MAGENTA
	@ 112,075 BUTTON "Atu.Ped.com.XML" SIZE 65,10 ACTION APCXML() // Produto GenИrico
	@ 112,145 BUTTON "Incluir Prod DemonstraГЦo" SIZE 65,10 ACTION caddemo() // Produto para demonstraГЦo
	@ 112,215 BUTTON "_Mensagem Nota" SIZE 65,10 ACTION MSGNF(_cMensag)
	@ 112,285 BUTTON "Legenda" SIZE 65,10 ACTION LEGENDA()                                               
	If lCheck2
		@ 112,285 BUTTON "_Selecionar Pedido" SIZE 65,10 ACTION PROCPED()
		@ 112,355 BUTTON "_Eliminar Pedido do item" SIZE 65,10 ACTION ELIMPED()
		@ 112,425 BUTTON "Eliminar _Todos Pedidos" SIZE 65,10 ACTION ELIMPEDT()
		@ 112,495 BUTTON "Incluir Produto" SIZE 65,10 ACTION mata010()
	Endif
	If aSize[5] >=1220
		@ 018,055 BITMAP SIZE 110,110 FILE "NFE.BMP" NOBORDER
		@ 018,065 BITMAP SIZE 110,110 FILE alltrim(cLogo)+".BMP" NOBORDER
	Endif
	ACTIVATE DIALOG oTela CENTER

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando arquivos temporarios										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Dbselectarea("LS1")
	dbCloseArea("LS1")
	fErase( cArqTrab+ ".DBF" )
	fErase( cArqTrab+ OrdBagExt() )

	Dbselectarea("LS5")
	dbCloseArea("LS5")
	fErase( cArqTrab5+ ".DBF" )
	fErase( cArqTrab5+ OrdBagExt() )

	Dbselectarea("LS3")
	dbCloseArea("LS3")
	fErase( cArqTrab3+ ".DBF" )
	fErase( cArqTrab3+ OrdBagExt() )
Return

/*/{Protheus.doc} IMPORTA
//TODO DescriГЦo: Gera pre nota.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function IMPORTA()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifico se existe a nota fiscal									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IF !file("\xml\"+lower(LS3->XML))
		msgbox("Este arquivo jА foi processado por outro usuАrio!","AtenГЦo...","ALERT")
		Reclock("LS3",.F.)
		dbdelete()
		MsUnlock()

		DbSelectarea("LS3")
		Dbgotop()
		PROCESS()
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando se todas as variaveis foram preenchidas					Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Empty(cNota)
		Msgbox("Numero de nota fiscal nЦo encontrada!")
		Return
	Endif
	If Empty(_cCNPJ)
		Msgbox("Dados do fornecedor nЦo encontrados/Numero de nota fiscal nЦo encontrada!")
		Return
	Endif

	If nTotIt<=0
		Msgbox("Nota fiscal nЦo contem itens!")
		Return
	Endif
	If nTotalNF<=0
		Msgbox("Nota fiscal sem valores das mercadorias!")
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando se todos os produtos foram identificados				      Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	lIdent :=.F. 
	lerropr:= .F.
	DbSelectarea("LS1")
	Dbgotop()
	While !Eof() .AND. cNota == LS1->NOTA
		If LS1->OK=="X"
			lIdent:=.T.
		Endif
		nQtdCent := 0
		nPrcCent := 0
		nC7preco := 0
		nC7quant := 0
		nC7quant2:= 0
		nC7QUJE  := 0
		nC7QUJE2 := 0
		lQuant   := .T.
		lPreco	:= .T. 
		lAlteraPc:= .F.
		If LS1->OK=="O" .AND. cPedCom
			DBSelectArea("AIC")
			DBSetOrder(2)
			If DBSEEK(xFilial("AIC")+LS3->FORNEC+LS3->LOJA+LS1->PRODUTO)
				If AIC->AIC_PQTDE > 0
					nQtdCent := AIC->AIC_PQTDE

					nC7quant := POSICIONE("SC7",1,xFilial("SC7")+LS1->PEDIDO+LS1->ITEM,"C7_QUANT") 
					nC7QUJE  := POSICIONE("SC7",1,xFilial("SC7")+LS1->PEDIDO+LS1->ITEM,"C7_QUJE")
					cC7UM	 := POSICIONE("SC7",1,xFilial("SC7")+LS1->PEDIDO+LS1->ITEM,"C7_UM")
					_cSC	 := POSICIONE("SC7",1,xFilial("SC7")+LS1->PEDIDO+LS1->ITEM,"C7_NUMSC")
					_cItSC	 := POSICIONE("SC7",1,xFilial("SC7")+LS1->PEDIDO+LS1->ITEM,"C7_ITEMSC")
					_cSolic	 := POSICIONE("SC1",1,xFilial("SC1")+_cSC+_cItSC,"C1_SOLICIT")
					_aC1Qtd	 := GetAdvFVal("SC1",{"C1_QUANT","C1_QUJE"},xFilial("SC1")+_cSC+_cItSC,1," ")
					_cUsuario	:= Alltrim(_cSolic)
					_cUsuSenha	:= ""
					_aUsuario	:= {}
					PswOrder(2)
					If PswSeek(_cUsuario,.T.)
						_aUsuario	:= PswRet()
						_cUsuSenha	:= Upper(Alltrim(_aUsuario[1][4]))
						_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
						_cEmailUsu  := Alltrim(_aUsuario[1][14])
						aadd(_aSolic,_cEmailUsu)
					Endif
					If cNumEmp <> "15"
						IF !(Alltrim(cC7UM) $ "KG_M_M2_M3_MT_ML")		//Verifica as unidades de medidas cadastrada no Pedido de Compra
							ALERT("Quantidade da NF И acima de "+ ALLTRIM(STR(nQtdCent)) +"%, entre em contato com compras! - quantidade limite para o item: "+ALLTRIM(STR(((nC7quant*nQtdCent)/100)+nC7quant)))
							lerropr:=.T.
						Else					  		
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//ЁCaso a unidade seja "KG" ou "Metro" e a quantidade for Ё
							//Ёsuperior ao Pedido de Compra, monta as inforamГУes paraЁ
							//Ёenviar o e-mail.                                       Ё
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							_cTitulo  := "DivergЙncia de Entrega - "+Alltrim(LS3->NOME)+" - NF "+LS1->NOTA+""  /*AGoncalves - ticket 2018020737000257 - Ajuste de layout de e-mail / correГЦo qtd SC*/
							_cMsgCab  := "O Pedido abaixo, foi entregue com quantidade divergente"+ cHtmlQbr  
							_cMsgCab  += cHtmlQbr
							_cMsgCab  += "Data de entrada: "+DTOC(dDataBase)+ cHtmlQbr
							_cMsgCab  += "Fornecedor: "+LS3->NOME+ cHtmlQbr
							_cMsgCab  += "Nota: "+LS1->NOTA+ cHtmlQbr
							_cMsgCab  += cHtmlQbr
							_cMsgItem += "PC/Item: "+LS1->PEDIDO+"/"+LS1->ITEM+ cHtmlQbr
							_cMsgItem += "Produto: "+LS1->PRODUTO+" - "+LS1->DESCRICAO+"UM: "+cC7UM+ cHtmlQbr							
							If (nC7quant-nC7QUJE) - (_aC1Qtd[1]-_aC1Qtd[2]) = 0
								_cMsgItem += "Quant PC: "+Alltrim(str(nC7quant-nC7QUJE))+" - Quant Nota: "+Alltrim(str(LS1->QUANTIDADE))+ cHtmlQbr
							Else
								_cMsgItem += "Quant SC: "+Alltrim(str(_aC1Qtd[1]))+" - Quant Nota: "+Alltrim(str(LS1->QUANTIDADE))+ cHtmlQbr							
							Endif
							_cMsgItem += "SC/Item: "+_cSC+"/"+_cItSC+" - Solicitante: "+Alltrim(_cUsuSenha)+" - Depto: "+Alltrim(_cDeptoUsu)+ cHtmlQbr
							_cMsgItem += + cHtmlQbr /*AGoncalves - ticket 2018020737000257 - Ajuste de layout de e-mail / correГЦo qtd SC FIM*/
						EndIf
					EndIf	
				Else
					ALERT("TolerБncia de quantidade estА zerada!")
					lQuant := .F. 
				EndIf        

				If AIC->AIC_PPRECO > 0 
					nPrcCent := AIC->AIC_PPRECO 
					nC7preco := POSICIONE("SC7",1,xFilial("SC7")+LS1->PEDIDO+LS1->ITEM,"C7_PRECO") 
					If (((nC7preco*nPrcCent)/100)+nC7preco >= LS1->PRECO) 
						lAlteraPc:= .F.
					Else
						IF !(cC7UM $ "KG_M_M2_M3_MT_ML")
							ALERT("PreГo da NF И acima de "+ ALLTRIM(STR(nPrcCent)) +"%, entre em contato com compras! - quantidade limite para o item: "+ALLTRIM(STR(((nC7preco*nPrcCent)/100)+nC7preco)))
							lerropr:=.T.
						Endif	
					EndIf
				Else 
					IF cNumEmp <> "15"
						ALERT("TolerБncia de preГo estА zerada!")
						lPreco := .F.   
					Endif
				EndIf

				If !lPreco .AND. !lQuant 
					lerropr:=.T.
				ElseIf lAlteraPc
					DBSELECTAREA("SC7")
					DBSETORDER(1)	
					DBSEEK(xFilial("SC7")+LS1->PEDIDO+LS1->ITEM)
					AADD(aC7Itens,{LS1->PEDIDO,LS1->ITEM,SC7->C7_QUANT,SC7->C7_PRECO,SC7->C7_TOTAL,LS1->QUANTIDADE,nC7QUJE,LS1->PRECO})

					DBSELECTAREA("LS1")
				EndIf

			Else
				ALERT("NЦo existe tolerБncia cadastrada para o Produto X Fornecedor!! O sistema irА incluir automaticamente")       
				cCodAIC  := ""
				DBSELECTAREA("AIC")
				DBSETORDER(1) 
				DBGoBottom()//Ultimo registro da tabela 
				cCodAIC := STRZERO(VAL(AIC->AIC_CODIGO) + 1,6)
				Reclock("AIC",.T.)
				AIC->AIC_FILIAL := "" 
				AIC->AIC_CODIGO := cCodAIC
				AIC->AIC_FORNEC := LS3->FORNEC
				AIC->AIC_LOJA   := LS3->LOJA  
				AIC->AIC_PRODUT := LS1->PRODUTO	  
				AIC->AIC_GRUPO  := ""
				AIC->AIC_PQTDE  := 10
				AIC->AIC_PPRECO := 0	                                                            
				AIC->(MsUnlock()) 
				DBSETORDER(2)
				If DBSEEK(xFilial("AIC")+LS3->FORNEC+LS3->LOJA+LS1->PRODUTO)
					alert("TolerБncia cadastrada, tente gerar a nota novamente!")
				Else 
					alert("Ouve um erro ao tentar gerar a tolerБncia, contate o TI com o cСdigo do fornecedor e cСdigo do produto!")
				EndIf                                                                                                              
				lerropr:=.T.
				Return
			EndIf
		Endif
		LS1->(Dbskip())
	End
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁInicia o envio do e-mail para o grupo sobre a quantidade Ё
	//Ёdivergente da nota fiscal de entrada X Pedido de compra  Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*	
	If !Empty(Alltrim(_cMsgItem))
		_cCco := ""
		_cDestino := ""
		For nX := 1 to len(_aSolic)
			If !(Alltrim(_aSolic[nX]) $ _cDestino) .And. !Empty(Alltrim(_aSolic[nX]))
				_cDestino       += Alltrim(_aSolic[nX])+";"
			Endif
		next

		_cDestino += Alltrim(GetMv("MS_EMAILPC"))
		
		oMail:= EnvMail():NEW(.F.)
		If oMail:ConnMail()
			oMail:SendMail(_cTitulo,_cDestino,,,_cMsgCab+_cMsgItem)
		EndIf
		oMail:DConnMail()

		_cMsgItem := ""
	Endif
*/
	Dbgotop()
	If lerropr
		Msgbox("Existem produtos com quantidade ou valor divergente, corrija primeiro!","AtenГЦo...","ALERT") 
		aC7Itens:={}
		Return 
	Endif
	If lIdent
		Msgbox("Existem produtos nЦo identificados, corrija primeiro!","AtenГЦo...","ALERT")
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando se o pedido foi feito por item							Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If cPedCom
		lItem:=.F.
		DbSelectarea("LS1")
		Dbgotop()
		While !Eof()
			IF !Empty(LS1->PEDIDO)
				lItem:=.T.
			Endif
			Dbskip()
		End

		If lItem
			DbSelectarea("LS1")
			Dbgotop()
			While !Eof()
				IF Empty(LS1->PEDIDO) .AND. LS1->OK <> "D" 
					Dbgotop()
					Msgbox("Existem produtos sem o pedido de compras, favor corrigi-los primeiro!","AtenГЦo...","ALERT")
					Return
				Endif
				Dbskip()
			End
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gerar pedido itens sem pedidos de compras							Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		lSemPed:=.F.
		If lItem
			DbSelectarea("LS1")
			Dbgotop()
			While !Eof()
				IF ALLTRIM(LS1->PEDIDO)=="CRIAR"
					lSemPed:=.T.
				Endif
				Dbskip()
			End
		Endif

		If lSemped
			NEWPED2()
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verificando se os produtos existem saldos no pedidos				Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lItem
			DbSelectarea("LS1")
			Dbgotop()
			While !Eof()
				IF !Empty(LS1->PEDIDO) .AND. LS1->OK <> "D"
					aProdutos	:= {{"PRODUTO","C",15,0 },;
					{"DESCRICAO","C",50,0 },;
					{"QUANTIDADE","N",18,6 },;
					{"PEDIDO","C",6,0 },;
					{"ITEM","C",4,0 },;
					{"CFOP","C",4,0 },;
					{"CERTIF","C",20,0 },;
					{"PRECO","N",18,7 }}


					cArqTrabp  := CriaTrab(aProdutos)
					dbUseArea( .T.,, cArqTrabp, "PRO", if(.F. .OR. .F., !.F., NIL), .F. )
					IndRegua("PRO",cArqTrabp,"PEDIDO+PRODUTO+ITEM",,,)
					dbSetIndex( cArqTrabp +OrdBagExt())
					dbSelectArea("PRO")

					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Aglutinando produtos iguais											Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectarea("LS1")
					Dbsetorder(1)
					Dbgotop()
					While !Eof()
						If LS1->OK <> "D" 
							DbSelectarea("PRO")
							DbSetorder(1)
							Dbgotop()
							Dbseek(LS1->PEDIDO+LS1->PRODUTO+LS1->ITEM)
							If !Found() 
								Reclock("PRO",.T.)
								PRO->PRODUTO:=LS1->PRODUTO
								PRO->QUANTIDADE:=LS1->QUANTIDADE
								PRO->DESCRICAO:=LS1->DESCRICAO
								PRO->PRECO:=LS1->PRECO
								PRO->PEDIDO:=LS1->PEDIDO
								PRO->ITEM:=LS1->ITEM
								PRO->CFOP:=LS1->CFOP
								PRO->CERTIF:=LS1->CERTIF
								MsUnlock()
							Else
								Reclock("PRO",.F.)
								PRO->QUANTIDADE:=(PRO->QUANTIDADE+LS1->QUANTIDADE)
								MsUnlock()
							Endif
						EndIf
						DbSelectarea("LS1")
						Dbskip()
					End
				Endif
				DbSelectarea("LS1")
				Dbskip()
			End
			cMsg:=''
			DbSelectArea("PRO")
			Dbgotop()
			While !Eof()
				cQuery:=" SELECT (C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
				cQuery:=cQuery + " AND C7_NUM='"+PRO->PEDIDO+"' "
				cQuery:=cQuery + " AND C7_PRODUTO='"+PRO->PRODUTO+"' "
				cQuery:=cQuery + " AND C7_ITEM='"+PRO->ITEM+"' "
				cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
				cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
				cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
				cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
				TCQUERY cQuery NEW ALIAS "TCQ"
				DbSelectarea("TCQ")
				IF PRO->QUANTIDADE>TCQ->QUANT
					cMsg:=cMsg+PRO->PEDIDO+"   "+PRO->ITEM+"   "+alltrim(PRO->PRODUTO)+"   "+PRO->DESCRICAO+CRLF
				Endif
				Dbclosearea("TCQ")
				DbSelectArea("PRO")
				Dbskip()
			End

			If !Empty(cMsg) .AND. !lVerPCS
				DEFINE MSDIALOG oProdd FROM 0,0 TO 300,420 PIXEL TITLE "produto sem estoque no momento..."
				@ 005,005 say " Pedido       Item       Produto    DescriГЦo" SIZE 150,40 FONT oFont1 OF oProdd PIXEL COLOR CLR_HBLUE
				@ 015,005 GET oMemo VAR cMsg MEMO SIZE 200,135 FONT oFont6 PIXEL OF oProdd
				ACTIVATE MSDIALOG oProdd CENTER

				Dbselectarea("PRO")
				dbCloseArea("PRO")
				fErase( cArqTrabp+ ".DBF" )
				fErase( cArqTrabp+ OrdBagExt() )

				DbSelectarea("LS1")
				Dbgotop()
				Return
			Endif
		Endif
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Valida se o preco esta proximo do correto							Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cMsg:=''
	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		IF LS1->CUSTO>0 .AND. LS1->OK <> "D"
			IF 100-((LS1->PRECO/LS1->CUSTO)*100)>10 .OR. 100-((LS1->PRECO/LS1->CUSTO)*100)<-10
				cMsg:=cMsg+ALLTRIM(LS1->PRODUTO)+"  "+SUBSTR(LS1->DESCRICAO,1,35)+CRLF
				cMsg:=cMsg+"PreГo Nota R$ "+transform(LS1->PRECO,"@E 9999,999.9999999")+"   PreГo Pedido R$"+transform(LS1->CUSTO,"@E 9999,999.999999999")+CRLF
				cMsg:=cMsg+CRLF

				Reclock("LS1",.F.)
				LS1->OK:="O"
				MsUnlock()
				If LS1->CFOP == "5902" 
					Reclock("LS1",.F.)
					LS1->OK:="D"                                                             
					MsUnlock()
				EndIf
			Endif
		Endif
		Dbskip()
	End
	Dbgotop()

	If !Empty(cMsg)
		lSaida:=.F.
		DEFINE MSDIALOG oProdd FROM 0,0 TO 330,420 PIXEL TITLE "Produtos com divergЙncia de preГos..."
		@ 005,005 GET oMemo VAR cMsg MEMO SIZE 200,135 FONT oFont6 PIXEL OF oProdd
		@ 150,005 BUTTON "<< Voltar" SIZE 55,10 ACTION oProdd:end()
		@ 150,070 BUTTON "Continuar >>" SIZE 55,10 ACTION (lsaida:=.T.,oProdd:end())
		ACTIVATE MSDIALOG oProdd CENTER

		If lSaida==.F.
			Return
		Endif
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Controla pedidos de compras											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If cPedCom

		if lItem==.F.
			aProdutos	:= {{"PRODUTO","C",15,0 },;
			{"DESCRICAO","C",50,0 },;
			{"QUANTIDADE","N",18,6 },;
			{"CFOP","C",4,0 },;
			{"CERTIF","C",20,0 },;
			{"PRECO","N",18,7 }}


			cArqTrabp  := CriaTrab(aProdutos)
			dbUseArea( .T.,, cArqTrabp, "PRO", if(.F. .OR. .F., !.F., NIL), .F. )
			IndRegua("PRO",cArqTrabp,"PRODUTO",,,)
			dbSetIndex( cArqTrabp +OrdBagExt())
			dbSelectArea("PRO")

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Aglutinando produtos iguais											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("LS1")
			Dbsetorder(1)
			Dbgotop()
			While !Eof()
				DbSelectarea("PRO")
				DbSetorder(1)
				Dbgotop()
				Dbseek(LS1->PRODUTO)
				If !Found()
					Reclock("PRO",.T.)
					PRO->PRODUTO:=LS1->PRODUTO
					PRO->QUANTIDADE:=LS1->QUANTIDADE
					PRO->DESCRICAO:=LS1->DESCRICAO
					PRO->PRECO:=LS1->PRECO
					MsUnlock()
				Else
					Reclock("PRO",.F.)
					PRO->QUANTIDADE:=(PRO->QUANTIDADE+LS1->QUANTIDADE)
					MsUnlock()
				Endif
				DbSelectarea("LS1")
				Dbskip()
			End

			aCampos2	:= {{"OK","C",1,0 },;
			{"EMISSAO","D",8,0 },;
			{"PEDIDO","C",6,0 },;
			{"LOJA","C",2,0 },;
			{"ITENS","N",5,0 },;
			{"ENTREGA","D",8,0 },;
			{"QTDIT","N",5,5 },;
			{"VALIDO","N",5,7 }}

			cArqTrab2  := CriaTrab(aCampos2)
			cIndice:="Descend(DTOS(EMISSAO))"
			dbUseArea( .T.,, cArqTrab2, "LS2", if(.F. .OR. .F., !.F., NIL), .F. )
			IndRegua("LS2",cArqTrab2,cIndice,,,)
			dbSetIndex( cArqTrab2 +OrdBagExt())
			dbSelectArea("LS2")

			lAchou:=.f.

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verificando pedidos em aberto										Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_LOJA LOJA,C7_NUM PEDIDO,MAX(C7_DATPRF) ENTREGA,COUNT(*) QTD FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_FORNECE='"+LS3->FORNEC+"' "
			cQuery:=cQuery + " AND C7_EMISSAO>='"+DTOS(DDATABASE-730)+"' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " GROUP BY C7_EMISSAO,C7_NUM,C7_LOJA "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
			TCQUERY cQuery NEW ALIAS "TCQ"
			DbSelectarea("TCQ") 

			While !Eof()
				Reclock("LS2",.T.)
				LS2->EMISSAO:=STOD(TCQ->EMISSAO)
				LS2->PEDIDO:=TCQ->PEDIDO
				LS2->LOJA:=TCQ->LOJA
				LS2->ITENS:=TCQ->QTD
				LS2->ENTREGA:=STOD(TCQ->ENTREGA)
				Msunlock()
				lAchou:=.T.
				DbSelectarea("TCQ")
				Dbskip()
			End
			DbClosearea("TCQ")

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifico quantidade de itens do pedidos e usados					Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("LS2")
			Dbgotop()
			While !Eof()
				cQuery:=" SELECT COUNT(*) QTD FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' AND C7_NUM='"+LS2->PEDIDO+"' "
				cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
				TCQUERY cQuery NEW ALIAS "TCQ"
				DbSelectarea("TCQ")
				_nUsados:=TCQ->QTD
				DbClosearea("TCQ")

				DbSelectarea("LS2")
				Reclock("LS2",.F.)
				LS2->QTDIT:=_nUsados
				MsUnlock()
				Dbskip()
			End

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifico Itens validos												Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("LS2")
			Dbgotop()
			While !Eof()
				_nItem:=0
				Dbselectarea("PRO")
				Dbgotop()
				While !Eof()
					DbSelectarea("SC7")
					DbSetorder(4)
					Dbgotop()
					Dbseek(xFilial("SC7")+PRO->PRODUTO+LS2->PEDIDO)
					If Found() .and. (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA>0) .AND. (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA>=PRO->QUANTIDADE) .AND. SC7->C7_RESIDUO<>"S"
						_nItem:=_nItem+1
					Endif
					Dbselectarea("PRO")
					Dbskip()
				End

				DbSelectarea("LS2")
				Reclock("LS2",.F.)
				IF _nItem==nTotIt
					LS2->OK:="X"
				Endif
				LS2->VALIDO:=_nItem
				MsUnlock()
				Dbskip()
			End

			Dbselectarea("LS1")
			Dbgotop()

			Dbselectarea("LS2")
			Dbgotop()

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё aHeader dos pedidos													Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			aTitulo2 := {}
			AADD(aTitulo2,{"EMISSAO","EmissЦo"})
			AADD(aTitulo2,{"PEDIDO","Pedido"})
			AADD(aTitulo2,{"LOJA","Lj"})
			AADD(aTitulo2,{"QTDIT","Itens","@E 9999"})
			AADD(aTitulo2,{"ITENS","Abertos","@E 9999"})
			AADD(aTitulo2,{"VALIDO","VАlidos","@E 9999"})
			AADD(aTitulo2,{"ENTREGA","Dt.Entrega"})

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Tela dos pedidos em aberto											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lAchou
				@ 120,040 TO 400,590 DIALOG oPedido TITLE "Pedidos em aberto..."
				@ 005,005 BITMAP ResName "CHECKED" OF oPedido Size 15,15 ON CLICK (VALIDA())  NoBorder  Pixel
				@ 005,095 BUTTON "_Abrir Pedido" SIZE 55,10 ACTION ABREPED()
				@ 005,155 BUTTON "_DivergЙncias" SIZE 55,10 ACTION DIVERG()
				@ 020,005 TO 140,275 BROWSE "LS2" ENABLE " LS2->OK<>'X' " OBJECT OBRWT FIELDS aTitulo2
				OBRWT:oBrowse:oFont := TFont():New ("Arial", 05, 18)
				ACTIVATE DIALOG oPedido CENTER
			Else
				cResp:= .f. 
				If cResp
					NEWPED()
				Endif
			Endif
			Dbselectarea("LS2")
			dbCloseArea("LS2")
			fErase( cArqTrab2+ ".DBF" )
			fErase( cArqTrab2+ OrdBagExt() )
		Else
			@ 120,040 TO 170,285 DIALOG oPedido TITLE "Pedidos por item..."
			@ 005,005 BUTTON "Gerar PrИ-Nota" SIZE 55,10 ACTION VALIDA()
			@ 005,065 BUTTON "_DivergЙncias" SIZE 55,10 ACTION DIVERG()
			ACTIVATE DIALOG oPedido CENTER
		Endif
		Dbselectarea("PRO")
		dbCloseArea("PRO")
		fErase( cArqTrabp+ ".DBF" )
		fErase( cArqTrabp+ OrdBagExt() )
	Else
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Nao controla pedidos de compras										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cRet:=.T.

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Manipulando numero da nota fiscal									Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If cZeros
			cNota:=strzero(val(cNota),9)
		Endif
		cSpaco:=9-len(alltrim(cNota))

		cResp:=msgbox("Deseja gerar a prИ-nota fiscal "+cNota+" agora?","AtenГЦo...","YESNO")

		If cResp
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifico se a pre nota ja existe									Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("SF1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SF1")+LS3->CHAVE)
			If Found() .and. SF1->F1_TIPO=="N"

				Msgbox("Nota fiscal jА existe!","AtenГЦo...","ALERT")

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Dados do fornecedor													Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectarea("SA2")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SA2")+LS3->FORNEC+LS3->LOJA)

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Nomenclatura dos arquivos											Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_cFileOri:="\xml\"+ALLTRIM(LS3->XML)

				// tratamento empresas
				IF _CNUMEMP=="01"
					__CopyFile(_cFileOri,"\xml\ArquivaMasipack\")
				ENDIF

				IF _CNUMEMP=="10"
					__CopyFile(_cFileOri,"\xml\ArquivaFabrima\")
				ENDIF

				IF _CNUMEMP=="15"
					__CopyFile(_cFileOri,"\xml\ArquivaHelsimplast\")
				endif

				IF _CNUMEMP=="40"
					__CopyFile(_cFileOri,"\xml\ArquivaLabortube\")
				endif

				IF _CNUMEMP=="45"
					__CopyFile(_cFileOri,"\xml\ArquivaMemb\")
				endif

				_cFileOri:="\xml\"+ALLTRIM(LS3->XML)

				_cFileNew:="\xml\"+ALLTRIM(LS3->CHAVE)+"xml.imp"
				FRename(_cFileOri,_cFileNew)
				__CopyFile("\xml\*.imp","\xml\importados\")
				// tratamento empresas        

				IF _CNUMEMP=="01"
					__CopyFile("\xml\*.imp","\xml\ArquivaMasipack\")
				ENDIF

				IF _CNUMEMP=="10"
					__CopyFile("\xml\*.imp","\xml\ArquivaFabrima\")
				ENDIF

				IF _CNUMEMP=="15"
					__CopyFile("\xml\*.imp","\xml\ArquivaHelsimplast\")
				endif

				IF _CNUMEMP=="40"
					__CopyFile("\xml\*.imp","\xml\ArquivaLabortube\")
				endif

				IF _CNUMEMP=="45"
					__CopyFile("\xml\*.imp","\xml\ArquivaMemb\")
				endif   
				ferase(_cFileNew)

				Reclock("LS3",.F.)
				dbdelete()
				MsUnlock()

				DbSelectarea("LS3")
				Dbgotop()

				DbSelectarea("LS1")
				Dbsetorder(1)
				Dbgotop()
				While !Eof()
					Reclock("LS1",.F.)
					dbdelete()
					MsUnlock()
					Dbskip()
				End

				DbSelectarea("LS5")
				Dbsetorder(1)
				Dbgotop()
				While !Eof()
					Reclock("LS5",.F.)
					dbdelete()
					MsUnlock()
					Dbskip()
				End

				PROCESS()
				Return
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Gravando pre nota entrada											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			MsgRun("Gerando prИ nota entrada No.:"+cNota,,{||PRENOTA()})
			cNotaAtu:=cNota

			If cRet

				DbSelectarea("LS1")
				Dbsetorder(1)
				Dbgotop()
				While !Eof()

					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualizando NCM do produto de acordo com o XML do fornecedor		Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					IF !Empty(LS1->NCM)
						DbSelectarea("SB1")
						DbSetorder(1)
						Dbgotop()
						Dbseek(xFilial("SB1")+LS1->PRODUTO)
						If Found()
							//	Reclock("SB1",.F.)
							//	SB1->B1_POSIPI:=LS1->NCM
							//	MsUnlock()
						Endif
					Endif

					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Gravando amarracao produto x fornecedor								Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If !Empty(LS1->PRODFOR)
						DbSelectarea("SA5")
						DbSetorder(1)
						Dbgotop()
						Dbseek(xFilial("SA5")+LS3->FORNEC+LS3->LOJA+LS1->PRODUTO)
						If !Found()
							Reclock("SA5",.T.)
							SA5->A5_FILIAL:=xFilial("SA5")
							SA5->A5_FORNECE:=LS3->FORNEC
							SA5->A5_LOJA:=LS3->LOJA
							SA5->A5_CODPRF:=LS1->PRODFOR
							SA5->A5_PRODUTO:=LS1->PRODUTO
							SA5->A5_NOMPROD:=SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC"),1,30)
							SA5->A5_NOMEFOR:=POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_NREDUZ")
							MsUnlock()
						Else
							Reclock("SA5",.F.)
							SA5->A5_CODPRF:=LS1->PRODFOR
							MsUnlock()
						Endif
					Endif
					DbSelectarea("LS1")
					Reclock("LS1",.F.)
					dbdelete()
					MsUnlock()
					Dbskip()
				End

				DbSelectarea("LS3")
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Dados do fornecedor													Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectarea("SA2")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SA2")+LS3->FORNEC+LS3->LOJA)

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Nomeclatura dos arquivos											Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_cFileOri:="\xml\"+ALLTRIM(LS3->XML)
				__CopyFile("\xml\*.xml","\xml\importados\")

				// tratamento empresas        

				IF _CNUMEMP=="01"
					__CopyFile(_cFileOri,"\xml\ArquivaMasipack\")
				ENDIF

				IF _CNUMEMP=="10"
					__CopyFile(_cFileOri,"\xml\ArquivaFabrima\")
				ENDIF

				IF _CNUMEMP=="15"
					__CopyFile(_cFileOri,"\xml\ArquivaHelsimplast\")
				endif

				IF _CNUMEMP=="40"
					__CopyFile(_cFileOri,"\xml\ArquivaLabortube\")
				endif

				IF _CNUMEMP=="45"
					__CopyFile(_cFileOri,"\xml\ArquivaMemb\")
				endif   

				_cFileNew:="\xml\"+ALLTRIM(SA2->A2_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.imp"


				FRename(_cFileOri,_cFileNew)

				__CopyFile("\xml\*.imp","\xml\importados\")

				// tratamento empresas        

				IF _CNUMEMP=="01"
					__CopyFile("\xml\*.imp","\xml\ArquivaMasipack\")
				ENDIF

				IF _CNUMEMP=="10"
					__CopyFile("\xml\*.imp","\xml\ArquivaFabrima\")
				ENDIF

				IF _CNUMEMP=="15"
					__CopyFile("\xml\*.imp","\xml\ArquivaHelsimplast\")
				endif

				IF _CNUMEMP=="40"
					__CopyFile("\xml\*.imp","\xml\ArquivaLabortube\")
				endif

				IF _CNUMEMP=="45"
					__CopyFile("\xml\*.imp","\xml\ArquivaMemb\")
				endif   

				ferase(_cFileNew)

				Reclock("LS3",.F.)
				dbdelete()
				MsUnlock()

				DbSelectarea("LS3")
				Dbgotop()
				Msgbox("PrИ-Nota "+cNotaAtu+" gerada com sucesso!","AtenГЦo...","INFO")
				PROCESS()
			Endif
		Else
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Apagando Flag dos pedidos											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("LS1")
			DbSetorder(1)
			Dbgotop()
			While !Eof()
				IF !Empty(LS1->PEDIDO)
					Reclock("LS1",.F.)
					LS1->PEDIDO:=""
					LS1->ITEM:=""
					LS1->ALTERADO:=""
					MsUnlock()
				Endif
				Dbskip()
			End
			DbSelectarea("LS1")
			DbSetorder(1)
			Dbgotop()
		Endif
	Endif

	Dbselectarea("LS1")
	Dbgotop()
Return

/*/{Protheus.doc} VALIDA
//TODO DescriГЦo: Valida pedido de compra antes da geraГЦo da nota.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type function
/*/
Static Function VALIDA()

	iF lItem==.F.
		If LS2->OK<>"X"
			Msgbox("Este pedido nЦo atende as necessidades da nota fiscal!")
			Return
		Endif
	Endif

	Dbselectarea("LS1")
	Dbgotop()
	While !Eof()
		cQuery:=" SELECT C7_NUM PEDIDO,C7_LOCAL ALMOX,C7_TES TES,C7_ITEM ITEM,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
		IF lItem==.F.
			cQuery:=cQuery + " AND C7_NUM='"+LS2->PEDIDO+"' "
		Else
			cQuery:=cQuery + " AND C7_NUM='"+LS1->PEDIDO+"' "
			cQuery:=cQuery + " AND C7_ITEM='"+LS1->ITEM+"' "
		Endif
		cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
		cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
		cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		While !Eof()
			IF (TCQ->QUANT>=LS1->QUANTIDADE) .AND. TCQ->QUANT>0 .AND. LS1->QUANTIDADE>0
				Reclock("LS1",.F.)
				LS1->PEDIDO:=TCQ->PEDIDO
				LS1->ITEM:=TCQ->ITEM
				LS1->TES:=TCQ->TES
				LS1->ALMOX:=TCQ->ALMOX
				MsUnlock()
			Else
				Reclock("LS1",.F.)
				LS1->ALMOX:=TCQ->ALMOX
				MsUnLock()
			Endif
			DbSelectarea("TCQ")
			Dbskip()
		End
		DbClosearea("TCQ")
		Dbselectarea("LS1")
		Dbskip()
	End

	lEntrou:=.f.
	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		IF (Empty(LS1->PEDIDO) .or. Empty(LS1->ITEM)) .AND. LS1->OK <> "D"
			Msgbox("O Produto "+alltrim(LS1->PRODUTO)+" nЦo possui pedido/Item!")
			lEntrou:=.T.
		Endif
		Dbskip()
	End

	If lEntrou
		Msgbox("Existem produtos sem o pedido/item!")
		Return
	Endif

	cRet:=.F.

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Manipulando numero da nota fiscal									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If cZeros
		cNota:=strzero(val(cNota),9)
	Endif
	cSpaco:=9-len(alltrim(cNota))

	cResp:=msgbox("Deseja gerar a prИ-nota fiscal "+cNota+" agora?","AtenГЦo...","YESNO")

	If cResp

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifico se a pre nota ja existe									Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		dbSelectArea("SF1")
		DbSetorder(8)
		Dbgotop()
		Dbseek(xFilial("SF1")+LS3->CHAVE)
		//		Dbseek(xFilial("SF1")+LS3->FORNEC+LS3->LOJA+alltrim(cNota)+Space(cSpaco))
		If Found() .and. SF1->F1_TIPO=="N"

			Msgbox("Nota fiscal jА existe!","AtenГЦo...","ALERT")

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Dados do fornecedor													Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("SA2")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA2")+LS3->FORNEC+LS3->LOJA)

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Nomeclatura dos arquivos											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cFileOri:="\xml\"+ALLTRIM(LS3->XML) 
			__CopyFile("\xml\*.xml","\xml\importados\")
			// tratamento empresas        

			IF _CNUMEMP=="01"
				__CopyFile(_cFileOri,"\xml\ArquivaMasipack\")
			ENDIF

			IF _CNUMEMP=="10"
				__CopyFile(_cFileOri,"\xml\ArquivaFabrima\")
			ENDIF

			IF _CNUMEMP=="15"
				__CopyFile(_cFileOri,"\xml\ArquivaHelsimplast\")
			endif

			IF _CNUMEMP=="40"
				__CopyFile(_cFileOri,"\xml\ArquivaLabortube\")
			endif

			IF _CNUMEMP=="45"
				__CopyFile(_cFileOri,"\xml\ArquivaMemb\")
			endif 
			_cFileNew:="\xml\"+ALLTRIM(SA2->A2_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.imp"

			FRename(_cFileOri,_cFileNew)
			__CopyFile("\xml\*.imp","\xml\importados\")
			// tratamento empresas        

			IF _CNUMEMP=="01"
				__CopyFile("\xml\*.imp","\xml\ArquivaMasipack\")
			ENDIF

			IF _CNUMEMP=="10"
				__CopyFile("\xml\*.imp","\xml\ArquivaFabrima\")
			ENDIF

			IF _CNUMEMP=="15"
				__CopyFile("\xml\*.imp","\xml\ArquivaHelsimplast\")
			endif

			IF _CNUMEMP=="40"
				__CopyFile("\xml\*.imp","\xml\ArquivaLabortube\")
			endif

			IF _CNUMEMP=="45"
				__CopyFile("\xml\*.imp","\xml\ArquivaMemb\")
			endif 

			ferase(_cFileNew)

			Reclock("LS3",.F.)
			dbdelete()
			MsUnlock()

			DbSelectarea("LS3")
			Dbgotop()

			DbSelectarea("LS1")
			Dbsetorder(1)
			Dbgotop()
			While !Eof()
				Reclock("LS1",.F.)
				dbdelete()
				MsUnlock()
				Dbskip()
			End

			DbSelectarea("LS5")
			Dbsetorder(1)
			Dbgotop()
			While !Eof()
				Reclock("LS5",.F.)
				dbdelete()
				MsUnlock()
				Dbskip()
			End

			PROCESS()
			oPedido:end()
			Return
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gravando pre nota entrada											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		MsgRun("Gerando prИ nota entrada No.:"+cNota,,{||PRENOTA()})
		cNotaAtu:=cNota

		If cRet

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Gravando amarracao produto x fornecedor								Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("LS1")
			Dbsetorder(1)
			Dbgotop()
			While !Eof()

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualizando NCM do produto de acordo com o XML do fornecedor		Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				IF !Empty(LS1->NCM)
					DbSelectarea("SB1")
					DbSetorder(1)
					Dbgotop()
					Dbseek(xFilial("SB1")+LS1->PRODUTO)
					If Found()
						//	Reclock("SB1",.F.)
						//SB1->B1_POSIPI:=LS1->NCM
						//	MsUnlock()
					Endif
				Endif

				If !Empty(LS1->PRODFOR)
					DbSelectarea("SA5")
					DbSetorder(1)
					Dbgotop()
					Dbseek(xFilial("SA5")+LS3->FORNEC+LS3->LOJA+LS1->PRODUTO)
					If !Found()
						Reclock("SA5",.T.)
						SA5->A5_FILIAL:=xFilial("SA5")
						SA5->A5_FORNECE:=LS3->FORNEC
						SA5->A5_LOJA:=LS3->LOJA
						SA5->A5_CODPRF:=LS1->PRODFOR
						SA5->A5_PRODUTO:=LS1->PRODUTO
						SA5->A5_NOMPROD:=SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC"),1,30)
						If lItem==.F.
							SA5->A5_NOMEFOR:=POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS2->LOJA,"A2_NREDUZ")
						Else
							SA5->A5_NOMEFOR:=POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_NREDUZ")
						Endif
						MsUnlock()
					Else
						Reclock("SA5",.F.)
						SA5->A5_CODPRF:=LS1->PRODFOR
						MsUnlock()
					Endif
				Endif
				DbSelectarea("LS1")
				Reclock("LS1",.F.)
				dbdelete()
				MsUnlock()
				Dbskip()
			End

			DbSelectarea("LS3")
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Dados do fornecedor													Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("SA2")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA2")+LS3->FORNEC+LS3->LOJA)

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Nomeclatura dos arquivos											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cFileOri:="\xml\"+ALLTRIM(LS3->XML)


			_cFileNew:="\xml\"+ALLTRIM(SA2->A2_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.imp"

			FRename(_cFileOri,_cFileNew)
			__CopyFile("\xml\*.imp","\xml\importados\")
			// tratamento empresas        

			IF _CNUMEMP=="01"
				__CopyFile("\xml\*.imp","\xml\ArquivaMasipack\")
			ENDIF

			IF _CNUMEMP=="10"
				__CopyFile("\xml\*.imp","\xml\ArquivaFabrima\")
			ENDIF

			IF _CNUMEMP=="15"
				__CopyFile("\xml\*.imp","\xml\ArquivaHelsimplast\")
			endif                  

			IF _CNUMEMP=="40"
				__CopyFile("\xml\*.imp","\xml\ArquivaLabortube\")
			endif                   

			IF _CNUMEMP=="45"
				__CopyFile("\xml\*.imp","\xml\ArquivaMemb\")
			endif

			ferase(_cFileNew)

			Reclock("LS3",.F.)
			dbdelete()
			MsUnlock()

			DbSelectarea("LS3")
			Dbgotop()
			oPedido:end()

			Msgbox("PrИ-Nota "+cNotaAtu+" gerada com sucesso!","AtenГЦo...","INFO")

			PROCESS()
		Endif
	Else
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Apagando Flag dos pedidos											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("LS1")
		DbSetorder(1)
		Dbgotop()
		While !Eof()
			IF !EMPTY(LS1->PEDIDO)
				Reclock("LS1",.F.)
				LS1->PEDIDO:=""
				LS1->ITEM:=""
				LS1->ALTERADO:=""
				MsUnlock()
			Endif
			Dbskip()
		End
		DbSelectarea("LS1")
		DbSetorder(1)
		Dbgotop()
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё 													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/{Protheus.doc} CORRIGE
//TODO DescriГЦo: Corrigir produto.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type function
/*/
Static Function CORRIGE()

	cEmail:=(ALLTRIM(SA2->A2_EMAIL))

	nSeek:=LS1->SEQ

	If LS1->OK=="X"
		aCampos6:= {{"PRODUTO","C",15,0 },;
		{"DESCRICAO","C",45,0 },;
		{"QE","N",12,5 },;
		{"SALDO","N",18,6 },;
		{"PEDIDO","C",3,0 },;
		{"CERTIF","C",20,0 },;
		{"BLQ","C",5,0 }}
		cArqTrab6  := CriaTrab(aCampos6)
		dbUseArea( .T.,, cArqTrab6, "LS4", if(.F. .OR. .F., !.F., NIL), .F. )
		IndRegua("LS4",cArqTrab6,"DESCRICAO",,,)
		dbSetIndex( cArqTrab6 +OrdBagExt())
		dbSelectArea("LS4")

		lTem:=.F.
		cQuery:=" SELECT B1_MSBLQL BLQ,B1_CODBAR CODBAR,B1_COD PRODUTO,B1_DESC DESCRICAO FROM SB1"+SM0->M0_CODIGO+"0 "
		cQuery:=cQuery + " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
		cQuery:=cQuery + " AND B1_PROC='"+LS3->FORNEC+"' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		While !Eof()
			If Empty(cAlmox)
				cAlmox:=Posicione("SB1",1,xFilial("SB1")+TCQ->PRODUTO,"B1_LOCPAD")
			Endif

			Reclock("LS4",.T.)
			LS4->PRODUTO:=TCQ->PRODUTO
			IF "SAIU" $ TCQ->DESCRICAO
				LS4->DESCRICAO:=SUBSTR(TCQ->DESCRICAO,6,45)
			Else
				LS4->DESCRICAO:=TCQ->DESCRICAO
			Endif
			LS4->SALDO:=POSICIONE("SB2",2,xFilial("SB2")+cAlmox+TCQ->PRODUTO,"B2_QATU-B2_RESERVA-B2_QEMP")
			LS4->QE:=POSICIONE("SB1",1,xFilial("SB1")+TCQ->PRODUTO,"B1_CONV")
			LS4->PEDIDO:=TEMPED(TCQ->PRODUTO)
			LS4->BLQ:=IIF(TCQ->BLQ=="1","Bloq.","Ativo")
			MsUnlock()
			DbSelectarea("TCQ")
			Dbskip()
		End
		DbClosearea("TCQ")

		_cProduto:=Space(15)

		aTitulo6 := {}
		AADD(aTitulo6,{"BLQ","Sit."})
		AADD(aTitulo6,{"PRODUTO","Produto"})
		AADD(aTitulo6,{"DESCRICAO","DescriГЦo"})
		AADD(aTitulo6,{"QE","Qtd.Emb.","@e 9999,999.99999"})
		AADD(aTitulo6,{"CERTIF","Certif.","@!"})
		AADD(aTitulo6,{"SALDO","Saldo Atual","@e 999,999,999.999999"})
		AADD(aTitulo6,{"PEDIDO","Possui Pedido?"})
		DbSelectarea("LS4")
		Dbgotop()

		_cFiltrox:=SUBSTR(LS1->DESCRICAO,1,4)+space(30)
		lCheck1:=.F.

		@ 120,040 TO 450,880 DIALOG oAmarra TITLE "Produto do fornecedor..."
		@ 005,005 say LS1->DESCRICAO SIZE 200,40 FONT oFont1 OF oAmarra PIXEL
		@ 020,005 TO 140,417 BROWSE "LS4" OBJECT OBRWX FIELDS aTitulo6
		OBRWX:OBROWSE:bLDblClick   := {|| SELECIONA(LS4->PRODUTO,2) }
		OBRWX:oBrowse:oFont := TFont():New ("Arial", 07, 18)

		@ 005,210 say "Filtro" SIZE 200,40 FONT oFont1 OF oAmarra PIXEL COLOR CLR_HRED
		@ 005,230 get _cFiltrox SIZE 70,20 Picture "@!"
		@ 005,300 BUTTON "_Filtrar" SIZE 35,10 ACTION MsgRun("Processando produtos...",,{||FILTRE()})
		If cPedCom
			@ 005,340 CHECKBOX "Somente com Pedidos" VAR lCheck1
		Endif
		@ 150,010 BUTTON "Reativar Produto" SIZE 60,12 ACTION DESBLOQ()
		@ 150,075 BUTTON "Incluir Produto" SIZE 60,12 ACTION mata010()
		ACTIVATE DIALOG oAmarra CENTER

		Dbselectarea("LS4")
		dbCloseArea("LS4")
		fErase( cArqTrab6+ ".DBF" )
		fErase( cArqTrab6+ OrdBagExt() )
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Corrigir produtos encontrados automaticamente						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Empty(LS1->OK) .OR. LS1->OK=="O" .OR. LS1->OK=="D"
		SELECIONA(LS1->PRODUTO,1)
	Endif
Return

/*/{Protheus.doc} XML
//TODO DescriГЦo: Processa os arquivos XML.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function XML(i)

	private _oXml    := NIL
	private cError   := ''
	private cWarning := ''
	nXmlStatus := XMLError()
	cFile:="\xml\"+lower(ALLTRIM(aXML[i]))
	oXml := XmlParserFile(cFile,"_",@cError, @cWarning )
	lTipo:=3

	If ALLTRIM(TYPE("oxml:_NFE:_INFNFE"))=="O"
		lTipo:=1
	Endif
	If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE"))=="O"
		lTipo:=2
	Endif  
	Private _cFrete := 0   
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//Ё Conhecimento de frete												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ALLTRIM(TYPE("oxml:_CTEPROC:_CTE"))=="O" .OR. ALLTRIM(TYPE("oxml:_PROCCTE:_CTE"))=="O" .OR. ALLTRIM(TYPE("oxml:_CTEOSPROC:_CTEOS"))== "O"
		lTipo:=7
		cTipoNF:="CTR"
	Endif


	If Empty(@cError) .and. lTipo<>3 
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Com _NFEPROC														Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_cCNPJ2:=""
		If lTipo==2
			XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
			If Type("oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE") == "U"
				_cCNPJ2 := ""
			Else
				If SUBSTR(alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
					_cCNPJ2:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Endif
			EndIf
			_cCNPJ:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT) 

			If alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT) == "1"																
				_cFrete:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:TEXT)
			Else
				_cFrete := 0
			EndIf  

			cNota:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT

			If Empty(cSerieNF)
				cSerie:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			Endif
			cNatOp:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT

			IF XXVERSAO=="2"
				cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
			ELSE
				cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
			ENDIF
			cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
			cChave:=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,200))

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Manipulando numero da nota fiscal									Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If len(alltrim(cNota))<=6
				cNota:=strzero(val(cNota),6)
			Endif
			If cZeros
				cNota:=strzero(val(cNota),9)
			Endif
			nTam:=len(alltrim(cNota))
			cSpaco:=(9-nTam)

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Empresa atual														Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If alltrim(_cCNPJ2)<>alltrim(SM0->M0_CGC)
				_cCNPJ:=''
			Endif
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Conhecimento de Frete												Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		ElseIf lTipo==7
			If Empty(@cError)
				cTipoCte := IIF(ALLTRIM(TYPE("oxml:_proccte"))=="O","pro",IIF(ALLTRIM(TYPE("oxml:_cteosproc"))=="O","cteos","cte"))
				If ALLTRIM(TYPE("oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT"))=="C" .OR.; 
				ALLTRIM(TYPE("oxml:_PROCCTE:_CTE:_INFCTE:_REM:_CNPJ:TEXT"))=="C"
					If ALLTRIM(TYPE("oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT"))=="C"
						cToma:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT)
					Elseif ALLTRIM(TYPE("oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT"))=="C"
						cToma:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT)
					ElseIf ALLTRIM(TYPE("oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT"))=="C" 
						cToma:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT)      
					ElseIf ALLTRIM(TYPE("oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT"))=="C"
						cToma:=oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT		  		
					ElseIf ALLTRIM(TYPE("oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT"))=="C"
						cToma:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT)
					Elseif ALLTRIM(TYPE("oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT"))=="C"
						cToma:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT)
					Else    
						If cTipoCte == "cte"
							cToma:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA2:_TOMA:TEXT)
						Else
							cToma:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA2:_TOMA:TEXT)
						Endif
					EndIf

					If cToma=="0" 
						If cTipoCte == "cte"
							_cCNPJ2:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
						Else
							_cCNPJ2:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
						Endif
					ElseIf cToma=="1" 
						If cTipoCte == "cte"
							_cCNPJ2:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
						Else
							_cCNPJ2:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
						Endif
					ElseIf cToma== "3" .OR. cToma== "2"
						If cTipoCte == "cte"
							_cCNPJ2:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
						Else
							_cCNPJ2:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
						Endif
					ElseIf cToma== "4"
						If cTipoCte == "cte"
							_cCNPJ2:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)		
						Else
							_cCNPJ2:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)		
						Endif
					EndIf
				Elseif ALLTRIM(TYPE("oxml:_CTEOSPROC:_CTEOS:_INFCTE:_TOMA:_CNPJ:TEXT"))== "C"
					_cCNPJ2:=ALLTRIM(oxml:_CTEOSPROC:_CTEOS:_INFCTE:_TOMA:_CNPJ:TEXT)		
				Endif

				If cTipoCte == "cte"
					_cCNPJ:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
				Elseif cTipoCte == "cteos"
					_cCNPJ:=ALLTRIM(oxml:_CTEOSPROC:_CTEOS:_INFCTE:_EMIT:_CNPJ:TEXT) 
				Else 
					_cCNPJ:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
				Endif	
				If cTipoCte == "cte"
					cNota:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_CCT:TEXT)
				Elseif cTipoCte == "cteos"
					cNota:=ALLTRIM(oxml:_CTEOSPROC:_CTEOS:_INFCTE:_IDE:_NCT:TEXT)
				Else
					cNota:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_CCT:TEXT)
				Endif
				If cTipoCte == "cte"
					cChave:=ALLTRIM(SUBSTR(ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT),4,200))
				Elseif cTipoCte == "cteos"
					cChave:=ALLTRIM(SUBSTR(ALLTRIM(oxml:_CTEOSPROC:_CTEOS:_INFCTE:_ID:TEXT),4,200))
				Else
					cChave:=ALLTRIM(SUBSTR(ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_ID:TEXT),4,200))
				Endif
				If cTipoCte == "cte"
					cEmissao:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT)
				ElseIf cTipoCte == "cteos"
					cEmissao:=ALLTRIM(oxml:_CTEOSPROC:_CTEOS:_INFCTE:_IDE:_DHEMI:TEXT)
				Else
					cEmissao:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_IDE:_DHEMI:TEXT)
				Endif
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				If cTipoCte == "cte"
					nValor:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)
				Elseif cTipoCte == "cteos"
					nValor:=ALLTRIM(oxml:_CTEOSPROC:_CTEOS:_INFCTE:_VPREST:_VTPREST:TEXT)
				Else
					nValor:=ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)
				Endif
				nValor:=VAL(nValor)


				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Empresa atual														Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If ALLTRIM(_cCNPJ2)<>ALLTRIM(SM0->M0_CGC)
					_cCNPJ:=''
				Endif
			Else
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Arquivos corrompidos												Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				fErase(cFile)
			Endif


		Else

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Sem _NFEPROC															Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If Type("oxml:_NFE:_INFNFE:_DEST:_IE") == "U"
				_cCNPJ2 := ""
			Else
				If SUBSTR(alltrim(oxml:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
					_cCNPJ2:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Endif
			EndIf
			_cCNPJ:=alltrim(oxml:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
			XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
			If alltrim(oxml:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT) == "1"															
				_cFrete:=alltrim(oxml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:TEXT)
			Else
				_cFrete := 0
			EndIf
			IF XXVERSAO=="2"
				cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
			else
				cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
			ENDIF
			cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
			cNota:=oxml:_NFE:_INFNFE:_IDE:_NNF:TEXT
			If Empty(cSerieNF)
				cSerie:=oxml:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			Endif
			cNatOp:=oxml:_NFE:_INFNFE:_IDE:_NATOP:TEXT
			cChave:=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_ID:TEXT,4,200))

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Manipulando numero da nota fiscal									Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If len(alltrim(cNota))<=6
				cNota:=strzero(val(cNota),6)
			Endif
			If cZeros
				cNota:=strzero(val(cNota),9)
			Endif
			nTam:=len(alltrim(cNota))
			cSpaco:=(9-nTam)

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Empresa atual														Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If alltrim(_cCNPJ2)<>alltrim(SM0->M0_CGC)
				_cCNPJ:=''
			Endif
		Endif


		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifico se a nota ja foi importada									Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !Empty(_cCNPJ)
			DbSelectarea("SA2")
			DbSetorder(3)
			Dbgotop()
			Dbseek(xFilial("SA2")+_cCNPJ)
			If Found()
				dbSelectArea("SF1")
				DbSetorder(8)
				Dbgotop()
				Dbseek(xFilial("SF1")+ALLTRIM(cChave))
				If Found() .and. SF1->F1_TIPO=="N"

					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Nomeclatura dos arquivos											Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					_cFileOri:="\xml\"+lower(ALLTRIM(aXML[i]))
					_cFileNew:="\xml\"+ALLTRIM(_cCNPJ)+"-nf"+ALLTRIM(cNota)+"-"+ALLTRIM(cChave)+".xml.imp"

					FRename(_cFileOri,_cFileNew)
					__CopyFile("\xml\*.imp","\xml\importados\")
					ferase(_cFileNew)

					_cCNPJ:=''
				Endif
			Endif
		Endif
	Else
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Nomeclatura dos arquivos											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_cFileOri:="\xml\"+lower(ALLTRIM(aXML[i]))
		_cFileNew:="\xml\"+lower(ALLTRIM(aXML[i]))+".err"

		FRename(_cFileOri,_cFileNew)
		__CopyFile("\xml\*.err","\xml\corrompidos\")
		ferase(_cFileNew)
	Endif
Return

/*/{Protheus.doc} PRENOTA
//TODO DescriГЦo: GeraГЦo da prИ-nota via execauto.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function PRENOTA()

	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Private lMsErroAuto := .f.
	cRet:=.F.

	DbSelectarea("LS1")
	dbgotop()
	_dEmissao:=STOD(LS1->EMISSAO)

	If cPedCom .and. lItem==.F.
		cQuere:=" UPDATE SC7"+SM0->M0_CODIGO+"0 SET C7_LOJA='"+LS3->LOJA+"' WHERE C7_FILIAL='"+xFilial("SC7")+"' AND C7_NUM='"+LS2->PEDIDO+"' AND D_E_L_E_T_<>'*' "
		TCSQLEXEC(cQuere)
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//| Grava status no fornecedor que manda o XML					 |
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	DbSelectarea("SA2")
	DbSetorder(1)
	Dbgotop()
	Dbseek(xFilial("SA2")+LS3->FORNEC+LS3->LOJA)
	If Found()
		Reclock("SA2",.F.)
		SA2->A2_STATUS:="1"
		MsUnlock()
	Endif   

	cMSOBS := ""
	If msgbox("Produto jА chegou?","AtenГЦo...","YESNO")
		cMSOBS := "S"
	Else 
		cMSOBS := "N"	
	EndIf           

	DbSelectarea("LS1")
	DbSetorder(1)
	Dbgotop()

	While !Eof()
		_cPedido:=LS1->PEDIDO

		If LS1->DESCONTO>0
			_nPrecoU:=LS1->PRECO+(LS1->DESCONTO/LS1->QUANTIDADE)
			_nTotalIt:=ROUND((LS1->QUANTIDADE*_nPrecoU),2)
		Else
			_nPrecoU:=LS1->PRECO
			_nTotalIt:=ROUND(LS1->TOTAL,2)
		Endif
		xxlocal := GetAdvFVal("SB1","B1_LOCPAD",xFilial("SB1")+LS1->PRODUTO,1," " )
		xxdesc  :=POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC")
		xxtipo  :=POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_TIPO")
		xxncm   :=POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_POSIPI")
		xxcta := GetAdvFVal("SB1","B1_CONTA",xFilial("SB1")+LS1->PRODUTO,1," " )
		aLinha := {}
		aadd(aLinha,{"D1_COD",LS1->PRODUTO,Nil})
		aadd(aLinha,{"D1_QUANT",LS1->QUANTIDADE,Nil})
		If LS1->OK <> "D" 
			aadd(aLinha,{"D1_PEDIDO",LS1->PEDIDO,Nil})
		EndIf
		If xxpedcom .AND. LS1->OK <> "D"  
			aadd(aLinha,{"D1_ITEMPC",LS1->ITEM,Nil}) 
		EndIf
		aadd(aLinha,{"D1_VUNIT",_nPrecoU,Nil})
		aadd(aLinha,{"D1_VALDESC",LS1->DESCONTO,Nil})
		aadd(aLinha,{"D1_LOCAL",IIF(!EMPTY(xxlocal),xxlocal,LS1->ALMOX),Nil})
		aadd(aLinha,{"D1_MSCERT",LS1->CERTIF,Nil})
		aadd(aLinha,{"D1_MSOBS",cMSOBS,Nil})
		aadd(aLinha,{"D1_MSNCM",xxncm,Nil})
		aadd(aLinha,{"D1_DTFISC",dDataBase,Nil})
		If !Empty(Alltrim(xxcta))
			aadd(aLinha,{"D1_CONTA",xxcta,Nil})
		Endif

		aadd(aItens,aLinha)
		DbSelectarea("LS1")
		Dbskip()
	End
	If !Empty(_cPedido) .and. cPedCom
		DbSelectarea("SC7")
		DbSetorder(1)
		Dbgotop()
		Dbseek(xFilial("SC7")+_cPedido)
	Endif
	aadd(aCabec,{"F1_TIPO","N"})
	aadd(aCabec,{"F1_SERIE",cSerie})
	aadd(aCabec,{"F1_FORMUL","N"})
	aadd(aCabec,{"F1_DOC",(cNota)})
	aadd(aCabec,{"F1_EMISSAO",_dEmissao})
	if !xxpedcom
		DBSELECTAREA("SA2")
		DBSETORDER(1)
		Dbseek(xFilial("SA2")+LS3->FORNEC)
		cCheckcgc := SA2->A2_CGC
	  	/*
	  	If cCheckcgc == "57582793000111" .AND. SubStr(cNumEmp,1,2) <> "15" 
			cResp10 := msgbox("FESTO - SIM para o cСdigo: 002045 - FESTO AUTOMACAO LTDA. e NцO para o cСdigo: 000157 - FESTO BRASIL LTDA.","AtenГЦo...","YESNO")
			If cResp10
				aadd(aCabec,{"F1_FORNECE","002045"})
			Else
				aadd(aCabec,{"F1_FORNECE","000157"})
			EndIf  
		
		Else
			aadd(aCabec,{"F1_FORNECE",LS3->FORNEC})
		EndIf 
		*/
		aadd(aCabec,{"F1_FORNECE",LS3->FORNEC})
	Else
		aadd(aCabec,{"F1_FORNECE",LS3->FORNEC})
	EndIf
	aadd(aCabec,{"F1_LOJA",LS3->LOJA})
	aadd(aCabec,{"F1_ESPECIE",cEspecie})
	cEspecie:="SPED"
	aadd(aCabec,{"F1_CHVNFE",LS3->CHAVE})
	aadd(aCabec,{"F1_CHVNFE",LS3->CHAVE})
	aadd(aCabec,{"F1_HORA",LEFT(TIME(),5)})
	If LS3->FRETE > 0
		aadd(aCabec,{"F1_FRETE",LS3->FRETE})
	EndIf

	If Len(aCabec)>0 .and. Len(aItens)>0
		MATA140(aCabec,aItens)
	Endif

	If lMsErroAuto
		MostraErro()
	Else

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gerando NDF para o fornecedor do valor excedido						Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If cNDF .and. cPedCom
			_nExcedido:=0 // NAO VAI GERAR NDF
			If _nExcedido>0
				cResp:=msgbox("Deseja gerar a NDF para o fornecedor no valor de R$ "+Transform(_nExcedido,"@E 999,999.99"),"AtenГЦo...","YESNO")
				If cResp
					NDF()
					Msgbox("NDF "+cNota+" gerada com sucesso!","AtenГЦo...","INFO")
				Endif
			Endif
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Calculando o total do item na nota									Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuere:=" UPDATE SD1"+SM0->M0_CODIGO+"0 SET D1_TOTAL=(D1_QUANT*D1_VUNIT) WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_DOC='"+cNota+"' AND D1_FORNECE='"+LS3->FORNEC+"' AND D1_LOJA='"+LS3->LOJA+"' AND D1_SERIE='"+cSerie+"' "
		TCSQLEXEC(cQuere)
		cRet:=.T.
	Endif

Return(cRet)

/*/{Protheus.doc} NEWPED
//TODO DescriГЦo: Novo Pedido.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function NEWPED()

	Local aCab2 :={}
	Local aItem2:={}
	PRIVATE lMsErroAuto := .F.
	lAchei:=.F.
	nOpc:=3

	_nItens:=0
	_cCond:=POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_COND")
	If Empty(_cCond)
		_cCond:="001"
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificar Status da Gravacao										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_lGrava:=Getmv("MV_GRVPEDI")
	_lGrava:=""
	If !Empty(Alltrim(_lGrava))
		ALERT("Atencao!!!, O Usuario "+_lGrava+" Esta concretizando um Pedido de Compra, Aguarde...")
		Return
	Else
		DbSelectArea("SX6")
		DbgoTop()
		While ! eof()
			If Alltrim(SX6->X6_VAR)=="MV_GRVPEDI" .and. SX6->X6_FIL==xFilial("SC7")
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD:="" //"NF-ELETRONICA-"+_cUsuario
				MsUnlock()
			Endif
			DbSkip()
		End
	Endif

	cQuery:=" SELECT MAX(C7_NUM) PEDIDO FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' AND D_E_L_E_T_<>'*' "
	TCQUERY cQuery NEW ALIAS "PED"
	DbSelectArea("PED")
	cNumPed:=STRZERO(VAL(PED->PEDIDO)+1,6)
	DbCloseArea("PED")

	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()

		If Empty(cAlmoPed)
			_cAlmoxPed:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_LOCPAD")
		Else
			_cAlmoxPed:=cAlmoPed
		Endif

		aCab2:={{"C7_NUM",cNumPed,Nil},;
		{"C7_EMISSAO" ,dDataBase,Nil},;
		{"C7_FORNECE" ,LS3->FORNEC,Nil},;
		{"C7_LOJA"    ,LS3->LOJA,Nil},;
		{"C7_CONTATO" ,Posicione("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_CONTATO"),Nil},;
		{"C7_COND"    ,_cCond,Nil},;
		{"C7_FILENT" ,xFilial("SC7"),Nil}}

		aItem3:={}
		aItem3:={{"C7_ITEM",Strzero(_nItens+1,4),Nil},;
		{"C7_PRODUTO",LS1->PRODUTO,Nil},;
		{"C7_QUANT" ,LS1->QUANTIDADE,Nil},;
		{"C7_PRECO" ,LS1->PRECO,Nil},;
		{"C7_TOTAL" ,LS1->TOTAL,Nil},;
		{"C7_DATPRF" ,dDataBase,Nil},;
		{"C7_TES"    ,POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_TE"),Nil},;
		{"C7_FLUXO" ,"S",Nil},;
		{"C7_USER" ,__CUSERID,Nil},;
		{"C7_OBS"  ,"NF-ELETRONICA"			,Nil},;
		{"C7_LOCAL",_cAlmoxPed,Nil}}

		aadd(aItem2,aItem3)
		_nItens:=_nItens+1
		DbSelectarea("LS1")
		Dbskip()
	End
	DbSelectarea("SC7")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Liberando a Gravacao de um pedido para outro usuario				Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("SX6")
	DbgoTop()
	While ! eof()
		If Alltrim(SX6->X6_VAR)=="MV_GRVPEDI" .and. SX6->X6_FIL==xFilial("SC7")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD:=""
			MsUnlock()
		Endif
		DbSkip()
	End
	DbSelectarea("LS1")
	Dbgotop()
Return

/*/{Protheus.doc} NEWPED2
//TODO DescriГЦo:  Novo Pedido por item.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type function
/*/
Static Function NEWPED2()

	Local aCab2 :={}
	Local aItem2:={}
	PRIVATE lMsErroAuto := .F.
	lAchei:=.F.
	nOpc:=3

	_nItens:=0
	_cCond:=POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_COND")
	If Empty(_cCond)
		_cCond:="001"
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificar Status da Gravacao										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_lGrava:=Getmv("MV_GRVPEDI")

	If ! Empty(Alltrim(_lGrava))
		ALERT("Atencao!!!, O Usuario "+_lGrava+" Esta concretizando um Pedido de Compra, Aguarde...")
		Return
	Else
		DbSelectArea("SX6")
		DbgoTop()
		While ! eof()
			If Alltrim(SX6->X6_VAR)=="MV_GRVPEDI" .and. SX6->X6_FIL==xFilial("SC7")
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD:="NF-ELETRONICA-"+_cUsuario
				MsUnlock()
			Endif
			DbSkip()
		End
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Numero do Pedido de compra											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cQuery:=" SELECT MAX(C7_NUM) PEDIDO FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' AND D_E_L_E_T_<>'*' "
	TCQUERY cQuery NEW ALIAS "PED"
	DbSelectArea("PED")
	cNumPed:=STRZERO(VAL(PED->PEDIDO)+1,6)
	DbCloseArea("PED")

	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		IF ALLTRIM(LS1->PEDIDO)=="CRIAR"

			If Empty(cAlmoPed)
				_cAlmoxPed:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_LOCPAD")
			Else
				_cAlmoxPed:=cAlmoPed
			Endif

			aCab2:={{"C7_NUM",cNumPed,Nil},;
			{"C7_EMISSAO" ,dDataBase,Nil},;
			{"C7_FORNECE" ,LS3->FORNEC,Nil},;
			{"C7_LOJA"    ,LS3->LOJA,Nil},;
			{"C7_CONTATO" ,Posicione("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_CONTATO"),Nil},;
			{"C7_COND"    ,_cCond,Nil},;
			{"C7_FILENT" ,xFilial("SC7"),Nil}}

			aItem3:={}
			aItem3:={{"C7_ITEM",Strzero(_nItens+1,4),Nil},;
			{"C7_PRODUTO",LS1->PRODUTO,Nil},;
			{"C7_QUANT" ,LS1->QUANTIDADE,Nil},;
			{"C7_PRECO" ,LS1->PRECO,Nil},;
			{"C7_TOTAL" ,LS1->TOTAL,Nil},;
			{"C7_DATPRF" ,dDataBase,Nil},;
			{"C7_TES"    ,POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_TE"),Nil},;
			{"C7_FLUXO" ,"S",Nil},;
			{"C7_USER" ,__CUSERID,Nil},;
			{"C7_OBS"  ,"NF-ELETRONICA"			,Nil},;
			{"C7_LOCAL",_cAlmoxPed,Nil}}
			aadd(aItem2,aItem3)

			Reclock("LS1",.F.)
			LS1->PEDIDO:=cNumPed
			LS1->ITEM:=Strzero(_nItens+1,4)

			_nItens:=_nItens+1
			MsUnlock()
		Endif
		DbSelectarea("LS1")
		Dbskip()
	End
	DbSelectarea("SC7")
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Liberando a Gravacao de um pedido para outro usuario				Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("SX6")
	DbgoTop()
	While ! eof()
		If Alltrim(SX6->X6_VAR)=="MV_GRVPEDI" .and. SX6->X6_FIL==xFilial("SC7")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD:=""
			MsUnlock()
		Endif
		DbSkip()
	End
	DbSelectarea("LS1")
	Dbgotop()
Return

/*/{Protheus.doc} PROCESS
//TODO DescriГЦo: Processa os arqvuivos XML.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type function
/*/
Static Function PROCESS()

Local i:= 0
Local w := 0

	private _oXml    := NIL
	private cError    := ''
	private cWarning := ''

	If LS3->(eof())
		msgbox("NЦo existem notas fiscais eletrТnicas para serem importadas!")
		OBRWI:obrowse:refresh()
		OBRWP:obrowse:refresh()
		OBRWI:obrowse:setfocus()
		OBRWP:obrowse:setfocus()
		ObjectMethod(oTela,"Refresh()")
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifico se existe a nota fiscal									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IF !file("\xml\"+lower(LS3->XML))
		msgbox("Este arquivo jА foi processado por outro usuАrio!","AtenГЦo...","ALERT")
		Reclock("LS3",.F.)
		dbdelete()
		MsUnlock()

		DbSelectarea("LS3")
		Dbgotop()
		PROCESS()
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifico se foi alterado algum item									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	lAltera:=.F.
	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		IF LS1->ALTERADO=="S"
			_cChave:=LS1->NOME+LS1->NOTA
			lAltera:=.T.
		Endif
		Dbskip()
	End

	IF lAltera
		cResp:=msgbox("Deseja perder todas as alteraГУes realizadas?","AtenГЦo...","YESNO")

		If cResp==.F.
			DbSelectarea("LS3")
			Dbsetorder(1)
			dbgotop()
			Dbseek(_cChave)

			DbSelectarea("LS1")
			Dbgotop()
			OBRWI:obrowse:refresh()
			OBRWP:obrowse:refresh()
			OBRWI:obrowse:setfocus()
			OBRWP:obrowse:setfocus()
			ObjectMethod(oTela,"Refresh()")
			Return
		Endif
	Endif

	nXmlStatus := XMLError()
	cFile:="\xml\"+lower(ALLTRIM(LS3->XML))
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando dados da tabela temporaria									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS1")
	Dbsetorder(1)
	Dbgotop()
	While !Eof()
		Reclock("LS1",.F.)
		dbdelete()
		MsUnlock()
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando produtos temporarios										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS5")
	Dbsetorder(1)
	Dbgotop()
	While !Eof()
		Reclock("LS5",.F.)
		dbdelete()
		MsUnlock()
		Dbskip()
	End

	oXml := XmlParserFile(cFile,"_",@cError, @cWarning )
	aCols:={}
	nTotIt:=0
	nTotalNF:=0

	IF ALLTRIM(TYPE("oxml:_NFE:_INFNFE"))=="O"
		lTipo:=1    
	ElseIf ALLTRIM(TYPE("oxml:_cteProc:_CTe"))=="O" .OR. ALLTRIM(TYPE("oxml:_PROCCTE:_CTE"))=="O" .OR. ALLTRIM(TYPE("oxml:_CTEOSPROC:_CTEOS"))=="O"
		lTipo:=7	
	Else
		lTipo:=2
	Endif

	nDescont:=0

	If ( nXmlStatus == XERROR_SUCCESS )

		If lTipo==2
			aCols:=aClone(oXml:_NFEPROC:_NFE:_INFNFE:_DET)
		ElseIf lTipo==7 // CT-e


		Else
			aCols:=aClone(oXml:_NFE:_INFNFE:_DET)
		Endif

		If aCols==NIL .AND. lTipo<>7  

			nItens:=1    

		ElseIf lTipo==7 //CT-e  
			cTipoCte := IIf(ALLTRIM(TYPE("oxml:_PROCCTE"))=="O","pro",IIF(ALLTRIM(TYPE("oxml:_CTEOSPROC"))=="O","cteos","cte"))
			If ALLTRIM(TYPE("oxml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMSSN"))=="O" .OR. ALLTRIM(TYPE("oxml:_PROCCTE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSSN"))=="O"       //NЦo possui imposto
				nItens:=1 

			ElseIf ALLTRIM(TYPE("oxml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00"))=="O" .OR. ALLTRIM(TYPE("oxml:_PROCCTE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00"))=="O"     //possui imposto

				If cTipoCte=="cte"
					If (oxml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT) == (oxml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_vBC:TEXT)
						nItens:=1
					Else     //Base de calculo ICMS nЦo И igual ao total, por isso deve ser aberto dois itens na prИ-nota, um deles И somente para os impostos que nЦo comporam o valor total.
						nItens:=2
					Endif
				Else 
					If (oxml:_PROCCTE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT) == (oxml:_PROCCTE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_vBC:TEXT)   // base de calculo ICMS И igual ao total 
						nItens:=1
					Else     //Base de calculo ICMS nЦo И igual ao total, por isso deve ser aberto dois itens na prИ-nota, um deles И somente para os impostos que nЦo comporam o valor total.
						nItens:=2                                                                                                                      
					Endif
				EndIf   
			Else
				nItens:=1
			EndIf
		Else
			nItens:=len(aCols)
		Endif

		For i:=1 to nItens
			nDescont := 0 /*Reinicio a variavel pois este cara И por item*/
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Com _NFEPROC														Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lTipo==2
				cEspecie := "SPED" 
				If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT"))=="C"
					_cMensag:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT)
				Endif

				If nItens>1
					cCodbar :=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CEAN:TEXT
					cProdFor:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT
					nQuant	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)
					xDesc	:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_XPROD:TEXT
					xCFOP:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CFOP:TEXT
					If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT"))=="C"
						cNCM	:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT
					Endif
					nPreco	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VUNCOM:TEXT)
					If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VDESC:TEXT"))=="C"
						nDescont:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VDESC:TEXT)
					Endif
					nTotal	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VPROD:TEXT)
					cNota	:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
					If Empty(cSerieNF)
						cSerie  :=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
					Endif
					cNatOp  :=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
					cUM		:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_UCOM:TEXT
					XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
					IF XXVERSAO=="2"
						cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
					else
						cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
					ENDIF
					If Type("oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE") == "U"
						_cCNPJ	:=""
						_cEmpresa:=""
					Else
						If SUBSTR(alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
							_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
						Else
							_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
							_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
						Endif
					EndIf
					cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
					cProd:=''
				Else 
					cEspecie := "SPED" 
					cCodbar :=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT
					cProdFor:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
					nQuant	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)
					xCFOP:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
					If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT"))=="C"
						nDescont:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT)
					Endif
					xDesc	:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT
					If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT"))=="C"
						cNCM	:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT
					Endif
					nPreco	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)
					nTotal	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT)
					cNota	:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
					If Empty(cSerieNF)
						cSerie  :=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
					Endif
					cNatOP	:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
					XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
					IF XXVERSAO=="2"
						cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
					else
						cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
					ENDIF
					cUM		:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT
					If Type("oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE") == "U"
						_cCNPJ	:=""
						_cEmpresa:=""
					Else
						If SUBSTR(alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
							_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
						Else
							_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
							_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
						Endif
					EndIf
					cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
					cProd:=''
				Endif     

			ElseIf lTipo==7 //CT-e

				If nItens == 1 
					IF cTipoCte=="cte"
						cNota	:= oxml:_cteProc:_CTe:_infCte:_ide:_NCT:TEXT
					Elseif cTipoCte=="cteos"
						cNota	:= oxml:_cteosproc:_cteos:_infcte:_ide:_NCT:TEXT
					Else
						cNota	:= oxml:_Proccte:_CTe:_infCte:_ide:_NCT:TEXT
					Endif
					IF cTipoCte=="cte"
						nTotal	:= val(oxml:_cteProc:_CTe:_infCte:_vPrest:_vTPrest:TEXT)
					Elseif cTipoCte=="cteos"
						nTotal  := val(oxml:_cteosProc:_CTeOS:_infCte:_vPrest:_vTPrest:TEXT)
					Else
						nTotal	:= val(oxml:_Proccte:_CTe:_infCte:_vPrest:_vTPrest:TEXT)
					Endif
					IF cTipoCte=="cte"
						nPreco	:= val(oxml:_cteProc:_CTe:_infCte:_vPrest:_vTPrest:TEXT)
					Elseif cTipoCte=="cteos" 
						nPreco	:= val(oxml:_CTeOSProc:_CTeOS:_InfCte:_vPrest:_vTPrest:TEXT)
					Else
						nPreco	:= val(oxml:_Proccte:_CTe:_infCte:_vPrest:_vTPrest:TEXT)
					Endif
					xDesc	:= "ServiГo de Transporte"
					cProdFor:="01"


				ElseIf nItens == 2   //Base de calculo do imposto И diferente do total da nota
					If i = 1 
						cNota	:= IIF(cTipoCte=="cte",oxml:_cteProc:_CTe:_infCte:_ide:_nCT:TEXT,oxml:_Proccte:_CTe:_infCte:_ide:_nCT:TEXT)
						nTotal	:= IIF(cTipoCte=="cte",val(oxml:_cteProc:_CTe:_infCte:_vPrest:_vTPrest:TEXT),val(oxml:_Proccte:_CTe:_infCte:_vPrest:_vTPrest:TEXT))
						nPreco	:= IIF(cTipoCte=="cte",val(oxml:_cteProc:_CTe:_infCte:_vPrest:_vTPrest:TEXT),val(oxml:_Proccte:_CTe:_infCte:_vPrest:_vTPrest:TEXT))
						xDesc		:= "ServiГo de Transporte" 
						cProdFor	:="01"
					Else 
						cNota	:= IIF(cTipoCte=="cte",oxml:_cteProc:_CTe:_infCte:_ide:_nCT:TEXT,oxml:_Proccte:_CTe:_infCte:_ide:_nCT:TEXT)
						nTotal	:= IIF(cTipoCte=="cte",val(oxml:_cteProc:_CTe:_infCte:_vPrest:_vTPrest:TEXT),val(oxml:_Proccte:_CTe:_infCte:_vPrest:_vTPrest:TEXT))
						nPreco	:= IIF(cTipoCte=="cte",val(oxml:_cteProc:_CTe:_infCte:_vPrest:_vTPrest:TEXT),val(oxml:_Proccte:_CTe:_infCte:_vPrest:_vTPrest:TEXT))
						xDesc		:= "Imposto" 
						cProdFor	:="02"
					EndIf
				EndIf   
				xCFOP:=""
				cEspecie := "CTE" 
				cCodbar 		:=""
				IF cTipoCte=="cte"
					cSerie 		:= alltrim(oxml:_cteProc:_CTe:_infCte:_ide:_serie:TEXT)
				Elseif cTipoCte=="cteos"
					cSerie 		:= alltrim(oxml:_cteosProc:_CTeOS:_infCte:_ide:_serie:TEXT)
				Else
					cSerie 		:= alltrim(oxml:_Proccte:_CTe:_infCte:_ide:_serie:TEXT)
				Endif
				cNatOp  		:=""
				cUM				:="UN"    
				IF cTipoCte=="cte"
					_cCNPJ 		:= ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
				Elseif cTipoCte=="cteos"
					_cCNPJ 		:= ALLTRIM(oxml:_CTEOSPROC:_CTEOS:_INFCTE:_EMIT:_CNPJ:TEXT)
				Else
					_cCNPJ 		:= ALLTRIM(oxml:_PROCCTE:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
				Endif
				_cEmpresa		:=_cCNPJ2 
				cProd			:=''
				IF cTipoCte=="cte"
					cEmissao	:= substr(oxml:_cteProc:_CTe:_infCte:_ide:_dhEmi:TEXT,1,10)
				ElseIf cTipoCte=="cteos"
					cEmissao	:= substr(oxml:_cteOSProc:_CTeOS:_infCte:_ide:_dhEmi:TEXT,1,10)
				Else
					cEmissao	:= substr(oxml:_Proccte:_CTe:_infCte:_ide:_dhEmi:TEXT,1,10)
				Endif
				cEmissao		:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				nQuant 		:= 1	  
				nDescont 	:= 0 
			Else
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Sem _NFEPROC														Ё              /
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If ALLTRIM(TYPE("oxml:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT"))=="C"
					_cMensag:=alltrim(oxml:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT)
				Endif

				If nItens>1
					cCodbar :=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_CEAN:TEXT
					cProdFor:=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT
					nQuant	:=val(oxml:_NFE:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)
					xDesc	:=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_XPROD:TEXT
					If ALLTRIM(TYPE("oxml:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT"))=="C"
						cNCM	:=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT
					Endif
					cUM		:=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_UCOM:TEXT
					If ALLTRIM(TYPE("oxml:_NFE:_INFNFE:_DET[i]:_PROD:_VDESC:TEXT"))=="C"
						nDescont:=val(oxml:_NFE:_INFNFE:_DET[i]:_PROD:_VDESC:TEXT)
					Endif
					nPreco	:=val(oxml:_NFE:_INFNFE:_DET[i]:_PROD:_VUNCOM:TEXT)
					nTotal	:=val(oxml:_NFE:_INFNFE:_DET[i]:_PROD:_VPROD:TEXT)
					cNota	:=oxml:_NFE:_INFNFE:_IDE:_NNF:TEXT
					If Empty(cSerieNF)
						cSerie  :=oxml:_NFE:_INFNFE:_IDE:_SERIE:TEXT
					Endif
					cNatOP	:=oxml:_NFE:_INFNFE:_IDE:_NATOP:TEXT
					xxversao:= substr(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1)
					IF XXVERSAO=="2"
						cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
					else
						cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
					ENDIF

					If Type("oxml:_NFE:_INFNFE:_DEST:_IE") == "U"
						_cCNPJ	:=""
						_cEmpresa:=""
					Else
						If SUBSTR(alltrim(oxml:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
							_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
						Else
							_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
							_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
						Endif
					EndIf
					cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
					cProd:=''
				Else
					cCodbar :=oxml:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT
					cProdFor:=oxml:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
					nQuant	:=val(oxml:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)
					xDesc	:=oxml:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT  

					If ALLTRIM(TYPE("oxml:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT"))=="C"
						cNCM	:=oxml:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT
					Endif
					If ALLTRIM(TYPE("oxml:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT"))=="C"
						nDescont:=val(oxml:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT)
					Endif
					cUM		:=oxml:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT
					nPreco	:=val(oxml:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)
					nTotal	:=val(oxml:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT)
					cNota	:=oxml:_NFE:_INFNFE:_IDE:_NNF:TEXT
					If Empty(cSerieNF)
						cSerie  :=oxml:_NFE:_INFNFE:_IDE:_SERIE:TEXT
					Endif
					cNatOP	:=oxml:_NFE:_INFNFE:_IDE:_NATOP:TEXT
					xxversao:= substr(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1)
					IF XXVERSAO=="2"
						cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
					else
						cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
					ENDIF
					If Type("oxml:_NFE:_INFNFE:_DEST:_IE") == "U"
						_cCNPJ	:=""
						_cEmpresa:=""
					Else
						If SUBSTR(alltrim(oxml:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
							_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
						Else
							_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
							_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
						Endif
					EndIf
					cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
					cProd:=''
				Endif
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё codigo barras														Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If !Empty(cCodbar) .and. SUBSTR(cCodbar,1,8)<>"00000000"
				DbSelectarea("SB1")
				DbSetorder(5)
				Dbgotop()
				Dbseek(xFilial("SB1")+cCodbar,.t.)
				If Found() .and. SB1->B1_MSBLQL<>"1"
					cProd:=SB1->B1_COD
				Endif

				If Empty(cProd)
					DbSelectarea("SLK")
					DbSetorder(1)
					Dbgotop()
					Dbseek(xFilial("SLK")+cCodbar,.t.)
					If Found()
						cProd:=SLK->LK_CODIGO

						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifico se esta bloqueado											Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						DbSelectarea("SB1")
						DbSetorder(1)
						Dbgotop()
						Dbseek(xFilial("SB1")+cProd,.t.)
						If Found() .and. SB1->B1_MSBLQL=="1"
							cProd:=''
						Endif
					Endif
				Endif
			Endif
			cProdFor := StrTran(cProdFor," ","")

			If len(alltrim(cProdfor))>15
				cProdFor:=SUBSTR(cProdFor,1,15)
			Endif
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Amarracao produto x fornecedor										Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If Empty(cCodbar) .or. Empty(cProd)
				DbSelectarea("SA5")
				DbSetorder(13)
				Dbgotop()
				Dbseek(xFilial("SA5")+cProdFor)
				While !Eof() .AND. ALLTRIM(SA5->A5_CODPRF)==ALLTRIM(cProdFor)
					IF SA5->A5_FORNECE==LS3->FORNEC .AND. SA5->A5_LOJA==LS3->LOJA
						cProd:=SA5->A5_PRODUTO

						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifico se esta bloqueado											Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						DbSelectarea("SB1")
						DbSetorder(1)
						Dbgotop()
						Dbseek(xFilial("SB1")+cProd,.t.)
						If Found() .and. SB1->B1_MSBLQL=="1"
							cProd:=''
						Endif
						If !Empty(cProd)
							If Empty(cCodbar)
								cCodbar:=POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_CODBAR")
							Endif
						Endif
					Endif
					DbSelectarea("SA5")
					Dbskip()
				End
			Endif

			_nQE:=1

			If Empty(cProd)
				cProd:="999999"
				_cDescricao:=xDesc
			Else
				_cDescricao:=POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
				_nQE:= POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_CONV")
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Unidade de medidas unitarias										Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_nQUM:= POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_UM")
			IF UPPER(cUM) $ cUnidades
				_nQE:= POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_CONV")
			Endif
			If _nQE <= 0 .OR. _nQUM == UPPER(cUM) 
				_nQE:= 1	
			EndIf
			If alltrim(cProd)<>"999999"
				DbSelectarea("LS5")
				DbSetorder(1)
				Dbgotop()
				Dbseek(cProd)
				if !Found()
					Reclock("LS5",.T.)
					LS5->PRODUTO:=cProd
					MsUnlock()
				Endif
			Endif

			IF alltrim(cProd)<>"999999"

				_nCusto:=ULTPED(cProd)
			Else
				_nCusto:=0
			Endif
			_nPreco:=((nTotal-nDescont)/(nQuant*_nQE))

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Gravando produtos do XML											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cCodFor:=''
			For w:=1 to len(alltrim(cProdFor))
				IF SUBSTR(UPPER(cProdFor),w,1) $ "A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/X/Z/W/Y/0/1/2/3/4/5/6/7/8/9"
					_cCodFor:=alltrim(_cCodFor)+SUBSTR(UPPER(cProdFor),w,1)
				Endif
			Next
			cProdFor:=_cCodFor
			Reclock("LS1",.T.)
			LS1->SEQ:=nTotIt
			LS1->CODBAR:=cCodbar
			LS1->PRODUTO:=cProd 

			If AllTRIM(cProdAnt) == ALLTRIM(cProdFor)
				lAtuA5  := .F.	
			EndIf
			LS1->PRODFOR:=cProdFor
			LS1->DESCRICAO:=UPPER(_cDescricao)
			LS1->DESCORI:=UPPER(_cDescricao)
			LS1->QUANTIDADE:=(nQuant*_nQE)
			LS1->PRECO:=ROUND(_nPreco,2) 
			LS1->CUSTO:=_nCusto
			LS1->NCM:=IIF(LEN(ALLTRIM(cNCM))>=8,SUBSTR(cNCM,1,10),"")
			LS1->PRECOFOR:=(nTotal/(nQuant*_nQE))
			LS1->TOTAL:=(nTotal-nDescont)
			LS1->CFOP:= XCFOP
			IF alltrim(cProd)=="999999"
				LS1->OK:="X"
			Else
				IF 100-((_nPreco/_nCusto)*100)>10 .OR. 100-((_nPreco/_nCusto)*100)<-10
					LS1->OK:="O"
				Endif
				IF XCFOP == "5902"
					LS1->OK:="D"
				Endif
			Endif
			LS1->EMISSAO:=cEmissao
			LS1->ALTERADO:="N"
			LS1->DESCONTO:=nDescont
			LS1->UM:=UPPER(cUM)
			LS1->NOTA:=LS3->NOTA
			LS1->NOME:=LS3->NOME
			LS1->QE:=_nQE
			LS1->CAIXAS:=nQuant
			MsUnlock()
			cProdAnt:= LS1->PRODFOR
			nTotIt:=nTotIt+1
			nTotalNF:=nTotalNF+(nTotal-nDescont)
		Next
	Else
		Msgbox("Problema ao abrir o arquivo!","AtenГЦo...","ALERT")
	Endif

	If nTotalNF==0
		Msgbox("Problema ao abrir o arquivo!","AtenГЦo...","ALERT")
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Fornecedor															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("SA2")
	DbSetorder(1)
	Dbgotop()
	Dbseek(xFilial("SA2")+LS3->FORNEC+LS3->LOJA)
	If Found()
		_cFornecedor:=SUBSTR(SA2->A2_NREDUZ,1,25)
		_cEnd:=ALLTRIM(SA2->A2_END)+" - "+SA2->A2_BAIRRO
		_cCidade:=ALLTRIM(SA2->A2_MUN)+"/"+SA2->A2_EST
		_cEmissao:=dtoc(stod(LS1->EMISSAO))
		_cCNPJ:=SA2->A2_CGC
		_cTelefone:=SA2->A2_TEL
	Endif

	If len(alltrim(cNota))<=5
		cNota:=strzero(val(cNota),6)
	Endif
	If cZeros
		cNota:=strzero(val(cNota),9)
	Endif

	DbSelectarea("LS3")
	DbSelectarea("LS1")
	Dbsetorder(1)
	Dbgotop()
	OBRWI:obrowse:refresh()
	OBRWP:obrowse:refresh()
	OBRWI:obrowse:setfocus()
	OBRWP:obrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return

/*/{Protheus.doc} ABREPED
//TODO DescriГЦo: Abre o pedido de compra selecionado na tela.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function ABREPED()
	DbSelectarea("SC7")
	SET FILTER TO C7_FILIAL==xFilial("SC7") .AND. C7_NUM==LS2->PEDIDO
	MATA121()
	SET FILTER TO
Return

/*/{Protheus.doc} RECUSAR
//TODO DescriГЦo: Envia o email de recusa e arquiva XML em pasta especМfica de recusa.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function RECUSAR()

	cResp:=msgbox("Deseja recusar o recebimento da nota fiscal "+cNota+" ?","AtenГЦo...","YESNO")

	If cResp

		_cSenha:=Space(06)

		@ 0,0 TO 100,235 DIALOG oSenha TITLE "Informe a Senha para acesso..."
		@ 10,10 SAY "Senha "  FONT oFont1 OF oSenha PIXEL
		@ 10,40 Get _cSenha Picture "@!" Size 20,20  Valid .T.  PASSWORD
		@ 30,40 BUTTON "Confirma" SIZE 35,12 ACTION Close(oSenha)
		ACTIVATE DIALOG oSenha CENTER

		If Empty(_cSenha)
			Return
		Endif

		If ALLTRIM(_cSenha)<>SUBSTR(DTOC(M->DDATABASE),1,2)+SUBSTR(DTOC(M->DDATABASE),4,2)+SUBSTR(DTOC(M->DDATABASE),7,2)
			Msgbox("Senha invАlida!")
			Return
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Se foi cadastrado os email de recusa 								Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !Empty(xEMAILREC)
			cResp:=msgbox("Deseja enviar um email para ficar documentado esta recusa?","AtenГЦo...","YESNO")

			If cResp
				EMAIL()
			Endif
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Dados do fornecedor													Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("SA2")
		DbSetorder(1)
		Dbgotop()
		Dbseek(xFilial("SA2")+LS3->FORNEC+LS3->LOJA)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Nomeclatura dos arquivos											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_cFileOri:="\xml\"+ALLTRIM(LS3->XML)
		_cFileNew:="\xml\"+ALLTRIM(SA2->A2_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.rec"

		FRename(_cFileOri,_cFileNew)
		__CopyFile("\xml\*.rec","\xml\recusadas\")
		ferase(_cFileNew)

		Msgbox("Nota Fiscal recusada com sucesso!","AtenГЦo...","INFO")

		Reclock("LS3",.F.)
		dbdelete()
		MsUnlock()

		DbSelectarea("LS3")
		Dbgotop()

		DbSelectarea("LS1")
		Dbsetorder(1)
		Dbgotop()
		While !Eof()
			Reclock("LS1",.F.)
			dbdelete()
			MsUnlock()
			Dbskip()
		End

		DbSelectarea("LS5")
		Dbsetorder(1)
		Dbgotop()
		While !Eof()
			Reclock("LS5",.F.)
			dbdelete()
			MsUnlock()
			Dbskip()
		End
		PROCESS()
	Endif
Return

/*/{Protheus.doc} DIVERG
//TODO DescriГЦo: auto-gerada.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function DIVERG()

	aCampos4:= {{"FLAG","C",1,0 },;
	{"OK","C",15,0 },;
	{"PRODUTO","C",15,0 },;
	{"DESCRICAO","C",50,0 },;
	{"PRCPED","N",18,7 },;
	{"PRCNFE","N",18,7 },;
	{"QTDPED","N",12,5 },;
	{"QTDNFE","N",12,5 }}

	cArqTrab4  := CriaTrab(aCampos4)
	dbUseArea( .T.,, cArqTrab4, "LS4", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS4",cArqTrab4,"DESCRICAO",,,)
	dbSetIndex( cArqTrab4 +OrdBagExt())
	dbSelectArea("LS4")
	_nMaior:=0

	Dbselectarea("PRO")
	DbSetorder(1)
	Dbgotop()  

	While !Eof()
		cQuery:=" SELECT COUNT(*) QTD,AVG(C7_MOEDA) MOEDA,AVG(C7_TXMOEDA) AS C7_TXMOEDA,AVG(C7_PRECO) PRECO,SUM(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
		If lItem==.F.
			cQuery:=cQuery + " AND C7_NUM='"+LS2->PEDIDO+"' "
		Else
			cQuery:=cQuery + " AND C7_NUM='"+PRO->PEDIDO+"' "
			cQuery:=cQuery + " AND C7_ITEM='"+PRO->ITEM+"' "
		Endif
		cQuery:=cQuery + " AND C7_PRODUTO='"+PRO->PRODUTO+"' "
		If lItem
		Endif
		cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")

		While !Eof()
			If TCQ->QTD==0
				Reclock("LS4",.T.)
				LS4->PRODUTO:=PRO->PRODUTO
				LS4->DESCRICAO:=PRO->DESCRICAO
				LS4->PRCNFE:=round(PRO->PRECO,7)
				LS4->OK:="Nao Existe"
				MsUnlock()
				DbSelectarea("TCQ")
				Dbskip()
				Loop
			Endif

			If (TCQ->QUANT<PRO->QUANTIDADE .AND. TCQ->QUANT>0)
				Reclock("LS4",.T.)
				LS4->PRODUTO:=PRO->PRODUTO
				LS4->DESCRICAO:=PRO->DESCRICAO
				LS4->QTDPED:=TCQ->QUANT
				LS4->QTDNFE:=PRO->QUANTIDADE
				If TCQ->MOEDA > 1
					LS4->PRCPED:= TCQ->PRECO * TCQ->C7_TXMOEDA// (RecMoeda(CTOD(_cEmissao),TCQ->MOEDA)) 
				Else
					LS4->PRCPED:=round(TCQ->PRECO,7)
				EndIf
				LS4->PRCNFE:=round(PRO->PRECO,7)
				LS4->OK:="Quantidade"
				MsUnlock()
				If TCQ->MOEDA > 1
					If (round(PRO->PRECO,7)>round(TCQ->PRECO * TCQ->C7_TXMOEDA,7)) .AND. round(TCQ->PRECO * TCQ->C7_TXMOEDA,7)>0

						_nMaior:=_nMaior+(PRO->QUANTIDADE*(round(PRO->PRECO,7)-round(TCQ->PRECO * TCQ->C7_TXMOEDA,7)))
					Endif
				Else
					If (round(PRO->PRECO,7)>round(TCQ->PRECO,7)) .AND. round(TCQ->PRECO,7)>0
						_nMaior:=_nMaior+(PRO->QUANTIDADE*(round(PRO->PRECO,7)-round(TCQ->PRECO,7)))
					Endif
				EndIf
				DbSelectarea("TCQ")
				DbSkip()

			Endif
			If (round(PRO->PRECO,7)>round(TCQ->PRECO,7)) .AND. round(TCQ->PRECO,7)>0 .AND. TCQ->QUANT>0
				Reclock("LS4",.T.)
				LS4->PRODUTO:=PRO->PRODUTO
				LS4->DESCRICAO:=PRO->DESCRICAO 
				If TCQ->MOEDA > 1
					LS4->PRCPED:= TCQ->PRECO * TCQ->C7_TXMOEDA//(RecMoeda(CTOD(_cEmissao),TCQ->MOEDA)) 
				Else
					LS4->PRCPED:=round(TCQ->PRECO,7)
				EndIf


				LS4->PRCNFE:=round(PRO->PRECO,7)
				LS4->QTDPED:=TCQ->QUANT
				LS4->QTDNFE:=PRO->QUANTIDADE
				LS4->OK:="Preco"
				MsUnlock()
				If TCQ->MOEDA > 1
					_nMaior:=_nMaior+(PRO->QUANTIDADE*(round(PRO->PRECO,7)-round(TCQ->PRECO * TCQ->C7_TXMOEDA,7)))	
				Else
					_nMaior:=_nMaior+(PRO->QUANTIDADE*(round(PRO->PRECO,7)-round(TCQ->PRECO,7)))
				EndIf
				DbSelectarea("TCQ")
				DbSkip()
				Loop
			Endif

			Reclock("LS4",.T.)
			LS4->PRODUTO:=PRO->PRODUTO
			LS4->DESCRICAO:=PRO->DESCRICAO

			If TCQ->MOEDA > 1
				LS4->PRCPED:= TCQ->PRECO * TCQ->C7_TXMOEDA//(RecMoeda(CTOD(_cEmissao),TCQ->MOEDA)) 
			Else
				LS4->PRCPED:=round(TCQ->PRECO,7)
			EndIf

			LS4->PRCNFE:=round(PRO->PRECO,7)
			LS4->QTDPED:=TCQ->QUANT
			LS4->QTDNFE:=PRO->QUANTIDADE
			If TCQ->QUANT>=PRO->QUANTIDADE
				LS4->FLAG:="X"
				LS4->OK:="Produto OK!"
			Else
				LS4->OK:="Sem saldo!"
			Endif
			MsUnlock()
			DbSelectarea("TCQ")
			Dbskip()
		End
		DbClosearea("TCQ")
		Dbselectarea("PRO")
		Dbskip()
	End

	DbSelectarea("LS4")
	Dbgotop()

	aTitulo4 := {}
	AADD(aTitulo4,{"OK","DivergЙncia"})
	AADD(aTitulo4,{"PRODUTO","Produto"})
	AADD(aTitulo4,{"DESCRICAO","DescriГЦo"})
	AADD(aTitulo4,{"PRCPED","R$ Pedido","@E 999,999,999.999999"})
	AADD(aTitulo4,{"PRCNFE","R$ Nota","@E 999,999.9999999"})
	AADD(aTitulo4,{"QTDPED","Qtd.Pedido","@E 999,999.99999"})
	AADD(aTitulo4,{"QTDNFE","Qtd.Nota","@E 999,999.99999"})

	If !LS4->(eof())
		@ 120,040 TO 400,880 DIALOG oAmar TITLE "DivergЙncias encontradas..."
		@ 005,005 BUTTON "Sair" SIZE 55,10 ACTION oAmar:end()
		If _nMaior>0
			@ 005,100 say "Valor Total Excedido R$ "+Transform(_nMaior,"@E 999,999.9999999") FONT oFont1 OF oAmar PIXEL COLOR CLR_HRED
		Endif
		@ 020,005 TO 140,417 BROWSE "LS4" ENABLE " LS4->FLAG<>'X' " OBJECT OBRWA FIELDS aTitulo4
		ACTIVATE DIALOG oAmar CENTER
	Else
		Msgbox("NЦo foram encontradas nenhuma divergЙncia!","AtenГЦo...","ALERT")
	Endif
	Dbselectarea("LS4")
	dbCloseArea("LS4")
	fErase( cArqTrab4+ ".DBF" )
	fErase( cArqTrab4+ OrdBagExt() )
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё 										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/{Protheus.doc} EMAIL
//TODO DescriГЦo: Envia email de nota recusada.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type function
/*/
Static Function EMAIL()

Local cSubject   := "Nota fiscal "+cNota+" recusado o recebimento..."
Local cMsg       := ""
Local cAttach    := ""
Local aMsg       := {}
Local aUsrMail   := {}
Local lConectou  := .f.
Local lConectou2 := .f.
Local cSERVER 	 := AllTrim(GETMV("MV_RELSERV"))
local cACCOUNT 	 := AllTrim(GETMV("MV_CMEMAS"))
local cPASSWORD	 := AllTrim(GetMV("MV_CMEMPS"))
Local lAuth		 := GetMv("MV_RELAUTH",,.F.)


	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
	ConOut('Conectando com o Servidor SMTP')

	If lAuth		// Autenticacao da conta de e-mail
		lResult := MailAuth(cAccount, cPASSWORD)
		If !lResult
			ConOut("Nao foi possivel autenticar a conta - " + cAccount)
			Return()
		EndIf
	EndIf


	cMensagem := "Nota fiscal "+cNota+" recusado o recebimento devido algumas divergЙncias encontradas pelo comprador"+ CRLF
	cMensagem := cMensagem+ " Fornecedor:"+_cFornecedor +"               CNPJ:"+_cCNPJ+ CRLF
	cMensagem := cMensagem+ " Data EmissЦo:"+_cEmissao+ CRLF
	cMensagem := cMensagem+ " Total da Nota Fiscal R$  "+alltrim(STR(nTotalNF,12,2))+ CRLF
	cMensagem := cMensagem+ CRLF
	cMensagem := cMensagem+ CRLF
	cMensagem := cMensagem+ "Caso tenha alguma dЗvida, entrar em contato com o comprador "+_cUsuario+ CRLF
	cMensagem := cMensagem+ CRLF
	cMensagem := cMensagem+ CRLF
	cMensagem := cMensagem+ "NOTA FISCAL DO "+SM0->M0_FILIAL+CRLF
	cMensagem := cMensagem+ CRLF
	cMensagem := cMensagem+ "EMAIL AUTOMаTICO ENVIADO PELO SISTEMA,FAVOR NцO RESPONDй-LO"

	SEND MAIL FROM cACCOUNT TO xEMAILREC SUBJECT cSubject BODY cMensagem RESULT lEnviado

	If !lEnviado
		cMensagem := ""
		GET MAIL ERROR cMensagem
		Alert(cMensagem)
	Endif
	DISCONNECT SMTP SERVER Result lDesConectou
Return

/*/{Protheus.doc} SELECIONA
//TODO DescriГЦo: Seleciona produto.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@param _cProduto, , descricao: Indicar o cСdigo do produto para gerar a prИ-nota
@param lOpcao, logical, descricao: VariАvel lСgica que determina se serА alterado ou incluМdo um produto
@type function
/*/
Static Function SELECIONA(_cProduto,lOpcao)

Local w := 0

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifico se o produto esta bloqueado para uso						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Dbselectarea("SB1")
	DbSetorder(1)
	Dbgotop()
	Dbseek(xFilial("SB1")+_cProduto)
	If Found() .and. SB1->B1_MSBLQL=="1"
		msgbox("Produto bloqueado para uso!","AtenГЦo...","ALERT")
		return
	Endif

	_nQE:=LS1->QE
	cMemo:=''

	_nQuantPed:=0
	_nVlrPed:=0

	If cPedCom
		cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_PRECO PRECO,C7_LOJA LOJA,C7_NUM PEDIDO,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
		cQuery:=cQuery + " AND C7_PRODUTO='"+ALLTRIM(_cProduto)+"' "
		cQuery:=cQuery + " AND C7_FORNECE='"+LS3->FORNEC+"' "
		cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 "
		cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		cQuery:=cQuery + " ORDER BY R_E_C_N_O_ DESC "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		While !Eof()
			cMemo:=cMemo+DTOC(STOD(TCQ->EMISSAO))+"   "+TCQ->PEDIDO+"   "+TCQ->LOJA+"   "+ALLTRIM(STR(TCQ->QUANT,12,2))+"       "+transform(TCQ->PRECO,"@E 9999,999.9999999")+CRLF
			If _nQuantPed==0
				_nQuantPed:=TCQ->QUANT
				_nVlrPed:=TCQ->PRECO
			Endif
			Dbskip()
		End
		DbClosearea("TCQ")
	Endif

	If Empty(cMemo)
		cmemo:="NЦo existe nenhum pedido com este produto..."
	Endif


	_nCaixas:=LS1->CAIXAS
	_nQuant:=(_nQE*_nCaixas)
	_nTotal:=LS1->TOTAL
	_nPreco:=(LS1->TOTAL/(_nQE*_nCaixas))
	_nQuantNF:=LS1->QUANTIDADE
	_ncert:=LS1->CERTIF
	If _nCaixas==0
		_nQuant:=_nQuantNF
		_nPreco:=ROUND(_nTotal/_nQuant,2) //VICTOR DESSUNTE
	Else
		_nQuant:=(_nQE*_nCaixas)
		_nPreco:=ROUND(_nTotal/_nQuant,2) //VICTOR DESSUNTE
	Endif
	///////////////////////SEGUNDA UNIDADE EDUARDO MANTOAN 03/09/2014
	IF SB1->B1_CONV > 0 

		If SB1->B1_TIPCONV == "M"
			_nQE := SB1->B1_CONV / _nCaixas
		Else
			_nQE := SB1->B1_CONV * _nCaixas
		EndIF 
	Else
		_nQE := 1
	ENDIF   
	///////////////////////////////////////////////////////////////////
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Tela de parametros													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	lGravou:=.F.
	cPictx:="@!"
	cPict1:="@E 999,999."
	For w:=1 to cDecQtd
		cPict1:=alltrim(cPict1)+"9"
	Next

	cPict2:="@E 999,999."
	For w:=1 to cDecUni
		cPict2:=alltrim(cPict2)+"9"
	Next  



	@ 120,040 TO 480,370 DIALOG oDef TITLE "Produto "+_cProduto
	@ 005,005 say "Qtd.Emb."  FONT oFont1 OF oDef PIXEL
	@ 015,005 get _nQE size 40,20 Picture "@E 9999,999.99" valid CALCULA()
	@ 005,050 say "Cx.Nota"  FONT oFont1 OF oDef PIXEL						
	@ 015,050 get _nCaixas when .f. size 50,40 Picture cPict1				
	@ 005,100 say "Quantidade"  FONT oFont1 OF oDef PIXEL COLOR CLR_GREEN
	@ 015,100 get _nQuant size 50,40 when .f. Picture cPict1

	@ 025,005 say "PreГo R$"  FONT oFont1 OF oDef PIXEL COLOR CLR_GREEN
	@ 035,005 get _nPreco size 50,40 WHEN .F. Picture cPict2
	@ 025,055 say "Total R$"  FONT oFont1 OF oDef PIXEL
	@ 035,055 get _nTotal when .f. size 50,40 Picture "@E 999,999.99"
	@ 045,005 say "Certificado"  FONT oFont1 OF oDef PIXEL COLOR CLR_GREEN
	@ 055,005 get _nCert size 50,40 Picture cPictx

	@ 060,005 say "Pedidos em aberto"  FONT oFont1 OF oDef PIXEL COLOR CLR_HBLUE
	@ 070,005 say "EmissЦo    Pedido   Lj  Quantidade  PreГo Unid."  FONT oFont1 OF oDef PIXEL COLOR CLR_HRED
	@ 080,005 GET oMemo VAR cMemo MEMO SIZE 140,55 when .f. PIXEL OF oDef
	@ 145,005 BUTTON "Confirmar" SIZE 50,10 ACTION GRAVANDO(lOpcao)
	@ 145,060 BUTTON "Sair" SIZE 50,10 ACTION oDef:end()
	ACTIVATE DIALOG oDef CENTER

	If lGravou .and. lOpcao==2
		oAmarra:end()
	Endif
Return

/*/{Protheus.doc} GRAVANDO
//TODO DescriГЦo: Grava amarraГЦo produto X fornecedor.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@param lOpcao, logical, descricao: VariАvel lСgica para o tipo de gravaГЦo
@type function
/*/
Static function GRAVANDO(lOpcao)

	lDifer:=.F.
	If _nQuantPed>0
		If _nQuant<>_nQuantPed
			Msgbox("Quantidade da Nota fiscal, diferente da quantidade do ultimo pedido!")
			lDifer:=.T.
		Endif

		If _nPreco>=(_nVlrPed+0.01)
			Msgbox("PreГo unitАrio da Nota fiscal, diferente do preГo do ultimo pedido!")
			lDifer:=.T.
		Endif

		If (_nPreco)>(_nVlrPed+1)
			Msgbox("PreГo da nota fiscal, muito maior que do ultimo pedido!")
			lDifer:=.T.
		Endif
	Endif

	If lDifer
		cResp:=Msgbox("Deseja gravar o produto mesmo assim?","AtenГЦo...","YESNO")
		If cResp==.F.
			Return
		Endif
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifico se o codigo de barras existe								Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lOpcao==2
		_cProduto:=LS4->PRODUTO
	Else
		_cProduto:=LS1->PRODUTO
	Endif

	_cCodBarras:=''
	DbSelectarea("SB1")
	DbSetorder(1)
	Dbgotop()
	Dbseek(xFilial("SB1")+_cProduto)
	If Found()
		_cCodBarras:=SB1->B1_CODBAR
	Endif

	_nCusto:=ULTPED(_cProduto)
	_nPrecoA:=(LS1->TOTAL/_nQuant)

	If lOpcao==2
		DbSelectarea("LS1")
		Reclock("LS1",.F.)
		IF 100-((_nPrecoA/_nCusto)*100)>10 .OR. 100-((_nPrecoA/_nCusto)*100)<-10
			LS1->OK:="O"
			lVerC := .F.
		Else
			LS1->OK:=""
			lVerC := .T.
		Endif
		If LS1->CFOP=="5902"
			LS1->OK:="D"	
		EndIf
		LS1->PRODUTO:=_cProduto
		LS1->DESCRICAO:=LS4->DESCRICAO
		LS1->ALTERADO:="S"
		LS1->CAIXAS:=_nCaixas
		LS1->QUANTIDADE:=_nQuant
		LS1->PRECOFOR:=_nPreco
		if SB1->B1_CONV<>0
			LS1->PRECO:=_nPreco
		else
			LS1->PRECO:=(LS1->TOTAL/_nQuant)
		endif
		LS1->CUSTO:=_nCusto
		LS1->QE:=_nQE
		LS1->CERTIF:=_nCert
		MsUnlock()

		MsUnlock()

		If lVerC
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Gravando amarracao produto x fornecedor								Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If !Empty(LS1->PRODFOR)
				DbSelectarea("SA5")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SA5")+LS3->FORNEC+LS3->LOJA+LS1->PRODUTO)
				If !Found()
					Reclock("SA5",.T.)
					SA5->A5_FILIAL	:=	xFilial("SA5")
					SA5->A5_FORNECE	:=	LS3->FORNEC
					SA5->A5_LOJA	:=	LS3->LOJA
					SA5->A5_CODPRF	:=	LS1->PRODFOR
					SA5->A5_PRODUTO	:=	LS1->PRODUTO
					SA5->A5_NOMPROD	:=	SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC"),1,30)
					SA5->A5_NOMEFOR	:=	POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_NREDUZ")
					MsUnlock()
				Else
					Reclock("SA5",.F.)
					SA5->A5_CODPRF:=LS1->PRODFOR
					MsUnlock()
				Endif
			Endif
		Else
			DbSelectarea("LS5")
			Reclock("LS5",.T.)
			LS5->PRODUTO:=_cProduto
			MsUnlock()    
		Endif
	Else
		DbSelectarea("LS1")
		Reclock("LS1",.F.)
		LS1->ALTERADO:="S"
		IF 100-((_nPrecoA/_nCusto)*100)>10 .OR. 100-((_nPrecoA/_nCusto)*100)<-10
			LS1->OK:="O"
		Else
			LS1->OK:=""
		Endif
		If LS1->CFOP=="5902"
			LS1->OK:="D"	
		EndIf
		LS1->CAIXAS:=_nCaixas
		LS1->QUANTIDADE:=_nQuant
		LS1->PRECOFOR:=_nPreco
		if SB1->B1_CONV<>0
			LS1->PRECO:=_nPreco
		else
			LS1->PRECO:=(LS1->TOTAL/_nQuant)
		endif
		LS1->CUSTO:=ULTPED(LS1->PRODUTO)
		LS1->QE:=_nQE
		LS1->CERTIF:=_nCert
		MsUnlock()
	Endif

	OBRWI:obrowse:refresh()
	OBRWP:obrowse:refresh()
	ObjectMethod(oTela,"Refresh()")

	DbSelectarea("LS1")
	DbSetorder(1)
	Dbgotop()
	Dbseek(nSeek)

	lGravou:=.T.
	oDef:end()
Return

/*/{Protheus.doc} FILTRE
//TODO DescriГЦo: Filtra os produtos baseado na informaГЦo digitada pelo usuАrio.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function FILTRE()

Local w := 0
	If Len(alltrim(_cFiltrox))>2
		Dbselectarea("LS4")
		Dbgotop()
		While !Eof()
			Reclock("LS4",.F.)
			dbdelete()
			MsUnlock()
			Dbskip()
		End

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁVerifica se a pesquisa do produto foi sub-dividida			Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_cDesc1:=''
		_cDesc2:=''
		_cDesc3:=''

		For w:=1 to len(alltrim(_cFiltrox))
			If SUBSTR(ALLTRIM(_cFiltrox),w,1) $ ";/,"
				cont2:=(w-1)
				_cDesc1:=SUBSTR(_cFiltrox,1,cont2)
				w:=100
			Endif
		Next

		If !Empty(_cDesc1)
			_nInicio:=(cont2+2)
			_cString:=SUBSTR(ALLTRIM(_cFiltrox),_nInicio,50)
			If !empty(_cString)
				For w:=1 to len(alltrim(_cString))
					If SUBSTR(ALLTRIM(_cString),w,1) $ ";/,"
						cont2:=(w-1)
						_cDesc2:=SUBSTR(_cString,1,cont2)
						w:=100
					Endif
				Next

				If Empty(_cDesc2)
					_cDesc2:=alltrim(_cString)
				Endif
			Endif
		Endif

		If !Empty(_cDesc2)
			_nInicio:=(cont2+2)
			_cString2:=SUBSTR(ALLTRIM(_cString),_nInicio,50)
			If !empty(_cString2)
				For w:=1 to len(alltrim(_cString2))
					If SUBSTR(ALLTRIM(_cString2),w,1) $ ";/,"
						cont2:=(w-1)
						_cDesc3:=SUBSTR(_cString2,1,cont2)
						w:=100
					Endif
				Next

				If Empty(_cDesc3)
					_cDesc3:=alltrim(_cString2)
				Endif
			Endif
		Endif

		If Empty(_cDesc1)
			_cDescp1:="%"+alltrim(_cFiltrox)+"%"
		Else
			_cDescp1:="%"+alltrim(_cDesc1)+"%"
			_cDescp2:="%"+alltrim(_cDesc2)+"%"
			_cDescp3:="%"+alltrim(_cDesc3)+"%"
		Endif

		cQuery:=" SELECT B1_MSBLQL BLQ,B1_CODBAR CODBAR,B1_COD PRODUTO,B1_DESC DESCRICAO FROM SB1"+SM0->M0_CODIGO+"0 "
		cQuery:=cQuery + " 	WHERE B1_FILIAL='"+xFilial("SB1")+"' AND (B1_DESC LIKE '"+_cDescp1+"' OR B1_COD LIKE '"+alltrim(_cDescp1)+"') "
		IF !Empty(_cDesc2)
			cQuery:=cQuery + " AND B1_DESC LIKE '"+_cDescp2+"' "
		Endif
		IF !Empty(_cDesc3)
			cQuery:=cQuery + " AND B1_DESC LIKE '"+_cDescp3+"' "
		Endif
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		While !Eof()
			If cPedCom .OR. LS1->CFOP == "5902"
				lPedido:=TEMPED(TCQ->PRODUTO)
			Else
				lPedido:="NЦo"
			Endif
			If (lCheck1 .and. lPedido=="Sim" .or. lCheck1==.F.)

				DbSelectarea("SB1")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SB1")+TCQ->PRODUTO)

				If Empty(cAlmox)
					cAlmox:=SB1->B1_LOCPAD
				Endif

				Reclock("LS4",.T.)
				LS4->PRODUTO:=TCQ->PRODUTO
				IF "SAIU" $ TCQ->DESCRICAO
					LS4->DESCRICAO:=SUBSTR(TCQ->DESCRICAO,6,45)
				Else
					LS4->DESCRICAO:=TCQ->DESCRICAO
				Endif
				LS4->SALDO:=POSICIONE("SB2",2,xFilial("SB2")+cAlmox+TCQ->PRODUTO,"B2_QATU-B2_RESERVA-B2_QEMP")
				LS4->QE:=SB1->B1_QE
				LS4->PEDIDO:=lPedido
				LS4->BLQ:=IIF(TCQ->BLQ=="1","Bloq.","Ativo")
				MsUnlock()
			Endif
			DbSelectarea("TCQ")
			Dbskip()
		End
		DbClosearea("TCQ")

		Dbselectarea("LS4")
		Dbgotop()
	Endif
Return

/*/{Protheus.doc} CALCULA
//TODO DescriГЦo: Calcula quantidade de produtos por caixa e o valor dos produtos.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function CALCULA()

	If _nCaixas==0
		_nQuant:=_nQuantNF
		_nPreco:=ROUND(_nTotal/_nQuant,2)
	Else
		_nQuant:=(_nQE*_nCaixas)
		_nPreco:=ROUND(_nTotal/_nQuant,2)
	Endif

	IF SB1->B1_CONV<>0
		_nQuant:=_nQE
		_nPreco:=(_nTotal/_nQE)
	ENDIF
Return

/*/{Protheus.doc} TEMPED
//TODO DescriГЦo: Calcula os produtos do pedido caso seja de dois fornecedores especМficos.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return _cTem, descriГЦo: VariАvel que verifica se o produto jА existe no pedido
@param _cProduto, , descricao: Produto que serА gerado caso seja um Kit, conjunto ou acessСrio
@type Static function
/*/
Static Function TEMPED(_cProduto)

   
	XXCNPJ:=ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_CGC"))  
	If XXCNPJ=='57582793000111' .AND. SubStr(cNumEmp,1,2) <> "15" 
		xxdesc:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC")
		xxtipo:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_UM")
		/*If SUBSTR(xxdesc,1,3)=="KIT" .AND. (xxtipo=="CJ" .OR. xxtipo=="AC")   
			Reclock("LS3",.F.)
			LS3->FORNEC:='002045' 
			MsUnlock()
		Else*/
			Reclock("LS3",.F.)
			LS3->FORNEC:='000157' 
			MsUnlock()	
		//EndIf
	EndIf 
	

	cQuery:=" SELECT COUNT(*) QTD FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
	cQuery:=cQuery + " AND C7_PRODUTO='"+alltrim(TCQ->PRODUTO)+"' "
	cQuery:=cQuery + " AND C7_FORNECE='"+LS3->FORNEC+"' "
	cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 "
	cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
	cQuery:=cQuery + " AND D_E_L_E_T_<>'*' " 
	TCQUERY cQuery NEW ALIAS "PED"
	DbSelectarea("PED")
	lPedido:=PED->QTD
	DbClosearea("PED")

	If lPedido>0
		_cTem:="Sim"
	Else
		_cTem:="NЦo"
	Endif
Return(_cTem)

/*/{Protheus.doc} REFAZER
//TODO DescriГЦo: Processa a nota Fiscal.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function REFAZER()

	cResp:=msgbox("Deseja refazer toda a nota fiscal?","AtenГЦo...","YESNO")

	If cResp
		PROCESS()
	Endif

Return

/*/{Protheus.doc} POPEMAIL
//TODO DescriГЦo: Recebendo email automaticamente. Alterado de POP3 para IMAP
@author Victor Dessunte
@since 05/03/2016
@version 1.0
@return NIL
@type Static function
/*/
Static Function POPEMAIL()

Local _nErro		:= 0
Local _nTotMsg		:= 0
Local _nX			:= 0
Local _nI			:= 0
Local _sErro		:= ""
Local _oMailManager := Nil
Local _oMailMessage := Nil

    _oMailManager := TMailManager():New()
	_oMailManager:SetUseSSL(.T.)

    _nErro := _oMailManager:Init("pop.gmail.com","",xConta,xSenha,995)
	
    If _nErro != 0
        _sErro := _oMailManager:GetErrorString(_nErro)
		ALERT(_sErro)
    Endif

    _nErro := _oMailManager:POPConnect()
    If _nErro != 0
		_sErro := _oMailManager:GetErrorString(_nErro)
		Alert(_sErro)
	EndIf

    _oMailManager:GetNumMsgs(@_nTotMsg)

    If _nTotMsg > 0
		MsgBox("Existem " + AllTrim(STR(_nTotMsg)) + " novas mensagens...","AtenГЦo...","INFO")
	EndIf

	For _nI := 1 To _nTotMsg
		
		_oMessage := tMailMessage():new()
		_oMessage:Clear()
		_nErro := _oMessage:Receive(_oMailManager,_nI)

        If _nErro <> 0
			Alert("NЦo foi possМvel receber os e-mails")
		Else
			For _nX:=1 To _oMessage:GetAttachCount()
				If UPPER(SUBSTRING(_oMessage:GetAttachInfo(_nX)[1],RAT('.',_oMessage:GetAttachInfo(_nX)[1])+1,LEN(_oMessage:GetAttachInfo(_nX)[1]))) == "XML"
					_oMessage:SaveAttach(_nX,GetSrvProfString( "RootPath", "" )+'\xml\'+_oMessage:GetAttachInfo(_nX)[1])
				EndIf
			Next _nX
			_oMailManager:DeleteMsg(_nI)
		EndIf

    Next _nI

    _nErro := _oMailManager:POPDisconnect()

    /*
	_oMailManager := TMailManager():New()
	_nErro := _oMailManager:Init("email-ssl.com.br","",xConta,xSenha,143)
	If _nErro != 0
		_sErro := _oMailManager:GetErrorString(_nErro)
		ALERT(_sErro)
	EndIf

	_nErro := _oMailManager:IMAPConnect()
	If _nErro != 0
		_sErro := _oMailManager:GetErrorString(_nErro)
		Alert(_sErro)
	EndIf

	_oMailManager:GetNumMsgs(@_nTotMsg)

	If _nTotMsg > 0
		MsgBox("Existem " + AllTrim(STR(_nTotMsg)) + " novas mensagens...","AtenГЦo...","INFO")
	EndIf

	For _nI := 1 To _nTotMsg
		_oMessage := tMailMessage():new()
		_oMessage:Clear()
		_nErro := _oMessage:Receive(_oMailManager,_nI)
		If _nErro <> 0
			Alert("NЦo foi possМvel receber os e-mails")
		Else
			For _nX:=1 To _oMessage:GetAttachCount()
				If UPPER(SUBSTRING(_oMessage:GetAttachInfo(_nX)[1],RAT('.',_oMessage:GetAttachInfo(_nX)[1])+1,LEN(_oMessage:GetAttachInfo(_nX)[1]))) == "XML"
					_oMessage:SaveAttach(_nX,GetSrvProfString( "RootPath", "" )+'\xml\'+_oMessage:GetAttachInfo(_nX)[1])
				EndIf
			Next _nX
			_oMailManager:DeleteMsg(_nI)
		EndIf
	Next

	_oMailManager:IMAPDisconnect()

    */

Return


/*/{Protheus.doc} EXCAMA
//TODO DescriГЦo: Exclui a amarraГЦo do produto X fornecedor (SA5).
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function EXCAMA()

	If Empty(LS1->OK) .OR. LS1->OK=="O" .OR. LS1->OK=="D"
		cResp:=msgbox("Deseja excluir a amarraГЦo do produto?","AtenГЦo...","YESNO")

		If cResp

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Excluindo da tabela de produtos identificados						Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("LS5")
			DbSetorder(1)
			Dbgotop()
			Dbseek(LS1->PRODUTO)
			If Found()
				Reclock("LS5",.F.)
				dbdelete()
				MsUnlock()
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Excluindo da tabela amarracao produto x fornecedor					Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("SA5")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA5")+LS3->FORNEC+LS3->LOJA+LS1->PRODUTO)
			If Found() .AND. lAtuA5
				Reclock("SA5",.F.)
				dbdelete()
				MsUnlock()
			Endif

			Reclock("LS1",.F.)
			LS1->DESCRICAO:=LS1->DESCORI
			LS1->PRODUTO:="999999"
			LS1->OK:="X"
			MsUnlock()
		Endif
	Else
		Msgbox("NЦo existe amarraГЦo para este produto!")
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ultimo preco de pedido												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/{Protheus.doc} ULTPED
//TODO DescriГЦo: Verifica o preГo pelo Зltimo pedido de compra e caso nЦo encontre utiliza o preГo do cadastro do produto.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return _nPedido, PreГo do Зltimo pedido ou do produto
@param _cProduto, , descricao: Produto a ser verifica
@type Static function
/*/
Static Function ULTPED(_cProduto)
	_nPedido:=0
	_nQtd:=1

	cQuery:=" SELECT C7_PRECO PRECO FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' AND C7_PRODUTO='"+alltrim(_cProduto)+"' AND C7_FORNECE='"+LS3->FORNEC+"' AND C7_PRECO>0 AND (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND  D_E_L_E_T_<>'*' ORDER BY C7_EMISSAO DESC "
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectarea("TCQ")
	While !Eof() .and. _nQtd==1
		_nPedido:=TCQ->PRECO
		_nQtd:=2
		Dbskip()
	End
	Dbclosearea("TCQ")

	If _nPedido<=0
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Caso nao encontre, ultimo preco de entrada							Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_nPedido:=POSICIONE("SB1",1,xFilial("SB1")+_cProduto,"B1_UPRC")
	Endif
Return(_nPedido)

/*/{Protheus.doc} MSGNF
//TODO DescriГЦo: Mensagem nota fiscal.
@author ivandro.santos
@since 16/05/2018
@version 1.0
@return NIL
@param _cMensag, , descricao: busca a mensagem da nota do XML para gravar no documento de entrada
@type function
/*/
Static Function MSGNF(_cMensag)

	If !Empty(_cMensag)
		DEFINE MSDIALOG oMensNF FROM 0,0 TO 290,415 PIXEL TITLE "Mensagem da Nota Fiscal"
		@ 005,005 GET oMemo VAR _cMensag MEMO SIZE 200,135 FONT oFont2 PIXEL OF oMensNF
		ACTIVATE MSDIALOG oMensNF CENTER
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao Legenda														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function LEGENDA()
	_cLegenda := "Legenda dos produtos"

	aCorLegen := { 	{ 'BR_VERDE'   ,"Produto OK!" },;
	{ 'BR_VERMELHO',"Sem identificaГЦo" },; 
	{ 'BR_PINK',"Retorno - CFOP 5902" },;
	{ 'BR_AZUL',"PreГo diferente em 10%" }}
	BrwLegenda(_cLegenda,"Status do Produto",aCorLegen)
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao Consulta SEFAZ												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function SEFAZ()    

	_cBackup:=LS3->CHAVE
	_cChave:=IIF(!EMPTY(LS3->CHAVE),LS3->CHAVE,Space(44))

	@ 070,070 TO 160,400 dialog oChave title "Chave Eletronica..."
	@ 005,010 SAY "Chave EletrТnica"
	@ 015,010 Get _cChave Picture "@!" SIZE 150,20
	@ 030,010 BUTTON "Confirma" SIZE 40,10 ACTION oChave:end()
	Activate Dialog oChave CENTERED
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza informacoes arquivo de configuracao						Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ATUCFG()

	_lAlmox:=LS1->ALMOX
	_lSerie:=LS1->SERIE
	_lEmail:=LS1->EMAIL
	_lPedido:=LS1->PEDIDO
	_lEspecie:=LS1->ESPECIE
	_lDecQtd:=LS1->DECQTD
	_lDecUni:=LS1->DECUNI

	DEFINE MSDIALOG oAtuCfg TITLE "Informe os parametros..." From 9,0 To 30,50 OF oMainWnd
	@002,004 TO 140,195
	@005,006 Say "Almox.p/ saldos            (Branco-Local PadrЦo)" FONT oFont6 PIXEL COLOR CLR_HBLUE
	@005,060 Get _lAlmox SIZE 20,10 Picture "@!"
	@025,006 Say "Almox.p/ Pedidos           (Branco-Local PadrЦo) " FONT oFont6 PIXEL COLOR CLR_HBLUE
	@025,060 Get _lPedido SIZE 20,10 Picture "@!"
	@045,006 Say "SИria da Nota              (Branco-SИrie Fornec.) " FONT oFont6 PIXEL COLOR CLR_HBLUE
	@045,060 Get _lSerie SIZE 20,10 Picture "@!"
	@065,006 Say "Emails  " FONT oFont6 PIXEL COLOR CLR_HBLUE
	@065,060 Get _lEmail SIZE 125,10 Picture "@"
	@085,006 Say "EspИcie NF " FONT oFont6 PIXEL COLOR CLR_HBLUE
	@085,060 Get _lEspecie SIZE 125,10 Picture "@"
	@105,006 Say "Decimais Quantidade " FONT oFont6 PIXEL COLOR CLR_HBLUE
	@105,070 Get _lDecQtd SIZE 30,10 Picture "99"
	@125,006 Say "Decimais PreГo Unit." FONT oFont6 PIXEL COLOR CLR_HBLUE
	@125,070 Get _lDecUni SIZE 30,10 Picture "99"
	@145,006 BUTTON "Gravar" SIZE 40,10 ACTION 	oAtuCfg:end()
	ACTIVATE MSDIALOG oAtuCfg CENTERED

	If Empty(_lDecQtd) .or. _lDecQtd==0
		_lDecQtd:=2
	Endif
	If Empty(_lDecUni) .or. _lDecUni==0
		_lDecUni:=7
	Endif

	Reclock("LS1",.F.)
	LS1->ALMOX:=_lAlmox
	LS1->SERIE:=_lSerie
	LS1->EMAIL:=_lEmail
	LS1->PEDIDO:=_lPedido
	LS1->ESPECIE:=_lEspecie
	LS1->DECQTD:=_lDecQtd
	LS1->DECUNI:=_lDecUni
	MsUnlock()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Geracao NDF fornecedor												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function NDF()
	RecLock("SE2",.T.)
	SE2->E2_FILIAL  := xFilial("SE2")
	SE2->E2_PREFIXO := "XML"
	SE2->E2_NUM     := cNota
	SE2->E2_PARCELA := ""
	SE2->E2_TIPO	 := "NDF"
	SE2->E2_EMISSAO := ddatabase
	SE2->E2_VENCREA := ddatabase+30
	SE2->E2_VENCTO  := ddatabase+30
	SE2->E2_VENCORI := ddatabase+30
	SE2->E2_MOEDA   := 1
	SE2->E2_EMIS1   := dDataBase
	SE2->E2_FORNECE := LS3->FORNEC
	SE2->E2_LOJA    := LS3->LOJA
	SE2->E2_VALOR   := _nExcedido
	SE2->E2_SALDO   := _nExcedido
	SE2->E2_VLCRUZ  := _nExcedido
	If lItem==.F.
		SE2->E2_NOMFOR  := POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS2->LOJA,"A2_NREDUZ")
	Else
		SE2->E2_NOMFOR  := POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_NREDUZ")
	Endif
	SE2->E2_ORIGEM  := "XMLFOR"
	MsUnlock()
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valor NDF do fornecedor												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function VALORNDF()

	_nExcedido:=0
	Dbselectarea("LS1")
	DbSetorder(1)
	Dbgotop()
	While !Eof()
		cQuery:=" SELECT COUNT(*) QTD,AVG(C7_PRECO) PRECO,SUM(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
		If lItem==.F.
			cQuery:=cQuery + " AND C7_NUM='"+LS2->PEDIDO+"' "
		Else
			cQuery:=cQuery + " AND C7_NUM='"+LS1->PEDIDO+"' "
			cQuery:=cQuery + " AND C7_ITEM='"+LS1->ITEM+"' "
		Endif
		cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
		cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		While !Eof()
			If (round(LS1->PRECO,7)>TCQ->PRECO) .AND. Round(TCQ->PRECO,7)>0
				_nExcedido:=_nExcedido+(LS1->QUANTIDADE*(round(LS1->PRECO,7)-Round(TCQ->PRECO,7)))
			Endif
			DbSelectarea("TCQ")
			Dbskip()
		End
		DbClosearea("TCQ")
		Dbselectarea("LS1")
		Dbskip()
	End
Return(_nExcedido)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Manipulando arquivo de configuracao									Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CONFARQ()

Local x := 0
	_lPOP:=space(100)
	_lConta:=space(100)
	_lSenha:=space(20)
	_lUM:=space(100)
	_lLogo:=space(20)
	_lPed:="NЦo"
	_lNDF:="NЦo"
	_lZeros:="NЦo"

	cResp:=msgbox("Deseja configurar os parametros da rotina?","AtenГЦo...","YESNO")

	If cResp
		cBuffer   := ""
		If File(cArqTxt)
			FT_FUSE(cArqTxt)
			FT_FGOTOP()
			ProcRegua(FT_FLASTREC())

			While !FT_FEOF()
				cBuffer := FT_FREADLN()
				If UPPER(SUBSTR(cBuffer,1,3))=="POP"
					_lPOP:=lower(ALLTRIM(SUBSTR(cBuffer,5,400)))+space(200)
				Endif
				If UPPER(SUBSTR(cBuffer,1,5))=="CONTA"
					_lConta:=lower(ALLTRIM(SUBSTR(cBuffer,7,400)))+space(200)
				Endif
				If UPPER(SUBSTR(cBuffer,1,5))=="SENHA"
					_lSenha:=lower(ALLTRIM(SUBSTR(cBuffer,7,400)))+space(200)
				Endif
				If UPPER(SUBSTR(cBuffer,1,2))=="UM"
					_lUM:=ALLTRIM(UPPER(SUBSTR(cBuffer,4,400)))+space(200)
				Endif
				If UPPER(SUBSTR(cBuffer,1,4))=="LOGO"
					_lLogo:=ALLTRIM(UPPER(SUBSTR(cBuffer,6,200)))+space(200)
				Endif
				If UPPER(SUBSTR(cBuffer,1,6))=="PEDIDO"
					_lPed:="Sim"
				Endif
				If UPPER(SUBSTR(cBuffer,1,3))=="NDF"
					_lNDF:="Sim"
				Endif
				If UPPER(SUBSTR(cBuffer,1,7))=="NFZEROS"
					_lZeros:="Sim"
				Endif
				If UPPER(SUBSTR(cBuffer,1,11))=="PEDPROD=SIM"
					lCheck2:=.T.
				Endif
				FT_FSKIP()
			EndDo
			FT_FUSE()
		Endif

		aCampos	:= {{"EMPRESA","C",2,0 },;
		{"FILIAL","C",2,0 },;
		{"NOME","C",20,0 },;
		{"ALMOX","C",2,0 },;
		{"PEDIDO","C",2,0 },;
		{"SERIE","C",3,0 },;
		{"ESPECIE","C",5,0 },;
		{"DECQTD","N",2,0 },;
		{"DECUNI","N",2,0 },;
		{"EMAIL","C",300,0 }}

		cArqTrab  := CriaTrab(aCampos)
		dbUseArea( .T.,, cArqTrab, "LS1", if(.F. .OR. .F., !.F., NIL), .F. )
		IndRegua("LS1",cArqTrab,"EMPRESA+FILIAL",,,)
		dbSetIndex( cArqTrab +OrdBagExt())
		dbSelectArea("LS1")

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Empresas/Filiais - SIGAMAT											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("SM0")
		Dbsetorder(1)
		Dbgotop()
		While !Eof()

			_lSerie:=space(03)
			_lAlmox:=space(02)
			_lEmail:=space(300)
			_lPedido:=space(02)
			_lEspecie:="NF   "
			_lDecQtd:=2
			_lDecUni:=7

			If File(cArqTxt)
				FT_FUSE(cArqTxt)
				FT_FGOTOP()
				ProcRegua(FT_FLASTREC())

				While !FT_FEOF()
					cBuffer := FT_FREADLN()
					If UPPER(SUBSTR(cBuffer,1,4))==SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
						_lSerie:=ALLTRIM(SUBSTR(cBuffer,6,3))
					Endif
					If UPPER(SUBSTR(cBuffer,1,5))=="S"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
						_lAlmox:=ALLTRIM(SUBSTR(cBuffer,7,2))
					Endif
					If UPPER(SUBSTR(cBuffer,1,9))=="EMAIL"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
						_lEmail:=ALLTRIM(SUBSTR(cBuffer,11,300))
					Endif
					If UPPER(SUBSTR(cBuffer,1,5))=="P"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
						_lPedido:=ALLTRIM(SUBSTR(cBuffer,7,2))
					Endif
					If UPPER(SUBSTR(cBuffer,1,7))=="ESP"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
						_lEspecie:=ALLTRIM(SUBSTR(cBuffer,9,5))
					Endif
					If UPPER(SUBSTR(cBuffer,1,10))=="DECQTD"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
						_lDecQtd:=val(ALLTRIM(SUBSTR(cBuffer,12,5)))
					Endif
					If UPPER(SUBSTR(cBuffer,1,10))=="DECUNI"+SM0->M0_CODIGO+Alltrim(SM0->M0_CODFIL)
						_lDecUni:=val(ALLTRIM(SUBSTR(cBuffer,12,5)))
					Endif
					FT_FSKIP()
				EndDo
				FT_FUSE()
			Endif

			Reclock("LS1",.T.)
			LS1->EMPRESA:=SM0->M0_CODIGO
			LS1->FILIAL:=Alltrim(SM0->M0_CODFIL)
			LS1->NOME:=UPPER(SM0->M0_FILIAL)
			LS1->SERIE:=_lSerie
			LS1->ESPECIE:=_lEspecie
			LS1->ALMOX:=_lAlmox
			LS1->EMAIL:=_lEmail
			LS1->PEDIDO:=_lPedido
			LS1->DECQTD:=_lDecQtd
			LS1->DECUNI:=_lDecUni
			MsUnlock()
			DbSelectarea("SM0")
			Dbskip()
		End

		aTitulo := {}
		AADD(aTitulo,{"EMPRESA","Empresa"})
		AADD(aTitulo,{"FILIAL","Filial"})
		AADD(aTitulo,{"NOME","Nome"})
		AADD(aTitulo,{"ESPECIE","EspИcie"})
		AADD(aTitulo,{"SERIE","SИrie"})
		AADD(aTitulo,{"ALMOX","Saldos"})
		AADD(aTitulo,{"PEDIDO","Pedidos"})
		AADD(aTitulo,{"EMAIL","Emails para notas fiscais - Recusadas ( ; para separar )"})

		DbSelectarea("LS1")
		Dbgotop()

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Opcoes COMBOBOX														Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		aPedidos:={}
		AADD(aPedidos,"Sim")
		AADD(aPedidos,"NЦo")

		aNDF:={}
		AADD(aNDF,"Sim")
		AADD(aNDF,"NЦo")

		aZeros:={}
		AADD(aZeros,"Sim")
		AADD(aZeros,"NЦo")

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Apagando arquivo anterior										z	Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Ferase(cArqTxt)

		DEFINE MSDIALOG oConfig FROM 0,0 TO 505,400 PIXEL TITLE "ConfiguraГЦo do arquivo CFGXML.TXT"
		@ 005,005 say "Servidor POP do recebimento do XML" SIZE 150,40 FONT oFont6 OF oConfig PIXEL
		@ 015,005 get _lPOP size 190,20
		@ 030,005 say "Email para recebimento do XML" SIZE 70,40 FONT oFont6 OF oConfig PIXEL
		@ 040,005 get _lConta size 90,20
		@ 030,135 say "NDF Fornecedor?" SIZE 150,40 FONT oFont6 OF oConfig PIXEL COLOR CLR_HRED
		@ 040,135 COMBOBOX _lNDF ITEMS aNDF SIZE 30,20
		@ 055,005 say "Senha do Email" SIZE 150,40 FONT oFont6 OF oConfig PIXEL
		@ 065,005 get _lSenha size 60,20 valid .t. PASSWORD
		@ 055,070 say "Logo (BMP)" SIZE 150,40 FONT oFont6 OF oConfig PIXEL
		@ 065,070 get _lLogo size 40,20 picture "@!"
		@ 055,135 say "Ped.Compras?" SIZE 150,40 FONT oFont6 OF oConfig PIXEL COLOR CLR_HRED
		@ 065,135 COMBOBOX _lPed ITEMS aPedidos SIZE 60,20
		@ 080,005 say "UM-UnitАrias - Ex.: UN/PC/LT" SIZE 150,40 FONT oFont6 OF oConfig PIXEL
		@ 090,005 get _lUM size 100,20 picture "@!"
		@ 080,135 say "Nota (9 Digitos)?" SIZE 150,40 FONT oFont6 OF oConfig PIXEL COLOR CLR_HRED
		@ 090,135 COMBOBOX _lZeros ITEMS aZeros SIZE 60,20
		@ 105,135 CHECKBOX "Pedido por Produto?" VAR lCheck2
		@ 115,005 say "Empresas/Filiais" SIZE 150,40 FONT oFont5 OF oConfig PIXEL COLOR CLR_HBLUE
		@ 125,005 TO 235,195 BROWSE "LS1" OBJECT OBRWP FIELDS aTitulo
		OBRWP:OBROWSE:bLDblClick   := {||ATUCFG()}
		OBRWP:oBrowse:oFont := TFont():New ("Courier New", 06, 16)
		@ 240,005 BUTTON "Salvar" SIZE 60,10 ACTION oConfig:end()
		ACTIVATE MSDIALOG oConfig CENTER

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Criando novo arquivo												Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cr:=CRLF
		_nDiv    := 0
		_cDados     :={}

		AADD( _cDados,"POP="+alltrim(_lPOP))
		AADD( _cDados,"CONTA="+alltrim(_lConta))
		AADD( _cDados,"SENHA="+alltrim(_lSenha))
		AADD( _cDados,"UM="+alltrim(_lUM))
		AADD( _cDados,"LOGO="+alltrim(_lLogo))
		If lCheck2
			AADD( _cDados,"PEDPROD=SIM")
		Endif

		DbSelectarea("LS1")
		Dbgotop()
		While !Eof()
			IF !Empty(LS1->SERIE)
				AADD( _cDados,LS1->EMPRESA+LS1->FILIAL+"="+LS1->SERIE)
			Endif
			If !Empty(LS1->ALMOX)
				AADD(_cDados,"S"+LS1->EMPRESA+LS1->FILIAL+"="+LS1->ALMOX)
			Endif
			If !Empty(LS1->EMAIL)
				AADD(_cDados,"EMAIL"+LS1->EMPRESA+LS1->FILIAL+"="+LS1->EMAIL)
			Endif
			If !Empty(LS1->PEDIDO)
				AADD(_cDados,"P"+LS1->EMPRESA+LS1->FILIAL+"="+LS1->PEDIDO)
			Endif
			If Empty(LS1->ESPECIE)
				AADD(_cDados,"ESP"+LS1->EMPRESA+LS1->FILIAL+"=NF")
			Else
				AADD(_cDados,"ESP"+LS1->EMPRESA+LS1->FILIAL+"="+LS1->ESPECIE)
			Endif
			If !Empty(LS1->DECUNI)
				AADD(_cDados,"DECUNI"+LS1->EMPRESA+LS1->FILIAL+"="+ALLTRIM(STR(LS1->DECUNI)))
			Else
				AADD(_cDados,"DECUNI"+LS1->EMPRESA+LS1->FILIAL+"=2")
			Endif
			If !Empty(LS1->DECQTD)
				AADD(_cDados,"DECQTD"+LS1->EMPRESA+LS1->FILIAL+"="+ALLTRIM(STR(LS1->DECQTD)))
			Else
				AADD(_cDados,"DECUNI"+LS1->EMPRESA+LS1->FILIAL+"=2")
			Endif
			Dbskip()
		End

		If alltrim(_lPed)=="Sim"
			AADD( _cDados,"PEDIDO=SIM")
		Endif
		If alltrim(_lNDF)=="Sim"
			AADD( _cDados,"NDF=SIM")
		Endif
		If alltrim(_lZeros)=="Sim"
			AADD( _cDados,"NFZEROS=SIM")
		Endif

		hnda:=Fcreate(cArqTxt,0)
		for x := 1 TO len( _cDados )
			dados := _cDados[x]
			Fwrite(hnda,dados+cr)
		next
		Fclose(hnda)
		FClose(cArqTxt)

		Msgbox("ConfiguraГУes salvas com sucesso!","AtenГЦo...","INFO")

		Dbselectarea("LS1")
		dbCloseArea("LS1")
		fErase( cArqTrab+ ".DBF" )
		fErase( cArqTrab+ OrdBagExt() )
	Endif
Return
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza pedido conforme o XML														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды    

Static Function APCXML()


	DbSelectarea("LS1")
	Dbgotop()

	If !Empty(LS1->PEDIDO) .and. ALLTRIM(LS1->PEDIDO)<>"CRIAR"
		Msgbox("Favor eliminar o pedido primeiro!","AtenГЦo...","ALERT")
		OBRWI:obrowse:refresh()
		OBRWI:obrowse:setfocus()
		ObjectMethod(oTela,"Refresh()")
		Return
	Endif

	aCampos2	:= {{"OK","C",1,0 },;
	{"EMISSAO","D",8,0 },;
	{"PEDIDO","C",6,0 },;
	{"ITEM","C",4,0 },;
	{"QUANTIDADE","N",18,6 },;
	{"PRECO","N",18,5 },;
	{"ENTREGA","D",8,0 }}

	cArqTrab2  := CriaTrab(aCampos2)
	cIndice:="Descend(DTOS(EMISSAO))"
	dbUseArea( .T.,, cArqTrab2, "LS2", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS2",cArqTrab2,cIndice,,,)
	dbSetIndex( cArqTrab2 +OrdBagExt())
	dbSelectArea("LS2")

	lAchou:=.f.
	_nQuantXml:=LS1->QUANTIDADE

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando pedidos em aberto										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


	cSeq:=LS1->SEQ
	cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_PRECO PRECO,C7_ITEM ITEM,C7_NUM PEDIDO,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANTIDADE,C7_DATPRF ENTREGA FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
	cQuery:=cQuery + " AND C7_PRODUTO='GENERICO01' "
	cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
	cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
	cQuery:=cQuery + " AND C7_ENCER <>'E' "
	cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
	cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "


	XXCNPJ:=ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_CGC"))  
  	IF XXCNPJ=='57582793000111'.AND. SubStr(cNumEmp,1,2) <> "15" 
		xxdesc:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC")
		xxtipo:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_UM")
		/*
		IF SUBSTR(xxdesc,1,3)=="KIT" .AND. (xxtipo=="CJ" .OR. xxtipo=="AC")   

			Reclock("LS3",.F.)

			LS3->FORNEC:='002045'

			MsUnlock() 
			cSeq:=LS1->SEQ
			cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_PRECO PRECO,C7_ITEM ITEM,C7_NUM PEDIDO,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANTIDADE,C7_DATPRF ENTREGA FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_FORNECE='002045' "
			cQuery:=cQuery + " AND C7_LOJA='"+LS3->LOJA+"' "
			cQuery:=cQuery + " AND C7_PRODUTO='GENERICO01' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_ENCER <>'E' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "

		ELSE 
		*/
			Reclock("LS3",.F.)
			LS3->FORNEC:='000157' 
			MsUnlock()
			cSeq:=LS1->SEQ
			cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_PRECO PRECO,C7_PRODUTO  PRODUTO,C7_ITEM ITEM,C7_NUM PEDIDO,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANTIDADE,C7_DATPRF ENTREGA FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_FORNECE='000157' "
			cQuery:=cQuery + " AND C7_LOJA='"+LS3->LOJA+"' "
			cQuery:=cQuery + " AND C7_PRODUTO='GENERICO01' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_ENCER <>'E' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
		//ENDIF
	ENDIF
	
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectarea("TCQ")
	cAtuPed := .F. 


	If Select("TCQ") > 0

	Else
		Alert("Pedido nЦo possui as especificaГЦo para esta operaГЦo")
		Return	
	EndIf
	cResp2:=msgbox("Deseja cadastrar os produtos conforme o XML e  alterar o PC?","AtenГЦo...","YESNO")
	If !cResp2
		Return
	EndIf

	DbSelectarea("LS1")

	Dbgotop()
	aItem1 := {}
	aItem  := {}
	aProds := {} 
	cMSG 	 := ""
	While !Eof()    

		IF LS1->PEDIDO $ "      " 
			vprodxml := "XM"+SUBSTR(LS3->FORNEC,3,4)+PADL(RIGHT(alltrim(LS1->PRODFOR),9),9,"0")
			cProdFor := Posicione("SB1",1,xFilial("SB1")+vprodxml,"B1_COD")
			If Empty(Alltrim(cProdFor))
				_aPerIPI := GetAdvFVal("SYD",{"YD_PER_IPI","YD_ICMS_RE","YD_BICMS"},xFilial("SYD")+LS1->NCM,1,{0,0," "})
				If SubStr(cNumEmp,1,2) $ "01" 
					Begin Transaction
					Reclock("SB1",.T.)
					SB1->B1_COD		:=  vprodxml
					SB1->B1_DESC	:=	IIF(LS1->DESCORI <> "          ",LS1->DESCORI,vprodxml)
					SB1->B1_TIPO	:=	"MC"
					SB1->B1_UM		:=	IIF(LS1->UM=="MI","MH",LS1->UM)	
					SB1->B1_CC		:=	"101"
					SB1->B1_LOCPAD	:=	"10"
					SB1->B1_FILIAL	:=	xFilial("SB1")
					SB1->B1_PROCED	:=	"2N"
					SB1->B1_ORIGEM	:=	"0" 
					SB1->B1_POSIPI	:=	LS1->NCM
					SB1->B1_IPI		:= _aPerIPI[1]
					SB1->B1_PICM	:= _aPerIPI[2]
					If _aPerIPI[3] == "S"
						If _aPerIPI[2] < 18
							SB1->B1_GRTRIB := "001"
						Else
							SB1->B1_GRTRIB := "002"
						EndIf					
					EndIf
					SB1->B1_MSCONF	:=	"N"                                  
					SB1->B1_GARANT	:=	"2"
					SB1->B1_MSGRVEN	:=	"IN" 
					Msunlock()
					End Transaction
				Else
					Begin Transaction
					Reclock("SB1",.T.)
					SB1->B1_COD		:=  vprodxml
					SB1->B1_DESC	:=	IIF(LS1->DESCORI <> "          ",LS1->DESCORI,vprodxml)
					SB1->B1_TIPO	:=	"MC"
					SB1->B1_UM		:=	IIF(LS1->UM=="MI","MH",LS1->UM)
					SB1->B1_CC		:=	"101"
					SB1->B1_LOCPAD	:=	"01"
					SB1->B1_FILIAL	:=	xFilial("SB1")
					SB1->B1_PROCED	:=	"2N"
					SB1->B1_ORIGEM	:=	"0"
					SB1->B1_POSIPI	:=	LS1->NCM
					SB1->B1_IPI		:= _aPerIPI[1]
					SB1->B1_PICM	:= _aPerIPI[2]
					If _aPerIPI[3] == "S"
						If _aPerIPI[2] < 18
							SB1->B1_GRTRIB := "001"
						Else
							SB1->B1_GRTRIB := "002"
						EndIf					
					EndIf
					SB1->B1_GARANT	:=	"2"
					SB1->B1_MSGRVEN	:=	"IN" 
					Msunlock()
					End Transaction
				EndIf
				aadd(aProds,vprodxml)
				cMSG += "Produto Criado "+vprodxml+CRLF	
			Else
				aadd(aProds,vprodxml)
				cMSG += "Produto "+vprodxml+CRLF
			EndIf 


		EndIf                                                                           
		DbSelectarea("LS1")
		Dbskip()
	EndDo      

	MsgInfo("Produtos:"+CRLF+cMSG)

	DbSelectarea("TCQ")
	While !Eof()
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verificando saldos de produtos em uso								Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_nUsados:=0

		DbSelectarea("LS1")
		Dbgotop()
		While !Eof()
			IF alltrim(LS1->PEDIDO)==TCQ->PEDIDO .AND. alltrim(LS1->ITEM)==TCQ->ITEM
				_nUsados:=(_nUsados+LS1->QUANTIDADE)
			Endif
			DbSelectarea("LS1")
			Dbskip()
		End

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gravando pedidos em aberto											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If (TCQ->QUANTIDADE-_nUsados)>0
			Reclock("LS2",.T.)
			IF (TCQ->QUANTIDADE-_nUsados)>=_nQuantXml
				LS2->OK:="X"
			Endif
			LS2->EMISSAO:=STOD(TCQ->EMISSAO)
			LS2->PEDIDO:=TCQ->PEDIDO
			LS2->ITEM:=TCQ->ITEM
			LS2->PRECO:=TCQ->PRECO
			LS2->QUANTIDADE:=(TCQ->QUANTIDADE-_nUsados)
			LS2->ENTREGA:=STOD(TCQ->ENTREGA)
			Msunlock()
			lAchou:=.T.
		Endif
		DbSelectarea("TCQ")
		Dbskip()
	End
	DbClosearea("TCQ")

	DbSelectarea("LS1")
	Dbgotop()
	DbSeek(cSeq)

	Dbselectarea("LS2")
	Dbgotop()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё aHeader dos pedidos													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	aTitulo2 := {}
	AADD(aTitulo2,{"EMISSAO","EmissЦo"})
	AADD(aTitulo2,{"PEDIDO","Pedido"})
	AADD(aTitulo2,{"ITEM","Item"})
	AADD(aTitulo2,{"QUANTIDADE","DisponМvel","@E 999,999.999"})
	AADD(aTitulo2,{"PRECO","PreГo R$","@E 999,999.99"})
	AADD(aTitulo2,{"ENTREGA","Dt.Entrega"})

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Tela dos itens														Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	If lAchou
		@ 120,040 TO 440,550 DIALOG oPedido TITLE "Pedidos em aberto para o produto..."
		@ 005,005 say "Quantidade NecessАria "+Transform(LS1->QUANTIDADE,"@E 999,999.99999")+"      PreГo R$ "+Transform(LS1->PRECO,"@E 99999,999.9999999") FONT oFont1 OF oPedido PIXEL COLOR CLR_HRED
		@ 015,005 TO 140,255 BROWSE "LS2" ENABLE " LS2->OK<>'X' " OBJECT OBRWT FIELDS aTitulo2
		OBRWT:oBrowse:oFont := TFont():New ("Arial", 05, 18)
		OBRWT:OBROWSE:bLDblClick   := {||CONFPED2()}
		ACTIVATE DIALOG oPedido CENTER
	Else
		Msgbox("NЦo existem pedidos em aberto para este produto!","AtenГЦo...","ALERT")
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gravando CRIAR nos produtos sem pedidos de compras em aberto		Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		SEMPED()
	Endif

	Dbselectarea("LS2")
	dbCloseArea("LS2")
	fErase( cArqTrab2+ ".DBF" )
	fErase( cArqTrab2+ OrdBagExt() )

	OBRWI:obrowse:refresh()
	OBRWI:obrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Confirma Pedido 																		Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CONFPED2()

Local nx := 0
	LS1->(dbgotop())
	DbSelectarea("SC7")
	DbSetorder(1)
	dbgotop()
	Dbseek(xFilial("SC7")+LS2->PEDIDO)
	nItem := VAL(SC7->C7_ITEM)
	cCond :=SC7->C7_COND
	cLoja :=SC7->C7_LOJA
	nY:=1
	lP := .F.       
	For nX := 1 to Len(aProds) 

		If ALLTRIM(SC7->C7_NUM)==ALLTRIM(LS2->PEDIDO) .AND. !lP

			If SC7->C7_PRODUTO <> 'GERAL0000003' .AND. SUBSTR(SC7->C7_PRODUTO,1,2) <> "XM"             

				cPRODUTO:=Posicione("SB1",1,xFilial("SB1")+aProds[nY],"B1_COD")
				cUM:=Posicione("SB1",1,xFilial("SB1")+aProds[nY],"B1_UM")
				cDESCRI:=ALLTRIM(Posicione("SB1",1,xFilial("SB1")+aProds[nY],"B1_DESC"))     
				DBSELECTAREA("SC7")
				Reclock("SC7",.F.)
				SC7->C7_FILIAL:=xFilial("SC7")
				SC7->C7_PRODUTO:=cPRODUTO
				SC7->C7_UM:=cUM
				SC7->C7_DESCRI:=ALLTRIM(cDESCRI)
				SC7->C7_QUANT:=LS1->CAIXAS
				SC7->C7_PRECO:=(LS1->TOTAL/LS1->CAIXAS)
				SC7->C7_TOTAL:=LS1->TOTAL
				SC7->C7_DATPRF:=dDataBase
				SC7->C7_IPIBRUT:="B"
				SC7->C7_FLUXO:="S"
				SC7->C7_USER:=__CUSERID
				SC7->C7_TPOP:="F"
				SC7->C7_CONAPRO:="L"
				SC7->C7_MOEDA:=1
				SC7->C7_TPFRETE:="C"
				SC7->C7_OBS+="INCLUIDO NF-ELETRONICA"
				SC7->C7_PENDEN:="N"
				SC7->C7_POLREPR:="N"
				SC7->C7_LOCAL := "01"
				SC7->(MsUnlock())
				nY++
				DBSELECTAREA("LS1")
				LS1->(DBSKIP())
			Else
				nX--
			EndIf
			DBSELECTAREA("SC7")
			nItem := VAL(SC7->C7_ITEM)
			nItem++

			SC7->(DBSKIP())
		Else 
			cCONTATO:=Posicione("SA2",1,xFilial("SA2")+LS3->FORNEC+cLoja,"A2_CONTATO")
			cPRODUTO:=Posicione("SB1",1,xFilial("SB1")+aProds[nY],"B1_COD")
			cUM:=Posicione("SB1",1,xFilial("SB1")+aProds[nY],"B1_UM") 
			cDESCRI:=Posicione("SB1",1,xFilial("SB1")+aProds[nY],"B1_DESC")
			cItem         := STRZERO(nItem,4)
			DBSELECTAREA("SC7")  

			Reclock("SC7",.T.)
			SC7->C7_FILIAL:=xFilial("SC7")
			SC7->C7_TIPO:=1
			SC7->C7_NUM:=LS2->PEDIDO
			SC7->C7_EMISSAO:=Date()
			SC7->C7_FORNECE:=LS3->FORNEC
			SC7->C7_LOJA:=cLoja
			SC7->C7_CONTATO:=cCONTATO
			SC7->C7_COND:=cCond                      
			SC7->C7_FILENT:=xFilial("SC7")

			SC7->C7_ITEM  := ALLTRIM(cItem)
			SC7->C7_PRODUTO:=cPRODUTO
			SC7->C7_UM:=cUM
			SC7->C7_DESCRI:=cDESCRI
			SC7->C7_QUANT:=LS1->CAIXAS
			SC7->C7_PRECO:=(LS1->TOTAL/LS1->CAIXAS)
			SC7->C7_TOTAL:=LS1->TOTAL
			SC7->C7_DATPRF:=Date()
			//SC7->C7_TES:=SB1->B1_TE
			SC7->C7_IPIBRUT:="B"
			SC7->C7_FLUXO:="S"
			SC7->C7_USER:="XML"
			SC7->C7_TPOP:="F"
			SC7->C7_CONAPRO:="L"
			SC7->C7_MOEDA:=1
			SC7->C7_TPFRETE:="C"
			SC7->C7_OBS:="INCLUIDO NF-ELETRONICA"
			SC7->C7_PENDEN:="N"
			SC7->C7_POLREPR:="N"
			SC7->C7_LOCAL := "01"
			SC7->(MsUnlock())	
			nItem++
			nY++
			DBSELECTAREA("LS1")
			LS1->(DBSKIP())
			lP := .T.
		EndIf
	Next nX

	LS1->(DBGOTOP())

	Reclock("LS1",.F.)
	LS1->PEDIDO:=LS2->PEDIDO
	LS1->ITEM:=LS2->ITEM
	LS1->ALTERADO:="S"
	MsUnlock()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Gravando o mesmo pedido para os outros itens						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cSeqori:=LS1->SEQ

	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		cSeq:=LS1->SEQ
		If Empty(LS1->PEDIDO)
			cQuery:=" SELECT C7_ITEM ITEM,C7_MOEDA,C7_TXMOEDA,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_NUM='"+LS2->PEDIDO+"' "
			cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
			TCQUERY cQuery NEW ALIAS "TCQ"
			DbSelectarea("TCQ")
			While !Eof()

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verificando saldos de produtos em uso								Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_nUsados:=0
				DbSelectarea("LS1")
				Dbgotop()
				While !Eof()
					IF alltrim(LS1->PEDIDO)==ALLTRIM(LS2->PEDIDO) .AND. alltrim(LS1->ITEM)==TCQ->ITEM
						_nUsados:=(_nUsados+LS1->QUANTIDADE)
					Endif
					DbSelectarea("LS1")
					Dbskip()
				End

				DbSelectarea("LS1")
				Dbgotop()
				DbSeek(cSeq)                                                      
				If TCQ->C7_MOEDA > 1

				Else
					If (LS1->QUANTIDADE<=(TCQ->QUANT-_nUsados))
						Reclock("LS1",.F.)
						LS1->PEDIDO:=LS2->PEDIDO
						LS1->ITEM:=TCQ->ITEM
						LS1->ALTERADO:="S"
						MsUnlock()
					Endif
				EndIf
				DbSelectarea("TCQ")
				Dbskip()
			End
			DbClosearea("TCQ")
		Endif
		DbSelectarea("LS1")
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Gravando CRIAR nos produtos sem pedidos de compras em aberto		Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS1")
	Dbgotop()
	DbSeek(cSeqOri)
	SEMPED()
	oPedido:end()
Return

/*/{Protheus.doc} DESBLOQ
//TODO DescriГЦo: FunГЦo responsАvel pelo desbloqueio de produto.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function DESBLOQ()

	If UPPER(ALLTRIM(LS4->BLQ))=="ATIVO"
		Msgbox("O Produto jА estА ativo!","AtenГЦo...","ALERT")
		Return
	Endif

	cResp:=msgbox("Deseja DESBLOQUEAR o produto novamente?","AtenГЦo...","YESNO")

	If cResp
		DbSelectarea("LS4")
		Reclock("LS4",.F.)
		LS4->BLQ:="Ativo"
		MsUnlock()

		Dbselectarea("SB1")
		DbSetorder(1)
		Dbgotop()
		Dbseek(xFilial("SB1")+LS4->PRODUTO)
		If Found()
			Reclock("SB1",.F.)
			SB1->B1_MSBLQL:="2"
			IF "SAIU" $ ALLTRIM(SB1->B1_DESC)
				SB1->B1_DESC:=SUBSTR(SB1->B1_DESC,6,45)
			Endif
			MsUnlock()
		End
		msgbox("O Produto foi reativado com sucesso!","AtenГЦo...","INFO")
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Procura pedido por item												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function PROCPED()

	If ALLTRIM(LS1->PRODUTO)=="999999"
		Msgbox("Favor identificar o produto primeiro!","AtenГЦo...","ALERT")
		OBRWI:obrowse:refresh()
		OBRWI:obrowse:setfocus()
		ObjectMethod(oTela,"Refresh()")
		Return
	Endif

	If !Empty(LS1->PEDIDO) .and. ALLTRIM(LS1->PEDIDO)<>"CRIAR"
		Msgbox("Favor eliminar o pedido primeiro!","AtenГЦo...","ALERT")
		OBRWI:obrowse:refresh()
		OBRWI:obrowse:setfocus()
		ObjectMethod(oTela,"Refresh()")
		Return
	Endif

	aCampos2	:= {{"OK","C",1,0 },;
	{"EMISSAO","D",8,0 },;
	{"PEDIDO","C",6,0 },;
	{"ITEM","C",4,0 },;
	{"QUANTIDADE","N",18,6 },;
	{"PRECO","N",18,5 },;
	{"ENTREGA","D",8,0 }}

	cArqTrab2  := CriaTrab(aCampos2)
	cIndice:="Descend(DTOS(EMISSAO))"
	dbUseArea( .T.,, cArqTrab2, "LS2", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS2",cArqTrab2,cIndice,,,)
	dbSetIndex( cArqTrab2 +OrdBagExt())
	dbSelectArea("LS2")

	lAchou:=.f.
	_nQuantXml:=LS1->QUANTIDADE

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando pedidos em aberto										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


	cSeq:=LS1->SEQ
	cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_PRECO PRECO,C7_ITEM ITEM,C7_MOEDA,C7_TXMOEDA,C7_NUM PEDIDO,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANTIDADE,C7_DATPRF ENTREGA FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
	cQuery:=cQuery + " AND C7_FORNECE='"+LS3->FORNEC+"' "
	cQuery:=cQuery + " AND C7_LOJA='"+LS3->LOJA+"' "
	cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
	cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
	cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
	cQuery:=cQuery + " AND C7_ENCER <>'E' "
	cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
	cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "


	XXCNPJ:=ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+LS3->FORNEC+LS3->LOJA,"A2_CGC"))  
  	IF XXCNPJ=='57582793000111'.AND. SubStr(cNumEmp,1,2) <> "15" 
		xxdesc:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC")
		xxtipo:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_UM")
		/*
		IF SUBSTR(xxdesc,1,3)=="KIT" .AND. (xxtipo=="CJ" .OR. xxtipo=="AC")   

			Reclock("LS3",.F.)

			LS3->FORNEC:='002045'

			MsUnlock() 
			cSeq:=LS1->SEQ
			cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_PRECO PRECO,C7_ITEM ITEM,C7_MOEDA,C7_TXMOEDA,C7_NUM PEDIDO,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANTIDADE,C7_DATPRF ENTREGA FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_FORNECE='002045' "
			cQuery:=cQuery + " AND C7_LOJA='"+LS3->LOJA+"' "
			cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_ENCER <>'E' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "

		ELSE */
			Reclock("LS3",.F.)
			LS3->FORNEC:='000157' 
			MsUnlock()
			cSeq:=LS1->SEQ
			cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_PRECO PRECO,C7_PRODUTO  PRODUTO,C7_TXMOEDA,C7_ITEM ITEM,C7_MOEDA,C7_NUM PEDIDO,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANTIDADE,C7_DATPRF ENTREGA FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_FORNECE='000157' "
			cQuery:=cQuery + " AND C7_LOJA='"+LS3->LOJA+"' "
			cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_ENCER <>'E' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
		//ENDIF
	ENDIF
	
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectarea("TCQ")
	cAtuPed := .F.
	lMoeda := .F.
	While TCQ->(!Eof())
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verificando saldos de produtos em uso								Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_nUsados:=0

		DbSelectarea("LS1")
		LS1->(Dbgotop())
		While !Eof()
			IF alltrim(LS1->PEDIDO)==TCQ->PEDIDO .AND. alltrim(LS1->ITEM)==TCQ->ITEM
				_nUsados:=(_nUsados+LS1->QUANTIDADE)
			Endif
			DbSelectarea("LS1")
			LS1->(Dbskip())
		End

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gravando pedidos em aberto											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If (TCQ->QUANTIDADE-_nUsados)>0
			Reclock("LS2",.T.)
			IF (TCQ->QUANTIDADE-_nUsados)>=_nQuantXml
				LS2->OK:="X"
			Endif  

			If TCQ->C7_MOEDA > 1

				nMoeda := TCQ->C7_MOEDA 
				nValor := TCQ->PRECO
				dEmis  := CTOD(_cEmissao)
				nVlrReal := 0
				LS2->PRECO:= TCQ->PRECO * TCQ->C7_TXMOEDA
				nTMoeda := TCQ->C7_TXMOEDA
				lMoeda := .T.
			Else

				LS2->PRECO := TCQ->PRECO

			EndIf
			LS2->EMISSAO:=STOD(TCQ->EMISSAO)
			LS2->PEDIDO:=TCQ->PEDIDO
			LS2->ITEM:=TCQ->ITEM
			LS2->QUANTIDADE:=(TCQ->QUANTIDADE-_nUsados)
			LS2->ENTREGA:=STOD(TCQ->ENTREGA)
			Msunlock()
			lAchou:=.T.
		Endif
		DbSelectarea("TCQ")
		Dbskip()
	End

	Dbselectarea("TCQ")
	DbClosearea("TCQ")
	DbSelectarea("LS1")
	Dbgotop()
	DbSeek(cSeq)

	Dbselectarea("LS2")
	Dbgotop()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё aHeader dos pedidos													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aTitulo2 := {}
	AADD(aTitulo2,{"EMISSAO","EmissЦo"})
	AADD(aTitulo2,{"PEDIDO","Pedido"})
	AADD(aTitulo2,{"ITEM","Item"})
	AADD(aTitulo2,{"QUANTIDADE","DisponМvel","@E 999,999.99999"})
	AADD(aTitulo2,{"PRECO","PreГo R$","@E 999,999.999999999"})
	AADD(aTitulo2,{"ENTREGA","Dt.Entrega"})

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Tela dos itens														Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lAchou
		@ 120,040 TO 440,550 DIALOG oPedido TITLE "Pedidos em aberto para o produto..."
		@ 005,005 say "Quantidade NecessАria "+Transform(LS1->QUANTIDADE,"@E 999,999.9999999")+"      PreГo R$ "+Transform(LS1->PRECO,"@E 999,999.9999999") FONT oFont1 OF oPedido PIXEL COLOR CLR_HRED
		@ 015,005 TO 140,255 BROWSE "LS2" ENABLE " LS2->OK<>'X' " OBJECT OBRWT FIELDS aTitulo2
		OBRWT:oBrowse:oFont := TFont():New ("Arial", 05, 18)
		OBRWT:OBROWSE:bLDblClick   := {||CONFPED()}
		ACTIVATE DIALOG oPedido CENTER
	Else
		Msgbox("NЦo existem pedidos em aberto para este produto!","AtenГЦo...","ALERT")
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gravando CRIAR nos produtos sem pedidos de compras em aberto		Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		SEMPED()
	Endif
	Dbselectarea("LS2")
	dbCloseArea("LS2")

	fErase( cArqTrab2+ ".DBF" )
	fErase( cArqTrab2+ OrdBagExt() )

	OBRWI:obrowse:refresh()
	OBRWI:obrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Confirma Pedido 													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддд²²ддддддддддды
Static Function CONFPED()
	If ALLTRIM(LS1->OK) == "D" 
		ALERT("и uma devoluГЦo, nЦo necessita de pedido de compras!")
		return
	EndIf
	If (LS1->QUANTIDADE > LS2->QUANTIDADE)      

		//////////Verifica pedidos que contem o item com fornecedor e quantidade iguais     
		IF Select("QR4") > 0
			DbSelectArea("QR4")
			DbCloseArea()
		ENDIF
		cQuery10 := " SELECT C7_NUM,C7_PRODUTO,C7_QUANT,C7_QUJE,C7_FORCECEDOR  "
		cQuery10 += " FROM " + RetSqlName("SC7") + " SC7  "
		cQuery10 += " WHERE C7_FILIAL='"+xFilial("SC7")+"' "
		cQuery10 += " AND C7_PRODUTO = '"+ALLTRIM(LS1->PRODUTO)+"'  "
		cQuery10 += " AND C7_FORNECE = '"+LS3->FORNEC+"'  "
		cQuery10 += " AND (C7_QUANT - C7_QUJE) = "+STR(LS1->QUANTIDADE)+"  "
		cQuery10 += " AND SC7.D_E_L_E_T_E_=''   "         

		TcQuery cQuery New Alias "QR4" 

		dbSelectArea("QR4")
		dbGoTop()

		If !QR4->(EOF())  
			Msgbox("Verifique a AmarraГЦo!","AtenГЦo...","ALERT") 

			lVerPCS := .T.
		Else 
			Msgbox("NЦo existe saldo suficiente para atender este produto!","AtenГЦo...","ALERT")
			Msgbox("O sistema irА permitir a entrada, porИm a quantidade real entregue ficarА somente como histСrico!","AtenГЦo...","ALERT")
		EndIf
	Endif
	Reclock("LS1",.F.)
	LS1->CUSTO:=LS2->PRECO	
	MsUnlock()
	If lMoeda
		Alert("Pedido nЦo estА em Real(R$), serА feita a conversЦo")    
		DBSELECTAREA("SC7")
		DBSETORDER(1)               
		DBSEEK(xFilial("SC7")+LS2->PEDIDO+LS2->ITEM)
		nTaxa2 := Round(LS1->PRECO/SC7->C7_PRECO,5) 
		If Round(LS1->PRECO,0) > Round(SC7->C7_PRECO*nTaxa2,0) + 10 .OR. Round(LS1->PRECO,0) < Round(SC7->C7_PRECO*nTaxa2,0) - 10  //preГo da nota И diferente do preГo do pedido(em reais)?
			ALERT("PreГo unitАrio do pedido de compras estА diferente da nota! solicite para o setor de compras acertar o pedido ou verifique se И necessАrio a recusa da nota fiscal.")	 
		EndIf
		Reclock("SC7",.F.) 
		SC7->C7_TXMOEDA := nTaxa2  
		MsUnlock()

		Reclock("LS1",.F.)
		LS1->CUSTO := Round(SC7->C7_PRECO*nTaxa2,5)     
		MsUnlock()


	EndIf  
	Reclock("LS1",.F.) 

	If (!(100-((LS1->PRECO/LS1->CUSTO)*100)>3) .AND. !(100-((LS1->PRECO/LS1->CUSTO)*100)<-3)) .AND. LS2->QUANTIDADE >= LS1->QUANTIDADE 
		LS1->OK :=""
	Else
		LS1->OK :="O"	                                           
	EndIf 

	LS1->PEDIDO:=LS2->PEDIDO
	LS1->ITEM:=LS2->ITEM
	LS1->ALTERADO:="S"
	MsUnlock()


	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Gravando o mesmo pedido para os outros itens						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cSeqori:=LS1->SEQ

	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		cSeq:=LS1->SEQ
		IF Empty(LS1->PEDIDO) .AND. ALLTRIM(LS1->OK) <> "D" 

			cQuery:=" SELECT C7_ITEM ITEM,C7_MOEDA,C7_TXMOEDA,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_NUM='"+LS2->PEDIDO+"' "
			cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
			TCQUERY cQuery NEW ALIAS "TCQ"
			DbSelectarea("TCQ")
			While !Eof()

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verificando saldos de produtos em uso								Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_nUsados:=0
				DbSelectarea("LS1")
				Dbgotop()
				While !Eof()
					IF alltrim(LS1->PEDIDO)==ALLTRIM(LS2->PEDIDO) .AND. alltrim(LS1->ITEM)==TCQ->ITEM
						_nUsados:=(_nUsados+LS1->QUANTIDADE)
					Endif
					DbSelectarea("LS1")
					Dbskip()
				End

				DbSelectarea("LS1")
				Dbgotop()
				DbSeek(cSeq)
				If TCQ->C7_MOEDA > 1

				Else

					IF (LS1->QUANTIDADE<=(TCQ->QUANT-_nUsados))
						Reclock("LS1",.F.)
						LS1->PEDIDO:=LS2->PEDIDO
						LS1->ITEM:=TCQ->ITEM
						LS1->ALTERADO:="S"
						MsUnlock()
					Endif
				EndIf
				DbSelectarea("TCQ")
				Dbskip()
			End
			DbClosearea("TCQ")
		Endif
		DbSelectarea("LS1")
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Gravando CRIAR nos produtos sem pedidos de compras em aberto		Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS1")
	Dbgotop()
	DbSeek(cSeqOri)
	If ALLTRIM(LS1->OK) <> "D" 
		SEMPED() 
	EndIf
	oPedido:end()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Eliminar pedido														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ELIMPED()

	Reclock("LS1",.F.)
	LS1->PEDIDO:=""
	LS1->ITEM:=""
	LS1->ALTERADO:=""
	MsUnlock()

	OBRWI:obrowse:refresh()
	OBRWI:obrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Eliminar Todos														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ELIMPEDT()

	cResp:=Msgbox("Deseja limpar todas as referЙncias de pedidos dos produtos da nota fiscal?","AtenГЦo...","YESNO")

	If cResp
		DbSelectarea("LS1")
		Dbgotop()
		While !Eof()
			IF !Empty(LS1->PEDIDO)
				Reclock("LS1",.F.)
				LS1->PEDIDO:=""
				LS1->ITEM:=""
				LS1->ALTERADO:=""
				MsUnlock()
			Endif
			Dbskip()
		End
		DbSelectarea("LS1")
		Dbgotop()
	Endif

	OBRWI:obrowse:refresh()
	OBRWI:obrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return

/*/{Protheus.doc} SEMPED
//TODO DescriГЦo: Verificando produto sem pedido de compras da nota.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function SEMPED()

	cSeqori:=LS1->SEQ

	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		cSeq:=LS1->SEQ

		IF Empty(LS1->PEDIDO) .AND. ALLTRIM(LS1->PRODUTO)<>"999999"
			lEntrou:=.F.
			cQuery:=" SELECT C7_NUM PEDIDO,C7_ITEM ITEM,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
			cQuery:=cQuery + " AND C7_FORNECE='"+LS3->FORNEC+"' "
			cQuery:=cQuery + " AND C7_LOJA='"+LS3->LOJA+"' "
			cQuery:=cQuery + " AND C7_PRODUTO='"+LS1->PRODUTO+"' "
			cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
			cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
			cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
			cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
			TCQUERY cQuery NEW ALIAS "TCQ"
			DbSelectarea("TCQ")
			While !Eof() .and. lEntrou==.F.
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verificando saldos de produtos em uso								Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_nUsados:=0
				DbSelectarea("LS1")
				Dbgotop()
				While !Eof()
					IF alltrim(LS1->PEDIDO)==ALLTRIM(TCQ->PEDIDO) .AND. alltrim(LS1->ITEM)==TCQ->ITEM
						_nUsados:=(_nUsados+LS1->QUANTIDADE)
					Endif
					DbSelectarea("LS1")
					Dbskip()
				End

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Se o saldo do pedido atende ao produto da nota fiscal				Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectarea("LS1")
				Dbgotop()
				DbSeek(cSeq)

				IF (LS1->QUANTIDADE<=(TCQ->QUANT-_nUsados)) .OR. (TCQ->QUANT-_nUsados)>0
					lEntrou:=.T.
				Endif
				DbSelectarea("TCQ")
				Dbskip()
			End
			DbClosearea("TCQ")

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Se nao encontrou nenhum pedido de compra com saldo suficiente		Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lEntrou==.F. .AND. ALLTRIM(LS1->CFOP) <> "5902"
				Reclock("LS1",.F.) 
				LS1->PEDIDO:="CRIAR"
				LS1->ALTERADO:="S"
				MsUnlock()
			Endif
		Endif
		DbSelectarea("LS1")
		Dbskip()
	End
	DbSelectarea("LS1")
	Dbgotop()
	DbSeek(cSeqori)
Return

/*/{Protheus.doc} XMLcgc
//TODO DescriГЦo: Retorna o nЗmero do CNPJ gravado no XML.
@author Horacio Laterza
@since 02/07/2010
@version 1.0
@return NIL
@type Static function
/*/
Static Function XMLcgc(i)
	private _oXml    := NIL
	private cError    := ''
	private cWarning := ''
	nXmlStatus := XMLError()
	cFile:="\xml\"+lower(ALLTRIM(aXML[i]))
	oXml := XmlParserFile(cFile,"_",@cError, @cWarning )
	lTipo:=3

	If ALLTRIM(TYPE("oxml:_NFE:_INFNFE"))=="O"
		lTipo:=1
	Endif

	If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE"))=="O"
		lTipo:=2
	Endif

	If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE"))=="U"
		Return(_cCNPJ2)
	Endif

	If Empty(@cError) .and. lTipo<>3
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Com _NFEPROC														Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_cCNPJ2:=""
		If lTipo==2
			If SUBSTR(alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
				_cCNPJ2:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
			Endif
			_cCNPJ:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
			cNota:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
			If Empty(cSerieNF)
				cSerie:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			Endif
			cNatOp:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
			xxversao:= substr(oxml:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT,1,1)
			IF XXVERSAO=="2"
				cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
			else
				cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
			ENDIF
			cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
			cChave:=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,200))
		ENDIF
	ENDIF
RETURN(_cCNPJ2) 

/*/{Protheus.doc} caddemo
//TODO DescriГЦo: FunГЦo para gerar cСdigos automАticos para produtos vindos de fornecedor para DemonstraГЦo.
@author ivandro.santos
@since 10/05/2017
@version 1.0
@return NIL
@type Static function
/*/
Static Function caddemo()   
	Local cCPD   		:= ""
	Local cCSoma 		:= ""
	LOcal aProd  		:= {}
	Local aItensProd 	:= {}
	Local _aDadoAdic	:= {}

	Private _cDepImp  := ""
	cResp2:=msgbox("Deseja cadastrar os produtos conforme o XML ?","AtenГЦo...","YESNO")
	If !cResp2
		Return
	EndIf

	DbSelectarea("LS1")	
	DBGOTOP()    
	Do While !LS1->(EOF())
		If LS1->OK == "X" 
			_aCod := GetAdvFVal("SB1",{"B1_COD","B1_DESC"},xFilial("SB1")+PADR(LS1->DESCRICAO,TamSX3("B1_DESC")[1]),3," ")
			If Alltrim(Substr(LS1->DESCRICAO,1,TamSX3("B1_DESC")[1])) == Alltrim(_aCod[2])
				Reclock("LS1",.F.)
				LS1->OK 	 := ""
				LS1->PRODUTO := _aCod[1]  
				MsUnlock()
				LS1->(DBSKIP())
				LOOP
			EndIf
			If Select("TP1") > 0 
				DbSelectArea("TP1")
				DbCloseArea()
			EndIf  

			cQuery := " SELECT B1_COD AS CODIGO "
			cQuery += " FROM " + RetSqlName("SB1") + " SB1 "
			cQuery += " WHERE SB1.D_E_L_E_T_='' "
			cQuery += " AND B1_FILIAL='" + xFilial("SB1") + "' " 
			cQuery += " AND SUBSTRING(B1_COD,1,4) IN ('PDEM')  "
			cQuery += " ORDER BY B1_COD DESC "    

			TCQUERY cQuery NEW ALIAS "TP1"
			If !TP1->(EOF())    
				TP1->(DBGOTOP())
				cCPD   := SUBSTR(TP1->CODIGO,5,11)
				cCSoma := VAL(cCPD)+1
				cCPD   :="PDEM"+ALLTRIM(STRZERO(cCSoma,11))
			Else
				cCPD   :="PDEM00000000001"	
			EndIf 
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			If SubStr(cNumEmp,1,2) $ "01_10" 
				_aPerIPI := GetAdvFVal("SYD",{"YD_PER_IPI","YD_ICMS_RE","YD_BICMS"},xFilial("SYD")+LS1->NCM,1,{0,0," "})
				/*Begin Transaction
				Reclock("SB1",.T.)
				SB1->B1_FILIAL  := xFilial("SB1")
				SB1->B1_COD  	:= cCPD 
				SB1->B1_LOCPAD 	:= "10"
				SB1->B1_DESC 	:= LS1->DESCRICAO
				SB1->B1_TIPO 	:= "OI"
				SB1->B1_UM   	:= IIF(Alltrim(LS1->UM)=="MI","MH",LS1->UM)
				SB1->B1_CC   	:= "207" 
				SB1->B1_PROCED  := "2N" 
				SB1->B1_POSIPI  := LS1->NCM 
				SB1->B1_IPI		:= _aPerIPI[1]
				SB1->B1_PICM	:= _aPerIPI[2]
				If _aPerIPI[3] == "S"
					If _aPerIPI[2] < 18
						SB1->B1_GRTRIB := "001"
					Else
						SB1->B1_GRTRIB := "002"
					EndIf					
				EndIf
				SB1->B1_MSCERT 	:= "N" 
				SB1->B1_MSCONF 	:= "N" 
				SB1->B1_GARANT  := "N" 
				SB1->B1_MSGRVEN := "IN" 
				SB1->B1_ORIGEM :=	"0"
				MsUnlock()
				End Transaction*/
				
				aadd(_aDadoAdi,"OI")  						//B1_TIPO
				aadd(_aDadoAdi,"207") 						//B1_CC
				aadd(_aDadoAdi,"2N")    					//B1_PROCED
				aadd(_aDadoAdi,"N")    						//B1_MSCONF
				aadd(_aDadoAdi,"2")   						//B1_GARANT
				aadd(_aDadoAdi,Space(TamSX3(B1_GRUPO)[1]))	//B1_GRUPO

				cprod := U_MSGERAB1(cCPD,aProd,_aPerIPI,_aDadoAdi)
				_aDadoAdi := {}
			Else
				Begin Transaction
				Reclock("SB1",.T.)
				SB1->B1_FILIAL  := xFilial("SB1")
				SB1->B1_COD  	:= cCPD 
				SB1->B1_LOCPAD 	:= "10"
				SB1->B1_DESC 	:= LS1->DESCRICAO
				SB1->B1_TIPO 	:= "OI"
				SB1->B1_UM   	:= IIF(Alltrim(LS1->UM)=="MI","MH",LS1->UM)
				SB1->B1_CC   	:= "207" 
				SB1->B1_PROCED  := "2N" 
				SB1->B1_POSIPI  := LS1->NCM 
				SB1->B1_IPI		:= _aPerIPI[1]
				SB1->B1_PICM	:= _aPerIPI[2]
				If _aPerIPI[3] == "S"
					If _aPerIPI[2] < 18
						SB1->B1_GRTRIB := "001"
					Else
						SB1->B1_GRTRIB := "002"
					EndIf					
				EndIf
				SB1->B1_MSCERT 	:= "N" 
				SB1->B1_GARANT  := "N" 
				SB1->B1_MSGRVEN := "IN"  
				SB1->B1_ORIGEM  := "0"
				MsUnlock()
				End Transaction
			EndIf
			DBSELECTAREA("LS1")

			Reclock("LS1",.F.)
			LS1->OK:=""
			LS1->PRODUTO:=cCPD 
			MsUnlock()	
		EndIf	
		LS1->(DBSKIP())
	EndDo   
	LS1->(dBGotop())
	If Select("TP1") > 0 
		DbSelectArea("TP1")
		DbCloseArea()
	EndIf

Return
