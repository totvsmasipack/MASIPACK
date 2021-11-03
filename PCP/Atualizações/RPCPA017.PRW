#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RPCPA017  ºAutor  ³Aparecida F.Stevanato º Data ³  16/06/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia email dos Pedidos não liberados pelo PCP              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCPA017(aParam)

Local I 
   Private _dDtFin  := Date()
   Private _aPedidos:= {}
   Private _cUsuAnt := ""                                                      
   Private _cEmail  := ""
   Private _cNome   := ""
   Private _lFirst  := .T. 

   // Campos que serao usados para envio de e_mail
   Private _cTitulo   := ""
   Private _cDestino  := ""
   Private _cCco      := ""
   Private _cMsg      := ""
   Private _cAnexo    := ""
 
   RPCSETTYPE(3)
   If FINDFUNCTION('WFPREPENV')
      WFPREPENV(APARAM[1],APARAM[2])
   Else
      PREPARE ENVIRONMENT EMPRESA APARAM[1] FILIAL APARAM[2]
   EndIf

   If Select("QR1") > 0 
      DbSelectArea("QR1")
      DbCloseArea()
   EndIf 

   _dDtFin := _dDtFin - 3

   If Dow(_dDtFin) == 1
      _dDtFin -= 1
   ElseIf Dow(_dDtFin) == 7
      _dDtFin -= 2
   EndIf

   _cQuery := "SELECT C5_NUM, C5_EMISSAO, C5_TIPO, C5_MSCATEG, C5_NOTA, C5_MSUSER "
   _cQuery += "FROM " + RetSqlName("SC5") + " C5 "
   _cQuery += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_EMISSAO <= '"+ Dtos(_dDtFin) +"' AND C5_NOTA = ''" 
   _cQuery += " AND C5_TIPO = 'N'  "
   If SubStr(cNumEmp,1,2) $ "01_10"
      _cQuery += " AND C5_MSCATEG  IN ('2','3','5')" 
   EndIf
   _cQuery += " AND D_E_L_E_T_ = ' ' "
   _cQuery += "ORDER BY C5_MSUSER, C5_NUM "

   DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.) 

   _aPedidos := {}

   SB1->(dbSetOrder(1))
   SC6->(dbSetOrder(1))
   SC6->(DbGoTop())

   _cTitulo  := "Pedidos sem Liberação para o PCP"

   Do While QR1->(!Eof())
      
      If _lFirst
         _cUsuAnt := Alltrim(QR1->C5_MSUSER)
         _lFirst := .F.
      EndIf   
      
      If Alltrim(QR1->C5_MSUSER) <> _cUsuAnt
         If Len(_aPedidos) > 0
            PswOrder(1)
            If PswSeek(_cUsuAnt)
               _cEmail := Alltrim(UsrRetMail(_cUsuAnt))+";"
               _cNome  := UsrRetName(_cUsuAnt)
            ElseIf SubStr(cNumEmp,1,2) $ "01_10"
               _cNome  := "Usuario Demitido" 
               If QR1->C5_MSCATEG == "2"
                  _cEmail := "comex@masipack.com.br"
               ElseIf QR1->C5_MSCATEG == "3"
                  _cEmail := "acessorios@masipack.com.br"
               ElseIf QR1->C5_MSCATEG == "5"
                  _cEmail := ""
               EndIf
            Else
            EndIf              
            _cMsg  := Alltrim(_cNome) + ", Os Pedidos/Itens abaixo ainda não estão liberados para Produção - Fale com o PCP:"+CHR(13)+CHR(10)
            _cMsg  += CHR(13)+CHR(10)
            For I := 1 to Len(_aPedidos)
               SB1->(DbSeek(xFilial("SB1")+Alltrim(_aPedidos[I][2])))
               _cMsg += _aPedidos[I][1] + " Produto: " + Alltrim(_aPedidos[I][2]) + "-" + SB1->B1_DESC + CHR(13)+CHR(10)
            Next I    
            _cDestino := _cEmail + "pcp@masipack.com.br"
            oMail:= EnvMail():NEW(.F.)
               If oMail:ConnMail()
                  oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
               EndIf
            oMail:DConnMail()
            _aPedidos := {}
         EndIf  
         _cUsuAnt := Alltrim(QR1->C5_MSUSER)
         SC6->(DbgoTop())
      EndIf   
                                                                                 
      If SC6->(dbSeek(xFilial("SC6")+QR1->C5_NUM))
         Do While SC6->(!Eof()) .AND. SC6->C6_NUM == QR1->C5_NUM 
            If Alltrim(SC6->C6_PRODUTO) <> "PEDIDO"
               If (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
                  If Empty(SC6->C6_MSPCP) .Or. SC6->C6_MSPCP == CTOD("31/12/49")
                     AADD(_aPedidos,{SC6->C6_NUM+"/"+ SC6->C6_ITEM,SC6->C6_PRODUTO})
               EndIf   
               EndIf   
            EndIf
            SC6->(dbSkip())
      EndDo   
      EndIf
      QR1->(DbSkip())
   EndDo

   If Len(_aPedidos) > 0 
      _cEmail := Alltrim(UsrRetMail(_cUsuAnt))+";"
      _cNome  := UsrRetName(_cUsuAnt)
      _cMsg := Alltrim(_cNome) + ", Os Pedidos/Itens abaixo ainda não estão liberados para Produção - Fale com o PCP:"+CHR(13)+CHR(10)
      _cMsg += CHR(13)+CHR(10)
      For I := 1 to Len(_aPedidos)
         SB1->(DbSeek(xFilial("SB1")+Alltrim(_aPedidos[I][2])))
         _cMsg += _aPedidos[I][1] + " Produto: " + Alltrim(_aPedidos[I][2]) + "-" + SB1->B1_DESC + CHR(13)+CHR(10)
      Next I    
      _cDestino := _cEmail + "pcp@masipack.com.br"
      oMail:= EnvMail():NEW(.F.)
         If oMail:ConnMail()
            oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
         EndIf
      oMail:DConnMail()
   EndIf   

Return  