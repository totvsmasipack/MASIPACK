#include "rwmake.ch" 
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ MA080VLD  ºAutor  ³  Cida                     ³ 30/08/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     | Gera Array com os Conjuntos do Pedidos de Venda            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Masipack                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA080VLD()
Local I
   Private _lRet := .T.
   Private _nReg := 0
   Private _aEmp := {"01","10"}
   
   If Inclui .Or. Altera
      Return(_lRet)
   EndIf   
               
   _nReg := 0
   For I := 1 to Len(_aEmp)
       If _nReg > 0
          Exit
       Else
          If Select("QR1") > 0 
             DbSelectArea("QR1")                                                                         
             DbCloseArea()
          EndIf  
             
          _cQuery := "SELECT SD2.D2_TES AS D2_TES FROM SD2" + _aEmp[I] + "0 SD2 "
          _cQuery += "WHERE D2_FILIAL = '" + xFilial("SD2") + "' AND D2_TES = '" + SF4->F4_CODIGO + "'" 
          _cQuery += " AND SD2.D_E_L_E_T_ = ' ' " 
    
          DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
   
          Do While QR1->(!Eof())
             _nReg++            
             QR1->(DbSkip())
          EndDo
          //Alert("SD2: " + Str(_nReg,5))
          
          If _nReg == 0
       
             If Select("QR1") > 0 
                DbSelectArea("QR1")                                                                         
                DbCloseArea()
             EndIf
          
             _cQuery := "SELECT SD1.D1_TES AS D1_TES FROM SD1" + _aEmp[I] + "0 SD1 "
             _cQuery += "WHERE D1_FILIAL = '" + xFilial("SD1") + "' AND D1_TES = '" + SF4->F4_CODIGO + "'" 
             _cQuery += " AND SD1.D_E_L_E_T_ = ' ' " 
  
             //Alert(_cQuery)

             DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
   
             Do While QR1->(!Eof())
                _nReg++                                                                  
                QR1->(DbSkip())
             EndDo
             //Alert("SD1: " + Str(_nReg,5))
          EndIf
          
          If _nReg == 0 .And. SF4->F4_TIPO == "S"
             If Select("QR1") > 0 
                DbSelectArea("QR1")                                                                         
                DbCloseArea()
             EndIf
   
             _cQuery := "SELECT SC6.C6_TES AS C6_TES FROM SC6" + _aEmp[I] + "0 SC6 "
             _cQuery += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_TES = '" + SF4->F4_CODIGO + "'" 
             _cQuery += " AND SC6.D_E_L_E_T_ = ' ' " 
  
             //Alert(_cQuery)

             DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
   
             Do While QR1->(!Eof())
                _nReg++                                                                  
                QR1->(DbSkip())
             EndDo
             //Alert("SC6: " + Str(_nReg,5))
          EndIf 
          
          If _nReg == 0 .And. SF4->F4_TIPO == "E"
             If Select("QR1") > 0 
                DbSelectArea("QR1")                                                                         
                DbCloseArea()
             EndIf
   
             _cQuery := "SELECT SC7.C7_TES AS C7_TES FROM SC7" + _aEmp[I] + "0 SC7 "
             _cQuery += "WHERE C7_FILIAL = '" + xFilial("SC7") + "' AND C7_TES = '" + SF4->F4_CODIGO + "'" 
             _cQuery += " AND SC7.D_E_L_E_T_ = ' ' " 
  
             //Alert(_cQuery)

             DbUseArea( .T., 'TOPCONN', TCGENQRY(NIL, NIL, _cQuery), "QR1", .T., .T.)
   
             Do While QR1->(!Eof())
                _nReg++                                                                  
                QR1->(DbSkip())
             EndDo
             //Alert("SC7: " + Str(_nReg,5))
          EndIf   
            
       EndIf   
   Next I
       
   If _nReg > 0
      apmsgStop("Houve Movimentação para esta TES - Exclusão Invalida")
      _lRet := .F.
   EndIf         
 
 Return(.F.)