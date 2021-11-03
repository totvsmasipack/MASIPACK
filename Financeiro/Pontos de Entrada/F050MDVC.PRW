#include "Topconn.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF050MDVC   บAutor  ณLIZANDRA MARQUES   บ Data ณ  09/13/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CALCULO DA DATA DO IMPOSTO ISS, IRRF, FGTS                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MASIPACK                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRevisใo   ณ Retirado a mudan็a da data de vencimento dos tํtulos de    บฑฑ
ฑฑบ          ณ PIS/COFINS/CSLL - Ivandro - 17/03/16                       บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION F050MDVC


Local dVencPR 	:= ParamIXB[1]
Local cImposto 	:= ParamIXB[2]
Local dEmissao 	:= ParamIXB[3]
Local dEmis1 	:= ParamIXB[4]
Local dVencRea 	:= ParamIXB[5]
Local _lTX		:= .F.
Local nNextMes := Month(dVencRea)+1


dDtVenc := dVencRea
If SubStr(cNumEmp,1,2) $ "10"  // - FABRIMA
	If AllTrim(Upper(cImposto)) == 'IRRF'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('20/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	ElseIf cImposto $ "PIS,CSLL,COFINS"//Calcula data 20 do pr๓ximo mes 
		dDtVenc := CTOD("20/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+; 
			Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))//Acho o ultimo dia util do periodo desejado 
		_lTX	:= .T.
	ELSEIF AllTrim(Upper(cImposto)) == 'ISS'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('25/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	ElseIf AllTrim(Upper(cImposto)) == 'INSS'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('20/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	ElseIf AllTrim(Upper(cImposto)) == 'FGTS'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('07/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	Endif
Else
	If AllTrim(Upper(cImposto)) == 'IRRF'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('20/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	ElseIf cImposto $ "PIS,CSLL,COFINS"//Calcula data 20 do pr๓ximo mes 
		dDtVenc := CTOD("20/"+Iif(nNextMes==13,"01",StrZero(nNextMes,2))+"/"+; 
			Substr(Str(Iif(nNextMes==13,Year(dVencRea)+1,Year(dVencRea))),2))//Acho o ultimo dia util do periodo desejado 
		_lTX	:= .T.
	ElseIf AllTrim(Upper(cImposto)) == 'INSS'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('20/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	ElseIf AllTrim(Upper(cImposto)) == 'ISS'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('15/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	ElseIf AllTrim(Upper(cImposto)) == 'FGTS'
		dDtVenc := MsSomaMes(dEmissao,1,.T.)
		dDtVenc := CtoD('07/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
		_lTX	:= .T.
	Endif
ENDIF

//Alert("Voce esta por aqui?")

// Tratamento da Data para Nใo Cair aos Sabados, Domingos e Feriados
// Antecipando o Vencimento
IF _lTX
	If Dow(dDtVenc) == 1
		dDtVenc := dDtVenc-2
		dDtVenc := DataValida(dDtVenc)
	ElseIf Dow(dDtVenc) == 7
		dDtVenc := dDtVenc-1
		dDtVenc := DataValida(dDtVenc)
	Endif                                               
ENDIF      
IF dDtVenc < DATE()
	apmsgAlert("Verifique data de emissใo da Nota de Entrada")
	dDtVenc = DATE()
ENDIF	
	

RETURN dDtVenc
