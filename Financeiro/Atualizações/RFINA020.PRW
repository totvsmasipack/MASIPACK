#include "TOTVS.CH"
/*------------------------------------------------------------------------------------------------------*
 | Programa:  RFINA020                                                                                  |
 | Desc:  Este programa tem como objetivo a execu��o autom�tica da rotina                               |
 |        FINA811 - Envio de Cartas de Cobran�a                                                         |
 |                                                                      								|
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Nov.2021																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function RFINA020(aParam)

//Prepara��o do Ambiente
RpcSetType(3)
RPCSetEnv(aParam[1],aParam[2])
CONOUT('= EMPRESA: ' + aParam[1] + ' | FILIAL: ' + aParam[2])
ProcCob(Nil,aParam)

Return

Static Function ProcCob(oSay,aParam)

Local a811Param           :={}   as array
Local cFiltro             :=""   As Character
Local cCliD               :=""   as character
Local cLojD               :=""   as character
Local cCliAt              :="ZZ" as character
Local cLojAt              :="ZZ" as character
Local cLay                :=""   as character
Private aRetorno          :={}
Private lMsErroAuto       := .F. as logical
Private lAutoErrNoFile    := .T. as logical


/*============= LAYOUT 000001 - AVISO 15 DIAS ANTES DO VENCIMENTO ================*/
cLay := "000001"

cFiltro := "E1_PREFIXO <> 'LJ ' " //Desconsidera titulos gerados pela LOJA

dbSelectArea("FWP")
FWP->(DbGoTop())
FWP->(DbSetOrder(1))//FWP_FILIAL, FWP_CODCRT, R_E_C_N_O_, D_E_L_E_T_

If !FWP->(DbSeek(xFilial("FWP") + cLay))  // Valido se encontrou o layout da carta de cobran�a
    conOut("Layout nao encontrado")
    RETURN
EndIf
aAdd( a811Param,  PadR(cCliD,TamSX3('A1_COD')[1])           )   //C�digo do cliente De (tipo caracter)
aAdd( a811Param,  PadR(cLojD,TamSX3('A1_LOJA')[1])          )   //Loja do cliente De (tipo caracter)
aAdd( a811Param,  Repl(cCliAt,TamSX3('A1_COD')[1])          )   //C�digo do cliente At� (tipo caracter)
aAdd( a811Param,  Repl(cLojAt,TamSX3('A1_LOJA')[1])         )   //Loja do cliente At� (tipo caracter)
aAdd( a811Param,  dDataBase + 15                            )   //Data de emiss�o De (tipo data)
aAdd( a811Param,  dDataBase + 15                            )   //Data de emiss�o At� (tipo data)
aAdd( a811Param,  dDataBase                                 )   //Data de refer�ncia (tipo data)
aAdd( a811Param,  0                                         )   //Valor de (tipo num�rico)
aAdd( a811Param,  999999999.99                              )   //Valor At� (tipo num�rico)
aAdd( a811Param,  '2'                                       )   //"2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE FILIAIS
aAdd( a811Param,  '1'                                       )   //T�tulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = N�o)
aAdd( a811Param,  '1'                                       )   //Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
aAdd( a811Param,  '2'                                       )   //2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE SITUA��O DE COBRAN�A
aAdd( a811Param,  {}                                        )   //{} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
aAdd( a811Param,  ''                                        )   //"" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
aAdd( a811Param,  cLay                                      )   //C�digo do layout da carta a ser utilizado (tipo caracter)
aAdd( a811Param,  '2'                                       )   //A1_MSBLQL

MSExecAuto({|x,y| Fina811(x,y)},0,a811Param, NIL, cFiltro)

if lMsErroAuto
    ConOut("Erro !")
    MostraErro()
    aLog := GetAutoGRLog()
else
    CONOUT(" --> Layout 000001 processado com sucesso | EMPRESA: " + aParam[1] + " | FILIAL: " + aParam[2])
endif

a811Param := {}

/*============= LAYOUT 000002 - AVISO 1 DIA ANTES DO VENCIMENTO ================*/

cLay := "000002"

cFiltro := "E1_PREFIXO <> 'LJ ' " //Desconsidera titulos gerados pela LOJA

dbSelectArea("FWP")
FWP->(DbGoTop())
FWP->(DbSetOrder(1))//FWP_FILIAL, FWP_CODCRT, R_E_C_N_O_, D_E_L_E_T_

If !FWP->(DbSeek(xFilial("FWP") + cLay))  // Valido se encontrou o layout da carta de cobran�a
    conOut("Layout nao encontrado")
    RETURN
EndIf

