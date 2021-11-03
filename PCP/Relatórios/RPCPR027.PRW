#Include "Rwmake.ch"
#include "shell.ch
#Include "Topconn.ch"

/*/{Protheus.doc} RPCPR027
//TODO Descrição auto-gerada.
@author Eduardo Mantoan
@since 16/06/2014
@version 1.0
@return .T.

@type User
/*/
User Function RPCPR027()

//+------------------------------------------------------------------------------+//
//| Declaracoes de variaveis                                                     |//
//+------------------------------------------------------------------------------+//

Local cDesc1  := "Status do Pedido Máquina"
Local cDesc2  := "parametros informado pelo usuario"
Local cDesc3  := ""

Private cString  := "SC2"
Private Tamanho  := "G"
Private aReturn  :=  {"Zebrado",1,"Administracao",1,2,1,"",0 }
Private wnrel    := "RPCPR027"
Private NomeProg := "RPCPR027"
Private nLastKey := 0
Private Limite   := 132
Private Titulo   := "Status do Pedido Máquina"
Private cPerg    := "XRPCPR027"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Li       := 800
Private m_pag    := 1
Private aOrd     := {}
Private Cabec1   := "Nº Lista    Cod. Prod.      Descrição                           UN     Quant     Est     N.B  Res.Vend. "//         |       SC          |                     PC                          | OP   Quant OP   Pisição    Lista(Falta)   Data CI "
Private Cabec2   := ""//                                                                                                            |Numero | Data Prev | Numero | Data | Fornecedor | Quant | Confirmado | 																  "
Private dDT 	  := Date()
Private cCC      := ""
#IFNDEF TOP
	MsgInfo("Não é possível executar este programa, está base de dados não é TopConnect","Incompatibilidade")
	RETURN
#ENDIF

//+-------------------------------------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------
Pergunte(cPerg,.T.)

