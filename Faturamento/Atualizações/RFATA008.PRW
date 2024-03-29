#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA008  �Autor  �Aparecida F.Stevanato� Data �  25/02/05  ���
�������������������������������������������������������������������������͹��
���Desc.     �Menu principal de chamada das funcoes do modelo 2 da tabela ���
���          �SZA, as funcoes que serao chamadas a partir deste fonte sao ���
���          �as seguintes:                                               ���
���          �Pesquisa           (AxPesqui)                               ���
���          �Inclusao           (AxInclui)                               ���
���          �Exclusao           (AxExclui)                               ���
���          �Imprimir Etiquetas (RFATR009)                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������                       
�����������������������������������������������������������������������������
*/

User Function RFATA008()
Private cCadastro := "Notas Fiscais para emiss�o de etiquetas"
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