#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/21/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento de visitas pelos vendedores                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack/Fabrima                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA067()

Local	_cCodVend	:= POSICIONE('SA3',7,XFILIAL('SA3')+RetCodUsr(),'A3_COD')
Private cCadastro := "Apontamento de Visitas"
Private aCores 	:= {	{"Z7_TPCLI == '2'",'ENABLE' },;	//CLIENTE
								{"Z7_TPCLI == '1'",'DISABLE'} }	//PROSPECT
Private aParam	:= {	{||U_RTA067V7()},{||.T.},{||.T.},{||U_RTA067V9()}}
Private aParam2	:= {	{||.T.},{||.T.},{||.T.},{||U_RTA067V9()}}
Private aRotina   := {	{"Pesquisa" 	,"AxPesqui"																													 										,0,1},;
						{"Visualiza"	,"AxVisual('SZ7',SZ7->(Recno()),2,,,,,{{'OK',{||U_RTA067V8(2)},'Historico'}},,,,,,,,,)"										  	,0,2},;
      			      	{"Incluir"		,"AxInclui('SZ7',,3,,,,'u_RTA067V5()',,, {{'OK',{||U_RFA067IN()},'Contatos'},{'OK',{||U_RTA067V8(2)},'Historico'}},aParam2)"	,0,3},;
      			      	{"Alterar"		,"AxAltera('SZ7',SZ7->(RECNO()),4,,,,,,,,{{'OK',{||U_RFA067IN()},'Contatos'},{'OK',{||U_RTA067V8(2)},'Historico'}},aParam2)" 	,0,4},;
      			      	{"Copiar"		,"AxInclui('SZ7',,3,,,,'u_RTA067V5()',,, {{'OK',{||U_RFA067IN()},'Contatos'},{'OK',{||U_RTA067V8(2)},'Historico'}},aParam)"		,0,5},;
      			      	{"Historico"	,"LJMSGRUN('Aguarde... Filtrando dados...',,{||U_RTA067V8(1)})"																	,0,6},;
      			      	{"Excluir"		,"AxDeleta('SZ7',SZ7->(Recno()),5)"																								,0,6},;
      			      	{"Legenda"   	,"U_LEG067"   																													,0,7} }

dbSelectArea("SZ7")
If !(AllTrim(cUserName) $ SuperGetMv("MS_RFTA067",,''))
	If Empty(_cCodVend)
		Aviso("Apontamento de Visitas","Usuário não vinculado ao cadastro de vendedores.",,1)
		Return
	Else
		SET FILTER TO SZ7->Z7_VEND == POSICIONE('SA3',7,XFILIAL('SA3')+RetCodUsr(),'A3_COD')
	EndIf
EndIf

MBROWSE(008,003,020,075,"SZ7",,,,,,aCores)

SZ7->(dbClearFilter())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/24/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Legenda do mbrowse                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack/Fabrima                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function LEG067()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"		,"Clientes" })
AADD(aLegenda,{"BR_VERMELHO"	,"Prospect"	})

BrwLegenda("Visitas", "Legenda", aLegenda)
           
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/23/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre tela para inclusao caso clique em                     º±±
±±º          ³ Acoes relacionadas->CONTATOS                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack/Fabrima                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFA067IN()

Local _lGravou := .F.
Local _aParam	:= {} 
Local _lAltera	:=	ALTERA

If _lAltera
	Altera := .F.
	Inclui := .T.
EndIf

aAdd(_aParam,{|| .T.			})
aAdd(_aParam,{|| .T. 			})
aAdd(_aParam,{|| .T. 			})
aAdd(_aParam,{|| u_RFA67IN2()	})

_nOpc := SU5->(AXINCLUI('SU5',,3,,,,,,,,_aParam))

If _nOpc == 1
	M->Z7_CODCONT := SU5->U5_CODCONT
	U_RTA067V2(1)
EndIf
	
If _lAltera
	Altera := .T.
	Inclui := .F.
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/23/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack/Fabrima                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFA67IN2()

RecLock("AC8",.T.)
AC8->AC8_FILIAL	:= xFilial("AC8")
AC8->AC8_FILENT	:= xFilial(IIF(M->Z7_TPCLI == '1','SUS','SA1'))
AC8->AC8_ENTIDA	:= IIF(M->Z7_TPCLI == '1','SUS','SA1')
AC8->AC8_CODENT	:= M->Z7_CLIPRO+M->Z7_LOJA
AC8->AC8_CODCON	:= SU5->U5_CODCONT
AC8->(MsUnlock())

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/21/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera consulta padrao caso seja cliente ou prospect       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067XB()

