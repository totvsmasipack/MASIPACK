#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FILEIO.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³RFATG037 ºAutor ³ Eduardo Mantoan        º Data ³ 30/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±     
±±ºDesc.     ³ RFATG037 - Consulta personalizada SC5->C5_MSPEDIN           °±±
±±º              			 Muda de empresa e abre a tabela SC5    			  °±±
±±º    																			  			  °±±
±±º          																				  °±±
±±º          ³ SC5                                                    	  °±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    



User Function RFATG037()  
Public _cCodigo     := Space(15)
Public _cFavor 
Public _cFavorAnt     := ""//M->C5_CLIENTE
Public _cNome			
Public _cPED1        
Public _cPED2        
Public _cPED3        
Private aEmpresa 		 := FWEmpLoad(.F.)
Private aArea 		    := GetArea() 
Private aAreaSC5 		 := SC5->( GetArea() ) 
Private aAreaSA1 		 := SA1->( GetArea() )
Private cSvFilAnt 	 := cFilAnt 				//Salva a Filial Anterior 
Private cSvEmpAnt 	 := cEmpAnt 				//Salva a Empresa Anterior 
Private cSvArqTab 	 := cArqTab 				//Salva os arquivos de //trabalho 
Private cModo 								  		   //Modo de acesso do arquivo aberto //"E" ou "C" 
Private cNewAls 		 := GetNextAlias() 		//Obtem novo Alias 
Private bRet 			 := .F.  
Private cNUM          := M->C5_NUM
Private cCampo 		 := READVAR()
Private cC1           := "MSPEDIN"
Private cC2           := "MSPEDI2"
Private cC3           := "MSPEDI3"
Private bRetorno      

If Inclui .Or. Altera

	If cC1 $ cCampo
	
		bRetorno :=	RFAT37()
		If !bRetorno 
			Return .F.
		EndIF
			
		//If DbSeek(xFilial("SC5")+cNUM)
		M->C5_MSPVOR := _cFavor+"-"+_cNome
		_cFavorAnt := _cFavor  
		
	ElseIf cC2 $ cCampo 
		If _cPED1 == NIL
			MSGALERT("Campo PV Cliente 1 não está preenchido")
			Return .F.	
		EndIF
	bRetorno :=	RFAT37()
	If !bRetorno 
			Return .F.
		EndIF	
	ElseIf cC3 $ cCampo
  	  	If	_cPED2 == NIL
  	  		MSGALERT("Campo PV Cliente 2 não está preenchido") 
  	  		Return .F.
  	  	EndIF
		bRetorno :=	RFAT37()
		If !bRetorno 
			Return .F.
		EndIF 
	EndIf
	  
  
//ElseIf Altera


 
//SC5->C5_MSPVOR := _cFavor+"-"+_cNome
EndIF




Return (.T.)


Static Function RFAT37() 


//---------------------------------------------------------------------------------------------
Private cTexto 	:= Alltrim(&(ReadVar()))
Private cPerg		:= "XRFATG037"
//Private aTexto 	:= StrTokArr(AllTrim(cTexto)," ")
//Private cMessage 	:= ""
If cTexto == ""
	cTexto := "0"
EndIF

IF ! Pergunte(cPerg,.T.)
 	Return
ENDIF

/*If MV_PAR01 <> "01" .AND. MV_PAR01 <> "10"

	MSGALERT("Empresa não disponível - Disponíveis - 01-Masipack/10-Fabrima") 
	
	Return
EndIf */ 


 
 
IF EmpOpenFile("SC5","SC5",1,.T.,MV_PAR01,@cModo) 


   
	@ 000,000 To 200,200 Dialog _oDlg1 Title OemToAnsi("Pedidos de Venda")
	@ 010,010 To 090,090 Title OemToAnsi("Pedido")
	@ 025,034 Say OemToAnsi("Pedido") 		Size 60,8
	@ 032,030 Get _cCodigo F3 "SC5" 			Size 37,10

	@ 070,020 BmpButton Type 1 Action Close(_oDlg1)
	@ 070,050 BmpButton Type 2 Action Close(_oDlg1)
	Activate Dialog _oDlg1
	If DbSeek(xFilial("SC5")+_cCodigo)
	
		_cFavor :=	SC5->C5_CLIENTE
	  If	_cFavorAnt == _cFavor  
	  
	  Else
	  		MSGALERT("Favorecido é diferente - Verifique se o campo Cliente de Entraga está igual ao campo Cliente do pedido selecionado")
	  		Return .F.		
	  EndIF 
   EndIF
	If ! MsgBox("**** A T E N Ç Ã O **** Deseja realmente gravar informações?(Serão gravadas em ambas as empresas)","CONFIRMAR","YESNO")
   	Return
	EndIf
Else
	Return .F.	
EndIF


IF EmpOpenFile("SA1","SA1",1,.T.,MV_PAR01,@cModo) 

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	If DbSeek(xFilial("SA1")+_cFavor)
		_cNome := SA1->A1_NREDUZ
	EndIF
Else
	Return .F.	
EndIF  



SA1->( dbCloseArea() )

	      
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
If DbSeek(xFilial("SC5")+_cCodigo)

	RecLock("SC5",.f.)
					
				
	If cC1 $ cCampo
	
		
		SC5->C5_MSPEDIN := cNUM
		
	
		
	ElseIf cC2 $ cCampo 
		//_cFavor
		SC5->C5_MSPEDI2 := cNUM
		
	ElseIf cC3 $ cCampo 
	
  	 	SC5->C5_MSPEDI3 := cNUM
  	 	
	EndIf
	SC5->C5_MSPVOR := _cFavor+"-"+_cNome
	SC5->(MsUnLock())
EndIF


SC5->( dbCloseArea() ) //Restaura os Dados de Entrada ( Ambiente )

cFilAnt := cSvFilAnt 
cEmpAnt := cSvEmpAnt 
cArqTab := cSvArqTab 
ChkFile( "SC5" ) //Reabre o SC5 da empresa atual 

RestArea( aAreaSA1 ) //Restaura os ponteiros das Tabelas
RestArea( aAreaSC5 ) //Restaura os ponteiros das Tabelas  
RestArea( aArea )


Return .T.

User Function RFAT037()

Return (_cCodigo)