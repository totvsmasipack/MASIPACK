#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Rwmake.ch"       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA062  �Autor  � Lizandra Marques	  � Data �  21/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera C5_MSPOSIC de acrdo com a necessidade do usuario    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA062()

cCadastro := "Alter�ao da posi�a� do PV"
aRotina   := { {"Pesquisa",     "AxPesqui",           0, 1 },;
               {"Visualiza",    "AxVisual",           0, 2 },;
               {"Altera",     'ExecBlock("GLLIB1")', 0, 3 } } 

mBrowse(8,03,20,75,"SC5",,,,)
return

User Function GLLIB1()
cC5Posic  := SC5->C5_MSPOSIC 

@ 0,0 TO 150,600 DIALOG oDlg1 TITLE "Dados Complementares do PV"
@ 10,10  SAY "Pedido : "+SC5->C5_NUM + "         " + Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
@ 30,10  SAY "Posi��o: "
@ 30,65  GET cC5Posic    SIZE 150,200

@ 50,90  BUTTON "_Ok"   SIZE 35,15 ACTION GLLIB2()// Substituido pelo assistente de conversao do AP5 IDE em 06/07/01 ==> @ 90,60 BUTTON "_Ok"   SIZE 35,15 ACTION Execute(MRDSAI2)
@ 50,140 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return

Static Function GLLIB2()
   RecLock("SC5",.F.)
   C5_MSPOSIC := cC5Posic
   MsUnlock()
   Close(oDlg1)
return(.t.)