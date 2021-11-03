#INCLUDE "Protheus.ch"   
#INCLUDE "rwmake.ch"   
#include "Topconn.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINA005  ºAutor  ³Cecilia             º Data ³07/07/08     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³Informar o valor do redendimento da aplicacao e atualizar   ³±±
±±³          ³o arquivo SEH                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Masipack                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFINA005()  

Local   cSeqSeh   := Space(06)  
Private _aArea
Private nRevisao  := 0  
Private nRevisao1 := 0
Private cNum      := " "
Private nVlRend   := 0.00    
Private nSaldo    := 0.00  
Private nValor    := 0.00
Private cStatus   := " "
Private _cUsuario := RetCodUsr()
Private _cNomusu  := UsrRetName(_cUsuario) 

_aArea    := GetArea()  

cNumero  := SEH->EH_NUMERO
cRevisao := SEH->EH_REVISAO
cAplemp  := SEH->EH_APLEMP  
cTipo    := SEH->EH_TIPO 
cBanco   := SEH->EH_BANCO
cAgencia := SEH->EH_AGENCIA 
cConta   := SEH->EH_CONTA  
dData    := SEH->EH_DATA  
nValor   := SEH->EH_VALOR    
cMoeda   := SEH->EH_MOEDA   
nNbanco  := SEH->EH_NBANCO 
nNaturez := SEH->EH_NATUREZ 
nQuotas  := SEH->EH_QUOTAS  
cContrat := SEH->EH_CONTRAT
cBcocont := SEH->EH_BCOCONT
cAgecont := SEH->EH_AGECONT 
cCtacont := SEH->EH_CTACONT 
nSaldo   := SEH->EH_SALDO 
nGarante := SEH->EH_GARANTE 
nVlcruz  := SEH->EH_VLCRUZ  
nVlrcota := SEH->EH_VLRCOTA 
nSldcota := SEH->EH_SLDCOTA 

DEFINE MSDIALOG oDlgDig TITLE "Atualiza os Saldos das Aplicações" FROM 010,010 TO 305,680 PIXEL  
DEFINE Font oFont Name "Arial" SIZE 008,017 Bold

@ 015,003 SAY "Operação: "       SIZE 030,010 PIXEL COLOR CLR_HBLUE
@ 015,065 SAY "Agencia: "        SIZE 050,010 PIXEL COLOR CLR_HBLUE
@ 015,135 SAY "Banco: "          SIZE 060,010 PIXEL COLOR CLR_HBLUE  
@ 015,205 SAY "Conta: "          SIZE 060,010 PIXEL COLOR CLR_HBLUE	

@ 038,003 SAY "Dt.Operação: "   SIZE 030,010 PIXEL COLOR CLR_HBLUE
@ 038,075 SAY "Nr.Contrato: "   SIZE 040,010 PIXEL COLOR CLR_HBLUE
@ 038,145 SAY "Bco.Contrato: "   SIZE 050,010 PIXEL COLOR CLR_HBLUE
@ 038,220 SAY "Ag.Contrato: "   SIZE 060,010 PIXEL COLOR CLR_HBLUE 

@ 061,003 SAY "Valor Operação: " SIZE 060,010 PIXEL COLOR CLR_HBLUE	
@ 061,110 SAY "Saldo: "          SIZE 060,010 PIXEL COLOR CLR_HBLUE	 

@ 014,035 MSGET SEH->EH_TIPO     SIZE 030,010 WHEN .F. PIXEL OF oDlgDig  
@ 014,095 MSGET SEH->EH_AGENCIA  SIZE 030,010 WHEN .F. PIXEL OF oDlgDig  
@ 014,155 MSGET SEH->EH_BANCO    SIZE 030,010 WHEN .F. PIXEL OF oDlgDig 
@ 014,225 MSGET SEH->EH_CONTA    SIZE 050,010 WHEN .F. PIXEL OF oDlgDig	

@ 037,040 MSGET Dtoc(SEH->EH_DATA)	SIZE 030,010 WHEN .F. PIXEL OF oDlgDig
@ 037,110 MSGET SEH->EH_CONTRAT    	SIZE 030,010 WHEN .F. PIXEL OF oDlgDig	 
@ 037,185 MSGET SEH->EH_BCOCONT    	SIZE 030,010 WHEN .F. PIXEL OF oDlgDig	
@ 037,255 MSGET SEH->EH_AGECONT     SIZE 030,010 WHEN .F. PIXEL OF oDlgDig	

@ 060,045 MSGET Transform(nValor,"@E 9,999,999.99") SIZE 050,008 WHEN .F. PIXEL OF oDlgDig	
@ 060,135 MSGET Transform(nSaldo,"@E 9,999,999.99") SIZE 050,008 WHEN .F. PIXEL OF oDlgDig	

