#Include "Rwmake.ch"

#Include "Topconn.ch"

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | RPCPR026.prw    | AUTOR | Eduardo Mantoan  | DATA | 26/05/2014  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | 							                                    |//
//|           | Relatório de Pedidos Pendentes PCP. (C5_MSCONCL = ' ')          |//
//|           |          													    				  |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////


User Function RPCPR026()

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------

Local cDesc1  := "Pedidos Pendentes PCP"         
Local cDesc2  := ""                      
Local cDesc3  := ""
                  

Private cString  	:= "SC5"
Private Tamanho  	:= "M"
Private aReturn  	:= { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    	:= "RPCPR026"
Private NomeProg 	:= "RPCPR026"
Private nLastKey 	:= 0
Private Limite   	:= 132
Private Titulo   	:= "Pedidos Pendentes PCP"
Private cPerg    	:= "XRPCPR026"
Private nTipo    	:= 0
Private cbCont   	:= 0
Private cbTxt    	:= "registro(s) lido(s)"
Private Cabec1   	:= ""
Private Cabec2   	:= ""
Private Li       	:= 80
Private m_pag    	:= 1
Private aOrd     	:= {}
Private Cabec1   	:= ""
Private Cabec2   	:= ""
Private Cabec3    := ""
Private cRegCSV  	:= ""
Private cArqCSV  	:= "C:\Relato_Microsiga\Total_Pedidos_Pendentes_PCP.csv" 
Private dEmi	 	
Private dDtent		
Private dDtpen
Private dDtMonta    
Private lCheck3 := .F.


#IFNDEF TOP
   MsgInfo("Não é possível executar este programa, está base de dados não é TopConnect","Incompatibilidade")
   RETURN
#ENDIF

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,.F.,.F.)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
   Return
Endif

//+-------------------------------------------------------------------------------
//| Estabelece os padroes para impressao, conforme escolha do usuario
//+-------------------------------------------------------------------------------
SetDefault(aReturn,cString)

//+-------------------------------------------------------------------------------
//| Verificar se sera reduzido ou normal
//+-------------------------------------------------------------------------------
nTipo := Iif(aReturn[4] == 1, 15, 18)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
   Return
Endif

