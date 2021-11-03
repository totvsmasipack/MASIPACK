#include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "MASI_EMP.CH"

/*/{Protheus.doc} RFATA071
//TODO Descrição auto-gerada.
@author ivandro.santos
@since 05/06/2018
@version 1.0
@return _lRet, lógica, valida se o pedido intercompany pode ser liberado para faturamento
@param _cNumPed, caracter, descricao: número do pedido de venda a ser liberado
@type function
/*/
User Function RFATA071(_cNumPed,aDadosEmp)
Local _cMsg		:= ""
Local nITPed	:= 0
Local cQuery	:= ""
Local cQuerYM	:= ""
Local _aMsg		:= {"O Produto abaixo tem divergência","Os Produtos abaixo têm divergências","não tem Preço de Tabela", "o Preço está diferente","SEM amarração com Pedido de Compra"}
Local _cTabIn	:= Alltrim(GetMv("MS_CODTABI"))
Local _lRet		:= .T.
Local _nQtdLib	:= IIF(!IsInCallStack("A440PROCES"),Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDLIB" }),0)
Local _nItPV	:= IIF(!IsInCallStack("A440PROCES"),Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM" }),0)
Local _nItSel	:= 0
Local _nPVI		:= 0

	If !(cEmpAnt == "15") .And. !IntCompany()

		cQuery += " SELECT C6_PRODUTO, ISNULL(DA1_PRCVEN,0) DA1_PRCVEN, C6_PRCVEN,C6_NUMPCOM,C6_ITEMPC,C6_PEDCLI,C6_MSITPEC,C6_QTDVEN "+CRLF
		cQuery += " FROM " + RetSqlName("SC6") + " C6 "+CRLF
		cQuery += " LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1_CODPRO = C6_PRODUTO AND DA1.D_E_L_E_T_ = '' AND DA1_FILIAL = '" + xFilial("DA1") + "' "+CRLF
		cQuery += " 	AND DA1_CODTAB = '"+_cTabIn+"' "+CRLF
		cQuery += " WHERE C6_NUM = '"+_cNumPed+"' AND C6_QTDVEN-C6_QTDENT>0 AND C6.D_E_L_E_T_ = '' AND C6_FILIAL = '"+XFILIAL("SC6")+"' "+CRLF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se é liberação automática ou manual, ³
		//³pois o aCols só é carregado na função Manual  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !IsInCallStack("A440PROCES")
			cQuery += " AND C6_ITEM IN ( "
			For _nPVI := 1 to len(aCols)
				If aCols[_nPVI,_nQtdLib] > 0
					_nItSel++
					If _nItSel == 1
						cQuery += "'"+aCols[_nPVI,_nItPV]+"' "
					Else
						cQuery += ",'"+aCols[_nPVI,_nItPV]+"' "
					Endif
				Endif
			Next
			cQuery += ") "
		Endif

		If Select("QRPV") > 0
			dbSelectArea("QRPV")
			dbCloseArea()
		EndIf              

		//-----------------------
		//| Cria uma view no banco
		//+-----------------------
		MPSysOpenQuery(cQuery,"QRPV")

		TcSetField("QRPV","DA1_PRCVEN"  ,"N",12,02)

		While QRPV->(!Eof())
			If QRPV->DA1_PRCVEN == 0
				_lRet := .F.
				_cMsg += CRLF+PADR(Alltrim(QRPV->C6_PRODUTO),15)+" - "+_aMsg[3]
				nITPed++	
			Elseif QRPV->DA1_PRCVEN <> QRPV->C6_PRCVEN
				_lRet := .F.
				_cMsg += CRLF+PADR(Alltrim(QRPV->C6_PRODUTO),15)+" - "+_aMsg[4]
				nITPed++	
			EndIf
			If (Empty(QRPV->C6_NUMPCOM) .And. Empty(QRPV->C6_PEDCLI))
				_cMsg += CRLF+PADR(Alltrim(QRPV->C6_PRODUTO),15)+" - "+_aMsg[5]
				_lRet := .F.
				nITPed++
			EndIf
			If _lRet .And. (!Empty(QRPV->C6_NUMPCOM) .OR. !Empty(QRPV->C6_PEDCLI))
				cQueryM	:= "UPDATE SC7"+aDadosEmp[MS_GRUPO]+"0 SET "
				cQueryM	+= "C7_PRECO 	=  "	+	Alltrim(Str(QRPV->DA1_PRCVEN))	+ ", "
				cQueryM	+= "C7_TOTAL 	= ("	+	Alltrim(Str(QRPV->DA1_PRCVEN))	+ " * C7_QUANT ) ,"
				cQueryM	+= "C7_BASEIPI 	= ("	+	Alltrim(Str(QRPV->DA1_PRCVEN))	+ " * C7_QUANT ) ,"
				cQueryM	+= "C7_VALIPI 	= ("	+	Alltrim(Str(QRPV->DA1_PRCVEN))	+ " * C7_QUANT * C7_IPI ) "
				cQueryM	+= "FROM SC7"+aDadosEmp[MS_GRUPO]+"0 C7 "
				cQueryM	+=  " WHERE C7_FILIAL='"+aDadosEmp[MS_FILIAL]+"' AND C7.D_E_L_E_T_<>'*' "
				cQueryM	+=  " AND ((C7_NUM = '"+QRPV->C6_PEDCLI+"' AND C7_ITEM = '"+QRPV->C6_MSITPEC+"') "
				cQueryM	+=  " OR (C7_NUM = '"+QRPV->C6_NUMPCOM+"' AND C7_ITEM = '"+PADL(ALLTRIM(QRPV->C6_ITEMPC),4,'0')+"')) "
				TCSQLEXEC(cQuerYM)
			Endif
		QRPV->(dBSkip())
		EndDo
		If !Empty(_cMsg)
			Alert(IIF(nITPed>1,_aMsg[2]+_cMsg,_aMsg[1]+_cMsg))
		Endif

	Endif
	
Return _lRet


Static Function IntCompany()

Local _aArea	:= { SA1->(GetArea()) }
Local _aFilial	:= FwLoadSM0()
Local _lRet		:= .F.
Local _nX		:= 0

	dbSelectArea('SA1')
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek( FWxFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI ) ))

		For _nX := 1 To Len(_aFilial)
			If Alltrim(_aFilial[_nX,18]) == Alltrim(SA1->A1_CGC)
				_lRet := .T.
				Exit
			Endif
		Next _nX

	Endif
	
	AEval(_aArea,{|x| RestArea(x) })

Return _lRet
