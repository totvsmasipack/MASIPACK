#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSPRETAB  ºAutor  ³Ivandro Santos      º Data ³  05/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que atualizará o preço dos produtos no orçamento   º±±
±±º          ³conforme tabela vigente                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA074()

Processa({|| MSPRETAB()},"Aguarde...","Ajuste dos preços do orçamento...",.F.)

Return

Static Function MSPRETAB()
Local _cNumOrc := SCJ->CJ_NUM
Local _cCodTab := SCJ->CJ_TABELA

If Select("QR1") > 0
	DbSelectArea("QR1")
	DbCloseArea()
EndIf
cQuery := " SELECT DA1_PRCVEN,CK_PRODUTO,CK_ITEM,CK_QTDVEN  "
cQuery += " FROM " + RetSqlName("SCK") + " SCK "
cQuery += " LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1_CODPRO = CK_PRODUTO AND DA1_CODTAB = '"+_cCodTab+"' AND DA1.D_E_L_E_T_='' AND DA1_FILIAL = '" + xFilial("DA1") + "' "
cQuery += " WHERE CK_NUM = '"+_cNumOrc+"' "
cQuery += " AND SCK.D_E_L_E_T_='' "
cQuery += " AND CK_FILIAL= '" + xFilial("SCK") + "' "
cQuery += " Order By CK_ITEM"

TcQuery cQuery New Alias "QR1"
TcSetField("QR1","DA1_PRCVEN","N",12,2)
dbSelectArea("QR1")
dbGoTop()
While !QR1->(eof())
	dbSelectArea("SCK")
	dbGoTop()
	dbSetOrder(1)
	dbSeek(xFilial("SCK")+_cNumOrc+QR1->CK_ITEM+QR1->CK_PRODUTO)
	If QR1->DA1_PRCVEN > 0
		Reclock("SCK")
		SCK->CK_PRCVEN := Round((QR1->DA1_PRCVEN),2)
		SCK->CK_PRUNIT := Round((QR1->DA1_PRCVEN),2)
		SCK->CK_VALOR  := Round((QR1->CK_QTDVEN*QR1->DA1_PRCVEN),2)
		SCK->(MSUNLOCK())
	Endif
	QR1->(dbSkip())
Enddo
dbCloseArea("SCK")
dbCloseArea("QR1")

Return
