#Include "Rwmake.ch"
#Include "Topconn.ch"
#include "ap5mail.ch"
#include "Protheus.ch"

Static nSegundaUnid           

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RCOMR002  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emissao das Cotacoes \ Envia por e-mail \ Caso escolha 'Sim'³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³Programador      ³ Manutencao efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³13/07/2007³Solange A. Vezu  ³                                          ³±± 
±±³09/05/2013³Ana P.           ³                                          ³±± 
±±³27/09/2018³Marcos Caparros  ³Realizado alteracao do e-mail destino     ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RCOMR002(cNumCota)

Local wnrel
Local cDesc1	:= "Emissao das cotacoes de compras"
Local cDesc2	:= ""
Local cDesc3	:= " "
Local Tamanho	:= "M"
Local cTel   	:= ""
Local cEndEnt	:= ""
Local oDlg	 	:= ""

STATIC aTamSXG, aTamSXG2

Private cNumero := 	""
Private cFornece:= 	""
Private cLoja   := 	""
Private cEmail  := 	""
Private titulo	:=	"Relacao de Cotacoes"
Private aReturn := 	{ "Zebrado",1,"Administracao", 2, 2, 1, "",0 }
Private nomeprog:=	"RCOMR002",nLastKey := 0
Private cString :=	"SC8"

Private cLinArq := ""

//************************** arquivo de Log ***********************************
cLinArq := cLinArq + ("Cotações enviadas com sucesso:")+chr(13)+chr(10)
cLinArq := cLinArq + ("==============================")+chr(13)+chr(10)
//*****************************************************************************

cPerg  := "RCOM02" + Space(4)

wnrel  := "RCOMR002"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01	      	  Do Numero                              ³
//³ mv_par02	      	  Ate o Numero 		                     ³
//³ mv_par03	     	  Do Fornecedor                          ³
//³ mv_par04              Ate o Fornecedor               	     ³
//³ mv_par05              Ate a data de validade     	   	     ³
//³ mv_par06              Campo Descricao do Produto             ³
//³ mv_par07              Endere‡o Fiscal                        ³
//³ mv_par08              Cidade - Estado                        ³
//³ mv_par09              Fax                                    ³
//³ mv_par10              Qual Unidade de Medida ?               ³
//³ mv_par11              Telefone                               ³
//³ mv_par12              Endereco de Entrega ?                  ³
//³ mv_par13              Envia e-mail ao fornecedor ?           ³
//³ mv_par14			  Emitir Confirmação de Envio?           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cNumCota == Nil
	pergunte("RCOM02    ",.F.)
Else
	cPerg := "MR150A    "
	Pergunte("MR150A    ",.F.)
EndIf

// Verifica conteudo da variavel static p/ Grupo Fornec. (001) e Loja (002)
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif
If !Empty(cNumCota)
	cEndEnt      := mv_par08
	cTel         := mv_par07
	nSegundaUnid := mv_par06		// Grupo MR150A
	mv_par09     := mv_par05
	mv_par08     := mv_par04
	mv_par07     := mv_par03
	mv_par06     := mv_par02
	mv_par05     := mv_par01
	nomeprog     := "MATA130"
	mv_par01     := cNumCota
	mv_par02     := cNumCota
	mv_par03     := "      "
	mv_par04     := "ZZZZZZ"
Else
	nSegundaUnid := mv_par10
	cTel         := mv_par11		// Grupo MR150A
	cEndEnt      := mv_par12
EndIf

RptStatus({|lEnd| R150Imp(@lEnd,wnrel,cString,@cTel,cEndEnt,cEmail)},Titulo)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ R150IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 10.11.95 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Uso      ³ RCOMR002                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function R150Imp(lEnd,wnrel,cString,cTel,cEndEnt,cEmail)

Local X
Local cDescri  := ""
Local cTecInf  := ""
Local cabec1   := ""
Local cabec2   := ""
Local cabec3   := ""
Local cContato := ""
Local cObs01   := ""
Local cObs02   := ""
Local cObs03   := ""
Local cObs04   := ""
Local cVar     := ""
Local cbCont   := 0
Local nItem    := 0
Local nLinObs  := 0

