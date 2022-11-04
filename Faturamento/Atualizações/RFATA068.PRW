#include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "MASI_EMP.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RFATA068  		³ Autor ³Ivandro Santos      ³Data ³13.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava Pedido de Intercompany									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³	Pedido de compra Fabrima ou Masipack					  	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Geração do Pedido de Venda e gravação no campo C7_MSPV do Pedido³±±
±±³          ³ de compra													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                      	
User Function RFATA068()
//Ivandro Santos - 26/05/17 - Início da alteração
//Ticket#2016080537000173 — Tarefa ID 120 - PC -> PV
Local aNomEmp    := {"",""}          
Local aEmpGru    := {"MASIPACK","FABRIMA","HELSIMPLAST"}          

Private  aDadosEmp 	:= {"","","",""}
Private aItensProd 	:= {}
Private _aItPed 	:= {}
Private _cEmpresa  	:=SM0->M0_CODIGO
Private cPerg      	:= "XFATA068"
Private _cPedcom   	:= ""
Private _dData		:= ""
Private _cTabIn 	:= Alltrim(GetMv("MS_CODTABI"))
Private nLastKey	:= 0
Private _lRet
	
_lRet := Pergunte(cPerg,.T.)

If nLastKey == 27 .Or. !_lRet
	Return
Else
	aNomEmp[1] := Alltrim(SM0->M0_NOME)
	aNomEmp[2] := Alltrim(aEmpGru[MV_PAR02])
	If aNomEmp[1] == aNomEmp[2]
		ApMsgAlert("Você selecionou a mesma empresa que está acessando. Selecione outra empresa")
		Return
	Endif	
Endif


aDadosEmp := U_MSACHAEM(aNomEmp,_cEmpresa)

If Substr(cNumEmp,1,2) == "15"
	//Query para verificar se o Pedido de Compra já Gerou PV
	cQry := " SELECT TOP (1) C1_NUM "
	cQry += " FROM "+RetSQLName("SC1")+" C1 "
	cQry += " WHERE SUBSTRING(C1_MSPV,1,6) = '"+MV_PAR01+"' AND C1.D_E_L_E_T_ = '' AND C1_FILIAL = '"+xFilial("SC1")+"' "
Else
	//Query para verificar se o Pedido de Compra já Gerou PV
	cQry := " SELECT TOP (1) C7_MSPV, C7_NUM "
	cQry += " FROM SC7"+aDadosEmp[MS_GRUPO]+"0 C7 "
	cQry += " INNER JOIN SB1"+aDadosEmp[MS_GRUPO]+"0 B1 ON B1_COD = C7_PRODUTO AND B1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' "
	cQry += " WHERE C7_NUM = '"+MV_PAR01+"' AND C7.D_E_L_E_T_ = '' AND C7_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' "
EndIf

If Select("QRPV") > 0
	dbSelectArea("QRPV")
	dbCloseArea()
EndIf              

//-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "QRPV", .T., .F. )
dbSelectArea("QRPV")      

If FWCodEmp() == "15"
	If Empty(Alltrim(QRPV->C1_NUM))
		MsgRun("Aguarde...Gravando Solicitações de Compra",, { || MSFT68SC() })
	Else
		Alert("Esse pedido de Venda já gerou a SC "+QRPV->C1_NUM)
	EndIf
Else
	If Empty(Alltrim(QRPV->C7_MSPV))
		MsgRun("Aguarde...Gravando Pedido de Venda",, { || U_MSFT68PV() })
	Else
		Alert("Esse pedido de compra já gerou o PV "+SUBSTR(QRPV->C7_MSPV,1,6))
	EndIf
EndIf
//Ticket#2016080537000173 — Término da alteração

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSFT68PV  ºAutor  ³Ivandro Santos      º Data ³  13/04/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a geração do Pedido de Venda baseado no Pedido de  º±±
±±º          ³ Compra Intercompany                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFATA068                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSFT68PV() 
Local aProd		 	:= Array(12)
Local aItensProd	:= {}
Local _aItensDiv	:= {}
Local cQuery	 	:= ""
Local _lRetorno  	:= .T.

Private _cUsuario 	:= RetCodUsr() 
Private _cDeptoUsu	:= ""
Private cMsgPro    	:= "Divergências Encontradas:"
Private cMsg		 	:= ""
Private _cDepImp  	:= ""
Private nMsgPro		:= Len(Alltrim(cMsgPro))
Private _aUsuario 	:= {}
Private _aGrupos  	:= {}
Private _lNovo			:= .T.

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12])) 
EndIf
IF SUBSTR(cNumEmp,1,2) $ "01"
	If _cDeptoUsu == "COMERCIAL" .OR. _cDeptoUsu == "VENDA DE PECAS"
			_cDepImp := "C"
	ElseIf _cDeptoUsu == "203-MAKLASER"
			_cDepImp := "P"
	EndIf
