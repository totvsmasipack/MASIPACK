#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP521VL   �Autor  �Cida                � Data �  18/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna Valor em lancamento padrao 521                      ���
���          �Contabiliza Recebimento de duplicatas em carteira simples   ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�����������������������������������������������������������������������������
*/
                                                                                               
User Function LP521VL(_nSeq)

// _nSeq => Sequencia dos lan�amentos  1-Valor do titulo, 2-Valor do Desconto concedido, 2-Valor de Juros/Multa/Correcao 

_cNat    := Alltrim(SE5->E5_NATUREZ)
_cTipoDoc:= Alltrim(SE5->E5_TIPODOC)
_nValor  := 0 
 
If _cNat $ "V14_V15"       // Finame Fabricante => V14 - Valor dos Juros, V15 - Valor principal
   If _cTipoDoc == "CM"    // Correcao monetaria, dever� ser incluido no valor principal
      _nValor := 0
   Else
      If _cTipoDoc == "VL"
         If _nSeq == 1        // Valor Principal do Finame Fabricante
            If SE1->E1_MOEDA == 5
               _nValor := SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA
            Else
               _nValor := SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA - SE5->E5_VLCORRE
            EndIf
         ElseIf _nSeq == 2
           _nValor := SE5->E5_VLDESCO - SE5->E5_VLDECRE
         ElseIf _nSeq == 3
            If SE1->E1_MOEDA == 5
              _nValor := (SE5->E5_VLJUROS + SE5->E5_VLMULTA) - SE5->E5_VLACRES
            Else
               _nValor := (SE5->E5_VLJUROS + SE5->E5_VLMULTA + SE5->E5_VLCORRE) - SE5->E5_VLACRES
            EndIf
         ElseIf _nSeq == 4
         		_nValor := SE5->E5_VALOR     
         EndIf  
      EndIf
   EndIf
Else
   If _nSeq == 1
		_nValor := SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA - SE5->E5_VLCORRE
   ElseIf _nSeq == 2
		_nValor := SE5->E5_VLDESCO - SE5->E5_VLDECRE
   ElseIf _nSeq == 3
		_nValor := (SE5->E5_VLJUROS + SE5->E5_VLMULTA + SE5->E5_VLCORRE) - SE5->E5_VLACRES
   ElseIf _nSeq == 4
		_nValor := SE5->E5_VALOR    
   EndIf
EndIf

Return(_nValor)
