/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCPA003  �Autor  �Adriano Luis Brandao� Data �  08/09/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de alteracao modelo 2 da tabela SZ3                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP - MASIPACK                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include "Rwmake.ch"

User Function RPCPA003()

Local aFldSZ3	:= {}
Local nX		   := 0
Local _I		   := 0
Local _z		   := 0

Private aHeader:= {}
Private aCols	:= {}

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

nOpcx := 3

//
// Montando um Aheader
//
/*
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZ3")
*/
nUsado:=0
aHeader:={}
/*
While !Eof() .And. (x3_arquivo == "SZ3")
		
		If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Alltrim(X3_CAMPO) <> "Z3_CONSULT"
			nUsado++
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture, x3_tamanho,; 
			x3_decimal,, x3_usado, x3_tipo,; 
			x3_arquivo, x3_context } )
		EndIf

		DbSkip()
Enddo
*/

aFldSZ3 := FwSx3Util():GetListFieldsStruct("SZ3",.F.)
For nX := 1 To Len(aFldSZ3)
	IF !(aFldSZ3[1,1] $ 'Z3_FILIAL|Z3_CONSULT|') .And. aScan(aHeader,ALLTRIM(aFldSZ3[nX,2])) == 0
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
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

_cConsult := SZ3->Z3_CONSULT

//
// Variaveis de rodape
//
//_cObs    := SC3->C3_OBS

//
// Posiciona no primeiro item da tabela para adiciona-los no acols
// 
DbSelectArea("SZ3")
DbSetOrder(1)
DbSeek(xFilial("SZ3")+_cConsult)

// 
// String para inclusao na matriz dos itens
//
_cString	:= ""
//
// Inicializando a matriz dos itens e matriz em branco
//
aCols 	:= {}
n		:= 1


While !Eof() .And. SZ3->Z3_CONSULT == _cConsult
   //
   // Adiciona matriz em branco, criado-se assim uma nova linha
   //
   aAdd(aCols,Array(nUsado+1))
   //
   // Grava todos os campos na linha do acols corrente
   //
   For _I:= 1 to Len(aHeader)       
      _cVar := Alltrim(aHeader[_I,2])
      aCols[len(aCols),_I] := SZ3->(&_cVar)
   Next _I
   //
   // Grava a ultima coluna logica .f. = usado
   //
   aCols[Len(aCols),Len(aHeader)+1] := .f.

	SZ3->(DbSkip())
Enddo

//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������

cTitulo  := "Resumo de Componentes"

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

AADD(aC,{"_cConsult",{15,18} ,"Consulta"  ,"@!"       ,                                 ,     ,.f.})

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

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������

aCGD := {40,5,128,315}

//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������

cLinhaOk := ".T."
cTudoOk  := ".T."

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

If lRetMod2

	DbSelectArea("SZ3")
	DbSetOrder(1)
	DbSeek(xFilial("SZ3")+_cConsult)
   //
   // Deletando os registros para gravar os novos
   //
	Do While ! Eof() .And. SZ3->Z3_CONSULT == _cConsult
	   RecLock("SZ3",.f.)
	   Delete
	   SZ3->(MsUnLock())
	   SZ3->(DbSkip())
	EndDo

   For _i:= 1 to Len(aCols)
      //
      // Se nao estiver deletado o item, cria o novo registro e grava os campos
      //
      If ! aCols[_i,Len(aHeader)+1]         
         RecLock("SZ3",.t.)                                           
         //
         // Gravacao do cabecalho
         //
         SZ3->Z3_FILIAL  := xFilial("SZ3")
         SZ3->Z3_CONSULT := _cConsult
         //
         // Loop para a gravacao de todos os campos dos itens do acols
         //
         For _z:= 1 to Len(aHeader)
            _cVar := Alltrim(aHeader[_z,2])
            SZ3->(&_cVar) := aCols[_i,_z]
         Next _z
         SZ3->(MsUnLock())
      EndIf
   Next _i

EndIf 

DbCommitAll()

Return
