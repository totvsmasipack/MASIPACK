#Include "Rwmake.ch"      
#Include "Topconn.ch"

/* 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±≥Funcao	 ≥ RFATR035≥ Autor ≥ Aparecida de F.Stevanato≥Data ≥ 28.04.08 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Emite identificaÁ„o Nota Fiscal/Cliente/Fornecedor     	  ≥±± 
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±± 
*/

User Function RFATR035()

PRIVATE titulo    := "" 
PRIVATE cString   := ""
PRIVATE nLastKey  := 0
PRIVATE Li        := 99
Private oPrn      := TMSPrinter():New()
Private lEnd      := .F.
Private aDados    := {}
Private aObs      := {} 
Private nInd      := 0
Private nOrdem    := 0
Private nTot      := 1
Private fRet      := .T.
Private cChave    := ""
Private cTransp   := "" 
Private aUsuario  := {}
Private cDeptoUsu := ""
Private _cUsuario := RetCodUsr()

aOpcao   := {"S-NF de Saida","E-NF de Entrada","Cliente","Fornecedor"}
aImp     := {"Video","Impressora"}
cOpcao   := Space(12)
cImp     := Space(10)
cFornec  := Space(6)
cCampo1  := Space(09)
cCampo11 := Space(03)
cCampo2  := Space(09)
cCampo22 := Space(03)
cCampo3  := Space(09)
cCampo33 := Space(03)
cObs1_1  := Space(50)
cObs1_2  := Space(50)
cObs1_3  := Space(50)
cObs2_1  := Space(50)
cObs2_2  := Space(50)
cObs2_3  := Space(50)
cObs3_1  := Space(50)
cObs3_2  := Space(50)
cObs3_3  := Space(50)

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario := PswRet()
   cDeptoUsu := _aUsuario[1][12]
EndIf
 
@ 089,235 To 550,850 Dialog _oDlg1 Title OemToAnsi("Emite IdentificaÁ„o - Cartas/Caixas")

@ 015,020 Say OemToAnsi("Opcao....................:")           Size 080,008
@ 015,135 Say OemToAnsi("Imprime:")                             Size 080,008
@ 015,205 Say OemToAnsi("Fornecedor da NFE..:") 	             Size 080,008  
                                                                                                                                 
@ 032,075 Say OemToAnsi("Nota Fiscal        Serie                    Nota Fiscal         Serie                   Nota Fiscal          Serie") Size 250,008
@ 040,020 Say OemToAnsi("IdentificaÁ„o para..:") 	             Size 080,008

@ 056,020 Say OemToAnsi("ObservaÁıes-1.....:")                  Size 080,008 
@ 103,020 Say OemToAnsi("ObservaÁıes-2.....:")                  Size 080,008
@ 150,020 Say OemToAnsi("ObservaÁıes-3.....:")                  Size 080,008          

@ 012,070 ComboBox cOpcao Items aOpcao                          Size 055,010  object oOpcao
@ 012,160 ComboBox cImp Items aImp                              Size 040,010  object oImp
@ 012,260 Get cFornec F3 "SA2"                                  Size 040,008

@ 038,070 Get cCampo1                                           Size 040,008
@ 038,110 Get cCampo11 Valid Campo1()                           Size 020,008

@ 038,150 Get cCampo2                                           Size 040,008
@ 038,190 Get cCampo22 Valid Campo2()                           Size 020,008

@ 038,230 Get cCampo3  Valid                                    Size 040,008
@ 038,270 Get cCampo33 Valid Campo3()                           Size 020,008

@ 056,070 Get cObs1_1                                           Size 230,008
@ 071,070 Get cObs1_2                                           Size 230,008
@ 086,070 Get cObs1_3                                           Size 230,008
@ 103,070 Get cObs2_1                                           Size 230,008
@ 118,070 Get cObs2_2                                           Size 230,008
@ 133,070 Get cObs2_3                                           Size 230,008
@ 150,070 Get cObs3_1                                           Size 230,008
@ 165,070 Get cObs3_2                                           Size 230,008
@ 180,070 Get cObs3_3                                           Size 230,008

