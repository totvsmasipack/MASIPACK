#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "shell.ch" 

#define SW_HIDE  0

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao	 ³ RPCPR039³ Autor ³ Ivandro Santos         ³Data  ³ 18/12/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Copia Desenhos do diretório Fabrina para Masipack          ³±±
±±³          |                                                        	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
*/
User Function RPCPR038()
Static cDesenho 	 := ""
Static cDriveD
Static cDriveO
Static _cPathO  	 := ":\Produto\Arquivos_Processos\Plotter\"
Static _cPathD  	 := ":\PLOTTER\"
Static cQuery   	 := ""
Static _cSemDes 	 := ""
Static _xEXE3   	 := ""
Static nD	   := 1
Static aExtDes  := {{".PRI",.T.},{".PRN",.T.},{".PDF",.T.},{".PLT",.T.}}
Static aFiles   := {}
Static cPerg  := "XPCPR38"
Static _cPathDesO := ""
Static _cPathDesD := ""

Private cString  := "SC7"
Private Tamanho  := "M"
Private wnrel    := "RPCPR038"
Private Titulo   := "Cópia de desenhos"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private cArq   	 :=	""

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString, wnrel,cperg,@titulo,,,,.F.,,,Tamanho)

cDriveO  := Alltrim(mv_par03)
cDriveD  := Alltrim(mv_par04)

If MV_PAR01 = 1
	cArq := "C:\Relato_Microsiga\Desenhos_PC_"+MV_PAR02+".CSV"
Else
	cArq := "C:\Relato_Microsiga\Desenhos_SC_"+MV_PAR02+".CSV"
Endif

Processa({|| R038()},"Aguarde...","Copiando Desenhos...",.F.)

Return

Static Function R038()

Local nD := 0

If MV_PAR01 == 1
	cQuery := " SELECT C7_PRODUTO, RTRIM(LTRIM(C7_PRODUTO))+RTRIM(LTRIM(B1_REVATU)) DESENHO "
	cQuery += " FROM "+RetSqlName("SC7")+" C7 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C7_PRODUTO AND B1.D_E_L_E_T_ = '' "
	cQuery += " WHERE C7_NUM = '"+MV_PAR02+"' AND C7.D_E_L_E_T_ = '' " //'"+MV_PAR01+"'
Else
	cQuery := " SELECT C1_PRODUTO, RTRIM(LTRIM(C1_PRODUTO))+RTRIM(LTRIM(B1_REVATU)) DESENHO "
	cQuery += " FROM "+RetSqlName("SC1")+" C1 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C1_PRODUTO AND B1.D_E_L_E_T_ = '' "
	cQuery += " WHERE C1_NUM = '"+MV_PAR02+"' AND C1.D_E_L_E_T_ = '' " //'"+MV_PAR01+"'
Endif

If Select("QRD") > 0
	dbSelectArea("QRD")
	dbCloseArea()
EndIf

//-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "QRD", .T., .F. )
dbSelectArea("QRD")

While QRD->(!Eof())
	cDesenho := Alltrim(QRD->DESENHO)
	If Substr(cDesenho,1,2) == "X1"
		If ExistDir(cDriveO+_cPathO+Substr(cDesenho,1,3))
			_cPathDesO := cDriveO + _cPathO + Substr(cDesenho,1,3) + "\"
			_cPathDesD := cDriveD + _cPathD  + Substr(cDesenho,1,2) + "\"
		Else
			_cPathDesO := cDriveO + _cPathO + Substr(cDesenho,2,3) + "\"
			_cPathDesD := cDriveD + _cPathD + Substr(cDesenho,1,2) + "\"	
		Endif
	Elseif Substr(cDesenho,1,2) == "70"
		_cPathDesO := cDriveO + _cPathO + Substr(cDesenho,1,2) + "\"
		_cPathDesD := cDriveD + _cPathD  + Substr(cDesenho,1,2) + "\"
	Else
		_cPathDesO := cDriveO + _cPathO + Substr(cDesenho,1,3) + "\"
		_cPathDesD := cDriveD + _cPathD + Substr(cDesenho,1,2) + "\"
	ENDIF
	For nD:=1 to 4
		ADir(_cPathDesO+cDesenho+aExtDes[nD][1], aFiles) //Localiza o desenho no diretório de origem
  		If len (aFiles) > 0  
  			ADir(_cPathDesD+cDesenho+aExtDes[nD][1], aFiles) //Localiza o desenho no diretório de destino
  			If len (aFiles) = 0 //Caso o desenho exista no diretório de origem, mas não tenha no destino executa o comando de cópia para o destino
	    		_xEXE3:= "cmd /c copy "+_cPathDesO+cDesenho+aExtDes[nD][1]+" "+_cPathDesD+cDesenho+aExtDes[nD][1]+""
    			WaitRun(_xEXE3,0)
    		EndIf
	  		aExtDes[nD][2] := .T.
  		Else
  			//Caso o desenho não exista no diretório de origem, verifica no destino
  			ADir(_cPathDesD+cDesenho+aExtDes[nD][1], aFiles)
  			If len (aFiles) > 0
  				aExtDes[nD][2] := .T.
  			Else
	  			aExtDes[nD][2] := .F.
  			EndIf
  		Endif
	Next
	IF !(aExtDes[1][2]) .And. !(aExtDes[2][2]) .And. !(aExtDes[3][2]) .And. !(aExtDes[4][2])
	   _cSemDes += cDesenho+CHR(13)+CHR(10)
	End If
	QRD->(DbSkip())
EndDo

If (cArqCSV := FCreate(cArq)) == -1 
	Alert("Arquivo para o Excel não pode ser criado - Verifique se o mesmo não está aberto - Avise o Depto. de Informática")
	Return
Else
	If !Empty(Alltrim(_cSemDes))
		//+-------------------------------------------------------------------------------
		//| Gera arquivo .CSV - FIM
		//+-------------------------------------------------------------------------------
		cRegCSV := "Os desenhos não encontrados foram:"
		FWrite(cArqCSV,cRegCSV+chr(13)+chr(10))
		FWrite(cArqCSV,_cSemDes)
		FClose(cArqCSV)
		Alert("Os desenhos não encontrados estão no arquivo"+CHR(13)+CHR(10)+cArq)
	Endif
EndIF

If ApMsgYesNo("Copiar desenhos de outro Pedido/Solicitação")
	_cSemDes := ""
	U_RPCPR038()
Endif

Return