#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define _CLRF CHR(13)+CHR(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFISA004     �Autor  �Ivandro M P Santos� Data �  28/04/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa que faz a leitura do arquivo txt e atualiza campos���
���          � Gera arquivo em xml para preenchimento de informa��es      ���
�������������������������������������������������������������������������͹��
���Uso       � Fiscal - Ticket#2017042837000055                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function RFISA004()
Private _cPerg 	:= "XFISR008"
Private nLastKey:= 0
Private _cArq	:= ""
Private aCampos := {}
Private _nReg	:= 0
Private _nRegA	:= 0
Private LastKey	:= 0

Pergunte(_cPerg,.T.)

If LastKey() == 27 .Or. nLastKey == 27
	Return
Else
	_cArq := MV_PAR04
	If MV_PAR01 == 1
		MsAguarde({||MSFISR004()}, OemToAnsi("Gerando Arquivo Notas Clientes, EXPORTA��O") )
	Elseif !Empty(_cArq)
		If !File(_cArq)
			MsgStop("O arquivo " +cArq + " n�o foi encontrado. A importa��o ser� abortada!"," - ATENCAO")
			Return
		EndIf
		MsAguarde({||MSFISA004()}, OemToAnsi("Atualizando Tabela SPED Exporta��o, CDL") )
		ApMsgInfo("Importa��o conclu�da de "+Alltrim(cValtoChar(_nReg))+" registros... "+_CLRF+"Foram alterados "+Alltrim(cValtoChar(_nRegA))+" registros"," - SUCESSO")
	Endif
Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSFISA004 �Autor  �Ivandro Santos      � Data �  28/04/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que atualizar� a tabela CDL com dados da AWB para  ���
���          �o complemento de exporta��o                                 ���
�������������������������������������������������������������������������͹��
���Uso       � RFISA004                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MSFISA004()

If !File(_cArq)
	MsgStop("O arquivo " +_cArq + " n�o foi encontrado. A importa��o ser� abortada!"," - ATENCAO")
	Return
EndIf

