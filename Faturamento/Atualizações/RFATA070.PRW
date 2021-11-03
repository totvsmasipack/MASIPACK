#Include "Rwmake.ch"
#Include "Topconn.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³RFATA070  ºAutor  ³Ivandro M. P. Santos    º Data  05/04/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao na tabela SZX - Vendores e Regiões (Comercial)   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA070()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cValIncAlt
Private aRotina   := {{"Pesquisa" ,"AxPesqui"  ,0,1} ,;   // Pesquisa
{"Visualiza","AxVisual"  ,0,2},;   // Visualiza
{"Inclui"   ,"AxInclui"  ,0,3} ,;   // Inclui
{"Altera"   ,"AxAltera"  ,0,4} ,;   // Altera
{"Exclui"   ,"AxDeleta"  ,0,5}}   // Exclui
                              
//Ivandro Santos - 22/11/16 - Início alteração
//Ticket#2016111737000082 — Tabela | Atualização (cadastro) de Vendedores
_cValIncAlt := "U_RF070INAL(nOpc)"
                              
AxCadastro1("SZX","Vendedores e Regiões",,_cValIncAlt)
//Ticket#2016111737000082 — Fim da alteração
Return                                            
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função criada para validar se o Vendedor não foi bloqueado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
//Ivandro Santos - 22/11/16
//Ticket#2016111737000082 — Tabela | Atualização (cadastro) de Vendedores
User Function RF070INAL(nOpc)
Local   _lRet  := .T.
Local _cTipoBl := "2"

   If Inclui
      _cTipoBl := GetAdvFval("SA3","A3_MSBLQL",xFilial("SA3")+M->ZX_CODVEND,1," ")
	  If _cTipoBl == "1"
	     apmsgStop("Vendedor Bloqueado... não pode ser usado")
	     _lRet := .F.
	  EndIf    
   EndIf
Return(_lRet)
//Ticket#2016111737000082 — Tabela | Atualização (cadastro) de Vendedores                                   
