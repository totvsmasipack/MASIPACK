#INCLUDE  "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#Include "Xmlxfun.ch"
#INCLUDE "bitmap.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "shell.ch"

#IFDEF WINDOWS
#ENDIF

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁXMLCLI    ╨Autor  ЁHoracio Laterza     ╨ Data Ё   02/07/10  ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁImportacao arquivo xml nota eletronica                      ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function XMLCLI()

Local i 		:= 0
Local nXml 		:= 0

Private cXml	:= '',oXml
Private _cCNPJ	:= ''

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Fontes do windows usadas											Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

DEFINE FONT oFont1 NAME "Arial Black" SIZE 6,17
DEFINE FONT oFont2 NAME "Courier New" SIZE 8,14
DEFINE FONT oFont3 NAME "Arial Black" SIZE 13,20
DEFINE FONT oFont4 NAME "Arial Black" SIZE 13,15
DEFINE FONT oFont5 NAME "Arial Black" SIZE 7,17
DEFINE FONT oFont6 NAME "Courier New" SIZE 6,20
DEFINE FONT oFont7 NAME "Courier New" SIZE 7,20

_cUsuario:=ALLTRIM(UPPER(SUBSTR(CUSUARIO,7,15)))
_cEmpresa:=SM0->M0_CODIGO   
_CNUMEMP := _cEmpresa
_cCorrente:=SM0->M0_CODFIL
cArqTxt := "\xmlcli\config\cfgxml.txt"
lCheck2:=.F.
Private cNCM := "" 
Private cCST := ""
cDecQtd:=2
cDecUni:=7

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Criando parametro do programa										Ё
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
//Ё Manipulando arquivo de configuracao									Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If !File(cArqTxt) .OR. _cUsuario=="ADMINISTRADOR" //.OR. upper(_cUsuario)=="EDUARDO BEGO MA" // .OR. _cUsuario=="xxx" .OR. _cUsuario=="xxx"
	CONFARQ()
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Filial e empresa atual												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

DbSelectarea("SM0")
Dbsetorder(1)
Dbgotop()
Dbseek(_cEmpresa+_cCorrente)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Lendo o arquivo de configuracao										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cArqTxt := "\xmlcli\config\cfgxml.txt"
cBuffer   := ""

IF !File("\xmlcli")
	msgbox("NЦo existe o diretСrio XML no ROOTPATH")
	Return
Endif

IF !File("\xmlcli\config")
	msgbox("NЦo existe o diretСrio CONFIG no diretСrio \xmlcli")
	Return
Endif

IF _CNUMEMP=="01"
	IF !File("\xmlcli\ArquivaMasipack")
		msgbox("NЦo existe o diretСrio ArquivaMasipack no diretСrio \XMLCLI")
		Return
	Endif
ENDIF
IF _CNUMEMP=="10"
	IF !File("\xmlcli\ArquivaFabrima")
		msgbox("NЦo existe o diretСrio ArquivaFabrima no diretСrio \XMLCLI")
		Return
	Endif
ENDIF
IF _CNUMEMP=="15"
	IF !File("\xmlcli\ArquivaHelsimplast")
		msgbox("NЦo existe o diretСrio ArquivaHelsimplast no diretСrio \XMLCLI")
		Return
	Endif
ENDIF
IF _CNUMEMP=="40"
	IF !File("\xmlcli\ArquivaLabortube")
		msgbox("NЦo existe o diretСrio ArquivaLabortube no diretСrio \XMLCLI")
		Return
	Endif
ENDIF
IF _CNUMEMP=="45"
	IF !File("\xmlcli\ArquivaMemb")
		msgbox("NЦo existe o diretСrio ArquivaMemb no diretСrio \XMLCLI")
		Return
	Endif
ENDIF


IF !File("\xmlcli\importados")
	msgbox("NЦo existe o diretСrio IMPORTADOS no diretСrio \xmlcli")
	Return
Endif

IF !File("\xmlcli\duplicados")
	msgbox("NЦo existe o diretСrio DUPLICADOS no diretСrio \xmlcli")
	Return
Endif

IF !File("\xmlcli\recusadas")
	msgbox("NЦo existe o diretСrio RECUSADAS no diretСrio \xmlcli")
	Return
