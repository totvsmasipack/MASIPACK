#include "TOTVS.CH" 
#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define _CRLF CHR(13)+CHR(10)   

/* 

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPCPC002  º Eduardo Bego Mantoan   º Data ³ 08/12/2014     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Status do Pedido online   	 						              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß   

*/

User Function RPCPC002()
Private lRET:= .T.    

Do While lRET
	PCPC002()
	If apmsgYesNo("Informar outro pedido de venda?") 
		lRET:= .T.
	Else 
		lRET:= .F.
	EndIf
EndDo
RETURN
//+--------------------------+\\
//| Declaracoes de variaveis |\\
//+--------------------------+\\
STATIC FUNCTION   PCPC002()

Local n
Local cDesc1     := "Status do Pedido"
Local cDesc2  	 := "parametros informado pelo usuario"
Local cDesc3  	 := ""
Private cString  := "SC6"
Private Tamanho  := "G"
Private aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",0 }
Private wnrel    := "RPCPC002"
Private NomeProg := "RPCPC002"
Private nLastKey := 0
Private Limite   := 132
Private Titulo   := "Status do Pedido"
Private cPerg    := "XRPCPC002"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Li       := 800
Private m_pag    := 1
Private aOrd     := {}
Private Cabec1   := "Nº Lista    Cod. Prod.      Descrição                           UN     Quant     Est     N.B  Res.Vend. "//         |       SC          |                     PC                          | OP   Quant OP   Pisição    Lista(Falta)   Data CI "
Private Cabec2   := ""//                                                                                                            |Numero | Data Prev | Numero | Data | Fornecedor | Quant | Confirmado | 																  "
Private dDT 	 := Date()
Private cVer1    := ""//"REST"   //LOG de OP
Private cVer2    := ""//"SD"      //LOD de OP
Private cVer3    := ""//"Estocagem"   //LOG de OP 
Private aSaldo1  := {}

#IFNDEF TOP
	MsgInfo("Não é possível executar este programa, está base de dados não é TopConnect","Incompatibilidade")
	RETURN
#ENDIF



CriaSx1()

//+-------------------------------------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------
Pergunte(cPerg,.T.)

