#include "protheus.ch"

/*/
{protheus.doc}
@Description: Fonte utilizado no ponto de entrada MT120GRV para enviar e-mails de prazo de entregas alterados.
@Author: Everton Diniz
@Date: 16.10.2019
@version: 1.0
@param:
/*/
User Function RCOMG013(cNumPed)

Local aAreaSC7  := SC7->(GetArea())
Local cBody     := ""
Local cTo       := ""
Local cSubject  := ""
Local cUser     := Alltrim(UsrRetName(RetCodUsr()))
Local lContinua := .F.
Local nPosCod   := 0
Local nPosItem  := 0
Local nPosPrz   := 0
Local nPosPrc   := 0
Local nX        := 0
Local oMail

    nPosCod  := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PRODUTO"    })
    nPosItem := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_ITEM"       })
    nPosPrc  := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_PRECO"      })
    nPosPrz  := aScan(aHeader,{|x| Alltrim(x[2]) == "C7_DATPRF"     })
    
    SB1->(dbSetOrder(1))
    SC1->(dbSetOrder(1))
    SC7->(dbSetOrder(1))

    //Inicio a preparação das tags HTML
    cBody := "<html>"
    cBody +=	"<body>"
    cBody += 		"Alteração de Prazo de Entrega - Pedido de Compra <br>" + CRLF
    cBody += + CRLF
    cBody += 	 	"Pedido: " + cNumPed + " - Usuario: "+ cUser + "<br>" + CRLF
    cBody += 	 	"Item(s) Alterados: <br>" + CRLF
    cBody += + CRLF

    For nX := 1 To Len(aCols)

        If ! aCols[nX][Len(aHeader)+1]

            //******************************************
            //* Grava-se o último preço do produto      
            //******************************************
            If SB1->(dbSeek(FWxFilial("SB1") + aCols[nX][nPosCod]))
                Reclock("SB1",.F.)
                SB1->B1_MSPRCRE := Round(aCols[nX][nPosPrc],TamSX3("B1_MSPRCRE")[2])
                SB1->(MSunlock())
            Endif

            If SC7->(DbSeek(FWxFilial("SC7") + cNumPed + aCols[nX][nPosItem]))

                If (DToS(aCols[nX][nPosPrz])) > DToS(SC7->C7_DATPRF)

                    lContinua := .T.
                    
                    cBody += "		Produto: " + Alltrim(SC7->C7_PRODUTO) + " - " + Alltrim(SC7->C7_DESCRI) + "<br>" + CRLF
                    cBody += "		Data Alterada de: " + DTOC(SC7->C7_DATPRF) + " | Para: " + DTOC(aCols[nX][nPosPrz]) + "<br>" + CRLF
                    
                    If SC1->(DbSeek(FWxFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC))
                        cBody += "      SC: " + SC7->C7_NUMSC + "/" + SC7->C7_ITEMSC + "  Emissão: " + DTOC(SC1->C1_EMISSAO) + "  Entrega: " + DTOC(SC1->C1_DATPRF) + "  Emitente: " + SC1->C1_SOLICIT + "<br>" + CRLF
                    Endif
                    
                Endif

            Endif

        Endif

    Next nX

    cBody += "	</body>"
    cBody += "</html>"

    If lContinua
        
        cSubject := "Alteração de Prazo em Pedido de Compra"
        cTo := GetMV("MS_ALTPC")
        
        If !Empty(cTo)
            oMail:= EnvMail():New(.F.)
            If oMail:ConnMail()
                oMail:SendMail(cSubject,cTo,,,cBody)
            EndIf
            oMail:DConnMail()
        Endif

    Endif

    RestArea(aAreaSC7)

Return .T.
