#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA010  �Autor  �Aparecida de F.Stevanato� Data  05/03/04 ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao na tabela SZB ().                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATA010()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
  
  Private cVldAlt := "" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
  Private cVldExc := "" // Validacao para permitir a exclusao.  Pode-se utilizar ExecBlock. 
    
  Private aRotina   := {{"Pesquisa" ,"AxPesqui"  ,0,1} ,;   // Pesquisa
   					    {"Visualiza","AxVisual"  ,0,2} ,;   // Visualiza
                        {"Inclui"   ,"AxInclui"  ,0,3} ,;   // Inclui
                        {"Altera"   ,"AxAltera"  ,0,4} ,;   // Altera 
                        {"Exclui"   ,"AxDeleta"  ,0,5} }    // Exclui
                         
 cVldAlt := "U_ValidaNF(nOpc)"
 cVldExc := "U_ValidaNF(5)"                         
               
AxCadastro("SZB","Descri��o Prolongada da N.Fiscal",cVldExc,cVldAlt)

Return                                                           

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidaNF       �Autor  �MASIPACK       � Data �  11/04/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDA SE EXISTE O PRODUTO EM ITENS DA N.FISCAL            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValidaNF(nOpc)
  _cRet := .T.
  If nOpc > 3
     SD2->(DbSelectArea("SD2"))
     SD2->(DbSetOrder(1))
     If SD2->(DBSeek(xFilial("SD2")+SZB->ZB_CODIGO))
        Alert("Altera��o/Exclus�o inv�lida - Item em Nota Fiscal")
        _cRet := .T.
     EndIf
  EndIf
Return(_cRet)