aPed 		:= {}
aLogs1  	:= {}
aItens 		:= {}
aCPasta 	:= {}
aNivel  	:= {}  
aArray      := {}
aArrayC2 	:= StrToKarr( MV_PAR01 , ';')
nNumElem := Len(aArrayC2) 
For n := 1 to nNumElem 
	
	IF Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	ENDIF
	IF Select("QR2") > 0
	  		DbSelectArea("QR2")
	   		DbCloseArea()
	ENDIF

	lVerAPV:= .T.
	nPEDIDO := aArrayC2[n]
	AADD(aItens,AllTrim(aArrayC2[n])) 
	AADD(aSaldo1,"")
	AADD(aNivel,"00")
   
	dbSelectArea("SZM")
	SZM->(DbSetOrder(1))
	If DBSEEK(xFilial("SZM")+AllTrim(aArrayC2[n])) 
		If (SZM->ZM_ACEITE = .T. .OR. SZM->ZM_STATUS  = 'E') .OR. ((SZM->ZM_ASSUNTO = 'AUTORI' .OR.  SZM->ZM_ASSUNTO = 'LIBPV ') .AND. SZM->ZM_STATUS = 'E') 
			lVerAPV := .F.
		Else
	 		AADD(aCPasta,"FOLDER12") 
	 		cLogapv:= ""
	 		nW     := 1
	 		Do While ALLTRIM(aArrayC2[n]) == ALLTRIM(SZM->ZM_PEDIDO)
	 
	 			If SZM->ZM_STATUS  <> 'E' .AND. !(SZM->ZM_ASSUNTO  = 'AUTORI' .AND. SZM->ZM_STATUS  = 'A') .AND. !(SZM->ZM_ASSUNTO  = 'LIBPV ' .AND. SZM->ZM_STATUS  = 'A') .AND. !(SZM->ZM_STATUS  = 'B') .AND. !(SZM->ZM_STATUS  = 'P' .AND. SZM->ZM_ASSUNTO = 'AUTORI').AND. !(SZM->ZM_ASSUNTO  = 'LIBPV ' .AND. SZM->ZM_STATUS  = 'S') .AND. !(SZM->ZM_STATUS  = 'S')
	 		      
	 				/////////////////////////////////////////////////////
	 				cLogapv += "APV "+ALLTRIM(STR(nW))+" - Fabrica Geral - "+SZM->ZM_NOASSUN			////////////////////////
	 				/////////////////////////////////////////////////////
	 	  
	 			ElseIf SZM->ZM_ASSUNTO  = 'AUTORI' .AND. SZM->ZM_STATUS  = 'A'
	 		
	 				/////////////////////////////////////////////////////
	 		  		cLogapv += "APV "+ALLTRIM(STR(nW))+" - Aguardando Lib. PCP - "+SZM->ZM_NOASSUN 	////////////////////////
	 		  		/////////////////////////////////////////////////////     
	 	  		
	 			ElseIf SZM->ZM_ASSUNTO  = 'LIBPV ' .AND. SZM->ZM_STATUS  = 'A'
	 		
	 				/////////////////////////////////////////////////////
	 				cLogapv += "APV "+ALLTRIM(STR(nW))+" - Aguardando Sep. Almox - "+SZM->ZM_NOASSUN //////////////////////// 
	 				/////////////////////////////////////////////////////   
	 			
				ElseIf SZM->ZM_STATUS  = 'B'    
			
					/////////////////////////////////////////////////////
					cLogapv += "APV "+ALLTRIM(STR(nW))+" - Beneficiamento - "+SZM->ZM_NOASSUN 			//////////////////////// 
					/////////////////////////////////////////////////////  
				
				ElseIf SZM->ZM_STATUS  = 'P' .AND. SZM->ZM_ASSUNTO = 'AUTORI'
			
					///////////////////////////////////////////////////// 
					cLogapv += "APV "+ALLTRIM(STR(nW))+" - em Processo PCP - "+SZM->ZM_NOASSUN			////////////////////////
					/////////////////////////////////////////////////////  
				
				ElseIf SZM->ZM_STATUS  = 'S' .AND. SZM->ZM_ASSUNTO = 'LIBPV '
			
					/////////////////////////////////////////////////////
					cLogapv += "APV "+ALLTRIM(STR(nW))+" - em Separação Atlmox. - "+SZM->ZM_NOASSUN	////////////////////////
					/////////////////////////////////////////////////////
				Else
  					If SZM->ZM_STATUS  <> 'E' 
  						/////////////////////////////////////////////////////
    	   	 		cLogapv += "APV "+ALLTRIM(STR(nW))+" - Vide APV  - "+SZM->ZM_NOASSUN							////////////////////////
    	   	 		/////////////////////////////////////////////////////   
    	   		Else
    	   			/////////////////////////////////////////////////////
    	   	 		cLogapv += "APV "+ALLTRIM(STR(nW))+" - APV ENCERRADO  - "+SZM->ZM_NOASSUN							////////////////////////
    	   	 		/////////////////////////////////////////////////////   
    	    	   EndIf
				EndIf
				nW++ 
		 		cLogapv +=_CRLF
		 		SZM->(DBSKIP())
		 	EndDo
			AADD(aLogs1,cLogapv)
	   EndIf
	Else
		lVerAPV := .F.
	EndIf
	If !lVerAPV
		dbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If DBSEEK(xFilial("SC5")+AllTrim(aArrayC2[n]))
			If Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ).AND.EMPTY(SC5->C5_MSLIBPV)/* .AND. SC5->C5_MSAPROV <> 'S' */.AND. EMPTY(SC5->C5_MSPRIOR)//",'ENABLE' },;	//Pedido em Aberto
				 AADD(aLogs1,"Pedido em Aberto")
				 AADD(aCPasta,"FOLDER5")
			ElseIf (!Empty(SC5->C5_NOTA).Or.SC5->C5_LIBEROK=='E')//",'DISABLE'},;	//Pedido Encerrado
				 AADD(aLogs1,"Pedido Encerrado")
				 AADD(aCPasta,"FOLDER10")
			ElseIf !Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ).and.SUBSTR(SC5->C5_MSLIBPV,1,1) == 'T'//",'BR_AMARELO'},;
				 AADD(aLogs1,"Pedido Liberado")
				 AADD(aCPasta,"FOLDER5")
			ElseIf SUBSTR(SC5->C5_MSLIBPV,3,1) == 'C'         //",'BR_AZUL'},;	//Pedido EM ANALISE DE CREDITO
				 AADD(aLogs1,"Pedido EM ANALISE DE CREDITO")
				 AADD(aCPasta,"FOLDER14")
			ElseIf SUBSTR(SC5->C5_MSLIBPV,2,2) == 'EC'        //",'BR_LARANJA'},;	//Pedido BloqueAdo por CREDITO/ESTOQUE
 				 AADD(aLogs1,"Pedido BloqueAdo por CREDITO/ESTOQUE") 
 				 AADD(aCPasta,"FOLDER14")
 			ElseIf SC5->C5_MSPRIOR =='1'.and.EMPTY(SC5->C5_MSLIBPV)//",'BR_BRANCO'},;	//Pedido Aguardando liberação PCP
				 AADD(aLogs1,"Pedido Aguardando liberação PCP") 
				 AADD(aCPasta,"FOLDER14")
			ElseIf SC5->C5_MSPRIOR =='2'.and.EMPTY(SC5->C5_MSLIBPV)//",'BR_MARROM'},;	//Pedido Aguardando liberação ALMOXARIFADO
				 AADD(aLogs1,"Pedido Aguardando liberação ALMOXARIFADO")
				 AADD(aCPasta,"FOLDER14")	
