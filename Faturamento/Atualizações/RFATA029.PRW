#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATA029  ºAutor  ³Aparecida de F.StevanatoºData ³ 05/07/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao na tabela SZL (Produtos em Conserto).            º±±
±±º          ³                                                            º±±
±±º          ³28/11/2011 - Alteracao efetuada por Ana Paula QFaustino     º±±
±±º          ³             foi criado mais alguns campos na tabela SZL e  º±±
±±º          ³             colocado tambem uma legenda                    º±±
±±º          ³02/04/2012 - Pesquisa se o Cliente tem restrição Financeira º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA029()
 
Private titulo    := "Identificação do Produto em Conserto"                                                     
Private wnrel     := "RFATA029"
Private aReturn   := {"Zebrado", 1, "Administracao", 2, 1, 1, "", 1 }
Private nomeprog  := "RFATA029" 
Private CbCont    := ""
Private CbTxt     := ""
Private cPerg	  := ""
Private nLastKey  := 0
Private Li        := 99 
Private cabec1    := ""
Private cabec2    := ""
Private tamanho   := "P"
Private limite    := 80
Private X         := 0
Private lRet      := .T.
Private nOpc      := 0

// Variaveis utilizadas para envio de email
Private _cTitulo   := ""
Private _cDestino  := ""
Private _cCco      := ""
Private _cMsg      := ""
Private _cAnexo    := "" 
Private _cUser     := Alltrim(UsrRetName(RetCodUsr()))                   
Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cDeptoUsu := ""

//Local cVldExc := ".T."
//Local cVldAlt := ".T."
//Local cVldInc := ".T."

//Private aRotina := MenuDef()
Private aCores := {}

Private cCadastro := "Produtos em Conserto"

Private aRotina := { {"Pesquisar" ,"AxPesqui", 0,1,0,.F.},;
					 {"Visualizar","AxVisual", 0,2,0,.F.},;
					 {"Incluir"   ,"U_CadInc29", 0,3,0,.T.},;
					 {"Alterar"   ,"U_CadAlt29", 0,4,0,.T.},;
					 {"Excluir"   ,"AxDeleta", 0,5,0,.F.},;
					 {"Imprimir"  ,"U_CadImp29", 0,6,0,.T.},;
					 {"Legenda"   ,"U_Legenda029", 0,7,0,.T.} }

Private cString   := "SZL" 

PswOrder(1)
If PswSeek(_cUsuario,.T.)                                                                  
   _aUsuario := PswRet()
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
   If SubStr(_cDeptoUsu,1,1) == "2"
      _cDeptoUsu := SubStr(_cDeptoUsu,5,Len(_cDeptoUsu))
   EndIf    
EndIf

dbSelectArea("SZL")
SZL->(dbSetOrder(1))
SZL->(dbGoTop())					 
//AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt,cVldInc)

AADD(aCores,{'(Empty(SZL->ZL_DTAVAL).And.Empty(SZL->ZL_RESULTA).And.Empty(SZL->ZL_DTORCAM).And.(SZL->ZL_APROVA="N").And.Empty(SZL->ZL_DTLIBER).And.Empty(SZL->ZL_DTRETIR))','BR_VERDE'})
AADD(aCores,{'!Empty(SZL->ZL_DTAVAL).And.(SZL->ZL_RESULTA="C".OR.SZL->ZL_RESULTA="E").And.Empty(SZL->ZL_DTORCAM).And.(SZL->ZL_APROVA="N").And.Empty(SZL->ZL_DTSFORN).And.Empty(SZL->ZL_CODFOR).And.Empty(SZL->ZL_DTLIBER).And.Empty(SZL->ZL_DTRETIR)','BR_AZUL'})
AADD(aCores,{'!Empty(SZL->ZL_DTAVAL).And.(SZL->ZL_RESULTA="C".OR.SZL->ZL_RESULTA="E").And.(!Empty(SZL->ZL_DTORCAM)).And.(SZL->ZL_APROVA="N").And.Empty(SZL->ZL_DTLIBER).And.Empty(SZL->ZL_DTRETIR)','BR_LARANJA'})
AADD(aCores,{'!Empty(SZL->ZL_DTAVAL).And.(SZL->ZL_RESULTA="C".OR.SZL->ZL_RESULTA="E").And.(!Empty(SZL->ZL_DTORCAM)).And.(SZL->ZL_APROVA="S").And.Empty(SZL->ZL_DTLIBER).And.Empty(SZL->ZL_DTRETIR)','BR_AMARELO'})
AADD(aCores,{'!Empty(SZL->ZL_DTAVAL).And.(SZL->ZL_RESULTA="C".OR.SZL->ZL_RESULTA="E").And.(!Empty(SZL->ZL_DTORCAM)).And.(SZL->ZL_APROVA="S".OR.SZL->ZL_APROVA="N").And.(!Empty(SZL->ZL_DTLIBER)).And.Empty(SZL->ZL_DTRETIR).OR.(!Empty(SZL->ZL_DTAVAL).And.(SZL->ZL_RESULTA="I".OR.SZL->ZL_RESULTA="S").And.Empty(SZL->ZL_DTRETIR))','BR_CINZA'})
AADD(aCores,{'!Empty(SZL->ZL_DTAVAL).And.(SZL->ZL_RESULTA="E").And.Empty(SZL->ZL_DTORCAM).And.(SZL->ZL_APROVA="N").And.Empty(SZL->ZL_DTLIBER).And.(!Empty(SZL->ZL_CODFOR)).And.(!Empty(SZL->ZL_DTSFORN)).And.Empty(SZL->ZL_DTRETIR)','BR_PINK'})
AADD(aCores,{'!Empty(SZL->ZL_DTAVAL).And.(SZL->ZL_RESULTA="C".OR.SZL->ZL_RESULTA="E".OR.SZL->ZL_RESULTA="S".OR.SZL->ZL_RESULTA="I").And.(SZL->ZL_APROVA="N".OR.SZL->ZL_APROVA="S").And.(!Empty(SZL->ZL_DTRETIR))','DISABLE'})  //.And.(!Empty(SZL->ZL_DTORCAM)) //.And.(!Empty(SZL->ZL_DTLIBER))

