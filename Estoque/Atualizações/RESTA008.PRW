#Include "Rwmake.ch"
#Include "Topconn.ch"
#include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±?  PROGRAMA  : MATP0921.PRG                                               º±?
±±?  FINALIDADE: MOVIMENTACAO DE ESTOQUE PELO RESUMOOP.EXE                  º±?
±±?                                                                         º±?
±±?  MODIFICACAO: TIRADO O ARQUIVO SZF POR CAUSAR MUITOS PROBLEMAS COM      º±?
±±?              INDICES                                                    º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³RESTA008  ºAutor  ?Jose Roberto       ?Data ?            º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³MOVIMENTACAO DE ESTOQUE                                     º±?
±±?         ?Pelo Integra - MAT0921)                                    º±?
±±?         ³Cecilia  - Alterado para o siga em 5.08.08                  º±?
±±?         ³Fabio - Alteracoes para gravar registros na tabela SD3010   º±?
±±?         ³compilado na base oficial com o nome RESTA019 e acrescentei º±?
±±?         ³no menu dos usuarios do estoque esta rotina para avaliacao. º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ³Masipack                                                    º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

User Function RESTA008()

Local I

Private I
Private wgrava
Private wrefer		:= SPACE(6)
Private cCusto		:= SPACE(3)
Private _cUsuario	:= RetCodUsr()
Private _aUsuario	:= {}
Private _aGrupos    := {}
Private _cDeptoUsu	:= ""
Private _cUsuSenha	:= ""
Private _cGrupo     := ""
Private cUsuarioSZS := ""

//Variaveis criadas para atender a funcao GravaSD3() - somente para realizar saida de produtos
Private cOpSai		:= ""
Private cProSai		:= ""
Private nQtdSai		:= 0
Private cMsRefer	:= ""
Private cMSTRT      := ""
Private cMsNred		:= ""
Private aAreaSB2	:= {}
Private aAreaSX5	:= {}
Private aOPs        := {}

PRIVATE	LMSERROAUTO	:= .F.	// INDICA SE GEROU ERRO NA TRANSACAO

	If cEmpAnt $ "01|15"
		Help(NIL, NIL, "NOPERM", NIL, "Esta rotina foi descontinuada no sistema Protheus", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Utilize a rotina 'Movimentação Múltipla' em Estoque/Custos > Atualizações > Movimentações > Internas > Movimentação Multipla"})
		Return
	Endif
PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_cUsuSenha	:= UsrRetName(_cUsuario)
	_cUsuSenha	:= Alltrim(Upper(SubStr(_cUsuSenha,1,6)))
	_aUsuario	:= PswRet()
	cUsuarioSX5	:= Upper(Alltrim(_aUsuario[1][2]))
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
	cUsuarioSZS	:= Upper(Alltrim(_aUsuario[1][4]))
	_aGrupos     := PswRet(1)[1][10]
	For I := 1 to Len(_aGrupos)
		_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	Next I
	_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)
EndIf

If !(_cGrupo $ "ADMINISTRADORES|INFORMATICA")
	SX5->(DbGotop())
	If !(SX5->(DbSeek(xFilial("SX5")+"ZD"+_cUsuSenha))) // Contem todos os usuarios que podem executar esta rotina
		apMsgStop("Usuário sem permissão para esta Rotina - ")
		Return .F.
	EndIf
EndIf                                                                        

@ 000,000 TO  250,350 DIALOG oDlg1 TITLE "Lancamento de O.P. geradas pelo Resumo de O.P."
@ 010,005 Say OemToAnsi("Referencia ")  Size 055,20
@ 010,070 Get wrefer Picture "999999"  valid vRefer() Size 055,20
@ 025,005 Say OemToAnsi("C. Custo ") Size 055,20
@ 025,070 Get cCusto Picture "999" Valid vCusto() Size 055,20
@ 070,040 BMPBUTTON TYPE 1 ACTION Processa({|| _fResop()})
@ 070,080 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 Centered
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³vCusto    ºAutor  ?                   ?Data ?            º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ³Masipack                                                    º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function vCusto()
Ret:= .T.

If !Empty(cCusto)
	If cCusto $ "102_201_202_203_205_208_209_212_216_217"
		RET := .t.
	Else
		MSGBOX("Verifique o Centro de Custo", "ALERT")
		RET := .f.
	Endif
Endif

RETURN(RET)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³vCusto    ºAutor  ?                   ?Data ?            º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ³Masipack                                                    º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function vRefer()
Ret:= .T.

If Empty(wrefer)
	apMSGStop("Referencia em Branco")
	RET := .f.
Endif

If !Empty(wrefer)
	dbSelectArea("SD4")
	sd4->(dbSetOrder(11))
	If dbSeek(xFilial("SD4")+Alltrim(wrefer))
		RET := .t.
	Else
		apMSGStop("Referencia não existe")
		RET := .f.
	Endif
