#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070TIT  �Autor  �Cecilia             � Data �  07/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para atualizar as comissoes               ��� 
���          � (Comissoes dos Supervisor e das Exportacoes)               ��� 
���          � Apos a confirmacao da baixa                                ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA070TIT()

aArea := GetArea()  

nComis   := 0               
_cVend   := SE1->E1_VEND1
_nTotal  := SE1->E1_BASCOM1 
_cPrefixo:= SE1->E1_PREFIXO
_cNum    := SE1->E1_NUM
lRet     := .T.
//Tratamento da Comissao qdo tem um supervisor   //Para todas as Empresas

 dbSelectArea("SE5")
 dbSetOrder(4)
 If dbSeek(xFilial("SE5")+SE1->E1_NATUREZ+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)  

    If !Empty(_cVend)
       SA3->(DbSetOrder(1))
       If SA3->(DbSeek(xFilial("SA3")+_cVend))   
          If SA3->A3_SUPER <> " "  
             _nComis := (SE5->E5_VALOR * SA3->A3_MSCOMSU) / 100
             SE3->(DbSetOrder(1))
             RecLock("SE3",.T.)
                 SE3->E3_BASE    := SE5->E5_VALOR  // Valor Base da Comissao
				 SE3->E3_COMIS   := _nComis // Valor a Pagar ( na Baixa )
				 SE3->E3_FILIAL  := xFilial("SE3")          // Filial
				 SE3->E3_VEND    := SA3->A3_SUPER     // C�d. Vendedor Supervisor
				 SE3->E3_NUM     := SE1->E1_NUM        // No. T�tulo
				 SE3->E3_SERIE   := SE1->E1_SERIE
				 SE3->E3_PORC    := SA3->A3_MSCOMSU   // % da Comiss�o ( na Baixa )
				 SE3->E3_CODCLI  := SE1->E1_CLIENTE    // C�d. Cliente
				 SE3->E3_LOJA    := SE1->E1_LOJA       // Loja
				 SE3->E3_EMISSAO := SE5->E5_DATA            // Data da emiss�o do t�tulo
				 SE3->E3_PREFIXO := SE1->E1_PREFIXO    // Prefixo do T�tulo
				 SE3->E3_PARCELA := SE1->E1_PARCELA
				 SE3->E3_TIPO    := SE1->E1_TIPO       // Tipo do T�tulo
				 SE3->E3_BAIEMI  := "B"                // Flag (Pago na Baixa)
				 SE3->E3_ORIGEM  := SE1->E1_ORIGEM
				 SE3->E3_PEDIDO  := SE1->E1_PEDIDO    
             	 SE3->(MsUnlock())
   	      Endif	
       Endif
    Endif
 Endif   
RestArea(aArea)

Return(lRet)
