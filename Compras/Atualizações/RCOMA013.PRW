#Include "Rwmake.ch"  
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RCOMA013  ºAutor  ³Cecilia             º Data ³  15/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Pedido de Compras com Base no Pedido de Vendas        º±±
±±º          ³ Antigo GERA_TS (Integra)                                   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                            

User Function RCOMA013() 

   Private nItem    := 0
   Private cProd    := ""
   Private cFornece := ""
   Private cLoja    := ""
   Private cCond    := ""
   Private cTipo    := ""
   Private cContato := ""
   Private cUser    := ""
   Private cFilent  := ""
   Private cTpfrete := ""
   Private cIpibrut := ""
   Private cFluxo   := ""
   Private cConapro := ""
   Private cPenden  := ""
   Private cRetfor  := "" 
   Private dDtFat   := CTOD("")
   Private _lEnvia  := .F.
   Private _lRet    := .F. 
   Private cItemNF  := ""
   Private cSerie   := ""
   Private oDlg, oList1, oList2
   Private nList1:= 1 
   Private nList2 := 0
   Private aItems:={} 
   Private aTrats:={}
   Private nItem := 0 
   Private CRLF := CHR(13)+CHR(10)

   // Campos que serao usados para envio de e_mail
   Private _cTitulo   := ""
   Private _cDestino  := ""
   Private _cCco      := ""
   Private _cMsg      := ""
   Private _cAnexo    := "" 
   Private _cUser     := Alltrim(UsrRetName(RetCodUsr()))
   
   apmsgAlert("Para que este programa funcione corretamente, um Pedido de Compra ja deve estar cadastrado com apenas um item, o TSPROV.NIQ.")

   cTipoPV := Space(14)
   nPC     := Space(06)
   cNF     := Space(09)
   cSerie     := Space(03)    
   aTipoPV := {"Beneficiamento","Conserto"}

   @ 000,000 TO  300,500 DIALOG oDlg1 TITLE OemToAnsi("Gera Pedido de Compras - Beneficiamento/Conserto")

   @ 015,021 SAY OemToAnsi("Benef / Conserto:")          Size 055,020 
   @ 040,021 Say OemToAnsi("Pedido de Compras:")         Size 060,020 
   @ 055,021 Say OemToAnsi("Nota Fiscal........:")       Size 060,020
   @ 070,021 Say OemToAnsi("Serie Fiscal......:")        Size 060,020

   @ 015,075 ComboBox cTipoPV Items aTipoPV               Size 055,020  object oTipoPV
   @ 040,075 GET nPC Picture "999999" VALID VerificaPC()  Size 055,020
   @ 055,075 GET cNF                                      Size 055,020
   @ 070,075 GET cSerie VALID VerificaNF()                Size 055,020

   @ 100,075 BmpButton Type 1 Action _fGrava()
   @ 100,110 BmpButton Type 2 Action close(oDlg1)

   Activate Dialog oDlg1 CENTERED

Return  

Static Function _fGrava()

  aItems := {}
  aTrats := {}
  SD2->(DbSetOrder(3))
  nItem := 0
  SD2->(DbSeek(xFilial("SD2")+cNF+cSerie))
  Do WHILE SD2->D2_DOC == cNF .And. SD2->D2_SERIE == cSerie .AND. SD2->(!EOF())
     cProd := SD2->D2_COD 
     If SubStr(cTipoPV,1,1) == "B"
        SG1->(DbSetOrder(1))
        If SG1->(DbSeek(xFilial("SG1")+SD2->D2_COD))
           Do While SG1->(!Eof()) .And. Alltrim(SG1->G1_COD) == Alltrim(SD2->D2_COD)
              If SubStr(Alltrim(SG1->G1_COMP),1,2) == "TS"
                 cProd := SG1->G1_COMP
                 AADD(aItems,SD2->D2_ITEM+"-"+cProd)
              EndIf
              SG1->(DBSkip())
              Loop
           EndDo      
        Else
           IF apmsgYESNO("Produto sem estrutura. Continua?")   
		        cProd := SD2->D2_COD
  		 	     AADD(aItems,SD2->D2_ITEM+"-"+cProd)
  		 	  ENDIF   
        EndIf
     Else
        cProd := SD2->D2_COD
        AADD(aItems,SD2->D2_ITEM+"-"+cProd)
     EndIf   
     SD2->(DBSKIP())
     Loop
  EndDo
  U_EscolheTrat()
