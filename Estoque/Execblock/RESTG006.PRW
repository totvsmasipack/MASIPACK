#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RESTG006
Função utilizada nos PE's MT380GRV e MT381GRV para atualização da Lista de Falta
@type  Function
@author E.DINIZ - [ DS2U ]
@since 18/10/2021
@param	xParam	-	Array
		xParam[1]	->	Código da Empresa	(FWCodEmp())
		xParam[2]	->	Nome da Rotina		(FUNNAME())
		xParam[3]	->	Número da Ordem de Produção
/*/
User Function RESTG006(xParam)

Local _nColProd	:= 0
Local _nColTRT	:= 0
Local _nX		:= 0

	Do Case

		Case xParam[1] $ '01|10' .And. xParam[2] == "MATA380"

			DbSelectArea('SB1')
			SB1->(DbSetOrder(1))
			SB1->(DbSeek( FWxFilial('SB1') + Padr(SD4->D4_COD, TamSX3('B1_COD')[1]) ))

			MSUPDSD4({ xParam[3], SD4->D4_COD, SB1->B1_GRUPO, SD4->D4_TRT })

		Case xParam[1] $ '01|10' .And. xParam[2] == "MATA381"

			_nColProd	:= aScan(aHeader,{|x| Alltrim(x[2]) == 'D4_COD' })
			_nColTRT	:= aScan(aHeader,{|x| Alltrim(x[2]) == 'D4_TRT' })

			DbSelectArea('SB1')
			SB1->(DbSetOrder(1))

			For _nX := 1 To Len(aCols)
				
				SB1->(DbSeek( FWxFilial('SB1') + Padr(aCols[_nX,_nColProd], TamSX3('B1_COD')[1]) ))
				
				MSUPDSD4({ xParam[3], aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2]) == 'D4_COD' })], SB1->B1_GRUPO, aCols[_nX][aScan(aHeader,{|x| Alltrim(x[2]) == 'D4_TRT' })] })
			
			Next _nX

	EndCase
    
Return


/*/{Protheus.doc} MSUPDSD4
Atualização da Lista de Falta
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 18/10/2021
@param	xParam	-	Array
		xParam[1]	->	Número da Ordem de Produção
		xParam[2]	->	Código do Produto/Componente
		xParam[3]	->	Código do Grupo de Produto/Componente
		xParam[4]	->	Código do Sequencial do Componente (TRT)
/*/
Static Function MSUPDSD4(xParam)

Local cTMP	:= GetNextAlias()
Local cQuery	:= ''
	
	cQuery := "SELECT	B1_GRUPO, D4_OP, D4_MSREFER" + CRLF
	cQuery += "FROM "+RetSQLName('SD4')+"	D4" + CRLF
	cQuery += CRLF
	cQuery += "	INNER JOIN "+RetSQLName('SB1')+" B1 ON" + CRLF
	cQuery += "	B1_FILIAL	=	D4_FILIAL	AND" + CRLF
	cQuery += "	B1_COD		=	D4_COD		AND" + CRLF
	cQuery += "	B1_GRUPO	=	'"+xParam[3]+"'		AND" + CRLF
	cQuery += "	B1.D_E_L_E_T_	=	' '" + CRLF
	cQuery += CRLF
	cQuery += "WHERE" + CRLF
	cQuery += "	D4_FILIAL	=	'"+FWxFilial('SD4')+"'			AND" + CRLF
	cQuery += "	D4_OP		=	'"+xParam[1]+"'	AND" + CRLF
	cQuery += "	D4_MSREFER	!=	''				AND" + CRLF
	cQuery += "	D4.D_E_L_E_T_	=	' '" + CRLF
	cQuery += "	GROUP BY B1_GRUPO, D4_OP, D4_MSREFER"
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cTMP)

	DbSelectArea('SD4')
	SD4->(DbSetOrder(1))	//D4_FILIAL + D4_COD + D4_OP + D4_TRT + D4_LOTECTL + D4_NUMLOTE

	While (cTMP)->(!EOF())

		SD4->( DbSeek( FWxFilial('SD4') + PadR(xParam[2],TamSX3('D4_COD')[1]) + PadR(xParam[1],TamSX3('D4_OP')[1]) + PadR(xParam[4],TamSX3('D4_TRT')[1]) ) )

		If SD4->(FOUND()) .And. !EMPTY( (cTMP)->D4_MSREFER )
			Reclock('SD4',.F.)
			SD4->D4_MSREFER := (cTMP)->D4_MSREFER
			SD4->D4_MSLF	:= 'X'
			SD4->D4_MSDTLF  := dDataBase
			SD4->(MsUnlock())
		Endif

		(cTMP)->(DbSkip())

	Enddo

	(cTMP)->(DbCloseArea())

Return
