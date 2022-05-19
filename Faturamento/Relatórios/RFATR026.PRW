#Include "Rwmake.ch"      
#Include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"   
#INCLUDE "SCROLLBX.CH"
#include "JPEG.CH"
#define _CRLF CHR(13)+CHR(10)

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ RFATR026 ³ Autor ³ Solange Vezú        ³ Data ³ 20/11/2006 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descricao ³ Demonstrativo de Orcamento                                 ³±±
±±³          29/10/08 - Emitir para qualquer empresa, conforme parametro  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function RFATR026()

SetPrvt("CBTXT,CBCONT,NORDEM,TAMANHO,LIMITE,CIMPRI")
SetPrvt("NTOTAL,TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NIPI,NVALIPI,NTOTIPI,TOTGER,NFRETE")
SetPrvt("NCOND,NCOND1,NCOND2,NCOND3,NVENC,NVENC1,NVENC2,NVENC3")
SetPrvt("NOMEPROG,CPERG,NLASTKEY,LCONTINUA,nLin,WNREL,NPAG")
SetPrvt("CSTRING,NQTD,")

Private cCGCPict
PRIVATE aParcelas   := {}
Private NomeProg	  := "RFATR026" 
Private wnrel  	  := "RFATR026"
Private cPerg		  := ""
Private dtEntrega   := CTOD("")
Private dParcela    := CTOD("")
Private cCNPJ       := ""
Private cNotas      := ""
Private _cOperacao  := ""
Private _cGrupo     := "" 
Private _lTerc      := .F.
Private nTotDesc    := 0  
Private cProdCli    := ""

// Atencao, para executar esta rotina no botao IMPRIMIR em Orcamento, Definir o parametro MV_ORCIMPR = RFATR026, Cida - 29/10/08
If nLastKey == 27
	Return
Endif

// Define Variaveis Ambientais                                  
cbTxt	   := ""
cbCont	:= "" 
cEst     := ""
nOrdem 	:= 0
Tamanho	:= "P" 
Limite	:= 132
cImpri   := ""
nTotal   := 0
nTotDesc := 0 
nIpi     := 0
nValIPI  := 0
nTotIpi  := 0
nTotGer  := 0
nFrete   := 0
nLin	   := 0
nParc    := 0
ncond    := 0  
cPedido  := "" 
cOrcam   := ""
cFrom    := ""
nvenc    := Date()
nvenc1   := Date() 
nvenc2   := Date()
nvenc3   := Date()
nvenc4   := Date()

Titulo   := PadC(OemToAnsi("Titulo"),74)
cDesc1   := PadC(OemToAnsi("Esta opção imprime o Orçamento"),74)
cDesc2   := PadC(OemToAnsi("de Venda que foi selecionado."),74)
cDesc3   := PadC(OemToAnsi(""),74)

aReturn	 := { OemToAnsi("STR0004"), 1,OemToAnsi("STR0005"), 1, 2, 1,"",1 }
nLastKey  := 0 
lContinua := .T.
nLin 	    := 99

If SubStr(cNumEmp,1,2) $ "10"  //FABRIMA
	//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal
	cString:="SCK"
	
	//³ Envia controle para a funcao SETPRINT
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
	If ( nLastKey == 27 .Or. LastKey() == 27 )
	   Return(.F.)
	Endif
	
	//³ Verifica Posicao do Formulario na Impressora 
	SetDefault(aReturn,cString)
	If ( nLastKey == 27 .Or. LastKey() == 27 )
	   Return(.F.)
	Endif

	RptStatus({|| RptDetFAB()})
	
Else
	RptStatus({|| RptDetMAS()})
	
EndIf	

Return(.T.)

//**********************************
	Static Function RptDetFAB()
//**********************************

Local cAliICM	 := ''
Local nLig1      := 0
Local nColEmp    := 550
Local nLig       := 2900
Local lPagPrint
Local _cAgreg 	 := " "
Local J, X

Private cOrc	 := ""	//Parâmetros criados para imprimir... 
Private cPed    := ""   //o PEDIDO no título do Relatorio caso...
Private cTitulo := ""   //o CJ_STATUS seja 'B' (Efetivado)
Private nColPed := 0		
Private nLig    := 0

Private oFont05
Private oFont06
Private oFont07
Private oFont08
Private oFont09
Private oFont10
Private oFont10n
Private oFont11
Private oFont12
Private oFont15
Private oFont20

Private oQPrint
Private nPag       := 1
Private nItem      := 0
Private lFirst     := .T.
Private lInicial   := .F.
Private aCausas    := {}
Private aFichas    := {}
Private aEtapas    := {}
Private cFileLogo  := ""
Private cFilOld    := cFilAnt
Private cNomFilial := ""
Private lTMKPMS    := If(GetMv("MV_QTMKPMS",.F.,1) == 1,.F.,.T.)//Integracao do QNC com TMK e PMS: 1-Sem integracao,2-TMKxQNC,3-QNCxPMS,4-TMKxQNCxPMS ³

oFont08 := TFont():New("Courier New",,08,,.F.,,,,,.F.)
oFont09 := TFont():New("Courier New",,09,,.F.,,,,,.F.)
oFont10 := TFont():New("Courier New",,10,,.F.,,,,,.F.)
oFont11 := TFont():New("Arial",,11,,.F.,,,,.T.,.F.)
oFont12 := TFont():New("Courier New",,10,,.T.,,,,,.F.)
oFont15 := TFont():New("Arial",15,15,,.F.,,,,.T.,.F.)

//³Inicializacao do objeto grafico             ³
oPrint := TMSPrinter():New("RFATR026")
oPrint:SetPortrait()
oPrint:StartPage()

cOrcam := SCJ->CJ_NUM

If Select("TMP1") > 0 
   DbSelectArea("TMP1")
   DbCloseArea()
EndIf

cQry1 := "SELECT SUM(SCK.CK_PRUNIT*SCK.CK_QTDVEN) AS UNITARIO, SUM(SCK.CK_VALOR) AS VENDA "
cQry1 += "FROM "+RetSqlName("SCJ")+" SCJ "
cQry1 += "INNER JOIN "+RetSqlName("SCK")+" SCK ON SCK.CK_FILIAL = '"+xFilial("SCK")+"' AND SCK.CK_NUM = SCJ.CJ_NUM "
cQry1 += "      AND SCK.D_E_L_E_T_ = ' '  "
cQry1 += "WHERE SCJ.CJ_FILIAL = '"+xFilial("SCJ")+"' AND SCK.CK_NUM = '"+SCJ->CJ_NUM+"' AND SCJ.D_E_L_E_T_ = ' '  "
cQry1 += "GROUP BY SCJ.CJ_NUM "
cQry1 += "ORDER BY SCJ.CJ_NUM "

TcQuery cQry1 New Alias "TMP1"

dbSelectArea("TMP1")
dbGoTop()

nPrcUnit := TMP1->UNITARIO
nPrcVend := TMP1->VENDA

TMP1->(DbCloseArea())                                           

If Select("TMP") > 0 
   DbSelectArea("TMP")
   DbCloseArea()
EndIf

cQuery := "SELECT SCJ.CJ_NUM,     SCJ.CJ_ORCAM,   SCJ.CJ_CLIENTE, SCJ.CJ_LOJA,   SCJ.CJ_MSTRANS, SCJ.CJ_CONDPAG, SCJ.CJ_STATUS,  "
cQuery += "       SCJ.CJ_MSCTATO, SCJ.CJ_MSVEND,  SCJ.CJ_EMISSAO, SCJ.CJ_FRETE,  SCJ.CJ_VALIDA,  SCJ.CJ_MSPRZEN, SCJ.CJ_MSNOTAS, "
cQuery += "       SCK.CK_NUM,     SCK.CK_ITEM,    SCK.CK_PRODUTO, SCK.CK_ENTREG, SCK.CK_UM,      SCK.CK_QTDVEN,  "
cQuery += "       SCK.CK_VALOR,   SCK.CK_VALDESC, SCK.CK_PRUNIT,  SCK.CK_PRCVEN, SCJ.CJ_TABELA,  SCK.CK_TES,     "
cQuery += "       SCK.CK_MSMATCL, SCK.CK_MSCL,    SCK.CK_MSDOBRA, SCK.CK_MSPINT, SCK.CK_MSSOLDA, SCK.CK_MSUSINA, "
cQuery += "       SA1.A1_COD,     SA1.A1_LOJA,    SA1.A1_NOME,    SA1.A1_END,    SA1.A1_BAIRRO,  SA1.A1_CEP,     SA1.A1_MUN,     "
cQuery += "       SA1.A1_EST,     SA1.A1_CEP,     SA1.A1_CGC,     SA1.A1_INSCR,  SA1.A1_TEL,     SA1.A1_FAX,     SA1.A1_ENDCOB,  "
//Ivandro Santos - 19/07/2017
//Ticket#2017071837000096 — ADICIONAR NO ORÇAMENTO INFORMAÇÕES DE ICMS REDUZIDO - MASIPACK E FABRIMA
cQuery += "       SA1.A1_BAIRROC, SA1.A1_CEPC,    SA1.A1_MUNC,    SA1.A1_ESTC,   SE4.E4_DESCRI,  SA3.A3_EMAIL,   SB1.B1_GRTRIB,  "
cQuery += "       SB1.B1_DESC,    SB1.B1_POSIPI,  SB1.B1_GRUPO,   SB1.B1_PICM,   SB1.B1_IPI,     SF4.F4_IPI,     SF4.F4_ICM,     "
cQuery += "       SF4.F4_AGREG,   DA1.DA1_PRCVEN, SA4.A4_NOME,    DA1.DA1_DATVIG,ISNULL(SYD.YD_BICMS,0) [YD_BICMS]    "
cQuery += "FROM "+RetSqlName("SCJ")+" SCJ "
cQuery += "INNER JOIN "+RetSqlName("SCK")+" SCK ON SCK.CK_FILIAL = '" + xFilial("SCK")+"' AND SCK.CK_NUM = SCJ.CJ_NUM AND SCK.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '" + xFilial("SA1")+"' AND SA1.A1_COD = SCJ.CJ_CLIENTE AND SA1.A1_LOJA = SCJ.CJ_LOJA AND SA1.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '" + xFilial("SE4")+"' AND SE4.E4_CODIGO = SCJ.CJ_CONDPAG AND SE4.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '" + xFilial("SA3")+"' AND SA3.A3_COD = SCJ.CJ_MSVEND  AND SA3.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1")+"' AND SB1.B1_COD = SCK.CK_PRODUTO AND SB1.D_E_L_E_T_ = '' "
cQuery += "LEFT JOIN  "+RetSqlName("SYD")+" SYD ON SYD.YD_FILIAL = '" + xFilial("SYD")+"' AND SB1.B1_POSIPI = SYD.YD_TEC AND SB1.D_E_L_E_T_ = '' "
//Ticket#2017071837000096 — Fim da alteração
cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL = '" + xFilial("SF4")+"' AND SF4.F4_CODIGO = SCK.CK_TES AND SF4.D_E_L_E_T_ = '' "
cQuery += "LEFT OUTER JOIN "+RetSqlName("DA1")+" DA1 ON DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.DA1_CODTAB = SCJ.CJ_TABELA AND "
cQuery += "                                      DA1.DA1_CODPRO = SCK.CK_PRODUTO AND DA1.D_E_L_E_T_ = '' "
cQuery += "LEFT OUTER JOIN "+RetSqlName("SA4")+" SA4 ON SA4.A4_FILIAL  = '"+xFilial("SA4")+"' AND SA4.A4_COD = SCJ.CJ_MSTRANS AND SA4.D_E_L_E_T_ = '' "
cQuery += "WHERE SCJ.CJ_FILIAL = '"+xFilial("SCJ")+"' AND SCJ.CJ_NUM = '"+cOrcam+"' AND SCJ.D_E_L_E_T_ = '' "
cQuery += "ORDER BY SCJ.CJ_NUM, SCK.CK_ITEM, DA1.DA1_DATVIG DESC "

TcQuery cQuery New Alias "TMP"

