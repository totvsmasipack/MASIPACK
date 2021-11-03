#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RATFA003  ºAutor  ³Victor Dessunte     º Data ³  12/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Inclusao das sobras fisicas (planilha enviada pela FDC)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RATFA003()
	Processa({|| RATF003B()},"Aguarde...","Gerando ATIVO (Sobras Fisicas)...",.F.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RATFA003  ºAutor  ³Victor Dessunte     º Data ³  12/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Execauto da inclusao do Ativo Fixo                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RATF003B()

Local _nX := 0
Local cArq 			:= 'C:\ATF\sobra_fisica.csv'
Local aCab, aItens, aCampos	:= {}
Private lMsHelpAuto	:= .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
Private lMsErroAuto	:= .f. // Determina se houve alguma inconsistencia na execucao da rotina 

If !File(cArq)
	MsgStop("O arquivo " + cArq + " não foi encontrado. A importação será abortada!"," - ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	If cLinha == "        " .OR. cLinha = NIL
		ALERT("Fim de arquivo!")
		FT_FUSE()
		Return
	EndIf
	
	aCampos := StrToKArr(cLinha,";")
	
	dbSelectArea("SNG")
	SNG->(dbSetOrder(1))
	SNG->(dbSeek(xFilial("SNG")+aCampos[01]))
	
	aCab := {	{'N1_FILIAL'	,'01'				,NIL},;
				{'N1_GRUPO'		,aCampos[01]		,NIL},;
				{'N1_CBASE'		,aCampos[02]		,NIL},;
				{'N1_ITEM'		,aCampos[03]		,NIL},;
				{'N1_CHAPA'		,aCampos[04]		,NIL},;
				{'N1_DESCRIC'	,aCampos[05]		,NIL},;
				{'N1_AQUISIC'	,dDatabase			,NIL},;
				{'N1_QUANTD'	,1					,NIL},;
				{'N1_XFDC'		,'INCLUSO PELA FDC'	,NIL} }
	
	aItens := {}
	aAdd(aItens,{	{'N3_TIPO'		,'01'				,NIL},;
					{'N3_HISTOR'	,aCampos[05]		,NIL},;
					{'N3_TPSALDO'	,'1'				,NIL},;
					{'N3_TPDEPR'	,'1'				,NIL},;
					{'N3_CCONTAB'	,SNG->NG_CCONTAB	,NIL},;
					{'N3_CDEPREC'	,SNG->NG_CDEPREC	,NIL},;
					{'N3_CCDEPR'	,SNG->NG_CCDEPR		,NIL},;
					{'N3_VORIG1'	,0.01  				,NIL},;
					{'N3_VORIG2'	,0					,NIL},;
					{'N3_VORIG3'	,0.01				,NIL},;
					{'N3_VORIG4'	,0					,NIL},;
					{'N3_VORIG5'	,0					,NIL},;
					{'N3_TXDEPR1'	,SNG->NG_TXDEPR1	,NIL},;
					{'N3_TXDEPR2'	,0					,NIL},;
					{'N3_TXDEPR3'	,SNG->NG_TXDEPR1	,NIL},;
					{'N3_TXDEPR4'	,0					,NIL},;
					{'N3_TXDEPR5'	,0					,NIL},;
					{'N3_VMXDEPR'	,0					,NIL},;
					{'N3_VLSALV1'	,0					,NIL},;
					{'N3_PERDEPR'	,0					,NIL},;
					{'N3_PRODMES'	,0					,NIL},;
					{'N3_PRODANO'	,0					,NIL},;
					{'N3_XFDC'		,'INCLUSO PELA FDC'	,NIL},;
					{'N3_DINDEPR'	,dDataBase			,NIL}})

	aAdd(aItens,{ 	{'N3_TIPO'		,'10'				,NIL},;
					{'N3_HISTOR'	,aCampos[05]		,NIL},;
					{'N3_TPSALDO'	,'1'				,NIL},;
					{'N3_TPDEPR'	,'7'				,NIL},;
					{'N3_CCONTAB'	,SNG->NG_CCONTAB	,NIL},;
					{'N3_CDEPREC'	,SNG->NG_CDEPREC	,NIL},;
					{'N3_CCDEPR'	,SNG->NG_CCDEPR		,NIL},;
					{'N3_VORIG1'	,VAL(aCampos[07])	,NIL},;
					{'N3_VORIG2'	,0	  				,NIL},;
					{'N3_VORIG3'	,VAL(aCampos[07])	,NIL},;
					{'N3_VORIG4'	,0	  				,NIL},;
					{'N3_VORIG5'	,0	  				,NIL},;
					{'N3_TXDEPR1'	,VAL(aCampos[06])	,NIL},;
					{'N3_TXDEPR2'	,0					,NIL},;
					{'N3_TXDEPR3'	,VAL(aCampos[06])	,NIL},;			
					{'N3_TXDEPR4'	,0					,NIL},;
					{'N3_TXDEPR5'	,0					,NIL},;
					{'N3_VMXDEPR'	,VAL(aCampos[08])	,NIL},;
					{'N3_VLSALV1'	,0					,NIL},;
					{'N3_PERDEPR'	,0					,NIL},;
					{'N3_PRODMES'	,0					,NIL},;
					{'N3_PRODANO'	,0					,NIL},;
					{'N3_XFDC'		,'INCLUSO PELA FDC'	,NIL},;
					{'N3_DINDEPR'	,dDataBase			,NIL}})
	
	lMsErroAuto := .F.
	MSExecAuto( {|X,Y,Z| ATFA010(X,Y,Z)} ,aCab ,aItens, 3)
	
	_nX++
	If lMsErroAuto
		_cErro := 'ERRO'+ALLTRIM(STR(_nX))+".txt"
		MostraErro('C:\ATF\ERROS SOBRAS FISICAS\',_cErro)
	EndIf
	
	FT_FSKIP()
	aCampos := {}
EndDo

FT_FUSE()

ApMsgInfo("Importação concluída!")

Return