//Variáveis para uso do e-mail caso o par_13 esteja "Sim"
Local cArqItem := ""													//Itens para enviar e-mail
//Local cServer  := 'smtp.masipack.com.br'
Local cServer  := 'smtp.gmail.com'
Local cConta   := 'cotacao'
Local cEnvia   := 'cotacao@masipack.com.br'
Local cSenha   := 'dispbox12'
Local cRecebe  := ''

Private _cUsuario   := ""
Private _cUsuSenha  := ""

Private cCorpo 	:= ""
Private dEmissao
Private cCotacao := ""

_cUsuario  := RetCodUsr()
_cUsuSenha := UsrRetname(_cUsuario)

limite   := 132
li       := 0
m_pag    := 1
nPag     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY AvalImp(Limite)

SetRegua(RecCount())

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf
	
	cQuery := "SELECT  SC8.C8_NUM,    SC8.C8_ITEM, SC8.C8_FORNECE, SC8.C8_LOJA,    SC8.C8_CONTATO, SC8.C8_EMISSAO, SA2.A2_COD,     SA2.A2_LOJA,    SA2.A2_NOME,    "
	IF SUBSTR(cNumEmp,1,2) <> "15"  
		//Ivandro Santos - 06/04/17 - Início da alteração
		//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
		cQuery += "      	  SA2.A2_EMAIL2, "		//cQuery += "      	  SA2.A2_EMAIL2, B1_DESCP,   " 
		//cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B1_MSDTEC )),' ' ) AS B1_MSDTEC, "	
		cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B5_MSOBS )),' ' ) AS B5_MSOBS, "	
		//Ticket#2017031037000107 — Fim da alteração
		
	ELSE	
		//cQuery += "      	  SA2.A2_MSEMAIL,   " - Alteração feita por campo não existir mais / Felipe Freitas
		cQuery += "      	  SA2.A2_EMAIL2,   "
		cQuery += "         ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),B5_MSOBS )),' ' ) AS B5_MSOBS, "
	ENDIF	
	cQuery += "        SA2.A2_DDD,  SA2.A2_TEL,     SA2.A2_FAX,     SC8.C8_FILENT,  SC8.C8_NUMSC,   SC8.C8_ITEMSC,  SC8.C8_PRODUTO, "
	//Ivandro Santos - 29/12/17 - início da alteração: Ticket#2017122037000152
	cQuery += "        SC8.C8_QUANT,  SC8.C8_UM,   SC8.C8_DATPRF,  ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),SC8.C8_OBS )),' ' ) AS  'C8_OBS', "
	cQuery += "        SB1.B1_FABRIC,  SC8.C8_QTSEGUM, SC8.C8_SEGUM,   "
	//Fim - Ticket#2017122037000152
	cQuery += "        SC8.C8_QUANT,  SB5.B5_CEME, SA5.A5_CODPRF,  SA5.A5_NOMPROD, SC1.C1_DESCRI,  SB1.B1_DESC,    "
	cQuery += "        SY1.Y1_NOME  "
	cQuery += "FROM "+RetSqlName("SC8")+" SC8 "
	cQuery += "INNER JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SA2.A2_COD = SC8.C8_FORNECE AND SA2.A2_LOJA = SC8.C8_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC8.C8_PRODUTO AND SB1.D_E_L_E_T_ = ' '  "
	cQuery += "LEFT OUTER JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' AND SB5.B5_COD = SC8.C8_PRODUTO AND SB5.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT OUTER JOIN "+RetSqlName("SA5")+" SA5 ON SA5.A5_FILIAL = '"+xFilial("SA5")+"' AND SA5.A5_FORNECE = SC8.C8_FORNECE AND SA5.A5_LOJA = SC8.C8_LOJA AND SA5.A5_PRODUTO = SC8.C8_PRODUTO AND SA5.D_E_L_E_T_ = ' ' "
	cQuery += "INNER JOIN "+RetSqlName("SC1")+" SC1 ON SC1.C1_FILIAL = '"+xFilial("SC1")+"' AND SC1.C1_NUM = SC8.C8_NUMSC AND SC1.C1_ITEM = SC8.C8_ITEMSC AND SC1.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT OUTER JOIN "+RetSqlName("SY1")+" SY1 ON SY1.Y1_FILIAL = '"+xFilial("SC1")+"' AND SY1.Y1_COD = '"+_cUsuario+"' AND SY1.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SC8.C8_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "  AND SC8.C8_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "  AND SC8.C8_VALIDA <= '"+DTOS(MV_PAR05)+"' "
	cQuery += "  AND RTRIM(LTRIM(SC8.C8_NUMPED)) = '' "
	cQuery += "  AND SC8.C8_FILIAL = '"+xFilial("SC8")+"'  AND SC8.D_E_L_E_T_ = ' '  "
	cQuery += "ORDER BY SC8.C8_FORNECE, SC8.C8_ITEM, SC8.C8_NUMSC  "
	

