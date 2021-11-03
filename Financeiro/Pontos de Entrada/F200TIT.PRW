#include "Rwmake.ch"       
#include "Topconn.ch"       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA200TIT  ºAutor  ³Cecilia             º Data ³  07/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para atualizar as comissoes               º±± 
±±º          ³ (Comissoes dos Supervisor e das Exportacoes)               º±± 
±±º          ³ Apos ler a linha de detalhe, depois da gravacao de         º±± 
±±º          ³ todos os dados CNAB.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F200TIT()
Local aArea := GetArea()

nComis   := 0               
_cVend   := SE1->E1_VEND1
_cPrefixo:= SE1->E1_PREFIXO
_cNum    := SE1->E1_NUM                                                                    
lRet     := .T.
//Tratamento da Comissao qdo tem um supervisor   //Para todas as Empresas

 dbSelectArea("SE5")
 dbSetOrder(3)
 If dbSeek(xFilial("SE5")+cBanco+cAgencia+cConta+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)  

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
				  SE3->E3_VEND    := SA3->A3_SUPER     // C¢d. Vendedor Supervisor
				  SE3->E3_NUM     := SE1->E1_NUM        // No. T¡tulo
				  SE3->E3_SERIE   := SE1->E1_SERIE
				  SE3->E3_PORC    := SA3->A3_MSCOMSU   // % da ComissÆo ( na Baixa )
				  SE3->E3_CODCLI  := SE1->E1_CLIENTE    // C¢d. Cliente
				  SE3->E3_LOJA    := SE1->E1_LOJA       // Loja
				  SE3->E3_EMISSAO := SE5->E5_DATA        // Data da emissÆo do t¡tulo
				  SE3->E3_PREFIXO := SE1->E1_PREFIXO    // Prefixo do T¡tulo
				  SE3->E3_PARCELA := SE1->E1_PARCELA
				  SE3->E3_TIPO    := SE1->E1_TIPO       // Tipo do T¡tulo
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