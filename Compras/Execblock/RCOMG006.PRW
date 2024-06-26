#Include "Protheus.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCOMG006  �Autor  �Lizandra Marques    � Data �  20/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � MENSAGEM QUANDO O PRODUTO N�O TEM DESENHO                  ���
���          � GATILHO EM SC1                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP - Masipack                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
// Alterado em 17/10/2012 por Ana Paula o e-mail mas.compras@masipack.com.br n�o receber� mais e-mail sobre a existencia do desenho
*/                                                 

User Function RCOMG006()     

	Private _cEmail	 := GetMV("MV_DESENHO")
	Private _aArea   := GetArea()
	Private _cSenha := ""
	
	If Inclui .or. Altera
		If SUBSTR(M->C1_PRODUTO,1,1) <= "9" .AND. Len(Alltrim(M->C1_PRODUTO)) >= 10 .or.;
			SUBSTR(M->C1_PRODUTO,1,2) == "AF" .OR. SUBSTR(M->C1_PRODUTO,1,2) == "BF" .OR. SUBSTR(M->C1_PRODUTO,1,2) == "FF" .OR. ;
			SUBSTR(M->C1_PRODUTO,1,2) == "CD" .OR. SUBSTR(M->C1_PRODUTO,1,2) == "CC" .OR. SUBSTR(M->C1_PRODUTO,1,2) == "CL" .OR. ;
			SUBSTR(M->C1_PRODUTO,1,2) == "IM" 
			
			Private _cRev	  := Posicione("SB1",1,xFilial("SB1")+M->C1_PRODUTO,"B1_REVATU")
			Private	_cCaminho := "\DESENHOS\"
			Private	_cNomeArq := Alltrim(M->C1_PRODUTO)+Alltrim(_cRev)+".PDF"
			Private _cNomComp := _cCaminho+_cNomeArq

			IF !File(_cNomComp)
				_cItemP	:= Ascan(aHeader,{|x|Upper(Alltrim(x[2])) == "C1_ITEM"})
				_cItem	:= acols[n,_cItemP]	
				cCorpoEmail := "Desenho � ser enviado para o fornecedor n�o encontrado." + CHR(13) + CHR(10)
				cCorpoEmail += CHR(13) + CHR(10)
				cCorpoEmail += "    Solicita��o: " + CA110NUM + "/" + _cItem + CHR(13) + CHR(10)
				cCorpoEmail += CHR(13) + CHR(10)
				cCorpoEmail += "        Produto: " +Alltrim(M->C1_PRODUTO)+Alltrim(_cRev) + " -  Descricao: " + Posicione("SB1",1,xFilial("SB1")+M->C1_PRODUTO,"B1_DESC") + CHR(13) + CHR(10)
				oMail:= EnvMail():NEW(.F.)
				If oMail:ConnMail()
					oMail:SendMail("Desenho n�o encontrado",_cEmail,,,cCorpoEmail)
				EndIf
				oMail:DConnMail()
			EndIf
		EndIf
	EndIf
	RestArea(_aArea)
Return(M->C1_PRODUTO)
