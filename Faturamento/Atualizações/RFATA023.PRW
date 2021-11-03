#Include "Rwmake.ch"
#Include "Topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³RFATA023  ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±                      ºAlterac³Solange Ap Vezu     º Data ³  03/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para preenchimento do Relatorio D.A.N.(Dados         º±±
±±º          ³Adicionais da Nota Fiscal de saida)                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                             º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RFATA023()
cCadastro := "Atualizacao do D.A.N."
aRotina := { 	{"Pesquisar"	,"AxPesqui"			,00,01	} 	,;
             	{"D.A.N."		,"U__fDan2()"		,00,04	}	,;
             	{"Relatorio"	,"U__fRelDan()"	,00,02	}	,;
             	{"Legenda"		,"U__fLeg2()"	,00,02	}	}
dbSelectArea("SF2")
dbSetOrder(1)
_aCores := 	{	{ "Empty(F2_MSCOLET)" 		, "BR_AZUL" 		}	,;
            	{ "! Empty(F2_MSCOLET)" 	, "BR_VERDE" 		} }
mBrowse( 6,1,22,75,"SF2",,,,,,_aCores)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³_fLengendaºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de criacao das legendas.                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                            
User Function _fLeg2()                     

Local aCores
Local _aCores    := 	{	{ 'BR_AZUL'   		, "D.A.N. a Gerar" 		}	,;
							{ 'BR_VERDE'   		, "D.A.N. Gerado" 		}	}

BrwLegenda(cCadastro,"Legenda do Browse",_aCores)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³_fDan2     ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de Atualizacao do DAN.                              º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                            

User Function _fDan2()

_cColeta  	:= SF2->F2_MSCOLET
_dDtCol   	:= iif(Empty(SF2->F2_MSDTCOL),dDataBase,SF2->F2_MSDTCOL)
_cTransp  	:= SF2->F2_TRANSP
_cMsMotor 	:= SF2->F2_MSMOTOR
_cVeiculo 	:= SF2->F2_VEICUL1
//_cMsPluf  	:= SF2->F2_MSPLUF
_cOcorren	:= ""	
_cCliente	:= ""  
cMsLcNf    	:= SF2->F2_MSLCNF
aMsLcNf  	:= {" ","A","P"} 		//Almoxarifado/Portaria  
cMsCanh    	:= SF2->F2_MSCANH
aMsCanh    	:= {" ","S","N"} 		//Sim/Nao
cMsDAN     	:= SF2->F2_MSDAN
aMsDAN     	:= {" ","S","N"} 		//Sim/Nao
cMsOrdem   	:= SF2->F2_MSORDEM
aMsOrdem   	:= {" ","S","N"} 		//Sim/Nao
cMsObDan    := SF2->F2_MSOBDAN

