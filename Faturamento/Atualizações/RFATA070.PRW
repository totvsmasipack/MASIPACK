#Include "Rwmake.ch"
#Include "Topconn.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �RFATA070  �Autor  �Ivandro M. P. Santos    � Data  05/04/16 ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao na tabela SZX - Vendores e Regi�es (Comercial)   ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA070()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local _cValIncAlt
Private aRotina   := {{"Pesquisa" ,"AxPesqui"  ,0,1} ,;   // Pesquisa
{"Visualiza","AxVisual"  ,0,2},;   // Visualiza
{"Inclui"   ,"AxInclui"  ,0,3} ,;   // Inclui
{"Altera"   ,"AxAltera"  ,0,4} ,;   // Altera
{"Exclui"   ,"AxDeleta"  ,0,5}}   // Exclui
                              
//Ivandro Santos - 22/11/16 - In�cio altera��o
//Ticket#2016111737000082 � Tabela | Atualiza��o (cadastro) de Vendedores
_cValIncAlt := "U_RF070INAL(nOpc)"
                              
AxCadastro1("SZX","Vendedores e Regi�es",,_cValIncAlt)
//Ticket#2016111737000082 � Fim da altera��o
Return                                            
/*
//����������������������������������������������������������Ŀ
//�Fun��o criada para validar se o Vendedor n�o foi bloqueado�
//������������������������������������������������������������
*/
//Ivandro Santos - 22/11/16
//Ticket#2016111737000082 � Tabela | Atualiza��o (cadastro) de Vendedores
User Function RF070INAL(nOpc)
Local   _lRet  := .T.
Local _cTipoBl := "2"

   If Inclui
      _cTipoBl := GetAdvFval("SA3","A3_MSBLQL",xFilial("SA3")+M->ZX_CODVEND,1," ")
	  If _cTipoBl == "1"
	     apmsgStop("Vendedor Bloqueado... n�o pode ser usado")
	     _lRet := .F.
	  EndIf    
   EndIf
Return(_lRet)
//Ticket#2016111737000082 � Tabela | Atualiza��o (cadastro) de Vendedores                                   