If M->Z7_TPCLI == '1'
	CONPAD1(,,,'SUS')
	M->Z7_NREDUZ 	:= SUS->US_NREDUZ
	M->Z7_CNPJ		:= SUS->US_CGC
	M->Z7_PAIS		:= SUS->US_PAIS
	M->Z7_EST		:= SUS->US_EST
	M->Z7_CID		:= SUS->US_MUN
	M->Z7_BAIRRO	:= SUS->US_BAIRRO
	M->Z7_END		:= SUS->US_END
ElseIf M->Z7_TPCLI == '2'
	CONPAD1(,,,'SA1')
	M->Z7_NREDUZ 	:= SA1->A1_NREDUZ
	M->Z7_CNPJ		:= SA1->A1_CGC
	M->Z7_PAIS		:= SA1->A1_PAIS
	M->Z7_EST		:= SA1->A1_EST
	M->Z7_CID		:= SA1->A1_MUN
	M->Z7_BAIRRO	:= SA1->A1_BAIRRO
	M->Z7_END		:= SA1->A1_END
Else
	Alert('Selecione o tipo de cliente.')
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Limpa campos caso seja alterado alguma informacao          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067VLD()

M->Z7_NREDUZ 	:= SPACE(TAMSX3("Z7_NREDUZ")[1]		)
M->Z7_CNPJ		:= SPACE(TAMSX3("Z7_CNPJ")[1]		)
M->Z7_PAIS		:= SPACE(TAMSX3("Z7_PAIS")[1]		)
M->Z7_EST		:= SPACE(TAMSX3("Z7_EST")[1]		)
M->Z7_CID		:= SPACE(TAMSX3("Z7_CID")[1]		)
M->Z7_BAIRRO	:= SPACE(TAMSX3("Z7_BAIRRO")[1]		)
M->Z7_END		:= SPACE(TAMSX3("Z7_END")[1]		)
M->Z7_CLIPRO	:= SPACE(TAMSX3("Z7_CLIPRO")[1]		)
M->Z7_LOJA		:= SPACE(TAMSX3("Z7_LOJA")[1]		)
M->Z7_CODCONT	:= SPACE(TAMSX3("Z7_CODCONT")[1]	)
M->Z7_NOMCONT	:= SPACE(TAMSX3("Z7_NOMCONT")[1]	)
M->Z7_EMAIL		:= SPACE(TAMSX3("Z7_EMAIL")[1]		)
M->Z7_DDI		:= SPACE(TAMSX3("Z7_DDI")[1]		)
M->Z7_DDD		:= SPACE(TAMSX3("Z7_DDD")[1]		)
M->Z7_CELULAR	:= SPACE(TAMSX3("Z7_CELULAR")[1]	)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao nos campos para preenchimento automatico          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V2(_nTp)

If _nTp == 1
	If SU5->U5_ATIVO == '2'
		Alert("Contato Inativo!")
		Return .F.
	EndIf
	
	M->Z7_NOMCONT	:= SU5->U5_CONTAT
	M->Z7_EMAIL		:= SU5->U5_EMAIL
	M->Z7_DDI		:= SU5->U5_CODPAIS
	M->Z7_DDD		:= SU5->U5_DDD
	M->Z7_CELULAR	:= SU5->U5_CELULAR
ElseIf _nTp == 2
	M->Z7_CODCONT	:= SPACE(TAMSX3("Z7_CODCONT")[1]	)
	M->Z7_NOMCONT	:= SPACE(TAMSX3("Z7_NOMCONT")[1]	)
	M->Z7_EMAIL		:= SPACE(TAMSX3("Z7_EMAIL")[1]		)
	M->Z7_DDI		:= SPACE(TAMSX3("Z7_DDI")[1]		)
	M->Z7_DDD		:= SPACE(TAMSX3("Z7_DDD")[1]		)
	M->Z7_CELULAR	:= SPACE(TAMSX3("Z7_CELULAR")[1]	)
