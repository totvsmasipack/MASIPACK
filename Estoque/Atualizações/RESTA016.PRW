#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RESTA016  ºAutor  ³Aparecida F.Stevanato º Data ³  14/09/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza se Produto foi separado para Faturamento           º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
- ESPECIFICO PARA FABRIMA 
*/
                                                                                                              
User Function RESTA016()

Private fRet := .T. 

aOpcao   := {"Separado no Estoque","Retornar P/Estoque"}
cOpcao   := Space(20)
cPedido  := Space(6)
cItem    := Space(2)
DEFINE MSDIALOG _oDlg1 FROM  090,1 TO 330,330 TITLE "Atualiza Itens Separados" PIXEL  
@ 010,030 Say "Esta rotina Atualiza Itens Separados no Estoque"      Size 151,010 OF _oDlg1 PIXEL
@ 020,000 Say Replicate("_",100)                                     Size 200,010 PIXEL COLOR CLR_HBLUE	
@ 040,024 Say "Opção........................... : "                  Size 065,006 PIXEL COLOR CLR_HBLUE	
@ 055,024 Say "Pedido de Vendas : " 				    	         Size 055,006 PIXEL COLOR CLR_HBLUE	
//@ 070,024 Say "Item (ZZ p/Todos) : " 	                             Size 055,006 PIXEL COLOR CLR_HBLUE	
@ 040,075 ComboBox cOpcao Items aOpcao                               Size 070,010 OBJECT oOpcao
@ 055,075 MsGet cPedido F3 "SC5"                                     Size 045,010 PIXEL OF _oDlg1
//@ 070,075 MsGet cItem  	        		                             Size 025,010 PIXEL OF _oDlg1
@ 095,080 BmpButton Type 1 Action Processa( { || AtuSeparacao() } )
@ 095,115 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1  Centered

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AtuSeparacao     º  Atualiza Separacao para Faturar         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSeparacao()

SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))

If !Empty(cPedido)
   If ! MsgBox("Confirma Atualização ?","AVISO","YESNO")
      Return
   EndIf
EndIf                    

_cQuery := " SELECT DISTINCT C6_PRODUTO, B1_DESC, C6_NUM,C6_ITEM, C6.R_E_C_N_O_ AS REGISTRO, C9_QTDLIB, C9_BLEST, C9_BLCRED "
_cQuery += " FROM " + RetSqlName("SC6") + " C6 "
_cQuery += " LEFT OUTER JOIN " + RetSqlName("SC9") + " C9 "
_cQuery += "      ON C9_FILIAL = '" + xFilial("SC9") + "' AND C9.D_E_L_E_T_ = ' ' "
_cQuery += "      AND C9_BLEST <> '10' AND C9_BLCRED <> '10' "
_cQuery += "      AND C9_PEDIDO = C6_NUM AND C9_PRODUTO = C6_PRODUTO AND C6_ITEM = C9_ITEM "
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
_cQuery += "      ON B1_FILIAL = '" + xFilial("SB1") + "' AND B1.D_E_L_E_T_ = ' '"
_cQuery += "	  AND B1_COD = C6_PRODUTO "	
_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6.D_E_L_E_T_ = ' '  "
_cQuery += "      AND C6_NUM = '" + cPedido + "' "

TcQuery _cQuery New Alias "QR1"

QR1->(dbGoTop())

DO WHILE !QR1->(EOF())
	If QR1->C6_PRODUTO <> "PEDIDO"
		IF SUBSTR(cOpcao,1,3) == "Ret"
			DbSelectArea("SC6")  
			SC6->(DBSEEK(XFILIAL("SC6")+QR1->C6_NUM+QR1->C6_ITEM+QR1->C6_PRODUTO))
			IF !EMPTY(SC6->C6_MSSEP)
				DbSelectArea("SC6")
				
				GO QR1->REGISTRO
				RecLock("SC6",.F.)
				SC6->C6_MSSEP := "N"
				SC6->(MsUnLock())
			ELSE	
				ApMsgInfo("Item não está Separado -  " + QR1->C6_PRODUTO) 
				fRet := .F.
			ENDIF	
		ELSE	
			IF QR1->C9_BLEST == "  " //.AND. QR1->C9_BLCRED == "  "  
				DbSelectArea("SC6")
				GO QR1->REGISTRO
				RecLock("SC6",.F.)
				SC6->C6_MSSEP := "S"
				SC6->(MsUnLock())  
			ELSE 
				IF 	QR1->C9_BLEST == "02" .AND. QR1->C9_BLCRED == "01"                                                    
					ApMsgInfo("Item " + ALLTRIM(QR1->C6_PRODUTO) + "  " + ALLTRIM(QR1->B1_DESC) + " - BLOQUADO POR CRÉDITO / ESTOQUE" )
				ELSEIF QR1->C9_BLCRED == "01"
					ApMsgInfo("Item " + ALLTRIM(QR1->C6_PRODUTO) + "  " + ALLTRIM(QR1->B1_DESC) + " - BLOQUADO POR CRÉDITO" )
				ELSEIF QR1->C9_BLEST == "02" 
					ApMsgInfo("Item " + ALLTRIM(QR1->C6_PRODUTO) + "  " + ALLTRIM(QR1->B1_DESC) + " - BLOQUADO POR ESTOQUE" )
				ELSE	
					ApMsgInfo("Item " + ALLTRIM(QR1->C6_PRODUTO) + "  " + ALLTRIM(QR1->B1_DESC) + " NÃO FOI LIBERADO " )
				ENDIF	
				fRet := .F.
			ENDIF	
		ENDIF		
	ELSE	
		ApMsgSTOP("Este Item não pode ser Separado: PEDIDO")
		fRet := .F.
	ENDIF	
	QR1->(dbSkip())
ENDDO	

QR1->(DbCloseArea())

Return 
