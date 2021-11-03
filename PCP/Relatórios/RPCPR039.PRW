
#include "PROTHEUS.CH"
#include "rwmake.ch"
#include "shell.ch" 

#define SW_HIDE  0
#DEFINE OPEN_FILE_ERROR -1
#DEFINE MSGIMP "A impressão não saiu! Verifique se: "
#DEFINE MSGTI 	"Dúvidas favor contatar o TI."

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPR039³ Autor ³ Ivandro Santos         ³Data  ³ 17/02/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime Desenhos do diretório Masipack                     ³±±
±±³          |                                                        	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/
User Function RPCPR039()
Local cDesenho 	 := ""
Local cDriveO
Local _cPathM  	 := ":\PLOTTER\"
Local _cPathF  	 := ":\Plotter\"
Local cQuery 	 := ""
Local _cSemDes 	 := ""
Local _cPathDesO := ""
Local _cMsg		 := ""
Local _xEXE1	 := "CMD /C NET USE LPT1: > c:\relato_microsiga\porta.txt"
Local _xEXE2	 := ""
Local _xEXE3   	 := ""
Local _lDrive    := .F.
Local _lImpMap   := .T.
Local _lStaImp   := .T.
Local nD	     := 1
Local aExtDes    := {{".PRI",.T.},{".PRN",.T.},{".PDF",.T.},{".PLT",.T.}}
Local aFiles     := {}
Local aAtributos := {}
Local _cUsuario	 := RetCodUsr()
Local _cDeptoUsu := ""
Local _aUsuario	 := {}
local _cUser	 := ALLTRIM(cUserName)
local _nQtDes	 := 0
Local nImp := 0
Local nArq := 0
Local _nX := 0


Static cPerg  := "XPCPR39"

Private cString  := "SB1"
Private Tamanho  := "M"
Private wnrel    := "RPCPR039"
Private Titulo   := "Impressão de desenhos"
Private cDesc1   := "Esse programa tem o objetivo de imprimir os desenhos conforme definido pelo usuário"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private nLastKey := 0
Private _aPrd    := {}

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario	:= PswRet()
	_cDeptoUsu	:= Upper(Alltrim(_aUsuario[1][12]))
Endif

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString, wnrel,cperg,@titulo,cDesc1,,,.F.,,,Tamanho)

If nLastKey == 27 
	Return 
Endif 

cDriveO  := IIF(mv_par01==1,"H","P")

aImps := GetImpWindows (.F.)

For nImp := 1 to len(aImps)
	If Substr(aImps[nImp],21,3) == "PCP" .And. Substr(_cDeptoUsu,1,3) $ '207_201'
		_xEXE2 := Alltrim(SubStr(aImps[nImp],1,24))
		Exit
	ElseIf Substr(aImps[nImp],21,3) == "ALM" .And. Substr(_cDeptoUsu,1,3) $ '205'
		WaitRun("CMD /C NET USE /DELETE LPT2")
		Waitrun("CMD /C NET USE LPT2 \\mssrv-app01\imp12-alm1")
		
		_xEXE1 := "CMD /C NET USE LPT2: > c:\relato_microsiga\porta.txt"
		_xEXE2 := Alltrim(SubStr(aImps[nImp],1,24))
		Exit
	ElseIf Substr(aImps[nImp],21,3) == "MKL" .And. Substr(_cDeptoUsu,1,3) $ '203'
		_xEXE2 := Alltrim(SubStr(aImps[nImp],1,24))
		Exit
	ElseIf Substr(aImps[nImp],21,3) == "USI" .And. Substr(_cDeptoUsu,1,3) $ '202'
		_xEXE2 := Alltrim(SubStr(aImps[nImp],1,24))
		Exit
	Endif
Next
If Empty(_xEXE2)
	_xEXE2 := Alltrim(SubStr(aImps[1],1,24))
Endif


If  MV_PAR03 == 1		//Substr(cNumEmp,1,2) == "01" // só Masipack
	_lDrive := ExistDir( cDriveO+_cPathM )
	
	For nArq := 1 to 2
		_lImpMap := .F.
		_lStaImp := .F.
		
		WaitRun(_xEXE1,0)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abertura do arquivo texto                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		_cArqTxt := "c:\relato_microsiga\porta.TXT"
		
		//Verifica se arquivo tem conteúdo
		If FT_FUSE( _cArqTxt ) = OPEN_FILE_ERROR
			MsgAlert( _cArqTxt + " nao pode ser aberto! Verifique os parametros.","Atencao!")
			Return
		EndIf
		
		//Posiciona no primeiro registro
		FT_FGOTOP()
		
		_nLinha:=1
		//Le arquivo linha a linha
		
		Do While !FT_FEOF()
			
			//Carrega uma linha do arquivo
			cLinha := FT_FREADLN()
			
			_cMap 	    := UPPER(Alltrim(Substr(cLinha,21,25)))
			If Substr(_cMap,3,11) $ "MSSRV-APP01_176.16.0.33"
				_lImpMap := .T.
			Endif
			_cStatus	:= Alltrim(Substr(cLinha,21,12))
			If Substr(_cStatus,1,2) == "OK"
				_lStaImp := .T.
			endif
			
			//Proxima linha
			FT_FSKIP()
			
		EndDo
	Next
ElseIf  MV_PAR03 == 2		//Substr(cNumEmp,1,2) == "10" // só Fabrima
	_lDrive := ExistDir( cDriveO+_cPathF )
Endif

