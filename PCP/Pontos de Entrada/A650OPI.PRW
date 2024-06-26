#include "Rwmake.ch"  
#Include "Topconn.ch"
#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
?????????????????????????????????????????????????????????????????????????????
??������������������������������������������������������������������������???
??�Programa  ?A650OPI   �Autor  ?Adriano Luis Brandao� Data ?  03/11/03   �??
??������������������������������������������������������������������������???
??�Desc.     ? Funcao para nao deixar gerar ordem de producao depois do   �??
??�          ? segundo nivel da estrutura.                                �??
??�          ? E acionado quando confirma a inclusao das ordens de produ- �??
??�          ? coes no programa MATA650.                                  �??
??�          ? Essa fun��o gerar� apenas OPs de produtos com Unidade de   �??
??�          ? medida "CJ" impedindo que OPs desnecess�rias sejam abertas �??
??�          ? para outras unidades de medidas como "PC".                 �??
??�          ? Esse programa s� ser� retirado quando rodas o MRP          �??
??������������������������������������������������������������������������???
??�Uso       ? AP - MASIPACK.                                             �??
??������������������������������������������������������������������������???
?????????????????????????????????????????????????????????????????????????????
�����������������������������������������������������������������������������
*/

User Function A650OPI()

	//Local cGrupoGer := SuperGetMV("MS_A650OPI",,'0090|0010') Elton pediu para desconsiderar as regras por grupo, tornando todos iguais 03/02/2023
	Local cUMPai    := ""
	Local cGrupoPai := ""
	Local _cRet     := .T.
	Local nPosComp  := 0
	
	IF SUBSTR(cNumEmp,1,2) == "01" //Masipack
		
		_aArea 		:= GetArea()
		_cProdPai	:= ""                                                     
		INKEY(0)
		DbSelectArea("SC2")
		_aAreaC2	:= GetArea()
		DbSetOrder(1)
		
		nPosComp := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "G1_COMP"})

		// Pesquisa OP Pai com as informacoes do arquivo temporario do sistema de producao.
		
		//		DbSeek(xFilial("SC2")+Substr(bat->OP,03,11),.T.)                        //linha comentada em 21/02/13 - TGOZOZ consultoria - B�rbara
		//		If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) == Substr(bat->OP,03,11)	//linha comentada em 21/02/13 - TGOZOZ consultoria - B�rbara
		//		DbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,.T.)   	//linha criada    em 21/02/13 - TGOZOZ consultoria - B�rbara
		_cProdPai	:= SC2->C2_PRODUTO
		//		EndIf
		cGrupoPai := Posicione("SB1",1,xFilial("SB1")+_cProdPai,"B1_GRUPO")
		cUMPai    := Posicione("SB1",1,xFilial("SB1")+_cProdPai,"B1_UM")
		
		// Se nao encontrou o produto na estrutura do produto pai, retorna falso.
		If SG1->(DbSeek(xFilial("SG1") + _cProdPai + aCols[Paramixb,nPosComp]))
			SB1->(DBSEEK(xFilial("SB1") + aCols[Paramixb,1]))
			If Alltrim(SB1->B1_UM) == "CJ" .and. Alltrim(cUMPai) == "CJ"
                _cRet := .T.
			ElseIf Alltrim(SB1->B1_UM) == "CJ" .and. Alltrim(cUMPai) != "CJ" //Elton pediu para retirar o CJ at� que o calculo de MRP seja desenvolvido.
				_cRet := .F.
			ElseIf Alltrim(cUMPai) == "CJ" .and. Alltrim(SB1->B1_UM) != "CJ"
				_cRet := .F.
			EndIf 

		EndIf 	
		
		// Restaura as areas correntes.
		RestArea(_aAreaC2)
		RestArea(_aArea)    
         

	ElseIf 	SUBSTR(cNumEmp,1,2) == "10" //Fabrima
		_aArea 		:= GetArea()
		_cProdPai	:= ""                                                     
		INKEY(0)
		DbSelectArea("SC2")
		_aAreaC2	:= GetArea()
		DbSetOrder(1)
		
		// Pesquisa OP Pai com as informacoes do arquivo temporario do sistema de producao.
		
	//		DbSeek(xFilial("SC2")+Substr(bat->OP,03,11),.T.)                        //linha comentada em 21/02/13 - TGOZOZ consultoria - B�rbara
	//		If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) == Substr(bat->OP,03,11)	//linha comentada em 21/02/13 - TGOZOZ consultoria - B�rbara
	//		DbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,.T.)   	//linha criada    em 21/02/13 - TGOZOZ consultoria - B�rbara
		_cProdPai	:= SC2->C2_PRODUTO
	//		EndIf
		cGrupoPai := Posicione("SB1",1,xFilial("SB1")+_cProdPai,"B1_GRUPO")
		cUMPai    := Posicione("SB1",1,xFilial("SB1")+_cProdPai,"B1_UM")
		
		// Se nao encontrou o produto na estrutura do produto pai, retorna falso.
		If SG1->(DbSeek(xFilial("SG1") + _cProdPai + aCols[Paramixb,1]))
			SB1->(DBSEEK(xFilial("SB1") + aCols[Paramixb,1]))

			If  Alltrim(cUMPai) != "CJ" 
				_cRet := .F.
			ElseIf Alltrim(SB1->B1_UM) == "CJ" .and. Alltrim(cUMPai) != "CJ" //Elton pediu para retirar o CJ at� que o calculo de MRP seja desenvolvido.
				_cRet := .F.
			ElseIf Alltrim(cUMPai) == "CJ" .and. Alltrim(SB1->B1_UM) != "CJ"
				_cRet := .F.
			EndIf 

		EndIf 	
		
		// Restaura as areas correntes.
		RestArea(_aAreaC2)
		RestArea(_aArea)             
	ELSE
		_cRet 		:= .T.
	ENDIF	


Return(_cRet)
