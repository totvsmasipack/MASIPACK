#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RATFA003  ºAutor  ³Victor Dessunte     º Data ³  12/14/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Inclusao da aba Gerencial (planilha enviada pela FDC)    º±±
±±º          ³   (Abertura de Itens)                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RATFA006()
	Processa({|| RATF006B()},"Aguarde...","ABERTURA DE ITEM ATIVO...",.F.)
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

Static Function RATF006B()

Local _nX := 0
Local cArq 			:= 'C:\ATF\carga_dados.csv'
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
	
	aCab := {	{'N1_FILIAL'	,'01'						,NIL},;
				{'N1_GRUPO'		,aCampos[01]				,NIL},;
				{'N1_CBASE'		,aCampos[02]				,NIL},;
				{'N1_ITEM'		,aCampos[04]				,NIL},;
				{'N1_CHAPA'		,aCampos[05]				,NIL},;
				{'N1_DESCRIC'	,aCampos[06]				,NIL},;
				{'N1_AQUISIC'	,CTOD(aCampos[12])			,NIL},;
				{'N1_QUANTD'	,1							,NIL},;
				{'N1_XCBORIG'	,aCampos[02]				,NIL},;
				{'N1_XITORIG'	,aCampos[03]				,NIL},;
				{'N1_XFDC'		,'ABERTURA PELA FDC'		,NIL} }
	
	aItens := {}
	aAdd(aItens,{	{'N3_FILIAL'	,'01'					,NIL},;
					{'N3_TIPO'		,'01'					,NIL},;
					{'N3_HISTOR'	,aCampos[06]			,NIL},;
					{'N3_TPSALDO'	,'1'					,NIL},;
					{'N3_TPDEPR'	,'1'					,NIL},;
					{'N3_CCONTAB'	,SNG->NG_CCONTAB		,NIL},;
					{'N3_CDEPREC'	,SNG->NG_CDEPREC		,NIL},;
					{'N3_CCDEPR'	,SNG->NG_CCDEPR			,NIL},;
					{'N3_VORIG1'	,VAL(aCampos[07])		,NIL},;
					{'N3_VORIG2'	,0						,NIL},;
					{'N3_VORIG3'	,VAL(aCampos[07])		,NIL},;
					{'N3_VORIG4'	,0						,NIL},;
					{'N3_VORIG5'	,0						,NIL},;
					{'N3_TXDEPR1'	,SNG->NG_TXDEPR1		,NIL},;
					{'N3_TXDEPR2'	,0						,NIL},;
					{'N3_TXDEPR3'	,SNG->NG_TXDEPR1		,NIL},;
					{'N3_TXDEPR4'	,0						,NIL},;
					{'N3_TXDEPR5'	,0						,NIL},;
					{'N3_VMXDEPR'	,0						,NIL},;
					{'N3_VLSALV1'	,0						,NIL},;
					{'N3_PERDEPR'	,0						,NIL},;
					{'N3_PRODMES'	,0						,NIL},;
					{'N3_PRODANO'	,0						,NIL},;
					{'N3_VRDACM1'	,VAL(aCampos[08])		,NIL},;
					{'N3_VRDACM2'	,0						,NIL},;
					{'N3_VRDACM3'	,VAL(aCampos[08])		,NIL},;
					{'N3_VRDACM4'	,0						,NIL},;
					{'N3_VRDACM5'	,0						,NIL},;
					{'N3_XFDC'		,'ABERTURA PELA FDC'	,NIL},;
					{'N3_DINDEPR'	,CTOD(aCampos[12])		,NIL}})
	
	aAdd(aItens,{ 	{'N3_FILIAL'	,'01'					,NIL},;
					{'N3_TIPO'		,'10'					,NIL},;
					{'N3_HISTOR'	,aCampos[06]			,NIL},;
					{'N3_TPSALDO'	,'1'					,NIL},;
					{'N3_TPDEPR'	,'7'					,NIL},;
					{'N3_CCONTAB'	,SNG->NG_CCONTAB		,NIL},;
					{'N3_CDEPREC'	,SNG->NG_CDEPREC		,NIL},;
					{'N3_CCDEPR'	,SNG->NG_CCDEPR			,NIL},;
					{'N3_VORIG1'	,VAL(aCampos[10])		,NIL},;
					{'N3_VORIG2'	,0	  					,NIL},;
					{'N3_VORIG3'	,VAL(aCampos[10])		,NIL},;
					{'N3_VORIG4'	,0	  					,NIL},;
					{'N3_VORIG5'	,0	  					,NIL},;
					{'N3_TXDEPR1'	,VAL(aCampos[09])		,NIL},;
					{'N3_TXDEPR2'	,0						,NIL},;
					{'N3_TXDEPR3'	,VAL(aCampos[09])		,NIL},;
					{'N3_TXDEPR4'	,0						,NIL},;
					{'N3_TXDEPR5'	,0						,NIL},;
					{'N3_VMXDEPR'	,VAL(aCampos[11])		,NIL},;
					{'N3_VLSALV1'	,0						,NIL},;
					{'N3_PERDEPR'	,0						,NIL},;
					{'N3_PRODMES'	,0						,NIL},;
					{'N3_PRODANO'	,0						,NIL},;
					{'N3_VRDACM1'	,0						,NIL},;
					{'N3_VRDACM2'	,0						,NIL},;
					{'N3_VRDACM3'	,0						,NIL},;
					{'N3_VRDACM4'	,0						,NIL},;
					{'N3_VRDACM5'	,0						,NIL},;
					{'N3_XFDC'		,'ABERTURA PELA FDC'	,NIL},;
					{'N3_DINDEPR'	,dDataBase				,NIL}})
	
	lMsErroAuto := .F.
	MSExecAuto( {|X,Y,Z| ATFA010(X,Y,Z)} ,aCab ,aItens, 3)
	
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