//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,tamanho,.F.,.F.)
//SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)

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
RptStatus({|lEnd| RelSQLImp(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return


Static Function RelSQLImp(lEnd,wnrel,cString)
Local cFilSE2   := xFilial(cString)
Local cQuery    := ""
Local aCol      := {}
Local apCol     := {}
Local cFornec   := ""
Local cUMFilho	:= ""
Local nValor    := 0
Local nPago     := 0
Local nSaldo    := 0
Local nT_Valor  := 0
Local nT_Pago   := 0
Local nT_Saldo  := 0
Local nTPP		:= 0
Local nQuantPai := 0
Local lCheckT   := .F.
Local cArqExcel := ""
Local cNUM 		 := ""
Local nCheck    := 0
Local cDescPai  := ""
Local cNumPC    := ""
Local cItemPC   := ""
Local cNumOP    := ""
Local n			:= 0
Private cArq    := "C:\Relato_Microsiga\Status_do_Pedido_Maquina_"+SubStr(MV_PAR01,1,6)+".CSV"
Private cVer1   := "REST"
Private cVer2   := "SD"
Private cVer3   := "Estocagem"
//+-------------------------------------------------------------------------------
//| Gera arquivo .CSV - INICIO
//+-------------------------------------------------------------------------------
If (cArqCSV := FCreate(cArq)) == -1
	
	Alert("Arquivo para o Excel não pode ser criado - Verifique se o mesmo não está aberto - Avise o Depto. de Informática")
	//Return
Else
	
	
	cRegCSV := "Status do PV maquina - emitida em " + DTOC(dDT)
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	
	
EndIF
//+-------------------------------------------------------------------------------
//| Gera arquivo .CSV - FIM
//+-------------------------------------------------------------------------------



//+--------------------
//| Coluna de impressao
//+--------------------


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

aAdd( apCol, 103 ) //      1
aAdd( apCol, 118 ) //      2
aAdd( apCol, 126 ) //      3
aAdd( apCol, 135 ) //      4
aAdd( apCol, 149 ) //      5
aAdd( apCol, 162 ) //      6
aAdd( apCol, 171 ) //      7
aAdd( apCol, 200 ) //      8
aAdd( apCol, 209 ) //      9
aAdd( apCol, 218 ) //      10
aAdd( apCol, 200 ) //      11
aAdd( apCol, 210 ) //      12
If MV_PAR07 = 1
	
	cProced := "1%"
	
ElseIF MV_PAR07 = 2
	
	cProced := "2%"
	
ElseIF MV_PAR07 = 3
	
	cProced := "3%"
	
EndIF


aArray      := {}
aArrayC2 	:= StrToKarr( MV_PAR01 , ';')
nNumElem := Len(aArrayC2)
For n := 1 to nNumElem
	Li := 800
	IF Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	ENDIF
	IF Select("QR2") > 0
	  		DbSelectArea("QR2")
	   		DbCloseArea()
	ENDIF
	
	If Len(AllTrim(aArrayC2[n])) = 11   
	
		dbSelectArea("SC2")
		SC2->(DbSetOrder(1)) 
		DBSEEK(xFilial("SC2")+AllTrim(aArrayC2[n])) 
		
		cNumpv := SC2->C2_MSPED
		
  		dbSelectArea("SC5")
		SC5->(DbSetOrder(1)) 
		DBSEEK(xFilial("SC5")+AllTrim(cNumpv)) 
		
	ElseIf Len(AllTrim(aArrayC2[n])) = 6 
	   
		dbSelectArea("SC5")
		SC5->(DbSetOrder(1)) 
		DBSEEK(xFilial("SC5")+AllTrim(aArrayC2[n])) 

	Else
		ALERT("Erro no pedido/OP digitada, verifique(OP 11 digitos - PV 6 digitos)")
	EndIf
	
	cQuery := " SELECT C2_NUM + C2_ITEM + C2_SEQUEN AS LISTA,B1C2.B1_UM 'C2_UM',C2_MSPED,C2_MSREDUZ,C2_NUM,C2_ITEM,C2_PRODUTO AS PAI," 
	cQuery += " ISNULL(C6_DESCRI,B1C2.B1_DESC) 'C6_DESCRI',ISNULL(C6_QTDVEN,0) 'C6_QTDVEN', "
	cQuery += "(SELECT ISNULL(SUM(C6_QTDVEN),0) FROM "+RetSQLName("SC6")+" C6 WHERE C6_NUM = '603190' AND C6_PRODUTO = C2_PRODUTO AND C6.D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"') AS 'NQUANTPAI',"
	cQuery += " D4_COD AS FILHO,SB1.B1_DESC, SB1.B1_UM, "
	cQuery += " B2_RESERVA + B2_QEMP AS NB,B2_QEMP,D4_QUANT,D4_QTDEORI,B2_QATU,B2_RESERVA,C2_MSDTCI,D4_MSLF,SB1.B1_PROCED,C2_MSREDUZ,D4_MSREFER,C2_MSIMPR, SB1.B1_UPRC,SB1.B1_TIPO "
	cQuery += " 	,(Select ISNULL(SUM(ISNULL(C6_QTDVEN,0))-SUM(ISNULL(C6_QTDENT,0)),0) FROM SC6010 SC6 "
	cQuery += " WHERE C6_PRODUTO = SC2.C2_PRODUTO"
	cQuery += " 	  AND C6_NOTA = '         '"
	cQuery += " 	  AND SC6.D_E_L_E_T_ = ' '"
	cQuery += " 	  AND C6_FILIAL = '01') - CASE WHEN" 
	cQuery += " (Select ISNULL(SUM(ISNULL(C6_QTDVEN,0))-SUM(ISNULL(C6_QTDENT,0)),0) FROM SC6010 SC6"
	cQuery += " WHERE C6_PRODUTO = SC2.C2_PRODUTO"
	cQuery += " 	  AND C6_NOTA = '         '"
	cQuery += " 	  AND SC6.D_E_L_E_T_ = ' '"
	cQuery += " 	  AND C6_FILIAL = '01') > B2_QATU THEN B2_QATU ELSE 0 END" 
	cQuery += "  as 'nTPP' "
	cQuery += " FROM "+RetSqlName("SC2")+" SC2 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1C2 ON C2_PRODUTO = B1_COD AND B1C2.D_E_L_E_T_ = ' ' AND B1C2.B1_FILIAL = '"+xFilial("SB1")+"'"   
	cQuery += " LEFT  JOIN "+RetSqlName("SD4")+" SD4 ON C2_NUM + C2_ITEM + C2_SEQUEN = D4_OP AND SD4.D_E_L_E_T_ = ' ' AND D4_FILIAL = C2_FILIAL "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON D4_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " INNER JOIN "+RetSqlName("SB2")+" SB2 ON D4_COD = B2_COD AND SB2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = SB1.B1_LOCPAD"
	cQuery += "	LEFT  JOIN "+RetSqlName("SC6")+" SC6 ON C6_NUM = C2_NUM AND C6_PRODUTO = C2_PRODUTO AND  C6_FILIAL = '01' AND SC6.D_E_L_E_T_ = ' ' "
	If MV_PAR13 = 1
		If Len(AllTrim(aArrayC2[n])) = 11
			cQuery += " WHERE D4_OP = '"+AllTrim(aArrayC2[n])+"'	 "
		ElseIf Len(AllTrim(aArrayC2[n])) = 6
			cQuery += " WHERE C2_MSPED = '"+AllTrim(aArrayC2[n])+"'	 "
		Else
			ALERT("PEDIDO DIGITADO NÂO CONFERE")
			Return
		EndIf
		cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"'   "	
	Else
		cQuery += " WHERE C2_FILIAL = '"+xFilial("SC2")+"'   "
		cQuery += " AND D4_COD NOT LIKE 'TSS%'      "
		cQuery += " AND SUBSTRING(D4_COD,1,1)<>'X'  "
		cQuery += " AND SUBSTRING(D4_COD,1,2)<>'TS' "
		cQuery += " AND B2_QATU < D4_QUANT   "
	EndIf
	If MV_PAR02 = 2
		cQuery += " AND SB1.B1_UM <> 'CJ'       " 
	Endif

	If !(MV_PAR07 = 4)
		cQuery += "AND SB1.B1_PROCED LIKE '"+cProced+"' "
	EndIF
	cQuery += "	AND D4_QUANT > 0  "
	cQuery += "	AND D4_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	//	cQuery += " AND C2_MSLISTA = 'S' "   -> Retirado para mostrar todos os Pedidos, e nãoo só de conjunto.22/09/2014 Eduardo
	
	If !Empty(MV_PAR06)
		cQuery += " AND B1_GRUPO = '"+MV_PAR06+"' "
	EndIF
	
	cQuery += " AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY C2_NUM, C2_ITEM,C2_SEQUEN,D4_COD   "
	If !(SC5->C5_MSCATEG == "1") .AND. SubStr(cNumEmp,1,2) $ "01"
	   	lCheckT := .T.
	 		Alert("O pedido "+AllTrim(aArrayC2[n])+" não é de categoria 1")
		Return .F.
	EndIf
	
	TcQuery cQuery New Alias "QR1"
	dbSelectArea("QR1")
	QR1->(dbGoTop())
	SetRegua( RecCount() )
	
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	
	cRegCSV := "**************************** P E D I D O  : "+AllTrim(aArrayC2[n])+" - "+C2_MSREDUZ+" ****************************"
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	
	cRegCSV := ""
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	If SubStr(cNumEmp,1,2) $ "10"
		If MV_PAR10 = 1
			cRegCSV := "Nº Lista;Cod. Prod.;Descrição;PV EMP;Cliente;UN;Quant;Est;N.B;Res.Vend.;Ref;Numero SC;Data Prev SC;Quant SC;Numero PC;Data PRV. PC;Fornecedor;Quant PC;Confirmado;OP;Quant OP;CC;Posição;Lista(Falta);Data CI;Impressão da OP"
		Else 
			cRegCSV := "Nº Lista;Cod. Prod.;Descrição;Quant;Est;N.B;OP/PC/SC;Quant;Posição/Fornecedor;Data PC/SC;Lista de Falta;Data CI;Centro de Custo;Ultimo Preço de Compra;Ult.Prec.Compras * Quant"
	
		//	cRegCSV := "Nº Lista;Cod. Prod.;Descrição;PV EMP;UN;Quant;Est;N.B;Res.Vend.;Ref;Numero SC;Data Prev SC;Quant SC;Numero PC;Data PRV. PC;Fornecedor;Quant PC;Confirmado;OP;Quant OP;CC;Posição;Lista(Falta);Data CI;Impressão da OP"
		EndIF
	Else
		If MV_PAR10 = 1
			cRegCSV := "Nº Lista;Cod. Prod.;Descrição;PV EMP;Cliente;UN;Quant;Est;N.B;Res.Vend.;Ref;Numero SC;Data Prev SC;Quant SC;Numero PC;Data PRV. PC;Fornecedor;Quant PC;Confirmado;OP;Quant OP;Posição;Lista(Falta);Data CI;Impressão da OP"
		Else
			cRegCSV := "Nº Lista;Cod. Prod.;Descrição;PV EMP;UN;Quant;Est;N.B;Res.Vend.;Ref;Numero SC;Data Prev SC;Quant SC;Numero PC;Data PRV. PC;Fornecedor;Quant PC;Confirmado;OP;Quant OP;Posição;Lista(Falta);Data CI;Impressão da OP"
		EndIF
	EndIf
	FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
	Cabec2 := "Data do empenho: "+DTOC(MV_PAR03)+" - "+DTOC(MV_PAR04)+" Centro de Custo: "+ MV_PAR12
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	Li := 9
	@ Li, aCol[5]  PSay "**************************** P E D I D O  : "+AllTrim(aArrayC2[n])+" - "+C2_MSREDUZ+" ****************************"
	Li += 2
	cNUM 	 := ""
	nCheck := 1
	DO WHILE !QR1->(EOF())
		If Li > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Endif
		If cNUM <> QR1->PAI
			cNUM 	 := QR1->PAI
			cDescPai := QR1->C6_DESCRI
			cUMPai   := QR1->C2_UM
			cProcedP := QR1->B1_PROCED
			If QR1->C6_QTDVEN <= 0
				nQuantPai := QR1->NQUANTPAI
			ELSE
				nQuantPai := QR1->C6_QTDVEN
			EndIF

			If nTPP > QR1->B2_QATU
				nTPP -= QR1->B2_QATU
			EndIf
			nSATUAL := QR1->B2_QATU
			nSPDVEN := QR1->B2_RESERVA
   		
			If !((QR1->C2_UM == "CJ" .OR. QR1->B1_UM == "CJ" ).AND.  mv_par02 = 2 .AND. SubStr(cNumEmp,1,2) $ "10")
				@ Li, aCol[1]  PSay QR1->LISTA		+"|"
				@ Li, aCol[2]  PSay QR1->PAI			+"|"
				@ Li, aCol[3]  PSay cDescPai			+"|"
				@ Li, aCol[4]  PSay QR1->C2_UM		+"|"
				@ Li, aCol[5]  PSay nQuantPai	   Picture "@E 9,999.99"      +"|"
				@ Li, aCol[6]  PSay nSATUAL     	Picture "@E 9,999.99" 		+"|"
				@ Li, aCol[7]  PSay nTPP			Picture "@E 9,999.99" 		+"|"
				@ Li, aCol[8]  PSay nSPDVEN     	Picture "@E 9,999.99" 		+"|"
			   If SubStr(cNumEmp,1,2) $ "10"
			   
					If MV_PAR10 = 1
						cRegCSV := QR1->LISTA +";"+ ToXlsFormat("'"+QR1->PAI) +";"+ cDescPai +"; ;"+QR1->C2_MSREDUZ+";"+QR1->C2_UM+";"+STR(nQuantPai)+";"+STR(nSATUAL)+";"+STR(nTPP)+";"+STR(nSPDVEN)+";;;;;;;;;;;;;;;"+DTOC(STOD(QR1->C2_MSIMPR))
					Else 
						If MV_PAR13 = 1
							cRegCSV := QR1->LISTA +";"+ ToXlsFormat("'"+QR1->PAI) +";"+ cDescPai +";"+STR(nQuantPai)+";"+STR(nSATUAL)+";"+STR(nTPP)+";;;;;;;;;;;;;;;"
			   				//cRegCSV := QR1->LISTA +";"+ ToXlsFormat("'"+QR1->PAI) +";"+ cDescPai +"; ;"+QR1->C2_UM+";"+STR(nQuantPai)+";"+STR(nSATUAL)+";"+STR(nTPP)+";"+STR(nSPDVEN)+";;;;;;;;;;;;;;;"+DTOC(STOD(QR1->C2_MSIMPR))
						Else  
							cRegCSV := QR1->C2_MSPED +";"+ ToXlsFormat("'"+QR1->PAI) +";"+ cDescPai +";"+STR(nQuantPai)+";"+STR(nSATUAL)+";"+STR(nTPP)+";0;0;;;;;;;;;;;;;"
			   		EndIf
					EndIf 
				Else
					If MV_PAR10 = 1
						cRegCSV := QR1->LISTA +";"+ ToXlsFormat("'"+QR1->PAI) +";"+ cDescPai +"; ;"+QR1->C2_MSREDUZ+";"+QR1->C2_UM+";"+STR(nQuantPai)+";"+STR(nSATUAL)+";"+STR(nTPP)+";"+STR(nSPDVEN)+";;;;;;;;;;;;;;"+DTOC(STOD(QR1->C2_MSIMPR))
					Else
			   			cRegCSV := QR1->LISTA +";"+ ToXlsFormat("'"+QR1->PAI) +";"+ cDescPai +"; ;"+QR1->C2_UM+";"+STR(nQuantPai)+";"+STR(nSATUAL)+";"+STR(nTPP)+";"+STR(nSPDVEN)+";;;;;;;;;;;;;;"+DTOC(STOD(QR1->C2_MSIMPR))
					EndIf 
				EndIf
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
				Li++
			EndIf			
		EndIf
		
		cLF   := QR1->D4_MSLF
		cPROD := QR1->FILHO
		
		IF Select("QR3") > 0
			DbSelectArea("QR3")
			DbCloseArea()
		ENDIF
		
		
		
		_cCQuery := "	SELECT D4_COD,D4_OP,D4_QUANT,D4_QTDEORI,D4_MSREFER,D4_MSLF "
		If MV_PAR10 = 1
			_cCQuery += ",C2_MSREDUZ  "
		EndIF
		_cCQuery += " FROM "+RetSqlName("SD4")+" SD4  "
		If MV_PAR10 = 1
			_cCQuery += " INNER JOIN "+RetSqlName("SC2")+" SC2  ON (C2_NUM+C2_ITEM+C2_SEQUEN) = D4_OP  AND C2_FILIAL = '"+xFilial("SC2")+"'   AND SC2.D_E_L_E_T_ = ' '    "
		EndIf
		_cCQuery += " WHERE D4_COD = '"+QR1->FILHO+"'  "
		_cCQuery += " AND D4_QUANT > 0   "
		_cCQuery += " AND D4_DATA BETWEEN '"+ DTOS(MV_PAR03) +"' AND '" + DTOS(MV_PAR04) + "' "
		_cCQuery += " AND D4_FILIAL = '"+xFilial("SD4")+"'   "
		_cCQuery += " AND SD4.D_E_L_E_T_ = ' ' "
		
		_cCQuery += " ORDER BY D4_OP     "
		
		TcQuery _cCQuery New Alias "QR3"
		
		dbSelectArea("QR3")
		QR3->(dbGoTop())
		SetRegua( RecCount() )
		nTotProd := 0
		
		DO WHILE !QR3->(EOF())
			nTotProd	+= QR3->D4_QUANT
			QR3->(dbSKIP())
		EndDo
		
		If MV_PAR09 = 1
			If	QR1->B2_QATU >= nTotProd
				QR1->(dbSKIP())
				LOOP
			EndIF
		EndIf 
		
		
		///////////////////////////////////////////////////////////////////////////
		If !Empty(Alltrim(MV_PAR12))     
			If !VerCC()
				QR1->(dbSKIP())
					LOOP
			EndIf
		EndIf
		////////////////////////////////////////////////////////////////////////////
	   //	If MV_PAR11 = 1	
		If !(QR1->B1_UM == "CJ" .AND.  mv_par02 = 2 .AND. SubStr(cNumEmp,1,2) $ "10")
			@ Li, aCol[2]  PSay QR1->FILHO			+"|"
			@ Li, aCol[3]  PSay QR1->B1_DESC			+"|"
			@ Li, aCol[4]  PSay QR1->B1_UM				+"|"
			@ Li, aCol[5]  PSay QR1->D4_QUANT   Picture "@E 9,999.99"		+"|"
			@ Li, aCol[6]  PSay QR1->B2_QATU 	Picture "@E 9,999.99" 		+"|"
			@ Li, aCol[7]  PSay nTotProd +QR1->B2_RESERVA		Picture "@E 9,999.99" 		+"|"
			@ Li, aCol[8]  PSay QR1->B2_RESERVA	Picture "@E 9,999.99" 		+"|" 
		
			If MV_PAR10 = 1
				
				cRegCSV := " - ;"+ToXlsFormat("'"+QR1->FILHO) +";"+QR1->B1_DESC+"; ;"+ QR1->C2_MSREDUZ+";"+cUmFilho +";"+ STR(QR1->D4_QUANT) +";"+ STR(QR1->B2_QATU) +";"+ STR(nTotProd+QR1->B2_RESERVA) +";"+ STR(QR1->B2_RESERVA)+";"+ToXlsFormat("'"+QR1->D4_MSREFER)+";"
				
			Else
				If SubStr(cNumEmp,1,2) $ "10"
					If MV_PAR13 = 1 // COMPLETO     
						cRegCSV := " - ;"+ToXlsFormat("'"+QR1->FILHO) +";"+QR1->B1_DESC+";"+STR(QR1->D4_QUANT) +";"+ STR(QR1->B2_QATU) +";"+ STR(nTotProd+QR1->B2_RESERVA)
				   Else //RESUMIDO
				   	nPrec2:= Posicione("SB1",1,xFilial("SB1")+ALLTRIM(QR1->FILHO),"B1_UPRC") 
						If nPrec2 <= 0
					  		nPrec2:=	Posicione("SB1",1,xFilial("SB1")+ALLTRIM(QR1->FILHO),"B1_MSPRCRE")
					   EndIf
				   	cRegCSV := QR1->C2_MSPED+";"+ToXlsFormat("'"+QR1->FILHO) +";"+QR1->B1_DESC+";"+STR(QR1->D4_QUANT) +";"+ STR(QR1->B2_QATU) +";"+ STR(nTotProd+QR1->B2_RESERVA)+";"+ STR(nPrec2) +";"+STR(QR1->D4_QUANT * nPrec2 )
				  		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10)) 
				  		QR1->(DBSKIP())
				  		LOOP
					EndIf
				Else
					cRegCSV := " - ;"+ToXlsFormat("'"+QR1->FILHO) +";"+QR1->B1_DESC+"; ;"+cUmFilho +";"+ STR(QR1->D4_QUANT) +";"+ STR(QR1->B2_QATU) +";"+ STR(nTotProd+QR1->B2_RESERVA) +";"+ STR(QR1->B2_RESERVA)+";"+ToXlsFormat("'"+QR1->D4_MSREFER)+";"
				EndIf
			EndIF
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))

		EndIf	
			If MV_PAR05 = 1 .AND. MV_PAR11 = 1 .AND. SubStr(cNumEmp,1,2) $ "01"
				IF MV_PAR08 = 1
					If QR1->B2_QATU >= nTotProd
						
					ELse
						dbSelectArea("QR3")
						QR3->(dbGoTop())
						Li++
	 //					cRegCSV:=""
	//					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
						
						@ Li, aCol[2] PSay "Pedidos com Empenho ->"
					
					cRegCSV := " ; ; ;"
					DO WHILE !QR3->(EOF())
						If Li > 65
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						Endif
						@ Li, aCol[4] PSay "Pedido: "+SubSTR(QR3->D4_OP,1,6)
						@ Li, aCol[8] PSay "Necessidade: "+STR(QR3->D4_QUANT)
						Li ++
						If SubStr(cNumEmp,1,2) $ "10"
							If MV_PAR10 = 1
								cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";"+QR3->C2_MSREDUZ+";;;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
							Else
								cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";;;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
							EndIF
						Else
							If MV_PAR10 = 1
								cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";"+QR3->C2_MSREDUZ+";;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
							Else
								cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
							EndIF
						EndIf
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
						cRegCSV :=" ; ; ;"
						QR3->(dbSKIP())
					EndDo
				EndIF
			Else
				QR3->(dbGoTop())
				Li++
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
				
				
				@ Li, aCol[2] PSay "Pedidos com Empenho ->"
				
				cRegCSV := " ; ; ;"
				DO WHILE !QR3->(EOF())
					If Li > 65
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					Endif
					@ Li, aCol[4] PSay "Pedido: "+SubSTR(QR3->D4_OP,1,6)
					@ Li, aCol[8] PSay "Necessidade: "+STR(QR3->D4_QUANT)
					Li ++
					If SubStr(cNumEmp,1,2) $ "10"
					
						If MV_PAR10 = 1
							cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";"+QR3->C2_MSREDUZ+";;;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
						Else 
							cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";;;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
						  //	cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";;;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
						EndIF
					Else 
						If MV_PAR10 = 1
								cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";"+QR3->C2_MSREDUZ+";;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
						Else
							cRegCSV += SubSTR(QR3->D4_OP,1,6)+" - "+STR(QR3->D4_QUANT)+";;;;;;"+ToXlsFormat("'"+QR3->D4_MSREFER)+"-"+QR3->D4_MSLF
						EndIF
					EndIf
					FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					cRegCSV :=" ; ; ;"
					QR3->(dbSKIP())
				EndDo
			EndIF
		Else 
	   		If MV_PAR11 = 2
	   			Li ++
	   		EndIf
		EndIF
		
		QR3->(dbCloseArea())
		
		dbSelectArea("QR1")
		
		//nC1 := 0
		//nC2 := 0
		cNumOP := ""
		_cQuery1 := ""  
		_cQuery2 := ""
		If SubStr(cNumEmp,1,2) $ "10" 
	 		If QR1->B1_PROCED == '1P' .OR. QR1->B1_PROCED == '2P'.OR. QR1->B1_PROCED == '3P' 
				If MV_PAR12 == "   " .OR. MV_PAR12 == "      "
	   			_cQuery1 := " SELECT C1_NUM AS NUMERO,C1_PRODUTO AS PROD,C1_QUANT AS QTD,C1_NUM AS RET,C1_DATPRF AS DAT,C1_FORNECE AS FORN, C1_ITEM AS ITEM "
	   			_cQuery1 += " FROM "+RetSqlName("SC1")+" SC1    "
	   			_cQuery1 += " WHERE C1_FILIAL = '"+xFilial("SC1")+"' "
	   			_cQuery1 += " AND SC1.D_E_L_E_T_ = ' ' "
	   			_cQuery1 += " AND C1_PRODUTO = '"+cPROD+"' "
	   			_cQuery1 += " AND C1_PEDIDO = '      '  "
	   			_cQuery1 += " AND C1_RESIDUO <> 'S'  "
			    	
					_cQuery1 += " UNION ALL
			
					_cQuery1 += " SELECT C7_NUM AS NUMERO,C7_PRODUTO AS PROD,C7_QUANT AS QTD,C7_RETFOR AS RET,C7_DATPRF AS DAT,A2_NREDUZ AS FORN, C7_ITEM AS ITEM  "
					_cQuery1 += " FROM "+RetSqlName("SC7")+" SC7  "
					_cQuery1 += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '"+xFilial("SA2")+"' AND SA2.D_E_L_E_T_ = ' '         "
					_cQuery1 += " WHERE C7_FILIAL = '"+xFilial("SC7")+"'       "
					_cQuery1 += " AND SC7.D_E_L_E_T_ = ' ' "
					_cQuery1 += " AND C7_RESIDUO <> 'S'  "
					_cQuery1 += " AND C7_QUANT > C7_QUJE "
					_cQuery1 += " AND C7_OBS NOT LIKE '%PV%' "
					_cQuery1 += " AND C7_PRODUTO = '"+cPROD+"'  "
					_cQuery1 += " ORDER BY C1_NUM   " 
			
					TcQuery _cQuery1 New Alias "LR1"  
					dbSelectArea("LR1")
					LR1->(dbGoTop())  
			    EndIf
		 	//	If !LR1->(EOF())
		 	//		nC1 := 1
		 	//	EndIf
			
		 		_cQuery2 += " SELECT C2_NUM + C2_ITEM + C2_SEQUEN AS LISTA, C2_PRODUTO AS PROD, C2_QUANT AS QTD,C2_MSUSER AS USU,C2_MSPOSIC AS POSIC,C2_MSDTCI AS DTCI,C2_MSIMPR "
		 		_cQuery2 += " FROM "+RetSqlName("SC2")+" SC2  "
		 		_cQuery2 += " WHERE C2_PRODUTO = '"+cPROD+"' "
		 		_cQuery2 += " AND C2_DATRF ='' "  
		 		
				_cQuery2 += " AND C2_FILIAL = '"+xFilial("SC2")+"'    "
				_cQuery2 += " AND SC2.D_E_L_E_T_ = ' ' "
				_cQuery2 += " ORDER BY C2_NUM	"   
			
				TcQuery _cQuery2 New Alias "LR2"   
				dbSelectArea("LR2")
				LR2->(dbGoTop())   
				
			//	If !LR2->(EOF())
			//		nC2 := 1
			//	EndIf
			Else
				If !(Substr(cPROD,1,2) == "TS") .And. !(B1_TIPO == "MC")
					ALERT("Produto "+ALLTRIM(cPROD)+" é "+QR1->B1_PROCED+" sendo material de consumo e não de produção" )
				Endif
				QR1->(dbSKIP())
				Li++
				If cNUM <> QR1->PAI
					
					@ Li,000 Psay __PrtFatLine()
					Li++
				ELSE
					@ li,001 PSAY Replicate(" -  - ",37)
					Li++
				EndIF
				LOOP		
			EndIf   
	
			SetRegua( RecCount() )
			nCont := 0              
			nPrec1:= Posicione("SB1",1,xFilial("SB1")+ALLTRIM(cPROD),"B1_UPRC") 
			If nPrec1 <= 0
		  		nPrec1:=	Posicione("SB1",1,xFilial("SB1")+ALLTRIM(cPROD),"B1_MSPRCRE")
		   EndIf
			DO WHILE !LR2->(EOF())
			
				If Li > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				Endif
			
				If LR2->LISTA == cNumOP
					LR2->(dbSKIP())
					LOOP
				EndIF
				cPosi := ""
				cLista2  := LR2->LISTA    
				
				If Select("LR3") > 0
					DbSelectArea("LR3")
					DbCloseArea()
				EndIf     
				
				_cQuery4 := " SELECT *	"
				_cQuery4 += " FROM "+RetSqlName("SZS")+" SZS     "
				_cQuery4 += " WHERE ZS_OP ='"+cLista2+"'  "
				_cQuery4 += " AND ZS_FILIAL= '"+xFilial("SZS")+"'    "  
				_cQuery4 += " AND ZS_QTDE > 0 "  
				_cQuery4 += " AND (ZS_POSICAO LIKE '%"+cVer1+"%' OR ZS_POSICAO LIKE '%"+cVer2+"%' OR ZS_POSICAO LIKE '%"+cVer3+"%') "
				_cQuery4 += " AND SZS.D_E_L_E_T_=''   "
				_cQuery4 += " ORDER BY R_E_C_N_O_ DESC  "
				
				TcQuery _cQuery4 New Alias "LR3"   
				dbSelectArea("LR3")
				LR3->(dbGoTop()) 
				cUSUA := ""
				cPosi := ""  
			
		   	If !LR3->(EOF())
		   	/*	If Len(alltrim(MV_PAR12)) = 3
				  		If SUBSTR(LR3->ZS_CC,1,3) == ALLTRIM(MV_PAR12)  
				  			cUSUA :=  Alltrim(LR3->ZS_USUARIO)
				  			cPosi :=  Alltrim(LR3->ZS_POSICAO)	
				  	 	EndIf             
					ElseIf Len(alltrim(MV_PAR12)) = 6
						If SUBSTR(LR3->ZS_CC,1,6) == ALLTRIM(MV_PAR12)  
						  	cUSUA :=  Alltrim(LR3->ZS_USUARIO)
							cPosi :=  Alltrim(LR3->ZS_POSICAO)	
						EndIf
					EndIf     */
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
				
				
				//If ALLTRIM(MV_PAR12) == "" .OR. (alltrim(MV_PAR12) == SUBSTR(cPosi,2,3) .OR. alltrim(MV_PAR12) == SUBSTR(cPosi,2,3)) .OR. (MV_PAR12 == SUBSTR(cPosi,2,6) .OR. substr(MV_PAR12,1,3) == SUBSTR(cPosi,2,3))  
				If nCont > 0
					If MV_PAR10 = 1
						cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;;"
					Else 
						cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ;"
					 //	cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;"
					EndIf
					Li++
				Else
					//If MV_PAR05 = 1
					If MV_PAR10 = 1
						cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;;"
					Else
							cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ;"
					  //	cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;"
					EndIf
					//EndIF
				EndIF
				nCont++ 
				If     SUBSTR(LR3->ZS_CC,1,3) == "202" //Usinagem
					cCC :="US" 
				ElseIf SUBSTR(LR3->ZS_CC,1,3) == "203" //Funilaria
			  		cCC :="FU"
				ElseIf SUBSTR(LR3->ZS_CC,1,3) == "205" //Almoxarifado
			 		cCC :="ALMOX"
				ElseIf SUBSTR(LR3->ZS_CC,1,3) == "207" //PCP
			  		cCC :="PCP"      
			 	Else
			 		cCC :="Centro de não apontado"  	
				EndIf 
				If MV_PAR11 = 2
					@ Li, aCol[3] 	 PSay "OP:"+LR2->LISTA
					@ Li, aCol[4] 	 PSay "Qtd:"+Alltrim(STR(LR2->QTD))
				Else
					@ Li, aCol[9] 	 PSay "OP:"+LR2->LISTA
					@ Li, aCol[10]+4 	 PSay "Qtd:"+Alltrim(STR(LR2->QTD))
				EndIf
				If MV_PAR11 = 2
					@ Li, aCol[6] 	 PSay "Posição: "+SUBSTR(cPosi,9,80)+"-"+cUSUA
					@ Li, aCol[18]   PSay cLF
					@ Li, aCol[19] 	 PSay "Data CI: "+DTOC(STOD(LR2->DTCI))
				Else
					@ Li, aCol[11] 	 PSay "Posição: "+SUBSTR(cPosi,9,80)+"-"+cUSUA
					@ Li, aCol[20]+10   PSay cLF
				   //	@ Li, aCol[19] 	 PSay "Data CI: "+DTOC(STOD(QR2->DTCI))
				EndIf
				cNumOP := LR2->LISTA
			
				cRegCSV += LR2->LISTA +";"+STR(LR2->QTD) +";"+ cPosi+" - "+cUSUA +"; - ;"+cLF+";"+ DTOC(STOD(LR2->DTCI))+";"+cCC+";"+STR(nPrec1);STR(nPrec1*QR1->D4_QUANT)      
			  //	cRegCSV += "-;-;-;-;-;-;"+LR2->LISTA +";"+STR(LR2->QTD) +";"+cCC+";"+ cPosi+" - "+cUSUA +";"+cLF+";"+ DTOC(STOD(LR2->DTCI))+";"+DTOC(STOD(LR2->C2_MSIMPR))
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))  
				Li++	                                   
				
				
					
				LR2->(DBSKIP())
			   
			EndDo 
			If MV_PAR12 == "   " .OR. MV_PAR12 == "      "
		  		DO WHILE !LR1->(EOF())
		  			If LR1->NUMERO == cNumPC .AND. LR1->ITEM == cItemPC
		  				LR1->(dbSKIP())
		  				LOOP
		  			EndIF
				
		  			nCont++
				
		  			If LR1->RET == LR1->NUMERO
		  				If nCont > 0
		  					If MV_PAR10 = 1
		  						cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; ; "
		  					Else 
		  						cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; "
		  					 //	cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; "
		  					EndIf
		  					Li++
		  				Else
		  						//If MV_PAR05 = 1
							If MV_PAR10 = 1
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; ; "
							Else  
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ;"
							 //	cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; "
							EndIf
							//EndIF
						EndIF
						@ Li, apCol[1]   PSay "Num.SC:"+LR1->NUMERO
						@ Li, apCol[2]   PSay "DataSC:"
						@ Li, apCol[3]   PSay STOD(LR1->DAT)
						
						cNumPC := LR1->NUMERO
						cItemPC := LR1->ITEM
					  	cRegCSV += ToXlsFormat("'"+LR1->NUMERO) +"-"+LR1->ITEM+";"+ STR(LR1->QTD)+"; - ;"+ DTOC(STOD(LR1->DAT))+";;;;"+STR(nPrec1)
						
					Else
						
						If nCont > 0
							//If MV_PAR05 = 1
							If MV_PAR10 = 1
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ; ;"
							Else  
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ;"
							 //	cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ;"
							EndIf
							//EndIF
							Li++
						Else
							//If MV_PAR05 = 1
							
							If MV_PAR10 = 1
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ; ;"
							Else
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ;"
							  //	cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ;"
							EndIf
							
							//EndIF
						EndIF
						@ Li, apCol[4]   PSay "NumPC:"+LR1->NUMERO
						@ Li, apCol[5]   PSay "Dat.Entr.PC:"
						@ Li, apCol[6]   PSay STOD(LR1->DAT)
						@ Li, apCol[7]   PSay "Fornece:"+LR1->FORN
						@ Li, apCol[8]   PSay "QuantPC:"
						@ Li, apCol[9]   PSay LR1->QTD Picture "@E 9,999.99"
						
						If !Empty(LR1->RET)
							@ Li, apCol[10]PSay LR1->RET
							cSN := LR1->RET
						Else
							@ Li, apCol[10]PSay "N"
							cSN := ""
						EndIf
						cNumPC := LR1->NUMERO
						cItemPC := LR1->ITEM
						
					   	cRegCSV += ToXlsFormat("'"+LR1->NUMERO) +"-"+LR1->ITEM+";"+ STR(LR1->QTD)+";"+ LR1->FORN +";"+DTOC(STOD(LR1->DAT))+";;;;?"+STR(nPrec1)
					   	//cRegCSV += ToXlsFormat("'"+LR1->NUMERO) +"-"+LR1->ITEM+";"+ DTOC(STOD(LR1->DAT)) +";"+ LR1->FORN +";"+ STR(LR1->QTD) +";"+ cSN
					EndIf
					
		    	
						FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
					LR1->(dbSKIP()) 
					Li++
			
				EndDo  
			EndIf
		 
			IF Select("LR1") > 0
		  		DbSelectArea("LR1")
		   		DbCloseArea()
			ENDIF
			IF Select("LR2") > 0
		  		DbSelectArea("LR2")
		   		DbCloseArea()
			ENDIF
			If Select("LR3") > 0
				DbSelectArea("LR3")
				DbCloseArea()
			EndIf  
		ElseIf SubStr(cNumEmp,1,2) $ "01"
			nC:=0 
			IF Select("QR2") > 0
		  		DbSelectArea("QR2")
		   		DbCloseArea()
			ENDIF   
			_cQuery:=""
   			If QR1->B1_PROCED == '2P'.OR. QR1->B1_PROCED == '3P'
				nC := 2
				_cQuery := " SELECT C1_NUM AS NUMERO,C1_PRODUTO AS PROD,C1_QUANT AS QTD,C1_NUM AS RET,C1_DATPRF AS DAT,C1_FORNECE AS FORN, C1_ITEM AS ITEM "
				_cQuery += " FROM "+RetSqlName("SC1")+" SC1    "
				_cQuery += " WHERE C1_FILIAL = '"+xFilial("SC1")+"' "
				_cQuery += " AND SC1.D_E_L_E_T_ = ' ' "
				_cQuery += " AND C1_PRODUTO = '"+cPROD+"' "
				_cQuery += " AND C1_PEDIDO = '      '  "
				_cQuery += " AND C1_RESIDUO <> 'S'  "
			
				_cQuery += " UNION ALL
			
				_cQuery += " SELECT C7_NUM AS NUMERO,C7_PRODUTO AS PROD,C7_QUANT AS QTD,C7_RETFOR AS RET,C7_DATPRF AS DAT,A2_NREDUZ AS FORN, C7_ITEM AS ITEM  "
				_cQuery += " FROM "+RetSqlName("SC7")+" SC7  "
				_cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND A2_FILIAL = '"+xFilial("SA2")+"' AND SA2.D_E_L_E_T_ = ' '         "
				_cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"'       "
				_cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
				_cQuery += " AND C7_RESIDUO <> 'S'  "
				_cQuery += " AND C7_QUANT > C7_QUJE "
				_cQuery += " AND C7_OBS NOT LIKE '%PV%' "
				_cQuery += " AND C7_PRODUTO = '"+cPROD+"'  "
				_cQuery += " ORDER BY C1_NUM   "
			
			ElseIf QR1->B1_PROCED == '1P'
				nC := 1
				_cQuery := " SELECT C2_NUM + C2_ITEM + C2_SEQUEN AS LISTA, C2_PRODUTO AS PROD, C2_QUANT AS QTD,C2_MSUSER AS USU,C2_MSPOSIC AS POSIC,C2_MSDTCI AS DTCI,C2_MSIMPR "
				_cQuery += " FROM "+RetSqlName("SC2")+" SC2  "
				_cQuery += " WHERE C2_PRODUTO = '"+cPROD+"' "
				_cQuery += " AND C2_DATRF ='' "
				_cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"'    "
				_cQuery += " AND SC2.D_E_L_E_T_ = ' ' "
				_cQuery += " ORDER BY C2_NUM	"
			Else
				If !(Substr(Alltrim(cPROD),1,2) == "TS") .And. !(QR1->B1_TIPO == "MC")
					ALERT("Produto "+ALLTRIM(cPROD)+" é "+QR1->B1_PROCED+" sendo material de consumo e não de produção" )
				ENDIF
				QR1->(dbSKIP())
				Li++
				If cNUM <> QR1->PAI
					
					@ Li,000 Psay __PrtFatLine()
					Li++
				ELSE
					@ li,001 PSAY Replicate(" -  - ",37)
					Li++
				EndIF
				LOOP		
			EndIf
			TcQuery _cQuery New Alias "QR2"
		
		
			dbSelectArea("QR2")
			QR2->(dbGoTop())
			SetRegua( RecCount() )
			nCont := 0
			DO WHILE !QR2->(EOF())
			
				If Li > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				Endif
			
				If nC = 1
					If QR2->LISTA == cNumOP
						QR2->(dbSKIP())
						LOOP
					EndIF
					If nCont > 0
						If MV_PAR10 = 1
							cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;;"
						Else
							cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;"
						EndIf
						Li++
					Else
						//If MV_PAR05 = 1
						If MV_PAR10 = 1
							cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;;"
						Else
							cRegCSV :=";"+ToXlsFormat("'"+cPROD)+";OP->; ; ; ; ; ; ; ; ;;"
						EndIf
						//EndIF
					EndIF
					nCont++ 
					If MV_PAR11 = 2
						@ Li, aCol[3] 	 PSay "OP:"+QR2->LISTA
						@ Li, aCol[4] 	 PSay "Qtd:"+Alltrim(STR(QR2->QTD))
					Else
						@ Li, aCol[9] 	 PSay "OP:"+QR2->LISTA
						@ Li, aCol[10]+4 	 PSay "Qtd:"+Alltrim(STR(QR2->QTD))
					EndIf
					cPosi := ""
					cLista2  := QR2->LISTA
					dbSelectArea("SZS")
					SZS->(DbSetOrder(2))
					If SZS->(DbSeek(xFilial("SZS")+Alltrim(cLista2)))
						Do While SZS->(!Eof()) .And. Alltrim(SZS->ZS_OP) == Alltrim(cLista2)
							
							If cVer1 $ SZS->ZS_POSICAO .OR. cVer2 $ SZS->ZS_POSICAO .OR. cVer3 $ SZS->ZS_POSICAO
								cUSUA :=  Alltrim(SZS->ZS_USUARIO)
								cPosi :=  Alltrim(SZS->ZS_POSICAO)
							EndIF 
							
							SZS->(DbSkip())
						EndDo
					EndIf
					SZS->(dbCloseArea())
					If cPosi == ""
						cPosi := "OP excluída ou não apontada"
						cUSUA := " "
					EndIF
				
					If MV_PAR11 = 2
						@ Li, aCol[6] 	 PSay "Posição: "+SUBSTR(cPosi,9,80)+"-"+cUSUA
						@ Li, aCol[18]   PSay cLF
						@ Li, aCol[19] 	 PSay "Data CI: "+DTOC(STOD(QR2->DTCI))
					Else
						@ Li, aCol[11] 	 PSay "Posição: "+SUBSTR(cPosi,9,80)+"-"+cUSUA
						@ Li, aCol[20]+10   PSay cLF
					   //	@ Li, aCol[19] 	 PSay "Data CI: "+DTOC(STOD(QR2->DTCI))
					EndIf
					cNumOP := QR2->LISTA
					
					cRegCSV += "-;-;-;-;-;-;"+QR2->LISTA +";"+STR(QR2->QTD) +";"+ cPosi+" - "+cUSUA +";"+cLF+";"+ DTOC(STOD(QR2->DTCI))+";"+DTOC(STOD(QR2->C2_MSIMPR))
					
				ElseIf nC = 2
					If QR2->NUMERO == cNumPC .AND. QR2->ITEM == cItemPC
						QR2->(dbSKIP())
						LOOP
					EndIF
					
					nCont++
					
					If QR2->RET == QR2->NUMERO
						If nCont > 0
							If MV_PAR10 = 1
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; ; "
							Else
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; "
							EndIf
							Li++
						Else
							//If MV_PAR05 = 1
							If MV_PAR10 = 1
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; ; "
							Else
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";SC->; ; ; ; ; ; ; ; "
							EndIf
							//EndIF
						EndIF
						@ Li, apCol[1]   PSay "Num.SC:"+QR2->NUMERO
						@ Li, apCol[2]   PSay "DataSC:"
						@ Li, apCol[3]   PSay STOD(QR2->DAT)
						
						cNumPC := QR2->NUMERO
						cItemPC := QR2->ITEM
						cRegCSV += ToXlsFormat("'"+QR2->NUMERO) +"-"+QR2->ITEM+";"+ DTOC(STOD(QR2->DAT))
						
					Else
						
						If nCont > 0
							//If MV_PAR05 = 1
							If MV_PAR10 = 1
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ; ;"
							Else
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ;"
							EndIf
							//EndIF
							Li++
						Else
							//If MV_PAR05 = 1
							
							If MV_PAR10 = 1
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ; ;"
							Else
								cRegCSV :=  ";"+ToXlsFormat("'"+cPROD)+";PC->; ; ; ; ; ; ; ; ; ;"
							EndIf
							
							//EndIF
						EndIF
						@ Li, apCol[4]   PSay "NumPC:"+QR2->NUMERO
						@ Li, apCol[5]   PSay "Dat.Entr.PC:"
						@ Li, apCol[6]   PSay STOD(QR2->DAT)
						@ Li, apCol[7]   PSay "Fornece:"+QR2->FORN
						@ Li, apCol[8]   PSay "QuantPC:"
						@ Li, apCol[9]   PSay QR2->QTD Picture "@E 9,999.99"
						
						If !Empty(QR2->RET)
							@ Li, apCol[10]PSay QR2->RET
							cSN := QR2->RET
						Else
							@ Li, apCol[10]PSay "N"
							cSN := "N"
						EndIf
						cNumPC := QR2->NUMERO
						cItemPC := QR2->ITEM
						
						cRegCSV += ";"+ ToXlsFormat("'"+QR2->NUMERO) +"-"+QR2->ITEM+";"+ DTOC(STOD(QR2->DAT)) +";"+ QR2->FORN +";"+ STR(QR2->QTD) +";"+ cSN
					EndIf
					
				EndIF
				FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
				QR2->(dbSKIP())
			
			EndDo  
			
		
			IF Select("QR2") > 0
		  		DbSelectArea("QR2")
		   		DbCloseArea()
			ENDIF
		EndIf 
		///////////////////////////////////////////////////////////////////////////////////////////////////
			
		QR1->(dbSKIP())
		Li++
		If cNUM <> QR1->PAI
			
			@ Li,000 Psay __PrtFatLine()
			Li++
		ELSE
			@ li,001 PSAY Replicate(" -  - ",37)
			Li++
		EndIF
	ENDDO
