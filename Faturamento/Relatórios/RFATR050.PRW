#Include "Rwmake.ch"      
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR050  ºAutor  ³Aparecida de F.Stevanatoº Data ³ 27/02/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime do Orçamento de Venda de Pecas (Exportacao)          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
20/02/2012 - Alterado por Ana Paula QFaustino - Alterado para impressão da MASIPACK 
21/03/2012 - Alterado por Ana Paula QFaustino - Acrescentado o campo de Notas importantes
13/08/2012 - Alterado por Ana Paula QFaustino - Acrescentado "*" apos a unidade de medida se o preco de venda for # preco Tabela
06/05/2013 - Alterado por Ana Paula QFaustino - Foi acrescentado o campo B1_POSIPI(NCM) e B1_PESO(Peso Liquido) no arquivo CSV   

±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ Descricao                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±º 12/10/18 ³ Felipe Freitas - Alteracao dados bancarios                   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


*/

User Function RFATR050() 

Private lEnd       := .F.                                                                          
Private nLastKey   := 0
Private cPerg      := "XRFATR050 "
Private nomeprog   := "RFATR050"
Private wnrel      := "RFATR050"
Private tamanho    := "P"
Private cString    := "SCK"
Private aReturn    := {"Zebrado",1,"Administracao",1,2,1,"",0 } 
Private titulo     := "Orçamento de Pecas Exportação"

Private nCol       := 0
Private nTotLin    := 0                                                                                                                                
Private nPag       := 1                                             
Private _nCont     := 0 
Private cEnd       := ""
Private cCNPJ      := ""
Private cDescr     := ""
Private cDesc      := ""
Private cDesc2     := ""
Private cValor     := "" 
Private cMoeda     := ""
Private nTotal     := 0
Private nTotMerc   := 0
Private nEmbDesp   := 0 
Private Idioma     := 0    // 1-Portugues   2-Espanhol   3-Ingles
Private nMes       := 0                                                                           
Private nLen       := 0
Private I          := 0
Private J          := 0 
Private _nEmp      := ""
Private cCondPgto  := "" 
Private nPrazo     := 0
Private _lItens    := .F.
Private aIdioma    := {"Portugues","Espanhol","Inglês"}

Private aMeses     := {{"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"},;
                       {"Enero","Febrero","Marzo","Abril","Mayo","Junio", "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"},;
                       {"January","February","March","April","May","June","July","August","September","October","November","Dezember"}}

Private DET0001    := {"ORÇAMENTO DE VENDA Nº ","Cotización Nº ","Quotation Nº "} 
Private DET0002    := {"It","Ít","Ít"}
Private DET0003    := {"Produto","Producto","Part no."}
Private DET0051    := {"NCM","NCM","NCM"}
Private DET0052    := {"Observação","Observacíon","Observation"}
Private DET0004    := {"Descrição","Descripción","Description"}
Private DET0005    := {"Qtd.","Ctd.","Qty"}
Private DET0006    := {"Pr.Unit.","Pr.Unit.","Unit Pr."}
Private DET0007    := {"Pr.Total","Pr.Total","Tot.Price"}
Private DET0008    := {"Ex-Fabrica","Ex-Works","Ex-Works"}
Private DET0009    := {"Custo de Embalagem","Gastos Embalaje","Cost Package"} 
Private DET0010    := {""," o si por courier express"," or by courier express"}
Private DET0011    := {"","Gastos aduana Y Flete Interno","Customs expenses and Inland Freight"}
Private DET0012    := {"Frete Internacional","Flete Internacional","International Freight"}
Private DET0013    := {"Seguro","Seguro","Insurance"}
Private DET0014    := {"MEIO DE TRANSPORTE","MEDIO TRANSPORTE","MEANS OF TRANSPORTATION"} 
Private DET0015    := {"PRAZO DE ENTREGA","PLAZO DE ENTREGA","DELIVERY TIME"}
Private DET0016    := {"CONDIÇÃO DE PGTO.","CONDICIÓN DE PAGO","PAYMENT TERMS"}
Private DET0017    := {"VALIDADE DA COTAÇÃO:","VALIDEZ DE LA COTIZATIÓN:","QUOTATION VALIDITY:"}
Private DET0018    := {"Atenciosamente,","Atentamente,","Very truly yours,"}
Private DET0019    := {"Masipack Ind. e Com. de Máquinas Automáticas S/A.","Fabrima Maquinas Automáticas Ltda."}
Private DET0020    := {"Documento sem assinatura, emitido/enviado por computador","Documento sin firma, emitido/enviado por computadora","(Document not signed, issued/transmitted by electronic way.)"}
Private DET0021    := {"Até ","Hasta ","Up to "}
Private DET0022    := {""," del pedido puesto en nuestra planta para despacho, salvo venta previa."," after your purchase order, ready for dispatch in our plant."}
Private DET0023    := {"","",""}
Private DET0024    := {"","Muy Importante:","Very important"}
Private DET0025    := {"","Instruir al banco a abonar el importe em su totalidad al beneficiario con cargo de gastos","Instructing the bank to pay the amount in full to the beneficiary. All bank"}
Private DET0026    := {"","bancarios a debitar de la cuenta del remitente/ordenante.","charges must be paid/debitted to buyer's or sender's account."}
Private DET0027    := {,"Beneficiario","Beneficiary"}
Private DET0028    := {"São Bernardo do Campo-SP, Brazil","Guarulhos-SP,Brazil"}
Private DET0029    := {"Solicite seus orçamentos p/ ","Solicite sus cotizaciónes p/ ","Request your quotatins to: "}
Private DET0030    := {"A.C.: ","Señor/es.","To "}
Private DET0031    := {"","Nos permitimos presentarles la siguiente cotización:","We are pleased to present you our quotation as follows:"} 
Private DET0032    := {"","Quedando a vuestra disposición para cualquier consulta y pendientes de vuestras noticias, los","We look forward to hearing from you,"} 
Private DET0033    := {"","saludamos muy",""}
Private DET0034    := {"","100% com el pedido, através de transferencia bancaria a nuestro favor al","100% in advance with the purchase order, by bank transfer to our favor at the bank: "}
Private DET0035    := {""," después de la fecha de la guia area, atraves de transferencia bancaria a nuestro favor al"," days after the AWB. The transfer must be to our favor at the bank: "} 
Private DET0036    := {"Semanas","Semanas","Weeks"}  
Private DET0037    := {"Conta nº","Cuenta nº","Account nº"}
Private DET0038    := {"","Tomar en cuenta que se tendrá que depositar el total de la factura (los demás gastos",""}
Private DET0039    := {"","con el banco corren por cuenta del cliente.)",""}
Private DET0040    := {"60 dias da data de emissão.","60 días de la fecha de emisión.","60 days from this date."}
Private DET0041    := {"FATURA DE VENDA Nº ","Factura Proforma Nº ","Proforma Invoice Nº "}
Private DET0042    := {""," si por agente transportista"," if by regular freight forworder"}
Private DET0050    := "________________________________________________________________________________________________________________________________________"