//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
RptStatus({|lEnd| RelPCP26(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )



	


	
	

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | RelPCP26.prw    | AUTOR | Eduardo Mantoan  | DATA | 26/05/2014  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | 							                                    |//
//|           | Relatório com o total de pedidos pendentes pcp                  |//
//|           |          														|//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

Static Function RelPCP26(lEnd,wnrel,cString)
Local cFilSE2   := xFilial(cString)
Local _cQuery   := ""
Local aCol      := {}
Local cFornec   := ""
Local nValor    := 0
Local nPago     := 0
Local nSaldo    := 0
Local nT_Valor  := 0
Local nT_Pago   := 0
Local nT_Saldo  := 0
Local cArqExcel := ""
Local cMes      := ""
Local cAno      := ""
Local dData     := CTOD("")
Local dDataA    := CTOD("")
Local nTotal    := 0
Local nTotalAC  := 0
Local nCol      := 0
Local nVez      := 1
//+-----------------------
//| Cria filtro temporario
//+-----------------------
While nVez = 1 .OR. (MV_PAR08 == 3 .AND. nVez = 2  )    
 
If !lCheck3 .AND. MV_PAR08 == 3 
	mv_par05 := 1
EndIf
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
EndIf
_cQuery := " SELECT SC5.C5_NUM,C5_MSCATEG,SC5.C5_MSENG,C5_MSTPVEN,C5_EMISSAO,C5_CLIENTE,C5_MSMULTA,C5_VEND1,C5_MSPOSIC,C5_NOTA,  "
_cQuery += " A1_NREDUZ,C5_MSDTPEN,C5_ORCAM,C5_COTACAO,C5_MSDTENT,C5_MSCONCL,C5_MENNOTA,C5_NATUREZ,C5_PC,C5_TRANSP,C5_MSPRIOR	"  
If MV_PAR08 = 2 .OR. mv_par05 = 2 .OR. MV_PAR08 = 4 .OR. (MV_PAR08 = 3 .AND. mv_par05 = 2  ) 
	_cQuery += ",C6_PRODUTO,C6_ITEM,C6_DESCRI,C6_MSDTLIB,C6_DATFAT,C6_NOTA,C6_UM,C6_PRCVEN,C6_QTDVEN,C6_QTDENT      "
EndIF

If MV_PAR07 = 1
	_cQuery += "				,C5_MSMONTA AS DAT                                                       "
ElseIf MV_PAR07 = 2
	_cQuery += "				,SC5.C5_MSDTENT AS DAT                                                   "				
Else
	_cQuery += "				,SC5.C5_MSDTENT AS DAT, C5_MSMONTA                                       "

EndIF                      


_cQuery += " FROM "+RetSqlName("SC5")+" SC5          "  

If MV_PAR08 = 2 .OR. mv_par05 = 2 .OR. MV_PAR08 = 4 .OR. (MV_PAR08 = 3 .AND. mv_par05 = 2) 												    						
	_cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6                                             		"
	_cQuery += "        ON C5_NUM = C6_NUM AND C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_ = ' ' 	" 
EndIf
_cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1                                            		"
_cQuery += "        ON   A1_COD = C5_CLIENTE AND C5_LOJAENT = A1_LOJA " 
                                               		"
_cQuery += " WHERE SC5.C5_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'	 				   		"
If MV_PAR07 = 1 .OR. MV_PAR07 = 3  .AND. MV_PAR08 <> 3
	_cQuery += " AND C5_MSDTENT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'      	 		"
ElseIf MV_PAR07 = 4 .AND. MV_PAR08 <> 3        
		_cQuery += " AND ((C5_MSDTPEN BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"')               "
		_cQuery += " OR   (C5_MSDTPEN < '10000101'AND C5_MSDTENT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'))      	 		"
ElseIf MV_PAR08 = 3 .AND. mv_par05 = 1 
	_cQuery += " AND C5_MSCONCL BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'      	 		" 
ElseIf mv_par05 == 2 
	_cQuery += " AND C6_DATFAT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'      	 		"
Else
	_cQuery += " AND C5_MSMONTA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'      	 		"
EndIf  


If mv_par05 == 1     .AND. SubStr(cNumEmp,1,2) $ "01_10"
	_cQuery += " AND C5_MSCATEG = '1'                                      			    			"
ElseIf mv_par05 == 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"
	_cQuery += " AND C5_MSCATEG <> '1'                                      			    		"

EndIf 

IF mv_par06 == 1
	_cQuery += " AND C5_MSENG = 'E'		                                      			    		"
ElseIf mv_par06 == 2
	_cQuery += " AND C5_MSENG = 'H'                                      			    			"
ElseIf mv_par06 == 3
	_cQuery += " AND C5_MSENG = 'V'                                      			    			"
//ElseIf mv_par06 == 4
//  	_cQuery += " AND C5_MSENG <> 'N'                                      			    			 		"
EndIF 

_cQuery += " AND SC5.C5_TIPO = 'N'                                     			    			  			"
If MV_PAR08 = 3
	If mv_par05 == 1 .AND. SubStr(cNumEmp,1,2) $ "01_10"
		_cQuery += " AND SC5.C5_MSCONCL <> '   '                      			    		  				"
	ElseIF mv_par05 == 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"
		_cQuery += " AND C6_NOTA <> '   '                      			    		  				"			
	EndIf	
Else 
 	If mv_par05 == 1 .AND. SubStr(cNumEmp,1,2) $ "01_10"
		_cQuery += " AND SC5.C5_MSCONCL = ' '                                 			    	
	ElseIF mv_par05 == 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"
		_cQuery += " AND C6_NOTA = '  ' OR ((C6_QTDVEN - C6_QTDENT) > 0) "
	EndIf
EndIf 

If MV_PAR07 = 1
_cQuery += " AND C5_MSMONTA <> ' '                                 			    		  					"
EndIF 
_cQuery += " AND SC5.C5_NOTA NOT LIKE '%999999%' "
_cQuery += " AND SC5.C5_NOTA NOT LIKE '%XXXXXX%'                                 			     		"  
_cQuery += " AND SC5.C5_NOTA <> 'XXXXXXXXX'                                 			     				"
_cQuery += " AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' '    		  				"

_cQuery += " AND A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.D_E_L_E_T_ = ' '               		    	"
If MV_PAR07 = 1 .OR. MV_PAR07 = 3
	_cQuery += " ORDER BY C5_MSDTENT,SC5.C5_NUM           			    			 						 	" 
ElseIf MV_PAR07 = 4
	_cQuery += " ORDER BY C5_MSDTENT,C5_MSDTPEN,SC5.C5_NUM           			    			 			 	" 
Else
	_cQuery += " ORDER BY C5_MSMONTA,SC5.C5_NUM           			    			 						 	"
EndIf


dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery), "TRB", .T., .F. ) 