@ 196,220 BmpButton Type 1 Action Processa( { || GeraRelat() } )
@ 196,255 BmpButton Type 2 Action _oDlg1:End()
Activate Dialog _oDlg1  Centered

Return

//********************************
	Static Function Campo1()
//********************************	
   Local fRet   := .F.
   cChave := cCampo1+cCampo11
   If cChave <> ""
      If VerCadastro()
         fRet := .T.
         nTot := 1
      EndIf
   EndIf
Return fRet

//********************************
	Static Function Campo2()
//********************************	
   fRet  := .T.
   cChave := cCampo2+cCampo22
   If cChave <> ""
      If SubStr(cOpcao,1,1) <> "E"
         If ! VerCadastro()
            fRet := .F.
         EndIf
      Else
         apmsgStop("Campo Invalido para Nota Fiscal de Entrada")
         fRet := .F. 
      EndIf   
   EndIf
   If fRet
      nTot := 2
   EndIf      
Return fRet

//********************************
	Static Function Campo3()
//********************************
   fRet   := .T.
   cChave := cCampo3+cCampo33
   If cChave <> ""
      If SubStr(cOpcao,1,1) <> "E"
         If ! VerCadastro()
            fRet := .F.
         EndIf
      Else
         apmsgStop("Campo Invalido para Nota Fiscal de Entrada")
         fRet := .F. 
      EndIf 
  EndIf
  If fRet
     nTot := 3
  EndIf   
Return fRet

//********************************
	Static Function VerCadastro() 
