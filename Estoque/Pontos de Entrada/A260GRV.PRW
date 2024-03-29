#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A260GRV   �Autor  �LIZANDRA            � Data �  05/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Alimenta SZ8 na transferencia                               ���
�����������������������������������������������������������������������������
*/

User Function A260GRV()

	_lRet		:= .T.

	IF SUBSTR(cNumEmp,1,2) <> "15"
		_aArea	:= GetArea()
		_aUsuario	:= {}
		_cUsuario	:= RetCodUsr()
		_cUsuSenha	:= UsrRetname(_cUsuario)


		PswOrder(1)

		IF PswSeek(_cUsuario,.T.)
			_aUsuario	:= PswRet()
			_cUsuSenha	:= UsrRetName(_cUsuario)
			cUsuarioSX5	:= UPPER(Alltrim(_aUsuario[1][2]))
			cUsuarioSZS	:= UPPER(Alltrim(_aUsuario[1][4]))
			_cDeptoUsu	:= UPPER(Alltrim(_aUsuario[1][12]))
		ENDIF
		
		IF SUBSTR(cNumEmp,1,2) == "40"

			IF CCODORIG == CCODDEST 

				cString 	:= "SD3"
				NomeProg	:= "A260GRV"
				titulo	:= "Documento de transferencia de MP"
				cDesc1	:= ""
				cDesc2	:= ""
				cDesc3	:= ""
				tamanho	:= "P"
				aOrd		:= {}
				aReturn	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
				Cabec1	:= "DOCUMENTO DE TRANSFERENCIA DE MATERIA PRIMA:  " +  CDOCTO
				Cabec2	:= ""
				nLin		:= 80
				nTipo		:= 18
				m_pag		:= 1


				wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

				If nLastKey == 27
					Return
				Endif
				SetDefault(aReturn,cString)
				If nLastKey == 27
					Return
				Endif

				RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

			ENDIF
		ENDIF
		RestArea(_aArea)
	ENDIF
RETURN(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunReport �Autor  �Lizandra            � Data �  05/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Impressao de documento de transferencia                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	IF nLin > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF


	nLin := 9
	@ nLin,00 PSAY "PRODUTO : " + CCODDEST + " - " + CDESCDEST
	nLin += 2
	@ nLin,00 PSAY "QUANTIDADE TRANSFERIDA: " + TRANSFORM(NQUANT260,"@E 999,999,999.999")
	nLin += 10
	@ nLin,00 PSAY "________________________________            _________________________________ "
	nLin += 2
	@ nLin,00 PSAY "Responsavel Local de sa�da " + CLOCORIG + "         Responsavel Local de entrada " + CLOCDEST
	nLin += 2
	@ nLin,00 PSAY "SAIDA:    ___/___/___                       ENTRADA:  ___/___/___ "

	SET DEVICE TO SCREEN


	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

RETURN
