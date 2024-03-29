#Include "Rwmake.ch"
#Include "Topconn.ch"
#Define SW_SHOWNORMAL        // Normal
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTR023  �Autor  �Lizandra	Marques     � Data �  11/11/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �IMPRESSAO DE DESENHOS                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RESTR023()

SetPrvt("CCADASTRO,ACAMPOS,AROTINA,DDTENT,")

cCadastro := "Impress�o de desenhos"
aRotina   := { {"Pesquisa" , "AxPesqui"				 , 0, 1 },;
               {"Visualiza", 'ExecBlock("VDesenho")', 0, 2 },;
               {"Imprime"  , 'ExecBlock("ImpDese")' , 0, 3 } } 

mBrowse(8,03,20,75,"SB1",,,,)
return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTR023  �Autor  �Eduardo Mantoan     � Data �  06/10/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �IMPRESSAO DE DESENHOS                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VDesenho()
 

_cEXE1  := "cmd /c start C:\\Microsiga\\dwg.lnk"
_cEXE2  := "cmd /c start C:\\Microsiga\\dft.lnk"
_cEXE3  := "cmd /c start C:\\Microsiga\\dxf.lnk"
_cEXE4  := "cmd /c start C:\\Microsiga\\pdf.lnk" 
_cEXE5  :="cmd /c net use T: /delete"
_cEXE6  :="cmd /c NET USE T: \\masipack-srv-2\Projetos\Desenhos"

//WaitRun(_cEXE5,SW_SHOWNORMAL)
//WaitRun(_cEXE6,SW_SHOWNORMAL)

_cPath := ""
cStartPath 	:= "\\masipack-srv-2\Projetos\Desenhos\"  
cProduto := Alltrim(SB1->B1_COD)
cREV := Alltrim(SB1->B1_REVATU)		
cCodPro1 :=	SUBSTR(cProduto,1,2)
cCodPro2 :=	SUBSTR(cProduto,3,2)
cCodPro3 :=	SUBSTR(cProduto,5,2) 
_cPath  += cStartPath
If cCodPro1 == "CL"
	_cPath += cCodPro2 
	_cPath += "\"	
	_cPath += cCodPro2+cCodPro3
	_cPath += "\"
Else
	_cPath += cCodPro1
	_cPath += "\"
	_cPath += cCodPro1+cCodPro2
	_cPath += "\"
EndIf 
		
cArqdwg := _cEXE1 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".dwg"
cArqdft := _cEXE2 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".dft"
cArqdxf := _cEXE3 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".dxf"
cArqpdf := _cEXE4 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".pdf" 

Statusdwg := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".dwg")
Statusdft := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".dft")		 
Statusdxf := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".dxf")
Statuspdf := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+cREV+".pdf")

If 	 Statusdwg = 193 .AND. Statusdwg <> 0      
	WaitRun(cArqdwg,SW_SHOWNORMAL) 
ElseIf Statusdft = 193 .AND. Statusdft <> 0
	WaitRun(cArqdft,SW_SHOWNORMAL)
ElseIf Statusdxf = 193 .AND. Statusdxf <> 0
	WaitRun(cArqdxf,SW_SHOWNORMAL)
ElseIf Statuspdf = 193 .AND. Statuspdf <> 0   
	WaitRun(cArqpdf,SW_SHOWNORMAL)
Else
	If cREV == ""
		ALERT("N�o foi poss�vel abrir o desenho - Desenho n�o encontrado")
	Else
		cArqdwg := _cEXE1 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+".dwg"
		cArqdft := _cEXE2 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+".dft"
		cArqdxf := _cEXE3 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+".dxf"
		cArqpdf := _cEXE4 +" "+alltrim(_cPath)+ALLTRIM(cProduto)+".pdf" 

		Statusdwg := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+".dwg")
		Statusdft := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+".dft")		 
		Statusdxf := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+".dxf")
		Statuspdf := WaitRun(alltrim(_cPath)+ALLTRIM(cProduto)+".pdf")
		If 	 Statusdwg = 193 .AND. Statusdwg <> 0      
   		WaitRun(cArqdwg,SW_SHOWNORMAL) 
		ElseIf Statusdft = 193 .AND. Statusdft <> 0
			WaitRun(cArqdft,SW_SHOWNORMAL)
		ElseIf Statusdxf = 193 .AND. Statusdxf <> 0
			WaitRun(cArqdxf,SW_SHOWNORMAL)
		ElseIf Statuspdf = 193 .AND. Statuspdf <> 0   
			WaitRun(cArqpdf,SW_SHOWNORMAL)
		Else
			ALERT("N�o foi poss�vel abrir o desenho - Desenho n�o encontrado")
		Endif	
	EndIf
	
EndIf
		


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpDese  �Autor  �Lizandra	           � Data �  07/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza a quantidade dos produtos em processo             ���
���          � Empenho do corte                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ImpDese()    

aReturn	:= { "Zebrado", 1,"Gerencial", 1, 2, 1, "",1 }
cString	:= "SB1" 
wnrel		:= "RESTR023"
nLastKey := 0 

//wnrel:=SetPrint(cString,wnrel,,,,,,.F.)

If nLastKey == 27
	set filter to
	Return
Endif

//SetDefault(aReturn,cString)

If nLastKey == 27
	set filter to
	Return
Endif

RptStatus({|| ImpDES()}, )

Return                             


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDes � Autor � LIZANDRA                � Data � 11/11/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � AP - Masipack                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static FUNCTION ImpDes()

Local J

aDesenhos := {}
cDesenho	 := ""
aReturn[5]:= 2

cDesenho := Alltrim(SB1->B1_COD)+Alltrim(SB1->B1_REVATU)
_cPath := "H:\PLOTTER\"
If SubStr(cNumEmp,1,2) == "01"
   If Substr(cDesenho,1,2) == "CL"
      _cPath += Substr(cDesenho,3,2) + "\"
   ELSE
      _cPath += Substr(cDesenho,1,2) + "\"
   ENDIF
ElseIf SubStr(cNumEmp,1,2) == "10"   
   _cPath += Substr(cDesenho,1,3) + "\"
EndIf

If 'ALMOX' $ Upper(Alltrim(PswRet()[1][12])) .OR. 'RECEB' $ Upper(Alltrim(PswRet()[1][12]))
	If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3_LPT2ALM.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
		AADD(aDesenhos,"H:\Plotter\Plot\plot3_LPT2ALM.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
		AADD(aDesenhos,"H:\Plotter\Plot\plot3_LPT2ALM.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
		AADD(aDesenhos,"H:\Plotter\Plot\plot3_LPT2ALM.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
	EndIf
Else
	If ASCAN(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT") == 0
		AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PLT")
		AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRI")
		AADD(aDesenhos,"H:\Plotter\Plot\plot3.bat " + _cPath + Alltrim(cDesenho) + ".PRN")
	EndIf
EndIf
 
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

//Imprime os desenhos
If Len(aDesenhos) > 0
	If aReturn[5] > 1 
		For J := 1 TO LEN(aDesenhos)
			WaitRun(aDesenhos[j])
		Next
	EndIf
Endif

RETURN
