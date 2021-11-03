#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} RFATR001
//TODO Descrição: Relação de pedidos de vendas - Fabrica.
@author Lizandra Marques
@since 29/10/2012
@version 1.0
@return .T.
@type function
/*/
User Function RFATR001()

Local titulo 	  := "Relacao de Pedidos de Vendas - Fábrica"
Local cDesc1 	  := "Este programa ira emitir a relacao  dos Pedidos de Vendas"
Local cDesc2 	  := "de acordo com os parametros do usuário"
Local cDesc3 	  := ""
Local nomeprog   := "RFATR001"
Private aReturn  := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1}
Private cPerg    := "XRFATR001 "
Private tamanho  := "M"
Private limite   := 132
Private li       := 80
Private m_pag    := 1
Private nLastKey := 0
Private lEnd     := .F.
Private cMsObs   := ""
Private cMonta   := ""
Private I        := 0
wnrel		  	     := "RFATR001"
cString 	 	     := "SC6"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VerIfica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01         // Do Pedido                                ³
//³ mv_par02         // Ate o Pedido                             ³
//³ mv_par03	     // Imprime Observaçoes                      ³
//³ mv_par04	     // Imprime Desenhos                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,nomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,,Tamanho)

If ( nLastKey == 27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
EndIf

SetDefault(aReturn,cString)

If ( nLastKey == 27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter To
	Return
EndIf

RptStatus({|| ImpFat01() }, )

Return(.T.)

/*/{Protheus.doc} ImpFat01
//TODO Descrição: Chamada do Relatorio.
@author Lizandra
@since 30/10/2012
@version 1.0
@return NIL
@type function
/*/
Static Function ImpFat01()

Local nomeprog   := "RFATR001"
Local titulo 	 := "Relacao de Pedidos de Vendas - Fábrica"
Local _cUsuario	 := RetCodUsr()
Local X, j
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definição dos cabeçalhos									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAliaSC6	 := GetNextAlias()
Local cabec1 	 := "IT PRODUTO          MONT. DESCRICAO DO PRODUTO           UM       QTDE.            OP          OBS "
                  //"0123456789D123456789V123456789T123456789Q123456789C123456789S123456789S123456789O123456789N123456789C123456789D123456789V12
                  // 99 999999999999999  99999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx 999,999.999 | 99999999999 |
Local cabec2 	 := ""
Private aDesenhos	 := {}

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
Endif

BeginSQL Alias cAliaSC6
	SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C2_PRODUTO,
		CASE WHEN (C6_QTDVEN - C6_QTDENT) = 0 THEN C6_QTDVEN ELSE (C6_QTDVEN - C6_QTDENT) END AS QUANT,
	 	C6_UM, C6_NUMOP, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO,
	 	C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_MSLINK, C5_TIPO, ZK_MONTAG, C6_MSOBS, 
	 	ISNULL(CONVERT(VARCHAR(2047),CONVERT(VARBINARY(2047),C5_OBS)),' ') AS OBS
	From %table:SC5% C5
	INNER JOIN %table:SC6% C6 ON C6_FILIAL = %xFilial:SC6% AND C6_NUM = C5_NUM AND C6.%notdel%
	LEFT OUTER JOIN %table:SC2% C2 ON C2_FILIAL = %xFilial:SC2% AND C6_NUMOP = C2_NUM AND C6_ITEM = C2_ITEM 
		AND (C2_QUJE + C2_PERDA) < C2_QUANT AND C2.%notdel%
	LEFT OUTER JOIN %table:SZK% ZK ON ZK_FILIAL = %xFilial:SZK% AND C2_PRODUTO =  ZK_COD AND ZK.%notdel%
	WHERE C5_FILIAL =  %xFilial:SC5% AND C5.%notdel% AND C6_BLQ <> 'R' AND C5_NUM BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% AND C5.%notdel% 
EndSQL
(cAliaSC6)->(DbGoTop())

DO WHILE !(cAliaSC6)->(EOF())
	_cPedido := (cAliaSC6)->C6_NUM
	_cItem 	 := "  "
	_cObs	 := (cAliaSC6)->OBS
	DO WHILE !(cAliaSC6)->(EOF()) .AND. _cPedido == (cAliaSC6)->C6_NUM

		IF mv_par04 == 1                                                     
			_cRev  := " "                              
			_cRev  := Posicione("SB1",1,xFilial("SB1")+IIF(EMPTY((cAliaSC6)->C2_PRODUTO),(cAliaSC6)->C6_PRODUTO,(cAliaSC6)->C2_PRODUTO),"B1_REVATU")
			_cPath := "H:\PLOTTER\"
			If SubStr(cNumEmp,1,2) == "01"
				If Substr((cAliaSC6)->C6_PRODUTO,1,2) == "CL"
					_cPath += Substr((cAliaSC6)->C6_PRODUTO,3,2) + "\"
				ELSE
					_cPath += Substr((cAliaSC6)->C6_PRODUTO,1,2) + "\"
				ENDIF
			ElseIf SubStr(cNumEmp,1,2) == "10"
				_cPath += Substr((cAliaSC6)->C6_PRODUTO,1,3) + "\"
			EndIf
			
			AADD(aDesenhos,_cPath + Alltrim((cAliaSC6)->C6_PRODUTO) + Alltrim(_cRev) + ".PLT")
			AADD(aDesenhos,_cPath + Alltrim((cAliaSC6)->C6_PRODUTO) + Alltrim(_cRev) + ".PRI")
			AADD(aDesenhos,_cPath + Alltrim((cAliaSC6)->C6_PRODUTO) + Alltrim(_cRev) + ".PRN")
			
		ENDIF
		IF li > 55
			Li	:= cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			Li	++
			@ Li, 00 PSAY "Pedido: " + (cAliaSC6)->C6_NUM
			@ Li, PCol()+2 PSAY "Link: " + (cAliaSC6)->C5_MSLINK
 			_nReduz := ""
 			_nForCli:= ""
			IF (cAliaSC6)->C5_TIPO$ "D/B"
	 			_nForCli:= "Fornecedor: "
				_nReduz := Posicione("SA2",1,xFilial("SA2") + (cAliaSC6)->C5_CLIENTE + (cAliaSC6)->C5_LOJACLI, "SA2->A2_NREDUZ")
			ELSE	
	 			_nForCli:= "Cliente: "
				_nReduz := Posicione("SA1",1,xFilial("SA1") + (cAliaSC6)->C5_CLIENTE + (cAliaSC6)->C5_LOJACLI, "SA1->A1_NREDUZ")
			ENDIF	
			@ Li, PCol()+2 PSAY _nForCli + (cAliaSC6)->C5_CLIENTE + " / " + (cAliaSC6)->C5_LOJACLI + " - " + _nReduz
			@ Li, PCol()+1 PSAY "Emissao: " + DTOC(STOD((cAliaSC6)->C5_EMISSAO))
			Li := 10
		ENDIF
		_cDesc := Posicione("SB1",1,xFilial("SB1")+IIF(EMPTY((cAliaSC6)->C2_PRODUTO),(cAliaSC6)->C6_PRODUTO,(cAliaSC6)->C2_PRODUTO),"B1_DESC")
		IF _cItem <> (cAliaSC6)->C6_ITEM
			@Li ,000 PSAY (cAliaSC6)->C6_ITEM
		ENDIF
		@Li ,003 PSAY IIF(EMPTY((cAliaSC6)->C2_PRODUTO),(cAliaSC6)->C6_PRODUTO,(cAliaSC6)->C2_PRODUTO)
		@Li ,024 PSAY IIF((cAliaSC6)->ZK_MONTAG == "S","X"," ")
		@Li ,026 PSAY SUBSTR(_cDesc,1,30)
		@Li ,057 PSAY (cAliaSC6)->C6_UM
		@Li ,060 PSAY TRANSFORM((cAliaSC6)->QUANT,"@E 999,999.999")
		@Li ,072 PSAY "|"
		@Li ,074 PSAY (cAliaSC6)->C2_NUM+(cAliaSC6)->C2_ITEM+(cAliaSC6)->C2_SEQUEN
		@Li, 086 PSAY "|" 
		IF MV_PAR03 == 1
			@Li ,087 PSAY SUBSTR((cAliaSC6)->C6_MSOBS,1,35)
		ENDIF	
		_cItem 	 := (cAliaSC6)->C6_ITEM
		Li++
		@ Li,000 Psay __PrtFatLine()
		Li++
		(cAliaSC6)->(dbSkip())
	ENDDO
	If !Empty(_cOBS)
	   	For X := 1 TO MLCOUNT(_cOBS)
			Li++
			If Li > 55
	 			Li	:= cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				Li	++
			EndIf
			@ Li,00 PSay MEMOLINE(_cOBS,132,X)
		Next
	EndIf     
	Li := 60
ENDDO           

If Select(cAliaSC6) > 0
	(cAliaSC6)->(dbCloseArea())
EndIf



If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
EndIf

IF aReturn[5] > 1 .AND. mv_par04 == 1
	If !NewImp()
		For j := 1 To Len(aDesenhos)
			If Substr(_cDeptoUsu,1,3) == "205"	
				WaitRun("H:\Plotter\Plot\plot3_LPT2ALM.bat " + aDesenhos[j])
			Else
				WaitRun("H:\Plotter\Plot\plot3.bat " + aDesenhos[j])
			EndIf
		Next
   EndIf	       
ENDIF

MS_FLUSH()

RETURN

/*/{Protheus.doc} NewImp
//TODO Descrição: Substituição do arquivo .Bat.
@author Eduardo Mantoan
@since 06/02/2015
@version 1.0
@return lOK, logical, description: Verifica se continua a impressão
@type function
/*/
Static Function NewImp()

Local I

lOk:= .F.                                                                                                                   //
cIm := ""                                                                                                                   //
aIMP:= {}                                                                                                                   //
                                                                                                                	        //
_cEXE1  := "cmd /c NET USE LPT1: " //\\MSSRV-FSV01\LASER08                                                        		//
_cEXE2  := "cmd /c net use lpt1: /delete"                                                                            		//
_cEXE5  := "cmd /c PRINT "                                                         		  	                                //
                                                                                                               								//
aImps  := {}
aImpsS := {}                                                                                                      								//
aImps := GetImpWindows (.F.)
aImpsS := GetImpWindows (.T.)
	
		                                                                                                                    //
If SubStr(cNumEmp,1,2) == "01"                                                                                     								//
  	If (("PDF" $ aImps[1] ) .OR. ("XPS" $ aImps[1])) .OR. !("\\MSCLD-FSV01\" $ aImps[1])                       		    					//                                  		
  		cIm := Tela(aImps)                                                                                                 						//
  		cImps := SUBSTR(cIm,1,24)                                                                                                     			//
	Else                                                                                                           								//
		cImps := SUBSTR(aImps[1],1,24)                                                                                                          //
	EndIf                                                                                                                                       //
ElseIf SubStr(cNumEmp,1,2) == "10"                                                                                                              //
	If (("PDF" $ aImps[1] ) .OR. ("XPS" $ aImps[1])) .OR. !("\\FMAVMW05\" $ aImps[1])                       		    						//                                  		
  		cIm := Tela(aImps)                                                                                                 						//
  		cImps := SUBSTR(cIm,1,19)                                                                                                     		    //
	Else                                                                                                           								//
		cImps := SUBSTR(aImps[1],1,19)                                                                                                          //
	EndIf                                                                                                                                       //
Else                                                                                                                                            //
                                                                                                                                                //
EndIf  
	
	                                                                                                                                                //
If SubStr(cNumEmp,1,2) == "10"                                                                                                                  //
																		                                                                            //////////////////////////////////////////////////////////////                                 
	If !(("PDF" $ SUBSTR(cImps,1,20)) .OR. ("XPS" $ SUBSTR(cImps,1,20))) .AND. ( ("\\FMAVMW05\" $ cImps) .OR. ("\\fmavmw05\" $ cImps) .OR. ("\\MSCLD-FSV01\" $ cImps) .OR. ("\\MSCLD-FSV01\" $ cImps))//
    	lOK := .T.
   Else
	    	                                                                                                                                                                                        //
	EndIf	                                                                                                                                                                                                //
			                                                                                       													                                                            //
ElseIf SubStr(cNumEmp,1,2) == "01"                                                                                                                                                                          //
		                                                                                                                                                                                                        //
	If !(("PDF" $ SUBSTR(cImps,1,24)) .OR. ("XPS" $ SUBSTR(cImps,1,24))) .AND. (("\\MSCLD-FSV01\" $ cImps) .OR. ("\\MSCLD-FSV01\" $ cImps) .OR. ("\\FMAVMW05\" $ cImps) .OR. ("\\fmavmw05\" $ cImps) .OR. ("\\MSSRV-APP01\" $ cImps) .OR. ("\\mssrv-app01\" $ cImps) ) //
		lOK := .T.
	Else
	                                                                                                                                 //////////////////////////////////////////////////////////////
	EndIf                                                                                                                                       //
	    	                                                                                                                                        //
EndIf                                                                                                                                           //
If lOK 
      If SubStr(cNumEmp,1,2) == "01"                                                                                                                                    //
	  		cIMP := SUBSTR(cImps,1,24) 
	  ElseIf SubStr(cNumEmp,1,2) == "10" 
	  		cIMP := SUBSTR(cImps,1,19)
	  	
	  EndIf	                                                                                  								//
		_cEXE1 += ALLTRIM(cIMP)                                                                                      								//
	
		WaitRun(_cEXE2)// Deleta mapeamento LPT1                                                                            //
	 
	 If Len(aDesenhos) > 0                                                                                           //
		WaitRun(_cEXE1)//Mapeia LPT1 com impressora padrão    
		                                                    //
		For I := 1 TO Len(aDesenhos)                                                                                //
		                                                                                                            //
			WaitRun(_cEXE5+aDesenhos[I])//Imprime Desenho                                                           //

		Next                                                                                                        //
		WaitRun(_cEXE2)//Deleta mapeamento LPT1                                                                     //
	EndIf                                                                                                           //
EndIf                                                                                                            		//

Return lOK  

/*/{Protheus.doc} Tela
//TODO Descrição: Tela para seleção da impressora.
@author Eduardo Mantoan
@since 06/02/2015
@version 1.0
@return nComboBo1, numeric, description: número referente a impressora escolhida
@param aArray, array, descricao: Tela com as impressoras configuradas na máquina
@type function
/*/
Static Function Tela(aArray) 

Local oButton1
Local oComboBo1
Local nComboBo1 := aArray[1]
Local oSay1
Local oSay2
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Atenção, Impressora não atende os requisitos para essa impressão" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL

    @ 002, 012 SAY oSay1 PROMPT "Altere para uma impressora válida(Não pode ser gerador de PDF ou XPS e deve estar mapeada na rede)" SIZE 175, 022 OF oDlg COLORS 0, 16777215 PIXEL
    @ 040, 037 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS aArray SIZE 112, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 041, 005 SAY oSay2 PROMPT "Impressora :" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 075 BUTTON oButton1 PROMPT "OK" SIZE 070, 014 OF oDlg ACTION (oDlg:End())PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED


Return nComboBo1     