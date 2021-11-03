USER FUNCTION PE01NFESEFAZ()
	Local nDi		
	Local aProd     := PARAMIXB[1]
	Local cMensCli  := PARAMIXB[2]
	Local cMensFis  := PARAMIXB[3]
	Local aDest     := PARAMIXB[4] 
	Local aNota     := PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl     := PARAMIXB[7]
	Local aTransp   := PARAMIXB[8]
	Local aEntrega  := PARAMIXB[9]
	Local aRetirada := PARAMIXB[10]
	Local aVeiculo  := PARAMIXB[11]
	Local aReboque  := PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol 	:= PARAMIXB[14]
	Local aObsCont	:= PARAMIXB[15]
	Local aRetorno  := {}
	Local nRet		:= 0
	Local _cNumPV	:= ""
	Local _aPesTot	:= {}
	Local cAliasFT	:= GetNextAlias()
	
	// Ivandro Santos - 13/07/17
	// Ticket #2017070537000128 — UNIDADE DE MEDIDAS EXPORTAÇÕES
	Local _aNCM		:= {{"23040010","TON"},;
						{"12019000","TON"},;
						{"15071000","TON"}}
	// Ticket #2017070537000128 — Fim da alteração
	
	Private aAreaAtu := GetArea()
	
	//O retorno deve ser exatamente nesta ordem e passando o conteúdo completo dos arrays
	//pois no rdmake nfesefaz é atribuido o retorno completo para as respectivas variáveis
	//Ordem:
	//      aRetorno[1] -> aProd
	//      aRetorno[2] -> cMensCli
	//      aRetorno[3] -> cMensFis
	//      aRetorno[4] -> aDest
	//      aRetorno[5] -> aNota
	//      aRetorno[6] -> aInfoItem
	//      aRetorno[7] -> aDupl
	//      aRetorno[8] -> aTransp
	//      aRetorno[9] -> aEntrega
	//      aRetorno[10] -> aRetirada
	//      aRetorno[11] -> aVeiculo
	//      aRetorno[12] -> aReboque
	//      aRetorno[13] -> aNfVincRur
	// 		aRetorno[14] -> aEspVol
	//		aRetorno[14] -> aNfVinc
	//		aRetorno[14] -> AdetPag
	//		aRetorno[15] -> aObsCont

	// Ivandro Santos - 11/01/2017 - Início da alteração
	// Ticket #2016112437000185 — PROBLEMAS NA EMISSAO DE NF DE IMPORTACAO
	If SFT->FT_TIPOMOV == "E" .And. SFT->FT_ESTADO == "EX"
		For nDi := 1 to len(aProd)
			DbSelectArea("SD1")
			DbSetOrder(1)
			If DbSeek(xFilial("SD1")+aNota[2]+aNota[1]+SFT->(FT_CLIEFOR+FT_LOJA)+aProd[nDi][2]+aInfoItem[nDi][4])
				If SD1->D1_II > 0
					aProd[nDi][10] := aProd[nDi][10] - SD1->D1_II
				Endif
			Endif                    
		Next
	Endif
	// Ticket #2016112437000185 — Fim da alteração
	
	// Ticket #2017070537000128 — UNIDADE DE MEDIDAS EXPORTAÇÕES
	If (SFT->FT_TIPOMOV == "S" .And. SFT->FT_ESTADO == "EX") .OR. SFT->FT_CFOP = "5505"
		_cNumPV  := GetAdvFVal("SD2","D2_PEDIDO",xFilial("SD2")+SFT->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM),3," ")
		_aPesTot := GetAdvFVal("SC5",{"C5_PESOL","C5_PBRUTO"},xFilial("SC5")+_cNumPV,1," ")
		BeginSQL Alias cAliasFT
			SELECT SUM(D2_QUANT) 'QTDD2' FROM %table:SD2% D2 WHERE D2_FILIAL = %xFilial:SD2% AND D2_DOC = %exp:SFT->FT_NFISCAL% AND D2.%notdel%
		EndSQL
		While !(cAliasFT)->(EOF())
			_nQTot := (cAliasFT)->QTDD2
			(cAliasFT)->(DbSkip())
		EndDo
		For nDi := 1 to len(aProd)
		    nRet := 0
		    _cUniNCM := GetAdvFVal("SYD","YD_UNID",xFilial("SYD")+Alltrim(aProd[nDi][5]),1," ")
	        nRet := ascan(_aNCM,{|x| x[1] == Alltrim(aProd[nDi][5]) })
	        If nRet > 0
				aProd[nDi][11] := _aNCM[nRet][2]
				aProd[nDi][12] := ROUND(_aPesTot[1]/_nQTot*aProd[nDi][09],4)
			ElseiF Alltrim(_cUniNCM) <> Alltrim(aProd[nDi][08])   
			   	aProd[nDi][11] := _cUniNCM
			   	If Alltrim(_cUniNCM)=="KG"
			   		AProd[nDi][12] := ROUND(_aPesTot[1]/_nQTot*aProd[nDi][09],4)
			   	EndIf
			Endif
		Next nDi
	EndIf
	
	If Select(cAliasFT) > 0
		(cAliasFT)->(dbCloseArea())
	EndIf
	
	aadd(aRetorno,aProd) 
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aObsCont)
	////Ticket#2017070537000128 — Fim da alteração 
	
	RestArea(aAreaAtu)
	 
RETURN aRetorno