#include "rwmake.ch"
#include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma ³ FA100CAN     ºAutor ³Eduardo Bego Mantoan  ³ 13/06/2014             			º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.    Ao excluir contas a receber, gravar no campo E5_MSCANCE de ambos os movimentosº ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso   ³Especifico Masipack  - para efeito de Controle e relatório            				 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function FA100CAN()

Local nValor    :=	SE5->E5_VALOR
Local cBanco    :=	SE5->E5_BANCO
Local cAgencia  :=	SE5->E5_AGENCIA
Local cConta    :=	SE5->E5_CONTA
Local cRecpag   :=	SE5->E5_RECPAG
Local cHist     :=	SE5->E5_HISTOR
Local cParcela  :=	SE5->E5_PARCELA
Local cPrefixo  :=	SE5->E5_PREFIXO
Local cNumero   :=	SE5->E5_NUMERO
Local cCliente  :=	SE5->E5_CLIENTE
Local cBenef    :=	SE5->E5_BENEF
Local cNumCheq  :=	SE5->E5_NUMCHEQ
Local cDoc      :=	SE5->E5_DOCUMEN
Local cDtDig    :=   SE5->E5_DTDIGIT
Local cNatur    :=   SE5->E5_NATUREZ
Local cSeq      :=   SE5->E5_SEQ
Local cCance    := 	""

IF SUBSTR(cNumEmp,1,2) $ "01_10_15_40"
	SE5->E5_MSCANCE := 	"E"
	
	//cCance 			 :=	SE5->E5_MSCANCE
	
	_aArea 	:= GetArea()
	//DbSelectArea("SE5")
	_aAreaE5 := GetArea()
	If Select("QR1") > 0
		DbSelectArea("QR1")
		DbCloseArea()
	EndIf
	
	cQuery := " SELECT R_E_C_N_O_ AS NR    "
	cQuery += " FROM "+RetSqlName("SE5")+" SE5   "
	cQuery += " WHERE SE5.D_E_L_E_T_ = '' AND E5_FILIAL = '"+xFilial("SE5")+"'  "
	cQuery += " AND E5_VALOR = "+STR(nValor)+"  "
	cQuery += " AND E5_BANCO = '"+cBanco+"' "
	cQuery += " AND E5_AGENCIA = '"+cAgencia+"' "
	cQuery += " AND E5_RECPAG <> '"+cRecpag+"'  "
	cQuery += " AND E5_HISTOR NOT LIKE '"+cHist+"'  "
	cQuery += " AND E5_PARCELA = '"+cParcela+"'   "
	cQuery += " AND E5_PREFIXO = '"+cPrefixo+"'   "
	cQuery += " AND E5_NUMERO = '"+cNumero+"'    "
	cQuery += " AND E5_CLIENTE = '"+cCliente+"' "
	cQuery += " AND E5_MSCANCE <> 'C'   "
	cQuery += " AND E5_MSCANCE <> 'E'   "
	cQuery += " AND E5_BENEF = '"+cBenef+"'   "
	cQuery += " AND E5_NUMCHEQ = '"+cNumCheq+"'     "
	cQuery += " AND E5_DOCUMEN = '"+cDoc+"'    "
	cQuery += " AND E5_SEQ = '"+cSeq+"'   "
	
	TcQuery cQuery New Alias "QR1"
	
	dbSelectArea("QR1")
	dbGoTop()
	If !QR1->(EOF())
		
		DbSelectArea("SE5")
		SE5->(DbSetOrder(1))
		SE5->(dbgotop())
		DbGoTo(QR1->NR)
		RecLock("SE5",.f.)
		SE5->E5_MSCANCE := "C"
		SE5->(MsUnLock())
		
	EndIf
ENDIF
/*

SE5->(DbSetOrder(3))
SE5->(dbgotop())
Dbseek(xFilial("SE5")+cBanco+cAgencia+cConta,.t.)

While !SE5->(Eof())
If (SE5->E5_VALOR = nValor) .AND. (SE5->E5_BANCO == cBanco) .AND. (SE5->E5_AGENCIA == cAgencia)
If (SE5->E5_RECPAG <> cRecpag) .AND. (SE5->E5_HISTOR <> cHist) .AND. (SE5->E5_PARCELA == cParcela)
If (SE5->E5_PREFIXO == cPrefixo) .AND. (SE5->E5_NUMERO == cNumero) .AND. (SE5->E5_CLIENTE == cCliente)
If (SE5->E5_MSCANCE <> "C") .AND. (SE5->E5_MSCANCE <> "E") .AND. (SE5->E5_BENEF == cBenef) .AND. (SE5->E5_NUMCHEQ == cNumCheq)
If (SE5->E5_DOCUMEN == cDoc) .AND. (SE5->E5_SEQ == cSeq)

RecLock("SE5",.f.)
SE5->E5_MSCANCE := "C"
SE5->(MsUnLock())
Alert("Movimentos gravados corretamente")
Return
Else
SE5->(DbSkip())
loop
EndIF
Else
SE5->(DbSkip())
loop
EndIf
Else
SE5->(DbSkip())
loop
EndIF
Else
SE5->(DbSkip())
loop
EndIF


Else
SE5->(DbSkip())
loop
EndIF
EndDo
Alert("Não foi possível gravar corretamente os movimentos")

*/
Return 
