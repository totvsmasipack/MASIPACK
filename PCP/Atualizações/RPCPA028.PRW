#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RPCPA028  ºAutor  ³Aparecida F.Stevanato º Data ³  15/03/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza Data de Liberação do PCP                           º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                                                                              
User Function RPCPA028()

PRIVATE titulo    := ""
PRIVATE cString   := "SC6"
PRIVATE tamanho   := "M"
PRIVATE wnrel     := "RPCPA028"
PRIVATE aOrd      := ""
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
PRIVATE nomeprog  := "RPCPA028"
PRIVATE cPerg	  := "PCPA28"
PRIVATE nLastKey  := 0 
PRIVATE CbTxt     := ""
PRIVATE cabec1    := ""
PRIVATE cabec2    := ""
PRIVATE m_pag     := 0
PRIVATE Li        := 80
PRIVATE limite    := 132
PRIVATE nImp      := 0

Private fRet := .T. 

aOpcao   := {"Libera p/OPs","Retira Liberação","Relaçao de Liberação"}
cOpcao   := Space(20)
cPedido  := Space(6)
cItem    := Space(2)
DEFINE MSDIALOG _oDlg1 FROM  090,1 TO 330,330 TITLE "Atualiza Data de Liberação" PIXEL  
@ 010,030 Say "Esta rotina Atualiza Data de Liberação do PCP"        Size 151,010 OF _oDlg1 PIXEL
@ 020,000 Say Replicate("_",100)                                     Size 200,010 PIXEL COLOR CLR_HBLUE	
@ 040,024 Say "Opção........................... : "                  Size 065,006 PIXEL COLOR CLR_HBLUE	
@ 055,024 Say "Pedido de Vendas : " 						         Size 055,006 PIXEL COLOR CLR_HBLUE	
@ 070,024 Say "Item do Pedido.........: (Brancos p/Todos)" 	         Size 055,006 PIXEL COLOR CLR_HBLUE	
@ 040,075 ComboBox cOpcao Items aOpcao                               Size 070,010 OBJECT oOpcao
@ 055,075 MsGet cPedido F3 "SC5"                                     Size 045,010 PIXEL OF _oDlg1
@ 070,075 MsGet cItem   Valid ValidaPedido()                         Size 025,010 PIXEL OF _oDlg1
@ 095,080 BmpButton Type 1 Action Processa( { || AtuLibPCP() } )
@ 095,115 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1  Centered
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AtuLibPCP        º  Atualiza data de Liberacao do PCP       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuLibPCP()

SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))

If SubStr(cOpcao,1,3) <> "Rel"
   If !Empty(cPedido)
      If ! apMsgYESNO("Confirma Atualização ?")
         Return
      EndIf
   Else
      ApMsgInfo("Informe o Numero do Pedido" + cPedido) 
      Return
   EndIf      
EndIf

If SubStr(cOpcao,1,3) == "Rel"
   If !Pergunte(cPerg,.T.)
      Return
   Else
      ImpPedidos()
   EndIf   
Else   
   If !Empty(cItem) 
      If SC6->C6_PRODUTO <> "PEDIDO"
         RecLock("SC6",.F.)
         If SubStr(cOpcao,1,3) == "Lib"
            SC6->C6_MSPCP := Date()
         Else
            SC6->C6_MSPCP := CTOD("")
         EndIf
         SC6->(MsUnLock()) 
      Else
         ApMsgInfo("Este Item não pode ser Liberado: PEDIDO")
         fRet := .F. 
      EndIf      
   Else
      SC6->(DbSeek(xFilial("SC6")+cPedido))
      Do While SC6->(!Eof()) .And. SC6->C6_NUM == cPedido 
         If Alltrim(SC6->C6_PRODUTO) <> "PEDIDO"
            RecLock("SC6",.F.)
            If SubStr(cOpcao,1,3) == "Lib"
               If Empty(SC6->C6_MSPCP) .Or. DTOC(SC6->C6_MSPCP) == "31/12/49"
                  SC6->C6_MSPCP := Date()
               EndIf   
            Else
               If !Empty(SC6->C6_MSPCP) 
                  SC6->C6_MSPCP := CTOD("")
               EndIf
            EndIf
            SC6->(MsUnLock())   
         EndIf   
         SC6->(DbSkip())
      EndDo      
   EndIf   
EndIf

If SubStr(cOpcao,1,3) <> "Rel"
   If fRet
      apMsgInfo("Atualizacão Efetuada com sucesso !!!!")
   Else 
      apMsgStop("Não Houve Atualização do Pedido !!!!")    
   EndIf   
EndIf 

cPedido  := Space(6)
cItem    := Space(2) 

Return

Static Function ValidaPedido() 
   SC5->(DbSetOrder(1))
   SC6->(DbSetOrder(1))
   fRet := .T. 
   If SubStr(cOpcao,1,3) <> "Rel"
      If SC5->(DbSeek(xFilial("SC5")+cPedido))
         If !SC6->(DbSeek(xFilial("SC6")+cPedido))
            ApMsgAlert("Pedido não encontrado (SC6): " + cPedido)
            fRet := .F.      
         Else
            If !Empty(SC5->C5_NOTA)
               ApMsgAlert("Pedido já faturado !!!")
               fRet := .F.
            EndIf   
         EndIf
      Else   
         ApMsgAlert("Pedido não encontrado (SC5): " + cPedido)
         fRet := .F.
      EndIf
      If fRet
         If !Empty(cItem)
            If !SC6->(DbSeek(xFilial("SC6")+cPedido+cItem))
               ApMsgAlert("Item do Pedido não encontrado: " + cPedido) 
               fRet := .F.
            Else
               If SubStr(cOpcao,1,3) == "Lib" 
                  If !Empty(SC6->C6_MSPCP) .And. DTOC(SC6->C6_MSPCP) <> "31/12/49"
                     ApMsgAlert("Item do Pedido já Liberado " + cPedido) 
                     fRet := .F.
                  EndIf
               ElseIf SubStr(cOpcao,1,3) == "Ret" 
                  If Empty(SC6->C6_MSPCP) .Or. DTOC(SC6->C6_MSPCP) == "31/12/49"
                     ApMsgAlert("Item do Pedido não está Liberado " + cPedido) 
                     fRet := .F.
                  EndIf
              EndIf         
            EndIf
         EndIf   
      EndIf   
   EndIf
   If !fRet
       fRet := .T.
       cPedido := Space(6)
       cItem   := Space(2)
   EndIf               