RETURN  

Static Function VerificaPC()

   _lRet := .T.

   SC7->(DbSetOrder(1))

   IF !sc7->(DBSEEK(xFilial("SC7") + nPC))
      apmsgStop("Pedido de Compras nao encontrado!")
      _lRet := .F.
   Else
      IF ALLTRIM(SC7->c7_produto) <> "TSPROV.NIQ."
         apmsgStop("Produto cadastrado no PC e diferente de TSPROV.NIQ.")
         _lRet := .F.
      ELSE
         cFornece := SC7->c7_fornece
         cLoja    := SC7->c7_loja
         cCond    := SC7->c7_cond
         cTipo    := SC7->c7_tipo
         cContato := SC7->c7_contato
         cUser    := SC7->c7_user                                                    
         cFilent  := SC7->c7_filent
         cTpfrete := SC7->c7_tpfrete
         cIpibrut := SC7->c7_ipibrut
         cFluxo   := SC7->c7_fluxo
         cConapro := SC7->c7_conapro
         cPenden  := SC7->c7_penden
         cRetfor  := SC7->c7_retfor   
      ENDIF   
   ENDIF

Return(_lRet)

Static Function VerificaNF() 

   _lRet := .T.

   SF2->(DBSetOrder(1))
   If !SF2->(DBSEEK(xFilial("SF2") + cNF+cSerie))
      apmsgStop("Nota Fiscal não encontrada - Verifique!")
      _lRet := .F.
   Else
      If SF2->F2_TIPO # "B"
         apmsgStop("A Nota Fiscal informada não se utiliza de fornecedor!")
         _lRet := .F.
      Else
         dDtFat := SF2->F2_EMISSAO 
      EndIf   
   EndIf

Return(_lRet)

User Function EscolheTrat() 

   DEFINE MSDIALOG oDlg FROM 0,0 TO 370,550 PIXEL TITLE "Selecione os Codigos para Beneficiamento/Conserto"
   oList1:= tListBox():New(10,10,{|u|if(Pcount()>0,nList1:=u,nList1)},aItems,100,150,,oDlg,,,,.T.) 
   oList2:= tListBox():New(10,170,{|u|if(Pcount()>0,nList2:=u,nList2)},aTrats,100,150,,oDlg,,,,.T.)
   @ 040,125 BUTTON "ADICIONA" SIZE 30,12 ACTION U_AddTrat()
   @ 065,125 BUTTON "REMOVE"   SIZE 30,12 ACTION U_DelTrat()
   @ 090,125 BUTTON "TODOS"    SIZE 30,12 ACTION U_Todos()    
   @ 165,170 BUTTON "Grava Pedido p/Codigos Selecionados" SIZE 100,15 ACTION U_GravaPC()
   ACTIVATE MSDIALOG oDlg CENTERED
   Return nil

Return

User Function AddTrat()

Local I := 0
   _lRet := .T.
   If Len(aTrats) > 0
      For I := 1 to Len(aTrats)
          If aItems[nList1] == aTrats[I]
             apmsgStop("Tratamento Externo já foi escolhido")
             _lRet := .F.
          EndIf
      Next I         
   EndIf
   If _lRet
      cTexto := aItems[nList1]
      AADD(aTrats,cTexto)
      oList2:Refresh()
      oList2:SetArray(aTrats)
   EndIf   

Return

User Function DelTrat()

   oList2:Del(nList2)
   oList2:Refresh()
   oList2:SetArray(aTrats)

Return

User Function Todos()