Private DET0053    := {"Notas Importantes: ","Notas importantes: " ,"Important notes: "}
Private DET0054    := {"Favor mencionar na Ordem de Compra, o número do nosso Orçamento.", "Por Favor, indicar en la Orden de Compra nuestro número de Cotización o Factura Comercial.","Please inform in the Order Purchase the number of our quotation or proforma invoice."}

Private cArqCSV    := "C:\Relato_microsiga\Orc_Pecas_Exp.csv"
Private cRegCSV    := ""

Private _cNomeEmp  := ""
Private _cEndEmp   := ""
Private _cCepEmp   := ""
Private _cCidEmp   := ""
Private _cEstEmp   := ""
Private _cTelEmp   := ""
Private _cNReduz   := ""

Private cNumSCJ    := ""
Private cStatus    := ""
Private dDtSCJ     := ctod("  /  /  ")

Private cCodCli   := ""
Private cNomCli   := ""
Private cBairCli  := ""
Private cEndCli   := ""
Private cCepCli   := ""
Private cMunCli   := ""
Private cEstCli   := ""
Private cPaisCli  := ""
Private cDescPais := ""
Private cTelCli   := ""
Private cFaxCli   := ""
Private cTipoCli  := ""
Private cInscrCli := ""
Private cEmailCli := ""
Private cContaCli  := ""
Private cCNPJCli   := ""
Private cPesoLiq   := ""
Private cNCM       := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros        				³
//³ mv_par01				// Numero do Orçamento              ³
//³ mv_par03     	     	// Idioma  1- Port. 2-Esp. 3-Ingles ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

Idioma := mv_par02

If mv_par01 == ""
   ApmsgStop("Entre com Número do Orçamento")
   Return
EndIf

If nLastkey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif   	

If (cArqCSV := FCreate(cArqCSV)) == -1
   apmsgAlert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
Else
   cRegCSV := ";;Orçamento de Peças - Exportação => "+ mv_par01
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := ""
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   cRegCSV := DET0002[Idioma]+";"+DET0003[Idioma]+";"+DET0004[Idioma]+";"+"UN"+";"+"Peso Liq."+";"+"NCM"+";"+DET0005[Idioma]+";"+DET0006[Idioma]+";"+DET0007[Idioma]+";"+DET0015[Idioma]
   FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
EndIf  

MsgRun("Aguarde, Imprimindo !!!!",, { || EmiteRelat() })

Return


/***********************************/
  Static Function EmiteRelat()
//Função de impressao do Relatorio
/***********************************/

Local X

Private	dDtSCJ  := ctod("  /  /  ")
Private _nCont   := 0 
Private _nEmp    := ""

_nEmp := Val(SubStr(cNumEmp,1,2))

If SubStr(cNumEmp,1,2) == "10"
   _nEmp := 2
ElseIf SubStr(cNumEmp,1,2) == "01"
	_nEmp := 1
EndIf   

oFont1  := TFont():New("Arial Black",,13,,.F.,,,,,.F.)
oFont2  := TFont():New("Arial Black",,11,,.F.,,,,,.F.)
oFont3  := TFont():New("Arial",,12,,.F.,,,,,.F.)
oFont4  := TFont():New("Courier New",,18,,.F.,,,,,.F.) 
oFont5  := TFont():New("Arial",,15,,.F.,,,,,.F.)
oFont6  := TFont():New("Arial Black",,10,,.F.,,,,,.F.)
oFont7  := TFont():New("Arial",,8,,.F.,,,,,.F.)
oFont8  := TFont():New("Arial",,9,,.F.,,,,,.F.)
oFont9  := TFont():New("Courier New",,12,,.F.,,,,,.F.)
oFont10 := TFont():New("Arial",,10,,.F.,,,,,.F.)
oFont11 := TFont():New("Arial Black",,9,,.F.,,,,,.F.)
oFont12 := TFont():New("Courier New",,9,,.F.,,,,,.F.)

oPrn := TMSPrinter():New("RFATR050") 

oPrn:StartPage() 

oPrn:Say(0, 0, " ",oFont1,010)     // startando a impressora 
Li:=50                                            
nTotLin := 2980

_nCont  := 0 
_lItens := .F. 

SM0->(dbSetOrder(1))
nRegistro := Recno()
SM0->(dbSeek(SubStr(cNumEmp,1,2)))
_cNomeEmp := SM0->M0_NOMECOM
_cEndEmp  := Alltrim(SM0->M0_ENDENT) + " - " + Alltrim(SM0->M0_BAIRENT)
_cCepEmp  := "CEP.: " + SubStr(SM0->M0_CEPENT,1,5) + "-" + SubStr(SM0->M0_CEPENT,6,3)
_cCidEmp  := Alltrim(SM0->M0_CIDENT)
_cEstEmp  := SM0->M0_ESTENT
_cTelEmp  := SM0->M0_TEL
_cNReduz  := Alltrim(SM0->M0_NOME)

If Select("QR1") > 0 
   DbSelectArea("QR1")                                                                         
   DbCloseArea()
EndIf   
	
