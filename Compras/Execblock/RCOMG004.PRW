#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RCOMG004  ºAutor  ³                    º Data ³14/06/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Preco com o Pedido de Compras  (Pre-Nota)           º±±
±±º          ³ Esta Rotina sera chamada nos pontos MT110LOK e MT140LOK    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMG004()

Private nPosPed, nPosItem, nPosVlum, nPostes, nPosDel, nPosCod, nPosCFOP 
Private _lRet    := .T.
Private _nPreco  := 0
Private _cRotina := "" 
Private _nQtde   := 0

If SF1->F1_TIPO <> "N"
   Return .T. 
EndIf 

_cRotina := FunName() 
alert(_crotina)

nPosDel  := Len(aHeader) + 1     
nPosPed  := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_PEDIDO" }) 
nPosItem := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_ITEMPC" }) 
nPosVlun := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_VUNIT" }) 
nPosTes  := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_TES" })
nPosCod  := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_COD" })
nPosCFOP := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_CF" })
nPosQtde := aScan(aHeader,{|x| UPPER(AllTrim(x[2])) == "D1_QUANT" })

If !(Acols[n,nPosDel]) 
   If !Empty(Acols[n,nPosPed])
      SC7->(dbSetOrder(14))
      If MsSeek(xFilial("SC7")+Acols[n,nPosPed]+Acols[n,nPosItem])
         IF Acols[n,nPosQtde] <> SC7->C7_QUANT .AND. Alltrim(SC7->C7_UM) <> "KG" .AND. ALLTRIM(SC7->C7_UM) <> "M" .AND. ( AllTrim(posicione("SB1",1,xFilial("SB1")+Acols[n,nPosProd],"B1_GRUPO")) <> "0190" )
            apmsgAlert("QUANTIDADE DIFERENTE DO PEDIDO, VERIFIQUE COM O DEPARTAMENTO DE COMPRAS!!!")
            _lRet := .F.
         ENDIF   
         If SC7->C7_MOEDA == 1 
            _nPreco := SC7->C7_PRECO 
//            If Acols[n,nPosVlun] > (_nPreco * 1.001) //.OR. Acols[n,nPosVlun] < (_nPreco * 0.99)  
//               Msgbox("VALOR DIFERENTE DO PEDIDO, VERIFIQUE COM O DEPARTAMENTO DE COMPRAS!!!","AVISO","STOP")
//               _lRet := .F.
//            EndIf
         Else
            _nPreco := SC7->C7_PRECO * SC7->C7_TXMOEDA//RecMoeda(DDEMISSAO,SC7->C7_MOEDA)
            
//            If Acols[n,nPosVlun] > (_nPreco * 1.001) //.OR. Acols[n,nPosVlun] < (_nPreco * 0.99) 
//               Msgbox("VALOR DIFERENTE DO PEDIDO, VERIFIQUE COM O DEPARTAMENTO DE COMPRAS!!!","AVISO","STOP")
//               _lRet := .F.
//            EndIf	
         EndIf
      Endif  
   Else
      If _cRotina == "MATA110"   
         SF4->(DbsetOrder(1))
         If DbSeek(xFilial("SF4")+Acols[n,nPosTes],.T.) .and. SF4->F4_UPRC == "S"
            If SubStr(Acols[n,nPosCFOP],2,3) $ "101_102"
               If SB1->(DbSeek(xFilial("SB1")+Acols[n,nPosCod]))
                  If SB1->B1_UPRC > 0 .And. Acols[n,nPosVlun] > (SB1->B1_UPRC * 1.1)
//                     Msgbox("Valor do Item incoerente com o Ultimo Preço de Compra - Verifique com Depto. de Compras!!!","AVISO","STOP")
  //                   _lRet := .F.
                  EndIf
               EndIf   
            EndIf    
         EndIf    
      EndIf
   EndIf   
EndIf

Return(_lRet)
