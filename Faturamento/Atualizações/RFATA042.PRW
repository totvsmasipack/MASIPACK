#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA042  �Autor  �Cecilia             � Data �24/08/2009   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao dos campos sem permissao de acesso.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Masipack                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RFATA042()

Local I

_aArea   := GetArea()
Private _cUsuario   := RetCodUsr()
Private _aUsuario   := {}
Private _aGrupos    := {}
Private _cGrupo     := ""

_lRet    := .t.      

_cUsuario  := RetCodUsr()

If SubStr(cNumEmp,1,2) $ "01_10"  	// empresa Masipack e Fabrima 
   PswOrder(1)
   If PswSeek(_cUsuario,.T.)
      _aGrupos  := PswRet(1)[1][10]
   EndIf 

  For I := 1 to Len(_aGrupos)
     _cGrupo := GrpRetName(_aGrupos[I])
     If Alltrim(_cGrupo) == "Vendas02" .or. Alltrim(_cGrupo) == "Fabrima_Vendas02"
        MsgBox("Usuario sem permiss�o para Alterar !!!")	    
        _lRet := .f.
     EndIf   
   Next I  
Endif                                                           
 
RestArea(_aArea)

Return (_lRet)