#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA003  ºAutor  ³Adriano Luis Brandaoº Data ³  22/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de geracao do numero de serie por produto / pedido deº±±
±±º          ³vendas.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA003()

_cPedido := Space(06)                 
_nGerou	 := 0
_cProd   := ""
_nQuant  := 0

@ 089,177 To 330,588 Dialog _oDlg1 Title OemToAnsi("Geração da Serie")
@ 009,011 To 055,188
@ 063,011 To 092,188
@ 020,024 Say OemToAnsi("Esta rotina tem como objetivo dar o numero de serie aos") 	Size 151,008
@ 034,024 Say OemToAnsi("produtos do pedido de vendas.") 							Size 151,008
@ 075,024 Say OemToAnsi("Pedido de Vendas") 										Size 055,008
@ 075,084 Get _cPedido Valid Existcpo("SC5") .And. NaoVazio()						Size 044,010
@ 101,095 BmpButton Type 1 Action Processa( { || _fGera() } )
@ 101,142 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fGera    ºAutor  ³Adriano Luis Brandaoº Data ³  22/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de geracao do numero de serie dos produtos do pedidoº±±
±±º          ³ de vendas.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fGera()

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+_cPedido))
If Alltrim(SC6->C6_PRODUTO) == "PEDIDO"
   apMsgStop("Pedido sem Itens de Maquina - Geração será cancelada")
   Return
EndIf   

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+_cPedido))
If SC5->C5_TIPO <> "N"
   apMsgStop("Este Pedido nao e de venda")
   Return
EndIf

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA))

If ! apMsgYesNo("Confirma Geracao do Pedido "+_cPedido+" Cliente : "+ SA1->A1_NREDUZ)
   Return
EndIf
//
// Monta a regua
//
_nCont := 0
Do While ! SC6->(Eof()) .And. SC6->C6_NUM == _cPedido
   _nCont++
   SC6->(DbSkip())
EndDo

ProcRegua(_nCont)
SC6->(DbSeek(xFilial("SC6")+_cPedido))

Do While ! SC6->(Eof()) .And. SC6->C6_NUM == _cPedido
   IncProc("Gerando o numero de serie do pedido " + _cPedido + " !!!!")
   //
   // Se nao encontrou uma geracao de serie, entao sera gerado a serie.
   //
   // alteração do processo - Lizandra - 07/11/13 - ACRESCENTADO " .OR. SUBSTR(C6_PRODUTO,3,6) == _cPedido "
   If SubStr(SC6->C6_PRODUTO,1,2) == "PV" .OR. SUBSTR(SC6->C6_PRODUTO,3,6) == _cPedido 
      SG1->(DbSetOrder(1))
      If SG1->(DbSeek(xFilial("SG1")+SC6->C6_PRODUTO))
         Do While ! SG1->(Eof()) .And. SC6->C6_PRODUTO == SG1->G1_COD
            SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
            If SB1->B1_ETIQUET == "S"
               _cProd := SG1->G1_COMP
               _nQuant := SC6->C6_QTDVEN * SG1->G1_QUANT
               GeraSerie()
            EndIf   
            SG1->(DbSkip())
            Loop
         EndDo   
      EndIf   
   Else
      SB1->(DbSetOrder(1))
      SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
      If SB1->B1_ETIQUET == "S"
         _cProd  := SC6->C6_PRODUTO
         _nQuant := SC6->C6_QTDVEN
         GeraSerie()
      EndIf
   EndIf
   SC6->(DbSkip())
EndDo                                                                         

If _nGerou > 0
   _cPedido := Space(06)
   apMsgInfo("Series geradas com sucesso !!!!","AVISO","INFO")
Else 
   apMsgAlert("Não houve geração de serie !!!!","AVISO","INFO")  
EndIf

Static Function GeraSerie() 

Local _nI

    AA3->(DbOrderNickName("AA3_PEDPRO"))
	If ! AA3->(DbSeek(xFilial("AA3")+SC6->C6_NUM+SC6->C6_ITEM+_cProd))
	  //
      // Gera todas as series de acordo com a quantidade do item do pedido de vendas.
      //
		For _nI := 1 To _nQuant
			_cSerie				:= GetMv("MV_MSSERIE")
			If Left(_cSerie,4) <> Strzero(Year(dDataBase),4)
				_cSerie			:= Strzero(Year(dDataBase),4)+"0001"
			Else
				_cSerie			:= Left(_cSerie,4)+Strzero(Val(Substr(_cSerie,5,4))+1,4)
			EndIf
			RecLock("AA3",.t.)
			AA3->AA3_FILIAL		:=	xFilial("AA3")
			AA3->AA3_MSPED		:=	SC6->C6_NUM
			AA3->AA3_MSITEM		:=	SC6->C6_ITEM
			AA3->AA3_CODPRO		:=	_cProd
			AA3->AA3_NUMSER		:=	_cSerie
			AA3->AA3_MSEMI  	:=  Posicione("SC5",1,xFilial("SC5")+SC6->C6_NUM,"C5_EMISSAO")
			AA3->AA3_DTVEND     :=	dDataBase
			AA3->AA3_MSOBS      :=	""
			AA3->AA3_CODCLI     := SC6->C6_CLI
			AA3->AA3_LOJA       := SC6->C6_LOJA 
			AA3->AA3_MODELO     := SB1->B1_MSMAQUI
			AA3->AA3_CONTRT     := SC5->C5_ORCAM 
			_nGerou++
			AA3->(MsUnLock())
			PutMv("MV_MSSERIE",_cSerie)
		Next _nI
	EndIf
Return