#Include "Rwmake.ch"
#Include "Topconn.ch"                    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �MS520VLD  �Autor  �Aparecida F.Stevanato � Data �  02/10/07 ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se a Nota Fiscal pode ser cancelada                ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MS520VLD()                                                                   

Private lRet := .T.
 
//Alert("MS520VLD "+SF2->F2_DOC)  

If SF2->F2_EMISSAO <= GetMV("MV_DATAFIS")  // ESte parametro contem Data Limite p/ realizacao de Operacoes Fiscais
	ApMsgStop("Nota n�o poder� ser cancelada - Periodo Encerrado")
	lRet := .F.
Else
	If SubStr(cNumEmp,1,2) $ "10" .AND. !EMPTY(SF2->F2_CHVNFE)
		If MONTH(SF2->F2_EMISSAO) <> MONTH(dDatabase)
			ApMsgStop("Nota n�o poder� ser cancelada - Cancelamento fora do m�s de emiss�o." )
			lRet := .F.
		EndIf
	ElseIf SubStr(cNumEmp,1,2) $ "01_40"
		If SF2->F2_EMISSAO < Date() - 1 .AND. !EMPTY(SF2->F2_CHVNFE)
			ApMsgStop("Nota n�o poder� ser cancelada - Prazo para cancelamento (1 dia)" )
			lRet := .F.
		EndIf
	EndIf
EndIf

Return lRet