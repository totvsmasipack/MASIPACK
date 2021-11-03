#include 'totvs.ch'
#include 'protheus.ch'

/*/{Protheus.doc} User Function RESTR043
Relatório de Dados do produto do cliente
@type  Function
@author E.DINIZ - [ DS2U ]
@since 09/08/2021
/*/
User Function RESTR043()
    
Local aArea	:= { SA1->(GetArea()), SA2->(GetArea()), SB1->(GetArea()), ZZ2->(GetArea()) }

	dbSelectArea('SA1')
	SA1->(dbSetOrder(1))

	dbSelectArea('SA2')
	SA2->(dbSetOrder(1))

	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))

	dbSelectArea('ZZ2')
	ZZ2->(dbSetOrder(1))

	oReport := ReportDef()
	oReport:PrintDialog()

	AEval(aArea, {|x| RestArea(x) })

Return

/*/{Protheus.doc} ReportDef
Definição do layout do relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 09/08/2021
@version version
/*/
Static Function ReportDef()

Local cDesc     := "Este relatório imprimirá as informações do produto do cliente"
Local cTitulo   := "Informações do Produto do Cliente"
Local oReport
Local oSection1

    oReport := TReport():New("RESTR043", cTitulo, , {|oReport| PrintReport(oReport)}, cDesc)
	oReport:oPage:setPaperSize(10)
	oReport:nFontBody := 12
	oReport:cFontBody := "Courier New"

    oSection1 := TRSection():New(oReport,"REPORT")

Return oReport


/*/{Protheus.doc} PrintReport
Impressão dos dados no relatório
@type  Static Function
@author E.DINIZ - [ DS2U ]
@since 09/08/2021
@version version
/*/
Static Function PrintReport(oReport)

