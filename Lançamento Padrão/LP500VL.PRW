#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP500VL   �Autor  �Cecilia             � Data �  07/05/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento padro-���
���          �nizado 500 - Sequencia 001 - Valor - Partida Dobrada        ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                                     
User Function LP500VL()
                                            
Private  _nValor                                 


_cAliasold:= alias()
_nValor   := 0

dbSelectArea("SM2")
dbSetOrder(1)
dbSeek(SE1->E1_EMISSAO,.T.)
  
 If (Substr(SE1->E1_PREFIXO,1,2) == "PR" .AND. SE1->E1_TIPO = "DP")  .OR. (Substr(SE1->E1_NUM,7,1) == "C" .AND. SE1->E1_TIPO = "NF")
    If SE1->E1_MOEDA = 05
       _nValor := SE1->E1_VALOR * SM2->M2_MOEDA5
    Else 
       _nValor := SE1->E1_VALOR
    Endif
 Else   
    _nValor := 0
 Endif 
  
Return(_nValor)