#INCLUDE "Topconn.ch" 
#Include "Rwmake.ch"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F040COM   ºAutor  ³Cecilia             º Data ³  17/09/08       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Trata comissao de titulos RA(Adiantamento de Clientes).So sera  º±±
±±º          ³executado qdo o tipo de titulo for Adiantamento a Receber       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function F040COM()

//Variaveis utilizados no programa
Local aArea   := GetArea()
Local nDia    := 0
Local nMes    := 0
Local nAno    := 0
Local dVencto := Ctod("")
Local nComis  := 0


If Inclui  
  
  If !Empty(SE1->E1_VEND1)  
 
   dbSelectArea("SA3")
   dbSetOrder(1)
   SA3->(MsSeek(xFilial("SA3")+SE1->E1_VEND1))
   
   dbSelectArea("SE3")
   Reclock("SE3",.T.)  
   
   SE3->E3_BASE    := SE1->E1_VALOR
   SE3->E3_COMIS   := Round(SE1->E1_VALOR*SA3->A3_COMIS,2) /100
   SE3->E3_PORC    := Abs(SE3->E3_COMIS/SE3->E3_BASE*100)
   SE3->E3_FILIAL  := SE1->E1_FILIAL
   SE3->E3_VEND    := SE1->E1_VEND1
   SE3->E3_SERIE   := SE1->E1_SERIE
   SE3->E3_NUM     := SE1->E1_NUM
   SE3->E3_CODCLI  := SE1->E1_CLIENTE
   SE3->E3_LOJA    := SE1->E1_LOJA
   SE3->E3_EMISSAO := SE1->E1_EMISSAO
   SE3->E3_PREFIXO := SE1->E1_PREFIXO
   SE3->E3_PARCELA := SE1->E1_PARCELA
   SE3->E3_TIPO    := SE1->E1_TIPO
   SE3->E3_BAIEMI  := "B"
   SE3->E3_ORIGEM  := "F"
   SE3->E3_PEDIDO  := SE1->E1_PEDIDO
   SE3->E3_SEQ     := " "   
   If Empty( SA3->A3_DIA )
      dVencto := SE1->E1_EMISSAO
   Else
      dVencto := Ctod( strzero(SA3->A3_DIA,2)+"/"+;
	  strzero(month(SE1->E1_EMISSAO),2)+"/"+;
	  strzero( year(SE1->E1_EMISSAO),4),"ddmmyy")
	  nDia := SA3->A3_DIA
	  while empty( dVencto)
		nDia -= 1
		dVencto := CtoD(strzero(nDia,2)+"/"+;
		strzero(month(SE1->E1_EMISSAO),2)+"/"+;
	 	strzero( year(SE1->E1_EMISSAO),4),"ddmmyy")
	  endDo
   EndIf
   if SA3->A3_DDD == "F" .or. dVencto < SE1->E1_EMISSAO		//Fora o mes
      nDia := SA3->A3_DIA
	  nMes := month(dVencto) + 1
	  nAno := year (dVencto)
	  If nMes == 13
	   	 nMes := 01
	 	 nAno := nAno + 1
	  Endif
	  nDia	  := strzero(nDia,2)
	  nMes	  := strzero(nMes,2)
	  nAno	  := substr(lTrim(str(nAno)),3,2)
	  dVencto := CtoD(nDia+"/"+nMes+"/"+nAno,"ddmmyy")
   Else
	  nDia	  := strzero(day(dVencto),2)
	  nMes	  := strzero(month(dVencto),2)
	  nAno	  := substr(lTrim(str(Year(dVencto))),3,2)
   Endif
   While empty( dVencto)
   	 nDia := if(Valtype(nDia)=="C",Val(nDia),nDia)
	 nDia -= 1
	 dVencto := CtoD(strzero(nDia,2)+"/"+nMes+"/"+nAno,"ddmmyy")
	 if !empty( dVencto )
	   if dVencto < SE1->E1_EMISSAO
	      dVencto += 2
	   EndIf
	 EndIf
   Enddo
   SE3->E3_VENCTO  := dVencto 
   MsUnlock()
  Endif  
EndIf
 