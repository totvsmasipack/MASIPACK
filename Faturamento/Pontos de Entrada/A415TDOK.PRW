#include "rwmake.ch" 
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ A415TDOK    ºAutor  ³Aparecida F.Stevanato       10/03/2007º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.       Grava Caracteristicas do produto (SZJ) - Copia do Orcamento ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function A415TDOK()

Local I
Private _cUsuario  := RetCodUsr()
Private _aUsuario  := {}
Private _cDeptoUsu := ""
Private _lRet      := .T. 
Private aSZJ       := {}
Private I          := 0

   If cEmpAnt $ '01|10'

      PswOrder(1)
      If PswSeek(_cUsuario,.T.)                                                                  
         _aUsuario := PswRet()
         _cDeptoUsu := Upper(Alltrim(_aUsuario[1][12]))
      EndIf

      //Alert("A415TDOK") 

      If _cDeptoUsu == "COMERCIAL" .And. Empty(M->CJ_MSCOR)
         apmsgStop("Por favor informe a cor predominante da maquina") 
         _lRet := .F.
      Else  
         If SubStr(cNumEmp,1,2) $ "01_10" // MASIPACK
            If SCJ->CJ_NUM <> M->CJ_NUM  .And. !Inclui
               DbSelectArea("SZJ")
               SZJ->(dbSetOrder(1))
               If ! SZJ->(dbSeek(xFilial("SZJ")+M->CJ_NUM))
                  If SZJ->(dbSeek(xFilial("SZJ")+SCJ->CJ_NUM))
                     Do While ! SZJ->(Eof()) .And. SZJ->ZJ_NUM == SCJ->CJ_NUM 
                        AADD(ASZJ,{SZJ->ZJ_ITEM,SZJ->ZJ_PRODUTO,SZJ->ZJ_FPROD,SZJ->ZJ_DIMENSA, SZJ->ZJ_MODEMB,SZJ->ZJ_PESOVOL,SZJ->ZJ_MATEMB,SZJ->ZJ_DIMEMB,SZJ->ZJ_RENDESP,SZJ->ZJ_EMPACOT,SZJ->ZJ_PASSO,SZJ->ZJ_FALIM,SZJ->ZJ_DIMALIM,SZJ->ZJ_FILLARG,SZJ->ZJ_FILMIN})
                        SZJ->(DbSkip())
                     EndDo
                     For I = 1 to Len(aSZJ)
                        RecLock("SZJ",.T.)
                        SZJ->ZJ_FILIAL  := "01" 
                        SZJ->ZJ_NUM     := M->CJ_NUM 
                        SZJ->ZJ_ITEM    := aSZJ[I][1] 
                        SZJ->ZJ_PRODUTO := aSZJ[I][2] 
                        SZJ->ZJ_FPROD   := aSZJ[I][3]
                        SZJ->ZJ_DIMENSA := aSZJ[I][4]
                        SZJ->ZJ_MODEMB  := aSZJ[I][5]
                        SZJ->ZJ_PESOVOL := aSZJ[I][6]
                        SZJ->ZJ_MATEMB  := aSZJ[I][7]
                        SZJ->ZJ_DIMEMB  := aSZJ[I][8]
                        SZJ->ZJ_RENDESP := aSZJ[I][9]
                        SZJ->ZJ_EMPACOT := aSZJ[I][10]
                        SZJ->ZJ_PASSO   := aSZJ[I][11]
                        SZJ->ZJ_FALIM   := aSZJ[I][12]
                        SZJ->ZJ_DIMALIM := aSZJ[I][13]
                        SZJ->ZJ_FILLARG := aSZJ[I][14]
                        SZJ->ZJ_FILMIN  := aSZJ[I][15]
                        SZJ->(MsUnLock())   
                     Next I    
                  EndIf   
               EndIf
            EndIf   
         EndIf
      EndIf 
   
   Endif

Return _lRet