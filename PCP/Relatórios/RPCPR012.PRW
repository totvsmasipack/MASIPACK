#Include "Rwmake.ch"
#Include "TopConn.ch"
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPR012  ºAutor  ³Lizandra Marques    º Data ³  17/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Resumo das operações - Produções                           º±±
±±º          ³ Reescrito - Substituido Z8/Z9 por D3                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Editado 28/04/2014 - Eduardo Mantoan - Lógica refeita (Estava imcompleta); Ajustes na Query; Criado pergunta MV_Par04; edição do relatório
*/

User Function RPCPR012()

PRIVATE titulo	:="Resumo de Operações - Mensal"
PRIVATE cDesc1	:="Esse programa tem por finalidade imprimir o relatorio de"
PRIVATE cDesc2	:="Ranking de Fornecedores"
PRIVATE cDesc3	:=""
PRIVATE cString:= "SD3"
PRIVATE wnrel  := "RPCPR012"
PRIVATE aReturn:= { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog:= "RPCPR012"
PRIVATE cPerg	 := "XRPCPR012 "
PRIVATE nLastKey:= 0
PRIVATE Li      := 99
PRIVATE tamanho := "P"
PRIVATE limite  := 80
PRIVATE m_pag	 :=0  
PRIVATE aOps    :={}
PRIVATE aTCc    :=Array(10000)
PRIVATE aCc     :={}

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,,,Tamanho) 
 
If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)  
/*
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)
If nLastKey == 27
	set filter to
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	set filter to
	Return
Endif*/

RptStatus({|| ImpPCP12()}, )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpPCP12ºAutor  ³ Lizandra Marques     º Data ³  17/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do relatório                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpPCP12()



Cabec1:= "Centro de Custo               Operação                                     Qtde."
cabec2:= ""
cabec3:= ""

/*aCampos  := {	{ "CCUSTO"    ,"C",09,0},;
{ "RECURSO"   ,"C",06,0},;
{ "DESCRI"    ,"C",30,0},;
{ "RQUAN"     ,"N",11,3},;
{ "RPERDA"    ,"N",10,3},; 
{ "RPROD"     ,"C",30,0},;
{ "ROP"       ,"C",15,0} }

cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

IndRegua("TRB",cArqTrab,"CCUSTO+RECURSO",,,"Selecionando Registros...")*/

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF    
	
	_cQuery := " SELECT C2_NUM,C2_SEQUEN,C2_ITEM,C2_PRODUTO,C2_QUJE,C2_PERDA "
	_cQuery += " FROM " + RetSqlName("SC2") + " C2 "
	_cQuery += " WHERE  C2_UM <> 'CJ' "
	_cQuery += "       AND C2_DATRF BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND (C2_QUJE + C2_PERDA) >= C2_QUANT AND C2_DATRF <> '        '  " 
	If MV_PAR03 <> 1
     _cQuery += "     AND C2_ROTEIRO <> ' '  " 
	EndIf
	If MV_PAR04 == 1               
	  _cQuery += "     AND C2_SEQUEN = '001' "
	EndIf 
	_cQuery += "       AND C2_FILIAL = '" + xFilial("SC2") + "' AND C2.D_E_L_E_T_ = ' '  "
	_cQuery += " ORDER BY C2_NUM,C2_ITEM"
	
	TcQuery _cQuery New Alias "QR1"
	nTOP 		:=0
	nErrProd := 0
	nTotGer  := 0 
	QR1->(dbGoTop())
	DO WHILE !QR1->(EOF())
   	
   	nTOP++
   	nTotGer  += QR1->C2_QUJE 
		nErrProd += QR1->C2_PERDA
		QR1->(dbSkip())

   EndDo
   QR1->(dbCloseArea())
	 
	IF Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	ENDIF
	_cQuery := " SELECT C2_NUM,C2_SEQUEN,C2_ITEM,C2_PRODUTO,C2_QUANT,C2_QUJE,C2_PERDA,H1_DESCRI, H1_CCUSTO,G2_RECURSO "
	_cQuery += " FROM " + RetSqlName("SC2") + " C2 "
	_cQuery += " LEFT OUTER JOIN " + RetSqlName("SG2") + " G2 "
	_cQuery += "       ON G2_CODIGO = C2_ROTEIRO AND G2_PRODUTO = C2_PRODUTO "
	_cQuery += "       AND G2_FILIAL = '" + xFilial("SG2") + "' AND G2.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT OUTER JOIN " + RetSqlName("SH1") + " H1 "
	_cQuery += "       ON H1_CODIGO = G2_RECURSO "
	_cQuery += "       AND H1_FILIAL = '" + xFilial("SH1") + "' AND H1.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE  C2_UM <> 'CJ' "
	_cQuery += "       AND C2_DATRF BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND (C2_QUJE + C2_PERDA) >= C2_QUANT AND C2_DATRF <> '        '  " 
	If MV_PAR03 <> 1
     _cQuery += "     AND C2_ROTEIRO <> ' ' AND G2_RECURSO <> ' ' " 
	EndIf
	If MV_PAR04 == 1               
	  _cQuery += "     AND C2_SEQUEN = '001' "
	EndIf 
	_cQuery += "       AND C2_FILIAL = '" + xFilial("SC2") + "' AND C2.D_E_L_E_T_ = ' '  "
	_cQuery += " ORDER BY C2_NUM,C2_ITEM,H1_CCUSTO, G2_RECURSO "
	
