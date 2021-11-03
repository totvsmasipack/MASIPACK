#include 'totvs.ch'
#include 'protheus.ch'


User Function MA140BUT()

Local aBtnRet  := {}

	If ( INCLUI .Or. ALTERA )
		AADD( aBtnRet, { 'PRODCLI', {|| U_GetProdCli() }, 'Dados Adic. do Produto', 'Dados Adic. do Produto' } )
	Endif

Return aBtnRet
