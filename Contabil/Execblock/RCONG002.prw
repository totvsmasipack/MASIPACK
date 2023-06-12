#INCLUDE "PROTHEUS.CH"

/*--------------------------------------------------------------------------------------------|
| {Protheus.doc} RCONG002()                                                                   |
| Validador de caracteres do campo CT1_CONTA.                                                 |
|                                                                                             |
| @author  DS2U (THOMAS MORAES)                                                               |
| @since   Jun.2023                                                                           |
| @version 1.0                                                                                |
| @type    function                                                                           |
|                                                                                             |
|---------------------------------------------------------------------------------------------*/

User Function RCONG002()
Local _cRet := .T.

If Len(AllTrim(M->CT1_CONTA))>9
    _cRet := .F.
    FWAlertHelp("Tamanho do código inválido", "Informe um código de até 9 caracteres")
Else
    _cRet := .T.
EndIf

Return _cRet