ElseIf _nTp == 3
	If AllTrim(M->Z7_TPVISIT) == 'INT'
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+'99999900')) //CLIENTE PADRAO MASIPACK/FABRIMA
		
		dbSelectArea("SU5")
		SU5->(dbSetOrder(1))
		SU5->(dbSeek(xFilial("SU5")+'000001')) //CONTATO PADRAO MASIPACK/FABRIMA
		
		M->Z7_TPCLI		:= '2'
		M->Z7_CLIPRO	:= SA1->A1_COD
		M->Z7_LOJA		:= SA1->A1_LOJA
		M->Z7_NREDUZ 	:= SA1->A1_NREDUZ
		M->Z7_CNPJ		:= SA1->A1_CGC
		M->Z7_PAIS		:= SA1->A1_PAIS
		M->Z7_EST		:= SA1->A1_EST
		M->Z7_CID		:= SA1->A1_MUN
		M->Z7_BAIRRO	:= SA1->A1_BAIRRO
		M->Z7_END		:= SA1->A1_END
		M->Z7_CODCONT	:= SU5->U5_CODCONT
		M->Z7_NOMCONT	:= SU5->U5_CONTAT
		M->Z7_EMAIL		:= SU5->U5_EMAIL
		M->Z7_DDI		:= SU5->U5_CODPAIS
		M->Z7_DDD		:= SU5->U5_DDD
		M->Z7_CELULAR	:= SU5->U5_CELULAR
	EndIf
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna dados para os campos de acordo com tipo de cliente º±±
±±º          ³ selecionado                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V3(_cCampo)

_cRet := ' '

If SZ7->Z7_TPCLI == '1'
	_cRet := POSICIONE('SUS',1,XFILIAL('SUS')+SZ7->Z7_CLIPRO+SZ7->Z7_LOJA,'US_'+SUBSTR(_cCampo,4,LEN(_cCampo)))
ElseIf SZ7->Z7_TPCLI == '2'
	_cRet := POSICIONE('SA1',1,XFILIAL('SA1')+SZ7->Z7_CLIPRO+SZ7->Z7_LOJA,'A1_'+SUBSTR(_cCampo,4,LEN(_cCampo)))
EndIf

Return _cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro para consulta padrao dos contatos                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack/Fabrima                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V4()

Local _aArea := GetArea()
Local _cQry  := ''
Local _cRet	 := ''

_cQry := " SELECT AC8_CODCON FROM " + RetSqlName("AC8")
_cQry += " WHERE D_E_L_E_T_ = ' ' "
_cQry += " AND AC8_FILIAL = '" + xFilial("AC8") + "' "
_cQry += " AND AC8_FILENT = '" + xFilial(IIF(M->Z7_TPCLI=='1','SUS','SA1')) + "' "
_cQry += " AND AC8_CODENT = '" + M->Z7_CLIPRO + M->Z7_LOJA + "' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

TRB->(dbGoTop())
While TRB->(!EOF())
	_cRet := _cRet + TRB->AC8_CODCON + '*'
	TRB->(dbSkip())
End

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

RestArea(_aArea)

Return "@# SU5->(U5_CODCONT $ '" + _cRet + "')@#"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida campos de Hora Inicial e Hora Final                 º±±
±±º          ³ Caso ja exista Data e hora cadastrados                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V5()

Local _aArea	:= GetAreA()
Local _lRet		:= .T.
Local _cQry		:= ""

_cQry := " SELECT " + CRLF
_cQry += "		COUNT(*) AS TOT " + CRLF
_cQry += " FROM " + CRLF
_cQry +=			RetSqlName("SZ7")
_cQry += " WHERE " + CRLF
_cQry += "		D_E_L_E_T_	= ' ' " + CRLF
_cQry += " AND	Z7_FILIAL	= '" + xFilial("SZ7") + "' " + CRLF
_cQry += " AND	Z7_VEND		= '" + M->Z7_VEND + "' " + CRLF
_cQry += " AND	Z7_DTVISIT	= '" + DTOS(M->Z7_DTVISIT) + "' " + CRLF
_cQry += " AND	( " + CRLF
_cQry += "			(Z7_HRINI BETWEEN '" + M->Z7_HRINI + "' AND '" + M->Z7_HRFIM + "')			OR	" + CRLF
_cQry += "			(Z7_HRFIM BETWEEN '" + M->Z7_HRINI + "' AND '" + M->Z7_HRFIM + "')			OR	" + CRLF
_cQry += "			(Z7_HRINI <= '" + M->Z7_HRINI + "' AND Z7_HRFIM >= '" + M->Z7_HRINI + "')	OR	" + CRLF
_cQry += "			(Z7_HRINI <= '" + M->Z7_HRFIM + "' AND Z7_HRFIM >= '" + M->Z7_HRFIM + "')		" + CRLF
_cQry += "		) "

