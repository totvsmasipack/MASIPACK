#include "totvs.ch"

/*/
@Description: Classe para envio de e-mails
@Author: Everton Diniz - DS2U
@Date: 04.10.2019
/*/

CLASS ENVMAIL

DATA oMail
DATA cEmail
DATA cSenha
DATA cServer
DATA lTLS
DATA lSSL
DATA lJob
DATA nPorta
DATA nTimeOut

    METHOD New()
    METHOD ConnMail()
    METHOD SendMail()
    METHOD DConnMail()

ENDCLASS

//Método para instanciar as variáveis
METHOD New(lJob) CLASS ENVMAIL

    ::oMail     := Nil
    ::cEmail    := GetMV("MV_RELACNT")
    ::cSenha    := GetMV("MV_RELAPSW")
    ::cServer   := SubStr(GetMV("MV_RELSERV"),1,At(":",GetMV("MV_RELSERV"))-1)
    ::lTLS      := GetMV("MV_RELTLS ")
    ::lSSL      := GetMV("MV_RELSSL ")
    ::lJob      := lJob
    ::nPorta    := Val(SubStr(GetMV("MV_RELSERV"),At(":",GetMV("MV_RELSERV"))+1))
    ::nTimeOut  := GetMV("MV_RELTIME")

Return


//Método para conectar na conta de email
METHOD ConnMail() CLASS ENVMAIL

Local lRet := .T.
Local nRet := 0

    ::oMail := TMailManager():New()
    ::oMail:SetUseSSL( ::lSSL )
    ::oMail:SetUseTLS( ::lTLS )
    
    ::oMail:Init( "", ::cServer, ::cEmail, ::cSenha, 0, ::nPorta )
    ::oMail:SetSMTPTimeout( ::nTimeOut )
    
    nRet := ::oMail:SMTPConnect()
    If nRet > 0
        lRet := .F.
        If ! ::lJob
            Help(NIL, NIL, "CONNERROR", NIL, ::oMail:GetErrorString( nRet ), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o departamento de TI"})
        Else
            Conout(Replicate("*",60))
            Conout("[Data]: " + DToC(DATE()))
            Conout("[Hora]: " + TIME())
            Conout("[CONNERROR] - Erro de conexão ao servidor de e-mails: " + Alltrim(::oMail:GetErrorString( nRet )))
            Conout("[Error Coode]: " + str(nRet ) ) 
            Conout("[Description]: " + Alltrim(::oMail:GetErrorString( nRet )))
            Conout(Replicate("*",60))
        Endif
    Endif
    
    If lRet
        nRet := ::oMail:SMTPAuth( ::cEmail, ::cSenha )
        If nRet > 0
            If ! ::lJob
                Help(NIL, NIL, "AUTHERROR", NIL, ::oMail:GetErrorString( nRet ), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o departamento de TI"})
            Else
                Conout(Replicate("*",60))
                Conout("[Data]: " + DToC(DATE()))
                Conout("[Hora]: " + TIME())
                Conout("[AUTHERROR] - Erro de conexão ao servidor de e-mail" ) 
                Conout("[Error Coode]: " + str(nRet ) ) 
                Conout("[Description]: " + Alltrim(::oMail:GetErrorString( nRet )))
                Conout(Replicate("*",60))
            Endif
            lRet := .F.
        Endif
    Endif   
    
 Return lRet


//Método para o envio de email
METHOD SendMail(cSubject, cTo, cCC, cBCC, cBody) CLASS ENVMAIL

Local lRet          := .T.
Local nRet          := 0

Default cSubject    := ""
Default cTo         := ""
Default cCC         := ""
Default cBCC        := ""
Default cBody       := ""

    If Empty( cTo ) .Or. Empty( cBody )
        If !::lJob
            Help(NIL, NIL, "VAZIO", NIL, "O destinatário e/ou conteúdo do e-mail estão vazios", 1, 0, NIL, NIL, NIL, NIL, NIL, {""})
        Endif
        lRet := .F.
    Endif

    oMessage := TMailMessage():New()
    oMessage:Clear()
    oMessage:cFrom      := ::cEmail
    oMessage:cSubject   := cSubject
    oMessage:cBody      := cBody
    oMessage:cTo        := cTo
    oMessage:cCC        := cCC
    oMessage:cBCC       := cBCC

    nRet := oMessage:Send( ::oMail )
    If ! nRet == 0
        If !::lJob
            Help(NIL, NIL, "SENDERR", NIL, ::oMail:GetErrorString( nRet ), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o departamento de TI"})
        Else
            conout("Could not send message: " + ::oMail:GetErrorString(nRet))
        Endif
        lRet := .F.
    EndIf

Return lRet


//Método para deconexão da conta do email
METHOD DConnMail() CLASS ENVMAIL

Local nRet := 0
    
    nRet := ::oMail:SMTPDisconnect()
    if ! nRet == 0
        If !::lJob
            Help(NIL, NIL, "DISCERR", NIL, ::oMail:GetErrorString( nRet ), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o departamento de TI"})
        Else
            conout("Could not disconnect from SMTP server: " + ::oMail:GetErrorString(nRet))
        Endif
    endif

Return