Return fRet 

Static Function ImpPedidos()

Li := 80

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,,,,.F.,aOrd,,Tamanho)

If nLastKey==27
   Set Filter to
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
   Set Filter to
   Return
Endif

titulo    := "Relacao da Liberação dos Pedidos pelo PCP - "
cabec1    := "Pedido/Item  Ctg  Usuario    Emissão   Produto                                                 Qtde.       Qtde.  Liberação  Liberado em:" 
cabec2    := "                                                                                               Pedida    Entregue"

If mv_par04 == 1
   titulo += "Liberados"
ElseIf mv_par04 == 2
   titulo += "Sem Liberação"
ElseIf mv_par04 == 3
   titulo += "Ambos"
EndIf

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)

If aReturn[5] = 1
   Set Printer To
   dbCommitAll()
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ImpRel()

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf 

If !Empty(mv_par03) .And. SubStr(mv_par03,1,2) <> "ZZ"
   _cQuery := "SELECT C5_NUM, C5_EMISSAO, C5_TIPO, C5_MSCATEG, C5_NOTA, C5_MSNOUSU "
   _cQuery += "FROM " + RetSqlName("SC5") + " C5 "
   _cQuery += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUM = '"  + mv_par03 + "' AND C5_TIPO = 'N'" 
   _cQuery += "  AND D_E_L_E_T_ = ' ' "
Else   
   _cQuery := "SELECT C5_NUM, C5_EMISSAO, C5_TIPO, C5_MSCATEG, C5_NOTA, C5_MSNOUSU "
   _cQuery += "FROM " + RetSqlName("SC5") + " C5 "
   _cQuery += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_EMISSAO Between '"+ Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'" 
   _cQuery += "  AND C5_TIPO = 'N'"
   _cQuery += "  AND D_E_L_E_T_ = ' ' "
   _cQuery += "ORDER BY C5_NUM "
EndIf       

//Alert(_cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.) 

nImp := 0 

If Alltrim(mv_par05) == ""
   mv_par05 := "1235"
EndIf   

SB1->(dbSetOrder(1))
SC6->(dbSetOrder(1))
SC6->(DbGoTop())

Do While QR1->(!Eof())
   If lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"  // STR0021    
		Exit
   EndIf
    
   If Alltrim(QR1->C5_NOTA) <> "" .Or. (!(QR1->C5_MSCATEG $ mv_par05) .OR. SubStr(cNumEmp,1,2) $ "15_40_45")
      QR1->(dbSkip())
      Loop
   EndIf
   
   If SC6->(dbSeek(xFilial("SC6")+QR1->C5_NUM))
      Do While SC6->(!Eof()) .AND. SC6->C6_NUM == QR1->C5_NUM 
         If Alltrim(SC6->C6_PRODUTO) <> "PEDIDO"
            If (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
               If mv_par04 == 3 .Or. (mv_par04 == 1 .And. !Empty(SC6->C6_MSPCP) .And. SC6->C6_MSPCP <> CTOD("31/12/49")) .Or. (mv_par04 == 2 .And. Empty(SC6->C6_MSPCP) .Or. SC6->C6_MSPCP == CTOD("31/12/49"))
                  If Li > 60
	                 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	              EndIf
	              @ Li,000 Psay SC6->C6_NUM + "/" + SC6->C6_ITEM 
	              If SubStr(cNumEmp,1,2) $ "01_10"
	              		@ Li,014 Psay QR1->C5_MSCATEG 
	              EndIf
	              @ Li,018 Psay SubStr(QR1->C5_MSNOUSU,1,10)
	              SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
	              @ Li,029 Psay STOD(QR1->C5_EMISSAO)
                  @ Li,039 Psay Alltrim(SC6->C6_PRODUTO) + "-" + SubStr(SB1->B1_DESC,1,32)
                  @ Li,093 Psay SC6->C6_QTDVEN Picture "@E 999.999" 
                  @ Li,105 Psay SC6->C6_QTDENT Picture "@E 999.999" 
                  If Empty(SC6->C6_MSPCP) .Or. DTOC(SC6->C6_MSPCP) == "31/12/49"
                     @ Li, 114 Psay "A Liberar"
                  Else
                     @ Li, 114 Psay "Liberado"
                  EndIf
                  If !Empty(SC6->C6_MSPCP)   
                     @ Li,125 Psay SC6->C6_MSPCP
                  EndIf
                  nImp++   
                  Li++
               EndIf   
            EndIf   
         EndIf   
	     SC6->(dbSkip())
	  EndDo   
   EndIf
   QR1->(DbSkip())
EndDo

If nImp == 0
   apMsgStop("Não Houve Itens Impressos - Verifique parametros !!!!")    	 
EndIf   

Return
  