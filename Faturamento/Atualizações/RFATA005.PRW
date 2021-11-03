#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATA005  ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para preenchimento do D.A.N.(Dados Adicionais da     º±±
±±º          ³Nota Fiscal de saida) e impressao. - Portaria               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function RFATA005()

Private fGravar    := .F.
Private cTipoVeic  := ""
Private cMotorista := ""
Private cDeptoUsu  := ""

cUsuSenha := UsrRetName(RetCodUsr())
PswOrder(2)
If PswSeek(cUsuSenha,.T.)
   _aUsuario := PswRet()
   cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf 

cCadastro := "Atualizacao do D.A.N."
aRotina   := { {"Pesquisar"	,"AxPesqui"			,00,01}	,;
             	{"D.A.N."		,"U__fDan()"		,00,04}	,;
             	{"Imprime"		,"U__fImprDan()"	,00,02}	,;
             	{"Legenda"		,"U__fLegenda()"	,00,02}	}

dbSelectArea("SF2")
dbSetOrder(1)

_aCores := 	{{"Empty(F2_MSDTCOL)" 	, "BR_AZUL"	},;
             {"!Empty(F2_MSDANDT)" 	, "BR_VERMELHO"},;
             {"!Empty(F2_MSDTCOL) .And. Empty(F2_MSDANDT)", "BR_VERDE"}}
             
SET FILTER TO SF2->F2_SERIE <> "UNI" .And.  SF2->F2_SERIE <> "000"          

mBrowse( 6,1,22,75,"SF2",,,,,,_aCores)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³_fLengendaºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de criacao das legendas.                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/                            
User Function _fLegenda()                     

Local _aCores  := {{ 'BR_AZUL'    ,"D.A.N. a Gerar"},;
						 { 'BR_VERDE'   ,"D.A.N. Gerado" },;
						 { 'BR_VERMELHO',"D.A.N. Impresso" }}

BrwLegenda(cCadastro,"Legenda do Browse",_aCores)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³_fDan     ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de Atualizacao do DAN.                              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/                            
User Function _fDan()

fGravar     := .F.
cMotorista  := space(65)
cTipoVeic   := space(65)
_cPortaria  := Space(2)
_DtRetDan   := CTOD("")
_cOcorren	:= ""	
_cCliente	:= ""
_cTransp    := Space(50)
_cMsObDan   := Space(35)
aMsCanh    	:= {"Sim","Nao"}
aMsDAN     	:= {"Sim","Nao"}
aMsOrdem   	:= {"Sim","Nao"} 
aMsPort     := {"01-MMDC","02-31 de Março","03-Expedição"}

IF SUBSTR(cNumEmp,1,2) == "10"
   aMsPort := {"01-Exp./Rec.","02-Estacionamento"}
ENDIF

If !Empty(SF2->F2_MSCOLET)
   _cColeta  := SF2->F2_MSCOLET
Else
   _cColeta  := Space(20)
EndIf

If !Empty(SF2->F2_MSDTCOL)
   _dDtCol := SF2->F2_MSDTCOL
EndIf
If Empty(SF2->F2_MSDANDT)
   If Empty(SF2->F2_MSDANUS) .Or. Alltrim(cUsuSenha) == Alltrim(SF2->F2_MSDANUS)
      fGravar  := .T.
   EndIf
EndIf

_dDtCol    := IIf(Empty(SF2->F2_MSDTCOL),dDataBase,SF2->F2_MSDTCOL)
_DtRetDan  := IIf(Empty(SF2->F2_MSRETDA),dDataBase,SF2->F2_MSRETDA)  
_cMsMotor  := space(06)
_cPortaria  := Space(02)
_cVeiculo  := SF2->F2_VEICUL1
If SF2->F2_MSCANH == "S"
   _cMsCanh := "Sim"
Else
   _cMsCanh := "Nao"
EndIf
If SF2->F2_MSDAN == "S"
   _cMsDAN := "Sim"
Else
   _cMsDAN := "Nao"
