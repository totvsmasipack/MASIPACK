#Include "rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP530DB   �Autor  �Cecilia             � Data �  26/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para retorno de conta contabil em lancamento padro-���
���          �nizado 530/02. Baixa de titulos.                            ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP530DB()

Private _cRet

// Alimenta variaveis
_cNat   := Alltrim(SE5->E5_NATUREZ)
_cSeq   := Alltrim(CT5->CT5_SEQUEN)
_cDoc   := Alltrim(SE5->E5_NUMERO)
_CPref  := SE5->E5_PREFIXO
_cConta := ""

// Contabiliza Nota de Servico
Do Case
	Case _cNat $ "PIS|COFINS|CSLL"
		_cConta := "220400005"
		
	Case _cNat = "ISS"
		_cConta := "220400009"
		
	Case _cNat = "IR"
		_cConta := "220300002"
		
	Case _cNat = "INSS"
		_cConta := "220300007"
		
	OtherWise                          
		IF (SE5->E5_TIPO ="PA " .OR. SE5->E5_TIPO ="NDF").AND.SE5->E5_MOTBX="DEB"
        	 _cConta := SA6->A6_CONTA 
  		ELSEIF SE5->E5_TIPO == "NF" .AND. SE5->E5_MOTBX == "DEB"
  			_cConta := SA2->A2_CONTA
  		ELSEIF SE5->E5_TIPO == "FT" .AND. SE5->E5_MOTBX == "DEB"
  	     _cConta := SED->ED_CONTA
			M->CT2_ITEMD := ""
		ELSE	               
  	     _cConta := SA2->A2_CONTA
			M->CT2_ITEMD := ""
    	ENDIF     
EndCase 


Return(_cConta)
