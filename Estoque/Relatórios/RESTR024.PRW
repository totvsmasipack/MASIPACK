#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RESTR024
Relatório da impressão de lista de Separação com empenhos
@type  Function
@author E.DINIZ - [ DS2U ]
@since 18/03/2021
@version 2.0
/*/
User Function RESTR024()

Local cPerg		:= "XRESTR024"
Local oReport

Private lFoundLF	:= .F.
Private lEmpFound	:= .F.

	If Pergunte(cPerg,.T.)
        oReport := ReportDef(cPerg)
        oReport:PrintDialog()
    Endif

	If MV_PAR02 == 2 .And. lEmpFound .And. FwAlertYesNo('Deseja imprimir as etiquetas da Lista de Separação?') 
		FwMsgRun(,{|| LabelPrint(),'Aguarde','Imprindo Etiquetas..'},'Aguarde','Imprimindo Etiquetas..')
	Endif

Return


/*/{Protheus.doc} ReportDef
Definição do layout do Relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 18/03/2021
/*/
Static Function ReportDef(cPerg)

Local aOrdem	:= {"Por Local","Por Produto"}
Local cDesc     := "Este relatório imprimirá as Etiquetas Lista de separação"
Local cTitulo   := "Etiquetas Lista de separação"
Local oReport
Local oSection1
Local oSection2

    oReport := TReport():New("RESTR024",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cDesc)

    oSection1 := TRSection():New(oReport,"CABEC",{"SB1"},aOrdem)
	TRCell():New(oSection1,"D4_COD"		,"SD4"	,RetTitle("D4_COD")		,PesqPict("SD4","D4_COD")		,20)
	TRCell():New(oSection1,"B1_DESC"	,"SB1"	,RetTitle("B1_DESC")	,PesqPict("SB1","B1_DESC")		,50)
	TRCell():New(oSection1,"B1_LOCAL"	,"SB1"	,RetTitle("B1_LOCAL")	,PesqPict("SB1","B1_LOCAL")		,20)
	TRCell():New(oSection1,"D4_MSLF"	,"SD4"	,RetTitle("D4_MSLF")	,PesqPict("SD4","D4_MSLF")		,20)
	TRCell():New(oSection1,"D3_QUANT"	,"SD3"	,'Qtd. P/ Separar'		,PesqPict("SD4","D4_QUANT")		,30)
	
	oSection2 := TRSection():New(oReport,"CABEC",{"SB1"},aOrdem)
	TRCell():New(oSection2,"D4_COD"		,"SD4"	,RetTitle("D4_COD")		,PesqPict("SD4","D4_COD")		,20)
	TRCell():New(oSection2,"B1_DESC"	,"SB1"	,RetTitle("B1_DESC")	,PesqPict("SB1","B1_DESC")		,50)
	TRCell():New(oSection2,"B1_LOCAL"	,"SB1"	,RetTitle("B1_LOCAL")	,PesqPict("SB1","B1_LOCAL")		,20)
	TRCell():New(oSection2,"D4_MSLF"	,"SD4"	,RetTitle("D4_MSLF")	,PesqPict("SD4","D4_MSLF")		,20)
	TRCell():New(oSection2,"D4_QUANT"	,"SD4"	,'Qtd. P/ Falta'		,PesqPict("SD4","D4_QUANT")		,30)
	
//	TRFunction():New(oSection1:Cell("D4_COD"),NIL,"COUNT",/*oBreak1*/,"Total de Produtos P/ Separar",'@E 999999',/*{|| oSection1:Cell("D3_QUANT"):GetValue(.T.) }*/,.F.,.T.)
//	TRFunction():New(oSection2:Cell("D4_COD"),NIL,"COUNT",/*oBreak2*/,"Total de Produtos P/ Falta  ",'@E 999999',/*{|| oSection2:Cell("D3_QUANT"):GetValue(.T.) }*/,.F.,.T.)

Return oReport


/*/{Protheus.doc} PrintReport
Processa a impressão do relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 18/03/2021
/*/
Static Function PrintReport(oReport)

