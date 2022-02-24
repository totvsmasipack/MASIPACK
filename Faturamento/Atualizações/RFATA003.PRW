#include 'totvs.ch'
#include 'protheus.ch'
#include "Rwmake.ch"

/*/{Protheus.doc} User Function RFATA003
Rotina para gravar os detalhes da base instalada
@type  Function
@author E.DINIZ - [ DS2U ]
@since 23/02/2022
/*/
User Function RFATA003()

Local cPedido	:= Space(TamSX3('C5_NUM')[1])
Local oDlg		:= Nil

	If !(FwCodEmp() $ '01|10')
		Help(" ",1,"RFATA003_1",, "A utilização desta rotina é exclusiva para as empresas 01-Masipack e 10-Fabrima",1,0)
		Return
	Endif

	@ 089,177 To 330,588 Dialog oDlg Title OemToAnsi("Geração da Serie")
	@ 009,011 To 055,188
	@ 063,011 To 092,188
	@ 020,024 Say OemToAnsi("Esta rotina tem como objetivo dar o numero de serie aos") 	Size 151,008
	@ 034,024 Say OemToAnsi("produtos do pedido de vendas.") 							Size 151,008
	@ 075,024 Say OemToAnsi("Pedido de Vendas") 										Size 055,008
	@ 075,084 Get cPedido Valid Existcpo("SC5") .And. NaoVazio()						Size 044,010
	@ 101,095 BmpButton Type 1 Action ProcNumSerie(cPedido)
	@ 101,142 BmpButton Type 2 Action oDlg:End()
	
	Activate Dialog oDlg Centered

Return


/*/{Protheus.doc} User Function ProcNumSerie
Função para posicionar os ponteiros nas tabelas e fornecer
a quantidade a ser gerada no número de sérir na base instalada
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 23/02/2022
/*/
Static Function ProcNumSerie(cPedido)

Local lContinua	:= .T.
Local nQuant	:= 0

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(FWxFilial("SC5") + PadR(cPedido,TamSx3('C5_NUM')[1])))

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(FWxFilial("SC6") + PadR(cPedido,TamSx3('C6_NUM')[1])))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(FWxFilial("SA1") + SC6->(C6_CLI + C6_LOJA)))

	DbSelectArea("AA3")
	AA3->(DbOrderNickName("AA3_PEDPRO"))

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SG1")
	SG1->(DbSetOrder(1))

	While SC6->(!EOF()) .And. lContinua .And. SC6->(C6_FILIAL + C6_NUM) == FWxFilial("SC6") + cPedido
		
		If LEFT(SC6->C6_PRODUTO,2) == "PV" .OR. SUBSTR(SC6->C6_PRODUTO,3,6) == cPedido 
			If SG1->(DbSeek(FWxFilial("SG1") + SC6->C6_PRODUTO))
				Do While SG1->(!EOF()) .And. SC6->C6_PRODUTO == SG1->G1_COD
					If SB1->(DbSeek(FWxFilial("SB1") + SG1->G1_COMP)) .And. SB1->B1_ETIQUET == "S"
						nQuant := SC6->C6_QTDVEN * SG1->G1_QUANT
						If MyTECA040(SG1->G1_COMP, nQuant)
							lContinua := .F.
							Exit
						Endif
					EndIf
					SG1->(DbSkip())
				EndDo
			EndIf
		Else
			If SB1->(DbSeek(FWxFilial("SB1") + SC6->C6_PRODUTO)) .And. SB1->B1_ETIQUET == "S"
				nQuant := SC6->C6_QTDVEN
				If MyTECA040(SC6->C6_PRODUTO, nQuant)
					lContinua := .F.
				Endif
			Endif
		EndIf
		SC6->(DbSkip())
	Enddo

	If lContinua
		FwAlertSuccess('Números de série gerados com sucesso')
	Endif

Return


/*/{Protheus.doc} User Function ProcNumSerie
Função para realizar o ExecAuto na rotina TECA040 - Base Instalada
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 23/02/2022
/*/
Static Function MyTECA040(cProduto, nQuant)

Local aCab040 	:= {}
Local aItens040	:= {}
Local cSerie	:= ''
Local nX		:= 0

Private lMsErroAuto := .F.

	If !(AA3->(DbSeek(FWxFilial("AA3")+ SC6->(C6_NUM + C6_ITEM) + _cProd)))

		For nX := 1 to nQuant
			
			cSerie := GetMv("MV_MSSERIE")

			If !(Left(_cSerie,4) == Strzero(Year(dDataBase),4))
				_cSerie := Strzero(Year(dDataBase),4) + "0001"
			Else
				_cSerie := Left(_cSerie,4) + Strzero(Val(Substr(_cSerie,5,4))+1,4)
			EndIf
			
			AADD(aCab040, { "AA3_FILIAL",	FWxFilial("AA3"), 	NIL } )
			AADD(aCab040, { "AA3_CODCLI", 	SC6->C6_CLI,		NIL } )
			AADD(aCab040, { "AA3_LOJA",		SC6->C6_LOJA,		NIL } )
			AADD(aCab040, { "AA3_CODPRO",	cProduto,			NIL } )
			AADD(aCab040, { "AA3_NUMSER",	cSerie,				NIL } )
			AADD(aCab040, { "AA3_DTVEND",	dDataBase,			NIL } )
			AADD(aCab040, { "AA3_MSPED",	SC6->C6_NUM,		NIL } )
			AADD(aCab040, { "AA3_MSITEM",	SC6->C6_ITEM,		NIL } )
			AADD(aCab040, { "AA3_MODELO",	SB1->B1_MSMAQUI,	NIL } )
			AADD(aCab040, { "AA3_CONTRT",	SC5->C5_ORCAM,		NIL } )
			AADD(aCab040, { "AA3_MSEMI",	SC5->C5_EMISSAO,	NIL } )
			
			MsExecAuto({|x,y,z| TECA040(x,y,z) }, aCab040, aItens040, 3)                
			
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
				Exit
			Else
				PutMv("MV_MSSERIE",_cSerie)
				aCab040		:= {}
				aItens040	:= {}
			Endif

		Next nX
	
	Endif

Return lMsErroAuto