TcQuery cQuery New Alias "QR1"


Do While !QR1->(EOF())
	
	IncRegua()
	
	cContato := QR1->C8_CONTATO
	cCotacao := QR1->C8_NUM
	dEmissao := StoD(QR1->C8_EMISSAO)
	IF SUBSTR(cNumEmp,1,2) = "15"
		//cEmail	:= IIF(!EMPTY(Alltrim(QR1->A2_MSEMAIL)),Alltrim(QR1->A2_MSEMAIL),"") - Alteração feita por campo não existir mais / Felipe Freitas
		cEmail	:= IIF(!EMPTY(Alltrim(QR1->A2_EMAIL2)),Alltrim(QR1->A2_EMAIL2),"")
	ELSE
		cEmail	:= IIF(!EMPTY(Alltrim(QR1->A2_EMAIL2)),Alltrim(QR1->A2_EMAIL2),"")
	ENDIF
	Cabecalho()
	
	ChecaLinha()
	@li, 00 PSAY "DESTINATARIO: "+QR1->A2_COD+"-"+QR1->A2_LOJA+" "+SubStr(QR1->A2_NOME,1,40) + SPACE(5) + "CONTATO.....: " + QR1->C8_CONTATO
	ChecaLinha()
	
	ChecaLinha()
	@li, 00 PSAY "E-mail......: "+cEmail
	
	ChecaLinha()
	@li, 00 PSAY "FONE........: "+QR1->A2_DDD+" "+Alltrim(QR1->A2_TEL)
	@li, 50 PSAY "Fax : "+QR1->A2_DDD+" "+QR1->A2_FAX
	ChecaLinha()
	
	ChecaLinha()
	@li, 00 PSAY Replicate("=",132)
	ChecaLinha()
	@li, 00 PSAY PADC("FAVOR FORNECER COTAÇÃO DOS ITENS ABAIXO:",limite)
	ChecaLinha()
	@li, 00 PSAY Replicate("=",132)
	ChecaLinha()
	
	@li, 00 PSAY "ITEM SOLIC. CODIGO          DESCRIÇÃO DA MERCADORIA                   QDE. UN | VLR.UNIT.| IPI | ENTREGA  OBSERVAÇÕES"
	
	ChecaLinha()
	@li, 00 PSAY Replicate("-",132)
	cUsuEmail 	:= Alltrim(QR1->Y1_NOME)+" - COMPRAS"
	
	cNumero := QR1->C8_NUM
	cFornece:= QR1->C8_FORNECE
	cLoja   := QR1->C8_LOJA
	cAssunto:= "C O T A C A O     N.o. "+QR1->C8_NUM
	cLin1	:= "Boa Tarde "+QR1->C8_CONTATO
	cLin2	:= "Segue Cotação    N.o. " + QR1->C8_NUM
	cLin3	:= "Att.: " + QR1->C8_FORNECE + " - " + QR1->A2_NOME + "    -    Contato: " + QR1->C8_CONTATO
	cLin4	:= "       Fone: ("+QR1->A2_DDD+") "+Alltrim(QR1->A2_TEL)+"  -  Fax: ("+QR1->A2_DDD + ") " + QR1->A2_FAX
	cLin5	:= "============================================================================================================================="
	cLin6	:= "                                         FAVOR FORNECER COTAÇÃO DOS ITENS ABAIXO:                                            "
	cLin7	:= "============================================================================================================================="
	cLin8	:= " ITEM----SOLIC------CODIGO-----DESCRICAO DA MERCADORIA-----------------------QDE.---UN---- VLR.UNIT------------IPI------ENTREGA----OBSERVAÇÕES"
	cLin9	:= ""//============================================================================================================================="
	cLin10	:= " "
	If cEmpAnt == "01"
		cLin11	:= "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO TEL " + ALLTRIM(SM0->M0_TEL) + " / FAX: " + ALLTRIM(SM0->M0_FAX) + " (Ramal 536)"
		cLin12	:= "ou e-mail: cotacao@masipack.com.br"
	ElseIf cEmpAnt $ "10" 
		cLin11	:= "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO TEL " + ALLTRIM(SM0->M0_TEL) + " / FAX: " + ALLTRIM(SM0->M0_FAX) + " (Ramal 381)"
		cLin12	:= "ou e-mail: cotacao@fabrima.com.br"
	ElseIf cEmpAnt $ "15" 
		cLin11	:= "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO TEL " + ALLTRIM(SM0->M0_TEL) + " / FAX: " + ALLTRIM(SM0->M0_FAX) + " (Ramal 800)"
		cLin12	:= "ou e-mail: cotacao@fabrima.com.br"
	ElseIf cEmpAnt == "40"
		cLin11	:= "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO TEL/FAX (47) 3425-0202"
		cLin12  := " "
	ElseIf cEmpAnt == "45"
		cLin11	:= "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO TEL/FAX (11) 4390-9955"
		cLin12  := " "
		//cLin12	:= "ou e-mail: cotacao@fabrima.com.br"
	Endif
	cLin13	:= "CASO NÃO RETORNE NESTE IMPRESSO, INFORME O NUMERO DESTA COTAÇÃO "+ QR1->C8_NUM
	cLin14	:= "CONDIÇÕES DE PAGAMENTO: _____________________________________________________________________________________________________"
	cLin15	:= "PRAZO DE ENTREGA..............: _____________________________________________________________________________________________________"
	cLin16	:= "VALIDADE DA PROPOSTA......: ______________________________________________% ICMS = _______________________________________________"
	IF cEmpAnt $ "01_10_15"
		cLin17  := "                                                                                                                           Eduardo P. Giannotti"
		cLin18	:= "                                                                                                                           Comprador"
	ELSE		
		cLin17  := "                                                                                                                                  Israel Duarte"
		cLin18	:= "                                                                                                                           Comprador"
	ENDIF
	nItem	:= 0
	cArqItem := ""					//Zera quando muda de Fornecedor
	
	//While !Eof() .And. C8_NUM == cNumero .And. cFornece == C8_FORNECE .And. C8_LOJA == cLoja
	Do While cNumero == QR1->C8_NUM .And. cFornece == QR1->C8_FORNECE .And. cLoja == QR1->C8_LOJA
		
		IncRegua()
		
		ChecaLinha()
		//@li, 00       PSAY QR1->C8_ITEMSC
		@li, 00       PSAY QR1->C8_ITEM
		@li, PCOL()+1 PSAY QR1->C8_NUMSC
		@li, PCOL()+1 PSAY QR1->C8_PRODUTO
		
		ImpDescr()
	 //	@li, 064      PSAY IIF(!EMPTY(QR1->C8_QTSEGUM),QR1->C8_QTSEGUM,QR1->C8_QUANT) Picture "999,999.99"
	 //	@li, PCOL()+1 PSAY IIF(!EMPTY(QR1->C8_SEGUM),QR1->C8_SEGUM,QR1->C8_UM) + " |          |     |"  
		@li, 064      PSAY QR1->C8_QUANT Picture "999,999.99"
		@li, PCOL()+1 PSAY QR1->C8_UM + " |          |     |"
		@li, PCOL()+1 PSAY StoD(QR1->C8_DATPRF)
		
		If !Empty(QR1->C8_OBS)
			ChecaLinha()                                                                                                                                                                 
			@ li,028 PSAY ALLTRIM(QR1->C8_OBS)
		endif
		
		if !Empty(QR1->B1_FABRIC)
			ChecaLinha()
			@ li,028 Psay "Fabricante: " + Alltrim(QR1->B1_FABRIC)
			@ li,078 PSAY "|" + SPACE(10) + "|" + SPACE(5) + "|"
		EndIf
		
		cTecInf := ""           