ELSEIF 	SUBSTR(cNumEmp,1,2) $ "10"
	//Ivandro Santos - 15/05/17 - Início da alteração
	//Ticket#2017051537000069 — PV Automático
	IF _cDeptoUsu == "COMERCIAL"	//_cDeptoUsu == "COMERCIAL" .OR. _cDeptoUsu == "VENDA DE PECAS"
		_cDepImp := "C"
	ElseIf _cDeptoUsu == "207-PCP" .OR. _cDeptoUsu == "VENDA DE PECAS"	//ElseIf _cDeptoUsu == "207-PCP"
	//Ticket#2017051537000069 — Fim da alteração
		_cDepImp := "P"
	EndIf
ENDIF

//Verifica as informação do pedido de compra
cQuery += " SELECT C7_ITEM, C7_PRODUTO, B1_DESC, B1_UM, B1_MSGRPMA, B1_MSGRVEN, B1_MSMAQUI, B1_POSIPI, C7_DATPRF, C7_QUANT, C7_NUM, ISNULL(DA1_PRCVEN,0.01) DA1_PRCVEN "
cQuery += " FROM SC7"+aDadosEmp[MS_GRUPO]+"0 C7 "
cQuery += " INNER JOIN SB1"+aDadosEmp[MS_GRUPO]+"0 B1 ON B1_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' AND B1_COD = C7_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1_FILIAL = '" + FWxFilial("DA1") + "' AND DA1_CODTAB = '"+_cTabIn+"' AND (DA1_CODPRO = B1_COD OR (DA1_CODPRO = B1_MSGRPMA AND RTRIM(LTRIM(B1_MSGRPMA)) <> '')) AND DA1.D_E_L_E_T_ = '' "
cQuery += " WHERE C7_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' AND C7_NUM = '"+MV_PAR01+"' AND ((C7_QUANT - C7_QUJE) > 0) AND C7.D_E_L_E_T_ = '' "
cQuery += " GROUP BY C7_ITEM, C7_PRODUTO, B1_DESC, B1_UM, B1_MSGRPMA, B1_MSGRVEN, B1_MSMAQUI, B1_POSIPI, C7_DATPRF, C7_QUANT, C7_NUM, DA1_PRCVEN "
cQuery += " ORDER BY C7_ITEM"

If Select("QRPC") > 0
	dbSelectArea("QRPC")
	dbCloseArea()
EndIf              

//-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRPC", .T., .F. )
dbSelectArea("QRPC")      

TcSetField("QRPC","C7_DATPRF" ,"D",08,00)
TcSetField("QRPC","C7_QUANT"  ,"N",12,02)
TcSetField("QRPC","DA1_PRCVEN"  ,"N",12,02)

If Select("QRPC") = 0    //Verifica se a query trouxe informação válida
	Alert("A Query não trouxe nenhum dado. Verifique se digitou o PC correto.")
	_lRetorno = .F.
Else   //Valida se os produtos estão criados na empresa que gerará o Pedido de Venda e se tem NCM
	_cPedcom := QRPC->C7_NUM
	_dData 	 := QRPC->C7_DATPRF
	While QRPC->(!Eof())
		
		//VICTOR DESSUNTE - 22/08/2016
		//INICIO TICKET - 2016080537000155
		If U_MSVALPRO(QRPC->C7_PRODUTO,@aProd,@cMsg,QRPC->C7_QUANT, QRPC->DA1_PRCVEN,QRPC->B1_MSGRVEN,QRPC->B1_MSMAQUI,QRPC->B1_DESC,"1P",QRPC->B1_POSIPI,_cDepImp)
			aadd(aItensProd,aProd)
			aProd := Array(12)
			IF !Empty(cMsg)
				cMsgPro += CHR(13)+CHR(10)+cMsg
				aAdd(_aItensDiv,cMsg)
				cMsg := ""
			EndIf
		Else
			cMsgPro += CHR(13)+CHR(10)+cMsg
			aAdd(_aItensDiv,cMsg)
			If !Empty(Alltrim(QRPC->B1_MSGRPMA)) .And. ;
				U_MSVALPRO(QRPC->B1_MSGRPMA,@aProd,@cMsg,QRPC->C7_QUANT, QRPC->DA1_PRCVEN,B1_MSGRVEN,QRPC->B1_MSMAQUI,QRPC->B1_DESC,"1P",QRPC->B1_POSIPI,_cDepImp)
				aadd(aItensProd,aProd)
				aProd := Array(12)
				IF !Empty(cMsg)
					cMsgPro += CHR(13)+CHR(10)+cMsg
					aAdd(_aItensDiv,cMsg)
					cMsg := ""
				EndIf
			Else 
				cMsgPro += CHR(13)+CHR(10)+cMsg
				aAdd(_aItensDiv,cMsg)
			EndIf
		EndIf
		//FIM TICKET - 2016080537000155
		
		aAdd(_aItPed,QRPC->C7_ITEM)
		QRPC->(DbSkip())
	EndDo
	If Len(Alltrim(cMsgPro)) > nMsgPro
		If apMsgYesNo("Gera Novo arquivo com os produtos divergentes?")
			_lNovo := .T.
			U_MSGeraTX(_aItensDiv)
		EndIf
		Alert(cMsgPro)
		_lRetorno = .F.
	Endif