Endif

RETURN(RET)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³_fResop   ºAutor  ?                   ?Data ?            º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ³Masipack                                                    º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

Static Function _fResop()

LOCAL wregistro
LOCAL cEmailMasi  := SUPERGETMV("ES_REST8MS",,"pcp@masipack.com.br")
LOCAL cEmailFabri := SUPERGETMV("ES_REST8FB",,"admilson.carvalho@fabrima.com.br")
PRIVATE wentregue
cOpSai		:= ""
cProSai		:= ""
nQtdSai		:= 0
cMsRefer	:= ""
cMSTRT      := ""
cMsNred		:= ""
aOPs        := {}
close(oDlg1)

dbSelectArea("SD4")
sd4->(dbSetOrder(11))
dbSeek(xFilial("SD4")+Alltrim(wrefer)) 

dbSelectArea("SB2")
SB2->(dbSetOrder(1))
SB2->(DBSEEK(xFilial("SB2") + SD4->D4_COD))  

DO WHILE sd4->d4_msrefer == wrefer .AND. !sd4->(EOF())
	
	IF sd4->d4_quant <= 0
		sd4->(DBSKIP(1))
		LOOP
	ENDIF
	
	nSaldo := 0
	nQde := 0
	
	
	If sb1->(DBSEEK(xFilial("SB1") + sd4->d4_cod))
		RecLock("SD4",.F.)
		sd4->d4_mslf := "X"
		sd4->d4_mssepar := dDatabase
		SD4->(MsUnlock())
		
		IF SB2->(DBSEEK(xFilial("SB2") + sd4->d4_cod + "01"))
//			nSaldo := SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QEMP
			nSaldo := SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QTNP - SB2->B2_QNPT
//		ELSE
//			nSaldo := SB2->B2_QATU 
		ENDIF
		
		IF nSaldo < 0
			nSaldo := 0
		ENDIF
		
		IF nSaldo >= sd4->d4_quant
			nQde := sd4->d4_quant
		Else
			nQde := nSaldo
		Endif
	Endif
	
	If nQde > 0
		dbSelectArea("SC2")
		dbSetOrder(1)
		IF sc2->(DBSEEK(xFilial("SC2") + substr(sd4->d4_op,1,11)))
			If SB1->B1_CUSTD == 0
				RecLock("SB1",.F.)
				If nQde < 1
					SB1->B1_CUSTD := 1.0
				Else
					SB1->B1_CUSTD := 0.1
				Endif
				SB1->(MsUnlock())
			Endif
					
			LMSERROAUTO := .F.
			cOpSai		:= Alltrim(SD4->D4_OP)
			cProSai		:= SD4->D4_COD
			nQtdSai		:= nQde
			cMsRefer	:= wrefer
			cMsNred		:= SC2->C2_MSREDUZ
			CMSTRT      := SD4->D4_TRT
			
			//// VERIFICA SE USUÁRIO TEM AUTORIZAÇÃO PARA MOVIMENTAÇÃO - EVITANDO ERRO NO PROGRAMA -- LIZANDRA 15/02/12
			
			SX5->(dbSetOrder(1))
			SX5->(dbSeek(xFilial("SX5")+"ZD"+cUsuarioSX5))
			If !SubStr(sb1->b1_local,1,1) $ Rtrim(X5DESCRI())
				apmsgStop('Usuario não autorizado a Movimentar Item, Produto: ' + SD4->D4_COD + ' Local: '+ SB1->B1_LOCAL)
				SD4->(DBSKIP())
				LOOP
			Endif
			
			GravaSd3(cOpSai,cProSai,nQtdSai,cMsRefer,cMsNred)
			
			IF LMSERROAUTO == .F.
			

							
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1)) 
			   SB1->(DBSEEK(xFilial("SB1") + SD4->D4_COD)) 
				
				Reclock("SC2",.F.)
				IF EMPTY(sc2->c2_msposic) .AND. sc2->c2_mslista == "S"
					sc2->c2_msposic := "(201XXX) - RESTA008 - MONTAGEM em " + DTOC(dDatabase)
				ENDIF
				IF EMPTY(sc2->c2_dataji)
					sc2->c2_dataji := dDatabase
				ENDIF
				SC2->(MsUnlock())
				IF sc2->c2_dataji < sc2->c2_datpri
					If ASCAN(aOPs,SD4->D4_OP) == 0
						AADD(aOPs,SD4->D4_OP)
						cCorpoEmail := "Lista de separacao separada antes do prazo<br><br>"
						cCorpoEmail += "          Lista: " + sc2->c2_num + sc2->c2_item + sc2->c2_sequen + "<br><br>"
						cCorpoEmail += "        Produto: " + sc2->c2_produto + "<br><br>"
						cCorpoEmail += "  Nome Reduzido: " + sc2->c2_msreduz + "<br><br>"
						cCorpoEmail += "Inicio Previsto: " + DTOC(sc2->c2_datpri) + "<br><br>"
						cCorpoEmail += "    Inicio Real: " + DTOC(sc2->c2_dataji) + "<br><br>"
						If SubStr(cNumEmp,1,2) == "01"
							oMail:= EnvMail():NEW(.F.)
							If oMail:ConnMail()
								oMail:SendMail("Lista de separacao adiantada - Masipack",cEmailMasi,cEmailMasi,,cCorpoEmail)
							EndIf
							oMail:DConnMail()
						
						Elseif SubStr(cNumEmp,1,2) == "10"
							oMail:= EnvMail():NEW(.F.)
							If oMail:ConnMail()
								oMail:SendMail("Lista de separacao adiantada - Fabrima",cEmailFabri,,,cCorpoEmail)
							EndIf
							oMail:DConnMail()
						Endif
					ENDIF
				EndIf
				IF !EMPTY(sc2->c2_msped)
					IF sc5->(DBSEEK(xFilial("SC5") + sc2->c2_msped))
						IF EMPTY(sc5->c5_msposic)
							Reclock("SC5",.F.)
							sc5->c5_msposic := "RESTA008 (201)-MONTAGEM em " + DTOC(DATE())
							SC5->(msUnlock())
						Endif
					Endif
				Endif
			Else
				apMSGSTOP("Apresentou erro ao realizar baixa da OP: " + ALLTRIM(sd4->d4_op) + "Favor entrar em contato com o depto. de informática")
				Return
			Endif
		EndIf
	Endif
	
	SD4->(DBSKIP())
	
