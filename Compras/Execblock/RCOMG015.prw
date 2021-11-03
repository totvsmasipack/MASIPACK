#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RCOMG015
Função para atualização do status da NF no NFESync
@type  Function
@author E.DINIZ - [ DS2U ]
@since 28/10/2021
@param  aNFiscal		Type	Value
		aNFiscal[1]		|	C	|	SF1->F1_DOC
        aNFiscal[2]		|	C	|	SF1->F1_SERIE
        aNFiscal[3]		|	C	|	SF1->F1_TIPO
        aNFiscal[4]		|	C	|	SF1->F1_FORNECE
        aNFiscal[5]		|	C	|	SF1->F1_LOJA
/*/
User Function RCOMG015(oSay, aNFiscal)

Default aParam  := {}
Default oSay    := Nil

    DbSelectArea('ZN0')
    ZN0->(DbSetOrder(1))
    If ZN0->(DbSeek( FWxFilial('ZN0') + PadR(aNFiscal[1],TamSX3('ZN0_DOC')[1]) + PadR(aNFiscal[2],TamSX3('ZN0_SERIE')[1]) + PadR(aNFiscal[4],TamSX3('ZN0_FORNEC')[1]) + PadR(aNFiscal[5],TamSX3('ZN0_LOJA')[1]) + PadR(aNFiscal[3],TamSX3('ZN0_TIPO')[1]) ))

		oSay:SetText('Atualizando NF ' + Alltrim(aNFiscal[1]))
			
		While .T.
			If Reclock('ZN0',.F.)
				ZN0->ZN0_STATUS	:= SPACE(TamSX3('ZN0_STATUS')[1])
				Exit
			Endif
			
			If !( ValType(oSay) == Nil )
				oSay:SetText('Aguardando liberação do documento para edição..')
				Sleep(5000)
			Endif
		Enddo

	Endif

Return
