#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_FATG52RE()  บAutor  ณIvandro M P Santosบ Data ณ  08/04/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar para os gatilhos do c๓digo do municํpio e  บฑฑ
ฑฑบ          ณ Pais (A1_COD_MUN e A1_PAIS respectivamente).               บฑฑ
ฑฑบ          ณ Abre tela com o combo para selecionar as regi๕es corretas  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/  

User Function RFATG055()
Local _cMoBlo	  := ""
Local _aBloqueio := {}
Local oRadio
Local _cEscolha  := ""

Static oDlg
	
IF !(IsInCallStack("U_MSARECLI") .OR. IsInCallStack("U_MSALTSA1"))
aAdd(_aBloqueio,"SC - Situa็ใo Cadastral",nil)
aAdd(_aBloqueio,"RD - Restri็ใo   Diretoria",nil)
aAdd(_aBloqueio,"RF - Restri็ใo Financeira",nil)
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