TcSetField("TMP","CJ_EMISSAO","D",08,00)
TcSetField("TMP","CJ_VALIDA" ,"D",08,00)
TcSetField("TMP","CK_ENTREG" ,"D",08,00)

dbSelectArea("TMP")
dbGoTop()

cPedido := TMP->CJ_NUM   
cOrcam  := TMP->CJ_ORCAM
cEst    := TMP->A1_EST
cCGCPict:=PesqPict("SA1","A1_CGC")
		
oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
nLin:=nLin+70       
oPrint:Say(nLin,0020,"RFATR026",oFont11)
oPrint:Say(nLin,0600,SM0->M0_NOMECOM,oFont11)
oPrint:Say(nlin,2200,"Pag.:"+Transform(nPag,"@E 99"),oFont11)
nLin:=nLin+55
oPrint:Say(nLin,0450,Alltrim(SM0->M0_ENDENT) + " - " + Alltrim(SM0->M0_BAIRENT) + " - " + Alltrim(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT + " - CEP: " + substr(SM0->M0_CEPENT,1,5)+"-"+substr(SM0->M0_CEPENT,6,3),oFont11)
nLin:=nLin+55
If SubStr(cNumEmp,1,2) == "01"
   oPrint:Say(nLin,0550,"Tel: (11) 3246-3666,4178-8099 R. 309      Fax: (11) 3246-3666,4178-8099 R. 352",oFont11)
Else   
   oPrint:Say(nLin,0550,"Tel: "+ SM0->M0_TEL + "  Fax: " + SM0->M0_FAX,oFont11)
EndIf   
nLin:=nLin+55
cCNPJ := SM0->M0_CGC
If !Empty(SM0->M0_INSC)
   
   oPrint:Say(nLin,0600,"Inscr: " + SM0->M0_INSC + " CNPJ: " + SubStr(cCNPJ,1,8) + "/" + SubStr(cCNPJ,9,4) + "-" + SubStr(cCNPJ,13,2),oFont11)
Else
   oPrint:Say(nLin,800,"CNPJ: " + SubStr(cCNPJ,1,8) + "/" + SubStr(cCNPJ,9,4) + "-" + SubStr(cCNPJ,13,2),oFont11)
EndIf      
nLin:=nLin+55
oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
nLin:=nLin+70
                               
_cCondP	 := TMP->CJ_CONDPAG
DtEmissao := TMP->CJ_EMISSAO
DtEntrega := TMP->CK_ENTREG
DtValida  := TMP->CJ_VALIDA
_cEntrega := TMP->CJ_MSPRZEN   // LIZANDRA 17/08/12 - NÃO ESTAVA SENDO IMPRESSO O PRAZO DE ENTREGA
cOrcam    := TMP->CJ_NUM

Do While !TMP->(Eof())
	
	cNum := TMP->CJ_NUM
	If TMP->CJ_STATUS == 'B'
		dbSelectArea("SC5")
		dbSetOrder(5)
		dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
		oPrint:Say(nLin-08,0700,TMP->CJ_NUM,oFont15)
		oPrint:Say(nLin-08,1550,SC5->C5_NUM,oFont15)
		oPrint:Say(nLin,0300,"ORCAMENTO  N.o.:                     aprovado conf. PEDIDO N.o.:  ",oFont11)
	Else
		oPrint:Say(nLin-08,1400,TMP->CJ_NUM,oFont15)
		//oPrint:Say(nLin-08,1400,cOrcam,oFont15)
		oPrint:Say(nLin,0700,"O  R  C  A  M  E  N  T  O     N.o.:  ",oFont11)
	Endif
	
	oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
	nLin:=nLin+70
	oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
	nLin:=nLin+70
	oPrint:Say(nLin,0020,"Cond.Pagto: ",oFont11)
	oPrint:Say(nLin,0300,TMP->E4_DESCRI,oFont11)
	oPrint:Say(nLin,1200,"Via de Transp: ",oFont11)
	oPrint:Say(nLin,1500,Alltrim(TMP->A4_NOME),oFont11)
	nLin:=nLin+90
	oPrint:Say(nLin,0020,"D A D O S    D O    D E S T I N A T A R I O:",oFont11)
	nLin:=nLin+70
	oPrint:Say(nLin,0020,"Codigo/Filial: ",oFont11)
	oPrint:Say(nLin,0300,TMP->A1_COD+"/"+TMP->A1_LOJA+" - "+TMP->A1_NOME,oFont11)
	nLin:=nLin+60
	oPrint:Say(nLin,0020,"Endereco: ",oFont11)
	oPrint:Say(nLin,0300,SUBSTR(TMP->A1_END,1,35),oFont11)
	oPrint:Say(nLin,1200,"Bairro: ",oFont11)
	oPrint:Say(nLin,1400,TMP->A1_BAIRRO,oFont11)
	nLin:=nLin+60
	oPrint:Say(nLin,0020,"CEP: ",oFont11)
	oPrint:Say(nLin,0300,(substr(TMP->A1_CEP,1,5)+"-"+substr(TMP->A1_CEP,6,3)),oFont11)
	oPrint:Say(nLin,1200,"Cidade: ",oFont11)
	oPrint:Say(nLin,1400,SUBST(TMP->A1_MUN,1,20)+"    UF: "+TMP->A1_EST,oFont11)
	nLin:=nLin+60
	oPrint:Say(nLin,0020,"CNPJ: ",oFont11)
	oPrint:Say(nLin,0300,Trans(TMP->A1_CGC,cCgcPict),oFont11)
	oPrint:Say(nLin,1200,"I.E.: ",oFont11)
	oPrint:Say(nLin,1400,TMP->A1_INSCR,oFont11)
	nLin:=nLin+60
	oPrint:Say(nLin,0020,"Fone/Fax: ",oFont11)
	oPrint:Say(nLin,0300,TMP->A1_TEL+" / "+TMP->A1_FAX,oFont11)
	oPrint:Say(nLin,1200,"Contato: ",oFont11)
	oPrint:Say(nLin,1400,Alltrim(TMP->CJ_MSCTATO)+"   -    S/Pedido: "+TMP->CJ_ORCAM,oFont11)
	nLin:=nLin+90
	oPrint:Say(nLin,0020,"E N D E R E C O    D E    C O B R A N C A:",oFont11)
	nLin:=nLin+70
	oPrint:Say(nLin,0020,"Endereco: ",oFont11)
	oPrint:Say(nLin,0300,SUBSTR(TMP->A1_ENDCOB,1,35),oFont11)
	oPrint:Say(nLin,1200,"Bairro: ",oFont11)
	oPrint:Say(nLin,1400,TMP->A1_BAIRROC,oFont11)
	nLin:=nLin+60
	oPrint:Say(nLin,0020,"CEP: ",oFont11)
	oPrint:Say(nLin,0300,substr(TMP->A1_CEPC,1,5)+"-"+substr(TMP->A1_CEPC,6,3),oFont11)
	oPrint:Say(nLin,1200,"Cidade: ",oFont11)
	oPrint:Say(nLin,1400,SUBST(TMP->A1_MUNC,1,20)+"  -  UF: "+TMP->A1_ESTC,oFont11)
	nLin:=nLin+90
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+TMP->CJ_MSVEND))
		oPrint:Say(nLin,0020,"Vendedor(a): ",oFont11)
		oPrint:Say(nLin,0300,SA3->A3_NOME,oFont11)
		oPrint:Say(nLin,1200,"E-mail: ",oFont11)
		If !Empty(SA3->A3_EMAIL)
			oPrint:Say(nLin,1400,SA3->A3_EMAIL,oFont11)
		Else
			oPrint:Say(nLin,1400,"acessorios@masipack.com.br",oFont11)
		EndIf
	Else
		oPrint:Say(nLin,0020,"E-mail:",oFont11)
		oPrint:Say(nLin,0300,"acessorios@masipack.com.br",oFont11)
	EndIf
	nLin:=nLin+90
	oPrint:Say(nLin,0020,"I T E N S:",oFont11)
	nLin:=nLin+40
	oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
	nLin:=nLin+30
	oPrint:Say(nLin,0020,"IT Codigo",oFont09)
	//Ticket#2017071837000096 — ADICIONAR NO ORÇAMENTO INFORMAÇÕES DE ICMS REDUZIDO - MASIPACK E FABRIMA
	oPrint:Say(nLin,0310,"Descricao",oFont09)
	oPrint:Say(nLin,0770,"Entrega",oFont09)
	oPrint:Say(nLin,0970,"CF",oFont09)
	oPrint:Say(nLin,1160,"UM",oFont09)
	oPrint:Say(nLin,1260,"Qtde",oFont09)
	oPrint:Say(nLin,1400,"Vlr.Unit.",oFont09)
	oPrint:Say(nLin,1600,"Vlr.Merc.",oFont09)
	oPrint:Say(nLin,1810,"%IPI",oFont09)
	oPrint:Say(nLin,1930,"Vlr.IPI",oFont09)
	oPrint:Say(nLin,2105,"%ICMS",oFont09)
	oPrint:Say(nLin,2230,"Red ICM",oFont09)
	
	nLin:=nLin+30
	oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
	nLin:=nLin+30
	
	TMP->(DbGotop())

	cOrcam := TMP->CK_NUM
	cCodigo := ""
	cItem	 := ""
	
	Do While ( cOrcam == TMP->CK_NUM .And. TMP->(!Eof())  )
		DtEmissao := TMP->CJ_EMISSAO
		DtEntrega := TMP->CK_ENTREG
		DtValida  := TMP->CJ_VALIDA   
		
	
		If cCodigo == TMP->CK_PRODUTO .AND. cItem == TMP->CK_ITEM //Se possuir duplicidade na tabela de preço pega somente o último preço pela data de vigência-FABRIMA 
		   cCodigo := TMP->CK_PRODUTO
			//TMP->(dbSkip())
		Else
		   cCodigo := TMP->CK_PRODUTO
			cItem	  := TMP->CK_ITEM
	
			oPrint:Say(nLin,0020,TMP->CK_ITEM,oFont09)           		                    //Item
			oPrint:Say(nLin,0070,TMP->CK_PRODUTO,oFont09)           		                 //Codigo
			
			//oPrint:Say(nLin,0380,SUBSTR(TMP->B1_DESC,1,30),oFont08)                      //Descrição
			oPrint:Say(nLin,0310,SUBSTR(TMP->B1_DESC,1,25),oFont08)            //Descrição    
			nLin2 := nLin
			If !EMPTY(SUBSTR(TMP->B1_DESC,25)) 
				nLin2 += 40
				oPrint:Say(nLin2,0310,SUBSTR(TMP->B1_DESC,26,25),oFont08)      //Descrição 
			EndIf 
			If !EMPTY(SUBSTR(TMP->B1_DESC,50)) 
				nLin2 += 40
				oPrint:Say(nLin2,0310,SUBSTR(TMP->B1_DESC,51,25),oFont08)      //Descrição 
			EndIf 
			If !EMPTY(SUBSTR(TMP->B1_DESC,75)) 
				nLin2 += 40
				oPrint:Say(nLin2,0310,SUBSTR(TMP->B1_DESC,76,25),oFont08)      //Descrição
			Endif
			
			oPrint:Say(nLin,0750,DtoC(DtEntrega),oFont09)                                //Entrega //oPrint:Say(nLin,0900,DtoC(DtEntrega),oFont09)
			oPrint:Say(nLin,0970,TMP->B1_POSIPI,oFont09)       							 //Classif.Fiscal //oPrint:Say(nLin,1070,TMP->B1_POSIPI,oFont09)
			oPrint:Say(nLin,1160,TMP->CK_UM,oFont09)                                     //U.M. //oPrint:Say(nLin,1250,TMP->CK_UM,oFont09)
			oPrint:Say(nLin,1180,Transform(TMP->CK_QTDVEN,"@E 9,999.999"),oFont09)        //Qtde //oPrint:Say(nLin,1280,Transform(TMP->CK_QTDVEN,"@E 9,999.99"),oFont09)
			If TMP->CK_PRCVEN <> TMP->DA1_PRCVEN
				oPrint:Say(nLin,1310,"*",oFont09)                                         //Qtde //oPrint:Say(nLin,1460,"*",oFont09)
			EndIf	
			oPrint:Say(nLin,1340,Transform(TMP->CK_PRCVEN,"@E 999,999.999"),oFont09)      //V.Unitario	//oPrint:Say(nLin,1470,Transform(TMP->CK_PRCVEN,"@E 999,999.99"),oFont09)
			oPrint:Say(nLin,1530,Transform(TMP->CK_VALOR,"@E 9,999,999.999"),oFont09)     //Vlr.Parcial	//oPrint:Say(nLin,1680,Transform(TMP->CK_VALOR,"@E 9,999,999.99"),oFont09)
			nTotal  := nTotal + TMP->CK_VALOR
			nTotDesc:= nTotDesc + (TMP->CK_PRUNIT-TMP->CK_PRCVEN)

