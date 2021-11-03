#Include "Rwmake.ch"
#Include "TbiConn.ch" 
#Include "TOPCONN.CH"                      

/*            
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ RFATR008  ³ Autor ³ Eduardo José Zanardo ³ Data ³ 26.12.01 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descricao ³Emissao do Pedido de Vendas (Tecnico)                       ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Alterado 16/02/2012 por Ana Paula QF - acrescentado Query
Alterado 13/01/2014 por Ana Paula QF - Padronização na impressão dos relatórios
Alterado 25/04/2014 por Eduardo Mantoan  - Correção na query e lógica. Ajustes na impressão do relatório
/*/

User Function RFATR008(cNumPed)                                                                               

//************************
// Define Variaveis
//************************

Private aReturn    := {"Zebrado",1,"Administracao",1,2,1,"",0 }  
Private cString    := "SA6" 
Private Tamanho    := "M" 
Private Titulo     := "Emissao da Relacao dos Pedidos"
Private nomeprog   := "RFATR008"
Private cPerg      := "XRFATR008 "        
Private wnrel      := "RFATR008"
PRIVATE cabec1      := ""
PRIVATE cabec2      := ""
Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cUsuSenha := ""
Private _cDeptoUsu := ""
Private cDesc1     := "Emissao da Relacao dos pedidos de venda, de acordo com"
Private cDesc2     := "intervalo informado na opcao Parametros."
Private cDesc3     := " "
Private Li         := 7000
Private cDescr     := ""
Private m_pag      := 0     // Contador de Paginas
Private lEnd       := .F.   // Controle de cancelamento do relatorio
Private nLastKey   := 0     // Controla o cancelamento da SetPrint e SetDefault
Private cObs       := ""
Private aCategoria := {"Reaberto","Comercial","Comex","Venda de Peças","Outros","Maklaser","Assist.Tecnica"}
Private dDtEntrega := STOD("")
Private cPEDSC5    := ""

//**************************************
// Verifica as Perguntas Seleciondas
//**************************************

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario := PswRet()
   _cUsuSenha := UsrRetName(_cUsuario)
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif   	
	
oFont1 := TFont():New("Courier New",,11,,.F.,,,,,.F.) 
oFont2 := TFont():New("Courier New",,20,,.T.,,,,,.F.)
oFont3 := TFont():New("Courier New",,10,,.F.,,,,,.F.)
oFont4 := TFont():New("Arial",,11,,.F.,,,,,.F.) 
oFont5 := TFont():New("Courier New",,9,,.F.,,,,,.F.) 

RptStatus({|lEnd| _ImpFATR08() })

Return(.T.)

//********************************
	Static Function _ImpFATR08()                                                                             
//********************************

Local X

oPrn := TMSPrinter():New("RFATR008") 

oPrn:SetPortrait() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Do Numero                                        ³
//³ mv_par02    Ate o Numero                                     ³
//³ mv_par03    Imprime Acompanhamento de PV                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf

_cQuery := "SELECT SC5.C5_TIPO,    SC5.C5_MSMONTA, SC5.C5_MSTPVEN, SC5.C5_MSTEND, SC5.C5_MSCATEG,SC5.C5_MSTPVEN,SC5.C5_MSNORMA, " 
_cQuery += "       SC5.C5_MSMULTA, SC5.C5_MSVISIT, SC5.C5_MSPOSIC, SC5.C5_TRANSP, SC5.C5_ORCAM,  SC5.C5_VEND1,  SC5.C5_CLIENTE, " 
_cQuery += "       SC5.C5_LOJACLI, SC5.C5_MSLINK,  SC5.C5_HZ,      SC5.C5_MSTEND, SC5.C5_MSLUM,  SC5.C5_COR,    SC5.C5_PINTURA, " 
_cQuery += "       SC5.C5_EMB,     SC5.C5_MSLAYOU, SC5.C5_EMISSAO, SC5.C5_MSDTPEN,SC5.C5_MSDTLBF,SC5.C5_MSDTENT, " 
_cQuery += "       SC5.C5_MSRT,    SC5.C5_MSERT,   SC5.C5_TRIFASI, SC5.C5_VOLTAGE,SC5.C5_VEND1,  SC5.C5_MSGARAN,SC5.C5_NUM, " 
_cQuery += "       SC6.C6_NUM,     SC6.C6_ITEM,    SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_MSITORC,SC6.C6_QTDVEN, SC6.C6_UM,  " 
_cQuery += "       SC6.C6_MSDTLIB, SC6.C6_MSOBS, " 
_cQuery += "       SA1.A1_ENDENT,  SA1.A1_END,     SA1.A1_COD,     SA1.A1_LOJA,   SA1.A1_CEPE,    SA1.A1_MUNE,  SA1.A1_ESTE, SA1.A1_TEL, " 
_cQuery += "       SA1.A1_EMAIL2,  SA1.A1_CONTATO, SA3.A3_NREDUZ,  SA3.A3_NOME,   " 
//Ivandro Santos - 04/04/2017 - Início da alteração
//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
_cQuery += "       SB1.B1_LOCAL,   SB1.B1_PE,      SB1.B1_TIPE,    SB1.B1_DESC,   SB1.B1_ETIQUET, SB5.B5_CEME, SB1.B1_MSGRVEN, "
//_cQuery += "       SB1.B1_LOCAL,   SB1.B1_PE,      SB1.B1_TIPE,    SB1.B1_DESC,   SB1.B1_ETIQUET, SB1.B1_DESCP, SB1.B1_MSGRVEN, "
_cQuery += "       SA4.A4_NOME     " 
_cQuery += "FROM "+RetSqlName("SC5")+" SC5 " 
_cQuery += "INNER JOIN      "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL='"+xFilial("SC6")+"' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' " 
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE And SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' " 
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " 
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL='"+xFilial("SB5")+"' AND SB5.B5_COD = SC6.C6_PRODUTO AND SB5.D_E_L_E_T_ = ' ' " 
//Ticket#2017031037000107 — Fim da alteração
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL='"+xFilial("SA3")+"' AND SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SA4")+" SA4 ON SA4.A4_FILIAL='"+xFilial("SA4")+"' AND SA4.A4_COD = SC5.C5_TRANSP AND SA4.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE SC5.C5_FILIAL='" + xFilial("SC5")+"' "
_cQuery += "  AND SC5.C5_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "   
_cQuery += "  AND SC6.C6_ITEM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "   
_cQuery += "  AND SC5.D_E_L_E_T_ = ' ' "
_cQuery += "ORDER BY SC5.C5_NUM, SC6.C6_ITEM " 

