#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RATFA005  ºAutor  ³Victor Dessunte     º Data ³  12/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Inclusao gerencial (planilha enviada pela FDC)           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RATFA005()
	Processa({|| RATF005B()},"Aguarde...","Gerando ATIVO (Gerencial)...",.F.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RATFA005B ºAutor  ³Victor Dessunte     º Data ³  12/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Execauto da inclusao do Ativo Fixo                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RATF005B()

Local _nX 						:= 0
Local cArq 						:= 'C:\ATF\carga_dados.csv'
Local _cDesc					:= ''
Local aCab, aItens, aCampos		:= {}
Local _cTpDep 					:= ''
Local _nValmax 					:= 0
Private lMsHelpAuto				:= .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
Private lMsErroAuto				:= .f. // Determina se houve alguma inconsistencia na execucao da rotina 

If !File(cArq)
	MsgStop("O arquivo " + cArq + " não foi encontrado. A importação será abortada!"," - ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	aCab 	:= {}
	aItens 	:= {}
	cLinha 	:= FT_FREADLN()
	If cLinha == "        " .OR. cLinha = NIL
		ALERT("Fim de arquivo!")
		FT_FUSE()
		Return
	EndIf
	
	aCampos := StrToKArr(cLinha,";")
	
	dbSelectArea("SN1")
	SN1->(dbSetOrder(1))
	SN1->(dbSeek(xFilial("SN1")+aCampos[01]+aCampos[02]))	
	
	dbSelectArea("SNG")
	SNG->(dbSetOrder(1))
	SNG->(dbSeek(xFilial("SNG")+RIGHT(aCampos[1],4)))
	
	dbSelectArea("SN3")
	SN3->(dbSetOrder(1))
	SN3->(dbSeek(xFilial("SN3")+aCampos[01]+aCampos[02]+'01'))
	
	//CASO SEJA A MESMA DESCRICAO DO GRUPO, ALTERA PARA A DESCRICAO DA PLANILHA
	If ALLTRIM(SNG->NG_DESCRIC) == ALLTRIM(SN1->N1_DESCRIC)
		_cDesc := aCampos[04]
	Else
		_cDesc := SN1->N1_DESCRIC
	EndIf
	
	//CASO NAO POSSUA VALOR RESIDUAL, CADASTRA COMO TIPO LINEAR SEM VALOR MAXIMO DE DEPRECIACAO
	If VAL(aCampos[07]) == 0
		_cTpDep 	:= '1'
		_nValmax 	:= 0
	Else
		_cTpDep 	:= '7'
		_nValmax 	:= VAL(aCampos[07])
	EndIf
	
	aCab := {	{"N1_FILIAL"	,'01'						,nil},;
				{"N1_CBASE"		,aCampos[01]				,nil},;
				{"N1_ITEM"		,aCampos[02]				,nil},;
				{"N1_CHAPA"		,SN1->N1_CHAPA				,nil},;
				{"N1_XCHAPA"	,aCampos[03]				,nil},;
				{"N1_XFDC"		,'INCLUSAO GERENCIAL FDC'	,nil},;
				{"N1_DESCRIC"	,_cDesc						,nil} }
	
	aAdd(aItens,{ 	{'N3_TIPO' 		,SN3->N3_TIPO 				,nil},;
					{'N3_HISTOR' 	,SN3->N3_HISTOR 			,nil},;
					{'N3_TPSALDO' 	,SN3->N3_TPSALDO			,nil},;
					{'N3_TPDEPR' 	,SN3->N3_TPDEPR				,nil},;
					{'N3_CCONTAB'	,SN3->N3_CCONTAB			,nil},;
					{'N3_CDEPREC'	,SN3->N3_CDEPREC			,nil},;
					{'N3_CCDEPR'	,SN3->N3_CCDEPR				,nil},;
					{'N3_VORIG1' 	,SN3->N3_VORIG1				,nil},;
					{'N3_TXDEPR1'	,SN3->N3_TXDEPR1			,nil},;
					{'N3_VORIG3' 	,SN3->N3_VORIG3				,nil},;
					{'N3_TXDEPR3'	,SN3->N3_TXDEPR3			,nil},;
					{'N3_VMXDEPR' 	,SN3->N3_VMXDEPR			,nil},;
					{'N3_VORIG2' 	,SN3->N3_VORIG2				,nil},;
					{'N3_VLSALV1' 	,SN3->N3_VLSALV1			,nil},;
					{'N3_PERDEPR' 	,SN3->N3_PERDEPR			,nil},;
					{'N3_PRODMES' 	,SN3->N3_PRODMES			,nil},;
					{'N3_PRODANO' 	,SN3->N3_PRODANO			,nil},;
					{'N3_DINDEPR' 	,SN3->N3_DINDEPR			,nil}})
	
	aAdd(aItens,{ 	{'N3_TIPO'		,'10'						,nil},;
					{'N3_HISTOR'	,aCampos[04]				,nil},;
					{'N3_TPSALDO'	,'1' 						,nil},;
					{'N3_TPDEPR'	,_cTpDep					,nil},;
					{'N3_CCONTAB'	,SNG->NG_CCONTAB			,nil},;
					{'N3_CDEPREC'	,SNG->NG_CDEPREC			,nil},;
					{'N3_CCDEPR'	,SNG->NG_CCDEPR				,nil},;
					{'N3_VORIG1'	,VAL(aCampos[06])			,nil},;
					{'N3_TXDEPR1'	,VAL(aCampos[05])			,nil},;
					{'N3_VORIG3' 	,VAL(aCampos[06])			,nil},;
					{'N3_TXDEPR3'	,VAL(aCampos[05])			,nil},;
					{'N3_VMXDEPR' 	,_nValmax					,nil},;
					{"N3_XFDC"		,'INCLUSAO GERENCIAL FDC'	,nil},;
					{'N3_VORIG2' 	,0							,nil},;
					{'N3_VLSALV1' 	,0							,nil},;
					{'N3_PERDEPR' 	,0							,nil},;
					{'N3_PRODMES' 	,0	   						,nil},;
					{'N3_PRODANO' 	,0							,nil},;
					{'N3_DINDEPR' 	,dDataBase					,nil}})
	
	lMsErroAuto := .F.
	MSExecAuto( {|X,Y,Z| ATFA010(X,Y,Z)} ,aCab ,aItens, 4) 
	
	_nX++
	If lMsErroAuto
		_cErro := 'ERRO'+ALLTRIM(STR(_nX))+".txt"
		MostraErro('C:\ATF\ERROS CARGA DE DADOS\',_cErro)
	EndIf
	
	FT_FSKIP()
	aCampos := {}
EndDo

FT_FUSE()

ApMsgInfo("Importação concluída!")

Return
