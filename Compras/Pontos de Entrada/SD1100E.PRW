#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออหออออออออออออออออออออออออหออออออหอออออออออออออปฑฑ
ฑฑบPrograma  ณ SD1100E  บAutor  บAparecida de F.Stevanatoบ Data บ 07/12/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออสออออออออออออออออออออออออสออออออสอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza Estoques - Cancelamento da N. Fiscal de Entradas      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
		SD1->D1_MSOBS := "SD1100E - ESTORNO DE CLASSIFICAวรO NFE - " + cDescTes
	Else
		SD1->D1_MSOBS := "SD1100E - CANCELAMENTO NFE - " + cDescTes
	EndIf
	SD1->(MsUnLock())
EndIf

Return
