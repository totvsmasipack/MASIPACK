#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFINA007  �Autor  �Cecilia             � Data �  17/07/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajuste das Aplicacoes                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function RFINA007()

cCadastro := "Atual.Aplica�oes/Empr�st."

aCores := {	{ "SEH->EH_STATUS == 'A'", "BR_VERDE"  },;
            { "SEH->EH_STATUS == 'B'", "BR_VERMELHO"   }}
                    
// Matriz com botoes de opcao
aRotina  := { {"Pesquisar"   ,"AxPesqui"  ,0,1},;
               {"Visualizar" ,"AxVisual",0,2},;
               {"Alterar"    ,"U_RFINA005()",0,4}}
             
_cArq     := CriaTrab(Nil,.f.)
_cChave   := "SEH->EH_NUMERO+SEH->EH_REVISAO"
_cFiltro1 := ("SEH->EH_REVISAO = '01'") 
_cFiltro  := _cFiltro1
IndRegua("SEH",_cArq,_cChave,,_cFiltro ,"") 
dbSelectArea("SEH")

// Monta browse atraves da funcao mBrowse
mBrowse(6,1,22,74,"SEH",,,,,,aCores)
Return
             
