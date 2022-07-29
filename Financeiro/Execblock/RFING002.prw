#include "TOTVS.CH"
#include "PROTHEUS.CH"

/*------------------------------------------------------------------------------------------------------*
 | Programa:  RFING002                                                                                  |
 | Desc:  Este programa tem como objetivo filtrar pedidos de compras vinculados a PA pela rotina        |
 |        FINXAPI Vinculos sao gravados na tabela FIE                                                   |
 |                                                                      								|
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Jul.2022																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function RFING002()

Local oDlg
Local oGridAtd
Local aHeader     := {}
Local aCols       := {}
Local cQuery      := ""

//Montagem do aHeader
AADD(aHeader, {"Pedido"      , "FIE_PEDIDO" , "" , 06 , 00, , , "C", "FIE", , , })
AADD(aHeader, {"Prefixo", "FIE_PREFIX", "@!", 03 , 00, , , "C", "FIE", , , })
AADD(aHeader, {"Num. Titulo" , "FIE_NUM", "@!", 09, 00, , , "C", "FIE", , , })
AADD(aHeader, {"Tipo Titulo" , "FIE_TIPO", "@!", 03, 00, , , "C", "FIE", , , })
AADD(aHeader, {"Fornecedor" , "FIE_FORNEC", "@!", 06, 00, , , "C", "FIE", , , })
AADD(aHeader, {"Loja" , "FIE_LOJA", "@!", 02, 00, , , "C", "FIE", , , })
AADD(aHeader, {"Valor" , "FIE_VALOR", "@E 999,999,999,999.99", 17, 02, , , "N", "FIE", , , })
AADD(aHeader, {"Saldo" , "FIE_SALDO", "@E 999,999,999,999.99", 17, 02, , , "N", "FIE", , , })
     

// Validacao se encontrou adiantamento amarrado na PA
DbSelectArea("FIE")
DbSetOrder(3)
If !FIE->(DbSeek(xFilial("FIE") + "P" + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM))
    Alert("Nenhum vinculo de pedido de compra encontrado")
    RETURN
EndIf

//? Filtra o título (PA) posicionado para buscar adiantamentos vinculados
If Select("QRY") > 0
	DbSelectArea("QRY")
	DbCloseArea()
EndIf

cQuery := "SELECT FIE_PEDIDO, FIE_PREFIX, FIE_NUM, FIE_TIPO, FIE_FORNEC, FIE_LOJA, FIE_VALOR, FIE_SALDO "
cQuery += " FROM " + RetSqlName("FIE") + " FIE "
cQuery += "WHERE D_E_L_E_T_ = ' ' AND FIE_FILIAL = '"+xFilial("SE2")+"' AND FIE_NUM = '"+ SE2->E2_NUM +"' AND FIE_PARCEL = '" + SE2->E2_PARCELA +" '"

DbUseArea( .T. , 'TOPCONN' , TcGenQry( ,, cQuery) , "QRY" , .T. , .T. )

// Alimenta o aCols com os pedidos vinculados a PA para exibir na grid da tela
Do While !(QRY->(EoF()))

    AADD(aCols, {QRY->FIE_PEDIDO,;
                QRY->FIE_PREFIX,;
                QRY->FIE_NUM,;
                QRY->FIE_TIPO,;
                QRY->FIE_FORNEC,;
                QRY->FIE_LOJA,;
                QRY->FIE_VALOR,;
                QRY->FIE_SALDO,;
                .F.})

    QRY->(DbSkip())
          
EndDo

//-- -- Cria Janela Dialog
oDlg := TDialog():New( 000, 000, 300, 700, "PC's vinculados ao titulo: " + cValToChar(SE2->E2_NUM) , , , , , , , , , .T., , , , , , .F.)
     
//-- -- Cria objeto MsNewGetDados
//-- -- Documentaçã: http://tdn.totvs.com/display/public/mp/MsNewGetDados
oGridAtd:= MsNewGetDados():New( 001, 001, 150, 351, , , , , , , 9999, , , , oDlg, aHeader, aCols, , )
     
//-- -- Ativa Janela DIalog
oDlg:Activate( , , , .T., {||}, , {||}, , )

DbCloseArea()
     
Return
