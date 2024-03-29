#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �U_FATG52RE()  �Autor  �Ivandro M P Santos� Data �  08/04/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o auxiliar para os gatilhos do c�digo do munic�pio e  ���
���          � Pais (A1_COD_MUN e A1_PAIS respectivamente).               ���
���          � Abre tela com o combo para selecionar as regi�es corretas  ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function RFATG055()
Local _cMoBlo	  := ""
Local _aBloqueio := {}
Local oRadio
Local _cEscolha  := ""

Static oDlg
	
IF !(IsInCallStack("U_MSARECLI") .OR. IsInCallStack("U_MSALTSA1"))
aAdd(_aBloqueio,"SC - Situa��o Cadastral",nil)
aAdd(_aBloqueio,"RD - Restri��o   Diretoria",nil)
aAdd(_aBloqueio,"RF - Restri��o Financeira",nil)
aAdd(_aBloqueio,"IN - Inatividade",nil)
aAdd(_aBloqueio,"CD - Cadastro em Duplicidade",nil)
aAdd(_aBloqueio,"NL - Nova Loja",nil)

	
	DEFINE MSDIALOG oDlg FROM  094,1 TO 230,300 TITLE "Informe o Motivo do Bloqueio!" PIXEL

	@ 05,07 TO 45, 145 OF oDlg  PIXEL
	@ 10,10 SAY OemToAnsi("Qual Motivo do bloqueio?") PIXEL 
	@ 20,10 COMBOBOX oRadio VAR _cEscolha ITEMS _aBloqueio SIZE 130,130 PIXEL

	DEFINE SBUTTON FROM 048,055 TYPE 1 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
	
	_cMoBlo := Left(_cEscolha,2)
Endif	
Return _cMoBlo