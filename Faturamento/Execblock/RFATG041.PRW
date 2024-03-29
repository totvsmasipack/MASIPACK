#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG041  �Autor  �Lizandra Marques    � Data �  03/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera valor unit�rio de acordo com a condi��o de pagamento���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG041()

_aArea := GetArea()     

_nDias := 0                    
_nPrcV := 0

dbSelectArea("DA1")
DA1->(dbSetOrder(1))
IF dbSeek(xFilial("DA1")+M->CJ_TABELA+TMP1->CK_PRODUTO)
	//Ivandro Santos - 11/11/16 - In�cio da altera��o
	//Ticket#2016111137000182 � PROBLEMAS P/ EFETIVAR O OR�AMENTO_nDesc := M->CJ_DESC1+M->CJ_DESC2+M->CJ_DESC3+M->CJ_DESC4
	_nPrcTab := _nPrcV := DA1->DA1_PRCVEN
	_nDesc:=M->CJ_DESC1+M->CJ_DESC2+M->CJ_DESC3+M->CJ_DESC4
	IIF(_nDesc>0,_nPrcV:=DA1->DA1_PRCVEN-(DA1->DA1_PRCVEN*(_nDesc/100)),_nPrcV:=DA1->DA1_PRCVEN)
	//Ticket#2016111137000182 � Fim da altera��o
ENDIF	

_nDias := Posicione("SE4",1,xFilial("SE4")+M->CJ_CONDPAG,"E4_DIASCOR")

IF DA1->DA1_MOEDA == 1
	//Ivandro Santos - 10/11/16 - Inicio da altera��o
	//Ticket#2016110937000285 � Problemas para gerar or�amentos
	_nVlrAl := TMP1->CK_PRCVEN	
	IF _nDias == 45
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.05.Or._nVlrAl==_nPrcV,_nPrcV*1.05,TMP1->CK_PRCVEN)//_nPrcV  * 1.05
	ELSEIF _nDias == 60	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.10.Or._nVlrAl==_nPrcV,_nPrcV*1.10,TMP1->CK_PRCVEN)//_nPrcV  * 1.10
	ELSEIF _nDias == 70	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.15.Or._nVlrAl==_nPrcV,_nPrcV*1.15,TMP1->CK_PRCVEN)//_nPrcV  * 1.15
	ELSEIF _nDias == 90	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.20.Or._nVlrAl==_nPrcV,_nPrcV*1.20,TMP1->CK_PRCVEN)//_nPrcV  * 1.20
	ELSEIF _nDias == 120	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.25.Or._nVlrAl==_nPrcV,_nPrcV*1.25,TMP1->CK_PRCVEN)//_nPrcV  * 1.25
	ELSEIF _nDias == 180	
		TMP1->CK_PRCVEN := iif(_nVlrAl==_nPrcV*1.35.Or._nVlrAl==_nPrcV,_nPrcV*1.35,TMP1->CK_PRCVEN)//_nPrcV  * 1.35
	ENDIF
	//Ticket#2016110937000285 � Fim da altera��o
	//Ivandro Santos - 11/11/16 - In�cio da altera��o
	//Ticket#2016111137000182 � PROBLEMAS P/ EFETIVAR O OR�AMENTO
	If _nDias = 45 .Or. _nDias = 60 .Or. _nDias = 70 .Or. _nDias = 90 .Or. _nDias = 120 .Or. _nDias = 180
		TMP1->CK_PRUNIT := TMP1->CK_PRCVEN
	Else
		TMP1->CK_PRUNIT := _nPrcTab
	Endif
	//Ticket#2016111137000182 � Fim da altera��o  
	TMP1->CK_VALOR	 := TMP1->CK_PRCVEN * TMP1->CK_QTDVEN
ENDIF

RestArea(_aArea)

Return(TMP1->CK_PRCVEN)
