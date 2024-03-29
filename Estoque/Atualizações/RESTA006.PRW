#Include "Rwmake.ch"
#Include "Topconn.ch"

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  砇ESTA006  篈utor  砈olange Vez�            � Data  30/05/07 罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     矴era arquivo de produtos para ser exportado p/ o VS         罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�*/

User Function RESTA006() 


Private cLote
Private cPasta

PRIVATE cPerg	  := "REST06"
//北北北北北北北北北北北北北北北北北北北北北北北北北�
//� Variaveis utilizadas para parametros   	        �
//� mv_par01			// De Local                 �
//� mv_par02			// Ate Local                �
//� mv_par03			// Imprime Desenhos (S/N)?  �      
//北北北北北北北北北北北北北北北北北北北北北北北北北�

mv_par02    := "1999999"   

If !(Pergunte(cPerg,.T.))
   Return
EndIf    
/*If Val(mv_par01) < 1001003 
   Alert ("Local Incorreto")
   Return
EndIf */
If Empty(mv_par01) .or. Empty(mv_par02) .or. Empty(mv_par03) 
   Alert ("Favor Preencher todas as perguntas")
   Return
EndIf
If mv_par01 > mv_par02 
   Alert ("Local Inicial maior do que Local Final")
   Return
EndIf
MsgRun("Aguarde...",, { || GeraArquivo() })
Return

//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//北矲uncao	 � RESTA006� Autor � Solange Ap.Vez�  矰ata � 30.05.07 潮�
//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
//北矰escricao � Fun玢o para Gerar arquivo de Produtos p/o VS       北 
//北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北

Static Function GeraArquivo()

cLinArq1	:= ""
cLinArq2	:= ""
cLote 		:= Substr(DTOS(Date()),7,2) + Substr(DTOS(Date()),5,2) + Substr(TIME(),1,2) + Substr(TIME(),4,2)
cArq1           := "I:\Produto.Csv"                                                  //"F:\KLG\Produto.Csv"
cArq2           := "I:\"+cLote+".Csv"                                                //"F:\KLG\"+cLote+".Csv"

If (cArq1       := FCreate("I:\Produto.Csv")) == -1                  //FCreate("F:\KLG\Produto.Csv")) == -1
	Alert("Arquivo n鉶 pode ser criado")
	Break
Else
	dbSelectArea("SB1")
	DbOrderNickName('MASSB1LOC') 
//	dbSetOrder(9)                         
	DbSeek(xFilial("SB1")+mv_par01)  
	Do While Alltrim(sb1->b1_local) <= Alltrim(mv_par02) .AND. !Eof()
		If mv_par03 == 1
		   	cPasta := Substr(sb1->b1_cod,1,2)
		   	If Substr(cNumEmp,1,2) == "01" 
		       If cPasta == "CL"
	              cPasta := Substr(sb1->b1_cod,3,2)
	           EndIf   
			Endif        

			//VICTOR DESSUNTE - 28/02/2017
			//INICIO - TICKET:2016122137000411
			/*
			cArqDes1 := "H:\PLOTTER\"+cPasta+"\"+Alltrim(sb1->b1_cod)+Alltrim(sb1->b1_revatu)+".PLT"
			cArqDes2 := "H:\PLOTTER\"+cPasta+"\"+Alltrim(sb1->b1_cod)+Alltrim(sb1->b1_revatu)+".PRN"
			cArqDes3 := "H:\PLOTTER\"+cPasta+"\"+Alltrim(sb1->b1_cod)+Alltrim(sb1->b1_revatu)+".PRI"
			WaitRun("F:\KLG\P_PLOT.EXE "+cArqDes1)
			WaitRun("F:\KLG\P_PLOT.EXE "+cArqDes2)
			WaitRun("F:\KLG\P_PLOT.EXE "+cArqDes3)
			*/
			//FIM - TICKET:2016122137000411
		Endif
		cLinArq1 := (clote+";1;"+Alltrim(sb1->b1_cod)+";"+Alltrim(sb1->b1_desc)+";"+Alltrim(sb1->b1_cod)+";1;15;1;999999;0;")
		FWrite(cArq1,cLinArq1+chr(13)+chr(10)) 
		Qout("")	
    	Dbskip()
	Enddo         
Endif

If (cArq2       := FCreate("I:\"+cLote+".Csv")) == -1                //FCreate("F:\KLG\"+cLote+".Csv")) == -1
	Alert("Arquivo n鉶 pode ser criado")
	Break
Else
	dbSelectArea("SB1")   
	DbOrderNickName('MASSB1LOC') 
//	dbSetOrder(9)                         
	DbSeek(xFilial("SB1")+mv_par01)  
	Do While Alltrim(sb1->b1_local) <= Alltrim(mv_par02) .AND. !Eof()
		cLinArq2 := (clote+";1;1;"+Substr(sb1->b1_local,1,1)+";"+Substr(sb1->b1_local,2,3)+";"+Substr(sb1->b1_local,5,3)+";"+Alltrim(sb1->b1_cod)+";100000;"+"9;CARGA INICIAL;1;999999")
		FWrite(cArq2,cLinArq2+chr(13)+chr(10))
		Qout("")	
    	Dbskip()
	Enddo         
Endif

FClose(cArq1)
FClose(cArq2)

Alert("Lote Gerado: "+cLote)

Return                      

