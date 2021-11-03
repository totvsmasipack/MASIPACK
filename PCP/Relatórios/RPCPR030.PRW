#Include "Rwmake.ch"
#include "shell.ch
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPR030     º Autor ³ Eduardo Bego Mantoanº Data ³ 22/10/14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Status do Pedido PCP.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RPCPR030()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "RPCR030"
Private cPict          := ""
Private titulo         := "Status do Pedido Categ 0,2,3,4,5"
Private nLin           := 80 
Private Cabec1         := ""                                                                                              
Private Cabec2         := " Item PV     COD             DESCRI                             UM      QTD    Estoque   N.B     RESER.   QTD Ent.   "
Private Cabec3         := ""
Private Cabec4         := "PC     ITEM QUANT PC     OP          SC     ITEM SC        LOG"
Private imprime        := .T.
Private aOrd           := {}
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private CbTxt          := ""
Private limite         := 220
Private tamanho        := "G"
Private nomeprog       := "Status do pedido PCP" // 
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cbtxt      	   := Space(10)
Private cbcont     	   := 00
Private CONTFL         := 01
Private m_pag          := 01
Private wnrel          := "RPCPR030" // 
Private cPerg2         := "XRPCPR030"
Private cString        := "SC6" 
Private cVer1          := "REST"
Private cVer2          := "SD"
Private cVer3          := "Estocagem" 
Private dDT 	       := Date()
Private apCol          := {}

