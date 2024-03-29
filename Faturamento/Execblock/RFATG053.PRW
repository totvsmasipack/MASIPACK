#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "rwmake.ch"
#include "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �U_RFATR053()  �Autor  �Ivandro M P Santos� Data �  01/04/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para preencher o campo A1_MSAREA quando preenche o ���
���          � pa�s diferente de Brasil                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function RFATG053(_Pais)

Local _cQuery     := ""

Private _cReg  	  := ""
Private _cEscolha := ""
Private _aRegiao  := {}

If Alltrim(_Pais) <> "BR" .And. !Empty(_Pais)

	_cQuery := "Select YA_MSREGI+' - '+RTRIM(LTRIM(X5_DESCRI)) REGIAO FROM "+ RetSqlName("SYA") +" SYA "
	_cQuery += "	INNER JOIN "+ RetSqlName("SX5") +" SX5 ON X5_TABELA = 'RC' AND X5_CHAVE = YA_MSREGI "
	_cQuery += "	WHERE YA_CODGI = '"+_Pais+"' AND SYA.D_E_L_E_T_ = '' "

	
	/*
	//����������������������������������������������������������troH�
	//�Rotina que far� a sele��o da query passada por par�metro �
	//�e alimentar� o array caso tenha mais que uma regi�o ou   �
	//�a vari�vel caso tenha apenas uma.                         �
	//�Fonte gravado no arquivo MSXFUN.PRW                      �
	//����������������������������������������������������������troH�
	*/
	U_FATG52QR(_cQuery)

	If Empty(Alltrim(_cReg))
		Alert("N�o existe Regi�o cadastrada da cidade,estado ou pais")
	EndIf

EndIf
 
Return(_cReg)