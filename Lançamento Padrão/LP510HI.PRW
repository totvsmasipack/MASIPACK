#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP510HI   �Autor  �Cecilia             � Data �  08/05/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento padro-���
���          �nizado 500 - Sequencia 001 - Historico                      ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                                     
User Function LP510HI()
                                            
Private   _cProduto,_cTes,_cAalisold,_nValor,_cTpProd,_cTpNf

_cAliasold:= alias()
_cHist    := " "

If SE2->E2_PREFIXO == "885"
   _cHist := "Tit.Finame "+ SE2->E2_NUM+"-"+SE2->E2_PARCELA+SUBSTR(SA2->A2_NREDUZ,1,10)+" (5101)" 
Else   
   IF SE2->E2_ORIGEM = "MATA"  
      _cHist := "REF NF "+ SE2->E2_NUM+" "+SUBSTR(SA2->A2_NREDUZ,1,10)+" (5101)" 
   Else
      _cHist := "REF TIT. "+SE2->E2_NUM+" "+SUBSTR(SA2->A2_NREDUZ,1,10)+" (5101)"
   Endif
Endif  
  
  
Return(_cHist)