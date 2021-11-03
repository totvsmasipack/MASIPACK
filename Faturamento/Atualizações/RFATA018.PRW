#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATA018 ºAutor ³ Aparecida de F.Stevanatoº Data ³ 14/05/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao na tabela SZ1 (Planejamento da Eletronica).      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA018() 

Private cPerg := "FATA18"

Pergunte(cPerg,.T.) 

Private cCadastro := "Planejamento Eletronica"
Private aRotina := {{"Pesquisar"	   	,"AxPesqui",0,1} ,;     // Pesquisa na tabela SZ1
                    {"Visualizar"		,"AxVisual",0,2} ,;     // Visualiza 
                    {"Incluir"		    ,"AxInclui",0,3} ,;     // Inclusão
      		        {"Alterar"			,"AxAltera",0,4} ,;		// Alteração
      		        {"Excluir"			,"AxDeleta",0,5}}		// Exclusão  
            			              
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