Local cAlias		:= ''
Local cD4MSIMPLI	:= ''
Local nOrientation	:= oReport:GetOrientation()
Local nMaxLin		:= IIF(nOrientation == 1, 2990 , 2000)
Local nOrdem		:= oReport:Section(1):GetOrder() 
Local oSection1  	:= oReport:Section(1)
Local oSection2  	:= oReport:Section(2)
Local lContinua		:= .T.

	oReport:SetMeter(0)

	dbSelectArea('SD4')
	SD4->(dbSetOrder(11))
	SD4->(dbSeek(FWxFilial("SD4") + PadR(MV_PAR01,TamSX3('D4_MSREFER')[1])))
	While SD4->(!EOF()) .And. FWCodEmp() $ '01' .And. SD4->(D4_FILIAL + D4_MSREFER) == FWxFilial("SD4") + PadR(MV_PAR01,TamSX3('D4_MSREFER')[1])
		If !Empty(SD4->D4_MSIMPLI)
			cD4MSIMPLI	:= DTOC(SD4->D4_MSIMPLI)
			FwAlertError('Referência impressa em: ' + cD4MSIMPLI, 'ATENÇÃO')
			lContinua := .F.
			Exit
		Endif
		SD4->(dbSkip())
	Enddo

	If lContinua
		
		cAlias := GetSD4Detail(.F.,nOrdem)	//Itens com saldo em estoque p/ separação

		oReport:PrintText('L I S T A  D E  S E P A R A Ç Ã O | REFERÊNCIA: ' + MV_PAR01 + IIF( !Empty(cD4MSIMPLI) , '  |  ' + "IMPRESSO EM: " + cD4MSIMPLI , '' ), oReport:Row(), oReport:Col()+10)
		oReport:SkipLine()
		oReport:FatLine()
			
		If (cAlias)->(!EOF())
			lEmpFound	:= .T.
			oSection1:Init()
			While (cAlias)->(!EOF())
				oSection1:Cell("D4_COD"):SetValue( (cAlias)->D4_COD )
				oSection1:Cell("B1_DESC"):SetValue( (cAlias)->B1_DESC )
				oSection1:Cell("B1_LOCAL"):SetValue( (cAlias)->B1_LOCAL )
				oSection1:Cell("D4_MSLF"):SetValue( (cAlias)->D4_MSLF )
				oSection1:Cell("D3_QUANT"):SetValue( (cAlias)->D3_QUANT )
				oSection1:PrintLine()

				If oReport:Row() == nMaxLin
					oSection1:Finish()
					oReport:EndPage(.T.)
					oReport:PrintText('L I S T A  D E  S E P A R A Ç Ã O | REFERÊNCIA: ' + MV_PAR01 + IIF( !Empty(cD4MSIMPLI) , '  |  ' + "IMPRESSO EM: " + cD4MSIMPLI , '' ), oReport:Row(), oReport:Col())
					oSection1:Init()
					oReport:SkipLine()
					oReport:FatLine()
				Endif

				(cAlias)->(dbSkip())
			Enddo
			oSection1:Finish()
		Else
			oReport:PrintText('Não há empenhos para separação', oReport:Row(), oReport:Col())
		Endif

		(cAlias)->(dbCloseArea())

		cAlias := GetSD4Detail(.T.,nOrdem)	//Itens sem saldo em estoque
		
		oReport:EndPage(.T.)
		oReport:PrintText('L I S T A  D E  F A L T A  | REFERÊNCIA: ' + MV_PAR01 + IIF( !Empty(cD4MSIMPLI) , '  |  ' + "IMPRESSO EM: " + cD4MSIMPLI , '' ), oReport:Row(), oReport:Col())
		oReport:SkipLine()
		oReport:FatLine()
		
		If (cAlias)->(!EOF())
			
			lFoundLF := .T.
			oSection2:Init()
			While (cAlias)->(!EOF())
				oSection2:Cell("D4_COD"):SetValue( (cAlias)->D4_COD )
				oSection2:Cell("B1_DESC"):SetValue( (cAlias)->B1_DESC )
				oSection2:Cell("B1_LOCAL"):SetValue( (cAlias)->B1_LOCAL )
				oSection2:Cell("D4_MSLF"):SetValue( (cAlias)->D4_MSLF )
				oSection2:Cell("D4_QUANT"):SetValue( (cAlias)->D4_QUANT )
				oSection2:PrintLine()

				If oReport:Row() >= nMaxLin
					oSection2:Finish()
					oReport:EndPage(.T.)
					oReport:PrintText('L I S T A  D E  F A L T A  | REFERÊNCIA: ' + MV_PAR01 + IIF( !Empty(cD4MSIMPLI) , '  |  ' + "IMPRESSO EM: " + cD4MSIMPLI , '' ), oReport:Row(), oReport:Col())
					oSection2:Init()
					oReport:SkipLine()
					oReport:FatLine()
				Endif

				(cAlias)->(dbSkip())
			Enddo
			oSection2:Finish()
		Else
			oReport:PrintText('Não há empenhos na lista de falta', oReport:Row(), oReport:Col())
			oReport:EndPage(.T.)
		Endif
		
		If !(lEmpFound) .And. !(lFoundLF)
			FwAlertError('Referência não vinculada a Ordem de Produção','TOTVS')
		Endif

		(cAlias)->(dbCloseArea())

		If Empty(cD4MSIMPLI)
			SD4->(dbGoTop())
			SD4->(dbSeek(FWxFilial("SD4") + PadR(MV_PAR01,TamSX3('D4_MSREFER')[1])))
			While SD4->(!EOF()) .And. SD4->(D4_FILIAL + D4_MSREFER) == FWxFilial("SD4") + PadR(MV_PAR01,TamSX3('D4_MSREFER')[1])
				If RecLock('SD4',.F.)
					SD4->D4_MSIMPLI := dDataBase
					SD4->(MsUnlock())
				Endif
				SD4->(dbSkip())
			Enddo
		Endif

	Endif
	