//		IF SUBSTR(cNumEmP,1,2) <> "15"
            //Ivandro Santos - 25/04/17 - Início da alteração
			//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
			If !Empty(QR1->B5_MSOBS)
				cTecInf := Alltrim(QR1->B5_MSOBS)
			EndIf
			/*If !Empty(QR1->B1_MSDTEC)
				cTecInf := Alltrim(QR1->B1_MSDTEC)
			EndIf			*/
			////Ticket#2017031037000107 — Fim da alteração
//		ENDIF	
		Li++
		If !Empty(cTecInf)
			For X := 1 TO MLCOUNT(cTecInf,35)
				//@ li,078 PSAY "|" + SPACE(10) + "|" + SPACE(5) + "|"
				checalinha()
				@li,028 PSay MEMOLINE(cTecInf,35,X)
			Next
		EndIf
		
		cFilEnt := QR1->C8_FILENT
		
		ChecaLinha()
		li+= 1
		@ li, 00 PSAY REPLICATE("-",132)
		//Itens para enviar e-mail
		dDATPRF := StoD(QR1->C8_DATPRF)
		
		cArqItem := cArqItem + (QR1->C8_ITEM+" -  "+QR1->C8_NUMSC+"  -  "+QR1->C8_PRODUTO+"  -  "+Substr(QR1->B1_DESC,1,35)+"  -  "+IIF(!EMPTY(QR1->C8_QTSEGUM),Transform(QR1->C8_QTSEGUM,"@E 9,999.99"),TRANSFORM(QR1->C8_QUANT,"@E 9,999.99"))+"  -  "+IIF(!EMPTY(QR1->C8_SEGUM),QR1->C8_SEGUM,QR1->C8_UM)+"  -  |___________| - |______|"+"  -  "+DtoS(dDATPRF)+"  -  "+ALLTRIM(QR1->C8_OBS)+chr(13)+chr(10))
		
		cCota	:= QR1->C8_NUM
		
		QR1->(dbSkip())
		
	EndDo
	cCorpo := 	cLin1  + CRLF + CRLF +;              //"Boa Tarde "+SC8->C8_CONTATO
	cLin2  + CRLF + CRLF +;              //"Segue Cotação    N.o. " + SC8->C8_NUM
	cLin3  + CRLF +;                     //"Att.: " + SC8->C8_FORNECE + " - " + SA2->A2_NOME + "    -    Contato: " + SC8->C8_CONTATO
	cLin4  + CRLF +;  	                //"Fone: ("+SA2->A2_DDD+") "+Alltrim(SA2->A2_TEL)+"  -  Fax: ("+SA2->A2_DDD + ") " + SA2->A2_FAX
	cLin5  + CRLF +;                     //"============================================================================================================================="
	cLin6  + CRLF +;						//"                                         FAVOR FORNECER COTAÇÃO DOS ITENS ABAIXO:                                            "
	cLin5  + CRLF +;                     //"============================================================================================================================="
	cLin8  + CRLF +;						//" ITEM----SOLIC------CODIGO-----DESCRICAO DA MERCADORIA-------------------------QDE.----UN---- VLR.UNIT----IPI----ENTREGA----OBSERVAÇÕES"
	cLin9  + CRLF +;
	cArqItem + CRLF + CRLF + CRLF +;
	cLin10 + CRLF + CRLF + CRLF + CRLF +;
	cLin5  + CRLF +;
	cLin11 + CRLF +;
	cLin12 + CRLF +;
	cLin13 + CRLF +;
	cLin5  + CRLF +;
	cLin14 + CRLF +;
	cLin15 + CRLF +;
	cLin16 + CRLF +;
	cLin17 + CRLF + CRLF +CRLF +;
	"Atenciosamente" + CRLF + CRLF +;
	cUsuEmail + CRLF + CRLF +;
	" ";
	
	lC8FilEnt := .F.                                   //Acessar o Endereco para Entrega do Arquivo de Empresa SM0.
	If QR1->(Eof()) .Or. cFilEnt != QR1->C8_FILENT
		dbSkip(-1)        											// Para ter Certeza que nao e Eof() ou trocou a filial
		lC8FilEnt := .T.  							   				// de Entrega
	Endif
	
	dbSelectArea("SM0")
	dbSetOrder(1)   && forca o indice na ordem certa
	nRegistro := Recno()
	dbSeek(SUBSTR(cNumEmp,1,2)+QR1->C8_FILENT)
	If lC8FilEnt .and. !QR1->(Eof())
		QR1->(dbSkip())
	Endif
	
	@48, 00 PSAY Replicate("=",132)
	@49, 00 PSAY PADC(cLin11,132)
	If SubStr(cNumEmp,1,2) == "01"
		@50, 00 PSAY PADC("ou E-mail: cotacao@masipack.com.br",132)
	ElseIf SubStr(cNumEmp,1,2) == "10"
		@50, 00 PSAY PADC("ou E-mail: cotacao@fabrima.com.br",132)
		//@50, 00 PSAY PADC("ou E-mail: followup@fabrima.com.br",132)
	ElseIf SubStr(cNumEmp,1,2) == "40"
		//@50, 00 PSAY PADC("ou E-mail: cotacao@fabrima.com.br",132)
	Endif
	@51, 00 PSAY PADC("CASO NÃO RETORNE NESTE IMPRESSO, INFORME O NUMERO DESTA COTAÇÃO: " + cNumero ,limite)
	@52, 00 PSAY Replicate("=",132)
	@54, 00 PSAY "CONDIÇÕES DE PAGAMENTO:" + Replicate("_",109)
	@56, 00 PSAY "PRAZO DE ENTREGA......:" + Replicate("_",109)
	@58, 00 PSAY "VALIDADE DA PROPOSTA..:" + Replicate("_",50) + "% ICMS = " + Replicate("_",50)
	@60, 00 PSAY "OBSERVAÇÕES...........:" + Replicate("_",109)
	IF SUBSTR(cNumEmp,1,2) $ "01_10_15"
		@61, 00 PSAY "                                                                                                    Eduardo P. Giannotti - Comprador"
	ELSE		
		@61, 00 PSAY "                                                                                                           Israel Duarte - Comprador"
	ENDIF
	@64,00 PSAY " "
	If mv_par13 == 1                                            //  Enviar e-mail caso o parâmetro esteja "Sim"
		If !Empty(cEmail)   							//  Clientes com e-mail
			EnvEmail()
		Endif
	Endif
	
	nPag := 1
	Loop
	