Endif
IF !File("\xmlcli\corrompidos")
	msgbox("NЦo existe o diretСrio CORROMPIDOS no diretСrio \xmlcli")
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
cDecQtd:=2

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Analisando configuracoes da rotina									Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If File(cArqTxt)
	FT_FUSE(cArqTxt)
	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())
	
	While !FT_FEOF()
		cBuffer := FT_FREADLN()
		
		If UPPER(SUBSTR(cBuffer,1,9))==AllTrim("EMAIL"+SM0->M0_CODIGO+SM0->M0_CODFIL)
			xEMAILREC:=lower(ALLTRIM(SUBSTR(cBuffer,11,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,3))=="POP"
			xPOP:=lower(ALLTRIM(SUBSTR(cBuffer,5,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,5))=="CONTA"
			xCONTA:=lower(ALLTRIM(SUBSTR(cBuffer,7,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,5))=="SENHA"
			xSENHA:=lower(ALLTRIM(SUBSTR(cBuffer,7,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,4))==AllTrim(SM0->M0_CODIGO+SM0->M0_CODFIL)
			cSerie:=UPPER(SUBSTR(cBuffer,6,3))
		Endif
		If UPPER(SUBSTR(cBuffer,1,7))==AllTrim("ESP"+SM0->M0_CODIGO+SM0->M0_CODFIL)
			cEspecie:= "SPED"//UPPER(SUBSTR(cBuffer,9,5))
		Endif
		If UPPER(SUBSTR(cBuffer,1,10))=="DECQTD0101"//"DECQTD"+SM0->M0_CODIGO+SM0->M0_CODFIL
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
			cPedCom:=.t.
		Endif
		If UPPER(SUBSTR(cBuffer,1,3))=="NDF"
			cNDF:=.t.
		Endif
		If UPPER(SUBSTR(cBuffer,1,7))=="NFZEROS"
			cZeros:=.T.
		Endif
		If UPPER(SUBSTR(cBuffer,1,11))=="PEDPROD=SIM"
			lCheck2:=.T.
		Endif
		FT_FSKIP()
	EndDo
	FT_FUSE()
Else
	Msgbox("Arquivo de configuracao CFGXML.TXT nЦo encontrado no diretСrio \xmlcli\CONFIG")
	Return
Endif

cSerieNF:=cSerie

If Empty(cUnidades)
	Msgbox("Favor informar as Unidades de medidas fracionadas!")
	Return
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Recebendo emails dos clientes    									Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
MsgRun("Recebendo XML "+xCONTA,,{||POPEMAIL()})

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Apagando arquivos diferentes de XML									Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aXML:={}
ADir("\xmlcli\*.*",aXML)
_cCNPJ2:=""
For i:=1 to len(aXML)
	If "XML" $ UPPER(ALLTRIM(aXML[i]))
		XMLCGCcl(i)
		IF _CNUMEMP=="01" .AND.  ALLTRIM(_cCNPJ2) == alltrim(SM0->M0_CGC)
			__CopyFile("\xmlCLI\"+UPPER(ALLTRIM(aXML[i])),"\xmlCLI\ArquivaMasipack\"+UPPER(ALLTRIM(aXML[i])))
		ENDIF
		
		IF _CNUMEMP=="10" .AND.  ALLTRIM(_cCNPJ2) == alltrim(SM0->M0_CGC)
			__CopyFile("\xmlCLI\"+UPPER(ALLTRIM(aXML[i])),"\xmlCLI\ArquivaFabrima\"+UPPER(ALLTRIM(aXML[i])))
		ENDIF
		
		IF _CNUMEMP=="15" .AND.  ALLTRIM(_cCNPJ2) == alltrim(SM0->M0_CGC)
			__CopyFile("\xmlCLI\"+UPPER(ALLTRIM(aXML[i])),"\xmlCLI\ArquivaHelsimplast\"+UPPER(ALLTRIM(aXML[i])))
		ENDIF
		
		IF _CNUMEMP=="40" .AND.  ALLTRIM(_cCNPJ2) == alltrim(SM0->M0_CGC)
			__CopyFile("\xmlCLI\"+UPPER(ALLTRIM(aXML[i])),"\xmlCLI\ArquivaLabortube\"+UPPER(ALLTRIM(aXML[i])))
		ENDIF
		
		IF _CNUMEMP=="45" .AND.  ALLTRIM(_cCNPJ2) == alltrim(SM0->M0_CGC)
			__CopyFile("\xmlCLI\"+UPPER(ALLTRIM(aXML[i])),"\xmlCLI\ArquivaMemb\"+UPPER(ALLTRIM(aXML[i])))
		ENDIF
		
	endif
	
	If !"XML" $ UPPER(ALLTRIM(aXML[i]))
		ferase("\xmlcli\"+lower(ALLTRIM(aXML[i])))
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
	@ 120,040 TO 750,1010 DIALOG oTela TITLE "ImportaГЦo nota fiscal eletrТnica -Clientes "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+"-"+SM0->M0_FILIAL
	_nTop:=750
	_nRight:=1010
	_nSize:=485
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Lista dos XML dos Clientes										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aXML:={}
//Ivandro Santos - 13/07/17
//Ticket#2017071337000167 ≈ Salvar xml pasta servidor
_aCpyxml:={}

_cLogin:= LogUserName()
ADir("C:\Users\"+Alltrim(_cLogin)+"\Downloads\*.xml",_aCpyxml)
For nXml := 1 to len(_aCpyxml)
	lRetCpy := CpyT2S( "C:\Users\"+_cLogin+"\Downloads\"+_aCpyxml[nXml], "\xmlcli" )
	If lRetCpy
		WaitRun("cmd /c del "+"C:\Users\"+_cLogin+"\Downloads\"+_aCpyxml[nXml],0)
	Else
	    ApMsgAlert("Erro ao copiar arquivo"+_aCpyxml[nXml])
	    Return
	Endif
Next
//Ticket#2017071337000167 ≈ Fim da alteraГЦo
ADir("\xmlcli\*.xml",aXML)

If Len(aXml)==0
	Msgbox("NЦo existem arquivos para serem importados no momento...","AtenГЦo...","INFO")
	Return
Endif

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
{"DESCRICAO","C",50,0 },;
{"DESCORI","C",50,0 },;
{"UM","C",2,0 },;
{"QE","N",12,0 },;
{"CAIXAS","N",11,cDecQtd },;
{"NCM","C",10,0 },;
{"CST","C",3,0 },;
{"QUANTIDADE","N",11,cDecQtd},;
{"PRECO","N",18,cDecUni },;
{"CUSTO","N",9,2 },;
{"CCUSTO","C",9,0 },;
{"ICMS","N",14,2 },;
{"PRECOFOR","N",18,cDecUni},;
{"TOTAL","N",14,2 },;
{"DESCONTO","N",12,2 },;
{"EMISSAO","C",8,0 },;
{"PEDIDO","C",6,0 },;
{"ITEM","C",4,0 },;
{"CFOP","C",4,0 },;
{"TES","C",3,0 },;
{"ALMOX","C",2,0 },;
{"ALTERADO","C",1,0 },;
{"NOME","C",35,0 },;
{"NOTA","C",9,0 }}

cArqTrab  := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTrab, "LS1", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("LS1",cArqTrab,"SEQ",,,)
dbSetIndex( cArqTrab +OrdBagExt())
dbSelectArea("LS1")

aCampos3:= {{"EMISSAO","D",8,0 },;
{"CLIENTE","C",6,0 },;
{"LOJA","C",2,0 },;
{"NOTA","C",9,0 },;
{"NOME","C",35,0 },;
{"VENDEDOR","C",30,0 },;
{"TELEFONE","C",20,0 },;
{"XML","C",150,0 },;
{"CHAVE","C",60,0 }}

cArqTrab3  := CriaTrab(aCampos3)
dbUseArea( .T.,, cArqTrab3, "LS3", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("LS3",cArqTrab3,"NOME+NOTA",,,)
dbSetIndex( cArqTrab3 +OrdBagExt())
dbSelectArea("LS3")

_cCNPJ:=''
lAchou:=.F.

#IFDEF WINDOWS
	Processa({|| XMLFOUND()})
	Return
	Static Function XMLFOUND()

	
#ENDIF
Local i := 0
Local w := 0

aCampos4:= {{"NOTA","C",9,0 },;
{"CLIENTE","C",6,0 },;
{"LOJA","C",2,0 }}

cArqTrab4  := CriaTrab(aCampos4)
dbUseArea( .T.,, cArqTrab4, "LS4", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("LS4",cArqTrab4,"CLIENTE+LOJA+NOTA",,,)
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
	//Ё Cliente            													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
		cQueryM	:= "SELECT * "
		cQueryM	+= " FROM " + RetSqlName("SA1") "
		cQueryM	+= " WHERE D_E_L_E_T_ <> '*' "
		cQueryM	+= " AND A1_MSBLQL<>'1'  AND A1_CGC= '" + _cCNPJ + "' "
		cQueryM	+= " AND A1_COD NOT LIKE 'IMP%'   "
		//Ivandro Santos - 15/05/17 - InМcio da alteraГЦo
		//Ticket#2017051537000087 ≈ xml cliente
		cQueryM	+= " AND A1_COD+A1_LOJA NOT IN ('66666600','88888800','22222200','55555500','00402100','33333300','00000101') "
		/*
		cQueryM	+= " AND A1_COD NOT LIKE '666666' "
		cQueryM	+= " AND A1_COD NOT LIKE '888888' "
		cQueryM	+= " AND A1_COD NOT LIKE '222222' "
		cQueryM	+= " AND A1_COD NOT LIKE '555555' "
		cQueryM	+= " AND A1_COD NOT LIKE '004021' "
		cQueryM	+= " AND A1_COD NOT LIKE '333333' "
		*/
		//Ticket#2017051537000087 ≈ Fim da alteraГЦo
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQueryM) , 'MTMP', .T., .F.)
		
		XCODCLI := ""
		XLOJACL := 0
		DBSELECTAREA("MTMP")
		DBGOTOP()
		WHILE !EOF()
			XCODCLI := MTMP->A1_COD
			XLOJACL := MTMP->A1_LOJA			
			DBSKIP()
		END   
		
		If XCODCLI == ""  .or. empty(XCODCLI)
			Msgbox("Cliente nao Cadastrado !!! XML serА excluМdo"+ _cCNPJ)
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Nomeclatura dos arquivos											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cFileOri:="\xmlcli\"+lower(ALLTRIM(aXML[i]))
			
			_cFileNew:="\xmlcli\"+ALLTRIM(_cCNPJ)+"-nf"+ALLTRIM(cNota)+"-"+alltrim(cChave)+".xml.dup"
			
			FRename(_cFileOri,_cFileNew)
		
			ferase(_cFileNew)   

			//VICTOR DESSUNTE - 10/04/17
			// INICIO - TICKET: 2017021637000161 
			
		   /*IF SELECT("LS3") > 0
    			DBSELECTAREA("LS3")
 				DBCLOSEAREA()
    	   ENDIF
    	   IF SELECT("LS4") > 0
    			DBSELECTAREA("LS4")
 				DBCLOSEAREA()
    	   ENDIF
    	   IF SELECT("LS5") > 0
    			DBSELECTAREA("LS5")
 				DBCLOSEAREA()
    	   ENDIF
    	   IF SELECT("LS1") > 0
    			DBSELECTAREA("LS1")
 				DBCLOSEAREA()
    	   ENDIF
    	   IF SELECT("LS2") > 0
    			DBSELECTAREA("LS2")
 				DBCLOSEAREA()
    	   ENDIF
			Return*/

			Loop
			//FIM - TICKET: 2017021637000161 

		Endif
				
	If !Empty(_cCNPJ)
		DbSelectarea("SA1")
		DbSetorder(1)
		Dbgotop()
		Dbseek(xFilial("SA1")+XCODCLI+XLOJACL)
		If Found()
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verificando grupo													Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			lFornec:=.T.
			
			//	Endif
			
			If lFornec
				Incproc(SA1->A1_NREDUZ)
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifico arquivos XML duplicados									Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectarea("LS4")
				DbSetorder(1)
				Dbgotop()
				dbseek(SA1->A1_COD+SA1->A1_LOJA+cNota)
				If !Found()
					Reclock("LS4",.T.)
					LS4->NOTA:=cNota
					LS4->CLIENTE:=SA1->A1_COD
					LS4->LOJA:=SA1->A1_LOJA
					MsUnlock()
					if cEmissao>'20110100'
						Reclock("LS3",.T.)
						LS3->EMISSAO:=STOD(cEmissao)
						LS3->CLIENTE:=SA1->A1_COD
						LS3->LOJA:=SA1->A1_LOJA
						LS3->VENDEDOR:="BENEFICIAMENTO"
						LS3->TELEFONE:=alltrim(SA1->A1_DDD)+" "+alltrim(SUBSTR(SA1->A1_TEL,1,20))
						LS3->NOME:=SA1->A1_NREDUZ
						LS3->XML:=UPPER(aXML[i])
						LS3->NOTA:=cNota
						LS3->CHAVE:=cChave
						MsUnlock()
						lAchou:=.T.
					endif
				Endif
			Endif
		Else
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Nomeclatura dos arquivos											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cFileOri:="\xmlcli\"+lower(ALLTRIM(aXML[i])) 
			
			IF _CNUMEMP=="01"
				__CopyFile("\xmlcli\*.*","\xmlcli\ArquivaMasipack\") 
			EndIf   
			
			IF _CNUMEMP=="10"
				__CopyFile("\xmlcli\*.*","\xmlcli\ArquivaFabrima\") 
			EndIf
			
			IF _CNUMEMP=="15"
				__CopyFile("\xmlcli\*.*","\xmlcli\ArquivaHelsimplast\") 
			EndIf
			
			IF _CNUMEMP=="40"
				__CopyFile("\xmlcli\*.*","\xmlcli\ArquivaLabortube\") 
			EndIf
			
			IF _CNUMEMP=="45"
				__CopyFile("\xmlcli\*.*","\xmlcli\ArquivaMemb\") 
			EndIf
			
			_cFileNew:="\xmlcli\"+ALLTRIM(_cCNPJ)+"-nf"+ALLTRIM(cNota)+"-"+alltrim(cChave)+".xml.dup"
			
			FRename(_cFileOri,_cFileNew)
			__CopyFile("\xmlcli\*.dup","\xmlcli\duplicados\")
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
_cxcliente:=''
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
cPict1:="@E 99,999."
For w:=1 to cDecQtd
	cPict1:=alltrim(cPict1)+"9"
Next
cPict2:="@E 99,999."
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
//@ 005,305 BUTTON "HistСrico" SIZE 65,10 ACTION MsgRun("Processando histСrico do Cliente...",,{||HISTFOR()})
@ 005,390 say "NOTA FISCAL ELETRтNICA" FONT oFont5 OF oTela PIXEL COLOR CLR_HRED

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Principal 															Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
@ 020,005 TO 110,_nSize BROWSE "LS3" OBJECT OBRWP FIELDS aTituloX
OBRWP:oBrowse:BCHANGE := {||PROCESS()}
OBRWP:oBrowse:oFont := TFont():New ("Arial", 05, 18)

OBRWP:oBrowse:AddColumn(TCColumn():New("EmissЦo",   {||LS3->EMISSAO},"@D 99/99/99",,,"LEFT",10))
OBRWP:oBrowse:AddColumn(TCColumn():New("Cliente",{||LS3->CLIENTE},,,,"LEFT",10))
OBRWP:oBrowse:AddColumn(TCColumn():New("Loja",      {||LS3->LOJA},,,,"LEFT",15))
OBRWP:oBrowse:AddColumn(TCColumn():New("Nome",      {||LS3->NOME},,,,"LEFT",60))
OBRWP:oBrowse:AddColumn(TCColumn():New("Vendedor",  {||LS3->VENDEDOR},"@!",,,"LEFT",90))
OBRWP:oBrowse:AddColumn(TCColumn():New("Telefone",  {||LS3->TELEFONE},"@!",,,"LEFT",60))
OBRWP:oBrowse:AddColumn(TCColumn():New("Nota Fiscal EletrТnica",{||LS3->CHAVE},"@!",,,"LEFT",10))
OBRWP:oBrowse:AddColumn(TCColumn():New("Arquivo XML",{||LS3->XML},"@!",,,"LEFT",10))

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Secundaria															Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
OBRWI:=MsSelect():New("LS1","","",aTitulo,@lInverte,@cMarca,{125,005,240,_nSize},,,,,aCores)
OBRWI:oBrowse:bLDblClick := {||CORRIGE()}
OBRWI:oBrowse:oFont := TFont():New ("Arial", 05, 18)

OBRWI:oBrowse:AddColumn(TCColumn():New("CСd.For." ,{||LS1->PRODFOR},,,,"LEFT", 25))
OBRWI:oBrowse:AddColumn(TCColumn():New("Produto"  ,{||LS1->PRODUTO},,,,"LEFT", 25))
OBRWI:oBrowse:AddColumn(TCColumn():New("DescriГЦo",{||LS1->DESCRICAO},,,,"LEFT",150))
OBRWI:oBrowse:AddColumn(TCColumn():New("UM"       ,{||LS1->UM},,,,"LEFT", 25))
OBRWI:oBrowse:AddColumn(TCColumn():New("Emb."     ,{||LS1->QE},"@E 9999",,,"LEFT", 25))
OBRWI:oBrowse:AddColumn(TCColumn():New("Caixas"   ,{||LS1->CAIXAS},cPict1,,,"RIGHT", 25))
OBRWI:oBrowse:AddColumn(TCColumn():New("Quant."   ,{||LS1->QUANTIDADE},cPict1,,,"RIGHT", 45))
OBRWI:oBrowse:AddColumn(TCColumn():New("PreГo R$" ,{||LS1->PRECO},cPict2,,,"RIGHT", 45))
OBRWI:oBrowse:AddColumn(TCColumn():New("Custo R$" ,{||LS1->CUSTO},"@E 9,999.99",,,"RIGHT", 45))
OBRWI:oBrowse:AddColumn(TCColumn():New("Desc.R$"  ,{||LS1->DESCONTO},"@E 99,999.99",,,"RIGHT", 45))
OBRWI:oBrowse:AddColumn(TCColumn():New("Total R$",{||LS1->TOTAL},"@E 99,999.99",,,"RIGHT", 45))
OBRWI:oBrowse:AddColumn(TCColumn():New("CFOP."     ,{||LS1->CFOP},"@E 9999",,,"LEFT", 25))
OBRWI:oBrowse:SetBlkColor(bColor)

If lCheck2
	OBRWI:oBrowse:AddColumn(TCColumn():New("Pedido",{||LS1->PEDIDO},,,,"LEFT", 30))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Item",{||LS1->ITEM},,,,"LEFT", 30))
Endif

@ 245,003 TO 315,235
@ 250,005 say "CLIENTE" SIZE 150,40 FONT oFont4 OF oTela PIXEL COLOR CLR_GREEN
@ 260,005 say _cxcliente size 200,20 FONT oFont3 OF oTela PIXEL COLOR CLR_HBLUE
@ 270,005 say "CNPJ" FONT oFont1 OF oTela PIXEL
@ 270,040 say _cCNPJ size 80,20 size 50,20 FONT oFont2 OF oTela PIXEL
@ 280,005 say "EndereГo" FONT oFont1 OF oTela PIXEL
@ 280,040 say _cEnd size 170,20 FONT oFont2 OF oTela PIXEL
@ 300,005 say "Cidade/UF" FONT oFont1 OF oTela PIXEL
@ 300,040 say _cCidade size 150,20 size 100,20 FONT oFont2 OF oTela PIXEL

@ 245,240 TO 315,435
@ 250,250 say "NOTA FISCAL" FONT oFont4 OF oTela PIXEL COLOR CLR_GREEN
@ 260,250 say "EmissЦo" FONT oFont1 OF oTela PIXEL
@ 260,290 say _cEmissao size 80,40 picture "@D 99/99/99" FONT oFont3 OF oTela PIXEL
@ 270,250 say "Total R$" FONT oFont1 OF oTela PIXEL
@ 270,290 say nTotalNF size 80,40 picture "@E 99,999.99" FONT oFont3 OF oTela PIXEL
@ 280,250 say "Qtd.Itens" FONT oFont1 OF oTela PIXEL
@ 280,290 say nTotIt size 40,40 picture "@E 9999" FONT oFont3 OF oTela PIXEL
@ 290,250 say "Nat.OperaГЦo" FONT oFont1 OF oTela PIXEL
@ 290,290 say SUBSTR(alltrim(cNatOP),1,32) size 180,40 picture "@!" FONT oFont2 OF oTela PIXEL COLOR CLR_HRED
@ 300,250 say "SИrie/Nota Fiscal" FONT oFont1 OF oTela PIXEL
@ 300,310 say ALLTRIM(cSerie)+"-"+cNota size 80,40 picture "@!" FONT oFont3 OF oTela PIXEL COLOR CLR_MAGENTA
@ 112,005 BUTTON "_HistСrico" SIZE 65,10 ACTION MACOMVIEW(LS1->PRODUTO)
@ 112,075 BUTTON "CСd.Barras" SIZE 65,10 ACTION CODBAR()
@ 112,145 BUTTON "_Mensagem Nota" SIZE 65,10 ACTION MSGNF(_cMensag)
@ 112,215 BUTTON "Legenda" SIZE 65,10 ACTION LEGENDA()
@ 112,285 BUTTON "Incluir Produto" SIZE 65,10 ACTION mata010() 
@ 112,355 BUTTON "Incluir produtos de teste" SIZE 65,10 ACTION cadtest()
If lCheck2
	@ 112,285 BUTTON "_Selecionar Pedido" SIZE 65,10 ACTION PROCPED()
	@ 112,355 BUTTON "_Eliminar Pedido do item" SIZE 65,10 ACTION ELIMPED()
	@ 112,425 BUTTON "Eliminar _Todos Pedidos" SIZE 65,10 ACTION ELIMPEDT()
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Gerando pre nota													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function IMPORTA()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifico se existe a nota fiscal									Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF !file("\xmlcli\"+lower(LS3->XML))
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
	Msgbox("Dados do Cliente nЦo encontradosNumero de nota fiscal nЦo encontrada!")
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
//Ё Verificando se todos os produtos foram identificados				Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
lIdent:=.F.
DbSelectarea("LS1")
Dbgotop()
While !Eof()
	IF LS1->OK=="X"
		lIdent:=.T.
	Endif
	Dbskip()
End
Dbgotop()

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
			IF Empty(LS1->PEDIDO)
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
		cResp:=msgbox("Deseja gerar o pedido para os itens que nЦo tem pedido de compra?","AtenГЦo...","YESNO")
		If cResp
			NEWPED2()
		Else
			DbSelectarea("LS1")
			dbgotop()
			Return
		Endif
	Endif
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando se os produtos existem saldos no pedidos				Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lItem
		DbSelectarea("LS1")
		Dbgotop()
		While !Eof()
			IF !Empty(LS1->PEDIDO)
				aProdutos	:= {{"PRODUTO","C",15,0 },;
				{"DESCRICAO","C",50,0 },;
				{"QUANTIDADE","N",12,3 },;
				{"PEDIDO","C",6,0 },;
				{"ITEM","C",4,0 },;
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
						MsUnlock()
					Else
						Reclock("PRO",.F.)
						PRO->QUANTIDADE:=(PRO->QUANTIDADE+LS1->QUANTIDADE)
						MsUnlock()
					Endif
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
				cMsg:=cMsg+PRO->PEDIDO+"   "+PRO->ITEM+"   "+alltrim(PRO->PRODUTO)+"   "+PRO->DESCRICAO+CHR(13)+CHR(10)
			Endif
			Dbclosearea("TCQ")
			DbSelectArea("PRO")
			Dbskip()
		End
		
		If !Empty(cMsg)
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
	IF LS1->CUSTO>0
		IF 100-((LS1->PRECO/LS1->CUSTO)*100)>10 .OR. 100-((LS1->PRECO/LS1->CUSTO)*100)<-10
			cMsg:=cMsg+ALLTRIM(LS1->PRODUTO)+"  "+SUBSTR(LS1->DESCRICAO,1,35)+CHR(13)+CHR(10)
			cMsg:=cMsg+"PreГo Nota R$ "+transform(LS1->PRECO,"@E 9,999.99")+"   PreГo Pedido R$"+transform(LS1->CUSTO,"@E 9,999.99")+CHR(13)+CHR(10)
			cMsg:=cMsg+CHR(13)+CHR(10)
			
			Reclock("LS1",.F.)
			LS1->OK:="O"
			MsUnlock()
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
		{"QUANTIDADE","N",12,3 },;
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
		{"QTDIT","N",5,0 },;
		{"VALIDO","N",5,0 }}
		
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
		cQuery:=cQuery + " AND C7_FORNECE='"+LS3->CLIENTE+"' "
		cQuery:=cQuery + " AND C7_EMISSAO>='"+DTOS(DDATABASE-60)+"' "
		cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA>0) "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
		cQuery:=cQuery + " GROUP BY C7_EMISSAO,C7_NUM,C7_LOJA "
		cQuery:=cQuery + " ORDER BY C7_EMISSAO DESC "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		While !Eof()
			if TCQ->EMISSAO>'20120100'
				Reclock("LS2",.T.)
				LS2->EMISSAO:=STOD(TCQ->EMISSAO)
				LS2->PEDIDO:=TCQ->PEDIDO
				LS2->LOJA:=TCQ->LOJA
				LS2->ITENS:=TCQ->QTD
				LS2->ENTREGA:=STOD(TCQ->ENTREGA)
				Msunlock()
				lAchou:=.T.
			endif
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
			@ 005,035 BUTTON "A_tualizar Pedido" SIZE 55,10 ACTION PEDIDOS()
			@ 005,095 BUTTON "_Abrir Pedido" SIZE 55,10 ACTION ABREPED()
			@ 005,155 BUTTON "_DivergЙncias" SIZE 55,10 ACTION DIVERG()
			@ 005,215 BUTTON "_Eliminar" SIZE 55,10 ACTION ELIMINAR()
			@ 020,005 TO 140,275 BROWSE "LS2" ENABLE " LS2->OK<>'X' " OBJECT OBRWT FIELDS aTitulo2
			OBRWT:oBrowse:oFont := TFont():New ("Arial", 05, 18)
			ACTIVATE DIALOG oPedido CENTER
		Else
			Msgbox("NЦo existem pedidos em aberto para este cliente!")
			
			cResp:=Msgbox("Deseja gerar um pedido automaticamente para esta nota eletrТnica?","AtenГЦo...","YESNO")
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
		DbSetorder(2)
		Dbgotop()
		Dbseek(xFilial("SF1")+LS3->CLIENTE+LS3->LOJA+alltrim(cNota)+Space(cSpaco))
		If Found() .and. SF1->F1_TIPO=="B"
			
			Msgbox("Nota fiscal jА existe!","AtenГЦo...","ALERT")
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Dados do Clienter													Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("SA1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA1")+LS3->CLIENTE+LS3->LOJA)
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Nomeclatura dos arquivos											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cFileOri:="\xmlcli\"+ALLTRIM(LS3->XML)
			_cFileNew:="\xmlcli\"+ALLTRIM(SA1->A1_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.imp"
			
			FRename(_cFileOri,_cFileNew)
			__CopyFile("\xmlcli\*.imp","\xmlcli\importados\")  
			// tratamento empresas        
			
			IF _CNUMEMP=="01"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaMasipack\")
			ENDIF
			
			IF _CNUMEMP=="10"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaFabrima\")
			ENDIF
			
			IF _CNUMEMP=="15"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaHelsimplast\")
			endif
			
			IF _CNUMEMP=="40"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaLabortube\")
			endif
			
			IF _CNUMEMP=="45"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaMemb\")
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
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Gravando amarracao produto x cliente								Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_ttt:=.t.
		IF _ttt
			If !Empty(LS1->PRODFOR)
				DbSelectarea("SA7")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SA7")+LS3->CLIENTE+LS3->LOJA+LS1->PRODUTO)
				If !Found()
					Reclock("SA7",.T.)
					SA7->A7_FILIAL:=xFilial("SA7")
					SA7->A7_CLIENTE:=LS3->CLIENTE
					SA7->A7_LOJA:=LS3->LOJA
					SA7->A7_CODCLI:=LS1->PRODFOR
					SA7->A7_PRODUTO:=LS1->PRODUTO
					SA7->A7_DESCCLI:=SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC"),1,30)
					//SA7->A7_NOMEFOR:=POSICIONE("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS2->LOJA,"A1_NREDUZ")
					MsUnlock()
				Else
					Reclock("SA7",.F.)
					SA7->A7_CODCLI:=LS1->PRODFOR
					MsUnlock()
				Endif
			Endif
		ENDIF
		
		
		If cRet
			
			DbSelectarea("LS1")
			Dbsetorder(1)
			Dbgotop()
			While !Eof()
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualizando NCM do produto de acordo com o XML do cliente   		Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				IF !Empty(LS1->NCM)
					DbSelectarea("SB1")
					DbSetorder(1)
					Dbgotop()
					Dbseek(xFilial("SB1")+LS1->PRODUTO)
					If Found()
//						Reclock("SB1",.F.)
//						SB1->B1_POSIPI:=LS1->NCM
//						MsUnlock()
					Endif
				Endif
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Gravando amarracao produto x cliente								Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If !Empty(LS1->PRODFOR)
					DbSelectarea("SA7")
					DbSetorder(1)
					Dbgotop()
					Dbseek(xFilial("SA7")+LS3->CLIENTE+LS3->LOJA+LS1->PRODUTO)
					If !Found()
						Reclock("SA7",.T.)
						SA7->A7_FILIAL:=xFilial("SA7")
						SA7->A7_CLIENTE:=LS3->CLIENTE
						SA7->A7_LOJA:=LS3->LOJA
						SA7->A7_CODCLI:=LS1->PRODFOR
						SA7->A7_PRODUTO:=LS1->PRODUTO
						SA7->A7_DESCCLI:=SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC"),1,30)
						//SA7->A7_NOMEFOR:=POSICIONE("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS2->LOJA,"A1_NREDUZ")
						MsUnlock()
					Else
						Reclock("SA7",.F.)
						SA7->A7_CODCLI:=LS1->PRODFOR
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
			//Ё Dados do CLIENTEr													Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("SA1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA1")+LS3->CLIENTE+LS3->LOJA)
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Nomeclatura dos arquivos											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cFileOri:="\xmlcli\"+ALLTRIM(LS3->XML)
			_cFileNew:="\xmlcli\"+ALLTRIM(SA1->A1_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.imp"
			
			FRename(_cFileOri,_cFileNew)
			__CopyFile("\xmlcli\*.imp","\xmlcli\importados\")
			// tratamento empresas        
			
			IF _CNUMEMP=="01"
				__CopyFile("\xmlcli\*.imp","\xmlcli\ArquivaMasipack\")
			ENDIF
			
			IF _CNUMEMP=="10"
				__CopyFile("\xmlcli\*.imp","\xmlcli\ArquivaFabrima\")
			ENDIF
			
			IF _CNUMEMP=="15"
				__CopyFile("\xmlcli\*.imp","\xmlcli\ArquivaHelsimplast\")
			endif
			
			IF _CNUMEMP=="40"
				__CopyFile("\xmlcli\*.imp","\xmlcli\ArquivaLabortube\")
			endif
			
			IF _CNUMEMP=="45"
				__CopyFile("\xmlcli\*.imp","\xmlcli\ArquivaMemb\")
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida pedido														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
	IF Empty(LS1->PEDIDO) .or. Empty(LS1->ITEM)
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
	DbSetorder(2)
	Dbgotop()
	Dbseek(xFilial("SF1")+LS3->CLIENTE+LS3->LOJA+alltrim(cNota)+Space(cSpaco))
	If Found() .and. SF1->F1_TIPO=="B"
		
		Msgbox("Nota fiscal jА existe!","AtenГЦo...","ALERT")
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Dados do cliente													Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("SA1")
		DbSetorder(1)
		Dbgotop()
		Dbseek(xFilial("SA1")+LS3->CLIENTE+LS3->LOJA)
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Nomeclatura dos arquivos											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_cFileOri:="\xmlcli\"+ALLTRIM(LS3->XML)
		_cFileNew:="\xmlcli\"+ALLTRIM(SA1->A1_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.imp"
		
		FRename(_cFileOri,_cFileNew)
		__CopyFile("\xmlcli\*.imp","\xmlcli\importados\")
		// tratamento empresas        
			
			IF _CNUMEMP=="01"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaMasipack\")
			ENDIF
			
			IF _CNUMEMP=="10"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaFabrima\")
			ENDIF
			
			IF _CNUMEMP=="15"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaHelsimplast\")
			endif
			
			IF _CNUMEMP=="40"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaLabortube\")
			endif
			
			IF _CNUMEMP=="45"
				__CopyFile("\xmlcli\*.imp","\xml\ArquivaMemb\")
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
		//Ё Gravando amarracao produto x clienter								Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("LS1")
		Dbsetorder(1)
		Dbgotop()
		While !Eof()
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualizando NCM do produto de acordo com o XML do cliente   		Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			IF !Empty(LS1->NCM)
				DbSelectarea("SB1")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SB1")+LS1->PRODUTO)
				If Found()
//					Reclock("SB1",.F.)
//					SB1->B1_POSIPI:=LS1->NCM
//					MsUnlock()
				Endif
			Endif
			
			If !Empty(LS1->PRODFOR)
				DbSelectarea("SA7")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SA7")+LS3->CLIENTE+LS3->LOJA+LS1->PRODUTO)
				If !Found()
					Reclock("SA7",.T.)
					SA7->A7_FILIAL:=xFilial("SA7")
					SA7->A7_CLIENTE:=LS3->CLIENTE
					SA7->A7_LOJA:=LS3->LOJA
					SA7->A7_CODCLI:=LS1->PRODFOR
					SA7->A7_PRODUTO:=LS1->PRODUTO
					SA7->A7_DESCCLI:=SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC"),1,30)
					MsUnlock()
				Else
					Reclock("SA7",.F.)
					SA7->A7_CODCLI:=LS1->PRODFOR
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
		//Ё Dados do CLIENTE													Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("SA1")
		DbSetorder(1)
		Dbgotop()
		Dbseek(xFilial("SA1")+LS3->CLIENTE+LS3->LOJA)
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Nomeclatura dos arquivos											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		_cFileOri:="\xmlcli\"+ALLTRIM(LS3->XML)
		_cFileNew:="\xmlcli\"+ALLTRIM(SA1->A1_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.imp"
		
		FRename(_cFileOri,_cFileNew)
		__CopyFile("\xmlcli\*.imp","\xmlcli\importados\")
		// tratamento empresas        
			
			IF _CNUMEMP=="01"
				__CopyFile("\xml\*.imp","\xmlcli\ArquivaMasipack\")
			ENDIF
			
			IF _CNUMEMP=="10"
				__CopyFile("\xml\*.imp","\xmlcli\ArquivaFabrima\")
			ENDIF
			
			IF _CNUMEMP=="15"
				__CopyFile("\xml\*.imp","\xmlcli\ArquivaHelsimplast\")
			endif
			
			IF _CNUMEMP=="40"
				__CopyFile("\xml\*.imp","\xmlcli\ArquivaLabortube\")
			endif
			
			IF _CNUMEMP=="45"
				__CopyFile("\xml\*.imp","\xmlcli\ArquivaMemb\")
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
//Ё Corrigir produto													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CORRIGE()

nSeek:=LS1->SEQ

If LS1->OK=="X"
	aCampos6:= {{"PRODUTO","C",15,0 },;
	{"DESCRICAO","C",45,0 },;
	{"QE","N",12,2 },;
	{"SALDO","N",12,2 },;
	{"PEDIDO","C",3,0 },;
	{"BLQ","C",5,0 }}
	
	cArqTrab6  := CriaTrab(aCampos6)
	dbUseArea( .T.,, cArqTrab6, "LS4", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS4",cArqTrab6,"DESCRICAO",,,)
	dbSetIndex( cArqTrab6 +OrdBagExt())
	dbSelectArea("LS4")
	
	LS1DESC=ALLTRIM(STRTRAN(SUBSTR(LS1->DESCRICAO,1,4),"'",""))
	lTem:=.F.
	cQuery:=" SELECT B1_MSBLQL BLQ,B1_CODBAR CODBAR,B1_COD PRODUTO,B1_DESC DESCRICAO FROM SB1010 " //+SM0->M0_CODIGO+"0 "
	cQuery:=cQuery + " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
	//cQuery:=cQuery + " AND B1_DESC+B1_XDESENH + B1_XPARTNU LIKE '"+'%'+SUBSTR(LS1->DESCRICAO,1,4)+'%'+"' "
	cQuery:=cQuery + " AND B1_DESC LIKE '"+'%'+LS1DESC+'%'+"' "
	cQuery:=cQuery + " AND B1_PROC='"+LS3->CLIENTE+"' "
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
		LS4->QE:=POSICIONE("SB1",1,xFilial("SB1")+TCQ->PRODUTO,"B1_QE")
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
	AADD(aTitulo6,{"QE","Qtd.Emb.","@E 99999"})
	AADD(aTitulo6,{"SALDO","Saldo Atual","@e 99,999.99"})
	AADD(aTitulo6,{"PEDIDO","Possui Pedido?"})
	
	DbSelectarea("LS4")
	Dbgotop()
	
	_cFiltrox:=SUBSTR(LS1->DESCRICAO,1,4)+space(30)
	lCheck1:=.F.
	
	@ 120,040 TO 450,880 DIALOG oAmarra TITLE "Produto do Cliente..."
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
If Empty(LS1->OK) .OR. LS1->OK=="O"
	SELECIONA(LS1->PRODUTO,1)
Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processando arquivos												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function XML(i)

private _oXml    := NIL
private cError    := ''
private cWarning := ''
nXmlStatus := XMLError()
cFile:="\xmlcli\"+lower(ALLTRIM(aXML[i]))
oXml := XmlParserFile(cFile,"_",@cError, @cWarning )
lTipo:=3

If ALLTRIM(TYPE("oxml:_NFE:_INFNFE"))=="O"
	lTipo:=1
Endif
If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE"))=="O"
	lTipo:=2
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
	   XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
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
	Else
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Sem _NFEPROC															Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		
		If SUBSTR(alltrim(oxml:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
			_cCNPJ2:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
		Endif
		_cCNPJ:=alltrim(oxml:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
        XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
		IF XXVERSAO=="2"
			cEmissao:=substr(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
		ELSE
			cEmissao:=substr(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
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
		DbSelectarea("SA1")
		DbSetorder(3)
		Dbgotop()
		Dbseek(xFilial("SA1")+_cCNPJ)
		If Found()
			dbSelectArea("SF1")
			DbSetorder(2)
			Dbgotop()
			Dbseek(xFilial("SF1")+SA1->A1_COD+SA1->A1_LOJA+alltrim(cNota)+Space(cSpaco))
			If Found() .and. SF1->F1_TIPO=="B"
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Nomeclatura dos arquivos											Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_cFileOri:="\xmlcli\"+lower(ALLTRIM(aXML[i]))
				_cFileNew:="\xmlcli\"+ALLTRIM(_cCNPJ)+"-nf"+ALLTRIM(cNota)+"-"+ALLTRIM(cChave)+".xml.imp"
				
				FRename(_cFileOri,_cFileNew)
				__CopyFile("\xmlcli\*.imp","\xmlcli\importados\")
					// tratamento empresas        
			
		  		IF _CNUMEMP=="01"
					__CopyFile("\xml\*.imp","\xmlcli\ArquivaMasipack\")
				ENDIF
			
				IF _CNUMEMP=="10"
					__CopyFile("\xml\*.imp","\xmlcli\ArquivaFabrima\")
				ENDIF
			
				IF _CNUMEMP=="15"
					__CopyFile("\xml\*.imp","\xmlcli\ArquivaHelsimplast\")
				endif
			
				IF _CNUMEMP=="40"
					__CopyFile("\xml\*.imp","\xmlcli\ArquivaLabortube\")
				endif
			
				IF _CNUMEMP=="45"
					__CopyFile("\xml\*.imp","\xmlcli\ArquivaMemb\")
				endif 
				ferase(_cFileNew)
				
				//_cCNPJ:=''
			Endif
		Endif
	Endif
Else
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Nomeclatura dos arquivos											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_cFileOri:="\xmlcli\"+lower(ALLTRIM(aXML[i]))
	_cFileNew:="\xmlcli\"+lower(ALLTRIM(aXML[i]))+".err"
	
	FRename(_cFileOri,_cFileNew)
	__CopyFile("\xmlcli\*.err","\xmlcli\corrompidos\")
	ferase(_cFileNew)
Endif
Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Pre nota entrada											 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
//| Grava status no Cliente  que manda o XML					 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*DbSelectarea("SA1")
DbSetorder(1)
Dbgotop()
Dbseek(xFilial("SA1")+LS3->CLIENTE+LS3->LOJA)
If Found()
Reclock("SA1",.F.)
SA2->A2_STATUS:="1"
MsUnlock()
Endif
*/
aadd(aCabec,{"F1_TIPO","B"})
aadd(aCabec,{"F1_SERIE",cSerie})
aadd(aCabec,{"F1_FORMUL","N"})
aadd(aCabec,{"F1_DOC",(cNota)})
aadd(aCabec,{"F1_EMISSAO",_dEmissao})

aadd(aCabec,{"F1_FORNECE",LS3->CLIENTE})

aadd(aCabec,{"F1_LOJA",LS3->LOJA})
aadd(aCabec,{"F1_ESPECIE",cEspecie})
aadd(aCabec,{"F1_CHVNFE",LS3->CHAVE})
aadd(aCabec,{"F1_HORA",LEFT(TIME(),5)})
//aadd(aCabec,{"F1_MSAUXML","S"})
DbSelectarea("LS1")
DbSetorder(1)
Dbgotop()
While !Eof()
	_cPedido:=LS1->PEDIDO
	
	If LS1->DESCONTO>0
		_nPrecoU:=LS1->PRECO+(LS1->DESCONTO/LS1->QUANTIDADE)
		_nTotalIt:=(LS1->QUANTIDADE*_nPrecoU)
	Else
		_nPrecoU:=LS1->PRECO
		_nTotalIt:=LS1->TOTAL
	Endif
	xxlocal := GetAdvFVal("SB1","B1_LOCPAD",xFilial("SB1")+LS1->PRODUTO,1," " )
	aLinha := {}
	aadd(aLinha,{"D1_COD",LS1->PRODUTO,Nil})
	aadd(aLinha,{"D1_QUANT",LS1->QUANTIDADE,Nil})
	aadd(aLinha,{"D1_PEDIDO",LS1->PEDIDO,Nil})
	aadd(aLinha,{"D1_VUNIT",_nPrecoU,Nil})
	aadd(aLinha,{"D1_TOTAL",_nTotalIt,Nil})
	aadd(aLinha,{"D1_VALDESC",LS1->DESCONTO,Nil})
	aadd(aLinha,{"D1_LOCAL",IIF(!EMPTY(xxlocal),xxlocal,LS1->ALMOX),Nil})
	aadd(aLinha,{"D1_TES",LS1->TES,Nil})
	aadd(aLinha,{"D1_CFCLI",LS1->CFOP,Nil})
  	aadd(aLinha,{"D1_DTFISC",dDataBase,Nil})

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

If Len(aCabec)>0 .and. Len(aItens)>0
	MATA140(aCabec,aItens)
Endif

If lMsErroAuto
	MostraErro()
Else
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Gerando NDF para o Cliente do valor excedido						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If cNDF .and. cPedCom
		_nExcedido:=VALORNDF()
		
		If _nExcedido>0
			cResp:=msgbox("Deseja gerar a NDC para o Cliente  no valor de R$ "+Transform(_nExcedido,"@E 99,999.99"),"AtenГЦo...","YESNO")
			If cResp
				NDF()
				Msgbox("NDF "+cNota+" gerada com sucesso!","AtenГЦo...","INFO")
			Endif
		Endif
	Endif
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Calculando o total do item na nota									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cQuere:=" UPDATE SD1"+SM0->M0_CODIGO+"0 SET D1_TOTAL=(D1_QUANT*D1_VUNIT) WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_DOC='"+cNota+"' AND D1_FORNECE='"+LS3->CLIENTE+"' AND D1_LOJA='"+LS3->LOJA+"' AND D1_SERIE='"+cSerie+"' "
	TCSQLEXEC(cQuere)
	cRet:=.T.
Endif
Return(cRet)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Alterar Pedido												 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function PEDIDOS()

If LS2->OK=="X"
	Msgbox("NЦo И necessАrio atualizar este pedido!","AtenГЦo...","ALERT")
	Return
Endif

cPedido:=LS2->PEDIDO
cLoja:=LS2->LOJA

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Verifica se algum pedido ainda nao foi usado				 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectarea("LS2")
Dbgotop()
While !Eof()
	IF 	LS2->OK=="X"
		Msgbox("Favor usar o Pedido "+LS2->PEDIDO,"Sem necessidade...","INFO")
		DbSelectarea("LS2")
		Dbgotop()
		Return
	Endif
	Dbskip()
End

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ajustando o pedido com a nota										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cResp:=msgbox("Deseja atualizar o pedido "+cPedido+" com os itens faltantes?","AtenГЦo...","YESNO")

If cResp
	
	lEntrou:=.F.
	_nQtdIt:=0
	
	Dbselectarea("PRO")
	DbSetorder(1)
	Dbgotop()
	While !Eof()
		DbSelectarea("SC7")
		DbSetorder(4)
		Dbgotop()
		Dbseek(xFilial("SC7")+PRO->PRODUTO+cPedido)
		If !Found()
			Dbselectarea("SB1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SB1")+PRO->PRODUTO)
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//| Dados do pedido												 |
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery:=" SELECT C7_EMISSAO EMISSAO,C7_COND COND,MAX(C7_ITEM) ITEM FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' AND C7_NUM='"+cPedido+"' AND D_E_L_E_T_<>'*' GROUP BY C7_EMISSAO,C7_COND "
			TCQUERY cQuery NEW ALIAS "PED"
			DbSelectArea("PED")
			nItem:=strzero(val(PED->ITEM)+1,4)
			_cCond:=PED->COND
			_dEmiss:=STOD(PED->EMISSAO)
			DbCloseArea("PED")
			
			Reclock("SC7",.T.)
			SC7->C7_FILIAL:=xFilial("SC7")
			SC7->C7_TIPO:=1
			SC7->C7_NUM:=cPedido
			SC7->C7_EMISSAO:=_dEmiss
			SC7->C7_FORNECE:=LS3->CLIENTE
			SC7->C7_LOJA:=cLoja
			SC7->C7_CONTATO:=Posicione("SA2",1,xFilial("SA2")+LS3->CLIENTE+cLoja,"A2_CONTATO")
			SC7->C7_COND:=_cCond
			SC7->C7_FILENT:=xFilial("SC7")
			SC7->C7_ITEM:=nItem
			SC7->C7_PRODUTO:=PRO->PRODUTO
			SC7->C7_UM:=SB1->B1_UM
			SC7->C7_SEGUM:=SB1->B1_SEGUM
			SC7->C7_DESCRI:=SUBSTR(SB1->B1_DESC,1,30)
			SC7->C7_QUANT:=PRO->QUANTIDADE
			SC7->C7_QTSEGUM:=(PRO->QUANTIDADE/SB1->B1_QE)
			SC7->C7_PRECO:=PRO->PRECO
			SC7->C7_TOTAL:=(PRO->QUANTIDADE*PRO->PRECO)
			SC7->C7_DATPRF:=_dEmiss
			SC7->C7_TES:=SB1->B1_TE
			SC7->C7_IPIBRUT:="B"
			SC7->C7_FLUXO:="S"
			SC7->C7_USER:=__CUSERID
			SC7->C7_TPOP:="F"
			SC7->C7_CONAPRO:="L"
			SC7->C7_MOEDA:=1
			SC7->C7_TPFRETE:="C"
			SC7->C7_OBS:="INCLUIDO NF-ELETRONICA"
			SC7->C7_PENDEN:="N"
			SC7->C7_POLREPR:="N"
			If Empty(cAlmoPed)
				SC7->C7_LOCAL:=Posicione("SB1",1,xFilial("SB1")+PRO->PRODUTO,"B1_LOCPAD")
			Else
				SC7->C7_LOCAL:=cAlmoPed
			Endif
			MsUnlock()
			
			_nQtdIt:=_nQtdIt+1
			
			If Empty(cAlmox)
				cAlmox:=Posicione("SB1",1,xFilial("SB1")+PRO->PRODUTO,"B1_LOCPAD")
			Endif
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualizado SB2 saldo de pedidos										Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("SB2")
			DbSetorder(2)
			Dbgotop()
			Dbseek(xFilial("SB2")+cAlmox+PRO->PRODUTO)
			If Found()
				Reclock("SB2",.F.)
				SB2->B2_SALPEDI:=(SB2->B2_SALPEDI+PRO->QUANTIDADE)
				MsUnlock()
			Endif
			lEntrou:=.T.
		Else
			If (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA)<PRO->QUANTIDADE
				_nTotal:=PRO->QUANTIDADE-(SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA)
				
				Reclock("SC7",.F.)
				SC7->C7_QUANT:=(SC7->C7_QUANT+_nTotal)
				SC7->C7_OBS+="ALTERADO NF-ELETRONICA"
				MsUnlock()
				
				Reclock("SC7",.F.)
				SC7->C7_TOTAL:=(SC7->C7_QUANT*SC7->C7_PRECO)
				MsUnlock()
				
				If Empty(cAlmox)
					cAlmox:=Posicione("SB1",1,xFilial("SB1")+PRO->PRODUTO,"B1_LOCPAD")
				Endif
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualizado SB2 saldo de pedidos										Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectarea("SB2")
				DbSetorder(2)
				Dbgotop()
				Dbseek(xFilial("SB2")+cAlmox+PRO->PRODUTO)
				If Found()
					Reclock("SB2",.F.)
					SB2->B2_SALPEDI:=(SB2->B2_SALPEDI+_nTotal)
					MsUnlock()
				Endif
				lEntrou:=.T.
			Endif
		Endif
		Dbselectarea("PRO")
		Dbskip()
	End
	
	If lEntrou
		Msgbox("Pedido atualizado com sucesso!","AtenГЦo...","INFO")
	Endif
	
	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		IF LS2->PEDIDO==cPedido
			Reclock("LS2",.F.)
			LS2->VALIDO:=nTotIt
			LS2->OK:="X"
			LS2->QTDIT:=(LS2->QTDIT+_nQtdIt)
			LS2->ITENS:=(LS2->ITENS+_nQtdIt)
			Msunlock()
		Endif
		Dbskip()
	End
Endif
DbSelectarea("LS2")
Dbgotop()
Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Novo Pedido													 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function NEWPED()

Local aCab2 :={}
Local aItem2:={}
PRIVATE lMsErroAuto := .F.
lAchei:=.F.
nOpc:=3

_nItens:=0
_cCond:=POSICIONE("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS3->LOJA,"A1_COND")
If Empty(_cCond)
	_cCond:="001"
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verificar Status da Gravacao										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
_lGrava:=Getmv("MV_GRVPEDI")

If !Empty(Alltrim(_lGrava))
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
	{"C7_FORNECE" ,LS3->CLIENTE,Nil},;
	{"C7_LOJA"    ,LS3->LOJA,Nil},;
	{"C7_CONTATO" ,Posicione("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS3->LOJA,"A1_CONTATO"),Nil},;
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
If Len(aItem2)>0 .and. Len(aCab2)>0
	MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCab2,aItem2,nOpc)
Endif

If lMsErroAuto
	mostraerro()
Else
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
	Msgbox("Pedido "+cNumped+" Gerado com sucesso!","AtenГЦo...","INFO")
EndIf
DbSelectarea("LS1")
Dbgotop()
Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Novo Pedido por item										 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function NEWPED2()

Local aCab2 :={}
Local aItem2:={}
PRIVATE lMsErroAuto := .F.
lAchei:=.F.
nOpc:=3

_nItens:=0
_cCond:=POSICIONE("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS3->LOJA,"A1_COND")
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
		{"C7_FORNECE" ,LS3->CLIENTE,Nil},;
		{"C7_LOJA"    ,LS3->LOJA,Nil},;
		{"C7_CONTATO" ,Posicione("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS3->LOJA,"A1_CONTATO"),Nil},;
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
If Len(aItem2)>0 .and. Len(aCab2)>0
	MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCab2,aItem2,nOpc)
Endif

If lMsErroAuto
	mostraerro()
Else
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
	Msgbox("Pedido "+cNumped+" Gerado com sucesso!","AtenГЦo...","INFO")
EndIf
DbSelectarea("LS1")
Dbgotop()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processando arquivo													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function PROCESS()

Local i := 0
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
IF !file("\xmlcli\"+lower(LS3->XML))
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
cFile:="\xmlcli\"+lower(ALLTRIM(LS3->XML))

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
Else
	lTipo:=2
Endif

nDescont:=0

If ( nXmlStatus == XERROR_SUCCESS )
	
	If lTipo==2
		aCols:=aClone(oXml:_NFEPROC:_NFE:_INFNFE:_DET)
	Else
		aCols:=aClone(oXml:_NFE:_INFNFE:_DET)
	Endif
	
	If aCols==NIL
		nItens:=1
	Else
		nItens:=len(aCols)
	Endif
	
	For i:=1 to nItens
		nDescont := 0 /*Reinicio a variavel pois este cara И por item*/
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Com _NFEPROC														Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lTipo==2
			
			If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT"))=="C"
				_cMensag:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT)
			Endif
			
			If nItens>1
				cCodbar :=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CEAN:TEXT
				cProdFor:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT
				nQuant	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)
				xDesc	:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_XPROD:TEXT
				xCFOP:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CFOP:TEXT
				cNCM	:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT 
			 //	cCST := oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_imposto:_ICMS:_ICMS00:TEXT
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
			cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
		ELSE
			cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
		ENDIF
				
				If SUBSTR(alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
					_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
					_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Else
					_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
					_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
				Endif
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				cProd:=''
			Else
				cCodbar :=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT
				cProdFor:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
				nQuant	:=val(oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)
				xCFOP:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
				cNCM	:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT
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
			cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
		ELSE
			cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)                                           
		ENDIF
				
				cUM		:=oxml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT
				If SUBSTR(alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
					_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
					_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Else
					_cCNPJ	:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
					_cEmpresa:=alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
				Endif
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				cProd:=''
			Endif
		Else
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Sem _NFEPROC														Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If ALLTRIM(TYPE("oxml:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT"))=="C"
				_cMensag:=alltrim(oxml:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT)
			Endif
			
			If nItens>1
				cCodbar :=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_CEAN:TEXT
				cProdFor:=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT
				nQuant	:=val(oxml:_NFE:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)
				xDesc	:=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_XPROD:TEXT
				xCFOP :=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_CFOP:TEXT
				cNCM	:=oxml:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT 
				//cCST := oxml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_imposto:_ICMS:_ICMS00:TEXT
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
				XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
		IF XXVERSAO=="2"
			cEmissao:=substr(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
		ELSE
			cEmissao:=substr(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
		ENDIF
				If SUBSTR(alltrim(oxml:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
					_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
					_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Else
					_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
					_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
				Endif
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				cProd:=''
			Else
				cCodbar :=oxml:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT
				cProdFor:=oxml:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
				nQuant	:=val(oxml:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)
				xDesc	:=oxml:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT
				xCFOP :=oxml:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
				cNCM	:=oxml:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT
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
				XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
		IF XXVERSAO=="2"
			cEmissao:=substr(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
		ELSE
			cEmissao:=substr(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
		ENDIF
				
				If SUBSTR(alltrim(oxml:_NFE:_INFNFE:_DEST:_IE:TEXT),1,1) $ "0/1/2/3/4/5/6/7/8/9"
					_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
					_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Else
					_cCNPJ	:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
					_cEmpresa:=alltrim(oxml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
				Endif
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
		
		If len(alltrim(cProdfor))<=5
			cProdFor:=strzero(val(cProdfor),6)
		Endif
		
		If len(alltrim(cProdfor))>15
			cProdFor:=SUBSTR(cProdFor,1,15)
		Endif
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Amarracao produto x cliente										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		//IF  LS3->CLIENTE=="000007"
		
		//	IF ( Empty(aLLTRIM(cProd)) .OR. cProd =="999999") .AND. LS3->CLIENTE=="000007"  .AND. ALLTRIM(cProdFor)=="00703850001"
		//	If  Empty(aLLTRIM(cProd)) .OR. cProd =="999999"
		DbSelectarea("SA7")
		DbOrderNickName("MSSA73")              	
		Dbgotop()
		Dbseek(xFilial("SA7")+ALLTRIM(cProdFor))
		While !Eof() .AND. ALLTRIM(SA7->A7_CODCLI)==ALLTRIM(cProdFor)
			IF SA7->A7_CLIENTE==LS3->CLIENTE .AND. SA7->A7_LOJA==LS3->LOJA
				cProd:=SA7->A7_PRODUTO
				
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
			
			DbSelectarea("SA7")
			Dbskip()
		End
		//		Endif
		
		_nQE:=1
		
		If Empty(cProd) //.or. Empty(cCodbar)
			cProd:="999999"
			_cDescricao:=xDesc
		Else
			_cDescricao:=POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
			_nQE:=POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_QE")
		Endif
		
		
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Unidade de medidas unitarias										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF cUM $ cUnidades
			_nQE:=1
		Endif
		
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
		
		_XXcfop:= Substr(LS1->CFOP,2,4)
		_XXEST:=Substr(LS1->CFOP,1,1)
		_XXTES :="103"
		_XXCCUSTO:="2021"
		_XXCF := "1901"
		IF _XXEST<>"5"
			_XXCF := "2901"
		ENDIF
		
		IF _XXcfop == "915"
			_XXTES :="303"
			_XXCCUSTO:="2022"
			_XXCF := "1915"
			IF _XXEST<>"5"
				_XXCF := "2915"
			ENDIF
		ENDIF
		
		IF _XXcfop == "924"
			_XXTES :="102"
			_XXCCUSTO:="2021"
			_XXCF := "1924"
			IF _XXEST<>"5"
				_XXCF := "2924"
			ENDIF
		ENDIF
		
		IF _XXcfop == "949"
			_XXTES :="401"
			_XXCCUSTO:="2021"
			_XXCF := "1949"
			IF _XXEST<>"5"
				_XXCF := "2949"
			ENDIF
		ENDIF
		
		Reclock("LS1",.T.)
		LS1->SEQ:=nTotIt
		LS1->CODBAR:=cCodbar
		LS1->PRODUTO:=cProd
		LS1->PRODFOR:=cProdFor
		LS1->CCUSTO:= _XXCCUSTO
		LS1->DESCRICAO:=UPPER(_cDescricao)
		LS1->DESCORI:=UPPER(_cDescricao)
		LS1->QUANTIDADE:=(nQuant*_nQE)
		LS1->CFOP  :=xCFOP
		LS1->PRECO:=_nPreco
		LS1->CUSTO:=_nCusto
		//	LS1->TES:=_XXTES
		LS1->NCM:=IIF(LEN(ALLTRIM(cNCM))>=8,SUBSTR(cNCM,1,10),"")
	  //	LS1->CST:=cCST
		LS1->PRECOFOR:=(nTotal/(nQuant*_nQE))
		LS1->TOTAL:=(nTotal-nDescont)
		IF alltrim(cProd)=="999999"
			LS1->OK:="X"
		Else
			IF 100-((_nPreco/_nCusto)*100)>10 .OR. 100-((_nPreco/_nCusto)*100)<-10
				LS1->OK:="O"
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
//Ё Cliente															Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectarea("SA1")
DbSetorder(1)
Dbgotop()
Dbseek(xFilial("SA1")+LS3->CLIENTE+LS3->LOJA)
If Found()
	_cxcliente:=SUBSTR(SA1->A1_NREDUZ,1,25)
	_cEnd:=ALLTRIM(SA1->A1_END)+" - "+SA1->A1_BAIRRO
	_cCidade:=ALLTRIM(SA1->A1_MUN)+"/"+SA1->A1_EST
	_cEmissao:=dtoc(stod(LS1->EMISSAO))
	_cCNPJ:=SA1->A1_CGC
	_cTelefone:=SA1->A1_TEL
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cliente															Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ABREPED()
DbSelectarea("SC7")
SET FILTER TO C7_FILIAL==xFilial("SC7") .AND. C7_NUM==LS2->PEDIDO
MATA121()
SET FILTER TO
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Confirma produto													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
	//Ё Dados do Clienter													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("SA1")
	DbSetorder(1)
	Dbgotop()
	Dbseek(xFilial("SA1")+LS3->CLIENTE+LS3->LOJA)
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Nomeclatura dos arquivos											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_cFileOri:="\xmlcli\"+ALLTRIM(LS3->XML)
	_cFileNew:="\xmlcli\"+ALLTRIM(SA1->A1_CGC)+"-nf"+ALLTRIM(LS3->NOTA)+"-"+ALLTRIM(LS3->CHAVE)+"xml.rec"
	
	FRename(_cFileOri,_cFileNew)
	__CopyFile("\xmlcli\*.rec","\xmlcli\recusadas\")
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Divergencias														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function DIVERG()

aCampos4:= {{"FLAG","C",1,0 },;
{"OK","C",15,0 },;
{"PRODUTO","C",15,0 },;
{"DESCRICAO","C",50,0 },;
{"PRCPED","N",9,2 },;
{"PRCNFE","N",9,2 },;
{"QTDPED","N",9,2 },;
{"QTDNFE","N",9,2 }}

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
	
	cQuery:=" SELECT COUNT(*) QTD,AVG(C7_PRECO) PRECO,SUM(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
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
		IF TCQ->QTD==0
			Reclock("LS4",.T.)
			LS4->PRODUTO:=PRO->PRODUTO
			LS4->DESCRICAO:=PRO->DESCRICAO
			LS4->PRCNFE:=round(PRO->PRECO,2)
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
			LS4->PRCPED:=round(TCQ->PRECO,2)
			LS4->PRCNFE:=round(PRO->PRECO,2)
			LS4->OK:="Quantidade"
			MsUnlock()
			If (round(PRO->PRECO,2)>round(TCQ->PRECO,2)) .AND. round(TCQ->PRECO,2)>0
				_nMaior:=_nMaior+(PRO->QUANTIDADE*(round(PRO->PRECO,2)-round(TCQ->PRECO,2)))
			Endif
			DbSelectarea("TCQ")
			DbSkip()
			Loop
		Endif
		If (round(PRO->PRECO,2)>round(TCQ->PRECO,2)) .AND. round(TCQ->PRECO,2)>0 .AND. TCQ->QUANT>0
			Reclock("LS4",.T.)
			LS4->PRODUTO:=PRO->PRODUTO
			LS4->DESCRICAO:=PRO->DESCRICAO
			LS4->PRCPED:=round(TCQ->PRECO,2)
			LS4->PRCNFE:=round(PRO->PRECO,2)
			LS4->QTDPED:=TCQ->QUANT
			LS4->QTDNFE:=PRO->QUANTIDADE
			LS4->OK:="Preco"
			MsUnlock()
			_nMaior:=_nMaior+(PRO->QUANTIDADE*(round(PRO->PRECO,2)-round(TCQ->PRECO,2)))
			DbSelectarea("TCQ")
			DbSkip()
			Loop
		Endif
		
		Reclock("LS4",.T.)
		LS4->PRODUTO:=PRO->PRODUTO
		LS4->DESCRICAO:=PRO->DESCRICAO
		LS4->PRCPED:=round(TCQ->PRECO,2)
		LS4->PRCNFE:=round(PRO->PRECO,2)
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
AADD(aTitulo4,{"PRCPED","R$ Pedido","@E 99,999.99"})
AADD(aTitulo4,{"PRCNFE","R$ Nota","@E 99,999.99"})
AADD(aTitulo4,{"QTDPED","Qtd.Pedido","@E 99,999.99"})
AADD(aTitulo4,{"QTDNFE","Qtd.Nota","@E 99,999.99"})

If !LS4->(eof())
	@ 120,040 TO 400,880 DIALOG oAmar TITLE "DivergЙncias encontradas..."
	@ 005,005 BUTTON "Sair" SIZE 55,10 ACTION oAmar:end()
	If _nMaior>0
		@ 005,100 say "Valor Total Excedido R$ "+Transform(_nMaior,"@E 99,999.99") FONT oFont1 OF oAmar PIXEL COLOR CLR_HRED
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
//Ё Envia email de nota recusada										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function EMAIL()

Local cSubject := "Nota fiscal "+cNota+" recusado o recebimento..."
Local cMsg      := ""
Local cAttach   := ""
Local aMsg      := {}
Local aUsrMail := {}
Local lConectou := .f.
LOCAL cACCOUNT := alltrim(getmv("MV_RELACNT"))
LOCAL cPASSWORD := alltrim(getmv("MV_RELPSW"))
LOCAL cSERVER   := alltrim(getmv("MV_RELSERV"))

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou

cMensagem := "Nota fiscal "+cNota+" recusado o recebimento devido algumas divergЙncias encontradas pelo comprador"+ chr(13)+chr(10)
cMensagem := cMensagem+ " Cliente:"+_cxcliente +"               CNPJ:"+_cCNPJ+ chr(13)+chr(10)
cMensagem := cMensagem+ " Data EmissЦo:"+_cEmissao+ chr(13)+chr(10)
cMensagem := cMensagem+ " Total da Nota Fiscal R$  "+alltrim(STR(nTotalNF,12,2))+ chr(13)+chr(10)
cMensagem := cMensagem+ chr(13)+chr(10)
cMensagem := cMensagem+ chr(13)+chr(10)
cMensagem := cMensagem+ "Caso tenha alguma dЗvida, entrar em contato com o comprador "+_cUsuario+ chr(13)+chr(10)
cMensagem := cMensagem+ chr(13)+chr(10)
cMensagem := cMensagem+ chr(13)+chr(10)
cMensagem := cMensagem+ "NOTA FISCAL DO "+SM0->M0_FILIAL+chr(13)+chr(10)
cMensagem := cMensagem+ chr(13)+chr(10)
cMensagem := cMensagem+ "EMAIL AUTOMаTICO ENVIADO PELO SISTEMA,FAVOR NцO RESPONDй-LO"

SEND MAIL FROM cACCOUNT TO xEMAILREC SUBJECT cSubject BODY cMensagem RESULT lEnviado

If !lEnviado
	cMensagem := ""
	GET MAIL ERROR cMensagem
	Alert(cMensagem)
Endif
DISCONNECT SMTP SERVER Result lDesConectou
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Seleciona produto													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function SELECIONA(_cProduto,lOpcao)

Local i := 0
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
	cQuery:=cQuery + " AND C7_FORNECE='"+LS3->CLIENTE+"' "
	cQuery:=cQuery + " AND (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 "
	cQuery:=cQuery + " AND C7_RESIDUO<>'S' "
	cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
	cQuery:=cQuery + " ORDER BY R_E_C_N_O_ DESC "
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectarea("TCQ")
	While !Eof()
		cMemo:=cMemo+DTOC(STOD(TCQ->EMISSAO))+"   "+TCQ->PEDIDO+"   "+TCQ->LOJA+"   "+ALLTRIM(STR(TCQ->QUANT,12,2))+"       "+transform(TCQ->PRECO,"@E 9,999.99")+CHR(13)+CHR(10)
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

If _nCaixas==0
	_nQuant:=_nQuantNF
	_nPreco:=(_nTotal/_nQuant)
Else
	_nQuant:=(_nQE*_nCaixas)
	_nPreco:=(_nTotal/_nQuant)
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Tela de parametros													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
lGravou:=.F.

cPict1:="@E 99,999."
For w:=1 to cDecQtd
	cPict1:=alltrim(cPict1)+"9"
Next

cPict2:="@E 99,999."
For w:=1 to cDecUni
	cPict2:=alltrim(cPict2)+"9"
Next

@ 120,040 TO 450,370 DIALOG oDef TITLE "Produto "+_cProduto
@ 005,005 say "Qtd.Emb."  FONT oFont1 OF oDef PIXEL
@ 015,005 get _nQE size 20,20 Picture "@E 9999" valid CALCULA()
@ 005,040 say "Cx.Nota"  FONT oFont1 OF oDef PIXEL
@ 015,040 get _nCaixas when .f. size 50,40 Picture cPict1
@ 005,100 say "Quantidade"  FONT oFont1 OF oDef PIXEL COLOR CLR_GREEN
@ 015,100 get _nQuant size 50,40 when .f. Picture cPict1

@ 025,005 say "PreГo R$"  FONT oFont1 OF oDef PIXEL COLOR CLR_GREEN
@ 035,005 get _nPreco size 50,40 WHEN .F. Picture cPict2
@ 025,055 say "Total R$"  FONT oFont1 OF oDef PIXEL
@ 035,055 get _nTotal when .f. size 50,40 Picture "@E 99,999.99"

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


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Gravando produto...													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
	Else
		LS1->OK:=""
	Endif
	LS1->PRODUTO:=_cProduto
	LS1->DESCRICAO:=LS4->DESCRICAO
	LS1->ALTERADO:="S"
	LS1->CAIXAS:=_nCaixas
	LS1->QUANTIDADE:=_nQuant
	LS1->PRECOFOR:=_nPreco
	LS1->PRECO:=(LS1->TOTAL/_nQuant)
	LS1->CUSTO:=_nCusto
	LS1->QE:=_nQE
	MsUnlock()
	
	DbSelectarea("LS5")
	Reclock("LS5",.T.)
	LS5->PRODUTO:=_cProduto
	MsUnlock()
Else
	DbSelectarea("LS1")
	Reclock("LS1",.F.)
	LS1->ALTERADO:="S"
	IF 100-((_nPrecoA/_nCusto)*100)>10 .OR. 100-((_nPrecoA/_nCusto)*100)<-10
		LS1->OK:="O"
	Else
		LS1->OK:=""
	Endif
	LS1->CAIXAS:=_nCaixas
	LS1->QUANTIDADE:=_nQuant
	LS1->PRECOFOR:=_nPreco
	LS1->PRECO:=(LS1->TOTAL/_nQuant)
	LS1->CUSTO:=ULTPED(LS1->PRODUTO)
	LS1->QE:=_nQE
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Filtrar produtos													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
	
	cQuery:=" SELECT B1_MSBLQL BLQ,B1_CODBAR CODBAR,B1_COD PRODUTO,B1_DESC DESCRICAO FROM "+ RetSqlName("SB1")+" "
	cQuery:=cQuery + " 	WHERE B1_FILIAL='"+xFilial("SB1")+"' AND ( B1_DESC LIKE '"+_cDescp1+"' OR B1_COD LIKE '"+alltrim(_cDescp1)+"') "
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
		If cPedCom
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Calcula produto														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CALCULA()

If _nCaixas==0
	_nQuant:=_nQuantNF
	_nPreco:=(_nTotal/_nQuant)
Else
	_nQuant:=(_nQE*_nCaixas)
	_nPreco:=(_nTotal/_nQuant)
Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Calcula produto														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function TEMPED(_cProduto)

cQuery:=" SELECT COUNT(*) QTD FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
cQuery:=cQuery + " AND C7_PRODUTO='"+alltrim(TCQ->PRODUTO)+"' "
cQuery:=cQuery + " AND C7_FORNECE='"+LS3->CLIENTE+"' "
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Refazer Nota fiscal													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function REFAZER()

cResp:=msgbox("Deseja refazer toda a nota fiscal?","AtenГЦo...","YESNO")

If cResp
	PROCESS()
Endif
Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁLERXML    ╨Autor  ЁVictor Dessunte     ╨ Data Ё  05/03/16   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRecebendo email automaticamente                             ╨╠╠
╠╠╨          ЁAlterado de POP3 para IMAP                                  ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Masipack                                                   ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function POPEMAIL()

Local _nErro		:= 0
Local _nTotMsg		:= 0
Local _nX			:= 0
Local _nI			:= 0
Local _sErro		:= ""
Local _oMailManager := Nil
Local _oMailMessage := Nil

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
				If _oMessage:SaveAttach(_nX,GetSrvProfString( "RootPath", "" )+'\xmlcli\'+_oMessage:GetAttachInfo(_nX)[1])
					_oMailManager:DeleteMsg(_nI)
				EndIf
			EndIf
		Next _nX
	EndIf
Next

_oMailManager:IMAPDisconnect()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Excluir amarracao													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function EXCAMA()

If Empty(LS1->OK) .OR. LS1->OK=="O"
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
		//Ё Excluindo da tabela amarracao produto x xcliente					Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("SA7")
		DbSetorder(1)
		Dbgotop()
		Dbseek(xFilial("SA7")+LS3->CLIENTE+LS3->LOJA+LS1->PRODUTO)
		If Found()
			Reclock("SA7",.F.)
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
Static Function ULTPED(_cProduto)
_nPedido:=0
_nQtd:=1

cQuery:=" SELECT C7_PRECO PRECO FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' AND C7_PRODUTO='"+alltrim(_cProduto)+"' AND C7_FORNECE='"+LS3->CLIENTE+"' AND C7_PRECO>0 AND D_E_L_E_T_<>'*' ORDER BY C7_EMISSAO DESC "
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Eliminar pedido														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ELIMINAR()

IF (DDATABASE-LS2->EMISSAO)<=30
	msgbox("O pedido tem que ter mais de 30 dias de vencimento!")
	Return
Endif

IF LS2->OK<>"X"
	cResp:=msgbox("Deseja eliminar o resМduo do pedido "+LS2->PEDIDO+"?","AtenГЦo...","YESNO")
	
	If cResp
		lEntrou:=.F.
		DbSelectarea("SC7")
		DbSetorder(1)
		dbgotop()
		Dbseek(xFilial("SC7")+LS2->PEDIDO)
		While !Eof() .and. ALLTRIM(SC7->C7_NUM)==ALLTRIM(LS2->PEDIDO)
			IF SC7->C7_QTDACLA<=0
				IF SC7->C7_RESIDUO<>"S" .and. (SC7->C7_QUANT-SC7->C7_QUJE)>0
					Reclock("SC7",.F.)
					SC7->C7_RESIDUO:="S"
					MsUnlock()
					lEntrou:=.T.
					
					DbSelectarea("SB2")
					DbSetorder(2)
					Dbgotop()
					Dbseek(xFilial("SB2")+SC7->C7_LOCAL+SC7->C7_PRODUTO)
					If Found()
						Reclock("SB2",.F.)
						SB2->B2_SALPEDI:=(SB2->B2_SALPEDI-(SC7->C7_QUANT-SC7->C7_QUJE))
						MsUnlock()
					Endif
				Endif
			Endif
			DbSelectarea("SC7")
			Dbskip()
		End
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Apagando pedido do browse											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lEntrou
			DbSelectarea("LS2")
			Reclock("LS2",.F.)
			dbdelete()
			MsUnlock()
			dbgobottom()
			Msgbox("Pedido eliminado com sucesso!","AtenГЦo...","INFO")
		Endif
	Endif
Else
	Msgbox("Este pedido nЦo pode ser eliminado!","AtenГЦo...","ALERT")
Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Mensagem nota fiscal												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
{ 'BR_AZUL',"PreГo diferente em 10%" }}
BrwLegenda(_cLegenda,"Status do Produto",aCorLegen)
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao Consulta SEFAZ												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function SEFAZ()
cChave:=  "https://nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx?=completa&chaveacesso="+ALLTRIM(LS3->CHAVE)
// cChave:=  "http://www.nfe.fazenda.gov.br/portal/consulta.aspx?tipoconsulta=completa&chaveacesso="+ALLTRIM(LS3->CHAVE)
//cChave:="https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx?tipoConsult=completa&chaveacesso="+ALLTRIM(LS3->CHAVE)
//  cChave:="http://www.nfe.fazenda.gov.br/PORTAL/consulta.aspx?tipoConsulta=completa&chaveacesso="+ALLTRIM(LS3->CHAVE)

//cChave:="https://www.nfe.fazenda.gov.br/PORTAL/consulta.aspx?tipoConsulta=completa&tipoConteudo="+ALLTRIM(LS3->CHAVE)


//     http://nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx
//cChave:=  "http://www.nfe.fazenda.gov.br/portal/consulta.aspx?tipoconsulta=completa&chaveacesso="+ALLTRIM(LS3->CHAVE)
ShellExecute("open",cChave,"","",0)
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
//Ё Geracao NDF xcliente												Ё
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
SE2->E2_FORNECE := LS3->CLIENTE
SE2->E2_LOJA    := LS3->LOJA
SE2->E2_VALOR   := _nExcedido
SE2->E2_SALDO   := _nExcedido
SE2->E2_VLCRUZ  := _nExcedido
If lItem==.F.
	SE2->E2_NOMFOR  := POSICIONE("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS2->LOJA,"A1_NREDUZ")
Else
	SE2->E2_NOMFOR  := POSICIONE("SA1",1,xFilial("SA1")+LS3->CLIENTE+LS3->LOJA,"A1_NREDUZ")
Endif
SE2->E2_ORIGEM  := "LERXML"
MsUnlock()
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valor NDF do xcliente												Ё
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
		If (round(LS1->PRECO,2)>TCQ->PRECO) .AND. Round(TCQ->PRECO,2)>0
			_nExcedido:=_nExcedido+(LS1->QUANTIDADE*(round(LS1->PRECO,2)-Round(TCQ->PRECO,2)))
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
				If UPPER(SUBSTR(cBuffer,1,4))==SM0->M0_CODIGO+SM0->M0_CODFIL
					_lSerie:=ALLTRIM(SUBSTR(cBuffer,6,3))
				Endif
				If UPPER(SUBSTR(cBuffer,1,5))=="S"+SM0->M0_CODIGO+SM0->M0_CODFIL
					_lAlmox:=ALLTRIM(SUBSTR(cBuffer,7,2))
				Endif
				If UPPER(SUBSTR(cBuffer,1,9))=="EMAIL"+SM0->M0_CODIGO+SM0->M0_CODFIL
					_lEmail:=ALLTRIM(SUBSTR(cBuffer,11,300))
				Endif
				If UPPER(SUBSTR(cBuffer,1,5))=="P"+SM0->M0_CODIGO+SM0->M0_CODFIL
					_lPedido:=ALLTRIM(SUBSTR(cBuffer,7,2))
				Endif
				If UPPER(SUBSTR(cBuffer,1,7))=="ESP"+SM0->M0_CODIGO+SM0->M0_CODFIL
					_lEspecie:=ALLTRIM(SUBSTR(cBuffer,9,5))
				Endif
				If UPPER(SUBSTR(cBuffer,1,10))=="DECQTD"+SM0->M0_CODIGO+SM0->M0_CODFIL
					_lDecQtd:=val(ALLTRIM(SUBSTR(cBuffer,12,5)))
				Endif
				If UPPER(SUBSTR(cBuffer,1,10))=="DECUNI"+SM0->M0_CODIGO+SM0->M0_CODFIL
					_lDecUni:=val(ALLTRIM(SUBSTR(cBuffer,12,5)))
				Endif
				FT_FSKIP()
			EndDo
			FT_FUSE()
		Endif
		
		Reclock("LS1",.T.)
		LS1->EMPRESA:=SM0->M0_CODIGO
		LS1->FILIAL:=SM0->M0_CODFIL
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
	@ 030,135 say "NDF Cliente?" SIZE 150,40 FONT oFont6 OF oConfig PIXEL COLOR CLR_HRED
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
	cr:=chr(13)+chr(10)
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
//Ё Codigo de barra														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CODBAR()

cCodbar:=''

If !Empty(LS1->CODBAR)
	cCodbar:=alltrim(cCodbar)+"CсDIGO BARRA DO XML"+chr(13)+chr(10)
	cCodbar:=alltrim(cCodbar)+alltrim(LS1->CODBAR)+chr(13)+chr(10)
	cCodbar:=alltrim(cCodbar)+chr(13)+chr(10)
Endif

If ALLTRIM(LS1->PRODUTO)<>"999999"
	DbSelectarea("SB1")
	DbSetorder(1)
	Dbgotop()
	Dbseek(xFilial("SB1")+LS1->PRODUTO,.t.)
	If Found()
		cCodbar:=alltrim(cCodbar)+"CADASTRO DE PRODUTO"+chr(13)+chr(10)
		cCodbar:=alltrim(cCodbar)+alltrim(SB1->B1_CODBAR)+chr(13)+chr(10)
		cCodbar:=alltrim(cCodbar)+chr(13)+chr(10)
	Endif
	
	DbSelectarea("SLK")
	DbSetorder(2)
	Dbgotop()
	Dbseek(xFilial("SLK")+LS1->PRODUTO,.t.)
	If Found()
		cCodbar:=alltrim(cCodbar)+"CADASTRO ALTERNATIVO"+chr(13)+chr(10)
		DbSelectarea("SLK")
		DbSetorder(2)
		Dbgotop()
		Dbseek(xFilial("SLK")+LS1->PRODUTO,.t.)
		While !Eof() .and. ALLTRIM(SLK->LK_CODIGO)==ALLTRIM(LS1->PRODUTO)
			cCodbar:=alltrim(cCodbar)+alltrim(SLK->LK_CODBAR)+chr(13)+chr(10)
			Dbskip()
		End
	Endif
Endif

If !Empty(cCodbar)
	Msgbox(cCodbar,"AtenГЦo...","INFO")
Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Desbloquear															Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
//Ё Incluir Produto															Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function Incprod()

cResp0=msgbox("Deseja Incluir o produto ???","AtenГЦo...","YESNO")

If cResp0
	msgbox("O Produto foi Cadastrado  com sucesso!","AtenГЦo...","INFO")
Endif
Return




//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Historico do Cliente												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function HISTFOR()

cCadastro :='Historico Cliente'

aRotina2  := { {"Perdas","U_PR_PERD()",0,2},;
{"Trocas Produtos","U_PR_TRO()",0,2},;
{"DivergЙncias Pedidos","U_PR_DIV()",0,2},;
{"Pedidos com cortes","U_PR_COR()",0,2},;
{"Pedidos NЦo Entregues","U_PR_NAO()",0,2},;
{"Saldos por Grupo","U_PR_SALG()",0,2}}

aRotina   := {  {"Pesquisar","AxPesqui",0,1},;
{"Comprar"      , "U_PR_COM()",0,8},;
{"Totalizar"    , "U_PR_TOT()",0,3},;
{"Gerar Pedidos" , "U_PR_PED()",0,8},;
{"F4-HistСrico"    , "U_PR_HIS()",0,8},;
{"Consultas"	,aRotina2        ,0,2,0 ,NIL},;
{"SugestЦo"     , "U_PR_SUG()",0,6},;
{"PreГo FamМlia", "U_PR_FAM()",0,7},;
{"Incluir Produto", "U_PR_INCP()",0,7},;
{"Fora de Linha", "U_PR_FORL()",0,7},;
{"Legenda"      , 'U_PR_LEG()', 0 , 9}}

Pergunte("FIC030",.T.)
ALTERA:=.T.
INCLUI:=.F.
NVLGERALNF:=0
LF030TITAB:=.F.
LF030TITPG:=.F.
FC030CON(LS3->CLIENTE,LS3->LOJA)
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
{"QUANTIDADE","N",12,3 },;
{"PRECO","N",18,2 },;
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
cQuery:=cQuery + " AND C7_FORNECE='"+LS3->CLIENTE+"' "
cQuery:=cQuery + " AND C7_LOJA='"+LS3->LOJA+"' "
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
	@ 005,005 say "Quantidade NecessАria "+Transform(LS1->QUANTIDADE,"@E 99,999.99")+"      PreГo R$ "+Transform(LS1->PRECO,"@E 99,999.99") FONT oFont1 OF oPedido PIXEL COLOR CLR_HRED
	@ 015,005 TO 140,255 BROWSE "LS2" ENABLE " LS2->OK<>'X' " OBJECT OBRWT FIELDS aTitulo2
	OBRWT:oBrowse:oFont := TFont():New ("Arial", 05, 18)
	OBRWT:OBROWSE:bLDblClick   := {||CONFPED()}
	@ 145,005 BUTTON "Atualizar Pedido" SIZE 65,10 ACTION ATUPED()
	@ 145,075 BUTTON "Eliminar do pedido" SIZE 65,10 ACTION ELIRPRO()
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
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CONFPED()

If (LS1->QUANTIDADE>LS2->QUANTIDADE)
	Msgbox("NЦo existe saldo suficiente para atender este produto!","AtenГЦo...","ALERT")
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Gravando CRIAR nos produtos sem pedidos de compras em aberto		Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	SEMPED()
	oPedido:end()
	Return
Endif

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
	IF Empty(LS1->PEDIDO)
		cQuery:=" SELECT C7_ITEM ITEM,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
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
			
			IF (LS1->QUANTIDADE<=(TCQ->QUANT-_nUsados))
				Reclock("LS1",.F.)
				LS1->PEDIDO:=LS2->PEDIDO
				LS1->ITEM:=TCQ->ITEM
				LS1->ALTERADO:="S"
				MsUnlock()
			Endif
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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Eliminar pedido														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ELIRPRO()

cResp:=msgbox("Deseja eliminar o resМduo deste item do pedido "+LS2->PEDIDO+"?","AtenГЦo...","YESNO")

If cResp
	DbSelectarea("SC7")
	DbSetorder(1)
	dbgotop()
	Dbseek(xFilial("SC7")+LS2->PEDIDO)
	While !Eof() .and. ALLTRIM(SC7->C7_NUM)==ALLTRIM(LS2->PEDIDO)
		IF alltrim(SC7->C7_PRODUTO)==alltrim(LS1->PRODUTO) .AND. LS2->ITEM==SC7->C7_ITEM
			IF SC7->C7_QTDACLA>0
				Msgbox("Este produto estА sendo usado em prИ nota fiscal!","AtenГЦo...","ALERT")
				Return
			Endif
			
			IF SC7->C7_RESIDUO<>"S" .and. (SC7->C7_QUANT-SC7->C7_QUJE)>0
				Reclock("SC7",.F.)
				SC7->C7_RESIDUO:="S"
				MsUnlock()
				
				DbSelectarea("SB2")
				DbSetorder(2)
				Dbgotop()
				Dbseek(xFilial("SB2")+SC7->C7_LOCAL+SC7->C7_PRODUTO)
				If Found()
					Reclock("SB2",.F.)
					SB2->B2_SALPEDI:=(SB2->B2_SALPEDI-(SC7->C7_QUANT-SC7->C7_QUJE))
					MsUnlock()
				Endif
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Apagando pedido do browse											Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectarea("LS2")
				Reclock("LS2",.F.)
				dbdelete()
				MsUnlock()
				dbgotop()
				Msgbox("ResМduo eliminado com sucesso!","AtenГЦo...","INFO")
			Endif
		Endif
		DbSelectarea("SC7")
		Dbskip()
	End
Endif
Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Alterar Pedido												 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ATUPED()

IF LS1->QUANTIDADE<=LS2->QUANTIDADE
	Msgbox("NЦo И necessАrio atualizar este pedido!","AtenГЦo...","ALERT")
	Return
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ajustando o pedido com a nota										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cResp:=msgbox("Deseja atualizar o pedido "+LS2->PEDIDO+" com a quantidade que falta?","AtenГЦo...","YESNO")

If cResp
	lEntrou:=.F.
	_nQtdIt:=0
	
	DbSelectarea("SC7")
	DbSetorder(4)
	Dbgotop()
	Dbseek(xFilial("SC7")+LS1->PRODUTO+LS2->PEDIDO+LS2->ITEM)
	If Found() .AND. (SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA)<LS1->QUANTIDADE
		_nTotal:=LS1->QUANTIDADE-(SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA)
		
		Reclock("SC7",.F.)
		SC7->C7_QUANT:=(SC7->C7_QUANT+_nTotal)
		SC7->C7_OBS+="ALTERADO NF-ELETRONICA"
		MsUnlock()
		
		Reclock("SC7",.F.)
		SC7->C7_TOTAL:=(SC7->C7_QUANT*SC7->C7_PRECO)
		MsUnlock()
		
		If Empty(cAlmox)
			cAlmox:=Posicione("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_LOCPAD")
		Endif
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Atualizado SB2 saldo de pedidos										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("SB2")
		DbSetorder(2)
		Dbgotop()
		Dbseek(xFilial("SB2")+cAlmox+LS1->PRODUTO)
		If Found()
			Reclock("SB2",.F.)
			SB2->B2_SALPEDI:=(SB2->B2_SALPEDI+_nTotal)
			MsUnlock()
		Endif
		lEntrou:=.T.                                       	
	Endif
	
	If lEntrou
		Msgbox("Pedido atualizado com sucesso!","AtenГЦo...","INFO")
		Reclock("LS2",.F.)
		LS2->QUANTIDADE:=LS1->QUANTIDADE
		LS2->OK:="X"
		Msunlock()
	Endif
Endif
DbSelectarea("LS2")
Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Verificando produto sem pedido de compras da nota			 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function SEMPED()

cSeqori:=LS1->SEQ

DbSelectarea("LS1")
Dbgotop()
While !Eof()
	cSeq:=LS1->SEQ
	
	IF Empty(LS1->PEDIDO) .AND. ALLTRIM(LS1->PRODUTO)<>"999999"
		lEntrou:=.F.
		cQuery:=" SELECT C7_NUM PEDIDO,C7_ITEM ITEM,(C7_QUANT-C7_QUJE-C7_QTDACLA) QUANT FROM SC7"+SM0->M0_CODIGO+"0 WHERE C7_FILIAL='"+xFilial("SC7")+"' "
		cQuery:=cQuery + " AND C7_FORNECE='"+LS3->CLIENTE+"' "
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
		If lEntrou==.F.
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


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processando arquivos												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function XMLcgccl(i)

private _oXml    := NIL
private cError    := ''
private cWarning := ''
nXmlStatus := XMLError()
cFile:="\xmlcli\"+lower(ALLTRIM(aXML[i]))
oXml := XmlParserFile(cFile,"_",@cError, @cWarning )
lTipo:=3

If ALLTRIM(TYPE("oxml:_NFE:_INFNFE"))=="O"
	lTipo:=1
Endif

If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE"))=="O"
	lTipo:=2
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
		XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
		IF XXVERSAO=="2"
			cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
		ELSE
			cEmissao:=substr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
		ENDIF
		
		
		cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
		cChave:=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,200))
	ENDIF
ENDIF
RETURN(_cCNPJ2)  

Static Function cadtest()   
Local cCPT   		:= ""
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
		DBSELECTAREA("SB1")
		DBSETORDER(3)
	
		If DBSEEK(xFilial("SB1")+ALLTRIM(LS1->DESCRICAO))
			If LS1->DESCRICAO == B1_DESC
				Reclock("LS1",.F.)
				LS1->PRODUTO := SB1->B1_COD  
				MsUnlock()
	    		LS1->(DBSKIP())
	    		LOOP
		    EndIf
		EndIf 
		If Select("TP1") > 0 
   			DbSelectArea("TP1")
   			DbCloseArea()
		EndIf  

		cQuery := " SELECT B1_COD AS CODIGO "
		cQuery += " FROM " + RetSqlName("SB1") + " SB1 "
		cQuery += " WHERE SB1.D_E_L_E_T_='' "
		cQuery += " AND B1_FILIAL='" + xFilial("SB1") + "' " 
		cQuery += " AND SUBSTRING(B1_COD,1,3) IN ('PT8')  "
		cQuery += " ORDER BY B1_COD DESC "    
		
   	TCQUERY cQuery NEW ALIAS "TP1"
		If !TP1->(EOF())    
			TP1->(DBGOTOP())
			cCPT   := SUBSTR(TP1->CODIGO,3,13)
			cCSoma := VAL(cCPT)+1
			cCPT   :="PT"+ALLTRIM(STR(cCSoma))
		Else
			cCPT   :="PT8000000000001"	
		EndIf 
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		//Ivandro Santos - 29/08/17 - Inicio da alteraГЦo - Ticket#2017082937000108 ≈ PRODUTO TESTE
		_aFisProd := GetAdvFval("SYD",{"YD_PER_IPI","YD_ICMS_RE","YD_BICMS"},xFilial("SYD")+LS1->NCM,1," ")
		If SubStr(cNumEmp,1,2) $ "01_10" 
			/*U_MSVALPRO(cCPT,@aProd,"","","","IN","",LS1->DESCRICAO,"2N",LS1->NCM)
				aadd(aItensProd,aProd)
			Endif
			aadd(_aDadoAdic,"OI")
			aadd(_aDadoAdic,"207")
			aadd(_aDadoAdic,"N")
			aadd(_aDadoAdic,"N")
			aadd(_aDadoAdic,"2")
			cprod := U_MSGERAB1(cCPT,aProd,_aFisProd,_aDadoAdic)*/
			
			Reclock("SB1",.T.)
			SB1->B1_FILIAL  := xFilial("SB1")
			SB1->B1_COD  	:= cCPT 
			SB1->B1_LOCPAD 	:= "10"
			SB1->B1_DESC 	:= LS1->DESCRICAO
			SB1->B1_TIPO 	:= "OI"
			SB1->B1_UM   	:= IIF(LS1->UM=="MI","MH",LS1->UM)  //Ticket#2017082237000095 ≈ Produtos com unidade de medidas MI (Milheiro)
			SB1->B1_CC   	:= "207" 
			SB1->B1_PROCED  := "2N" 
			SB1->B1_POSIPI  := LS1->NCM 
			SB1->B1_MSCERT 	:= "N" 
			SB1->B1_MSCONF 	:= "N" 
			SB1->B1_GARANT  := "N" 
			SB1->B1_MSGRVEN := "IN" 
			SB1->B1_ORIGEM  :=	"0"//SUBSTR(LS1->CST,1,2) 
			SB1->B1_IPI		:= _aFisProd[1]
			
	 		MsUnlock()
	   Else
	   	Reclock("SB1",.T.)
			SB1->B1_FILIAL  := xFilial("SB1")
			SB1->B1_COD  	:= cCPT 
			SB1->B1_LOCPAD 	:= "10"
			SB1->B1_DESC 	:= LS1->DESCRICAO
			SB1->B1_TIPO 	:= "OI"
			SB1->B1_UM   	:= IIF(LS1->UM=="MI","MH",LS1->UM)  //Ticket#2017082237000095 ≈ Produtos com unidade de medidas MI (Milheiro)
			SB1->B1_CC   	:= "207" 
			SB1->B1_PROCED  := "2N" 
			SB1->B1_POSIPI  := LS1->NCM 
			SB1->B1_MSCERT 	:= "N" 
		//SB1->B1_MSCONF 	:= "N" 
			SB1->B1_GARANT  := "N" 
			SB1->B1_MSGRVEN := "IN"  
			SB1->B1_ORIGEM :=	"0"//SUBSTR(LS1->CST,1,2)
			SB1->B1_IPI		:= _aFisProd[1]
	 		//Ticket#2017082937000108 ≈ Fim da alteraГЦo
	 		MsUnlock()
		EndIf
		DBSELECTAREA("LS1")
		
	   	Reclock("LS1",.F.)
		LS1->OK:=""
		LS1->PRODUTO:=cCPT 
		MsUnlock()
		If !Empty(LS1->PRODFOR)
			DbSelectarea("SA7")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA7")+LS3->CLIENTE+LS3->LOJA+LS1->PRODUTO)
			If !Found()
				Reclock("SA7",.T.)
				SA7->A7_FILIAL:=xFilial("SA7")
				SA7->A7_CLIENTE:=LS3->CLIENTE
				SA7->A7_LOJA:=LS3->LOJA
				SA7->A7_CODCLI:=LS1->PRODFOR
				SA7->A7_PRODUTO:=LS1->PRODUTO
				SA7->A7_DESCCLI:=SUBSTR(POSICIONE("SB1",1,xFilial("SB1")+LS1->PRODUTO,"B1_DESC"),1,30)
				MsUnlock()
			Else
				Reclock("SA7",.F.)
				SA7->A7_CODCLI:=LS1->PRODFOR
				MsUnlock()
			Endif
		EndIf
	
	EndIf	
	LS1->(DBSKIP())
EndDo   

If Select("TP1") > 0 
   	DbSelectArea("TP1")
	DbCloseArea()
EndIf
cResp1:=msgbox("Deseja gerar as etiquetas ?","AtenГЦo...","YESNO")
If cResp1
	GeraEtiqu()
EndIf
  

Return  
Static Function GeraEtiqu()

	_cEXE2  := "cmd /c net use lpt1: /delete"
	WaitRun(_cEXE2)// Deleta mapeamento LPT1
	 
	If cResp1:=msgbox("Impressora LPT1?","AtenГЦo...","YESNO") 
		MSCBPRINTER("OS 214","LPT1",NIL,)
	Else
		MSCBPRINTER("OS 214","COM1",NIL,)	
	EndIf   
	MSCBCHKSTATUS(.F.)

	LS1->(dbGoTop())
	DO WHILE !LS1->(EOF())
		
		MSCBBEGIN(1,4)   
	   
		MSCBSAY(05,03,"NF:"+ LS3->NOTA,"B","2","01,01") 
		MSCBSAY(09,03,"Cod.Cli:" + LS3->CLIENTE,"B","2","01,01")
		MSCBSAY(13,03,"Cliente:" + SUBSTR(LS3->NOME,1,22),"B","2","01,01")
		MSCBSAY(17,03,"Produto:" + LS1->PRODUTO    ,"B","2","01,01")   
		MSCBSAY(21,03,"Desc:"    + SUBSTR(LS1->DESCRICAO,1,22) ,"B","2","01,01")
		MSCBSAY(25,03,"Quant:" + TRANSFORM(LS1->QUANTIDADE, "@E 999,999,999.99999")    ,"B","2","01,01")
			
		LS1->(dbSkip())
		IF !LS1->(EOF())
		    
		    
		    MSCBSAY(35,03,"NF:"+ LS3->NOTA,"B","2","01,01") 
	  		MSCBSAY(39,03,"Cod.Cli:" + LS3->CLIENTE,"B","2","01,01")
	  		MSCBSAY(43,03,"Cliente:" + SUBSTR(LS3->NOME,1,22),"B","2","01,01")
	  		MSCBSAY(47,03,"Produto:" + LS1->PRODUTO    ,"B","2","01,01")   
	  		MSCBSAY(51,03,"Desc:"    + SUBSTR(LS1->DESCRICAO,1,22) ,"B","2","01,01")
	  		MSCBSAY(55,03,"Quant:" + TRANSFORM(LS1->QUANTIDADE, "@E 999,999,999.99999")    ,"B","2","01,01")   
		
				 
			LS1->(dbSkip())
			IF !LS1->(EOF())
				
				MSCBSAY(65,03,"NF:"+ LS3->NOTA,"B","2","01,01") 
	  			MSCBSAY(69,03,"Cod.Cli:" + LS3->CLIENTE,"B","2","01,01")
	  			MSCBSAY(73,03,"Cliente:" + SUBSTR(LS3->NOME,1,22),"B","2","01,01")
	 			MSCBSAY(77,03,"Produto:" + LS1->PRODUTO    ,"B","2","01,01")   
	 			MSCBSAY(81,03,"Desc:"    + SUBSTR(LS1->DESCRICAO,1,22) ,"B","2","01,01")
	   			MSCBSAY(85,03,"Quant:" + TRANSFORM(LS1->QUANTIDADE, "@E 999,999,999.99999")    ,"B","2","01,01")
		
					
				LS1->(dbSkip())
			ELSE
				MSCBEND() //Fim da Imagem da Etiqueta
				EXIT
			ENDIF
		ELSE
			MSCBEND() //Fim da Imagem da Etiqueta
			EXIT
		ENDIF
		MSCBEND() //Fim da Imagem da Etiqueta
	ENDDO
	
	MSCBEND() //Fim da Imagem da Etiqueta
	
	MSCBCLOSEPRINTER()
	


RETURN

