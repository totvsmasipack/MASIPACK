#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MTA416PV  ºAutor  ³                           ³ 05/01/2007            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     Efetivacao do Orcamento (Leva Dados p/PV)Gera produto automaticamente    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function MTA416PV()

Local cUsuario   := RetCodUsr()
Local cNomusu    := UsrRetName(cUsuario)
Local aUsuario   := {}
Local _aGrupos   := {}
Local _cDeptoUsu := ""
Local _cGrupo    := ""   
Local nAux 		 := PARAMIXB
Local I
Private lOkCB1   := .F.    
Private aConj    := {}
Private aConj2   := {}
Private cHex     := ""  
Private cP1  	  := "" 
Private cP2  	  := ""
aUsuario  		:= PswRet()
_cDeptoUsu 		:= Upper(Alltrim(aUsuario[1][12]))
_aGrupos        := PswRet(1)[1][10]
For I := 1 to Len(_aGrupos)
	_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
Next I
_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)

If SubStr(cNumEmp,1,2) $ "01_10"            // apenas para empresa Masipack
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
	M->C5_TRANSP  := SCJ->CJ_MSTRANS
	M->C5_COTACAO := SCJ->CJ_ORCAM
	M->C5_VEND1   := SCJ->CJ_MSVEND
	M->C5_MSTPVEN := SCJ->CJ_MSTPVEN
	M->C5_TRIFASI := SCJ->CJ_MSTRIF
	M->C5_VOLTAGE := SCJ->CJ_MSVOLTG
	M->C5_HZ      := SCJ->CJ_MSHZ
	M->C5_COR     := SCJ->CJ_MSCOR
	M->C5_MSGARAN := SCJ->CJ_MSGARAN
	M->C5_MSMULTA := SCJ->CJ_MSMULTA
	M->C5_MSINIGA := SCJ->CJ_MSINIGA
	M->C5_MSSTART := SCJ->CJ_MSSTART
	M->C5_MSVLPED := SCJ->CJ_MSVLORC
	//   M->C5_MSVLEMB := SCJ->CJ_MSVLEMB
	M->C5_MSVLMON := SCJ->CJ_MSVLMON
	M->C5_MSALIM  := SCJ->CJ_MSALIM
	M->C5_MSCTATO := SCJ->CJ_MSCTATO
	M->C5_MSCLIEN := SA1->A1_NREDUZ
	M->C5_OBS     := SA1->A1_NREDUZ
	M->C5_MSLINK  := M->C5_NUM
	
	If SubStr(cNumEmp,1,2) $ "10"
		aDadosCfo := {}
		Aadd(aDadosCfo,{"OPERNF"  ,"S"}) 
		Aadd(aDadosCfo,{"TPCLIFOR",M->C5_TIPOCLI})
		Aadd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
		Aadd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
		Aadd(aDadosCfo,{"CONTR"   ,SA1->A1_CONTRIB})

		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+_aCols[nAux][9]))
		_aCols[nAux][21] := MaFisCfo(nAux,SF4->F4_CF,aDadosCfo) //Processa o CFOP do item especificado na MATXFIS
	EndIf

	If "ENGENHARIA" $ _cGrupo .OR. "PROJETOS" $ _cGrupo
		M->C5_MSCATEG := "0"
	ElseIf _cDeptoUsu == "COMERCIAL"
		M->C5_MSCATEG := "1"
		
		//VICTOR DESSUNTE - 28/03/2017
		//INICIO - TICKET:2017032837000093 
		M->C5_NATUREZ := PADR("V01",TAMSX3("C5_NATUREZ")[1],' ')
		//FIM - TICKET:2017032837000093 
		
	ElseIf _cDeptoUsu == "COMEX/COMERCIAL"
		If M->C5_TIPOCLI == "X"
			M->C5_MSCATEG := "2"
		Else
			M->C5_MSCATEG := "3"
			M->C5_OBS := SCJ->CJ_MSNOTAS + "*** PROJETO : " + SCJ->CJ_MSPROJE + " ***"
		EndIf
	ElseIf _cDeptoUsu == "VENDA DE PECAS"
		If M->C5_TIPOCLI == "X"
			M->C5_MSCATEG := "2"
		Else
			M->C5_MSCATEG := "3"
			M->C5_OBS := SCJ->CJ_MSNOTAS + "*** PROJETO : " + SCJ->CJ_MSPROJE + " ***"
		EndIf
		M->C5_TPFRETE := "F"
		M->C5_MSDTENT := Date()

		//VICTOR DESSUNTE - 28/03/2017
		//INICIO - TICKET:2017032837000093 
		M->C5_NATUREZ := PADR("V02",TAMSX3("C5_NATUREZ")[1],' ')
		//FIM - TICKET:2017032837000093 

		M->C5_MSTPVEN := "RE"
		M->C5_MSGARAN := SCJ->CJ_MSGARAN
	ElseIf _cDeptoUsu == "203-MAKLASER"
		M->C5_MSCATEG := "5"
	ElseIf _cDeptoUsu == "ASSIST.TECNICA"
		M->C5_MSCATEG := "6"		
	Else
		M->C5_MSCATEG := "4"
	EndIf
	
	If M->C5_MSCATEG == "1"  // sera usado para orcamento de maquina -> características do produto do cliente (SZJ)
		SZ4->(dbSetOrder(1))
		If ! SZ4->(dbSeek(xFilial("SZ4")+M->C5_NUM))
			SZJ->(dbSetOrder(1))
			If SZJ->(dbSeek(xFilial("SZJ")+SCJ->CJ_NUM))
				Do While ! SZJ->(Eof()) .And. SZJ->ZJ_NUM == SCJ->CJ_NUM
					RecLock("SZ4",.T.)
					SZ4->Z4_FILIAL  := ""
					SZ4->Z4_PEDIDO  := M->C5_NUM
					SZ4->Z4_PRODUTO := SZJ->ZJ_PRODUTO
					SZ4->Z4_FPROD   := SZJ->ZJ_FPROD
					SZ4->Z4_DIMENSA := SZJ->ZJ_DIMENSA
					SZ4->Z4_MODEMB  := SZJ->ZJ_MODEMB
					SZ4->Z4_PESOVOL := SZJ->ZJ_PESOVOL
					SZ4->Z4_MATEMB  := SZJ->ZJ_MATEMB
					SZ4->Z4_DIMEMB  := SZJ->ZJ_DIMEMB
					SZ4->Z4_RENDESP := SZJ->ZJ_RENDESP
					SZ4->Z4_EMPACOT := SZJ->ZJ_EMPACOT
					SZ4->Z4_PASSO   := SZJ->ZJ_PASSO
					SZ4->Z4_FALIM   := SZJ->ZJ_FALIM
					SZ4->Z4_DIMALIM := SZJ->ZJ_DIMALIM
					SZ4->Z4_FILLARG := SZJ->ZJ_FILLARG
					SZ4->Z4_FILMIN  := SZJ->ZJ_FILMIN
					SZ4->(MsUnLock())
					SZJ->(DbSkip())
				EndDo
			EndIf
		EndIf
	EndIf        