EndDo

SET DEVICE TO SCREEN

QR1->(dbCloseArea())

If aReturn[5] = 1   							 					// Se Saida para disco, ativa SPOOL
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±³Descri‡…o ³ Imprimir Valores da Cotacao.	 ³Sintaxe  ³ ImpValores(Void)±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

Static Function ImpValores()

//If nSegundaUnid == 2 .And. !Empty(QR1->C8_QTSEGUM)
If !Empty(QR1->C8_QTSEGUM)
	@li, 52 PSAY  QR1->C8_QTSEGUM Picture "99999999.99"
	@li, 64 PSAY  QR1->C8_SEGUM
Else
	@li, 52 PSAY  QR1->C8_QUANT Picture "99999999.99"
	@li, 64 PSAY  QR1->C8_UM
Endif

Return Nil

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ ImpDescr ³ Autor ³ Jose Lucas            ³ Data ³ 19.07.93 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Imprimir descricao do Produto.	  						  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function ImpDescr()

Local cDesc   := " "
Local cDescri := " "
Local nLinRef := 1

mv_par06:= Upper(mv_par06)

If AllTrim(mv_par06) == "B5_CEME"                           //Impressao da descricao cientifica do Produto.
	cDescri := QR1->B5_CEME
ElseIf AllTrim(mv_par06) == "A5_NOMPROD"
	cDescri := QR1->A5_NOMPROD
