#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFENTRADA ºAutor  ³Aparecida de F.Stevanato Dt. ³21/09/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para impressao de notas fiscais de entrada.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NFENTRADA() 

Private Tamanho := "G"
Private cNFIni  := ""
Private dDtEmi  := CTOD("")

//Inicializa Variaveis
nLastKey   := 0                       
aReturn    := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
_cNomeProg := "NFENTRADA" 
_cString   := ""
//_cPerg     := "NFENTR" + Space(4)
_cTitulo   := "IMPRESSAO DE NOTA FISCAL DE ENTRADA"
_cDesc1    := "Este programa tem por objetivo a impressao das notas fiscais"
_cDesc2    := "de entrada da empresa Masipack, conforme os parametros  infor-"
_cDesc3    := "mados pelo usuario.

cNomeProg := "NFENTRADA" 
wnrel     := "NFENTRADA" 
cPerg     := "NFENTRADA "
cString   := ""
Titulo   := "IMPRESSAO DE NOTA FISCAL DE ENTRADA"
cDesc1    := "Este programa tem por objetivo a impressao das notas fiscais"
cDesc2    := "de entrada da empresa Masipack, conforme os parametros  infor-"
cDesc3    := "mados pelo usuario.
tamanho   := "P"

Pergunte(cPerg,.F.)

cNFIni := StrZero(Val(mv_par01) - 10,6) + Space(3)

If Select("QR1") > 0 
   DbSelectArea("QR1")
   DbCloseArea()
EndIf 

_cQuery := "SELECT F3_EMISSAO, F3_NFISCAL, F3_SERIE, F3_CFO, F3_SERIE, F3_FORMUL "
_cQuery += "FROM " + RetSqlName("SF3") + " F3 "
_cQuery += "WHERE F3_FILIAL = '" + xFilial("SF3") + "' "
_cQuery += "  AND F3_SERIE = '" + mv_par03 + "' "
_cQuery += "  AND F3_NFISCAL > '" + cNFIni + "' AND F3_NFISCAL < '" + mv_par01 + "' "
_cQuery += "  AND (F3_FORMUL = 'S' OR F3_CFO > 500) "  
_cQuery += "  AND D_E_L_E_T_ = ' ' "
_cQuery += "ORDER BY F3_NFISCAL " 

//DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
TcQuery _cQuery New Alias "QR1"

Do While ! QR1->(Eof()) 
   dDtEmi := STOD(QR1->F3_EMISSAO) 
   QR1->(DbSkip())
EndDo 

QR1->(dbClosearea())  // LIZANDRA 09/04/13

//Chamada para a Setprint
//wnrel := SetPrint(_cString,_cNomeProg,_cPerg,@_cTitulo,_cDesc1,_cDesc2,_cDesc3,.F.,,.F.,Tamanho)
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2, cDesc3,.F.,,.F.,Tamanho)

//Verifica se foi cancelada a impressao
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,_cString)

//Verifica se foi cancelada a impressao
If nLastKey == 27
   Return
Endif

//Chamada para funcao principal do programa
RptStatus({|| RptDetail()})

Set Device To Screen

If aReturn[5] == 1
   Set Printer To
   DbcommitAll()
   OurSpool(wnrel)
Endif

Ms_Flush()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RptDetail ºAutor  ³Paulo Moreto        º Data ³28/12/2001   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montagem de Lay-Out e impressao da nota fiscal              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Masipack                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RptDetail()

Local _aCab   , _aItens , _aCliFor, _aLetIpi, I
Local _nI     , _nExt   , _nIOld  , _nTamdesc , _nDesc , _nMens , _nTamMens
Local _cCfo   , _cTexto , _cDescPro , _cCampo 
Local _nImp    := .t.
Local aMens    := {}
Local cNota    := "" 
Local cCodMens := ""
Local cMenSZO  := ""
Local nItem    := 0
Local nMens    := 0
Local cItemAnt := 0 
Local cUF      := ""