TcQuery _cQuery New Alias "QR1"

dbGotop()
nTReg := QR1->(RecCount())
ProcRegua(nTReg)

// Inicia a Impressao       
If lEnd
   Alert("CANCELADO PELO OPERADOR") 
   Return
EndIf 

cPedSC5 := QR1->C5_NUM
cabec1      := " CARACTERISTICAS DOS PRODUTOS "
cabec2      := " .... "
Do While !QR1->(Eof())

	ImpCabec()

	Do While cPedSC5 = QR1->C5_NUM 

		If Li > 2900
			oPrn:EndPage()
			ImpTitulo()
			oPrn:Say (Li,0300,"PEDIDO DE VENDA: " +cPedSC5,oFont1)
			Li +=60
			oPrn:Say (Li,0010,"IT Produto       Grp Etiq Descrição",oFont3)
			oPrn:Say (Li,1780,"Orcam   Qtde. UN  Entrega",oFont3)
			Li+=50
			oPrn:Say (Li,0010,Replicate("=",125),oFont1)
			Li+=50
		EndIf	
		
		Li+=50
		oPrn:Say (Li,0010,QR1->C6_ITEM,oFont3)
		oPrn:Say (Li,0065,QR1->C6_PRODUTO,oFont3)
		    
		cDescr   := QR1->C6_DESCRI
		//Ivandro Santos - 04/04/2017 - início da alteração
		//Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
		cDescrP  := Alltrim(QR1->B5_CEME)  //cDescrP  := Alltrim(QR1->B1_DESCP)                        
		//Ticket#2017031037000107 — Fim da alteração
		
		oPrn:Say (Li,0400,QR1->B1_MSGRVEN,oFont3)
		oPrn:Say (Li,0480,QR1->B1_ETIQUET,oFont3)

		If cDescrP <> ""
			oPrn:Say (Li,0530,SubStr(cDescrP,1,55),oFont3)
		Else
			oPrn:Say (Li,0530,SubStr(cDescr,1,55),oFont3)
		EndIf
			
		oPrn:Say (Li,1870,QR1->C6_MSITORC,oFont3)     
		oPrn:Say (Li,1900,Transform(QR1->C6_QTDVEN	,"@E 999,999"),oFont3)
		oPrn:Say (Li,2090,QR1->C6_UM,oFont3)
		oPrn:Say (Li,2175,DTOC(dDtEntrega),oFont3)
		
		If cDescrP <> ""
			If Len(cDescrP) > 55
				Li+=50
				oPrn:Say (Li,0530,SubStr(cDescrP,56,49),oFont3)  
			EndIf
		Else
			If Len(cDescr) > 55
				Li+=50
				oPrn:Say (Li,0530,SubStr(cDescr,56,49),oFont3)  
			EndIf
		EndIf	
		nCol := 10
		Li+=50
		
		IF QR1->C5_MSTPVEN $ "AC_RE_OU_AT" .AND. !EMPTY(QR1->B1_LOCAL)
			oPrn:Say (Li,nCol,"Local: " + QR1->B1_LOCAL,oFont3)
			nCol := 530
		ENDIF
		
		oPrn:Say (Li,nCol,"Prazo: " + STR(QR1->B1_PE,5,0) + " " + QR1->B1_TIPE,oFont3)
		If !Empty(QR1->C6_MSDTLIB)
			Li+=50
			dMSDTLIB := StoD(QR1->C6_MSDTLIB)
			oPrn:Say (Li,10,"Liberado pela Engenharia em ",oFont3)
			oPrn:Say (Li,630,DtoC(dMSDTLIB),oFont3)		
		ENDIF         
		If !Empty(QR1->C6_MSOBS)
			Li+=50
			oPrn:Say (Li,0530,"Obs.: " + Alltrim(QR1->C6_MSOBS),oFont3)
		EndIf
		   
		If SubStr(QR1->C6_PRODUTO,1,2) == "PV" .OR. SubStr(QR1->C6_PRODUTO,1,2) == "MQ" 
			Li+=50
			
			If Select("QR2") > 0 
			   DbSelectArea("QR2")
			   DbCloseArea()
			EndIf
			                                               
			_cQuery := "SELECT SG1.G1_COD, SG1.G1_COMP, SG1.G1_QUANT, SB1.B1_DESC, SB1.B1_ETIQUET  " 
			_cQuery += "FROM "+RetSqlName("SG1")+" SG1 " 
			_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD=SG1.G1_COMP AND SB1.D_E_L_E_T_ = ' ' " 
			_cQuery += "WHERE SG1.G1_FILIAL='" + xFilial("SG1")+"' AND SG1.D_E_L_E_T_ = ' ' "  
			_cQuery += "  AND SG1.G1_COD ='"+QR1->C6_PRODUTO+"' "
			_cQuery += "ORDER BY SG1.G1_COD " 
			
			TcQuery _cQuery New Alias "QR2"
			
			Do While !QR2->(Eof()) .And. (QR1->C6_PRODUTO == QR2->G1_COD)
