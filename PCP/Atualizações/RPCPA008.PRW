#Include "Protheus.ch"
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPA008  ºAutor  ³Jose Roberto Funari                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida produto para abertura de OP´s                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "Rwmake.ch"

User Function RPCPA008()

Private _lRet    := .T.
Private cCod     := ""
Private nItens   := 0
Private _dDtEmi  := CTOD("")
Private _cNum    := ""
Private _cProced := ""
Private _cItem   := ""
Private _cSeq    := "" 
Private _cUser   := ""

cCod := M->C2_PRODUTO
If SubStr(cNumEmp,1,2) == "01"
	_cProced := GetAdvFval("SB1","B1_PROCED",xFilial("SB1")+cCod,1," ")
	
	If !(SubStr(_cProced,1,1)=='1')
		apmsgStop("Produto Comprado ou importado não pode ser fabricado!")
		_lRet := .F.
	EndIf
Endif

SG1->(DbSetOrder(1))
If !SG1->(DbSeek(xFilial("SG1")+cCod))
   apmsgStop("Produto sem Estrutura não pode ser fabricado!")
   _lRet := .F.
ELSE
   IF SUBSTR(cNumEmp,1,2) $ "01_10" // MASIPACK
      sb1->(DBSEEK(xFilial("SB1") + cCod))
      IF ALLTRIM(sb1->b1_um) == "CJ"
         M->C2_MSLISTA := "S"
      ELSE
         M->C2_MSLISTA := "N"
      ENDIF      
   ENDIF
   Do While ! SG1->(Eof()) .AND. SG1->G1_COD == cCod
      IF SubStr(SG1->G1_COMP,1,2) <> "CL"
         nItens := 9
      Else   
         nItens++
      EndIf
      SG1->(DbSkip())
   Enddo
   If nItens == 1
      ApMsgAlert("À partir de 20/01/07 não será possível abrir OP para este código - Falar com Projetos")
   EndIf
    
   If Select("QR1") > 0 
      DbSelectArea("QR1")
      DbCloseArea()
   EndIf
     
   _cQuery := "SELECT C2_EMISSAO, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_DATRF, C2_QUANT, C2_USERLGI "
   _cQuery += "FROM " + RetSqlName("SC2") + " C2 "
   _cQuery += "WHERE C2_FILIAL = '" + xFilial("SC2") + "' AND C2_PRODUTO = '" + cCod + "'" 
   _cQuery += "  AND D_E_L_E_T_ = ' ' "
   _cQuery += "ORDER BY C2_EMISSAO " 

   //alert(_cQuery)
   
   TcQuery _cQuery New Alias "QR1"
   
   TcSetField("QR1","C2_EMISSAO" ,"D",08,0)
   TcSetField("QR1","C2_DATRF"	 ,"D",08,0)
      
   _dDtEmi := CTOD("")
   Do While ! QR1->(Eof())
      If Empty(QR1->C2_DATRF) .And. QR1->C2_EMISSAO > Date() - 3
         _cNum   := QR1->C2_NUM
         _cItem  := QR1->C2_ITEM
         _cSeq   := QR1->C2_SEQUEN
         _dDtEmi := QR1->C2_EMISSAO 
         _nQtde  := QR1->C2_QUANT 
         _cUser  := Substr(Embaralha(QR1->C2_USERLGI,1),1,13)
      EndIf   
      QR1->(DbSkip())
   EndDo
   If !Empty(_dDtEmi) 
      apmsgAlert("Ultima OP emitida para este produto => " + _cNum + _cItem + _cSeq + " em: " + DTOC(_dDtEmi) + " por: " + _cUser + " - Qtde: " + Str(_nQtde,4))
   EndIf    
ENDIF
        
Return _lRet
