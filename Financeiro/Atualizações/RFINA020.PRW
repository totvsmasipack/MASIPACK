#include "TOTVS.CH"
/*------------------------------------------------------------------------------------------------------*
 | Programa:  RFINA020                                                                                  |
 | Desc:  Este programa tem como objetivo a execução automática da rotina                               |
 |        FINA811 - Envio de Cartas de Cobrança                                                         |
 |                                                                      								|
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Nov.2021																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function RFINA020()

Local a811Param           :={}   as array
Local cCliD               :=""   as character
Local cLojD               :=""   as character
Local cCliAt              :="ZZ" as character
Local cLojAt              :="ZZ" as character
Local cLay                :=""   as character
Private lMsErroAuto     := .F. as logical
Private lAutoErrNoFile  := .T. as logical
//Preparação do Ambiente
RpcSetType(3)
RpcSetEnv("01","01")
dbSelectArea("FWP")

FWP->(DbSetOrder(1))//FWP_FILIAL, FWP_CODCRT, R_E_C_N_O_, D_E_L_E_T_

/*============= LAYOUT 000001 - AVISO 15 DIAS ANTES DO VENCIMENTO ================*/

cLay := "000001"
If !FWP->(DbSeek(FWxFilial("FWP") + PadR(cLay,TamSX3("FWP_CODCRT")[1])))
    conOut("Layout nao encontrado")
    RETURN
EndIf
aAdd( a811Param,  PadR(cCliD,TamSX3('A1_COD')[1])           )   //Código do cliente De (tipo caracter)
aAdd( a811Param,  PadR(cLojD,TamSX3('A1_LOJA')[1])          )   //Loja do cliente De (tipo caracter)
aAdd( a811Param,  Repl(cCliAt,TamSX3('A1_COD')[1])          )   //Código do cliente Até (tipo caracter)
aAdd( a811Param,  Repl(cLojAt,TamSX3('A1_LOJA')[1])         )   //Loja do cliente Até (tipo caracter)
aAdd( a811Param,  dDataBase + 15                            )   //Data de emissão De (tipo data)
aAdd( a811Param,  dDataBase + 15                            )   //Data de emissão Até (tipo data)
aAdd( a811Param,  dDataBase                                 )   //Data de referência (tipo data)
aAdd( a811Param,  0                                         )   //Valor de (tipo numérico)
aAdd( a811Param,  99.99999                                  )   //Valor Até (tipo numérico)
aAdd( a811Param,  '1'                                       )   //"2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE FILIAIS
aAdd( a811Param,  '1'                                       )   //Títulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = Não)
aAdd( a811Param,  '1'                                       )   //Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
aAdd( a811Param,  '2'                                       )   //2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE SITUAÇÃO DE COBRANÇA
aAdd( a811Param,  {}                                        )   //{} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
aAdd( a811Param,  ''                                        )   //"" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
aAdd( a811Param,  cLay                                      )   //Código do layout da carta a ser utilizado (tipo caracter)
aAdd( a811Param,  '2'                                       )   //A1_MSBLQL
MSExecAuto({|x,y| Fina811(x,y)},0,a811Param)
if lMsErroAuto
    ConOut("Erro !")
    MostraErro()
    aLog := GetAutoGRLog()
else
    FwAlertSucess("Sucesso!")
endif

/*============= LAYOUT 000002 - AVISO 1 DIA ANTES DO VENCIMENTO ================*/

cLay := "000002"
If !FWP->(DbSeek(FWxFilial("FWP") + PadR(cLay,TamSX3("FWP_CODCRT")[1])))
    conOut("Layout nao encontrado")
    RETURN
