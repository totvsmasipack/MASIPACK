#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA012  �Autor  �Aparecida F.Stevanato� Data �  27/07/07  ���
�������������������������������������������������������������������������͹��
���Desc.     �Menu principal de chamada das funcoes do modelo 2 (SZF)     ���
���          �Pesquisa           (AxPesqui)                               ��� 
���          �Visualizar         (AxPesqui)                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������                       
�����������������������������������������������������������������������������
*/

User Function RFATA012()

Private cCadastro := "Pe�as de Reposi��o"
Private aRotina := { {"Pesquisar"	   	,"AxPesqui",0,1} ,;     // Pesquisa na tabela SZF
                     {"Visualizar"	    ,"AxVisual",0,2} ,;  	// Visualiza Modelo 2 
                     {"Imprimir"		,"U_RFATR015)",0,6} }   // Imprime Modelo 2 
      		       	
Private cString := "SZF"

dbSelectArea("SZF")

mBrowse( 6,1,22,75,"SZF")

DbCloseArea()

Return 