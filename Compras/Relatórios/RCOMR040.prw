#Include "Comr040.ch"
#Include "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR160  � Autor � Nereu Humberto Junior � Data � 31.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao das Cotacoes em aberto                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR160(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RCOMR040()
Local oReport

	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �31.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oSection1 
Local oSection2

	//������������������������������������������������������������������������Ŀ
	//�Criacao do componente de impressao                                      �
	//�                                                                        �
	//�TReport():New                                                           �
	//�ExpC1 : Nome do relatorio                                               �
	//�ExpC2 : Titulo                                                          �
	//�ExpC3 : Pergunte                                                        �
	//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
	//�ExpC5 : Descricao                                                       �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport := TReport():New("RCOMR040",STR0003,"MTR160", {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002) //"Cotacoes em Aberto"##"Emite o relatorio de cotacoes em aberto por ordem"##"de Numero, Produto e Valor do menor para o maior."
	Pergunte("MTR160",.F.)

	oSection1 := TRSection():New(oReport,STR0014,{"SC8"}) //"Cotacoes em Aberto"

	TRCell():New(oSection1,"C8_NUM","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C8_VALIDA","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection2 := TRSection():New(oSection1,STR0015,{"SC8","SA2"}) //"Cotacoes em Aberto"
	oSection2 :SetHeaderPage()

	TRCell():New(oSection2,"C8_PRODUTO","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C8_FORNECE","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C8_LOJA","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C8_NUMSC","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C8_ITEMSC","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"nCusto","   ",STR0013,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Valor Presente"
	TRCell():New(oSection2,"C8_PRAZO","SC8",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"A2_DESVIO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �31.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cAliasSC8 := "SC8"
Local cCotacao  := ""
Local cProduto  := ""
Local aRelImp   := MaFisRelImp("MT150",{"SC8"})
Local nCusto    := 0
Local nY         

	//������������������������������������������������������������������������Ŀ
	//�Filtragem do relat�rio                                                  �
	//��������������������������������������������������������������������������
	dbSelectArea("SC8")
	dbSetOrder(3)

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �	
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	

	cAliasSC8 := GetNextAlias()

	BeginSql Alias cAliasSC8

	SELECT SC8.*, SA2.* 

	FROM %table:SC8% SC8,%table:SA2% SA2

	WHERE SC8.C8_FILIAL = %xFilial:SC8% AND 
		SC8.C8_NUM >= %Exp:mv_par01% AND 
		SC8.C8_NUM <= %Exp:mv_par02% AND 
		SC8.C8_NUMPED = ' ' AND
		SC8.%notDel% AND
			SA2.A2_FILIAL = %xFilial:SA2% AND
			SA2.A2_COD = SC8.C8_FORNECE AND
			SA2.A2_LOJA = SC8.C8_LOJA AND
		SA2.%NotDel%
		
	ORDER BY C8_FILIAL,C8_NUM,C8_PRODUTO,C8_TOTAL 
			
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	oSection2:SetParentQuery()

	oSection2:Cell("nCusto"):SetPicture(PesqPict("SC8","C8_PRECO"))

	//������������������������������������������������������������������������Ŀ
	//�Inicio da impressao do fluxo do relat�rio                               �
	//��������������������������������������������������������������������������

	oReport:SetMeter(SC8->(LastRec()))

	dbSelectArea(cAliasSC8)
	While !oReport:Cancel() .And. !(cAliasSC8)->(Eof())

		If oReport:Cancel()
			Exit
		EndIf
		
		oReport:IncMeter()
		
		cCotacao := (cAliasSC8)->C8_NUM  
		
		oSection1:Init()
		oSection1:PrintLine()
		oSection1:Finish()
		
		While !oReport:Cancel() .And. !(cAliasSC8)->(Eof()) .And. (cAliasSC8)->C8_FILIAL+(cAliasSC8)->C8_NUM == xFilial("SC8")+cCotacao
			
			If oReport:Cancel()
				Exit
			EndIf
			
			//������������������������������������������������������������������������Ŀ
			//� Calculo do custo da Cotacao                                            �
			//��������������������������������������������������������������������������
			MaFisIni((cAliasSC8)->C8_FORNECE,(cAliasSC8)->C8_LOJA,"F","N","R",aRelImp)
			MaFisIniLoad(1)
			For nY := 1 To Len(aRelImp)
				MaFisLoad(aRelImp[nY][3],(cAliasSC8)->(FieldGet(FieldPos(aRelImp[nY][2]))),1)
			Next nY
			MaFisEndLoad(1)
			nCusto := Ma160Custo((cAliasSC8),1)
			MaFisEnd()

			dbSelectArea(cAliasSC8)
			oSection2:Init()

			
			If cProduto  <> (cAliasSC8)->C8_PRODUTO
				oSection2:Cell("C8_PRODUTO"):Show()
				cProduto := (cAliasSC8)->C8_PRODUTO
			Else
				oSection2:Cell("C8_PRODUTO"):Hide()
			Endif
			
			oSection2:Cell("nCusto"):SetValue(nCusto)
			oSection2:PrintLine()

			dbSkip()
			If cProduto <> (cAliasSC8)->C8_PRODUTO
				cProduto := ""
			Endif	
		EndDo
		oSection2:Finish()
		oReport:SkipLine()
		oReport:ThinLine() 
	EndDo

	(cAliasSC8)->(DbCloseArea())

Return NIL