ENDDO


RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±?PROGRAMA     ?  GRAVASD3     ?AUTOR ?FABIO MARCELO DIAS    ?DATA ?   09/11/10  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±?HISTORICO    ?FUNCAO PARA GRAVAR MOVIMENTACAO NA TABELA SD3 (MOVIMENTOS INTERNOS)  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±?PROPRIETARIO ?CUSTOMIZADO PARA MASIPACK                                            º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/

STATIC FUNCTION GRAVASD3()

LOCAL AAREASB1	:= SB1->(GETAREA())
LOCAL AAREASB2	:= SB2->(GETAREA())
LOCAL AAREASC2	:= SC2->(GETAREA())
LOCAL AAREASD4	:= SD4->(GETAREA())
LOCAL AMSD3		:= {}	// ARRAY CONTENDO OS PRODUTOS A SEREM GRAVADOS NO SD3
LOCAL CTIPOSD3	:= ""	// TIPO MOVIMENTACAO
LOCAL CPRODSD3	:= ""	// PRODUTO
LOCAL CNOPSD3	:= ""	// NUMERO OP
LOCAL CUNMSD3	:= ""	// UNIDADE MEDIDA
LOCAL NQTDSD3	:= 0	// QUANTIDADE
LOCAL CDOCSD3	:= ""	// NUMERO DOCUMENTO
LOCAL CGRUPSD3	:= ""	// GRUPO
LOCAL CLOCSD3	:= ""	// LOCAL
LOCAL CREFESD3	:= ""	// REFERENCIA
LOCAL CNREDSD3	:= ""	// NOME REDUZIDO (FANTASIA)
LOCAL CLOCALD3	:= ""	// LOCAL FISICO DO PRODUTO NO ESTOQUE
LOCAL _NQTDFIM	:= 0
LOCAL _NQTDRES	:= 0
LOCAL _NQTDPED	:= 0
LOCAL _LALTSB2	:= .F.
LOCAL CTRTSD3   := ""
LOCAL CMENSAGEM := ""

DBSELECTAREA("SB2")
SB2->(DBSETORDER(1))
SB2->(DBGOTOP())

CTIPOSD3	:= '603'
CPRODSD3	:= CPROSAI
CUNMSD3		:= SB1->B1_UM
NQTDSD3		:= NQTDSAI
CNOPSD3		:= COPSAI
CLOCSD3		:= SB1->B1_LOCPAD
CDOCSD3		:= "OP"+SUBSTR(CNOPSD3,1,6)
CGRUPSD3	:= SB1->B1_GRUPO
CREFESD3	:= CMSREFER
CNREDSD3	:= CMSNRED
CLOCALD3	:= SB1->B1_LOCAL
CTRTSD3     := CMSTRT

// MSGALERT("Produto: " +PADR(CPRODSD3,15) + " Local: " +CLOCSD3)

