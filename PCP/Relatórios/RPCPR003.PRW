#INCLUDE "protheus.ch"
#INCLUDE "Topconn.ch"       
#Include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPR003  บAutor  ณJose Roberto        บ Data ณ  20/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmissao de produtos que o almoxarifado deve pagar para a    บฑฑ
ฑฑบ          ณ  montagem. Imprimir Lista de Faltas                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK.                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
// Alterado 26/03/2012 - por Ana Paula QFaustino - Acrecentado campo monitoramento C7_MSREUNI
*/

User Function RPCPR003()

	Private cDesc1       := "Emissao de produtos que o almoxarifado deve pagar"
	Private cDesc2       := "para a Montagem."
	Private cDesc3 	   := ""
	Private cPict 	      := ""
	Private wnRel        := "RPCPR003"
	Private titulo       := "Lista de faltas"
	Private Cabec1       := ""
	Private Cabec2       := ""
	Private imprime      := .T.
	Private aOrd         := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "M"
	Private nomeprog     := "RPCPR003"
	Private aReturn      := { "Zebrado", 1,"Administracao", 2, 1, 1, "", 1 }      
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont     	 := 00
	Private CONTFL     	 := 01
	Private cPerg		 := "PCPR03" + Space(4)
	Private _nLin		 := 80
	Private m_pag      	 := 1
	Private cCodig1      := ""
	Private cCodig2      := ""
	PRIVATE _nCont       := ""
	PRIVATE cGrupo       := SPACE(2)
	PRIVATE cPedVendas   := SPACE(6)
	PRIVATE cPosicao     := ""
	Private cPosicao1    := ""
	PRIVATE cReserva     := ""
	Private cString      := "SD4"
	PRIVATE nQUANTTOTAL  := 0
	PRIVATE cCelMont     := ""
	PRIVATE cCelMont     := ""
	PRIVATE aDesenhos    := {}
	PRIVATE cDesenho     := ""
	PRIVATE _cPath       := ""
	PRIVATE J            := 0
	PRIVATE CPRODCOM	 := ""
	PRIVATE APEDCOM		 := {}
	PRIVATE ASOLCOM		 := {}
	PRIVATE NX			 := 0
	
//	apmsgAlert("No fim da Emissใo, Verifique se a lista de Locais estแ correta")
	
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	//อออออออออออออออออออออออออออออออออออ
	// MV_PAR01 = GRUPO ?
	// MV_PAR02 = Do ProduTO ?
	// MV_PAR03 = Ate PRODUTO ?
	// MV_PAR04 = Pedido de Vendas   ?
	// MV_PAR05 = Imprime Saldo Zero ?
	// MV_PAR06 = LOCAL ?
	// MV_PAR07 = Centro de Custo ?
	// MV_PAR08 = Imprime Desenhos?
	// MV_PAR09 = Considera Produtos?  
	// MV_PAR10 = Ordena Produtos?
	// MV_PAR11 = Subtrai saldo em estoque? 
	// MV_PAR12 = Gera Etiqueta
	//			  - Fabricados - ALLTRIM(SB1->B1_PROCED) == "1P"
	//			  - Comprados  - ALLTRIM(SB1->B1_PROCED) == "2P"
	//			  - Ambos
	//ฑฑศออออออออออฯอออออออออออออออออออออ
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

	Pergunte(cPerg,.F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)
	
	If nLastKey == 27
		Set Filter to
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	RptStatus({|lEnd| _fImprime(@lEnd,wnRel,cString)},titulo)
	
Return

