#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "rptdef.ch"
#include "fwprintsetup.ch"
#include "colors.ch"

/*/
-------------------------------------------------------------------------------
{Protheus.doc} PREDNFLOAD
Esta function tem como objetivo realizar os filtros de notas a serem impressas
na rotina PREDANFE.
Sua utilização se encontra dentro da rotina SPEDNFE, no menu "outras ações",
que está sendo chamado no P.E FISTRNFE.prw

@author T. MORAES [DS2U]
@since 02.ago.2021
@type function
-------------------------------------------------------------------------------
/*/

user function PREDNFLOAD(cMod)
Local _aMvPar 		:= {}
Local _nX			:= 0
Local aPergs		:= {}
Local aRet			:= {}

	For _nX := 1 To 40
		aAdd(_aMvPar, &( "MV_PAR" + StrZero( _nX, 2, 0 ) ) )
	Next _nX

	If FUNNAME() = "MATA410"
		PREDANFE(cMod)
	ElseIf FwAlertYesNo("Deseja imprimir a NF "+AllTrim(SF2->F2_DOC)+" posicionada?")
		PREDANFE(cMod)
	Else
		//parambox
		aAdd( aPergs ,{1,"Série de: "    , Upper(Space(1))    ,"","","","",15,.T.})
		aAdd( aPergs ,{1,"Série Até: "    , Upper(Space(1))    ,"","","","",15,.T.})
		aAdd( aPergs ,{1,"Documento de: "    , Upper(Space(9))    ,"","","","",30,.T.})		
		aAdd( aPergs ,{1,"Documento Até: "    , Upper(Space(9))    ,"","","","",30,.T.})
		
		If ParamBox(aPergs ,"DNFPARBOX",aRet,{|| .T. },,,,,,,,)
			SF2->(dbSeek(FWxFilial('SF2') + PadR(MV_PAR03,TamSX3('F2_DOC')[1]) + PadR(MV_PAR01,TamSX3('F2_SERIE')[1]) ))
			While SF2->(!EOF()) .And. SF2->(F2_DOC+F2_SERIE) >= PadR(MV_PAR03,TamSX3('F2_DOC')[1]) + PadR(MV_PAR01,TamSX3('F2_SERIE')[1]) .And. SF2->(F2_DOC+F2_SERIE) <= PadR(MV_PAR04,TamSX3('F2_DOC')[1]) + PadR(MV_PAR02,TamSX3('F2_SERIE')[1])
				PREDANFE(cMod)
				SF2->(dbSkip())
			Enddo
		EndIf
	Endif

	For _nX := 1 To Len( _aMvPar )
		&( "MV_PAR" + StrZero( _nX, 2, 0 ) ) := _aMvPar[ _nX ]
	Next _nX

return

/*/
-------------------------------------------------------------------------------
{Protheus.doc} PREDANFE
Esta rotina tem como objetivo realizar impressão de uma DANFE antes da 
transmissão para SEFAZ.

@author T. MORAES [DS2U]
@since 12.jul.2021
@type function
-------------------------------------------------------------------------------
/*/

#define ESPLIN		2
#define IMP_SPOOL	2
#define MAXMSG		80												// Maximo de dados adicionais por pagina
#define MAXITEM		22												// Maximo de produtos para a primeira pagina
#define MAXITEMP2	49												// Maximo de produtos para a pagina 2 em diante
#define MAXITEMC	38												// Maximo de caracteres por linha de produtos/servicos
#define _MAXIMP		62												// Maximo de impostos calculados pela funcao FIMPOSTOS

Static function PREDANFE(cMod)
	Local aArea 		:= GetArea()
	Local nMaxDes	    := MAXITEMC
	Local nMaxImp		:= _MAXIMP
	private nConsTex 	:= 0.5											// Constante para consertar o calculo retornado pelo GetTextWidth.
	private nFolha 		:= 1
	private nFolhas 	:= 1
	private lExistNfe 	:= .T.
	
	private aEmpresa 	:= {}
	private aDestinat 	:= {}
	private aTotais 	:= {}
	private aTransp 	:= {}
	private aISSQN 		:= {}
	private aNotaF 		:= {}
	private aItens 		:= {}
	private aFaturas 	:= {}
	private aTabImposto := {}
	private cMensagem 	:= {}
	private cResFisco 	:= ""
	private aTot 		:= {}
	private nModImp 	:= IIf(Empty(SF2->F2_DOC),1,0)
	
	private oPrinter	:= FWMSPrinter():New( 'PRE_'+ALLTRIM(SF2->F2_DOC) , IMP_PDF, .F., "c:\relato_microsiga\", .T. )
	private oFont07 	:= TFontEx():New(oPrinter,"Times New Roman",06,06,.F.,.T.,.F.)
	private oFont07N 	:= TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)
	private oFont08 	:= TFontEx():New(oPrinter,"Times New Roman",05,07,.F.,.T.,.F.)
	private oFont08N 	:= TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)
	private oFont09 	:= TFontEx():New(oPrinter,"Times New Roman",08,08,.F.,.T.,.F.)
	private oFont09N 	:= TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)
	private oFont10 	:= TFontEx():New(oPrinter,"Times New Roman",09,09,.F.,.T.,.F.)
	private oFont10N 	:= TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)
	private oFont11 	:= TFontEx():New(oPrinter,"Times New Roman",10,10,.F.,.T.,.F.)
	private oFont11N 	:= TFontEx():New(oPrinter,"Times New Roman",10,10,.T.,.T.,.F.)
	private oFont12 	:= TFontEx():New(oPrinter,"Times New Roman",11,11,.F.,.T.,.F.)
	private oFont12N 	:= TFontEx():New(oPrinter,"Times New Roman",11,11,.T.,.T.,.F.)
	private oFont18N 	:= TFontEx():New(oPrinter,"Times New Roman",17,17,.T.,.T.,.F.)
	private oFont19N 	:= TFontEx():New(oPrinter,"Times New Roman",07,07,.T.,.T.,.F.)


	oPrinter:cPathPdf	:="c:\relato_microsiga\"
	oPrinter:cPathPrint	:="c:\relato_microsiga\"
	oPrinter:SetResolution(78)	//Tamanho estipulado para a Danfe
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(60,60,60,60)

	If FUNNAME() = "SPEDNFE"
		RptStatus({|| DPreDanfeNF(IIf(cMod == "S","1","0"),SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE)},"Gravando o dados da "+IIf(nModImp == 1,"PRE-NOTA","PRE-DANFE")+" de saida...")
	else
		RptStatus({|| DPreDanfePV(IIf(cMod == "S","1","0"),SC5->C5_NUM,SC5->C5_CLIENTE)},"Gravando o dados da "+IIf(nModImp == 1,"PRE-NOTA","PRE-DANFE")+" de saida...")
	endif

	
	if lExistNfe
		RptStatus({|| PreDanfeProc(cMod)},"Imprimindo "+IIf(nModImp == 1,"PRE-NOTA","PRE-DANFE")+"...")
		
		oPrinter:Preview()												//Visualiza antes de imprimir
	endif
	
	FreeObj(oPrinter)
	
	oPrinter := nil
	
	RestArea(aArea)
return

/*===============================================
| GERANDO DADOS DA PRE-DANFE PELA NOTA FISCAL    |
/================================================*/

