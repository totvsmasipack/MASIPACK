
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATR930A  ºAutor  ³Ivandro Santos      º Data ³  03/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para registra no relatório Registro de     º±±
±±º          ³Processamento de dados o valor do ICMS Simples Nacional     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack - Fiscal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
//³Ponto de entrada criado para atender ao Fiscal                      ³
//³Ticket#2017011937000256 — Campo para Lançar ICMS de Simples Nacional³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ
*/
User Function MATR930A
Local _aArea 	:= GetArea()
Local aOBSERV := ParamIXB[1]  //Array contendo as observações geradas no sistema                                                            
//aOBSERV[1][1] => Observação a ser impressa                                                            
//aOBSERV[1][2] => .T.  - Imprime no Relatório   e .F. - Não Imprime no Relatório 
cAlias := Alias()
dbSelectArea("SF1")
dbSetOrder(1)
If dbSeek( xFilial("SF1") + (cAlias)->F3_NFISCAL + (cAlias)->F3_SERIE + (cAlias)->F3_CLIEFOR + (cAlias)->F3_LOJA ) .And. (cAlias)->F3_OBSICM > 0 .And. (cAlias)->F3_ESTADO <> "EX"
	aOBSERV := {}
	AADD(aOBSERV,{"CREDITO ICMS",.T.})
	AADD(aOBSERV,{"SIMPLES",.T.})
	AADD(aOBSERV,{"NACIONAL:",.T.})
	cRet := Alltrim(TransForm(SF1->F1_VALICM,PesqPict("SF1","F1_VALICM")))
	AADD(aOBSERV,{cRet,.T.})
EndIf 
RestArea(_aArea)
Return aOBSERV
