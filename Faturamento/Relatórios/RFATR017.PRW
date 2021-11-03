#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR017 º Autor ³ Aparecida de F.Stevanato º Data ³  02/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de impressão da Ordem de Montagem                         º±±
±±º          ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - MASIPACK.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
// Reescrito por Ana Paula QF em 16/01/2014
*/

User Function RFATR017()

Private cString     := "SC5"
Private nomeprog    := "RFATR017" 
Private cPerg		  := "XRFATR017 "
Private wnrel       := "RFATR017" 
Private Titulo      := "Ordem de Montagem"
Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2      := "de Maquinas vendidas"
Private cDesc3      := ""
Private tamanho     := "P"
Private aReturn     := { "Zebrado",1,"Administracao",1,2,1,"",1}

Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cUsuSenha := ""
Private _cDeptoUsu := "" 
Private lEnd      := .F.                                                                      
Private nLastKey  := 0
Private _nI       := 0
Private _nItem    := 0
Private _nEtiq    := 99
//Private cPerg     := "RFAT17"
Private _Li       := 9000
Private _nPag     := 1 
Private _nCont    := 0 
Private cCliente  := ""  
Private cEnd      := "" 
Private cDtEnt    := ""
Private _cEvento  := ""
Private _cMaq     := ""
Private cLogo     := "logo" + SubStr(cNumEmp,1,2) + ".bmp"

PswOrder(1)
If PswSeek(_cUsuario,.T.)
   _aUsuario := PswRet()
   _cUsuSenha := UsrRetName(_cUsuario)
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros        				³
//³ mv_par01				// Numero do Pedido                 ³
//³ mv_par02				// Video ou Impressora  			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set filter to
   Return
Endif

oFont1 := TFont():New("Times New Roman",,22,,.F.,,,,,.F.)
oFont2 := TFont():New("Times New Roman",,35,,.F.,,,,,.F.)
oFont3 := TFont():New("Times New Roman",,32,,.F.,,,,,.F.)
oFont4 := TFont():New("Times New Roman",,30,,.F.,,,,,.F.)

RptStatus( { |lEnd| EmiteRelat() })

Return 

//***********************************
	Static Function EmiteRelat()
//***********************************

oPrn := TMSPrinter():New("RESTR017") 

oPrn:SetPortrait()

oPrn:Say(0, 0, " ",oFont1,1000)     // startando a impressora                                             

_nCont  := 0 

If Select("QR1") > 0   
	dbSelectArea("QR1")
	dbCloseArea()
EndIf

_cQuery := "SELECT  SC5.C5_NUM,  SC5.C5_NOTA,  SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_MSDTENT, SC5.C5_MSCATEG, SC5.C5_VOLTAGE  "
_cQuery += "        , SC5.C5_HZ,   SC5.C5_COR,   SC5.C5_TRIFASI, SC5.C5_MSPOSIC, SC5.C5_MSMONTA                                "
_cQuery += "        , SA1.A1_NREDUZ,   SA1.A1_PAIS, SYA.YA_DESCR                                                               "
_cQuery += "        , SC2.C2_NUM, SC2.C2_MSPED, SC2.C2_PRODUTO, SB1.B1_MSMAQUI, SB1.B1_ETIQUET, SB1.B1_DESC                    "
_cQuery += "        , SZK.ZK_MONTAG                                                                                            "
_cQuery += "FROM "+RetSqlName("SC5")+" SC5  "
_cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
_cQuery += "INNER JOIN "+RetSqlName("SYA")+" SYA ON SYA.YA_FILIAL = '"+xFilial("SYA")+"' AND SYA.YA_CODGI = SA1.A1_PAIS AND SYA.D_E_L_E_T_ = ' '  "
_cQuery += "INNER JOIN "+RetSqlName("SC2")+" SC2 ON SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.C2_MSPED = SC5.C5_NUM AND SC2.D_E_L_E_T_ = '  '  "
_cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " 
_cQuery += "LEFT OUTER JOIN "+RetSqlName("SZK")+" SZK ON SZK.ZK_FILIAL='"+xFilial("SZK")+"' AND SZK.ZK_COD = SC2.C2_PRODUTO AND SZK.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"'   "
_cQuery += "AND SC5.D_E_L_E_T_ = ' '   "
_cQuery += "AND SC5.C5_NUM = '"+MV_PAR01+"'  "
_cQuery += "ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN  "

