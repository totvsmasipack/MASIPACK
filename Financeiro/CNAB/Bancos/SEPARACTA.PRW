/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEPARACTA   �Autor �Aparecida F.Stevanado� Data � 27/01/05  ���
�������������������������������������������������������������������������͹��
���Desc.     � Transforma N� e DV da Conta Corrente em campo numerico     ���                                   
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SEPARACTA() 
   Private _cAux := " "
   _cAux := Right(AllTrim(SEA->EA_NUMCON),1)
   _cRet:=StrZero(Val(StrTran(Stuff(SEA->EA_NUMCON,AT("-",SEA->EA_NUMCON),10,""),".","")),12)
   If SubStr(SEA->EA_PORTADO,1,3) == "341"
      If Substr(cNumemp,1,2) == "01"
         _cRet:=StrZero(Val(Substr(SEA->EA_NUMCON,1,5)),12) + " 1"  //provisorio ate acertar conta com digito
      ElseIf Substr(cNumemp,1,2) == "10"
         _cRet:=StrZero(Val(Substr(SEA->EA_NUMCON,1,5)),12) + " 6"  //provisorio ate acertar conta com digito
      ElseIf Substr(cNumemp,1,2) == "15"
         _cRet:=StrZero(Val(Substr(SEA->EA_NUMCON,1,5)),12) + " 8"  //provisorio ate acertar conta com digito
      Endif
      //_cRet := _cRet + " " + _cAux
   ElseIf SubStr(SEA->EA_PORTADO,1,3) == "001"
      If Substr(cNumemp,1,2) == "01"
         _cRet:=StrZero(Val(Substr(SEA->EA_NUMCON,1,5)),12) + "6"  //provisorio ate acertar conta com digito
      ElseIf Substr(cNumemp,1,2) == "10"
         _cRet:=StrZero(Val(Substr(SEA->EA_NUMCON,1,5)),12) + "1"  //provisorio ate acertar conta com digito
      Endif
   Else
      _cRet := _cRet + _cAux
   EndIf
Return(_cRet)