EndIf


/*If apmsgYesNo("Pedido é de máquina(Irá gerar a estrutura automaticamente)?")
	
	MsgRun("Verificando Estrutura, Aguarde...(Pode levar alguns minutos)" ,, { || PRODESTR() } )
EndIf*/
Return()               


// Se existe estrutura criada na tabela SZQ, então o sistema cria produtos automaticamente, cria estrutura para eles, atualiza no PV
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PRODESTR()

Local x
	aConj2 := {}
	If SubStr(cNumEmp,1,2) $ "01_10"            // apenas para empresa Masipack e Fabrima
	
		For x = 1 To Len(_aCols) 
			If Select("QR1") > 0
				DbSelectArea("QR1")
				DbCloseArea()
			EndIf      
			
			cQuery := "	SELECT * "
			cQuery += " FROM " + RetSqlName("SZQ") + " SZQ " 
			cQuery += " INNER JOIN " + RetSqlName("SCK") + " SCK ON ZQ_MASTER = CK_PRODUTO AND SUBSTRING(ZQ_ORCA,1,6) = CK_NUM AND SCK.D_E_L_E_T_= '' AND CK_FILIAL='"+xFilial("SCK")+"' "  
			cQuery += " WHERE ZQ_FILIAL='"+xFilial("SZQ")+"'"
			cQuery += " AND SZQ.D_E_L_E_T_= ''"
			cQuery += " AND ZQ_OPCIOBR <> 'AF'"           
			cQuery += " AND ZQ_ORCA = '"+SCJ->CJ_NUM + _aCols[x][1] +"' "             
			cQuery += " ORDER BY ZQ_ESTRU"//ZQ_ORCA,ZQ_MASTER,ZQ_PRODUTO,ZQ_COMP "   
			
			TcQuery cQuery New Alias "QR1" 
		  
			DbSelectArea("QR1")
			
			QR1->(DBGOTOP()) 
		   If QR1->(!Eof())
		   	cCodMaster := "MQ"+ SUBSTR(QR1->ZQ_ORCA,1,6)  + "-" + SUBSTR(QR1->ZQ_MASTER,4,3)    
		   	cDesMaster := _aCols[x][3] //
		   	
		   Else
		   	Return()
		   EndIf
		   cCodprod   := cCodMaster  
		   cDescProd  := cDesMaster
		   cTIPO      := "PA"
		   DBSELECTAREA("SB1")
		   SB1->(DBSETORDER(1))       
		   
		   If DBSEEK(xFilial("SB1") + cCodMaster)
		  		ALERT("Produto máquina já existe não será feito o cadastro")	 
		   Else
		   	GeraB1(cCodMaster,cDescProd,cTIPO)
		   EndIf
		   cDescProd  := ""
		   cCodprod   := ""
		   cTIPO      := "PI" 
		  	M->C5_NUM := SUBSTR(QR1->ZQ_ORCA,1,6)
		  
		   If DBSEEK(xFilial("SB1") + QR1->ZQ_COMP)
		   	cRevisao := SB1->B1_REVATU	
		   EndIf   
		   
			Do While QR1->(!Eof())  
				If SUBSTR(QR1->ZQ_ESTRU,6,3) == "000" .AND. SUBSTR(QR1->ZQ_ESTRU,9,3) == "000"   
					nSeq := 0
				  	cCodprod := "P"+SUBSTR(QR1->ZQ_ORCA,1,6)+"-"+SUBSTR(QR1->ZQ_COMP,7,5)+IIF(SUBSTR(QR1->ZQ_COMP,13,2) $ "ME_EE",SUBSTR(QR1->ZQ_COMP,13,2),SUBSTR(QR1->ZQ_COMP,12,2)) // SUBSTR(QR1->ZQ_MASTER,1,4) +STRZERO(VAL(cRevisao),3)+ SUBSTR(QR1->ZQ_COMP,6,5)+ STRZERO(nSeq,4) 
				  	cDescProd := QR1->ZQ_DESC
				  	cP1  := cCodprod
				  	cHex := QR1->ZQ_HEX 
			  		If !(DBSEEK(xFilial("SB1") + alltrim(cCodprod))) 
				   	GeraB1(cCodprod,cDescProd,"PI")
				   Else
				   	ALERT(cCodprod)		
				  	EndIf 
				  	AADD(aConj,{cCodMaster,cCodprod,QR1->ZQ_QUANT}) 
				  	aConj2 := {}
				  	QR1->(DBSKIP())	
				EndIf
				
				Do While QR1->(!Eof()) .AND. SUBSTR(QR1->ZQ_ESTRU,6,3) <> "000" .AND. SUBSTR(QR1->ZQ_ESTRU,9,3) == "000" 
					nSeq := 0
					
					If SUBSTR(QR1->ZQ_COMP,13,2) == "MM" .OR. SUBSTR(QR1->ZQ_COMP,12,2) == "MM" 
				  		cCodprod := QR1->ZQ_COMP
				  	Else
				  		cCodprod := "P"+SUBSTR(QR1->ZQ_ORCA,1,6)+"-"+SUBSTR(QR1->ZQ_COMP,7,5)+IIF(SUBSTR(QR1->ZQ_COMP,13,2) $ "ME_EE",SUBSTR(QR1->ZQ_COMP,13,2),SUBSTR(QR1->ZQ_COMP,12,2)) // SUBSTR(QR1->ZQ_MASTER,1,4) +STRZERO(VAL(cRevisao),3)+ SUBSTR(QR1->ZQ_COMP,6,5)+ STRZERO(nSeq,4) 
				  	EndIf
				  	cDescProd := QR1->ZQ_DESC
				  	cP2  := cCodprod
				  	cHex := QR1->ZQ_HEX 
			  		If !(DBSEEK(xFilial("SB1") + alltrim(cCodprod))) .AND. SUBSTR(cCodprod,13,2) <> "MM" .AND. SUBSTR(QR1->ZQ_COMP,12,2) <> "MM"  
				   	GeraB1(cCodprod,cDescProd,"PI")
				   Else
				   	ALERT(cCodprod)		
				  	EndIf 
				  	AADD(aConj2,{cP1,cCodprod,QR1->ZQ_QUANT}) 
				  	aConj3 := {} 
				  	QR1->(DBSKIP())
				  	Do While QR1->(!Eof()) .AND. SUBSTR(QR1->ZQ_ESTRU,9,3) <> "000"   
				
						cCodComp := QR1->ZQ_COMP
				 	   AADD(aConj3,{cP2,cCodComp,QR1->ZQ_QUANT})
				 
				 		QR1->(DBSKIP())
				  	EndDo    
				  	
					If Len(aConj3) > 0
						If SUBSTR(cP2,13,2) <> "MM" .AND. SUBSTR(QR1->ZQ_COMP,12,2) <> "MM" 
				   		GeraG1(aConj3)
				    	Else
				   		ALERT(cCodprod)
				      EndIf
				   EndIf		   
				   
				EndDo  	
				If Len(aConj2) > 0 
					GeraG1(aConj2)
				EndIf
 
			EndDo  
			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			If Len(aConj) > 0 
				GeraG1(aConj)
			EndIf 
			_aCols[x][2] := cCodMaster
		Next X
	EndIf         

	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf 
	
