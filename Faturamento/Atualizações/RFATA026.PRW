#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA026  �Autor  �Aparecida de F.Stevanato� Data  25/03/09 ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao na tabela SZA - Parametros de Necessidades       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA026()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
  
Private cVldOK  := "" // Validacao para grava��o. Pode-se utilizar ExecBlock.
Private cVldExc := "" // Validacao para permitir a exclusao.  Pode-se utilizar ExecBlock. 
Private _fRet   := .T. 
   
Private aRotina   := {{"Pesquisa" ,"AxPesqui"  ,0,1} ,;   // Pesquisa
   				      {"Visualiza","AxVisual"  ,0,2} ,;   // Visualiza
                      {"Altera"   ,"AxAltera"  ,0,4}}     // Altera 
                      
         
AxCadastro("SZA","Parametros de Necessidades")

Return                                                           