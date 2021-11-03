#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RFATG060
//TODO Descrição: Gatilho do campo DA1_CODPROD para o campo DA1_PRCVEN.
@author ivandro.santos
@since 25/05/2018
@version 1.0
@return nValor, Valor cadastrado no campo B2_CM1 do produto pai ou da soma de seus componentes.
@type function
/*/

User function RFATG060()
	Local  cProduto := ""
	Local _cTab := M->DA0_CODTAB
	Static nValor	:= 0
	Static nCusSTD  := 0
	Static nUltPrc	:= 0
	Static cAliasG1	:= GetNextAlias()
	Static _aArea	:= GetArea()

	Private nEstru		:= 0

	iF !(_cTab == "900")
		RestArea(_aArea)
		Return
	EndIf
	cProduto := ReadVar()

	If !Empty(&cProduto)
		nValor	:= 0
		nValor := RFATG60PRE(&cProduto,1)

		If nValor = 0
			Estrut2(&cProduto,1,,NIL)
			If Select('ESTRUT')
				ESTRUT->(DbGotop())

				Do While !ESTRUT->(Eof())
					RFATG60PRE(ESTRUT->COMP,ESTRUT->QUANT) 
					ESTRUT->(DbSkip())
				EndDo

				ESTRUT->(DbCloseArea()) //Fecho o arquivo, caso não exclua abaixo o arquivo estara fechado
				//Podendo ser reaberto

			EndIf	
		EndIf
	EndIf

	nValor := IIF(nValor>0,nValor,IIF(nUltPrc>0,nUltPrc,IIF(nCusSTD>0,nCusSTD,0))) 
	RestArea(_aArea)
Return ROUND(nValor,2) 

/*/{Protheus.doc} RFATG60PRE
//TODO Descrição: Forma o preço baseado no custo médio do produto final ou de sua estrutura; se não tiver preço busca última compra ou custo std.
@author ivandro.santos
@since 25/05/2018
@version 1.0
@return nValor, Valor cadastrado no campo B2_CM1 do produto pai ou da soma de seus componentes.
@param cProd, characters, descricao: produto posicionado na tabela de preço
@param nVlrRat, numeric, descricao: valor do rateio vindo da estrutura, caso não tenha custo médio no produto final
@type function
/*/
Static Function RFATG60PRE(cProd,nVlrRat)
	Local nVlrCalc	:=	0

	Default cProd	:= 	''
	default nVlrRat	:= 	0

	BeginSQL Alias cAliasG1 
		Select B2_CM1, B1_CUSTD,B1_UPRC
		FROM %table:SB2% B2
		INNER JOIN %table:SB1% B1 ON B1_FILIAL = %xfilial:SB1% AND B1_COD = B2_COD AND B1.%notdel% 
		WHERE 
		B2_FILIAL = %xfilial:SB2%
		AND B2_COD = %exp:cProd%
		AND B2_LOCAL = B1_LOCPAD
		AND B2.%notdel%	
	EndSQL
	If Select (cAliasG1) > 0
		Do While (cAliasG1)->(!EOF())
			nVlrCalc := (cAliasG1)->B2_CM1 * nVlrRat
			nValor   := nValor + nVlrCalc
			nCusSTD  := nCusSTD + ((cAliasG1)->B1_CUSTD * nVlrRat) 
			nUltPrc	 := nUltPrc + ((cAliasG1)->B1_UPRC * nVlrRat) 
			(cAliasG1)->(DbSkip())
		EndDo
		(cAliasG1)->(DbCloseArea())
	EndIf

Return nValor