//			ElseIf SC5->C5_MSAPROV =='N'//",'BR_PRETO'},;	//Pedido Aguardando liberação fiscal
//		    	 AADD(aLogs1,"Pedido Aguardando liberação fiscal")   
//		    	 AADD(aCPasta,"FOLDER14")
			ElseIf SUBSTR(SC5->C5_MSLIBPV,2,1) == 'E'//",'BR_PINK'}} // BLOQUEADO POR ESTOQUE
				AADD(aLogs1,"Pedido BLOQUEADO POR ESTOQUE") 
				AADD(aCPasta,"FOLDER14")
			Else
				AADD(aLogs1,"Vide APV ")
				AADD(aCPasta,"FOLDER5") 
			EndIf	
		Else
			Alert("Erro no pedido selecionado")
			Return
		EndIf 	
	EndIf   
	
	//If SC5->C5_MSCATEG <> "1"            // Não pode ser máquina
	    
	    cQuery := " SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_UM,C6_QTDENT,B1_PROCED,B2_QATU,B2_RESERVA,C6_NOTA "
		cQuery += " FROM "+RetSqlName("SC6")+" SC6   "
	 	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' " 
		cQuery += " INNER JOIN "+RetSqlName("SB2")+" SB2 ON C6_PRODUTO = B2_COD AND SB2.D_E_L_E_T_ = '' AND B2_FILIAL = '"+xFilial("SB2")+"' "
		cQuery += " WHERE C6_NUM = '"+AllTrim(aArrayC2[n])+"' "
		cQuery += " AND SC6.D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"'  "
		cQuery += " ORDER BY C6_NUM, C6_ITEM  	"   
		
		TcQuery cQuery New Alias "QR1" 
		
		AADD(aPed,AllTrim(aArrayC2[n]))  
		
		dbSelectArea("QR1")
		dbGoTop()
		Do While !QR1->(EOF()) 
			If QR1->C6_NOTA = "         "  
				AADD(aCPasta,"FOLDER8")
			Else
				AADD(aCPasta,"FOLDER10")
			EndIf
			AADD(aItens,QR1->C6_ITEM+" - "+QR1->C6_PRODUTO+" - "+QR1->C6_DESCRI)
			If QR1->B1_PROCED == "1P" 
				cLogA := VEROP(QR1->C6_PRODUTO)
				cLogA += _CRLF+"__________________________"+_CRLF + VERPC(QR1->C6_PRODUTO)
			Else
				cLogA := VERPC(QR1->C6_PRODUTO)
			EndIf
			
			AADD(aSaldo1,"Quantidade PV   : "+ALLTRIM(STR(QR1->C6_QTDVEN-QR1->C6_QTDENT))+_CRLF+"Saldo Estoque    : "+ALLTRIM(STR(QR1->B2_QATU))+_CRLF+"N.B.                    : "+ALLTRIM(STR(CalcNB(QR1->C6_PRODUTO,1)))+_CRLF+"Reserva vendas: "+ALLTRIM(STR(QR1->B2_RESERVA)))
			AADD(aLogs1,cLogA)
			AADD(aNivel,"01")
			If QR1->B1_PROCED == "1P" 
				Nivel2(QR1->C6_NUM,QR1->C6_ITEM,QR1->C6_PRODUTO)
			EndIf
			QR1->(DBSKIP())
		EndDo
    //Else
    
    //Endif
Next n
//U_DbTree()
U_PTSendTree(aPed,aItens)	

