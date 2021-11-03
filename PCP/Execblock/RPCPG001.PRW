#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPG001  ºAutor  ³Adriano Luis Brandaoº Data ³  29/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa utilizado pelo gatilho D3_OP ordem 3 durante a     º±±
±±º          ³execução do fonte MATA241 (Internos 2), onde irá assim que  º±±
±±º          ³digitar o número da OP atualizar automaticamente todos os   º±±
±±º          ³itens a serem requisitados para a OP, buscando da tabela SD4º±±
±±º          ³ de empenhos e suas quantidades.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCPG001()
//
// Variaveis utilizadas no programa
//
Private _aArea
Private _aAreaB1
Private _aAreaD4
Private _nPosOP
Private _nPosCod
Private _nPosUM
Private _nPosQtd
Private _nPosLocal
Private _nPosConta
Private _nPosGrupo  
Private _cRet
Private _nI
Private _nCont
//
// Verifica as posicoes dos campos da tatela SD3 no modelo 2
//
_nPosOP		:=	aScan(aHeader,{|x| Alltrim(x[2]) == "D3_OP"		}) 
_nPosCod		:=	aScan(aHeader,{|x| Alltrim(x[2]) == "D3_COD"		}) 
_nPosUM		:=	aScan(aHeader,{|x| Alltrim(x[2]) == "D3_UM"		}) 
_nPosQtd		:=	aScan(aHeader,{|x| Alltrim(x[2]) == "D3_QUANT"	}) 
_nPosLocal	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "D3_LOCAL"	}) 
_nPosConta	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "D3_CONTA"	}) 
_nPosGrupo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "D3_GRUPO"	}) 
_cRet 		:= aCols[n,_nPosOp]
//
// Caso ja buscou automaticamente ou ja exista dados cadastrados nao fara a busca automatica.
//
If Len(aCols) > n
   Return(_cRet)
EndIf
//
// Confirmacao se utilizara ou nao a busca automatica dos empenhos da OP
//
If ! MsgBox("Voce gostaria que atualiza-se todos os itens empenhados desta OP","Confirmar","YESNO")
   Return(_cRet)
EndIf

_cGrDe 	:= Space(4)
_cGrAte 	:= "ZZZZ"

@ 076,229 To 291,598 Dialog _oDlg1 Title OemToAnsi("Qual Grupo ??")
@ 013,015 To 086,167 Title OemToAnsi("Grupos")
@ 030,029 Say OemToAnsi("Do grupo") 	Size 33,08
@ 052,029 Say OemToAnsi("Ate grupo") 	Size 34,08
@ 030,069 Get _cGrDe 	F3 "SBM" 		Size 38,10
@ 052,069 Get _cGrAte 	F3 "SBM" 		Size 38,10
@ 090,124 BmpButton Type 1 Action _fAtualiz()

Activate Dialog _oDlg1

Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fAtualiz ºAutor  ³Adriano Luis Brandaoº Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de atualizacao dos acols de acordo com os empenhos. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fAtualiz()       
Local _nI             

_oDlg1:End()
//
// Salva as areas correntes.
//
_aArea 		:= GetArea()

DbSelectArea("SC2")
_aAreaC2		:= GetArea()
//
// Grava Flag na OP selecionada, mostrando que esta OP ja foi separada.
//
DbSetOrder(1)
DbSeek(xFilial("SC2")+aCols[n,_nPosOP],.t.)
If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) == Alltrim(aCols[n,_nPosOP])
   RecLock("SC2",.f.)
   SC2->(MsUnLock())
EndIf

DbSelectArea("SB1")
_aAreaB1		:= GetArea()
DbSetOrder(1)

DbSelectArea("SD4")
_aAreaD4		:= GetArea()
SD4->(DbSetOrder(2))
//
// Posiciona no primeiro empenho da OP
//
SD4->(DbSeek(xFilial("SD4")+aCols[n,_nPosOP],.t.))

_nCont := n
Do While ! SD4->(Eof()) .And. SD4->D4_OP == aCols[n,_nPosOP]
	//
	// So atualizara automaticamente se houver saldo no empenho da OP
	//
   SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD))                 
   If SB1->B1_GRUPO < _cGrDe .Or. SB1->B1_GRUPO > _cGrAte
      SD4->(DbSkip())
      Loop
   EndIf 	
	
	If SD4->D4_QUANT > 0 
	   //
	   // Adicionara somente se nao for a linha que esta digitando.
	   //
	   If _nCont <> n
         aAdd(aCols,Array(Len(aHeader)+1))
    	EndIf
    	//
    	// Grava os valores em branco na nova linha criada.
    	//
      For _nI := 1 to Len(aHeader)+1
         aCols[_nCont,_nI] := aCols[n,_nI]
      Next _nI
      //
      // atualizando os campos em memoria
      //
      aCols[_nCont,_nPosOp] 		:= SD4->D4_OP				//	Numero Ordem de Producao
      aCols[_nCont,_nPosCod]		:= SD4->D4_COD				//	Codigo do Produto requisitado
      aCols[_nCont,_nPosUm]		:= SB1->B1_UM				//	Unidade de medida do produto
      aCols[_nCont,_nPosQtd]		:= SD4->D4_QUANT			//	Saldo empenhado.
      aCols[_nCont,_nPosLocal]	:= SD4->D4_LOCAL			//	Local Padrao (almoxarifado)
      aCols[_nCont,_nPosConta]	:= SB1->B1_CONTA			//	Conta Contabil do produto
      aCols[_nCont,_nPosGrupo]	:= SB1->B1_GRUPO			//	Grupo do Produto
      _nCont++
  	EndIf
  	
  	SD4->(DbSkip())
EndDo
//
// Restauracao das areas correntes.
//
RestArea(_aAreaC2)
RestArea(_aAreaB1)                    
RestArea(_aAreaD4)
RestArea(_aArea)
 
Return