_cQuery := "SELECT SCJ.CJ_MOEDA,   SCJ.CJ_STATUS,  SCJ.CJ_EMISSAO, SCJ.CJ_NUM,     SCJ.CJ_MSINCOT, SCJ.CJ_CLIENTE, SCJ.CJ_LOJA,   SCJ.CJ_MSNOTAS, " 
_cQuery += "       SCJ.CJ_MSEMAIL, SCJ.CJ_MSCTATO, SCJ.CJ_MSVLEMB, SCJ.CJ_DESPESA, SCJ.CJ_FRETE,   SCJ.CJ_FRETAUT, SCJ.CJ_SEGURO, " 
_cQuery += "       SCJ.CJ_MSTRANS, SCJ.CJ_MSPRZEN, SCJ.CJ_CONDPAG, SA1.A1_NOME,    SA1.A1_BAIRRO,  SA1.A1_END,     SA1.A1_CEP,    " 
_cQuery += "       ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SCJ.CJ_MSNOTAS)),' ' ) AS CJ_MSNOTAS,  "
_cQuery += "       SA1.A1_MUN,     SA1.A1_EST,     SA1.A1_PAIS,    SA1.A1_TEL,     SA1.A1_FAX,     SA1.A1_PESSOA,  SA1.A1_INSCR,  " 
_cQuery += "       SA1.A1_CGC,     SYA.YA_DESCR,   SB1.B1_PESO,    SB1.B1_POSIPI,   " 
_cQuery += "       SCK.CK_NUM,     SCK.CK_ITEM,    SCK.CK_PRODUTO, SCK.CK_QTDVEN,  SCK.CK_UM,      SCK.CK_PRCVEN,  SCK.CK_VALOR, SCK.CK_DESCRI,  " 
_cQuery += "       SZG.ZG_MSDESC,  SZG.ZG_DESCRE,  SZG.ZG_DESCRI,  SE4.E4_DESCRI,  DA1.DA1_PRCVEN  " 
_cQuery += "FROM "+RetSqlName("SCJ")+" SCJ " 
_cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '" + xFilial("SA1")+"' AND SA1.A1_COD    = SCJ.CJ_CLIENTE AND SA1.A1_LOJA = SCJ.CJ_LOJA AND SA1.D_E_L_E_T_ = ' ' "  
_cQuery += "INNER JOIN "+RetSqlName("SYA")+" SYA ON SYA.YA_FILIAL = '" + xFilial("SYA")+"' AND SYA.YA_CODGI  = SA1.A1_PAIS    AND SYA.D_E_L_E_T_ = ' ' "
_cQuery += "INNER JOIN "+RetSqlName("SCK")+" SCK ON SCK.CK_FILIAL = '" + xFilial("SCK")+"' AND SCK.CK_NUM    = SCJ.CJ_NUM     AND SCK.D_E_L_E_T_ = ' ' " 
_cQuery += "INNER JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL = '" + xFilial("SE4")+"' AND SE4.E4_CODIGO = SCJ.CJ_CONDPAG AND SE4.D_E_L_E_T_ = ' ' " 
_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1")+"' AND SB1.B1_COD    = SCK.CK_PRODUTO AND SB1.D_E_L_E_T_ = ' '  "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SZG")+" SZG ON SZG.ZG_FILIAL  = '" + xFilial("SZG")+"' AND SZG.ZG_CODIGO  = SCK.CK_PRODUTO AND SZG.D_E_L_E_T_ = ' ' " 
_cQuery += "LEFT OUTER JOIN "+RetSqlName("DA1")+" DA1 ON DA1.DA1_FILIAL = '" + xFilial("DA1")+"' AND DA1.DA1_CODTAB = SCJ.CJ_TABELA  AND DA1.DA1_CODPRO = SCK.CK_PRODUTO AND DA1.D_E_L_E_T_ = ' ' " 
_cQuery += "WHERE SCJ.CJ_FILIAL = '"+xFilial("SCJ")+"' AND SCJ.CJ_NUM = '"+MV_PAR01+"' " 
_cQuery += "AND SCJ.D_E_L_E_T_ = '' " 
_cQuery += "ORDER BY SCJ.CJ_NUM, SCK.CK_ITEM " 

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","QR1->CJ_EMISSAO","D",08,00) 

dbSelectArea("QR1")
dbGoTop()
nTReg := QR1->(RecCount())
ProcRegua(nTReg)		