NEXT n
FClose(cArqCSV)
QR1->(dbCloseArea())


If lEnd
	@ Li, aCol[1] PSay cCancel
	Return
Endif


If Li <> 80
	Roda(cbCont,cbTxt,Tamanho)
Endif


If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
EndIf

/*Ms_Flush()
oExcelApp:Quit()
oExcelApp:Destroy()*///Não funciona se o usuário local não for ADM da máquina
Return       

Static Function VerCC()
	Local _cQuery3 := "" 
	Local lOk := .F. 
	If Select("LR2") > 0
		DbSelectArea("LR2")
		DbCloseArea()
	EndIf
	_cQuery3 += " SELECT C2_NUM + C2_ITEM + C2_SEQUEN AS LISTA, C2_PRODUTO AS PROD, C2_QUANT AS QTD,C2_MSUSER AS USU,C2_MSPOSIC AS POSIC,C2_MSDTCI AS DTCI,C2_MSIMPR "
	_cQuery3 += " FROM "+RetSqlName("SC2")+" SC2  "
	_cQuery3 += " WHERE C2_PRODUTO = '"+cPROD+"' "
	_cQuery3 += " AND C2_DATRF ='' "  
	_cQuery3 += " AND C2_FILIAL = '"+xFilial("SC2")+"'    "
	_cQuery3 += " AND SC2.D_E_L_E_T_ = ' ' "
	_cQuery3 += " ORDER BY C2_NUM	"   
			
	TcQuery _cQuery3 New Alias "LR2"   
	dbSelectArea("LR2")
	LR2->(dbGoTop())  
   Do While !LR2->(EOF()) .AND. !lOk	 
   	cPosi := ""
		cLista2  := LR2->LISTA 
		
		If Select("LR3") > 0
			DbSelectArea("LR3")
			DbCloseArea()
		EndIf     
		
		_cQuery4 := " SELECT *	"
		_cQuery4 += " FROM "+RetSqlName("SZS")+" SZS     "
		_cQuery4 += " WHERE ZS_OP ='"+cLista2+"'  "
		_cQuery4 += " AND ZS_FILIAL= '"+xFilial("SZS")+"'    "  
		_cQuery4 += " AND ZS_QTDE > 0 "   
	 	_cQuery4 += " AND (ZS_POSICAO LIKE '%"+cVer1+"%' OR ZS_POSICAO LIKE '%"+cVer2+"%' OR ZS_POSICAO LIKE '%"+cVer3+"%') "
		_cQuery4 += " AND SZS.D_E_L_E_T_=''   "
		_cQuery4 += " ORDER BY R_E_C_N_O_ DESC  "
		
		TcQuery _cQuery4 New Alias "LR3"   
		dbSelectArea("LR3")
		LR3->(dbGoTop())  
   	If !LR3->(EOF()) 
	   	If Len(alltrim(MV_PAR12)) = 3
		   	If SUBSTR(LR3->ZS_CC,1,3) == ALLTRIM(MV_PAR12) 
		   		cUSUA :=  Alltrim(LR3->ZS_USUARIO)
		  			cPosi :=  Alltrim(LR3->ZS_POSICAO)
					lOk := .T.	
		   	Else
		   		Return .F.
		   	EndIf   
			ElseIf Len(alltrim(MV_PAR12)) = 6
				If SUBSTR(LR3->ZS_CC,1,6) == ALLTRIM(MV_PAR12)        
					cUSUA :=  Alltrim(LR3->ZS_USUARIO)
		  			cPosi :=  Alltrim(LR3->ZS_POSICAO)
					lOk := .T.	 
				Else
					Return .F.	
				EndIf
			Else
				ALERT("Campo Centro de Custo está diferente de 3 ou 6 digitos")
				RETURN .F.
			EndIf     
	   
	   EndIf
		LR2->(DBSKIP()) 
	EndDo	
	If Select("LR3") > 0
		DbSelectArea("LR3")
		DbCloseArea()
	EndIf  
	If Select("LR2") > 0
		DbSelectArea("LR2")
		DbCloseArea()
	EndIf 

RETURN lOk