If Select("TRBV5") > 0
	TRBV5->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRBV5"

TRBV5->(dbGoTop())

If TRBV5->TOT > 0
	Alert("Já existem apontamentos correspondente a está data e hora.")
	_lRet := .F.
EndIf

If Select("TRBV5") > 0
	TRBV5->(dbCloseArea())
EndIf

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Valida campo de Hora e se hora inicial e maior que final º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V6(_cHora,_nTp)

Local _aArea	:= GetArea()
Local _lRet		:= .T.
Local _cHr1		:= VAL(STRTRAN(M->Z7_HRINI,':','.'))
Local _cHr2		:= VAL(STRTRAN(M->Z7_HRFIM,':','.'))

If VAL(SUBSTR(_cHora,1,2)) > 23 .OR. VAL(SUBSTR(_cHora,4,2)) > 59
	Alert("Hora inválida, digite uma hora válida.")
	_lRet := .F.
Else
	//VICTOR DESSUNTE - 09/09/2016
	//INICIO - TICKET: 2016090137000197
	If _nTP == 1 .AND. !EMPTY(_cHora) .AND. SUBSTR(Time(),1,5) < _cHora
		Alert("Hora inicial deve ser menor ou igual a hora atual.")
		_lRet := .F.
	EndIf
	//FIM - TICKET: 2016090137000197
		
	If _nTp == 2 .AND. _cHr1 >= _cHr2
		Alert("Informe uma hora maior que a Hora Inicial.")
		_lRet := .F.
	EndIf

	//VICTOR DESSUNTE - 09/09/2016
	//INICIO - TICKET: 2016090137000197
	If _nTp == 2 .AND. !EMPTY(_cHora) .AND. SUBSTR(Time(),1,5) < _cHora
		Alert("Hora final deve ser menor ou igual a hora atual.")
		_lRet := .F.
	EndIf
	//FIM - TICKET: 2016090137000197
EndIf

RestArea(_aArea)

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  03/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Valida campo de Hora e se hora inicial e maior que final º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V7()

If SZ7->Z7_TPCLI == '1'
	M->Z7_NREDUZ 	:= SUS->US_NREDUZ
	M->Z7_CNPJ		:= SUS->US_CGC
	M->Z7_PAIS		:= SUS->US_PAIS
	M->Z7_EST		:= SUS->US_EST
	M->Z7_CID		:= SUS->US_MUN
	M->Z7_BAIRRO	:= SUS->US_BAIRRO
	M->Z7_END		:= SUS->US_END
Else
	M->Z7_NREDUZ 	:= SA1->A1_NREDUZ
	M->Z7_CNPJ		:= SA1->A1_CGC
	M->Z7_PAIS		:= SA1->A1_PAIS
	M->Z7_EST		:= SA1->A1_EST
	M->Z7_CID		:= SA1->A1_MUN
	M->Z7_BAIRRO	:= SA1->A1_BAIRRO
	M->Z7_END		:= SA1->A1_END
EndIf

M->Z7_TPCLI		:= SZ7->Z7_TPCLI
M->Z7_CLIPRO	:= SZ7->Z7_CLIPRO
M->Z7_LOJA		:= SZ7->Z7_LOJA

If SU5->U5_ATIVO == '2'
	Alert("Contato inativo, os dados do contato não serão preenchidos.")
	Return
EndIf

M->Z7_CODCONT	:= SZ7->Z7_CODCONT
M->Z7_NOMCONT	:= SU5->U5_CONTAT
M->Z7_EMAIL		:= SU5->U5_EMAIL
M->Z7_DDI		:= SU5->U5_CODPAIS
M->Z7_DDD		:= SU5->U5_DDD
M->Z7_CELULAR	:= SU5->U5_CELULAR

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATA067  ºAutor  ³Victor Dessunte     º Data ³  04/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Exibe historico do cliente/prospect                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V8(_nTp)

Local _cArq 	:= "C:\relato_microsiga\RFATA067.TXT"
Local _cQry		:= ""
Local _cAux		:= ""
Local	_cTexto	:= ""
Local _nX		:= 0

If _nTp == 2 .AND. (Empty(M->Z7_TPCLI) .OR. Empty(M->Z7_CLIPRO) .OR. Empty(M->Z7_LOJA))
	Alert("Para visualização do histórico é necessário o preenchimento dos campos Tipo Cliente, Cli./Prosp. e Loja.")
	Return
