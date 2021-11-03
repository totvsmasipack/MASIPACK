#include 'protheus.ch'
#include 'parmtype.ch'

User Function RFATR079()

Local cAliasC6  := GetNextAlias()
Local nLastkey	:= 0
Local cPerg		:= "FATR78"

_lRet := Pergunte(cPerg)

If nLastKey == 27 .Or. !_lRet
	ApMsgAlert("Cancelado pelo usuário")
	Return
Endif

MsAguarde({||FATR79QRY(cAliasC6)}, OemToAnsi("Gerando Dados") )
MsAguarde({||FATR79TXT(cAliasC6)}, OemToAnsi("Gerando Planilha") )	

return

Static Function FATR79QRY(cAliasC6) 
Local cWhere := "" 
Local nA

If LEN(ALLTRIM(MV_PAR03)) > 1
	aCampos := StrToKArr(MV_PAR03,";")
	cWhere += "% C5_MSCATEG IN ("
	For nA := 1 to len(aCampos)
		If nA = 1
			cWhere += "'"+Alltrim(aCampos[nA])+"'"
		Else
			cWhere += ",'"+Alltrim(aCampos[nA])+"'"
		EndIf
	Next
	cWhere += ") %"
ElseIf LEN(ALLTRIM(MV_PAR03)) = 1
	cWhere := "%C5_MSCATEG = '"+Alltrim(aCampos[nA])+"'%"
Else
	cWhere := "%C5_MSCATEG = '3'%
EndIf

BeginSQL Alias cAliasC6
	SELECT DISTINCT(C6_NUM) 'PEDIDO',
		SUBSTRING(C6_DATFAT,1,6) 'MES',
		A1_NREDUZ 'CLIENTE',
		A1_TEL ,
		A1_EMAIL , 
		CASE WHEN patindex('%@%',CONVERT(VARCHAR(2048),CONVERT(VARBINARY(2048),C5_OBS))) > 0 THEN 
			SUBSTRING(CONVERT(VARCHAR(2048),CONVERT(VARBINARY(2048),C5_OBS)), 
			patindex('%@%',CONVERT(VARCHAR(2048),CONVERT(VARBINARY(2048),C5_OBS)))-20,patindex('%.COM%',CONVERT(VARCHAR(2048),CONVERT(VARBINARY(2048),C5_OBS)))+45)  
		ELSE '' END AS 'EMAIL_PEDIDO'  
	FROM %Table:SC6% C6 
	INNER JOIN %Table:SC5% C5 ON 
		C5_FILIAL = %xFilial:SC5% AND 
		C6_NUM = C5_NUM AND 
		C5.%NotDel%   
	INNER JOIN %Table:SA1% A1 ON 
		A1_FILIAL = %xFilial:SA1% AND 
		A1_COD+A1_LOJA = C6_CLI+C6_LOJA AND 
		A1_MSBLQL <> '1' AND 
		A1.%NotDel% 
	WHERE 
		C6.C6_NOTA <> '' AND 
		C5_TIPO = 'N' AND 
		C6_DATFAT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
		%Exp:cWhere% AND
		C6.%NotDel%  
	ORDER BY SUBSTRING(C6_DATFAT,1,6),C6_NUM
EndSQL

Return

Static Function FATR79TXT(cAliasC6)

Local _cA1_EMAIL:= ""
Local _cA1_EMPED:= ""
Local cCaminho 	:= "C:\RELATO_MICROSIGA\EMAIL_CLIENTES.CSV"
Local cNomTrb	:= FCreate(cCaminho,0)
Local cLinha	:= ""

//Exclui arquivo criado anteriormente
fErase(cCaminho) 

cLinha := "PEDIDO;MÊS;CLIENTE;TELEFONE_CADASTRAO;EMAIL_CADASTRO;EMAIL_PEDIDO"
fWrite(cNomTrb,cLinha)

	(cAliasC6)->(DBGotop())
	While (cAliasC6)->(!Eof())
		_cA1_EMAIL := STRTRAN(ALLTRIM((cAliasC6)->A1_EMAIL),";","|")
		_cA1_EMPED := STRTRAN(ALLTRIM((cAliasC6)->EMAIL_PEDIDO),";","|")
		_cA1_EMAIL := STRTRAN(ALLTRIM(_cA1_EMAIL),CHR(13)+CHR(10)," ")
		_cA1_EMPED := STRTRAN(ALLTRIM(_cA1_EMPED),CHR(13)+CHR(10)," ")
		cLinha := (cAliasC6)->PEDIDO	+ ";"
		cLinha += (cAliasC6)->MES		+ ";"
		cLinha += (cAliasC6)->CLIENTE	+ ";"
		cLinha += (cAliasC6)->A1_TEL	+ ";"
		cLinha += _cA1_EMAIL	 		+ ";"
		cLinha += _cA1_EMPED
	
		fWrite(cNomTrb,CHR(13)+CHR(10)+cLinha)

		(cAliasC6)->(dbSkip())
	EndDo

If Select(cAliasC6) > 0
	(cAliasC6)->(DbCloseArea())
Endif

fClose(cNomTrb)

Return