Local I := 0
   aTrats := {}
   oList2:Refresh()
   oList2:SetArray(aTrats)
   For I := 1 to Len(aItems)
       cTexto := aItems[I]
       AADD(aTrats,cTexto)
   Next I
   oList2:Refresh()
   oList2:SetArray(aTrats)

Return

User Function GravaPC()

Local nItem := 0

   SD2->(DbSetOrder(3))
   For nItem := 1 to Len(aTrats) 
       cProd := SubStr(aTrats[nItem],4,15)
       cItemNF := SubStr(aTrats[nItem],1,2)
       If nItem == 1
          SA2->(DbSetOrder(1))
          SA2->(DbSeek(xFilial("SA2")+cFornece+cLoja))
          _cTitulo  := "Masipack - Cotação de Preços para Beneficiamento de Peças"
          _cDestino := "cotacao@masipack.com.br;"
          _cDestino += Alltrim(SA2->A2_EMAIL2)
          _cCco     := ""
          _cMsg     := " <br>"+CRLF
          _cMsg     += "************************* COTAÇÃO DE PREÇOS ************************<br><br>"+CRLF
          _cMsg     += "Fornecedor: "+Alltrim(cFornece)+"/"+cLoja+" - "+Alltrim(SA2->A2_NREDUZ)+"<br>"+CRLF
          _cMsg     += "Prezado fornecedor, favor enviar cotação de preços dos itens abaixo, enviados pela nossa nota fiscal: "+Alltrim(cNF)+ " - emitida em: " + DTOC(dDtFat) +"<br>"+CRLF
         If SubStr(cNumEmp,1,2) == "01"
				_cMsg     += "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO FAX (" + Substr(SM0->M0_TEL,1,2) + ")" + Substr(SM0->M0_TEL,4,8) + "," + Substr(SM0->M0_FAX,4,8) + " (Ramal 536)<br>"+CRLF
				_cMsg     += "ou e-mail: cotacao@masipack.com.br<br>"+CRLF
			ElseIf SubStr(cNumEmp,1,2) $ "10_15" 
				_cMsg     += "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO FAX (" + Substr(SM0->M0_TEL,1,2) + ")" + Substr(SM0->M0_TEL,4,8) + "," + Substr(SM0->M0_FAX,4,8) + " (Ramal 381)<br>"+CRLF
				_cMsg     += "ou e-mail: cotacao@fabrima.com.br<br>"+CRLF
			ElseIf SubStr(cNumEmp,1,2) == "40"
				_cMsg     += "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO FAX (" + Substr(SM0->M0_TEL,1,2) + ")" + Substr(SM0->M0_TEL,4,8) + "," + "(47) 3425-0202<br>" +CRLF//Substr(SM0->M0_FAX,4,8) + " (Ramal 381)"
				_cMsg     += " <br>"+CRLF
			ElseIf SubStr(cNumEmp,1,2) == "45"
				_cMsg     += "FAVOR RETORNAR A COTAÇÃO NESTE MESMO IMPRESSO, ATRAVÉS DO FAX (" + Substr(SM0->M0_TEL,1,2) + ")" + Substr(SM0->M0_TEL,4,8) + "," + "(11) 4390-9955<br>" +CRLF//Substr(SM0->M0_FAX,4,8) + " (Ramal 381)"
				_cMsg     += " "+ CHR(13)+CHR(10)
			Endif
          
          
          _cMsg     += "<br>"+CRLF
          RecLock("SC7",.F.) 
       Else
          RecLock("SC7",.T.)
       EndIf
       SD2->(DbSeek(xFilial("SD2")+cNF+cSerie+cFornece+cLoja))
       nQtde := 0
       Do While SD2->(!Eof()) .And. SD2->D2_DOC == cNF .And. SD2->D2_SERIE == cSerie
          If SD2->D2_ITEM == cItemNF
             nQtde := SD2->D2_QUANT
             Exit
          EndIf
          SD2->(DbSkip())
       EndDo 
       SC7->c7_filial  := "01"
       SC7->c7_num     := nPC
       SC7->c7_item    := StrZero(nItem,4)
       SC7->c7_produto := cProd
       SB1->(DbSetOrder(1))
       SB1->(DbSeek(xFilial("SB1")+cProd))
       SC7->c7_um      := sb1->b1_um
       SC7->c7_quant   := nQtde
       SC7->c7_datprf  := DATE() + 1
       SC7->c7_local   := sb1->b1_locpad
       SC7->c7_obs     := "*** PV " + SD2->D2_PEDIDO + " emitido em " + DTOC(SD2->D2_EMISSAO) + ", NF: " + SD2->D2_DOC + " ***"
       SC7->c7_cc      := sb1->b1_cc
       SC7->c7_conta   := sb1->b1_conta
       SC7->c7_emissao := DATE()
       SC7->c7_descri  := sb1->b1_desc
       SC7->c7_preco   := sb1->b1_uprc
       SC7->c7_total   := SC7->c7_quant * SC7->c7_preco
       SC7->c7_tipo    := cTipo
       SC7->c7_fornece := cFornece
       SC7->c7_loja    := cLoja
       SC7->c7_cond    := cCond
       SC7->c7_contato := cContato
       SC7->c7_user    := cUser
       SC7->c7_filent  := cFilent
       SC7->c7_tpfrete := cTpfrete
       SC7->c7_ipibrut := cIpibrut
       SC7->c7_fluxo   := cFluxo
       SC7->c7_conapro := cConapro
       SC7->c7_penden  := cPenden
       SC7->c7_retfor  := cRetfor
       SC7->c7_msnf    := SD2->D2_DOC
       SC7->c7_moeda   := 1
       SC7->(MsUnLock())
       If SubStr(cTipoPV,1,1) == "B"
          SA5->(DbSetOrder(2))
          If !SA5->(DbSeek(xFilial("SA5")+cProd+cFornece+cLoja))
             RecLock("SA5",.T.)
             SA5->A5_FILIAL  := xFilial("SA5")
             SA5->A5_FORNECE := cFornece
             SA5->A5_LOJA    := cLoja
             SA2->(DbSetOrder(1))
             If SA2->(DbSeek(xFilial("SA2")+cFornece+cLoja))
                SA5->A5_NOMEFOR := SA2->A2_NOME
             EndIf   
             SA5->A5_PRODUTO := cProd
             SA5->A5_NOMPROD := SB1->B1_DESC
             SA5->(MsUnlock())
          EndIf   
       EndIf
       If SB1->B1_UPRC == 0 .Or. SB1->B1_UCOM < Date() - 365
          _lEnvia := .T. 
          _cMsg += "Produto: " + Alltrim(cProd) + " - " + Alltrim(SB1->B1_DESC)+" ==> Qtde.: "+STR(SC7->C7_QUANT,5)+"<br>"+CRLF
       EndIf   
    Next nItem
    nItem--
    apMsgInfo("Itens gravados no Pedido de Compra: " + Str(nItem))
    If _lEnvia
       _cMsg += "<br><br>No Aguardo, <br><br>"+CRLF
       _cMsg += "Eduardo p. Giannotti - Comprador<br>"+CRLF
       _cMsg += "Fone: (11)3126-3666,4178-8099<br>"+CRLF
       _cMsg += "Fax.: (11)3126-3666,4178-8099<br>"+CRLF
       _cMsg += "E-Mail: cotacao@masipack.com.br<br>"  
       _cDE		:= IIF(SM0->M0_CODIGO == '01','pedidos.masipack',IIF(SM0->M0_CODIGO == '10','pedidos','pedidos.helsimplast'))
	   _cSenha	:= IIF(SM0->M0_CODIGO == '01','Fabrima742',IIF(SM0->M0_CODIGO == '10','Fabrima17','Fabrima743'))
       oMail:= EnvMail():NEW(.F.)
       If oMail:ConnMail()
           oMail:SendMail(_cTitulo,_cDestino,_cCCo,,_cMsg)
       EndIf
       oMail:DConnMail()
    EndIf   
    oDlg:End()
   
Return