static function DPreDanfeNF(cModNF,cNota,cSerie,cCliFor)
	local aCampo 		:= {}
	local aTes 			:= {}
	local nTotServico 	:= 0
	Local nMaxDes	    := MAXITEMC
	
	//--------------------------------------------------------------------------
	// Dados da empresa emitente
	//--------------------------------------------------------------------------
	
	DbSelectArea("SM0")
	SM0->(DbSeek(cEmpAnt+cFilAnt,.F.))
	
	AAdd(aEmpresa,AllTrim(SM0->M0_NOMECOM))															// 01 Razão Social
	AAdd(aEmpresa,AllTrim(SM0->M0_ENDCOB))															// 02 Endereço/Número
	AAdd(aEmpresa,AllTrim(SM0->M0_BAIRCOB)+" - CEP: "+Transf(SM0->M0_CEPCOB,"@R 99999-999"))		// 03 Bairro/CEP
	AAdd(aEmpresa,AllTrim(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB)										// 04 Município/Estado
	AAdd(aEmpresa,"Fone: 31 "+Transf(Right(AllTrim(SM0->M0_TEL),8),"@R 9999-9999"))					// 05 Telefone
	AAdd(aEmpresa,GetSrvProfString("Startpath","")+"DANFE"+cEmpAnt+cFilAnt+".BMP")					// 06 Logomarca
	AAdd(aEmpresa,AllTrim(SM0->M0_CGC))																// 07 CNPJ
	AAdd(aEmpresa,AllTrim(SM0->M0_INSC))															// 08 Inscricao Estadual
	AAdd(aEmpresa,AllTrim(SM0->M0_INSCM))															// 09 Inscricao Municipal
	
	//--------------------------------------------------------------------------
	// Dados da nota fiscal
	//--------------------------------------------------------------------------
	
	if cModNF == "1"
		cAliasNF := "SF2"
		nIndice := 2
	else
		cAliasNF := "SF1"
		nIndice := 1
	endif
	
	aCampo := {{"F1_TIPO","F1_EMISSAO","F1_HORA","00/00/0000","F1_TRANSP"},;
				{"F2_TIPO","F2_EMISSAO","F2_HORA","F2_MSDTCOL","F2_TRANSP","F2_LOJA"}}
	
	DbSelectArea(cAliasNF)
	(cAliasNF)->(DbSeek(xFilial(cAliasNF)+cNota+cSerie+cCliFor,.F.))
	
	AAdd(aNotaF,cModNF)																// 01 Modelo (0-entrada/1-saída)
	AAdd(aNotaF,cNota)																// 02 Nota Fiscal
	AAdd(aNotaF,cSerie)																// 03 Série
	AAdd(aNotaF,cCliFor)															// 04 Cliente/Fornecedor
	AAdd(aNotaF,(cAliasNF)->&(aCampo[nIndice][6]))									// 05 Cliente/Fornecedor
	AAdd(aNotaF,(cAliasNF)->&(aCampo[nIndice][1]))									// 06 Tipo
	AAdd(aNotaF,DToS((cAliasNF)->&(aCampo[nIndice][2])))							// 07 Data Emissao
	
	if Empty((cAliasNF)->&(aCampo[nIndice][4]))										// 08 Data Saída
		AAdd(aNotaF,DToS((cAliasNF)->&(aCampo[nIndice][2])))
	else
		AAdd(aNotaF,DToS((cAliasNF)->&(aCampo[nIndice][4])))
	endif
	
	AAdd(aNotaF,(cAliasNF)->&(aCampo[nIndice][3])+":00")							// 09 Hora
	AAdd(aNotaF,(cAliasNF)->&(aCampo[nIndice][5]))									// 10 Transportadora
	AAdd(aNotaF,"")																	// 11 Natureza Operação (está sendo atribuido valor na parte dos itens)
	
	//--------------------------------------------------------------------------
	// Dados do cliente/fornecedor
	//--------------------------------------------------------------------------
	
	if cModNF == "1"
		if aNotaF[6] $ "B/D"
			cAliasCF := "SA2"
			nIndice1 := 2
		else
			cAliasCF := "SA1"
			nIndice1 := 1
		endif
	else
		if aNotaF[6] $ "B/D"
			cAliasCF := "SA1"
			nIndice1 := 1
		else
			cAliasCF := "SA2"
			nIndice1 := 2
		endif
	endif
	
	aCampo := {{"A1_PESSOA","A1_NOME","A1_CGC","A1_END","A1_NR_END","A1_BAIRRO","A1_CEP","A1_MUN","A1_DDD","A1_TEL","A1_EST","A1_INSCR","A1_INSCRM"},;
				{"A2_TIPO","A2_NOME","A2_CGC","A2_END","A2_NR_END","A2_BAIRRO","A2_CEP","A2_MUN","A2_DDD","A2_TEL","A2_EST","A2_INSCR","A2_INSCRM"}}
	
	DbSelectArea(cAliasCF)
	(cAliasCF)->(DbSeek(xFilial(cAliasCF)+cCliFor,.F.))
	
	AAdd(aDestinat,(cAliasCF)->&(aCampo[nIndice1][1]))																// 01 Pessoa Física/Pessoa Jurídica
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][2])))														// 02 Razão Social
	AAdd(aDestinat,(cAliasCF)->&(aCampo[nIndice1][3]))																// 03 CNPJ/CPF
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][4])))														// 04 Endereço
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][6])))														// 05 Bairro
	AAdd(aDestinat,Transf((cAliasCF)->&(aCampo[nIndice1][7]),"@R 99999-999"))										// 06 CEP
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][8])))														// 07 Municipio
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][9]))+AllTrim((cAliasCF)->&(aCampo[nIndice1][10])))		// 08 Telefone ou Fax
	AAdd(aDestinat,(cAliasCF)->&(aCampo[nIndice1][11]))																// 09 Estado
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][12])))													// 10 Inscrição Estadual
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][13])))													// 11 Inscrição Municipal
	
	//--------------------------------------------------------------------------
	// Dados da fatura
	//--------------------------------------------------------------------------
	
	if cModNF == "1"
		cAliasFT := "SE1"
		nIndice := 2
		nIndOrd := 2
	else
		cAliasFT := "SE2"
		nIndice := 1
		nIndOrd := 6
	endif
	
	aCampo := {{"E2_NUM","E2_PREFIXO","E2_VALOR","E2_VENCTO","E2_FORNECE","E2_LOJA"},;
				{"E1_NUM","E1_PREFIXO","E1_VALOR","E1_VENCTO","E1_CLIENTE","E1_LOJA"}}
	
	DbSelectArea(cAliasFT)
	(cAliasFT)->(DbSetOrder(nIndOrd))
	
	if (cAliasFT)->(DbSeek(xFilial(cAliasFT)+aNotaF[4]+aNotaF[3]+aNotaF[2],.F.))
		while !(cAliasFT)->(Eof()) .and. (cAliasFT)->&(aCampo[nIndice][2])+(cAliasFT)->&(aCampo[nIndice][1]) == aNotaF[3]+aNotaF[2] .and. (cAliasFT)->&(aCampo[nIndice][5])+(cAliasFT)->&(aCampo[nIndice][6]) == aNotaF[4]
			AAdd(aFaturas,{(cAliasFT)->&(aCampo[nIndice][2]),;														// 01 Prefixo 
							(cAliasFT)->&(aCampo[nIndice][1]),;														// 02 Número
							DToS((cAliasFT)->&(aCampo[nIndice][4])),;												// 03 Data Vencimento
							AllTrim(Transf((cAliasFT)->&(aCampo[nIndice][3]),"@E 9,999,999,999,999.99"))})			// 04 Valor
		
			(cAliasFT)->(DbSkip())
		enddo
	endif
	
	//--------------------------------------------------------------------------
	// Dados dos impostos
	//--------------------------------------------------------------------------
	
	aCampo := {{"F1_BASEICM","F1_VALICM","F1_VALMERC","F1_FRETE","F1_SEGURO","F1_DESCONT","F1_DESPESA","F1_VALIPI","F1_VALBRUT","F1_BRICMS","F1_ICMSRET"},;
				{"F2_BASEICM","F2_VALICM","F2_VALMERC","F2_FRETE","F2_SEGURO","F2_DESCONT","F2_DESPESA","F2_VALIPI","F2_VALBRUT","F2_BRICMS","F2_ICMSRET","F2_BASIMP6","F2_VALIMP6","F2_VALIMP5"}}
	
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][1]),"@E 9,999,999,999,999.99"))			// 01 Base calculo ICMS
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][2]),"@E 9,999,999,999,999.99"))			// 02 Valor ICMS
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][10]),"@E 9,999,999,999,999.99"))			// 03 Base calculo ICMS ST
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][11]),"@E 9,999,999,999,999.99"))			// 04 Valor ICMS ST
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][3]),"@E 9,999,999,999,999.99"))			// 05 Valor Total Produto
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][4]),"@E 9,999,999,999,999.99"))			// 06 Valor Frete
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][5]),"@E 9,999,999,999,999.99"))			// 07 Valor Seguro
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][6]),"@E 9,999,999,999,999.99"))			// 08 Valor Desconto
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][7]),"@E 9,999,999,999,999.99"))			// 09 Outras Despesas
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][8]),"@E 9,999,999,999,999.99"))			// 10 Valor IPI
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][12]),"@E 9,999,999,999,999.99"))			// 11 Base calculo PIS/COFINS
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][13]),"@E 9,999,999,999,999.99"))			// 12 Valor PIS
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][14]),"@E 9,999,999,999,999.99"))			// 13 Valor COFINS
	AAdd(aTotais,Transf((cAliasNF)->&(aCampo[nIndice][9]),"@E 9,999,999,999,999.99"))			// 14 Valor Total Nota
	
	//--------------------------------------------------------------------------
	// Dados da transportadora
	//--------------------------------------------------------------------------
	
	DbSelectArea("SA4")
	
	if SA4->(DbSeek(xFilial("SA4")+aNotaF[9],.F.))
		AAdd(aTransp,AllTrim(SA4->A4_NOME))															// 01 Razão Social
		
		if Len(AllTrim(SA4->A4_CGC)) == 14
			cAux := Transf(SA4->A4_CGC,"@R 99.999.999/9999-99")
		else
			cAux := Transf(SA4->A4_CGC,"@R 999.999.999-99")
		endif
		
		AAdd(aTransp,cAux)																			// 02 CNPJ/CPF
		AAdd(aTransp,AllTrim(SA4->A4_END))															// 03 EndereÃ§o
		AAdd(aTransp,AllTrim(SA4->A4_MUN))															// 04 MunicÃ­pio
		AAdd(aTransp,SA4->A4_EST)																	// 05 UF
		AAdd(aTransp,IIf(Empty(SA4->A4_INSEST),"ISENTO",AllTrim(SA4->A4_INSEST)))					// 06 InscriÃ§Ã£o Estadual
	else
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
	endif
	
	DbSelectArea("SC5")
	DbSetOrder(8)
	DbSeek(xFilial("SC5")+aNotaF[2]+aNotaF[3]+aNotaF[4],.F.)
	
	do case															// 07 Frete por Conta
		case SC5->C5_TPFRETE == "C"
			AAdd(aTransp,"0")
		case SC5->C5_TPFRETE == "F"
			AAdd(aTransp,"1")
		case SC5->C5_TPFRETE == "T"
			AAdd(aTransp,"2")
		case SC5->C5_TPFRETE == "S"
			AAdd(aTransp,"9")
		otherwise
			AAdd(aTransp,"1")
	endcase
	
	AAdd(aTransp,"")												// 08 Código ANTT
	AAdd(aTransp,"")												// 09 Placa do Veículo SC5->C5_PLACA
	AAdd(aTransp,SC5->C5_UFORIG)									// 10 UF SC5->C5_UFPLACA
	
	if !Empty(SC5->C5_VOLUME1)
		AAdd(aTransp,AllTrim(Str(Round(SC5->C5_VOLUME1,0))))		// 11 Quantidade
	else
		AAdd(aTransp,"")
	endif
	
	AAdd(aTransp,AllTrim(SC5->C5_ESPECI1))							// 12 Espécie
	AAdd(aTransp,"")												// 13 Marca
	AAdd(aTransp,"")												// 14 Numeração
	
	if !Empty(SC5->C5_PBRUTO)
		AAdd(aTransp,Transf(SC5->C5_PBRUTO,"@E 999999.999"))		// 15 Peso Bruto
	else
		AAdd(aTransp,"")
	endif
	
	if !Empty(SC5->C5_PESOL)
		AAdd(aTransp,Transf(SC5->C5_PESOL,"@E 999999.999"))			// 16 Peso Líquido
	else
		AAdd(aTransp,"")
	endif
	
	/*if !Empty(aTransp[1])
		if Empty(aTransp[9]) .or. Empty(aTransp[10])
			MsgAlert("Esta faltando preencher a PLACA ou a UF do veiculo.")
			
			lExistNfe := .F.
		endif
	endif*/
	
	//--------------------------------------------------------------------------
	// Dados do ISSQN
	//--------------------------------------------------------------------------
	
	aCampo := {{"F1_VALMERC","F1_ISS"},;
				{"F2_BASEISS","F2_VALISS"}}
	
	if !Empty((cAliasNF)->&(aCampo[nIndice][2]))
		AAdd(aISSQN,aEmpresa[09])																//01 Inscrição Municipal
		AAdd(aISSQN,"")																			//02 Valor Total servicos (está sendo atribuido valor na parte dos itens)
		AAdd(aISSQN,Transf((cAliasNF)->&(aCampo[nIndice][1]),"@E 99,999,999,999.99"))			//03 Base calculo ISSQN
		AAdd(aISSQN,Transf((cAliasNF)->&(aCampo[nIndice][2]),"@E 99,999,999,999.99"))			//04 Valor ISSQN
	else
		AAdd(aISSQN,"")
		AAdd(aISSQN,"")
		AAdd(aISSQN,"")
		AAdd(aISSQN,"")
	endif
	
	//--------------------------------------------------------------------------
	// Dados do produto/servico
	//--------------------------------------------------------------------------
	
	if cModNF == "1"
		cAliasIT := "SD2"
		nIndice := 2
		nIndOrd := 3
	else
		cAliasIT := "SD1"
		nIndice := 1
		nIndOrd := 1
	endif
	
	aCampo := {{"D1_DOC","D1_SERIE","D1_FORNECE","D1_LOJA","D1_DESCPRO","D1_COD","D1_TES","D1_CF","D1_CLASFIS","D1_UM","D1_QUANT","D1_VUNIT","D1_TOTAL","D1_BASEICM","D1_VALICM","D1_VALIPI","D1_PICM","D1_IPI","D1_VALISS"},;
				{"D2_DOC","D2_SERIE","D2_CLIENTE","D2_LOJA","C6_DESCRI","D2_COD","D2_TES","D2_CF","D2_CLASFIS","D2_UM","D2_QUANT","D2_PRCVEN","D2_TOTAL","D2_BASEICM","D2_VALICM","D2_VALIPI","D2_PICM","D2_IPI","D2_VALISS"}}
	
	DbSelectArea(cAliasIT)
	(cAliasIT)->(DbSetOrder(nIndOrd))
	(cAliasIT)->(DbSeek(xFilial(cAliasIT)+aNotaF[2]+aNotaF[3]+aNotaF[4],.F.))
	
	nItem := 0
	
	while !(cAliasIT)->(Eof()) .and. (cAliasIT)->&(aCampo[nIndice][1]) == aNotaF[2] .and. (cAliasIT)->&(aCampo[nIndice][2]) == aNotaF[3] .and. (cAliasIT)->&(aCampo[nIndice][3]) == aNotaF[4] .and. (cAliasIT)->&(aCampo[nIndice][4]) == aNotaF[5]
		if cAliasIT == "SD2"
			DbSelectArea("SC6")
			DbSetOrder(4)
			DbSeek(xFilial("SC6")+aNotaF[2]+aNotaF[3]+SD2->D2_ITEMPV,.F.)
		endif
		
		cDescri := IIf(SB1->(DbSeek(xFilial("SB1")+(cAliasIT)->&(aCampo[nIndice][6]),.F.)),AllTrim(SB1->B1_DESC),"")
		
		DbSelectArea(cAliasIT)
		
		cNcm := IIf(SB1->(DbSeek(xFilial("SB1")+(cAliasIT)->&(aCampo[nIndice][6]),.F.)),AllTrim(SB1->B1_POSIPI),"")
		cTes := (cAliasIT)->&(aCampo[nIndice][7])
		
		if (nInd := AScan(aTes,{|x| x[1] == cTes})) == 0
			AAdd(aTes,{cTes,IIf(SF4->(DbSeek(xFilial("SF4")+cTes,.F.)),AllTrim(SF4->F4_FINALID),""),AllTrim((cAliasIT)->&(aCampo[nIndice][8]))})
			
			aNotaF[10] := AllTrim(SF4->F4_FINALID)+"/"
		endif
		
		AAdd(aItens,{Left(&(aCampo[nIndice][6]),15),;																	// 01 Codigo Produto
						MemoLine(cDescri,nMaxDes,1),;																	// 02 descricao do Produto
						cNcm,;																							// 03 NCM
						&(aCampo[nIndice][9]),;																			// 04 CST
						&(aCampo[nIndice][8]),;																			// 05 CFOP
						&(aCampo[nIndice][10]),;																		// 06 Unidade
						AllTrim(Transf(&(aCampo[nIndice][11]),PesqPict(cAliasIT,aCampo[nIndice][11]))),;				// 07 Quantidade
						AllTrim(Transf(&(aCampo[nIndice][12]),PesqPict(cAliasIT,aCampo[nIndice][12]))),;				// 08 Valor Unitário
						AllTrim(Transf(&(aCampo[nIndice][13]),PesqPict(cAliasIT,aCampo[nIndice][13]))),;				// 09 Valor Total
						AllTrim(Transf(&(aCampo[nIndice][14]),PesqPict(cAliasIT,aCampo[nIndice][14]))),;				// 10 Base calculo ICMS
						AllTrim(Transf(&(aCampo[nIndice][15]),PesqPict(cAliasIT,aCampo[nIndice][15]))),;				// 11 Valor ICMS
						AllTrim(Transf(&(aCampo[nIndice][16]),PesqPict(cAliasIT,aCampo[nIndice][16]))),;				// 12 Valor IPI
						AllTrim(Transf(&(aCampo[nIndice][17]),"@E 99.99%")),;											// 13 Aliquota ICMS
						AllTrim(Transf(&(aCampo[nIndice][18]),"@E 99.99%"))})											// 14 Aliquota IPI
		
		nItem++
		
		/*if MLCount(cDescri,nMaxDes) > 1
			for k := 2 to MLCount(cDescri,nMaxDes)
				AAdd(aItens,{"",MemoLine(cDescri,nMaxDes,k),"","","","","","","","","","","",""})
				
				nItem++
			next
		endif*/
		
		if !Empty((cAliasIT)->&(aCampo[nIndice][19]))
			nTotServico += (cAliasIT)->&(aCampo[nIndice][13])
		endif
		
		(cAliasIT)->(DbSkip())
	enddo
	
	if !Empty(nTotServico)
		aISSQN[2] := Transf(nTotServico,"@E 99,999,999,999.99")
	endif
	
	nItem -= MAXITEM
	lFlag := .T.
	
	while lFlag
		if nItem > 0
			nFolhas++
			
			nItem -= MAXITEMP2
		else
			lFlag := .F.
		endif
	enddo
	
	//--------------------------------------------------------------------------
	// Dados dos dados adicionais
	//--------------------------------------------------------------------------
	
	cProjetos := "Projeto(s): "+Projetos(aNotaF[2],aNotaF[3],Left(aNotaF[4],6),Right(aNotaF[4],2),cAliasNF)

	If !(cEmpAnt $ "15") 
		dbSelectArea('SZO')
		SZO->(DbSetOrder(1))
		SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
		If SZO->(FOUND()) .And. !Empty(Alltrim(MEMOLINE(SZO->ZO_MENS,130,1))) 
			cMensagem := AllTrim(SZO->ZO_MENS)+" "+Chr(13)+Chr(10)+cProjetos
		Else
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))
			If SC5->(FOUND())
				cMensagem := AllTrim(SC5->C5_MENNOTA)+" "+Chr(13)+Chr(10)+cProjetos
			EndIf
		EndIf
		cResFisco := " "
	Else
		cMensagem := IIF( SF2->(FieldPos("F2_MENNOTA")) > 0, AllTrim(SF2->F2_MENNOTA),AllTrim(SC5->C5_MENNOTA))
	EndIf
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))
	If SC5->(FOUND())
		cRetForm := FORMULA(SC5->C5_MENPAD)
	Else
		cRetForm :=""
	EndIf
	if !(ValType(cRetForm) == nil) .and. !(AllTrim(cRetForm) $ cMensagem)
		If Len(cMensagem) > 0 .And. SubStr(cMensagem, Len(cMensagem), 1) <> " "
			cMensagem += " "
		EndIf
		cMensagem += AllTrim(cRetForm)
	endif

	If !EMPTY(SC5->C5_PC)
		cMensagem += " | Nº Ped. Cliente: " + ALLTRIM(SC5->C5_PC)
	If !(Alltrim(cRetForm) $ cMensagem)
		cMensagem += cRetForm
	Endif
	cMensagem += " | *** N/NF REF PV: " + SC5->C5_NUM + " ***"

	Endif
	
	//--------------------------------------------------------------------------
	// Dados folha da tabela de impostos
	//--------------------------------------------------------------------------
	
	TabImpostos(cModNF)
