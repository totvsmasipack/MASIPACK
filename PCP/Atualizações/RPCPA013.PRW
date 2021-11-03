/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RPCPA013  ºAutor  ³Ana Paula QFaustino º Data 29/11/2011    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao na tabela SZ0 - Gerenciador de Desenhos          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#Include "Rwmake.ch"

User Function RPCPA013()

Local aArea        := GetArea()

Private _cUsuario  := ""
Private _aUsuario  := {}
Private _cUsuSenha := {}
Private _cDeptoUsu := {}

Private aRotina    := {}
Private cCadastro  := "Gerenciador de Impressao"
Private cUsuario

cUsuario := AllTrim(Substr(cUserName,1,15))

_cUsuario  := RetCodUsr()

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cUsuSenha	:= UsrRetName(_cUsuario)
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
EndIf

aAdd( aRotina, { "Pesquisar"  , "AxPesqui"  , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "AxVisual"  , 0 , 2 })
aAdd( aRotina, { "Excluir"    , "U_PCPA13exc" , 0 , 5 })

UsrRetName(_cUsuario)
RetCodUsr()

IF "INFORMATICA" $ _cDeptoUsu .or. "QUALIDADE" $ _cDeptoUsu    	// Se for Informatica ou Qualidade
	dbSelectArea("SZ0")
	dbSetOrder(1)
	dbGoTop()
Else
	dbSelectArea("SZ0")
	dbSetOrder(1)
	Set Filter To Alltrim(SZ0->Z0_USUARIO) == cUSUARIO
	dbGoTop()
EndIf

mBrowse(6,1,22,75,"SZ0")

RestArea(aArea)

Return

/****************************************/
User Function PCPA13exc()

Local lRet

lRet := .T.

If Alltrim(SZ0->Z0_USUARIO) == cUsuario
	If SZ0->Z0_STATUS = 'I'
		RecLock("SZ0",.F.,.T.)
		DBDelete()
		MSUnlock()    
	Else
		MsgStop("Desenho ainda nao foi Impresso!")
	EndIf
	//MsgStop("Exclusão Concluída com sucesso!")
Else
   MsgStop("Usuario nao pode excluir desenho, pois nao foi gerado por ele.")
EndIf   

Return