//				If Li > 3200
				If Li > 2900
					oPrn:EndPage() 
					ImpTitulo()
					Li += 100 
				EndIF
				oPrn:Say (Li,0010,Alltrim(QR2->G1_COMP),oFont3)
				oPrn:Say (Li,0530,QR2->B1_DESC ,oFont3)
				oPrn:Say (Li,1700,Transform(QR2->G1_QUANT,"@E 999.9999"),oFont3)
				If QR2->B1_ETIQUET == "S"
					oPrn:Say (Li,1950,"ETIQ",oFont3)
				EndIf
				Li+=100
				oPrn:Say (Li,0010,Replicate("-",125),oFont1) 
				Li+=100
				QR2->(DbSkip())
				Loop
			EndDo
			
		EndIf         
		
		Li+=50
		//oPrn:Say (Li,0010,Replicate("-",125),oFont1)

		QR1->(dbSkip())	
	
	Enddo

	Li+=50
	If Li > 3100
		ImpTitulo()
	EndIf 

	If _cDeptoUsu = '201'
		Li+=100
		oPrn:Say (Li,0010,"Visto da Montagem: _________________________",oFont1)
		oPrn:Say (Li,1200,"Visto da Expedição: _________________________",oFont1)
	EndIf
   Li+=80
   //soPrn:Say (Li,0010,Replicate("-",125),oFont1)
   Li := 3900
   If QR1->C5_MSCATEG == "1" .AND. SubStr(cNumEmp,1,2) $ "01_10" 
		GravaSZM() 
   EndIf
	
	If MV_PAR04 == 1
		If Li > 3000
			oPrn:EndPage()
			ImpTitulo() 
			oPrn:Say (Li,0400,"PEDIDO DE VENDA: " + cPedSC5,oFont1)
		EndIf   
		Li+=80
	
		// Imprime acompanhamento do pedido
		SC5->(dbSetOrder(1))                           
		If SC5->(DbSeek(xFilial()+cPEDSC5))
			If !Empty(SC5->C5_OBS)
				oPrn:Say (Li,0010,"O B S E R V A Ç O E S",oFont1)
				Li+=50
				oPrn:Say (Li,0010,"=====================",oFont1)
				Li+=50
				FOR X := 1 TO MLCOUNT(SC5->C5_OBS,110)
					If Li > 2900 //3200
						oPrn:EndPage()
						ImpTitulo() 
						oPrn:Say (Li,0400,"PEDIDO DE VENDA: " + cPedSC5,oFont1)
						Li+=80
						oPrn:Say (Li,0010,"OBSERVAÇÕES (CONTINUAÇÃO)",oFont1)
						Li+=50
						oPrn:Say (Li,0010,Replicate("=",23),oFont1)
						Li+=80
					EndIf    
					oPrn:Say (Li,0050,MEMOLINE(SC5->C5_OBS,110,X),oFont3)
					Li+=50
				NEXT
			EndIf
		
			//If Li > 3100
			If Li > 2900
				oPrn:EndPage() 
				ImpTitulo()
			EndIf   
			Li+=50
			If SubStr(cNumEmp,1,2) $ "01_10"
				If !Empty(SC5->C5_MSPEND)
					oPrn:Say (Li,0010,"P E N D E N C I A S",oFont1)
					Li+=50
					oPrn:Say (Li,0010,"===================",oFont1)
					Li+=50

					FOR X := 1 TO MLCOUNT(SC5->C5_MSPEND,80)
						//If Li > 3200
						If Li > 2900
							oPrn:EndPage() 
		               ImpTitulo()
							oPrn:Say (Li,0400,"PEDIDO DE VENDA: " + cPedSC5,oFont1)
							Li+=80
			            oPrn:Say (Li,0010,"PENDENCIAS (CONTINUAÇÃO)",oFont1)
			            Li+=50
			            oPrn:Say (Li,0010, Replicate("=",22),oFont1)
			            Li+=80
						EndIf    
						oPrn:Say (Li,0050,MEMOLINE(SC5->C5_MSPEND,80,X),oFont3)
			         Li+=50
					NEXT
				EndIf
				If mv_par03 <> 3              
					//If Li > 3200
					If Li > 2900
						oPrn:EndPage()
						ImpTitulo()
						Li+=50
					EndIf 
					SZM->(dbSetOrder(1))                           // Imprime acompanhamento do pedido
					If SZM->(DbSeek(xFilial()+cPedSC5))
						oPrn:Say (Li,0010,Replicate("*",49) + "  Acompanhamento do Pedido  " + Replicate("*",49),oFont3)
						Li+=30
						fImp := .F.
						Do While !SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(cPedSC5)
							If mv_par03 == 2 .Or. (mv_par03 == 1 .And. SZM->ZM_STATUS <> "E") .And. !Empty(SZM->ZM_EVENTO)
								fImp := .T.
							EndIf   
							If fImp 
								ImpAcompaPV()
							Else                                                                               
								Li+=50
								oPrn:Say (Li,0010,"Não há eventos em aberto para este Pedido",oFont1)
							EndIf
					      SZM->(DbSkip())
							Loop  
						Enddo
					EndIf   
				EndIf
		    EndIf
		EndIf
	EndIf