Pergunte(cPerg2,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local n		:= 0
Local nOrdem
Local Li 	 := 0  
Local cUSUA  := ""
Local cPosi  := ""  
Local nTPP   := 0
Local cArq   := "C:\Relato_Microsiga\Status_do_Pedido_PCP_"+SubStr(MV_PAR01,1,6)+".CSV"  
Local aCol   := {} 
Local cProd  := ""
Local cItem2 := ""
Local cProd2 := ""
//+-------------------------------------------------------------------------------
//| Gera arquivo .CSV - INICIO
//+-------------------------------------------------------------------------------
If (cArqCSV := FCreate(cArq)) == -1
	
	Alert("Arquivo para o Excel não pode ser criado - Verifique se o mesmo não está aberto - Avise o Depto. de Informática")
	//Return
Else
	
	
	cRegCSV := "Status do PV PCP - emitida em " + DTOC(dDT)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	
	cRegCSV :=""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	
EndIF 

Cabec1:= "Status do PV PCP - emitida em " + DTOC(dDT) 
//+--------------------
//| Coluna de impressao
//+--------------------

/*
aAdd( aCol, 000 ) //	            1
aAdd( aCol, 012 ) //                2
aAdd( aCol, 028 ) //                3
aAdd( aCol, 064 ) //                4
aAdd( aCol, 067 ) // 	            5
aAdd( aCol, 076 ) //                6
aAdd( aCol, 094 ) //                7
aAdd( aCol, 106 ) //    		    8
aAdd( aCol, 118 ) //                9
aAdd( aCol, 130 ) //               10
aAdd( aCol, 142 ) //               11
aAdd( aCol, 154 ) //               12
aAdd( aCol, 140 ) //               13
aAdd( aCol, 150 ) //		       14
aAdd( aCol, 160 ) //               15
aAdd( aCol, 170 ) //               16
aAdd( aCol, 185 ) //               17
aAdd( aCol, 190 ) //               18
aAdd( aCol, 200 ) //               19
aAdd( aCol, 205 ) //               20
*/
aAdd( aCol, 000 ) //	            1
aAdd( aCol, 012 ) //                2
aAdd( aCol, 028 ) //                3
aAdd( aCol, 064 ) //                4
aAdd( aCol, 067 ) // 	            5
aAdd( aCol, 076 ) //                6
aAdd( aCol, 085 ) //                7
aAdd( aCol, 094 ) //    		    8
aAdd( aCol, 103 ) //                9
aAdd( aCol, 114 ) //               10
aAdd( aCol, 126 ) //               11
aAdd( aCol, 136 ) //               12
aAdd( aCol, 146 ) //               13
aAdd( aCol, 158 ) //		       14
aAdd( aCol, 164 ) //               15
aAdd( aCol, 170 ) //               16
aAdd( aCol, 185 ) //               17
aAdd( aCol, 190 ) //               18
aAdd( aCol, 200 ) //               19
aAdd( aCol, 205 ) //               20   

aAdd( apCol, 108 ) //      1
aAdd( apCol, 112 ) //      2
aAdd( apCol, 131 ) //      3
aAdd( apCol, 140 ) //      4
aAdd( apCol, 149 ) //      5
aAdd( apCol, 162 ) //      6
aAdd( apCol, 171 ) //      7
aAdd( apCol, 200 ) //      8
aAdd( apCol, 209 ) //      9
aAdd( apCol, 218 ) //      10
aAdd( apCol, 200 ) //      11
aAdd( apCol, 210 ) //      12
If MV_PAR07 = 2  
	If ALLTRIM(MV_PAR01) == "" 
	  
		If Select("QL1") > 0
			DbSelectArea("QL1")
			DbCloseArea()
		EndIf   
		
		cQuery := " SELECT * "
		cQuery += " FROM "+RetSqlName("SC5")+" SC5  "
		cQuery += " WHERE C5_MSCONCL = ''  "
		cQuery += " AND C5_NOTA = '' "
		cQuery += " AND C5_NOTA NOT LIKE 'X' "
		cQuery += " AND SC5.D_E_L_E_T_='' "   
		If MV_PAR02 = 2
			cQuery += " AND C5_MSCATEG <> '0'	
		EndIf
		If MV_PAR03 = 2
			cQuery += " AND C5_MSCATEG <> '2'	
		EndIf
		If MV_PAR04 = 2
			cQuery += " AND C5_MSCATEG <> '3'	
		EndIf
		If MV_PAR05 = 2
			cQuery += " AND C5_MSCATEG <> '4'	
		EndIf
		If MV_PAR06 = 2
			cQuery += " AND C5_MSCATEG <> '5'	
		EndIf
		cQuery += " AND C5_MSCATEG <> '' " 
		cQuery += " AND C5_MSCATEG <> '1' "
		cQuery += " AND C5_TIPO = 'N' "
		cQuery += " AND C5_FILIAL='"+xFilial("SC5")+"'    "
		cQuery += " AND C5_CLIENTE <> '999999' "
		
		cQuery += " ORDER BY C5_NUM  "  
		
		TcQuery cQuery New Alias "QL1" 
			
		dbSelectArea("QL1")
		dbGoTop()
		SetRegua( RecCount() )
			
		If !QL1->(EOF())
			MV_PAR01 := QL1->C5_NUM
		EndIf	 
		QL1->(DBSKIP())	
		Do While !QL1->(EOF())
			MV_PAR01 += ";"
			MV_PAR01 += QL1->C5_NUM       
			QL1->(DBSKIP())	
		EndDo
		
		
		If Select("QL1") > 0
			DbSelectArea("QL1")
			DbCloseArea()
		EndIf
	EndIf
	aArray      := {}
	aArrayC2 	:= StrToKarr( MV_PAR01 , ';')
	nNumElem := Len(aArrayC2) 
	Li:= 0
	For n := 1 to nNumElem 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Li := 8
		Li++ 
		@ Li,050 PSAY "************************* P E D I D O "+AllTrim(aArrayC2[n])+" *************************" 
		Li += 2    
		
		cRegCSV :="************************* P E D I D O "+AllTrim(aArrayC2[n])+" *************************" 
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		
		cRegCSV :="Pedido/Item;Codigo;Descricao;UM;Quantidade Pedido;Estoque;N.B;Reserva;Quantidade Entregue;Procedência"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
	
		cRegCSV :="" 
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		
		IF Select("QR1") > 0
			DbSelectArea("QR1")
			DbCloseArea()
		ENDIF
		
		dbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		DBSEEK(xFilial("SC5")+AllTrim(aArrayC2[n]))
		
		If SC5->C5_MSCATEG <> "1"            // Não pode ser máquina
		    
			cQuery := " SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_UM,C6_QTDENT,B1_PROCED,C7_NUM,C7_ITEM,C7_QUANT - C7_QUJE AS C7_QTD,C7_FORNECE,C7_DATPRF, "
		   cQuery += " C2_NUM,C2_ITEM,C2_QUANT,C1_NUM,C1_ITEM,C1_QUANT,C1_DATPRF  "
			cQuery += " FROM "+RetSqlName("SC6")+" SC6   "
			cQuery += " LEFT JOIN  "+RetSqlName("SC1")+" SC1 ON C6_PRODUTO = C1_PRODUTO AND C1_QUANT > C1_QUJE    AND SC1.D_E_L_E_T_ = '' AND C1_FILIAL = '"+xFilial("SC1")+"' "
			cQuery += " LEFT JOIN  "+RetSqlName("SC2")+" SC2 ON C6_PRODUTO = C2_PRODUTO AND C2_DATRF = '        ' AND SC2.D_E_L_E_T_ = '' AND C2_FILIAL = '"+xFilial("SC2")+"' "
			cQuery += " LEFT JOIN  "+RetSqlName("SC7")+" SC7 ON C6_PRODUTO = C7_PRODUTO AND C7_QUANT > C7_QUJE    AND SC7.D_E_L_E_T_ = '' AND C7_FILIAL = '"+xFilial("SC7")+"' "
			cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON C6_PRODUTO = B1_COD     						  AND SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' " 
			cQuery += " INNER JOIN "+RetSqlName("SB2")+" SB2 ON C6_PRODUTO = B2_COD     						  AND SB2.D_E_L_E_T_ = '' AND B2_FILIAL = '"+xFilial("SB2")+"' "
			cQuery += " WHERE C6_NUM = '"+AllTrim(aArrayC2[n])+"' "
			cQuery += " AND C6_QTDVEN > C6_QTDENT  " 
			cQuery += " AND C6_BLQ <> 'R'  " 
			cQuery += " AND SC6.D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"'  "
			cQuery += " ORDER BY C6_NUM, C6_ITEM  	"   
			
			TcQuery cQuery New Alias "QR1" 
			
			dbSelectArea("QR1")
			dbGoTop()
			SetRegua( RecCount() )
			
			 
			
			Do While !QR1->(EOF())
			
				IF Select("QR4") > 0
					DbSelectArea("QR4")
					DbCloseArea()
				ENDIF
			
				nTPP := 0
				_ccCQuery := "	Select *  "
				_ccCQuery += "	FROM "+RetSqlName("SC6")+" SC6   "
				_ccCQuery += "	WHERE C6_PRODUTO = '"+QR1->C6_PRODUTO+"'  "
				_ccCQuery += "	AND C6_NOTA = '         '    "
				_ccCQuery += " AND SC6.D_E_L_E_T_ = ' ' "
				_ccCQuery += " AND C6_FILIAL = '"+xFilial("SC6")+"'   "
				_ccCQuery += "	ORDER BY C6_NUM "
				TcQuery _ccCQuery New Alias "QR4"
			
				dbSelectArea("QR4")
				dbGoTop("QR4")
				SetRegua( RecCount() )
				Do While !QR4->(EOF())
					nTPP +=	QR4->C6_QTDVEN - QR4->C6_QTDENT
					QR4->(DBSKIP())
				EndDo        
				dbSelectArea("SB2")
				DBSETORDER(1)
				SB2->(DBSEEK(xFilial("SB2")+QR1->C6_PRODUTO))
				nTPP -= SB2->B2_QATU
				If nTPP < 0
					nTPP := 0	 
				EndIf
				nSATUAL := SB2->B2_QATU
				nSPDVEN := SB2->B2_RESERVA
				If Li > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					Li := 8
				Endif
				//@ Li,001 PSAY Cabec3 
				If QR1->C6_QTDVEN <= nSATUAL
				
					QR1->(DBSKIP())	
					LOOP
					
				EndIf
				Li++
				/*@ Li, aCol[1]  PSay QR1->LISTA		    +"|"
				@ Li, aCol[2]  PSay QR1->PAI			+"|"
				@ Li, aCol[3]  PSay cDescPai			+"|"
				@ Li, aCol[4]  PSay QR1->C2_UM			+"|"
				@ Li, aCol[5]  PSay nQuantPai	    Picture "@E 9,999.99"       +"|"
				@ Li, aCol[6]  PSay nSATUAL     	Picture "@E 9,999.99" 		+"|"
				@ Li, aCol[7]  PSay nTPP			Picture "@E 9,999.99" 		+"|"
				@ Li, aCol[8]  PSay nSPDVEN     	Picture "@E 9,999.99" 		+"|"  */
				
				@ Li, aCol[1]   PSay QR1->C6_NUM+"/"+QR1->C6_ITEM				+"|"
				@ Li, aCol[2]   PSay QR1->C6_PRODUTO		    			+"|"
				@ Li, aCol[3]   PSay QR1->C6_DESCRI							+"|"
				@ Li, aCol[4]   PSay QR1->C6_UM              				+"|"
				@ Li, aCol[5]   PSay QR1->C6_QTDVEN  Picture "@E 9,999.99"  +"|"
				@ Li, aCol[6]   PSay nSATUAL         Picture "@E 9,999.99" 	+"|"
				@ Li, aCol[7]   PSay nTPP		       Picture "@E 9,999.99" 	+"|"
				@ Li, aCol[8]   PSay nSPDVEN         Picture "@E 9,999.99" 	+"|"
				@ Li, aCol[9]   PSay QR1->C6_QTDENT  Picture "@E 9,999.99"	+"|"
				Li++ 
				cRegCSV :=QR1->C6_NUM+"/"+QR1->C6_ITEM+";"+QR1->C6_PRODUTO+";"+QR1->C6_DESCRI+";"+QR1->C6_UM+";"+STR(QR1->C6_QTDVEN)+";"+STR(nSATUAL)+";"+STR(nTPP)+";"+STR(nSPDVEN)+";"+STR(QR1->C6_QTDENT)+";"+QR1->B1_PROCED 
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			 
				
				IF Select("QR2") > 0
					DbSelectArea("QR2")
					DbCloseArea()
				ENDIF
			
				nTPP := 0 
				
				_cCQuery := "	SELECT D4_COD,D4_OP,D4_QTDEORI,D4_QUANT,B1_DESC,B1_UM,B1_PROCED,B2_QATU,B2_RESERVA,B2_RESERVA + B2_QEMP AS NB  "
				_cCQuery += "	FROM "+RetSqlName("SD4")+" SD4   "
				_cCQuery += "	INNER JOIN "+RetSqlName("SB1")+" SB1 ON D4_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = '"+xFilial("SB1")+"' "
				_cCQuery += "	INNER JOIN "+RetSqlName("SB2")+" SB2 ON D4_COD = B2_COD AND SB2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' " 
				_cCQuery += "	WHERE  D4_OP Like '"+QR1->C6_NUM+QR1->C6_ITEM+"001' "
				_cCQuery += "	AND D4_COD NOT LIKE '%MP%'   "  
				_cCQuery += "	AND D4_DATA BETWEEN '" + DTOS(MV_PAR08) + "' AND '" + DTOS(MV_PAR09) + "' "
				_cCQuery += "	AND D4_QUANT > 0 "
				_cCQuery += "  AND SD4.D_E_L_E_T_ = ' ' "
				_cCQuery += "  AND D4_FILIAL = '"+xFilial("SD4")+"'   "
				_cCQuery += "	ORDER BY D4_COD "
				TcQuery _cCQuery New Alias "QR2"
			
				dbSelectArea("QR2")
				dbGoTop("QR2")
				SetRegua( RecCount() )
				
				 
				 
				cProd 	:= QR1->C6_PRODUTO  
				cLog 	:= VLOG(QR1->C2_NUM+QR1->C2_ITEM+"001") 
				cItem 	:= QR1->C6_ITEM 
				Do While QR1->C6_PRODUTO == cProd .AND. QR1->C6_ITEM == cItem 
					If Li > 65
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						Li := 8
					Endif 
					
					   /*
						@ Li, apCol[4]   PSay "NumPC:"+QR2->NUMERO
						@ Li, apCol[5]   PSay "Dat.Entr.PC:"
						@ Li, apCol[6]   PSay STOD(QR2->DAT)
						@ Li, apCol[7]   PSay "Fornece:"+QR2->FORN
						@ Li, apCol[8]   PSay "QuantPC:"
						@ Li, apCol[9]   PSay QR2->QTD Picture "@E 9,999.99"
						                                                */
					If ALLTRIM(QR1->C2_NUM) <> ""  
					                 
					   //	@ Li, apCol[1]  PSAY "OP ->"
						@ Li, apCol[2]  PSay "NumOP: "  + QR1->C2_NUM+QR1->C2_ITEM+"001|"
						@ Li, apCol[3]  PSay "QTD: "  + ALLTRIM(STR(QR1->C2_QUANT)) +"|" 
						@ Li, apCol[4]  PSay "Log:" + cLog							+"|"
			  			Li++ 
			  			cRegCSV := QR1->C6_NUM+"/"+QR1->C6_ITEM+";"+QR1->C6_PRODUTO+";;;;;;;"+"NumOP: "+QR1->C2_NUM+QR1->C2_ITEM+"001;"+"QTD: "+ALLTRIM(STR(QR1->C2_QUANT))+";Log:" + cLog
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))  
			  			
					ElseIf ALLTRIM(QR1->C7_NUM) <> ""  
					
						//@ Li, apCol[3]  PSAY "PC ->"
				  		@ Li, apCol[2]   PSay "NumPC: " +QR1->C7_NUM		    		    	+"|"
						@ Li, apCol[3]-2   PSay "Item: " +QR1->C7_ITEM		   				+"|"
						@ Li, apCol[4]+2 PSay "QTD: " +ALLTRIM(STR(QR1->C7_QTD))   		+"|"		
			   			@ Li, apCol[5]PSay "PrvEnt: " +DTOC(STOD(QR1->C7_DATPRF)) 	+"|"
			  			Li++      
			  			cRegCSV := QR1->C6_NUM+"/"+QR1->C6_ITEM+";"+QR1->C6_PRODUTO+";;;;;;;"+"NumPC: " +QR1->C7_NUM+";"+"Item: " +QR1->C7_ITEM+";QTD: "+ALLTRIM(STR(QR1->C7_QTD))+";"+"PrvEnt: " +DTOC(STOD(QR1->C7_DATPRF))+";Fornecedor: "+QR1->C7_FORNECE
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
					ElseIf ALLTRIM(QR1->C1_NUM) <> ""   
					         
						//@ Li, apCol[3]  PSAY "SC ->"
						@ Li, apCol[2]  PSay "NumSC: "  +QR1->C1_NUM	    			+"|"
						@ Li, apCol[3]-2  PSay "Item: "  +QR1->C1_ITEM		   			+"|"
				 		@ Li, apCol[4]+2  PSay "QTD: "  +ALLTRIM(STR(QR1->C1_QUANT))  	+"|" 						
			   	 		@ Li, apCol[5]  PSay "PrvEnt: " +DTOC(STOD(QR1->C1_DATPRF)) 	+"|"
			  			Li++
			  			cRegCSV := QR1->C6_NUM+"/"+QR1->C6_ITEM+";"+QR1->C6_PRODUTO+";;;;;;;"+"NumSC: " +QR1->C1_NUM+";"+"Item: " +QR1->C1_ITEM+";QTD: "+ALLTRIM(STR(QR1->C1_QUANT))+";"+"PrvEnt: " +DTOC(STOD(QR1->C1_DATPRF))
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
					EndIf    
					QR1->(DBSKIP()) 
				EndDo
					
				Do While !QR2->(EOF()) 
				  
					Li++
				   	@ Li, aCol[2]   PSay QR2->D4_COD			    			+"|"
					@ Li, aCol[3]   PSay QR2->B1_DESC	            			+"|"
					@ Li, aCol[4]   PSay QR2->B1_UM              				+"|"
					@ Li, aCol[5]   PSay QR2->D4_QTDEORI Picture "@E 9,999.99" 	+"|"
					@ Li, aCol[6]   PSay QR2->B2_QATU    Picture "@E 9,999.99" 	+"|"
					@ Li, aCol[7]   PSay QR2->NB     	 Picture "@E 9,999.99" 	+"|"
					@ Li, aCol[8]  PSay QR2->B2_RESERVA Picture "@E 9,999.99" 	+"|"
					@ Li, aCol[9]  PSay QR2->D4_QUANT-QR2->D4_QTDEORI   Picture "@E 9,999.99"	+"|" 
					Li++ 
					cRegCSV :=";"+QR2->D4_COD+";"+QR2->B1_DESC+";"+QR2->B1_UM +";"+STR(QR2->D4_QTDEORI)+";"+STR(QR2->B2_QATU)+";"+STR(QR2->NB)+";"+STR(QR2->B2_RESERVA)+";"+STR(QR2->D4_QUANT-QR2->D4_QTDEORI)+";"+QR2->B1_PROCED  
					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					
					IF Select("QR3") > 0
						DbSelectArea("QR3")
						DbCloseArea()
					ENDIF
					cPD := QR2->D4_COD  
					lP:= .T.
					If QR2->B1_PROCED == '2P'.OR. QR2->B1_PROCED == '3P'
						nC := 2
						_cQuery := " SELECT C1_NUM AS NUMERO,C1_PRODUTO AS PROD,C1_QUANT AS QTD,C1_NUM AS RET,C1_DATPRF AS DAT,C1_FORNECE AS FORN, C1_ITEM AS ITEM "
			 			_cQuery += " FROM "+RetSqlName("SC1")+" SC1    "
			 			_cQuery += " WHERE C1_FILIAL = '"+xFilial("SC1")+"' "
			 			_cQuery += " AND SC1.D_E_L_E_T_ = ' ' "
			 			_cQuery += " AND C1_PRODUTO = '"+cPD+"' "
			 			_cQuery += " AND C1_PEDIDO = '      '  "
						_cQuery += " AND C1_RESIDUO <> 'S'  "
				
						_cQuery += " UNION ALL
				
						_cQuery += " SELECT C7_NUM AS NUMERO,C7_PRODUTO AS PROD,C7_QUANT AS QTD,C7_RETFOR AS RET,C7_DATPRF AS DAT,C7_FORNECE AS FORN, C7_ITEM AS ITEM  "
						_cQuery += " FROM "+RetSqlName("SC7")+" SC7  "
						_cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '"+xFilial("SA2")+"' AND SA2.D_E_L_E_T_ = ' '         "
			 			_cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"'       "
						_cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
						_cQuery += " AND C7_RESIDUO <> 'S'  "
						_cQuery += " AND C7_QUANT > C7_QUJE "
						_cQuery += " AND C7_OBS NOT LIKE '%PV%' "
						_cQuery += " AND C7_PRODUTO = '"+cPD+"'  "
						_cQuery += " ORDER BY C1_NUM   "
						
		   			ElseIf QR2->B1_PROCED == '1P'
		 				nC := 1
		   			_cQuery := " SELECT C2_NUM + C2_ITEM + C2_SEQUEN AS LISTA, C2_PRODUTO AS PROD, C2_QUANT AS QTD,C2_MSUSER AS USU,C2_MSPOSIC AS POSIC,C2_MSDTCI AS DTCI,C2_MSIMPR "
		   			_cQuery += " FROM "+RetSqlName("SC2")+" SC2  "
		   			_cQuery += " WHERE C2_PRODUTO = '"+cPD+"' "
		  				_cQuery += " AND C2_DATRF ='' "
		   			_cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"'    "
		  				_cQuery += " AND SC2.D_E_L_E_T_ = ' ' "
		 				_cQuery += " ORDER BY C2_NUM	" 
		 			Else
		 				ALERT("Produto: "+cPD+" não é produtivo, verifique o cadastro")
		 				lP:= .F.
				
		  			EndIf
		  			If lP
		   			TcQuery _cQuery New Alias "QR3"
			
			  			dbSelectArea("QR3")
			 			dbGoTop("QR3")
			  			SetRegua( RecCount() )
					
						If nC == 1
							cLog2 := VLOG(QR3->LISTA) 
						EndIf 
					EndIf						
					Do while !QR3->(EOF()) .AND. lP      
					
						If Li > 65
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							Li := 8
						Endif   
						
				 		If  nC == 1                  
			  				@ Li, apCol[2]  PSay "NumOP: "    + QR3->LISTA   		    	+"|"
			 				@ Li, apCol[3]  PSay "QTD: "    + ALLTRIM(STR(QR3->QTD)) 	+"|" 
							@ Li, apCol[4]  PSay "Log: "     + cLog2					+"|"
				  			Li++
				  			cRegCSV := QR1->C6_NUM+"/"+QR1->C6_ITEM+";"+cPD+";;;;;;;"+"NumOP: "+QR3->LISTA+";"+"QTD: "+ALLTRIM(STR(QR3->QTD))+";Log:" + cLog2
							FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))   
							
						ElseIf QR3->RET <> QR3->NUMERO
					  		@ Li, apCol[2]  PSay "NumPC: "   +QR3->NUMERO		    	+"|"
							@ Li, apCol[3]-2  PSay "Item: "   +QR3->ITEM		   			+"|"
							@ Li, apCol[4]+2  PSay "QTD: "    +ALLTRIM(STR(QR3->QTD))   	+"|"		
				   			@ Li, apCol[5]  PSay "PrvEnt: " +DTOC(STOD(QR3->DAT)) 	    +"|"
				   			@ Li, apCol[6]  PSay "Ret. For?: " +QR3->RET                +"|"
				  			Li++
				  			cRegCSV := QR1->C6_NUM+"/"+QR1->C6_ITEM+";"+cPD+";;;;;;;"+"NumPC: " +QR3->NUMERO+";"+"Item: " +QR3->ITEM+";QTD: "+ALLTRIM(STR(QR3->QTD))+";"+"PrvEnt: " +DTOC(STOD(QR3->DAT))+";"+"Ret. For?: " +QR3->RET+";Fornecedor: "+QR3->FORN
							FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
							
						ElseIf QR3->RET == QR3->NUMERO            
							@ Li, apCol[2]  PSay "NumSC: "    +QR3->NUMERO		    	+"|"
							@ Li, apCol[3]-2  PSay "Item: "   +QR3->ITEM		   			+"|"
					 		@ Li, apCol[4]+2  PSay "QTD: "    +ALLTRIM(STR(QR3->QTD))  	+"|" 						
				   	 		@ Li, apCol[5]  PSay "PrvEnt: " +DTOC(STOD(QR3->DAT)) 	    +"|"
				  			Li++
				  			cRegCSV := QR1->C6_NUM+"/"+QR1->C6_ITEM+";"+cPD+";;;;;;;"+"NumSC: " +QR3->NUMERO+";"+"Item: " +QR3->ITEM+";QTD: "+ALLTRIM(STR(QR3->QTD))+";"+"PrvEnt: " +DTOC(STOD(QR3->DAT))
							FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
							
						EndIf    
						QR3->(DBSKIP()) 
			   	EndDo		
					QR2->(DBSKIP()) 
					If !QR2->(EOF())
						@ li,001 PSAY Replicate(" -  - ",37)
						Li++
						cRegCSV := ""
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					EndIf		
				EndDo    
		 		@ Li,000 Psay __PrtFatLine()
				Li++
				cRegCSV := ""
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
			EndDo
			
		Else
			ALERT("Não pode ser máquina") 
		EndIf 
	Next n 
	FClose(cArqCSV)
	SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
	Else 
	cRegCSV :="Pedidos de Compra"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))  
	
	
	cRegCSV :="PEDIDO COMPRA;ITEM;COD.FOR;NOME;PRODUTO;DESCRICAO;UM;QTD;EMISSAO PC;ENTREGA;PV+ITEM;OBSERVAÇÃO;PV;EntPv"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 

	
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf   

	//Pedidos de Compra
	cQuery := " SELECT C7_NUM,C7_ITEM,C7_FORNECE,A2_NREDUZ,C7_PRODUTO,B1_DESC,B1_UM,C7_QUANT,C7_EMISSAO,C7_DATPRF,C7_MSDTPE,C7_MSPV,C6_NUM,C6_ENTREG  "
	cQuery += " FROM "+RetSqlName("SC7")+" SC7  "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = C7_PRODUTO AND B1_FILIAL= '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_='' AND B1_PROCED <> '1P' " 
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = C7_FORNECE AND A2_FILIAL= '"+xFilial("SA2")+"' AND SA2.D_E_L_E_T_=''  "
	cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 ON C6_PRODUTO = C7_PRODUTO AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R'AND C6_FILIAL= '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_='' "
	cQuery += " WHERE C7_QUANT > C7_QUJE  " 
	cQuery += " AND C7_RESIDUO = ''      "
	cQuery += " AND C7_FILIAL  = '"+xFilial("SC7")+"'    "
	cQuery += " AND SC7.D_E_L_E_T_ = ''  "
	cQuery += " ORDER BY C7_NUM,C7_ITEM "

	
	TcQuery cQuery New Alias "QR1"
	
	TcSetField ("QR1","C7_QUANT"  ,"N",12,5)
	TcSetField ("QR1","C7_EMISSAO","D",08,0) 
	TcSetField ("QR1","C7_DATPRF" ,"D",08,0) 
	TcSetField ("QR1","C7_MSDTPE" ,"D",08,0)
	TcSetField ("QR1","C6_ENTREG" ,"D",08,0)			
	dbSelectArea("QR1")
	dbGoTop("QR1")
	SetRegua( RecCount() )
	Do while !QR1->(EOF())      
		cRegCSV := QR1->C7_NUM+";"+QR1->C7_ITEM+";"+QR1->C7_FORNECE+";"+QR1->A2_NREDUZ+";"+QR1->C7_PRODUTO+";"+QR1->B1_DESC+";"+QR1->B1_UM+";"+STR(QR1->C7_QUANT)+";"+DTOC(QR1->C7_EMISSAO)+";"+DTOC(QR1->C7_DATPRF)+";"+DTOC(QR1->C7_MSDTPE)+";"+QR1->C7_MSPV+";"+QR1->C6_NUM+";"+DTOC(QR1->C6_ENTREG)
	 	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		QR1->(DBSKIP())	
	EndDo  
		
	cRegCSV :=""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
	cRegCSV :="Ordens de Produção"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))  
		
	cRegCSV :="OP;ITEM;PRODUTO;DESCRICAO;UM;QTD;QTD ENTREGUE;LOG;ENTREGA OP;PV;ITEM PV;Ent Pv Item;Ent PV TOTAL;Ent PV TOTAL Atualizada"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
		
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf   
		
	//Ordens de Produção
	cQuery := " SELECT C2_NUM,C2_ITEM,C2_PRODUTO,B1_DESC,C2_UM,C2_QUANT,C2_QUJE,C2_MSPOSIC,C2_MSPED,C2_PEDIDO,C2_DATPRF,C6_NUM,C6_ITEM,C6_QTDVEN,C6_ENTREG,C5_MSDTENT,C5_MSDTPEN    "
	cQuery += " FROM "+RetSqlName("SC2")+" SC2  "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = C2_PRODUTO AND B1_PROCED = '1P' AND B1_FILIAL= '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_='' "
	cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 ON C6_PRODUTO = C2_PRODUTO AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND  C6_FILIAL= '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_='' "
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_NUM = C6_NUM AND  C5_FILIAL= '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_='' "
  	cQuery += " WHERE C2_QUANT > C2_QUJE  "
	cQuery += " AND C2_DATRF = ''  "
	cQuery += " AND C2_FILIAL  = '"+xFilial("SC2")+"'  "
	cQuery += " AND SC2.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY C2_NUM,C2_ITEM  "
	
	TcQuery cQuery New Alias "QR1"         
	
	TcSetField ("QR1","C2_QUANT"  ,"N",12,5)   
	TcSetField ("QR1","C2_QUJE"  ,"N",12,5)
	TcSetField ("QR1","C2_DATPRF","D",08,0) 
	TcSetField ("QR1","C6_ENTREG" ,"D",08,0)  
	TcSetField ("QR1","C5_MSDTENT" ,"D",08,0)
	TcSetField ("QR1","C5_MSDTPEN" ,"D",08,0)
				
	dbSelectArea("QR1")
	dbGoTop("QR1")
	SetRegua( RecCount() )
	Do while !QR1->(EOF()) 
	
		If Select("LR4") > 0
			DbSelectArea("LR4")
			DbCloseArea()
		EndIf 
  	
  		cQuery := " 	SELECT *     	"
  		cQuery += " 	FROM "+RetSqlName("SC9")+" SC9     	"   
  		cQuery += "    WHERE C9_FILIAL= '"+xFilial("SC9")+"' AND SC9.D_E_L_E_T_=''
  		cQuery += " 	AND C9_PEDIDO+C9_ITEM = '"+QR1->C6_NUM+QR1->C6_ITEM+"'	" 
  		cQuery += " 	AND C9_PRODUTO = '"+QR1->C2_PRODUTO+"'	" 
  		TcQuery cQuery New Alias "LR4"   
		dbSelectArea("LR4")
		dbGoTop("LR4") 
		lPula := .F.
		nSomaC9 := 0
  		Do While !LR4->(EOF())        
  			If LR4->C9_QTDLIB < QR1->C6_QTDVEN
  				nSomaC9 +=	LR4->C9_QTDLIB	
  			Else 
  				lPula := .T.	
  			EndIf  
  			
  			If nSomaC9 >= QR1->C6_QTDVEN
  				lPula := .T.
  			EndIf   
  			
  			LR4->(DBSKIP())
  		EndDo
  		If Select("LR4") > 0
			DbSelectArea("LR4")
			DbCloseArea()
		EndIf  
		
  		If lPula
  			QR1->(DBSKIP())
  			LOOP
  		EndIf
  		
		If Select("LR3") > 0
			DbSelectArea("LR3")
			DbCloseArea()
		EndIf     
					
		_cQuery4 := " SELECT *	"
		_cQuery4 += " FROM "+RetSqlName("SZS")+" SZS     "
		_cQuery4 += " WHERE ZS_OP = '"+QR1->C2_NUM+"01001'  "
		_cQuery4 += " AND ZS_FILIAL= '"+xFilial("SZS")+"'    "  
		_cQuery4 += " AND ZS_QTDE > 0 "  
		_cQuery4 += " AND (ZS_POSICAO LIKE '%"+cVer1+"%' OR ZS_POSICAO LIKE '%"+cVer2+"%' OR ZS_POSICAO LIKE '%"+cVer3+"%') "
		_cQuery4 += " AND SZS.D_E_L_E_T_=''   "
		_cQuery4 += " ORDER BY R_E_C_N_O_ DESC  "
					
		TcQuery _cQuery4 New Alias "LR3"   
		dbSelectArea("LR3")
		dbGoTop("LR3") 
		cUSUA := ""
		cPosi := ""  
				
		If !LR3->(EOF())
			cUSUA :=  Alltrim(LR3->ZS_USUARIO)
			cPosi :=  Alltrim(LR3->ZS_POSICAO)	
		EndIf   
		If cPosi == ""  
			cPosi := "OP excluída ou não apontada"
			cUSUA := " "
		EndIF 
		If Len(alltrim(MV_PAR12)) = 3
			If alltrim(MV_PAR12) <> SUBSTR(LR3->ZS_CC,1,3) 
		   	LR2->(dbSKIP())
				LOOP  
			EndIf
		ElseIf Len(alltrim(MV_PAR12)) = 6
			If alltrim(MV_PAR12) <> SUBSTR(LR3->ZS_CC,1,6) 
		   	LR2->(dbSKIP())
				LOOP  
			EndIf
		EndIf 
		cRegCSV := QR1->C2_NUM+";"+QR1->C2_ITEM+";"+QR1->C2_PRODUTO+";"+QR1->B1_DESC+";"+QR1->C2_UM+";"+STR(QR1->C2_QUANT)+";"+STR(QR1->C2_QUJE)+";"+cPosi+";"+DTOC(QR1->C2_DATPRF)+";"+QR1->C6_NUM+";"+QR1->C6_ITEM+";"+DTOC(QR1->C6_ENTREG)+";"+DTOC(QR1->C5_MSDTENT)+";"+DTOC(QR1->C5_MSDTPEN) 
	 	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
		QR1->(DBSKIP())	
	EndDo  
	
	
			