Endif

If _lRetorno
	//Executa a gravação do Pedido
	FAT68GPV(aDadosEmp[MS_CNPJ],aItensProd)
Endif			

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FAT68GPV    		³ Autor ³Ivandro Santos      ³Data ³13.04.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera o Pedido de Venda 			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³	Codigo						    			               	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Codigo e Loja do Cliente								       	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FAT68GPV(_CNPJ,aItensProd)
Local _nCli, nT, nX, nI
Local _cTESINT  := IIF(_cDepImp=="C",Alltrim(GetMv("MS_TESIMAQ")),Alltrim(GetMv("MS_TESINT")))
Local cProd 	:= ""
Local _aInfoTes := {}
Local _aCondPag := {'V41'	,'V99'}
//Ivandro Santos - 25/08/17
//Ticket#2017082537000106 — NOTA FABRIMA P/ MASIPACK COM NATUREZA INCORRETA
Local _aNaturez := {IIF(Alltrim(_cEmpresa)='01','V02.1','V02.3') ,'V01'}     //Local _aNaturez := {'V02.1' ,'V01'}
//Ticket#2017082537000106 — Fim da alteração
Local _aDadoAdic:= {}
Local _cNumPVPro:= ""

// Valida cadastro de Cliente
//Ivandro Santos - 03/02/17
//Ticket#2017020337000042 — Emissao de NF para Fabrima com pedidos com 0,01
_aCli := {}
_aCli2:= U_MSCODCLI(aDadosEmp)
If Len(_aCli2) > 1
     For _nCli := 1 to len(_aCli2)
	     //Ivandro Santos - 07/02/17
	     //Ticket#2017020637000162 — ERRO AO GERAR PV AUTOMÁTICO
	     //If ApMsgYesNO("Deseja abrir o Pedido para a Fabrima - Código "+_aCli2[_nCli][1]+" ?")
	     If ApMsgYesNO("Deseja abrir o Pedido para a Fabrima - Código "+Substr(_aCli2[_nCli],1,6)+" ?")
	        //aadd(_aCli,{_aCli2[_nCli][1],_aCli2[_nCli][2]})
	        aadd(_aCli,_aCli2[_nCli])
	     //Ticket#2017020637000162 — Fim da alteração
	        Exit
	     Endif
     Next _nCli
Else
	aadd(_aCli,_aCli2[1])
Endif

DbSelectArea("SC5")
DbSetOrder(1)
_cNumPVPro	:= GetSX8Num("SC5","C5_NUM")
RollBAckSx8()
//Ticket#2017020337000042 — Fim da alteração
aItem	:= {}
aItemPv	:= {}
_aTESINT := StrToKarr(_cTESINT,"/")
For nT := 1 to len(_aTESINT)
	_aTES := GetAdvFval("SF4",{"F4_CODIGO","F4_ICM","F4_IPI","F4_CF","F4_SITTRIB"},xFilial("SF4")+_aTESINT[nT],1," ")
	aAdd(_aInfoTes,_aTES)