// Endereca a funcao de BROWSE
mBrowse(6,1,22,75,"SZL",,,,,,aCores)

Return(lRet)                                                     

/*****************************************/
 User Function CadInc29(cAlias,nReg,nOpc)
/*****************************************/

Local lRet     := .T.
Local _cTitulo := ""
Local aAreaAtu := GetArea()
//Local cTudoOk  := "(Alert('OK'),.T.)"
Local cAlias   := "SZL"

If nOpc == 3
	_cTitulo  := "" 
	_cMsg     := "Equipamento para ser Consertado:"+CHR(13)+CHR(10)
	_cDestino := "jorge.candido@masipack.com.br;software@masipack.com.br" 
	
	M->ZL_EMITENT := _cUser
			
	AxInclui("SZL",0,3,,,,"U_Valida29(3)")

EndIf			

RestArea(aAreaAtu)

Return

/*****************************************/
 User Function CadAlt29(cAlias,nReg,nOpc)
/*****************************************/

Local lRet := .T.
Local _cTitulo := "" 

If nOpc == 4
	If _cDeptoUsu = "ENG. ELETRONICA" 
		If !Empty(SZL->ZL_DTRETIR)
			apmsgStop("Estas informações não podem ser alteradas - Conserto já retirado")
			lRet := .F. 
		Else
	   		AxAltera(cAlias,nReg,nOpc,,,,"TudoOK29()") 
		EndIf 
	ELSE
       apmsgStop("Estas informações só poderão ser efetuadas pela Engenharia Eletronica")
 	    lRet := .F. 
	EndIf   
EndIf

If lRet = .T.

	M->ZL_NUM     := SZL->ZL_NUM
	M->ZL_DTENT   := SZL->ZL_DTENT
	M->Zl_CODCLI  := SZL->Zl_CODCLI
	M->ZL_LOJA    := SZL->ZL_LOJA
	M->ZL_CLIENTE := SZL->ZL_CLIENTE
	M->ZL_NFISCAL := SZL->ZL_NFISCAL
	M->ZL_PRODUTO := SZL->ZL_PRODUTO
	M->ZL_DESC    := SZL->ZL_DESC
	M->ZL_QTDE    := SZL->ZL_QTDE
	M->ZL_DEFCONS := SZL->ZL_DEFCONS           
	
	_cMsg  += CHR(13)+CHR(10)
	_cMsg  += "Numero: "+M->ZL_NUM+ " - Data da Entrada: " + DTOC(M->ZL_DTENT)+ "  Emitente: "+ _cUser + CHR(13)+CHR(10)
	_cMsg  += "Cliente: "+M->Zl_CODCLI+"/"+M->ZL_LOJA+" - "+Alltrim(M->ZL_CLIENTE)+"  Nota Fiscal: "+M->ZL_NFISCAL+CHR(13)+CHR(10)  
	_cMsg  += CHR(13)+CHR(10)
	_cMsg  += "Produto: "+Alltrim(M->ZL_PRODUTO)+"-"+Alltrim(M->ZL_DESC)+" Qtde: "+ Str(M->ZL_QTDE,3)+CHR(13)+CHR(10)
	If !Empty(Alltrim(M->ZL_DEFCONS))
	_cMsg  += CHR(13)+CHR(10)
	    _cMsg  += "Defeito Constatado: " + Alltrim(M->ZL_DEFCONS)
	Endif
	
   If Alltrim(_cTitulo) <> ""
	  oMail:= EnvMail():NEW(.F.)
	  If oMail:ConnMail()
		  oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
	  EndIf
	  oMail:DConnMail()
   EndIf