Enddo

oPrn:EndPage()     // Finaliza a pagina

oPrn:Preview()     // Video

oPrn:End()

QR1->(DbCloseArea())
SC5->(DbSetOrder(1))

MS_FLUSH()   //Libera fila de relatorios em spool (Tipo Rede Netware)

Return .T.

//********************************
	Static Function ImpCabec()
//********************************

_cNomCli := ""
_cNReduz := ""
cPedSC5  := ""

If QR1->C5_TIPO <> "N"
 	SA2->(dbSetOrder(1))
  	SA2->(dbSeek(xFilial()+QR1->C5_CLIENTE+QR1->C5_LOJACLI))
	_cNomCli := Alltrim(SA2->A2_NOME)
  	_cNReduz := Alltrim(SA2->A2_NREDUZ)
Else	
  	SA1->(dbSetOrder(1))
  	SA1->(dbSeek(xFilial()+QR1->C5_CLIENTE+QR1->C5_LOJACLI))
	_cNomCli := SubStr(SA1->A1_NOME,1,35)
   _cNReduz := Alltrim(SA1->A1_NREDUZ)
Endif

ImpTitulo()

cPEDSC5 := QR1->C5_NUM

oPrn:Say (200,0010,"Pedido: "+QR1->C5_NUM,oFont1)
If QR1->C5_MSLINK <> QR1->C5_NUM
   oPrn:Say (300,0380,"Orig.:" + QR1->C5_MSLINK,oFont1)
EndIf  	
oPrn:Say (200,0700,_cNomCli,oFont1)
oPrn:Say (200,1600,"Nome Reduzido: " + _cNReduz,oFont1)

//Li=+100
If SubStr(cNumEmp,1,2) $ "01_10"
	oPrn:Say (250,0010,"Categ.: "+QR1->C5_MSCATEG+"-"+aCategoria[Val(QR1->C5_MSCATEG)+1],oFont1)  
EndIf
IF !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT # SA1->A1_END
   oPrn:Say (250,0700,SA1->A1_ENDENT,oFont1)
Else  
   oPrn:Say (250,0700,SA1->A1_END,oFont1)