EndIf

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf 
If Select("LR3") > 0
	DbSelectArea("LR3")
	DbCloseArea()
EndIf          
FClose(cArqCSV)
_cEXE2  := "cmd /c C:\Relato_Microsiga\Status_do_Pedido_PCP_"+SubStr(MV_PAR01,1,6)+".CSV "
WaitRun(_cEXE2)		
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
Static Function VLOG(cLista2) 

Local cLOG := "" 

///Verifica Log
			dbSelectArea("SZS")
			SZS->(DbSetOrder(2))
			If SZS->(DbSeek(xFilial("SZS")+Alltrim(cLista2)))
				Do While SZS->(!Eof()) .And. Alltrim(SZS->ZS_OP) == Alltrim(cLista2)
					If cVer1 $ SZS->ZS_POSICAO .OR. cVer2 $ SZS->ZS_POSICAO .OR. cVer3 $ SZS->ZS_POSICAO
						cLOG :=  Alltrim(SZS->ZS_USUARIO)+"-"
						cLOG :=  Alltrim(SZS->ZS_POSICAO)
					EndIF
					SZS->(DbSkip())
				EndDo
			EndIf
			If ALLTRIM(cLOG)==""
				cLOG:="Log não apontado"	
			EndIf
			SZS->(dbCloseArea())

Return cLOG