Return()

Static Function GeraB1(cprod,cdesc,cT)
Local aVetor := {}
Private lMsErroAuto := .F. 
Begin Transaction
//PREPARE ENVIRONMENT EMPRESA SUBSTR(cNumEmp,1,2) FILIAL "01" MODULO "EST"
//--- Inclusao --- //
aVetor:= {{"B1_CONTRAT" 	,"N"             ,Nil},; 
          {"B1_LOCALIZ" 	,"N"             ,Nil},;
          {"B1_PROCED"     ,"1P"				  ,Nil},;
          {"B1_MSGRVEN"    ,"IN"				  ,NIL},;
			 {"B1_COD"        ,cprod	        ,NIL},;
			 {"B1_DESC"       ,cdesc   		  ,NIL},;
  			 {"B1_TIPO"       ,cT			 	  ,NIL},;
			 {"B1_UM"         ,"CJ"				  ,NIL},;
			 {"B1_CC"         ,"207"           ,NIL},;
			 {"B1_LOCPAD"     ,"01"				  ,NIL},;
			 {"B1_PROCED"     ,"1P"            ,NIL},;
			 {"B1_ORIGEM"     ,"0"             ,NIL},;
			 {"B1_MSATOX"     ,"N"             ,NIL},;
			 {"B1_GARANT"     ,"2"          	  ,NIL},;
			 {"B1_MSCONF"     ,"N"             ,NIL},;
			 {"B1_REVATU"     ,"001"           ,NIL},;
			 {"B1_MSHEX"     ,""   				  ,NIL},;	
			 {"B1_MSCERT"     ,"N"          	  ,NIL}}				 
          MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) 

