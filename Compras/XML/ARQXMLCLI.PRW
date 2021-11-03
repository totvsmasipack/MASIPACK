#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#Include "Xmlxfun.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "shell.ch"
#include "apwizard.ch"
#DEFINE ENTER CHR(13)+CHR(10)

#IFDEF WINDOWS
#ENDIF

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁARQXML    ╨Autor  ЁHracio  ╨ Data Ё  09/05/12   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁArquivamento de XML						                  ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/ 

User Function ARQXMLCLI()
Local aDirEmp	:= {{"01","\xmlcli\ArquivaMasipack","Masipack"},;
					{"10","\xmlcli\ArquivaFabrima","Fabrima"},;
					{"15","\xmlcli\ArquivaHelsimplast","Helsimplast"}}
	_cEmpresa:=SM0->M0_CODIGO
	_cCorrente:=SM0->M0_CODFIL

	DbSelectarea("SM0")
	Dbsetorder(1)
	Dbgotop()
	Dbseek(_cEmpresa+_cCorrente)

	_cEmpresa:=SM0->M0_CODIGO
	_cCorrente:=SM0->M0_CODFIL

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Controle de validade do programa									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	/*If DDATABASE>STOD(_dDtVenc) .OR. DATE()>STOD(_dDtVenc)
	msgbox("PROGRAMA EXPIRADO, FAVOR LEGALIZAR!")
	Return
	Endif*/

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica data do sistema											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If DATE()<>DDATABASE
		Msgbox("Problema na database do sistema!")
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Fontes Utilizadas											  						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DEFINE FONT oFont1 NAME "Courier New" SIZE 13,15
	DEFINE FONT oFont2 NAME "Arial" SIZE 5,18
	DEFINE FONT oFont3 NAME "Courier New" SIZE 6,18                         

	DEFINE FONT oFont4 NAME "Arial Black" SIZE 12,15

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica estrutura da tabela									 					Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If TcCanOpen("ARQXML")
		DbUseArea(.T.,"TOPCONN","ARQXML","ARQ",.T.,.F.)
		DbSelectarea("ARQ")
		nFields:=FCOUNT()
		DbClosearea("ARQ")

		If nFields<>10
			TCDelFile("ARQXML")
		Endif
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Criando Tabela para controle dos arquivos XML								Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !TcCanOpen("ARQXML")
		aCampos:= {{"TIPO","C",3,0 },;
		{"EMPFIL","C",4,0 },;
		{"FORNEC","C",6,0 },;
		{"LOJA","C",2,0 },;
		{"NOTA","C",9,0 },;
		{"EMISSAO","D",8,0 },;
		{"VALOR","N",12,2 },;
		{"CHAVE","C",44,0 },;
		{"ARQ","C",200,0 },;
		{"NATOP","C",100,0 }}
		DbCreate("ARQXML",aCampos,"TOPCONN")
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando registros corrompidos													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cQuere:=" DELETE FROM ARQXML WHERE (TIPO='' OR EMPFIL='' OR FORNEC='' OR LOJA='' OR NOTA='' OR EMISSAO='' OR VALOR='' OR CHAVE='' OR ARQ='') "
	TCSQLEXEC(cQuere)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Criando Diretorios													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cStartPath:= GetSrvProfString("Rootpath","")+"\xmlcli\"

	IF !File("\xmlcli")
		MakeDir(Trim(cStartPath))
	Endif
	nRet := Ascan(aDirEmp,{|x|x[1]==_cEmpresa})
	aArqxEmp := StrToKarr(aDirEmp[nRet][2],"\")
	IF !File(aDirEmp[nRet][2])
		msgbox("NЦo existe o diretСrio "+aArqxEmp[2]+" no diretСrio \xmlcli")
		Return
	Else
		IF !File(aDirEmp[nRet][2]+"\removidos")
			MakeDir(Trim(cStartPath)+aDirEmp[nRet][2]+"\removidos\")
		Endif
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Configuracao do Email												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cArqcfg:=aDirEmp[nRet][2]+"\contaxml.txt"
	_cUsuario:=ALLTRIM(UPPER(SUBSTR(CUSUARIO,7,15)))
	_cEmpFil:=ALLTRIM(SM0->M0_CODIGO)+ALLTRIM(SM0->M0_CODFIL)
	_cCCNPJ:=SM0->M0_CGC
	lFiltro2:=.F.
	lFiltro3:=.F.

	cSMTP:=Space(200)
	cPOP:=Space(200)
	cCONTA:=space(200)
	_cSenha:=Space(30)
	cSenXML:=Space(10)
	cEMAXML:=space(200)
	cMSGXML:=Space(200)
	cCCXML:=space(100)
	cURL:=space(150)
	cNF01:="NF/NFE/SPED"
	cNF02:="NFPS/NFS/NFSC/NFST/NTSC/NTST"
	cNF03:="CTA/CTE/CTF/CTR"

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Editar Configuracoes												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If File(cArqcfg) .and. _cUsuario=="ADMINISTRADOR"
		cResp:=Msgbox("Deseja Editar as configuraГУes do Email?","AtenГЦo...","YESNO")

		If cResp
			LENDO()
			CFGXML()

			cResp:=msgbox("Deseja Prosseguir com a execuГЦo?","AtenГЦo...","YESNO")
			If !cResp
				Return
			Endif
		Endif
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Lendo Configuracao													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !File(cArqcfg)
		CFGXML()
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Lendo Arquivo de Configuracao										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !File(cArqcfg)
		Return
	Endif

	LENDO()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Criando Email para o workflow se nao tiver							Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	lWork:=.F.
	DbSelectarea("WF7")
	Dbgotop()
	While !Eof()
		lWork:=.T.
		Dbskip()
	End

	If !lWork
		DbSelectarea("WF7")
		Reclock("WF7",.T.)
		WF7->WF7_FILIAL:=xFilial("WF7")
		WF7->WF7_PASTA:="SOLXML"
		WF7->WF7_REMETE:=cEMAXML
		WF7->WF7_ENDERE:=cEMAXML
		WF7->WF7_TEMPO:=60
		WF7->WF7_POP3SR:=cPOP
		WF7->WF7_POP3PR:=995 // 110
		WF7->WF7_CONTA:=cCONTA
		WF7->WF7_SENHA:=_cSenha
		WF7->WF7_SMTPSR:=cSMTP
		WF7->WF7_SMTPPR:=587 // 25
		WF7->WF7_AUTUSU:=cCONTA
		WF7->WF7_AUTSEN:=_cSenha
		WF7->WF7_TCONEX:=1
		WF7->WF7_ATIVO:=.T.
		MsUnlock()

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Parametros Workflow													Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		putmv("MV_WFMLBOX","SOLXML")
		putmv("MV_WFADMIN",ALLTRIM(cEMAXML))
		putmv("MV_WFATTHT","")
		putmv("MV_WFDIR","\workflow")
		putmv("MV_WFENVJA",.T.)
		putmv("MV_WFHTML",.T.)
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Criacao de tabelas temporarias										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aCampos:= {{"TIPO","C",3,0 },;
	{"FORNEC","C",6,0 },;
	{"LOJA","C",2,0 },;
	{"NOME","C",35,0 },;
	{"NOTA","C",9,0 },;
	{"EMISSAO","D",8,0 },;
	{"VALOR","N",12,2 },;
	{"CHAVE","C",44,0 },;
	{"ARQ","C",200,0 },;
	{"CNPJ","C",14,0 },;
	{"NATOP","C",100,0 },;
	{"SITUAC","C",1,0 }}

	cArqTrab  := CriaTrab(aCampos)
	dbUseArea( .T.,, cArqTrab, "LS1", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS1",cArqTrab,"EMISSAO",,,)
	dbSetIndex( cArqTrab +OrdBagExt())
	dbSelectArea("LS1")

	aCampos2:= {{"OK","C",1,0 },;
	{"DTDIGIT","D",8,0 },;
	{"FORNEC","C",6,0 },;
	{"LOJA","C",2,0 },;
	{"NOME","C",35,0 },;
	{"ESPECIE","C",5,0 },;
	{"NOTA","C",9,0 },;
	{"SERIE","C",3,0 },;
	{"EMISSAO","D",8,0 },;
	{"TELEFONE","C",15,0 },;
	{"EMAIL","C",60,0 },;
	{"CHAVE","C",44,0 },;
	{"VALOR","N",12,2 },;
	{"CNPJ","C",14,0 },;
	{"TIPO","C",12,0 },;
	{"TPNF","C",1,0 }}

	cArqTrab2  := CriaTrab(aCampos2)
	dbUseArea( .T.,, cArqTrab2, "LS2", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS2",cArqTrab2,"DTOS(DTDIGIT)+NOTA",,,)
	dbSetIndex( cArqTrab2 +OrdBagExt())
	dbSelectArea("LS2")

	aCampos3:= {{"ESPECIE","C",5,0 },;
	{"TPNF","C",1,0 }}

	cArqTrab3  := CriaTrab(aCampos3)
	dbUseArea( .T.,, cArqTrab3, "LS3", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("LS3",cArqTrab3,"ESPECIE",,,)
	dbSetIndex( cArqTrab3 +OrdBagExt())
	dbSelectArea("LS3")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_cCNPJ:=''
	_cCNPJ2:=''
	cNota:=''
	cChave:=''
	aCabec:={}
	aCabec2:={}
	_dData01:=(DDATABASE-1)
	_dData02:=(DDATABASE-1)
	nQtdNF:=0
	_nTot01:=0
	_nTot02:=0
	_nTot03:=0
	_nTot04:=0
	_nTot05:=0
	nTotal:=0
	cEmissao:=''
	cTipoNF:=""
	cNatOP:=""
	nValor:=0
	lCheck1:=.T.
	lCheck2:=.F.
	lCheck3:=.F.
	lCheck4:=.F.
	lCheck5:=.T.
	cMsgRet:=''

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Recebendo XML														Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	RECEBEXML(.T.,aDirEmp,nRet)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apaga XML arquivados												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DELXML()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Legenda de cores													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aCores := {{ 'LS2->OK=="X" ', 'BR_VERMELHO'  },;
	{ 'Empty(LS2->OK) ', 'BR_VERDE'  },;
	{ 'LS2->OK=="E" ', 'BR_AZUL'  },;
	{ 'LS2->OK=="C" ', 'BR_AMARELO'  },;
	{ 'LS2->OK=="P" ', 'BR_PRETO'  }}

	cMarca := GetMark()
	linverte:=.f.
	DbSelectarea("LS1")
	Dbgotop()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Interface Usuario													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cIdEnt := IDENTCLI()

	bColor := &("{||IF('DEV.' $ ALLTRIM(LS1->NATOP) .OR. 'DEVOL' $ ALLTRIM(LS1->NATOP) .OR. 'TROCA' $ ALLTRIM(LS1->NATOP),"+Str(CLR_HGRAY)+",IIf(LS1->SITUAC=='C',"+Str(CLR_YELLOW)+","+Str(CLR_WHITE)+"))}")

	SetKey(116,{||APAGAR()}) //F5-Remover XML
	SetKey(117,{||RECEBEXML(.F.,aDirEmp,nRet)}) //F6-Receber XML

	SetKey(118,{||MsgRun("Gerando DANFE em PDF...","Aguarde o processamento...",{||U_DANFEPDF(LS1->TIPO,LS1->ARQ,aDirEmp[nRet][2]+"\")})}) //F7-Gerar Danfe PDF
	SetKey(119,{||MsgRun("Consulta SituaГЦo na SEFAZ... ","Aguarde, Consultando XML...",{||SEFAZ(1)})}) //F8-Situacao Sefaz
	SetKey(120,{||MsgRun("Processando XML NЦo Autorizados... ","Aguarde, isto pode levar alguns minutos...",{||SEFAZ(2)})}) //F9-Todos nЦo autorizadas

	@120,040 TO 675,1024 DIALOG oTela TITLE "Arquivamento dos XML: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+"-"+SM0->M0_FILIAL+" Build:17/05/2012"

	@005,005 say "NцO arquivados  " SIZE 250,40 FONT oFont4 OF oTela PIXEL
	@005,240 say "NOTAS FISCAIS NO PERIODO  " SIZE 250,40 FONT oFont4 OF oTela PIXEL

	@005,115 say STRZERO(nTotal,5) SIZE 250,40 FONT oFont4 OF oTela PIXEL COLOR CLR_RED
	@005,410 say STRZERO(nQtdNF,5) SIZE 250,40 FONT oFont4 OF oTela PIXEL COLOR CLR_RED


	@015,005 TO 255,235 BROWSE "LS1" OBJECT OBRWP
	OBRWP:oBrowse:AddColumn(TCColumn():New("Tipo   ",{||LS1->TIPO},,,,"LEFT",10))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Fornecedor",{||LS1->FORNEC},,,,"LEFT",10))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Loja",      {||LS1->LOJA},,,,"LEFT",15))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Nome",      {||LS1->NOME},,,,"LEFT",60))
	OBRWP:oBrowse:AddColumn(TCColumn():New("EmissЦo   ",{||LS1->EMISSAO},"@D 99/99/99",,,"LEFT",10))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Nota Fiscal   ",{||LS1->NOTA},"@!",,,"LEFT",10))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Valor R$    ",{||LS1->VALOR},"@E 999,999.99",,,"RIGHT",15))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Chave XML",{||LS1->CHAVE},"@!",,,"LEFT",200)) 
	OBRWP:oBrowse:AddColumn(TCColumn():New("Arquivo Fisico - "+aDirEmp[nRet][2],{||LS1->ARQ},"@!",,,"LEFT",200))
	OBRWP:oBrowse:AddColumn(TCColumn():New("Natureza OperaГЦo",{||LS1->NATOP},"@!",,,"LEFT",100))
	OBRWP:oBrowse:oFont := TFont():New ("Arial", 05, 16)
	OBRWP:oBrowse:SetBlkBackColor(bColor) // Cor de Fundo

	@260,005 BITMAP ResName "SDUERASE.PNG" OF oTela Size 40,40 ON CLICK (APAGAR()) NoBorder  Pixel
	@260,025 BITMAP ResName "COPYUSER.PNG" OF oTela Size 40,40 ON CLICK (COPIAR()) NoBorder  Pixel    
	@260,045 BITMAP ResName "IMPRESSAO_OCEAN.PNG" OF oTela Size 40,40 ON CLICK (MsgRun("Gerando DANFE em PDF...","Aguarde o processamento...",{||U_DANFEPDF(LS1->TIPO,LS1->ARQ,aDirEmp[nRet][2]+"\")})) NoBorder  Pixel
	@260,065 BITMAP ResName "UPDWARNING.PNG" OF oTela Size 40,40 ON CLICK (RECEBEXML(.F.,aDirEmp,nRet)) NoBorder  Pixel
	@260,085 BITMAP ResName "QADIMG32_MDI.PNG" OF oTela Size 40,40 ON CLICK (FILTRO2()) NoBorder  Pixel
	@255,110 say "F5-Remover XML " SIZE 250,40 FONT oFont2 OF oTela PIXEL COLOR CLR_BLUE
	@262,110 say "F6-Receber XML " SIZE 250,40 FONT oFont2 OF oTela PIXEL COLOR CLR_BLUE
	@269,110 say "F7-Gerar Danfe " SIZE 250,40 FONT oFont2 OF oTela PIXEL COLOR CLR_BLUE
	@255,160 say "F8-SituaГЦo SEFAZ" SIZE 250,40 FONT oFont2 OF oTela PIXEL COLOR CLR_BLUE
	@262,160 say "F9-Todos NЦo Autorizados" SIZE 250,40 FONT oFont2 OF oTela PIXEL COLOR CLR_BLUE

	OBRWI:=MsSelect():New("LS2","","",aCabec2,@lInverte,@cMarca,{015,240,170,490},,,,,aCores)
	OBRWI:oBrowse:oFont := TFont():New ("Arial", 05, 16)

	OBRWI:oBrowse:AddColumn(TCColumn():New("DigitaГЦo " ,{||LS2->DTDIGIT},,,,"LEFT", 18))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Status" ,{||LS2->TIPO},,,,"LEFT", 30))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Cliente"  ,{||LS2->FORNEC},,,,"LEFT", 10))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Loja   ",{||LS2->LOJA},,,,"LEFT",8))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Nome"       ,{||LS2->NOME},,,,"LEFT", 40))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Nota Fiscal   "     ,{||LS2->NOTA},,,,"LEFT", 15))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Valor R$   "     ,{||LS2->VALOR},"@E 99,999.99",,,"RIGHT", 15))
	OBRWI:oBrowse:AddColumn(TCColumn():New("EmissЦo  "     ,{||LS2->EMISSAO},,,,"LEFT", 10))
	OBRWI:oBrowse:AddColumn(TCColumn():New("SИrie  "     ,{||LS2->SERIE},,,,"LEFT", 10))
	OBRWI:oBrowse:AddColumn(TCColumn():New("EspХcie   "     ,{||LS2->ESPECIE},,,,"LEFT", 10))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Telefone      "   ,{||LS2->TELEFONE},,,,"LEFT", 50))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Email"   ,{||LS2->EMAIL},,,,"LEFT", 100))
	OBRWI:oBrowse:AddColumn(TCColumn():New("Chave EletrТnica" ,{||LS2->CHAVE},,,,"LEFT", 160))

	@170,293 BITMAP ResName "AUTORIZ.PNG" OF oTela Size 40,40 ON CLICK (ATUCHAVE()) NoBorder  Pixel

	@170,322 BITMAP ResName "QADIMG32_MDI.PNG" OF oTela Size 40,40 ON CLICK (FILTRO()) NoBorder  Pixel
	@170,340 BITMAP ResName "OCUPACAO.PNG" OF oTela Size 40,40 ON CLICK (FILTRO3()) NoBorder  Pixel
	@170,355 BITMAP ResName "BPMSDOCE.PNG" OF oTela Size 40,40 ON CLICK (ELIMINA()) NoBorder  Pixel
	@170,370 BITMAP ResName "BPMSDOCI.PNG" OF oTela Size 40,40 ON CLICK (RETORNA()) NoBorder  Pixel

	@175,240 BUTTON "Atualizar Email" SIZE 50,10 ACTION ATUEMAIL()
	@188,240 BUTTON "Solicitar XML" SIZE 50,10 ACTION MsgRun("Enviando E-Mail solicitando XML...","Aguarde, processando E-mails...",{||AVISOEMA(aDirEmp[nRet][2])})

	@175,390 BITMAP ResName "OFFICEBTNTABFILTER.PNG" OF oTela Size 40,40 ON CLICK (FILOPC(" ")) NoBorder  Pixel
	@175,400 BITMAP oBmp RESNAME "BR_VERDE" oF oTela SIZE 60,30 NOBORDER PIXEL
	@175,410 Say strzero(_nTot01,4)+" - "+"XML Recebido com Sucesso" FONT oFont2 OF oTela PIXEL

	@185,390 BITMAP ResName "OFFICEBTNTABFILTER.PNG" OF oTela Size 40,40 ON CLICK (FILOPC("X")) NoBorder  Pixel
	@185,400 BITMAP oBmp RESNAME "BR_VERMELHO" oF oTela SIZE 60,30 NOBORDER PIXEL
	@185,410 Say strzero(_nTot02,4)+" - "+"XML NЦo Encontrado" FONT oFont2 OF oTela PIXEL

	@195,390 BITMAP ResName "OFFICEBTNTABFILTER.PNG" OF oTela Size 40,40 ON CLICK (FILOPC("C")) NoBorder  Pixel
	@195,400 BITMAP oBmp RESNAME "BR_AMARELO" oF oTela SIZE 60,30 NOBORDER PIXEL
	@195,410 Say strzero(_nTot03,4)+" - "+"Nota Fiscal sem a Chave" FONT oFont2 OF oTela PIXEL

	@205,390 BITMAP ResName "OFFICEBTNTABFILTER.PNG" OF oTela Size 40,40 ON CLICK (FILOPC("E")) NoBorder  Pixel
	@205,400 BITMAP oBmp RESNAME "BR_AZUL" oF oTela SIZE 60,30 NOBORDER PIXEL
	@205,410 Say strzero(_nTot04,4)+" - "+"Fornecedor sem Email" FONT oFont2 OF oTela PIXEL

	@215,390 BITMAP ResName "OFFICEBTNTABFILTER.PNG" OF oTela Size 40,40 ON CLICK (FILOPC("P")) NoBorder  Pixel
	@215,400 BITMAP oBmp RESNAME "BR_PRETO" oF oTela SIZE 60,30 NOBORDER PIXEL
	@215,410 Say strzero(_nTot05,4)+" - "+"Chave EletrТnica Incorreta" FONT oFont2 OF oTela PIXEL

	@202,240 CHECKBOX "Mostrar Somente NF Classificadas" VAR lCheck5

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Borda																Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	@214,236 to 274,350

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Parametros															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	@220,240 Say "PerМodo de " FONT oFont2 OF oTela PIXEL
	@220,265 get _dData01 Picture "@D 99/99/99" SIZE 40,40
	@230,240 Say "PerМodo AtИ " FONT oFont2 OF oTela PIXEL
	@230,265 get _dData02 Picture "@D 99/99/99" SIZE 40,40

	@260,353 BITMAP ResName "FW_TOTVS_LOGO_61X27.PNG" OF oTela Size 40,40 NoBorder  Pixel

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё CheckBox															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	@173,388 to 227,487
	@228,388 to 274,487

	@230,390 CHECKBOX "Notas Fiscais de Entrada" VAR lCheck1
	@240,390 CHECKBOX "Notas Fiscais de ServiГos" VAR lCheck2
	@250,390 CHECKBOX "Conhecimento de Fretes" VAR lCheck3
	@260,390 CHECKBOX "Eliminadas Pelo UsuАrio" VAR lCheck4

	@250,240 BITMAP ResName "MYBUTRF.JPG" OF oTela Size 40,40 ON CLICK (MsgRun("Processando Notas Fiscais no periodo... ","Periodo "+DTOC(_dData01)+" AtИ "+DTOC(_dData02),{||ENTRADAS()})) NoBorder  Pixel
	@250,285 BITMAP ResName "MYBUTSAI.JPG" OF oTela Size 40,40 ON CLICK (oTela:end()) NoBorder  Pixel

	@220,330 BITMAP ResName "QDOIMG32.PNG" OF oTela Size 40,40 ON CLICK (MsgRun("Arquivando Registros... ","Aguarde o arquivamento...",{||ARQUIVAR(aDirEmp,nRet)})) NoBorder  Pixel
	@250,330 BITMAP ResName "OPEN" OF oTela Size 15,15 ON CLICK (OPEN()) NoBorder  Pixel
	ACTIVATE DIALOG oTela CENTER

	Dbselectarea("LS1")
	dbCloseArea("LS1")
	fErase(cArqTrab+".DTC")
	fErase(cArqTrab+OrdBagExt())

	Dbselectarea("LS2")
	dbCloseArea("LS2")
	fErase(cArqTrab2+".DTC")
	fErase(cArqTrab2+OrdBagExt())

	Dbselectarea("LS3")
	dbCloseArea("LS3")
	fErase(cArqTrab3+".DTC")
	fErase(cArqTrab3+OrdBagExt())
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza Email														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ATUEMAIL()

	_cEmail:=ALLTRIM(LS2->EMAIL)
	_cEmail:=lower(_cEmail+space(50-len(_cEmail)))

	@ 070,070 TO 160,380 dialog oEMAIL title "Informe o Novo Email..."
	@ 005,010 SAY "Informe o Email"
	@ 015,010 Get _cEmail Picture "@!" SIZE 130,20
	@ 030,010 BUTTON "Confirma" SIZE 40,10 ACTION oEMAIL:end()
	Activate Dialog oEMAIL CENTERED

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Se foi informado o email											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !Empty(_cEmail)
		cResp:=Msgbox("Confirma gravaГЦo do Email?","AtenГЦo...","YESNO")

		If cResp
			DbSelectarea("SA1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SA1")+LS2->FORNEC+LS2->LOJA)
			If Found()
				Reclock("SA1",.F.)                           
				IF SUBSTR(cNumEmp,1,2) <> '15'
					SA1->A1_EMAIL2:=lower(_cEmail)
				ELSE
					SA1->A1_EMAIL
				ENDIF		
				MsUnlock()
			Endif
			ENTRADAS()
		Endif
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza Chave Eletronica											Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ATUCHAVE()

	_cBackup:=LS2->CHAVE
	_cChave:=IIF(!EMPTY(LS2->CHAVE),LS2->CHAVE,Space(44))

	@ 070,070 TO 160,400 dialog oChave title "Informe a Chave Eletronica..."
	@ 005,010 SAY "Informe a Chave EletrТnica"
	@ 015,010 Get _cChave Picture "@!" SIZE 150,20
	@ 030,010 BUTTON "Confirma" SIZE 40,10 ACTION oChave:end()
	Activate Dialog oChave CENTERED

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Se foi informado a chave eletronica									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !Empty(_cChave) .AND. ALLTRIM(_cChave)<>ALLTRIM(_cBackup)

		cResp:=Msgbox("Confirma gravaГЦo da Chave EletrТnica?","AtenГЦo...","YESNO")

		If cResp
			DbSelectarea("SF1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SF1")+LS2->NOTA+LS2->SERIE+LS2->FORNEC+LS2->LOJA)
			If Found()
				Reclock("SF1",.F.)
				SF1->F1_CHVNFE:=_cChave
				MsUnlock()
			Endif

			DbSelectarea("SFT")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SFT")+"E"+LS2->SERIE+LS2->NOTA+LS2->FORNEC+LS2->LOJA)
			While !Eof() .AND. SFT->FT_FILIAL==xFilial("SFT") .AND. SFT->FT_TIPOMOV=="E" .AND. SFT->FT_SERIE==LS2->SERIE .AND. SFT->FT_NFISCAL==LS2->NOTA .AND. SFT->FT_CLIEFOR==LS2->FORNEC .AND. SFT->FT_LOJA==LS2->LOJA
				Reclock("SFT",.F.)
				SFT->FT_CHVNFE:=_cChave
				MsUnlock()
				DbSelectarea("SFT")
				Dbskip()
			End

			Reclock("LS2",.F.)
			LS2->CHAVE:=_cChave
			LS2->OK:="X"
			If Empty(LS2->EMAIL)
				LS2->OK:="E"
			Endif
			MsUnlock()

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifico se a Chave informada ja possui o XML na lista				Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("LS1")
			IndRegua("LS1",cArqTrab,"CHAVE",,,)

			DbSelectarea("LS1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(_cChave)
			If Found()
				Reclock("LS2",.F.)
				LS2->OK:=""
				MsUnlock()
			Endif
			DbSelectarea("LS1")
			IndRegua("LS1",cArqTrab,"EMISSAO",,,)
		Endif
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Arquivar															Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ARQUIVAR(aDirEmp,nRet)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualizo entradas													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	ENTRADAS()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifico registros validos para arquivamento						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	lTem:=.F.
	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		IF Empty(LS2->OK)
			lTem:=.T.
		Endif
		Dbskip()
	End

	If !lTem
		Msgbox("NЦo existem registros para serem arquivados!")
		Dbgotop()
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Arquivando registros												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_cEmpFil:=ALLTRIM(SM0->M0_CODIGO)+ALLTRIM(SM0->M0_CODFIL)

	DbSelectarea("LS1")
	IndRegua("LS1",cArqTrab,"CHAVE",,,)

	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		IF Empty(LS2->OK)

			DbSelectarea("LS1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(LS2->CHAVE)
			If Found()     
				_cFileOri:=aDirEmp[nRet][2]+"\"+lower(ALLTRIM(LS1->ARQ))
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Nomeclatura dos arquivos											Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				_cArqNew:=Lower(ALLTRIM(LS2->CNPJ)+"-nf"+ALLTRIM(LS2->NOTA)+"-"+ALLTRIM(LS2->CHAVE)+".xml")
				If LS2->TPNF=="N"
					_cArqNew:=Lower(ALLTRIM(LS2->CNPJ)+"-nf"+ALLTRIM(LS2->NOTA)+"-"+ALLTRIM(LS2->CHAVE)+".xml")
				Endif
				If LS2->TPNF=="S"
					_cArqNew:=Lower(ALLTRIM(LS2->CNPJ)+"-nfse"+ALLTRIM(LS2->NOTA)+"-"+ALLTRIM(LS2->CHAVE)+".xml")
				Endif
				If LS2->TPNF=="C"
					_cArqNew:=Lower(ALLTRIM(LS2->CNPJ)+"-ct"+ALLTRIM(LS2->NOTA)+"-"+ALLTRIM(LS2->CHAVE)+".xml")
				Endif
				_cFileNew:=aDirEmp[nRet][2]+"\"+_cArqNew
				cEmpFis:=aDirEmp[nRet][3]

				If !File(_cFileNew)
					__CopyFile(_cFileOri,_cFileNew)
				Endif

				lExistD:= ExistDir("J:\fiscal\XML_NFe_Entrada\"+cEmpFis+"\"+DTOS(LS2->DTDIGIT))
				nRetD  := MakeDir("J:\fiscal\XML_NFe_Entrada\"+cEmpFis+"\"+DTOS(LS2->DTDIGIT))
				
				If nRetD != 0 .And. !lExistD 
					conout( "NЦo foi possМvel criar o diretСrio. J:\fiscal\XML_NFe_Entrada\"+cEmpFis+"\"+DTOS(LS2->DTDIGIT)+"Erro: " + cValToChar( FError() ) )
				Else
					cPath2 := "J:\fiscal\XML_NFe_Entrada\"+cEmpFis+"\"+DTOS(LS2->DTDIGIT)
					CpyS2T(_cFileNew,cPath2,.F.)
					fErase(_cFileOri)
					fErase(_cFileNew)
				EndIf

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Apaga XML arquivados												Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cQuere:=" DELETE FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' AND CHAVE='"+LS1->CHAVE+"' "
				TCSQLEXEC(cQuere)

				Reclock("LS1",.F.)
				dbDelete()
				MsUnlock()
				nTotal:=(nTotal-1)
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualizando Nota Fiscal como arquivada								Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectarea("SF1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SF1")+LS2->NOTA+LS2->SERIE+LS2->FORNEC+LS2->LOJA)
			If Found()
				Reclock("SF1",.F.)
				SF1->F1_TX:="*"
				MsUnlock()
			Endif

			Reclock("LS2",.F.)
			dbdelete()
			MsUnlock()

			nQtdNF:=(nQtdNF-1)
		Endif
		DbSelectarea("LS2")
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processando entradas atualizadas									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	ENTRADAS()

	Msgbox("Registros arquivados com sucesso!","AtenГЦo...","INFO")
	DbSelectarea("LS2")
	Dbgotop()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia email solicitando XML											Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function AVISOEMA(cArqEmp)

	Local cEnvia	:=cEMAXML

	If Empty(cEnvia)
		Msgbox("Favor preencher o Email para recebimento do XML nas configuraГУes!")
		Return
	Endif
	If !File(aDirEmp[nRet][2]+"\solxml.html")
			Msgbox("NЦo existe o arquivo SOLXML.HTML na pasta de "+cArqEmp+"!")
			Return
	Endif
	_cNomeEmp:=ALLTRIM(SM0->M0_FILIAL)+Space(50)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Nome da empresa atual												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("SA1")
	DbSetorder(3)
	DBgotop()
	Dbseek(xFilial("SA1")+_cCCNPJ)
	If Found()
		_cNomeEmp:=SA1->A1_NREDUZ
	Else
		DbSelectarea("SA1")
		DbSetorder(3)
		DBgotop()
		Dbseek(xFilial("SA1")+_cCCNPJ)
		If Found()
			_cNomeEmp:=SA1->A1_NREDUZ
		Endif
	Endif

	@ 070,070 TO 160,380 dialog oEmp title "Empresa solicitante..."
	@ 005,010 SAY "Nome da Empresa (Corpo do Email) "
	@ 015,010 Get _cNomeEmp Picture "@!" SIZE 130,20 VALID !Empty(_cNomeEmp)
	@ 030,010 BUTTON "Confirma" SIZE 40,10 ACTION oEmp:end()
	Activate Dialog oEmp CENTERED

	If Empty(_cNomeEmp)
		Msgbox("Favor informar o nome da empresa solicitante!")
		Return
	Endif

	cResp:=Msgbox("Deseja enviar todos os Emails solicitando o XML?","AtenГЦo...","YESNO")

	If cResp

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Confirmar envio da solicitacao copiando email...					Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !Empty(cCCXML)
			cResp:=msgbox("Deseja enviar uma cСpia das solicitaГУes para "+ALLTRIM(cCCXML)+"?","AtenГЦo...","YESNO")
			If !cResp
				cCCXML:=""
			Endif
		Endif

		lEntrou:=.F.
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Notas Fiscais do periodo											Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("LS2")
		IndRegua("LS2",cArqTrab2,"FORNEC+LOJA",,,)

		cQuery:=" SELECT F1_FORNECE FORNEC,F1_LOJA LOJA "
		cQuery:=cQuery + " FROM SF1"+SM0->M0_CODIGO+"0 "
		cQuery:=cQuery + " WHERE F1_FILIAL ='"+xFilial("SF1")+"' "
		cQuery:=cQuery + " AND F1_DTDIGIT BETWEEN '"+DTOS(_dData01)+"' AND '"+DTOS(_dData02)+"' "
		cQuery:=cQuery + " AND F1_PREFIXO NOT IN ('ICM','JUR') "
		cQuery:=cQuery + " AND F1_FORMUL<>'S' "
		cQuery:=cQuery + " AND F1_TX=' ' "
		cQuery:=cQuery + " AND F1_TIPO <> 'N' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
		cQuery:=cQuery + " GROUP BY F1_FORNECE,F1_LOJA "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		While !Eof()

			nCont:=1

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Criando Obejto Envio Email											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			oProcess := TWFProcess():New( "COMPRAS", "SolicitaГЦo XML") 

			If _cEmpresa=="01"
				oProcess:NewTask( "SolicitaГЦo Arquivo XML", "\xmlcli\ArquivaMasipack\solxml.html") 
			EndIf
			If _cEmpresa=="10"
				oProcess:NewTask( "SolicitaГЦo Arquivo XML", "\xmlcli\ArquivaFabrima\solxml.html") 
			EndIf
			If _cEmpresa=="15"
				oProcess:NewTask( "SolicitaГЦo Arquivo XML", "\xmlcli\ArquivaHelsimplast\solxml.html") 
			EndIf
			If _cEmpresa=="40"
				oProcess:NewTask( "SolicitaГЦo Arquivo XML", "\xmlcli\ArquivaLabortube\solxml.html") 
			EndIf
			If _cEmpresa=="45"
				oProcess:NewTask( "SolicitaГЦo Arquivo XML", "\xmlcli\ArquivaMemb\solxml.html") 
			EndIf

			oProcess:cSubject := "SolicitaГЦo do Arquivo XML"
			oHTML := oProcess:oHTML

			DbSelectarea("LS2")
			DbSetorder(1)
			Dbgotop()
			DbSeek(TCQ->FORNEC+TCQ->LOJA)
			While !Eof() .AND. LS2->FORNEC==ALLTRIM(TCQ->FORNEC) .AND. LS2->lOJA==ALLTRIM(TCQ->LOJA)
				IF !Empty(LS2->OK) .AND. !Empty(LS2->EMAIL)
					If nCont==1

						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Fornecedor															Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						DbSelectarea("SA1")
						DbSetorder(1)
						Dbgotop()
						Dbseek(xFIlial("SA1")+TCQ->FORNEC+TCQ->LOJA)

						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Cabecalho do email													Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						oProcess:cTo :=LOWER(ALLTRIM(LS2->EMAIL))+IIF(!Empty(cCCXML),";"+ALLTRIM(cCCXML),"")
						oHTML:ValByName('CLIENTE',LS2->NOME)
						oHTML:ValByName('CNPJ',LS2->CNPJ)
						oHTML:ValByName('DATA',DTOC(DDATABASE))
						oHTML:ValByName('EMPRESA',_cNomeEmp)
						oHTML:ValByName('MSGADIC',cMSGXML)
						oHTML:ValByName('EMAIL',cEMAXML)
						oHTML:ValByName('END',SA1->A1_END)
						oHTML:ValByName('BAIRRO',SA1->A1_BAIRRO)
						oHTML:ValByName('MUN',ALLTRIM(SA1->A1_MUN)+"/"+SA1->A1_EST)
						oHTML:ValByName('URL',ALLTRIM(cURL))
					Endif
					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Relacao das notas fiscais											Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cLink:="http://ww2.webdanfe.com.br/NfeCrawler/Crawl.aspx?chaveNfe="+ALLTRIM(LS2->CHAVE)
					aadd((oHtml:valByName('TB.EMISSAO')),DTOC(LS2->EMISSAO))
					aadd((oHtml:valByName('TB.NOTA')),ALLTRIM(LS2->NOTA))
					aadd((oHtml:valByName('TB.VALOR')),Transform(LS2->VALOR,"@E 999,999.99"))
					aadd((oHtml:valByName('TB.CHAVE')),ALLTRIM(LS2->CHAVE))
					aadd((oHtml:valByName('TB.LINK')),cLink)
					nCont:=nCont+1
				Endif
				DbSelectarea("LS2")
				Dbskip()
			End
			If nCont>1
				lEntrou:=.T.
				oProcess:Start()
				WFSendMail()
				oProcess:Finish()
			Endif
			DbSelectarea("TCQ")
			Dbskip()
		End
		DbClosearea("TCQ")

		DbSelectarea("LS2")
		IndRegua("LS2",cArqTrab2,"DTOS(DTDIGIT)+NOTA",,,)
		Dbgotop()

		If lEntrou
			Msgbox("Email enviado com sucesso!","AtenГЦo...","INFO")
		Endif
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё GetFile dos registros arquivados									Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function OPEN() 

	If _cEmpresa=="01"
		cFile := cGetFile("Todos (*.*) |*.*|","Todos os arquivos",0,"SERVIDOR\xmlcli\ArquivaMasipack\",.T.,GETF_ONLYSERVER)
	EndIf
	If _cEmpresa=="10"
		cFile := cGetFile("Todos (*.*) |*.*|","Todos os arquivos",0,"SERVIDOR\xmlcli\ArquivaFabrima\",.T.,GETF_ONLYSERVER)
	EndIf
	If _cEmpresa=="15"
		cFile := cGetFile("Todos (*.*) |*.*|","Todos os arquivos",0,"SERVIDOR\xmlcli\ArquivaHelsimplast\",.T.,GETF_ONLYSERVER)
	EndIf
	If _cEmpresa=="40"
		cFile := cGetFile("Todos (*.*) |*.*|","Todos os arquivos",0,"SERVIDOR\xmlcli\ArquivaLabortube\",.T.,GETF_ONLYSERVER)
	EndIf
	If _cEmpresa=="45"
		cFile := cGetFile("Todos (*.*) |*.*|","Todos os arquivos",0,"SERVIDOR\xmlcli\ArquivaMemb\",.T.,GETF_ONLYSERVER)
	EndIf

Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Copiar arquivo XML													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function COPIAR()
	cFile := cGetFile("Todos (*.*) |*.*|","Todos os arquivos",0,"C:\"+lower(ALLTRIM(LS1->ARQ)),.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	If _cEmpresa=="01"
		__CopyFile("\xmlcli\ArquivaMasipack\"+lower(ALLTRIM(LS1->ARQ)),alltrim(cFile)+".xml") 
	EndIf 
	If _cEmpresa=="10"
		__CopyFile("\xmlcli\ArquivaFabrima\"+lower(ALLTRIM(LS1->ARQ)),alltrim(cFile)+".xml") 
	EndIf
	If _cEmpresa=="15"
		__CopyFile("\xmlcli\ArquivaHelsimplast\"+lower(ALLTRIM(LS1->ARQ)),alltrim(cFile)+".xml") 
	EndIf
	If _cEmpresa=="40"
		__CopyFile("\xmlcli\ArquivaLabortube\"+lower(ALLTRIM(LS1->ARQ)),alltrim(cFile)+".xml") 
	EndIf
	If _cEmpresa=="45"
		__CopyFile("\xmlcli\ArquivaMemb\"+lower(ALLTRIM(LS1->ARQ)),alltrim(cFile)+".xml") 
	EndIf
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Eliminando XML														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function APAGAR()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Senha para apagar o XML												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !Empty(ALLTRIM(cSenXML))
		_cPassw:=Space(10)

		@ 0,0 TO 100,235 DIALOG oSenha TITLE "Senha de ExclusЦo..."
		@ 10,10 SAY "Senha "  FONT oFont1 OF oSenha PIXEL
		@ 10,55 Get _cPassw Size 30,20  Valid .T.  PASSWORD
		@ 30,40 BUTTON "Confirma" SIZE 35,12 ACTION Close(oSenha)
		ACTIVATE DIALOG oSenha CENTER

		If Empty(_cPassw)
			Return
		Endif

		If ALLTRIM(_cPassw)<>ALLTRIM(cSenXML)
			Msgbox("Senha invАlida!")
			Return
		Endif
	Endif

	cResp:=Msgbox("Deseja Remover o arquivo?","AtenГЦo...","YESNO")

	If cResp

		_cArqNew:=Lower(ALLTRIM(LS1->CNPJ)+"-nf"+ALLTRIM(LS1->NOTA)+"-"+ALLTRIM(LS1->CHAVE)+".xml")

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Eliminando arquivo fisicamente										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды 
		If _cEmpresa=="01"
			__CopyFile("\xmlcli\ArquivaMasipack\"+lower(ALLTRIM(LS1->ARQ)),"\xmlcli\ArquivaMasipack\removidos\"+_cArqNew)
			cErase:="\xmlcli\ArquivaMasipack\"+lower(ALLTRIM(LS1->ARQ))
		EndIf
		If _cEmpresa=="10"
			__CopyFile("\xmlcli\ArquivaFabrima\"+lower(ALLTRIM(LS1->ARQ)),"\xmlcli\ArquivaFabrima\removidos\"+_cArqNew)
			cErase:="\xmlcli\ArquivaFabrima\"+lower(ALLTRIM(LS1->ARQ))
		EndIf
		If _cEmpresa=="15"
			__CopyFile("\xmlcli\ArquivaHelsimplast\"+lower(ALLTRIM(LS1->ARQ)),"\xmlcli\ArquivaHelsimplast\removidos\"+_cArqNew)
			cErase:="\xmlcli\ArquivaHelsimplast\"+lower(ALLTRIM(LS1->ARQ))
		EndIf
		If _cEmpresa=="40"
			__CopyFile("\xmlcli\ArquivaLabortube\"+lower(ALLTRIM(LS1->ARQ)),"\xmlcli\ArquivaLabortube\removidos\"+_cArqNew)
			cErase:="\xmlcli\ArquivaLabortube\"+lower(ALLTRIM(LS1->ARQ))
		EndIf
		If _cEmpresa=="45"
			__CopyFile("\xmlcli\ArquivaMemb\"+lower(ALLTRIM(LS1->ARQ)),"\xmlcli\ArquivaMemb\removidos\"+_cArqNew)
			cErase:="\xmlcli\ArquivaMemb\"+lower(ALLTRIM(LS1->ARQ))
		EndIf
		fErase(cErase)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Apaga XML arquivados												Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuere:=" DELETE FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' AND CHAVE='"+LS1->CHAVE+"' "
		TCSQLEXEC(cQuere)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Eliminando do Browse												Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Reclock("LS1",.F.)
		dbdelete()
		MsUnlock()

		nTotal:=(nTotal-1)

		OBRWP:oBrowse:refresh()
		OBRWP:oBrowse:setfocus()
		ObjectMethod(oTela,"Refresh()")
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Recebendo novos XML													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function RECEBEXML(lOpc,aDirEmp,nRet)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Recebendo emails dos fornecedores									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	MsgRun("Importando XML do E-mail "+ALLTRIM(cCONTA),"Lendo apartir do E-Mail configurado...",{||POPEMAIL()})

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Copiando novos arquivos recebidos									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	MsgRun("Apagando arquivos diferentes de XML... ","Removendo Arquivos...",{||TEMXML(aDirEmp,nRet)})

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis															Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	_cCNPJ:=''
	_cCNPJ2:=''
	cNota:=''
	cChave:=''
	nTotal:=0
	cEmissao:=''
	nValor:=0
	nCont:=1

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Adicionando XML no array											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aXML:={}
	ADir(aDirEmp[nRet][2]+"\*.imp",aXML)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando se existe arquivos XML									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Len(aXML)==0
		Msgbox("NЦo existem arquivos para serem arquivados no momento!","AtenГЦo...","INFO")
		Return
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Regua de Processamento												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oProcess := MsNewProcess():New({|lEnd| IMPORT(@oProcess, @lEnd,@aDirEmp,@nRet) },"Leitura dos Arquivos XML...","Importando Arquivos do Email...",.T.)
	oProcess:Activate()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processando XML														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function IMPORT()
Local i			:= 0
Local aDirEmp	:= {{"01","\xmlcli\ArquivaMasipack","Masipack"},;
					{"10","\xmlcli\ArquivaFabrima","Fabrima"},;
					{"15","\xmlcli\ArquivaHelsimplast","Helsimplast"}}

	oProcess:SetRegua1(Len(aXML))

	nRet := Ascan(aDirEmp,{|x|x[1]==_cEmpresa})

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apaga XML recebidos anteriormente									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		cQuery:=" SELECT COUNT(*) QTD FROM SF1"+SM0->M0_CODIGO+"0 WHERE F1_FILIAL='"+xFilial("SF1")+"' AND F1_CHVNFE='"+LS1->CHAVE+"' AND F1_TX='*' AND D_E_L_E_T_<>'*' "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		lSF1:=TCQ->QTD
		DbClosearea("TCQ")

		If lSF1>0
			_cArqNew:=Lower(ALLTRIM(LS1->CNPJ)+"-nf"+ALLTRIM(LS1->NOTA)+"-"+ALLTRIM(LS1->CHAVE)+".xml")

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Eliminando arquivo fisicamente										Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			__CopyFile(aDirEmp[nRet][2]+"\"+lower(ALLTRIM(LS1->ARQ)),aDirEmp[nRet][2]+"removidos\"+_cArqNew)
			cErase:=aDirEmp[nRet][2]+"\"+lower(ALLTRIM(LS1->ARQ))
			fErase(cErase)

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Apaga XML arquivados												Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuere:=" DELETE FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' AND CHAVE='"+LS1->CHAVE+"' "
			TCSQLEXEC(cQuere)
		Endif
		DbSelectarea("LS1")
		Dbskip()
	End

	DbSelectarea("LS1")
	Dbgotop()
	IndRegua("LS1",cArqTrab,"CHAVE",,,)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Recebendo dados do XML												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	For i:=1 to Len(aXML)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifica se nao existe na tabela temporaria ARQXML					Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery:=" SELECT COUNT(*) QTD FROM ARQXML WHERE ARQ='"+ALLTRIM(aXML[i])+"' "
		TCQUERY cQuery NEW ALIAS "TCQ"
		DbSelectarea("TCQ")
		lExiArq:=TCQ->QTD
		DbCloseArea("TCQ")

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Leitura dos arquivos XML novos										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lExiArq==0
			XML()
		Else
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Registros recuperados												Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cQuery:=" SELECT * FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' AND ARQ='"+ALLTRIM(aXML[i])+"' "
			TCQUERY cQuery NEW ALIAS "TCQ"
			DbSelectarea("TCQ")
			_cFornec:=TCQ->FORNEC+TCQ->LOJA
			cNota:=TCQ->NOTA
			cChave:=TCQ->CHAVE
			nValor:=TCQ->VALOR
			cEmissao:=TCQ->EMISSAO
			cTipoNF:=TCQ->TIPO
			cNatOP:=TCQ->NATOP
			DbCloseArea("TCQ")

			_cCNPJ:=''
			If !Empty(_cFornec)
				DbSelectarea("SA1")
				DbSetorder(1)
				Dbgotop()
				Dbseek(xFilial("SA1")+_cFornec)
				If Found()
					_cCNPJ:=SA1->A1_CGC
				Endif
			Endif
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Fornecedor															Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !Empty(_cCNPJ)
			DbSelectarea("LS1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(ALLTRIM(cChave))
			If !Found()
				DbSelectarea("SA1")
				DbSetorder(3)
				Dbgotop()
				Dbseek(xFilial("SA1")+_cCNPJ)
				If Found()

					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Verifica se o XML ja esta arquivado									Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cQuery:=" SELECT COUNT(*) QTD FROM SF1"+SM0->M0_CODIGO+"0 WHERE F1_FILIAL='"+xFilial("SF1")+"' AND F1_FORNECE='"+SA1->A1_COD+"' AND F1_LOJA='"+SA1->A1_LOJA+"' AND F1_CHVNFE='"+ALLTRIM(cChave)+"' AND F1_TX='*' AND D_E_L_E_T_<>'*' "
					TCQUERY cQuery NEW ALIAS "XML"
					DbSelectarea("XML")
					lXml:=XML->QTD
					DbClosearea("XML")
					DbSelectarea("SA1")

					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Regua de processamento												Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					oProcess:IncRegua1("EmissЦo:"+DTOC(STOD(cEmissao)))

					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Gravando XML nao arquivados											Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If lXml==0
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Regua de processamento												Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						oProcess:IncRegua2(SA1->A1_NREDUZ)

						If lExiArq==0
							DbUseArea(.T.,"TOPCONN","ARQXML","ARQ",.T.,.F.)
							DbSelectarea("ARQ")
							Reclock("ARQ",.T.)
							ARQ->EMPFIL:=_cEmpFil
							ARQ->FORNEC:=SA1->A1_COD
							ARQ->LOJA:=SA1->A1_LOJA
							ARQ->NOTA:=cNota
							ARQ->EMISSAO:=STOD(cEmissao)
							ARQ->CHAVE:=cChave
							ARQ->VALOR:=nValor
							ARQ->ARQ:=ALLTRIM(aXML[i])
							ARQ->TIPO:=cTipoNF
							ARQ->NATOP:=cNatOP
							MsUnlock()
							DbClosearea("ARQ")
						Endif

						DbSelectarea("LS1")
						Reclock("LS1",.T.)
						LS1->FORNEC:=SA1->A1_COD
						LS1->LOJA:=SA1->A1_LOJA
						LS1->NOME:=SA1->A1_NREDUZ
						LS1->NOTA:=IIF(Len(ALLTRIM(cNota))<6,strzero(val(cNota),6),cNota)
						LS1->CHAVE:=cChave
						LS1->ARQ:=Lower(ALLTRIM(aXML[i]))
						LS1->VALOR:=nValor
						LS1->EMISSAO:=STOD(cEmissao)
						LS1->NATOP:=cNatOP
						LS1->CNPJ:=SA1->A1_CGC
						LS1->TIPO:=cTipoNF
						MsUnlock()
						nCont:=nCont+1
					Else
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Apagando arquivo XML arquivados										Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cErase:=aDirEmp[nRet][2]+"\"+Lower(ALLTRIM(aXML[i]))
						fErase(cErase)
						fErase("\xmlcli\"+Lower(ALLTRIM(aXML[i])))
					Endif
				Endif
			Endif
		Endif
	Next

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifico se o arquivo XML ja foi arquivado							Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cQuery:=" SELECT CHAVE,ARQ FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' AND CHAVE IN (SELECT F1_CHVNFE FROM SF1"+SM0->M0_CODIGO+"0 WHERE F1_FILIAL='"+xFilial("SF1")+"' AND F1_DTDIGIT>=EMISSAO AND F1_CHVNFE=CHAVE AND F1_TX='*' AND D_E_L_E_T_<>'*') "
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectarea("TCQ")
	While !Eof()
		oProcess:IncRegua1("Eliminando XML arquivados...")
		oProcess:IncRegua2(TCQ->CHAVE)

		cQuere:=" DELETE FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' AND CHAVE='"+TCQ->CHAVE+"' "
		TCSQLEXEC(cQuere)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Eliminando arquivo fisicamente										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды 
		If _cEmpresa=="01"
			cErase:="\xmlcli\ArquivaMasipack\"+lower(ALLTRIM(TCQ->ARQ))
		ElseIf _cEmpresa=="10"
			cErase:="\xmlcli\ArquivaFabrima\"+lower(ALLTRIM(TCQ->ARQ))
		ElseIf _cEmpresa=="15" 
			cErase:="\xmlcli\ArquivaHelsimplast\"+lower(ALLTRIM(TCQ->ARQ))
		ElseIf _cEmpresa=="40" 
			cErase:="\xmlcli\ArquivaLabortube\"+lower(ALLTRIM(TCQ->ARQ))
		ElseIf _cEmpresa=="45"
			cErase:="\xmlcli\ArquivaMemb\"+lower(ALLTRIM(TCQ->ARQ))
		EndIf
		fErase(cErase)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Eliminando do Browse												Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("LS1")
		IndRegua("LS1",cArqTrab,"CHAVE",,,)
		Dbgotop()
		Dbseek(ALLTRIM(TCQ->CHAVE))
		If Found()
			Reclock("LS1",.F.)
			dbDelete()
			MsUnlock()
		Endif
		DbSelectarea("TCQ")
		Dbskip()
	End
	DbClosearea("TCQ")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Quantidade de registros												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS1")
	Dbgotop()
	While !Eof()
		nTotal:=nTotal+1
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processando entradas do dia anterior								Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	ENTRADAS()

	DbSelectarea("LS1")
	IndRegua("LS1",cArqTrab,"EMISSAO",,,)
	Dbgotop()
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
	_nErro := _oMailManager:Init("email-ssl.com.br","",cConta,_cSenha,143)
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
					If File("\xmlcli\config\cfgxml.txt")
						_oMessage:SaveAttach(_nX,GetSrvProfString( "RootPath", "" )+'\xmlcli\'+_oMessage:GetAttachInfo(_nX)[1])
					EndIf

					If _cEmpresa=="01"
						_cCaixa := '\xmlcli\ArquivaMasipack'
					ElseIf _cEmpresa=="10"
						_cCaixa := '\xmlcli\ArquivaFabrima'
					ElseIf _cEmpresa=="15"
						_cCaixa := '\xmlcli\ArquivaHelsimplast'
					ElseIf _cEmpresa=="40"
						_cCaixa := '\xmlcli\ArquivaLabortube'
					ElseIf _cEmpresa=="45"
						_cCaixa := '\xmlcli\ArquivaMemb'
					EndIf

					If _oMessage:SaveAttach(_nX,GetSrvProfString( "RootPath", "" ) + _cCaixa + _oMessage:GetAttachInfo(_nX)[1])
						_oMailManager:DeleteMsg(_nI)
					EndIf
				EndIf
			Next _nX
		EndIf
	Next

	_oMailManager:IMAPDisconnect()

Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processando arquivos												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function XML()

	Private oXml :=NIL
	Private cError:=''
	Private cWarning:=''

	oXml :=NIL 
	If _cEmpresa=="01"
		cFile:="\xmlcli\ArquivaMasipack\"+lower(ALLTRIM(aXML[i])) 
	EndIf 
	If _cEmpresa=="10"
		cFile:="\xmlcli\ArquivaFabrima\"+lower(ALLTRIM(aXML[i])) 
	EndIf
	If _cEmpresa=="15"
		cFile:="\xmlcli\ArquivaHelsimplast\"+lower(ALLTRIM(aXML[i])) 
	EndIf
	If _cEmpresa=="40"
		cFile:="\xmlcli\ArquivaLabortube\"+lower(ALLTRIM(aXML[i])) 
	EndIf
	If _cEmpresa=="45"
		cFile:="\xmlcli\ArquivaMemb\"+lower(ALLTRIM(aXML[i])) 
	EndIf
	oXml := XmlParserFile(cFile,"_",@cError, @cWarning )
	_cCNPJ:=''
	_cCNPJ2:=''
	cNota:=''
	cChave:=''
	cEmissao:=''
	nValor:=0
	lTipo:=8
	cTipoNF:=""
	cNatOP:=""

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Notas Fiscais normais												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ALLTRIM(TYPE("oxml:_NFE:_INFNFE"))=="O"
		lTipo:=1
		cTipoNF:="NF"
	Endif
	If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE"))=="O"
		lTipo:=2
		cTipoNF:="NF"
	Endif
	If ALLTRIM(TYPE("oxml:_ENVINFE:_NFE:_INFNFE"))=="O"
		lTipo:=3
		cTipoNF:="NF"
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Notas Fiscais de servico											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ALLTRIM(TYPE("oxml:_GERARNFSERESPOSTA:_LISTANFSE"))=="O"
		lTipo:=4
		cTipoNF:="NFS"
	Endif
	If ALLTRIM(TYPE("oxml:_COMPNFSE:_NFSE"))=="O"
		lTipo:=5
		cTipoNF:="NFS"
	Endif
	If ALLTRIM(TYPE("oxml:_ENVIARLOTERPSENVIO:_LOTERPS"))=="O"
		lTipo:=6
		cTipoNF:="NFS"
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Conhecimento de frete												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ALLTRIM(TYPE("oxml:_CTEPROC:_CTE"))=="O"
		lTipo:=7
		cTipoNF:="CTR"
	Endif

	If (lTipo==1 .OR. lTipo==2 .OR. lTipo==3)
		If Empty(@cError)

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Sem _NFEPROC															Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lTipo==1
				If ALLTRIM(TYPE("oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT"))=="C"
					_cCNPJ2:=ALLTRIM(oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Endif
				_cCNPJ:=ALLTRIM(oxml:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
				cNota:=oxml:_NFE:_INFNFE:_IDE:_NNF:TEXT
				cChave:=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_ID:TEXT,4,200))
				XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
				IF XXVERSAO=="2"
					cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
				else
					cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
				ENDIF
				XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
				IF XXVERSAO=="2"
					cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
				else
					cEmissao:=SUBSTR(oxml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
				ENDIF
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Empresa atual														Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If ALLTRIM(_cCNPJ2)<>ALLTRIM(SM0->M0_CGC)
					_cCNPJ:=''
				Endif
			Endif
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Com _NFEPROC														Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lTipo==2
				If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT"))=="C"
					_cCNPJ2:=ALLTRIM(oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Endif
				_cCNPJ:=ALLTRIM(oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
				cNota:=oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
				If ALLTRIM(TYPE("oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT"))=="C"
					cNatOP:=ALLTRIM(UPPER(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT))
				Endif
				cChave:=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,200))

				XXVERSAO :=ALLTRIM(SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
				IF XXVERSAO=="2"
					cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
				else
					cEmissao:=SUBSTR(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
				ENDIF

				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				nValor:=oxml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT
				nValor:=VAL(nValor)

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Empresa atual														Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If ALLTRIM(_cCNPJ2)<>ALLTRIM(SM0->M0_CGC)
					_cCNPJ:=''
				Endif
			Endif
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё EnviNFE																Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lTipo==3
				If ALLTRIM(TYPE("oxml:_ENVINFE:_NFE:_INFNFE:_DEST:_CNPJ:TEXT"))=="C"
					_cCNPJ2:=ALLTRIM(oxml:_ENVINFE:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				Endif
				_cCNPJ:=ALLTRIM(oxml:_ENVINFE:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
				cNota:=oxml:_ENVINFE:_NFE:_INFNFE:_IDE:_NNF:TEXT
				If ALLTRIM(TYPE("oxml:_ENVINFE:_NFE:_INFNFE:_IDE:_NATOP:TEXT"))=="C"
					cNatOP:=ALLTRIM(UPPER(oxml:_ENVINFE:_NFE:_INFNFE:_IDE:_NATOP:TEXT))
				Endif
				cChave:=ALLTRIM(SUBSTR(oxml:_ENVINFE:_NFE:_INFNFE:_ID:TEXT,4,200))
				//cEmissao:=oxml:_ENVINFE:_NFE:_INFNFE:_IDE:_DEMI:TEXT
				XXVERSAO :=ALLTRIM(SUBSTR(oxml:_ENVINFE:_NFE:_INFNFE:_VERSAO:TEXT,1,1))
				IF XXVERSAO=="2"
					cEmissao:=SUBSTR(oxml:_ENVINFE:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,10)
				else
					cEmissao:=SUBSTR(oxml:_ENVINFE:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,10)
				ENDIF

				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				nValor:=oxml:_ENVINFE:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT
				nValor:=VAL(nValor)

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Empresa atual														Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If ALLTRIM(_cCNPJ2)<>ALLTRIM(SM0->M0_CGC)
					_cCNPJ:=''
				Endif
			Endif
		Else
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Arquivos corrompidos												Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			fErase(cFile)
		Endif
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Nota fiscal de servico												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If (lTipo==4 .OR. lTipo==5 .OR. lTipo==6)
		If Empty(@cError)
			If lTipo==4
				If ALLTRIM(TYPE("oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT"))=="C"
					_cCNPJ2:=ALLTRIM(oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT)
				Endif

				_cCNPJ:=ALLTRIM(oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_PRESTADORSERVICO:_IDENTIFICACAOPRESTADOR:_CNPJ:TEXT)
				If ALLTRIM(TYPE("oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_IDENTIFICACAORPS:_NUMERO:TEXT"))=="C"
					cNota:=ALLTRIM(oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_IDENTIFICACAORPS:_NUMERO:TEXT)
				Else
					cNota:=SUBSTR(ALLTRIM(oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_NUMERO:TEXT),7,9)
				Endif
				cChave:=_cCNPJ+ALLTRIM(oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_NUMERO:TEXT)
				cEmissao:=ALLTRIM(oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_DATAEMISSAO:TEXT)
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				nValor:=ALLTRIM(oxml:_GERARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_SERVICO:_VALORES:_VALORSERVICOS:TEXT)
				nValor:=VAL(nValor)
			ElseIf lTipo==5
				If ALLTRIM(TYPE("oxml:_COMPNFSE:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT"))=="C"
					_cCNPJ2:=ALLTRIM(oxml:_COMPNFSE:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT)
				Endif

				_cCNPJ:=ALLTRIM(oxml:_COMPNFSE:_NFSE:_INFNFSE:_PRESTADORSERVICO:_IDENTIFICACAOPRESTADOR:_CNPJ:TEXT)
				If ALLTRIM(TYPE("oxml:_COMPNFSE:_NFSE:_INFNFSE:_IDENTIFICACAORPS:_NUMERO:TEXT"))=="C"
					cNota:=ALLTRIM(oxml:_COMPNFSE:_NFSE:_INFNFSE:_IDENTIFICACAORPS:_NUMERO:TEXT)
				Else
					cNota:=SUBSTR(ALLTRIM(oxml:_COMPNFSE:_NFSE:_INFNFSE:_NUMERO:TEXT),7,9)
				Endif
				cChave:=_cCNPJ+ALLTRIM(oxml:_COMPNFSE:_NFSE:_INFNFSE:_NUMERO:TEXT)
				cEmissao:=ALLTRIM(oxml:_COMPNFSE:_NFSE:_INFNFSE:_DATAEMISSAO:TEXT)
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				nValor:=ALLTRIM(oxml:_COMPNFSE:_NFSE:_INFNFSE:_SERVICO:_VALORES:_VALORSERVICOS:TEXT)
				nValor:=VAL(nValor)
			ElseIf lTipo==6
				If ALLTRIM(TYPE("oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_TOMADOR:TEXT"))=="C"
					_cCNPJ2:=ALLTRIM(oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_TOMADOR:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT)
				Endif

				_cCNPJ:=ALLTRIM(oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_PRESTADOR:_CNPJ:TEXT)
				If ALLTRIM(TYPE("oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_IDENTIFICACAORPS:_NUMERO:TEXT"))=="C"
					cNota:=ALLTRIM(oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_IDENTIFICACAORPS:_NUMERO:TEXT)
				Else
					cNota:=""
				Endif
				cChave:=_cCNPJ+ALLTRIM(oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_IDENTIFICACAORPS:_NUMERO:TEXT)
				cEmissao:=ALLTRIM(oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_DATAEMISSAO:TEXT)
				cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
				nValor:=ALLTRIM(oxml:_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_SERVICO:_VALORES:_VALORSERVICOS:TEXT)
				nValor:=VAL(nValor)
			Endif
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
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Conhecimento de Frete												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lTipo==7
		If Empty(@cError)

			If ALLTRIM(TYPE("oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT"))=="C"
				_cCNPJ2:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
			Endif

			_cCNPJ:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
			cNota:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_CCT:TEXT)
			cChave:=ALLTRIM(SUBSTR(ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT),4,200))
			cEmissao:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT)
			cEmissao:=SUBSTR(cEmissao,1,4)+SUBSTR(cEmissao,6,2)+SUBSTR(cEmissao,9,2)
			nValor:=ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)
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
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verificando se os arquivos pertencem a empresa						Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !Empty(_cCNPJ2)
		lExiste:=.F.
		DbSelectarea("SM0")
		Dbsetorder(1)
		Dbgotop()
		While !Eof()
			IF ALLTRIM(SM0->M0_CGC)==ALLTRIM(_cCNPJ2)
				lExiste:=.T.
			Endif
			DbSelectarea("SM0")
			Dbskip()
		End
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Retornando filial posicionada										Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectarea("SM0")
		Dbsetorder(1)
		Dbgotop()
		Dbseek(_cEmpFil)

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Se o arquivo nao pertencer a nenhuma empresa, apaga					Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !lExiste
			fErase(cFile)
			fErase("\xmlcli\"+lower(ALLTRIM(aXML[i])))
		Endif
	Endif
Return .T.

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Filtro Fornecedor													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function FILTRO()

	_cFornec:=LS2->FORNEC

	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		IF ALLTRIM(LS2->FORNEC)<>ALLTRIM(_cFornec)
			Reclock("LS2",.F.)
			dbdelete()
			MsUnlock()
		Endif
		Dbskip()
	End
	Dbgotop()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ordena arquivos recebidos											Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function FILTRO2()

	If !lFiltro2
		DbSelectarea("LS1")
		IndRegua("LS1",cArqTrab,"NOME+STR(VALOR,12,2)+DTOS(EMISSAO)",,,)
		Dbgotop()
		lFiltro2:=.T.
	Else
		DbSelectarea("LS1")
		IndRegua("LS1",cArqTrab,"EMISSAO",,,)
		Dbgotop()
		lFiltro2:=.F.
	Endif

	DbSelectarea("LS1")
	Dbgotop()
	OBRWP:oBrowse:refresh()
	OBRWP:oBrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ordena por nome do fornecedor										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function FILTRO3()

	If !lFiltro3
		DbSelectarea("LS2")
		IndRegua("LS2",cArqTrab2,"NOME",,,)
		Dbgotop()
		lFiltro3:=.T.
	Else
		DbSelectarea("LS2")
		IndRegua("LS2",cArqTrab2,"DTOS(DTDIGIT)+NOTA",,,)
		Dbgotop()
		lFiltro3:=.F.
	Endif

	DbSelectarea("LS2")
	Dbgotop()
	OBRWI:oBrowse:refresh()
	OBRWI:oBrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Filtro por Status													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function FILOPC(lStatus)

	ENTRADAS()

	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		IF ALLTRIM(LS2->OK)<>ALLTRIM(lStatus)
			Reclock("LS2",.F.)
			dbdelete()
			MsUnlock()
		Endif
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Quantidade de registros												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nQtdNF:=0
	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		nQtdNF:=nQtdNF+1
		Dbskip()
	End

	DbSelectarea("LS2")
	Dbgotop()
	OBRWI:oBrowse:refresh()
	OBRWI:oBrowse:setfocus()
	ObjectMethod(oTela,"Refresh()")
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Configuracao XML													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CFGXML()

	cSMTP	:=ALLTRIM(cSMTP)+space(150)
	cPOP	:=ALLTRIM(cPOP)+space(150)
	cCONTA	:=ALLTRIM(cCONTA)+space(150)
	_cSenha	:=ALLTRIM(_cSenha)+space(50)
	cEMAXML	:=ALLTRIM(cEMAXML)+space(150)
	cNF01	:=ALLTRIM(cNF01)+space(100)
	cNF02	:=ALLTRIM(cNF02)+space(100)
	cNF03	:=ALLTRIM(cNF03)+space(100)
	cMSGXML	:=ALLTRIM(cMSGXML)+space(200)
	cCCXML	:=ALLTRIM(cCCXML)+space(100)
	cURL	:=ALLTRIM(cURL)+space(150)
	cSenXML	:=ALLTRIM(cSENXML)+space(50)

	lChkTWiz:= .F.
	lWiz 	:= .F.

	DEFINE WIZARD oWizard TITLE "Arquivamento do XML..." HEADER "Wizard de ConfiguraГЦo" MESSAGE " " TEXT "Esta И a tela de configuraГЦo do programa de Arquivamento do XML..." PANEL NEXT {|| .T.} FINISH {|| .T.}

	CREATE PANEL oWizard HEADER "Parametros" MESSAGE "Dados da Conta do Email..." PANEL BACK {|| .T.} NEXT {|| If(Empty(cSMTP),(MsgStop("Informe o servidor SMTP"), .F.), If(Empty(cPOP),(msgStop("Informe o servidor POP"), .F.), .T.))} FINISH {|| .T.} EXEC {|| .T.}

	@010,010 TO 125,280 OF oWizard:oMPanel[2] PIXEL
	@020,015 SAY oSay1 VAR "Informe o Servidor SMTP " OF oWizard:oMPanel[2] PIXEL
	@020,100 GET oGet1 VAR cSMTP OF oWizard:oMPanel[2] SIZE 140,009 PIXEL
	@040,015 SAY oSay2 VAR "Informe o Servidor POP " OF oWizard:oMPanel[2] PIXEL
	@040,100 GET oGet2 VAR cPOP OF oWizard:oMPanel[2] SIZE 140,009 PIXEL
	@060,015 SAY oSay3 VAR "Conta do Email " OF oWizard:oMPanel[2] PIXEL
	@060,100 GET oGet3 VAR cCONTA OF oWizard:oMPanel[2] SIZE 140,009 PIXEL
	@080,015 SAY oSay4 VAR "Senha da Conta " OF oWizard:oMPanel[2] PIXEL
	@080,100 GET oGet4 VAR _cSenha Valid .T.  PASSWORD OF oWizard:oMPanel[2] SIZE 50,009 PIXEL
	@100,015 SAY oSay5 VAR "Email para recebimento do XML " OF oWizard:oMPanel[2] PIXEL
	@100,100 GET oGet5 VAR cEMAXML OF oWizard:oMPanel[2] SIZE 140,009 PIXEL

	CREATE PANEL oWizard HEADER "Parametros" MESSAGE "Dados para tratamentos internos..." PANEL BACK {|| oWizard:nPanel := 3, .T.}  EXEC {||lChkTWiz:=.F., .T.}

	@010,010 TO 125,280 OF oWizard:oMPanel[3] PIXEL

	@020,015 SAY oSay6 VAR "EspИcie/Notas Fiscais Normais" OF oWizard:oMPanel[3] PIXEL
	@020,120 GET oGet6 VAR cNF01 OF oWizard:oMPanel[3] SIZE 140,009 PIXEL
	@040,015 SAY oSay7 VAR "EspИcie/Notas Fiscais ServiГos" OF oWizard:oMPanel[3] PIXEL
	@040,120 GET oGet7 VAR cNF02 OF oWizard:oMPanel[3] SIZE 140,009 PIXEL
	@060,015 SAY oSay8 VAR "EspИcie/Conhecimento de Fretes" OF oWizard:oMPanel[3] PIXEL
	@060,120 GET oGet8 VAR cNF03 OF oWizard:oMPanel[3] SIZE 140,009 PIXEL
	@080,015 SAY oSay9 VAR "Mensagem Adicional Corpo do Email" OF oWizard:oMPanel[3] PIXEL
	@080,120 GET oGet9 VAR cMSGXML OF oWizard:oMPanel[3] SIZE 140,009 PIXEL
	@100,015 SAY oSay10 VAR "Receber CСpia SolicitaГЦo XML - Email" OF oWizard:oMPanel[3] PIXEL
	@100,120 GET oGet10 VAR cCCXML OF oWizard:oMPanel[3] SIZE 140,009 PIXEL

	CREATE PANEL oWizard HEADER "Parametros" MESSAGE "Logomarca da Empresa no Email..."  PANEL BACK {|| oWizard:nPanel := 4, .T.} NEXT {|| .T.} FINISH {|| If(Empty(cSMTP), (MsgStop('Informe o servidor SMTP'), .F.), (lWiz := .T., .T.)) } EXEC {|| .T.}

	@010,010 TO 125,280 OF oWizard:oMPanel[4] PIXEL
	@020,015 SAY oSay11 VAR "URL-Logo Empresa-(Tamanho 176x140)" OF oWizard:oMPanel[4] PIXEL
	@020,120 GET oGet11 VAR cURL OF oWizard:oMPanel[4] SIZE 140,009 PIXEL
	@040,015 SAY oSay11 VAR "Senha para ExclusЦo do XML" OF oWizard:oMPanel[4] PIXEL
	@040,120 GET oGet11 VAR cSenXML Valid .T.  PASSWORD OF oWizard:oMPanel[4] SIZE 50,009 PIXEL

	oWizard:oDlg:OPARENT:lEscClose := .F.
	ACTIVATE WIZARD oWizard CENTERED VALID {|| .T. }
	If lWiz
		CONFIRMA()
	EndIf
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Criando novo arquivo												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function CONFIRMA()

Local x := 0

	cr:=ENTER
	_nDiv    := 0
	_cDados     :={}

	AADD( _cDados,"SMTP="+ALLTRIM(cSMTP))
	AADD( _cDados,"POP="+ALLTRIM(cPOP))
	AADD( _cDados,"CONTA="+ALLTRIM(cCONTA))
	AADD( _cDados,"SENHA="+ALLTRIM(_cSenha))
	AADD( _cDados,"EMAXML="+ALLTRIM(cEMAXML))
	AADD( _cDados,"NF01="+ALLTRIM(cNF01))
	AADD( _cDados,"NF02="+ALLTRIM(cNF02))
	AADD( _cDados,"NF03="+ALLTRIM(cNF03))
	AADD( _cDados,"MSGXML="+ALLTRIM(cMSGXML))
	AADD( _cDados,"CCXML="+ALLTRIM(cCCXML))
	AADD( _cDados,"URL="+ALLTRIM(cURL))
	AADD( _cDados,"SENXML="+ALLTRIM(cSenXML))
	hnda:=Fcreate(cArqcfg,0)
	for x := 1 TO LEN( _cDados )
		dados := _cDados[x]
		Fwrite(hnda,dados+cr)
	next
	Fclose(hnda)
	FClose(cArqcfg)
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Lendo arquivo de configuracoes										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function LENDO()

	FT_FUSE(cArqcfg)
	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While !FT_FEOF()
		cBuffer := FT_FREADLN()

		If UPPER(SUBSTR(cBuffer,1,4))=="SMTP"
			cSMTP:=lower(ALLTRIM(SUBSTR(cBuffer,6,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,3))=="POP"
			cPOP:=lower(ALLTRIM(SUBSTR(cBuffer,5,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,5))=="CONTA"
			cCONTA:=lower(ALLTRIM(SUBSTR(cBuffer,7,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,5))=="SENHA"
			_cSenha:=ALLTRIM(SUBSTR(cBuffer,7,400))
		Endif
		If UPPER(SUBSTR(cBuffer,1,6))=="EMAXML"
			cEMAXML:=lower(ALLTRIM(SUBSTR(cBuffer,8,400)))
		Endif
		If UPPER(SUBSTR(cBuffer,1,4))=="NF01"
			cNF01:=ALLTRIM(SUBSTR(cBuffer,6,400))
		Endif
		If UPPER(SUBSTR(cBuffer,1,4))=="NF02"
			cNF02:=ALLTRIM(SUBSTR(cBuffer,6,400))
		Endif
		If UPPER(SUBSTR(cBuffer,1,4))=="NF03"
			cNF03:=ALLTRIM(SUBSTR(cBuffer,6,400))
		Endif
		If UPPER(SUBSTR(cBuffer,1,6))=="MSGXML"
			cMSGXML:=ALLTRIM(SUBSTR(cBuffer,8,400))
		Endif
		If UPPER(SUBSTR(cBuffer,1,5))=="CCXML"
			cCCXML:=ALLTRIM(SUBSTR(cBuffer,7,400))
		Endif
		If UPPER(SUBSTR(cBuffer,1,3))=="URL"
			cURL:=ALLTRIM(SUBSTR(cBuffer,5,400))
		Endif
		If UPPER(SUBSTR(cBuffer,1,6))=="SENXML"
			cSenXML:=ALLTRIM(SUBSTR(cBuffer,8,400))
		Endif
		FT_FSKIP()
	EndDo
	FT_FUSE()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Eliminar Nota Fiscal do browse										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ELIMINA()

	If !Empty(LS2->OK)
		cResp:=Msgbox("Deseja Eliminar a Nota Fiscal para nЦo arquivar o XML?","AtenГЦo...","YESNO")

		If cResp
			DbSelectarea("SF1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SF1")+LS2->NOTA+LS2->SERIE+LS2->FORNEC+LS2->LOJA)
			If Found()
				Reclock("SF1",.F.)
				SF1->F1_TX:="E"
				MsUnlock()

				DbSelectarea("LS2")
				Reclock("LS2",.F.)
				dbdelete()
				MsUnlock()

				OBRWI:oBrowse:refresh()
				OBRWI:oBrowse:setfocus()
				ObjectMethod(oTela,"Refresh()")

				nQtdNF:=(nQtdNF-1)
			Endif
		Endif
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Retornar Nota Fiscal 												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function RETORNA()

	If lCheck4
		cResp:=Msgbox("Deseja Retornar a Nota Fiscal para arquivar o XML?","AtenГЦo...","YESNO")

		If cResp
			DbSelectarea("SF1")
			DbSetorder(1)
			Dbgotop()
			Dbseek(xFilial("SF1")+LS2->NOTA+LS2->SERIE+LS2->FORNEC+LS2->LOJA)
			If Found() .AND. ALLTRIM(SF1->F1_TX)=="E"
				Reclock("SF1",.F.)
				SF1->F1_TX:=""
				MsUnlock()

				DbSelectarea("LS2")
				Reclock("LS2",.F.)
				dbdelete()
				MsUnlock()

				OBRWI:oBrowse:refresh()
				OBRWI:oBrowse:setfocus()
				ObjectMethod(oTela,"Refresh()")

				nQtdNF:=(nQtdNF-1)
			Else
				Msgbox("Esta Nota Fiscal nЦo foi Eliminada para ser retornada!")
			Endif
		Endif
	Endif
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Copiando os novos XML recebidos										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function TEMXML()

Local i := 0
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando arquivos diferentes de XML									Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aImp:={}
	If _cEmpresa=="01"
		ADir("\xmlcli\ArquivaMasipack\*.*",aImp)

		For i:=1 to Len(aImp)
			If !"XML" $ UPPER(ALLTRIM(aImp[i]))
				fErase("\xmlcli\ArquivaMasipack\"+lower(ALLTRIM(aImp[i])))
			Else
				_cFileOri:="\xmlcli\ArquivaMasipack\"+lower(ALLTRIM(aImp[i]))
				FRename(_cFileOri,lower(_cFileOri))
			Endif
		Next
	EndIf 
	If _cEmpresa=="10"
		ADir("\xmlcli\ArquivaFabrima\*.*",aImp)

		For i:=1 to Len(aImp)
			If !"XML" $ UPPER(ALLTRIM(aImp[i]))
				fErase("\xmlcli\ArquivaFabrima\"+lower(ALLTRIM(aImp[i])))
			Else
				_cFileOri:="\xmlcli\ArquivaFabrima\"+lower(ALLTRIM(aImp[i]))
				FRename(_cFileOri,lower(_cFileOri))
			Endif
		Next
	EndIf
	If _cEmpresa=="15"
		ADir("\xmlcli\ArquivaHelsimplast\*.*",aImp)

		For i:=1 to Len(aImp)
			If !"XML" $ UPPER(ALLTRIM(aImp[i]))
				fErase("\xmlcli\ArquivaHelsimplast\"+lower(ALLTRIM(aImp[i])))
			Else
				_cFileOri:="\xmlcli\ArquivaHelsimplast\"+lower(ALLTRIM(aImp[i]))
				FRename(_cFileOri,lower(_cFileOri))
			Endif
		Next
	EndIf
	If _cEmpresa=="40"
		ADir("\xmlcli\ArquivaLabortube\*.*",aImp)

		For i:=1 to Len(aImp)
			If !"XML" $ UPPER(ALLTRIM(aImp[i]))
				fErase("\xmlcli\ArquivaLabortube\"+lower(ALLTRIM(aImp[i])))
			Else
				_cFileOri:="\xmlcli\ArquivaLabortube\"+lower(ALLTRIM(aImp[i]))
				FRename(_cFileOri,lower(_cFileOri))
			Endif
		Next
	EndIf
	If _cEmpresa=="45"
		ADir("\xmlcli\ArquivaMemb\*.*",aImp)

		For i:=1 to Len(aImp)
			If !"XML" $ UPPER(ALLTRIM(aImp[i]))
				fErase("\xmlcli\ArquivaMemb\"+lower(ALLTRIM(aImp[i])))
			Else
				_cFileOri:="\xmlcli\ArquivaMemb\"+lower(ALLTRIM(aImp[i]))
				FRename(_cFileOri,lower(_cFileOri))
			Endif
		Next
	EndIf

	aImp:={}
	ADir("\xmlcli\*.*",aImp)

	For i:=1 to Len(aImp)
		If !"XML" $ UPPER(ALLTRIM(aImp[i]))
			fErase("\xmlcli\"+lower(ALLTRIM(aImp[i])))
		Endif
	Next
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Entradas de Notas Fiscais											Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function ENTRADAS()

Local w := 0
	_nTot01:=0
	_nTot02:=0
	_nTot03:=0
	_nTot04:=0
	_nTot05:=0
	nQtdNF:=0

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando registros anteriores										Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		Reclock("LS2",.F.)
		dbdelete()
		MsUnlock()
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Apagando ultimas especies											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS3")
	Dbgotop()
	While !Eof()
		Reclock("LS3",.F.)
		dbdelete()
		MsUnlock()
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Notas Fiscais Normais												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lCheck1
		nCont:=1
		nPos:=1
		For w:=1 to Len(ALLTRIM(cNF01))
			If SUBSTR(cNF01,w,1)=="/" .OR. (w==Len(ALLTRIM(cNF01)))
				If (w<>Len(ALLTRIM(cNF01)))
					DbSelectarea("LS3")
					Reclock("LS3",.T.)
					LS3->ESPECIE:=SUBSTR(cNF01,nPos,nCont-1)
					LS3->TPNF:="N"
					MsUnlock()
				Else
					DbSelectarea("LS3")
					Reclock("LS3",.T.)
					LS3->ESPECIE:=SUBSTR(cNF01,nPos,nCont+1)
					MsUnlock()
				Endif
				nPos:=(nPos+nCont)
				nCont:=0
			Endif
			nCont:=nCont+1
		Next
	Endif
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Notas Fiscais de Servicos											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lCheck2
		nCont:=1
		nPos:=1
		For w:=1 to Len(ALLTRIM(cNF02))
			If SUBSTR(cNF02,w,1)=="/" .OR. (w==Len(ALLTRIM(cNF02)))
				If (w<>Len(ALLTRIM(cNF02)))
					DbSelectarea("LS3")
					Reclock("LS3",.T.)
					LS3->ESPECIE:=SUBSTR(cNF02,nPos,nCont-1)
					LS3->TPNF:="S"
					MsUnlock()
				Else
					DbSelectarea("LS3")
					Reclock("LS3",.T.)
					LS3->ESPECIE:=SUBSTR(cNF02,nPos,nCont+1)
					MsUnlock()
				Endif
				nPos:=(nPos+nCont)
				nCont:=0
			Endif
			nCont:=nCont+1
		Next
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Conhecimento de Fretes												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lCheck3
		nCont:=1
		nPos:=1
		For w:=1 to Len(ALLTRIM(cNF03))
			If SUBSTR(cNF03,w,1)=="/" .OR. (w==Len(ALLTRIM(cNF03)))
				If (w<>Len(ALLTRIM(cNF03)))
					DbSelectarea("LS3")
					Reclock("LS3",.T.)
					LS3->ESPECIE:=SUBSTR(cNF03,nPos,nCont-1)
					LS3->TPNF:="C"
					MsUnlock()
				Else
					DbSelectarea("LS3")
					Reclock("LS3",.T.)
					LS3->ESPECIE:=SUBSTR(cNF03,nPos,nCont+1)
					MsUnlock()
				Endif
				nPos:=(nPos+nCont)
				nCont:=0
			Endif
			nCont:=nCont+1
		Next
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Filial posicionada													Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("SM0")
	Dbsetorder(1)
	Dbgotop()
	Dbseek(_cEmpFil)

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Filtro das notas fiscais											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !lCheck4
		cQuery:=" SELECT F1_FORNECE FORNECEDOR,F1_LOJA LOJA,F1_DTDIGIT DTDIGIT,F1_CHVNFE CHAVE,F1_DOC NOTA,F1_SERIE SERIE,F1_VALBRUT VALOR,F1_EMISSAO EMISSAO,F1_ESPECIE ESPECIE,F1_HORA HORA "
		cQuery:=cQuery + " FROM SF1"+SM0->M0_CODIGO+"0 "
		cQuery:=cQuery + " WHERE F1_FILIAL ='"+xFilial("SF1")+"' "
		cQuery:=cQuery + " AND F1_DTDIGIT BETWEEN '"+DTOS(_dData01)+"' AND '"+DTOS(_dData02)+"' "
		//	cQuery:=cQuery + " AND F1_DTDIGIT<='"+_dDtVenc+"' "
		cQuery:=cQuery + " AND F1_PREFIXO NOT IN ('ICM','JUR') "
		cQuery:=cQuery + " AND F1_FORMUL<>'S' "
		cQuery:=cQuery + " AND F1_TIPO <> 'N' "
		cQuery:=cQuery + " AND F1_TX=' ' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
	Else
		cQuery:=" SELECT F1_FORNECE FORNECEDOR,F1_LOJA LOJA,F1_DTDIGIT DTDIGIT,F1_CHVNFE CHAVE,F1_DOC NOTA,F1_SERIE SERIE,F1_VALBRUT VALOR,F1_EMISSAO EMISSAO,F1_ESPECIE ESPECIE,F1_HORA HORA "
		cQuery:=cQuery + " FROM SF1"+SM0->M0_CODIGO+"0 "
		cQuery:=cQuery + " WHERE F1_FILIAL ='"+xFilial("SF1")+"' "
		cQuery:=cQuery + " AND F1_DTDIGIT BETWEEN '"+DTOS(_dData01)+"' AND '"+DTOS(_dData02)+"' "
		//cQuery:=cQuery + " AND F1_DTDIGIT<='"+_dDtVenc+"' "
		cQuery:=cQuery + " AND F1_PREFIXO NOT IN ('ICM','JUR') "
		cQuery:=cQuery + " AND F1_FORMUL<>'S' "
		cQuery:=cQuery + " AND F1_TIPO <> 'N' "
		cQuery:=cQuery + " AND F1_TX='E' "
		cQuery:=cQuery + " AND D_E_L_E_T_<>'*' "
	Endif
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectarea("TCQ")
	While !Eof()
		DbSelectarea("LS3")
		DbSetorder(1)
		Dbgotop()
		Dbseek(ALLTRIM(TCQ->ESPECIE))
		If Found() .AND. ALLTRIM(LS3->ESPECIE)==ALLTRIM(TCQ->ESPECIE)

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Mostra somente NF Classificadas										Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lCheck5 .AND. TCQ->VALOR==0
				DbSelectarea("TCQ")
				DbSkip()
				Loop
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Monta Chave nota de servico											Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			_cAno:=SUBSTR(TCQ->EMISSAO,1,4)
			If LS3->TPNF=="S"
				_cCNPJF:=ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+TCQ->FORNECEDOR+TCQ->LOJA,"A1_CGC"))
				_cChvAce:=_cCNPJF+_cAno+strzero(val(TCQ->NOTA),11)
			Else
				_cChvAce:=TCQ->CHAVE
			Endif

			DbSelectarea("LS2")
			Reclock("LS2",.T.)
			LS2->DTDIGIT:=STOD(TCQ->DTDIGIT)
			LS2->FORNEC:=TCQ->FORNECEDOR
			LS2->LOJA:=TCQ->LOJA
			LS2->NOME:=POSICIONE("SA1",1,xFilial("SA1")+TCQ->FORNECEDOR+TCQ->LOJA,"A1_NREDUZ")
			LS2->NOTA:=TCQ->NOTA
			LS2->TELEFONE:=POSICIONE("SA1",1,xFilial("SA1")+TCQ->FORNECEDOR+TCQ->LOJA,"A1_TEL")
			IF SUBSTR(cNumEmp,1,2) <> '15'
				LS2->EMAIL:=LOWER(POSICIONE("SA1",1,xFilial("SA1")+TCQ->FORNECEDOR+TCQ->LOJA,"A1_EMAIL2"))
			ELSE
				LS2->EMAIL:=LOWER(POSICIONE("SA1",1,xFilial("SA1")+TCQ->FORNECEDOR+TCQ->LOJA,"A1_EMAIL"))
			ENDIF	
			LS2->CHAVE:=_cChvAce
			LS2->ESPECIE:=TCQ->ESPECIE
			LS2->SERIE:=TCQ->SERIE
			LS2->VALOR:=TCQ->VALOR
			LS2->EMISSAO:=STOD(TCQ->EMISSAO)
			LS2->CNPJ:=POSICIONE("SA1",1,xFilial("SA1")+TCQ->FORNECEDOR+TCQ->LOJA,"A1_CGC")
			LS2->TIPO:=IIF(TCQ->VALOR>0,"Classificada","PrИ Nota")
			LS2->TPNF:=LS3->TPNF
			nQtdNF:=nQtdNF+1
			MsUnlock()
		Endif
		DbSelectarea("TCQ")
		Dbskip()
	End
	DbClosearea("TCQ")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza Recebimento do XML											Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS1")
	IndRegua("LS1",cArqTrab,"CHAVE",,,)

	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		DbSelectarea("LS1")
		Dbsetorder(1)
		Dbgotop()
		Dbseek(LS2->CHAVE)
		If !Found()
			Reclock("LS2",.F.)
			LS2->OK:="X"
			MsUnlock()
		Endif
		DbSelectarea("LS2")
		Dbskip()
	End

	DbSelectarea("LS1")
	IndRegua("LS1",cArqTrab,"EMISSAO",,,)
	Dbgotop()

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza Flag 														Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		If LS2->OK=="X"
			If Empty(LS2->EMAIL)
				Reclock("LS2",.F.)
				LS2->OK:="E"
				MsUnlock()
			Endif
			If Empty(LS2->CHAVE)
				Reclock("LS2",.F.)
				LS2->OK:="C"
				MsUnlock()
			Endif
			If Len(ALLTRIM(LS2->CHAVE))<>44 .AND. !Empty(LS2->CHAVE) .AND. LS2->TPNF<>"S"
				Reclock("LS2",.F.)
				LS2->OK:="P"
				MsUnlock()
			Endif
		Endif
		Dbskip()
	End

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Totalizando Situacao												Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectarea("LS2")
	Dbgotop()
	While !Eof()
		If Empty(LS2->OK)	//XML Recebidos
			_nTot01:=_nTot01+1
		Endif
		If LS2->OK=="X"    //Sem XML
			_nTot02:=_nTot02+1
		Endif
		If LS2->OK=="C"	    //Sem Chave Eletronica
			_nTot03:=_nTot03+1
		Endif
		If LS2->OK=="E"	    //Sem Email
			_nTot04:=_nTot04+1
		Endif
		If LS2->OK=="P"	    //Chave Eletronica Incorreta
			_nTot05:=_nTot05+1
		Endif
		Dbskip()
	End
	DbSelectarea("LS2")
	Dbgotop()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Deletando registros da tabela ARQXML								Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function DELXML()

	DbSelectarea("LS1")
	IndRegua("LS1",cArqTrab,"CHAVE",,,)

	cQuery:=" SELECT CHAVE FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' GROUP BY CHAVE "
	TCQUERY cQuery NEW ALIAS "TCQ"
	DbSelectarea("TCQ")
	While !Eof()
		DbSelectarea("LS1")
		DbSetorder(1)
		Dbgotop()
		Dbseek(ALLTRIM(TCQ->CHAVE))
		If !Found()
			cQuere:=" DELETE FROM ARQXML WHERE EMPFIL='"+_cEmpFil+"' AND CHAVE='"+TCQ->CHAVE+"' "
			TCSQLEXEC(cQuere)
		Endif
		DbSelectarea("TCQ")
		Dbskip()
	End
	DbCloseArea("TCQ")
	DbSelectarea("LS1")
	IndRegua("LS1",cArqTrab,"EMISSAO",,,)
	Dbgotop()
Return

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Funcao Consulta SEFAZ												Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function SEFAZ(cOpc)
	If cOpc==1
		If ALLTRIM(LS1->TIPO)=="NF"
			SEFAZNFE(LS1->CHAVE,cIdEnt,1)
		Else
			Msgbox("Somente Notas Fiscais de compra poderЦo ser consultadas!")
		Endif
	Else
		cResp:=msgbox("Verificar todos os XML nЦo autorizados?","AtenГЦo...","YESNO")

		If cResp
			DbSelectarea("LS1")
			Dbgotop()
			While !Eof()
				If ALLTRIM(LS1->TIPO)=="NF"
					cMsgRet:=SEFAZNFE(LS1->CHAVE,cIdEnt,2)

					If !"AUTORIZADO O USO" $ cMsgRet .AND. !Empty(cMsgRet)
						Reclock("LS1",.F.)
						LS1->SITUAC:="C"
						MsUnlock()
					Endif
				Endif
				Dbskip()
			End
			Dbgotop()
		Endif
	Endif
Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁEntidade																   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function IDENTCLI()

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁObtem o codigo da entidade                                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"

	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
	EndIf
	RestArea(aArea)
Return(cIdEnt)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁConsulta Status na Sefaz										Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function SEFAZNFE(cChaveNFe,cIdEnt,cOpcao)

	Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMensagem:= ""
	Local lErro := .F.
	Local oWs

	lWeb := .F.
	cMsgRet:=''
	oWs:= WsNFeSBra():New()
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := cIdEnt
	ows:cCHVNFE	   := cChaveNFe
	oWs:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"

	If oWs:ConsultaChaveNFE()
		If cOpcao==1 //Somente Uma pesquisa
			cMensagem := ""
			If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
				cMensagem += "VersЦo da Mensagem"+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
			EndIf
			cMensagem += "Ambiente"+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"ProduГЦo","HomologaГЦo")+CRLF
			cMensagem += "Cod.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
			cMensagem += "Msg.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
			If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
				cMensagem += "Protocolo"+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
			EndIf
			If oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE # "100"
				lErro := .T.
			EndIf

			If !lWeb
				Aviso("Consulta da Nota Fiscal",cMensagem,{"Ok"},3)
			Endif
		Else	//Pesquisando todos os arquivos
			If !lWeb
				cMsgRet:=UPPER(ALLTRIM(oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF))
			Endif
		Endif
	Endif
Return(cMsgRet)