EndIf
If SF2->F2_MSORDEM == "S"
   _cMsOrdem := "Sim"
Else
   _cMsOrdem := "Nao"
EndIf            
_cMsObDan    := SF2->F2_MSOBDAN

If !Empty(SF2->F2_TRANSP)
   SA4->(DbSetOrder(1))
   If SA4->(DbSeek(xFilial("SA4")+SF2->F2_TRANSP))
      _cTransp := Alltrim(SA4->A4_COD) + " - " + Alltrim(SA4->A4_NOME)
   EndIf
Else
   _cTransp := Space(50) 
EndIf

DA4->(DbSetOrder(1))
If DA4->(DbSeek(xFilial("DA4")+SF2->F2_MSMOTOR))
   cMotorista := DA4->DA4_NOME
EndIf

DA3->(DbSetOrder(1))
If DA3->(DbSeek(xFilial("DA3")+SF2->F2_VEICUL1))
   If SX5->(DbSeek(xFilial("SX5")+"M6"+DA3->DA3_MARVEI))
      cTipoVeic := Alltrim(SubStr(X5DESCRI(),1,15)) + " " + Alltrim(DA3->DA3_DESC)
   EndIf   
   If !Empty(DA3->DA3_CORVEI)
      If SX5->(DbSeek(xFilial("SX5")+"M7"+DA3->DA3_CORVEI))
         cTipoVeic += "   Cor: " + Alltrim(X5DESCRI())
      EndIf   
   EndIf
EndIf        

SD2->(DbSetOrder(3))     
SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
If (SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA) == ;
   (SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
   SF4->(DbSetOrder(1))
   If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))
   
   		_cOcorren := SF4->F4_TEXTO

   EndIf
EndIf
                                                
If SF2->F2_TIPO $ "NIPC"
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

@ 077,108 To 600,590 Dialog _oDlg1 Title OemToAnsi("DAN - Dados Adicionais da Nota Fiscal")
@ 006,012 To 065,223 Title OemToAnsi("Dados da Nota Fiscal")
@ 020,021 Say OemToAnsi("Nota Fiscal: " + SF2->F2_DOC) 	Size 059,008
@ 020,104 Say OemToAnsi("Ocorrencia: "  + _cOcorren) 		Size 101,008
@ 035,021 Say OemToAnsi("Destinatario: " + _cCliente) 	Size 183,008
@ 050,021 Say OemToAnsi("Transportadora: " + _cTransp)  	Size 180,008

@ 070,012 To 170,223 Title OemToAnsi("Dados Preenchidos pela Portaria")
@ 090,021 Say OemToAnsi("Portaria: ") 			Size 025,008
@ 105,021 Say OemToAnsi("Coleta: ") 			Size 025,008
@ 105,100 Say OemToAnsi("Data Coleta: ") 		Size 035,008
@ 120,021 Say OemToAnsi("Motorista: ") 		Size 045,008
@ 135,021 Say OemToAnsi("Veiculo: ") 		   Size 035,008
@ 150,021 Say OemToAnsi("Observação: ") 	   Size 040,008 

If cDeptoUsu <> "PORTARIA"
   @ 177,012 To 239,223 Title OemToAnsi("Dados Preenchidos pelo Faturamento")
   @ 198,021 Say OemToAnsi("Data : ")	       	Size 050,008  
   @ 213,021 Say OemToAnsi("Canhoto?")	         Size 030,008
   @ 213,086 Say OemToAnsi("DAN?")	   	      Size 030,008
   @ 213,141 Say OemToAnsi("Ord.Coleta?")	   	Size 030,008
EndIf   

If fGravar
   @ 090,045 ComboBox _cPortaria Items aMsPort  Size 055,010 object oMsPort
   @ 105,045 Get _cColeta                  		Size 045,010
   @ 105,135 Get _dDtCol    Valid NaoVazio()    Size 045,010
   @ 120,045 Get _cMsMotor  Valid  Busca01() F3 "DA4"	Size 045,010  
   @ 120,095 Get cMotorista WHEN .F.
   @ 135,045 Get _cVeiculo   F3 "DA3"  Valid Busca02()	Size 035,010 
   @ 135,095 Get cTipoVeic WHEN .F.
   @ 150,055 Get _cMsObDan					                  Size 138,010 
