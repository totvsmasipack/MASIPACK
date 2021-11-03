#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA008  บAutor  ณAparecida F.Stevanatoบ Data ณ  25/02/05  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMenu principal de chamada das funcoes do modelo 2 da tabela บฑฑ
ฑฑบ          ณSZA, as funcoes que serao chamadas a partir deste fonte sao บฑฑ
ฑฑบ          ณas seguintes:                                               บฑฑ
ฑฑบ          ณPesquisa           (AxPesqui)                               บฑฑ
ฑฑบ          ณInclusao           (AxInclui)                               บฑฑ
ฑฑบ          ณExclusao           (AxExclui)                               บฑฑ
ฑฑบ          ณImprimir Etiquetas (RFATR009)                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                       
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATA008()
Private cCadastro := "Notas Fiscais para emissใo de etiquetas"
Private aRotina := {{"Pesquisar"	   	,"AxPesqui",0,1} ,;     // Pesquisa na tabela SZA
      		       	{"Incluir"			,"AxInclui",0,3} ,;		// Inclusao Modelo 2 
            		{"Excluir"			,"AxDeleta",0,5} ,;		// Exclusao Modelo 2
		            {"Emitir Etiquetas"	,"U_RFATR009()",0,4} }	// Emite Etiquetas para os Produtos

Private cString := "SZA"

dbSelectArea("SZA")
dbSetOrder(1)
//
// Chamada do browse
//
mBrowse( 6,1,22,75,"SZA")

Return