TcQuery _cQuery New Alias "QR1"

TcSetField("QR1","C5_MSDTENT","D",08,00)
TcSetField("QR1","C5_MSMONTA","D",08,00)

QR1->(dbGotop())
SetRegua(QR1->(Lastrec()))

If Select("QR1") == 0   
	dbSelectArea("QR1")
	dbCloseArea()
	RETURN
Endif

lPrim := .T.

oPrn:StartPage()
_Li:=050
oPrn:SayBitmap (_Li,010,cLogo,450,200)
_Li+=80

Do While !QR1->(EOF())

//		Tirado em 22/09/14 - a pedido do Vagner (Montagem) - Lizandra
//   If !Empty(QR1->C5_NOTA)
//      ApMsgStop("Impressão será cancelada - Pedido já faturado")
//      Return
//   EndIf
   
	If lPrim
	 
		lPrim := .F.

	   oPrn:Say (_Li,700, "Ordem  de  Montagem", oFont3)
		oPrn:Say (_Li,1970, "Pag. "+ Str(_nPag,2), oFont1)
		_Li+=170
  	
		oPrn:Say (_Li,1400, "Entrega para: ", oFont1)    
		oPrn:Say (_Li,1850, DtoC(QR1->C5_MSDTENT), oFont1)
		_Li+=80

	   oPrn:Say (_Li,010, "Pedido: " + mv_par01, oFont2)
		_Li+=50
		oPrn:Say (_Li,1200, "Pais: " + QR1->YA_DESCR, oFont1)
		_Li+=100
		oPrn:Say (_Li,010, "Cliente: " + QR1->A1_NREDUZ, oFont2)
		_Li+=150

		oPrn:Say (_Li,010, "Trifasico? ", oFont1)
		If QR1->C5_TRIFASI == 'T'
	      oPrn:Say (_Li,330, "S", oFont1)
   	Else
      	oPrn:Say (_Li,330, "N", oFont1)
	   EndIf

   	oPrn:Say (_Li,500, "Tensão: " + (STR(QR1->C5_VOLTAGE,3) + " V"), oFont1) 
   	oPrn:Say (_Li,1100, "Frequencia: " + STR(QR1->C5_HZ,3) + " HZ",oFont1)
	   If Alltrim(QR1->C5_COR) == "TIT"
			oPrn:Say (_Li,1800,"Cor: TITANIO",oFont1)
		ElseIf Alltrim(QR1->C5_COR) == "BCO"
			oPrn:Say (_Li,1800,"Cor: BRANCO",oFont1)
		ElseIf Alltrim(QR1->C5_COR) == "PRE"
			oPrn:Say (_Li,1800,"Cor: PRETO",oFont1)   
		ElseIf Alltrim(QR1->C5_COR) == "AMA"
			oPrn:Say (_Li,1800,"Cor: AMARELO",oFont1) 
		ElseIf Alltrim(QR1->C5_COR) == "AZU"
			oPrn:Say (_Li,1800,"Cor: AZUL",oFont1)
		ElseIf Alltrim(QR1->C5_COR) == "VRD"
			oPrn:Say (_Li,1800,"Cor: VERDE",oFont1)
		EndIf        

	   _Li+=150
	   oPrn:Say (_Li,010, "Produto", oFont1)
	   oPrn:Say (_Li,550, "Etiq", oFont1)
	   oPrn:Say (_Li,700, "Descrição", oFont1)
	   _Li+=100 
	
   EndIf
   
	If QR1->ZK_MONTAG == "S"

		oPrn:Say (_Li,010, QR1->C2_PRODUTO, oFont1)  
		_cMaq := Alltrim(QR1->B1_MSMAQUI)
		
		If QR1->B1_ETIQUET == "S"
			oPrn:Say (_Li,580, QR1->B1_ETIQUET, oFont1)
		EndIf   
		oPrn:Say (_Li,700, SubStr(QR1->B1_DESC,1,35), oFont1)

		If _cMaq <> "" 
			_Li+=60
			oPrn:Say (_Li,700, "Maquina: " + _cMaq, oFont1)
		EndIf   

		_nCont++
		_Li+=80
   
		If _Li > 2700
			_nPag++
			oPrn:Say (3250,1400,"Emitido em: " + DTOC(Date()), oFont1)
			oPrn:EndPage()
			oPrn:StartPage()
			_Li:=050
			oPrn:SayBitmap (_Li,010,"logopp.bmp",450,200)
			_Li+=80
			oPrn:Say (_Li,700, "Ordem  de  Montagem", oFont1)
			oPrn:Say (_Li,1970, "Pag. "+ Str(_nPag,2), oFont1)
			_Li+=170
			oPrn:Say (_Li,010, "Produto", oFont1)
			oPrn:Say (_Li,550, "Etiq", oFont1)
			oPrn:Say (_Li,700, "Descrição", oFont1)
			_Li+=100
		EndIf
	EndIf   
  
   QR1->(DbSkip())
      
