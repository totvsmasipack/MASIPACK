#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

/*/{Protheus.doc} M110STTS
//TODO Descrição Após criar a solicitação de compra, se for intercompany, 
se não estiver cadastrado na tabela 900(preço), manda email p/ custos.
@author Eduardo Bego Mantoan
@since 21/07/2015
@version 1.0
@return Nil

@type function
/*/

User Function M110STTS() 

	Local cNumSol	:= Paramixb[1]
	Local nOpt		:= Paramixb[2]  
	Local cQuery    := ""  
	Local cMSG      := ""
	Local cMSGT     := ""
	Local lOk       := .F.
	Local _aArea	:= GetArea()

	If nOpt <> 1 .AND. nOpt <> 2     // Somente na inclusão
		Return .T.	
	EndIf

	If SUBSTR(cNumEmp,1,2) <> "40"

		If Select("QR1") > 0
			DbSelectArea("QR1")
			DbCloseArea()
		EndIf    
		
		cQuery := " SELECT *   					"
		cQuery += " FROM " + RetSqlName("SC1") + " SC1  			"
		cQuery += " WHERE C1_FILIAL= '" + xFilial("SC1") + "' 	"
		cQuery += " AND SC1.D_E_L_E_T_=''	"
		cQuery += " AND C1_MSINTER = 'S' 	"
		cQuery += " AND C1_NUM = '"+cNumSol+"' 	"
		cQuery += " ORDER BY C1_NUM,C1_ITEM "
		
		TcQuery cQuery New Alias "QR1"
				
		dbSelectArea("QR1")
		dbGoTop("QR1")  
		
		Do While !QR1->(EOF()) 

		   DBSELECTAREA("DA1")
		   DBSETORDER(1)

		   If !(DBSEEK(xFilial("DA1")+"900"+QR1->C1_PRODUTO))
				lOk := .T.		
				cMSG     += "Produto (s) não possui cadastro na tabela 900 - Solicitação de Compra: "+cNumSol+ CRLF+ CRLF+ CRLF+ CRLF		 	
				cMSG     += +" - "+QR1->C1_PRODUTO + CRLF
		   EndIf
		   
			QR1->(DBSKIP())

		EndDo 
		
		If SUBSTR(cNumEmp,1,2) == "01"

			If Select("QR1") > 0
				DbSelectArea("QR1")
				DbCloseArea()
			EndIf    
			
			cQuery := " SELECT C1_PRODUTO, C1_ITEM, C1_DESCRI,	"
			cQuery += "       CASE WHEN
			cQuery += "       ZE_ESPMIN+ZE_ESPMAX+ZE_LARGMIN+ZE_LARGMAX+ZE_ALTMIN+ZE_ALTMAX+ZE_DIAMMIN+ZE_DIAMMAX+ZE_DIAEMIN+ZE_DIAEMAX+ZE_DIAIMIN+ZE_DIAIMAX+ZE_PAREMIN+ZE_PAREMAX+ZE_ALMAMIN+ZE_ALMAMAX+ZE_LADOMIN+ZE_LADOMAX > 0 "
			cQuery += "       THEN 'S' ELSE 'N' END 'TOLERANCIA', "
			cQuery += "       ISNULL(B1_MSCERT,'') 'CERTIFICADO', "
			cQuery += "       ISNULL(B1_MSATOX,'') 'CERT_ATOX', "
			cQuery += "       ISNULL(B1_MSCONF,'') 'CERT_CE' "
			cQuery += " FROM " + RetSqlName("SC1") + " SC1  			"
			cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC1.C1_PRODUTO AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_MSBLQL <> '1' "
			cQuery += " LEFT JOIN "+RetSqlName("SZE")+" SZE ON SZE.ZE_FILIAL = '"+xFilial("SZE")+"' AND SZE.ZE_CODIGO = SC1.C1_PRODUTO AND SZE.D_E_L_E_T_ = ' ' "
			cQuery += " WHERE C1_FILIAL= '" + xFilial("SC1") + "' 	"
			cQuery += " AND SC1.D_E_L_E_T_=''	"
			cQuery += " AND C1_NUM = '"+cNumSol+"' 	"
			cQuery += " AND SUBSTRING(C1_PRODUTO,1,2) = 'MP' "
			cQuery += " AND ZE_OBSERV NOT LIKE ('%NAO REQUER%') "
			cQuery += " ORDER BY C1_NUM,C1_ITEM "
			
			TcQuery cQuery New Alias "QR1"
					
			dbSelectArea("QR1")
			dbGoTop("QR1")  
			cMSG     := "Produto (s) não possui cadastro - Solicitação de Compra: "+cNumSol+ CRLF+ CRLF+ CRLF+ CRLF		 	

			Do While !QR1->(EOF()) 

			   If QR1->TOLERANCIA == "N"
			      lOk := .T.		
			   	  cMSGT    += +"Item:" +QR1->C1_ITEM+" Produto - "+QR1->C1_PRODUTO + " - Descrição: " +QR1->C1_DESCRI + " - Sem tolerância" + CRLF
			   EndIf

			   If Empty(QR1->CERTIFICADO) .OR. Empty(QR1->CERT_ATOX) .OR. Empty(QR1->CERT_CE)
			      lOk := .T.		
			   	  cMSGT    += +"Item:" +QR1->C1_ITEM+" Produto - "+QR1->C1_PRODUTO + " - Descrição: " +QR1->C1_DESCRI + " - Sem Certificado" + CRLF
			   EndIf

				QR1->(DBSKIP())

			EndDo 
			
			If lOK  
				_cDestino := Alltrim(GetMV("MS_GRUTOMP"))
				_cTitulo  := "Solicitação de compra "+cNumSol+", possui produtos sem tolerância e/ou Certificado "
				_cCCo     := ""
				oMail:= EnvMail():NEW(.F.)
				If oMail:ConnMail()
					oMail:SendMail(_cTitulo,_cDestino,_cCCo,,cMSG+cMSGT)
				EndIf
				oMail:DConnMail()
			EndIf

		Endif
		
	EndIf		

	Restarea(_aArea)

Return Nil