EndIf  
	
Return(lRet)

/***************************************/
 User Function Valida29(nOpc)
/***************************************/

Local lRet     := .T.
Local _cTitulo := "" 

If nOpc == 3
	If lRet = .T.
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial()+M->ZL_CODCLI+M->ZL_LOJA))
		If AllTrim(SA1->A1_RISCO) $ "C_D_E" .and. AllTrim(SA1->A1_MSBLQL)<> "1"
			ApMsgAlert("Cliente possui restrição financeira. Favor verificar com Depto. Financeiro!!!")
			lRet := .T.
		ElseIf AllTrim(SA1->A1_MSBLQL) == "1"
			ApMsgStop("Cliente bloqueado !!! Entrar em contato com o Depto. Comercial !!!")
			lRet := .F.
		EndIf
	EndIf   	
Else
	If nOpc == 4
		If !Empty(SZL->ZL_DTRETIR)
			apmsgStop("Estas informações não podem serem alteradas - Conserto já liberado")
			lRet := .F. 
		Else
			If Alltrim(SZL->ZL_DEFCONS) <> Alltrim(M->ZL_DEFCONS) .Or. Alltrim(SZL->ZL_MATUTIL) <> Alltrim(M->ZL_MATUTIL) .Or. Alltrim(SZL->ZL_QTHORAS) <> Alltrim(M->ZL_QTHORAS)
				If _cDeptoUsu == "ENG. ELETRONICA" 
   		         	If !Empty(SZL->ZL_MSDTLIB)
   		               apmsgStop("Estas informações não podem serem alteradas - Conserto já liberado")
    		           lRet := .F. 
        		    EndIf 
				Else
    		        apmsgStop("Estas informações só poderão serem efetuadas pela Engenharia Eletronica")
        		    lRet := .F. 
				EndIf   
			EndIf   
			If SZL->ZL_DTLIBER <> M->ZL_DTLIBER 
				If _cDeptoUsu <>  "ENG. ELETRONICA" 
					apmsgStop("Esta alteração só poder ser efetuada pela Engenharia Eletronica")
					lRet := .F. 
				EndIf     
			EndIf      
		EndIf
	EndIf
EndIf

If lRet = .T.
	_cMsg  += CHR(13)+CHR(10)
	_cMsg  += "Numero: "+M->ZL_NUM+ " - Data da Entrada: " + DTOC(M->ZL_DTENT)+ "  Emitente: "+ _cUser + CHR(13)+CHR(10)
	_cMsg  += "Cliente: "+M->Zl_CODCLI+"/"+M->ZL_LOJA+" - "+Alltrim(M->ZL_CLIENTE)+"  Nota Fiscal: "+M->ZL_NFISCAL+CHR(13)+CHR(10)  
	_cMsg  += CHR(13)+CHR(10)
	_cMsg  += "Produto: "+Alltrim(M->ZL_PRODUTO)+"-"+Alltrim(M->ZL_DESC)+" Qtde: "+ Str(M->ZL_QTDE,3)+CHR(13)+CHR(10)
	If !Empty(Alltrim(M->ZL_DEFCONS))
		_cMsg  += CHR(13)+CHR(10)
	    _cMsg  += "Defeito Constatado: " + Alltrim(M->ZL_DEFCONS)
	Endif
	
   If Alltrim(_cTitulo) <> ""                                            
	  oMail:= EnvMail():NEW(.F.)
	  If oMail:ConnMail()
		  oMail:SendMail(_ctitulo,_cDestino,_cCCo,,_cMsg)
	  EndIf
	  oMail:DConnMail()
   EndIf
   If _cDeptoUsu $ "ASSIST.TECNICA_ENG. ELETRONICA_INFORMATICA_INFORMATICA/QUALIDADE" 
      If MsgBox("*** ATENÇÃO, Deseja Imprimír o Relatorio para Conserto?","AVISO","YESNO")
         ImpIdent()
      EndIf   
   EndIf   
EndIf

Return(lRet)

/****************************/
  Static Function ImpIdent()
/****************************/

Local X

