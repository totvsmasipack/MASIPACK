/*
*************************************************************************
* Programa...: PAGVERDG.PRX
* Objetivo...: Analisar a linha digitavel atraves do digito verificador
*************************************************************************
*/

User function PAGVERDG()  

Private _cCampoLivre := ""
Private _cLinDig     := ""
Private _cDigito     := "" 
Private _cDigArq     := ""
Private _cCampo      := ""

If !Empty(M->E2_LINDIG)
   _cLinDig  := M->E2_LINDIG   
   _cCampoLivre:= SubStr(_cLinDig,05,05)+SubStr(_cLinDig,11,10)+SubStr(_cLinDig,22,10)
   _cDigArq    := Val(SubStr(_cLinDig,33,01))
   _cCampo     := AllTrim(SubStr(_cLinDig,01,03)+SubStr(_cLinDig,04,01)+StrZero(Val(SubStr(_cLinDig,34,14)),14)+_cCampoLivre)
   Modulo11()
   If _cDigArq <> _cDigito
      Alert("Linha Digitavel Invalida!","ALERT")
      _cLinDig := ""
   EndIf 
Endif

Return(_cLinDig)

Static Function Modulo11()

Local _i       := 0
Local _nMult   := 2
Local _nModulo := 0
Local _cChar   := SPACE(1)
Local _nVal    := 0

For _i := Len(_cCampo) To 1 Step -1

    _cChar := Substr(_cCampo,_i,1)
    _nModulo := Val(_cChar)*_nMult
    _nVal    := _nVal + _nModulo
    _nMult   := If(_nMult>=9,2,_nMult:=_nMult+1)

Next

_nResto := _nVal % 11

_cDigito := 11 - _nResto

If _nResto == 0 .or. _nResto > 9
   _cDigito := 1
Endif

Return(_cDigito)