Local cKey		:= ''
Local oFont16B	:= TFont():New('Arial',,16,.T.)
Local oSection	:= oReport:Section(1)
	
	cKey := ZZ2->(ZZ2_FILIAL + ZZ2_DOC + ZZ2_SERIE + ZZ2_CLIENT + ZZ2_LOJA)

	While ZZ2->(!EOF()) .And. ZZ2->(ZZ2_FILIAL + ZZ2_DOC + ZZ2_SERIE + ZZ2_CLIENT + ZZ2_LOJA) == cKey

		oSection:Init()
		
		oReport:PrintText( Padr('Nota Fiscal / Item:',20) +  Padr(Alltrim(ZZ2->ZZ2_DOC)+'-'+ALLTRIM(ZZ2->ZZ2_SERIE)+ ' / '+ZZ2->ZZ2_ITEM,60), oReport:Row(), oReport:Col()+10 )
		oReport:SkipLine(2)
		oReport:PrintText( Padr( IIF(ZZ2->ZZ2_CLIFOR=='C','Cliente:','Fornecedor:'),20) + ZZ2->ZZ2_CLIENT+'/'+ZZ2->ZZ2_LOJA+' - '+Alltrim(POSICIONE( IIF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2'),1 , FWxFilial(IIF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2')) + ZZ2->(ZZ2_CLIENT+ZZ2_LOJA), IIF(ZZ2->ZZ2_CLIFOR=='C','A1_NOME','A2_NOME') )), oReport:Row(), oReport:Col() )
		oReport:SkipLine(2)
		oReport:PrintText( Padr('Contato:',20) + Alltrim(POSICIONE( IIF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2'),1 , FWxFilial(IIF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2')) + ZZ2->(ZZ2_CLIENT+ZZ2_LOJA), IIF(ZZ2->ZZ2_CLIFOR=='C','','A2_CONTATO') )), oReport:Row(), oReport:Col() )
		oReport:SkipLine(2)
		oReport:PrintText( Padr('Telefone:',20 ) + Alltrim(POSICIONE( IIF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2'),1 , FWxFilial(IIF(ZZ2->ZZ2_CLIFOR=='C','SA1','SA2')) + ZZ2->(ZZ2_CLIENT+ZZ2_LOJA), IIF(ZZ2->ZZ2_CLIFOR=='C','A1_TEL','A2_TEL') )), oReport:Row(), oReport:Col() )
		oReport:SkipLine(2)
		oReport:PrintText( Padr('Produto:',20) + Alltrim(ZZ2->ZZ2_COD) +' - '+ Alltrim(POSICIONE('SB1',1,FWxFilial('SB1')+PadR(ZZ2->ZZ2_COD,TamSX3('B1_COD')[1]),'B1_DESC')), oReport:Row(), oReport:Col() )
		oReport:SkipLine(2)
		oReport:PrintText( Padr('Quantidade:',20) + Alltrim(Transform(ZZ2->ZZ2_QUANT,PesqPict('ZZ2','ZZ2_QUANT')) +' '+ Alltrim(POSICIONE('SB1',1,FWxFilial('SB1')+PadR(ZZ2->ZZ2_COD,TamSX3('B1_COD')[1]),'B1_UM'))), oReport:Row(), oReport:Col() )

		oReport:SkipLine(2)
		oReport:ThinLine()
		oReport:SkipLine(5)

		oReport:Say(oReport:Row(), oReport:Col()+130, 'V E R I F I C A Ç Ã O', oFont16B)
		oReport:SkipLine(3)
		oReport:PrintText( 'O Produto possui etiqueta de identificação: ' + IIF(ZZ2->ZZ2_ETIQ=='S','Sim','Não'), oReport:Row(), oReport:Col()+200 )
		oReport:SkipLine(2)
		oReport:PrintText( 'O Produto possui impureza: ' + IIF(ZZ2->ZZ2_IMPURE=='S','Sim','Não'), oReport:Row(), oReport:Col()+200 )
		oReport:SkipLine(2)
		oReport:PrintText( 'O Produto possui avarias: ' + IIF(ZZ2->ZZ2_AVARIA=='S','Sim','Não'), oReport:Row(), oReport:Col()+200 )

		oReport:SkipLine(8)

		oReport:Say(oReport:Row(), oReport:Col()+130, 'A R M A Z E N A G E M', oFont16B)
		oReport:SkipLine(3)
		oReport:PrintText( 'O Produto requer local fresco e arejado: ' + IIF(ZZ2->ZZ2_LOCARM=='S','Sim','Não'), oReport:Row(), oReport:Col()+200 )
		oReport:SkipLine(2)
		oReport:PrintText( 'O Produto requer abrigo para proteção de luz solar ou chuva: ' + IIF(ZZ2->ZZ2_SOLCHV=='S','Sim','Não') , oReport:Row(), oReport:Col()+200 )
		oReport:SkipLine(2)
		oReport:PrintText( 'O Produto requer empilhamento máximo: ' + IIF(ZZ2->ZZ2_EMPILH == 0, '-', Str(ZZ2->ZZ2_EMPILH)), oReport:Row(), oReport:Col()+200 )

		oReport:SkipLine(8)

		oReport:Say(oReport:Row(), oReport:Col()+130, 'T E M P E R A T U R A', oFont16B)
		oReport:SkipLine(3)
		oReport:PrintText( 'O Produto requer armazenagem com temperatura controlada: ' + IIF(ZZ2->ZZ2_CTRTEM=='S', 'Sim ' + ZZ2->ZZ2_TEMPER, 'Não'), oReport:Row(), oReport:Col()+200 )
		oReport:SkipLine(2)
		oReport:PrintText( 'O Produto possui recomendação de embalagem: ' + IIF(ZZ2->ZZ2_RECOME == 'S', ALLTRIM(ZZ2->ZZ2_TXTREC), 'Não'), oReport:Row(), oReport:Col()+200 )


		oReport:SkipLine(8)

		oReport:Say(oReport:Row(), oReport:Col()+130, 'E N C A M I N H A M E N T O', oFont16B)
		oReport:SkipLine(3)
		oReport:PrintText( 'Encaminhado para: ' + Alltrim(ZZ2->ZZ2_RESP), oReport:Row(), oReport:Col()+200 )
		oReport:PrintText( 'Data: ' + DTOC(ZZ2->ZZ2_DATA), oReport:Row(), oReport:Col()+70 )
		oReport:SkipLine(2)
		oReport:PrintText( 'Encaminhado por: ' + Alltrim(ZZ2->ZZ2_RESP), oReport:Row(), oReport:Col()+200 )

		oReport:SkipLine(8)

		oReport:Say(oReport:Row(), oReport:Col()+130, 'O B S E R V A Ç Õ E S', oFont16B)
		oReport:SkipLine(3)
		oReport:PrintText( ZZ2->ZZ2_OBS, oReport:Row(), oReport:Col()+200 )

		oSection:Finish()

		oReport:EndPage()

		ZZ2->(dbSkip())
	Enddo

Return
