#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410  �Autor �Aparecida de F.Stevanato Data � 15/09/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Verifica se h� Itens Separados para Faturamento           ���
�����������������������������������������������������������������������������
*/

User Function MTA410()

_fRet := .T.

IF SUBSTR(cNumEmp,1,2) <> "15"
	
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
	Do While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
		If SC6->C6_QTDEMP > 0 .And. SC6->C6_MSSEP == "S"
			_fRet := .F.
		EndIf
		SC6->(DbSkip())
	EndDo
	If !_fRet
		Alert("Altera��o Invalida, Pedido com Itens Separados no Estoque - Fale com Almoxarifado")
	EndIf
	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �MTA410    �Autor  �Lizandra            � Data �  30/04/13   ���
	�������������������������������������������������������������������������͹��
	���Desc.     � Consiste as condi��es do tipo 9                            ���
	���          �                                                            ���
	�������������������������������������������������������������������������͹��
	���Uso       � AP                                                        ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
	//Ivandro Santos - 16/11/16
	//Ticket#2016111537000317 � COND PAGTO V91
	//lRet := .t.
	//Ivandro Santos - 21/11/16
	//Ticket#2016112137000083 � PROBLEMAS COM COND PGTO V91
	/*
	If Posicione("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_TIPO") == "9"
	   	//_nTotal := M->C5_PARC1+M->C5_PARC2+M->C5_PARC3+M->C5_PARC4+M->C5_PARC5+M->C5_PARC6+M->C5_PARC7+M->C5_PARC8
	   	_nTotal := M->C5_PARC1+M->C5_PARC2+M->C5_PARC3+M->C5_PARC4+M->C5_PARC5+M->C5_PARC6+M->C5_PARC7+M->C5_PARC8+;
				   M->C5_PARC9+M->C5_PARCA+M->C5_PARCB+M->C5_PARCC+M->C5_PARCD+M->C5_PARCE+M->C5_PARCF
		If (_nTotal/M->C5_MSVLPED*100 <> 100) //If _nTotal < 100
		//Ticket#2016111537000317 � Fim da altera��o
			APMSGSTOP("PREENCHER OS VALORES DAS PARCELAS TIPO 9 CORRETAMENTE !!!","BLOQUEIO")
			_fRet := .F.
		EndIf
	EndIf    */
	//Ticket#2016112137000083 � Fim da altera��o
ENDIF
Return _fRet
