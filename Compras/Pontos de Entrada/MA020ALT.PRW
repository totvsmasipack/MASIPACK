#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ MA020ALT  ºAutor  ³                            ³ 14/10/2009º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.Validar os Dados Cadastrais para NFe e Gravar Item Contabil        ±±
±±º 29/08/2011 - Verifica movimentação para todas as empresasr             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function MA020ALT()

Local I := 0

Private _cUsuario := RetCodUsr() 
Private _cDeptoUsu:= ""
Private _aUsuario := {}
Private _lRet     := .T. 
Private _dDtAux   := Date()
Private _nReg     := 0
Private _fEnd     := .T.
Private _aEmp     := {"01","10"}

PswOrder(1)
If PswSeek(_cUsuario,.T.)                                                                  
   _aUsuario  := PswRet()
   _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
EndIf

_dDtAux := Date() - Day(Date()) 

If Altera 
   _nReg := 0
   _fEnd := .T.

   For I := 1 to Len(_aEmp)
       If Select("QR1") > 0 
          DbSelectArea("QR1")                                                                         
          DbCloseArea()
       EndIf 
   
       _cQuery := "SELECT SF1.F1_FORNECE AS F1_FORNECE, SF1.F1_LOJA AS F1_LOJA, SF1.F1_EMISSAO AS F1_EMISSAO, SF1.F1_TIPO AS F1_TIPO FROM SF1" + _aEmp[I] + "0 SF1 "
       _cQuery += "WHERE F1_FILIAL = '" + xFilial("SF1") + "' AND F1_FORNECE = '" + M->A2_COD + "' AND F1_LOJA = '" + M->A2_LOJA + "' AND F1_TIPO IN ('N','I','P','C')" 
       _cQuery += " AND SF1.D_E_L_E_T_ = ' ' " 
     
       //Alert(_cQuery)

       DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
   
       Do While QR1->(!Eof())
          _nReg++
          If QR1->F1_EMISSAO > Dtos(_dDtAux)
             _fEnd := .F.
          EndIf                                                                
          QR1->(DbSkip())
       EndDo
   
       //Alert("SF1: " + Str(_nReg,5))
    
       If _nReg == 0 .Or. _fEnd
          If Select("QR1") > 0 
             DbSelectArea("QR1")                                                                         
             DbCloseArea()
          EndIf
   
          _cQuery := "SELECT SF2.F2_CLIENTE AS F2_CLIENTE, SF2.F2_LOJA AS F2_LOJA, SF2.F2_EMISSAO AS F2_EMISSAO, SF2.F2_TIPO AS F2_TIPO FROM SF2" + _aEmp[I] + "0 SF2 "
          _cQuery += "WHERE F2_FILIAL = '" + xFilial("SF2") + "' AND F2_CLIENTE = '" + M->A2_COD + "' AND F2_LOJA = '" + M->A2_LOJA + "' AND F2_TIPO IN ('D','B')" 
          _cQuery += " AND SF2.D_E_L_E_T_ = ' ' " 
     
          DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
   
          Do While QR1->(!Eof())
             _nReg++
             If QR1->F2_EMISSAO > Dtos(_dDtAux)
                _fEnd := .F.
             EndIf                                                                
             QR1->(DbSkip())
          EndDo      
          //Alert("SF2: " + Str(_nReg,5))
       EndIf
   Next I       

   //Alert(_fEnd)
   // Os campos abaixo nao poderao ser alterados quando houver houver movimento fiscal para o fornecedor
   If SA2->A2_CGC <> M->A2_CGC  .And. !Empty(SA2->A2_CGC)
      apMsgAlert("Alteração - Recadastre")
      _lRet := .F.
   EndIf    
EndIf

If _lRet   
   If M->A2_EST <> "EX"
      If Empty(Alltrim(M->A2_CGC))
         ALERT("Necessário informar o campo CNPJ/CPF")
         _lRet := .F.
      Else
         M->A2_CODPAIS := "01058"
         If Empty(Alltrim(M->A2_INSCR)) .And. Empty(Alltrim(M->A2_INSCRM)) .And. M->A2_TPESSOA == "J"
            Alert("Necessário informar o campo Inscrição Estadual ou Municipal")
           _lRet := .F.
         EndIf   
      EndIf
   Else
      If Empty(Alltrim(M->A2_BAIRRO))
         Alert("Necessário informar o campo Bairro para Exportação")
         _lRet := .F.
      Else
         M->A2_TIPO    := "X"      // para os Fornecedores do Exterior utilizado na geração das informações complementares de importação (NFe)
         M->A2_CGC     := SPACE(14)
         M->A2_INSCR   := SPACE(18)
         M->A2_COD_MUN := "99999"            
         IF SUBSTR(cNumEmp,1,2) <> "15"
	         M->A2_MSHABIL := "HABILITADO"
	      ENDIF   
      EndIf
   EndIf

   IF SUBSTR(cNumEmp,1,2) <> "15"
	   If Substr(M->A2_MSHABIL,1,3) == "NAO"
 	     Alert("Fornecedor com restrição no Sintegra. Cadastro não será efetivado")
  	    _lRet := .F.
  	 Endif
  	ENDIF 

EndIf

If _lRet 
   // Esta rotina estava nos pontos de entrada M020INC e M020ALT (ATU_SA2) no modulo Financeiro
   M->A2_MSDATAC := Date()
  
   If Inclui
      // Esta rotina estava nos pontos de entradas M020INC e M020ALT (ATU_SA2) no modulo Financeiro
      If Alltrim(M->A2_NATUREZ) == "J04"
         M->A2_CONTA := "110700008"
      ElseIf Alltrim(M->A2_NATUREZ) == "K06"
         M->A2_CONTA := "110700009"   
      Else   
	     IF M->A2_EST == "EX"
   		    M->A2_CONTA := "220010002"
	     Else
   		    M->A2_CONTA := "220010001" 
	     EndIf
	  EndIf   
   
      CTD->(dbSetOrder(1))
      CTD->(DbGoTop())
      If !CTD->(DbSeek(xFilial("CTD")+"F"+M->A2_COD))
         RecLock("CTD",.T.)
         CTD->CTD_FILIAL	:=	"01"
         CTD->CTD_ITEM		:=	"F"+M->A2_COD
         CTD->CTD_CLASSE	:=	"2"
         CTD->CTD_DESC01	:=	M->A2_NOME
         CTD->CTD_BLOQ		:=	"2"
         CTD->CTD_DTEXIS	:=	dDataBase   // alterado de Date() para dDataBase
         CTD->CTD_ITLP		:=	"F"+M->A2_COD
         CTD->CTD_CLOBRG	:=	"2"
         CTD->CTD_ACCLVL	:=	"1"
      Else
         RecLock("CTD",.F.)
	     CTD->CTD_DESC01	:=	M->A2_NOME
         CTD->CTD_DTEXIS	:=	dDataBase   // alterado de Date() para dDataBase
      EndIf   
      CTD->(MsUnLock())
   EndIf   
EndIf   
                
RETURN(_lRet)   
