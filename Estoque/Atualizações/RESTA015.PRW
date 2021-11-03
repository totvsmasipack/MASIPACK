#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   RESTA015     บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  22/10/10    บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ DESCRICAO    บ ALTERACAO / EXCLUSAO - CADASTRO DE PRODUTO FORNECIDO PELO CLIENTE    บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ TABS.UTILIZ  บ DESCRICAO                                              บ   ACESSO    บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮอฮออออออออออนฑฑ
ฑฑบ    SZ6       บ PRODUTO FORNECIDO PELO CLIENTE                         บ  READ/WRITE บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออสอออออฮออออออนฑฑ
ฑฑบ HISTORICO    บ 22/10/2010 CRIACAO.                                                  บฑฑ
ฑฑบ              บ                                                                      บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ USO          บ MODULO ESTOQUE/CUSTOS                                                บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER FUNCTION RESTA015(CALIAS, NREG, NOPC)
    
LOCAL CTITULO 		:= "Produto Fornecido pelo Cliente"

PRIVATE ABUTTONS	:= {}
PRIVATE OCHECKBO1
PRIVATE LCHECKBO1	:= .F.
PRIVATE OCHECKBO2
PRIVATE LCHECKBO2	:= .F.
PRIVATE OCHECKBO3
PRIVATE LCHECKBO3	:= .F.
PRIVATE OCHECKBO4
PRIVATE LCHECKBO4	:= .F.
PRIVATE OCOMBO1
PRIVATE CCOMBO1     
PRIVATE ACLIFOR		:= {"C-Cliente","F-Fornecedor"}
PRIVATE OGET2
PRIVATE CGET2		:= SPACE(9)
PRIVATE OGET3
PRIVATE CGET3		:= SPACE(3)
PRIVATE OGET4
PRIVATE CGET4		:= SPACE(6)
PRIVATE OGET5
PRIVATE CGET5		:= SPACE(2)
PRIVATE OGET6
PRIVATE CGET6		:= SPACE(30)
PRIVATE OGET7
PRIVATE CGET7		:= ALLTRIM(USRRETNAME(RETCODUSR()))
PRIVATE OGET8
PRIVATE DGET8
PRIVATE OGET9
PRIVATE OSAY1
PRIVATE OSAY2
PRIVATE OSAY3
PRIVATE OSAY4
PRIVATE OSAY5
PRIVATE OSAY6
PRIVATE OSAY7
PRIVATE OSAY8
PRIVATE OSAY9
PRIVATE OSAY10
PRIVATE OSAY11
PRIVATE NX			:= 0
PRIVATE AREG		:= {}
PRIVATE LRET		:= .F.
PRIVATE CNOTA		:= ""
PRIVATE CSERIE		:= ""
PRIVATE CCLIFOR		:= ""
PRIVATE CLOJA		:= ""
PRIVATE CNREDUZ		:= ""
PRIVATE _CMSG		:= ""
PRIVATE NPITEM		:= 0
PRIVATE NPPROD		:= 0
PRIVATE NPQTDE		:= 0
PRIVATE NPTES		:= 0
PRIVATE NPDESCT		:= 0
PRIVATE NPIDENT		:= 0
PRIVATE NPNIDEN		:= 0
PRIVATE NPIMPUR		:= 0
PRIVATE NPAVARI		:= 0
PRIVATE NPNATOP		:= 0
PRIVATE NPFREAR		:= 0
PRIVATE NPEMPMA		:= 0
PRIVATE NPPRETE		:= 0
PRIVATE NPEMBAL		:= 0
PRIVATE NPDESTI		:= 0
PRIVATE NPOBS		:= 0
PRIVATE NVEZES		:= 0
PRIVATE AAREASZ6	:= {}
STATIC ODLG
	
	DEFINE MSDIALOG ODLG TITLE CTITULO FROM 000, 000  TO 600, 900 COLORS 0, 16777215 PIXEL
	
		@ 018, 012 SAY OSAY1 PROMPT "Entregue p/: " SIZE 032, 009 OF ODLG COLORS 0, 16777215 PIXEL
		@ 018, 056 MSCOMBOBOX OCOMBO1 VAR CCOMBO1 ITEMS ACLIFOR SIZE 052, 010 VALID VALID01(CCOMBO1) OF ODLG COLORS 0, 16777215 PIXEL  
		
		@ 018, 127 SAY OSAY2 PROMPT "Nota Fiscal: " SIZE 038, 008 OF ODLG COLORS 0, 16777215 PIXEL
		@ 018, 172 MSGET OGET2 VAR CGET2 SIZE 049, 010 WHEN .F. OF ODLG COLORS 0, 16777215 PIXEL
	
		@ 018, 241 SAY OSAY3 PROMPT "Serie: " SIZE 036, 006 OF ODLG COLORS 0, 16777215 PIXEL
		@ 018, 270 MSGET OGET3 VAR CGET3 SIZE 051, 010 WHEN .F. OF ODLG COLORS 0, 16777215 PIXEL

		@ 038, 012 SAY OSAY4 PROMPT "Cliente: " SIZE 037, 010 OF ODLG COLORS 0, 16777215 PIXEL
		@ 038, 056 MSGET OGET4 VAR CGET4 SIZE 051, 010 WHEN .F. OF ODLG COLORS 0, 16777215 PIXEL

		@ 038, 127 SAY OSAY5 PROMPT "Loja: " SIZE 042, 008 OF ODLG COLORS 0, 16777215 PIXEL
		@ 038, 172 MSGET OGET5 VAR CGET5 SIZE 048, 010 WHEN .F. OF ODLG COLORS 0, 16777215 PIXEL

		@ 058, 012 SAY OSAY6 PROMPT "Razao Social: " SIZE 039, 011 OF ODLG COLORS 0, 16777215 PIXEL
		@ 058, 056 MSGET OGET6 VAR CGET6 SIZE 280, 010 WHEN .F. OF ODLG COLORS 0, 16777215 PIXEL

		@ 078, 012 SAY OSAY7 PROMPT "Usuario: " SIZE 037, 009 OF ODLG COLORS 0, 16777215 PIXEL
		@ 078, 056 MSGET OGET7 VAR CGET7 SIZE 051, 010 WHEN .F. OF ODLG COLORS 0, 16777215 PIXEL

		@ 078, 127 SAY OSAY8 PROMPT "Data Envio: " SIZE 037, 009 OF ODLG COLORS 0, 16777215 PIXEL
		@ 078, 172 MSGET OGET8 VAR DGET8 SIZE 051, 010 WHEN .F. OF ODLG COLORS 0, 16777215 PIXEL

		@ 098, 012 SAY OSAY9 PROMPT "Inf. Comercial:" SIZE 041, 010 OF ODLG COLORS 0, 16777215 PIXEL
		@ 098, 050 CHECKBOX OCHECKBO1 VAR LCHECKBO1 PROMPT "OCHECKBO1" SIZE 007, 005 OF ODLG COLORS 0, 16777215 PIXEL

		@ 098, 080 SAY OSAY10 PROMPT "Inf. Testes:" SIZE 037, 010 OF ODLG COLORS 0, 16777215 PIXEL
		@ 098, 110 CHECKBOX OCHECKBO2 VAR LCHECKBO2 PROMPT "OCHECKBO2" SIZE 007, 005 OF ODLG COLORS 0, 16777215 PIXEL

		@ 098, 138 SAY OSAY11 PROMPT "Inf. Ass.Tecnica:" SIZE 040, 009 OF ODLG COLORS 0, 16777215 PIXEL
		@ 098, 187 CHECKBOX OCHECKBO3 VAR LCHECKBO3 PROMPT "OCHECKBO3" SIZE 007, 005 OF ODLG COLORS 0, 16777215 PIXEL

		@ 098, 213 SAY OSAY12 PROMPT "Diversos:" SIZE 040, 009 OF ODLG COLORS 0, 16777215 PIXEL
		@ 098, 241 CHECKBOX OCHECKBO4 VAR LCHECKBO4 PROMPT "OCHECKBO4" SIZE 007, 005 OF ODLG COLORS 0, 16777215 PIXEL

		ENCHOICEBAR( ODLG, { || (IIF(NOPC == 4, VALIDALT(NOPC), IIF(NOPC == 5, VALIDEXC(NOPC), ODLG:END())), ODLG:END())}, {|| RESTAREA(AAREASZ6), ODLG:END()},,ABUTTONS)
        FMSNEWGE1(NOPC)
		ATCABEC(NREG)
		ATUACOLS(CALIAS, NREG, NOPC)

	ACTIVATE MSDIALOG ODLG CENTERED


RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   FMSNEWGE1     บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA CRIAR A MSNEWGETDADOS                                    บฑฑ
ฑฑบ              บ                                                                      บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION FMSNEWGE1(NOPC)

Local aGetSX3		:= {}
LOCAL AFIELDFILL	:= {}
LOCAL AFIELDS		:= {"Z6_ITEM","Z6_PRODUTO","Z6_QTDE","Z6_TES","Z6_DESCTES","Z6_IDENTIF","Z6_NIDENTI","Z6_IMPUREZ","Z6_AVARIAS","Z6_NATOPE","Z6_FREAREJ","Z6_EMPMAX","Z6_PRETEMP","Z6_EMBALAG","Z6_DESTINO","Z6_OBS","Z6_DTENVIO"}
LOCAL AALTERFIELDS	:= {"Z6_PRODUTO","Z6_IDENTIF","Z6_NIDENTI","Z6_IMPUREZ","Z6_AVARIAS","Z6_FREAREJ","Z6_EMPMAX ","Z6_PRETEMP","Z6_EMBALAG","Z6_DESTINO","Z6_OBS","Z6_DTENVIO"}
LOCAL CLINOK      	:= "ALLWAYSTRUE"
LOCAL CTUDOOK     	:= "ALLWAYSTRUE"
LOCAL CINICPOS    	:= "D1_ITEM"
LOCAL NFREEZE     	:= 000
LOCAL NMAX        	:= 99
LOCAL CFIELDOK    	:= "ALLWAYSTRUE"
LOCAL CSUPERDEL   	:= ""
LOCAL CDELOK      	:= "ALLWAYSFALSE"
LOCAL AHEADEREX   	:= {}
LOCAL ACOLSEX		:= {}
LOCAL NX := 0

