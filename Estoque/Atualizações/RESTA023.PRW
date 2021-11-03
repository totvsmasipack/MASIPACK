/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESTA023  ºAutor  ³Eduardo Mantoan    º Data ³  01/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Atualiza B1_PE.      ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
#Include "Rwmake.ch"
#Include "Topconn.ch"

User Function RESTA023()  

If !(cEmpAnt $ "01|10")  // MASIPACK/FABRIMA  
	Return
EndIF

_cProd := SB1->B1_COD     
_cGRT  := SB1->B1_GRTRIB                                                                           
cGet1  := "0"
@ 080,153 To 352,584 Dialog _oDlg1 Title OemToAnsi("Alterarção prazo de Entrega - SB1.")
@ 012,016 To 103,198 Title OemToAnsi("Alterar")
@ 032,034 Say OemToAnsi("Produto")		 		Size 60,8
@ 051,035 Say OemToAnsi("Prazo"    )		 		Size 59,8
@ 032,105 Get _cProd F3 "SB1" 					Size 50,10
@ 051,105 GET cGet1  					Size 37,10 

@ 115,090 BmpButton Type 1 Action _fAltera()
@ 115,157 BmpButton Type 2 Action Close(_oDlg1)
Activate Dialog _oDlg1

return





Static Function _fAltera()

If ! apmsgYESNO("Confirma a alteracao ?")
   Return
EndIf

MsgRun("Atualizando!",, { || _fGravaB1() })

Return


Static Function _fGravaB1()

dbSelectArea("SB1")
SB1->(DbSetOrder(1))
IF SB1->(DbSeek(xFilial("SB1")+_cProd))
			RecLock("SB1",.F.)
			SB1->B1_PE   	 := VAL(cGet1)
//			SB1->B1_MSDTPE  := DATE()+VAL(cGet1)
			SB1->(MsUnLock())     
ELSE			
  	IF apMsgYesNo("Produto não existe. Informar outros parâmetros ??")
		RESTA023()
	ENDIF	 
ENDIF		


Close(_oDlg1)

Return
