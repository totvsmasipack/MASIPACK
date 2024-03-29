#Include "Rwmake.ch"
#Include "Topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A650PRCPV �Autor  �Lizandra	Marques    � Data �  05/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  N�o gerar OP para pedidos que n�o tiverem data de         ���
���          �  inicio de montagem                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A650PRCPV()     

Local _lRet 		:= .T.
Local _aArea 		:= { GetArea(), SC5->(GetArea()) }
Local _cUsuario		:= RetCodUsr()
Local _aUsuario		:= {}
Local _cDeptoUsu	:= "" 

	If cEmpAnt $ "01|10" .And. !( FwIsAdmin() )

		PswOrder(1)
		IF PswSeek(_cUsuario,.T.)
			
			_aUsuario := PswRet()
			_cDeptoUsu := UPPER(Alltrim(_aUsuario[1][12]))
		
			dbSelectArea("SC5")
			SC5->(DbSetOrder(1))

			IF SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))
				
				IF SC5->C5_MSCATEG <> '5' .AND. EMPTY(SC5->C5_MSMONTA) .AND. !( "PCP" $ _cDeptoUsu )
					_lRet := .F.
					FwAlertError("Pedido sem data de inicio de montagem.",'TOTVS')
				ENDIF
				
				IF !EMPTY(SC5->C5_MSCONCL)
					_lRet := .F.
					FwAlertError("Pedido concluido em " + DTOC(SC5->C5_MSCONCL) + ".  Verifique com a montagem",'TOTVS')
				ENDIF
			
			ENDIF
		
		Endif

	Endif
		            
	AEval(_aArea,{|x| RestArea(X) })

RETURN _lRet     
