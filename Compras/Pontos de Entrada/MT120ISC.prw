#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function MT120ISC
	MT120ISC - Manipula o acols do pedido de compras no retorno da escolha da SC
@type  Function
@author E.DINIZ - [ DS2U ]
@since 07/04/2022
@see https://tdn.totvs.com/display/PROT/MT120ISC+-++Manipula+o+acols+do+pedido+de+compras
/*/
User Function MT120ISC()

Local _aArea	:= {SC1->(GetArea()), SC7->(GetArea())}
Local _aPosLin	:= Array(8)

	_aPosLin[1]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_RETFOR"})	//Identifica o campo Retorno do Fornecedor
	_aPosLin[2]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})		//Identifica o campo Preço Unitário
	_aPosLin[3]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})	//Identifica o campo do código do Produto
	_aPosLin[4]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"})		//Identifica o campo do total do item
	_aPosLin[5]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_QUANT"})		//Identifica o campo da quantidade do item
	_aPosLin[6]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_VALIPI"})	//Identifica o campo valor do IPI
	_aPosLin[7]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_IPI"})	    //Identifica o campo percentual de IPI
	_aPosLin[8]	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_BASEIPI"})	//Identifica o campo da base do IPI

	// Atualiza o campo do Retorno do Fornecedor (C7_RETFOR)
	If _aPosLin[1] > 0
		aCols[N][_aPosLin[1]] 	:= 'N'
	Endif

	//Atualiza o campo Preço Unitário (C7_PRECO)
	If _aPosLin[3] > 0 .And. _aPosLin[2] > 0
		aCols[N][_aPosLin[2]] 	:= U_RCOMG016( aCols[N][_aPosLin[3]] )
	Endif

	//Atualiza o campo Valor Total (C7_TOTAL)
	If _aPosLin[4] > 0 .And. _aPosLin[5] > 0
		aCols[N][_aPosLin[4]]	:= aCols[N][_aPosLin[5]] * aCols[N][_aPosLin[2]]
	Endif
	
	//Caso o percentual de IPI esteja como zero busco o percentual no cadastro do produto
	If _aPosLin[7] > 0 .and. _aPosLin[3] > 0
		If aCols[N][_aPosLin[7]] == 0
			aCols[N][_aPosLin[7]] := Posicione("SB1",1,xFilial("SB1")+aCols[N][_aPosLin[3]],"B1_IPI")
		EndIf 
	EndIf 

	//Atualiza o valor do IPI
	If _aPosLin[3] > 0 .and. _aPosLin[7] > 0  .and. _aPosLin[4] > 0 
		aCols[N][_aPosLin[6]] := ((aCols[N][_aPosLin[4]] * aCols[N][_aPosLin[7]]) / 100)
	EndIf 

	//Atualiza a base de calculo do IPI
	If _aPosLin[8] > 0 .and. _aPosLin[4] > 0 
		aCols[N][_aPosLin[8]] := aCols[N][_aPosLin[4]]
	EndIf 
	//Retirado refresh pois após atualização de 23/01 do padrão ele passou a apagar os dados do campo quantidade.
	//Força o refresh na lista e grade.
	/*
	Eval(bListRefresh)
	Eval(bGDRefresh)
	*/

	AEval(_aArea,{|x| RestArea(x) })


Return
