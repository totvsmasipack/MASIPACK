#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �RFATA009  �Autor  �Aparecida de F.Stevanato� Data  23/05/08 ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao na tabela SZO - Mensagens da Nota Fiscal         ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA009()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
  
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
   apMsgStop("Altera��o inv�lida - Nota Fiscal j� impressa")
   Return .F. 
EndIf

Return .T.