STATIC OMSNEWGE1
	

	// DEFINE PROPRIEDADES AFIELD
/*	
	DBSELECTAREA("SX3")
	SX3->(DBSETORDER(2))
	FOR NX := 1 TO LEN(AFIELDS)
		IF SX3->(DBSEEK(AFIELDS[NX]))
			AADD(AHEADEREX, {ALLTRIM(X3TITULO()),ALLTRIM(SX3->X3_CAMPO),SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ENDIF
	NEXT NX
*/
	aGetSX3 := FWSX3Util():GetAllFields('SZ6',.F.)
	For nX := 1 To Len(aGetSX3)
		If aScan(AFIELDS, aGetSX3[nX]) > 0
			AADD(AHEADEREX,{ RetTitle(aGetSX3[nX]), aGetSX3[nX], PesqPict('SZ6',aGetSX3[nX]), TamSX3(aGetSX3[nX])[1], TamSX3(aGetSX3[nX])[2], .T., 'S', TamSX3(aGetSX3[nX])[3] })
		Endif
	Next nX

	// DEFINE VALORES AFIELD
	FOR NX := 1 TO LEN(AHEADEREX)
		AADD(AFIELDFILL, CRIAVAR(AHEADEREX[nX,2],.F.))
	NEXT NX
	AADD(AFIELDFILL, .F.)
	AADD(ACOLSEX, AFIELDFILL)
	
	IF NOPC == 4
		OMSNEWGE1 := MSNEWGETDADOS():NEW( 118, 007, 226, 435, GD_INSERT+GD_DELETE+GD_UPDATE, CLINOK, CTUDOOK, CINICPOS, AALTERFIELDS, NFREEZE, NMAX, CFIELDOK, CSUPERDEL, CDELOK, ODLG, AHEADEREX, ACOLSEX)
		OMSNEWGE1:OBROWSE:AALTER := AALTERFIELDS	// ENVIA ARRAY EDITAVEL
		OMSNEWGE1:LDELETE := .F.					// INDICA SE PODE OU NAO DELETAR LINHA DO ARRAY
	ELSE
		OMSNEWGE1 := MSNEWGETDADOS():NEW( 118, 007, 226, 435, NOPC, CLINOK, CTUDOOK, CINICPOS, AALTERFIELDS, NFREEZE, NMAX, CFIELDOK, CSUPERDEL, CDELOK, ODLG, AHEADEREX, ACOLSEX)
	ENDIF


RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   ATCABEC       บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA ALIMENTAR O CABECALHO DA MSNEWGETDADOS                   บฑฑ
ฑฑบ              บ P/ ACESSAR O AHEADER DESTA MSNEWGETDADOS: OMSNEWGE1:AHEADER[NX,NY]   บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION ATCABEC(NREG)

	AAREASZ6 := SZ6->(GETAREA())

    DBSELECTAREA("SZ6")
	SZ6->(DBSETORDER(2))
	SZ6->(DBGOTOP())
	SZ6->(DBGOTO(NREG))
    
	IF ALLTRIM(SZ6->Z6_CLIFOR) == "C"
		CCOMBO1 := "C-Cliente"
	ELSE
		CCOMBO1 := "F-Fornecedor"
	ENDIF

	CGET2 := SZ6->Z6_NFISCAL
	CGET3 := SZ6->Z6_SERIE
	CGET4 := SZ6->Z6_CLIENTE
	CGET5 := SZ6->Z6_LOJA
	CGET6 := ALLTRIM(SZ6->Z6_NREDUZ)
	CGET7 := SZ6->Z6_USUARIO
	DGET8 := SZ6->Z6_DTENVIO
	LCHECKBO1 := SZ6->Z6_INFCOM
    LCHECKBO2 := SZ6->Z6_INFTST
    LCHECKBO3 := SZ6->Z6_INFATEC
    LCHECKBO4 := SZ6->Z6_DIVERSO


RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ     VALID01     บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA VALIDAR DADOS DO CAMPO: Entregue p/                      บฑฑ
ฑฑบ              บ                                                                      บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION VALID01(CCOMBO1)
             
	LOCAL LRET1	:= .F.
	
	IF (CCOMBO1 == NIL) .OR. !(SUBSTR(CCOMBO1,1,1) == "C" .OR. SUBSTR(CCOMBO1,1,1) == "F")
		ALERT("Informar se o Produto foi entregue pelo Cliente - (C) ou entregue pelo Fornecedor do Cliente (F)")
		RETURN(LRET1)
	ELSE
	    LRET1 := .T.
	ENDIF
	