Return 


/*/{Protheus.doc} GetSD4Detail
Realiza a consulta dos empenhos das OP's associadas a um número de referência
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 18/03/2021
@version version
@param param_name, param_type, param_descr
@return cRet	| Character		| Arquivo de trabalho temporário
/*/
Static Function GetSD4Detail(lFalta,nOrdem)

Local cRet		:= GetNextAlias()
Local cOrder	:= IIF(nOrdem==1,'%B1_LOCAL, D4_COD%','%D4_COD,B1_LOCAL%')

	If !lFalta	//Busca empenhos com saldo

		BEGINSQL ALIAS cRet
		
			SELECT	D4_COD, B1_DESC, B1_LOCAL, D4_MSIMPLI,
					'Nao' AS D4_MSLF, SUM(D3_QUANT) AS D3_QUANT
			
			FROM	%Table:SD4% D4, %Table:SB1% B1, %Table:SD3% D3
			
			WHERE	D4_FILIAL = %xFilial:SD4%	AND
					D4_MSREFER = %Exp:MV_PAR01%	AND
					D4.%NOTDEL%					AND
					D3_FILIAL = D4_FILIAL 		AND
					D3_MSREFER = D4_MSREFER 	AND
					D3_OP = D4_OP 				AND
					D3_COD = D4_COD				AND
					D3_ESTORNO = %Exp:''%		AND
					D3_TM = %Exp:'603'%			AND
					SUBSTRING(D3_DOC,1,2) != %Exp:'OP'%	AND
					D3_TRT = D4_TRT				AND
					D3.%NOTDEL%					AND
					B1_FILIAL = D4_FILIAL		AND
					B1_COD = D4_COD				AND
					B1.%NOTDEL%
			
			GROUP BY D4_COD, B1_DESC, B1_LOCAL, D4_MSIMPLI
			ORDER BY %Exp:cOrder%
			
		ENDSQL

		If (cRet)->(EOF())

			(cRet)->(dbCloseArea())
			cRet := GetNextAlias()

			BEGINSQL ALIAS cRet

				SELECT	D4_COD, B1_DESC, B1_LOCAL, D4_MSIMPLI,
						'Nao' AS D4_MSLF, SUM(D3_QUANT) AS D3_QUANT
				
				FROM	%Table:SD4% D4, %Table:SB1% B1, %Table:SC2% C2,
						%Table:SD3% D3
				
				WHERE	D4_FILIAL = %xFilial:SD4%			AND
						D4.%NOTDEL%							AND
						D3_FILIAL = D4_FILIAL 				AND
						D3_MSREFER = D4_MSREFER 			AND
						D3_OP = D4_OP 						AND
						D3_COD = D4_COD						AND
						D3_ESTORNO = %Exp:''%				AND
						D3_TM = %Exp:'603'%					AND
						SUBSTRING(D3_DOC,1,2) != %Exp:'OP'%	AND
						D3_TRT = D4_TRT						AND
						D3.%NOTDEL%							AND
						B1_FILIAL = D4_FILIAL				AND
						B1_COD = D4_COD						AND
						B1.%NOTDEL%							AND
						B1_FILIAL = D4_FILIAL				AND 
						B1_COD = D4_COD						AND
						B1.%NOTDEL%							AND
						C2_FILIAL = D4_FILIAL				AND
						C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP	AND
						C2_MSREFER = %Exp:MV_PAR01%			AND
						C2.%NOTDEL%

				GROUP BY D4_COD, B1_DESC, B1_LOCAL, D4_MSIMPLI
				ORDER BY %Exp:cOrder%

			ENDSQL
		
		Endif
			
	Else

		BEGINSQL ALIAS cRet
		
			SELECT	D4_COD, B1_DESC, B1_LOCAL, D4_MSIMPLI,
					'Sim' AS D4_MSLF, SUM(D4_QUANT) AS D4_QUANT
			
			FROM	%Table:SD4% D4, %Table:SB1% B1
			
			WHERE	D4_FILIAL = %xFilial:SD4%	AND
					D4_QUANT > %Exp:0%			AND
					D4_MSREFER = %Exp:MV_PAR01%	AND
					D4_MSLF = %Exp:'X'%			AND
					D4.%NOTDEL%					AND
					B1_FILIAL = D4_FILIAL		AND
					B1_COD = D4_COD				AND
					B1.%NOTDEL%	
			
			GROUP BY D4_COD, B1_DESC, B1_LOCAL, D4_MSIMPLI
			ORDER BY %Exp:cOrder%

		ENDSQL

		If (cRet)->(EOF())

			(cRet)->(dbCloseArea())
			cRet := GetNextAlias()

			BEGINSQL ALIAS cRet

				SELECT	D4_COD, B1_DESC,B1_LOCAL, D4_MSIMPLI,
						'Sim' AS D4_MSLF, SUM(D4_QUANT) AS D4_QUANT
				
				FROM	%Table:SD4% D4, %Table:SB1% B1, %Table:SC2% C2,
				
				WHERE	D4_FILIAL = %xFilial:SD4%				AND
						D4_QUANT > %Exp:0%						AND
						D4_MSLF = %Exp:'X'%						AND
						D4.%NOTDEL%								AND
						B1_FILIAL = D4_FILIAL					AND
						B1_COD = D4_COD							AND
						B1.%NOTDEL%								AND
						C2_FILIAL = D4_FILIAL					AND
						C2_NUM + C2_ITEM + C2_SEQUEN = D4_OP	AND
						C2_MSREFER = %Exp:MV_PAR01%				AND
						C2.%NOTDEL%								
				
				GROUP BY D4_COD, B1_DESC, B1_LOCAL, D4_MSIMPLI
				ORDER BY %Exp:cOrder%

			ENDSQL
		
		Endif
	
	Endif