//			nTotDesc:= nTotDesc + TMP->CK_VALDESC
			//******************************** IPI / ICMS *******************************************
			nIPI := 0
			nICM := 0
			_cGrupo := ""
			If SubStr(cNumEmp,1,2) <> "05"
				SB1->(ORDSETFOCUS(1))
				If SB1->(dbSeek(xFilial("SB1") + Alltrim(TMP->CK_PRODUTO)))
					_cGrupo := Alltrim(TMP->B1_GRUPO)
				Else
					Alert("Produto não cadastrado: " + TMP->CK_PRODUTO)
				EndIf
			EndIf
			
			If TMP->F4_ICM == "S"
				//Ivandro - 27/09/16
	      		//[Ticket#2016092037000161] ICMS ERRADO NO ORÇAMENTO
	      		If cEst == "SP"
	      		//If cEst == "SP" .Or. Alltrim(TMP->A1_INSCR) == "ISENTO"
	      		//[Ticket#2016092037000161] - Fim da alteração
					nICM := TMP->B1_PICM
				Else
/*				
					dbSelectArea("SX6")
					dbSetOrder(1)
					If DbSeek(xFilial("SX6")+"MS_ALINICM")
						nICM := val(Substr(SX6->X6_CONTEUD,At(cEst,SX6->X6_CONTEUD)+2,2))
					Endif
*/					
					cAliICM := GetMV('MS_ALINICM')
					If !Empty(cAliICM)
						nICM := Val(Substr(cAliICM,At(cEst,cAliICM)+2,2))
					Endif

				EndIf
			Else
				nICM := 0
			Endif
			
			If TMP->F4_IPI == "S"
				nIPI := TMP->B1_IPI
			Else
				nIPI := 0
			Endif
						
			//***************************************************************************************
			oPrint:Say(nLin,1790,Transform(nIPI,"@E 99.99"),oFont09)           			   	//% IPI		//oPrint:Say(nLin,1960,Transform(nIPI,"@E 99.99"),oFont09)
			If TMP->F4_IPI == "S"
				// tirado em 20/03/15 - Lizandra - para utilização do campo desconto no cabec.
				/*
				If TMP->CK_PRUNIT > TMP->CK_PRCVEN
	            nFrete   := TMP->CJ_FRETE
					nTotItem := (TMP->CK_PRUNIT * TMP->CK_QTDVEN)
					nVlrPFrt := (( nTotItem / nPrcUnit) * TMP->CJ_FRETE)
					nValIPI := (nTotItem + nVlrPFrt) * nIPI/100
				Else
	            nFrete   := TMP->CJ_FRETE
					nTotItem := TMP->CK_VALOR 
					nVlrPFrt := ((nTotItem / nPrcVend) * TMP->CJ_FRETE)
					nValIPI := (nTotItem + nVlrPFrt) * nIPI/100
				EndIf			
				*/
            	nFrete   := TMP->CJ_FRETE
				nTotItem := TMP->CK_VALOR 
				nVlrPFrt := ((nTotItem / nPrcVend) * TMP->CJ_FRETE)
				nValIPI := (nTotItem + nVlrPFrt) * nIPI/100
				nTotIpi := nTotIpi + nValIpi
				// fim da alteração
			Else
				nValIPI  := 0
				nFrete   := TMP->CJ_FRETE
				nTotItem := (TMP->CK_PRUNIT * TMP->CK_QTDVEN)
				nVlrPFrt := (( nTotItem / nPrcUnit) * TMP->CJ_FRETE)
			Endif
			
			_cAgreg := " "
			IF TMP->F4_AGREG == "D"
				_cAgreg := "D"
			ENDIF	
	
			//VICTOR DESSUNTE - 09/09/2016
			//INICIO - TICKET: 2016090937000075
			oPrint:Say(nLin,1860,Transform(nValIpi,"@E 999,999.99"),oFont09)                  	//Vlr.IPI	//oPrint:Say(nLin,2090,Transform(nValIpi,"@E 999,999.99"),oFont09)
			//FIM TICKET: 2016090937000075
			//oPrint:Say(nLin,2120,Transform(nICM,"@E 99.99"),oFont09)
			IF !EMPTY(TMP->B1_GRTRIB) .And. Alltrim(TMP->B1_GRTRIB) $ "001_002_007" //.AND. TMP->YD_BICMS = "S"
				If Select("TMF7") > 0 
				   DbSelectArea("TMF7")
				   DbCloseArea()
				EndIf
				_cQryF7 := "Select F7_BASEICM, F7_ALIQINT From "+RetSQLName("SF7")+" Where F7_GRTRIB = '"+TMP->B1_GRTRIB+"' 
				_cQryF7 += " And F7_EST = '"+TMP->A1_EST+"' And F7_FILIAL = '"+xFilial("SF7")+"' And D_E_L_E_T_ = '' "
				
				TcQuery _cQryF7 New Alias "TMF7"
		
				TcSetField("TMF7","F7_BASEICM","N",05,02)
				TcSetField("TMF7","F7_ALIQINT","N",05,02)
				dbSelectArea("TMF7")
				TMF7->(DbGoTop())
				nPerRed := TMF7->F7_BASEICM
				nIcm    := TMF7->F7_ALIQINT
				If nIcm == 0
					cAliICM := GetMV('MS_ALINICM')
					If !Empty(cAliICM)
						nICM := Val(Substr(cAliICM,At(cEst,cAliICM)+2,2))
					EndIf
				Else
					nIcm := TMF7->F7_ALIQINT
				EndIf
			Else
				nPerRed := 0
				//nIcm    := TMP->B1_PICM
			Endif
			oPrint:Say(nLin,2280,Transform(nPerRed,"@E 99.99"),oFont09)			               	//% Icms
			oPrint:Say(nLin,2120,Transform(nICM,"@E 99.99"),oFont09)
			//Ticket#2017071837000096 — Fim da alteração
			_cOperacao := ""
			If _cGrupo == "0090"
				_lTerc  := .T.
				If TMP->CK_MSMATCLI == "S"
					_cOperacao := "MP do Cliente"
				Else
					_cOperacao := "Nossa MP"
				EndIf
				If TMP->CK_MSCL == "S"
					_cOperacao := _cOperacao + ", Corte Laser"
				EndIf
				If TMP->CK_MSDOBRA == "S"
					_cOperacao := _cOperacao + ", Dobra"
				EndIf
				If TMP->CK_MSPINT == "S"
					_cOperacao := _cOperacao + ", Pintura"
				EndIf
				If TMP->CK_MSSOLDA == "S"
					_cOperacao := _cOperacao + ", Solda"
				EndIf
				If TMP->CK_MSUSINA == "S"
					_cOperacao := _cOperacao + ", Usinagem"
				EndIf
				nLin+=30
				oPrint:Say(nLin,0430,_cOperacao,oFont09)
			EndIf
			dbSelectArea("SCL")
			dbSetOrder(1)
			dbSeek(xFilial("SCL")+TMP->CK_NUM+TMP->CK_ITEM,.T.)
			
			While  (!Eof() .And. xFilial("SCL") == SCL->CL_FILIAL .And. SCL->CL_NUM == TMP->CK_NUM .And. SCL->CL_ITEMORC == TMP->CK_ITEM)
				//Ver agora se acabou a pág. e começar cabeçalho novamente
				//Alterar pág
				
				oPrint:Say(nLin,0020,"* ----->",oFont09)
				oPrint:Say(nLin,0100,SCL->CL_PRODUTO,oFont09)
				oPrint:Say(nLin,0250,SubStr(SCL->CL_DESCRI,1,30),oFont09)
				nQtd := SCL->CL_QUANT*TMP->CK_QTDVEN
				oPrint:Say(nLin,0350,Transform(nQtd,"@E 9,999.99"),oFont09)
				dbSelectArea("SCL")
				dbSkip()
			EndDo
			
			nLin := nLin2
			//Ticket#2017071837000096 — Fim da alteração
			dbSelectArea("SA7")
			dbSetOrder(1)
			IF dbSeek(xFilial("SA7")+TMP->CJ_CLIENTE+TMP->CJ_LOJA+TMP->CK_PRODUTO)
				cProdCli := SA7->A7_CODCLI
			ENDIF	
			
			If !Empty(Alltrim(cProdCli))
				nLin := nLin + 30
				oPrint:Say(nLin,0380,"Cod.Cliente: "+SUBSTR(cProdCli,1,15),oFont08)      //Cod.Produto Cliente
			EndIf
			
			nLin := nLin + 50
			If nLin > 3200
				ImpCabec()
			EndIf
		EndIf
					
		TMP->(dbSkip())
		
	EndDo
	
	oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
	//Ver agora se acabou a pág. e começar cabeçalho novamente
	//Alterar pág
	If nLin > 3000
		ImpCabec()
		If TMP->CJ_STATUS == 'B'
			dbSelectArea("SC5")
			dbSetOrder(5)
			dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
			oPrint:Say(nLin-08,0700,cNum,oFont15)
			oPrint:Say(nLin-08,1550,SC5->C5_NUM,oFont15)
			oPrint:Say(nLin,0300,"ORCAMENTO  N.o.:                     aprovado conf. PEDIDO N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Else
			oPrint:Say(nLin-08,1400,cNum,oFont15)
			oPrint:Say(nLin,0700,"O  R  C  A  M  E  N  T  O     N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Endif
		nLin += 200
	EndIf
	nLin := nLin + 20
	oPrint:Say(nLin,0020,"V A L O R E S:",oFont11)
	nLin := nLin + 60      
	oPrint:Say(nLin,0020,"Total Mercad.: "+Transform(nTotal,"@E 999,999,999.99"),oFont11)
	oPrint:Say(nLin,0550,"Valor do IPI.: "+Transform(nTotIpi,"@E 999,999.99"),oFont11)
	oPrint:Say(nLin,1000,"Valor do Frete.: "+Transform(nFRETE,"@E 999,999.99"),oFont11)
	nTotGer := nTotal+nTotIpi+nFRETE

	nDescIcm := 0                          
	IF _cAgreg == "D"
		nDescICM := nTotGer * (nICM/100) 
		nTotGer	 -= nDescICM 
	ENDIF	
	oPrint:Say(nLin,1450,"Descontos aplicados.: "+Transform(nTotDesc+nDescICM,"@E 999,999.99"),oFont11)
	oPrint:Say(nLin,2020,"Total.: "+Transform(nTotGer,"@E 999,999,999.99"),oFont11)
	nLin := nLin + 90
	
	//Ver agora se acabou a pág. e começar cabeçalho novamente
	//Alterar pág
	oPrint:Say(nLin,0020,"V E N C I M E N T O S:",oFont11)
	nLin := nLin + 60
	
	aParcelas := Condicao(nTotGer,_cCondP,,dtEntrega)
	If Len(aParcelas) > 0
		For J := 1 to Len(aParcelas)
			oPrint:Say(nLin,0030,DTOC(aParcelas[J,1]),oFont11)
			oPrint:Say(nLin,0250,Transform(aParcelas[J,2],"@E 999,999,999.99"),oFont11)
			nLin := nLin + 70
		Next
	EndIf
	
	If _lTerc
		nLin+=60
		
		If nLin > 3000
			ImpCabec()
			If TMP->CJ_STATUS == 'B'
				dbSelectArea("SC5")
				dbSetOrder(5)
				dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
				oPrint:Say(nLin-08,0700,cNum,oFont15)
				oPrint:Say(nLin-08,1550,SC5->C5_NUM,oFont15)
				oPrint:Say(nLin,0300,"ORCAMENTO  N.o.:                     aprovado conf. PEDIDO N.o.:  ",oFont11)
				oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
				nLin:=nLin+70
				oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
				nLin:=nLin+70
			Else
				oPrint:Say(nLin-08,1400,cNum,oFont15)
				oPrint:Say(nLin,0700,"O  R  C  A  M  E  N  T  O     N.o.:  ",oFont11)
				oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
				nLin:=nLin+70
				oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
				nLin:=nLin+70
			Endif
			Li+=200
		EndIf
		
		oPrint:Say(nLin,0020,"* A matéria-prima, quando fornecida pelo cliente, deverá ter no máximo 2m X 4m;",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"* No caso de chapa em aço carbono, quando fornecida pelo cliente, deverá ser",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"  decapada e oleada;",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"* Furos escareados, roscados, laterais chanfradas ou com inclinações angulares",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"  no sentido da chapa, não são executados pelo processo de corte a laser;",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"* Os diâmetros dos furos devem ter no mínimo a medida da espessura da chapa",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"  para que possam ser executados, caso contrário, os mesmos só serão marcados;",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"* Tolerância de corte: +/- 0,1mm. As tolerâncias não atendidas pelo processo",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"  a laser serão cortadas com sobre-metal;",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"* O cliente deverá enviar o desenho em padrão DXF, desenvolvidos quando houver",oFont09)
		nLin+=30
		oPrint:Say(nLin,0020,"  dobra, caso contrário, será cobrado o desenvolvimento do desenho.",oFont09)
		nLin+=60
		oPrint:Say(nLin,0020,"* Não aceitaremos pedidos com valor inferior à R$ 500,00 (Quinhentos reais)",oFont09)
		nLin+=30
	EndIf
	
	nLin+=70
	
	SA3->(dbSetOrder(7))
	SA3->(dbSeek(xFilial("SA3")+RetCodUsr()))
	
	oPrint:Say(nLin,0020,Alltrim(SA3->A3_NOME)+" - VENDAS",oFont11)
	
	If SubStr(cNumEmp,1,2) == "10"
		nLin+=50
		oPrint:Say(nLin,0750,"*",oFont12)
		nLin-=8
		oPrint:Say(nLin,0770,Replicate("-",52),oFont12)
		nLin+=8
		oPrint:Say(nLin,1920,"*",oFont12)
		nLin+=50
		oPrint:Say(nLin,0750,"|",oFont12)
		oPrint:Say(nLin,0770,"  D E F I N I R   T R A N S P O R T A D O R   N A",oFont12)
		oPrint:Say(nLin,1920,"|" ,oFont12)
		nLin+=50          
		oPrint:Say(nLin,0020,"O B S E R V A C O E S: ",oFont11)
		oPrint:Say(nLin,0750,"|",oFont12)
		oPrint:Say(nLin,0770,"    C O N F I R M A Ç Ã O   D O   P E D I D O",oFont12)
		oPrint:Say(nLin,1920,"|",oFont12)
		nLin+=50
		oPrint:Say(nLin,0750,"*",oFont12)
		oPrint:Say(nLin,0770,Replicate("-",52),oFont12)
		oPrint:Say(nLin,1920,"*",oFont12)
	//Else
	//	nLin+=140
	//	oPrint:Say(nLin,0020,"O B S E R V A C O E S: ",oFont11)
	EndIf
	nLin := nLin + 80
	oPrint:Say (nLin,0020,"VALIDADE DO ORCAMENTO: "+DtoC(DtValida), oFont10)
	nLin := nLin + 60
	oPrint:Say (nLin,0020,"PRAZO DE ENTREGA: "+_cEntrega, oFont10)
	nLin := nLin + 60
	cNotas := Alltrim(SCJ->CJ_MSNOTAS)
	If !Empty(cNotas)
		For X := 1 TO MLCOUNT(cNotas,80)
			oPrint:Say (nLin,0020, MEMOLINE(cNotas,80,X), oFont10)
			nLin := nLin + 60
		Next
	EndIf
	nLin := nLin + 60
	oPrint:Say (nLin,0020,"Sr Cliente, Favor confirmar as Classificacoes Fiscais para não ocorrer divergências na Emissão da Nota Fiscal.", oFont09)
	
	nLin+=80
	If nLin > 3000
		ImpCabec()
		If TMP->CJ_STATUS == 'B'
			dbSelectArea("SC5")
			dbSetOrder(5)
			dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
			oPrint:Say(nLin-08,0700,cNum,oFont15)
			oPrint:Say(nLin-08,1550,SC5->C5_NUM,oFont15)
			oPrint:Say(nLin,0300,"ORCAMENTO  N.o.:                     aprovado conf. PEDIDO N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Else
			oPrint:Say(nLin-08,1400,cNum,oFont15)
			oPrint:Say(nLin,0700,"O  R  C  A  M  E  N  T  O     N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Endif
		nLin+=200
	EndIf
	
	//Ivandro Santos - 28/04/17 - Início da alteração
	//Ticket#2017042837000064 — Alteração de Valor de Faturamento Mínimo nos Orçamentos de Peças
	//Felipe Freitas - 30/01/19 - Início da alteração
	//Chamado Murilo (via e-mail) - Valor mínimo de faturamento
	oPrint:Say (nLin,0020,"Valor mínimo para faturamento: R$ 200,00",oFont10)
	//Fim da alteração - Valor mínimo de faturamento
	//oPrint:Say (nLin,0020,"Valor mínimo para faturamento: R$ 300,00",oFont10)
	//oPrint:Say (nLin,0020,"Valor mínimo para faturamento: R$ 100,00",oFont10)
	//Ticket#2017042837000064 — Fim da alteração
	nLin+=70
	If SubStr(cNumEmp,1,2) == "10"
		oPrint:Say (nLin,0020,"Expedição: Indique em seu pedido de compra a transportadora de sua preferência ou solicite o despacho via SEDEX ",oFont10)
		nLin+=50
		oPrint:Say (nLin,0020,"   com a inclusão do valor do frete na nota fiscal. Na ausência dessas definições a nota fiscal será emitida e ",oFont10)
		nLin+=50
		oPrint:Say (nLin,0020,"   solicitaremos a coleta ao comprador responsável.",oFont10)
	Else
		oPrint:Say (nLin,0020,"Expedição: Solicitamos indicar a Transportadora de sua preferência. Na ausência desta",oFont10)
		nLin+=50
		oPrint:Say (nLin,0020,"   a Nota Fiscal será emitida e faremos contato com o comprador para a coleta do material.",oFont10)
	Endif
	nLin+=70
	If nLin > 3000
		ImpCabec()
		If TMP->CJ_STATUS == 'B'
			dbSelectArea("SC5")
			dbSetOrder(5)
			dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
			oPrint:Say(nLin-08,0700,cNum,oFont15)
			oPrint:Say(nLin-08,1550,SC5->C5_NUM,oFont15)
			oPrint:Say(nLin,0300,"ORCAMENTO  N.o.:                     aprovado conf. PEDIDO N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Else
			oPrint:Say(nLin-08,1400,cNum,oFont15)
			oPrint:Say(nLin,0700,"O  R  C  A  M  E  N  T  O     N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Endif
		nLin+=200
	EndIf

	oPrint:Say (nLin,0020,"Prazo de entrega:  Os  itens  com  prazo  de  entrega  futuro  eventualmente poderão ser antecipados,",oFont10)
	nLin+=50
	oPrint:Say (nLin,0020,"   dependendo apenas de nossa capacidade de produção no período de vigência do pedido.",oFont10)
	nLin+=70
	If nLin > 3000
		ImpCabec()
		If TMP->CJ_STATUS == 'B'
			dbSelectArea("SC5")
			dbSetOrder(5)
			dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
			oPrint:Say(nLin-08,0700,cNum,oFont15)
			oPrint:Say(nLin-08,1550,SC5->C5_NUM,oFont15)
			oPrint:Say(nLin,0300,"ORCAMENTO  N.o.:                     aprovado conf. PEDIDO N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Else
			oPrint:Say(nLin-08,1400,cNum,oFont15)
			oPrint:Say(nLin,0700,"O  R  C  A  M  E  N  T  O     N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Endif
		nLin+=200
	EndIf

	oPrint:Say (nLin,0020,"Devolução de Mercadorias: Em  nenhuma  hipótese  será  aceita  a  devolução  de  mercadoria sem prévia",oFont10)
	nLin+=50
	oPrint:Say (nLin,0020,"   autorização.",oFont10)
	nLin+=70
	If nLin > 3000
		ImpCabec()
		If TMP->CJ_STATUS == 'B'
			dbSelectArea("SC5")
			dbSetOrder(5)
			dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
			oPrint:Say(nLin-08,0700,cNum,oFont15)
			oPrint:Say(nLin-08,1550,SC5->C5_NUM,oFont15)
			oPrint:Say(nLin,0300,"ORCAMENTO  N.o.:                     aprovado conf. PEDIDO N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Else
			oPrint:Say(nLin-08,1400,cNum,oFont15)
			oPrint:Say(nLin,0700,"O  R  C  A  M  E  N  T  O     N.o.:  ",oFont11)
			oPrint:Say(nLin,2160,DtoC(DtEmissao),oFont11)
			nLin:=nLin+70
			oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
			nLin:=nLin+70
		Endif
		nLin+=200
	EndIf

	oPrint:Say (nLin,0020,"Embalagem: Inclusa no preço. Será utilizada a embalagem mais apropriada em função das características",oFont10)
	nLin+=50
	oPrint:Say (nLin,0020,"   de cada mercadoria.",oFont10)
	If SubStr(cNumEmp,1,2) == "01"
		nLin+=70
		oPrint:Say (nLin,0020,"Confirmacao de Compra: Em caso de aprovacao, favor informar o(s) numero(s) do(s) orcamento(s) aprovados(s).",oFont10)
	Endif
	Set Device to Screen
	Set Printer To
	dbCommitAll()

EndDo

TMP->(DbCloseArea())                                           

oPrint:EndPage() 
oPrint:Setup() 
oPrint:Preview()
oPrint:End()

MS_FLUSH()

Return()


//**********************************
	Static Function RptDetMAS()
//**********************************

Local cAliICM	 := ''
Local nLig1      := 0
Local nColEmp    := 550
Local nLig       := 2900
Local lPagPrint, X

Private cOrc	 := ""					//Parâmetros criados para imprimir... 
Private cPed	 := ""               //o PEDIDO no título do Relatorio caso...
Private cTitulo := ""               //o CJ_STATUS seja 'B' (Efetivado)
Private nColPed := 0					   //
Private nLig    := 0

Private oFont05
Private oFont06
Private oFont07
Private oFont08
Private oFont09
Private oFont10
Private oFont10n
Private oFont11
Private oFont12
Private oFont15
Private oFont20

Private nPag     := 1
Private nItem    := 0
Private oQPrint
Private lFirst   := .T.
Private lInicial := .F.
Private aCausas  := {}
Private aFichas  := {}
Private aEtapas  := {}
Private cFileLogo  := ""
Private cFilOld    := cFilAnt
Private cNomFilial := ""
Private lTMKPMS    := If(GetMv("MV_QTMKPMS",.F.,1) == 1,.F.,.T.)//Integracao do QNC com TMK e PMS: 1-Sem integracao,2-TMKxQNC,3-QNCxPMS,4-TMKxQNCxPMS ³

oFont05	:= TFont():New("Courier New",05,05,,.T.,,,,.T.,.F.)
oFont06	:= TFont():New("Courier New",06,06,,.T.,,,,.T.,.F.)
oFont07	:= TFont():New("Courier New",07,07,,.T.,,,,.T.,.F.)
oFont08	:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
//oFont08 := TFont():New("Courier New",08,08,,.F.,,,,,.F.)
oFont09 := TFont():New("Courier New",09,09,,.F.,,,,,.F.)
oFont10	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont10n:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oFont11 := TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
oFont12 := TFont():New("Courier New",12,12,,.T.,,,,,.F.)
oFont15	:= TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.)
oFont20	:= TFont():New("Courier New",20,20,,.T.,,,,.T.,.F.)
// 5o. Bold
// 9o. Italico
//10o. Underline

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o conteudo do X3_CBOX no array                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cFileLogo  := "LGRL"+SM0->M0_CODIGO
If (FWModeAccess("QI2") == "C")
	cFileLogo += FWCodFil()+".BMP"
Else
	cFileLogo += QI2->QI2_FILIAL+".BMP"
Endif

If !File( cFileLogo )
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
Endif

//³Inicializacao do objeto grafico             ³
oQPrint:= TMSPrinter():New("RFATR026")
oQPrint:SetPortrait()
oQPrint:StartPage()

cOrcam := SCJ->CJ_NUM

dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
//nRegistro := Recno()
//If dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
If dbSeek(SUBS(cNumEmp,1,2))	
	cNomFor  := SM0->M0_NOMECOM
	cEndFor  := SM0->M0_ENDENT
	cBairFor := SM0->M0_BAIRENT
	cCidFor  := SM0->M0_CIDENT
	cEstFor  := SM0->M0_ESTENT
	cCepFor  := SM0->M0_CEPENT
	cTelFor  := SM0->M0_TEL
	cFaxFor  := SM0->M0_FAX
	cInscFor := SM0->M0_INSC
	cCGCFor  := SM0->M0_CGC
EndIf

cQry1 := "SELECT SUM(SCK.CK_PRUNIT*SCK.CK_QTDVEN) AS UNITARIO, SUM(SCK.CK_VALOR) AS VENDA "
cQry1 += "FROM "+RetSqlName("SCJ")+" SCJ "
cQry1 += "INNER JOIN "+RetSqlName("SCK")+" SCK ON SCK.CK_FILIAL = '"+xFilial("SCK")+"' AND SCK.CK_NUM = SCJ.CJ_NUM AND SCK.D_E_L_E_T_ = ' ' "
cQry1 += "WHERE SCK.CK_NUM = '"+SCJ->CJ_NUM+"' " 
cQry1 += "  AND SCK.CK_FILIAL = '"+xFilial("SCK")+"' AND SCJ.D_E_L_E_T_ = ' ' "
cQry1 += "GROUP BY SCJ.CJ_NUM "
cQry1 += "ORDER BY SCJ.CJ_NUM "

TcQuery cQry1 New Alias "TMP1"

dbSelectArea("TMP1")
dbGoTop()

nPrcUnit := TMP1->UNITARIO
nPrcVend := TMP1->VENDA

TMP1->(DbCloseArea())                       

cQuery := "SELECT  SCJ.CJ_NUM,     SCJ.CJ_ORCAM,   SCJ.CJ_EMISSAO, SCJ.CJ_MSVEND,  SCJ.CJ_CONDPAG, SCJ.CJ_FRETE,   SCJ.CJ_CLIENTE, SCJ.CJ_LOJA, "
cQuery += "        SCJ.CJ_STATUS,  SCJ.CJ_VALIDA,  SCJ.CJ_MSPRZEN, SCJ.CJ_MSTRANS, SCJ.CJ_MSCTATO, SCJ.CJ_MSEMAIL, " 
cQuery += "        SCK.CK_NUM,     SCK.CK_ITEM,    SCK.CK_PRODUTO, SCK.CK_ENTREG,  SCK.CK_UM,      SCK.CK_QTDVEN,  SCK.CK_PRCVEN,  SCK.CK_VALOR,  " 
cQuery += "        SCK.CK_VALDESC, SCK.CK_TES,     SCK.CK_PRUNIT,  SCK.CK_VALOR,   SCK.CK_MSMATCL, SCK.CK_MSCL,    SCK.CK_MSDOBRA, SCK.CK_MSPINT, "  
cQuery += "        SCK.CK_MSSOLDA, SCK.CK_MSUSINA, SCK.CK_MSPE," 
cQuery += "        SA1.A1_NOME,    SA1.A1_END,     SA1.A1_BAIRRO,  SA1.A1_CEP,     SA1.A1_MUN,     SA1.A1_EST,     SA1.A1_CGC,     SA1.A1_INSCR,  "
//Ivandro Santos - 19/07/17
////Ticket#2017071837000096 — ADICIONAR NO ORÇAMENTO INFORMAÇÕES DE ICMS REDUZIDO - MASIPACK E FABRIMA
//Ivandro Santos - 26/10/16
//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
//cQuery += "        SA1.A1_TEL,     SA1.A1_FAX,     SA1.A1_CONTATO, SA1.A1_EMAIL,   " 
cQuery += "        SA1.A1_TEL,     SA1.A1_FAX,     SA1.A1_CONTATO, SA1.A1_EMAIL,   SA1.A1_TIPO,   	SB1.B1_GRTRIB, " 
//Ivandro Santos - 04/04/17 - Início alteração
//Ticket#2017040437000055 — RELATÓRIO DE ALTERAÇÃO DE ESTRUTURA
//cQuery += "        CASE WHEN RTRIM(LTRIM(SB1.B1_DESCP)) = '' THEN SB1.B1_DESC ELSE SB1.B1_DESCP END 'B1_DESC',   " 
cQuery += "        CASE WHEN RTRIM(LTRIM(SB5.B5_CEME)) = '' THEN SB1.B1_DESC ELSE SB5.B5_CEME END 'B1_DESC',   " 
//Ticket#2017040437000055 — Fim da alteração
cQuery += "        SB1.B1_POSIPI,  SB1.B1_GRUPO,   SB1.B1_PICM,    SB1.B1_IPI, 		ISNULL(SYD.YD_BICMS,0) [YD_BICMS],	SA3.A3_NOME,    SA3.A3_EMAIL,   SE4.E4_DESCRI   " 
//Ticket#2016102137000031 — Fim da alteração
cQuery += "FROM "+RetSqlName("SCJ")+" SCJ " 
cQuery += "INNER JOIN "+RetSqlName("SCK")+" SCK ON SCK.CK_FILIAL = '"+xFilial("SCK")+"' AND SCK.CK_NUM = SCJ.CJ_NUM AND SCK.D_E_L_E_T_ = ' ' " 
cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SCJ.CJ_CLIENTE AND SA1.A1_LOJA = SCJ.CJ_LOJA AND SA1.D_E_L_E_T_ = ' ' " 
cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SCK.CK_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " 
cQuery += "LEFT JOIN  "+RetSqlName("SYD")+" SYD ON SYD.YD_FILIAL = '"+xFilial("SYD")+"' AND SB1.B1_POSIPI = SYD.YD_TEC AND SYD.D_E_L_E_T_ = ' ' " 
//Ivandro Santos - 04/04/17 - início da alteração
//Ticket#2017040437000055 — RELATÓRIO DE ALTERAÇÃO DE ESTRUTURA 
////Ticket#2017071837000096 — Fim da alteração
cQuery += "LEFT  JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' AND SB5.B5_COD = SCK.CK_PRODUTO AND SB5.D_E_L_E_T_ = ' ' " 
//Ticket#2017040437000055 — Fim da alteração
cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SCJ.CJ_MSVEND AND SA3.D_E_L_E_T_ = ' ' " 
cQuery += "INNER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' AND SE4.E4_CODIGO = SCJ.CJ_CONDPAG AND SE4.D_E_L_E_T_ = ' '  " 
cQuery += "WHERE SCJ.CJ_FILIAL = '"+xFilial("SCJ")+"' AND SCJ.D_E_L_E_T_ = ' ' "
cQuery += "  AND SCJ.CJ_NUM = '"+cOrcam+"' " 
cQuery += "ORDER BY SCJ.CJ_NUM, SCK.CK_MSITEM " 

TcQuery cQuery New Alias "TMP"

TcSetField("TMP","CJ_EMISSAO","D",08,00)
TcSetField("TMP","CK_ENTREG","D",08,00)
TcSetField("TMP","CJ_VALIDA","D",08,00)

dbSelectArea("SCJ")
dbSetOrder(1)
//cPedido := SCJ->CJ_NUM   
cMSNotas  := SCJ->CJ_MSNOTAS

dbSelectArea("SC5")
//dbSetOrder(1)
If dbSeek(xFilial("SC5")+TMP->CJ_ORCAM)
	cPedido := SC5->C5_NUM
Else
    cPedido := " "
EndIf

dbSelectArea("SA4")
dbSetOrder(1)
If dbSeek(xFilial("SA4")+TMP->CJ_MSTRANS )
	cTransp := SA4->A4_NOME
Else
    cTransp := " "
EndIf

cCondi    := TMP->CJ_CONDPAG
cDescCond := TMP->E4_DESCRI
cVendedor := TMP->CJ_MSVEND                 
cCotacao  := TMP->CJ_ORCAM
cNomVend  := TMP->A3_NOME
cEmailVd  := TMP->A3_EMAIL
cNomCli   := TMP->A1_NOME
cEndCli   := TMP->A1_END
cBairCli  := TMP->A1_BAIRRO
cCepCli   := TMP->A1_CEP
cCidCli   := TMP->A1_MUN
cEstCli   := TMP->A1_EST
cCGCCli   := TMP->A1_CGC
cInscCli  := TMP->A1_INSCR
cTelCli   := TMP->A1_TEL
cFaxCli   := TMP->A1_FAX
cContCli  := TMP->CJ_MSCTATO
cEmailCli := TMP->CJ_MSEMAIL
DtValida  := TMP->CJ_VALIDA
DtEmissao := TMP->CJ_EMISSAO
DtEntrega := TMP->CK_ENTREG
cEntrega  := TMP->CJ_MSPRZEN
nFrete    := TMP->CJ_FRETE

If !lInicial
	lInicial := .T.
	oQPrint:= TMSPrinter():New( Titulo )
	oQPrint:SetPortrait()
	nLig := 2900
Endif

lFirst := .T.

ImpCabec1()

ImpItem1()	
nTotGer := 0
TMP->(DbGoTop())
Do While !TMP->(EOF())      
	//Ivandro Santos - 
	//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
	aRefImp := MAFISRELIMP("MT100",{"SCK"})
	MaFisIni(TMP->CJ_CLIENTE,;		// 1-Codigo Cliente/Fornecedor
		TMP->CJ_LOJA,;				// 2-Loja do Cliente/Fornecedor
		"C",;						// 3-C:Cliente , F:Fornecedor
		"N",;						// 4-Tipo da NF
		TMP->A1_TIPO,;	    		// 5-Tipo do Cliente/Fornecedor
			aRefImp,;				// 6-Relacao de Impostos que suportados no arquivo
			,;						// 7-Tipo de complemento
			,;						// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;					// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MTR700")				// 10-Nome da rotina que esta utilizando a funcao

	//Victor Dessunte - Ticket#2016102837000054
	//ANTIGO - (TMP->CK_PRCVEN+TMP->CK_VALDESC)
	//NOVO   - (TMP->CK_VALOR+TMP->CK_VALDESC)

	MaFisAdd(TMP->CK_PRODUTO,; 	  	  // 1-Codigo do Produto ( Obrigatorio )
		TMP->CK_TES,;			  // 2-Codigo do TES ( Opcional )
		TMP->CK_QTDVEN,;		  // 3-Quantidade ( Obrigatorio )
		TMP->CK_PRCVEN,;		  // 4-Preco Unitario ( Obrigatorio )
		TMP->CK_VALDESC,;       			      // 5-Valor do Desconto ( Opcional )
		,;		                  // 6-Numero da NF Original ( Devolucao/Benef )
		,;		                  // 7-Serie da NF Original ( Devolucao/Benef )
		,;			          		// 8-RecNo da NF Original no arq SD1/SD2
		0,;							  		// 9-Valor do Frete do Item ( Opcional )
		0,;							  		// 10-Valor da Despesa do item ( Opcional )
		0,;            				  		// 11-Valor do Seguro do item ( Opcional )
		0,;							  		// 12-Valor do Frete Autonomo ( Opcional )
		(TMP->CK_VALOR+TMP->CK_VALDESC),;	// 13-Valor da Mercadoria ( Obrigatorio )
		0,;							  		// 14-Valor da Embalagem ( Opiconal )
		0,;		     				 		 // 15-RecNo do SB1
		0) 							 		 // 16-RecNo do SF4
	nVlrPFrt := MaFisRet(,"NF_FRETE")
	nValIpi := MaFisRet(1,"IT_VALIPI")
	nTotItem := MaFisRet(1,"IT_TOTAL")
	nValSol := MaFisRet(1,"IT_VALSOL") // obtém o valor total do item calculado pela matxfis com a incidência dos impostos 
	MaFisEnd() // FINALIZA A OPERAÇÃO E LIMPA TODOS OS ARRAYS INTERNOS DA MATXFIS	
	nTotIpi += nValIpi
	nTotGer += nTotItem
	//Fecha a query antes de validar se o item tem grupo tributario
	If Select("TMF7") > 0 
		DbSelectArea("TMF7")
		DbCloseArea()
	EndIf

	IF !EMPTY(TMP->B1_GRTRIB) .And. Alltrim(TMP->B1_GRTRIB) $ "001_002_007" //.AND. TMP->YD_BICMS = "S"
		_cQryF7 := "Select F7_BASEICM, F7_ALIQINT From "+RetSQLName("SF7")+" Where F7_GRTRIB = '"+TMP->B1_GRTRIB+"' 
		_cQryF7 += " And F7_EST = '"+TMP->A1_EST+"' And F7_FILIAL = '"+xFilial("SF7")+"' And D_E_L_E_T_ = '' "
		
		TcQuery _cQryF7 New Alias "TMF7"

		TcSetField("TMF7","F7_BASEICM","N",05,02)
		TcSetField("TMF7","F7_ALIQINT","N",05,02)
		dbSelectArea("TMF7")
		TMF7->(DbGoTop())
		nPerRed := TMF7->F7_BASEICM
		nIcm    := TMF7->F7_ALIQINT
	Else
		nPerRed := 0
	Endif
	//Ticket#2016102137000031 — Fim da alteração
	////Ticket#2017071837000096 — Fim da alteração
	nItem += 1
	If nLin > 2070 
		oQPrint:EndPage()
		nPag++
		ImpCabec1()
		ImpItem1()
		lFirst := .F.
	EndIf 
	nLin2 := nLin
	DtEntrega := Date()
   	DEntrega  := TMP->CK_ENTREG
    
	oQPrint:Say(nLin,0032,TMP->CK_ITEM,oFont08)           		            //Item
	
	////Ticket#2017071837000096 — ADICIONAR NO ORÇAMENTO INFORMAÇÕES DE ICMS REDUZIDO - MASIPACK E FABRIMA
   	If SB1->(DbSeek(xFilial("SB1")+TMP->CK_PRODUTO))    
   	
		oQPrint:Say(nLin,0080,SUBSTR(TMP->B1_DESC,1,25),oFont08)            //Descrição    
		
		If !EMPTY(SUBSTR(TMP->B1_DESC,25)) 
			nLin2 += 40
			oQPrint:Say(nLin2,0080,SUBSTR(TMP->B1_DESC,26,25),oFont08)      //Descrição 
		EndIf 
		If !EMPTY(SUBSTR(TMP->B1_DESC,50)) 
			nLin2 += 40
			oQPrint:Say(nLin2,0080,SUBSTR(TMP->B1_DESC,51,25),oFont08)      //Descrição 
		EndIf 
		If !EMPTY(SUBSTR(TMP->B1_DESC,75)) 
			nLin2 += 40
			oQPrint:Say(nLin2,0080,SUBSTR(TMP->B1_DESC,76,25),oFont08)      //Descrição 
		EndIf		
	   
	EndIf   
	//Ivandro Santos - 26/10/16
	//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
	oQPrint:Say(nLin,0540,TMP->CK_PRODUTO,oFont08)  //oQPrint:Say(nLin,0690,TMP->CK_PRODUTO,oFont08)           		          //Codigo
         		          //Codigo    
	If SB1->(DbSeek(xFilial("SB1")+TMP->CK_PRODUTO))
		oQPrint:Say(nLin,0780,TMP->B1_POSIPI,oFont08)  //oQPrint:Say(nLin,0910,TMP->B1_POSIPI,oFont07)                                   //Classif.Fiscal
    EndIf
	oQPrint:Say(nLin,0940,TMP->CK_UM,oFont08)  	//oQPrint:Say(nLin,1060,TMP->CK_UM,oFont08)  //oQPrint:Say(nLin,1010,TMP->CK_UM,oFont07) //U.M.
	oQPrint:Say(nLin,1005,Transform(TMP->CK_QTDVEN,"@E 9,999.99"),oFont08) 	//oQPrint:Say(nLin,1100,Transform(TMP->CK_QTDVEN,"@E 9,999.99"),oFont08) //oQPrint:Say(nLin,1150,Transform(TMP->CK_QTDVEN,"@E 9,999.99"),oFont07)             //Qtde
	oQPrint:Say(nLin,1205,Transform(TMP->CK_PRCVEN,"@E 999,999.99"),oFont08) //	oQPrint:Say(nLin,1275,Transform(TMP->CK_PRCVEN,"@E 999,999.99"),oFont08) //oQPrint:Say(nLin,1360,Transform(TMP->CK_PRCVEN,"@E 999,999.99"),oFont07)           //V.Unitario
	oQPrint:Say(nLin,1385,Transform(TMP->CK_VALOR,"@E 9,999,999.99"),oFont08) //	oQPrint:Say(nLin,1490,Transform(TMP->CK_VALOR,"@E 9,999,999.99"),oFont08) //oQPrint:Say(nLin,1580,Transform(TMP->CK_VALOR,"@E 9,999,999.99"),oFont07)          //Vlr.Parcial
    nTotal  := nTotal + TMP->CK_VALOR
    //Ticket#2016102137000031 — Fim da alteração
	nTotDesc:= nTotDesc + ((TMP->CK_QTDVEN*TMP->CK_PRUNIT)-TMP->CK_VALOR)
//	nTotDesc:= nTotDesc + (TMP->CK_PRUNIT-TMP->CK_PRCVEN)
//   nTotDesc:= nTotDesc + TMP->CK_VALDESC  
  
	//******************************** IPI / ICMS ******************************************* 
	nIPI := 0
	nICM := 0
   _cGrupo := ""
	If SubStr(cNumEmp,1,2) <> "05"
      SB1->(ORDSETFOCUS(1))
	   If SB1->(dbSeek(xFilial("SB1") + Alltrim(TMP->CK_PRODUTO)))
	      _cGrupo := Alltrim(TMP->B1_GRUPO)   
   	Else
	      Alert("Produto não cadastrado: " + TMP->CK_PRODUTO)      
 	   EndIf     
  	EndIf   

	SF4->(ORDSETFOCUS(1))
	If SF4->(dbSeek(xFILIAL("SF4") + Alltrim(TMP->CK_TES)))
	   If SF4->F4_ICM == "S" 
	    	If cEstCli == "SP" .And. Select("TMF7") > 0
				nICM := IIF( TMF7->F7_ALIQINT > 0, TMF7->F7_ALIQINT, SB1->B1_PICM )
	    	Else  
				nICM := SB1->B1_PICM
					If nICM == 0
						cAliICM := GetMV('MS_ALINICM')
						If !Empty(cAliICM)
							nICM := Val(Substr(cAliICM,At(cEstCli,cAliICM)+2,2))
						Endif
					EndIf
			
			EndIf   
   	EndIf
   	If SF4->F4_IPI == "S"
			nIPI := SB1->B1_IPI
		Endif
	Else
		Alert("TES não cadastrada: " + TMP->CK_TES)
	EndIf

	//***************************************************************************************
  	//Ivandro Santos - 26/10/16
  	//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
  	oQPrint:Say(nLin,1630,Transform(nIPI,"@E 99.99"),oFont08) //  	oQPrint:Say(nLin,1750,Transform(nIPI,"@E 99.99"),oFont08) //oQPrint:Say(nLin,1860,Transform(nIPI,"@E 99.99"),oFont07)           			   	//% IPI
    /*
	If SF4->F4_IPI == "S"
		  
		If TMP->CK_PRUNIT > TMP->CK_PRCVEN
			nTotItem := (TMP->CK_PRUNIT * TMP->CK_QTDVEN)
			nVlrPFrt := (( nTotItem / nPrcUnit) * TMP->CJ_FRETE)
			nValIPI := (nTotItem + nVlrPFrt) * nIPI/100
		Else
			nTotItem := TMP->CK_VALOR
			nVlrPFrt := ((nTotItem / nPrcVend) * TMP->CJ_FRETE)
			nValIPI := (nTotItem + nVlrPFrt) * nIPI/100
		EndIf
		
		//nTotItem := TMP->CK_VALOR                                         
		//nVlrPFrt := ((nTotItem / nPrcVend) * TMP->CJ_FRETE)
		//nValIPI := (nTotItem + nVlrPFrt) * nIPI/100
	
		nTotIpi := nTotIpi + nValIpi
	Else
		nValIPI := 0
	Endif */
	//Ticket#2016102137000031 — Fim da alteração	 
   nPE := TMP->CK_MSPE
	
	//VICTOR DESSUNTE - 09/09/2016
	//INICIO - TICKET: 2016090937000075
	//	oQPrint:Say(nLin,1870,Transform(nValIpi,"@E 999,999.99"),oFont08)  //oQPrint:Say(nLin,1995,Transform(nValIpi,"@E 9,999.99"),oFont07)                  	//Vlr.IPI
	//FIM - TICKET: 2016090937000075
	//Ivandro Santos - 26/10/16
	//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
	oQPrint:Say(nLin,1720,Transform(nValIpi,"@E 999,999.99"),oFont08)  //oQPrint:Say(nLin,1870,Transform(nValIpi,"@E 999,999.99"),oFont08)  //oQPrint:Say(nLin,1995,Transform(nValIpi,"@E 9,999.99"),oFont07)                  	//Vlr.IPI
	oQPrint:Say(nLin,1940,Transform(nICM,"@E 99.99"),oFont08) //	oQPrint:Say(nLin,2130,Transform(nICM,"@E 99.99"),oFont08) //oQPrint:Say(nLin,2185,Transform(nICM,"@E 99.99"),oFont07)			               	//% Icms
	oQPrint:Say(nLin,2070,Transform(IIF(nPerRed>0,nPerRed,0),"@E 99.99"),oFont08) 
	oQPrint:Say(nLin,2190,Transform(nValSol,"@E 99.99"),oFont08) //oQPrint:Say(nLin,2185,Transform(nICM,"@E 99.99"),oFont07)			               	//% Icms
//   oQPrint:Say(nLin,2185,Transform(nPE,"@E 999"),oFont08)
	//Ticket#2016102137000031 — Fim da alteração
	////Ticket#2017071837000096 — Fim da alteração
	_cOperacao := ""
	If _cGrupo == "0090"
	   _lTerc  := .T.
		If TMP->CK_MSMATCLI == "S"
			_cOperacao := "MP do Cliente"
		Else
			_cOperacao := "Nossa MP"
		EndIf
		If TMP->CK_MSCL == "S"
			_cOperacao := _cOperacao + ", Corte Laser"
		EndIf
		If TMP->CK_MSDOBRA == "S"
			_cOperacao := _cOperacao + ", Dobra"
		EndIf
		If TMP->CK_MSPINT == "S"
			_cOperacao := _cOperacao + ", Pintura"
		EndIf
		If TMP->CK_MSSOLDA == "S"
			_cOperacao := _cOperacao + ", Solda"
		EndIf
		If TMP->CK_MSUSINA == "S"
			_cOperacao := _cOperacao + ", Usinagem"
		EndIf
		nLin+=30   				          
		oQPrint:Say(nLin,0430,_cOperacao,oFont06)
	EndIf
   
	dbSelectArea("SCL")
	dbSetOrder(1)
	dbSeek(xFilial("SCL")+TMP->CK_NUM+TMP->CK_ITEM,.T.)

	If (SCL->CL_NUM == TMP->CK_NUM) .And. (SCL->CL_ITEMORC == TMP->CK_ITEM)

		nQtd := SCL->CL_QUANT*TMP->CK_QTDVEN

		oQPrint:Say(nLin,0020,"* ----->",oFont06)                        
		oQPrint:Say(nLin,0100,SCL->CL_PRODUTO,oFont06)             				          
		oQPrint:Say(nLin,0250,SubStr(SCL->CL_DESCRI,1,30),oFont08)                        			
		oQPrint:Say(nLin,0350,Transform(nQtd,"@E 9,999.99"),oFont08)                    			

	EndIf

	dbSelectArea("SA7")
	dbSetOrder(1)
	IF dbSeek(xFilial("SA7")+TMP->CJ_CLIENTE+TMP->CJ_LOJA+TMP->CK_PRODUTO) 
		cProdCli := SA7->A7_CODCLI
	ENDIF	
    nLin := nLin2
	If !Empty(Alltrim(cProdCli))
 		nLin := nLin + 60
		oQPrint:Say(nLin,080,"Cod.Cliente: "+SUBSTR(cProdCli,1,15),oFont08)      //Cod.Produto Cliente
	EndIf
	
	nLin := nLin + 50
	If nLin > 3000
		oQPrint:EndPage()
		//lFirst := .T.
		nPag++
   	ImpCabec1()
   	ImpItem1()
 	EndIf   

	If nLin > 2070  //.and. nPag = 1
		nLin := 2130
		oQPrint:Say(nLin,0040,"Continuacao...",oFont08)
		nLin +=120 //2550
		nLin+=70   //2750 normal - 3200 terceiro
		oQPrint:Say(nLin,0020,Alltrim(cNomVend)+" - VENDAS",oFont11)
		
		nLin+=100
		oQPrint:Say(nLin,0020,"O B S E R V A C O E S: ",oFont10)
		
		nLin += 80
		oQPrint:Say (nLin,0020,"VALIDADE DO ORCAMENTO: "+DTOC(DtValida), oFont10) 
		nLin += 60
		oQPrint:Say (nLin,0020,"PRAZO DE ENTREGA: "+cEntrega, oFont10)   
		nLin += 60
		
		//cNotas := Alltrim(TMP->CJ_MSNOTAS) 
		cNotas := Alltrim(cMSNotas) 
		If !Empty(cNotas)
			nLin+=60
			For X := 1 TO MLCOUNT(cNotas,150)
			If nLin > 3000
				oQPrint:EndPage()
				lFirst := .T.
				nPag++
				ImpCabec1()
		 	EndIf   
		   	oQPrint:Say (nLin,0020, MEMOLINE(cNotas,150,X), oFont08)   
			nLin += 60
		    Next
		EndIf
	EndIf

	TMP->(dbSkip())

EndDo			

nLin := 2130
oQPrint:Say(nLin,0040,"Total Mercad.: "+Transform(nTotal,"@E 999,999,999.99"),oFont07)
oQPrint:Say(nLin,0550,"Valor do IPI.: "+Transform(nTotIpi,"@E 999,999.99"),oFont07)
//Ivandro Santos - 26/10/16
//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
//nTotGer := nTotal+nTotIpi+nFrete                             
//Ticket#2016102137000031 — Fim da alteração
oQPrint:Say(nLin,1450,"Total.: "+Transform(nTotGer+nFrete,"@E 999,999,999.99"),oFont07)
oQPrint:Say(nLin,1800,"Descontos aplicados.: "+Transform(nTotDesc,"@E 999,999.99"),oFont07)
oQPrint:Say(nLin,1000,"Valor do Frete.: "+Transform(nFrete,"@E 999,999.99"),oFont07)

nLin += 120 //2550

nLin+=70   //2750 normal - 3200 terceiro
oQPrint:Say(nLin,0020,Alltrim(cNomVend)+" - VENDAS",oFont11)	

ImpVenc1()

Set Device to Screen
Set Printer To
dbCommitAll()

DbSelectArea("SCJ")
DbSetOrder(1)
DbSelectArea("SC5")
DbSetOrder(1)
DbSelectArea("SA4")
DbSetOrder(1)
DbSelectArea("SCL")
DbSetOrder(1)
DbSelectArea("SA7")
DbSetOrder(1)

oQPrint:EndPage() 
oQPrint:Setup() 
oQPrint:Preview()
oQPrint:End()

TMP->(DbCloseArea())                                           

MS_FLUSH()

Return()

//**************************************************
	Static Function ImpCabec1() //Orçamento MASIPACK
//**************************************************

lPagPrint := .T.
oQPrint:StartPage()

oQPrint:SayBitmap(35,100,cFileLogo,220,170)
oQPrint:Say(40,2100,"Pag.:"+Transform(nPag,"@E 99"),oFont11)

oQPrint:Box(230,  30,850,1180 )
oQPrint:Box(230,1200,950,2300 )
oQPrint:Line(850,1200,850,2300)

oQPrint:Line(300,  30, 300, 1180 )
oQPrint:Line(300,1200, 300, 2300 )

oQPrint:Say(235, 300,   "CLIENTE",oFont15 )
oQPrint:Say(235,1550,"FORNECEDOR",oFont15 )

oQPrint:Say(320,50,cNomCli,oFont12)
oQPrint:Say(320,1220,cNomFor,oFont12)

nLin := 400
oQPrint:Say(nLin,50,Alltrim(cEndCli)+" - "+Alltrim(cBairCli),oFont09)
oQPrint:Say(nLin,1220,Alltrim(cEndFor)+" - "+Alltrim(cBairFor),oFont09)

nLin +=50  //350
oQPrint:Say(nLin,50,+"Cidade: "+Alltrim(cCidCli)+" - "+Alltrim(cEstCli)+" - CEP: "+Transform(cCepCli,"@R 99999-999"),oFont09)
oQPrint:Say(nLin,1220,+"Cidade: "+Alltrim(cCidFor)+" - "+Alltrim(cEstFor)+" - CEP: "+Transform(cCepFor,"@R 99999-999"),oFont09)

nLin += 50 //400
oQPrint:Say(nLin,50,"Tel: "+Alltrim(cTelCli)+"  Fax: "+Alltrim(cFaxCli),oFont09)
If SubStr(cNumEmp,1,2) == "01"
   oQPrint:Say(nLin,1220,"Tel:(11)3246-3666,4178-8099 R.309",oFont09)
Else   
   oQPrint:Say(nLin,1220,"Tel: "+Alltrim(cTelFor)+"  Fax: "+Alltrim(cFaxFor),oFont09)
EndIf 

nLin +=50  //450
oQPrint:Say(nLin,1220,"Fax:(11)3246-3666,4178-8099 R.352",oFont09)

nLin +=50  //500
If !Empty(cInscCli)
   oQPrint:Say(nLin,50,"Inscr: "+cInscCli+"    CNPJ: "+SubStr(cCGCCli,1,2)+"."+SubStr(cCGCCli,3,3)+"."+SubStr(cCGCCli,6,3)+"/"+SubStr(cCGCCli,9,4)+"-"+SubStr(cCGCCli,13,2),oFont09)
Else
   oQPrint:Say(nLin,50,"CNPJ: "+SubStr(cCGCCli,1,2)+"."+SubStr(cCGCCli,3,3)+"."+SubStr(cCGCCli,6,3)+"/"+SubStr(cCGCCli,9,4)+"-"+SubStr(cCGCCli,13,2),oFont09)
EndIf
  
If !Empty(cInscFor)
   oQPrint:Say(nLin,1220,"Inscr: "+cInscFor+"      CNPJ: "+SubStr(cCGCFor,1,2)+"."+SubStr(cCGCFor,3,3)+"."+SubStr(cCGCFor,6,3)+"/"+SubStr(cCGCFor,9,4)+"-"+SubStr(cCGCFor,13,2),oFont09)
Else
   oQPrint:Say(nLin,1220,"CNPJ: "+SubStr(cCGCFor,1,2)+"."+SubStr(cCGCFor,3,3)+"."+SubStr(cCGCFor,6,3)+"/"+SubStr(cCGCFor,9,4)+"-"+SubStr(cCGCFor,13,2),oFont09)
EndIf

nLin +=100 //600

If cNomVend <> " "
	If cCotacao <> " "
		oQPrint:Say(nLin,   50,"Contato: "+Alltrim(cContCli)+" - S/Pedido: "+Alltrim(cCotacao),oFont09)
		oQPrint:Say(nLin,1220,"Contato: "+Alltrim(cNomVend),oFont09)
   	Else
		oQPrint:Say(nLin,   50,"Contato: "+Alltrim(cContCli),oFont09)
		oQPrint:Say(nLin,1220,"Contato: "+Alltrim(cNomVend),oFont09)
	EndIf
Else
	If cCotacao <> " "
		oQPrint:Say(nLin,  50,"Contato: "+Alltrim(cContCli)+" - S/Pedido: "+Alltrim(cCotacao),oFont09)
		oQPrint:Say(nLin,1220,"Contato: ",oFont09)
    Else
		oQPrint:Say(nLin,  50,"Contato: "+Alltrim(cContCli),oFont09)
		oQPrint:Say(nLin,1220,"Contato: ",oFont09)
	EndIf
EndIf

nLin +=50  //650
If !Empty(cEmailCli)
	oQPrint:Say(nLin,50,"E-mail: "+alltrim(cEmailCli),oFont09) 
Else
	oQPrint:Say(nLin,50,"E-mail: ",oFont09) 
EndIf       

If !Empty(cEmailVd)
	oQPrint:Say(nLin,1220,"E-mail: "+alltrim(cEmailVd),oFont09)
Else
	oQPrint:Say(nLin,1420,"E-mail: acessorios@masipack.com.br",oFont09)
EndIf

dEmissao := (TMP->CJ_EMISSAO)
nLin +=50   //700

oQPrint:Say(nLin,1220,"Cond.Pagto: "+cDescCond+"  Transp: "+cTransp,oFont10)

//oQPrint:Say(nLin,1220,"Data: "+DTOC(dEmissao)+"  Cond.Pagto: "+TMP->E4_DESCRI+"  Via de Transp: "+cTransp,oFont10)
//oQPrint:Say(nLin,1650,"Cond.Pagto: "+TMP->E4_DESCRI,oFont10)
//oQPrint:Say(nLin,1220,"Via de Transp: ",oFont11)
//oQPrint:Say(nLin,1650,cTransp,oFont11)

nLin += 60  //760
If TMP->CJ_STATUS == 'B'
	dbSelectArea("SC5")                                                   
	
	dbSetOrder(5)
	dbSeek(xFilial("SC5")+Alltrim(TMP->CJ_ORCAM))
	oQPrint:Say(nLin,1220,"Orcamento: "+Alltrim(cOrcam)+" Data: "+DTOC(DtEmissao)+"  Pedido: "+Alltrim(SC5->C5_NUM),oFont15)
Else
	oQPrint:Say(nLin,1220,"Orcamento: "+Alltrim(cOrcam)+" Data: "+DTOC(DtEmissao),oFont15)
Endif	

If nLin > 2070
	ImpItem1()
	nItem := 1
Else
	nLin := 990
EndIf

Return

/*************************************************/
Static Function ImpItem1()  //Orçamento MASIPACK
/*************************************************/

oQPrint:Box(970,30,2200,2300 ) //Box(920,30,2500,2300 )
oQPrint:Line(1020,30,1020,2300 ) //Line(970,30,970,2300 )
oQPrint:Line(2100,30,2100,2300 ) //Line(2410,30,2410,2300 )
    
nLin := 990
oQPrint:Say(nLin,0032,"IT",oFont07)
oQPrint:Say(nLin,0080,"Descricao",oFont07)
//Ivandro Santos - 19/07/17
////Ticket#2017071837000096 — ADICIONAR NO ORÇAMENTO INFORMAÇÕES DE ICMS REDUZIDO - MASIPACK E FABRIMA
//Ivandro Santos - 26/10/16
//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
oQPrint:Say(nLin,0540,"Codigo",oFont07) 	//oQPrint:Say(nLin,0690,"Codigo",oFont07)
oQPrint:Say(nLin,0780,"NCM",oFont07) 		//oQPrint:Say(nLin,0940,"NCM",oFont07)
oQPrint:Say(nLin,0940,"UM",oFont07)			//oQPrint:Say(nLin,1090,"UM",oFont07)
oQPrint:Say(nLin,1055,"Qtde",oFont07)		//oQPrint:Say(nLin,1185,"Qtde",oFont07)
oQPrint:Say(nLin,1205,"  Vlr.Unit.",oFont07)//oQPrint:Say(nLin,1285,"  Vlr.Unit.",oFont07)
oQPrint:Say(nLin,1425,"  Vlr.Merc.",oFont07)//oQPrint:Say(nLin,1535,"  Vlr.Merc.",oFont07)
oQPrint:Say(nLin,1630," %IPI",oFont07)		//oQPrint:Say(nLin,1750," %IPI",oFont07)
oQPrint:Say(nLin,1780,"Vlr.IPI",oFont07)	//oQPrint:Say(nLin,1890,"Vlr.IPI",oFont07)
oQPrint:Say(nLin,1910," %ICMS",oFont07)		//oQPrint:Say(nLin,2120," %ICMS",oFont07)
oQPrint:Say(nLin,2060,"Redu ICMS",oFont07)		//oQPrint:Say(nLin,2120," %ICMS",oFont07)
oQPrint:Say(nLin,2170,"   ST",oFont07)                         
//Ticket#2016102137000031 — Fim da alteração
//oQPrint:Say(nLin,2145,"Prazo/Dias",oFont07)
////Ticket#2017071837000096 — Fim da alteração

nLin += 60

Return

/**************************************************/
Static Function ImpVenc1()  //Orçamento MASIPACK
/**************************************************/

Local X
If _lTerc
   nLin+=60   //2740
   
	If nLin > 3000
		oQPrint:EndPage()
		lFirst := .T.
		nPag++
		ImpCabec1()
	EndIf   
   
   oQPrint:Say(nLin,0020,"* A matéria-prima, quando fornecida pelo cliente, deverá ter no máximo 2m X 4m;",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"* No caso de chapa em aço carbono, quando fornecida pelo cliente, deverá ser",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"  decapada e oleada;",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"* Furos escareados, roscados, laterais chanfradas ou com inclinações angulares",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"  no sentido da chapa, não são executados pelo processo de corte a laser;",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"* Os diâmetros dos furos devem ter no mínimo a medida da espessura da chapa",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"  para que possam ser executados, caso contrário, os mesmos só serão marcados;",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"* Tolerância de corte: +/- 0,1mm. As tolerâncias não atendidas pelo processo",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"  a laser serão cortadas com sobre-metal;",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"* O cliente deverá enviar o desenho em padrão DXF, desenvolvidos quando houver",oFont09)
   nLin+=30
   oQPrint:Say(nLin,0020,"  dobra, caso contrário, será cobrado o desenvolvimento do desenho.",oFont09)
   nLin+=60
   oQPrint:Say(nLin,0020,"* Não aceitaremos pedidos com valor inferior à R$ 500,00 (Quinhentos reais)",oFont09) 
   nLin+=30
EndIf   
    
nLin+=100
oQPrint:Say(nLin,0020,"O B S E R V A C O E S: ",oFont10)
//Ivandro Santos - 26/10/16
//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
oQPrint:Say(nLin,0850,"*",oFont12)
nLin-=8
oQPrint:Say(nLin,0870,Replicate("-",52),oFont12)
nLin+=8
oQPrint:Say(nLin,2220,"*",oFont12)
nLin+=50
oQPrint:Say(nLin,0850,"|",oFont12)
oQPrint:Say(nLin,0870,"  D E F I N I R   T R A N S P O R T A D O R   N A",oFont12)
oQPrint:Say(nLin,2220,"|" ,oFont12)
nLin+=50             
oQPrint:Say(nLin,0850,"|",oFont12)
oQPrint:Say(nLin,0870,"    C O N F I R M A Ç Ã O   D O   P E D I D O",oFont12)
oQPrint:Say(nLin,2220,"|",oFont12)
nLin+=50
oQPrint:Say(nLin,0850,"*",oFont12)
oQPrint:Say(nLin,0870,Replicate("-",52),oFont12)
oQPrint:Say(nLin,2220,"*",oFont12)
nLin -= 70                     
oQPrint:Say (nLin,0020,"VALIDADE DO ORCAMENTO: "+DTOC(DtValida), oFont10) 
nLin+=60
oQPrint:Say (nLin,0020,"PRAZO DE ENTREGA: "+cEntrega, oFont10)
//nLin+=80
//Ticket#2016102137000031 — Fim da alteração
//cNotas := Alltrim(TMP->CJ_MSNOTAS) 
cNotas := Alltrim(cMSNotas) 
If !Empty(cNotas)
	nLin+=60
	For X := 1 TO MLCOUNT(cNotas,150)
	If nLin > 3000
		oQPrint:EndPage()
		lFirst := .T.
		nPag++
		ImpCabec1()
 	EndIf   
   	oQPrint:Say (nLin,0020, MEMOLINE(cNotas,150,X), oFont08)   
	nLin += 60
    Next
EndIf
 
If nLin > 3000
	oQPrint:EndPage()
	lFirst := .T.
	nPag++
	ImpCabec1()
    
	nLin := 1100 
	//Ivandro Santos - 26/10/16
	//Ticket#2016102137000031 — INCLUSÃO DE INFORMAÇÃO NO ORÇAMENTO
	oQPrint:Say (nLin,0020,"Sr Cliente, Favor confirmar as Classificacoes Fiscais para não ocorrer divergências na Emissão da Nota Fiscal.", oFont10)  
	nLin+=80
	//Ivandro Santos - 28/04/17 - Início da alteração
	//Ticket#2017042837000064 — Alteração de Valor de Faturamento Mínimo nos Orçamentos de Peças
	oQPrint:Say (nLin,0020,"Valor mínimo para faturamento: R$ 300,00",oFont10)
	//oPrint:Say (nLin,0020,"Valor mínimo para faturamento: R$ 100,00",oFont10)
	//Ticket#2017042837000064 — Fim da alteração
	nLin+=70 
	//oQPrint:Say (nLin,0020,"Expedição: Solicitamos indicar a Transportadora de sua preferência. Na ausência desta a Nota Fiscal será emitida e faremos contato com o",oFont08) 
	//nLin+=70 
	//oQPrint:Say (nLin,0020,"comprador para a coleta do material",oFont08)
	//nLin+=70 
	oQPrint:Say (nLin,0020,"Prazo de entrega:  Os  itens  com  prazo  de  entrega  futuro  eventualmente poderão ser antecipados, ",oFont10)  
	nLin+=70 
	oQPrint:Say (nLin,0020,"dependendo apenas de nossa capacidade de produção no período de vigência do pedido",oFont10) 
	nLin+=70 
	oQPrint:Say (nLin,0020,"Devolução de Mercadorias: Em  nenhuma  hipótese  será  aceita  a  devolução  de  mercadoria sem prévia autorização.",oFont10)
	nLin+=70
	//oQPrint:Say (nLin,0020,"Embalagem: Inclusa no preço. Será utilizada a embalagem mais apropriada em função das características de cada mercadoria.",oFont08)
	//nLin+=70 
	oQPrint:Say (nLin,0020,"Confirmacao de Compra: Em caso de aprovacao, favor informar o(s) numero(s) do(s) orcamento(s) aprovados(s).",oFont10)    
	nLin+=70 
Else
	nLin += 100
	oQPrint:Say (nLin,0020,"Sr Cliente, Favor confirmar as Classificacoes Fiscais para não ocorrer divergências na Emissão da Nota Fiscal.", oFont10)  
	nLin+=80
	//Ivandro Santos - 28/04/17 - Início da alteração
	//Ticket#2017042837000064 — Alteração de Valor de Faturamento Mínimo nos Orçamentos de Peças
	oQPrint:Say (nLin,0020,"Valor mínimo para faturamento: R$ 300,00",oFont10)
	//oPrint:Say (nLin,0020,"Valor mínimo para faturamento: R$ 100,00",oFont10)
	//Ticket#2017042837000064 — Fim da alteração
	nLin+=70 
	//oQPrint:Say (nLin,0020,"Expedição: Solicitamos indicar a Transportadora de sua preferência. Na ausência desta a Nota Fiscal será emitida e faremos contato com o",oFont08) 
	//nLin+=70 
	//oQPrint:Say (nLin,0020,"comprador para a coleta do material",oFont08)
	//nLin+=70 
	oQPrint:Say (nLin,0020,"Prazo de entrega:  Os  itens  com  prazo  de  entrega  futuro  eventualmente poderão ser antecipados,",oFont10)  
	nLin+=70 
	oQPrint:Say (nLin,0020,"dependendo apenas de nossa capacidade de produção no período de vigência do pedido",oFont10) 
	nLin+=70 
	oQPrint:Say (nLin,0020,"Devolução de Mercadorias: Em  nenhuma  hipótese  será  aceita  a  devolução  de  mercadoria sem prévia autorização.",oFont10)
	nLin+=70
	//oQPrint:Say (nLin,0020,"Embalagem: Inclusa no preço. Será utilizada a embalagem mais apropriada em função das características de cada mercadoria.",oFont08)
	//nLin+=70 
	//Ticket#2016102137000031 — Fim da alteração
	oQPrint:Say (nLin,0020,"Confirmacao de Compra: Em caso de aprovacao, favor informar o(s) numero(s) do(s) orcamento(s) aprovados(s).",oFont10)    
	nLin+=70 
EndIf
			
Return

/***************************************************/
Static Function ImpCabec()  //Orçamento FABRIMA
/**************************************************/

oPrint:EndPage()
oPrint:StartPage()
nLin := 50
nPag++
oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
nLin+=50
oPrint:Say(nLin,0020,"RFATR026",oFont11)
oPrint:Say(nLin,0600,SM0->M0_NOMECOM,oFont11)
oPrint:Say(nlin,2200,"Pag.:"+Transform(nPag,"@E 99"),oFont11)
nLin:=nLin+55
oPrint:Say(nLin,0450,Alltrim(SM0->M0_ENDENT) + " - " + Alltrim(SM0->M0_BAIRENT) + " - " + Alltrim(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT + " - CEP: " + SM0->M0_CEPENT,oFont11)
nLin:=nLin+55
If SubStr(cNumEmp,1,2) == "01"
	oPrint:Say(nLin,0550,"Tel: (11) 3246-3666,4178-8099 R. 309      Fax: (11) 3246-3666,4178-8099 R. 352",oFont11)
Else
	oPrint:Say(nLin,0550,"Tel: "+ SM0->M0_TEL + " Fax: " + SM0->M0_FAX,oFont11)
EndIf
nLin:=nLin+55
cCNPJ := SM0->M0_CGC
If !Empty(SM0->M0_INSC)
	oPrint:Say(nLin,0600,"Inscr: " + SM0->M0_INSC + " CNPJ: " + SubStr(cCNPJ,1,8) + "/" + SubStr(cCNPJ,9,4) + "-" + SubStr(cCNPJ,13,2),oFont11)
Else
	oPrint:Say(nLin,800,"CNPJ: " + SubStr(cCNPJ,1,8) + "/" + SubStr(cCNPJ,9,4) + "-" + SubStr(cCNPJ,13,2),oFont11)
EndIf
nLin:=nLin+55
oPrint:Say(nLin,0000,Replicate("=",172),oFont09)
nLin:=nLin+70

Return
