#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³U_RFATG056()  ºAutor  ³Ivandro M P Santosº Data ³  01/07/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para validar as informações registradas nos campos  º±±
±±º          ³ Segmento do Cliente.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

User Function RFATG056()
Local _lRet  	 := .T.
Local _cSegAlim := Alltrim(GetMv("MS_SEGALIM"))
Local _cSegHig	 := Alltrim(GetMv("MS_SEGHIGI"))
Local _cSegFarm := Alltrim(GetMv("MS_SEGFARM"))
Local _cSegOut  := Alltrim(GetMv("MS_SEGOUT"))
Local _cRamo	 := Alltrim(&(ReadVar()))
Local _aSegErr  := {}
Local _cSegErr  := ""
Local nS

If Empty(Alltrim(M->A1_SATIV1))
	Alert("Não existe Segmento 1 Cadastrado. Primeiro cadastre esse Segmento")
Elseif _cRamo $ _cSegAlim .And. Alltrim(M->A1_SATIV1) $ _cSegAlim
	_lRet := .T.
Elseif _cRamo $ _cSegHig  .And. Alltrim(M->A1_SATIV1) $ _cSegHig
	_lRet := .T.
Elseif _cRamo $ _cSegFarm .And. Alltrim(M->A1_SATIV1) $ _cSegFarm
	_lRet := .T.
Elseif _cRamo $ _cSegOut  .And. Alltrim(M->A1_SATIV1) $ _cSegOut
	_lRet := .T.
Else
	_cRamo 	 := Alltrim(GetAdvFval("SX5","X5_CHAVE",xFilial("SX5")+"T3"+M->A1_SATIV1,1," "))
	
	If _cRamo $ _cSegAlim
		_aSegErr := STRTOKARR(_cSegAlim,";")
	Elseif _cRamo $ _cSegHig
		_aSegErr := STRTOKARR(_cSegHig,";")
	Elseif _cRamo $ _cSegFarm
		_aSegErr := STRTOKARR(_cSegFarm,";")
	Elseif _cRamo $ _cSegOut
		_aSegErr := STRTOKARR(_cSegOut,";")
	Endif
	For nS := 1 to len(_aSegErr)
		nPos := AsCan(_aSegErr,{|x|x == _cRamo})
		If nPos != nS
			_cRamo1 := Alltrim(GetAdvFval("SX5","X5_DESCRI",xFilial("SX5")+"T3"+Alltrim(_aSegErr[nS]),1," "))
			_cSegErr += CHR(13)+_aSegErr[nS]+" - "+_cRamo1
		Endif
	Next
	_cDesRamo := Alltrim(GetAdvFval("SX5","X5_DESCRI",xFilial("SX5")+"T3"+M->A1_SATIV1,1," "))
	MSGINFO("O Segmento 1 é do Ramo "+_cDesRamo+"."+CHR(10)+CHR(13)+"Cadastre um dos Segmentos abaixo"+_cSegErr,"Segmentos")
	_lRet := .F.
Endif

Return _lRet