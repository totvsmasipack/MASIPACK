#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATA009  ºAutor  ³Aparecida de F.Stevanatoº Data  23/05/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao na tabela SZO - Mensagens da Nota Fiscal         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA009()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
 Private cVldAlt := "" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
    
 Private aRotina   := {{"Pesquisa" ,"AxPesqui"  ,0,1} ,;   // Pesquisa
     				   {"Visualiza","AxVisual"  ,0,2} ,;   // Visualiza
                       {"Inclui"   ,"AxInclui"  ,0,3} ,;   // Inclui
                       {"Altera"   ,"AxAltera"  ,0,4}}   // Altera 
                         
cVldAlt := "U_VerImp(nOpc)"
             
AxCadastro("SZO","Mensagens de Notas Fiscais",,cVldAlt)

Return  

User Function VerImp(nOpc)

If nOpc == 4 .And. SZO->ZO_IMPR == "S"
   apMsgStop("Alteração inválida - Nota Fiscal já impressa")
   Return .F. 
EndIf

Return .T.