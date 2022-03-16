#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RCOMR023
Relatório de Ranking de Fornecedores
@type  Function
@author E.DINIZ - [ DS2U ]
@since 16/03/2022
/*/
User Function RCOMR023()

Local cPerg		:= 'XRCOMR023'
Local oReport	:= Nil

	If !(FwCodEmp() $ '01|10')
		Help(" ",1,"RCOMR0423_1",, "Este relatório é de uso exclusivo das empresas 01-Masipack e 10-Fabrima",1,0)
		Return
	Endif

	Pergunte(cPerg,.F.)
	oReport:= ReportDef(, cPerg)
	oReport:PrintDialog()

Return


/*/{Protheus.doc} User Function ReportDef
Definição do relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 16/03/2022
/*/
Static Function ReportDef(cTRB, cPerg)

Local cTitle	:= "Relação de Ranking de Fornecedores"
Local oReport	:= Nil
Local oSection	:= Nil

	oReport := TReport():New("RCOMR023",cTitle,cPerg,{|oReport| ReportPrint(oReport)},"Relacao de Ranking de Fornecedores")

	oSection := TRSection():New(oReport,'Ranking de Fornecedores',{})
	TRCell():New(oSection,	'SEQ',			'',	'Linha',					PesqPict('SA2','A2_COD'),		05)
	TRCell():New(oSection,	'A2COD',		'',	RetTitle('A2_COD'),			PesqPict('SA2','A2_COD'),		15)
	TRCell():New(oSection,	'A2LOJA',		'',	RetTitle('A2_LOJA'),		PesqPict('SA2','A2_LOJA'),		15)
	TRCell():New(oSection,	'A2NOME',		'',	RetTitle('A2_NOME'),		PesqPict('SA2','A2_NOME'),		TamSX3('A2_NOME')[1])
	TRCell():New(oSection,	'A2MSBLQL',		'',	RetTitle('A2_MSBLQL'),		PesqPict('SA2','A2_NOME'),		12					)
	TRCell():New(oSection,	'D1TOTAL',		'',	'VALOR',					PesqPict('SD1','D1_TOTAL'),		20					)
	TRCell():New(oSection,	'PARTIC',		'',	'% Partic.',				'@E 999.999'	,				12					)
	TRCell():New(oSection,	'VLACUM',		'',	'ACUMULADO',				'@E 999.99'	,					12					)
	TRCell():New(oSection,	'CLASSI',		'',	'CLASSIFICAÇÃO',			'@!'		,					12					)

Return oReport


/*/{Protheus.doc} User Function ReportPrint
Definição do relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 16/03/2022
/*/
Static Function ReportPrint(oReport)

Local aTotal	:= {0,0,0,0,0}
Local cTMP		:= GetNextAlias()
Local cRank		:= ''
Local cWhere	:= ''
Local nAcumula	:= 0
Local nReg		:= 0
Local oSection	:= oReport:Section(1)

	cWhere := '%'	
	If MV_PAR04 == 1
		cWhere += " AND D1_PEDIDO != ' ' "
	ElseIf  MV_PAR04 == 2
		cWhere += " AND D1_PEDIDO  = ' ' "
	EndIf

	If MV_PAR05 == 2        
		cWhere += " AND A2_NATUREZ IN ('A01','A05') "
	ElseIf MV_PAR05 == 3	
		cWhere += " AND A2_NATUREZ NOT IN ('A01','A05') "          
	EndIf	
	cWhere += '%'

	cRank := '%'
	If MV_PAR03 > 0       
		cRank += " WHERE TMP.ROWNUMBER <= " + Alltrim(Str(MV_PAR03))
	EndIf
	cRank += '%'

	BEGINSQL ALIAS cTMP

		SELECT * 
		FROM	(
				SELECT	ROW_NUMBER() OVER( ORDER BY D1_TOTAL DESC ) ROWNUMBER,
						TMPA.*
				FROM	
					(
						SELECT	A2_COD,
								A2_LOJA,
								A2_NOME,
								A2_NATUREZ,
								A2_MSBLQL,
								TOTAL,
								ROUND(SUM(D1_TOTAL),2) [D1_TOTAL],
								ROUND(SUM(D1_TOTAL_MP),2) [D1_TOTAL_MP],
								ROUND(SUM(D1_TOTAL_SV),2) [D1_TOTAL_SV],
								ROUND(SUM(D1_TOTAL_EX),2) [D1_TOTAL_EX],
								ROUND(SUM(D1_TOTAL_OU),2) [D1_TOTAL_OU],
								ROUND(((SUM(D1_TOTAL) / TOTAL ) * 100),4) [PARTIC] 
						FROM
							(	SELECT	A2_COD, A2_LOJA, A2_NOME, A2_NATUREZ,
										IIF(A2.A2_MSBLQL = '1', 'SIM', 'NAO') [A2_MSBLQL],
										
										(	SELECT	ROUND( SUM(AA.D1_TOTAL) + SUM(AA.D1_VALIPI),2 ) 
											FROM	%Table:SD1% AA, %Table:SA2% AB, %Table:SF4% AC
											WHERE	AA.D1_FILIAL = %xFilial:SD1% AND 
													AA.D1_DTDIGIT BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)% AND 
													AA.D1_TIPO IN ('N') AND
													AA.%NOTDEL% AND
													AB.A2_FILIAL = %xFilial:SA2% AND
													AB.A2_COD = AA.D1_FORNECE AND
													AB.A2_LOJA = AA.D1_LOJA AND
													AB.%NOTDEL%	AND
													AC.F4_FILIAL	= %xFilial:SF4%	AND
													AC.F4_CODIGO	= AA.D1_TES		AND
													AC.F4_DUPLIC	= %Exp:'S'%		AND
													AC.%NOTDEL%
													%Exp:cWhere%
													
										) [TOTAL],

										D1.D1_TOTAL + D1.D1_VALIPI [D1_TOTAL],
										IIF(F4.F4_CF IN ('1101','2101','1401','2401','1124','2124','1651','2651'),D1.D1_TOTAL + D1.D1_VALIPI,0) [D1_TOTAL_MP],
										IIF(F1.F1_ESPECIE IN ('NFS','NFSC','NFST','NTSC','NTST','NFFA','NFCEE'),D1.D1_TOTAL + D1.D1_VALIPI,0) [D1_TOTAL_SV],
										IIF(F4.F4_CF IN ('3101'),D1.D1_TOTAL + D1.D1_VALIPI,0) [D1_TOTAL_EX],
										IIF(F4.F4_CF NOT IN ('1101','2101','1401','2401','1124','2124','1651','2651') AND 
											F1.F1_ESPECIE NOT IN ('NFS','NFSC','NFST','NTSC','NTST','NFFA','NFCEE') AND 
											F4.F4_CF NOT IN ('3101'), D1.D1_TOTAL + D1.D1_VALIPI, 0) [D1_TOTAL_OU]

								FROM %Table:SD1% D1

								INNER JOIN %Table:SF1% F1 ON
								F1.F1_FILIAL	= D1.D1_FILIAL	AND
								F1.F1_DOC		= D1.D1_DOC		AND
								F1.F1_SERIE		= D1.D1_SERIE	AND
								F1.F1_FORNECE	= D1.D1_FORNECE AND
								F1.F1_LOJA		= D1.D1_LOJA	AND
								F1.F1_TIPO		= D1.D1_TIPO	AND
								F1.%NOTDEL%

								INNER JOIN %Table:SF4% F4 ON
								F4.F4_FILIAL	= %xFilial:SF4%	AND
								F4.F4_CODIGO	= D1.D1_TES		AND
								F4.F4_DUPLIC	= %Exp:'S'%		AND
								F4.%NOTDEL%

								INNER JOIN %Table:SA2% A2 ON
								A2.A2_FILIAL	= %xFilial:SA2%	AND
								A2.A2_COD		= D1.D1_FORNECE	AND
								A2.A2_LOJA		= D1.D1_LOJA	AND
								A2.%NOTDEL%

								WHERE	D1.D1_FILIAL	= %xFilial:SD1%	AND
										D1.D1_DTDIGIT	BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)% AND
										D1.D1_TIPO		IN ('N')	AND
										D1.%NOTDEL%				
										%Exp:cWhere%
							) TMPB
						GROUP BY A2_COD, A2_LOJA, A2_NOME, A2_NATUREZ, A2_MSBLQL, TOTAL
					) TMPA
				) TMP
		%Exp:cRank%

	ENDSQL

	(cTMP)->(dbEval({|| nReg++ },, { || (cTMP)->(!EOF()) } ) )
	(cTMP)->(dbGoTop())

	oReport:SetMeter(nReg)

	If (cTMP)->(!EOF())

		If MV_PAR06 == 2
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
		Endif

		oSection:Init()

		While (cTMP)->(!EOF())

			If (oReport:Cancel())
				Exit
			Endif

			nAcumula += (cTMP)->PARTIC

			aTotal[1] += (cTMP)->D1_TOTAL
			aTotal[2] += (cTMP)->D1_TOTAL_MP
			aTotal[3] += (cTMP)->D1_TOTAL_SV
			aTotal[4] += (cTMP)->D1_TOTAL_EX
			aTotal[5] += (cTMP)->D1_TOTAL_OU

			oSection:Cell("SEQ"):SetValue( (cTMP)->ROWNUMBER )
			oSection:Cell("A2COD"):SetValue( (cTMP)->A2_COD )
			oSection:Cell("A2LOJA"):SetValue( (cTMP)->A2_LOJA )
			oSection:Cell("A2NOME"):SetValue( (cTMP)->A2_NOME )
			oSection:Cell("A2MSBLQL"):SetValue( (cTMP)->A2_MSBLQL )
			oSection:Cell("D1TOTAL"):SetValue( (cTMP)->D1_TOTAL )
			oSection:Cell("PARTIC"):SetValue( (cTMP)->PARTIC )
			oSection:Cell("VLACUM"):SetValue( nAcumula )
			
			If Alltrim((cTMP)->A2_NATUREZ) == 'A05' .Or. ( Alltrim((cTMP)->A2_NATUREZ) == 'A01' .And. nAcumula < 80 )
				oSection:Cell("CLASSI"):SetValue( 'A' )
			Else
				oSection:Cell("CLASSI"):SetValue( 'B' )
			Endif
			oSection:PrintLine()

			If MV_PAR06 == 2
				If SA2->(DbSeek(FWxFilial('SA2') + (cTMP)->(A2_COD + A2_LOJA)))
					RecLock("SA2",.F.)
					SA2->A2_RISCO := IIF( Alltrim((cTMP)->A2_NATUREZ) == 'A05' .Or. ( Alltrim((cTMP)->A2_NATUREZ) == 'A01' .And. nAcumula < 80 ) , 'A', 'B')
					SA2->(MsUnLock())
				Endif
			Endif

			(cTMP)->(DbSkip())
		Enddo

		oSection:Finish()
		
		oReport:SkipLine(3)
		oReport:PrintText(PadR('T O T A L  G E R A L',40) + ;
						  PadR('PRODUTIVOS',40) +  ;
						  PadR('SERVIÇOS',40) + ;
						  PadR('IMPORTADOS',40) + ;
						  PadR('OUTROS',40), oReport:Row(), oSection:Cell('A2COD'):ColPos()+10)
		oReport:SkipLine()
		oReport:FatLine()
		oReport:SkipLine()
		oReport:PrintText(	PadR(Alltrim(Transform(aTotal[1],PesqPict('SD1','D1_TOTAL'))),40) + ;
							PadR(Alltrim(Transform(aTotal[2],PesqPict('SD1','D1_TOTAL'))),40) + ;
							PadR(Alltrim(Transform(aTotal[3],PesqPict('SD1','D1_TOTAL'))),40) + ;
							PadR(Alltrim(Transform(aTotal[4],PesqPict('SD1','D1_TOTAL'))),40) + ;
							PadR(Alltrim(Transform(aTotal[5],PesqPict('SD1','D1_TOTAL'))),40), oReport:Row(), oSection:Cell('A2COD'):ColPos()+10)
	
	Endif

	(cTMP)->(DbCloseArea())

Return
