#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Rwmake.ch"          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA065  ºAutor  ³Lizandra            º Data ³  12/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteração do SC5 após liberação do PV pelo almoxarifado    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºInformação³ Rotina MSLEGPED está no programa MSXFUN                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA065()

SetPrvt("CCADASTRO,ACAMPOS,AROTINA,DDTENT,")

aCores := {}
cCadastro := "Alterçao pos-liberação"
aRotina   := { {"Pesquisa",     "AxPesqui",           0, 1 },;
               {"Visualiza",    "AxVisual",           0, 2 },;
               {"Altera",     'ExecBlock("C5CABEC")', 0, 3 } }    
               
               
aCores := U_MSLEGPED()


mBrowse(8,03,20,75,"SC5",,,,,, aCores)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C5CABEC   ºAutor  ³Lizandra	           º Data ³  12/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteração do cabec do PV - Venda de peças                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function C5CABEC()

Local oMultiGe1
Local oMultiGe2          
Local oButton1
Local oButton2          
Local oCheckBo1

lCheckBo1 := .F.

                       
//cC5TRIFA   := .F.
cC5PED     := SC5->C5_NUM
cC5PEDCLI  := SC5->C5_PC
cC5CONTATO := SC5->C5_MSCTATO
cC5VOLUME1 := SC5->C5_VOLUME1
cC5TRANSP  := SC5->C5_TRANSP
cC5CONDPG  := SC5->C5_CONDPAG
cC5MENOTA  := SC5->C5_MENNOTA
cC5COTACAO := SC5->C5_COTACAO
cC5FRETE   := SC5->C5_TPFRETE
cC5PBRUTO  := SC5->C5_PBRUTO
cC5PLIQ    := SC5->C5_PESOL
cC5ESPEC   := SC5->C5_ESPECI1
cC5OBS     := SC5->C5_OBS
cC5PEND    := SC5->C5_MSPEND	
cC5DTENT   := SC5->C5_MSDTPEN
lCheckBo1  := SC5->C5_TRIFASI
cC5VOLTAGE := SC5->C5_VOLTAGE
cC5FREQ    := SC5->C5_HZ		

@ 0,0 TO 700,500 DIALOG oDlg1 TITLE "Alteração do cabeçalho do PV"
//DEFINE MSDIALOG oDlg1 FROM 000, 000  TO 500, 500 COLORS 0, 5723991 PIXEL

@ 010,010 SAY "Pedido : "+SC5->C5_NUM    
@ 010,065 SAY Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
@ 030,010 SAY "Contato       : "
@ 030,065 GET cC5CONTATO SIZE 50,200
@ 030,135 SAY "Cotação       : "
@ 030,165 GET cC5COTACAO PICTURE "@!" SIZE 50,200
@ 045,010 SAY "Volumes       : "
@ 045,065 GET cC5VOLUME1 PICTURE "@E 99,999" SIZE 50,200
@ 045,135 SAY "Especie      : "
@ 045,165 GET cC5ESPEC  PICTURE "@!"  SIZE 50,200
@ 060,010 SAY "Condicao Pgto.: "
@ 060,065 GET cC5CONDPG  F3 "MASSE4" SIZE 50,200 VALID ExistCpo("SE4")
@ 060,135 SAY "Dt.Entrega "
@ 060,165 GET cC5DTENT    SIZE 50,200
@ 075,010 SAY "Transportadora: "
@ 075,065 GET cC5TRANSP  F3 "MASSA4" SIZE 50,200 VALID existcpo("SA4").OR.EMPTY(cC5TRANSP)  
@ 075,135 SAY "Frete         : "
@ 075,165 GET cC5FRETE    SIZE 50,200
@ 090,010 SAY "Pedido Cliente: "
@ 090,065 GET cC5PEDCLI  PICTURE "@!" SIZE 100,200
@ 105,010 SAY "Mensagem Nota : "
@ 105,065 GET cC5MENOTA  PICTURE "@!" SIZE 100,200
@ 120,010 SAY "Peso Liquido   : "
@ 120,065 GET cC5PLIQ    PICTURE "@E 999,999.999"  SIZE 50,200
@ 120,135 SAY "Peso Bruto    : "
@ 120,165 GET cC5PBRUTO PICTURE "@E 999,999.999"  SIZE 50,200
@ 135,010 SAY "Observação    : "
@ 135,065 GET oMultiGe1 VAR cC5OBS OF oDlg1 MULTILINE SIZE 150, 50 COLORS 0, 16777215 HSCROLL PIXEL
@ 200,010 SAY "Pendencias   : "
@ 200,065 GET oMultiGe2 VAR cC5PEND OF oDlg1 MULTILINE SIZE 150, 50 COLORS 0, 16777215 HSCROLL PIXEL
@ 265,010 SAY "Frequencia    : "
@ 265,065 GET cC5FREQ PICTURE "@E 999" SIZE 50,200
@ 265,135 SAY "Tensão        : "
@ 265,165 GET cC5VOLTAGE PICTURE "@E 999" SIZE 50,200
//@ 280,010 SAY "Trifasico     : "      
@ 280,010 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Trifásico" SIZE 171, 032 OF oDlg1 COLORS 0, 16777215 PIXEL
//@ 280,065 GET cC5TRIFA SIZE 50,200

@ 300,090 BmpButton Type 1 ACTION ALTCABEC()
@ 300,140 BmpButton Type 2 ACTION Close(oDlg1)



//@ 700,90  BUTTON "_Ok"   SIZE 35,15 ACTION ALTCABEC()
//@ 700,140 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALTCABEC  ºAutor  ³Microsiga           º Data ³  11/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Atualização da tabela SC5 após liberação do PV pelo       º±±
±±º          ³  almoxarifado                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ALTCABEC()

RecLock("SC5",.F.)
SC5->C5_PC		 := cC5PEDCLI
SC5->C5_MSCTATO := cC5CONTATO 
SC5->C5_VOLUME1 := cC5VOLUME1 
SC5->C5_TRANSP	 := cC5TRANSP  
SC5->C5_CONDPAG := cC5CONDPG  
SC5->C5_MENNOTA := cC5MENOTA  
SC5->C5_COTACAO := cC5COTACAO 
SC5->C5_TPFRETE := cC5FRETE   
SC5->C5_PBRUTO	 := cC5PBRUTO  
SC5->C5_PESOL	 := cC5PLIQ    
SC5->C5_ESPECI1 := cC5ESPEC   
SC5->C5_OBS		 := cC5OBS     
SC5->C5_MSPEND	 := cC5PEND    
//SC5->C5_MSDTPEN := cC5DTENT   
SC5->C5_TRIFASI := lCheckBo1   
SC5->C5_VOLTAGE := cC5VOLTAGE 
SC5->C5_HZ		 := cC5FREQ    
SC5->(MsUnLock())
IF !EMPTY(cC5PEDCLI)
	dbSelectarea("SC6")
	IF (dbSeek(xFilial("SC6")+cC5PED))
		DO WHILE !SC6->(EOF()) .AND. SC6->C6_NUM == cC5PED
			RecLock("SC6",.F.)
			SC6->C6_NUMPCOM := cC5PEDCLI
			SC6->C6_ITEMPC	 := IIF(!EMPTY(SC6->C6_MSITPEC),SC6->C6_MSITPEC,SC6->C6_ITEM)
			SC6->(MsUnLock())
			dbSkip()
		ENDDO
	ENDIF
ENDIF		
	
Close(oDlg1)
Return(.t.)