Next
For nI := 1 to len (aItensProd)
	_aFisProd := GetAdvFval("SYD",{"YD_PER_IPI","YD_ICMS_RE","YD_BICMS"},xFilial("SYD")+aItensProd[nI][4],1," ")
	aadd(_aDadoAdic,"PA")  //	B1_TIPO
	aadd(_aDadoAdic,"207") //   B1_CC
	aadd(_aDadoAdic,"")    //	B1_PROCED
	aadd(_aDadoAdic,"N")    //	B1_MSCONF
	aadd(_aDadoAdic,"2")   //	B1_GARANT
	aadd(_aDadoAdic,"")   //	B1_GRUPO
	If _cDepImp = "C"
		If Substr(cNumEmp,1,2) == "01"
			cProd :=  U_MSGeraB1("MQ"+_cNumPVPro+"-"+Strzero(nI,2,0),aItensProd[nI],_aFisProd,_aDadoAdic)
		Else
			cProd :=  U_MSGeraB1("FMA"+_cNumPVPro+"-"+Strzero(nI,4,0),aItensProd[nI],_aFisProd,_aDadoAdic)
		Endif
		//Ticket#2016080537000173 — Tarefa ID 120 - PC -> PV
		//Verifica se o programa MSGeraB1 com Execauto gerou o produto. Há o chamado na Totvs para resolver o problema
		_cTestIncPro := Alltrim(GetAdvFVal("SB1","B1_COD",xFilial("SB1")+cProd,1," "))
       	If Empty(_cTestIncPro)
       		MSFORSB1(cProd,aItensProd[nI],_aFisProd,_aDadoAdic)
       	Endif
		
		aItensProd[nI][1] := cProd
	Endif
	_Ctes := ""
	//_aTipo	  := GetAdvFval("SB1",{"B1_GRTRIB","B1_PROCED","B1_POSIPI"},xFilial("SB1")+aItensProd[nI][1],1," ")
	For nX :=1 to len(_aInfoTes)
		//Filtro: Produto Procedência Fabricado, CFOP 5101, IPI = 0, TES Não Calcula IPI, Produto sem Grupo Tributário 
		//e Situação tritutária = 00
		If SUBSTR(aItensProd[nI][10],1,1)=="1".And.Alltrim(_aInfoTes[nX][4])=="5101".And._aFisProd[1]==0.And._aInfoTes[nX][3]=='N';
			.And.Alltrim(aItensProd[nI][9])==''.And._aInfoTes[nX][5]=='00'
			_cTes:=_aInfoTes[nX][1]
		//Filtro: Produto Procedência Fabricado, CFOP 5101, IPI > 0, TES Calcula IPI, Produto sem Grupo Tributário 
		//e Situação tritutária = 00
		ElseIf SUBSTR(aItensProd[nI][10],1,1)=="1".And.Alltrim(_aInfoTes[nX][4])=="5101".And._aFisProd[1]>0.And._aInfoTes[nX][3]=='S';
			.And.Alltrim(aItensProd[nI][9])==''.And._aInfoTes[nX][5]=='00'
			_cTes:=_aInfoTes[nX][1]
		//Filtro: Produto Procedência Fabricado, CFOP 5101, IPI = 0, TES Não Calcula IPI, Produto com Grupo Tributário 
		//e Situação tritutária = 20
		Elseif SUBSTR(aItensProd[nI][10],1,1)=="1".And.Alltrim(_aInfoTes[nX][4])=="5101".And._aFisProd[1]==0.And._aInfoTes[nX][3]=='N';
			.And.Alltrim(aItensProd[nI][9])<>''.And._aInfoTes[nX][5]=='20'
			_cTes:=_aInfoTes[nX][1]
		//Filtro: Produto Procedência comprado, CFOP 5102, IPI > 0, TES Calcula IPI, Produto sem Grupo Tributário 
		//e Situação tritutária = 00
		Elseif SUBSTR(aItensProd[nI][10],1,1)=="2".And.Alltrim(_aInfoTes[nX][4])=="5102".And._aFisProd[1]>0.And._aInfoTes[nX][3]=='S';
			.And.Alltrim(aItensProd[nI][9])==''.And._aInfoTes[nX][5]=='00'
			_cTes:=_aInfoTes[nX][1]
		//Filtro: Produto Procedência Comprado, CFOP 5102, IPI > 0, TES Calcula IPI, Produto com Grupo Tributário 
		//e Situação tritutária = 20
		Elseif SUBSTR(aItensProd[nI][10],1,1)=="2".And.Alltrim(_aInfoTes[nX][4])=="5102".And._aFisProd[1]>0.And._aInfoTes[nX][3]=='S';
			.And.Alltrim(aItensProd[nI][9])<>''.And._aInfoTes[nX][5]=='20'
			_cTes:=_aInfoTes[nX][1]
		//Filtro: Produto Procedência Comprado, CFOP 5102, IPI = 0, TES Não Calcula IPI, Produto com Grupo Tributário 
		//e Situação tritutária = 20
		Elseif SUBSTR(aItensProd[nI][10],1,1)=="2".And.Alltrim(_aInfoTes[nX][4])=="5102".And._aFisProd[1]==0.And._aInfoTes[nX][3]=='N';
			.And.Alltrim(aItensProd[nI][9])<>''.And._aInfoTes[nX][5]=='20'
			_cTes:=_aInfoTes[nX][1]
		//Ivandro Santos - 17/03/17
		//Ticket#2017031737000032 — Emissão de Pedido de Venda
		//Filtro: Produto Procedência Comprado, CFOP 5102, IPI = 0, TES Não Calcula IPI, Produto sem Grupo Tributário 
		//e Situação tritutária = 00
		Elseif SUBSTR(aItensProd[nI][10],1,1)=="2".And.Alltrim(_aInfoTes[nX][4])=="5102".And._aFisProd[1]==0.And._aInfoTes[nX][3]=='N';
			.And.Alltrim(aItensProd[nI][9])==''.And._aInfoTes[nX][5]=='00'
			_cTes:=_aInfoTes[nX][1]
		//Ticket#2017031737000032 — Fim da alteração
		Endif
	Next
	
	// Atualização da Matriz dos Itens de Pedidos de vendas..
	aItemPV :={	{"C6_ITEM"   	,Strzero(nI,2,0)															,Nil},;	//Item do pedido
				{"C6_FILIAL"	,FWxFilial("SC6")															,Nil},;	//Filial da empresa
				{"C6_PRODUTO"	,Alltrim(aItensProd[nI][1])													,Nil},;	//Produto
				{"C6_UM" 		,Alltrim(aItensProd[nI][2])													,Nil},;	//Unidade de medida
				{"C6_QTDVEN" 	,aItensProd[nI][6]															,Nil},;	//Quantidade Vendida
				{"C6_PRUNIT" 	,aItensProd[nI][8]															,Nil},;	//Preço Unitário
				{"C6_PRCVEN" 	,aItensProd[nI][8]															,Nil},;	//Preço de Venda
				{"C6_VALOR"  	,(aItensProd[nI][6]) * aItensProd[nI][8]									,Nil},;	//Valor total dos produtos
				{"C6_TES"   	,_cTes																		,Nil},;	//TES
				{"C6_LOCAL"   	,"01"																		,Nil},;	//Local
				{"C6_PEDCLI"	,_cPedcom																	,Nil},;	//Pedido do Cliente
				{"C6_MSITPEC"	,_aItPed[nI]																,Nil},;	//Item do Pedido do Cliente
				{"C6_DTSUGER"	,IIf(_dData-dDatabase>30,DataValida(_dData-30),DataValida(dDatabase+15))	,Nil},;	//Entrega Prevista
				{"C6_ENTREG" 	,IIf(_dData-dDatabase>30,DataValida(_dData-30),DataValida(dDatabase+15))	,Nil}}	//Entrega Prevista

	aadd(aItem,aitempv)