AMSD3:={{"D3_FILIAL" ,'01'		,NIL},;
{"D3_TM"     ,CTIPOSD3          ,NIL},;
{"D3_COD"    ,CPRODSD3          ,NIL},;
{"D3_UM"     ,CUNMSD3	       	,NIL},;
{"D3_QUANT"  ,NQTDSD3	     	,NIL},;
{"D3_CONTA"  ,'112000010'     	,NIL},;
{"D3_OP"     ,CNOPSD3    		,NIL},;
{"D3_LOCAL"  ,CLOCSD3           ,NIL},;
{"D3_DOC"    ,CDOCSD3   		,NIL},;
{"D3_EMISSAO",DATE()            ,NIL},;
{"D3_GRUPO"  ,CGRUPSD3			,NIL},;
{"D3_MSOBS"	 ,'RESTA008 '+Time(),NIL},;
{"D3_MSREFER",CREFESD3			,NIL},;
{"D3_MSREDUZ",CNREDSD3			,NIL},;
{"D3_MSLOCAL",CLOCALD3			,NIL},;
{"D3_TRT"	 ,CTRTSD3			,NIL},;
{"D3_HORAS"  ,TIME()            ,NIL},;
{"D3_CODLAN" ,""				,NIL}}

If SB2->(DBSEEK(XFILIAL("SB2")+PADR(CPRODSD3,15)+CLOCSD3))
//	If SB2->B2_QTNP > 0 
	//	ALERT(CPRODSD3)
//	EndIf

//	If SB2->B2_QATU - SB2->B2_RESERVA - nQde >= 0
		
		//		IF _lMov
		BEGIN TRANSACTION
		
		LJMSGRUN("Efetuando Movimentação Interna " +CPRODSD3,,{|| MSEXECAUTO({|X,Y|MATA240(X,Y)},AMSD3,3)})
		
		IF  LMSERROAUTO
			CFILELOG    := ""
			CPATH       := ""
			LMSERROAUTO := .F.
			DISARMTRANSACTION()		// CASO APRESENTE ERRO DESFAZ TRANSACAO
/*			
			AUTOGRLOG("INICIANDO O LOG")
			AUTOGRLOG("---------------")
			AUTOGRLOG("PRODUTO............: "+CPRODSD3)
			AUTOGRLOG("DATABASE...........: "+DTOC(DDATABASE))
			AUTOGRLOG("DATA...............: "+DTOC(MSDATE()))
			AUTOGRLOG("HORA...............: "+TIME())
			AUTOGRLOG("ENVIRONMENT........: "+GETENVSERVER())
			AUTOGRLOG("PATCH..............: "+GETSRVPROFSTRING("Startpath",""))
			AUTOGRLOG("ROOT...............: "+GETSRVPROFSTRING("SourcePath",""))
			AUTOGRLOG("VERSÃO.............: "+GETVERSAO())
			AUTOGRLOG("MÓDULO.............: "+"SIGA"+CMODULO)
			AUTOGRLOG("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
			AUTOGRLOG("NOME EMPRESA.......: "+CAPITAL(TRIM(SM0->M0_NOME)))
			AUTOGRLOG("NOME FILIAL........: "+CAPITAL(TRIM(SM0->M0_FILIAL)))
			AUTOGRLOG("USUÁRIO............: "+SUBSTR(CUSUARIO,7,15))
			
			CFILELOG := NOMEAUTOLOG()
			
			IF  CFILELOG <> ""
				MOSTRAERRO(CPATH,CFILELOG)
			ENDIF
*/
			MOSTRAERRO()

			RECLOCK("SZS",.T.)
			SZS->ZS_FILIAL  := "01"
			SZS->ZS_OP      := CNOPSD3
			SZS->ZS_PRODUTO := CPRODSD3
			SZS->ZS_QTDE    := NQTDSD3
			SZS->ZS_POSICAO := "ERRO ROTINA RESTA008 - FUNCAO GRAVASD3 - TIPO MOVIMENTO: " + CTIPOSD3
			SZS->ZS_DATA    := DATE()
			SZS->ZS_HORA    := TIME()     
			SZS->ZS_CC      := "XXXXXX"
			SZS->ZS_USUARIO := UPPER(CUSUARIOSZS)
			SZS->ZS_DEPTO   := _CDEPTOUSU
			SZS->(MSUNLOCK())
			
//			PutMV("MV_MSGEROP","N")
			
//			CMENSAGEM := "O sistema apresentou um erro de processamento e ser?fechado !!!" + CHR(13);
//			+ "Apresente esta OP ao Depto. de Informática para que possam efetuar análise." + CHR(13);
//			+ "Continue utilizando o sistema para apontar outras OP's. Obrigado !"
			
//			USEREXCEPTION(CMENSAGEM)
			// return
		ENDIF
		
		END TRANSACTION
		//		ENDIF
//	Else
//		LMSERROAUTO := .T.
//	EndIf
EndIf

RESTAREA(AAREASB1)
RESTAREA(AAREASB2)
RESTAREA(AAREASC2)
RESTAREA(AAREASD4)
RETURN()