dbSelectArea("TRB")
dbGoTop()
SetRegua( RecCount() )

Li := 2

cTime := TIME()  
cHora := SUBSTR(cTime, 1, 2)   
cMinutos := SUBSTR(cTime, 4, 2) 
cSegundos := SUBSTR(cTime, 7, 2)  
cDT       := DTOS(Date())
cDT       += cHora + cMinutos + cSegundos
//+-------------------------------------------------------------------------------
//| Gera arquivo .CSV - INICIO
//+------------------------------------------------------------------------------- 
If MV_PAR08 == 3 .AND. !lCheck3
	
	cArq := "C:\Relato_Microsiga\Total_Pedidos_Pendentes_PCP"+cDT+".csv"
	If (cArqCSV := FCreate(cArq)) == -1 

		Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
		Cabec1  := "Do período de: "+DTOC(MV_PAR03)+" até: "+DTOC(MV_PAR04)+"  Não foi gerado arquivo .CSV - Contate o TI"
	  
	Else
		
		Cabec1  := "Do período de: "+DTOC(MV_PAR03)+" até: "+DTOC(MV_PAR04)+"   Arquivo EXCEL gerado em: C:\Relato_Microsiga\Total_Pedidos_Pendentes_PCP"+cDT+".csv "
		 
		cRegCSV := "Relação dos Pedidos Pendentes PCP - emitida em " + cDT + " - Periodo de: "+DTOC(mv_par03)+" à "+DTOC(mv_par04) 
	 	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   
   		cRegCSV := ""
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Pula Linha 
	
	EndIF          
ElseIf MV_PAR08 == 3 .AND. lCheck3 	
	
ElseIf MV_PAR08 <> 3
		cArq := "C:\Relato_Microsiga\Total_Pedidos_Pendentes_PCP"+cDT+".csv"
	If (cArqCSV := FCreate(cArq)) == -1 

		Alert("Arquivo para o Excel não pode ser criado - Avise o Depto. de Informática")
		Cabec1  := "Do período de: "+DTOC(MV_PAR03)+" até: "+DTOC(MV_PAR04)+"  Não foi gerado arquivo .CSV - Contate o TI"
	  
	Else
		
		Cabec1  := "Do período de: "+DTOC(MV_PAR03)+" até: "+DTOC(MV_PAR04)+"   Arquivo EXCEL gerado em: C:\Relato_Microsiga\Total_Pedidos_Pendentes_PCP"+cDT+".csv "
		 
		cRegCSV := "Relação dos Pedidos Pendentes PCP - emitida em " + cDT + " - Periodo de: "+DTOC(mv_par03)+" à "+DTOC(mv_par04) 
	 	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
   
   		cRegCSV := ""
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Pula Linha 
	
	EndIF
EndIf

//+-------------------------------------------------------------------------------
//| Gera arquivo .CSV - FIM
//+-------------------------------------------------------------------------------
Cabec2  := " "
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
If mv_par07 = 1        
	Cabec3  := "Pedido |Cat|Eng| Tip |Emissão PV| Cliente                         |Dat.Montag| Ent.Prev | Descri                              | Contrato"
ElseIF mv_par07 = 2 .OR. MV_PAR07 = 4
	Cabec3  := "Pedido |Cat|Eng| Tip |Emissão PV| Cliente                         | Ent.Orig | Ent.Prev | Descri                              | Contrato"
Else
	Cabec3  := "Pedido |Cat|Eng| Tip |Emissão PV| Cliente                         |Dat.Montag| Ent.Orig | Ent.Prev | Descri                              | Contrato"
EndIF
@ Li, 002 PSay Cabec3
Li++
@ Li,000 Psay __PrtFatLine()
Li++

cNEng  	:= ""
dAtual 	:= DATE()
nCont 	:= 0
cPV      := ""
cIPV     := ""


cRegCSV := ""
FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
If MV_PAR08 = 2
	If mv_par07 = 1 
		cRegCSV := "Pedido;Cat;Eng;Tip;Emissão PV;Cliente;Dat.Montag;Ent.Prevista;Data de Liberação;Multa;Vendedor;Posição;Descri;Contrato" // Cabeçalho .CSV              
	ElseIf mv_par07 = 2 .OR. MV_PAR07 = 4
		cRegCSV := "Pedido;Cat;Eng;Tip;Emissão PV;Cliente;Ent.Original;Ent.Prevista;Data de Liberação;Multa;Vendedor;Posição;Descri;Contrato" // Cabeçalho .CSV
	Else 
		cRegCSV := "Pedido;Cat;Eng;Tip;Emissão PV;Cliente;Dat.Montag;Ent.Original;Ent.Prevista;Multa;Vendedor;Posição;Descri;Contrato" // Cabeçalho .CSV
	EndIF