Else
   @ 105,045 Say OemToAnsi(_cColeta)                           Size 045,010
   @ 105,135 Say OemToAnsi(DTOC(_dDtCol))                      Size 045,010
   @ 120,045 Say OemToAnsi(_cMsMotor + Space(1) + cMotorista)  Size 130,010 
   @ 135,045 Say OemToAnsi(_cVeiculo + Space(5) + cTipoVeic)   Size 130,010
EndIf 
If cDeptoUsu <> "PORTARIA"
   @ 198,046 Get 	    _DtRetDan					            Size 045,010      
   @ 213,046 ComboBox 	_cMsCanh  	    Items aMsCanh	        Size 030,010 object oMsCanh
   @ 213,101 ComboBox 	_cMsDan		    Items aMsDan	        Size 030,010 object oMsDan  
   @ 213,171 ComboBox 	_cMsOrdem 	    Items aMsOrdem	        Size 030,010 object oMsOrdem		
EndIf   

@ 244,102 BmpButton Type 13 Action _fGrava()
@ 244,161 BmpButton Type 02 Action _oDlg1:End()
Activate Dialog _oDlg1

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³_fGrava   ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de gravacao dos dados informados.                   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function _fGrava()
If ! MsgBox("Confirma a Gravacao dos dados acima digitados ???","CONFIRMAR","YESNO")
   Return
EndIf

RecLock("SF2",.F.)
If fGravar
   SF2->F2_MSPORT   := SubStr(_cPortaria,1,2)
   SF2->F2_MSCOLET  := _cColeta
   SF2->F2_MSDTCOL  := _dDtCol
   SF2->F2_MSMOTOR  := _cMsMotor
   SF2->F2_VEICUL1  := _cVeiculo
   SF2->F2_MSDANHR  := Time()
   SF2->F2_MSDANUS  := cUsuSenha
EndIf 
SF2->F2_MSCANH	  := SubStr(_cMsCanh,1,1) 
SF2->F2_MSDAN 	  := SubStr(_cMsDan,1,1) 
SF2->F2_MSORDEM  := SubStr(_cMsOrdem,1,1)
SF2->F2_MSOBDAN  := _cMsObDan
SF2->F2_MSRETDA  := _DtRetDan
SF2->(MsUnLock())

_oDlg1:End()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³_fImprDan ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao do D.A.N. ja preenchido.               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function _fImprDan()     

If Empty(SF2->F2_MSDTCOL)
   apMsgStop("D.A.N. nao foi preenchido, Impressao será cancelada !!!!")
   Return
EndIf

If !("INFORMATICA" $ cDeptoUsu) .And. Alltrim(cUsuSenha) <> Alltrim(SF2->F2_MSDANUS)
   apMsgStop("Somente o usuário que preencheu o DAN poderá imprimí-lo, Impressao será cancelada !!!!")
   Return
EndIf

_cRecnoF2 := SF2->(Recno())

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "do D.A.N. ."
Private cDesc3       := ""
Private cPict        := ""
Private titulo       := "Emissao D.A.N."
Private nLin         := 80

Private Cabec1       := ""
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd 		   := {}
Private lEnd         := .F.
Private lAbortPrint	:= .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RFATA005" 
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RFATA005" 
Private cString		:= "SF2"


dbSelectArea("SF2")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| _fImprime() })

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³_fImprime ºAutor  ³Adriano Luis Brandaoº Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao do relatorio.                          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function _fImprime()

_cCliente 	:= ""
_cOcorren 	:= ""
_cTransp	:= ""
_cMotorist  := "" 
_cNome      := ""
_cRg		:= ""
_cRGOrg		:= ""
_cCNH		:= ""
_cVeiculo   := ""
_cDesCor    := ""
_cPlaca     := ""
_cEstPla    := ""
_aPortaria  := {"01-MMDC","02-31 de Março","03-Expedição"}