/*************************************************/
STATIC FUNCTION _FIMPRIME(LEND,WNREL,CSTRING)
/*************************************************/
	LOCAL NORDEM
	Local NX
	Local J
	LOCAL CSALDO0	:= 0
	LOCAL CQUERY	:= ""
	LOCAL CLINHA 	:= Chr(13) + Chr(10)
	LOCAL CPRODTST	:= ""
	LOCAL I			:= 0
	LOCAL NQTDLOC	:= 0
	LOCAL CMV_PAR06	:= ""
	Local aCampos := {}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria array para gerar arquivo de trabalho                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD(aCampos,{ "TB_PRODUTO"  ,"C",15,0 } )
	AADD(aCampos,{ "TB_DESC"     ,"C",35,0 } )
	AADD(aCampos,{ "TB_OP"       ,"C",6,0  } )
	AADD(aCampos,{ "TB_QTD"      ,"N",11,5 } )
	//AADD(aCampos,{ "TB_UM"     	 ,"C",06,0 } )
   	AADD(aCampos,{ "TB_CLIENTE"  ,"C",60,0 } )
   	AADD(aCampos,{ "TB_LOCAL"    ,"C",08,0 } )
   	AADD(aCampos,{ "TB_REFER"    ,"C",10,0}  )
   	AADD(aCampos,{ "TB_UM"       ,"C",02,0 } )
   //	AADD(aCampos,{ "TB_EST"    ,"C",02,0 } )
   //  	AADD(aCampos,{ "TB_DESC"   ,"C",35,0 } )
   //  	AADD(aCampos,{ "TB_PROCED" ,"C",02,0 } )
   //  	AADD(aCampos,{ "TB_CLASFIS","C",02,0 } )
   //	AADD(aCampos,{ "TB_TOTAL"  ,"N",14,2 } )
   //	AADD(aCampos,{ "TB_VALICM" ,"N",14,2 } )
   //	AADD(aCampos,{ "TB_VALIPI" ,"N",14,2 } )
   //	AADD(aCampos,{ "TB_OPTANTE","N",01,0 } )
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria arquivo de trabalho                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Select("TRB") > 0 
  	 DbSelectArea("TRB")
	   TRB->(DbCloseArea())
	EndIf

	oTable := FWTemporaryTable():New("TRB",aCampos)
	oTable:Create()
		
		
	TITULO	:=  "L I S T A  D E  F A L T A S"
	CABEC1	:=  "CODIGO            SEQ.   DESCRICAO           INI.MONT   ORDEM DE                            SALDO             CELULA      LOTE   EST."
	CABEC2  :=  "                                                        PRODUCAO     REFER.  SEPAR.  QUANT  ESTOQUE  LOCAL    MONTAG      MIN.   SEG "
	//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
	//           0         1         2         3         4         5         6         7         8         9        10        11        12        13
	
	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	SC2->(dbGoTop())
	
	dbSelectArea("SD4")
	SD4->(dbSetOrder(9))
	SD4->(dbGoTop())

	SetRegua(LastRec())
	
	_nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
	
	_nLin++
	@ _nLin,000 Psay PADC("Do Grupo "  + ALLTRIM(MV_PAR01),132)
	_nLin++
	@ _nLin,000 Psay PADC("Do Produto " + ALLTRIM(MV_PAR02),132)
	_nLin++
	@ _nLin,000 Psay  PADC("Ate o Produto " + ALLTRIM(MV_PAR03),132)
	_nLin++
	@ _nLin,000 Psay  PADC("Pedido de Vendas " + ALLTRIM(MV_PAR04),132)
	_nLin++
	@ _nLin,000 Psay  PADC("Imprime Saldo Zero " + ALLTRIM(MV_PAR05),132)
	_nLin++
	@ _nLin,000 Psay  PADC("LOCAL " + ALLTRIM(MV_PAR06),132)
	_nLin++
	
	IF EMPTY(MV_PAR03)
		MV_PAR03 := "ZZZZZZZZZZ"
	ENDIF
	
	CQUERY := " SELECT " + CLINHA
	CQUERY += " SD4.D4_COD AS D4_COD, " + CLINHA
	CQUERY += "	SD4.D4_TRT AS D4_TRT, " + CLINHA
	CQUERY += " SUBSTRING(SB1.B1_DESC,1,30) AS B1_DESC, " + CLINHA
	CQUERY += " SB1.B1_UM AS B1_UM, " + CLINHA
	CQUERY += " SD4.D4_OP AS D4_OP, " + CLINHA
	CQUERY += " SD4.D4_MSREFER AS D4_MSREFER, " + CLINHA
	CQUERY += " SD4.D4_MSSEPAR AS D4_MSSEPAR, " + CLINHA
	CQUERY += " SD4.D4_QUANT AS D4_QUANT, " + CLINHA
	CQUERY += " SB2.B2_QATU AS B2_QATU, " + CLINHA
	CQUERY += " SB2.B2_RESERVA AS B2_RESERVA, " + CLINHA
	CQUERY += " SB1.B1_LOCAL AS B1_LOCAL, " + CLINHA
	CQUERY += " SB1.B1_LM AS B1_LM, " + CLINHA
	CQUERY += " SB1.B1_UM AS B1_UM, " + CLINHA
	CQUERY += " SB1.B1_ESTSEG AS B1_ESTSEG, " + CLINHA
	CQUERY += " (SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN) AS C2_OP, " + CLINHA
	CQUERY += " SC2.C2_PRODUTO AS C2_PRODUTO, " + CLINHA
	CQUERY += " SC2.C2_MSPOSIC AS C2_MSPOSIC, " + CLINHA
	CQUERY += " ( SELECT SUBSTRING(SB1.B1_LOCAL,1,4) FROM SB1010 SB1 WHERE SB1.D_E_L_E_T_ = '' AND SB1.B1_COD = SC2.C2_PRODUTO) AS LOCAL_C2_PRODUTO, " + CLINHA
	CQUERY += " SC2.C2_MSPED AS C2_MSPED, " + CLINHA
	CQUERY += " SC5.C5_NUM , " + CLINHA
	CQUERY += " SC5.C5_MSMONTA , " + CLINHA
	CQUERY += " SC2.C2_MSREDUZ AS C2_MSREDUZ, " + CLINHA
	CQUERY += " SC2.C2_MSCI AS C2_MSCI, " + CLINHA
	CQUERY += " SC2.C2_MSDTCI AS C2_MSDTCI " + CLINHA
	CQUERY += " FROM  " + RETSQLNAME("SD4") + " SD4 " + CLINHA
	CQUERY += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 "
	CQUERY += " ON SD4.D4_COD = SB1.B1_COD " + CLINHA
	CQUERY += " INNER JOIN " + RETSQLNAME("SB2") + " SB2 "
	CQUERY += " ON SD4.D4_COD = SB2.B2_COD AND SB2.B2_LOCAL = SB1.B1_LOCPAD " + CLINHA
	CQUERY += " INNER JOIN " + RETSQLNAME("SC2") + " SC2 "
	CQUERY += " ON SUBSTRING(SD4.D4_OP,1,11) = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN "  + CLINHA
	CQUERY += " AND	SB1.B1_FILIAL = SD4.D4_FILIAL " + CLINHA
	CQUERY += " AND	SB2.B2_FILIAL = SD4.D4_FILIAL " + CLINHA
	CQUERY += " AND SC2.C2_FILIAL = SD4.D4_FILIAL " + CLINHA
	CQUERY += " LEFT JOIN " + RETSQLNAME("SC5") + " SC5 "
	CQUERY += " ON C2_MSPED = C5_NUM AND SC5.D_E_L_E_T_='' AND C5_FILIAL = '"+xFilial("SC5")+"' "  + CLINHA
	CQUERY += " WHERE SD4.D_E_L_E_T_ = '' " + CLINHA
	CQUERY += " AND	SB1.D_E_L_E_T_ = '' " + CLINHA
	CQUERY += " AND	SB2.D_E_L_E_T_ = '' " + CLINHA
	CQUERY += " AND SC2.D_E_L_E_T_ = ''	" + CLINHA
	CQUERY += " AND SD4.D4_MSLF = 'X' " + CLINHA
	CQUERY += " AND SD4.D4_QUANT > 0 " + CLINHA
	CQUERY += " AND	SD4.D4_COD BETWEEN '" + RTRIM(MV_PAR02) + "' AND '" + MV_PAR03 + "' " + CLINHA

	// FILTRAR OS GRUPOS DIGITADO PELO USUARIO NO MV_PAR01
	IF !EMPTY(ALLTRIM(MV_PAR01))
		CQUERY += " AND SB1.B1_GRUPO = '" + MV_PAR01 + "' " + CLINHA
	ENDIF
	
	IF !EMPTY(ALLTRIM(MV_PAR04))
		CQUERY += " AND SC2.C2_MSPED = '" + ALLTRIM(MV_PAR04) + "' " + CLINHA
		//CQUERY += " AND SC2.C2_NUM = '" + ALLTRIM(MV_PAR04) + "' " + CLINHA
	ENDIF

	// FILTRAR O SALDO EM ESTOQUE PELO USUARIO NO MV_PAR05
	IF MV_PAR05 == "N"

		CQUERY += " AND SB2.B2_QATU <> 0 " + CLINHA
	ENDIF

	// FILTRAR OS LOCAIS QUE O USUARIO DIGITOU NO MV_PAR06 ATRAVES DO COMANDO SQL CHAMADO IN
	IF !EMPTY(MV_PAR06)
		I 			:= 1
		NQTDLOC		:= LEN(RTRIM(MV_PAR06))
		CMV_PAR06	:= ""

		DO WHILE I <= NQTDLOC

			CMV_PAR06 += "'" + SUBSTR(MV_PAR06,I,1) + "'"
			I ++
		    
			IF I <= NQTDLOC
				CMV_PAR06 += ","
			ENDIF
	
		END DO
		CQUERY += " AND SUBSTRING(SB1.B1_LOCAL,1,1) IN (" + CMV_PAR06 + ")" + CLINHA
	ENDIF

	// FILTRAR A PROCEDENCIA DO PRODUTO ESCOLHIDO PELO USUARIO NO MV_PAR09
	IF MV_PAR09 <> 3
		DO CASE
			CASE MV_PAR09 == 1
				CQUERY += "	AND SB1.B1_PROCED = '1P' " + CLINHA
			CASE MV_PAR09 == 2
				CQUERY += " AND SB1.B1_PROCED = '2P' " + CLINHA
		END CASE
	ENDIF
   If SubStr(cNumEmp,1,2) == "10"
   
		CQUERY += " ORDER BY B1_LOCAL, SD4.D4_MSLF, SD4.D4_COD,C5_MSMONTA, SD4.D4_OP "   //DBSETORDER 9
   Else 
   	CQUERY += " ORDER BY SD4.D4_FILIAL, SD4.D4_MSLF, SD4.D4_COD,C5_MSMONTA, SD4.D4_OP "   //DBSETORDER 9

   EndIf
	//ALERT(CQUERY)
	CQUERY := CHANGEQUERY(CQUERY)
	TCQUERY CQUERY NEW ALIAS(ALIAS:=GETNEXTALIAS())
	
	DBSELECTAREA(ALIAS)
	(ALIAS)->(DBGOTOP())

	DO WHILE (ALIAS)->(!EOF())
		IncRegua()

		If lEnd
			@ _nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		cReserva	:= ""
		cCodAnt		:= (ALIAS)->D4_COD
		lFaltante	:= .F.
        lPrim       := .T.
        nQuantest   := (ALIAS)->B2_QATU
		WHILE (ALIAS)->D4_COD == cCodAnt .AND. (ALIAS)->(!EOF())
            
			cProdAnt := (ALIAS)->D4_COD
			CCELMONT := ""
			IF !EMPTY(ALLTRIM((ALIAS)->LOCAL_C2_PRODUTO))
				CCELMONT := ALLTRIM((ALIAS)->LOCAL_C2_PRODUTO)
			ENDIF
			
			IF _nLin > 55
				lPrim := .T.
				_nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,18)
			ENDIF
			_nLin++
			lFaltante := .T.

            If lPrim 
				@ _nLin,000 Psay (ALIAS)->D4_COD
				@ _nLin,018 psay (ALIAS)->D4_TRT
				@ _nLin,022 Psay SUBSTR((ALIAS)->B1_DESC,1,22)
				@ _nLin,045 psay DTOC(STOD((ALIAS)->C5_MSMONTA))
				@ _nLin,056 Psay ALLTRIM((ALIAS)->D4_OP)
				@ _nLin,069 psay (ALIAS)->D4_MSREFER
				@ _nLin,077 Psay SUBSTR((ALIAS)->D4_MSSEPAR,7,2) + "/" + SUBSTR((ALIAS)->D4_MSSEPAR,5,2)
				@ _nLin,083 Psay (ALIAS)->D4_QUANT Picture "@E 9999.999"
				If MV_PAR11 = 1
					@ _nLin,092 Psay nQuantest Picture "@E 9999.999"
				Else 
					@ _nLin,092 Psay (ALIAS)->B2_QATU Picture "@E 9999.999"
				EndIf
				@ _nLin,101 Psay (ALIAS)->B1_LOCAL
				@ _nLin,110 Psay CCELMONT
				@ _nLin,120 Psay STR((ALIAS)->B1_LM,5,0)
				@ _nLin,127 Psay STR((ALIAS)->B1_ESTSEG,5,0)
	            lPrim := .F.
			Else
				@ _nLin,018 psay (ALIAS)->D4_TRT
				@ _nLin,045 psay DTOC(STOD((ALIAS)->C5_MSMONTA))
				@ _nLin,056 Psay ALLTRIM((ALIAS)->D4_OP)
				@ _nLin,069 psay (ALIAS)->D4_MSREFER
				@ _nLin,077 Psay SUBSTR((ALIAS)->D4_MSSEPAR,7,2) + "/" + SUBSTR((ALIAS)->D4_MSSEPAR,5,2)
				@ _nLin,083 Psay (ALIAS)->D4_QUANT Picture "@E 9999.999"
				If MV_PAR11 = 1
					@ _nLin,092 Psay nQuantest Picture "@E 9999.999"
				Else 
					@ _nLin,092 Psay (ALIAS)->B2_QATU Picture "@E 9999.999"
				EndIf
				@ _nLin,101 Psay (ALIAS)->B1_LOCAL

				@ _nLin,110 Psay CCELMONT
				@ _nLin,120 Psay STR((ALIAS)->B1_LM,5,0)
				@ _nLin,127 Psay STR((ALIAS)->B1_ESTSEG,5,0)
			EndIf 
			//////////////////////////////////////////
			If nQuantest > 0
		   		If ( nQuantest - (ALIAS)->D4_QUANT ) >= 0   
		   			nQTDET := (ALIAS)->D4_QUANT 
		   		Else
		   			nQTDET := nQuantest 	
		   		EndIf
		   		RecLock("TRB",.T.)
   				TRB->TB_DESC  	:= SUBSTR((ALIAS)->B1_DESC,1,22)
   				TRB->TB_PRODUTO := (ALIAS)->D4_COD     
   				TRB->TB_OP 		:= ALLTRIM(SUBSTR((ALIAS)->D4_OP,1,6))
   				TRB->TB_QTD 	:= nQTDET
				TRB->TB_CLIENTE := (ALIAS)->C2_MSREDUZ   
				TRB->TB_LOCAL   := (ALIAS)->B1_LOCAL
				TRB->TB_REFER   := (ALIAS)->D4_MSREFER
				TRB->TB_UM      := (ALIAS)->B1_UM
				TRB->(MSUnlock())		
			EndIf			
            ///////////////////////////////////////////
			IF !EMPTY((ALIAS)->C2_MSREDUZ)
				_nLin++
				@ _nLin,022 PSAY "Cliente: " + (ALIAS)->C2_MSREDUZ
				// Alterado 04/05/2012 POR Ana Paula QFaustino
				//IF !EMPTY(ALLTRIM((ALIAS)->C2_MSCI))
				//	@ _nLin,051 PSAY " CI: " + ALLTRIM((ALIAS)->C2_MSCI) + " de: " + DTOC(STOD((ALIAS)->C2_MSDTCI))	//DTOC(STOD(
				//ENDIF
			ENDIF
			IF (ALIAS)->B2_QATU < ((ALIAS)->B2_RESERVA + (ALIAS)->D4_QUANT) .AND. !EMPTY((ALIAS)->B2_RESERVA)
				cReserva := "*** RESERVADO PARA VENDAS: " + STR((ALIAS)->B2_RESERVA,8) + " " + (ALIAS)->B1_UM + " ***"
			ENDIF
			IF SD4->(DBSEEK(XFILIAL("SD4")+"X"+(ALIAS)->D4_COD))
				RECLOCK("SD4",.F.)
				SD4->D4_MSIMPRE := "X"
				SD4->(MSUNLOCK())
			ENDIF
			nQuantest -= (ALIAS)->D4_QUANT 			
			(ALIAS)->(DBSKIP())

		ENDDO 
		If MV_PAR11 = 1
	   		_nLin++   
	   		@ _nLin,092 Psay nQuantest Picture "@E 9999.999"
		Else     
		
		EndIf
		//**********************************************
		// impressใo dos desenhos
		//**********************************************
		cDesenho := cProdAnt
		_cPath := "H:\PLOTTER\"
		If SubStr(cNumEmp,1,2) == "01"
			If Substr(cDesenho,1,2) == "CL"
				_cPath += Substr(cDesenho,3,2) + "\"
			ELSE
				_cPath += Substr(cDesenho,1,2) + "\"
			ENDIF
		ElseIf SubStr(cNumEmp,1,2) == "10"
			_cPath += Substr(cDesenho,1,3) + "\"
		EndIf
		
		AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
		AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
		AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
		
		sc2->(dBSetOrder(2))
		sc2->(DBGOTOP())

		IF sc2->(DBSEEK(xFilial("SC2") + cProdAnt)) .AND. lFaltante
			cPosicao  := ""
			cPosicao1 := ""
			WHILE sc2->c2_produto == cProdAnt .AND. !sc2->(EOF()) .AND. EMPTY(cPosicao)
				IF EMPTY(sc2->c2_datrf) .AND. !EMPTY(sc2->c2_msposic)
					cPosicao := "OP: " + sc2->c2_num + sc2->c2_item + sc2->c2_sequen + " - Posicao: " + sc2->c2_msposic 
					If !EMPTY(SC2->C2_MSCI)
						cPosicao1:= "CI: "+SC2->C2_MSCI+" de: " + DTOC(SC2->C2_MSDTCI)
					EndIf
				ENDIF
				sc2->(DBSKIP())
			EndDo
			IF !EMPTY(cPosicao)
				_nLin++
				@ _nLin,022 PSAY cPosicao
			ENDIF
			IF !EMPTY(cPosicao1)
				_nLin++
				@ _nLin,022 PSAY cPosicao1
			ENDIF
		ENDIF
		
		sc2->(dbSetOrder(1))
		IF !EMPTY(cReserva)
			_nLin++
			@ _nLin,022 PSAY cReserva
		ENDIF
        
		//IF MV_PAR09 <> 2	// SE PRODUTO NAO FOR COMPRADO
		cPRODCOM := cProdAnt //(ALIAS)->D4_COD 
		
		BUSCAPC(cPRODCOM)

		NX := 0
		IF LEN(aPEDCOM) > 0 	// PEDIDO DE COMPRAS
			FOR NX := 1 TO LEN(aPEDCOM)
				IF cProdAnt == aPEDCOM[NX,1]  //(ALIAS)->D4_COD == aPEDCOM[NX,1]
					_NLIN ++
					_CFORNECE := Posicione("SA2",1,xFilial("SA2")+APEDCOM[NX,3]+APEDCOM[NX,4],"A2_NREDUZ")
					_CFORNECE := SUBSTR(ALLTRIM(_CFORNECE),1,15)
					If APEDCOM[NX,8] = " "
						@ _NLIN,022 PSAY "Pedido Compra: " +APEDCOM[NX,2] + " Fornecedor: " +_CFORNECE + " Quant: " +STR(APEDCOM[NX,6],7,0) + " Entrega: " +DTOC(STOD(APEDCOM[NX,7]))
					Else
					@ _NLIN,022 PSAY "Pedido Compra: " +APEDCOM[NX,2] + " Fornecedor: " +_CFORNECE + " Quant: " +STR(APEDCOM[NX,6],7,0) + " Entrega: " +DTOC(STOD(APEDCOM[NX,7]))+"  Monit.: " +DTOC(STOD(APEDCOM[NX,8]))
					EndIf														
				ENDIF
			NEXT NX
		ENDIF
		IF LEN (aSOLCOM) > 0    // SOLICITACAO DE COMPRAS
			FOR NX := 1 TO LEN(aSOLCOM)
				IF cProdAnt == aSOLCOM[NX,1]   //(ALIAS)->D4_COD == aSOLCOM[NX,1]
					_NLIN ++
					If ASOLCOM[NX,6] = " "
						@ _NLIN,022 PSAY "Solicita็ใo Compra: " +ASOLCOM[NX,2] + " Solicitante: " +ASOLCOM[NX,3] + " Quant: " +STR(ASOLCOM[NX,4],7,0) + " Entrega: " +DTOC(STOD(ASOLCOM[NX,5]))
					Else
						@ _NLIN,022 PSAY "Solicita็ใo Compra: " +ASOLCOM[NX,2] + " Solicitante: " +ASOLCOM[NX,3] + " Quant: " +STR(ASOLCOM[NX,4],7,0) + " Entrega: " +DTOC(STOD(ASOLCOM[NX,5]))+" Monit.: " +DTOC(STOD(ASOLCOM[NX,6]))
					EndIf
				ENDIF
			NEXT NX
		ENDIF
		//ENDIF
		
		If lFaltante
			_nLin++
			@ _nLin,000 Psay Replicate("-",132)
		EndIf
        
	ENDDO
	If SUBSTR(cNumEmp,1,2) $ "10" 
		_nLin++
		@ _nLin,001 PSAY  "Separador: ->  "+ ALLTRIM(MV_PAR13)
	EndIf
	SET DEVICE TO SCREEN 

	If aReturn[5] > 1 .And. MV_PAR08 == 1
		For J := 1 TO LEN(aDesenhos)
			WaitRun(aDesenhos[j])
		Next
	Endif
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool (wnrel)
	Endif
	
	MS_FLUSH()
	If MV_PAR12 = 1  .AND. MV_PAR11 = 1
		ALERT("Imprimindo etiquetas!")
   		GeraEtiqu() 
 	EndIf
	 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   BUSCAPC      บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ    25/07/11  บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION BUSCAPC()

	LOCAL CQPEDCOM := ""	// VARIAVEL CARACTER QUE ARMAZENARA A QUERY PARA PEDIDOS DE COMPRAS
	LOCAL CQSOLCOM := ""	// VARIAVEL CARACTER QUE ARMAZENARA A QUERY PARA SOLICITACAO DE COMPRAS
	LOCAL CPRODUTO := CPRODCOM
	
	APEDCOM := {}
	ASOLCOM := {}
	
	CQPEDCOM := " SELECT SC7.C7_PRODUTO C7_PRODUTO, "
	CQPEDCOM += " SC7.C7_NUM C7_NUM, "
	CQPEDCOM += " SC7.C7_FORNECE C7_FORNECE, "
	CQPEDCOM += " SC7.C7_LOJA C7_LOJA, "
	CQPEDCOM += " SUBSTRING(SA2.A2_NOME,1,30) A2_NOME, "
	CQPEDCOM += " SC7.C7_QUANT C7_QUANT, "
	CQPEDCOM += " SC7.C7_QUJE C7_QUJE, "
	CQPEDCOM += " SC7.C7_DATPRF C7_DATPRF, " 
   CQPEDCOM += " SC7.C7_MSREUNI C7_MSREUNI "
	CQPEDCOM += " FROM " + RETSQLNAME("SC7") + " SC7 "
	CQPEDCOM += " INNER JOIN " + RETSQLNAME("SA2") + " SA2 "
	CQPEDCOM += " ON SA2.A2_COD = SC7.C7_FORNECE "
	CQPEDCOM += " AND SA2.A2_LOJA = SC7.C7_LOJA "
	CQPEDCOM += " WHERE	SC7.D_E_L_E_T_ = '' "
	CQPEDCOM += " AND SA2.D_E_L_E_T_ = ''
	CQPEDCOM += " AND SC7.C7_RESIDUO = '' "
	CQPEDCOM += " AND SC7.C7_QUJE < SC7.C7_QUANT "
	CQPEDCOM += " AND SC7.C7_PRODUTO = '" + CPRODUTO + "' "
	CQPEDCOM += " ORDER BY SC7.C7_FILIAL, SC7.C7_PRODUTO, SC7.C7_DATPRF "
	
	CQPEDCOM := CHANGEQUERY(CQPEDCOM)
	TCQUERY CQPEDCOM NEW ALIAS(ALIAS2:=GETNEXTALIAS())

	DBSELECTAREA(ALIAS2)
	(ALIAS2)->(DBGOTOP())
	
	DO WHILE (ALIAS2)->(!EOF())
		AADD(APEDCOM, {(ALIAS2)->C7_PRODUTO, (ALIAS2)->C7_NUM, (ALIAS2)->C7_FORNECE, (ALIAS2)->C7_LOJA, (ALIAS2)->A2_NOME, ((ALIAS2)->C7_QUANT - (ALIAS2)->C7_QUJE), (ALIAS2)->C7_DATPRF, (ALIAS2)->C7_MSREUNI})