QR1->(DbCloseArea())
Return

                   
oTree:TreeSeek("001") // Retorna ao primeiro nível        
// Cria botões com métodos básicos    
TButton():New(160,002,"Seek Item 4"  , oDlg,{||oTree:TreeSeek("004")                                                    },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
TButton():New(160,052,"Enable"	     , oDlg,{||oTree:SetEnable()      													},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
TButton():New(160,102,"Disable"	     , oDlg,{||oTree:SetDisable()     													},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
TButton():New(160,152,"Novo Item"    , oDlg,{||TreeNewIt()            													},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
TButton():New(172,002,"Dados do item", oDlg,{||Alert("Cargo: "+oTree:GetCargo()+chr(13)+"Texto: "+oTree:GetPrompt(.T.)) },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )    
TButton():New(172,052,"Muda Texto"   , oDlg,{||oTree:ChangePrompt("Novo Texto Item 001","001") 							},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
TButton():New(172,102,"Muda Imagem"  , oDlg,{||oTree:ChangeBmp("LBNO","LBTIK",,,"001") 									},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
TButton():New(172,152,"Apaga Item"   , oDlg,{||if(oTree:TreeSeek("006"),oTree:DelItem(),) 								},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )    
oTree:EndTree()  
ACTIVATE DIALOG oDlg CENTERED 
Return                                             
//----------------------------------------// Função auxiliar para inserção de item //----------------------------------------
Static Function TreeNewIt()  
// Cria novo item na Tree  
oTree:AddTreeItem("Novo Item","FOLDER7",,"006")  
if oTree:TreeSeek("006")     
	oTree:AddItem("Sub-nivel 01","007", "FOLDER6",,,,2)	    
	oTree:AddItem("Sub-nivel 02","008", "FOLDER6",,,,2)	  
endif
Return




User Function PTSendTree(aPed,aItens)
Local nX,nY,nZ
DEFINE DIALOG oDlg TITLE "Pedido" FROM 100,100 TO 700,900 PIXEL
aNodes := {}
IMAGE1  := ""// Imagem quando nível estiver fechado
IMAGE2  := ""// Imagem quando nível estiver aberto
nLoop   := 20  // Quantidade de Loops - irá gerar 20010 Itens
nCount	:= 0	// Simula ID dos itens da Tree//
cTime1 := Time()// PRIMEIRO NÍVEL
//for nX := 1 to Len(aPed)		
	//nCount++	
//	IMAGE1 := "FOLDER5"	
//	aadd( aNodes, {'00', StrZero(nCount,4), "", aPed[nX], IMAGE1, IMAGE1} )		
	// SEGUNDO NÍVEL	
	for nY := 1 to Len(aItens)				
		nCount++		
	   //	IMAGE1 := "FOLDER6"		
		aadd( aNodes, {aNivel[nY], StrZero(nCount,4), "", StrZero(nCount,4)+" - "+aItens[nY], aCPasta[nY], aCPasta[nY]} )				
		// TERCEIRO NÍVEL
  //		Nivel2(aItens[nY])		
  //		for nZ := 1 to 3						
  //			nCount++			
  //			IMAGE1 := "FOLDER10"			
//			aadd( aNodes, {'02',StrZero(nCount,4),"","Terceiro Nível->ID: "+			StrZero(nCount,7), IMAGE1, IMAGE2} )					
 // 		next nZ			
	next nY	
//next nX
// Cria o objeto Tree
oTree := DbTree():New(0,0,270,500,oDlg,,,.T.)
// Método para carga dos itens da Tree
oTree:PTSendTree( aNodes )
TButton():New(272,002,"Log",     oDlg,{||AVISO("Log",aLogs1[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],{ "OK"},3) },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
TButton():New(272,052,"Saldos",  oDlg,{||AVISO("Saldos",aSaldo1[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],{ "OK"},3) },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
TButton():New(285,002,"Legenda", oDlg,{||Legenda()},40,10,,,.F.,.T.,.F.,,.F.,,,.F.   )
TButton():New(285,052,"Produto", oDlg,{||CHAMAMB(aItens[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],"SB1","Cadastro de Produtos")},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
TButton():New(285,100,"APV",     oDlg,{||CHAMAMB(aItens[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],"SZM","Acompanhamento do Pedido")},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
TButton():New(272,100,"PV",		oDlg,{||CHAMAMB(aItens[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],"SC5","Pedido de Venda")},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
TButton():New(285,150,"PC",		oDlg,{||CHAMAMB(aItens[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],"SC7","Pedido de Compra")},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
TButton():New(272,150,"OP",		oDlg,{||CHAMAMB(aItens[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],"SC2","Ordem de Produção")},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
TButton():New(285,200,"SC",		oDlg,{||CHAMAMB(aItens[VAL(SUBSTR(oTree:GetPrompt(.T.),1,4))],"SC8","Solicitação de compra")},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

       
ACTIVATE DIALOG oDlg CENTERED

Return 
Static Function CHAMAMB(cItem,cTab,cNomTab)
	
	Local aString := StrToKArr(cItem," - ")
	Local cProd   := ""
	Local cAlias  := cTab 
	If Len(aString) = 2  
   		cProd   := aString[2]    
	Else
		cProd   := aString[1]
	EndIf
 	Private cCadastro := cNomTab
 	//If Len(cProd) = 15 
 		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
 		DBSEEK(xFILIAL("SB1")+cProd)
 		cProd := SB1->B1_COD 
 		cPROCED:=SB1->B1_PROCED
  //	EndIf 
 	dbSelectArea(cAlias)
	dbSetOrder(1)
	If cAlias == "SB1"
		//If Len(cProd) = 15  
			If DBSEEK(xFILIAL(cAlias)+cProd) 
				MsFilter("SB1->B1_COD == '"+cProd+"'")
			Else
				ALERT("Produto não encontrado")
				DBGOTOP()	
			EndIf	
   	//Else
		//	ALERT("Produto não encontrado")
		//	DBGOTOP()	
		//EndIf
	ElseIf cAlias == "SZM" 
		If DBSEEK(xFilial("SZM")+AllTrim(nPEDIDO))
			MsFilter("SZM->ZM_PEDIDO == '"+AllTrim(nPEDIDO)+"'")
		EndIf  
		
	ElseIf cAlias == "SC5" 
	
		MsFilter("SC5->C5_NUM == '"+AllTrim(nPEDIDO)+"'") 	
		
	ElseIf cAlias == "SC7"
		//If Len(cProd) = 15
			If cPROCED == "1P"         
				ALERT("Produto é 1P (Produzido e Produtivo)")
			EndIf
			MsFilter("SC7->C7_PRODUTO == '"+cProd+"' .AND. SC7->C7_QUANT > SC7->C7_QUJE .AND. SC7->C7_RESIDUO <> 'S'") 
		//Else
		//	ALERT("Produto não encontrado")
		//EndIf
	ElseIf cAlias == "SC2"
		//If Len(cProd) = 15
			If cPROCED <> "1P"         
				ALERT("Produto não é 1P (Produzido e Produtivo)")
			EndIf
			MsFilter("SC2->C2_PRODUTO == '"+cProd+"'.AND. DTOS(SC2->C2_DATRF) == '        ' ") 
		//Else
		//	ALERT("Produto não encontrado")
		//EndIf
	ElseIf cAlias == "SC8"
		//If Len(cProd) = 15
			If cPROCED == "1P"         
				ALERT("Produto é 1P (Produzido e Produtivo)")
			EndIf
			MsFilter("SC8->C8_PRODUTO == '"+cProd+"' .AND. SC8->C8_QUANT > SC8->C8_QUJE") 
		//Else
		//	ALERT("Produto não encontrado")
		//EndIf				
	EndIf
	aRotina   := {}
	AADD(aRotina, { "Pesquisar" , "AxPesqui" , 0, 1 })
	AADD(aRotina, { "Visualizar", "AxVisual" , 0, 2 })
 	AADD(aRotina, { "Incluir"   , "AxInclui" , 0, 3 })
 	AADD(aRotina, { "Alterar"   , "AxAltera" , 0, 4 })
 //AADD(aRotina, { "Excluir"   , "AxDeleta" , 0, 5 })
	mBrowse(6,1,22,75,cAlias)
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | VLOG()    | AUTOR | Eduardo Mantoan  | DATA | 22/10/2014        |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Verifica log                                           |//
//|           |                 									            |//
//|           | 																|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function VLOG(cLista1) 


Local cLOG := "" 
///Verifica Log
dbSelectArea("SZS")
SZS->(DbSetOrder(2))
If SZS->(DbSeek(xFilial("SZS")+Alltrim(cLista1)))
	Do While SZS->(!Eof()) .And. Alltrim(SZS->ZS_OP) == Alltrim(cLista1)
		If cVer1 $ SZS->ZS_POSICAO .OR. cVer2 $ SZS->ZS_POSICAO .OR. cVer3 $ SZS->ZS_POSICAO
			cLOG :=  Alltrim(SZS->ZS_USUARIO)+"-"
			cLOG +=  Alltrim(SZS->ZS_POSICAO)
		EndIF
		SZS->(DbSkip())
	EndDo
EndIf


Return cLOG

Static Function VEROP(cProdOP) 

Local cLista:= ""    

IF Select("LR1") > 0
	DbSelectArea("LR1")
	DbCloseArea()
ENDIF 

cQuery:= " SELECT C2_NUM +C2_ITEM +C2_SEQUEN AS LISTA,C2_PRODUTO,C2_QUANT,C2_PEDIDO,C2_MSPED " 
cQuery+= " FROM "+RetSqlName("SC2")+" SC2 "
cQuery+= " WHERE C2_PRODUTO = '"+ALLTRIM(cProdOP)+"' "
cQuery+= " AND C2_DATRF = '        ' " 
cQuery+= " AND SC2.D_E_L_E_T_ = '' AND C2_FILIAL = '"+xFilial("SC2")+"' "  
cQuery+= " ORDER BY C2_NUM, C2_ITEM  " 

TcQuery cQuery New Alias "LR1" 

dbSelectArea("LR1")
dbGoTop()
   
Do While !LR1->(EOF()) 
    cLista += LR1->LISTA+"- Pedido: "+IIF(LR1->C2_PEDIDO == "      ",LR1->C2_MSPED,LR1->C2_PEDIDO)+" - Quantidade: "+ALLTRIM(STR(LR1->C2_QUANT))+_CRLF+"LOG: "+VLOG(LR1->LISTA)+_CRLF +_CRLF
	LR1->(DBSKIP())		   
EndDo
 



LR1->(DbCloseArea())
	   
Return cLista 


Static Function VERPC(cPRODUTO)  
Local cLogPCSC := ""
IF Select("LR2") > 0
	DbSelectArea("LR2")
	DbCloseArea()
ENDIF  

cQuery:= " SELECT 'PC' AS TIPO,C7_NUM AS NUM,C7_QUANT AS QUANT,C7_DATPRF AS PREV,C7_RETFOR AS COMENT "
cQuery+= " FROM "+RetSqlName("SC7")+" SC7  "
cQuery+= " Where C7_QUANT > C7_QUJE  "
cQuery+= " AND C7_RESIDUO <> 'S'"
cQuery+= " AND C7_PRODUTO='"+cPRODUTO+"'  "  
cQuery+= " AND SC7.D_E_L_E_T_ = ''   "
cQuery+= " AND C7_FILIAL='"+xFilial("SC7")+"'    "

cQuery+= " UNION ALL   "

cQuery+= " SELECT 'SC' AS TIPO,C1_NUM AS NUM, C1_QUANT AS QUANT,C1_DATPRF AS PREV,C1_OBS AS COMENT  "
cQuery+= " FROM "+RetSqlName("SC1")+" SC1  "
cQuery+= " WHERE C1_QUANT > C1_QUJE  "
cQuery+= " AND C1_PRODUTO='"+cPRODUTO+"'  "  
cQuery+= " AND SC1.D_E_L_E_T_ = '' "
cQuery+= " AND C1_FILIAL='"+xFilial("SC1")+"' "
cQuery+= " ORDER BY NUM  "

TcQuery cQuery New Alias "LR2" 
TcSetField("LR2","PREV","D",08,00)
dbSelectArea("LR2")
dbGoTop()  
Do While !LR2->(EOF()) 
	cLogPCSC += LR2->TIPO+" -> "+LR2->NUM+" Quantidade: "+ALLTRIM(STR(LR2->QUANT))+"    Dat Prev Ent/Dat Necessidade: "+DTOC(LR2->PREV)+_CRLF+"Ret For?/OBS: "+LR2->COMENT+_CRLF +_CRLF 
	LR2->(DBSKIP())		   
EndDo
LR2->(DbCloseArea())   

Return cLogPCSC 


Static Function CalcNB(cProdS,nNivel)

Local nSaldo := 0
IF Select("LR3") > 0
	DbSelectArea("LR3")
	DbCloseArea()
ENDIF
IF Select("LR4") > 0
	DbSelectArea("LR4")
	DbCloseArea()
ENDIF
		
	_cCQuery := "Select D4_COD,D4_OP,D4_QUANT,D4_QTDEORI,D4_MSREFER,D4_MSLF "
	_cCQuery += " FROM "+RetSqlName("SD4")+" SD4  "
	_cCQuery += " Where D4_COD = '"+cProdS+"'  "
	_cCQuery += " AND D4_QUANT > 0   "
	_cCQuery += " AND D4_DATA BETWEEN '"+ DTOS(MV_PAR03) +"' AND '" + DTOS(MV_PAR04) + "' "
	_cCQuery += " AND D4_FILIAL = '"+xFilial("SD4")+"'   "
	_cCQuery += " AND SD4.D_E_L_E_T_ = ' ' "
	_cCQuery += " ORDER BY D4_OP     "

	TcQuery _cCQuery New Alias "LR3"

	dbSelectArea("LR3")	
	dbGoTop("LR3")



	DO WHILE !LR3->(EOF())
		nSaldo	+= LR3->D4_QUANT
		LR3->(dbSKIP())
	EndDo 
	LR3->(DbCloseArea())

	_ccCQuery := "	Select *  "
	_ccCQuery += "	FROM "+RetSqlName("SC6")+" SC6   "
	_ccCQuery += "	WHERE C6_PRODUTO = '"+cProdS+"'  "
	_ccCQuery += "	AND C6_NOTA = '         '    "
	_ccCQuery += "  AND SC6.D_E_L_E_T_ = ' ' "
	_ccCQuery += "  AND C6_FILIAL = '"+xFilial("SC6")+"'   "
	_ccCQuery += "	ORDER BY C6_NUM " 

	TcQuery _ccCQuery New Alias "LR4"

	dbSelectArea("LR4")
	dbGoTop("LR4")
	Do While !LR4->(EOF())
		nSaldo +=	LR4->C6_QTDVEN - LR4->C6_QTDENT
		LR4->(DBSKIP())
	EndDo
	dbGoTop("LR4")
	dbSelectArea("SB2")
	DBSETORDER(1)
	SB2->(DBSEEK(xFilial("SB2")+cProdS)) 
	
	If nSaldo > SB2->B2_QATU
		nSaldo -= SB2->B2_QATU
	EndIf   

	LR4->(DbCloseArea())

Return nSaldo

Static Function Nivel2(cNum,cItem,cProd)  

IF Select("QR2") > 0
	DbSelectArea("QR2")
	DbCloseArea()
ENDIF           

_cCQuery := "	SELECT D4_COD,D4_OP,D4_QTDEORI,D4_QUANT,B1_DESC,B1_UM,B1_PROCED,B2_QATU,B2_RESERVA,B2_RESERVA + B2_QEMP AS NB  "
_cCQuery += "	FROM "+RetSqlName("SD4")+" SD4   "
_cCQuery += "	INNER JOIN "+RetSqlName("SB1")+" SB1 ON D4_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = '"+xFilial("SB1")+"' "
_cCQuery += "	INNER JOIN "+RetSqlName("SB2")+" SB2 ON D4_COD = B2_COD AND SB2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' " 
_cCQuery += "	WHERE  D4_OP Like '"+cNum+cItem+"001' "
//_cCQuery += "	AND D4_COD NOT LIKE '%MP%'   "
//_cCQuery += "	AND D4_QUANT > 0 "
_cCQuery += "   AND SD4.D_E_L_E_T_ = ' ' "
_cCQuery += "   AND D4_FILIAL = '"+xFilial("SD4")+"'   "
_cCQuery += "	ORDER BY D4_COD " 

TcQuery _cCQuery New Alias "QR2"
		
dbSelectArea("QR2")
dbGoTop("QR2")

Do While !QR2->(EOF())  
	If QR2->D4_QUANT > 0  
		AADD(aCPasta,"FOLDER8")
	Else
		AADD(aCPasta,"FOLDER10")
	EndIf
	AADD(aItens,QR2->D4_OP+" - "+QR2->D4_COD+" - "+QR2->B1_DESC)
	If QR2->B1_PROCED == "1P" 
		cLogA := VEROP(QR2->D4_COD)
		cLogA += _CRLF+"__________________________"+_CRLF + VERPC(QR2->D4_COD)
	Else
		cLogA := VERPC(QR2->D4_COD)
	EndIf
	
	AADD(aSaldo1,"Quantidade PV   : "+ALLTRIM(STR(QR2->D4_QUANT))+_CRLF+"Saldo Estoque    : "+ALLTRIM(STR(QR2->B2_QATU))+_CRLF+"N.B.                    : "+ALLTRIM(STR(CalcNB(QR2->D4_COD,2)))+_CRLF+"Reserva vendas: "+ALLTRIM(STR(QR2->B2_RESERVA)))
	AADD(aLogs1,cLogA)
	AADD(aNivel,"02")
	If QR2->B1_PROCED == "1P" .AND. MV_PAR05 > 1 
		Nivel3(cNum,QR2->D4_COD)
	EndIf
	QR2->(DBSKIP())    
EndDo
QR2->(DbCloseArea())	
Return 


Static Function Nivel3(cNum,cProd)      

IF Select("QR3") > 0
	DbSelectArea("QR3")
	DbCloseArea()
ENDIF   

_cCQuery := "	SELECT G1_COMP,G1_TRT,D4_OP,D4_QUANT,D4_COD,B2_RESERVA,B2_QATU,B1_PROCED,B1_DESC  "
_cCQuery += "	FROM "+RetSqlName("SG1")+" SG1 "
_cCQuery += "	INNER JOIN "+RetSqlName("SD4")+" SD4 ON D4_COD = G1_COMP  AND SD4.D_E_L_E_T_='' AND D4_OP LIKE '"+cNum+"%' AND G1_FILIAL='"+xFilial("SD4")+"' " 
_cCQuery += "	INNER JOIN "+RetSqlName("SB1")+" SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = '"+xFilial("SB1")+"' "
_cCQuery += "	INNER JOIN "+RetSqlName("SB2")+" SB2 ON G1_COMP = B2_COD AND SB2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' " 
_cCQuery += "	WHERE G1_COD = '"+cProd+"' "
_cCQuery += "	AND SG1.D_E_L_E_T_='' "
_cCQuery += "	AND G1_FILIAL='"+xFilial("SG1")+"' "
_cCQuery += "	ORDER BY G1_COMP  " 
 


TcQuery _cCQuery New Alias "QR3"
		
dbSelectArea("QR3")
dbGoTop("QR3")

Do While !QR3->(EOF())  
	If QR3->D4_QUANT > 0  
		AADD(aCPasta,"FOLDER8")
	Else
		AADD(aCPasta,"FOLDER10")
	EndIf
	AADD(aItens,QR3->D4_OP+" - "+QR3->G1_COMP+" - "+QR3->B1_DESC)
	If QR3->B1_PROCED == "1P" 
		cLogA := VEROP(QR3->G1_COMP)
		cLogA += _CRLF+"__________________________"+_CRLF + VERPC(QR3->G1_COMP)
	Else
		cLogA := VERPC(QR3->G1_COMP)
	EndIf
	
	AADD(aSaldo1,"Quantidade PV   : "+ALLTRIM(STR(QR3->D4_QUANT))+_CRLF+"Saldo Estoque    : "+ALLTRIM(STR(QR3->B2_QATU))+_CRLF+"N.B.                    : "+ALLTRIM(STR(CalcNB(QR3->G1_COMP,2)))+_CRLF+"Reserva vendas: "+ALLTRIM(STR(QR3->B2_RESERVA)))
	AADD(aLogs1,cLogA)
	AADD(aNivel,"03")
	If QR3->B1_PROCED == "1P" .AND. MV_PAR05 > 2 
		Nivel4(cNum,QR3->G1_COMP)
	EndIf
	QR3->(DBSKIP())    
EndDo 

QR3->(DbCloseArea())


Return      


Static Function Nivel4(cNum,cProd)      

IF Select("QR4") > 0
	DbSelectArea("QR4")
	DbCloseArea()
ENDIF   

_cCQuery := "	SELECT G1_COMP,G1_TRT,D4_OP,D4_QUANT,D4_COD,B2_RESERVA,B2_QATU,B1_PROCED,B1_DESC   "
_cCQuery += "	FROM "+RetSqlName("SG1")+" SG1 "
_cCQuery += "	INNER JOIN "+RetSqlName("SD4")+" SD4 ON D4_COD = G1_COMP  AND SD4.D_E_L_E_T_='' AND D4_OP LIKE '"+cNum+"%' AND G1_FILIAL='"+xFilial("SD4")+"' " 
_cCQuery += "	INNER JOIN "+RetSqlName("SB1")+" SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = '"+xFilial("SB1")+"' "
_cCQuery += "	INNER JOIN "+RetSqlName("SB2")+" SB2 ON G1_COMP = B2_COD AND SB2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' " 
_cCQuery += "	WHERE G1_COD = '"+cProd+"' "
_cCQuery += "	AND SG1.D_E_L_E_T_='' "
_cCQuery += "	AND G1_FILIAL='"+xFilial("SG1")+"' "
_cCQuery += "	ORDER BY G1_COMP  " 
 


TcQuery _cCQuery New Alias "QR4"
		
dbSelectArea("QR4")
dbGoTop("QR4")

 Do While !QR4->(EOF())  
	If QR4->D4_QUANT > 0  
		AADD(aCPasta,"FOLDER8")
	Else
		AADD(aCPasta,"FOLDER10")
	EndIf
	AADD(aItens,QR4->D4_OP+" - "+QR4->G1_COMP+" - "+QR4->B1_DESC)
	If QR4->B1_PROCED == "1P" 
		cLogA := VEROP(QR4->G1_COMP)
		cLogA += _CRLF+"__________________________"+_CRLF + VERPC(QR4->G1_COMP)
	Else
		cLogA := VERPC(QR4->G1_COMP)
	EndIf
	
	AADD(aSaldo1,"Quantidade PV   : "+ALLTRIM(STR(QR4->D4_QUANT))+_CRLF+"Saldo Estoque    : "+ALLTRIM(STR(QR4->B2_QATU))+_CRLF+"N.B.                    : "+ALLTRIM(STR(CalcNB(QR4->G1_COMP,2)))+_CRLF+"Reserva vendas: "+ALLTRIM(STR(QR4->B2_RESERVA)))
	AADD(aLogs1,cLogA)
	AADD(aNivel,"04")
	If QR4->B1_PROCED == "1P" .AND. MV_PAR05 > 3 
		Nivel5(cNum,QR4->G1_COMP)
	EndIf
	QR4->(DBSKIP())    
EndDo 

QR4->(DbCloseArea())


Return      


Static Function Nivel5(cNum,cProd)      

IF Select("QR5") > 0
	DbSelectArea("QR5")
	DbCloseArea()
ENDIF   

_cCQuery := "	SELECT G1_COMP,G1_TRT,D4_OP,D4_QUANT,D4_COD,B2_RESERVA,B2_QATU,B1_PROCED,B1_DESC   "
_cCQuery += "	FROM "+RetSqlName("SG1")+" SG1 "
_cCQuery += "	INNER JOIN "+RetSqlName("SD4")+" SD4 ON D4_COD = G1_COMP  AND SD4.D_E_L_E_T_='' AND D4_OP LIKE '"+cNum+"%' AND G1_FILIAL='"+xFilial("SD4")+"' " 
_cCQuery += "	INNER JOIN "+RetSqlName("SB1")+" SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = '"+xFilial("SB1")+"' "
_cCQuery += "	INNER JOIN "+RetSqlName("SB2")+" SB2 ON G1_COMP = B2_COD AND SB2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' " 
_cCQuery += "	WHERE G1_COD = '"+cProd+"' "
_cCQuery += "	AND SG1.D_E_L_E_T_='' "
_cCQuery += "	AND G1_FILIAL='"+xFilial("SG1")+"' "
_cCQuery += "	ORDER BY G1_COMP  " 
 


TcQuery _cCQuery New Alias "QR5"
		
dbSelectArea("QR5")
dbGoTop("QR5")

Do While !QR5->(EOF())  
	If QR5->D4_QUANT > 0  
		AADD(aCPasta,"FOLDER8")
	Else
		AADD(aCPasta,"FOLDER10")
	EndIf
	AADD(aItens,QR5->D4_OP+" - "+QR5->G1_COMP+" - "+QR5->B1_DESC)
	If QR5->B1_PROCED == "1P" 
		cLogA := VEROP(QR5->G1_COMP)
		cLogA += _CRLF+"__________________________"+_CRLF + VERPC(QR5->G1_COMP)
	Else
		cLogA := VERPC(QR5->G1_COMP)
	EndIf
	
	AADD(aSaldo1,"Quantidade PV   : "+ALLTRIM(STR(QR5->D4_QUANT))+_CRLF+"Saldo Estoque    : "+ALLTRIM(STR(QR5->B2_QATU))+_CRLF+"N.B.                    : "+ALLTRIM(STR(CalcNB(QR5->G1_COMP,2)))+_CRLF+"Reserva vendas: "+ALLTRIM(STR(QR5->B2_RESERVA)))
	AADD(aLogs1,cLogA)
	AADD(aNivel,"04")
	If QR5->B1_PROCED == "1P" .AND. MV_PAR05 > 4 
		//Nivel6(cNum,QR5->G1_COMP)
	EndIf
	QR5->(DBSKIP())    
EndDo 

QR5->(DbCloseArea())


Return 
///////////////////////////////////////
///////////LEGENDA DE CORES ///////////
///////////////////////////////////////
STATIC Function Legenda()
Local aLegenda  := {}
Local cCad := "Legenda Status do Pedido"
AADD(aLegenda,{"BR_VERDE" ,"Item ou pedido já entregue/encerrado" })
AADD(aLegenda,{"BR_VERMELHO" ,"Item pendente/faltante" })
AADD(aLegenda,{"BR_PRETO" ,"Pedido bloqueado Estoque/Fiscal/Crédito" })
AADD(aLegenda,{"BR_AMARELO" ,"Pedido disponível para processo" })
AADD(aLegenda,{"BR_AZUL" ,"Pedido aguardando APV" })
BrwLegenda(cCad, "Legenda", aLegenda)

Return Nil