IF SUBSTR(cNumEmp,1,2) == "10"
   _aPortaria := {"01-Exp./Rec.","02-Estacionamento"}
ENDIF



SetRegua(RecCount())

SF2->(DbGoTo(_cRecnoF2))             

SD2->(DbSetOrder(3))     
SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
SF4->(DbSetOrder(1))
If SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))

	_cOcorren := SD2->D2_CF + " - " + SF4->F4_TEXTO
	
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
	_cRg			:= IIF(EMPTY(DA4->DA4_RG),DA4->DA4_NUMCNH,DA4->DA4_RG)
	_cRgOrg		:= DA4->DA4_RGORG
	_cCNH			:= DA4->DA4_NUMCNH
EndIf

DA3->(DbSetOrder(1))
If DA3->(DbSeek(xFilial("DA3")+SF2->F2_VEICUL1))
   If SX5->(DbSeek(xFilial("SX5")+"M6"+DA3->DA3_MARVEI))
      _cVeiculo   := Alltrim(SubStr(X5DESCRI(),1,15))
   EndIf
   _cVeiculo += " " + DA3->DA3_DESC
   _cPlaca   := DA3->DA3_PLACA
   _cEstPla  := DA3->DA3_ESTPLA 
   If !Empty(DA3->DA3_CORVEI)
       SX5->(DbGoTop())
       SX5->(DbSeek(xFilial("SX5")+"M7"+DA3->DA3_CORVEI))
       _cDesCor := Alltrim(X5DESCRI())
   EndIf   
EndIf

_nLin := 0
@ _nLin,000 		Psay __PrtThinLine()
_nLin++
@ _nLin,000 		Psay SM0->M0_NOMECOM
@ _nLin,090 		Psay "Portaria: "+ _aPortaria[Val(SF2->F2_MSPORT)]

_nLin++                                       
@ _nLin,000 		Psay Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_BAIRCOB)
@ _nLin,Pcol()+1 	Psay " - CEP:"
@ _nLin,Pcol()+1	Psay SM0->M0_CEPCOB Picture "@R 99999-999"
@ _nLin,Pcol()+1   Psay " - " + Alltrim(SM0->M0_CIDCOB) + " - " + Alltrim(SM0->M0_ESTCOB)
_nLin++                                       
@ _nLin,000 		Psay "CNPJ: "
@ _nLin,Pcol()+1  Psay SM0->M0_CGC	Picture "@R 99.999.999/9999-99"
@ _nLin,Pcol()+1  Psay " - I.E.: " + SM0->M0_INSC
_nLin++
If SubStr(cNumEmp,1,2) == "01"
   @ _nLin,000 		Psay "FONE/FAX: (11) 3246-3666,4178-8099"
Else   	
   @ _nLin,000 		Psay "FONE/FAX: " + SM0->M0_TEL
EndIf   
_nLin++
If Substr(cNumEmp,1,2) == "01
   @ _nLin,000 		Psay "Site: www.masipack.com.br"
   _nLin++
Else
   @ _nLin,000 		Psay "Site: www.fabrima.com.br" 
EndIf    
_nLin++
@ _nLin,000			Psay "E-Mail: fiscal@masipack.com.br"
_nLin++
@ _nLin,000 		Psay __PrtThinLine()
_nLin+=2

@ _nLin,000			Psay Padc("D.A.N. - DADOS ADICIONAIS DA NOTA FISCAL",Limite)
_nLin+=2
@ _nLin,000 		Psay __PrtThinLine()
_nLin+=2

