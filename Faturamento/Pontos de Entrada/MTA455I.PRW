#Include "totvs.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA455I   �Autor  �Lizandra Marques    � Data �  18/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA PARA GRAVAR MSLIBPV (STATUS DO PV)        ���
���          � - depois da libera��o do ESTOQUE                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA455I()

    IF cEmpAnt $ "01|10"
        U_MUDACOR()
	Endif

Return .T.