If lMsErroAuto 
	DisarmTransaction()
	  
	MostraErro() 
	lOkCB1 := .F.
   Break
Else 
	lOkCB1 := .T.
Endif  
End Transaction

Return    

STATIC Function GeraG1(aEstru1)
Local i
Local PARAMIXB1  := {}
Local PARAMIXB2 := {}
Local aGets := {}
Local lOK   := .T.
Local cString 
Private aEstru := {}

Private lMsErroAuto := .F.  

aEstru := aEstru1

ConOut(Repl("-",80))
ConOut(PadC("Rotina automatica para estrutura de produtos",80))
//------------------------//| Inclusao    |//------------------------
dbSelectArea("SB1")
dbSetOrder(1)  
  
Begin Transaction


PARAMIXB1 := {	{"G1_COD",aEstru[1][1],NIL},;		
					{"G1_QUANT",1,NIL},;		
					{"NIVALT","N",NIL}} // A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura	

For i = 1 To LEN(aEstru)
	aGets := {}	
	aadd(aGets,{"G1_COD",aEstru[i][1],NIL})	
	aadd(aGets,{"G1_COMP",aEstru[i][2],NIL})	
	aadd(aGets,{"G1_TRT","001",NIL})	
	aadd(aGets,{"G1_QUANT",aEstru[i][3],NIL})	
	aadd(aGets,{"G1_PERDA",0,NIL})	
	aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})	
	aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})	
	aadd(PARAMIXB2,aGets)	
Next i

If lOk		
	ConOut("Inclusao")		
	ConOut("Inicio: "+Time())		
	MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,PARAMIXB2,3) //Inclusao		
	ConOut("Fim: "+Time())	
EndIf


If lMsErroAuto	
	If IsBlind()		
		If IsTelnet()			
			VTDispFile(NomeAutoLog(),.t.)		
		Else			
			cString := MemoRead(NomeAutoLog())			
			Aviso("Aviso de Erro:",cString)		
		EndIf	
	Else		
		MostraErro()	
	EndIf
Else	
	If lOk		
 //		Aviso("Aviso","Operacao efetuada com sucesso",{"Ok"})	
	Else		
//		Aviso("Aviso","Fazer os devidos cadastros",{"Ok"})	
	EndIf
Endif
End Transaction
Return

