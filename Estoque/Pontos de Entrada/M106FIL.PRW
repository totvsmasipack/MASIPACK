#Include "Rwmake.ch"
#Include "Topconn.ch" 
#Include "PROTHEUS.CH"
/*
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �SD3240E   � Autor � Eduardo Bego Mantoan Data �  27/11/14   ���
//�������������������������������������������������������������������������͹��
//���Descricao � Filtro Gera pr�-requisi��o uniformes somente Seila         ���
//�����������������������������������������������������������������������������
*/
User Function M106FIL() 

Local cRet:= ""

_cUsuario  := RetCodUsr()

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12])) 
	
EndIf
If Upper(_cDeptoUsu) $ "ALMOXARIFADO" 
	cRet += " SUBSTR(CP_PRODUTO,1,2) <> 'UN' "
ElseIf Upper(_cDeptoUsu) $ "RESTAURANTE" 
	cRet += " SUBSTR(CP_PRODUTO,1,2) == 'UN' .OR. SUBSTR(CP_PRODUTO,1,2) == 'ML'  .OR. SUBSTR(CP_PRODUTO,1,10) =='MI01000002'     "
Else 
	cRet += "CP_PRODUTO <> '000000000000000'"
EndIf
Return cRet
