
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATG045  ºAutor  ³Lizandra Marques    º Data ³  24/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera apv para PCP/ALmoxarifado                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG045()

Local I

fInclui    := .T. 

_cUsuario  := RetCodUsr()
_aUsuario  := {}
_cDeptoUsu := ""
_cGrupo    := ""
_aGrupos   := {}

          
_aArea := GetArea()       

PswOrder(1)
IF PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cDeptoUsu := UPPER(Alltrim(_aUsuario[1][12]))
	_aGrupos  := PswRet(1)[1][10]
	FOR I := 1 TO LEN(_aGrupos)
		_cGrupo += UPPER(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	NEXT I
	_cGrupo := SUBSTR(_cGrupo,1,LEN(_cGrupo)-1)
ENDIF                   

_cObsPN := M->C5_MSOBSPN 

IF M->C5_MSPRIOR == '1'
	IF SZM->(DbSeek(xFilial("SZM")+Alltrim(M->C5_NUM)))
		DO WHILE !SZM->(EOF()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(M->C5_NUM)
			cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
			IF "AUTORIZACAO P/ FABRICAR PV" $ cAux
				fInclui := .F.
				exit
			ENDIF
			SZM->(dbSkip())
			
		ENDDO
	ENDIF
	IF fInclui
		cEvento   := "AUTORIZACAO P/ FABRICAR PV." 
		cAssunto  := "AUTORI"                   
		cCodDepDes:= "PCP"
		cDeptoDes := "207-PCP"
		nDias     := 5
	ELSE
		cEvento   := "AUTORIZACAO P/ FABRICAR PV." 
	ENDIF   
	IncSZM()     
ELSEIF M->C5_MSPRIOR == '2'	
	IF SZM->(DbSeek(xFilial("SZM")+Alltrim(M->C5_NUM)))
		DO WHILE !SZM->(EOF()) .And. Alltrim(SZM->ZM_PEDIDO) == Alltrim(M->C5_NUM)
			cAux := Alltrim(MEMOLINE(SZM->ZM_EVENTO,80,1))
			IF "LIBERACAO PV P/ FATURAMENTO" $ cAux
				fInclui := .F.    
				exit
			ENDIF
			SZM->(dbSkip())
			
		ENDDO
	ENDIF
	IF fInclui
		cEvento   := "LIBERACAO PV P/ FATURAMENTO."
		cAssunto  := "LIBPV"                   
		cCodDepDes:= "ALMOXI"
		cDeptoDes := "205-ALMOXARIFADO"
		nDias     := 5
		IncSZM()
	ENDIF   
ENDIF

RestArea(_aArea)

Return(M->C5_MSPRIOR)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncSZM    ºAutor  ³Lizandra	Marques    º Data ³  24/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusão de APV (Venda de peças)                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IncSZM()
                         
IF fInclui
	RecLock("SZM",.T.)
	SZM->ZM_FILIAL  := "01"
	SZM->ZM_PEDIDO  := M->C5_NUM
	SZM->ZM_MSCAT   := M->C5_MSCATEG
	SZM->ZM_CODCLI  := M->C5_CLIENTE
	SZM->ZM_LOJACLI := M->C5_LOJACLI              
	SZM->ZM_CLIENTE := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NREDUZ")
	SZM->ZM_DATA    := Date()
	SZM->ZM_MSUSER  := UsrRetName(RetCodUsr())
	SZM->ZM_DEPTO   := _cDeptoUsu
	SZM->ZM_ASSUNTO := cAssunto
	SX5->(DbGotop())
	If SX5->(DbSeek(xFilial("SX5")+"ZE"+SZM->ZM_ASSUNTO))
		SZM->ZM_NOASSUN := SubStr(X5DESCRI(),1,30)
	EndIf
	SZM->ZM_STATUS  := "A"
	IF !EMPTY(_cObsPN)
		SZM->ZM_EVENTO  := cEvento+CHR(13)+CHR(10)+CHR(13)+CHR(10)+_cObsPN
	ELSE	
		SZM->ZM_EVENTO  := cEvento
	ENDIF
	SZM->ZM_CODDEPT := cCodDepDes
	SZM->ZM_DEPTDES := cDeptoDes
	SZM->ZM_DTPREV  := Date() + nDias
	SZM->ZM_INIMONT := M->C5_MSMONTA
ELSE

	RecLock("SZM",.F.)
	IF !EMPTY(_cObsPN)
		SZM->ZM_EVENTO  := cEvento+CHR(13)+CHR(10)+CHR(13)+CHR(10)+_cObsPN
	ELSE	
		SZM->ZM_EVENTO  := cEvento
	ENDIF
ENDIF	
SZM->(MsUnLock())

Return