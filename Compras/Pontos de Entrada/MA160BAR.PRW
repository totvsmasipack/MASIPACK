#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �MA160BAR  �Autor  �Eduardo B Mantoan  � Data �28/05/2015   ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona bot�es no Toolbar An�lise de Cota��es				  ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

User Function MA160BAR()
	Local nRegSC8  := PARAMIXB[1]
	Local aButtons := {}

	aadd(aButtons,{'BUDGETY',{|| u_RCOMA021(nRegSC8)},'Envia-email','Envia-email'})   
	
Return (aButtons )