EndIf
If AllTrim(mv_par06) == "C1_DESCRI"        			//Impressao da descricao do produto do arquivo de Cotacoes.
	cDescri := QR1->C1_DESCRI
EndIf
If Empty(cDescri) 
	//Ivandro Santos - 06/04/17 - Início da alteração
	//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
	cDescri := QR1->B5_CEME
	/*IF SUBSTR(cNumEmp,1,2) <> "15"
		IF !EMPTY(QR1->B1_DESCP)
			cDescri := QR1->B1_DESCP
		ELSE
			cDescri := QR1->B1_DESC
		ENDIF  
	ELSE	
		cDescri := QR1->B1_DESC
	ENDIF*/
	If Empty(Alltrim(cDescri))
		cDescri := QR1->B1_DESC
	ENDIF
	//Ticket#2017031037000107 — Fim da alteração
EndIf

IF !EMPTY(QR1->A5_CODPRF)
	cDescri := ALLTRIM(cDescri) + " (" + ALLTRIM(QR1->A5_CODPRF)+ ")"
ENDIF

nBegin:=0
cDescri := ALLTRIM(cDescri)
@ li,028 PSAY SubStr(cDescri,1,35)
IF ALLTRIM(SUBSTR(cDescri,36,35))<>""
	//@ li,078 PSAY "|" + SPACE(10) + "|" + SPACE(5) + "|"
	//ChecaLinha()
	Li++
	@ li,028 PSAY SubStr(cDescri,36,35)