TcQuery _cQuery New Alias "QR1"
                                                   
QR1->(dbGoTop())
cOP 	  	:= ""
cCCusto 	:= "" 
nX 		:= 0
nCusto   := 1
nQuantC  := 0
nTCC     := 0
AFILL(aTCC, 0)


DO WHILE !QR1->(EOF())
	cOP := QR1->C2_NUM+QR1->C2_ITEM	  
	While cOP == QR1->C2_NUM+QR1->C2_ITEM
		cCCusto 	:= QR1->H1_CCUSTO
		nX 		:= 0  
		While cCCusto == QR1->H1_CCUSTO .AND. cOP == QR1->C2_NUM+QR1->C2_ITEM
			If nX = 0
				nCusto := Val(cCCusto)
				If nCusto = 0
					nCusto := 1     
				EndIf
			aTCC[nCusto] += QR1->C2_QUJE

			nX := 1
			EndIf
		   QR1->(dbSkip())
		End
	End
EndDo	          
QR1->(dbCloseArea())	
	
	
	
	
	
	
	
	IF Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	ENDIF
	_cQuery := " SELECT C2_NUM,C2_SEQUEN,C2_ITEM,C2_PRODUTO,C2_QUANT,C2_QUJE,C2_PERDA,H1_DESCRI, H1_CCUSTO,G2_RECURSO "
	_cQuery += " FROM " + RetSqlName("SC2") + " C2 "
	_cQuery += " LEFT OUTER JOIN " + RetSqlName("SG2") + " G2 "
	_cQuery += "       ON G2_CODIGO = C2_ROTEIRO AND G2_PRODUTO = C2_PRODUTO "
	_cQuery += "       AND G2_FILIAL = '" + xFilial("SG2") + "' AND G2.D_E_L_E_T_ = ' ' "
	_cQuery += " LEFT OUTER JOIN " + RetSqlName("SH1") + " H1 "
	_cQuery += "       ON H1_CODIGO = G2_RECURSO "
	_cQuery += "       AND H1_FILIAL = '" + xFilial("SH1") + "' AND H1.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE  C2_UM <> 'CJ' "
	_cQuery += "       AND C2_DATRF BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	_cQuery += "       AND (C2_QUJE + C2_PERDA) >= C2_QUANT AND C2_DATRF <> '        '  " 
	If MV_PAR03 <> 1
     _cQuery += "     AND C2_ROTEIRO <> ' ' AND G2_RECURSO <> ' ' " 
	EndIf
	If MV_PAR04 == 1               
	  _cQuery += "     AND C2_SEQUEN = '001' "
	EndIf 
	_cQuery += "       AND C2_FILIAL = '" + xFilial("SC2") + "' AND C2.D_E_L_E_T_ = ' '  "
	_cQuery += " ORDER BY H1_CCUSTO, G2_RECURSO,C2_NUM,C2_ITEM "
	
TcQuery _cQuery New Alias "QR1"
                                                   