EndIf

_cQry := " SELECT " + CRLF
_cQry += "	Z7_VEND + ' - ' + A3_NOME AS 'VEND', " + CRLF
_cQry += "	'DATA:' + SUBSTRING(Z7_DTVISIT,7,2) +'/'+ SUBSTRING(Z7_DTVISIT,5,2) +'/'+SUBSTRING(Z7_DTVISIT,1,4) + '      ' + Z7_HRINI+'hs.' + ' ÀS ' + Z7_HRFIM+'hs.' AS DTHR , " + CRLF
_cQry += "	(CASE " + CRLF
_cQry += "		WHEN Z7_TPCLI = '1' THEN " + CRLF
_cQry += " 			'PROSPECT: ' + Z7_CLIPRO+'/'+Z7_LOJA+' - '+(SELECT US_NREDUZ FROM " + RetSqlName("SUS") + " WHERE US_COD = Z7_CLIPRO AND US_LOJA = Z7_LOJA AND D_E_L_E_T_ = ' ') " + CRLF
_cQry += "		WHEN Z7_TPCLI = '2' THEN " + CRLF
_cQry += "			'CLIENTE: ' + Z7_CLIPRO+'/'+Z7_LOJA+' - '+(SELECT A1_NREDUZ FROM " + RetSqlName("SA1") + " WHERE A1_COD = Z7_CLIPRO AND A1_LOJA = Z7_LOJA AND D_E_L_E_T_ = ' ') " + CRLF
_cQry += " 	END) AS 'CLIENTE', " + CRLF
_cQry += " 		Z7_CODCONT + ' - ' + U5_CONTAT AS 'CONTATO'	, " + CRLF
_cQry += " 		Z7_TPVISIT + ' - ' + X5_DESCRI AS 'TPVISIT'	, " + CRLF
_cQry += " 		Z7_ASSUNTO	, " + CRLF
_cQry += " 		ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),Z7_PRODUTO)),'') AS 'Z7_PRODUTO', " + CRLF
_cQry += " 		Z7_CONCOR	, " + CRLF
_cQry += " 		ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),Z7_OBS)),'') AS 'Z7_OBS', " + CRLF
_cQry += " 		ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),Z7_ACAO)),'') AS 'Z7_ACAO', " + CRLF
_cQry += " 		Z7_TPCLI " + CRLF
_cQry += " 	FROM " + CRLF
_cQry += 		RetSqlName("SZ7") + " AS Z7 INNER JOIN " + RetSqlName("SX5") + " AS X5 " + CRLF
_cQry += " 		ON	X5.D_E_L_E_T_ 	= ' ' " + CRLF
_cQry += " 		AND	X5_TABELA	= '70' " + CRLF
_cQry += " 		AND	X5_CHAVE		= Z7_TPVISIT " + CRLF

_cQry += " 		LEFT JOIN " + RetSqlName("SU5") + " AS U5 " + CRLF
_cQry += " 		ON 	U5.D_E_L_E_T_ 	= ' ' " + CRLF
_cQry += " 		AND U5_FILIAL 		= ' ' " + CRLF
_cQry += " 		AND U5_CODCONT		= Z7_CODCONT " + CRLF

_cQry += " 		INNER JOIN " + RetSqlName("SA3") + " AS A3 " + CRLF
_cQry += " 		ON	A3.D_E_L_E_T_	= ' ' " + CRLF
_cQry += " 		AND	A3_COD			= Z7_VEND " + CRLF
_cQry += " 	WHERE " + CRLF
_cQry += " 		Z7.D_E_L_E_T_	= ' ' " + CRLF
_cQry += " 	AND Z7_FILIAL		= '" + xFilial("SZ7") + "' " + CRLF

If !(AllTrim(cUserName) $ SuperGetMv("MS_RFTA067",,''))
	If _nTp == 1
		_cQry += "AND Z7_VEND = '" + SZ7->Z7_VEND + "' " + CRLF
	Else
		_cQry += "AND Z7_VEND = '" + M->Z7_VEND + "' " + CRLF
	EndIf
EndIf

If _nTp == 1
	_cQry += " AND	Z7_CLIPRO 	= '" + SZ7->Z7_CLIPRO	+ "' " + CRLF
	_cQry += " AND	Z7_LOJA 	= '" + SZ7->Z7_LOJA		+ "' " + CRLF
	_cQry += " AND	Z7_TPCLI	= '" + SZ7->Z7_TPCLI	+ "' " + CRLF