Next

// Atualização do Array dos cabeçalhos dos pedido de venda dos Produtos
aCabPV	:= {}
aCabPV:={{"C5_NUM"    ,_cNumPVPro									  	,Nil},; // Numero do pedido
		{"C5_FILIAL"  ,XFILIAL("SC5")								  	,Nil},; // Filial da empres
		{"C5_TIPO"    ,"N"											  	,Nil},; // Tipo de pedido
		{"C5_CLIENTE" , Substr(_aCli[1],1,6)	  						,Nil},; // Codigo do cliente
		{"C5_LOJACLI" , Substr(_aCli[1],7,2)	 						,Nil},; // Loja do cliente
		{"C5_TRANSP"  ,"001" 										  	,Nil},; // Transportadora
		{"C5_PC"	  ,_cPedcom 										,Nil},; // Pedido de Compra
		{"C5_TIPOCLI" ,"R" 											  	,Nil},; // Tipo do Cliente
		{"C5_COTACAO" ,IIF(_cDepImp=="P","TERCEIROS","")		  		,Nil},; // Cotação
		{"C5_VEND1"   ,"000001" 									  	,Nil},; // Vendedor
		{"C5_TPFRETE" ,"F" 											  	,Nil},; // tipo do frete
		{"C5_PBRUTO"  ,1 											  	,Nil},; // Peso Bruto
		{"C5_PESOL"   ,1 												,Nil},; // Peso líquido
		{"C5_VOLUME1" ,1 												,Nil},; // Volumes
		{"C5_ESPECI1","CAIXA" 										  	,Nil},; // Espécie do Volume
		{"C5_EMISSAO" ,dDatabase 										,Nil},; // Data da Emissão do Pedido de Venda
		{"C5_NATUREZ" ,IIF(_cDepImp=="P",_aNaturez[1],_aNaturez[2])		,Nil},; // Natureza do pedido de Venda
		{"C5_CONDPAG" ,IIF(_cDepImp=="P",_aCondPag[1],_aCondPag[2])		,Nil},; // Condição de pagamento
		{"C5_OBS"	  ,"PC "+_cPedcom 									,Nil},; // Observação da Nota
		{"C5_TABELA"  ,_cTabIn											,Nil},; // Tabela de Preço
		{"C5_ENTREGA" ,IIf(_dData-dDatabase>30,DataValida(_dData-30),DataValida(dDatabase+15))	,Nil},; // Data da Entrega
		{"C5_MSDTENT" ,IIf(_dData-dDatabase>30,DataValida(_dData-30),DataValida(dDatabase+15))	,Nil},; // Data da Entrega
		{"C5_MSTPVEN" ,IIF(_cDepImp=="P","TE","OU")						,Nil},; // Tipo de Venda
 		{"C5_MSENG"	  ,"N"												,Nil},; // Engenharia
		{"C5_MSCONT"  ,"PC"+_cPedcom									,Nil},; // Num.Contrato
		{"C5_MSMULTA" ,"N"												,Nil},; // Multa
		{"C5_MSNORMA"   ,"NA"												,Nil}}  // Norma
