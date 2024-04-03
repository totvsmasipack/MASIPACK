#Include "rwmake.ch"
#Include "Topconn.ch"
/*/
------------------------------------------------------------------------
{Protheus.doc} LP610VL2()
Programa Retorna Valor em lancamento padrao (610) seq 001 e 002

@author  DS2U 
@since   Mar.2024
@version 1.0
@type    function
------------------------------------------------------------------------
/*/

User Function LP610VL2(_nSeq)

Private _nValor := 0

SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))       

If SF4->F4_CONTAB == "1"
   If _nSeq == 1
      If SubStr(cNumEmp,1,2) $ "01" /*MASIPACK*/ 
		If !SD2->D2_SERIE $ "PRE" .AND.SD2->D2_TIPO $ "N|B"
			 If SUBSTR(SD2->D2_CF,2,3) $ "116/901/902/912/913/914/915/916/949"
				If SD2->D2_TES $ "84Y/945/892/895/85X/86C/993/994/998/988/930/937/936/935/976/85V/87W/86T/981/974/973/962/87A/81G/943/960/637/959/81T/83Z/951/85E/990/991"
				   _nValor := 0
				Else
                    _nValor := (SD2->D2_VALBRUT)
				EndIf
			 Else
				_nValor := (SD2->D2_VALBRUT)
			 EndIf
		Else 
			_nValor := 0
		EndIf	 
      ElseIf SubStr(cNumEmp,1,2) $ "10"  //FABRIMA 
		If !SD2->D2_SERIE $ "PRE" .AND.SD2->D2_TIPO $ "N|B"
			 If SUBSTR(SD2->D2_CF,2,3) $ "116/554/901/902/908/915/916/923/925/949"
				If SD2->D2_TES $ "84Y/945/872/893/895/88A/930/937/950/584/91I/87W/85V/943/951/81Q/962/83Z/952/974/909/81N/918/84J/990/991"
				   _nValor := 0      
				Else
				   _nValor := (SD2->D2_VALBRUT)
				EndIf
			 Else
				_nValor := (SD2->D2_VALBRUT)
			 EndIf
		Else 
			_nValor := 0
		EndIf	 
      ElseIf SubStr(cNumEmp,1,2) $ "15"  //MASITUBOS 
		If !SD2->D2_SERIE $ "PRE|8  |9  |10 |LJ " .AND. SD2->D2_TIPO $ "N|B"
			 If SUBSTR(SD2->D2_CF,2,3) $ "901/910/914/915/916/920/921/924/949"
				If SD2->D2_TES $ "825/813/919/806/818/846/845/834/851/811"
				   _nValor := 0      
				Else
				   _nValor := (SD2->D2_VALBRUT)
				EndIf
			 Else
				_nValor := (SD2->D2_VALBRUT)
			 EndIf
		Else 
			_nValor := 0
		EndIf
      Else
         _nValor := (SD2->D2_VALBRUT)      
      EndIf
   ElseIf _nSeq == 2
      If SubStr(cNumEmp,1,2) $ "01" /*MASIPACK*/ 
		If !SD2->D2_SERIE $ "PRE" .AND.SD2->D2_TIPO $ "N|B"
			 If SUBSTR(SD2->D2_CF,2,3) $ "116/901/902/912/913/914/915/916/949"
				If SD2->D2_TES $ "84Y/945/892/895/85X/86C/993/994/998/988/930/937/936/935/976/85V/87W/86T/981/974/973/962/87A/81G/943/960/637/959/81T/83Z/951/85E/990/991"
				   _nValor := 0
				Else
				   _nValor := (SD2->D2_VALBRUT-SD2->D2_VALINS)
				EndIf
			 Else
				_nValor := (SD2->D2_VALBRUT-SD2->D2_VALINS)
			 EndIf
		Else 
			_nValor := 0
		EndIf	 
      ElseIf SubStr(cNumEmp,1,2) $ "10"  //FABRIMA 
		If !SD2->D2_SERIE $ "PRE" .AND.SD2->D2_TIPO $ "N|B"
			 If SUBSTR(SD2->D2_CF,2,3) $ "116/554/901/902/908/915/916/923/925/949"
				If SD2->D2_TES $ "84Y/945/872/893/895/88A/930/937/950/584/91I/87W/85V/943/951/81Q/962/83Z/952/974/909/81N/918/84J/990/991"
				   _nValor := 0      
				Else
				   _nValor := (SD2->D2_VALBRUT-SD2->D2_VALINS)
				EndIf
			 Else
				_nValor := (SD2->D2_VALBRUT-SD2->D2_VALINS)
			 EndIf
		Else 
			_nValor := 0
		EndIf	 
      ElseIf SubStr(cNumEmp,1,2) $ "15"  //MASITUBOS 
		If !SD2->D2_SERIE $ "PRE|8  |9  |10 |LJ " .AND. SD2->D2_TIPO $ "N|B"
			 If SUBSTR(SD2->D2_CF,2,3) $ "901/910/914/915/916/920/921/924/949"
				If SD2->D2_TES $ "825/813/919/806/818/846/845/834/851/811"
				   _nValor := 0      
				Else
				   _nValor := (SD2->D2_VALBRUT)
				EndIf
			 Else
				_nValor := (SD2->D2_VALBRUT)
			 EndIf
		Else 
			_nValor := 0
		EndIf
      Else
         _nValor := (SD2->D2_VALBRUT)      
      EndIf

EndIf   

Return(_nValor)