//Monta Array com as Datas de Entrega dos Pedidos
While QR1->(!Eof())

	cNotas := Alltrim(QR1->CJ_MSNOTAS)

	cCodCli   := QR1->CJ_CLIENTE
	cNomCli   := QR1->A1_NOME                                             
	cBaiCli   := QR1->A1_BAIRRO
	cEndCli   := QR1->A1_END
	cCEPCli   := QR1->A1_CEP
	cMunCli   := QR1->A1_MUN
	cEstCli   := QR1->A1_EST
	cPaisCli  := QR1->A1_PAIS
	cDescPais := QR1->YA_DESCR
	cTelCli   := QR1->A1_TEL
	cFaxCli   := QR1->A1_FAX
	cTipoCli  := QR1->A1_PESSOA
	cInscrCli := QR1->A1_INSCR
	cEmailCli := QR1->CJ_MSEMAIL
	cContaCli := QR1->CJ_MSCTATO
	cCNPJCli  := QR1->A1_CGC
	cPesoLiq  := QR1->B1_PESO
	cNCM      := QR1->B1_POSIPI
	cIncoterm := QR1->CJ_MSINCOT
	
	cCJ_MOEDA   := QR1->CJ_MOEDA
	cCJ_FRETE   := QR1->CJ_FRETE
	cCJ_FRETAUT := QR1->CJ_FRETAUT
	cCJ_SEGURO  := QR1->CJ_SEGURO
	cCJ_MSTRANS := QR1->CJ_MSTRANS
	cCJ_MSPRZEN := QR1->CJ_MSPRZEN
	cCJ_CONDPAG := QR1->CJ_CONDPAG
	cE4_DESCRI  := QR1->E4_DESCRI

	If Idioma > 1 .And. Empty(QR1->CJ_MSINCOT)
		apmsgStop("Orçamento de exportação - Informe o INCOTERM antes da emissão")
	    Exit
	EndIf

	If QR1->CJ_MOEDA = 1
		cMoeda := "R$ "
	ElseIf QR1->CJ_MOEDA = 2
		cMoeda := "US$"
	ElseIf QR1->CJ_MOEDA = 4
		cMoeda := "EUR"
	EndIf
	cLogo := "logo"+SubStr(cNumEmp,1,2)+".bmp"
	oPrn:SayBitmap (Li,110,cLogo,450,200)
	
	oPrn:Say (Li,1450,_cNomeEmp,oFont8)
	Li+=50
	oPrn:Say (Li,1450,_cEndEmp + " " + _cCepEmp,oFont8)
	Li+=50
	oPrn:Say (Li,1450,_cCidEmp + " " + _cEstEmp + " Brazil Tel.: +55 " + _cTelEmp,oFont8)

	If SubStr(cNumEmp,1,2) == "01"
		oPrn:Say (Li,2150, "",oFont7)
		Li+=50
		oPrn:Say (Li,1450,"www.masipack.com.br - e-mail: comex@masipack.com.br",oFont7)
	ElseIf SubStr(cNumEmp,1,2) == "10"
		oPrn:Say (Li,2150, "Fax: 24652587",oFont7)
		Li+=50
		oPrn:Say (Li,1450,"www.fabrima.com.br - e-mail: pecas@fabrima.com.br",oFont8)
	EndIf
	
	Li+=150
	oPrn:Say (Li,100, DET0050,oFont2)
	Li+=55
	
	If QR1->CJ_STATUS == "A"
		oPrn:Say (Li,110, DET0001[Idioma] + QR1->CJ_NUM, oFont1)
	ElseIf QR1->CJ_STATUS == "B"
		oPrn:Say (Li,110, DET0041[Idioma] + QR1->CJ_NUM, oFont1)
	ElseIf QR1->CJ_STATUS <> "A" .or. QR1->CJ_STATUS <> "B"
		oPrn:Say (Li,110, DET0001[Idioma] + QR1->CJ_NUM, oFont1)
	EndIf                                                                

	nMes   := Month(QR1->CJ_EMISSAO)
	dDtSCJ := QR1->CJ_EMISSAO
	
	If Idioma == 3
		If Day(QR1->CJ_EMISSAO) == 1
			oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "st, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
		ElseIf Day(QR1->CJ_EMISSAO) == 2
			oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "nd, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
		ElseIf Day(QR1->CJ_EMISSAO) == 3
			oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "rd, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
		Else
			oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "th, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
		EndIf
	Else
		oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + SubStr(DtoS(dDtSCJ),7,2) + " de " + aMeses[Idioma][nMes] + " de 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
	EndIf
	
	Li+=15
	oPrn:Say (Li,100, DET0050,oFont2)
	Li+=150
	oPrn:Say (Li,110, DET0030[Idioma],oFont2)
	cEnd  := ""

	Li+=70

	cCodCli   := QR1->CJ_CLIENTE
	cNomCli   := QR1->A1_NOME
	cBaiCli   := QR1->A1_BAIRRO
	cEndCli   := QR1->A1_END
	cCEPCli   := QR1->A1_CEP
	cMunCli   := QR1->A1_MUN
	cEstCli   := QR1->A1_EST
	cPaisCli  := QR1->A1_PAIS
	cDescPais := QR1->YA_DESCR
	cTelCli   := QR1->A1_TEL
	cFaxCli   := QR1->A1_FAX
	cTipoCli  := QR1->A1_PESSOA
	cInscrCli := QR1->A1_INSCR
	cEmailCli := QR1->CJ_MSEMAIL
	cContaCli := QR1->CJ_MSCTATO
	cCNPJCli  := QR1->A1_CGC
		
	oPrn:Say (Li,110, QR1->A1_NOME, oFont2)
	Li+=50
		cEnd := Alltrim(QR1->A1_END)
		If !Empty(QR1->A1_BAIRRO)
			cEnd += " - " + Alltrim(QR1->A1_BAIRRO)
		EndIf
	If QR1->A1_EST <> "EX"
		cEnd := "CEP: " + SubStr(QR1->A1_CEP,1,5) + "-" + SubStr(QR1->A1_CEP,6,3) + " - " + Alltrim(QR1->A1_MUN) + " - " + Alltrim(QR1->A1_EST)
	Else
		cEnd += ", " + QR1->YA_DESCR
	EndIf
	oPrn:Say (Li,110, cEnd, oFont10)
	Li+=50
	oPrn:Say (Li,110, "Tel.: "+ QR1->A1_TEL, oFont10)
	If !Empty(QR1->A1_FAX)
		oPrn:Say (Li,550, "Fax: "+ Alltrim(QR1->A1_FAX), oFont10)
	EndIf
	Li+=50
	If QR1->A1_EST <> "EX"
		cCNPJ := QR1->A1_CGC
		If Alltrim(QR1->A1_PESSOA) == "J"
			oPrn:Say (Li,110, "CNPJ: " + SubStr(cCNPJ,1,8) + "/" + SubStr(cCNPJ,9,4) + "-" + SubStr(cCNPJ,13,2), oFont10)
			Li+=50
			oPrn:Say (Li,110, "I.E.: " + Alltrim(QR1->A1_INSCR), oFont10)
		Else
			oPrn:Say (Li,110, "CPF: " + SubStr(cCNPJ,1,Len(cCNPJ)-2) + "-" + SubStr(cCNPJ,Len(cCNPJ)-1,2), oFont10)
		EndIf
		Li+=50
	EndIf
	If !Empty(QR1->CJ_MSEMAIL)
		oPrn:Say (Li,110, "e-mail: " + QR1->CJ_MSEMAIL, oFont10)
		Li+=50
	EndIf
	
	Li+=80
	If !Empty(QR1->CJ_MSCTATO)
		oPrn:Say (Li,110, QR1->CJ_MSCTATO,oFont10)               
	EndIf
	Li+=100
	oPrn:Say (Li,110, DET0031[Idioma],oFont2)
	Li+=60

	ImpDet()
	
	nTotMerc := 0
	nPrazo   := 0

	nEmbDesp := QR1->CJ_MSVLEMB + QR1->CJ_DESPESA

	Do While QR1->CK_NUM == Alltrim(mv_par01)
		_lItens := .T.
		oPrn:Say(Li,0110,QR1->CK_ITEM,oFont12)
		oPrn:Say(Li,0190,QR1->CK_PRODUTO,oFont12)
		cDescr := ""
		If Idioma == 1
			cDescr := Alltrim(QR1->ZG_MSDESC)
		ElseIf Idioma == 2
			cDescr := Alltrim(QR1->ZG_DESCRE)
		Else
			cDescr := Alltrim(QR1->ZG_DESCRI)
		EndIf
		// ALTERADO - LIZANDRA 13/02/15 - 
		If Empty(cDescr)
			cDescr := Alltrim(QR1->CK_DESCRI)
		ENDIF
		oPrn:Say(Li,0460,cDescr,oFont12)
		/*
		If !Empty(cDescr)
			oPrn:Say(Li,0460,cDescr,oFont12)
		Else
			oPrn:Say(Li,0460,"Peça sem descrição em "+aIdioma[Idioma],oFont12)
		EndIf
		*/
		
		oPrn:Say(Li,1450,QR1->B1_POSIPI,oFont12)
		
		oPrn:Say(Li,1650,Transform(QR1->CK_QTDVEN,"@E 9,999.99"),oFont12)
		oPrn:Say(Li,1825,QR1->CK_UM,oFont12)
		If QR1->CK_PRCVEN <> QR1->DA1_PRCVEN 
			oPrn:Say(Li,1880,"*",oFont12)
		EndIf		
		oPrn:Say(Li,1890,Transform(QR1->CK_PRCVEN,"@E 999,999.99"),oFont12)
		oPrn:Say(Li,2100,Transform(QR1->CK_VALOR,"@E 9,999,999.99"),oFont12)
		nTotMerc += QR1->CK_VALOR
		Checalinha()
		Li+=050
	
		cRegCSV :=  QR1->CK_ITEM+";"+QR1->CK_PRODUTO+";"+cDescr+";"+QR1->CK_UM+";"+Transform(QR1->B1_PESO,"999,999.9999")+";"+;
					QR1->B1_POSIPI+";"+Transform(QR1->CK_QTDVEN,"9,999.99")+";"+Transform(QR1->CK_PRCVEN,"999,999.99")+";"+;					
					Transform(QR1->CK_VALOR,"9,999,999.99")+";"+QR1->CJ_MSPRZEN
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		
		QR1->(DbSkip())
	EndDo
	_lItens := .F.
	
	Li+=100
	Checalinha()
	oPrn:Say (Li,0104,Replicate("_",80),oFont9)
	Li+=36
	oPrn:Say (Li,0089, "|",oFont4)
	Li+=10
	oPrn:Say (Li,0130, DET0008[Idioma],oFont9)
	Li-=10
	oPrn:Say (Li,1550, "|",oFont4)
	Li+=10
	oPrn:Say (Li,1600,cMoeda,oFont9)
	Li-=10
	oPrn:Say (Li,1700,"|",oFont4)
	cValor := Transform(nTotMerc,"99,999,999.99")
	If cCJ_MOEDA == 2
		cValor := Replace(cValor,",","*")
		cValor := Replace(cValor,".",",")
		cValor := Replace(cValor,"*",".")
	EndIf
	Li+=10
	oPrn:Say (Li,1740, cValor ,oFont9)
	Li-=10
	oPrn:Say (Li,2157, "|",oFont4)
	Li+=25
	oPrn:Say (Li,0104, Replicate("_",80),oFont9)

	Checalinha()
	
	If nEmBDesp > 0
		Li+=36
		oPrn:Say (Li,0089, "|",oFont4)
		Li+=10
		oPrn:Say (Li,0130, DET0009[Idioma],oFont9)
		Li-=10
		oPrn:Say (Li,1550, "|",oFont4)
		Li+=10
		oPrn:Say (Li,1600, cMoeda,oFont9)
		Li-=10
		oPrn:Say (Li,1700, "|",oFont4)
		cValor := Transform(nEmbDesp,"99,999,999.99")
		If cCJ_MOEDA == 2
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		Li+=10
		oPrn:Say (Li,1740, cValor ,oFont9)
		Li-=10
		oPrn:Say (Li,2157, "|",oFont4)
		Li+=25
		oPrn:Say (Li,0104, Replicate("_",80),oFont9)
	EndIf

	Checalinha()
	
	Li+=36
	oPrn:Say (Li,0089, "|",oFont4)
	Li+=10
