#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �RFATA018 �Autor � Aparecida de F.Stevanato� Data � 14/05/07 ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao na tabela SZ1 (Planejamento da Eletronica).      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA018() 

Private cPerg := "FATA18"

Pergunte(cPerg,.T.) 

Private cCadastro := "Planejamento Eletronica"
Private aRotina := {{"Pesquisar"	   	,"AxPesqui",0,1} ,;     // Pesquisa na tabela SZ1
                    {"Visualizar"		,"AxVisual",0,2} ,;     // Visualiza 
                    {"Incluir"		    ,"AxInclui",0,3} ,;     // Inclus�o
      		        {"Alterar"			,"AxAltera",0,4} ,;		// Altera��o
      		        {"Excluir"			,"AxDeleta",0,5}}		// Exclus�o  
            			              
Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

Do Case
   Case mv_par01 == 3
      SET FILTER TO SZ1->Z1_OK == "S"
   Case mv_par01 == 2
      SET FILTER TO SZ1->Z1_OK <> "S"
   Case mv_par01 == 1
      SET FILTER TO
EndCase 

// Chamada do browse   
mBrowse( 6,1,22,75,"SZ1")

Return