RETURN(LRET1)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ     ATUACOLS    บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA ALIMENTAR OS ITENS DA NF ENTRADA NO ACOLS                บฑฑ
ฑฑบ              บ PARA ACESSAR O ACOLS DESTA MSNEWGETDADOS: OMSNEWGE1:ACOLS[NX,NY]     บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION ATUACOLS(CALIAS, NREG, NOPC)
	
	NX		:= 1
	NPITEM	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_ITEM"})
	NPPROD	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_PRODUTO"})
	NPQTDE	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_QTDE"})
	NPTES	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_TES"})
	NPDESCT	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_DESCTES"})
	NPIDENT	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_IDENTIF"})
	NPNIDEN	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_NIDENTI"})
	NPIMPUR	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_IMPUREZ"})
	NPAVARI	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_AVARIAS"})
	NPNATOP	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_NATOPE"})
	NPFREAR	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_FREAREJ"})
	NPEMPMA	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_EMPMAX"})
	NPPRETE	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_PRETEMP"})
	NPEMBAL	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_EMBALAG"})
	NPDESTI	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_DESTINO"})
	NPOBS	:= ASCAN(OMSNEWGE1:AHEADER,{|X| ALLTRIM(X[2]) == "Z6_OBS"})
	
	SZ6->(DBGOTOP())
	IF SZ6->(DBSEEK(XFILIAL("SZ6")+CGET4+CGET5+CGET2+CGET3))
		DO WHILE (SZ6->Z6_FILIAL+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA+SZ6->Z6_NFISCAL+SZ6->Z6_SERIE) == (XFILIAL("SZ6")+CGET4+CGET5+CGET2+CGET3) .AND. SZ6->(!EOF())
			AADD (AREG, SZ6->(RECNO()))
			IF (LEN(OMSNEWGE1:ACOLS) >= 1) .AND. !EMPTY(OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPPROD])
				AADD(OMSNEWGE1:ACOLS,ARRAY(LEN(OMSNEWGE1:AHEADER) + 1))
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPITEM] := SPACE(04)						//ITEM
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPPROD] := SPACE(TAMSX3("B1_COD")[1])		//PRODUTO
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPQTDE] := SPACE(TAMSX3("D1_QUANT")[1])	//QUANTIDADE
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPTES]  := SPACE(TAMSX3("D1_TES")[1])		//TES
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPDESCT]:= SPACE(TAMSX3("F4_TEXTO")[1])	//DESCRICAO TES
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPIDENT]:= SPACE(TAMSX3("Z6_IDENTIF")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPNIDEN]:= SPACE(TAMSX3("Z6_NIDENTI")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPIMPUR]:= SPACE(TAMSX3("Z6_IMPUREZ")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPAVARI]:= SPACE(TAMSX3("Z6_AVARIAS")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPNATOP]:= SPACE(TAMSX3("Z6_NATOPE")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPFREAR]:= SPACE(TAMSX3("Z6_FREAREJ")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPEMPMA]:= SPACE(TAMSX3("Z6_EMPMAX")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPPRETE]:= SPACE(TAMSX3("Z6_PRETEMP")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPEMBAL]:= SPACE(TAMSX3("Z6_EMBALAG")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPDESTI]:= SPACE(TAMSX3("Z6_DESTINO")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),NPOBS]:= SPACE(TAMSX3("Z6_OBS")[1])
				OMSNEWGE1:ACOLS[LEN(OMSNEWGE1:ACOLS),LEN(OMSNEWGE1:AHEADER)+1] := .F.
			ENDIF
				
			OMSNEWGE1:ACOLS[NX ,NPITEM]  := SZ6->Z6_ITEM		//ITEM
			OMSNEWGE1:ACOLS[NX ,NPPROD]  := SZ6->Z6_PRODUTO		//PRODUTO
			OMSNEWGE1:ACOLS[NX ,NPQTDE]  := SZ6->Z6_QTDE		//QUANTIDADE
			OMSNEWGE1:ACOLS[NX ,NPTES]   := SZ6->Z6_TES			//TES
			OMSNEWGE1:ACOLS[NX ,NPDESCT] := SZ6->Z6_DESCTES		//DESCRICAO TES 
			OMSNEWGE1:ACOLS[NX, NPIDENT] := SZ6->Z6_IDENTIF
			OMSNEWGE1:ACOLS[NX, NPNIDEN] := SZ6->Z6_NIDENTI
			OMSNEWGE1:ACOLS[NX, NPIMPUR] := SZ6->Z6_IMPUREZ
			OMSNEWGE1:ACOLS[NX, NPAVARI] := SZ6->Z6_AVARIAS 
			OMSNEWGE1:ACOLS[NX, NPNATOP] := SZ6->Z6_NATOPE
			OMSNEWGE1:ACOLS[NX, NPFREAR] := SZ6->Z6_FREAREJ
			OMSNEWGE1:ACOLS[NX, NPEMPMA] := SZ6->Z6_EMPMAX
			OMSNEWGE1:ACOLS[NX, NPPRETE] := SZ6->Z6_PRETEMP
			OMSNEWGE1:ACOLS[NX, NPEMBAL] := SZ6->Z6_EMBALAG
			OMSNEWGE1:ACOLS[NX, NPDESTI] := SZ6->Z6_DESTINO
			OMSNEWGE1:ACOLS[NX, NPOBS]   := SZ6->Z6_OBS
			OMSNEWGE1:ACOLS[NX, LEN(OMSNEWGE1:AHEADER)+1] := .F.
			
			SZ6->(DBSKIP())
			NX ++
			LOOP
			
		ENDDO
		
	ELSE
		ALERT("Nใo existe registros para serem alterados")
		RETURN(.F.)
	ENDIF

	//MUDLINHA()
	OMSNEWGE1:OBROWSE:REFRESH()
	OMSNEWGE1:FORCEREFRESH()

RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ    VALIDALT     บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA VALIDAR DADOS                                            บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION VALIDALT(NOPC)

	LOCAL NI 	:= 0
	LOCAL NX 			:= 0
	LOCAL LRET		:= .F.
	
	P_ACOLS()	//CHAMADA DA FUNCAO QUE VALIDA OS ITENS DA TELA
    

	// MONTA CABECALHO DO EMAIL
	_CMSG := ""
	_CMSG := "ALTERAวรO Cadastro de Produto Fornecido pelo Cliente - Realizado pelo Usuแrio: " +CGET7
	_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	_CMSG += "Produto Entregue Por: " + ALLTRIM(SUBSTR(CCOMBO1,3,10))
	_CMSG += ": " + CCLIFOR + "-" + CLOJA + " / " + CNREDUZ
	_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	_CMSG += "Nota Fiscal: " + CNOTA + " / S้rie: " + CSERIE  + " / Data de Envio: " + DTOC(DGET8)
	_CMSG += CHR(13)+CHR(10)
	_CMSG += "************************************************************************************"
	_CMSG += CHR(13)+CHR(10)
	_CMSG += "ITENS"
	_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	// FIM DO CABECALHO DO EMAIL
	
	FOR NX := 1 TO LEN(AREG)
		IF NX <= LEN (AREG)
			DBGOTO(AREG[NX])
			RECLOCK("SZ6",.F.)
			IF OMSNEWGE1:ACOLS[NX, LEN(OMSNEWGE1:AHEADER)+1]
				DBDELETE()
			ENDIF
		ELSE
			RECLOCK("SZ6",.T.)
		ENDIF
		
		IF !OMSNEWGE1:ACOLS[NX, LEN(OMSNEWGE1:AHEADER)+1]
			SZ6->Z6_CLIFOR	:= SUBSTR(CCOMBO1,1,1)
	        SZ6->Z6_INFCOM	:= LCHECKBO1
	        SZ6->Z6_INFTST	:= LCHECKBO2
	        SZ6->Z6_INFATEC	:= LCHECKBO3
	        SZ6->Z6_DIVERSO := LCHECKBO4

	        FOR NI := 1 TO LEN (OMSNEWGE1:AHEADER)
	        	FIELDPUT( FIELDPOS (OMSNEWGE1:AHEADER[NI, 2]), OMSNEWGE1:ACOLS[NX, NI])
	        NEXT NI

        ENDIF

        SZ6->(MSUNLOCK())
		GERAEMAIL()

	NEXT NX

	RESTAREA(AAREASZ6)
	LRET := .T.
	MSGRUN("Gravando Informa็๕es e enviando email...","Aguarde",{|| CURSORWAIT(), ENVEMAIL(NOPC), CURSORARROW()})


RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ     P_ACOLS    บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10    บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA PREPARAR ARRAY ACOLS                                     บฑฑ
ฑฑบ              บ PARA ACESSAR O ACOLS DESTA MSNEWGETDADOS: OMSNEWGE1:ACOLS[NX,NY]     บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION P_ACOLS()
    
	LOCAL NY := 0

	FOR NY := 1 TO LEN(OMSNEWGE1:ACOLS)
		IF EMPTY (OMSNEWGE1:ACOLS[NY,NPPROD])					//CASO POSSUA ITEM COM O CAMPO PRODUTO EM BRANCO
			ADEL(OMSNEWGE1:ACOLS, NY)							//DELETA ARRAY ACOLS
			ASIZE(OMSNEWGE1:ACOLS,LEN(OMSNEWGE1:ACOLS)-1)		//REORGANIZA ARRAY ACOLS
			OMSNEWGE1:OBROWSE:REFRESH()							//ATUALIZA TELA
			OMSNEWGE1:FORCEREFRESH()                            //ATUALIZA TELA
		ENDIF
	NEXT NY


RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ     VALIDEXC   บ  AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA VALIDAR DADOS                                            บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION VALIDEXC(NOPC)

	LOCAL NI := 0
    
	FOR NI := 1 TO LEN(OMSNEWGE1:ACOLS)
		DBGOTO(AREG[NI])
		RECLOCK("SZ6",.F.)
		SZ6->(DBDELETE())
		SZ6->(MSUNLOCK())
	NEXT NI

	RESTAREA(AAREASZ6)


RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   GERAEMAIL     บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10   บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA GERAR EMAIL COM ITENS DA NOTA FISCAL.                    บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION GERAEMAIL()

	_CMSG  += "Item: " + CVALTOCHAR(OMSNEWGE1:ACOLS[NX, NPITEM]) + " - Produto: " + CVALTOCHAR(OMSNEWGE1:ACOLS[NX, NPPROD]) + " / " + ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + OMSNEWGE1:ACOLS[NX, NPPROD],"B1_DESC"," "))
	_CMSG  += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	_CMSG  += "Quantidade: " + CVALTOCHAR(OMSNEWGE1:ACOLS[NX, NPQTDE])
	_CMSG  += " / Tes: " + CVALTOCHAR(OMSNEWGE1:ACOLS[NX, NPTES]) + " / " + "Descri็ใo da Tes: " + ALLTRIM(OMSNEWGE1:ACOLS[NX, NPDESCT])
	_CMSG  += CHR(13)+CHR(10) + CHR(13)+CHR(10)

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPIDENT])
		_CMSG += "Identificado: "
		IF OMSNEWGE1:ACOLS[NX, NPIDENT] == "S"
			_CMSG += "Sim"
		ELSEIF OMSNEWGE1:ACOLS[NX, NPIDENT] == "N"
			_CMSG += "Nใo"
		ENDIF
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPNIDEN])
		_CMSG += "Identifica็ใo da Pe็a: " + OMSNEWGE1:ACOLS[NX, NPNIDEN]
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPIMPUR])
		_CMSG += "Impureza? "
		IF OMSNEWGE1:ACOLS[NX, NPIMPUR] == "S"
			_CMSG += "Sim"
		ELSEIF OMSNEWGE1:ACOLS[NX, NPIMPUR] == "N"
			_CMSG += "Nใo"
		ENDIF
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPAVARI])
		_CMSG += "Avarias: " + OMSNEWGE1:ACOLS[NX, NPAVARI]
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPNATOP])
		_CMSG += "Nat.Opera็ใo: " + OMSNEWGE1:ACOLS[NX, NPNATOP]
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPFREAR])
		_CMSG += "Fresco/Arejado: "
		IF OMSNEWGE1:ACOLS[NX, NPFREAR] == "S"
			_CMSG += "Sim"
		ELSEIF OMSNEWGE1:ACOLS[NX, NPFREAR] == "N"
			_CMSG += "Nใo"
		ENDIF
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPEMPMA])
		_CMSG += "Empil. Mแximo: " + OMSNEWGE1:ACOLS[NX, NPEMPMA]
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPPRETE])
		_CMSG += "Temperatura ? " + OMSNEWGE1:ACOLS[NX, NPPRETE]
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPEMBAL])
		_CMSG += "Como Embalar ? " + OMSNEWGE1:ACOLS[NX, NPEMBAL]
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF

	_CMSG += "Encaminhar: " + OMSNEWGE1:ACOLS[NX, NPDESTI]
	_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)

	IF !EMPTY(OMSNEWGE1:ACOLS[NX, NPOBS])
		_CMSG += "Observa็๕es: " + OMSNEWGE1:ACOLS[NX, NPOBS]
		_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)
	ENDIF
	
	_CMSG += "----------------------------------------------------------------------------------------------------------"
	_CMSG += CHR(13)+CHR(10) + CHR(13)+CHR(10)


RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหออออออออออออออออหอออออออหอออออออออออออออออออออออหออออออหออออออออออออออปฑฑ
ฑฑบ PROGRAMA     บ   ENVEMAIL     บ AUTOR บ FABIO MARCELO DIAS    บ DATA บ  10/10/10    บฑฑ
ฑฑฬออออออออออออออฮออออออออออออออออสอออออออสอออออออออออออออออออออออสออออออสออออออออออออออนฑฑ
ฑฑบ HISTORICO    บ FUNCAO PARA ENVIAR EMAIL CONFORME SELECIONADO NAS VARIAVEIS          บฑฑ
ฑฑบ              บ LCHECKBO1 - LCHECKBO2 - LCHECKBO3                                    บฑฑ
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออนฑฑ
ฑฑบ PROPRIETARIO บ CUSTOMIZADO PARA MASIPACK                                            บฑฑ
ฑฑศออออออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

STATIC FUNCTION ENVEMAIL(NOPC)

	LOCAL _CTITULO   := ""
	LOCAL _CDESTINO  := ""
	LOCAL _CCCO      := ""
	LOCAL _CANEXO    := ""
	LOCAL _cDE       := ""
	
	IF SUBSTR(cNumEmp,1,2) == "01" // Masipack
		_cDE		  := "pcmasipack.totvs@masipack.com.br"	
	ELSEIF SUBSTR(cNumEmp,1,2) $ "10_11" // Fabrima
		_cDE		  := "pcfabrima.totvs@masipack.com.br"	
	ELSE	
		//_cDE		  := "masipack@masipack.com.br"	
	ENDIF	

	
	IF (NOPC == 3 .OR. NOPC == 4) .AND. (LCHECKBO1 == .T. .OR. LCHECKBO2 == .T. .OR. LCHECKBO3 == .T.)
		
		_CTITULO := "Altera็ใo de Cadastro de Produto Fornecido pelo Cliente"

		IF	LCHECKBO1 == .T.
			_CDESTINO := "comercial@masipack.com.br;vendas@masipack.com.br"
		ENDIF

		IF LCHECKBO2 == .T.
			IF _CDESTINO == ""
				_CDESTINO := "vagner.cm@masipack.com.br"
			ELSE
				_CDESTINO += ";vagner.cm@masipack.com.br"
			ENDIF
		ENDIF

		IF LCHECKBO3 == .T.
			IF _CDESTINO == ""
				_CDESTINO := "fernando.padial@masipack.com.br"
			ELSE
				_CDESTINO += ";fernando.padial@masipack.com.br"
			Endif
		ENDIF
	    
		oMail:= EnvMail():NEW(.F.)
		If oMail:ConnMail()
			oMail:SendMail(_CTITULO,_cDESTINO,_CCCO,,_CMSG)
		EndIf
		oMail:DConnMail()

	ENDIF

RETURN()