SD2->(DbSetOrder(3))     
SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
If (SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA) == ;
   	(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
   	SF4->(DbSetOrder(1))
   	If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
   		_cOcorren := SF4->F4_TEXTO
   	EndIf
EndIf
If SF2->F2_TIPO == "N"
   	SA1->(DbSetOrder(1))                                         
   	If SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
      	_cCliente := SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + SA1->A1_NREDUZ
   	EndIf
Else
   	SA2->(DbSetOrder(1))
   	If SA2->(DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
      	_cCliente := SA2->A2_COD + "/" + SA2->A2_LOJA + " - " + SA2->A2_NREDUZ
   	EndIf
Endif

SA4->(DbSetOrder(1))
If SA4->(DbSeek(xFilial("SA4")+SF2->F2_TRANSP))
   	_cTransp := SA4->A4_NOME
EndIf       

DA4->(DbSetOrder(1))
If DA4->(DbSeek(xFilial("DA4")+SF2->F2_MSMOTOR))
	_cMotorist	:= DA4->DA4_COD
	_cNome      := DA4->DA4_NOME
	_cRg		:= DA4->DA4_RG
	_cRgOrg		:= DA4->DA4_RGORG
	_cCNH		:= DA4->DA4_NUMCNH
	_cVinculo   := DA4->DA4_TIPMOT
EndIf
DA3->(DbSetOrder(1))
If DA3->(DbSeek(xFilial("DA3")+SF2->F2_VEICUL1))
	_cVeiculo	:= DA3->DA3_DESC
	_cPlaca     := DA3->DA3_PLACA
	_cEstPla    := DA3->DA3_ESTPLA
	_cDescor    := DA3->DA3_CORVEI
EndIf
@ 077,108 To 600,590 Dialog _oDlg1 Title OemToAnsi("D.A.N.")
@ 006,012 To 060,223 Title OemToAnsi("DAN - Dados Adicionais da Nota Fiscal")
@ 020,021 Say OemToAnsi("Nota Fiscal  : " + SF2->F2_DOC) 						Size 059,008
@ 020,104 Say OemToAnsi("Ocorrencia : "  + _cOcorren) 							Size 101,008
@ 042,021 Say OemToAnsi("Destinatario : " + _cCliente) 							Size 183,008
@ 069,012 To 152,223 Title OemToAnsi("Dados preenchidos pela Portaria")
@ 082,021 Say OemToAnsi("Coleta: ") 											Size 027,008
@ 082,055 Say _cColeta 															Size 052,010
@ 082,104 Say OemToAnsi("Data Coleta  : " + dtoc(_dDtCol))						Size 101,010
@ 100,021 Say OemToAnsi("Transportadora:")  									Size 045,008
@ 100,071 Say _cTransp															Size 100,010
@ 116,021 Say OemToAnsi("Motorista    : ") 										Size 040,008
@ 116,071 Say DA4->DA4_NOME														Size 100,010
@ 132,021 Say OemToAnsi("Veiculo      : ") 										Size 040,008
@ 132,071 Say _cVeiculo															Size 058,010
@ 162,012 To 239,223 Title OemToAnsi("Dados preenchidos pelo Faturamento")
@ 178,021 Say OemToAnsi("Local Ent.NF : ")				Size 030,008
@ 193,021 Say OemToAnsi("Canhoto?       ")	   			Size 030,008
@ 193,071 Say OemToAnsi("DAN?           ")	   			Size 030,008
@ 193,121 Say OemToAnsi("Ord.Coleta?    ")	   			Size 030,008
@ 218,021 Say OemToAnsi("Observação:    ") 	   			Size 030,008
@ 178,071 ComboBox  cMsLcNf  	Items aMsLcNf  	Size 030,010 object oMsLcNF 
@ 178,105 Say OemToAnsi("A=Almoxarifado / P=Portaria")	Size 100,010 
@ 200,021 ComboBox 	cMsCanh  	Items aMsCanh	Size 030,010 object oMsCanh
@ 200,071 ComboBox 	cMsDan		Items aMsDan	Size 030,010 object oMsDan
@ 200,121 ComboBox 	cMsOrdem 	Items aMsOrdem	Size 030,010 object oMsOrdem		
@ 218,071 Get 		cMsObDan								Size 138,010
@ 244,102 BmpButton Type 13 Action _fGrava()
@ 244,161 BmpButton Type 02 Action _oDlg1:End()
Activate Dialog _oDlg1
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³_fGrava   ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de gravacao dos dados informados.                   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function _fGrava()
If ! MsgBox("Confirma a Gravacao dos dados acima digitados ???","CONFIRMAR","YESNO")
   Return
EndIf
If RecLock("SF2",.f.)
	If cMsLcNf=="A"
		SF2->F2_MSLCNF  := "A"
	Elseif cMsLcNf=="P"
		SF2->F2_MSLCNF  := "P"
	Endif           
	SF2->F2_MSCANH	:= cMsCanh
	SF2->F2_MSDAN 	:= cMsDan
	SF2->F2_MSORDEM := cMsOrdem
	SF2->F2_MSOBDAN := cMsObDan 
	SF2->(MsUnLock())
Endif
_oDlg1:End()
Return

//******************************************************************************************************************
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Emissao do Relação de Notas Fiscais p/ o D.A.N.            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function _fRelDan()

LOCAL wnrel		  := "RFATA023"
LOCAL aOrd        := {"Por Nota","Por Fornecedor","Por Data de Digitação"}
LOCAL cDesc1	  := "Emissao da Relação de Notas Fiscais"			        //"Relaçao de Notas Fiscais com Informações do DAN" 
PRIVATE Titulo	  := "Relação de Notas Fiscais conforme Parâmetros"			//"Notas Fiscais" 
PRIVATE aReturn   := {"Zebrado", 1,"Administraçao", 1, 2, 1, "",1 }	     	
PRIVATE Tamanho   := "M"
PRIVATE Limite    := 132
PRIVATE nomeprog  := "RFATA023"
PRIVATE nLastKey  := 0
PRIVATE cString   := "SF2"
PRIVATE M_PAG	  := 1
PRIVATE Li        := 99
Private cPerg	  := "RFIN02"
Private Cabec1    := ""
Private Cabec2    := ""  
Private _cForn    := ""
Private _cLoja    := ""
Private _NumDup   := ""
Private _QtdDup   := 0

pergunte(cPerg,.F.)                                              
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
³ mv_par01    Da Nota                                          ³
³ mv_par02    Ate a Nota                                       ³ 
³ mv_par03    Da Serie                                         ³
³ mv_par04    Ate Serie                                        ³
³ mv_par07    A Partir da data de digitação                    ³
³ mv_par08    Ate a data de digitação                          ³ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,,,.F.,/*aOrd*/,.F.,Tamanho)
If nLastKey == 27
	Set Filter To
	Return
Endif
 
SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RFAT23Imp(@lEnd,wnrel,cString,Tamanho)},Titulo) 

Return NIL

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡…o    ³ RFAT23IMP                                                  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RFAT23Imp(lEnd,wnrel,cString,Tamanho)  