//	oPrn:Say (Li,0130, "Total " + DET0008[Idioma] + DET0010[Idioma],oFont9)
	oPrn:Say (Li,0130, "Total " + DET0008[Idioma],oFont9)
	Li-=10
	oPrn:Say (Li,1550, "|",oFont4)
	Li+=10
	oPrn:Say (Li,1600, cMoeda,oFont9)
	Li-=10
	oPrn:Say (Li,1700, "|",oFont4)
	nTotal := nTotMerc + nEmbDesp
	cValor := Transform(nTotal,"99,999,999.99")
	If cCJ_MOEDA == 2
		cValor := Replace(cValor,",","*")
		cValor := Replace(cValor,".",",")
		cValor := Replace(cValor,"*",".")
	EndIf
	Li+=10
	oPrn:Say (Li,1740, cValor ,oFont9)
	Li-=10
	oPrn:Say (Li,2157, "|",oFont4)
	Li+=25
	oPrn:Say (Li,0104, Replicate("_",80),oFont9)

	Checalinha()
	
	If (cCJ_FRETE) > 0
		Li+=36
		oPrn:Say (Li,0089, "|",oFont4)
		Li+=10
//		oPrn:Say (Li,0130, "FCA - " + DET0011[Idioma],oFont9)
		oPrn:Say (Li,0130, cIncoterm + "/" + cIncoterm + SPACE(1) + DET0011[Idioma],oFont9)
		Li-=10
		oPrn:Say (Li,1550, "|",oFont4)
		Li+=10
		oPrn:Say (Li,1600, cMoeda,oFont9)
		Li-=10
		oPrn:Say (Li,1700, "|",oFont4)
		cValor := Transform(cCJ_FRETE,"99,999,999.99")
		If cCJ_MOEDA == 2
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		Li+=10
		oPrn:Say (Li,1740, cValor ,oFont9)
		Li-=10
		oPrn:Say (Li,2157, "|",oFont4)
		Li+=25
		oPrn:Say (Li,0104, Replicate("_",80),oFont9)
		Li+=36
		oPrn:Say (Li,0089, "|",oFont4)
		Li+=10
