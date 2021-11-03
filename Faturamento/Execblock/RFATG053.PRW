#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "rwmake.ch"
#include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_RFATR053()  บAutor  ณIvandro M P Santosบ Data ณ  01/04/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho para preencher o campo A1_MSAREA quando preenche o บฑฑ
ฑฑบ          ณ paํs diferente de Brasil                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - Masipack                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function RFATG053(_Pais)

Local _cQuery     := ""

Private _cReg  	  := ""
Private _cEscolha := ""
Private _aRegiao  := {}

If Alltrim(_Pais) <> "BR" .And. !Empty(_Pais)

	_cQuery := "Select YA_MSREGI+' - '+RTRIM(LTRIM(X5_DESCRI)) REGIAO FROM "+ RetSqlName("SYA") +" SYA "
	_cQuery += "	INNER JOIN "+ RetSqlName("SX5") +" SX5 ON X5_TABELA = 'RC' AND X5_CHAVE = YA_MSREGI "
	_cQuery += "	WHERE YA_CODGI = '"+_Pais+"' AND SYA.D_E_L_E_T_ = '' "

	
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤtroHฟ
	//ณRotina que farแ a sele็ใo da query passada por parโmetro ณ
	//ณe alimentarแ o array caso tenha mais que uma regiใo ou   ณ
	//ณa variแvel caso tenha apenas uma.                         ณ
	//ณFonte gravado no arquivo MSXFUN.PRW                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤtroHู
	*/
	U_FATG52QR(_cQuery)

	If Empty(Alltrim(_cReg))
		Alert("Nใo existe Regiใo cadastrada da cidade,estado ou pais")
	EndIf

EndIf
 
Return(_cReg)