#Include "Topconn.ch"
#Include "Rwmake.ch"

User Function RCOMA004()

   SetPrvt("CCADASTRO,ACAMPOS,AROTINA,DDTENT,")

   cCadastro := "Alteração da Apropriação - SC1"
   aRotina   := { {"Pesquisa",     "AxPesqui",           0, 1 },;
                  {"Visualiza",    "AxVisual",           0, 2 },;
                  {"Altera",     'ExecBlock("MSALTERA")', 0, 3 } } 

   mBrowse(8,03,20,75,"SC1",,,,)

Return

User Function MSALTERA()

   cC1APROP   := SC1->C1_MSAPROP 

   @ 0,0 TO 250,450 DIALOG oDlg1 TITLE "Dados Complementares da SC"
   @ 10,10  SAY "Solicitação   : " + SC1->C1_NUM
   @ 30,10  SAY "Apropriação   : "
   @ 30,65  GET cC1APROP    PICTURE "@!S40" SIZE 150,200
   @ 100,80  BUTTON "_Ok"   SIZE 35,15 ACTION MSGRAVA()
   @ 100,130 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)
   ACTIVATE DIALOG oDlg1 CENTER

Return

Static Function MSGRAVA()  

   RecLock("SC1",.F.)
   SC1->C1_MSAPROP:= cC1APROP
   MsUnlock()
   Close(oDlg1)

Return(.T.)                