wnrel := SetPrint(cString,NomeProg,"",@titulo,cabec1,cabec2,,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

cbtxt    := SPACE(10)
cbcont   := 0
cString  := "SZL"
Li       := 80
m_pag    := 1 

SZL->(DbSetOrder(1))

If SZL->(DbSeek(xFilial()+SZL->ZL_NUM))

   cabec(titulo,cabec1,cabec2,wnRel,Tamanho)
   Li+=2
   @Li,005 Psay "Conserto: " + SZL->ZL_NUM
   @Li,030 Psay "Data da entrada: "+ DTOC(SZL->ZL_DTENT)
   Li+=2
   @Li,005 Psay "Cliente.: " + SZL->ZL_CODCLI + "/" + SZL->ZL_LOJA + " - " + SZL->ZL_CLIENTE 
   Li+=2
   @Li,005 Psay "Produto.: " + Alltrim(SZL->ZL_PRODUTO) + " - " + SZL->ZL_DESC + " Qtde.: " + STR(SZL->ZL_QTDE,3)
   Li+=2
   @Li,005 Psay "Defeito declarado: "
   Li++
   For X := 1 TO MLCOUNT(SZL->ZL_DEFDECL,60)
       If Li > 62
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	      @Li,005 Psay "Defeito declarado: " 
       EndIF
       @Li,015 Psay MEMOLINE(SZL->ZL_DEFDECL,60,X)
       Li++
   Next
   Li+=2
   @Li,005 Psay "Emitente: " + SZL->ZL_EMITENT 
   Li+=3
   @Li,005 Psay "Responsavel pelo conserto: ______________________________"
   Li+=3
   @Li,005 Psay "Data da Conclusão: ______/______/_______"
    	
EndIf
	                                                                             
If aReturn[5] = 1
	Set Printer TO 
   	dbCommit()
   	ourspool(wnrel)
EndIf

MS_FLUSH()

AnaReturn(lRet)

/*******************************/
 User Function Legenda029()
/*******************************/

Local aCores := {}

lRet := .T.

aCores := {	{'BR_VERDE'   ,'Fazer Orcamento'},; 	   
			{'BR_AZUL'    ,'Produto Avaliado'},; 	     
			{'BR_LARANJA' ,'Orcamento Enviado'},;      
			{'BR_AMARELO' ,'Orcamento Concluido'},;    
			{'BR_CINZA'   ,'Liberado para Retira'},;   
			{'BR_PINK'    ,'Prod.Enviado Fornec'},;
			{'BR_VERMELHO','Produto Retirado'} }
			//{'DISABLE'    ,'Produto Retirado'} } 	   
			
BrwLegenda(cCadastro,'Legenda',aCores) //"Legenda"

Return(lRet)

/**************************/
  User Function CadImp29()
/**************************/

Local X

wnrel := SetPrint(cString,NomeProg,"",@titulo,cabec1,cabec2,,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

cbtxt    := SPACE(10)
cbcont   := 0
cString  := "SZL"
Li       := 80
m_pag    := 1 

SZL->(DbSetOrder(1))

If SZL->(DbSeek(xFilial()+SZL->ZL_NUM))

   cabec(titulo,cabec1,cabec2,wnRel,Tamanho)
   Li+=2
   @Li,005 Psay "Conserto: " + SZL->ZL_NUM
   @Li,030 Psay "Data da entrada: "+ DTOC(SZL->ZL_DTENT)
   Li+=2
   @Li,005 Psay "Fornecedor.: " + SZL->ZL_CODFOR + "/" + SZL->ZL_LOJAFOR + " - " + SZL->ZL_FORNECE
   Li+=2
   @Li,005 Psay "Produto.: " + Alltrim(SZL->ZL_PRODUTO) + " - " + SZL->ZL_DESC + " Qtde.: " + STR(SZL->ZL_QTDE,3)
   Li+=2
   @Li,005 Psay "Defeito Constatado: "
   Li++
   For X := 1 TO MLCOUNT(SZL->ZL_DEFCONS,60)
       If Li > 62
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	      @Li,005 Psay "Defeito Constatado: " 
       EndIF
       @Li,015 Psay MEMOLINE(SZL->ZL_DEFCONS,60,X)
       Li++
   Next
   Li+=2
   @Li,005 Psay "Emitente: " + SZL->ZL_TECAVAL
   Li+=3
   @Li,005 Psay "Responsavel pela avaliacao: ______________________________"
   Li+=3
   @Li,005 Psay "Data de Saida: ______/______/_______"
    	
EndIf
	                                                                             
If aReturn[5] = 1
	Set Printer TO 
   	dbCommit()
   	ourspool(wnrel)
EndIf

MS_FLUSH()

Return(lRet)
				 