return

/*===================================================
| GERANDO DADOS DA PRE-DANFE PELO PEDIDO DE VENDA    |
/===================================================*/

static function DPreDanfePV(cModNF,cPedVen,cCliFor)
Local aCampo		:= {}
Local aTes			:= {}
Local nTotNota		:= 0
Local nTotServico 	:= 0
Local nMaxImp		:=_MAXIMP
Local nMaxDes	    := MAXITEMC

//--------------------------------------------------------------------------
// Dados da empresa emitente
//--------------------------------------------------------------------------

DbSelectArea("SM0")
SM0->(DbSeek(cEmpAnt+cFilAnt,.F.))

AAdd(aEmpresa,AllTrim(SM0->M0_NOMECOM))															// 01 Razão Social
AAdd(aEmpresa,AllTrim(SM0->M0_ENDCOB))															// 02 Endereco/Numero
AAdd(aEmpresa,AllTrim(SM0->M0_BAIRCOB)+" - CEP: "+Transf(SM0->M0_CEPCOB,"@R 99999-999"))		// 03 Bairro/CEP
AAdd(aEmpresa,AllTrim(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB)										// 04 Municipio/Estado
AAdd(aEmpresa,"Fone: 31 "+Transf(Right(AllTrim(SM0->M0_TEL),8),"@R 9999-9999"))					// 05 Telefone
AAdd(aEmpresa,GetSrvProfString("Startpath","")+"DANFE"+cEmpAnt+cFilAnt+".BMP")					// 06 Logomarca
AAdd(aEmpresa,AllTrim(SM0->M0_CGC))																// 07 CNPJ
AAdd(aEmpresa,AllTrim(SM0->M0_INSC))															// 08 Inscricao Estadual
AAdd(aEmpresa,AllTrim(SM0->M0_INSCM))															// 09 Inscricao Municipal

//--------------------------------------------------------------------------
// Dados do pedido de venda
//--------------------------------------------------------------------------

DbSelectArea("SC5")
SC5->(DbSeek(xFilial("SC5")+cPedVen,.F.))

AAdd(aNotaF,cModNF)																// 01 Módulo (0-entrada/1-saída)
AAdd(aNotaF,cPedVen)															// 02 Nota Fiscal
AAdd(aNotaF,"")																	// 03 Série
AAdd(aNotaF,cCliFor)															// 04 Cliente/Fornecedor
AAdd(aNotaF,SC5->C5_LOJACLI)													// 05 Loja
AAdd(aNotaF,SC5->C5_TIPO)														// 06 Tipo
AAdd(aNotaF,DToS(SC5->C5_EMISSAO))												// 07 Data Emissão
AAdd(aNotaF,DToS(SC5->C5_EMISSAO))												// 08 Data Saída
AAdd(aNotaF,"")																	// 09 Hora
AAdd(aNotaF,SC5->C5_TRANSP)														// 10 Transportadora
AAdd(aNotaF,"")																	// 11 Natureza Operação (está sendo atribuido valor na parte dos itens)
AAdd(aNotaF,AllTrim(SC5->C5_TPFRETE))											// 12 Tipo do Frete
AAdd(aNotaF,"")																	// 13 Placa do Veiculo
AAdd(aNotaF,"")																	// 14 UF
AAdd(aNotaF,SC5->C5_VOLUME1)													// 15 Quantidade
AAdd(aNotaF,AllTrim(SC5->C5_ESPECI1))											// 16 Especie
AAdd(aNotaF,SC5->C5_PBRUTO)														// 17 Peso Bruto
AAdd(aNotaF,SC5->C5_PESOL)														// 18 Peso Liquido

dbSelectArea('SZO')
SZO->(DbSetOrder(1))
SZO->(DbSeek(xFilial("SZO")+SF2->F2_SERIE+SF2->F2_DOC))
If SZO->(FOUND()) .And. !Empty(Alltrim(MEMOLINE(SZO->ZO_MENS,130,1))) 
	AAdd(aNotaF,AllTrim(SZO->ZO_MENS))											// 19 Mensagem
Else
	AAdd(aNotaF,AllTrim(SC5->C5_MENNOTA))										// 19 Mensagem
EndIf

	
	//--------------------------------------------------------------------------
	// Dados do cliente/fornecedor
	//--------------------------------------------------------------------------
	
	if cModNF == "1"
		if aNotaF[5] $ "B/D"
			cAliasCF := "SA2"
			nIndice1 := 2
		else
			cAliasCF := "SA1"
			nIndice1 := 1
		endif
	else
		if aNotaF[5] $ "B/D"
			cAliasCF := "SA1"
			nIndice1 := 1
		else
			cAliasCF := "SA2"
			nIndice1 := 2
		endif
	endif
	
	aCampo := {{"A1_PESSOA","A1_NOME","A1_CGC","A1_END","A1_NR_END","A1_BAIRRO","A1_CEP","A1_MUN","A1_DDD","A1_TEL","A1_EST","A1_INSCR","A1_INSCRM"},;
				{"A2_TIPO","A2_NOME","A2_CGC","A2_END","A2_NR_END","A2_BAIRRO","A2_CEP","A2_MUN","A2_DDD","A2_TEL","A2_EST","A2_INSCR","A2_INSCRM"}}
	
	DbSelectArea(cAliasCF)
	(cAliasCF)->(DbSeek(xFilial(cAliasCF)+cCliFor,.F.))
	
	AAdd(aDestinat,(cAliasCF)->&(aCampo[nIndice1][1]))																// 01 Pessoa Fisica/Pessoa Juridica
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][2])))														// 02 Razao Social
	AAdd(aDestinat,(cAliasCF)->&(aCampo[nIndice1][3]))																// 03 CNPJ/CPF
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][4])))														// 04 Endereço
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][6])))														// 05 Bairro
	AAdd(aDestinat,Transf((cAliasCF)->&(aCampo[nIndice1][7]),"@R 99999-999"))										// 06 CEP
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][8])))														// 07 Municipio
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][9]))+AllTrim((cAliasCF)->&(aCampo[nIndice1][10])))		// 08 Telefone ou Fax
	AAdd(aDestinat,(cAliasCF)->&(aCampo[nIndice1][11]))																// 09 Estado
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][12])))													// 10 Inscricao Estadual
	AAdd(aDestinat,AllTrim((cAliasCF)->&(aCampo[nIndice1][13])))													// 11 Inscricao Municipal
	
	//--------------------------------------------------------------------------
	// Dados dos impostos
	//--------------------------------------------------------------------------
	
	AAdd(aTotais,"")			// 01 Base calculo ICMS
	AAdd(aTotais,"")			// 02 Valor ICMS
	AAdd(aTotais,"")			// 03 Base calculo ICMS ST
	AAdd(aTotais,"")			// 04 Valor ICMS ST
	AAdd(aTotais,"")			// 05 Valor Total Produto
	AAdd(aTotais,"")			// 06 Valor Frete
	AAdd(aTotais,"")			// 07 Valor Seguro
	AAdd(aTotais,"")			// 08 Valor Desconto
	AAdd(aTotais,"")			// 09 Outras Despesas
	AAdd(aTotais,"")			// 10 Valor IPI
	AAdd(aTotais,"")			// 11 Base calculo PIS/COFINS
	AAdd(aTotais,"")			// 12 Valor do Pis
	AAdd(aTotais,"")			// 13 Valor do Cofins
	AAdd(aTotais,"")			// 14 Valor Total Nota
	
	for m := 1 to nMaxImp
		AAdd(aTot,0)
	next
	
	//--------------------------------------------------------------------------
	// Dados da transportadora
	//--------------------------------------------------------------------------
	
	DbSelectArea("SA4")
	
	if SA4->(DbSeek(xFilial("SA4")+aNotaF[9],.F.))
		AAdd(aTransp,AllTrim(SA4->A4_NOME))															// 01 RazÃ£o Social
		
		if Len(AllTrim(SA4->A4_CGC)) == 14
			cAux := Transf(SA4->A4_CGC,"@R 99.999.999/9999-99")
		else
			cAux := Transf(SA4->A4_CGC,"@R 999.999.999-99")
		endif
		
		AAdd(aTransp,cAux)																			// 02 CNPJ/CPF
		AAdd(aTransp,AllTrim(SA4->A4_END))															// 03 EndereÃ§o
		AAdd(aTransp,AllTrim(SA4->A4_MUN))															// 04 MunicÃ­pio
		AAdd(aTransp,SA4->A4_EST)																	// 05 UF
		AAdd(aTransp,IIf(Empty(SA4->A4_INSEST),"ISENTO",AllTrim(SA4->A4_INSEST)))					// 06 InscriÃ§Ã£o Estadual
	else
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
		AAdd(aTransp,"")
	endif
	
	do case																							// 07 Frete por Conta
		case aNotaF[11] == "F"
			AAdd(aTransp,"0")
		case aNotaF[11] == "C"
			AAdd(aTransp,"1")
		case aNotaF[11] == "T"
			AAdd(aTransp,"2")
		case aNotaF[11] == "S"
			AAdd(aTransp,"9")
		otherwise
			AAdd(aTransp,"1")
	endcase
	
	AAdd(aTransp,"")						// 08 CÃ³digo ANTT
	AAdd(aTransp,aNotaF[12])																		// 09 Placa do VeÃ­culo
	AAdd(aTransp,aNotaF[13])																		// 10 UF
	
	if !Empty(aNotaF[14])
		AAdd(aTransp,AllTrim(Str(Round(aNotaF[14],0))))												// 11 Quantidade
	else
		AAdd(aTransp,"")
	endif
	
	AAdd(aTransp,AllTrim(Str(aNotaF[15])))															// 12 EspÃ©cie
	AAdd(aTransp,"")						// 13 Marca
	AAdd(aTransp,"")						// 14 NumeraÃ§Ã£o
	
	if !Empty(aNotaF[16])
		AAdd(aTransp,Transf(aNotaF[16],"@E 999999.999"))											// 15 Peso Bruto
	else
		AAdd(aTransp,"")
	endif
	
	if !Empty(aNotaF[17])
		AAdd(aTransp,Transf(aNotaF[17],"@E 999999.999"))											// 16 Peso LÃ­quido
	else
		AAdd(aTransp,"")
	endif
	
	/*if !Empty(aTransp[1])
		if Empty(aTransp[9]) .or. Empty(aTransp[10])
			MsgAlert("Esta faltando preencher a PLACA ou a UF do veiculo.")
			
			lExistNfe := .F.
		endif
	endif*/
	
	//--------------------------------------------------------------------------
	// Dados do ISSQN
	//--------------------------------------------------------------------------
	
	AAdd(aISSQN,"")																//01 InscriÃ§Ã£o Municipal
	AAdd(aISSQN,"")																//02 Valor Total servicos
	AAdd(aISSQN,"")																//03 Base calculo ISSQN
	AAdd(aISSQN,"")																//04 Valor ISSQN
	
	//--------------------------------------------------------------------------
	// Dados do produto/servico
	//--------------------------------------------------------------------------
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(MsSeek(xFilial("SC6")+aNotaF[2],.F.))
	
	nItem := 0
	
	while !SC6->(Eof()) .and. SC6->C6_NUM == aNotaF[2]
		cDescri := AllTrim(SC6->C6_DESCRI)
		cNcm := IIf(SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)),AllTrim(SB1->B1_POSIPI),"")
		cTes := SC6->C6_TES
		
		if (nInd := AScan(aTes,{|x| x[1] == cTes})) == 0
			AAdd(aTes,{cTes,IIf(SF4->(DbSeek(xFilial("SF4")+cTes,.F.)),AllTrim(SF4->F4_TEXTO),""),AllTrim(SC6->C6_CF)})
			
			aNotaF[10] := AllTrim(SF4->F4_TEXTO)+"/"
		endif
		
		aImpostos := U_FIMPOSTOS(Left(aNotaF[4],6),Right(aNotaF[4],2),aNotaF[5],SC6->C6_PRODUTO,SC6->C6_TES,SC6->C6_QTDVEN,SC6->C6_PRCVEN,SC6->C6_VALOR)
		nTotIpi := 0
		
		SF4->(DbGoTop())
		
		if SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES,.F.))
			if SF4->F4_INCIDE == "S"
				nTotIpi := aImpostos[10]
			endif
		endif
		
		AAdd(aItens,{Left(SC6->C6_PRODUTO,15),;																			// 01 CÃ³digo Produto
						MemoLine(cDescri,nMaxDes,1),;																	// 02 descricao do Produto
						cNcm,;																							// 03 NCM
						SC6->C6_CLASFIS,;																				// 04 CST
						SC6->C6_CF,;																					// 05 CFOP
						SC6->C6_UM,;																					// 06 Unidade
						AllTrim(Transf(SC6->C6_QTDVEN,PesqPict("SD2","D2_QUANT"))),;									// 07 Quantidade
						AllTrim(Transf(SC6->C6_PRCVEN,PesqPict("SD2","D2_PRCVEN"))),;									// 08 Valor UnitÃ¡rio
						AllTrim(Transf(SC6->C6_VALOR,PesqPict("SD2","D2_TOTAL"))),;										// 09 Valor Total
						AllTrim(Transf(aImpostos[4],PesqPict("SD2","D2_BASEICM"))),;									// 10 Base calculo ICMS
						AllTrim(Transf(aImpostos[6],PesqPict("SD2","D2_VALICM"))),;										// 11 Valor ICMS
						AllTrim(Transf(aImpostos[10],PesqPict("SD2","D2_VALIPI"))),;									// 12 Valor IPI
						AllTrim(Transf(aImpostos[5],"@E 99.99%")),;														// 13 Aliquota ICMS
						AllTrim(Transf(aImpostos[9],"@E 99.99%"))})														// 14 Aliquota IPI
		
		nItem++
		
		if MLCount(cDescri,nMaxDes) > 1
			for k := 2 to MLCount(cDescri,nMaxDes)
				AAdd(aItens,{"",MemoLine(cDescri,nMaxDes,k),"","","","","","","","","","","",""})
				
				nItem++
			next
		endif
		
		aTot[1] := aImpostos[1]
		aTot[2] := aImpostos[2]
		
		for m := 3 to nMaxImp
			if !(StrZero(m,2) $ "03/07/11/15/19/23/27/31/35/39/43/47/51")
				aTot[m] += aImpostos[m]
			endif
		next
		
		for m := 3 to nMaxImp step 4
			if m <= 51
				if aImpostos[m + 3] > 0
					cAlqImposto := Transf(aImpostos[m + 2],"@E 99.99")+"%"
					
					if (nInd := AScan(aTabImposto,{|x| x[1] = aImpostos[m] .and. x[2] = cAlqImposto})) == 0
						AAdd(aTabImposto,{aImpostos[m],cAlqImposto,Transf(aImpostos[m + 1],"@E 999,999,999,999.99"),Transf(aImpostos[m + 3],"@E 999,999,999,999.99"),aImpostos[m + 3],aImpostos[m + 1]})
					else
						aTabImposto[nInd][5] += aImpostos[m + 3]
						aTabImposto[nInd][6] += aImpostos[m + 1]
						aTabImposto[nInd][3] := Transf(aTabImposto[nInd][6],"@E 999,999,999,999.99")
						aTabImposto[nInd][4] := Transf(aTabImposto[nInd][5],"@E 999,999,999,999.99")
					endif
				endif
			endif
		next
		
		nTotNota += (SC6->C6_VALOR + nTotIpi)
		
		if !Empty(aImpostos[22])
			nTotServico += SC6->C6_VALOR
		endif
		
		aImpostos := {}
		
		SC6->(DbSkip())
	enddo
	
	aTotais[1] := Transf(aTot[4],"@E 9,999,999,999,999.99")							// 01 Base calculo ICMS
	aTotais[2] := Transf(aTot[6],"@E 9,999,999,999,999.99")							// 02 Valor ICMS
	aTotais[3] := Transf(aTot[55],"@E 9,999,999,999,999.99")						// 03 Base calculo ICMS ST
	aTotais[4] := Transf(aTot[57],"@E 9,999,999,999,999.99")						// 04 Valor ICMS ST
	aTotais[5] := Transf(aTot[62],"@E 9,999,999,999,999.99")						// 05 Valor Total Produto
	aTotais[6] := Transf(aTot[59],"@E 9,999,999,999,999.99")						// 06 Valor Frete
	aTotais[7] := Transf(aTot[60],"@E 9,999,999,999,999.99")						// 07 Valor Seguro
	aTotais[8] := Transf(aTot[58],"@E 9,999,999,999,999.99")						// 08 Valor Desconto
	aTotais[9] := Transf(aTot[61],"@E 9,999,999,999,999.99")						// 09 Outras Despesas
	aTotais[10] := Transf(aTot[10],"@E 9,999,999,999,999.99")						// 10 Valor IPI
	aTotais[11] := Transf(aTot[36],"@E 9,999,999,999,999.99")						// 11 Base calculo PIS/COFINS
	aTotais[12] := Transf(aTot[38],"@E 9,999,999,999,999.99")						// 12 Valor do Pis
	aTotais[13] := Transf(aTot[42],"@E 9,999,999,999,999.99")						// 13 Valor do Cofins
	aTotais[14] := Transf(nTotNota,"@E 9,999,999,999,999.99")						// 14 Valor Total Nota
	
	if !Empty(aTot[22])
		aISSQN[1] := aEmpresa[09]													//01 Inscricao Municipal
		aISSQN[2] := Transf(nTotServico,"@E 99,999,999,999.99")						//02 Valor Total servicos
		aISSQN[3] := Transf(aTot[20],"@E 99,999,999,999.99")						//03 Base calculo ISSQN
		aISSQN[4] := Transf(aTot[22],"@E 99,999,999,999.99")						//04 Valor ISSQN
	endif
	
	nItem -= MAXITEM
	lFlag := .T.
	
	while lFlag
		if nItem > 0
			nFolhas++
			
			nItem -= MAXITEMP2
		else
			lFlag := .F.
		endif
	enddo
	
	//--------------------------------------------------------------------------
	// Dados dos dados adicionais
	//--------------------------------------------------------------------------
	
	cProjetos := "Projeto(s): "+Projetos(aNotaF[2],"",Left(aNotaF[4],6),Right(aNotaF[4],2),"SC6")
	cMensagem := " "+aNotaF[19]+" "+Chr(13)+Chr(10)+cProjetos
	cResFisco := " "