mv_par04 := Alltrim(mv_par04)

SF1->(DbSetOrder(1))
SA1->(DbSetOrder(1))
SA2->(DbSetOrder(1))
              
//If SF1->(DbSeek(xFilial()+mv_par01)) 
If SF1->(DbSeek(xFilial("SF1")+Padr(mv_par01,9)+mv_par03))

Do While !SF1->(Eof()) .And. SF1->F1_DOC <= mv_par02
   If Alltrim(SF1->F1_ESPECIE) <> "SPED"
      Alert("*** ATENÇÃO, Especie da Nota Fiscal incoerente (SPED)")
      Return
   EndIf
   If Alltrim(SF1->F1_EST) == "EX" .And. Empty(SF1->F1_TRANSP)
      If ! MsgBox("ATENÇÃO, N.Fiscal de Importação sem Transportadora, Continua? ","AVISO","YESNO")
         Return
      EndIf   
    EndIf 
    
    If SF1->F1_MSIMPR == "S" .And.(aReturn[5] == 2 .OR. aReturn[5] == 3)
       If ! MsgBox("*** ATENÇÃO, N.Fiscal já foi impressa. Deseja reimprimí-la ***","AVISO","YESNO")
          Return
       EndIf
    Endif 
    
    If AllTrim(SF1->F1_FORMUL) <> "S"
       SF1->(DbSkip())                   
       Loop
    Endif
    
    If AllTrim(SF1->F1_SERIE) <> AllTrim(mv_par03)
       SF1->(DbSkip())
       Loop
    Endif 
    
    If SF1->F1_EMISSAO < dDtEmi
       Alert("*** ATENÇÃO, Data de Emissão incoerente com Ultima Nota Emitida, Espelho da N.Fiscal não será emitido ***","Escape")
       Return
    EndIf  
    
    If SF1->F1_TIPO $ "DB"
       //Cliente
       SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
       cUF := SA1->A1_EST
    Else
       //Fornecedor
       SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
       cUF := SA2->A2_EST
    EndIf        
     
    //Inicia Matriz com dados do cabecalho da nota
    _aCab    := {}
    
    Aadd(_aCab,SF1->F1_DOC     )  //Numero da nota     [01]
    Aadd(_aCab,SF1->F1_EMISSAO )  //Emissao da nota    [02]
    Aadd(_aCab,SF1->F1_BASEICM )  //Valor base do ICMS [03]
    Aadd(_aCab,SF1->F1_VALICM  )  //Valor do ICMS      [04]
    Aadd(_aCab,SF1->F1_VALIPI  )  //Valor do IPI       [05]
    Aadd(_aCab,SF1->F1_FRETE   )  //Valor do frete     [06]
    Aadd(_aCab,SF1->F1_SEGURO  )  //Valor do Seguro    [07]
    Aadd(_aCab,SF1->F1_VALMERC )  //Total dos produtos [08]
    Aadd(_aCab,SF1->F1_VALBRUT )  //Total da nota      [09]
    Aadd(_aCab,SF1->F1_PBRUTO  )   //Peso Bruto na nota [10]
    Aadd(_aCab,SF1->F1_PLIQUI  )   //Peso Liq. na nota  [11]
    Aadd(_aCab,SF1->F1_ESPECI1 )   //Especie do volume  [12]
    Aadd(_aCab,SF1->F1_VOLUME1 )   //Volume na nota     [13] 
        
    //Inicia Matriz com dados dos itens da nota
    
    _aItens  := {}
    _aCfo    := {}
    
    //Alimenta matriz dos itens
    DbSelectArea("SD1")
    SD1->(DbSetOrder(1))
    DbSeek(xFilial("SD1")+ SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA,.t.)
    
    //Variaveis para tratamento de mais de um cfop na mesma nota
    _cCfo   := ""
    _cTexto := ""
    nItem   := 0
    aMens   := {}
    
    While xFilial("SD1") == SD1->D1_FILIAL .And. SD1->D1_DOC == SF1->F1_DOC .And. ;
       SD1->D1_SERIE == SF1->F1_SERIE .And. !Eof()
       
       cNota := ""
       nItem++ 
       
       If !Empty(SD1->D1_NFORI)
          SF2->(DbSetOrder(1))
          If SF2->(DbSeek(xFilial("SF2")+SD1->D1_NFORI))
             If Empty(cNota)
                cNota := " REF. NF. " + SD1->D1_NFORI + " - " + DTOC(SF2->F2_EMISSAO) 
             Else    
                cNota += "/" + SD1->D1_NFORI + " - " + DTOC(SF2->F2_EMISSAO)
             EndIf   
          Endif
       EndIf
       _lNotDev  := .t.
       _cDescPro := ""
       
       DbSelectArea("SB1")
       DbSetorder(1)
       DbSeek(xFilial("SB1")+ SD1->D1_COD,.t.)
             
       DbSelectArea("SF4")
       DbSetOrder(1)
       DbSeek(xFilial("SF4")+ SD1->D1_TES,.t.)
               
       DbSelectarea("SB5")
       DbSetOrder(1)

       //Ivandro Santos - 06/04/17 - início da alteração
	   //Ticket#2017031037000107 — Equalização dos campos de descrição do produto (Masipack e Fabrima)
       //Se existir descricao no complemento do produto
       If DbSeek(xFilial("SB5") + SD1->D1_COD,.t.)
          _cDescpro := ALLTRIM(SB5->B5_CEME)
       Endif
       If Empty(Alltrim(_cDescPro))
          _cDescPro := ALLTRIM(SB1->B1_DESC)
       EndIf

       //Se existir descricao estendida no cadastro
       /*If Alltrim(_cDescPro) == ""
          If !Empty(SB1->B1_DESCP)
             _cDescPro := ALLTRIM(SB1->B1_DESCP)
          Else   
             _cDescPro := ALLTRIM(SB1->B1_DESC)
          EndIf   
       EndIf*/
       //Ticket#2017031037000107 — Fim da alteração
                      
       Aadd(_aItens,{SD1->D1_COD  ,_cDescPro     ,SB1->B1_POSIPI ,SD1->D1_CLASFIS,;
                      SD1->D1_UM   ,SD1->D1_QUANT,SD1->D1_VUNIT ,SD1->D1_TOTAL ,;
                      SD1->D1_PICM ,SD1->D1_IPI  ,SD1->D1_VALIPI ,SD1->D1_CF    ,;
                      SD1->D1_NFORI,SD1->D1_SERIORI})
               
      If Len(_aCfo) > 0                                                        
          If !Empty(SF4->F4_MEN)
             If ( Ascan( _aCfo ,SF4->F4_MEN )) == 0
                Aadd(_aCfo,SF4->F4_MEN)
             Endif
          Endif
       Else
          If !Empty(SF4->F4_MEN)          
             Aadd(_aCfo,SF4->F4_MEN)
          Endif
       Endif
       
       If !Empty(SF4->F4_MEN)
          AADD (aMens,{Alltrim(SF4->F4_MEN),StrZero(nItem,2)})
       EndIf   
      
       //Tratamento para mais de um cfop na mesma nota
       If _cCfo == ""
          _cCfo   := Alltrim(SD1->D1_CF)
          _cTexto := Alltrim(SF4->F4_DESCRIC)
       Else
          If Alltrim(SD1->D1_CF) $ _cCfo
            _cCfo := _cCfo
          Else
            _cCfo   := _cCfo+"/"+Alltrim(SD1->D1_CF) 
            _cTexto := _cTexto+"/"+Alltrim(SF4->F4_DESCRIC)
          Endif
       Endif
       
       // Mensagens da Nota Fiscal
       If Alltrim(cUF) <> "EX"
	      SB1->(DbSetorder(1))
       	  SB1->(DbSeek(xFilial("SB1")+ SD1->D1_COD))
          SYD->(dbSetOrder(1))
	      If SYD->(dbSeek(xFilial("SYD")+SB1->B1_POSIPI))
	         If !Empty(SYD->YD_MENS1)
	   	        cCodMens := Alltrim(SYD->YD_MENS1)
	   	        AADD(aMens,{cCodMens,StrZero(nItem,2)})
	   	     EndIf
             If !Empty(SYD->YD_MENS2)
                cCodMens := Alltrim(SYD->YD_MENS2) 
                If cCodMens == "102" .And. (cUF <> "SP" .Or. SD1->D1_PICM == 0)
	   	           cCodMens := "" 
	   	        Else 
	   	           //If cCodMens <> "102" .Or. (cCodMens == "102" .And. cUF == "SP" .And. SF1->F1_TIPO == "N") // .And. cTpOper <> "9")
                   AADD(aMens,{cCodMens,StrZero(nItem,2)})
                   //EndIf   
                EndIf   
             EndIf   
	         If !Empty(SYD->YD_MENS3)
	  	        cCodMens := Alltrim(SYD->YD_MENS3)
	  	        If cCodMens == "103" .And. SD1->D1_PICM == 0
	   	           cCodMens := "" 
	   	        Else  
	  	           AADD(aMens,{cCodMens,StrZero(nItem,2)})
                EndIf   
             EndIf 
          EndIf   
       EndIf
       DbSelectArea("SD1")  
       SD1->(DbSkip())
    EndDo
 
    //Inicia matriz com dados do cliente / fornecedor
    _aCliFor := {}

    //Verifica se a nota e para cliente ou fornecedor
    If SF1->F1_TIPO $ "DB"
       //Cliente
       SA1->(DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
       Aadd(_aCliFor,SA1->A1_NOME   )  //Nome do cliente   [01]
       Aadd(_aCliFor,SA1->A1_CGC    )  //CNPJ/CPF          [02]
       Aadd(_aCliFor,SA1->A1_END    )  //Endereco          [03]
       Aadd(_aCliFor,SA1->A1_BAIRRO )  //Bairro            [04]
       Aadd(_aCliFor,SA1->A1_CEP    )  //CEP               [05]
       Aadd(_aCliFor,SA1->A1_MUN    )  //Municipio         [06]
       Aadd(_aCliFor,SA1->A1_TEL    )  //Telefone          [07]
       Aadd(_aCliFor,SA1->A1_FAX    )  //FAX               [08]
       Aadd(_aCliFor,SA1->A1_EST    )  //Estado            [09]
       Aadd(_aCliFor,SA1->A1_INSCR  )  //Incricao Estadual [10]    
       Aadd(_aCliFor,SA1->A1_ENDCOB )  //Endereco de Cob   [11]
    Else
       SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
       Aadd(_aCliFor,SA2->A2_NOME   )  //Nome do fornec.   [01]
       Aadd(_aCliFor,SA2->A2_CGC    )  //CNPJ/CPF          [02]
       Aadd(_aCliFor,SA2->A2_END    )  //Endereco          [03]
       Aadd(_aCliFor,SA2->A2_BAIRRO )  //Bairro            [04]
       Aadd(_aCliFor,SA2->A2_CEP    )  //CEP               [05]
       Aadd(_aCliFor,SA2->A2_MUN    )  //Municipio         [06]
       Aadd(_aCliFor,SA2->A2_TEL    )  //Telefone          [07]
       Aadd(_aCliFor,SA2->A2_FAX    )  //FAX               [08]
       Aadd(_aCliFor,SA2->A2_EST    )  //Estado            [09]
       Aadd(_aCliFor,SA2->A2_INSCR  )  //Incricao Estadual [10]
       Aadd(_aCliFor," ")              //                  [11]  // compatibilidade para a matriz ficar com 11 elementos
    Endif 
      
    //Inicia a Impressao da nota atual
    _nLi := 003
    @ _nLi , 092 Psay "X"
    //@ _nLi , 106 Psay _aCab[01]
    _nLi+=5
    @ _nLi , 002 Psay _cTexto
   
    If Len(Alltrim(_cCfo)) > 4
       @ _nLi , 054 Psay _cCfo
    Else
       @ _nLi , 057 Psay _cCfo
    Endif
    
    _nLi+=3
    @ _nLi , 002 Psay _aCliFor[01]
    @ _nLi , 082 Psay _aCliFor[02] Picture "@R 99.999.999/9999-99"
    @ _nLi , 104 Psay _aCab[02]
    _nLi+=2    
    @ _nLi , 002 Psay _aCliFor[03]
    @ _nLi , 062 Psay _aCliFor[04]
    @ _nLi , 091 Psay _aCliFor[05] Picture "@R 99999-999" 
    _nLi+=2
    @ _nLi , 002 Psay _aCliFor[06]
    @ _nLi , 035 Psay _aCliFor[07]
    @ _nLi , 055 Psay _aCliFor[08]
    @ _nLi , 080 Psay _aCliFor[09]
    @ _nLi , 084 Psay _aCliFor[10]
    _nLi+=3 
    
    _nExt := 1
       
    // Compressao de caractere de impressao    
    @ _nLi , 000 Psay Chr(15)
    
    If !Empty(SF1->F1_DUPL)               //Se a nota possuir duplicatas
       DbSelectArea("SE2")
       DbSetOrder(1)    
       If SE2->(DbSeek(xFilial("SE2")+SF1->F1_SERIE+SF1->F1_DUPL))
          @ _nLi , 002 Psay Alltrim(SE2->E2_NUM) + "/" + SE2->E2_PARCELA
          @ _nLi , 015 Psay SE2->E2_VENCTO
          @ _nLi , 025 Psay SE2->E2_VALOR Picture "@E 9,999,999.99"
          @ _nLi , 094 Psay Substr(Rtrim(Substr(Extenso(SE2->E2_VALOR),_nExt,029)) + Replicate("*",29),1,29)
          For _nI := 2 to 5
              _nExt+=29
              _nLi++
              @ _nLi , 094 Psay Substr(Rtrim(Substr(Extenso(SE2->E2_VALOR),_nExt,042)) + Replicate("*",42),1,42)
          Next _nI   
       EndIf   
    Else
       For _nI := 1 to 5
           @ _nLi , 094 Psay Substr(Rtrim(Substr(Extenso(_aCab[9]),_nExt,042)) + Replicate("*",42),1,42)
           _nExt+=29
           _nLi++
       Next _nI      
    EndIf
   _nLi := 25
    
    _nLi++
    _nImp := .t.
     
    //ASORT(_aItens,,,{ |x, y| x[12] + x[14] < y[12] + y[14] })    
    //ASORT(_aItens,,,{ |x, y| x[12] < y[12] }) 
    
    For _nI := 1 to Len(_aItens)
        @ _nLi , 002 Psay Alltrim(_aItens[_nI,01])
        @ _nLi , 018 Psay Substr(_aItens[_nI,02],1,90)                                      // Descrição 	
        @ _nLi , 109 Psay _aItens[_nI,12]  
        @ _nLi , 114 Psay _aItens[_nI,03]
        @ _nLi , 124 Psay _aItens[_nI,04]
        @ _nLi , 129 Psay _aItens[_nI,05]
        @ _nLi , 132 Psay _aItens[_nI,06] Picture "@E 999,999.99"
        @ _nLi , 142 Psay _aItens[_nI,07] Picture "@E 99,999,999.9999"
        @ _nLi , 160 Psay _aItens[_nI,08] Picture "@E 99,999,999.99"
        @ _nLi , 176 Psay _aItens[_nI,09] Picture "99"
        @ _nLi , 180 Psay _aItens[_nI,10] Picture "99.99"
        @ _nLi , 184 Psay _aItens[_nI,11] Picture "@E 9,999,999.99"
        _nLi++
        _nTamdesc := Len(_aItens[_nI,02])
          
        If _nTamdesc > 90
           _nDesc := 91
           While .t.
              If _nTamDesc > _nDesc
                 @ _nLi , 018 Psay Substr(_aItens[_nI,02],_nDesc,90)
                 _nLi++
                 _nDesc+=90
              Else
                 Exit
              Endif
           EndDo
        Endif
    Next _nI 
     
    _nLi := 45
    
    // Descompressao de caractere de impressao    
    @ _nLi , 000 Psay Chr(18)
    
    _nLi++

    @ _nLi , 007 Psay _aCab[03] Picture "@E 999,999,999.99"  
    @ _nLi , 030 Psay _aCab[04] Picture "@E 999,999,999.99"  
    @ _nLi , 098 Psay _aCab[08] Picture "@E 999,999,999.99"  
    _nLi+=2                                
    @ _nLi , 007 Psay _aCab[06] Picture "@E 999,999,999.99"  // Frete
    @ _nLi , 030 Psay _aCab[07] Picture "@E 999,999,999.99"  
    @ _nLi , 075 Psay _aCab[05] Picture "@E 999,999,999.99"  
    @ _nLi , 098 Psay _aCab[09] Picture "@E 999,999,999.99"  
       
    _nLi += 3
    // Se a nota possuir transportadora
    SA4->(DbSetOrder(1))
    If !Empty(SF1->F1_TRANSP)
       If SA4->(DbSeek(xFilial("SA4")+Alltrim(SF1->F1_TRANSP)))
          @ _nLi , 002 Psay SA4->A4_NOME
   	      @ _nLi , 074 Psay "1"       
   	      
          If !Empty(SA4->A4_CGC)
             @ _nLi , 093 Psay SA4->A4_CGC Picture "@R 99.999.999/9999-99"
          EndIf   
          _nLi+=2
          @ _nLi , 002 Psay SA4->A4_END 
          @ _nLi , 062 Psay SA4->A4_MUN
          @ _nLi , 088 Psay SA4->A4_EST
          @ _nLi , 093 Psay SA4->A4_INSEST
       EndIf   
    EndIf
    
    _nLi := 55
        
    If _aCab[13] > 0
       @ _nLi , 002 Psay _aCab[13]
    Endif
    
    @ _nLi , 012 Psay _aCab[12]
    @ _nLi , 083 Psay _aCab[10] Picture "@E 99,999,999.99"  
    @ _nLi , 098 Psay _aCab[11] Picture "@E 99,999,999.99"  

    // Compressao de caractere de impressao    
    @ _nLi , 000 Psay Chr(15)
    
     //Grava arquivo (SZO) com as mensagens da nota fiscal
    
    cCodMens := ""
    cMensSZO := ""
    SZO->(DbSetOrder(1))
    If !SZO->(DbSeek(xFilial("SZO")+SF1->F1_SERIE+SF1->F1_DOC))
       If !Empty(cNota)
          cMensSZO := cNota + " " 
       EndIf   
       If !Empty(mv_par04)
          cMensSZO += mv_par04
       EndIf   
       RecLock("SZO",.T.)
       SZO->ZO_FILIAL  := "01"
       SZO->ZO_SERIE   := SF1->F1_SERIE
	   SZO->ZO_NFISCAL := SF1->F1_DOC
	   SZO->ZO_MENS    := Alltrim(cMensSZO)
	   SZO->ZO_DATA    := SF1->F1_EMISSAO
	   SZO->ZO_IMPR    := "N"
	   SZO->(MsUnlock())
	   If Len(aMens) > 0
          ASORT(aMens,,,{ |x, y| x[1]+x[2] < y[1]+y[2] })
	      cCodMens := ""
	      For I := 1 to Len(aMens)
	          If aMens[I][1] <> cCodMens
	             cCodMens := Alltrim(aMens[I][1])
	             SM4->(dbSetOrder(1))
		         If SM4->(dbSeek(xFilial("SM4")+cCodMens))
			        cMensSZO := " " + Alltrim(SM4->M4_FORMULA) + "-Item(s):" + aMens[I][2]
			        SZO->(DbSeek(xFilial("SZO")+SF1->F1_SERIE+SF1->F1_DOC))
			        RecLock("SZO",.F.)
			        SZO->ZO_MENS := Alltrim(SZO->ZO_MENS) + cMensSZO
			        SZO->(MsUnlock())   
			     EndIf   
	             cItemAnt := Alltrim(aMens[I][2])
	             //Alert("Mensagem: "+ cCodMens+ "-"+cMensSZO)
	          Else
	             If cItemAnt <> aMens[I][2]
	                SZO->(DbSeek(xFilial("SZO")+SF1->F1_SERIE+SF1->F1_DOC))
			        RecLock("SZO",.F.)
			        SZO->ZO_MENS := SZO->ZO_MENS + "/" + aMens[I][2]
			        SZO->(MsUnlock())
			        cItemAnt := aMens[I][2]
			     EndIf   
	          EndIf
	      Next
	      SZO->(DbSeek(xFilial("SZ0")+SF1->F1_SERIE+SF1->F1_DOC))
	      nTamMens := Len(Alltrim(SZO->ZO_MENS))
	      If nTamMens > 910
	         apmsgStop("Mensagens da Nota Fiscal ultrapassa o limite de impressão, Corrija e re-imprima")
	         //If aReturn[5] == 2 .OR. aReturn[5] == 3
	            RecLock("SF1",.F.)
                SF1->F1_MSIMPR := "S"
	            SF1->(MsUnLock()) 
	            RecLock("SZO",.F.)
                SZO->ZO_IMPR := "S"
	            SZO->(MsUnLock()) 
	         //EndIf
	         Return
	      EndIf   
	   EndIf 
	Else
	   apmsgStop("Mensagens da Nota Fiscal criada anteriormente - Verifique")     
	EndIf
        
    // Mensagens da Nota Fiscal 
    
    _nLi  := 57
    nMens := 0
    If !Empty(Alltrim(MEMOLINE(SZO->ZO_MENS,130,1)))
       cMensSZO := Alltrim(MEMOLINE(SZO->ZO_MENS,130,1))
       @ _nLi,002 Psay cMensSZO 
    Else
       If !Empty(cMensSZO)
          @ _nLi,002 Psay cMensSZO 
       Endif     
    EndIf     
    _nLi++ 
    For I := 2 to 7
        If !Empty(Alltrim(MEMOLINE(SZO->ZO_MENS,130,I-nMens)))
           cMensSZO := Alltrim(MEMOLINE(SZO->ZO_MENS,130,I-nMens))
           @ _nLi,002 Psay cMensSZO
        Endif
        _nLi++   
    Next I       
               
    // Descompressao de caractere de impressao    
    @ _nLi , 000 Psay Chr(18)

    _nLi := 68

    _nLi+=4

    @ _nLi , 001 Psay "" 
    
    //Finaliza a impressao da nota atual
   
    //Zera o formulario
    SetPrc(0,0)
     
    // Atualiza flag de impressão da NF se opção for impressora
    
    DbSelectArea("SF1")
    
    RecLock("SF1")
    //If aReturn[5] == 2 .OR. aReturn[5] == 3
       SF1->F1_MSIMPR := "S"
    //EndIf   
	SF1->(MsUnLock()) 
   
    //Avanca para a proxima nota
    
    DbSkip()
EndDo
EndIf

Return