@ 080,003 SAY "Rendimentos: "                      SIZE 060,010 PIXEL COLOR CLR_HBLUE	

@ 080,055 MSGET nVlRend   PICTURE "@E 999,999,999.99" SIZE 050,008 PIXEL OF oDlgDig	  

                                                                                                               
@ 110,096 BmpButton Type 1 Action _fGrava()
@ 110,130 BmpButton Type 2 Action close(oDlgDig)
Activate Dialog oDlgDig CENTERED

RestArea(_aArea) 
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³_fGrava   ³ Autor ³ Cecilia               ³ Data ³ 18.07.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava campo Rendimentos                                     |±±                                 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function _fGrava() 

If nVlRend <> 0 
  
//   DbSelectArea("SEH")
//   DbSetOrder(1) 
 //  If DbSeek(xFilial("SEH")+cNumero+cRevisao)
      RecLock("SEH",.F.)
      SEH->EH_STATUS   := "B" 
      SEH->EH_SALDO    :=  0  
      SEH->EH_DATARES  := DDATABASE
      SEH->EH_MSREND   := 0
      MsUnLock()
//   Endif     

   cSeqSeh := GetSx8Num("SEH", "EH_NUMERO")
   While !MayIUseCode("SEH"+xFilial("SEH")+cSeqSeh)   //verifica se esta na memoria, sendo usado
    //      busca o proximo numero disponivel 
         cSeqSeh := Soma1(cSeqSeh)
   Enddo
   ConfirmSX8()   

  DbSelectArea("SEH")
  DbSetOrder(1)

  If ! DbSeek(xFilial("SEH")+cSeqSeh+"01")
      RecLock("SEH",.t.)                                                             
      SEH->EH_FILIAL   := xFilial("SEH")
      SEH->EH_REVISAO  := "01"
      SEH->EH_NUMERO   := cSeqSeh     
      SEH->EH_APLEMP   := cAplemp 
      SEH->EH_TIPO     := cTipo  
      SEH->EH_BANCO    := cBanco  
      SEH->EH_AGENCIA  := cAgencia 
      SEH->EH_CONTA    := cConta  
      SEH->EH_DATA     := dData
      SEH->EH_VALOR    := nValor   
      SEH->EH_MOEDA    := cMoeda  
      SEH->EH_NBANCO   := nNbanco
      SEH->EH_NATUREZ  := nNaturez
      SEH->EH_QUOTAS   := nQuotas
      SEH->EH_CONTRAT  := cContrat
      SEH->EH_BCOCONT  := cBcocont
      SEH->EH_AGECONT  := cAgecont
      SEH->EH_CTACONT  := cCtacont
      SEH->EH_SALDO    := nSaldo + nVlRend
      SEH->EH_GARANTE  := nGarante
      SEH->EH_VLCRUZ   := nSaldo + nVlRend
      SEH->EH_VLRCOTA  := nVlrcota
      SEH->EH_SLDCOTA  := nSaldo + nVlRend
      SEH->EH_DTULTAT  := DDATABASE
      SEH->EH_STATUS   := "A"   
      SEH->EH_MSREND   := nVlRend
      SEH->EH_MSUSER   := _cUsuario
      SEH->EH_MSNOUSU  := _cNomusu
      MsUnLock()  
 
 
      Reclock("SE5",.T.)
      SE5-> E5_FILIAL  := cFilial  
      SE5-> E5_DATA    := dDataBase
      SE5-> E5_BANCO   := SEH->EH_BANCO
      SE5-> E5_DATA    := SEH->EH_DATA
      SE5-> E5_CONTA   := SEH->EH_CONTA
      SE5-> E5_AGENCIA := SEH->EH_AGENCIA
      SE5 ->E5_VALOR   := nVlRend
      SE5-> E5_VLMOED2 := nVlRend
      SE5-> E5_RECPAG  := Iif(SEH->EH_APLEMP=="EMP","R","P")
      SE5-> E5_TIPODOC := "JR"
      SE5-> E5_HISTOR  := "RENDIMENTOS DAS APLICACOES"
      SE5-> E5_DTDIGIT := dDataBase
      SE5-> E5_DTDISPO := dDataBase
      SE5-> E5_LA      := " "
      SE5-> E5_DOCUMEN := cSeqSeh+"01"
      SE5->E5_NATUREZ := "REND.APLIC"
      MsUnLock() 
  Endif
Else
     MSGBOX("O Valor do Rendimento está Zerado, Não será Atualizado o Saldo ", "ALERT")
     Return   
Endif
     
Close(oDlgDig)
Return