//		oPrn:Say (Li,0130, "TOTAL FCA " + DET0042[Idioma] ,oFont9)
		oPrn:Say (Li,0130, "TOTAL " + cIncoterm + DET0042[Idioma] ,oFont9)
		Li-=10
		oPrn:Say (Li,1550, "|",oFont4)
		Li+=10
		oPrn:Say (Li,1600, cMoeda,oFont9)
		Li-=10
		oPrn:Say (Li,1700, "|",oFont4)
		
		nTotal += cCJ_FRETE
		cValor := Transform(nTotal,"99,999,999.99")
		If cCJ_MOEDA == 2
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		Li+=10
		oPrn:Say (Li,1740, cValor ,oFont9)
		Li-=10
		oPrn:Say (Li,2157, "|",oFont4)
		Li+=25
		oPrn:Say (Li,0104, Replicate("_",80),oFont9)
	EndIf

	Checalinha()
	
	If (cCJ_FRETAUT) > 0
		Li+=36
		oPrn:Say (Li,0089, "|",oFont4)
		Li+=10
		oPrn:Say (Li,0130, DET0012[Idioma],oFont9)
		Li-=10
		oPrn:Say (Li,1550, "|",oFont4)
		Li+=10
		oPrn:Say (Li,1600, cMoeda,oFont9)
		Li-=10
		oPrn:Say (Li,1700, "|",oFont4)
		cValor := Transform(cCJ_FRETAUT,"99,999,999.99")
		If cCJ_MOEDA == 2
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		Li+=10
		oPrn:Say (Li,1740, cValor ,oFont9)
		Li-=10
		oPrn:Say (Li,2157, "|",oFont4)
		Li+=25
		oPrn:Say (Li,0104, Replicate("_",80),oFont9)
		
		nTotal += cCJ_FRETAUT
		Li+=36
		oPrn:Say (Li,0089, "|",oFont4)
		Li+=10
		oPrn:Say (Li,0130, "TOTAL CPT " ,oFont9)
		Li-=10
		oPrn:Say (Li,1550, "|",oFont4)
		Li+=10
		oPrn:Say (Li,1600, cMoeda,oFont9)
		Li-=10
		oPrn:Say (Li,1700, "|",oFont4)
		cValor := Transform(nTotal,"99,999,999.99")
		If cCJ_MOEDA == 2
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		Li+=10
		oPrn:Say (Li,1740, cValor ,oFont9)
		Li-=10
		oPrn:Say (Li,2157, "|",oFont4)
		Li+=25
		oPrn:Say (Li,0104, Replicate("_",80),oFont9)
	EndIf

	Checalinha()
	
	If cCJ_SEGURO > 0
		Li+=36
		oPrn:Say (Li,0089, "|",oFont4)
		Li+=10
		oPrn:Say (Li,0130, DET0013[Idioma],oFont9)
		Li-=10
		oPrn:Say (Li,1550, "|",oFont4)
		Li+=10
		oPrn:Say (Li,1600, cMoeda,oFont9)
		Li-=10
		oPrn:Say (Li,1700, "|",oFont4)
		cValor := Transform(cCJ_SEGURO,"99,999,999.99")
		If cCJ_MOEDA == 2
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		Li+=10
		oPrn:Say (Li,1740, cValor ,oFont9)
		Li-=10
		oPrn:Say (Li,2157, "|",oFont4)
		Li+=25
		oPrn:Say (Li,0104, Replicate("_",80),oFont9)
		
		Li+=36
		oPrn:Say (Li,0089, "|",oFont4)
		Li+=10
		oPrn:Say (Li,0130, "TOTAL CIP" ,oFont9)
		Li-=10
		oPrn:Say (Li,1550, "|",oFont4)
		Li+=10
		oPrn:Say (Li,1600, cMoeda,oFont9)
		Li-=10
		oPrn:Say (Li,1700, "|",oFont4)
		nTotal += cCJ_SEGURO
		cValor := Transform(nTotal,"99,999,999.99")
		If cCJ_MOEDA == 2
			cValor := Replace(cValor,",","*")
			cValor := Replace(cValor,".",",")
			cValor := Replace(cValor,"*",".")
		EndIf
		Li+=10
		oPrn:Say (Li,1740, cValor ,oFont9)
		Li-=10
		oPrn:Say (Li,2157, "|",oFont4)
		Li+=25
		oPrn:Say (Li,0104, Replicate("_",80),oFont9)
	EndIf
	Li+=150        
	Checalinha()
	_lItens := .F.
	ChecaLinha()
	
	If !Empty(cNotas)
		oPrn:Say (Li,0110, DET0052[Idioma], oFont2)
		Li += 10
		For X := 1 TO MLCOUNT(cNotas,80)
			oPrn:Say (Li,0630, MEMOLINE(cNotas,80,X), oFont10)
			Li := Li + 60
		Next
	EndIf

	// aqui começa a impressão meio de transporte
	Li+=145
	ChecaLinha()
	oPrn:Say (Li,0110, DET0014[Idioma], oFont2)
	If Idioma == 1
		nCol := 640
	ElseIf Idioma == 2
		nCol := 630
	ElseIf Idioma == 3
		nCol := 780
	EndIf
	
	If !Empty(cCJ_MSTRANS)
		If SA4->(DbSeek(xFilial("SA4")+Alltrim(cCJ_MSTRANS)))
			oPrn:Say (Li,nCol,Alltrim(SA4->A4_NOME), oFont3)
		Else
			oPrn:Say (Li,nCol,Alltrim(cCJ_MSTRANS), oFont3)
		EndIf
	Else
		oPrn:Say (Li,nCol,"Sem meio de transporte", oFont3)
	EndIf
	
	Li+=145
	ChecaLinha()
	oPrn:Say (Li,0110, DET0015[Idioma], oFont2)
	
	oPrn:Say (Li,0640, DET0021[Idioma] + Alltrim(cCJ_MSPRZEN), oFont6)
	oPrn:Say (Li,1000, DET0022[Idioma] , oFont3)

	Li+=145
	ChecaLinha()
	oPrn:Say (Li,0110, DET0016[Idioma], oFont2)
  
	cCondPgto := Alltrim(cCJ_CONDPAG)
	If !Empty(cCondPgto) .And. cCondPgto <> "V01" .And. cCondPgto <> "V02"
		nPos := AT(" ",cE4_DESCRI)
		cCondPgto := SubStr(cE4_DESCRI,1,nPos - 1)
	EndIf
	If cCondPgto == "V02"
		oPrn:Say (Li,0630, DET0034[Idioma], oFont3)
	Else
		oPrn:Say (Li,0630, cCondPgto + DET0035[Idioma], oFont3)
	EndIf
	
	If SubStr(cNumEmp,1,2) == "10"
		//Ivandro Santos - 28/03/17
		//Ticket#2017032837000137 — Relatório Orçamento Exportação
		//Felipe Freitas - 30/11/18
		//Alteracao informacoes bancarias - Solicitante: Murilo
	   /*	If cCJ_MOEDA == 2
			Li+=70
			oPrn:Say (Li,0630, "Account with Institution : Banco do Brasil S A",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "SWIFT: BRASBRRJOCO",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Beneficiary Account: BR3100000000033570000106631C1",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Nome da Empresa: FABRIMA MÁQUINAS AUTOMÁTICAS LTDA",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Endereço Completo: AVENIDA NARAIN SINGH, 547 - BONSUCESSO - CEP 07.250-000 - GUARULHOS-SP",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Moeda . . . . . : 220 USD",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Banq. cobertura : BANCO DO BRASIL S.A.",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Praca/Pais . . : NEW YORK (NEW YORK-USA)-BIC SWIFT: BRASUS33",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "FedWire ABA : //FW026003557",oFont2)
			Li+=50
		Endif
		
		If cCJ_MOEDA == 4
			oPrn:Say (Li,0630, "Account with Institution : Banco do Brasil S A",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "SWIFT: BRASBRRJOCO",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Beneficiary Account: BR3100000000033570000106631C1",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Nome da Empresa: FABRIMA MÁQUINAS AUTOMÁTICAS LTDA",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Endereço Completo: AVENIDA NARAIN SINGH, 547 - BONSUCESSO - CEP 07.250-000 - GUARULHOS-SP",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Moeda . . . . . : 978 EUR",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Banq. cobertura : BANCO DO BRASIL S.A.",oFont2)
			Li+=50
			oPrn:Say (Li,0630, "Praca/Pais . . : FRANKFURT AM MAIN (GERMANY)-BIC SWIFT:BRASDEFF",oFont2)
			Li+=50
		Endif
        */
		/*
		Li+=70
		oPrn:Say (Li,0630, "Destinatary Bank: BANCO SANTANDER S/A ",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "                            São Paulo - Brasil ",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "SWIFT:                  BSCHBRSP ",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Account nr.            3544034644001 ",oFont2)
		Li+=50
		*/
		If cCJ_MOEDA == 4
		Li+=50
		oPrn:Say (Li,0630, "Correspondent Bank: Banco Santander S/A - Madrid - España ",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Swift(BIC CODE): BSCHESMMXXX",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Account Number: 15439",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Beneficiary Bank: Banco Santander (Brasil) S.A.",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Swift(BIC CODE): BSCHBRSP",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Beneficiary Name: [FABRIMA MAQUINAS AUTOMATICAS LTDA, ACCOUNT IN BRASIL 0140130063840]",oFont2)
		Endif
		
		If cCJ_MOEDA == 2
		Li+=50
		oPrn:Say (Li,0630, "Correspondent Bank: Standard Chartered Bank - New York - USA ",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Swift(BIC CODE): SCBLUS33XXX",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Clearing Code: ABA 026002561 / CHIPS UID 0256",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Account Number: 3544034644001",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Beneficiary Bank: Banco Santander (Brasil) S.A.",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Swift(BIC CODE): BSCHBRSP",oFont2)
		Li+=50
		oPrn:Say (Li,0630, "Beneficiary Name: [FABRIMA MAQUINAS AUTOMATICAS LTDA, ACCOUNT IN BRASIL 0140130063840]",oFont2)
		Endif   
		//Fim da alteracao
		//*/
		//Ticket#2017032837000137 — Relatório Orçamento Exportação
	EndIf
	
	If Idioma == 2
		Li+=50
		oPrn:Say (Li,0630, DET0038[Idioma], oFont3)
		Li+=50
		oPrn:Say (Li,0630, DET0039[Idioma], oFont3)
		Li+=70
		oPrn:Say (Li,0630, DET0024[Idioma], oFont2)
		Li+=50
		oPrn:Say (Li,0630, DET0025[Idioma], oFont3)
		Li+=50
		oPrn:Say (Li,0630, DET0026[Idioma], oFont3)
	EndIf
	
	If Idioma == 3 .And. cCondPgto <> "01"
		Li+=50
		oPrn:Say (Li,0630, DET0025[Idioma], oFont3)
		Li+=50
		oPrn:Say (Li,0630, DET0026[Idioma], oFont3)
	EndIf

	Li+=150
	checalinha()
	oPrn:Say (Li,0110, DET0017[Idioma], oFont2)
	Li+=10
	oPrn:Say (Li,0780, DET0040[Idioma], oFont3)
	
	Li+=150
	checalinha()
	oPrn:Say (Li,0110, DET0032[Idioma], oFont5)
	If Idioma == 2
		Li+=50
		oPrn:Say (Li,0110, DET0033[Idioma], oFont5)
	EndIf

	Li+=110
	checalinha()
	oPrn:Say (Li,0110, DET0053[Idioma], oFont2)
	oPrn:Say (Li,0480, DET0054[Idioma], oFont2)
	
	Li+=180
	ChecaLinha()
	oPrn:Say (Li,110, DET0018[Idioma], oFont5)
	Li+=150
	oPrn:Say (Li,110, DET0019[_nEmp], oFont5)
	Li+=50
	oPrn:Say (Li,110, DET0020[Idioma], oFont8)
	Li+=150
    
	If _nEmp == 2
		oPrn:Say (Li,610, DET0029[Idioma] + "repuestos@fabrima.com.br", oFont1)
	EndIf
    checalinha()
	oPrn:Say (3000,2100, STR(nPag), oFont3)

	_nCont := _nCont + 1
	
EndDo

QR1->(dbCloseArea())

ApmsgInfo("A planilha foi gerada em ==> C:\relato_microsiga\Orc_Pecas_Exp.csv")

If _nCont == 0
   apmsgStop("Erro no Processamento")
   oPrn:End()
   MS_FLUSH()  
   Return
EndIf

oPrn:EndPage()   // Finaliza a pagina

oPrn:Preview()   // Video
   
oPrn:End() 

FClose(cArqCSV) 

MS_FLUSH() 

Return (.T.)

/************************************/
Static Function ChecaLinha()
/************************************/

If Li > nTotLin

	oPrn:Say (Li,2100, STR(nPag), oFont3)
	nPag++

	If nPag > 1

		oPrn:EndPage()
		oPrn:StartPage()
		If _lItens
			Li+=100
			ImpDet() 
			_lItens := .F.
		EndIf
		
		Li:=100
		
		oPrn:SayBitmap (Li,110,cLogo,450,200)
		
		oPrn:Say (Li,1450,_cNomeEmp,oFont8)
		Li+=50
		oPrn:Say (Li,1450,_cEndEmp + " " + _cCepEmp,oFont8)
		Li+=50
		oPrn:Say (Li,1450,_cCidEmp + " " + _cEstEmp + " Brazil Tel.: +55 " + _cTelEmp,oFont8)
	
		If SubStr(cNumEmp,1,2) == "01"
			oPrn:Say (Li,2150, "",oFont7)
			Li+=50
			oPrn:Say (Li,1450,"www.masipack.com.br - e-mail: comex@masipack.com.br",oFont7)
		ElseIf SubStr(cNumEmp,1,2) == "10"
			oPrn:Say (Li,2150, "Fax: 24652587",oFont7)
			Li+=50
			oPrn:Say (Li,1450,"www.fabrima.com.br - e-mail: pecas@fabrima.com.br",oFont8)
		EndIf
		
		Li+=150
		oPrn:Say (Li,100, DET0050,oFont2)
		Li+=55

		If cStatus == "A"
			oPrn:Say (Li,110, DET0001[Idioma] + cNumSCJ, oFont1)
		ElseIf cStatus == "B"
			oPrn:Say (Li,110, DET0041[Idioma] + cNumSCJ, oFont1)
		EndIf
	
		nMes := Month(dDtSCJ)
	
		If Idioma == 3
			If Day(QR1->CJ_EMISSAO) == 1
				oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "st, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
			ElseIf Day(QR1->CJ_EMISSAO) == 2
				oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "nd, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
			ElseIf Day(QR1->CJ_EMISSAO) == 3
				oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "rd, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
			Else
				oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + aMeses[Idioma][nMes] + " " + SubStr(DTOS(dDtSCJ),7,2) + "th, 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
			EndIf
		Else
			oPrn:Say (Li,1550,DET0028[_nEmp] + ", " + SubStr(DtoS(dDtSCJ),7,2) + " de " + aMeses[Idioma][nMes] + " de 20" + SubStr(DTOS(dDtSCJ),3,2),oFont10)
		EndIf
		
		Li+=15
		oPrn:Say (Li,100, DET0050,oFont2)
		Li+=150

		oPrn:Say (Li,110, DET0030[Idioma],oFont2)
		Li+=70

		oPrn:Say (Li,110, cNomCli, oFont2)
		Li+=50
		oPrn:Say (Li,110, cEnd, oFont10)
		Li+=50
		oPrn:Say (Li,110, "Tel.: "+ cTelCli, oFont10)
		If !Empty(QR1->A1_FAX)
			oPrn:Say (Li,550, "Fax: "+ cFaxCli, oFont10)
		EndIf

		Li+=50
		If cEstCli <> "EX"
			If Alltrim(cTipoCli) == "J"
				oPrn:Say (Li,110, "CNPJ: " + SubStr(cCNPJCli,1,8) + "/" + SubStr(cCNPJCli,9,4) + "-" + SubStr(cCNPJCli,13,2), oFont10)
				Li+=50
				oPrn:Say (Li,110, "I.E.: " + Alltrim(cInscrCli), oFont10)
			Else
				oPrn:Say (Li,110, "CPF: " + SubStr(cCNPJCli,1,Len(cCNPJCli)-2) + "-" + SubStr(cCNPJCli,Len(cCNPJCli)-1,2), oFont10)
			EndIf
			Li+=50
		EndIf

		If !Empty(cEmailCli)
			oPrn:Say (Li,110, "e-mail: " + cEmailCli, oFont10)
			Li+=50
		EndIf

		Li+=80
		If !Empty(cContaCli)
			oPrn:Say (Li,110, cContaCli,oFont10)
		EndIf
		Li+=100
		oPrn:Say (Li,110, DET0031[Idioma],oFont2)
		Li+=60

	EndIf
Endif

Return                            

/************************************/
Static Function ImpDet()
/************************************/

oPrn:Say (Li,1500, DET0051[Idioma], oFont2)
oPrn:Say (Li,1690, DET0005[Idioma], oFont2)
oPrn:Say (Li,1820, "Un", oFont2)
oPrn:Say (Li,1910, DET0006[Idioma], oFont2)
oPrn:Say (Li,2150, DET0007[Idioma], oFont2)
Li+=40
oPrn:Say (Li,0110, DET0002[Idioma], oFont2)
oPrn:Say (Li,0190, DET0003[Idioma], oFont2)
oPrn:Say (Li,0460, DET0004[Idioma], oFont2)
If QR1->CJ_MOEDA == 2
	oPrn:Say (Li,1950, "USD", oFont2)
	oPrn:Say (Li,2220, "USD", oFont2)
ElseIf QR1->CJ_MOEDA == 4
	oPrn:Say (Li,1950, "EUR", oFont2)
	oPrn:Say (Li,2220, "EUR", oFont2)
EndIf
Li+=60

Return
