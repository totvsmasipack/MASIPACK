#Include "Protheus.ch" 
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATG002  �Autor  �Lizandra Marques    � Data �  17/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza o campo regiao no cadastro de clientes            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATG002()

IF INCLUI
	_cEst := M->A1_EST
ELSE	
	_cEst := SA1->A1_EST
ENDIF	

IF _cEst$ "BA/SE/MA/PI/CE/RN/PB/PE/AL"
   wREG := "NO"
ELSEIF _cEst$ "AC/AM/RO/RR/AP/PA/TO"
   wREG := "N"
ELSEIF _cEst$ "DF/GO/MT/MS"
   wREG := "CO"
ELSEIF _cEst$ "ES/RJ/SP/MG"
   wREG := "SE"
ELSEIF _cEst$ "PR/SC/RS"
   wREG := "S"
ELSEIF _cEst$ "EX"
   wREG := "EX"
ENDIF   

Return(wREG)