//		AADD(APEDCOM, {(ALIAS2)->C7_PRODUTO, (ALIAS2)->C7_NUM, (ALIAS2)->C7_FORNECE, (ALIAS2)->C7_LOJA, (ALIAS2)->A2_NOME, ((ALIAS2)->C7_QUANT - (ALIAS2)->C7_QUJE), (ALIAS2)->C7_DATPRF})
		(ALIAS2)->(DBSKIP())
	ENDDO
	
	(ALIAS2)->(DBCLOSEAREA())

	// SE NAO ENCONTRAR PEDIDOS DE COMPRAS NA CONSULTA ACIMA, VERIFICA SE EXISTE SOLICITACAO DE COMPRAS PARA O MESMO PRODUTO
	IF LEN(APEDCOM) == 0
		CQSOLCOM := " SELECT SC1.C1_PRODUTO,
		CQSOLCOM += " SC1.C1_NUM, "
		CQSOLCOM += " SC1.C1_SOLICIT, "
		CQSOLCOM += " SC1.C1_QUANT, "
		CQSOLCOM += " SC1.C1_DATPRF, "
		CQSOLCOM += " SC1.C1_MSREUNI "
		CQSOLCOM += " FROM SC1010 SC1 "
		CQSOLCOM += " WHERE	SC1.D_E_L_E_T_ = '' "
		CQSOLCOM += " AND SC1.C1_RESIDUO = '' "
		CQSOLCOM += " AND SC1.C1_PEDIDO = '' "
		CQSOLCOM += " AND SC1.C1_PRODUTO = '" + CPRODUTO + "' "
		CQSOLCOM += " ORDER BY SC1.C1_FILIAL, SC1.C1_PRODUTO, SC1.C1_NUM, SC1.C1_ITEM, SC1.C1_FORNECE, SC1.C1_LOJA "
	
		CQSOLCOM := CHANGEQUERY(CQSOLCOM)
		TCQUERY CQSOLCOM NEW ALIAS(ALIAS3:=GETNEXTALIAS())
		
		DBSELECTAREA(ALIAS3)
		(ALIAS3)->(DBGOTOP())
		
		DO WHILE (ALIAS3)->(!EOF())
			AADD(ASOLCOM, {(ALIAS3)->C1_PRODUTO, (ALIAS3)->C1_NUM, (ALIAS3)->C1_SOLICIT, (ALIAS3)->C1_QUANT, (ALIAS3)->C1_DATPRF, (ALIAS3)->C1_MSREUNI })
