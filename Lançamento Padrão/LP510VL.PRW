#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP510VL   �Autor  �Cecilia             � Data �  08/05/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento padro-���
���          �nizado 510 - Sequencia 001 - Valor - Titulos a Pagar        ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                                     
User Function LP510VL()
                                            
Private   _nValor

_cAliasold:= alias()
_nValor   := 0

dbSelectArea("SM2")
dbSetOrder(1)
dbSeek(se2->e2_emissao,.T.)    

If SE2->E2_PREFIXO == "885" 
   If se2->e2_tipo= "DP"
      If se2->e2_moeda = 5
        _nValor := se2->e2_valor * sm2->m2_moeda5 
      Else
        _nValor := se2->e2_valor
      Endif  
   Else
   _nValor := 0
  Endif   
Endif 
  
Return(_nValor)