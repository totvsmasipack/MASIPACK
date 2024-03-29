#Include "Rwmake.ch"
#Include "Topconn.ch" 
#Include "PROTHEUS.CH"
#Define _CRLF CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCOMA021  �Autor  �Eduardo Mantoan � Data �  28/05/15      ���
�������������������������������������������������������������������������͹��
���Desc.     �Manda e-mail para aprova��o de primeiro pre�o do produto    ���
���          �    							                              ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function RCOMA021(cReg)  

	Email(cReg)   

Return   

Static Function Email(cFor)   
	
	Local cTitulo   := "Primeiro pre�o de compra"
	Local cDestina  := "carlos.p@masipack.com.br;vagner.cm@masipack.com.br;contabil@masipack.com.br"
	Local cCco      := ""
	Local cMensagem := ""
	Local cPath     := ""
	Local cQuery 	 := ""        
	
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf
	
	cQuery := " SELECT C8_NUM,C8_PRODUTO,B1_DESC,C8_UM,C8_QUANT,C8_PRECO,C8_FORNECE,A2_NREDUZ,C8_EMISSAO,C8_NUMSC,C8_ITEMSC"
	cQuery += " FROM " + RetSqlName("SC8") + " SC8 "
	cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON C8_FORNECE = A2_COD AND SA2.D_E_L_E_T_='' AND A2_FILIAL = '" + xFilial("SA2") + "' " 
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON C8_PRODUTO = B1_COD AND B1_UPRC = 0 AND SB1.D_E_L_E_T_='' AND B1_FILIAL = '" + xFilial("SB1") + "' "                  
	cQuery += " WHERE SC8.R_E_C_N_O_= '"+STR(cFor)+"' "
	cQuery += " AND SC8.D_E_L_E_T_='' AND C8_FILIAL = '" + xFilial("SC8") + "' "
	cQuery += " ORDER BY C8_PRODUTO"
	
	TcQuery cQuery New Alias "QR1" 
 
	QR1->(dbGoTop()) 

	IF SUBSTR(cNumEmp,1,2) == "01" // Masipack
		_cDE		  := "pcmasipack.totvs@masipack.com.br"	
	ELSEIF SUBSTR(cNumEmp,1,2) $ "10_11" // Fabrima
		_cDE		  := "pcfabrima.totvs@masipack.com.br"	
	ENDIF
	
	If !QR1->(Eof())
		cMensagem += "Cota��o: "+ QR1->C8_NUM+" Emiss�o "+DTOC(STOD(QR1->C8_EMISSAO)) 			+_CRLF+_CRLF
		cMensagem += "Fornecedor: "+ QR1->C8_FORNECE+" - "+QR1->A2_NREDUZ   							+_CRLF+_CRLF
		cMensagem += "Solicita��o de Compra: "+ QR1->C8_NUMSC+" Item "+QR1->C8_ITEMSC       	+_CRLF+_CRLF
		cMensagem += "Produto: "+ QR1->C8_PRODUTO +" - "+QR1->B1_DESC       							+_CRLF+_CRLF 
		cMensagem += "Quantidade: "+ STR(QR1->C8_QUANT)+" Unidade de Medida "+QR1->C8_UM    	+_CRLF+_CRLF 
		cMensagem += "Pre�o cotado: R$"+ STR(QR1->C8_PRECO)  					  							+_CRLF+_CRLF
		oMail:= EnvMail():NEW(.F.)
		If oMail:ConnMail()
			MsgRun("Enviando e-mail para "+cDestina ,, { || oMail:SendMail(cTitulo,cDestina,cCco,,cMensagem) } )
		EndIf
		oMail:DConnMail()
	Else
		ALERT("Este produto j� possui ultimo pre�o de compra, n�o h� necessidade de encaminhar e-mail para avalia��o")
	EndIf

	
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf
	
Return

