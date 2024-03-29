#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯送屯屯屯屯屯屯屯屯屯屯屯退屯屯屯送屯屯屯屯屯屯槐�
北篜rograma  � SD1100E  篈utor  篈parecida de F.Stevanato� Data � 07/12/2006  罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯释屯屯屯屯屯屯屯屯屯屯屯褪屯屯屯释屯屯屯屯屯屯贡�
北篋esc.     � Atualiza Estoques - Cancelamento da N. Fiscal de Entradas      罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       矱specifico Masipack                                             罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
// ALTERADO EM 07/08/13 por Ana Paula QF
*/

User Function SD1100E()

Local _cRotina   := FunName()
Local AtuEstoque := "N"
Local cDescTes   := ""

If SubStr(cNumEmp,1,2) <> "15" // MASIPACK ou FABRIMA
	SF4->(DbSetOrder(1))
	cDescTes := ""
	If SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))
		cDescTes := SF4->F4_DESCRIC
		AtuEstoque := SF4->F4_ESTOQUE
	EndIf       
	
	
	If AtuEstoque == "S" .AND. SD1->D1_LOCAL <> '10'    // LABORTUBE - 26/03/14
		
	Else
		AtuEstoque := "N"
	EndIf  
	
	If SUBSTR(SD1->D1_CF,1,1) == "3"
		AtuEstoque := "N"
	EndIf           
	
	Reclock("SD1")
	SD1->D1_MSSZ8  := ""
	SD1->D1_MSUSER := UsrRetName(RetCodUsr())
	If _cRotina == "MATA140"
		SD1->D1_MSOBS := "SD1100E - ESTORNO DE CLASSIFICA敲O NFE - " + cDescTes
	Else
		SD1->D1_MSOBS := "SD1100E - CANCELAMENTO NFE - " + cDescTes
	EndIf
	SD1->(MsUnLock())
EndIf

Return
