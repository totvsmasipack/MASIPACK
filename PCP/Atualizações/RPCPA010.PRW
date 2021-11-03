#INCLUDE "rwmake.ch"   
#include "protheus.ch" 
#include "topconn.ch"           
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPA010     บ Autor ณ Jose Roberto Data ณ  30/11/06        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  AP6 IDE.                                                  บฑฑ
ฑฑบ          ณTROCA DE DATAS PARA ORDENS DE PRODUCAO                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RPCPA010()    

Private _nCnt := 0
Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cUsuSenha := ""
Private _cDeptoUsu := ""
Private cPerg      := "PCPA10"
Private nAlterados := 0
Private cOP        := ""
Private dDtIni     := CTOD("")
Private dDtFin     := CTOD("")
Private cProc      := ""

// OPS inicial    := mv_par01   
// OPS final      := mv_par02  
// Data inicial   := mv_par03                                             
// Data Final     := mv_par04 
// Pedido         := mv_par05
 
If !(Pergunte (cPerg,.T.))
   Return
EndIf

If !MsgBox("Confirma altera็ใo das datas na OP ??","CONFIRMAR","YESNO")
   Return
Else
   If !Empty(mv_par01)   
      If SubStr(mv_par01,1,6) <> SubStr(mv_par02,1,6)
         If !apMsgYesNo("Os Pedidos (Inicial e Final) estใo diferentes - Confirma Altera็ใo ??")
            Return
         EndIf   
      EndIf   
   Else
      If Empty(mv_par05)   
         apMsgStop("Informe o Numero do Pedido ou um Intervalo de OPs")
         Return
      EndIf         
   EndIf
   IF mv_par03 > mv_par04
      apMsgStop("Data fim deve ser maior ou igual a inicio!")
      Return
   ENDIF
EndIf

If Len(Alltrim(mv_par02)) == 6
   mv_par02 := Alltrim(mv_par02) + "ZZZZZ"
ElseIf Len(Alltrim(mv_par02)) == 8
   mv_par02 := Alltrim(mv_par02) + "ZZZ"   
EndIf   

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario := PswRet()
   _cUsuSenha := UsrRetName(_cUsuario)
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf 

SA1->(DbSetOrder(1))
SD4->(DbSetOrder(2))
SD4->(DbSeek(xFilial("SD4")))    //DbSeek(xFilial()+(MV_PAR01)) 
SD4->(ORDSETFOCUS(2))

SC2->(DbSetOrder(1))
SC2->(DBGotop())

If !Empty(mv_par05)
   _cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_MSLISTA, C2_PEDIDO, C2_MSPED, C2_DATPRI, C2_DATPRF, C2_DATRF "
   _cQuery += "FROM " + RetSqlName("SC2") + " C2 "
   _cQuery += "WHERE C2_FILIAL = '" + xFilial("SC2") + "' AND C2_MSLISTA = 'S' AND C2_MSPED = '"+ mv_par05 + "' AND C2_DATRF = '' "
   _cQuery += "AND D_E_L_E_T_ = ' ' "
   _cQuery += "ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN" 
Else
   _cQuery := "SELECT TOP 50 C2_NUM, C2_ITEM, C2_SEQUEN, C2_MSLISTA, C2_PEDIDO, C2_MSPED, C2_DATPRI, C2_DATPRF "
   _cQuery += "FROM " + RetSqlName("SC2") + " C2 "
   _cQuery += "WHERE C2_FILIAL = '" + xFilial("SC2") + "' AND C2_MSLISTA = 'S' AND C2_NUM + C2_ITEM + C2_SEQUEN Between '" + mv_par01 +"' AND '" + mv_par02 + "' AND C2_DATRF = '' "
   _cQuery += "AND D_E_L_E_T_ = ' ' "
   _cQuery += "ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN" 
EndIf

//Alert(_cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)

Do While ! QR1->(Eof())
   SC2->(DbSeek(xFilial("SC2")+(QR1->C2_NUM+QR1->C2_ITEM+QR1->C2_SEQUEN)))

   If SC2->C2_DATPRI < mv_par03 .Or. SC2->C2_DATPRF < mv_par04 
      
      cProc := "A"
             
      DEFINE MSDIALOG _oDlg FROM 0,0 TO 200,320 PIXEL TITLE "ATENวรO, Data da OP ้ inferior a data de Altera็ใo" FONT COLOR CLR_HRED

      @ 010,030 Say OemToAnsi("Ordem de Produ็ใo: "+ SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN) Pixel Size 120,010 FONT COLOR CLR_HRED
      @ 022,030 Say OemToAnsi("Data Inicial da OP: "+ DTOC(SC2->C2_DATPRI) + " - Para: " + DTOC(mv_par03)) Pixel Size 130,010
      @ 034,030 Say OemToAnsi("Data Final da OP: "+ DTOC(SC2->C2_DATPRF) + " - Para: " + DTOC(mv_par04)) Pixel Size 130,010
      @ 050,040 BUTTON "CONFIRMA ALTERACAO " Pixel SIZE 80,10 ACTION AltData1()
      @ 065,040 BUTTON "DESPREZA ESTA OP" Pixel SIZE 80,10 ACTION _oDlg:End()
      @ 080,040 BUTTON "ENCERRA O PROCESSO" Pixel SIZE 80,10 ACTION _fFinaliza() 
   
      _oDlg:lEscClose := .F.
      ACTIVATE MSDIALOG _oDlg CENTERED
   Else
      cProc := "" 
      AltData1() 
   EndIf
   If cProc == "E"
      Exit
   Else
      QR1->(DbSkip())
   EndIf   