If _lDrive

	//VICTOR DESSUNTE - 08/09/2016
	//INICIO - TICKET: 2016081537000136
	_aPrd := {}

	If Empty(MV_PAR04)
		AADD(_aPrd,MV_PAR02)
	Else
		If !File(MV_PAR04)
			MsgStop("O arquivo " +cArq + " não foi encontrado."," - ATENCAO")
			Return
		EndIf
		FT_FUSE(MV_PAR04)
		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		_nReg := 0
		While !FT_FEOF()
			_nReg++
			
			cLinha := FT_FREADLN()
			If cLinha == "        " .OR. cLinha = NIL
				ALERT("Fim de arquivo!")
				FT_FUSE()
				Return
			EndIf
			
			AADD(_aPrd,cLinha)
			FT_FSKIP()
		EndDo
		FT_FUSE()
	EndIf
	//FIM - TICKET: 2016081537000136
	
	For _nX:=1 To Len(_aPrd)
		
		If Select("QRD") > 0
			dbSelectArea("QRD")
			dbCloseArea()
		EndIf
		
		cQuery := " SELECT RTRIM(LTRIM(B1_COD))+RTRIM(LTRIM(B1_REVATU)) DESENHO "
		//cQuery += " FROM "+RetSqlName("SB1")+" B1 "
		//Ivandro Santos - 07/03/17
		////Ticket#2017030337000121
		//If MV_PAR03 == 1
		If MV_PAR03 == 1 .Or. Substr(Right(Alltrim(_aPrd[_nX]),3),1,1) == "P"
		////Ticket#2017030337000121 — Fim da alteração
			cQuery += " FROM SB1010 B1  "
		Else
			cQuery += " FROM SB1100 B1  "
		Endif
		cQuery += " WHERE B1_COD = '"+_aPrd[_nX]+"' AND B1.D_E_L_E_T_ = '' "
		
		//-----------------------
		//| Cria uma view no banco
		//+-----------------------
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRD", .T., .F. )
		dbSelectArea("QRD")
		QRD->(DBGotop())
		cDesenho := Alltrim(QRD->DESENHO)
		If !Empty(cDesenho)
			
			While QRD->(!Eof())
				
				
				If  MV_PAR03 == 2 //Substr(cNumEmp,1,2) == "10" //
					If Substr(cDesenho,1,1) == "X"
						If ExistDir(cDriveO+_cPathF+Substr(cDesenho,1,3))
							_cPathDesO := cDriveO + _cPathF + Substr(cDesenho,1,3) + "\"
						Else
							_cPathDesO := cDriveO + _cPathF + Substr(cDesenho,2,3) + "\"
						Endif
					ElseIf Substr(cDesenho,1,2) == "70"
						_cPathDesO := cDriveO + _cPathF + Substr(cDesenho,1,2) + "\"
					Else
						_cPathDesO := cDriveO + _cPathF + Substr(cDesenho,1,3) + "\"
					EndIf
				Else
					If Substr(cDesenho,1,2) == "CL"
						_cPathDesO := cDriveO + _cPathM  + Substr(cDesenho,3,2) + "\"
					Else
						_cPathDesO := cDriveO + _cPathM  + Substr(cDesenho,1,2) + "\"
					EndIf
				Endif
				For nD:=1 to 4
					ADir(_cPathDesO+cDesenho+aExtDes[nD][1], aFiles)
					If len (aFiles) > 0
						If Substr(_cDeptoUsu,1,3) $ '205'
							_xEXE3:= "cmd /c COPY /B "+_cPathDesO+cDesenho+aExtDes[nD][1]+" LPT2"
						Else
							_xEXE3:= "cmd /c print "+_cPathDesO+cDesenho+aExtDes[nD][1]+" LPT1:"
						EndIf
						
						//WaitRun(_xEXE3,0)
						WinExec(_xEXE3)
						aExtDes[nD][2] := .T.
					Else
						aExtDes[nD][2] := .F.
					Endif
				Next
				QRD->(DbSkip())
			EndDo
			
			
			IF !(aExtDes[1][2]) .And. !(aExtDes[2][2]) .And. !(aExtDes[3][2]) .And. !(aExtDes[4][2])
				_nQtDes++
				If _nQtDes == 1
					_cSemDes += cDesenho+CHR(13)+CHR(10)
				Else
					_cSemDes += " | " + cDesenho+CHR(13)+CHR(10)				
				Endif
			EndIf
			
		Else
			Alert("O produto não existe. Favor digitar um produto válido.")
		EndIf
	Next _nX
	If !Empty(Alltrim(_cSemDes))
		If _nQtDes == 1
			Alert("O desenho "+_cSemDes+" não foi encontrado.")
		elseif _nQtDes > 1
			Alert("Os desenhos "+_cSemDes+" não foram encontrados.")		
		Endif
	ElseIf MV_PAR03 == 1 //Substr(cNumEmp,1,2) == "01" //
		If !apmsgYesNo("*** ATENÇÃO, Desenho foi impresso? ***")
			If !_lStaImp
				_cMsg+="A impressora "+_xEXE2+" está conectada."+CHR(13)+CHR(10)+""
			Endif
			If!_lImpMap
				_cMsg+="A impressora "+_xEXE2+" está mapeada. "+CHR(13)+CHR(10)+""
			Endif
			IIf(!Empty(_cMsg),Alert(MSGIMP+CHR(13)+CHR(10)+_cMsg+CHR(13)+CHR(10)+MSGTI),"")
		EndIf
		
	Endif
Else
	_cMsg+="O diretório existe e está mapeado."+CHR(13)+CHR(10)+""
	Alert(MSGIMP+CHR(13)+CHR(10)+_cMsg+CHR(13)+CHR(10)+MSGTI)
EndIf

Return