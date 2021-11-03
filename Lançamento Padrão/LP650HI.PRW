#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP650HI  ºAutor  ³Cida                º Data ³  24/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna Historico em Lancamento Padrao 650                 º±±
±±º          ³ de acordo com a sequencia do Lançamento                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack/Fabrima                                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                                                               
User Function LP650HI(_nSeq)

Private _cHistor := ""
Private _cCliFor := ""
Private _cCompl  := ""

// _nSeq => Sequencia dos lançamentos

If SD1->D1_TIPO $ "B_D"
   SA1->(DbSetOrder(1))
   If SA1->(DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA))
      _cCliFor := Alltrim(SA1->A1_NREDUZ)
   EndIf
Else
   SA2->(DbSetOrder(1))
   If SA2->(DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
      _cCliFor := Alltrim(SA2->A2_NREDUZ)
   EndIf 
EndIf

_cHistor := "CFOP " + Alltrim(SD1->D1_CF) + " "

If _nSeq == 4
   _cHistor += "PIS/COF/CSLL "
ElseIf _nSeq == 5
   _cHistor += "ISS "
ElseIf _nSeq == 6
   _cHistor += "INSS "
ElseIf _nSeq == 7
   _cHistor += "IRRF " 
ElseIf _nSeq == 8
   _cHistor += "FRETE "
ElseIf _nSeq == 9
   _cHistor += "SEGURO "
ElseIf _nSeq == 10
   _cHistor += "DESPESAS "
ElseIf _nSeq == 11
   _cHistor += "ICMS " 
ElseIf _nSeq == 12
   _cHistor += "IPI "
ElseIf _nSeq == 13
   _cHistor += "PIS "
ElseIf _nSeq == 14
   _cHistor += "COFINS "
EndIf   
            
If SD1->D1_TES $ "074_075"
   _cHistor += "REL.DESP "
Else   
   If SD1->D1_TIPO $ "D"
      _cHistor += "DEV "
      If !Empty(SD1->D1_NFORI)
         _cCompl  += " - NFS " + Alltrim(SD1->D1_NFORI)
      EndIf   
   Else  
      _cHistor += "NF. "
   EndIf   
EndIf 
_cHistor += Alltrim(SD1->D1_DOC) + "-"+_cCliFor+_cCompl 

Return(_cHistor)
