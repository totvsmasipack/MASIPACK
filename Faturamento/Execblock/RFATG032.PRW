
#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG032  �Autor  �Lizandra Marques    � Data �  01/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � VERIFICA ALTERA��O DA DATA DE ENTREGA.                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG032()

_aArea := GetArea()

_dDtEnt		:= M->C5_MSDTENT

IF !Inclui 
	_nPosPCP1	:= Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_MSPCP"})
	_dDtEnt		:= SC5->C5_MSDTENT
	IF !EMPTY(aCols[n,_nPosPCP1])
		IF M->C5_MSDTENT > _dDtEnt + 7
			M->C5_MSDTENT := _dDtEnt
			ApMsgAlert("N�o � permitido Altera��o pois item j� foi analisado pelo PCP.")
		ELSE
			_dDtEnt := M->C5_MSDTENT		
		ENDIF
	ELSE	
		_dDtEnt := M->C5_MSDTENT		
	ENDIF	
ENDIF

RestArea(_aArea)
Return(_dDtEnt)