QR1->(dbGoTop())
aProd    := {}
//aItem    :=	{}
aTOP     := {}
aCC   	:= {}
aTOPC    := {}
nX			:= 0
cOP      := ""
nScan 	:= 1
nTQTDCC  := 0
nQTDCC   := 0
//IF lEnd
//	@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR" 
//	EXIT
//ENDIF
IF Li > 60
	Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
	Li := 9
	@ Li,000 PSAY "Periodo de: " + DTOC(MV_PAR01) + " Ate: " + DTOC(MV_PAR02)
	Li++
ENDIF
DO WHILE !QR1->(EOF())
   
	 cCC      	:=	QR1->H1_CCUSTO
	 
	 nTQTDCC    := 0
	 ASIZE(aTOP,0)
    ASIZE(aCC,0)
    //ASIZE(aItem,0)
	 WHILE cCC == QR1->H1_CCUSTO
	  		cRecurso 	:=	QR1->H1_DESCRI
	  		cCodRecu 	:=	QR1->G2_RECURSO
	  		nQTDCC 		:= 0            
	  		
	      WHILE cCodRecu == QR1->G2_RECURSO
	      	
	        	/*IF (ASCAN(aTOP,QR1->C2_NUM+QR1->C2_ITEM)=0) .OR. (ASCAN(aCC,QR1->H1_CCUSTO)=0)
					If (ASCAN(aTOP,QR1->C2_NUM+QR1->C2_ITEM)=0)
						AADD(aTOP,QR1->C2_NUM+QR1->C2_ITEM)
					EndIF
					If(ASCAN(aCC,QR1->H1_CCUSTO)=0)
						AADD(aCC,QR1->H1_CCUSTO)
					EndIF
					nTQTDCC	+=  QR1->C2_QUJE
		  		EndIf */
		  		
		  		nQTDCC	+=  QR1->C2_QUANT
	      	QR1->(dbSkip())
	      	
	      End
	      //Imprimir Total do recurso
	      IF Li > 60
				Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
				Li := 9
				@ Li,000 PSAY "Periodo de: " + DTOC(MV_PAR01) + " Ate: " + DTOC(MV_PAR02)
				Li++
			ENDIF
		   @ Li,000 PSAY cCC
			@ Li,030 PSAY cCodRecu + " "+ cRecurso
			@ Li,069 PSAY nQTDCC  Picture "@E 999,999,999"
			Li++
	 End
	//imprimir Total do CC e separação (--------------)
	 nCusto := Val(cCC)	
	 IF Li > 60
		Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
		@ Li,000 PSAY "Periodo de: " + DTOC(MV_PAR01) + " Ate: " + DTOC(MV_PAR02)
		Li++
	 ENDIF
	 @ Li,000 Psay "Total de Peças no Centro de Custo: "
	 //@ Li,036 Psay nTQTDCC  Picture "@E 999,999,999"
	 @ Li,036 Psay aTCC[nCusto]  Picture "@E 999,999,999"
	 Li++
	 @ Li,000 Psay Replicate("-",80)
	 Li+=2
	
	/*IF !TRB->(dbSeek(QR1->H1_CCUSTO+QR1->G2_RECURSO))
		RecLock("TRB",.T.)
		TRB->CCUSTO := QR1->H1_CCUSTO
		TRB->RECURSO:= QR1->G2_RECURSO
		TRB->DESCRI := QR1->H1_DESCRI
		TRB->RQUAN	+= QR1->D3_QUANT
		//TRB->RPERDA	+= QR1->D3_PERDA
		TRB->ROP 	:= QR1->D3_OP
		TRB->RPROD	:= QR1->D3_COD
		If nCusto <> Val(QR1->H1_CCUSTO)
	   	nX	:=	0
	   	ASIZE(aProdC,0)
			ASIZE(aTOPC,0)      
	   EndIf
	   IF (ASCAN(aTOP,QR1->D3_OP)=0) .OR. (ASCAN(aProd,QR1->D3_COD)=0)
				If (ASCAN(aTOP,QR1->D3_OP)=0)
					AADD(aTOP,QR1->D3_OP)
				EndIF
				If(ASCAN(aProd,QR1->D3_COD)=0)
					AADD(aProd,QR1->D3_COD)
				EndIF
		  	nTotGer  += QR1->D3_QUANT
			nErrProd += QR1->D3_PERDA
			
	   EndIf
	   IF (ASCAN(aTOPC,QR1->D3_OP)=0) .OR. (ASCAN(aProdC,QR1->D3_COD)=0)
				If (ASCAN(aTOPC,QR1->D3_OP)=0)
					AADD(aTOPC,QR1->D3_OP)
				EndIF
				If(ASCAN(aProdC,QR1->D3_COD)=0)
					AADD(aProdC,QR1->D3_COD)
				EndIF
		  		nX 		+= QR1->D3_QUANT
	   EndIf
	   
	   
	   
	ELSE	
		RecLock("TRB",.F.) 
		TRB->ROP := QR1->D3_OP 
		TRB->RQUAN	+= QR1->D3_QUANT 
	
		IF (ASCAN(aTOP,QR1->D3_OP)=0) .OR. (ASCAN(aProd,QR1->D3_COD)=0)
				If (ASCAN(aTOP,QR1->D3_OP)=0)
					AADD(aTOP,QR1->D3_OP)
				EndIF
				If(ASCAN(aProd,QR1->D3_COD)=0)
					AADD(aProd,QR1->D3_COD)
				EndIF
		  	nTotGer  += QR1->D3_QUANT
			nErrProd += QR1->D3_PERDA
		EndIf
		IF (ASCAN(aTOPC,QR1->D3_OP)=0) .OR. (ASCAN(aProdC,QR1->D3_COD)=0)
			If (ASCAN(aTOPC,QR1->D3_OP)=0)
				AADD(aTOPC,QR1->D3_OP)
			EndIF
			If(ASCAN(aProdC,QR1->D3_COD)=0)
				AADD(aProdC,QR1->D3_COD)
			EndIF
		  	nX 		+= QR1->D3_QUANT
			nCusto:=Val(QR1->H1_CCUSTO)
			If nCusto = 0
				nCusto := 1 
			EndIf 
			aTCc[nCusto] := nX 
		EndIf
		  
		
	
		
	ENDIF   
		
		
		
	TRB->(MsUnLock())
	QR1->(dbSkip()) 
	
ENDDO               




TRB->(DbGoTop())

_cCusto  := ""  
nCon 	   := 0
nX := 1
DO WHILE !TRB->(EOF())
	 nCon++
	_cCusto := TRB->CCUSTO
	nTotCCusto := 0
	 	
	DO WHILE !TRB->(EOF()) .AND. TRB->CCUSTO == _cCusto
		IF lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR" 
			EXIT
		ENDIF
		
		IF Li > 60
			Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
			@ Li,000 PSAY "Periodo de: " + DTOC(MV_PAR01) + " Ate: " + DTOC(MV_PAR02)
			Li++
		ENDIF
		@ Li,000 PSAY TRB->CCUSTO
		@ Li,030 PSAY TRB->RECURSO + " "+ TRB->DESCRI
		@ Li,069 PSAY TRB->RQUAN  Picture "@E 999,999,999"
		AADD(aTCc,TRB->RQUAN)
			
	  //	cCc		  := ASCAN(aCc,TRB->CCUSTO)
	   nCusto := Val(TRB->CCUSTO)
	   If nCusto = 0
	   	nCusto := 1
	   EndIf
		nTotCCusto := aTCc[nCusto] 
		Li++  
		TRB->(dbSkip())
	ENDDO
	IF Li > 60
		Cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,18)
		@Li,000 PSAY "Periodo de: " + DTOC(MV_PAR01) + " Ate: " + DTOC(MV_PAR02)
		Li++
	ENDIF
	@ Li,000 Psay "Total de Peças no Centro de Custo: "
	@ Li,036 Psay nTotCCusto  Picture "@E 999,999,999"
	Li++
	@ Li,000 Psay Replicate("-",80)
	Li+=2
	nX++*/
ENDDO
//nTotGer -= nErrProd
Li+=2
@ Li,000 Psay "Total Geral de Peças.............: "
@ Li,036 Psay nTotGer Picture "@E  999,999,999"

Li+=2
@ Li,000 Psay "Total Geral de OP's..............: "
@ Li,036 Psay nTOP Picture "@E  999,999,999"


Li+=2
@ Li,000 Psay "Total de Peças sem Operação......: "
@ Li,036 Psay nErrProd Picture "@E  999,999,999"


//TRB->(DbCloseArea())

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif
QR1->(dbCloseArea())
MS_FLUSH()


RETURN