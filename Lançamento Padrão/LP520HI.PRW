#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP520HI   �Autor  � Cecilia            � Data �  18/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento padro-���
���          �nizado 520 - Historico - Sequencia 05                       ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LP520HI()

Private  _cAalisold,_nValor,_cTpProd,_cTpNf,_cHist

_cAliasold:= alias()
_cConta   := " "
_cHist    := " " 
_cTpDoc   := SE1->E1_TIPO
_cSeq     := Alltrim(CT5->CT5_SEQUEN)
_cCli     := SE1->E1_CLIENTE
_cLoja    := SE1->E1_LOJA 
_cTpCli   := " " 
_cHist    := " "

// Contabiliza se for Cliente de exportacao com variacao cambial

If _cSeq == "05"
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
	  _cTpCli := SA1->A1_EST
   EndIf  
   
   If _cTpDoc = "RA" .and. _cTpCli = "EX"
      cHist:= "VARIACAO CAMBIAL "+SE1->E1_PREFIXO+SE1->E1_NUM+"*"+substr(SA1->A1_NREDUZ,1,16)                                                                                                                                                                                                                                          
   Endif   
Endif 

Return(_cHist)