Return cRet


/*/{Protheus.doc} LabelPrint()
Impressão da Etiqueta
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 18/03/2021
@version version
/*/
Static Function LabelPrint()

Local cAlias	:= GetNextAlias()
Local cExec		:= "cmd /c net use LPT1: /delete"

	If FwAlertYesNo("Impressora de etiquetas está na porta LPT1?") 
		WaitRun(cExec)	// Deleta mapeamento LPT1
		MSCBPRINTER("OS 214","LPT1",NIL,)
	Else
		MSCBPRINTER("OS 214","COM1",NIL,)	
	EndIf

	BEGINSQL ALIAS cAlias
		
		SELECT	D4_COD, B1_DESC, B1_LOCAL, B1_UM, D4_OP, D4_MSREFER, SUM(D3_QUANT) AS D3_QUANT
		FROM	%Table:SD4% D4, %Table:SB1% B1, %Table:SD3% D3
		WHERE	D4_FILIAL = %xFilial:SD4%	AND
				D4_MSREFER = %Exp:MV_PAR01%	AND
				D4.%NOTDEL%					AND
				B1_FILIAL = D4_FILIAL		AND
				B1_COD = D4_COD				AND
				B1.%NOTDEL%					AND
				D3_FILIAL = D4_FILIAL 		AND
				D3_MSREFER = D4_MSREFER 	AND
				D3_OP = D4_OP 				AND
				D3_COD = D4_COD				AND
				D3_ESTORNO = %Exp:''%		AND
				D3_TM = %Exp:'603'%			AND
				SUBSTRING(D3_DOC,1,2) != %Exp:'OP'%	AND
				D3_TRT = D4_TRT				AND
				D3.%NOTDEL%
		GROUP BY D4_COD, B1_DESC, B1_LOCAL, B1_UM, D4_OP, D4_MSREFER
		ORDER BY B1_LOCAL, D4_OP, D4_COD

	ENDSQL

	If (cAlias)->(EOF())

		(cAlias)->(dbCloseArea())
		cAlias := GetNextAlias()

		BEGINSQL ALIAS cAlias

			SELECT	D4_COD, B1_DESC, B1_LOCAL, B1_UM, D4_OP, D4_MSREFER, SUM(D3_QUANT) AS D3_QUANT
			FROM	%Table:SD4% D4, %Table:SB1% B1, %Table:SC2% C2, %Table:SD3% D3
			WHERE	D4_FILIAL = %xFilial:SD4%				AND
					D4.%NOTDEL%								AND
					B1_FILIAL = D4_FILIAL					AND
					B1_COD = D4_COD							AND
					B1.%NOTDEL%								AND
					C2_FILIAL = D4_FILIAL					AND
					C2_NUM + C2_ITEM + C2_SEQUEN = D4_OP	AND
					C2_MSREFER = %Exp:MV_PAR01%				AND
					C2.%NOTDEL%								AND
					D3_FILIAL = D4_FILIAL 					AND
					D3_MSREFER = D4_MSREFER 				AND
					D3_OP = D4_OP 							AND
					D3_COD = D4_COD							AND
					D3_ESTORNO = %Exp:''%					AND
					D3_TM = %Exp:'603'%						AND
					SUBSTRING(D3_DOC,1,2) != %Exp:'OP'%		AND
					D3_TRT = D4_TRT							AND
					D3.%NOTDEL%
			GROUP BY D4_COD, B1_DESC, B1_LOCAL, B1_UM, D4_OP, D4_MSREFER
			ORDER BY B1_LOCAL, D4_OP, D4_COD

		ENDSQL
	
	Endif	

	MSCBCHKSTATUS(.F.)
		
	(cAlias)->(dbGoTop())
	
	DO WHILE (cAlias)->(!EOF())
		
		MSCBBEGIN(1,4)   
		If cEmpAnt $ "01"
			MSCBSAY(05,03,"Codigo.: " + (cAlias)->D4_COD, "B", "2", "01,01")
		Else
			MSCBSAY(05,03,"Codigo.:" +(cAlias)->D4_COD    ,"B","2","01,01")
			MSCBSAY(05,45,"LS"    ,"B","2","01,01")
		EndIf
		MSCBSAY(09,03,"Desc...:" + SUBSTR((cAlias)->B1_DESC,1,22),"B","2","01,01")
		MSCBSAY(13,03,"Cliente:" + SUBSTR( POSICIONE('SC2', 1, FWxFilial('SC2') + (cAlias)->D4_OP, 'C2_MSREDUZ'),1,22),"B","2","01,01")
		MSCBSAY(17,03,"Pedido.:" + POSICIONE('SC2', 1, FWxFilial('SC2') + (cAlias)->D4_OP, 'C2_MSPED')  ,"B","2","01,01")
		MSCBSAY(17,35," - "  	 + ALLTRIM(MV_PAR03)  ,"B","2","01,01")
		MSCBSAY(21,03,"Refer..:" + (cAlias)->D4_MSREFER,"B","2","01,01")
		MSCBSAY(25,03,"Quant..:" + TRANSFORM((cAlias)->D3_QUANT,"@E 9,999,999.999"),"B","2","01,01")
		MSCBSAY(25,35,"UM.:"	 + (cAlias)->B1_UM,"B","2","01,01")
		MSCBSAY(29,03,"Local..:" + (cAlias)->B1_LOCAL,"B","2","01,01")  
	
		If SUBSTR(cNumEmp,1,2) $ "01"
			DBSELECTAREA("SD3")
			SD3->(dbGoTop())
			DBORDERNICKNAME("REFER")
			If SD3->(DBSEEK(xFilial("SD3")+(cAlias)->D4_MSREFER+(cAlias)->B1_LOCAL+(cAlias)->D4_COD+(cAlias)->D4_OP))
				RecLock("SD3",.F.)
				SD3->D3_MSETIQU := 1
				SD3->(MsUnlock())
			EndIf
		EndIf
		
		(cAlias)->(dbSkip())
		
		IF (cAlias)->(!EOF())
			
			If cEmpAnt $ "01"
				MSCBSAY(35,03,"Codigo.: " + (cAlias)->D4_COD, "B", "2", "01,01")
			Else
				MSCBSAY(35,03,"Codigo.:" +(cAlias)->D4_COD    ,"B","2","01,01")
				MSCBSAY(35,45,"LS"    ,"B","2","01,01")
			EndIf
			MSCBSAY(39,03,"Desc...:" + SUBSTR((cAlias)->B1_DESC,1,22),"B","2","01,01")
			MSCBSAY(43,03,"Cliente:" + SUBSTR( POSICIONE('SC2', 1, FWxFilial('SC2') + (cAlias)->D4_OP, 'C2_MSREDUZ'),1,22),"B","2","01,01")
			MSCBSAY(47,03,"Pedido.:" + POSICIONE('SC2', 1, FWxFilial('SC2') + (cAlias)->D4_OP, 'C2_MSPED')  ,"B","2","01,01")
			MSCBSAY(47,35," - "  	 + ALLTRIM(MV_PAR03)  ,"B","2","01,01")
			MSCBSAY(51,03,"Refer..:" + (cAlias)->D4_MSREFER,"B","2","01,01")
			MSCBSAY(55,03,"Quant..:" + TRANSFORM((cAlias)->D3_QUANT,"@E 9,999,999.999"),"B","2","01,01")
			MSCBSAY(55,35,"UM.:"	 + (cAlias)->B1_UM,"B","2","01,01")
			MSCBSAY(59,03,"Local..:" + (cAlias)->B1_LOCAL,"B","2","01,01")  
		
			If SUBSTR(cNumEmp,1,2) $ "01"
				DBSELECTAREA("SD3")
				SD3->(dbGoTop())
				DBORDERNICKNAME("REFER")
				If SD3->(DBSEEK(xFilial("SD3")+(cAlias)->D4_MSREFER+(cAlias)->B1_LOCAL+(cAlias)->D4_COD+(cAlias)->D4_OP))
					RecLock("SD3",.F.)
					SD3->D3_MSETIQU := 1
					SD3->(MsUnlock())
				EndIf
			EndIf

			(cAlias)->(dbSkip())

			IF (cAlias)->(!EOF())
				
				If cEmpAnt $ "01"
					MSCBSAY(65,03,"Codigo.: " + (cAlias)->D4_COD, "B", "2", "01,01")
				Else
					MSCBSAY(65,03,"Codigo.:" +(cAlias)->D4_COD    ,"B","2","01,01")
					MSCBSAY(65,45,"LS"    ,"B","2","01,01")
				EndIf
				MSCBSAY(69,03,"Desc...:" + SUBSTR((cAlias)->B1_DESC,1,22),"B","2","01,01")
				MSCBSAY(73,03,"Cliente:" + SUBSTR( POSICIONE('SC2', 1, FWxFilial('SC2') + (cAlias)->D4_OP, 'C2_MSREDUZ'),1,22),"B","2","01,01")
				MSCBSAY(77,03,"Pedido.:" + POSICIONE('SC2', 1, FWxFilial('SC2') + (cAlias)->D4_OP, 'C2_MSPED')  ,"B","2","01,01")
				MSCBSAY(77,35," - "  	 + ALLTRIM(MV_PAR03)  ,"B","2","01,01")
				MSCBSAY(81,03,"Refer..:" + (cAlias)->D4_MSREFER,"B","2","01,01")
				MSCBSAY(85,03,"Quant..:" + TRANSFORM((cAlias)->D3_QUANT,"@E 9,999,999.999"),"B","2","01,01")
				MSCBSAY(85,35,"UM.:"	 + (cAlias)->B1_UM,"B","2","01,01")
				MSCBSAY(89,03,"Local..:" + (cAlias)->B1_LOCAL,"B","2","01,01")  
			
				If SUBSTR(cNumEmp,1,2) $ "01"
					DBSELECTAREA("SD3")
					SD3->(dbGoTop())
					DBORDERNICKNAME("REFER")
					If SD3->(DBSEEK(xFilial("SD3")+(cAlias)->D4_MSREFER+(cAlias)->B1_LOCAL+(cAlias)->D4_COD+(cAlias)->D4_OP))
						RecLock("SD3",.F.)
						SD3->D3_MSETIQU := 1
						SD3->(MsUnlock())
					EndIf
				EndIf

				(cAlias)->(dbSkip())

			ELSE
				
				MSCBEND() //Fim da Imagem da Etiqueta
				EXIT
			
			ENDIF
		
		ELSE
			
			MSCBEND() //Fim da Imagem da Etiqueta
			EXIT
		
		ENDIF
		
		MSCBEND() //Fim da Imagem da Etiqueta
	
	ENDDO
	
	MSCBEND() //Fim da Imagem da Etiqueta
	
	MSCBCLOSEPRINTER()

	(cAlias)->(dbCloseArea())

Return
