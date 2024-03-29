#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP530CR   �Autor  �Lizandra            � Data �  13/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento padro-���
���          �nizado 530/01. Baixa de titulos. TRATA REEMBOLSO DE PA      ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP530CR()         
            
_aArea := GetArea()

M->CT2_ITEMD := ""
M->CT2_ITEMC := ""

If SE5->E5_TIPO="NF ".AND.SE5->E5_MOTBX="LIQ"
	_cConta := "110700004"
ElseIf Empty(SE5->E5_BANCO).AND.SE5->E5_TIPO ="NF ".AND.SE5->E5_MOTBX<>"CX1"
	_cConta := SE5->E5_CREDITO
ELSEIF SE5->E5_MOTBX="CX1"
    _cConta := ""         
ELSEIF SE5->E5_TIPO ="PA ".AND.SE5->E5_MOTBX="DEB"
    _cConta := "110700004"        
ELSEIF SE5->E5_TIPO ="NDF".AND.SE5->E5_MOTBX="DEB"
    _cConta := "110700010"
ELSE
	_cConta := SA6->A6_CONTA
ENDIF	
	    
RestArea(_aArea)	    

Return(_cConta)