@ _nLin,000		    Psay "Nota Fiscal...: " + SF2->F2_DOC
@ _nLin,046 		Psay "Ocorrencia: " + _cOcorren
_nLin+=2
@ _nLin,000			Psay "Destinatario..: " + _cCliente
_nLin+=2
@ _nLin,000			Psay "Coleta........: " + Alltrim(SF2->F2_MSCOLET)
@ _nLin,046			Psay "Data da Coleta : "  + Dtoc(SF2->F2_MSDTCOL)
_nLin+=2
@ _nLin,000			Psay "Transportadora: " + SF2->F2_TRANSP + " - " + _cTransp
_nLin+=3
@ _nLin,000 		Psay "Motorista.....: " + SubStr(_cNome,1,30)
_nLin+=2
If Empty(_cRgOrg)
   @ _nLin,000		Psay "RG/Orgao Exp..: " + _cRg
Else
   @ _nLin,000		Psay "RG/Orgao Exp..: " + Alltrim(_cRg) + "/" + _cRgOrg  
EndIf
_nLin+=3
@ _nLin,000 		Psay "Veiculo.......: " + Alltrim(_cVeiculo)
@ _nLin,046			Psay "Cor: " + _cDesCor
_nLin+=2
If Empty(_cEstPla)
   @ _nLin,000		Psay "Placa/UF......: " + _cPlaca
Else   
   @ _nLin,000		Psay "Placa/UF......: " + _cPlaca + " / " + _cEstPla
EndIf 
_nLin+=2
@ _nLin,000 		Psay "Observações...: " + Alltrim(SF2->F2_MSOBDAN)  
_nLin+=8

@ _nLin,000			Psay Replicate("_",40)
_nLin++
@ _nLin,000			Psay Padc(Alltrim(_cNome),40)
_nLin+=8

@ _nLin,000			Psay Replicate("_",40)
_nLin++
@ _nLin,000			Psay Padc(UsrFullName(RetCodUsr()),40)
_nLin+=5
@_nLin,000          Psay "DAN Gerado em " + DTOC(Date()) + " as " + SF2->F2_MSDANHR + " pelo usuário " + SF2->F2_MSDANUS
_nLin++

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

If aReturn[5] > 1
   If MsgBox("*** ATENÇÃO, A impressão do D.A.N. está correta?,","AVISO","YESNO")
      RecLock("SF2",.F.)
      SF2->F2_MSDANDT  := Date()
      SF2->(MsUnLock())    
   EndIf   
EndIf 

DbSelectArea("SF2")
DbGoTo(_cRecnoF2)

Return             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Busca01   ³ Autor ³ Cecilia               ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function Busca01()

RET := .T.

If !Empty(_cMsMotor)
    dbSelectArea("DA4")
    dbSetorder(1)

    //If !dbSeek(xFilial("DA4")+_cMsMotor, .T.)
    If !dbSeek(xFilial("DA4")+_cMsMotor)
       MSGBOX("Motorista não Cadastrado", "ALERT")
       RET := .F.
    Else 
      cMotorista := Alltrim(DA4->DA4_NOME)       
      RET := .T. 
   Endif
Else
	RET := .F.
Endif  

RETURN(RET)               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Busca02   ³ Autor ³ Cecilia               ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function Busca02()

RET := .T.

If !Empty(_cVeiculo)
	dbSelectArea("DA3")
	dbSetorder(1)

	//If !dbSeek(xFilial("DA3")+_cVeiculo, .T.)
	If !dbSeek(xFilial("DA3")+_cVeiculo)
   	MSGBOX("Veiculo não Cadastrado", "ALERT")
	   RET := .F.
	Else
		If SX5->(DbSeek(xFilial("SX5")+"M6"+DA3->DA3_MARVEI))
	      cTipoVeic := Alltrim(SubStr(X5DESCRI(),1,15)) + " " + Alltrim(DA3->DA3_DESC)
		EndIf   
   	If !Empty(DA3->DA3_CORVEI)
			If SX5->(DbSeek(xFilial("SX5")+"M7"+DA3->DA3_CORVEI))
				cTipoVeic += "   Cor: " + Alltrim(X5DESCRI())
			EndIf   
		EndIf   
   	RET := .T. 
	Endif
Else
	RET := .F.
EndIf
   
Return(RET)                               