//Verifica se cabeçalho e itens estão preenchidos
If len(aCabPv)>0 .and. Len(aItem)>0
	lMSErroAuto	:= .F.
	lMSHelpAuto	:= .F.
	//Executa o cadastro do Pedido de Venda
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,3)
	If lMsErroAuto   //Verifica se há erros no cadastro
		DisarmTransaction()
		MostraErro()
		//Excluir o produto MQ criado devido ao erro no pedido
		If _cDepImp = "C"
			lMSErroAuto	:= .F.
			lMSHelpAuto	:= .F.
			aCab:= { 	{"B5_COD"  ,cProd,Nil}}	// Codigo identificador do produto
			MSExecAuto({|x,y| Mata180(x,y)},aCab,5) //Exclusao
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
			Endif
			lMSErroAuto	:= .F.
			lMSHelpAuto	:= .F.
			aVetor := {{"B1_COD",cProd,NIL}}
			MSExecAuto({|x,y| Mata010(x,y)},aVetor,5)
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
			Endif			
		Endif
		Return
	Else  //Confirma o cadastro
		ConfirmSX8()                                                         
		//Executa a gravação dos dados do Pedido de Venda no Pedido de Compras
		For nI := 1 to len (aItensProd)
			cQueryM	:= "UPDATE SC7"+aDadosEmp[MS_GRUPO]+"0 SET C7_MSPV = '"+_cNumPVPro+strzero(nI,2,0)+"' FROM SC7"+aDadosEmp[MS_GRUPO]+"0 C7 "
			cQueryM	+=  " WHERE C7_FILIAL='"+aDadosEmp[MS_FILIAL]+"' AND C7.D_E_L_E_T_<>'*' "
			cQueryM	+=  " AND C7_NUM = '"+_cPedcom+"' AND C7_ITEM = '"+_aItPed[nI]+"' "
			TCSQLEXEC(cQuerYM)
		Next
		alert("Gerou Pedido de Venda "+_cNumPVPro)
		//Abre a Tela do Pedido de Venda
		MATA410()
	EndIf
EndiF
Return


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³@ Ivandro Santos                                                       ³
//³Função: MSGERATXT                                                      ³
//³Função que cria um arquivo com informações dos produtos com divergência³
//³Uso: RFATA068                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

User Function MSGeraTX(_aItens)
Local cCaminho := "C:\Relato_Microsiga\Produto_Com_Problema.csv"
Local cNomTrb	:= ""
Local cEol		:= CHR(13)+CHR(10)
Local cLinha    := ""       
Local ni


If _lNovo
	//Exclui arquivo criado anteriormente
	fErase(cCaminho)
	cNomTrb := FCreate(cCaminho,0)
	fWrite(cNomTrb,Substr(cMsgPro,1,nMsgPro))
Else

	IF (nHandle := FOPEN(cCaminho)) >= 0
    // Posiciona no fim do arquivo, retornando o tamanho do mesmo
    nLength := FSEEK(nHandle, 0, FS_END)
    // Posiciona no início do arquivo
    FSEEK(nHandle, 0)
    FRead( nHandle, cString, nLength )
    // Fecha arquivo
    FCLOSE(nHandle)
  ENDIF
	fErase(cCaminho)
	cNomTrb := FCreate(cCaminho,0)
	fWrite(cNomTrb,cString)
Endif

For nI := 1 to len(_aItens)

	cLinha := _aItens[nI]
	
	fWrite(cNomTrb,cEol+cLinha)
	                       		
Next

