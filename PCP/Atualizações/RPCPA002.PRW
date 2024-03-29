/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCPA002  �Autor  �Adriano Luis Brandao� Data �  08/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de inclusao modelo 2 na tabela SZ3                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#Include "Rwmake.ch"

User Function RPCPA002()

Local aFldSZ3	:= {}
Local nX		:= 0
Local _I


//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

nOpcx := 3

//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
/*
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZ3")
*/
_nUsado:=0
aHeader:={}

/*
While !Eof() .And. (x3_arquivo == "SZ3")
	
	If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Alltrim(X3_CAMPO) <> "Z3_CONSULT"
		_nUsado++
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho,;
		x3_decimal,, x3_usado, x3_tipo,;
		x3_arquivo, x3_context } )
	EndIf
	
	DbSkip()
Enddo
*/

aFldSZ3 := FwSx3Util():GetListFieldsStruct("SZ3",.F.)
For nX := 1 To Len(aFldSZ3)
	IF !(aFldSZ3[nX,1] $ 'Z3_FILIAL|Z3_CONSULT|') .And. aScan(aHeader,ALLTRIM(aFldSZ3[nX,2])) == 0
		_nUsado++
		AADD(aHeader,{	RetTitle(aFldSZ3[nX,1]),; 
						ALLTRIM(aFldSZ3[nX,1]) ,; 
						PesqPict('SZ3',aFldSZ3[nX,1]),; 
						aFldSZ3[nX,3],;
						aFldSZ3[nX,4],;
						,; 
						,; 
						aFldSZ3[nX,2],;
						'SZ3', })
	ENDIF
Next nX

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������

aCols  := Array(1,_nUsado+1)
_nUsado := 0

/*
DbSelectArea("SX3")
DbSeek("SZ3")

While !Eof() .And. (x3_arquivo == "SZ3")
	
	If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Alltrim(X3_CAMPO) <> "Z3_CONSULT"
		_nUsado++
		
      If Alltrim(X3_CAMPO) == "Z3_ITEM"
         aCols[1][_nUsado]	:= "001"
		ElseIf x3_tipo == "C"
			aCOLS[1][_nUsado] := SPACE(x3_tamanho)
		ElseIf x3_tipo == "N"
			aCOLS[1][_nUsado] := 0
		ElseIf x3_tipo == "D"
			aCOLS[1][_nUsado] := dDataBase
		ElseIf x3_tipo == "M"
			aCOLS[1][_nUsado] := ""
		Else
			aCOLS[1][_nUsado] := .F.
		EndIf
		
	Endif
	
	DbSkip()
Enddo
*/

For nX := 1 To Len(aHeader)
	
	IF aHeader[nX,2] == "Z3_ITEM"
		aCols[Len(aCols)][nX] := "001"
	
	ELSEIF aHeader[nX,8] == "C"
		aCols[Len(aCols)][nX] := SPACE(aHeader[nX,4])
	
	ELSEIF aHeader[nX,8] == "N"
		aCols[Len(aCols)][nX] := 0

	ELSEIF aHeader[nX,8] == "D"
		aCols[Len(aCols)][nX] := dDataBase
	
	ELSEIF aHeader[nX,8] == "M"
		aCols[Len(aCols)][nX] := ''
	
	ELSEIF aHeader[nX,8] == "L"
		aCols[Len(aCols)][nX] := .F.
	
	ENDIF

Next nX

aCols[1][Len(aHeader)+1] := .F.

//��������������������������������������������������������������Ŀ
//� Variaveis do Posicionamento no aCols                         �
//����������������������������������������������������������������

_cItem   	:= aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "Z3_ITEM"   })
_cProduto	:= aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "Z3_PRODUTO"})
_nQuant 	:= aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "Z3_QUANT"  })
_cNomCons	:= aScan(aHeader,{|x| Alltrim(Upper(x[2])) == "Z3_NOMCONS"})

_nPosDel := Len(aHeader) + 1

//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

_cConsult := GetSxeNum("SZ3","Z3_CONSULT")

//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������

//_cObs    := Space(256)

//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������

cTitulo  := "RESUMO DE COMPONENTES"

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������

aC := { }

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.


AADD(aC,{"_cConsult",{15,18} ,"Consulta"  ,"@!"       ,                        ,     ,.f.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������

aR := { }

// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//AADD(aR,{"_cObs",{129,17},"Observacao","@S40",,,.t.})

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������

//aCGD := {68,5,128,315}
aCGD := {40,5,128,315}

//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������

//cLinhaOk := "ExecBlock('PA010B4',.f.,.f.)"
//cTudoOk  := "ExecBlock('PA010B4',.f.,.f.)"
_cLinhaOk  := ".T."
_cTudoOk   := ".T."  
n:= 1

//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������

// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,_cLinhaOK,_cTudoOK)


If lRetMod2
	
	ConfirmSX8()
	
	DbSelectArea("SZ3")
	For _I := 1 to Len(aCols)
		If ! aCols[_I,_nPosDel]
			RecLock("SZ3",.t.)
			SZ3->Z3_FILIAL 	:= xFilial("SZ3")
			SZ3->Z3_CONSULT := _cConsult
			SZ3->Z3_ITEM    := aCols[_I,_cItem]
			SZ3->Z3_PRODUTO	:= aCols[_I,_cProduto]
			SZ3->Z3_QUANT	:= aCols[_I,_nQuant]
			SZ3->Z3_USUARIO	:= cUserName
			SZ3->Z3_NOMCONS	:= aCols[_I,_cNomCons]
			SZ3->(MsUnLock())
		EndIf
	Next I

Else
	RollBackSx8()
EndIf

DbCommitAll()

Return
