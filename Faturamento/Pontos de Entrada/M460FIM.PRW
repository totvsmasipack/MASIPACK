#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � M460FIM    篈utor  �   Cida                     05/12/2011 罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.       Retira Separa玢o no Almoxarifado dos Itens com Saldo        北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function M460FIM()

//Alert(SD2->D2_DOC+"/"+SD2->D2_SERIE)

If SubStr(cNumEmp,1,2) == "10"       // Apenas para Fabrima
   SC6->(DbSetOrder(4))
   If SC6->(DbSeek(xFilial("SC6")+Alltrim(SD2->D2_DOC)+Space(3)+SD2->D2_SERIE)) 
      Do While ! SC6->(Eof()) .And. Alltrim(SC6->C6_NOTA) == Alltrim(SD2->D2_DOC) .And. Alltrim(SC6->C6_SERIE) == Alltrim(SD2->D2_SERIE)
         If SC6->C6_MSSEP == "S" .And. SC6->C6_QTDVEN - SC6->C6_QTDENT > 0
            RecLock("SC6",.F.)
            SC6->C6_MSSEP := "N"
            SC6->(MsUnLock())
         EndIf   
         SC6->(DbSkip())   
      EndDo
   EndIf   
EndIf

// LIMPA PRIMEIRA POSI敲O DO C5_MSLIBPV


_aArea 		:= GetArea()
_aAreaSC5	:= SC5->(GetArea())                       
lRet		:= .t.
DbSelectArea("SC5")
IF RecLock("SC5",.F.)
	SUBSTR(SC5->C5_MSLIBPV,1,1) := " "
	MsUnlock()
Endif
RestArea(_aAreaSC5)
RestArea(_aArea)
Return()  