#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATG058  ºAutor  ³Ivandro Santos      º Data ³  24/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para permitir a cópia de informações do cliente se º±±
±±º          ³o usuário optar por cadastrar nova loja.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Masipack - Fontes MATA010/MA030BUT/RFATG057                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG058()
Local _cCodCli 	:= ""
Local _aArea    := GetArea()
Local _cQry		:= ""

If M->A1_COD == SA1->A1_COD
	M->A1_NOME 		:= SA1->A1_NOME
	M->A1_MSAREA	:= SA1->A1_MSAREA
	M->A1_END		:= SA1->A1_END
	M->A1_BAIRRO	:= SA1->A1_BAIRRO
	M->A1_CEP		:= SA1->A1_CEP
	M->A1_COD_MUN	:= SA1->A1_COD_MUN
	M->A1_MUN		:= SA1->A1_MUN
	M->A1_EST		:= SA1->A1_EST
	M->A1_PAIS		:= SA1->A1_PAIS
	M->A1_CGC		:= SA1->A1_CGC
	M->A1_INSCR		:= SA1->A1_INSCR
	M->A1_TEL		:= SA1->A1_TEL
	M->A1_TIPO		:= SA1->A1_TIPO
	M->A1_FAX		:= SA1->A1_FAX
	M->A1_EMAIL		:= SA1->A1_EMAIL
	M->A1_CONTA		:= SA1->A1_CONTA
	M->A1_CODPAIS	:= SA1->A1_CODPAIS
	M->A1_SATIV1 	:= SA1->A1_SATIV1
	M->A1_SATIV2	:= SA1->A1_SATIV2
	M->A1_SATIV3	:= SA1->A1_SATIV3
	M->A1_SATIV4	:= SA1->A1_SATIV4
	M->A1_SATIV5	:= SA1->A1_SATIV5
	M->A1_SATIV6	:= SA1->A1_SATIV6
	M->A1_SATIV7	:= SA1->A1_SATIV7
	M->A1_SATIV8	:= SA1->A1_SATIV8
	M->A1_CNAE		:= SA1->A1_CNAE
	M->A1_NATUREZ	:= SA1->A1_NATUREZ
	M->A1_VEND		:= SA1->A1_VEND	
	M->A1_REGIAO	:= SA1->A1_REGIAO
	M->A1_TRANSP	:= SA1->A1_TRANSP
	M->A1_COND		:= SA1->A1_COND	
	M->A1_TABELA	:= SA1->A1_TABELA
Endif

RestArea(_aArea)
Return()