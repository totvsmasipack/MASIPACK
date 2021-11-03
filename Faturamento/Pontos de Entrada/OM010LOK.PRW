#include "PROTHEUS.CH"
#include 'FwMvcDef.ch'

/*/{Protheus.doc} OM010LOK
//TODO Descrição: P.E. para gravar os preços incluídos e/ou alterados nos Pedidos de venda e compra das Empresas do Grupo.
@author ivandro.santos
@since 26/05/2017
@version 1.0
@return _lRet, description: Valida se produto pode ser alterado
@type function
/*/
User Function OM010LOK()

Local cTabIn	:= Alltrim(GetMv("MS_CODTABI"))
Local cProduto	:= ""
Local lRet		:= .T.
Local oModel	:= FwModelActive()
Local oGridDA1	:= oModel:GetModel('DA1DETAIL')
Local nPos		:= oGridDA1:nLine
Local nX		:= 0

	If oModel:GetValue('DA0MASTER','DA0_CODTAB') == cTabIn
		
		cProduto := oModel:GetValue('DA1DETAIL','DA1_CODPRO')
		
		For nX := 1 To oGridDA1:Length()
			If !(nX == nPos)
				oGridDA1:GoLine( nX )
				If !(oGridDA1:IsDeleted()) .And. oModel:GetValue('DA1DETAIL','DA1_CODPRO') == cProduto
					lRet := .F.
					FwAlertError('Produto ' + Alltrim(oModel:GetValue('DA1DETAIL','DA1_CODPRO')) + ' já cadastrado nesta tabela'  )
					Exit
				EndIf
			Endif
		Next nX

		oGridDA1:GoLine( nPos )
		
		If lRet
			FwMsgRun(,{|| U_RFATA072(oModel:GetValue('DA1DETAIL','DA1_CODPRO'),Round(oModel:GetValue('DA1DETAIL','DA1_PRCVEN'),2)) }, 'Aguarde', 'Atualizando Pedidos de Vendas..')
		Endif

	Endif

Return lRet