#Include "RWMAKE.CH"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFIS001   �Autor  �Cecilia             � Data �  16/07/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela de Atualiza��o do Parametro MV_DATAFIS                 ���
���          �                                                            ���
���          �Este rotina tem o objetivo de atualizar o parametro         ���
���          �MV_DATAFIS para a trava do Fiscal                           ���
���          �MV_DATAFIN para trava financeira - 20/09/13 Lizandra        ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
// Foi inclu�do o parametro do Financeiro para travamento de lan�amentos anteriores ao mes corrente
// REESCRITO 20/09/13 - LIZANDRA
*/

User Function MFIS001()

//		_DataFech := cTod(Alltrim(SX6->X6_CONTEUD))
_DataFech := GetMv("MV_DATAFIS")
_DtFecFin := GetMv("MV_DATAFIN")

@ 200,001 TO 350,480 DIALOG oDlg1 TITLE "Bloquear Movimentacao Fiscal"
@ 010,010 Say "Informe a Data Limite para o Bloqueio Fiscal"
@ 030,010 Say "Informe a Data Limite para o Bloq Financeiro"
@ 010,140 Get _DataFech Size 50,50   //Picture "99/99/99"
@ 030,140 Get _DtFecFin Size 50,50   //Picture "99/99/99"

@ 045,110 BMPBUTTON TYPE 01 ACTION U_GRAVADAT()
@ 045,150 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTERED
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BLQDATAFIS�Autor  �Microsiga           � Data �  01/05/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GRAVADAT()

PutMV("MV_DATAFIS",_DataFech)
PutMV("MV_DATAFIN",_DtFecFin)

Close(oDlg1)

Return
