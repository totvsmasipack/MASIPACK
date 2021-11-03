#Include "Rwmake.ch"
#include "shell.ch
#Include "Topconn.ch"          
#Define _CRLF CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³RFINA018  ³ Autor ³  Eduardo Bego Mantoan  ³ Data ³ 12/06/15³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Aviso de cobrança										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function RFINA018() 

	Local cTitulo := "Aviso de Cobrança"

	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf 
	
	_cQuery := " SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_SALDO, E1_VENCREA, A1_NOME, A1_ENDCOB,A1_END,A1_MUN,A1_EST,A1_CEP,SE1.R_E_C_N_O_ AS REG "
	_cQuery += "        A1_MUNC, A1_ESTC, A1_CEPC, A1_COD, A1_LOJA "
	_cQuery += " FROM "+RetSqlName("SE1")+" E1 "
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+ " A1 "
	_cQuery += "       ON A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1_EST <> 'EX' "
	_cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
	_cQuery += "       AND (E1_CLIENTE + E1_LOJA) BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += "		 AND E1_MSMAIL = 'false' 
	_cQuery += "       AND E1_VENCREA BETWEEN  '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += "       AND E1_PORTADO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  AND E1_SALDO > 0 " 
	_cQuery += "       AND E1_PORTADO NOT LIKE  '891' " 
	_cQuery += "       AND E1_PORTADO NOT LIKE  '997' "
	_cQuery += "       AND E1_PORTADO NOT LIKE  '889' "
	_cQuery += "       AND E1_NUM 	 NOT LIKE  'MBR%'"
	_cQuery += "       AND E1_NUM 	 NOT LIKE  'ADT%'"
	_cQuery += "       AND E1_PREFIXO NOT LIKE  'MBR%'"
	_cQuery += "       AND E1_PREFIXO NOT LIKE  'ADT%'"
	_cQuery += "       AND E1_PREFIXO NOT LIKE  'NCC%'"
	_cQuery += "       AND E1_PREFIXO NOT LIKE  'RA%'"
	_cQuery += "       AND E1_VEND1 BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery += "       AND E1.D_E_L_E_T_ = ' '  AND  A1.D_E_L_E_T_ = ' ' "
	_cQuery += "       Order By A1_COD "
	
	
	TcQuery _cQuery New Alias "QR1"
	
	TcSetField("QR1","E1_VENCREA","D",08,02)
	TcSetField("QR1","E1_SALDO","N",14,02) 
	
	QR1->(DBGoTop())   
	cCodCli:= QR1->A1_COD

	Do While !QR1->(EOF()) 

		cMail := ""
		cMail += "São Bernardo do Campo, "+STRZERO(DAY(dDataBase),2)+" de "+MesExtenso(dDataBase)+" de "+STRZERO(YEAR(dDataBase),4)+_CRLF
		cMail += "A " 																																					+_CRLF
		cMail += QR1->A1_COD+"/"+QR1->A1_LOJA+" - "+QR1->A1_NOME																							+_CRLF
		
		If ALLTRIM(QR1->A1_ENDCOB) == "" 
   		cMail += QR1->A1_END																																		+_CRLF      
			cMail += QR1->A1_MUN+" - "+QR1->A1_EST+" CEP: "+TRANSFORM(QR1->A1_CEP,"@R 99999-999")												+_CRLF
		Else
			cMail += QR1->A1_ENDCOB																															   	+_CRLF
			cMail += QR1->A1_MUNC+" - "+QR1->A1_ESTC+" CEP: "+TRANSFORM(QR1->A1_CEPC,"@R 99999-999")											+_CRLF
		EndIf
		
		nTot := 0 
		 
	  	Do	WHILE QR1->A1_COD == cCodCli
	  	
			cMail += QR1->E1_PREFIXO									   +_CRLF
			
			If QR1->E1_PARCELA == "  "
				cMail += QR1->E1_NUM										   +_CRLF		
			Else
				cMail += QR1->E1_NUM+"/"+QR1->E1_PARCELA				+_CRLF
			EndIf             
			
			cMail += TRANSFORM(QR1->E1_SALDO,"@E 999,999,999.99")	+_CRLF
			cMail += QR1->E1_VENCREA									   +_CRLF+_CRLF  
			cMail += "-------------------------------------------------"+_CRLF +_CRLF  
			nTot++
		   cCodCli:= QR1->A1_COD  
		   
		   DBSelectArea("SE1")
			SE1->(DBGOTO(QR1->REG))
			RecLock("SE1", .F.,)
				SE1->E1_MSMAIL := .T.
			SE1->(MsUnlock())  		   
			QR1->(DbSkip())  
			
    	EndDo  
     
		cCodCli:= QR1->A1_COD
		cDestina:= "eduardo.bego@masipack.com.br" 
		cPath   := ""
		// Dispara email para os clientes \\	
		oMail:= EnvMail():NEW(.F.)
		If oMail:ConnMail()
			oMail:SendMail(cTitulo,cDestina,cCco,,cMail)
		EndIf
		oMail:DConnMail()
	
	EndDo
		
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf 
    
Return