return

/*===================================================
|    		IMPRESSAO DA PRE-DANFE                   |
/====================================================*/

static function PreDanfeProc(cModNF)
	
	local lConverte := GetNewPar("MV_CONVERT",.F.)	
	private nLinCalc := 0
	private nFolImp := IIf(!Empty(aTabImpostos),1,0)
	
	oPrinter:StartPage()
	Cabecalho(42,.T.)

	/*----------------------------------------------------
	|    DESTINATARIO/REMETENTE                          |
	/---------------------------------------------------*/
	
	oPrinter:Say(195,002,"DESTINATARIO/REMETENTE",oFont08N:oFont)
	oPrinter:Line(197,000,197,500,ESPLIN)
	oPrinter:Line(197,000,257,000,ESPLIN)
	oPrinter:Line(197,500,257,500,ESPLIN)
	oPrinter:Line(257,000,257,500,ESPLIN)
	oPrinter:Say(205,002,"NOME/RAZÃO SOCIAL",oFont08N:oFont)
	oPrinter:Say(215,002,aDestinat[2],oFont08:oFont)
	oPrinter:Line(197,280,217,280,ESPLIN)
	
	do case
		case aDestinat[1] == "J"
			cAux := Transf(aDestinat[3],"@R 99.999.999/9999-99")
		case aDestinat[1] == "F"
			cAux := Transf(aDestinat[3],"@R 999.999.999-99")
		otherwise
			cAux := Space(14)
	endcase
	
	oPrinter:Say(205,283,"CNPJ/CPF",oFont08N:oFont)
	oPrinter:Say(215,283,cAux,oFont08:oFont)
	oPrinter:Line(217,000,217,500,ESPLIN)
	oPrinter:Say(224,002,"ENDEREÇO",oFont08N:oFont)
	oPrinter:Say(234,002,aDestinat[4],oFont08:oFont)
	oPrinter:Line(217,230,237,230,ESPLIN)
	oPrinter:Say(224,232,"BAIRRO/DISTRITO",oFont08N:oFont)
	oPrinter:Say(234,232,aDestinat[5],oFont08:oFont)
	oPrinter:Line(217,380,237,380,ESPLIN)
	oPrinter:Say(224,382,"CEP",oFont08N:oFont)
	oPrinter:Say(234,382,aDestinat[6],oFont08:oFont)
	oPrinter:Line(237,000,237,500,ESPLIN)
	oPrinter:Say(245,002,"MUNICIPIO",oFont08N:oFont)
	oPrinter:Say(255,002,aDestinat[7],oFont08:oFont)
	oPrinter:Line(237,150,257,150,ESPLIN)
	oPrinter:Say(245,152,"FONE/FAX",oFont08N:oFont)
	oPrinter:Say(255,152,aDestinat[8],oFont08:oFont)
	oPrinter:Line(237,255,257,255,ESPLIN)
	oPrinter:Say(245,257,"UF",oFont08N:oFont)
	oPrinter:Say(255,257,aDestinat[9],oFont08:oFont)
	oPrinter:Line(237,340,257,340,ESPLIN)
	oPrinter:Say(245,342,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
	oPrinter:Say(255,342,aDestinat[10],oFont08:oFont)
	
	oPrinter:Line(197,502,197,603,ESPLIN)
	oPrinter:Line(197,502,257,502,ESPLIN)
	oPrinter:Line(197,603,257,603,ESPLIN)
	oPrinter:Line(257,502,257,603,ESPLIN)
	oPrinter:Say(205,504,"DATA DE EMISSÃO",oFont08N:oFont)
	oPrinter:Say(215,504,ConvDate(aNotaF[7]),oFont08:oFont)
	oPrinter:Line(217,502,217,603,ESPLIN)
	oPrinter:Say(224,504,"DATA ENTRADA/SAÍDA",oFont08N:oFont)
	oPrinter:Say(233,504,ConvDate(aNotaF[8]),oFont08:oFont)
	oPrinter:Line(237,502,237,603,ESPLIN)
	oPrinter:Say(245,505,"HORA ENTRADA/SAÍDA",oFont08N:oFont)
	oPrinter:Say(255,505,aNotaF[9],oFont08:oFont)
	
	/*----------------------------------------------------
	|    				FATURA                          |
	/---------------------------------------------------*/
	
	oPrinter:Say(263,002,"FATURA",oFont08N:oFont)
	oPrinter:Line(265,000,265,603,ESPLIN)
	oPrinter:Line(265,000,296,000,ESPLIN)
	
	nCol := 067
	
	for i := 1 to 8
		oPrinter:Line(265,nCol,296,nCol,ESPLIN)
		
		nCol += 67
	next i
	
	oPrinter:Line(265,603,296,603,ESPLIN)
	oPrinter:Line(296,000,296,603,ESPLIN)
	
	nColuna := 002
	
	if Len(aFaturas) > 0
		for n := 1 to Len(aFaturas)
			oPrinter:Say(273,nColuna,aFaturas[n][1]+" "+aFaturas[n][2],oFont08:oFont)
			oPrinter:Say(281,nColuna,aFaturas[n][3],oFont08:oFont)
			oPrinter:Say(289,nColuna,aFaturas[n][4],oFont08:oFont)
			
			nColuna += 67
		next n
	endif
	
	/*----------------------------------------------------
	| 			CALCULO DO IMPOSTO                       |
	/---------------------------------------------------*/

	
	oPrinter:Say(305,002,"CALCULO DO IMPOSTO",oFont08N:oFont)
	oPrinter:Line(307,000,307,603,ESPLIN)
	oPrinter:Line(307,000,353,000,ESPLIN)
	oPrinter:Line(307,603,353,603,ESPLIN)
	oPrinter:Line(353,000,353,603,ESPLIN)
	oPrinter:Say(316,002,"BASE DE CALCULO DO ICMS",oFont08N:oFont)
	oPrinter:Say(326,002,aTotais[1],oFont08:oFont)
	oPrinter:Line(307,120,330,120,ESPLIN)
	oPrinter:Say(316,125,"VALOR DO ICMS",oFont08N:oFont)
	oPrinter:Say(326,125,aTotais[2],oFont08:oFont)
	oPrinter:Line(307,199,330,199,ESPLIN)
	oPrinter:Say(316,201,"BASE DE CALCULO DO ICMS SUBSTITUIÇÃO",oFont08N:oFont)
	oPrinter:Say(326,202,aTotais[3],oFont08:oFont)
	oPrinter:Line(307,360,330,360,ESPLIN)
	oPrinter:Say(316,363,"VALOR DO ICMS SUBSTITUIÇÃO",oFont08N:oFont)
	oPrinter:Say(326,363,aTotais[4],oFont08:oFont)
	oPrinter:Line(307,490,330,490,ESPLIN)
	oPrinter:Say(316,491,"VALOR TOTAL DOS PRODUTOS",oFont08N:oFont)
	oPrinter:Say(327,491,aTotais[5],oFont08:oFont)
	oPrinter:Line(330,000,330,603,ESPLIN)
	oPrinter:Say(339,002,"VALOR DO FRETE",oFont08N:oFont)
	oPrinter:Say(349,001,aTotais[6],oFont08:oFont)
	oPrinter:Line(330,058,353,058,ESPLIN)
	oPrinter:Say(339,060,"VALOR DO SEGURO",oFont08N:oFont)
	oPrinter:Say(349,058,aTotais[7],oFont08:oFont)
	oPrinter:Line(330,125,353,125,ESPLIN)
	oPrinter:Say(339,130,"DESCONTO",oFont08N:oFont)
	oPrinter:Say(349,110,aTotais[8],oFont08:oFont)
	oPrinter:Line(330,168,353,168,ESPLIN)
	oPrinter:Say(339,170,"OUTRAS DESPESAS ACESSÓRIAS",oFont08N:oFont)
	oPrinter:Say(349,180,aTotais[9],oFont08:oFont)
	oPrinter:Line(330,270,353,270,ESPLIN)
	oPrinter:Say(339,280,"VALOR DO IPI",oFont08N:oFont)
	oPrinter:Say(349,275,aTotais[10],oFont08:oFont)
	oPrinter:Line(330,325,353,325,ESPLIN)
	oPrinter:Say(339,335,"BASE PIS/COFINS",oFont08N:oFont)
	oPrinter:Say(349,330,aTotais[11],oFont08:oFont)
	oPrinter:Line(330,395,353,395,ESPLIN)
	oPrinter:Say(339,400,"VALOR DO PIS",oFont08N:oFont)
	oPrinter:Say(349,393,aTotais[12],oFont08:oFont)
	oPrinter:Line(330,455,353,455,ESPLIN)
	oPrinter:Say(339,460,"VALOR DO COFINS",oFont08N:oFont)
	oPrinter:Say(349,458,aTotais[13],oFont08:oFont)
	oPrinter:Line(330,520,353,520,ESPLIN)
	oPrinter:Say(339,530,"VALOR TOTAL DA NOTA",oFont08N:oFont)
	oPrinter:Say(349,530,aTotais[14],oFont08:oFont)
	
	/*---------------------------------------------------/
	|  TRANSPORTADOR/VOLUMES TRANSPORTADOS               |
	/---------------------------------------------------*/
	
	oPrinter:Say(361,002,"TRANSPORTADOR/VOLUMES TRANSPORTADOS",oFont08N:oFont)
	oPrinter:Line(363,000,363,603,ESPLIN)
	oPrinter:Line(363,000,432,000,ESPLIN)
	oPrinter:Line(363,603,432,603,ESPLIN)
	oPrinter:Line(432,000,432,603,ESPLIN)
	oPrinter:Say(372,002,"RAZÃO SOCIAL",oFont08N:oFont)
	oPrinter:Say(382,002,aTransp[1],oFont08:oFont)
	oPrinter:Line(363,245,385,245,ESPLIN)
	oPrinter:Say(372,247,"FRETE POR CONTA",oFont08N:oFont)
	
	if aTransp[7] == "0"
		oPrinter:Say(382,247,"0-EMITENTE",oFont08:oFont)
	elseif aTransp[7] == "1"
		oPrinter:Say(382,247,"1-DESTINATARIO",oFont08:oFont)
	elseif aTransp[7] == "2"
		oPrinter:Say(382,247,"2-TERCEIROS",oFont08:oFont)
	elseif aTransp[7] == "9"
		oPrinter:Say(382,247,"9-SEM FRETE",oFont08:oFont)
	else
		oPrinter:Say(382,247,"",oFont08:oFont)
	endif
	
	oPrinter:Line(363,315,385,315,ESPLIN)
	oPrinter:Say(372,317,"CÓDIGO ANTT",oFont08N:oFont)
	oPrinter:Say(382,319,aTransp[8],oFont08:oFont)
	oPrinter:Line(363,370,385,370,ESPLIN)
	oPrinter:Say(372,375,"PLACA DO VEÍCULO",oFont08N:oFont)
	oPrinter:Say(382,375,IIf(Empty(aTransp[1]),"",aTransp[9]),oFont08:oFont)
	oPrinter:Line(363,450,385,450,ESPLIN)
	oPrinter:Say(372,452,"UF",oFont08N:oFont)
	oPrinter:Say(382,452,IIf(Empty(aTransp[1]),"",aTransp[10]),oFont08:oFont)
	oPrinter:Line(363,510,385,510,ESPLIN)
	oPrinter:Say(372,512,"CNPJ/CPF",oFont08N:oFont)
	oPrinter:Say(382,512,aTransp[2],oFont08:oFont)
	oPrinter:Line(385,000,385,603,ESPLIN)
	oPrinter:Say(393,002,"ENDEREÇO",oFont08N:oFont)
	oPrinter:Say(404,002,aTransp[3],oFont08:oFont)
	oPrinter:Line(385,240,408,240,ESPLIN)
	oPrinter:Say(393,242,"MUNICIPIO",oFont08N:oFont)
	oPrinter:Say(404,242,aTransp[4],oFont08:oFont)
	oPrinter:Line(385,340,408,340,ESPLIN)
	oPrinter:Say(393,342,"UF",oFont08N:oFont)
	oPrinter:Say(404,342,aTransp[5],oFont08:oFont)
	oPrinter:Line(385,440,408,440,ESPLIN)
	oPrinter:Say(393,442,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
	oPrinter:Say(404,442,aTransp[6],oFont08:oFont)
	oPrinter:Line(408,000,408,603,ESPLIN)
	oPrinter:Say(418,002,"QUANTIDADE",oFont08N:oFont)
	oPrinter:Say(428,002,aTransp[11],oFont08:oFont)
	oPrinter:Line(408,100,432,100,ESPLIN)
	oPrinter:Say(418,102,"ESPECIE",oFont08N:oFont)
	oPrinter:Say(428,102,aTransp[12],oFont08:oFont)
	oPrinter:Line(408,200,432,200,ESPLIN)
	oPrinter:Say(418,202,"MARCA",oFont08N:oFont)
	oPrinter:Say(428,202,aTransp[13],oFont08:oFont)
	oPrinter:Line(408,300,432,300,ESPLIN)
	oPrinter:Say(418,302,"NUMERAÇÃO",oFont08N:oFont)
	oPrinter:Say(428,302,aTransp[14],oFont08:oFont)
	oPrinter:Line(408,400,432,400,ESPLIN)
	oPrinter:Say(418,402,"PESO BRUTO",oFont08N:oFont)
	oPrinter:Say(428,402,aTransp[15],oFont08:oFont)
	oPrinter:Line(408,500,432,500,ESPLIN)
	oPrinter:Say(418,502,"PESO LIQUIDO",oFont08N:oFont)
	oPrinter:Say(428,502,aTransp[16],oFont08:oFont)
	
	/*----------------------------------------------------
	|  DADOS DO PRODUTO/SERVICO	                          |
	/---------------------------------------------------*/
	
	oPrinter:Say(440,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N:oFont)
	oPrinter:Line(442,000,442,603,ESPLIN)
	oPrinter:Line(442,000,678,000,ESPLIN)
	oPrinter:Line(442,603,678,603,ESPLIN)
	oPrinter:Line(678,000,678,603,ESPLIN)
	
	aAux := {{{},{},{},{},{},{},{},{},{},{},{},{},{},{}}}
	nY := 0
	nLenItens := Len(aItens)
	
	for nX := 1 to nLenItens
		AAdd(ATail(aAux)[01],aItens[nX][01])
		AAdd(ATail(aAux)[02],NoChar(Alltrim(aItens[nX][02]),lConverte))
		AAdd(ATail(aAux)[03],aItens[nX][03])
		AAdd(ATail(aAux)[04],aItens[nX][04])
		AAdd(ATail(aAux)[05],aItens[nX][05])
		AAdd(ATail(aAux)[06],aItens[nX][06])
		AAdd(ATail(aAux)[07],aItens[nX][07])
		AAdd(ATail(aAux)[08],aItens[nX][08])
		AAdd(ATail(aAux)[09],aItens[nX][09])
		AAdd(ATail(aAux)[10],aItens[nX][10])
		AAdd(ATail(aAux)[11],aItens[nX][11])
		AAdd(ATail(aAux)[12],aItens[nX][12])
		AAdd(ATail(aAux)[13],aItens[nX][13])
		AAdd(ATail(aAux)[14],aItens[nX][14])
	next nX
	
	for nK := 1 to nLenItens
		AAdd(ATail(aAux)[01],"")
		AAdd(ATail(aAux)[02],"")
		AAdd(ATail(aAux)[03],"")
		AAdd(ATail(aAux)[04],"")
		AAdd(ATail(aAux)[05],"")
		AAdd(ATail(aAux)[06],"")
		AAdd(ATail(aAux)[07],"")
		AAdd(ATail(aAux)[08],"")
		AAdd(ATail(aAux)[09],"")
		AAdd(ATail(aAux)[10],"")
		AAdd(ATail(aAux)[11],"")
		AAdd(ATail(aAux)[12],"")
		AAdd(ATail(aAux)[13],"")
		AAdd(ATail(aAux)[14],"")
	next nK
	
	aAuxCabec := {"COD. PROD","DESC. PROD","NCM/SH","CST","CFOP","UN","QUANT.","V.UNITARIO","V.TOTAL","BC.ICMS","V.ICMS","V.IPI","A.ICMS","A.IPI"}
	aTamCol := RetTamCol(aAuxCabec,aAux,oPrinter,oFont08:oFont,oFont08N:oFont)
	
	nAuxH := 0
	
	for nK := 1 to Len(aAuxCabec)
		oPrinter:Line(442,nAuxH,678,nAuxH,2)
		oPrinter:Say(450,nAuxH + 2,aAuxCabec[nK],oFont08N:oFont)
		
		nAuxH += aTamCol[nK]
	next nK
	
	nLinha := 460
	nK := 1
	
	while nK <= Len(aItens) .and. nK <= MAXITEM
		nAuxH := 0
		
		for nJ := 1 to 14
			oPrinter:Say(nLinha,nAuxH + 2,aItens[nK][nJ],oFont08:oFont)
			
			nAuxH += aTamCol[nJ]
		next nJ
		
		nLinha += 10
		nK++
	enddo
	
	/*---------------------------------------------------/
	|   		CALCULO DO ISSQN                         |
	/---------------------------------------------------*/
	
	oPrinter:Say(686,000,"CALCULO DO ISSQN",oFont08N:oFont)
	oPrinter:Line(688,000,688,603,ESPLIN)
	oPrinter:Line(688,000,711,000,ESPLIN)
	oPrinter:Line(688,603,711,603,ESPLIN)
	oPrinter:Line(711,000,711,603,ESPLIN)
	oPrinter:Say(696,002,"INSCRIÇÃO MUNICIPAL",oFont08N:oFont)
	oPrinter:Say(706,002,aISSQN[1],oFont08:oFont)
	oPrinter:Line(688,150,711,150,ESPLIN)
	oPrinter:Say(696,152,"VALOR TOTAL DOS SERVIÇOS",oFont08N:oFont)
	oPrinter:Say(706,152,aISSQN[2],oFont08:oFont)
	oPrinter:Line(688,300,711,300,ESPLIN)
	oPrinter:Say(696,302,"BASE DE CÁLCULO DO ISSQN",oFont08N:oFont)
	oPrinter:Say(706,302,aISSQN[3],oFont08:oFont)
	oPrinter:Line(688,450,711,450,ESPLIN)
	oPrinter:Say(696,452,"VALOR DO ISSQN",oFont08N:oFont)
	oPrinter:Say(706,452,aISSQN[4],oFont08:oFont)
	
	/*---------------------------------------------------/
	|    			DADOS ADICIONAIS                     |
	/---------------------------------------------------*/
	
	oPrinter:Say(719,000,"DADOS ADICIONAIS",oFont08N:oFont)
	oPrinter:Line(721,000,721,603,ESPLIN)
	oPrinter:Line(721,000,865,000,ESPLIN)
	oPrinter:Line(721,603,865,603,ESPLIN)
	oPrinter:Line(865,000,865,603,ESPLIN)
	oPrinter:Say(729,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N:oFont)
	
	nLin := 741
	
	oPrinter:Say(nLin,002,MemoLine(cMensagem,MAXMSG,1),oFont08:oFont)
	
	nLin := nLin + 10
	
	if MLCount(cMensagem,MAXMSG) > 1
		for k := 2 to MLCount(cMensagem,MAXMSG)
			oPrinter:Say(nLin,002,MemoLine(cMensagem,MAXMSG,k),oFont08:oFont)
			
			nLin := nLin + 10
		next
	endif
	
	oPrinter:Line(721,350,865,350,ESPLIN)
	oPrinter:Say(729,352,"RESERVADO AO FISCO",oFont08N:oFont)
	
	nLin := 741
	
	oPrinter:Say(nLin,351,MemoLine(cResFisco,MAXMSG,1),oFont08:oFont)
	
	nLin := nLin + 10
	
	if MLCount(cResFisco,MAXMSG) > 1
		for k := 2 to MLCount(cResFisco,MAXMSG)
			oPrinter:Say(nLin,351,MemoLine(cResFisco,MAXMSG,k),oFont08:oFont)
			
			nLin := nLin + 10
		next
	endif
	
	oPrinter:EndPage()
	
	/*----------------------------------------------------
	|  	IMPRESSAO DA SEGUNDA PAGINA EM DIANTE            |
	/---------------------------------------------------*/
	
	nFolha := 2
	nItens := MAXITEM + 1
	
	while nFolha <= nFolhas
		oPrinter:StartPage()
		Cabecalho(0,.F.)
		
		/*---------------------------------------------------/
		| 			 DADOS DO PRODUTO/SERVICO                |
		/---------------------------------------------------*/
		
		oPrinter:Say(161,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N:oFont)
		oPrinter:Line(163,000,163,603,ESPLIN)
		oPrinter:Line(163,000,865,000,ESPLIN)
		oPrinter:Line(163,603,865,603,ESPLIN)
		oPrinter:Line(865,000,865,603,ESPLIN)
		
		nAuxH := 0
		
		for nK := 1 to Len(aAuxCabec)
//			oPrinter:Box(163,nAuxH,865,nAuxH + aTamCol[nK])
			oPrinter:Line(163,nAuxH,865,nAuxH,2)
			oPrinter:Say(171,nAuxH + 2,aAuxCabec[nK],oFont08N:oFont)
			
			nAuxH += aTamCol[nK]
		next nK
		
		nLinha := 181
		
		while nItens <= Len(aItens) .and. nItens <= MAXITEMP2
			nAuxH := 0
			
			for nJ := 1 to 14
				oPrinter:Say(nLinha,nAuxH + 2,aItens[nItens][nJ],oFont08:oFont)
				
				nAuxH += aTamCol[nJ]
			next nJ
			
			nLinha += 10
			nItens++
		enddo
		
		nFolha++
		
		oPrinter:EndPage()
	enddo
	
	ASort(aTabImposto,,,{|x,y| x[1] < y[1]})
	
	if Len(aTabImposto) > 0
		
		/*--------------------------------------/
		| IMPRESSAO DA TABELA DE IMPOSTOS       |
		/--------------------------------------*/
		
		oPrinter:StartPage()
		Cabecalho(0,.F.)
		
		/*---------------------------------------------------/
		|   DADOS DA TABELA DE IMPOSTO                       |
		/---------------------------------------------------*/
		
		oPrinter:Say(161,002,"TABELA DE IMPOSTOS",oFont08N:oFont)
		oPrinter:Line(163,000,163,603,ESPLIN)
		oPrinter:Line(163,000,865,000,ESPLIN)
		oPrinter:Line(163,603,865,603,ESPLIN)
		oPrinter:Line(865,000,865,603,ESPLIN)
		oPrinter:Say(171,002,"IMPOSTO",oFont08N:oFont)
		oPrinter:Say(171,160,"ALIQUOTA",oFont08N:oFont)
		oPrinter:Say(171,270,"BASE CALCULO",oFont08N:oFont)
		oPrinter:Say(171,380,"VALOR IMPOSTO",oFont08N:oFont)
		
		nLinha := 181
		nTotal := 0
		
		for nI := 1 to Len(aTabImposto)
			oPrinter:Say(nLinha,002,aTabImposto[nI][1],oFont08:oFont)
			oPrinter:Say(nLinha,025,U_MPREDANF(Left(aTabImposto[nI][1],3)),oFont08:oFont)
			oPrinter:Say(nLinha,160,AllTrim(aTabImposto[nI][2]),oFont08:oFont)
			oPrinter:Say(nLinha,270,AllTrim(aTabImposto[nI][3]),oFont08:oFont)
			oPrinter:Say(nLinha,380,AllTrim(aTabImposto[nI][4]),oFont08:oFont)
			
			nTotal += aTabImposto[nI][5]
			nLinha += 10
		next nI
		
		oPrinter:Line(nLinha,370,nLinha,450,2)
		oPrinter:Say(nLinha + 10,380,AllTrim(Transf(nTotal,"@E 999,999,999,999.99")),oFont19N:oFont)
	endif
return

/*---------------------------------------------------/
| 		RETORNA OS PROJETOS UTILIZADO                |
/---------------------------------------------------*/
static function Projetos(cNota,cSerie,cCliFor,cLoja,cTab)
	local cQry := ""
	local cProj := ""
	local cCampo := ""
	
	do case
		case cTab == "SF2"
			cQry := "select distinct C6_CLVL from "+RetSqlName("SC6")+" where C6_NOTA = '"+cNota+"' and C6_SERIE = '"+cSerie+"' and C6_CLI = '"+cCliFor+"' and C6_LOJA = '"+cLoja+"' and D_E_L_E_T_ <> '*'"
			cCampo := "C6_CLVL"
		case cTab == "SF1"
			cQry := "select distinct D1_CLVL from "+RetSqlName("SD1")+" where D1_DOC = '"+cNota+"' and D1_SERIE = '"+cSerie+"' and D1_FORNECE = '"+cCliFor+"' and D1_LOJA = '"+cLoja+"' and D_E_L_E_T_ <> '*'"
			cCampo := "D1_CLVL"
		case cTab == "SC6"
			cQry := "select distinct C6_CLVL from "+RetSqlName("SC6")+" where C6_NUM = '"+cNota+"' and D_E_L_E_T_ <> '*'"
			cCampo := "C6_CLVL"
	endcase
	
	tcquery cQry new alias "TMP"
	DbSelectArea("TMP")
	
	while !TMP->(Eof())
		if AllTrim(TMP->&(cCampo)) <> "000000000"
			cProj += AllTrim(TMP->&(cCampo))+" / "
		endif
		
		TMP->(DbSkip())
	enddo
	
	TMP->(DbCloseArea())
return (SubStr(cProj,1,Len(cProj) - 3))

/*---------------------------------------------------/
| 		RETORNA OS IMPOSTOS UTILIZADO                |
/---------------------------------------------------*/

static function TabImpostos(cModNF)
	if cModNF == "1"
		cCondicao := "and CD2_CODCLI = '"+Left(aNotaF[4],6)+"' and CD2_LOJCLI = '"+Right(aNotaF[4],2)+"' "
	else
		cCondicao := "and CD2_CODFOR = '"+Left(aNotaF[4],6)+"' and CD2_LOJFOR = '"+Right(aNotaF[4],2)+"' "
	endif
	
	if Select("QRY") <> 0
		QRY->(DbCloseArea())
	endif
	
	cQry := "select CD2_IMP, CD2_ALIQ, sum(CD2_BC) as CD2_BC, sum(CD2_VLTRIB) as CD2_VLTRIB "
	cQry += "from "+RetSqlName("CD2")+" "
	cQry += "where CD2_TPMOV = '"+IIf(cModNF == "1","S","E")+"' and CD2_DOC = '"+aNotaF[2]+"' and CD2_SERIE = '"+aNotaF[3]+"' "+cCondicao+"and D_E_L_E_T_ <> '*' "
	cQry += "group by CD2_IMP, CD2_ALIQ "
	cQry += "order by CD2_IMP, CD2_ALIQ"
	
	tcquery cQry new alias "QRY"
	
	DbSelectArea("QRY")
	QRY->(DbGoTop())
	
	while !QRY->(Eof())
		AAdd(aTabImposto,{QRY->CD2_IMP,Transf(QRY->CD2_ALIQ,"@E 99.99")+"%",Transf(QRY->CD2_BC,"@E 999,999,999,999.99"),Transf(QRY->CD2_VLTRIB,"@E 999,999,999,999.99"),QRY->CD2_VLTRIB,QRY->CD2_BC})
		
		QRY->(DbSkip())
	enddo
return
/*---------------------------------------------------/
|    	CONVERTER CARACTERES ESPECIAIS               |
/---------------------------------------------------*/

static function NoChar(cString,lConverte)
	default lConverte := .F.
	
	if lConverte
		cString := (StrTran(cString,"&lt;","<"))
		cString := (StrTran(cString,"&gt;",">"))
		cString := (StrTran(cString,"&amp;","&"))
		cString := (StrTran(cString,"&quot;",'"'))
		cString := (StrTran(cString,"&#39;","'"))
	endif
return cString

/*---------------------------------------------------/
|    	QUEBRAR TEXTO EM LINHAS                      |
/---------------------------------------------------*/

static function QbraTexto(cStrAux,nTam,oFont)
	nForTo := Len(cStrAux) / nTam
	nForTo += IIf(nForTo > Round(nForTo,0),Round(nForTo,0) + 1 - nForTo,nForTo)
	
	for nX := 1 to nForTo
		oPrinter:Say(nLinCalc,098,SubStr(cStrAux,IIf(nX == 1,1,((nX - 1) * nTam) + 1),nTam),oFont)
		
		nLinCalc += 10
	next nX
return

/*---------------------------------------------------/
|   CALCULA TAMANHO DE CADA COLUNA DOS ITENS         |
/---------------------------------------------------*/

static function RetTamCol(aCabec,aValores,oPrinter,oFontCabec,oFont)
	local aTamCol := {}
	local nAux := 0
	local nX := 0
	local nY := 0
	local oFontSize := FWFontSize():New()
	
	for nX := 1 to Len(aCabec)
		AAdd(aTamCol,{})
		
		aTamCol[nX] := oFontSize:GetTextWidth(AllTrim(aCabec[nX]),oFontCabec:Name,oFontCabec:nWidth,oFontCabec:Bold,oFontCabec:Italic)
	next nX
	
	for nX := 1 to Len(aValores[1])
		nAux := 0
		
		for nY := 1 to Len(aValores[1][nX])
			if (oPrinter:GetTextWidth(aValores[1][nX][nY], oFont) * nConsTex) > nAux
				nAux := oFontSize:GetTextWidth(AllTrim(aValores[1][nX][nY]),oFontCabec:Name,oFontCabec:nWidth,oFontCabec:Bold,oFontCabec:Italic)
			endif
		next nY
		
		if aTamCol[nX] < nAux
			aTamCol[nX] := nAux
		endif
	next nX
	
	// Checa se os campos completam a pagina, senao joga o resto na coluna da
	// descricao de produtos/servicos
	nAux := 0
	
	for nX := 1 to Len(aTamCol)
		nAux += aTamCol[nX]
	next nX
	
	if nAux < 603
		aTamCol[2] += 603 - nAux
	endif
	                       
	if nAux > 603
		aTamCol[2] -= nAux - 603
	endif
return aTamCol

/*---------------------------------------------------/
|    		IMPRIMIR CABECALHO                       |
/---------------------------------------------------*/

static function Cabecalho(nLinha,lPrincipal)

Local lMv_Logod     := If(GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F.   )
Local cDescLogo		:= ""
Local cLogoD	    := ""
Local cLogo      	:= FisxLogo("1")
oPrinter:SayBitmap(150,030,GetSrvProfString("Startpath","")+IIf(nModImp <> 1,"mdpredanfe.bmp","mdprenota.bmp"),495,496)			//mdagua.bmp
	
	/*---------------------------------------------------/
	|    	CABECALHO DA PRE-DANFE                       |
	/---------------------------------------------------*/
	
	if lPrincipal
		oPrinter:Line(000,000,000,603,ESPLIN)
		oPrinter:Line(000,000,037,000,ESPLIN)
		oPrinter:Line(000,603,037,603,ESPLIN)
		oPrinter:Line(037,000,037,603,ESPLIN)
		oPrinter:Say(008,003,"A "+IIf(nModImp == 1,"PRE-NOTA","PRE-DANFE")+" É UM DOCUMENTO NÃO FISCAL, COM O INTUITO DE FACILITAR A VISUALIZAÇÃO DA DANFE ANTES QUE A MESMA SEJA TRANSMITIDA, EVITANDO ASSIM",oFont07:oFont)
		oPrinter:Say(017,003,"O SEU CANCELAMENTO. MESMO COM ESSA PRATICIDADE, É DE EXTREMA IMPORTÂNCIA A VERIFICAÇÃO DA DANFE ORIGINAL IMPRESSA.",oFont07:oFont)
		oPrinter:Line(000,500,037,500,ESPLIN)
		
		if nModImp <> 1
			oPrinter:Say(007,542,"NF-e",oFont08N:oFont)
		else
			oPrinter:Say(007,538,"Pre-Nota",oFont08N:oFont)
		endif
		
		oPrinter:Say(017,510,"N. "+aNotaF[2],oFont08:oFont)
		
		if nModImp <> 1
			oPrinter:Say(027,510,"SÉRIE "+IIf(AllTrim(aNotaF[3]) == "U","0",aNotaF[3]),oFont08:oFont)
		endif
	endif
	
//	oPrinter:SayBitmap(nLinha,000,aEmpresa[6],095,096)
	oPrinter:Line(nLinha,000,nLinha,603,ESPLIN)
	oPrinter:Line(nLinha,000,nLinha + 95,000,ESPLIN)
	oPrinter:Line(nLinha,603,nLinha + 95,603,ESPLIN)
	oPrinter:Line(nLinha + 95,000,nLinha + 95,603,ESPLIN)
	oPrinter:SayBitmap(nLinha,000,aEmpresa[6],095,096)
	oPrinter:Say(nLinha + 10,098,"Identificação do emitente",oFont12N:oFont)
	
	nLinCalc := nLinha + 23
	
	QbraTexto(aEmpresa[1],25,oFont12N:oFont)
	oPrinter:Say(nLinCalc,098,aEmpresa[2],oFont08N:oFont)
	
	nLinCalc += 10
	
	oPrinter:Say(nLinCalc,098,aEmpresa[3],oFont08N:oFont)
	
	nLinCalc += 10
	
	oPrinter:Say(nLinCalc,098,aEmpresa[4],oFont08N:oFont)
	
	nLinCalc += 10
	
	oPrinter:Say(nLinCalc,098,aEmpresa[5],oFont08N:oFont)
	oPrinter:Line(nLinha,248,nLinha + 95,248,ESPLIN)

	//Logotipo
	If lMv_Logod
		cGrpCompany	:= AllTrim(FWGrpCompany())
		cCodEmpGrp	:= AllTrim(FWCodEmp())
		cUnitGrp	:= AllTrim(FWUnitBusiness())
		cFilGrp		:= AllTrim(FWFilial())

		If !Empty(cUnitGrp)
			cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
		Else
			cDescLogo	:= cEmpAnt + cFilAnt
		EndIf

		cLogoD := GetSrvProfString("Startpath","") + "DANFE" + cDescLogo + ".BMP"
		If !File(cLogoD)
			cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
			If !File(cLogoD)
				lMv_Logod := .F.
			EndIf
			EndIf
		EndIf

		If nfolha==1
			If lMv_Logod
				oPrinter:SayBitmap(045,003,cLogoD,090,090)
			Else
				oPrinter:SayBitmap(045,003,cLogo,090,090)
			EndIF
	Endif
	
	if nModImp <> 1
		oPrinter:Say(nLinha + 13,258,"PRE-DANFE",oFont18N:oFont,,CLR_HRED)
		oPrinter:Say(nLinha + 23,261,"DOCUMENTO AUXILIAR DA",oFont07:oFont)
	else
		oPrinter:Say(nLinha + 13,261,"PRE-NOTA",oFont18N:oFont,,CLR_HRED)
		oPrinter:Say(nLinha + 23,262,"DOCUMENTO MODELO DA",oFont07:oFont)
	endif
	
	oPrinter:Say(nLinha + 33,261,"NOTA FISCAL ELETRÔNICA",oFont07:oFont)
	oPrinter:Say(nLinha + 43,266,"0-ENTRADA",oFont08:oFont)
	oPrinter:Say(nLinha + 53,266,"1-SAÍDA",oFont08:oFont)
	oPrinter:Say(nLinha + 47,318,aNotaF[1],oFont08N:oFont)
	oPrinter:Line(nLinha + 36,315,nLinha + 36,325,ESPLIN)
	oPrinter:Line(nLinha + 36,315,nLinha + 53,315,ESPLIN)
	oPrinter:Line(nLinha + 36,325,nLinha + 53,325,ESPLIN)
	oPrinter:Line(nLinha + 53,315,nLinha + 53,325,ESPLIN)
	oPrinter:Say(nLinha + 68,255,"N. "+aNotaF[2],oFont10N:oFont)
	
	if nModImp <> 1
		oPrinter:Say(nLinha + 78,255,"SÉRIE "+IIf(AllTrim(aNotaF[3]) == "U","0",aNotaF[3]),oFont10N:oFont)
	endif
	
	oPrinter:Say(nLinha + 88,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas + nFolImp,2),oFont10N:oFont)
	oPrinter:Line(nLinha,351,nLinha + 95,351,ESPLIN)
	oPrinter:Line(nLinha + 33,351,nLinha + 33,603,ESPLIN)
	oPrinter:Say(nLinha + 43,355,"CHAVE DE ACESSO DA NF-E",oFont12N:oFont)
	oPrinter:Line(nLinha + 63,351,nLinha + 63,603,ESPLIN)
	oPrinter:Say(nLinha + 75,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12:oFont)
	oPrinter:Say(nLinha + 85,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12:oFont)
	
	nTamNatureza := Len(AllTrim(aNotaF[10])) - 1
	
	oPrinter:Line(nLinha + 97,000,nLinha + 97,603,ESPLIN)
	oPrinter:Line(nLinha + 97,000,nLinha + 120,000,ESPLIN)
	oPrinter:Line(nLinha + 97,603,nLinha + 120,603,ESPLIN)
	oPrinter:Line(nLinha + 120,000,nLinha + 120,603,ESPLIN)
	oPrinter:Say(nLinha + 106,002,"NATUREZA DA OPERAÇÃO",oFont08N:oFont)
	oPrinter:Say(nLinha + 116,002,Left(aNotaF[10],nTamNatureza),oFont08:oFont)
	oPrinter:Line(nLinha + 97,350,nLinha + 120,350,ESPLIN)
	oPrinter:Say(nLinha + 106,352,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N:oFont)
	
	oPrinter:Line(nLinha + 122,000,nLinha + 122,603,ESPLIN)
	oPrinter:Line(nLinha + 122,000,nLinha + 145,000,ESPLIN)
	oPrinter:Line(nLinha + 122,603,nLinha + 145,603,ESPLIN)
	oPrinter:Line(nLinha + 145,000,nLinha + 145,603,ESPLIN)
	oPrinter:Say(nLinha + 130,002,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
	oPrinter:Say(nLinha + 138,002,aEmpresa[8],oFont08:oFont)
	oPrinter:Line(nLinha + 122,200,nLinha + 145,200,ESPLIN)
	oPrinter:Say(nLinha + 130,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N:oFont)
	oPrinter:Line(nLinha + 122,400,nLinha + 145,400,ESPLIN)
	oPrinter:Say(nLinha + 130,405,"CNPJ",oFont08N:oFont)
	oPrinter:Say(nLinha + 138,405,Transf(aEmpresa[7],IIf(Len(aEmpresa[7]) <> 14,"@R 999.999-99","@R 99.999.999/9999-99")),oFont08:oFont)
return


Static Function ConvDate(cData)

Local dData
cData  := StrTran(cData,"-","")
dData  := Stod(cData)

Return PadR(StrZero(Day(dData),2)+ "/" + StrZero(Month(dData),2)+ "/" + StrZero(Year(dData),4),15)


/*______________________________________________________________________
   ¦Autor     ¦ Breno Ferreira                      ¦ Data ¦ 09/09/14 ¦
   +----------+-------------------------------------------------------¦
   ¦Descrição ¦ Funcao para calcular os impostos                      ¦
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#include "rwmake.ch"
#include "protheus.ch"

user function FIMPOSTOS(cCliente,cLoja,cTipo,cProduto,cTes,nQtd,nPrc,nValor)
Local aImp := {}
	
for i := 1 to 62
	AAdd(aImp,0)
next

// -------------------------------------------------------------------
// Realiza os calculos necessários
// -------------------------------------------------------------------
MaFisIni(cCliente,;										// 01- Codigo Cliente/Fornecedor
			cLoja,;										// 02- Loja do Cliente/Fornecedor
			"C",;											// 03- C: Cliente / F: Fornecedor
			"N",;											// 04- Tipo da NF
			cTipo,;										// 05- Tipo do Cliente/Fornecedor
			MaFisRelImp("MTR700",{"SC5","SC6"}),;			// 06- Relacao de Impostos que suportados no arquivo
			,;												// 07- Tipo de complemento
			,;												// 08- Permite incluir impostos no rodape (.T./.F.)
			"SB1",;										// 09- Alias do cadastro de Produtos - ("SBI" para Front Loja)
			"MTR700")										// 10- Nome da rotina que esta utilizando a funcao

// -------------------------------------------------------------------
// Monta o retorno para a MaFisRet
// -------------------------------------------------------------------
MaFisAdd(cProduto,cTes,nQtd,nPrc,0,"","",,0,0,0,0,nValor,0)

// -------------------------------------------------------------------
// Monta um array com os valores necessários
// -------------------------------------------------------------------
aImp[01] := cProduto
aImp[02] := cTes
aImp[03] := "ICM"							//03 ICMS
aImp[04] := MaFisRet(1,"IT_BASEICM")		//04 Base do ICMS
aImp[05] := MaFisRet(1,"IT_ALIQICM")		//05 Aliquota do ICMS
aImp[06] := MaFisRet(1,"IT_VALICM")			//06 Valor do ICMS
aImp[07] := "IPI"							//07 IPI
aImp[08] := MaFisRet(1,"IT_BASEIPI")		//08 Base do IPI
aImp[09] := MaFisRet(1,"IT_ALIQIPI")		//09 Aliquota do IPI
aImp[10] := MaFisRet(1,"IT_VALIPI")			//10 Valor do IPI
aImp[11] := "PIS"							//11 PIS/PASEP
aImp[12] := MaFisRet(1,"IT_BASEPIS")		//12 Base do PIS
aImp[13] := MaFisRet(1,"IT_ALIQPIS")		//13 Aliquota do PIS
aImp[14] := MaFisRet(1,"IT_VALPIS")			//14 Valor do PIS
aImp[15] := "COF"							//15 COFINS
aImp[16] := MaFisRet(1,"IT_BASECOF")		//16 Base do COFINS
aImp[17] := MaFisRet(1,"IT_ALIQCOF")		//17 Aliquota COFINS
aImp[18] := MaFisRet(1,"IT_VALCOF")			//18 Valor do COFINS
aImp[19] := "ISS"							//19 ISS
aImp[20] := MaFisRet(1,"IT_BASEISS")		//20 Base do ISS
aImp[21] := MaFisRet(1,"IT_ALIQISS")		//21 Aliquota ISS
aImp[22] := MaFisRet(1,"IT_VALISS")			//22 Valor do ISS
aImp[23] := "IRR"							//23 IRRF
aImp[24] := MaFisRet(1,"IT_BASEIRR")		//24 Base do IRRF
aImp[25] := MaFisRet(1,"IT_ALIQIRR")		//25 Aliquota IRRF
aImp[26] := MaFisRet(1,"IT_VALIRR")			//26 Valor do IRRF
aImp[27] := "INS"							//27 INSS
aImp[28] := MaFisRet(1,"IT_BASEINS")		//28 Base do INSS
aImp[29] := MaFisRet(1,"IT_ALIQINS")		//29 Aliquota INSS
aImp[30] := MaFisRet(1,"IT_VALINS")			//30 Valor do INSS
aImp[31] := "CSL"							//31 CSLL
aImp[32] := MaFisRet(1,"IT_BASECSL")		//32 Base do CSLL
aImp[33] := MaFisRet(1,"IT_ALIQCSL")		//33 Aliquota CSLL
aImp[34] := MaFisRet(1,"IT_VALCSL")			//34 Valor do CSLL
aImp[35] := "PS2"							//35 PIS/Pasep - Via Apuração
aImp[36] := MaFisRet(1,"IT_BASEPS2")		//36 Base do PS2 (PIS/Pasep - Via Apuração)
aImp[37] := MaFisRet(1,"IT_ALIQPS2")		//37 Aliquota PS2 (PIS/Pasep - Via Apuração)
aImp[38] := MaFisRet(1,"IT_VALPS2")			//38 Valor do PS2 (PIS/Pasep - Via Apuração)
aImp[39] := "CF2"							//39 COFINS - Via Apuração
aImp[40] := MaFisRet(1,"IT_BASECF2")		//40 Base do CF2 (COFINS - Via Apuração)
aImp[41] := MaFisRet(1,"IT_ALIQCF2")		//41 Aliquota CF2 (COFINS - Via Apuração)
aImp[42] := MaFisRet(1,"IT_VALCF2")			//42 Valor do CF2 (COFINS - Via Apuração)
aImp[43] := "ICC"							//43 ICMS Complementar
aImp[44] := MaFisRet(1,"IT_ALIQCMP")		//44 Base do ICMS Complementar
aImp[45] := MaFisRet(1,"IT_ALIQCMP")		//45 Aliquota do ICMS Complementar
aImp[46] := MaFisRet(1,"IT_VALCMP")			//46 Valor do do ICMS Complementar
aImp[47] := "ICA"							//47 ICMS ref. Frete Autonomo
aImp[48] := MaFisRet(1,"IT_BASEICA")		//48 Base do ICMS ref. Frete Autonomo
aImp[49] := 0								//49 Aliquota do ICMS ref. Frete Autonomo
aImp[50] := MaFisRet(1,"IT_VALICA")			//50 Valor do ICMS ref. Frete Autonomo
aImp[51] := "TST"							//51 ICMS ref. Frete Autonomo ST
aImp[52] := MaFisRet(1,"IT_BASETST")		//52 Base do ICMS ref. Frete Autonomo ST
aImp[53] := MaFisRet(1,"IT_ALIQTST")		//53 Aliquota do ICMS ref. Frete Autonomo ST
aImp[54] := MaFisRet(1,"IT_VALTST")			//54 Valor do ICMS ref. Frete Autonomo ST
aImp[55] := MaFisRet(1,"IT_BASESOL")		//55 Base do ICMS ST
aImp[56] := MaFisRet(1,"IT_ALIQSOL")		//56 Aliquota do ICMS ST
aImp[57] := MaFisRet(1,"IT_VALSOL")			//57 Valor do ICMS ST
aImp[58] := MaFisRet(1,"IT_DESCONTO")		//58 Valor do Desconto
aImp[59] := MaFisRet(1,"IT_FRETE")			//59 Valor do Frete
aImp[60] := MaFisRet(1,"IT_SEGURO")			//60 Valor do Seguro
aImp[61] := MaFisRet(1,"IT_DESPESA")		//61 Valor das Despesas
aImp[62] := MaFisRet(1,"IT_VALMERC")		//62 Valor da Mercadoria
/*	aImp[10] := MaFisRet(1,"IT_DESCZF")		//Valor de Desconto da Zona Franca de Manaus
aImp[14] := MaFisRet(1,"IT_BASESOL")	//Base do ICMS Solidario
aImp[15] := MaFisRet(1,"IT_ALIQSOL")	//Aliquota do ICMS Solidario
aImp[16] := MaFisRet(1,"IT_MARGEM")		//Margem de lucro para calculo da Base do ICMS Sol.*/

//	MaFisSave()
MaFisEnd()
return aImp

/*
// -------------------------------------------------------------------
// Campos utilizados para retorno dos impostos calculado
// -------------------------------------------------------------------
IT_GRPTRIB				//Grupo de Tributacao
IT_EXCECAO				//Array da EXCECAO Fiscal
IT_ALIQICM				//Aliquota de ICMS
IT_ICMS					//Array contendo os valores de ICMS
IT_BASEICM				//Valor da Base de ICMS
IT_VALICM				//Valor do ICMS Normal
IT_BASESOL				//Base do ICMS Solidario
IT_ALIQSOL				//Aliquota do ICMS Solidario
IT_VALSOL				//Valor do ICMS Solidario
IT_MARGEM				//Margem de lucro para calculo da Base do ICMS Sol.
IT_BICMORI				//Valor original da Base de ICMS
IT_ALIQCMP				//Aliquota para calculo do ICMS Complementar
IT_VALCMP				//Valor do ICMS Complementar do item
IT_BASEICA				//Base do ICMS sobre o frete autonomo
IT_VALICA				//Valor do ICMS sobre o frete autonomo
IT_DEDICM				//Valor do ICMS a ser deduzido
IT_VLCSOL				//Valor do ICMS Solidario calculado sem o credito aplicado
IT_PAUTIC				//Valor da Pauta do ICMS Proprio
IT_PAUTST				//Valor da Pauta do ICMS-ST
IT_PREDIC				//%Redução da Base do ICMS
IT_PREDST				//%Redução da Base do ICMS-ST
IT_MVACMP				//Margem do complementar
IT_PREDCMP				//%Redução da Base do ICMS-CMP
IT_ALIQIPI				//Aliquota de IPI
IT_IPI					//Array contendo os valores de IPI
IT_BASEIPI				//Valor da Base do IPI
IT_VALIPI				//Valor do IPI
IT_BIPIORI				//Valor da Base Original do IPI
IT_PREDIPI				//%Redução da Base do IPI
IT_PAUTIPI				//Valor da Pauta do IPI
IT_NFORI				//Numero da NF Original
IT_SERORI				//Serie da NF Original
IT_RECORI				//RecNo da NF Original (SD1/SD2)
IT_DESCONTO				//Valor do Desconto
IT_FRETE				//Valor do Frete
IT_DESPESA				//Valor das Despesas Acessorias
IT_SEGURO				//Valor do Seguro
IT_AUTONOMO				//Valor do Frete Autonomo
IT_VALMERC				//Valor da mercadoria
IT_PRODUTO				//Codigo do Produto
IT_TES					//Codigo da TES
IT_TOTAL				//Valor Total do Item
IT_CF					//Codigo Fiscal de Operacao
IT_FUNRURAL				//Aliquota para calculo do Funrural
IT_PERFUN				//Valor do Funrural do item
IT_DELETED				//Flag de controle para itens deletados
IT_LIVRO				//Array contendo o Demonstrativo Fiscal do Item
IT_ISS					//Array contendo os valores de ISS
IT_ALIQISS				//Aliquota de ISS do item
IT_BASEISS				//Base de Calculo do ISS
IT_VALISS				//Valor do ISS do item
IT_CODISS				//Codigo do ISS
IT_CALCISS				//Flag de controle para calculo do ISS
IT_RATEIOISS			//Flag de controle para calculo do ISS
IT_CFPS					//Codigo Fiscal de Prestacao de Servico
IT_PREDISS				//Redução da base de calculo do ISS
IT_VALISORI				//Valor do ISS do item sem aplicar o arredondamento
IT_IR					//Array contendo os valores do Imposto de renda
IT_BASEIRR				//Base do Imposto de Renda do item
IT_REDIR				//Percentual de Reducao da Base de calculo do IR
IT_ALIQIRR				//Aliquota de Calculo do IR do Item
IT_VALIRR				//Valor do IR do Item
IT_INSS					//Array contendo os valores de INSS
IT_BASEINS				//Base de calculo do INSS
IT_REDINSS				//Percentual de Reducao da Base de Calculo do INSS
IT_ALIQINS				//Aliquota de Calculo do INSS
IT_VALINS				//Valor do INSS
IT_ACINSS				//Acumulo INSS
IT_VALEMB				//Valor da embalagem
IT_BASEIMP				//Array contendo as Bases de Impostos Variaveis
IT_BASEIV1				//Base de Impostos Variaveis 1
IT_BASEIV2				//Base de Impostos Variaveis 2
IT_BASEIV3				//Base de Impostos Variaveis 3
IT_BASEIV4				//Base de Impostos Variaveis 4
IT_BASEIV5				//Base de Impostos Variaveis 5
IT_BASEIV6				//Base de Impostos Variaveis 6
IT_BASEIV7				//Base de Impostos Variaveis 7
IT_BASEIV8				//Base de Impostos Variaveis 8
IT_BASEIV9				//Base de Impostos Variaveis 9
IT_ALIQIMP				//Array contendo as Aliquotas de Impostos Variaveis
IT_ALIQIV1				//Aliquota de Impostos Variaveis 1
IT_ALIQIV2				//Aliquota de Impostos Variaveis 2
IT_ALIQIV3				//Aliquota de Impostos Variaveis 3
IT_ALIQIV4				//Aliquota de Impostos Variaveis 4
IT_ALIQIV5				//Aliquota de Impostos Variaveis 5
IT_ALIQIV6				//Aliquota de Impostos Variaveis 6
IT_ALIQIV7				//Aliquota de Impostos Variaveis 7
IT_ALIQIV8				//Aliquota de Impostos Variaveis 8
IT_ALIQIV9				//Aliquota de Impostos Variaveis 9
IT_VALIMP				//Array contendo os valores de Impostos Agentina/Chile/Etc.
IT_VALIV1				//Valor do Imposto Variavel 1
IT_VALIV2				//Valor do Imposto Variavel 2
IT_VALIV3				//Valor do Imposto Variavel 3
IT_VALIV4				//Valor do Imposto Variavel 4
IT_VALIV5				//Valor do Imposto Variavel 5
IT_VALIV6				//Valor do Imposto Variavel 6
IT_VALIV7				//Valor do Imposto Variavel 7
IT_VALIV8				//Valor do Imposto Variavel 8
IT_VALIV9				//Valor do Imposto Variavel 9
IT_BASEDUP				//Base das duplicatas geradas no financeiro
IT_DESCZF				//Valor do desconto da Zona Franca do item
IT_DESCIV				//Array contendo a descricao dos Impostos Variaveis
IT_DESCIV1				//Array contendo a Descricao dos IV 1
IT_DESCIV2				//Array contendo a Descricao dos IV 2
IT_DESCIV3				//Array contendo a Descricao dos IV 3
IT_DESCIV4				//Array contendo a Descricao dos IV 4
IT_DESCIV5				//Array contendo a Descricao dos IV 5
IT_DESCIV6				//Array contendo a Descricao dos IV 6
IT_DESCIV7				//Array contendo a Descricao dos IV 7
IT_DESCIV8				//Array contendo a Descricao dos IV 8
IT_DESCIV9				//Array contendo a Descricao dos IV 9
IT_QUANT				//Quantidade do Item
IT_PRCUNI				//Preco Unitario do Item
IT_VIPIBICM				//Valor do IPI Incidente na Base de ICMS
IT_PESO					//Peso da mercadoria do item
IT_ICMFRETE				//Valor do ICMS Relativo ao Frete
IT_BSFRETE				//Base do ICMS Relativo ao Frete
IT_BASECOF				//Base de calculo do COFINS
IT_ALIQCOF				//Aliquota de calculo do COFINS
IT_VALCOF				//Valor do COFINS
IT_BASECSL				//Base de calculo do CSLL
IT_ALIQCSL				//Aliquota de calculo do CSLL
IT_VALCSL				//Valor do CSLL
IT_BASEPIS				//Base de calculo do PIS
IT_ALIQPIS				//Aliquota de calculo do PIS
IT_VALPIS				//Valor do PIS
IT_RECNOSB1				//RecNo do SB1
IT_RECNOSF4				//RecNo do SF4
IT_VNAGREG				//Valor da Mercadoria nao agregada.
IT_TIPONF				//Tipo da nota fiscal
IT_REMITO				//Remito
IT_BASEPS2				//Base de calculo do PIS 2
IT_ALIQPS2				//Aliquota de calculo do PIS 2
IT_VALPS2				//Valor do PIS 2
IT_BASECF2				//Base de calculo do COFINS 2
IT_ALIQCF2				//Aliquota de calculo do COFINS 2
IT_VALCF2				//Valor do COFINS 2
IT_ABVLINSS				//Abatimento da base do INSS em valor 
IT_ABVLISS				//Abatimento da base do ISS em valor 
IT_REDISS				//Percentual de reducao de base do ISS ( opcional, utilizar normalmente TS_BASEISS ) 
IT_ICMSDIF				//Valor do ICMS diferido
IT_DESCZFPIS			//Desconto do PIS
IT_DESCZFCOF			//Desconto do Cofins
IT_BASEAFRMM			//Base de calculo do AFRMM ( Item )
IT_ALIQAFRMM			//Aliquota de calculo do AFRMM ( Item )
IT_VALAFRMM				//Valor do AFRMM ( Item )
IT_PIS252				//Decreto 252 de 15/06/2005 - PIS no item para retencao aquisicao a aquisicao - sem considerar R# 5.000,00 da Lei 10925
IT_COF252				//Decreto 252 de 15/06/2005 - COFINS no item para retencao aquisicao a aquisicao - sem considerar R# 5.000,00 da Lei 10925
IT_CRDZFM				//Credito Presumido - Zona Franca de Manaus
IT_CNAE					//Codigo da Atividade Economica da Prestacao de Servicos
IT_ITEM					//Numero Item
IT_SEST					//Array contendo os valores do SEST
IT_BASESES				//Base de calculo do SEST
IT_ALIQSES				//Aliquota de calculo do SEST
IT_VALSES				//Valor do INSS
IT_BASEPS3				//Base de calculo do PIS Subst. Tributaria
IT_ALIQPS3				//Aliquota de calculo do PIS Subst. Tributaria
IT_VALPS3				//Valor do PIS Subst. Tributaria
IT_BASECF3				//Base de calculo da COFINS Subst. Tributaria
IT_ALIQCF3				//Aliquota de calculo da COFINS Subst. Tributaria
IT_VALCF3				//Valor da COFINS Subst. Tributaria
IT_VLR_FRT				//Valor do Frete de Pauta
IT_BASEFET				//Base do Fethab   
IT_ALIQFET				//Aliquota do Fethab
IT_VALFET				//Valor do Fethab   
IT_ABSCINS				//Abatimento do Valor do INSS em Valor - SubContratada
IT_SPED					//SPED
IT_ABMATISS				//Abatimento da base do ISS em valor referente a material utilizado 
IT_RGESPST				//Indica se a operacao, mesmo sem calculo de ICMS ST, faz parte do Regime Especial de Substituicao Tributaria
IT_PRFDSUL				//Percentual de UFERMS para o calculo do Fundersul - Mato Grosso do Sul
IT_UFERMS				//Valor da UFERMS para o calculo do Fundersul - Mato Grosso do Sul
IT_VALFDS				//Valor do Fundersul - Mato Grosso do Sul
IT_ESTCRED				//Valor do Estorno de Credito/Debito
IT_CODIF				//Codigo de autorizacao CODIF - Combustiveis
IT_BASETST				//Base do ICMS de transporte Substituicao Tributaria
IT_ALIQTST				//Aliquota do ICMS de transporte Substituicao Tributaria
IT_VALTST				//Valor do ICMS de transporte Substituicao Tributaria
IT_CRPRSIM				//Valor Crédito Presumido Simples Nacional - SC, nas aquisições de fornecedores que se enquadram no simples
IT_VALANTI				//Valor Antecipacao ICMS                       
IT_DESNTRB				//Despesas Acessorias nao tributadas - Portugal
IT_TARA					//Tara - despesas com embalagem do transporte - Portugal
IT_PROVENT				//Provincia de entrega
IT_VALFECP				//Valor do FECP
IT_VFECPST				//Valor do FECP ST
IT_ALIQFECP				//Aliquota FECP
IT_CRPRESC				//Credito Presumido SC 
IT_DESCPRO				//Valor do desconto total proporcionalizado
IT_ANFORI2				//IVA Ajustado
IT_UFORI				//UF Original da Nota de Entrada para o calculo do IVA Ajustado( Opcional )
IT_ALQORI				//Aliquota Original da Nota de Entrada para o calculo do IVA Ajustado ( Opcional )
IT_PROPOR				//Quantidade proporcional na venda para o calculo do IVA Ajustado( Opcional )
IT_ALQPROR				//Aliquota proporcional na venda para o calculo do IVA Ajustado( Opcional )
IT_ANFII				//Array contendo os valores do Imposto de Importação
IT_ALIQII				//Aliquota do Imposto de Importação
IT_VALII				//Valor do Imposto de Importação (Digitado direto na Nota Fiscal)
IT_PAUTPIS				//Valor da Pauta do PIS
IT_PAUTCOF				//Valor da Pauta do Cofins
IT_ALIQDIF				//Aliquota interna do estado para calculo do Diferencial de aliquota do Simples Nacional
IT_CLASFIS				//Valor do Imposto de Importação (Digitado direto na Nota Fiscal)
IT_VLRISC				//Valor do imposto ISC (Localizado Peru) por unidade  "PER"
IT_CRPREPE				//Credito Presumido - Art. 6 Decreto  n28.247
IT_CRPREMG				//Credito Presumido MG 
IT_SLDDEP				//Valor de desconto de depedendente fornecedor
*/

/*______________________________________________________________________
   ¦Autor     ¦ Breno Ferreira                      ¦ Data ¦ 28/08/14 ¦
   +----------+-------------------------------------------------------¦
   ¦Descrição ¦ Retornar o titulo da sigla do imposto na Pre-DANFE    ¦
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#include "rwmake.ch"
#include "protheus.ch"

User Function MPREDANF(cSigla)
Local cRet := ""
	
do case
	case cSigla == "ICM"
		cRet := "ICMS"
	case cSigla == "IPI"
		cRet := "IPI"
	case cSigla == "ICA"
		cRet := "ICMS ref. Frete Autonomo"
	case cSigla == "TST"
		cRet := "ICMS ref. Frete Autonomo - ST"
	case cSigla == "ICR"
		cRet := "ICMS Retido"
	case cSigla == "ICC"
		cRet := "ICMS Complementar"
	case cSigla == "ISS"
		cRet := "ISS"
	case cSigla == "IRR"
		cRet := "IRRF"
	case cSigla == "INS"
		cRet := "INSS"
	case cSigla == "COF"
		cRet := "COFINS - Via Retenção"
	case cSigla == "CSL"
		cRet := "CSLL - Via Retenção"
	case cSigla == "PIS"
		cRet := "PIS - Via Retençao"
	case cSigla == "FRU"
		cRet := "FUNRURAL"
	case cSigla == "PS2"
		cRet := "PIS/Pasep - Via Apuração"
	case cSigla == "CF2"
		cRet := "COFINS - Via Apuração"
	case cSigla == "AFR"			//AFRMM
		cRet := "AFRMM"
	case cSigla == "SES"
		cRet := "SEST/SENAT"
	case cSigla == "PS3"
		cRet := "PIS/Pasep - Subst. Tributária"
	case cSigla == "CF3"
		cRet := "COFINS - Subst. Tributária"
	case cSigla == "FET"
		cRet := "FETHAB"
	case cSigla == "FDS"
		cRet := "FUNDERSUL"
	otherwise
		cRet := "Sigla não encontrada"
endcase
return cRet
