/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATG040  บAutor  ณEduardo Bego Mantoanบ Data ณ  11/07/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. ณ Funcao para Atualizar tabela ADL										  .ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK.                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
#Include "Rwmake.ch"
#Include "Topconn.ch"

User Function RFATG040(cV) 

Local aVend  		:= {}
Local cCodVe 		:= ""
Local cQuery 		:= ""
Private cPerg 		:= "XRFATG040" 
Private cVendedor := ""

If cV <> NIL

cVendedor := cV

Else
 
	IF ! Pergunte(cPerg,.T.)
 		Return
	ENDIF
	cVendedor := MV_PAR01
	
EndIf


If Select("QR1")  > 0 
	DbSelectArea("QR1") 
	DbCloseArea()
EndIf 

If Select("QR2")  > 0 
	DbSelectArea("QR2") 
	DbCloseArea()
EndIf
	
	cQuery :=" SELECT *
	cQuery +=" FROM SA3010 SA3
	cQuery +=" WHERE A3_END NOT LIKE 'MASIPACK' AND A3_END NOT LIKE 'FABRIMA'
	cQuery +=" AND A3_FILIAL=''
	cQuery +=" AND SA3.D_E_L_E_T_=''
	TcQuery cQuery New Alias "QR2"
          	           
   QR2->(dbGoTop())    
   
  	cQuery :=" SELECT * "
	cQuery +=" FROM "+RetSqlName("SA1")+" SA1 "
	cQuery +=" WHERE SA1.D_E_L_E_T_ = '' "
	cQuery +=" AND A1_COD <> '000001' "
	cQuery +=" AND A1_MSBLQL <> '1' "
	cQuery +=" ORDER BY A1_COD "
	
	TcQuery cQuery New Alias "QR1" 
	
   If ALLTRIM(MV_PAR01) <> ""       	           
  		QR1->(dbGoTop()) 
  		DbSelectArea("ADL")
  		If SUBSTR(cNumEmp,1,2) == '10'   // /Fabrima
	  		DBSETORDER(9)
	  	Else
	  		DBSETORDER(6)
	  	EndIf
		Do While QR1->(!Eof())
		
			If !(DBSEEK(xFilial("ADL")+QR1->A1_COD+cVendedor))
				RecLock("ADL",.T.)
					ADL->ADL_FILIAL  	:= ""
					ADL->ADL_VEND    	:= cVendedor
					ADL->ADL_FILENT   := ""
					ADL->ADL_ENTIDA  	:= "SA1"
					ADL->ADL_CODENT 	:= QR1->A1_COD
					ADL->ADL_LOJENT   := QR1->A1_LOJA
					ADL->ADL_NOME   	:= QR1->A1_NOME
					ADL->ADL_CGC   	:= QR1->A1_CGC  
				If SUBSTR(cNumEmp,1,2) == '10'   // /Fabrima
					ADL->ADL_MSTIPO  	:= QR1->A1_SATIV1 
					ADL->ADL_MSBR  	:= QR1->A1_MSAREA
					ADL->ADL_MSFANT   := QR1->A1_NREDUZ
					ADL->ADL_MSMUNI   := QR1->A1_MUN
					ADL->ADL_MSPAIS   := QR1->A1_PAIS
					ADL->ADL_MSEST    := QR1->A1_EST  
					//ADL_MSMUNI
				EndIf	
				ADL->(MsUnlock())  
			EndIf
			QR1->(DBSKIP())
		EndDo			
	Else 
	   QR1->(dbGoTop())
	   DbSelectArea("ADL")
		If SUBSTR(cNumEmp,1,2) == '10'   // /Fabrima
	  		DBSETORDER(9)
	  	Else
	  		DBSETORDER(6)
	  	EndIf
		Do While QR1->(!Eof()) 
			QR2->(dbGoTop())
			Do While QR2->(!Eof())
				If !(DBSEEK("ADL")+QR1->A1_COD+QR2->A3_COD)
			  		RecLock("ADL",.T.)
						ADL->ADL_FILIAL  	:= ""
						ADL->ADL_VEND    	:= QR2->A3_COD
						ADL->ADL_FILENT   := ""
						ADL->ADL_ENTIDA  	:= "SA1"
						ADL->ADL_CODENT 	:= QR1->A1_COD
						ADL->ADL_LOJENT   := QR1->A1_LOJA
						ADL->ADL_NOME   	:= QR1->A1_NOME
						ADL->ADL_CGC   	:= QR1->A1_CGC 
					If SUBSTR(cNumEmp,1,2) == '10'   // /Fabrima		
						ADL->ADL_MSTIPO  	:= QR1->A1_SATIV1 
						ADL->ADL_MSBR  	:= QR1->A1_MSAREA
						ADL->ADL_MSFANT   := QR1->A1_NREDUZ  
						ADL->ADL_MSMUNI   := QR1->A1_MUN
						ADL->ADL_MSPAIS   := QR1->A1_PAIS
						ADL->ADL_MSEST    := QR1->A1_EST
					EndIf		
					ADL->(MsUnlock())
				EndIf 
				QR2->(DBSKIP())
			EndDo
			QR1->(DBSKIP())
		EndDo
	EndIf  
		

	

	
If Select("QR1")  > 0 
	DbSelectArea("QR1") 
	DbCloseArea()
EndIf 

If Select("QR2")  > 0 
	DbSelectArea("QR2") 
	DbCloseArea()
EndIf
 
ALERT("Processo concluํdo!")
Return 