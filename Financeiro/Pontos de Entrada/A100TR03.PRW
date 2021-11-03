#include "rwmake.ch" 
#include "Topconn.ch" 

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma ³ A100TR03     ºAutor ³Eduardo Bego Mantoan  ³ 19/06/2014             			º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.    Ao estornar Transferência, gravar no campo E5_MSCANCE de ambos os movimentos  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso   ³Especifico Masipack  - para efeito de Controle e relatório            				 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function A100TR03()


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
Local CDTR      :=   SE5->E5_PROCTRA
Local cCance    := 	""  
Local cQuery    := ""  
Local bPar	    := 	PARAMIXB

If !bPar
	Return 
EndIf   

RecLock("SE5",.f.)
SE5->E5_MSCANCE := 	"E" 
SE5->(MsUnLock())
cCance 			 :=	SE5->E5_MSCANCE 

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
//cQuery += " AND E5_BANCO = '"+cBanco+"' "
cQuery += " AND E5_PROCTRA = '"+CDTR+"'"
//cQuery += " AND E5_AGENCIA = '"+cAgencia+"' "
//cQuery += " AND E5_RECPAG <> '"+cRecpag+"'  "
//cQuery += " AND E5_HISTOR NOT LIKE '"+cHist+"'  "
//cQuery += " AND E5_PARCELA = '"+cParcela+"'   "
//cQuery += " AND E5_PREFIXO = '"+cPrefixo+"'   "
//cQuery += " AND E5_NUMERO = '"+cNumero+"'    "
//cQuery += " AND E5_CLIENTE = '"+cCliente+"' "
cQuery += " AND E5_MSCANCE <> 'C'   "
cQuery += " AND E5_MSCANCE <> 'E'   "
//cQuery += " AND E5_BENEF = '"+cBenef+"'   "
//cQuery += " AND E5_NUMCHEQ = '"+cNumCheq+"'     "
//cQuery += " AND E5_DOCUMEN = '"+cDoc+"'    "
//cQuery += " AND E5_SEQ = '"+cSeq+"'   "      

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
/*
SE5->(DbSetOrder(1))
SE5->(dbgotop())
Dbseek(xFilial("SE5")+CDTR,.t.)
nCont := 1
While !SE5->(Eof())
	If nCont > 4
		Alert("MOVIMENTOS GRAVADOS CORRETAMENTE") 
		Return
	EndIF
	If (SE5->E5_VALOR = nValor)
		If (SE5->E5_MSCANCE <> "C") .AND. (SE5->E5_MSCANCE <> "E")
			If (SE5->E5_PROCTRA == CDTR)
				RecLock("SE5",.f.)
				SE5->E5_MSCANCE := "E" 
				SE5->(MsUnLock())
				nCont++    
   	   	SE5->(DbSkip())
   	   	loop
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
EndDo    */


Return 