ENDIF
IF ALLTRIM(SUBSTR(cDescri,71,35))<> ""
	@ li,078 PSAY "|" + SPACE(10) + "|" + SPACE(5) + "|"
	ChecaLinha()
	@ li,028 PSAY SubStr(cDescri,71,35)
ENDIF
IF ALLTRIM(SUBSTR(cDescri,106,35))<>""
	@ li,078 PSAY "|" + SPACE(10) + "|" + SPACE(5) + "|"
	ChecaLinha()
	@ li,028 PSAY SubStr(cDescri,106,35)
ENDIF

Return Nil

//******************************
STATIC FUNCTION Cabecalho()
//******************************
Local cInsPict	:= "@E 999.999.999.999"
Local cCgcPict	:= "@R 99.999.999/9999-99"

If cEmpAnt == "01"
	@ 000,000 PSAY PADC(Alltrim(SM0->M0_NOMECOM),132)
	@ 001,000 PSAY PADC(AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT)+ " - " + SM0->M0_ESTENT,132)
	@ 002,000 PSAY PADC("TEL.: " + Alltrim(SM0->M0_TEL) + " FAX...: " + Alltrim(SM0->M0_FAX) + " (Ramal 536)",132)
	@ 003,000 PSAY PADC("CNPJ: " + Transform(SM0->M0_CGC,cCgcPict) + " IE.: " + SM0->M0_INSC,132)
	@ 004,000 PSAY PADC("E-Mail: cotacao@masipack.com.br",132)
ElseIf cEmpAnt == "10"
	@ 000,000 PSAY PADC(Alltrim(SM0->M0_NOMECOM),132)
	@ 001,000 PSAY PADC(AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT)+ " - " + SM0->M0_ESTENT,132)
	@ 002,000 PSAY PADC("TEL.: " + Alltrim(SM0->M0_TEL) + " FAX...: " + Alltrim(SM0->M0_FAX) + " (Ramal 381)",132)
	@ 003,000 PSAY PADC("CNPJ: " + Transform(SM0->M0_CGC,cCgcPict) + " IE.: " + SM0->M0_INSC,132)
	@ 004,000 PSAY PADC("E-Mail: cotacao@fabrima.com.br",132)
ELSEIF cEmpAnt == "15"
	@ 000,000 PSAY PADC(Alltrim(SM0->M0_NOMECOM),132)
	@ 001,000 PSAY PADC(AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT)+ " - " + SM0->M0_ESTENT,132)
	@ 002,000 PSAY PADC("TEL.: " + Alltrim(SM0->M0_TEL) + " FAX...: " + Alltrim(SM0->M0_FAX) + " (Ramal 800)",132)
	@ 003,000 PSAY PADC("CNPJ: " + Transform(SM0->M0_CGC,cCgcPict) + " IE.: " + SM0->M0_INSC,132)
	@ 004,000 PSAY PADC("E-Mail: cotacao@helsimplast.com.br",132)
ElseIf cEmpAnt == "40"
	@ 000,000 PSAY PADC(Alltrim(SM0->M0_NOMECOM),132)
	@ 001,000 PSAY PADC(AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT)+ " - " + SM0->M0_ESTENT,132)
	@ 002,000 PSAY PADC("TEL.: (" + Substr(SM0->M0_TEL,1,2) + ")" + Substr(SM0->M0_TEL,4,8) + "  (47) 3425-0202",132)  //FAX...: (" + Substr(SM0->M0_FAX,1,2) + ")" + Substr(SM0->M0_FAX,4,8) +" (Ramal 381)"
	@ 003,000 PSAY PADC("CNPJ: " + Transform(SM0->M0_CGC,cCgcPict) + " IE.: " + SM0->M0_INSC,132)
	//@ 004,000 PSAY PADC("E-Mail: cotacao@fabrima.com.br",132)
