#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA057  ºAutor  ³Lizandra Marques    º Data ³  27/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteração de tabelas no cad. do Cliente                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Masipack                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                             

USER FUNCTION RFATA057

Local cDesc1       := "Este programa tem como objetivo alterar as tabelas de preço "
Local cDesc2       := "no cadastro dos clientes."
Local cDesc3       := "Processamento de Clientes"
Local cPict        := ""
Local titulo       := "Processamento de Clientes"
Local nLin         := 80 
Local cString	   :="SA1"

Local Cabec1       := "Ocorrencias"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RFATA057"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
//Private cPerg       := "RFATA5"
Private cPerg       := "XRFATA057"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFATA057"


SA1->(dbSetOrder(1))

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif
nTipo := If(aReturn[4]==1,15,18)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

            

SA1->(DbGoTop())

_cRET1 := Posicione("DA0",1,xFilial("DA0")+MV_PAR01,"DA0_DESCRI")
_cRET2 := Posicione("DA0",1,xFilial("DA0")+MV_PAR02,"DA0_DESCRI")

nCont:=0
While !EOF()        
	IF !EMPTY(_cRET1) .AND. !EMPTY(_cRET2)
		IF  SUBSTR(cNumEmp,1,2) $ "01"		// empresa Masipack 
			IF SA1->A1_TABELA == MV_PAR01
				RecLock("SA1",.f.)
				SA1->A1_TABELA := MV_PAR02
				MsUnlock() 
				nCont++
			ENDIF
		ELSEIF SUBSTR(cNumEmp,1,2) $ "10"		
			IF SA1->A1_MSTABFA == MV_PAR01
				RecLock("SA1",.f.)
				SA1->A1_MSTABFA := MV_PAR02
				MsUnlock() 
				nCont++
			ENDIF
		ENDIF		
		SA1->(DbSkip())
	ELSE
		ApmSgInfo("Verifique código das tabelas!!!")
		EXIT
	ENDIF		
Enddo	

// GRAVA SB1 - CADASTRO DE PRODUTOS


nLin := 9
@ nLin,00 PSAY "--> FORAM PROCESSADOS "+STRZERO(nCont,4)+" REGISTROS."
nLin++
SET DEVICE TO SCREEN

DbSelectArea("SA1")
RetIndex("SA1")

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

RETURN