Else
	_cQry += " AND	Z7_CLIPRO 	= '" + M->Z7_CLIPRO	+ "' " + CRLF
	_cQry += " AND	Z7_LOJA 	= '" + M->Z7_LOJA	+ "' " + CRLF
	_cQry += " AND	Z7_TPCLI	= '" + M->Z7_TPCLI	+ "' " + CRLF
EndIf

_cQry += " ORDER BY Z7_VEND,Z7_DTVISIT,Z7_HRINI,Z7_TPVISIT "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "TRB"

TRB->(dbGoTop())

MAKEDIR('C:\relato_microsiga') //Cria dire
FERASE(_cArq)

ACALOG(_cArq,'          ....:::: HISTÓRICO DE VISITAS ::::....          '	)
ACALOG(_cArq,'----------------------------------------------------------'	)
ACALOG(_cArq,''				 																)
ACALOG(_cArq,TRB->CLIENTE	  																)
ACALOG(_cArq,''																				)

While TRB->(!EOF())
	ACALOG(_cArq,TRB->DTHR)
	
	If (AllTrim(cUserName) $ SuperGetMv("MS_RFTA067",,'')	)
		ACALOG(_cArq,'VENDEDOR....: '+AllTrim(TRB->VEND)	)
	EndIf
	
	ACALOG(_cArq,'CONTATO.....: '+AllTrim(TRB->CONTATO)		)
	ACALOG(_cArq,'TIPO VISITA.: '+AllTrim(TRB->TPVISIT	)	)
	ACALOG(_cArq,'ASSUNTO.....: '+AllTrim(TRB->Z7_ASSUNTO)	)
	ACALOG(_cArq,'CONCORRENTE.: '+AllTrim(TRB->Z7_CONCOR)	)
	
	_cTexto 	:= AllTrim(TRB->Z7_PRODUTO)
	_cAux		:= ""
	_nX		:= 0
	While Len(_cTexto) > 0
		_nX++
		_cAux 	:= SubStr(_cTexto,1,80)
		_cTexto  := SubStr(_cTexto,Len(_cAux)+1,Len(_cTexto))
		ACALOG(_cArq,IIF(_nX == 1,'OPORT./PROD.: ',Space(14))+_cAux)
	End
	
	_cTexto 	:= AllTrim(TRB->Z7_ACAO)
	_cAux		:= ""
	_nX		:= 0
	While Len(_cTexto) > 0
		_nX++
		_cAux 	:= SubStr(_cTexto,1,80)
		_cTexto  := SubStr(_cTexto,Len(_cAux)+1,Len(_cTexto))
		ACALOG(_cArq,IIF(_nX == 1,'ACAO........: ',Space(14))+_cAux)
	End

	_cTexto 	:= AllTrim(TRB->Z7_OBS)
	_cAux		:= ""
	_nX		:= 0
	While Len(_cTexto) > 0
		_nX++
		_cAux 	:= SubStr(_cTexto,1,80)
		_cTexto  := SubStr(_cTexto,Len(_cAux)+1,Len(_cTexto))
		ACALOG(_cArq,IIF(_nX == 1,'OBS.........: ',Space(14))+_cAux)
	End

	ACALOG(_cArq,'')
	TRB->(dbSkip())
End

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

ShowMemo(_cArq,"VISITAS")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTA067V9  ºAutor  ³Victor Dessunte     º Data ³  04/13/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³- Grava campo Data da ultima visita no prospect ou cliente  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTA067V9()

If M->Z7_CLIPRO == '999999'
	Return
EndIf

If M->Z7_TPCLI == '1'
	dbSelectArea("SUS")
	SUS->(dbSetOrder(1))
	If SUS->(dbSeek(xFilial("SUS")+M->Z7_CLIPRO+M->Z7_LOJA))
		If DTOS(SUS->US_ULTVIS) < DTOS(M->Z7_DTVISIT)
			RECLOCK("SUS",.F.)
			SUS->US_ULTVIS := M->Z7_DTVISIT
			SUS->(MsUnlock())
		EndIf
	EndIf
Else
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+M->Z7_CLIPRO+M->Z7_LOJA))
		If DTOS(SA1->A1_ULTVIS) < DTOS(M->Z7_DTVISIT)
			RECLOCK('SA1',.F.)
			SA1->A1_ULTVIS := M->Z7_DTVISIT
			SA1->(MsUnlock())
		EndIf
	EndIf
EndIf

Return