#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
+---------------------------------------------------------------------------+
|Programa  |LP530HI   |Autor: Elpídio Lima        |Data: 22/11/23           |
+---------------------------------------------------------------------------+
|Desc.     |Historico lançamento padrão    |
+---------------------------------------------------------------------------+
|Uso       |Masipack                                                        |
+---------------------------------------------------------------------------+
*/

User Function LP530HI()         
            
_aArea := GetArea()

Local  cHist := ""

If SE5->E5_MOTBX = "VAR"
    cHist :="VAR. CAMBIAL "+Alltrim(SE5->E5_TIPO)+" "+Alltrim(SE5->E5_PREFIXO)+" - "+Alltrim(SE5->E5_NUMERO)+" - "+SE5->E5_PARCELA+" "+SUBSTR(SA2->A2_NREDUZ,1,8)
Else 
    cHist := IF(SE2->E2_ORIGEM="MATA","PG.NF. ","PG.TIT. ")+SE5->E5_NUMERO+IF(SE5->E5_MOTBX=="LIQ"," LIQ. "+ALLTRIM(SE5->E5_DOCUMEN)," ")+" "+SUBSTR(SE2->E2_NOMFOR,1,9)+" 5301"
EndIf

RestArea(_aArea)	    

Return(cHist)