//********************************	
   fRet := .T.
   If SubStr(cOpcao,1,1) == "S"
      SF2->(DbSetOrder(1))
      If SF2->(DbSeek(xFilial("SF2")+cChave))
         cTransp := ""
         SA4->(DbSetOrder(1))
         If SA4->(DbSeek(xFilial("SA4")+SF2->F2_TRANSP))
            cTransp := SA4->A4_NOME
         EndIf
         If SF2->F2_TIPO $ "NIPC"
            SA1->(DbSetOrder(1))
            If SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
               AADD(aDados,{SA1->A1_NOME,SubStr(SA1->A1_END,1,45),SA1->A1_BAIRRO,Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST,SA1->A1_CEP,SA1->A1_PESSOA,SA1->A1_CGC,cChave,cTransp})
            Else
               apmsgStop("Cliente  n„o cadastrado")
               fRet := .F.
            EndIf
         Else          
            SA2->(DbSetOrder(1))
            If SA2->(DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
               AADD(aDados,{SA2->A2_NOME,SubStr(SA2->A2_END,1,45),SA2->A2_BAIRRO,Alltrim(SA2->A2_MUN)+" - "+SA2->A2_EST,SA2->A2_CEP,SA2->A2_PFISICA,SA2->A2_CGC,cChave,cTransp})
            Else
               apmsgStop("Fornecedor  n„o cadastrado")
               fRet := .F.
            EndIf   
         EndIf
      Else
         Alert("Atenc„o, Nota Fiscal n„o encontrada")
         fRet := .F.
      EndIf
   ElseIf SubStr(cOpcao,1,1) == "E"
      If !Empty(cFornec)
         cChave := cFornec+"00"+cChave
         nOrdem := 2
      Else
         nOrdem := 1
      EndIf      
      SF1->(DbSetOrder(nOrdem))
      If SF1->(DbSeek(xFilial("SF1")+cChave))
         cTransp := ""
         If SF1->F1_TIPO $ "NIPC"
            SA2->(DbSetOrder(1))
            If SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
               AADD(aDados,{SA2->A2_NOME,SubStr(SA2->A2_END,1,45),SA2->A2_BAIRRO,Alltrim(SA2->A2_MUN)+" - "+SA2->A2_EST,SA2->A2_CEP,SA2->A2_PFISICA,SA2->A2_CGC,cChave,cTransp})
            Else
               apmsgStop("Fornecedor  n„o cadastrado")
               fRet := .F.
            EndIf   
         Else
            SA1->(DbSetOrder(1))
            If SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
               AADD(aDados,{SA1->A1_NOME,SubStr(SA1->A1_END,1,45),SA1->A1_BAIRRO,Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST,SA1->A1_CEP,SA1->A1_PESSOA,SA1->A1_CGC,cChave,cTransp})
            Else
               apmsgStop("Cliente  n„o cadastrado")
               fRet := .F.
            EndIf
         EndIf
      Else
         Alert("Atenc„o, Nota Fiscal n„o encontrada para Este Fornecedor")
         fRet := .F.
      EndIf         
   ElseIf SubStr(cOpcao,1,1) == "C" 
      SA1->(DbSetOrder(1))
      If SA1->(DbSeek(xFilial("SA1")+cChave))
         AADD(aDados,{SA1->A1_NOME,SubStr(SA1->A1_END,1,45),SA1->A1_BAIRRO,Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST,SA1->A1_CEP,SA1->A1_PESSOA,SA1->A1_CGC,,})
      Else
         apmsgStop("Cliente  n„o cadastrado")
         fRet := .F.
      EndIf
   ElseIf SubStr(cOpcao,1,1) == "F"
      SA2->(DbSetOrder(1))
      If SA2->(DbSeek(xFilial("SA2")+cChave))
         AADD(aDados,{SA2->A2_NOME,SubStr(SA2->A2_END,1,45),SA2->A2_BAIRRO,Alltrim(SA2->A2_MUN)+" - "+ SA2->A2_EST,SA2->A2_CEP,SA2->A2_PFISICA,SA2->A2_CGC,,})
      Else
         apmsgStop("Fornecedor  n„o cadastrado")
         fRet := .F.
      EndIf
   EndIf
Return fRet

//********************************
	Static Function GeraRelat()
//********************************	

Local nInd

AADD(aObs,{cObs1_1,cObs1_2,cObs1_3})
If Alltrim(cCampo2) == ""
   AADD(aDados,{,,,,,,,,,})
   AADD(aObs,{,,})
Else   
   AADD(aObs,{cObs2_1,cObs2_2,cObs2_3})
EndIf
If Alltrim(cCampo3) == ""
   AADD(aDados,{,,,,,,,,,})
   AADD(aObs,{,,})
Else   
   AADD(aObs,{cObs3_1,cObs3_2,cObs3_3})
EndIf

oFont   := TFont():New("Arial Black",,17,,.F.,,,,,.F.)   
oFont1  := TFont():New("Arial Black",,17,,.F.,,,,,.F.) 
oFont2  := TFont():New("Courier New",,16,,.T.,,,,,.F.)
oFont3  := TFont():New("Courier New",,9,,.F.,,,,,.F.)
oFont4  := TFont():New("Arial Black",,13,,.F.,,,,,.F.)  
oPrn 	:= TMSPrinter():New("RFATR028")

oPrn:Say(0, 0, " ",oFont1,10)     // startando a impressora 
oPrn:SetPortrait()

If Alltrim(cDeptoUsu) == "Almoxarifado" .And. SubStr(cOpcao,1,1) == "F"
   cOpcao := "E"
EndIf   
If SubStr(cOpcao,1,1) <> "E"
   nLin := 300
Else
   nLin := 1500
EndIf
For nInd := 1 to nTot
    If Alltrim(aDados[nInd][1]) <> ""
       If SubStr(cOpcao,1,1) <> "E"
          If Alltrim(aDados[nInd][8]) <> ""
             oPrn:Say(nLin,320,"Nota Fiscal: ",oFont1)
             oPrn:Say(nLin,780,aDados[nInd][8],oFont1)
             nLin +=90 
          EndIf   
          oPrn:Say(nLin,320,aDados[nInd][1],oFont1)
          nLin +=60  
          oPrn:Say(nLin,320,aDados[nInd][2],oFont1)
          nLin +=60 
          oPrn:Say(nLin,320,aDados[nInd][3],oFont1)
          nLin +=60 
          oPrn:Say(nLin,320,aDados[nInd][4],oFont1)
          nLin +=60 
          oPrn:Say(nLin,320,Substr(aDados[nInd][5],1,5) + "-" + Substr(aDados[nInd][5],6,3) ,oFont1)
          If SubStr(cOpcao,1,1) <> "E"
             nLin +=60 
             If Alltrim(aDados[nInd][6]) == "PF" .Or. Alltrim(aDados[nInd][6]) == "F"
                oPrn:Say(nLin,320,"CPF.: "+SubStr(aDados[nInd][7],1,Len(aDados[nInd][7])-2) + "-" + SubStr(aDados[nInd][7],Len(aDados[nInd][7])-2,2),oFont1)
             Else   
                oPrn:Say(nLin,320,"CNPJ: "+SubStr(aDados[nInd][7],1,8) + "/" + SubStr(aDados[nInd][7],9,4) + "-" + SubStr(aDados[nInd][7],13,2),oFont1)
             EndIf   
          EndIf
          If Alltrim(aDados[nInd][9]) <> ""
             nLin +=60 
             oPrn:Say(nLin,320,"Transp.: ",oFont1)
             oPrn:Say(nLin,650,aDados[nInd][9],oFont1)
          EndIf  
          nLin +=150
          If Alltrim(aObs[nInd][1]) <> ""   
             oPrn:Say(nLin,320,"Obs: "+aObs[nInd][1],oFont2)
          EndIf   
          nLin +=60
          If Alltrim(aObs[nInd][2]) <> ""  
             oPrn:Say(nLin,490,aObs[nInd][2],oFont2)
          EndIf   
          nLin +=60
          If Alltrim(aObs[nInd][3]) <> ""  
             oPrn:Say(nLin,490,aObs[nInd][3],oFont2)
          EndIf
          nLin +=400   
       Else
          oPrn:Say(nLin,320,aDados[nInd][1],oFont4)
          nLin +=60  
          oPrn:Say(nLin,320,aDados[nInd][2],oFont4)
          nLin +=60 
          oPrn:Say(nLin,320,aDados[nInd][3],oFont4)
          nLin +=60 
          oPrn:Say(nLin,320,aDados[nInd][4],oFont4)
          nLin +=60 
          oPrn:Say(nLin,320,Substr(aDados[nInd][5],1,5) + "-" + Substr(aDados[nInd][5],6,3) ,oFont4)
          nLin +=50
       EndIf    
    EndIf
Next

If SubStr(cOpcao,1,1) == "E"
   oPrn:Say(nLin,030,Replicate("_",80),oFont3)
   nLin +=40
   oPrn:Say(nLin,030,"De: " + Alltrim(UsrFullName(RetCodUsr()))+ " - "+ cDeptoUsu,oFont3)
   nLin +=40
   oPrn:Say(nLin,030,"11 3246-3666,4178-8099",oFont3)
   nLin +=40
   oPrn:Say(nLin,030,UsrRetMail(RetCodUsr()),oFont3)
   nLin +=40
   oPrn:Say(nLin,030,"www.masipack.com.br",oFont3)
EndIf   

oPrn:EndPage()      // Finaliza a pagina

//oPrn:SaveAllAsJpeg('\RELATO\RFATR035',640,900)
//ShellExecute( "open", 'RFATR035.jpg',"","\RELATO\", 5 )   

If SubStr(cImp,1,1) == "V"
   oPrn:Preview()   // Video
Else 
   oPrn:Setup()  
   oPrn:Print()
EndIF
aDados   := {}
aObs     := {}
cCampo1  := Space(09)
cCampo11 := Space(03)
cCampo2  := Space(09)
cCampo22 := Space(03)
cCampo3  := Space(09)
cCampo33 := Space(03)
cFornec  := Space(6)
cObs1_1  := Space(50)
cObs1_2  := Space(50)
cObs1_3  := Space(50)
cObs2_1  := Space(50)
cObs2_2  := Space(50)
cObs2_3  := Space(50)
cObs3_1  := Space(50)
cObs3_2  := Space(50)
cObs3_3  := Space(50)
nTot     := 1
   
oPrn:End() 

MS_FLUSH() 

Return

