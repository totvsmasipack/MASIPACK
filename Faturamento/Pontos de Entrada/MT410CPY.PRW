#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MT410CPY ºAutor  ³Aparecida F.Stevanato Data ³ 02/10/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Deixa varios campos em branco, Atual. Categoria (Copia PV) º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT410CPY()

Local I, nx
Private _cUsuario  := RetCodUsr()
Private _cNomeUsu  := UsrRetName(_cUsuario)
Private _aUsuario  := {}
Private _aGrupos   := {}
Private _cDeptoUsu := ""
Private _cGrupo    := ""
_nPosPCP     := GDFIELDPOS("C6_MSPCP")   //Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_MSPCP"})
_nPosTES     := GDFIELDPOS("C6_TES")   //Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_MSPCP"})
_nPosST      := GDFIELDPOS("C6_CLASFIS")   //Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C6_MSPCP"})
nx 			:= 0
_lCopia := .T.

aArea	:= GetArea()
//Alert("MT410CPY")

PswOrder(1)
If PswSeek(_cUsuario,.T.)
	_aUsuario := PswRet()
	_cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
	For I := 1 to Len(_aGrupos)
		_cGrupo += Upper(Alltrim(GrpRetName(_aGrupos[I]))) + "_"
	Next I
	_cGrupo := SubStr(_cGrupo,1,Len(_cGrupo)-1)
EndIf

If SubStr(cNumEmp,1,2) $ "01_10_11"      // MASIPACK
	If "ENGENHARIA" $ _cGrupo .OR. "PROJETOS" $ _cGrupo
		M->C5_MSCATEG := "0"
	Else
		If _cDeptoUsu == "COMERCIAL"
			M->C5_MSCATEG := "1"
			//M->C5_MSCLIEN := SC5->C5_MSCLIEN
		ElseIf _cDeptoUsu == "COMEX/COMERCIAL"
			If M->C5_TIPOCLI == "X"
				M->C5_MSCATEG := "2"
			Else
				M->C5_MSCATEG := "3"
			EndIf
		ElseIf _cDeptoUsu == "VENDA DE PECAS"
			If M->C5_TIPOCLI == "X"
				M->C5_MSCATEG := "2"
			Else
				M->C5_MSCATEG := "3"
			EndIf
		ElseIf _cDeptoUsu == "203-MAKLASER"
			M->C5_MSCATEG := "5"
		ElseIf _cDeptoUsu == "ASSIST.TECNICA"
			M->C5_MSCATEG := "6"
		Else
			M->C5_MSCATEG := "4"
		EndIf
	EndIf
	
	If M->C5_MSCATEG <> "1"
		M->C5_MSDTENT := CTOD(" ")
		M->C5_MSDTPEN := CTOD(" ")
		M->C5_MSDTCE  := CTOD(" ")
		M->C5_MSMONTA := CTOD(" ")
		//      M->C5_MSVLEMB := 0
		M->C5_MSVLMON := 0
		M->C5_OBS     := " "
		M->C5_MSVISIT := " "
		M->C5_MSINIGA := " "
		M->C5_MSSTART := " "
		M->C5_MSLAYEN := " "
		M->C5_MSPLANT := " "
		M->C5_MSENVPR := " "
		M->C5_MSENVBO := " "
		M->C5_MSDADFI := " "
		M->C5_VEND1   := "001"
		M->C5_COMIS1  := 0
		M->C5_VEND2   := " "
		M->C5_COMIS2  := 0
		M->C5_VEND3   := " "
		M->C5_COMIS3  := 0
		M->C5_VEND4   := " "
		M->C5_COMIS4  := 0
		M->C5_VEND5   := " "
		M->C5_COMIS5  := 0
	EndIf

// TIRADO EM 14/10/14 - LIZANDRA - MUDANÇA DE PROCESSO - O SISTEMA FAZ COSNSISTENCIA NO PEDIDO LINKADO:
// GARANTIA DA NF, SE É NF DE VENDA

//	If M->C5_MSCATEG == "0" 
//		M->C5_MSLINK  := SC5->C5_NUM
//	Else
//		M->C5_MSLINK  := M->C5_NUM
//	EndIf
	//Ivandro Santos - 01/03/17
	//Ticket#2017022837000031 — Natureza T03 - Garantia
	M->C5_MSLINK  := SPACE(6)	//	M->C5_MSLINK  := " "
	M->C5_MSVLPED := 0
	M->C5_MSUSER  := _cUsuario
	M->C5_MSNOUSU := _cNomeUsu
	M->C5_MSPEND  := ""         //	M->C5_MSPEND  := " "
	M->C5_MSPOSIC := ""         //	M->C5_MSPOSIC := " "
	M->C5_MSCONCL := CTOD(" ")
	M->C5_MSDTLBF := CTOD(" ")
	M->C5_COR     := SPACE(3) 	//	M->C5_COR     := " "   
//	M->C5_MSAPROV := ""        
	//Ticket#2017022837000031 — Fim da alteração
	
	IF !EMPTY(aCols[n,_nPosPCP])
		FOR nx :=1 TO LEN(aCols)
			aCols[nx][_nPosPCP] = CTOD(" ")
		NEXT
	ENDIF		

	IF !EMPTY(aCols[n,_nPosST])
		FOR nx :=1 TO LEN(aCols)
			aCols[nx][_nPosST] = "   "
		NEXT
	ENDIF		
EndIf
M->C5_NATUREZ := "          " 
//RestArea(aArea)
Return