ElseIf cEmpAnt == "45"
	@ 000,000 PSAY PADC(Alltrim(SM0->M0_NOMECOM),132)
	@ 001,000 PSAY PADC(AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT)+ " - " + SM0->M0_ESTENT,132)
	@ 002,000 PSAY PADC("TEL.: (" + Substr(SM0->M0_TEL,1,2) + ")" + Substr(SM0->M0_TEL,4,8) + "  (11) 4390-9955",132) //    FAX...: (" + Substr(SM0->M0_FAX,1,2) + ")" + Substr(SM0->M0_FAX,4,8) +" (Ramal 381)"
	@ 003,000 PSAY PADC("CNPJ: " + Transform(SM0->M0_CGC,cCgcPict) + " IE.: " + SM0->M0_INSC,132)
EndIf
@ 005,000 PSAY Replicate("-",132)
@ 006,000 PSAY dEmissao
@ 006,053 PSAY "C O T A Ç Ã O   N.o " + cCotacao
@ 006,120 PSAY "Pagina: " + STRZERO(nPag++,4)
@ 007,000 PSAY Replicate("-",132)
li := 8

RETURN NIL

//********************************
STATIC FUNCTION ChecaLinha()
//********************************
IF li > 58
	Cabecalho()
ELSE
	li++
ENDIF

RETURN NIL

//*********************************
STATIC FUNCTION Envemail()						//Envio do e-mail caso o mv_par13 esteja "Sim"
//*********************************
LOCAL cArqItem 	:= ''														//Itens para enviar e-mail
//Local cServer   := 'smtp.masipack.com.br'
Local cServer   := 'smtp.gmail.com'
Local cConta  	:= 'masipack'                 //'mas.compras'
Local cEnvia    := 'pedidos.compras@masipack.com.br' //'masipack@masipack.com.br'
Local cSenha	:= 'achoice789'               //'dispbox12'
Local cRecebe   := IIF(SUBSTR(cNumEmp,1,2)<>"15",Alltrim(SA2->A2_EMAIL2),Alltrim(SA2->A2_MSEMAIL))
Local cAssunto	:= 'COTACAO N.o.'+ cCota+' - '+Substr(SA2->A2_NOME,1,15)    //MASIPACK - COTACAO N.cCota

//**** Se mv_par14 = Sim, gera arquivo de Log de envio dos e-mails ****************
Local cArqEnv := ("c:\cotacoes\"+(/*Substr(DTOS(Date()),3,2)+*/Substr(DTOS(Date()),5,2)+Substr(DTOS(Date()),7,2)+"-"+Substr(TIME(),1,2)+Substr(TIME(),4,2))+".txt")

If (cArqEnv	:= FCreate(cArqEnv)) == -1
	Alert("Arquivo não pode ser criado")
	Break
Else
	mv_par14 == 1
	FWrite(cArqEnv,cLinArq+chr(13)+chr(10))
	//*********************************************************************************
	//	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenha RESULT lConectou
	If lConectou
		MsgStop( "Conexão OK" )
		MAILAUTH(cEnvia,cSenha)			   									//servidor de e-mail requer autenticação de segurança
		SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY cCorpo RESULT lConectou
		If lConectou
			//******** arquivo de Log ******************
			cLinArq := ("Cot.: "+QR1->C8_NUMERO+" - Forn.: "+QR1->C8_FORNECE+"-"+Alltrim(QR1->A2_NOME)+" - E-mail: "+Alltrim(cEmail))+chr(13)+chr(10)
			FWrite(cArqEnv,cLinArq+chr(13)+chr(10))
			Qout("")
			//******************************************
			MsgStop( "Envio OK para "+Substr(QR1->A2_NOME,1,15))
		Else
			GET MAIL ERROR cSmtpError
			MsgSTop( "Erro de envio " + cSmtpError)
		Endif
		DISCONNECT SMTP SERVER
	Else
		GET MAIL ERROR cSmtpError
		MsgStop( "Erro de conexão : " + cSmtpError)
	Endif 												// FIM  E-MAIL
	Inkey(5)
	//*********** Arquivo de Log ***************
Endif
FClose(cArqEnv)
//******************************************
Return
