#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP520CR   �Autor  � Cecilia            � Data �  18/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento padro-���
���          �nizado 520 - sequencia 05 - Credito                         ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/    

User Function LP520CR(_nSeq)

Private  _cCli,_cHist,_nValor,_cTpDoc

_cAliasold:= alias()
_cConta    := ""
_cTpDoc    := SE1->E1_TIPO
_cSeq      := Alltrim(CT5->CT5_SEQUEN)
_cCli      := SE1->E1_CLIENTE
_cLoja     := SE1->E1_LOJA 
_cTpCli    := " "

// Contabiliza se for Cliente de exportacao com variacao cambial
If _nSeq == 5
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
	  _cTpCli := SA1->A1_EST
   EndIf  
   
   If _cTpDoc = "RA" .and. _cTpCli = "EX"
    If SE1->E1_ACRESC > 0
       _cConta := "110400002"
    ElseIf SE1->E1_DECRESC > 0
       _cConta := "440310001"
    Endif
   Endif

ElseIf _nSeq == 1	
		// Quando for baixa de NCC (devolucao de valor para cliente)
		If SE5->E5_MOTBX == 'DEB' .AND. SE5->E5_TIPO = "NCC"
			_cConta := SA6->A6_CONTA
			
		// Quando for JUROS FINAME
		ElseIf (SE5->E5_NATUREZ) = "V14" 
			If (Substr(SE5->E5_FATURA,7,1) == "B"  )
				_cConta := "110400001"
			Else				
				_cConta := SED->ED_CONTA
			EndIf

		// Quando for FINAME PRINCIPAL
      	ElseIf (SE5->E5_NATUREZ) = "V15"
				If (Substr(SE5->E5_FATURA,7,1) == "A"  )
			      _cConta := "110400001"
			   Else
					_cConta := SED->ED_CONTA
				EndIf

		// Quando n�o for FINAME
		ElseIf (SE5->E5_NATUREZ) <> "V14" .AND. (SE5->E5_NATUREZ) <> "V15"

			If SE5->E5_MOTBX == 'DEB' .OR. SE5->E5_MOTBX == 'LIQ'
				_cConta := SA1->A1_CONTA

			// Quando for baixa de t�tulo criado por liquida��o (renegocia��o)	
			ElseIf !EMPTY(SE1->E1_NUMLIQ) .AND. (SE5->E5_MOTBX == 'DEB' .OR. SE5->E5_MOTBX == 'NOR')
				_cConta := "110400001"
			Else
				If SE5->E5_PREFIXO == 'JRS' //JUROS
					_cConta := '440210001'
				Else
					SA1->(DbSetOrder(1))
					If SA1->(DbSeek(xFilial("SA1")+SE5->E5_CLIENTE+SE5->E5_LOJA))
						_cConta := SA1->A1_CONTA
					EndIf
				EndIf
				
		 	EndIf
		EndIf
ElseIf _nSeq == 4

	If SE5->E5_MOTBX == 'DEB' .OR. SE5->E5_PREFIXO == 'JRS' //.AND. ALLTRIM(SE5->E5_NATUREZ) == 'L01'
		_cConta := ''
	Else
		_cConta := 'C'+_cCli
 	EndIf
 	
Endif 

Return(_cConta)
