#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA011  �Autor  �Aparecida F.Stevanato� Data �  07/04/06  ���
�������������������������������������������������������������������������͹��
���Desc.     �Menu principal de chamada das funcoes do modelo 2 da tabela ���
���          �SC6, as funcoes que serao chamadas a partir deste fonte sao ���
���          �as seguintes:                                               ���
���          �Pesquisa           (AxPesqui)                               ��� 
���          �Visualizar         (AxPesqui)                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������                       
�����������������������������������������������������������������������������
*/

User Function RFATA011()

Private cCadastro := "Exibe Itens do Pedido de Vendas"
Private aRotina := { {"Pesquisar"	   	,"AxPesqui",0,1} ,;     // Pesquisa na tabela SC6
                     {"Visualizar"		,"AxVisual",0,2} ,;  	// Visualiza Modelo 2 
                     {"Imprimir"		,"U_RFATR002(SC6->C6_NUM)",0,6} }		// Imprime Modelo 2 
      		       	
Private cString := "SC6"

dbSelectArea("SC6")

//                                               
// Chamada do browse
//
mBrowse( 6,1,22,75,"SC6")

Return 
  