FT_FUSE(_cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()

While !FT_FEOF()
	
	cLinha := FT_FREADLN()
	If cLinha == "        " .OR. cLinha = NIL
		ALERT("Fim de arquivo!")
		FT_FUSE()
		Return
	EndIf
	lOK := .F.
	aCampos := StrToKArr2(cLinha,";",.T.)
	
	If !(ALLTRIM(aCampos[1]) == "Serie")
		dbSelectArea("CDL")
		dbSetOrder(2)
		DbGoTop()
		
		IF CDL->(dbSeek(xFilial("CDL")+PADR(aCampos[6],9)+PADR(aCampos[1],3)+aCampos[2]+aCampos[3]+aCampos[7]))
			Begin Transaction
			Reclock("CDL",.F.)
			CDL_NUMDE	:= aCampos[10]
			CDL_DTDE	:= CTOD(aCampos[11])
			CDL_NATEXP	:= aCampos[12]
			CDL_NRREG	:= aCampos[13]
			CDL_INDDOC	:= aCampos[09] 
			CDL_DTREG	:= CTOD(aCampos[14])
			CDL_CHCEMB	:= aCampos[15]
			CDL_DTCHC	:= CTOD(aCampos[16])
			CDL_DTAVB	:= CTOD(aCampos[17])
			CDL_TPCHC	:= aCampos[18]
			CDL_PAIS	:= aCampos[19]
			CDL_CHVEXP	:= aCampos[20]
			CDL->(MsUnlock())
			End Transaction
			_nRegA++
		EndIf
		_nReg++
	Endif
	FT_FSKIP()
	aCampos := {}
EndDo


 
FT_FUSE()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSFISR004 �Autor  �Ivandro Santos      � Data �  28/04/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que importar� as informa��es de notas fiscai de ex-���
���          �porta��o para o usu�rio exportar os dados para tabela CDL   ���
�������������������������������������������������������������������������͹��
���Uso       � RFISA004                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MSFISR004()


If Select("QRCDL") > 0
	DbSelectArea("QRCDL")
	DbCloseArea()
EndIf

_cQuery := "SELECT CDL_SERIE,CDL_CLIENT,CDL_LOJA,D2_CF,F2_EMISSAO,CDL_DOC,CDL_ITEMNF,CDL_PRODNF,CDL_INDDOC,CDL_NUMDE,CDL_DTDE,CDL_NATEXP,CDL_NRREG,CDL_DTREG "+_CLRF
_cQuery += "	,CDL_CHCEMB,CDL_DTCHC,CDL_DTAVB,CDL_TPCHC,SUBSTRING(A1_CODPAIS,2,3) 'CDL_PAIS',F2_CHVNFE "+_CLRF
_cQuery += "FROM "+RetSQLName("SF2")+" SF2 "+_CLRF
_cQuery += "INNER JOIN "+RetSQLName("SA1")+" SA1 ON "+_CLRF
_cQuery += "	A1_COD+A1_LOJA = F2_CLIENT+F2_LOJA "+_CLRF
_cQuery += "	AND SA1.D_E_L_E_T_ = '' "+_CLRF
_cQuery += "	AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+_CLRF					
_cQuery += "INNER JOIN "+RetSQLName("SD2")+" SD2 ON "+_CLRF
_cQuery += "	D2_SERIE+D2_CLIENTE+D2_LOJA+D2_DOC = F2_SERIE+F2_CLIENTE+F2_LOJA+F2_DOC "+_CLRF
_cQuery += "	AND SD2.D_E_L_E_T_ = '' "+_CLRF
_cQuery += "	AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "+_CLRF
_cQuery += "INNER JOIN "+RetSQLName("CDL")+" CDL ON  "+_CLRF
_cQuery += "	CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_DOC+CDL_ITEMNF = D2_SERIE+D2_CLIENTE+D2_LOJA+D2_DOC+D2_ITEM "+_CLRF
_cQuery += "	AND CDL.D_E_L_E_T_ = '' "+_CLRF
_cQuery += "	AND CDL.CDL_FILIAL = '"+xFilial("CDL")+"' "+_CLRF
_cQuery += "WHERE "+_CLRF
_cQuery += "	F2_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "+_CLRF
_cQuery += "	AND D2_CF IN ('7101','7127','7501') "+_CLRF
_cQuery += "	AND SF2.D_E_L_E_T_ = '' "+_CLRF
_cQuery += "	AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' "+_CLRF
_cQuery += "	AND F2_TIPO = 'N' "+_CLRF

TcQuery _cQuery New Alias "QRCDL"

MSFISE004()
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MSFISE004 �Autor  �Microsiga           � Data �  28/04/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � GERA PLANILHA XML                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RFISA004                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MSFISE004()
Local oExcel	:= FWMSEXCEL():New()

oExcel:AddWorkSheet("EXPORTA��O")
oExcel:AddTable ("EXPORTA��O","NOTAS")
oExcel:AddColumn("EXPORTA��O","NOTAS","Serie"		 ,2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Cliente"	 ,2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Loja",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Cod_Fiscal",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Emissao",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Num_Nota",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Item_Nf",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Produto",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Tipo_Doc",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Num_Dec",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Dt_Declaracao",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Nat_Exportacao",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Nr_Registro",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Dt_Registro",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Nr_conhecimento",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Data_Conhec",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Data_Averb",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Tipo_Conhec",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Cod_Pais",2,1,.F.)
oExcel:AddColumn("EXPORTA��O","NOTAS","Chv_Nfe",2,1,.F.)

DbSelectArea("QRCDL")
QRCDL->(DbGoTop())

If Select("QRCDL") > 0
	QRCDL->(DBGotop())
	Do While !QRCDL->(Eof())
		oExcel:AddRow("EXPORTA��O","NOTAS" ,{	QRCDL->CDL_SERIE,;
		QRCDL->CDL_CLIENT,;
		QRCDL->CDL_LOJA,;
		QRCDL->D2_CF,;
		QRCDL->F2_EMISSAO,;
		QRCDL->CDL_DOC,;
		QRCDL->CDL_ITEMNF,;
		QRCDL->CDL_PRODNF,;
		QRCDL->CDL_INDDOC,;
		QRCDL->CDL_NUMDE,;
		STOD(QRCDL->CDL_DTDE),;
		QRCDL->CDL_NATEXP,;
		QRCDL->CDL_NRREG,;
		STOD(QRCDL->CDL_DTREG),;
		QRCDL->CDL_CHCEMB,;
		STOD(QRCDL->CDL_DTCHC),;
		STOD(QRCDL->CDL_DTAVB),;
		QRCDL->CDL_TPCHC,;
		QRCDL->CDL_PAIS,;
		QRCDL->F2_CHVNFE})
		
		QRCDL->(DbSkip())
	EndDo
Endif


oExcel:Activate()
oExcel:GetXMLFile("C:/RELATO_MICROSIGA/EXPORTASPED.xml")

If File("C:/RELATO_MICROSIGA/EXPORTASPED.xml")
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open("C:/RELATO_MICROSIGA/EXPORTASPED.xml")
	oExcelApp:SetVisible(.T.)
EndIf

Return