fClose(cNomTrb)
Return


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL¿
//³@ Ivandro Santos - 26/05/17                                     ³
//³Função MSFT68SC                                                 ³
//³Função criada para gerar as Solicitações de compra intercompany.³
//³Usuário fará a parametrização com o número do Pedido de venda   ³
//³e informará o forncedor intercompany                            ³
//³USO: RFATA068                                                   ³
//³Ticket#2016080537000173 — Tarefa ID 120 - PC -> PV              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLÙ
*/

Static Function MSFT68SC()

Local _aDadoAdic	:= {}
Local _aMsg	  		:= {"Solicitacao de Compra Gerada. Numero SC :"}
Local _cMsgSC 		:= ""
Local _nSC 	  		:= 0
Local _lOK	  		:= .F.
Local aProd	  		:= {"","","","","","","","","","","",""}
Local nSC

Private aLinha  := {}
Private aItens  := {}
Private _aNumSC	:= {}
Private _nQtSC	:= 0
Private lMsErroAuto := .F.

cQuery := "SELECT C6_PRODUTO,C6_QTDVEN,B1_DESC,B1_POSIPI,B1_UM,B1_MSGRPMA,C5_MSDTENT,B1_TS,C6_PRCVEN,B1_GRTRIB,B1_PROCED,B1_MSGRVEN,B1_GRUPO, "
cQuery += "ISNULL(B5_CEME,'') 'B5_CEME',C6_NUM+C6_ITEM 'MSPV' "
cQuery += "FROM SC6"+aDadosEmp[MS_GRUPO]+"0 C6 "
cQuery += "INNER JOIN SC5"+aDadosEmp[MS_GRUPO]+"0 C5 ON C5.C5_NUM = C6.C6_NUM "
cQuery += "INNER JOIN SB1"+aDadosEmp[MS_GRUPO]+"0 B1 ON B1.B1_COD = C6_PRODUTO "
cQuery += "LEFT  JOIN SB5"+aDadosEmp[MS_GRUPO]+"0 B5 ON B5.B5_COD = C6_PRODUTO 
cQuery += " AND B5.D_E_L_E_T_ = '' "
cQuery += " AND B5.B5_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' "
cQuery += "WHERE C6_NUM = '"+MV_PAR01+"' "
cQuery += "	AND C6.D_E_L_E_T_ = '' "
cQuery += "	AND B1.D_E_L_E_T_ = '' "
cQuery += "	AND C5.D_E_L_E_T_ = '' "
cQuery += "	AND C6.C6_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' "
cQuery += "	AND C5.C5_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' "
cQuery += "	AND B1.B1_FILIAL = '"+aDadosEmp[MS_FILIAL]+"' "
cQuery += "	ORDER BY C6_ITEM "

If Select("QRPC") > 0
	dbSelectArea("QRPC")
	dbCloseArea()
EndIf              

//-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRPC", .T., .F. )
dbSelectArea("QRPC")

While !(QRPC->(EOF()))
	
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	DbGotop()
	IF SB1->(dbSeek(xFilial("SB1")+"FE"+QRPC->C6_PRODUTO))
		_lOK := .T.
		cProd := "FE"+QRPC->C6_PRODUTO
	Elseif SB1->(dbSeek(xFilial("SB1")+QRPC->C6_PRODUTO))
		cProd := QRPC->C6_PRODUTO
		_lOK := .T.
	Else
		//aaDD(aProd,{CODIGOPROD,B1_UM,SB1->B1_MSGRPMA,_nNCM,_dData,SB1->B1_TS,_nPreco,SB1->B1_GRTRIB,SB1->B1_PROCED,_cGrVen,_Desc})
		aProd[01] := QRPC->C6_PRODUTO
		aProd[02] := Alltrim(QRPC->B1_UM)
		aProd[03] := QRPC->B1_MSGRPMA
		aProd[04] := QRPC->B1_POSIPI
		aProd[05] := QRPC->C5_MSDTENT
		aProd[06] := QRPC->C6_QTDVEN
		aProd[07] := QRPC->B1_TS
		aProd[08] := QRPC->C6_PRCVEN
		aProd[09] := QRPC->B1_GRTRIB
		aProd[10] := "2N"
		aProd[11] := QRPC->B1_MSGRVEN
		aProd[12] := QRPC->B1_DESC
		
		_aFisProd := GetAdvFval("SYD",{"YD_PER_IPI","YD_ICMS_RE","YD_BICMS"},xFilial("SYD")+QRPC->B1_POSIPI,1,{0,0," "})
		aadd(_aDadoAdic,"PA")  				//B1_TIPO
		aadd(_aDadoAdic,"122207") 			//B1_CC
		aadd(_aDadoAdic,"2N")    			//B1_PROCED
		aadd(_aDadoAdic,"")    				//B1_MSCONF
		aadd(_aDadoAdic,"2")   				//B1_GARANT
		aadd(_aDadoAdic,QRPC->B1_GRUPO)		//B1_GRUPO
		
		cProd :=  U_MSGeraB1("FE"+QRPC->C6_PRODUTO,aProd,_aFisProd,_aDadoAdic) 
       	//Testar a inclusão do produto
       	_cTestIncPro := Alltrim(GetAdvFVal("SB1","B1_COD",xFilial("SB1")+IIF(!Empty(cProd),cProd,"FE"+QRPC->C6_PRODUTO),1," "))
       	If Empty(_cTestIncPro)
       		MSFORSB1(cProd,aProd,_aFisProd,_aDadoAdic,QRPC->B5_CEME)
       		_lOK := .T.
		Else
       		_lOK := .T.
       	Endif
	ENDIF
	
	If _lOK
		_nSC++
		aadd(aLinha,{"C1_ITEM"   ,StrZero(_nSC,TamSX3("C1_ITEM")[1]),Nil})
		aadd(aLinha,{"C1_PRODUTO",cProd								,Nil})
		aadd(aLinha,{"C1_QUANT"  ,QRPC->C6_QTDVEN  					,Nil})
		aadd(aLinha,{"C1_MSINTER","S"								,Nil})
		aadd(aLinha,{"C1_MSPV",QRPC->MSPV							,Nil})
		aadd(aLinha,{"C1_DATPRF" ,DataValida(STOD(QRPC->C5_MSDTENT)),Nil})
		aadd(aItens,aLinha)
		_lOK := .F.
		aLinha := {}
	ENDIF
	SB1->(DbCloseArea())
	QRPC->(DbSkip())