ElseIf MV_PAR08 = 1 
	If mv_par07 = 1 
		cRegCSV := "Pedido;Cat;Eng;Tip;Emissão PV;Cliente;Dat.Montag;Ent.Prevista;Multa;Vendedor;Posição;Contrato" // Cabeçalho .CSV              
	ElseIf mv_par07 = 2 .OR. MV_PAR07 = 4
		cRegCSV := "Pedido;Cat;Eng;Tip;Emissão PV;Cliente;Ent.Original;Ent.Prevista;Multa;Vendedor;Posição;Contrato" // Cabeçalho .CSV
	Else 
		cRegCSV := "Pedido;Cat;Eng;Tip;Emissão PV;Cliente;Dat.Montag;Ent.Original;Ent.Prevista;Multa;Vendedor;Posição;Contrato" // Cabeçalho .CSV
	EndIF
	
ElseIf MV_PAR08 = 3 
	If mv_par05 == 1 .AND. SubStr(cNumEmp,1,2) $ "01_10"
		cRegCSV := "Pedido;Orçamento;Cat;Eng;Tip;Emissão PV;Cliente;Nome Cli;Data Entrega;Prev.Entrega;Conclusão;Atrasado?;Nota"    // Cabeçalho .CSV
	ElseIf mv_par05 == 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"
		cRegCSV := "Pedido;Orçamento;Cat;Eng;Tip;Item;Cod;Desc;Emissão PV;Cliente;Nome Cli;Data Entrega;Prev.Entrega;Dat Fat;Atrasado?;Nota" // Cabeçalho .CSV
	EndIF
ElseIf MV_PAR08 = 4 .AND. SubStr(cNumEmp,1,2) $ "01_10"
	
		cRegCSV := "Pedido;Cotacao;Emissão PV;Cat;Vendedor;Cliente;Ent.Original;Ent.Prevista;Item;Produto;Descrição;UM;Preço Unit.;Qde.Vendida;Qde.Entregue;Transp.;Num. Ped. Cli.;Natureza;Posicao PV.;Nota fiscal;Mens. p/ Nota"
EndIf
FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