EndDo
   
_Li:= 2900
oPrn:Say (_Li,000, "Observações:_____________________________________________",oFont1)
_Li+=80
oPrn:Say (_Li,000, "_________________________________________________________",oFont1)
_Li+=80
oPrn:Say (_Li,000, "_________________________________________________________",oFont1)
_Li+=80
oPrn:Say (_Li,000, "_________________________________________________________",oFont1)
If QR1->C5_MSCATEG == "1" .AND. SubStr(cNumEmp,1,2) $ "01_10"
   _GravaSZM()
EndIf

If _nCont == 0
   apmsgStop("Erro no Processamento ***","Escape")
   oPrn:End()
   MS_FLUSH()  
   Return 
Else
      
EndIf

oPrn:Say (3250,1350,"Emitido em: " + DTOC(Date()), oFont1)
oPrn:EndPage()      // Finaliza a pagina

oPrn:Preview()   // Video
   
oPrn:End() 

MS_FLUSH()  

QR1->(dbCloseArea())
Return (.T.)

//*********************************    
	Static Function _GravaSZM() 
//*********************************    
	
Local _lGrava := .T.
SZM->(DbSetOrder(9))
SZM->(DbGoTop())
If SZM->(DbSeek(xFilial("SZM")+"LOGPV "+QR1->C5_NUM))
   Do While SZM->(!Eof()) .And. SZM->ZM_PEDIDO == SC5->C5_NUM .And. Alltrim(SZM->ZM_ASSUNTO) == "LOGPV"  
      If SZM->ZM_DATA == Date()
         If "Montagem" $ SZM->ZM_EVENTO
            _lGrava := .F. 
         EndIf 
      EndIf
      SZM->(DbSkip())
   EndDo   
EndIf
If _lGrava       
   RecLock("SZM",.T.)
   SZM->ZM_FILIAL  := "01" 
   SZM->ZM_PEDIDO  := QR1->C5_NUM
   SZM->ZM_CODCLI  := QR1->C5_CLIENTE
   SZM->ZM_LOJACLI := QR1->C5_LOJACLI
   SZM->ZM_CLIENTE := QR1->A1_NREDUZ
   SZM->ZM_DATA    := Date() 
   SZM->ZM_MSUSER  := _cUsuSenha
   SZM->ZM_DEPTO   := _cDeptoUsu
   SZM->ZM_ASSUNTO := "LOGPV"
   SZM->ZM_NOASSUN := "LOG DO PV"
   SZM->ZM_RESUMO  := "LOG DO PV"
   SZM->ZM_EVENTO  := "Emissao da Ordem de Montagem"
   SZM->ZM_CODDEPT := "QUALID"
   SZM->ZM_DEPTDES := "QUALIDADE"
   SZM->ZM_DTPREV  := Date()
   SZM->ZM_STATUS  := "E"
   SZM->ZM_CODTEC  := "" 
   SZM->ZM_LIDO    := .F.
   SZM->ZM_ACEITE  := .F.
   SZM->ZM_COMENT  := QR1->C5_MSPOSIC
   SZM->ZM_COPIA   := .F.
   SZM->ZM_INIMONT := QR1->C5_MSMONTA
   SZM->(MsUnlock())
EndIf   

Return