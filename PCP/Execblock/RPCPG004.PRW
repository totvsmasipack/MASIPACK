#include "rwmake.ch" 
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCPG004  �Autor  �Cecilia             � Data �  04/09/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho  que verifica B1_LOCAL de produtos "MP" e B1_LOCAL ���
���          � "2020" nao deixa cadastrar.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Masipack                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RPCPG004()

_lRet := M->G1_COMP

If SubStr(cNumEmp,1,2) $ "01_10"  	// empresa Masipack 

  If substr(M->G1_COMP,1,2) == "MP"   

     dbSelectArea("SB1")
     dbSetOrder(1)
     If dbSeek(xFilial("SB1")+M->G1_COMP) 
      
        If SB1->B1_LOCAL = " "
           MSGBOX("Materia Prima s/ Local Cadastrado !!! Informar Local !!!")  
        Endif
     Endif
  Endif
Endif   
Return(_lRet)