#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA415BUT  �Autor �Eduardo Bego Mantoan	   Data � 15/04/2015���
�������������������������������������������������������������������������͹��
���Desc.     �  Adiciona bot�es � barra no topo da tela         			  ���
�����������������������������������������������������������������������������
*/

User Function MA415BUT()  

Local aAreaAtu	:= GetArea()
Local aBotao	:= {} 
Local _aUsuario	:= {}               
	
	If cEmpAnt $ '01|10'
	
		PswOrder(1)
		If PswSeek(RetCodUsr(),.T.)
			_aUsuario := PswRet()
			_cDeparUsu := Upper(Alltrim(_aUsuario[1][12]))
			_cCargoUsu := Upper(Alltrim(_aUsuario[1][13])) 
		Else
			Return(aBotao)
		EndIf
		
		AAdd(aBotao,{"USER"   ,{|| U_RFATG049() }, "Desbloquear Or�amento" })
		If _cDeparUsu $ "INFORMATICA" .OR. _cCargoUsu $ "GERENTE DE VENDAS"  
			AAdd(aBotao,{"USER"   ,{|| U_RFATG050() }, "Aprovar Or�amento" }) 
		EndIf

	Endif
	
	RestArea(aAreaAtu) 
	 
Return aBotao