#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT381VLD  ºAutor  ³Victor Dessunte     º Data ³  03/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida alteracao do empenho                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Incluída validação na função MSPEDCON não permitir exclusãoº±±
±±º          ³ de empenho caso o Pedido de Venda foi concluído-Ivandro-6/6º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT381VLD()

Local _aArea 	:= GetArea()
Local _lRet		:= .F.
Local _nX		:= 0   

Private _cMsgBloq := ""

	If cEmpAnt $ '01|10'

		//Variaveis padrao para verificar se esta habilitado
		//zerar empenho
		If (lZeraEmp .OR. lZeraEmp2) .AND. PARAMIXB[2]
			//VICTOR DESSUNTE - 28/06/17
			//INICIO - TICKET: 2017062637000199 
			If Pergunte("M381ZEMP",.T.)
				If EMPTY(MV_PAR01)
					Return .F.
				EndIf
			//FIM - TICKET: 2017062637000199
				For _nX:=1 To Len(aCols)
					//If u_MSEMPEN2(aCols[_nX,GDFIELDPOS("D4_COD")],SD4->D4_OP,2) > 0 .And. U_MSPEDCON(SD4->D4_OP,"EMP2")
					If U_MSPEDCON(SD4->D4_OP,"EMP2")
						_lRet := .T.
						Exit
					EndIf
				Next _nX
				
				/*If !_lRet .And. Empty(Alltrim(_cMsgBloq))
					Alert("Inclua algum item no empenho desta OP, em seguida exclua este item.")
				Elseif !_lRet .And. !Empty(Alltrim(_cMsgBloq)) 
					Alert(_cMsgBloq)
				EndIf*/
				
				If !_lRet .And. !Empty(Alltrim(_cMsgBloq)) 
					Alert(_cMsgBloq)
				EndIf
			
				//VICTOR DESSUNTE - 28/06/17
				//INICIO - TICKET: 2017062637000199 
				If _lRet
					For _nX:=1 To Len(aCols)
						SD4->(dbSetOrder(1))
						If SD4->(dbSeek(xFilial("SD4")+aCols[_nX,1]+SD4->D4_OP))
							If aCols[_nX,aScan(aHeader,{|x| ALLTRIM(x[2]) == "D4_QUANT"})] > 0
								aCols[_nX,aScan(aHeader,{|x| ALLTRIM(x[2]) == "D4_MSCOMEN"})] := MV_PAR01
							EndIf
						EndIf
					Next _nX
				EndIf
				//FIM - TICKET: 2017062637000199

			EndIf
		Else
			For _nX:=1 To Len(aCols)
				If !aCols[_nX,Len(aHeader)+1] .And. U_MSPEDCON(SD4->D4_OP,"EMP2")
					_lRet := .T.
				EndIf
			Next _nX
			If !_lRet
				Alert(_cMsgBloq)
			EndIf 
		EndIf
	
	Endif

	RestArea(_aArea)

Return _lRet
