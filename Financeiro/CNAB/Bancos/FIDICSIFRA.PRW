#include "protheus.ch"

// Date: 14/08/2019
// Description: Função utilizada No CNAB Bradesco para o processo FIDICSIFRA
// Author: Everton Diniz - DS2U

User Function FIDICSIFRA()
Local cRet  := ""

Default MV_PAR05 := "902"
Default MV_PAR06 := "1"
Default MV_PAR07 := "1"

    If MV_PAR05 == "902" .And. Alltrim(MV_PAR06) == "1" .And. Alltrim(MV_PAR07) == "1"
        cRet := StrZero(Val(SE1->E1_NUM),10)
    Else
        cRet := SPACE(10)
    Endif

Return cRet