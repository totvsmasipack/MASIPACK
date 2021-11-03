#include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "MASI_EMP.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA072  ºAutor  ³Ivandro Santos      º Data ³  26/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa que atualiza o preço de venda nos pedidos de Vendaº±±
±±º          ³ e compra                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PE OM010LOK                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RFATA072(cProdTab,nPrecVen)
Local _cQry  	:= ""
Local aCabec 	:= {}
Local aItem	 	:= {}
//Ivandro Santos - 26/05/17 - início da alteração
//Ticket#2016080537000173 — Tarefa ID 120 - PC -> PV
Local aNomEmp   := {"",""}
Local _aCli		:= {"",""}	             
Local aEmpGru   := {"MASIPACK","FABRIMA","HELSIMPLAST"}
Local _nEmG

Private  aDadosEmp 	:= {"","","",""}
Private _cEmpresa  	:=SM0->M0_CODIGO
Private _cTabIn 	:= Alltrim(GetMv("MS_CODTABI"))

aNomEmp[1] := Alltrim(SM0->M0_NOME)
For _nEmG := 1 to len(aEmpGru)
	If !(aEmpGru[_nEmG] == aNomEmp[1])
		aNomEmp[2] := aEmpGru[_nEmG]
		aDadosEmp := U_MSACHAEM(aNomEmp,_cEmpresa)
		//Ivandro Santos - 02/02/17
		//Ticket#2017020237000106 — Tabela 900
		//_aCli := U_MSCODCLI(aDadosEmp)
		//Ticket#2017020237000106 — Fim da alteração
		
		_cQry := "SELECT C6_NUM, C6_ITEM, C6_QTDVEN,C6_PRCVEN,C6_PEDCLI,C6_MSITPEC,C6_NUMPCOM,C6_ITEMPC "
		//Ivandro Santos - início da alteração
		//Ticket#2017050437000197 — Intercompany
		_cQry += "FROM "+RetSQLName("SC6")+" C6 "
		//_cQry += "FROM SC6010 C6 "
		_cQry += "INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_NUM = C6_NUM AND C5.D_E_L_E_T_ = '' AND C5_FILIAL = '" + xFilial("SC5")+"' "
		//_cQry += "INNER JOIN SC5010 C5 ON C5_NUM = C6_NUM AND C5.D_E_L_E_T_ = '' AND C5_FILIAL = '" + xFilial("SC5")+"' "
		_cQry += "INNER JOIN "+RetSQLName("SA1")+" A1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA AND A1.D_E_L_E_T_ = '' AND A1_FILIAL = '" + xFilial("SA1")+"' "
		//_cQry += "INNER JOIN SA1010 A1 ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA AND A1.D_E_L_E_T_ = '' AND A1_FILIAL = '" + xFilial("SA1")+"' "
		//Ticket#2017050437000197 — Fim da alteração
		//Ticket#2017020237000106 — Fim da alteração
		_cQry += "WHERE "
		_cQry += "	C6_BLQ <> 'R' "
		//Ticket#2017020237000106 — Tabela 900
		/*_cQry += "	AND C5_CLIENTE = '"+_aCli[1]+"' "
		_cQry += "	AND C5_LOJACLI = '"+_aCli[2]+"' " */
		If len(aDadosEmp) > 0
			_cQry += "	AND A1_CGC = '"+aDadosEmp[4]+"' "
		Endif
		//Ticket#2017020237000106 — Fim da alteração
		_cQry += "	AND C5_LIBEROK = '' "
		_cQry += "	AND (C5_NOTA <> 'XXXXXX' OR C5_NOTA = '') "
		_cQry += "	AND C5_MSCONCL = '' "
		_cQry += "	AND (C6_QTDVEN-(C6_QTDENT+C6_QTDENT2))>0 "
		_cQry += "	AND C5_TABELA = '"+_cTabIn+"' "
		_cQry += "	AND C6_FILIAL = '" + xFilial("SC6") + "' "
		_cQry += "	AND C6.D_E_L_E_T_ = '' "
		_cQry += "	AND C6_PRODUTO = '"+cProdTab+"' "
		_cQry += "	AND C6_PEDCLI <> '' "
		_cQry += "	AND C6_MSITPEC <> '' "
		
		If Select("QRPV") > 0
			dbSelectArea("QRPV")
			dbCloseArea()
		EndIf
		
		//-----------------------
		//| Cria uma view no banco
		//+-----------------------
		dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "QRPV", .T., .F. )
		dbSelectArea("QRPV")
		
		TcSetField("QRPV","C6_QTDVEN"  ,"N",12,02)
		TcSetField("QRPV","C6_PRCVEN"  ,"N",12,02)
		
		
		
		
		DO WHILE !QRPV->(Eof())
			//VICTOR DESSUNTE - 25/01/2017
			//INICIO - TICKET: 2017012037000208
			aCabec	:= {}
			aItem		:= {}
			//FIM - TICKET: 2017012037000208
			If nPrecVen <> QRPV->C6_PRCVEN
				aadd(aCabec,{"C5_NUM",QRPV->C6_NUM,Nil})
				aItemPV:={	{"AUTDELETA"		,"N"			,Nil},;
				{"LINPOS","C6_ITEM"	,QRPV->C6_ITEM				,Nil},;	//Item do pedido
				{"C6_PRUNIT" 		,nPrecVen					,Nil},;	//Preço de Venda
				{"C6_PRCVEN" 		,nPrecVen					,Nil},;	//Preço de Venda
				{"C6_VALOR"  		,(nPrecVen*QRPV->C6_QTDVEN)	,Nil}}	//Valor total dos produtos
				
				aadd(aItem,aitempv)
				lMsErroAuto		:= .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItem,4)
				If lMsErroAuto   //Verifica se há erros no cadastro
					DisarmTransaction()
					MostraErro()
				Else
					IF (!Empty(Alltrim(QRPV->C6_PEDCLI)) .And. !Empty(Alltrim(QRPV->C6_MSITPEC)) );
						.OR. (!Empty(Alltrim(QRPV->C6_NUMPCOM)) .And. !Empty(Alltrim(QRPV->C6_ITEMPC)) )
						//Ivandro Santos - 19/09/17 - início da alteração - Ticket#2017082537000035 — Eliminado por resíduo
						_cQryC7 := "SELECT C7_IPI FROM SC7"+aDadosEmp[MS_GRUPO]+"0 C7"
						_cQryC7	+=  " WHERE C7_FILIAL='"+aDadosEmp[MS_FILIAL]+"' AND C7.D_E_L_E_T_='' "
						_cQryC7	+=  " AND ((C7_NUM = '"+ALLTRIM(QRPV->C6_PEDCLI)+"' AND C7_ITEM = '"+ALLTRIM(QRPV->C6_MSITPEC)+"') "
						_cQryC7	+=  " OR (C7_NUM = '"+ALLTRIM(QRPV->C6_NUMPCOM)+"' AND RIGHT(LTRIM(RTRIM(C7_ITEM)),2) = '"+ALLTRIM(QRPV->C6_ITEMPC)+"')) "
						If Select("QRPC") > 0
							dbSelectArea("QRPC")
							dbCloseArea()
						EndIf
		
						//-----------------------
						//| Cria uma view no banco
						//+-----------------------
						dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQryC7), "QRPC", .T., .F. )
						dbSelectArea("QRPC")
						
						_cPerIPI := QRPC->C7_IPI/100
						QRPC->(dbCloseArea())
						cQueryM	:= "UPDATE SC7"+aDadosEmp[MS_GRUPO]+"0 SET "
						cQueryM	+= " C7_PRECO 	=  "	+	Alltrim(Str(nPrecVen))	+	", "
						cQueryM	+= " C7_TOTAL 	= ("	+	Alltrim(Str(nPrecVen))	+	" * C7_QUANT ) , "
						cQueryM	+= " C7_BASEIPI	= ("	+	Alltrim(Str(nPrecVen))	+	" * C7_QUANT ) , "
						cQueryM	+= " C7_VALIPI 	= ("	+	Alltrim(Str(nPrecVen))	+	" * C7_QUANT * C7_IPI) "	
						cQueryM	+= "FROM SC7"+aDadosEmp[MS_GRUPO]+"0 C7 "
						cQueryM	+=  " WHERE C7_FILIAL='"+aDadosEmp[MS_FILIAL]+"' AND C7.D_E_L_E_T_<>'*' "
						cQueryM	+=  " AND ((C7_NUM = '"+ALLTRIM(QRPV->C6_PEDCLI)+"' AND C7_ITEM = '"+ALLTRIM(QRPV->C6_MSITPEC)+"') "
						cQueryM	+=  " OR (C7_NUM = '"+ALLTRIM(QRPV->C6_NUMPCOM)+"' AND RIGHT(LTRIM(RTRIM(C7_ITEM)),2) = '"+ALLTRIM(QRPV->C6_ITEMPC)+"')) "						
						TCSQLEXEC(cQuerYM)
					Endif
				Endif
			Endif
			QRPV->(dbSkip())
		Enddo
	Endif
Next _nEmG
//Ticket#2016080537000173 — Término da alteração


Return