//			AADD(ASOLCOM, {(ALIAS3)->C1_PRODUTO, (ALIAS3)->C1_NUM, (ALIAS3)->C1_SOLICIT, (ALIAS3)->C1_QUANT, (ALIAS3)->C1_DATPRF})
			(ALIAS3)->(DBSKIP())
		END DO
		
		(ALIAS3)->(DBCLOSEAREA())

	ENDIF

RETURN()  

Static Function GeraEtiqu()

	_cEXE2  := "cmd /c net use lpt1: /delete"
	WaitRun(_cEXE2)// Deleta mapeamento LPT1
	If cResp1:=msgbox("Impressora LPT1?","Aten็ใo...","YESNO") 
		MSCBPRINTER("OS 214","LPT1",NIL,)
	Else
		MSCBPRINTER("OS 214","COM1",NIL,)	
	EndIf   
      
	MSCBCHKSTATUS(.F.)
//	If n = 2
//		TcQuery _cQuery2 New Alias "QR1" 
//		ALERT("O sistema irแ imprimir a lista de falta ")
//	EndIf
	TRB->(dbGoTop())
	DO WHILE !TRB->(EOF())
		
		MSCBBEGIN(1,4)   
	    
	  
	   
		MSCBSAY(05,03,"Codigo.:" + TRB->TB_PRODUTO    ,"B","2","01,01")  
		MSCBSAY(05,45,"LF"    ,"B","2","01,01")
	   MSCBSAY(09,03,"Desc...:" + TRB->TB_DESC       ,"B","2","01,01")
		MSCBSAY(13,03,"Cliente:" + SUBSTR(TRB->TB_CLIENTE,1,22),"B","2","01,01")
		MSCBSAY(17,03,"Pedido.:" + TRB->TB_OP         ,"B","2","01,01")   
		MSCBSAY(21,03,"Refer..:" + ALLTRIM(TRB->TB_REFER) ,"B","2","01,01")
		MSCBSAY(25,03,"Quant.:"  + ALLTRIM(TRANSFORM(TRB->TB_QTD, "@E 999,999.999"))    ,"B","2","01,01")
		MSCBSAY(25,30,"UM.:"     + ALLTRIM(TRB->TB_UM),"B","2","01,01")
		MSCBSAY(29,03,"Local:"   + ALLTRIM(TRB->TB_LOCAL)    ,"B","2","01,01")    
			 
		If SUBSTR(cNumEmp,1,2) $ "10" 
		 	MSCBSAY(29,30,ALLTRIM(MV_PAR13)    ,"B","2","01,01")
		Else  
			MSCBSAY(29,30,"Imp:"	    + ALLTRIM(DTOC(DATE()))    ,"B","2","01,01")
		EndIf
		TRB->(dbSkip())
		IF !TRB->(EOF())
		    
			MSCBSAY(35,03,"Codigo.:" + TRB->TB_PRODUTO    ,"B","2","01,01") 
			MSCBSAY(35,45,"LF"    ,"B","2","01,01")
	    	MSCBSAY(39,03,"Desc...:" + TRB->TB_DESC       ,"B","2","01,01")
			MSCBSAY(43,03,"Cliente:" + SUBSTR(TRB->TB_CLIENTE,1,22),"B","2","01,01")
			MSCBSAY(47,03,"Pedido.:" + TRB->TB_OP         ,"B","2","01,01")   
			MSCBSAY(51,03,"Refer..:" + ALLTRIM(TRB->TB_REFER) ,"B","2","01,01")
			MSCBSAY(55,03,"Quant.:" + ALLTRIM(TRANSFORM(TRB->TB_QTD, "@E 999,999.999"))    ,"B","2","01,01")
			MSCBSAY(55,30,"UM.:" + ALLTRIM(TRB->TB_UM),"B","2","01,01")
			MSCBSAY(59,03,"Local:" + ALLTRIM(TRB->TB_LOCAL)    ,"B","2","01,01")    
			If SUBSTR(cNumEmp,1,2) $ "10" 
				MSCBSAY(59,30,ALLTRIM(MV_PAR13)    ,"B","2","01,01")
			Else  
				MSCBSAY(59,30,"Imp:"	    + ALLTRIM(DTOC(DATE()))    ,"B","2","01,01")
			EndIf		
		 
			TRB->(dbSkip())
			IF !TRB->(EOF())
				
				MSCBSAY(65,03,"Codigo.:" + TRB->TB_PRODUTO    ,"B","2","01,01")     
				MSCBSAY(65,45,"LF"    ,"B","2","01,01")
	    		MSCBSAY(69,03,"Desc...:" + TRB->TB_DESC       ,"B","2","01,01")
				MSCBSAY(73,03,"Cliente:" + SUBSTR(TRB->TB_CLIENTE,1,22),"B","2","01,01")
				MSCBSAY(77,03,"Pedido.:" + TRB->TB_OP         ,"B","2","01,01")   
				MSCBSAY(81,03,"Refer..:" + ALLTRIM(TRB->TB_REFER) ,"B","2","01,01")
				MSCBSAY(85,03,"Quant.:" + ALLTRIM(TRANSFORM(TRB->TB_QTD, "@E 999,999.999"))    ,"B","2","01,01")
				MSCBSAY(85,30,"UM.:" + ALLTRIM(TRB->TB_UM),"B","2","01,01")
				MSCBSAY(89,03,"Local:" + ALLTRIM(TRB->TB_LOCAL)    ,"B","2","01,01")    
			  
				If SUBSTR(cNumEmp,1,2) $ "10" 
		 			MSCBSAY(89,30,ALLTRIM(MV_PAR13)    ,"B","2","01,01")
	  			Else  
					MSCBSAY(89,30,"Imp:"	    + ALLTRIM(DTOC(DATE()))    ,"B","2","01,01")
				EndIf		
			 				
				TRB->(dbSkip())
			ELSE
				MSCBEND() //Fim da Imagem da Etiqueta
				EXIT
			ENDIF
		ELSE
			MSCBEND() //Fim da Imagem da Etiqueta
			EXIT
		ENDIF
		MSCBEND() //Fim da Imagem da Etiqueta
	ENDDO
	
	MSCBEND() //Fim da Imagem da Etiqueta
	
	MSCBCLOSEPRINTER()
	
	TRB->(dbCloseArea())


IF Select("QR2") > 0
	DbSelectArea("QR2")
	DbCloseArea()
ENDIF

IF Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
ENDIF
IF Select("QR3") > 0
	DbSelectArea("QR3")
	DbCloseArea()
ENDIF
Return

RETURN