EndIf
oPrn:Say (300,0010,"Cliente:" + SA1->A1_COD+"/"+SA1->A1_LOJA,oFont1)
oPrn:Say (300,0700, IF( !Empty(SA1->A1_CEPE) .And. SA1->A1_CEPE # SA1->A1_CEP,SA1->A1_CEPE, SA1->A1_CEP),oFont1)
oPrn:Say (300,1000, IF( !Empty(SA1->A1_MUNE) .And. SA1->A1_MUNE # SA1->A1_MUN,SA1->A1_MUNE, SA1->A1_MUN),oFont1)
oPrn:Say (300,1650, IF( !Empty(SA1->A1_ESTE) .And. SA1->A1_ESTE # SA1->A1_EST,SA1->A1_ESTE, SA1->A1_EST),oFont1)
oPrn:Say (350,0700,"Fone:" + SA1->A1_TEL + " Fax:" + SA1->A1_FAX ,oFont5)
oPrn:Say (350,1650,"E-mail:" + SubStr(SA1->A1_Email2,1,35),oFont5)
oPrn:Say (400,0700,"Contato:" + SA1->A1_CONTATO,oFont1)
oPrn:Say (450,0700,"Responsável Técnico:" + QR1->C5_MSRT,oFont1)
oPrn:Say (500,0700,"Email Resp. Técnico:" + QR1->C5_MSERT,oFont1)

If (QR1->C5_TRIFASI) = 'F'
	cTrifasico := 'N'
Else
	cTrifasico := 'S'
EndIf

oPrn:Say (580,0010,"Trifasico? "+ cTrifasico,oFont1) 
oPrn:Say (580,0330,"Tensao:" + STR(QR1->C5_VOLTAGE,3) + " V",oFont1) 
oPrn:Say (580,0700,"Frequencia:" + STR(QR1->C5_HZ,3) + " HZ",oFont1)

If SubStr(cNumEmp,1,2) $ "01_10"
	If QR1->C5_MSTEND = 'F'
		cMSTEND := 'N'
	Else
		cMSTEND := 'S'
	EndIf
	oPrn:Say (580,1130,"Tendencia: " + cMSTEND,oFont1)
	
	If QR1->C5_MSLUM = 'F'
		cMSLUM := 'N'
	Else
		cMSLUM := 'S'
	EndIf	
	oPrn:Say (580,1450, "Luminaria: " + cMSLUM,oFont1)
	
   If Alltrim(QR1->C5_COR) == "TIT"
      oPrn:Say (660,0010,"Cor: TITANIO",oFont1)
   ElseIf Alltrim(QR1->C5_COR) == "BCO"
      oPrn:Say (660,0010,"Cor: BRANCO",oFont1)
   ElseIf Alltrim(QR1->C5_COR) == "PRE"
      oPrn:Say (660,0010,"Cor: PRETO",oFont1)   
   ElseIf Alltrim(QR1->C5_COR) == "AMA"
      oPrn:Say (660,0010,"Cor: AMARELO",oFont1) 
   ElseIf Alltrim(QR1->C5_COR) == "AZU"
      oPrn:Say (660,0010,"Cor: AZUL",oFont1)
   ElseIf Alltrim(QR1->C5_COR) == "VRD"
      oPrn:Say (660,0010,"Cor: VERDE",oFont1)
   EndIf              
   oPrn:Say (660,0320,"Tipo Pintura:" + QR1->C5_PINTURA,oFont1)
	
	If QR1->C5_EMB = 'F'
		cMSEMB := 'N'
	Else
		cMSEMB := 'S'
	EndIf	
	oPrn:Say (660,0700,"Embalagem:" + cMSEMB,oFont1)    
	
   oPrn:Say (660,1450,"LAY-OUT.:" + QR1->C5_MSLAYOU,oFont1)
EndIf

oPrn:Say (740,0010,"Emissao: ",oFont1)
dDtEmissao := StoD(QR1->C5_EMISSAO) 
oPrn:Say (740,200,DTOC(dDtEmissao),oFont1)

dDtEntrega := StoD(QR1->C5_MSDTENT)
If SubStr(cNumEmp,1,2) $ "01_10"
   If !Empty(QR1->C5_MSDTPEN)
      dDtEntrega := StoD(QR1->C5_MSDTPEN)
   EndIf   
EndIf

oPrn:Say (740,0700,"Entrega: ",oFont2)
oPrn:Say (740,1040,DtoC(dDtEntrega),oFont2)
If SubStr(cNumEmp,1,2) $ "01_10"
   If ! Empty(QR1->C5_MSDTLBF)
      oPrn:Say (740,1450,"Liberado para faturar : " ,oFont1)
      oPrn:Say (740,1650, DTOC(QR1->C5_MSDTLBF),oFont1)
   Else
      oPrn:Say (740,1450,"Liberado para faturar : Sem liberação",oFont1)
   EndIf   
EndIf

oPrn:Say (810,0010,"C.E. No.: " + QR1->C5_ORCAM,oFont1)
oPrn:Say (810,0700,"Vendedor: ",oFont1)
oPrn:Say (810,930,AllTrim(QR1->C5_VEND1) + " - " + SubStr(QR1->A3_NOME,1,30),oFont1)  //910

If SubStr(cNumEmp,1,2) $ "01_10" 
   oPrn:Say (810,1700,"Tipo de Venda: " + QR1->C5_MSTPVEN,oFont1)
   oPrn:Say (850,0010,"Norma Tecnica: " + QR1->C5_MSNORMA,oFont1)
   oPrn:Say (910,0010,"***********************************  A   T   E   N   Ç   Ã   O   ***********************************",oFont1)
   oPrn:Say (950,0010,"Multa no contrato: ",oFont1)
   If QR1->C5_MSMULTA == "S"
      oPrn:Say (950,0460,"Sim",oFont1)
   Else
      oPrn:Say (950,0460,"Não",oFont1)
   EndIf

   oPrn:Say (950,0700,"Visita do Cliente: ",oFont1)
   If QR1->C5_MSVISIT == "S"
      oPrn:Say (950,1150,"Sim",oFont1)
   Else
      oPrn:Say (950,1150,"Não",oFont1)
   EndIf 

   If QR1->C5_MSGARANT > 0 
      oPrn:Say (950,1700,"Garantia: " + Alltrim(Str(QR1->C5_MSGARANT)) + " meses",oFont1)
   EndIf

   If !Empty(QR1->C5_MSPOSIC)
      oPrn:Say (1000,0010,"Posição do Pedido: " + QR1->C5_MSPOSIC,oFont1) 
   EndIf                     
EndIf 

oPrn:Say (1050,0010,"Transportadora: " + AllTrim(QR1->C5_TRANSP)+" - "+QR1->A4_NOME,oFont1)
oPrn:Say (1100,0010,Replicate("*",125),oFont1)
oPrn:Say (1150,0010,"PRODUTOS DO CLIENTE: ",oFont3)
oPrn:Say (1200,0010,Replicate("=",125),oFont1) 
oPrn:Say (1250,0010,"Produto",oFont3)
oPrn:Say (1250,0450,"Peso/Volume",oFont3)
oPrn:Say (1250,0750,"Embalagem",oFont3)
oPrn:Say (1250,1090,"Material",oFont3)
oPrn:Say (1250,1450,"Dimensão",oFont3)
oPrn:Say (1250,1700,"Produção(p/min)",oFont3)
oPrn:Say (1250,2050,"Planta Embal.",oFont3)
oPrn:Say (1300,0010,Replicate("=",125),oFont1)

Li:=1300

If SubStr(cNumEmp,1,2) $ "01_10"
   SZ4->(dbSetOrder(1))
   //SZ4->(dbSeek(xFilial("SZ4")+cPedido))  //cPEDSC5
   //While SZ4->(!Eof()) .And. SZ4->Z4_PEDIDO == cPedido
   SZ4->(dbSeek(xFilial("SZ4")+cPEDSC5)) 
   Do While SZ4->(!Eof()) .And. SZ4->Z4_PEDIDO == cPEDSC5    
      Li+=50
      oPrn:Say (Li,0010,SZ4->Z4_PRODUTO,oFont5)
      oPrn:Say (Li,0450,SZ4->Z4_PESOVOL,oFont5)
      If !Empty(SZ4->Z4_MODEMB)
         If SX5->(DbSeek(xFilial("SX5")+"Z2"+SZ4->Z4_MODEMB))
            oPrn:Say (Li,0750,SubStr(X5DESCRI(),1,18),oFont5)
         Else
            oPrn:Say (Li,0750,"Emb.não cadast.",oFont5)
         EndIf   
      EndIf
      If Empty(SZ4->Z4_MATER) 
         If SX5->(DbSeek(xFilial("SX5")+"Z6"+SZ4->Z4_MATEMB))
            oPrn:Say (Li,1090,SubStr(X5DESCRI(),1,18),oFont5)
         EndIf
      Else
         oPrn:Say (Li,1090,SZ4->Z4_MATER,oFont5)
      EndIf   
      oPrn:Say (Li,1450,SZ4->Z4_DIMEMB,oFont5)
      oPrn:Say (Li,1820,SZ4->Z4_RENDESP,oFont5)
      oPrn:Say (Li,2120,SZ4->Z4_PLANEMB,oFont5)
      SZ4->(DbSkip())
   EndDo
EndIf

If Li > 2900
   oPrn:EndPage()
   ImpTitulo()
EndIf   

Li+=50 
oPrn:Say (Li,0010,Replicate("*",125),oFont1)

Li+=50
oPrn:Say (Li,0010,"CARACTERISTICAS DOS PRODUTOS",oFont1)

Li+=50
oPrn:Say (Li,0010,Replicate("=",125),oFont1)

Li+=50     
oPrn:Say (Li,0010,"IT Produto       Grp Etiq Descrição",oFont3)
oPrn:Say (Li,1780,"Orcam   Qtde. UN  Entrega",oFont3)

Li+=50
oPrn:Say (Li,0010,Replicate("*",125),oFont1)

Li+=50

Return( .T. )

/***********************************/
Static Function ImpAcompaPV()
/***********************************/
Local cVendedor := "Não cadastrado" 
Local nTarefa   := 0
Local X

cVendedor :=  SubStr(QR1->A3_NREDUZ,1,15)
 
Li+=50                                                                    
If SZM->(DbSeek(xFilial()+cPedSC5))
	oPrn:Say (Li,0010,"Pedido: " + SZM->ZM_PEDIDO,oFont3)
	oPrn:Say (Li,0370,"Cliente: " + SubStr(SZM->ZM_CLIENTE,1,15),oFont3)
	oPrn:Say (Li,1200,"Vendedor.......: " + cVendedor,oFont5)
	Do While ! SZM->(Eof()) .And. Alltrim(SZM->ZM_PEDIDO) == cPedSC5
		If mv_par03 == 2 .Or. (mv_par03 == 1 .And. SZM->ZM_STATUS <> "E")
			If !Empty(Alltrim(SZM->ZM_EVENTO))
				nTarefa++
				Li+=50
				//If Li > 3200
				If Li > 2900
					oPrn:EndPage()
					ImpTitulo()
				Else
					If nTarefa > 1
						oPrn:Say (Li,0100,Replicate("-",121),oFont3)
						Li+=50
					EndIf
				EndIf
				oPrn:Say (Li,0160,"De....: " + SZM->ZM_DEPTO,oFont5)
				oPrn:Say (Li,0730,"Emitente...:" + SubStr(SZM->ZM_MSUSER,1,13),oFont5)
				oPrn:Say (Li,1200,"Emissão:" + DTOC(SZM->ZM_DATA),oFont5)
				oPrn:Say (Li,1550,"Ult.Atualização:"+DTOC(SZM->ZM_ULTALT),oFont5)
				oPrn:Say (Li,2060,"Status:",oFont5)
				If SZM->ZM_STATUS == "A"
					oPrn:Say (Li,2200,"Aberto",oFont5)
				ElseIf SZM->ZM_STATUS == "P"
					oPrn:Say (Li,2200,"Em Processo",oFont5)
				ElseIf SZM->ZM_STATUS == "E"
					oPrn:Say (Li,2200,"Encerrado",oFont5)
				ElseIf SZM->ZM_STATUS == "R"
					oPrn:Say (Li,2200,"Reavaliar",oFont5)
				EndIf                                                                                   
				
				Li+=80
				oPrn:Say (Li,0160,"Para..: " + SZM->ZM_DEPTDES,oFont5)
				oPrn:Say (Li,0730,"Resposta p/:" + DTOC(SZM->ZM_DTPREV),oFont5)
				If SZM->ZM_STATUS == "E"
					oPrn:Say (Li,1200,"Tarefa realizada:",oFont5)
					If (SZM->ZM_DTPREV - SZM->ZM_ULTALT) >= 0
						oPrn:Say (Li,1500,"No prazo",oFont5)
					Else
						If !Empty(SZM->ZM_ULTALT) .And. SZM->ZM_ULTALT > SZM->ZM_DTPREV
							oPrn:Say (Li,1500,"com ",oFont5)
							oPrn:Say (Li,1550,Transform((SZM->ZM_ULTALT - SZM->ZM_DTPREV),"@E 99"),oFont5)
							oPrn:Say (Li,1600,"dia(s) de atraso",oFont5)
						EndIf
					EndIf
				EndIf
				Li+=80
				//If Li > 3200
				If Li > 2900
					oPrn:EndPage()
					ImpTitulo()
					oPrn:Say (Li,0010,SZM->ZM_PEDIDO,oFont3)
				EndIf
				oPrn:Say (Li,0160,"Tarefa: ",oFont3)
				For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_EVENTO),80)
					//If Li > 3200
					If Li > 2900
						oPrn:EndPage()
						ImpTitulo()
						oPrn:Say (Li,0010,SZM->ZM_PEDIDO,oFont3)
						oPrn:Say (Li,0160,"Tarefa: ",oFont3)
					EndIf
					oPrn:Say (Li,0330,MEMOLINE(Alltrim(SZM->ZM_EVENTO),80,X),oFont3)
					Li+=50
				Next
				Li+=50
				If !Empty(Alltrim(SZM->ZM_COMENT))
					//If Li > 3200
					If Li > 2900
						oPrn:EndPage()
						ImpTitulo()
						oPrn:Say (Li,0010,SZM->ZM_PEDIDO,oFont3)
						oPrn:Say (Li,0160,"Comentario do Destino: ",oFont3)
					Else
						oPrn:Say (Li,0160,"Comentario do Destino: ",oFont3)
					EndIf
					For X := 1 TO MLCOUNT(Alltrim(SZM->ZM_COMENT),80)
						//If Li > 3200
						If Li > 2900
							oPrn:EndPage()
							ImpTitulo()
							oPrn:Say (Li,0010,SZM->ZM_PEDIDO,oFont3)
							oPrn:Say (Li,0160,"Comentario do Destino: ",oFont3)
						EndIf
						oPrn:Say (Li,0670,MEMOLINE(Alltrim(SZM->ZM_COMENT),80,X),oFont3)
						Li+=50
					Next
					If !Empty(SZM->ZM_DTACEIT)
						oPrn:Say (Li,0160,"Concluido em: "+ DTOC(SZM->ZM_DTACEIT)  + "  Usuario: "+ SZM->ZM_USUACEI,oFont3)
						Li+=50
					EndIf
				EndIf
			EndIf
		EndIf

		SZM->(DbSkip())
		Loop

	EndDo
EndIf
  
Return

//*******************************
	Static Function ImpTitulo()
//*******************************
If Li < 4000
	oPrn:EndPage()
EndIf

oPrn:StartPage()

Li:=1
m_pag++
oPrn:Say (Li,0010,Replicate("=",125),oFont1)
Li+=50
oPrn:Say (Li,0010,SM0->M0_NOME,oFont1)
oPrn:Say (Li,2130,DTOC(Date()),oFont1)
Li+=20
//Ivandro Santos - 08/03/17
//Ticket#2017011137000047 — Pedido de Venda Técnico
/*If _cDeptoUsu = '201'
	oPrn:Say (Li,0700,"Check List - Montagem/Expedição",oFont1)
Else*/
oPrn:Say (Li,0700,"P E D I D O   D E   V E N D A S    "  + "T E C N I C O / C H E C K  L I S T",oFont1)
	//oPrn:Say (Li,0700,"P E D I D O   D E   V E N D A S    "  + "T E C N I C O",oFont1)
//EndIf
//Ticket#2017011137000047 — Fim da alteração
Li+=20
oPrn:Say (Li,0010,NomeProg ,oFont1)
oPrn:Say (Li,2060,"Pagina: " + STRZERO(m_Pag,3),oFont1)
Li+=50
oPrn:Say (Li,0010,Replicate("=",125),oFont1)
Li+=20
Return

//********************************
	Static Function GravaSZM()
//********************************
Local _lGrava := .T.
SZM->(DbSetOrder(9))
SZM->(DbGoTop())
If SZM->(DbSeek(xFilial()+"LOGPV "+SC5->C5_NUM))
	Do While SZM->(!Eof()) .And. SZM->ZM_PEDIDO == QR1->C5_NUM .And. Alltrim(SZM->ZM_ASSUNTO) == "LOGPV"
		If SZM->ZM_DATA == Date()
			If "Pedido de Venda Tecnico" $ SZM->ZM_EVENTO
				_lGrava := .F.
			EndIf
		EndIf
		SZM->(DbSkip())
	EndDo
EndIf

If _lGrava
	RecLock("SZM",.T.)
	SZM->ZM_FILIAL  := "01"
	SZM->ZM_PEDIDO  := QR1->C5_NUM
	SZM->ZM_CODCLI  := QR1->C5_CLIENTE
	SZM->ZM_LOJACLI := QR1->C5_LOJACLI
	SA1->(DbSeek(xFilial()+QR1->C5_CLIENTE+QR1->C5_LOJACLI))
	SZM->ZM_CLIENTE := SA1->A1_NREDUZ
	SZM->ZM_DATA    := Date()
	SZM->ZM_MSUSER  := _cUsuSenha
	SZM->ZM_DEPTO   := _cDeptoUsu
	SZM->ZM_ASSUNTO := "LOGPV"
	SZM->ZM_NOASSUN := "LOG DO PV"
	SZM->ZM_RESUMO  := "LOG DO PV"
	SZM->ZM_EVENTO  := "Emissao do Pedido de Venda Tecnico"
	SZM->ZM_CODDEPT := "QUALID"
	SZM->ZM_DEPTDES := "QUALIDADE"
	SZM->ZM_DTPREV  := Date()
	SZM->ZM_STATUS  := "E"
	SZM->ZM_CODTEC  := ""
	SZM->ZM_LIDO    := .F.
	SZM->ZM_ACEITE  := .F.
	SZM->ZM_COMENT  := QR1->C5_MSPOSIC
	SZM->ZM_COPIA   := .F.
	SZM->ZM_INIMONT := CtoD(QR1->C5_MSMONTA)
	SZM->(MsUnlock())
EndIf

Return