EndIf
aAdd( a811Param,  PadR(cCliD,TamSX3('A1_COD')[1])           )   //Código do cliente De (tipo caracter)
aAdd( a811Param,  PadR(cLojD,TamSX3('A1_LOJA')[1])          )   //Loja do cliente De (tipo caracter)
aAdd( a811Param,  Repl(cCliAt,TamSX3('A1_COD')[1])          )   //Código do cliente Até (tipo caracter)
aAdd( a811Param,  Repl(cLojAt,TamSX3('A1_LOJA')[1])         )   //Loja do cliente Até (tipo caracter)
aAdd( a811Param,  dDataBase + 1                             )   //Data de emissão De (tipo data)
aAdd( a811Param,  dDataBase + 1                             )   //Data de emissão Até (tipo data)
aAdd( a811Param,  dDataBase                                 )   //Data de referência (tipo data)
aAdd( a811Param,  0                                         )   //Valor de (tipo numérico)
aAdd( a811Param,  99.99999                                  )   //Valor Até (tipo numérico)
aAdd( a811Param,  '1'                                       )   //"2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE FILIAIS
aAdd( a811Param,  '1'                                       )   //Títulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = Não)
aAdd( a811Param,  '1'                                       )   //Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
aAdd( a811Param,  '2'                                       )   //2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE SITUAÇÃO DE COBRANÇA
aAdd( a811Param,  {}                                        )   //{} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
aAdd( a811Param,  ''                                        )   //"" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
aAdd( a811Param,  cLay                                      )   //Código do layout da carta a ser utilizado (tipo caracter)
aAdd( a811Param,  '2'                                       )   //A1_MSBLQL
MSExecAuto({|x,y| Fina811(x,y)},0,a811Param)
if lMsErroAuto
    ConOut("Erro !")
    MostraErro()
    aLog := GetAutoGRLog()
else
    FwAlertSucess("Sucesso!")
endif

/*============= LAYOUT 000003 - AVISO TITULOS VENCIDOS ================*/

cLay := "000003"
If !FWP->(DbSeek(FWxFilial("FWP") + PadR(cLay,TamSX3("FWP_CODCRT")[1])))
    conOut("Layout nao encontrado")
    RETURN
EndIf
aAdd( a811Param,  PadR(cCliD,TamSX3('A1_COD')[1])           )   //Código do cliente De (tipo caracter)
aAdd( a811Param,  PadR(cLojD,TamSX3('A1_LOJA')[1])          )   //Loja do cliente De (tipo caracter)
aAdd( a811Param,  Repl(cCliAt,TamSX3('A1_COD')[1])          )   //Código do cliente Até (tipo caracter)
aAdd( a811Param,  Repl(cLojAt,TamSX3('A1_LOJA')[1])         )   //Loja do cliente Até (tipo caracter)
aAdd( a811Param,  dDataBase - 9999                          )   //Data de emissão De (tipo data)
aAdd( a811Param,  dDataBase - 1                             )   //Data de emissão Até (tipo data)
aAdd( a811Param,  dDataBase                                 )   //Data de referência (tipo data)
aAdd( a811Param,  0                                         )   //Valor de (tipo numérico)
aAdd( a811Param,  99.99999                                  )   //Valor Até (tipo numérico)
aAdd( a811Param,  '1'                                       )   //"2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE FILIAIS
aAdd( a811Param,  '1'                                       )   //Títulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = Não)
aAdd( a811Param,  '1'                                       )   //Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
aAdd( a811Param,  '2'                                       )   //2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE SITUAÇÃO DE COBRANÇA
aAdd( a811Param,  {}                                        )   //{} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
aAdd( a811Param,  ''                                        )   //"" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
aAdd( a811Param,  cLay                                      )   //Código do layout da carta a ser utilizado (tipo caracter)
aAdd( a811Param,  '2'                                       )   //A1_MSBLQL
MSExecAuto({|x,y| Fina811(x,y)},0,a811Param)
if lMsErroAuto
    ConOut("Erro !")
    MostraErro()
    aLog := GetAutoGRLog()
else
    FwAlertSucess("Sucesso!")
endif
//RpcClearEnv()
Return
/*
a811Param[01] := Código do cliente De (tipo caracter)
a811Param[02] := Loja do cliente De (tipo caracter)
a811Param[03] := Código do cliente Até (tipo caracter)
a811Param[04] := Loja do cliente Até (tipo caracter)
a811Param[05] := Data de emissão De (tipo data)        
a811Param[06] := Data de emissão Até (tipo data)  
a811Param[07] := Data de referência (tipo data)     
a811Param[08] := Valor de (tipo numérico)     
a811Param[09] := Valor Até (tipo numérico)        
a811Param[10] := "2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE FILIAIS
a811Param[11] := Títulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = Não)
a811Param[12] := Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
a811Param[13] :="2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA NÃO APRESENTAR TELA DE SELEÇÃO DE SITUAÇÃO DE COBRANÇA
a811Param[14] := {} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
a811Param[15] := "" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
a811Param[16] := Código do layout da carta a ser utilizado (tipo caracter) 
a811Param[17] := A1_MSBLQL 
*/
