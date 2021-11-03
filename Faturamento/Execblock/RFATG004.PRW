#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATG004 ºAutor  ³Aparecida F.Stevanato º Data ³  31/10/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para acessar informações do arquivo de senhas      º±±
±±º          ³         Nome e Depto. do Usuario                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG004()

Local _cUsuario := RetCodUsr()
Local _aUsuario := {}
Local cUsuAnt   := M->ZM_MSUSER

SC5->(DbGoTop())
SC5->(DbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+M->ZM_PEDIDO))
   M->ZM_CODCLI  := SC5->C5_CLIENTE
   M->ZM_LOJACLI := SC5->C5_LOJACLI 
   SA1->(dbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
      M->ZM_CLIENTE := SA1->A1_NREDUZ
   EndIf
EndIf

If Empty(cUsuAnt)  
   M->ZM_MSUSER := UsrRetName(_cUsuario)
   PswOrder(1)
   If PswSeek(_cUsuario,.T.)
      _aUsuario   := PswRet()
      M->ZM_DEPTO := _aUsuario[1][12]
   EndIf      
EndIf   

Return  