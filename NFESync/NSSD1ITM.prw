/*/{Protheus.doc} NSSD1ITM
Ponto de entrada na geração da pré-nota processada pelo Nfesync item a item
@author DS2U (SDA)
@since 04/07/2019
@version 1.0
@return alNewSD1, Array atualizado conforme item posicionado na ZN1

@type function
/*/
User Function NSSD1ITM()

Local aArea    := getArea()
Local alNewSD1 := PARAMIXB[1]

// Adicionando campo customizado para Masipack
if ( fieldPos( "ZN1_MSCERT" ) > 0 .and. !empty( ZN1->ZN1_MSCERT ) )
	AADD( alNewSD1, { "D1_MSCERT" , allTrim( ZN1->ZN1_MSCERT ),	 NIL} )
endif	

restArea( aArea )

Return alNewSD1