//cRegCSV := ""
//FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Pula Linha 
nContA := 0
While TRB->(!Eof())
	
	If TRB->C5_NOTA <> "         " .AND. TRB->C5_MSCATEG $ "0_2_3_4" .AND. MV_PAR08 <> 3 
		TRB->(DBSKIP())
		loop 
	EndIf 
	
	If Li > 55
	
 		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	Li 	:= 8
   	@ Li, 002 PSay Cabec3
   	Li++
   	@ Li,000 Psay __PrtFatLine()
   	Li++
	Endif  
	
 
	If MV_PAR08 = 2 
	  
		If TRB->C5_NUM == cPV .AND. TRB->C6_ITEM == cIPV
			TRB->(dbSkip())
			Loop
		EndIF
	  	
	  	If MV_PAR09 = 2   
	  		
 			If TRB->C5_NUM == cPV
				TRB->(dbSkip())
				Loop	
 			EndIf	
 				
		ElseIf MV_PAR09 = 3
	   	If nContA >= 2
	   		If TRB->C5_NUM == cPV	
	   			TRB->(dbSkip())
					Loop	
	   		Else
	   			nContA := 1
	   		EndIf
	   		
	   	Else
	   		nContA++
	   	EndIf
		EndIf
			
		
	
	ElseIf MV_PAR08 = 1
	
		If TRB->C5_NUM == cPV 
	  
			TRB->(dbSkip())
			Loop
		
		EndIf
	
	EndIF
	dEmi	 	:=	STOD(TRB->C5_EMISSAO)
	dDtent 	:=	STOD(TRB->DAT)
	dDtpen 	:=	STOD(TRB->C5_MSDTPEN) 
	If MV_PAR07 = 1 .OR. MV_PAR07 = 2 
		dDtMonta :=	STOD(TRB->DAT)	
	Else
		dDtMonta :=	STOD(TRB->C5_MSMONTA)
	EndIf
	////////////
	If MV_PAR08 = 2
		dDtLIb	:=		STOD(TRB->C6_MSDTLIB)
		 
	EndIf
					
  	///////////	
	If MV_PAR08 = 4 .AND. TRB->C5_NUM <> cPV 
 	
 		cRegCSV := ""	
 		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Pula Linha

	EndIf
		
		@ Li, 002  PSay TRB->C5_NUM					+ " | "
		If SubStr(cNumEmp,1,2) $ "01_10"
			@ Li, 011  PSay TRB->C5_MSCATEG			+ " | "
		EndIf
		@ Li, 015  PSay TRB->C5_MSENG					+ " | "
		@ Li, 019  PSay TRB->C5_MSTPVEN				+ "  | "
		@ Li, 025  PSay DTOC(dEmi)				  		+ " | "
		@ Li, 036  PSay TRB->C5_CLIENTE				+ " - "
		@ Li, 047  PSay TRB->A1_NREDUZ		  		+ " | "
		If MV_PAR07 = 1 .OR. MV_PAR07 = 2 .OR. MV_PAR07 = 4  
		
			@ Li, 070  PSay DTOC(dDtent)				+ " | "
			
			@ Li, 081  PSay DTOC(dDtpen)				+ " | " 
			/////////// 
			If MV_PAR08 = 2
				@ Li, 92  PSay TRB->C6_DESCRI		   + " | " 
			EndIf
			///////////
			@ Li, 130  PSay TRB->C5_ORCAM				+ " | "
		Else 
		
			@ Li, 070  PSay DTOC(dDtMonta)  			+ " | "
			@ Li, 081  PSay DTOC(dDtent)				+ " | "
		
			@ Li, 092  PSay DTOC(dDtpen)				+ " | "
			/////////////
			If MV_PAR08 = 2
				@ Li, 103  PSay TRB->C6_DESCRI		+ " | "
			EndIF	 
			////////////
			@ Li, 141  PSay TRB->C5_ORCAM				+ " | " 
			
		EndIf
		
		If MV_PAR08 = 3
			If mv_par05 == 1 .AND. SubStr(cNumEmp,1,2) $ "01_10" 
			 
				If TRB->C5_MSDTPEN <> '        '
				 	nAtraso	:= STOD(TRB->C5_MSCONCL) - STOD(TRB->C5_MSDTPEN)
				Else
					nAtraso	:= STOD(TRB->C5_MSCONCL) - STOD(TRB->C5_MSDTENT)
				EndIf  
				
				cRegCSV := TRB->C5_NUM+";"+TRB->C5_COTACAO+";"+TRB->C5_MSCATEG+";"+TRB->C5_MSENG+";"+TRB->C5_MSTPVEN+";"+DTOC(dEmi)+";_"+TRB->C5_CLIENTE+";"+TRB->A1_NREDUZ+";"+DTOC(STOD(TRB->C5_MSDTENT))+";"+DTOC(STOD(TRB->C5_MSDTPEN))+";"+DTOC(STOD(TRB->C5_MSCONCL))+";"+IIF(nAtraso > 0 ,STR(nAtraso),"0")+";"+TRB->C5_NOTA
	        
	        ElseIf mv_par05 == 2 .AND. SubStr(cNumEmp,1,2) $ "01_10"  
	            
	        	If TRB->C5_MSDTPEN <> '        '
				 	nAtraso	:= STOD(TRB->C6_DATFAT) - STOD(TRB->C5_MSDTPEN)
				Else
					nAtraso	:= STOD(TRB->C6_DATFAT) - STOD(TRB->C5_MSDTENT)
				EndIf     
	        
	        	cRegCSV := TRB->C5_NUM+";"+TRB->C5_COTACAO+";"+TRB->C5_MSCATEG+";"+TRB->C5_MSENG+";"+TRB->C5_MSTPVEN+";"+TRB->C6_ITEM+";"+TRB->C6_PRODUTO+";"+TRB->C6_DESCRI+";"+DTOC(dEmi)+";_"+TRB->C5_CLIENTE+";"+TRB->A1_NREDUZ+";"+DTOC(STOD(TRB->C5_MSDTENT))+";"+DTOC(STOD(TRB->C5_MSDTPEN))+";"+DTOC(STOD(TRB->C6_DATFAT))+";"+IIF(nAtraso > 0 ,STR(nAtraso),"0")+";"+TRB->C5_NOTA
	        
	        EndIf
	    ElseIf MV_PAR08 = 4 
	      
	    	dbSelectArea("SA3")
			SA3->(DbSetOrder(1))
	    	Dbseek(xFilial("SA3")+TRB->C5_VEND1,.t.)
		    cVendedor := SA3->A3_NOME
		    dbSelectArea("TRB")    
			cRegCSV :=TRB->C5_NUM+";"+TRB->C5_COTACAO+";"+DTOC(dEmi)+";"+TRB->C5_MSCATEG+";_"+TRB->C5_VEND1+"-"+ALLTRIM(cVendedor)+";_"+TRB->C5_CLIENTE+"-"+TRB->A1_NREDUZ+";"+DTOC(STOD(TRB->C5_MSDTENT))+";"+DTOC(STOD(TRB->C5_MSDTPEN))+";"+TRB->C6_ITEM+";_"+TRB->C6_PRODUTO+";"+TRB->C6_DESCRI+";"+TRB->C6_UM+";"+STR(TRB->C6_PRCVEN)+";"+STR(TRB->C6_QTDVEN)+";"+STR(TRB->C6_QTDENT)+";"+TRB->C5_TRANSP+";"+TRB->C5_PC+";"+TRB->C5_NATUREZ+";"+TRB->C5_MSPRIOR+";"+TRB->C6_NOTA+";"+TRB->C5_MENNOTA    
	   
		Else
			cRegCSV := TRB->C5_NUM 			   			    + ";"
			If SubStr(cNumEmp,1,2) $ "01_10"
				cRegCSV += TRB->C5_MSCATEG  	  		    + ";"
			Else
				cRegCSV += ";"
			EndIF
			cRegCSV += TRB->C5_MSENG		   			    + ";"
			cRegCSV += TRB->C5_MSTPVEN		  				+ ";"
			cRegCSV += DTOC(dEmi)  							+ ";"
			cRegCSV += TRB->C5_CLIENTE  					+ "-"
			cRegCSV += TRB->A1_NREDUZ  					    + ";"
			If MV_PAR07 = 1 .OR. MV_PAR07 = 2 .OR. MV_PAR07 = 4
				cRegCSV += DTOC(dDtent)  	  				+ ";"
			Else
				cRegCSV += DTOC(dDtMonta) 					+ ";"
				cRegCSV += DTOC(dDtent)  	  			 	+ ";"
			EndIF
			cRegCSV += DTOC(dDtpen)  						+ ";"
			If MV_PAR08 = 2 .AND. MV_PAR07 <> 3
				cRegCSV += DTOC(dDtLIb)  					+ ";"
			EndIf
			cRegCSV += TRB->C5_MSMULTA						+ ";"
			dbSelectArea("SA3")
			SA3->(DbSetOrder(1))
			Dbseek(xFilial("SA3")+TRB->C5_VEND1,.t.)
			cRegCSV += TRB->C5_VEND1+"-"+SA3->A3_NOME       + ";"
			dbSelectArea("TRB")
			cRegCSV += TRB->C5_MSPOSIC						+ ";"
		
			//////
			If MV_PAR08 = 2
	  			cRegCSV += TRB->C6_DESCRI  	  			    + ";" 
	 		EndIf
			/////////
			cRegCSV += TRB->C5_ORCAM	  	  				+ ";"
		EndIf
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))//Grava Linha
		
	
		Li++			
 
   
   cPV 		:= TRB->C5_NUM
   If MV_PAR08 = 2
   	cIPV 		:= TRB->C6_ITEM 
   EndIF
	TRB->(dbSkip())
EndDo

Li+=2
@ Li,000 Psay __PrtFatLine()



If MV_PAR08 == 3 .AND. !lCheck3 
	lCheck3 := .T.
 	cRegCSV := "" 
 	mv_par05 := 2
 	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))     
 	
// 	RelPCP26(lEnd,wnrel,cString)	
EndIf
nVez ++
EndDo   
If Li <> 80
   Roda(cbCont,cbTxt,Tamanho)
Endif

//+-------------------------------------------------------------------------------
//| Finaliza arquivo com extensao .CSV p/ usuario abrir no Excel.
//+-------------------------------------------------------------------------------

FClose(cArqCSV)
SET DEVICE TO SCREEN  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama o Excel         																 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If ApOleClient('MsExcel')
   oExcelApp:= MsExcel():New()
   oExcelApp:WorkBooks:Open(cArq)
   oExcelApp:SetVisible(.T.) 
EndIF */  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif 

  


MS_FLUSH()
dbSelectArea("TRB")
dbCloseArea()

Return