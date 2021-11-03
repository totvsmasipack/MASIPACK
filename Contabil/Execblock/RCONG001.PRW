	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RCONG001  ºAutor ³Aparecida de F.Stevanato ºData ³ 12/05/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para retornar contabilização (Finan/Fatura/Compras) º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
#Include "Rwmake.ch"
#Include "Topconn.ch"

User Function RCONG001() 

Private nReg  := 0
Private nDias := 0
Private cPerg := "CONG01"

Pergunte(cPerg,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    1-Compras  2-Faturamento  3-Financeiro  4-Todos  ³
//³ mv_par02    Data para retorno dos lançamentos                ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

nDias := GetMv("MV_MSDRCTB")     // Este parâmetro indica que a data para retorno não poderá ser inferior ao periodo

If mv_par02 < Date() - nDias
   apmsgStop("Data não pode ser menor que " + Str(nDias,3) + " dias")
   Return
EndIf   

If !apmsgYesNo("Confirma Retorno dos Lctos. do Dia: " + DTOC(mv_par02))
   Return
EndIf

MsgRun("Aguarde, Atualizando !!!!",, { || Atualiza() })

If nReg > 0
   apMsgInfo("Registros apagados no CT2: " + STR(nReg))
Else
   apMsgInfo("Não houve contabilização neste dia - Verifique")
EndIf      

Return

Static Function Atualiza()

DbSelectArea("CT2")
CT2->(DbSetOrder(1))
If DbSeek(xFilial("CT2")+DTOS(mv_par02))

   Do While ! CT2->(Eof()) .And. Dtos(CT2->CT2_DATA) == Dtos(mv_par02)
      If Alltrim(CT2->CT2_ROTINA) == "CTBANFE"
         If mv_par01 == 1 .Or. mv_par01 == 4
            RecLock("CT2")
            CT2->(DbDelete())
            CT2->(MsUnLock())
            nReg++
         EndIf   
      Else
         If Alltrim(CT2->CT2_ROTINA) == "CTBANFS" .Or. Alltrim(CT2->CT2_ROTINA) == "MATA460"
            If mv_par01 == 2 .Or. mv_par01 == 4
               RecLock("CT2")
               CT2->(DbDelete())
               CT2->(MsUnLock())
               nReg++
            EndIf   
         Else
            If Alltrim(CT2->CT2_ROTINA) == "FINA370"
               If mv_par01 == 3 .Or. mv_par01 == 4
                 RecLock("CT2")
                 CT2->(DbDelete())
                 CT2->(MsUnLock())
                 nReg++
               EndIf
            EndIf
         EndIf   
      EndIf   
      CT2->(DbSkip())
   EndDo
EndIf
   
If mv_par01 == 1 .Or. mv_par01 == 4       // Retorna data do arquivo da nota fiscal de entradas
   DbSelectArea("SF1")
   SF1->(DbSetOrder(8))
   If DbSeek(xFilial("SF1")+DTOS(mv_par02))
      Do While ! SF1->(Eof()) .And. Dtos(SF1->F1_DTDIGIT) == Dtos(mv_par02)
         RecLock("SF1")
         SF1->F1_DTLANC := CTOD(Space(8))
         SF1->(MsUnLock())
         SF1->(DbSkip())
      EndDo
   EndIf
EndIf

If mv_par01 == 2 .Or. mv_par01 == 4       // Retorna data do arquivo da nota fiscal de saidas
   DbSelectArea("SF2")
   SF2->(DbSetOrder(3))                   // Serie ECF + Data de Emissão
   If DbSeek(xFilial("SF2")+Space(1)+DTOS(mv_par02))      
      Do While ! SF2->(Eof()) .And. Dtos(SF2->F2_EMISSAO) == Dtos(mv_par02)
         RecLock("SF2")
         SF2->F2_DTLANC := CTOD(Space(8))
         SF2->(MsUnLock())
         SF2->(DbSkip())
      EndDo
   EndIf
EndIf

If mv_par01 == 3 .Or. mv_par01 == 4       // Retorna Campo LA do Mov.Bancario e Cheques
   SE5->(DbSetOrder(1))
   SE1->(DbSetOrder(1))
   SE2->(DbSetOrder(6))
   If SE5->(DbSeek(xFilial("SE5")+DTOS(mv_par02)))                                                                     
      Do While !SE5->(Eof()) .And. Dtos(SE5->E5_DATA) == Dtos(mv_par02)
         If SE5->E5_RECPAG == "R"
            If SE1->(DbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA))
               RecLock("SE1")
               SE1->E1_LA := ""
               SE1->(MsUnLock()) 
            EndIf
         ElseIf SE5->E5_RECPAG == "P"
            If SE2->(DbSeek(xFilial("SE2")+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA))
               RecLock("SE2")
               SE2->E2_LA := ""
               SE2->(MsUnLock()) 
            EndIf   
         EndIf   
         RecLock("SE5")
         SE5->E5_LA := ""
         SE5->(MsUnLock()) 
         SE5->(DbSkip())                                                                                   
      EndDo
   EndIf
   DbSelectArea("SEF")
   SEF->(DbSetOrder(5))
   If DbSeek(xFilial("SEF")+"S"+DTOS(mv_par02))
      Do While ! SEF->(Eof()) .And. SEF->EF_LIBER == "S" .And. Dtos(SEF->EF_DATA) == Dtos(mv_par02)
         RecLock("SEF")
         SEF->EF_LA := ""
         SEF->(MsUnLock())
         SEF->(DbSkip())
      EndDo
   EndIf
EndIf                      
         
Return