Local cDupl  
Local nVlrNota        

mv_par01 := UPPER(mv_par01)
mv_par02 := UPPER(mv_par02)
mv_par03 := UPPER(mv_par03)
mv_par04 := UPPER(mv_par04)

SetRegua(LastRec())

Cabec1  := "NUMERO   SER  DATA DE       FORNECEDOR                                 TOTAL DA NOTA                  T  Í  T  U  L  O  S" 
Cabec2  := "              DIGITAÇÃO                                                   COM IPI         VALOR       NÚMERO    VENCTO.   VCTO.REAL"
Titulo := "Relatorio  de  Notas  Fiscais  -  "    //+ STR0010

dbSelectArea("SF3") 
SF3->(DbSetOrder(6))     
SF3->(DbSeek(xFilial("SF2")+mv_par01+mv_par02))

Do While AllTrim(SF3->F3_NFISCAL) >= AllTrim(mv_par01) .OR. AllTrim(SF3->F3_NFISCAL) <= AllTrim(mv_par02) .and.	AllTrim(SF3->F3_Serie) >= AllTrim(mv_par03) .OR. AllTrim(SF3->F3_Serie) <= AllTrim(mv_par04)
	If lEnd     
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR" 	
		Exit
	Endif
  	IncRegua() 
	If SF3->F3_ENTRADA < mv_par07 .OR. SF3->F3_ENTRADA > mv_par08
		dbSkip()
		Loop
	Endif 
   	ChecaLinha()
	If SF3->F3_MSCLIFO == "C"
   		SA1->(DbSetOrder(1))                                         
   		If SA1->(DbSeek(xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA))
      		_cReduz := Alltrim(SA1->A1_NREDUZ)
   		EndIf
	Else
   		SA2->(DbSetOrder(1))
   		If SA2->(DbSeek(xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA))
      		_cReduz := Alltrim(SA2->A2_NREDUZ)
   		EndIf
	Endif
   	@ Li,000 PSAY SF3->F3_NFISCAL
   	@ Li,007 PSAY SF3->F3_SERIE
   	@ Li,012 PSAY SF3->F3_ENTRADA
   	@ Li,024 PSAY SF3->F3_CLIEFOR + "/" + AllTrim(SF3->F3_LOJA)
   	@ Li,034 PSAY "- " + _cReduz
	@ Li,061 PSAY SF3->F3_VALCONT Picture PesqPict("SF3","F3_VALcont",14,2)
/*   
   _QtdDup = 0
   DBSELECTAREA("SE2")                                                                      
   DBSETORDER(6)
   SE2->(DBGOTOP())
   If DBSEEK(cFilial+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC)
      While !Eof() .AND. AllTrim(SE2->E2_FORNECE)+AllTrim(SE2->E2_LOJA) == _cForn+_cLoja .And. AllTrim(SE2->E2_NUM) == _NumDup 
         If _QtdDup > 0 
            Li++
            If Li > 62
               cabec(titulo,cabec1,cabec2,nomeprog,Tamanho) 
               DbSelectArea("SF1")
               @ Li,000 PSAY SF1->F1_DOC
               @ Li,008 PSAY SF1->F1_SERIE
               @ Li,012 PSAY SF1->F1_DTDIGIT
               @ Li,024 PSAY AllTrim(SF1->F1_FORNECE) + "/" + AllTrim(SF1->F1_LOJA)
               @ Li,034 PSAY "- " + SUBSTR(SF1->F1_NREDUZ,1,20) 
             	@ Li,061 PSAY SF1->F1_VALBRUT Picture PesqPict("SF1","F1_VALBRUT",12,2)
             		DbSelectArea("SE2")
            	EndIf  	
         	EndIf   
         	@ Li,085 PSAY SE2->E2_VALOR  Picture PesqPict("SE2","E2_VALOR",12,2)
         	cDupl := AllTrim(SE2->E2_NUM)
         	If AllTrim(SE2->E2_PARCELA) <> ""
	         	cDupl := cDupl + "/" + AllTrim(SE2->E2_PARCELA)
	      	EndIf   
	      	@ Li,100 PSay cDupl                                                    
	      	@ Li,112 PSay SE2->E2_VENCTO PICTURE "99/99/99"
	      	@ Li,122 PSay SE2->E2_VENCREA PICTURE "99/99/99"
	      	_QtdDup++
         	dbSkip()
         	Loop 
      	End   
    Endif */
Enddo       

Set Device To Screen
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return //.t.

******************************************
Static Function ChecaLinha(nLinhas,cCabec)
******************************************
// nLinhas = salto de cada linha
If nLinhas == Nil
   nLinhas := 1
Endif
If cCabec == Nil
   cCabec := 1
Endif      
If Li > 62
   cabec(titulo,cabec1,cabec2,nomeprog,Tamanho)
Endif
Li += nLinhas   
Return nil

