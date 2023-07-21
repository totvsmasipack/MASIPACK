#Include 'Protheus.ch'

/*------------------------------------------------------------------------------------------------------*
 | P.E.:  {Protheus.doc} MTA131C8                                                                       |
 | Desc:  Utilizado para acrescentar informacoes na geração da cotacao.                                 |
 |        Será executado após a gravação de cada item da SC8.                                           |
 | Links: https://tdn.totvs.com/pages/releaseview.action?pageId=267811289                				|
 |                                                                                                      |
 | @author  DS2U (THOMAS MORAES)																		|
 | @since   Jun.2023																					|
 | @version 1.0																							|
 | @type    function                                  													|
 *------------------------------------------------------------------------------------------------------*/

User Function MTA131C8()

Local oModFor     := PARAMIXB[1]
Local _cFornece   := Alltrim(oModFor:GetValue("C8_FORNECE"))
Local _cLoja      := Alltrim(oModFor:GetValue("C8_LOJA"))
Local _cMailForn  := Alltrim(SA2->A2_EMAIL2)
Local _cMailEnv   := ''
Local _cSize      := TamSX3("C8_FORMAIL")[1]

If !Empty(_cFornece) .AND. !Empty(_cLoja)
    _cMailEnv := SUBSTR(_cMailForn,1,_cSize) //limita tamanho do caractere conforme SX3 do campo que recebera o dado
    oModFor:LoadValue("C8_FORMAIL",_cMailEnv)

EndIf

Return