aAdd( a811Param,  PadR(cCliD,TamSX3('A1_COD')[1])           )   //C�digo do cliente De (tipo caracter)
aAdd( a811Param,  PadR(cLojD,TamSX3('A1_LOJA')[1])          )   //Loja do cliente De (tipo caracter)
aAdd( a811Param,  Repl(cCliAt,TamSX3('A1_COD')[1])          )   //C�digo do cliente At� (tipo caracter)
aAdd( a811Param,  Repl(cLojAt,TamSX3('A1_LOJA')[1])         )   //Loja do cliente At� (tipo caracter)
aAdd( a811Param,  dDataBase + 1                             )   //Data de emiss�o De (tipo data)
aAdd( a811Param,  dDataBase + 1                             )   //Data de emiss�o At� (tipo data)
aAdd( a811Param,  dDataBase                                 )   //Data de refer�ncia (tipo data)
aAdd( a811Param,  0                                         )   //Valor de (tipo num�rico)
aAdd( a811Param,  999999999.99                              )   //Valor At� (tipo num�rico)
aAdd( a811Param,  '2'                                       )   //"2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE FILIAIS
aAdd( a811Param,  '1'                                       )   //T�tulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = N�o)
aAdd( a811Param,  '1'                                       )   //Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
aAdd( a811Param,  '2'                                       )   //2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE SITUA��O DE COBRAN�A
aAdd( a811Param,  {}                                        )   //{} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
aAdd( a811Param,  ''                                        )   //"" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
aAdd( a811Param,  cLay                                      )   //C�digo do layout da carta a ser utilizado (tipo caracter)
aAdd( a811Param,  '2'                                       )   //A1_MSBLQL

MSExecAuto({|x,y| Fina811(x,y)},0,a811Param, NIL, cFiltro)

if lMsErroAuto
    ConOut("Erro !")
    MostraErro()
    aLog := GetAutoGRLog()
else
    CONOUT(" --> Layout 000002 processado com sucesso | EMPRESA: " + aParam[1] + " | FILIAL: " + aParam[2])
endif

a811Param := {}

/*============= LAYOUT 000003 - AVISO TITULOS VENCIDOS ================*/

cLay := "000003"

cFiltro := "E1_PREFIXO <> 'LJ ' " //Desconsidera titulos gerados pela LOJA

dbSelectArea("FWP")
FWP->(DbGoTop())
FWP->(DbSetOrder(1))//FWP_FILIAL, FWP_CODCRT, R_E_C_N_O_, D_E_L_E_T_

If !FWP->(DbSeek(xFilial("FWP") + cLay))  // Valido se encontrou o layout da carta de cobran�a
    conOut("Layout nao encontrado")
    RETURN
EndIf

aAdd( a811Param,  PadR(cCliD,TamSX3('A1_COD')[1])           )   //C�digo do cliente De (tipo caracter)
aAdd( a811Param,  PadR(cLojD,TamSX3('A1_LOJA')[1])          )   //Loja do cliente De (tipo caracter)
aAdd( a811Param,  Repl(cCliAt,TamSX3('A1_COD')[1])          )   //C�digo do cliente At� (tipo caracter)
aAdd( a811Param,  Repl(cLojAt,TamSX3('A1_LOJA')[1])         )   //Loja do cliente At� (tipo caracter)
aAdd( a811Param,  dDataBase - 9999                          )   //Data de emiss�o De (tipo data)
aAdd( a811Param,  dDataBase - 5                             )   //Data de emiss�o At� (tipo data)
aAdd( a811Param,  dDataBase                                 )   //Data de refer�ncia (tipo data)
aAdd( a811Param,  0                                         )   //Valor de (tipo num�rico)
aAdd( a811Param,  999999999.99                              )   //Valor At� (tipo num�rico)
aAdd( a811Param,  '2'                                       )   //"2" (tipo caracter) - IMPORTANTE:  SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE FILIAIS
aAdd( a811Param,  '2'                                       )   //T�tulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = N�o)
aAdd( a811Param,  '1'                                       )   //Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
aAdd( a811Param,  '2'                                       )   //2" (tipo caracter) - IMPORTANTE: SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE SITUA��O DE COBRAN�A
aAdd( a811Param,  {}                                        )   //{} (tipo array) - IMPORTANTE: ENVIAR ARRAY VAZIO
aAdd( a811Param,  ''                                        )   //"" (tipo caracter) - IMPORTANTE: SEMPRE VAZIO
aAdd( a811Param,  cLay                                      )   //C�digo do layout da carta a ser utilizado (tipo caracter)
aAdd( a811Param,  '2'                                       )   //A1_MSBLQL

MSExecAuto({|x,y| Fina811(x,y)},0,a811Param, NIL, cFiltro)

if lMsErroAuto
    ConOut("Erro !")
    MostraErro()
    aLog := GetAutoGRLog()
else
    CONOUT(" --> Layout 000003 processado com sucesso | EMPRESA: " + aParam[1] + " | FILIAL: " + aParam[2])
endif

RpcClearEnv()

Return