EndDo   
   
If nAlterados == 0
   apmsgStop("Nใo houve altera็ใo de datas - Verifique os parโmetros")
EndIf      
 
RETURN NIL 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPA010  บAutor  ณMicrosiga           บ Data ณ  02/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION AltData1()

If cProc == "A"
   _oDlg:End()
EndIf      
 
RecLock("SC2",.F.)
sc2->c2_datpri := mv_par03 //wdata1
sc2->c2_datprf := mv_par04 //wdata2
nalterados++
sc2->(MsUnlock()) 

AtuPedido()
 
If sd4->(DBSEEK(xFilial("SD4") + sc2->c2_num + sc2->c2_item + sc2->c2_sequen))
   sd4->(DBEVAL({||AltData2()},,{||ALLTRIM(sd4->d4_op) == sc2->c2_num + sc2->c2_item + sc2->c2_sequen}))
ENDIF

RETURN .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPA010  บAutor  ณMicrosiga           บ Data ณ  02/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION AltData2()

RecLock("SD4",.F.)
sd4->d4_data := mv_par03 //wdata1
nAlterados++
sd4->(MsUnlock())

RETURN .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPA010  บAutor  ณMicrosiga           บ Data ณ  02/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuPedido()
   If SC5->(DbSeek(xFilial("SC5")+SC2->C2_NUM))
      If SC5->C5_MSMONTA <> mv_par03
         RecLock("SC5",.F.)
         SC5->C5_MSMONTA := mv_par03
         SC5->(MsUnlock())
         If SC5->C5_MSCATEG $ "0_1" .AND. SubStr(cNumEmp,1,2) $ "01_10"
            _GravaSZM()
         EndIf   
      EndIf
   EndIf   
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPA010  บAutor  ณMicrosiga           บ Data ณ  02/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fFinaliza()
   _oDlg:End()
   cProc := "E"  
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPA010  บAutor  ณMicrosiga           บ Data ณ  02/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _GravaSZM() 
   Local _lGrava := .T.
   SZM->(DbSetOrder(9))
   SZM->(DbGoTop())
   If SZM->(DbSeek(xFilial("SZM")+"LOGPV "+SC5->C5_NUM))
      Do While SZM->(!Eof()) .And. SZM->ZM_PEDIDO == SC5->C5_NUM .And. Alltrim(SZM->ZM_ASSUNTO) == "LOGPV"  
         If SZM->ZM_DATA == Date()
            If "Data da OP" $ SZM->ZM_EVENTO
               _lGrava := .F. 
            EndIf 
         EndIf
         SZM->(DbSkip())
      EndDo   
   EndIf
   If _lGrava       
      RecLock("SZM",.T.)
      SZM->ZM_FILIAL  := "01" 
      SZM->ZM_PEDIDO  := SC5->C5_NUM
      SZM->ZM_CODCLI  := SC5->C5_CLIENTE
      SZM->ZM_LOJACLI := SC5->C5_LOJACLI
      SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
      SZM->ZM_CLIENTE := SA1->A1_NREDUZ
      SZM->ZM_DATA    := Date() 
      SZM->ZM_MSUSER  := _cUsuSenha
      SZM->ZM_DEPTO   := _cDeptoUsu
      SZM->ZM_ASSUNTO := "LOGPV"
      SZM->ZM_NOASSUN := "LOG DO PV"
      SZM->ZM_RESUMO  := "LOG DO PV"
      SZM->ZM_EVENTO  := "Altera็ใo da Data da OP pelo PCP"
      SZM->ZM_CODDEPT := "QUALID"
      SZM->ZM_DEPTDES := "QUALIDADE"
      SZM->ZM_DTPREV  := Date()
      SZM->ZM_STATUS  := "E"
      SZM->ZM_CODTEC  := "" 
      SZM->ZM_LIDO    := .F.
      SZM->ZM_ACEITE  := .F.
      SZM->ZM_COMENT  := SC5->C5_MSPOSIC
      SZM->ZM_INIMONT := SC5->C5_MSMONTA
      SZM->ZM_COPIA   := .F.
      SZM->(MsUnlock())
   EndIf   
Return     