EndDo

If Len(aItens) > 0
	_cNumSC	:= GetSX8Num("SC1","C1_NUM")
	MsAguarde({|| U_MSSolCom(_cNumSC,aItens) }, OemToAnsi("Gerando Solicitação de compra: "+_cNumSC) )	
	For nSC := 1 to len(_aNumSC)
		_cMsgSC += IIF(nSC>1," | "+_aNumSC[nSC],_aNumSC[nSC])
	Next
Endif

MSGINFO(IIF(_nQtSC==0,"Não gerou SC",_aMsg[1]+chr(10)+chr(13)+_cMsgSC+chr(10)+chr(13)))


Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSFORSB1  ºAutor  ³Ivandro Santos      º Data ³  26/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Devido a divergência de cadastro com uso do Execauto foi   º±±
±±º          ³ criado essa rotina para garantir o cadastro do produto     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFATA068                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Ticket#2016080537000173 — Tarefa ID 120 - PC -> PV
Static Function MSFORSB1(cProd,_aProd,_aFisProd,_aDadoAdic,_cNomeCien)
Default _cNomeCien := ""
Begin Transaction
Reclock("SB1",.T.)
B1_FILIAL	:= xFilial("SB1")
B1_CONTRAT	:= "N"
B1_LOCALIZ	:= "N"
B1_PROCED	:= _aProd[10]
B1_MSGRVEN	:= _aProd[11]
B1_COD		:= cprod
B1_DESC		:= _aProd[12]
B1_TIPO		:= _aDadoAdic[1]
B1_UM		:= _aProd[02]
IF _aFisProd[3]=="S"
	If _aFisProd[2] < 18
		SB1->B1_GRTRIB := "001"
	Else
		SB1->B1_GRTRIB := "002"
	EndIf
Endif
B1_CC		:= _aDadoAdic[2]
If SubStr(cNumEmp,1,2) == "01"
	B1_LOCPAD	:= IIF(SUBSTR(_aProd[10],2,1)=="N","10","01")
Else
	B1_LOCPAD	:= "01"
EndIf
B1_ORIGEM	:= "0"
B1_MSATOX	:= "N"
B1_GARANT	:= _aDadoAdic[5]
B1_GRUPO	:= _aDadoAdic[6]
B1_REVATU	:= "001"
B1_POSIPI	:= _aProd[04]
B1_PICM		:= _aFisProd[2]
B1_IPI		:= _aFisProd[1]
B1_UPRC		:= 1
SB1->(MsUnLock())
End Transaction
Begin Transaction
DbSelectArea("SB5")
DbSetOrder(1)
If !DbSeek(xFilial("SB5")+cProd)
	Reclock("SB5",.T.)
	B5_FILIAL	:= xFilial("SB5")
	B5_COD := cProd
	B5_CEME:= IIF(!Empty(Alltrim(_cNomeCien)),_cNomeCien,_aProd[12])
	SB5->(MsUnLock())
Endif
End Transaction
SB5->(DbCloseArea())
Return
