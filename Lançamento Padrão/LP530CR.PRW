#Include "rwmake.ch"   
#Include "Topconn.ch"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLP530CR   บAutor  ณLizandra            บ Data ณ  13/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para retorno de conta contabil em lancamento padro-บฑฑ
ฑฑบ          ณnizado 530/01. Baixa de titulos. TRATA REEMBOLSO DE PA      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMasipack                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/

User Function LP530CR()         
            
_aArea := GetArea()

M->CT2_ITEMD := ""
M->CT2_ITEMC := ""

If SE5->E5_TIPO="NF ".AND.SE5->E5_MOTBX="LIQ"
	_cConta := "110700004"
ELSEIF Empty(SE5->E5_BANCO).AND.SE5->E5_TIPO ="NF ".AND.(SE5->E5_MOTBX<>"CX1".AND.SE5->E5_MOTBX<>"VAR")
	_cConta := SE5->E5_CREDITO
ELSEIF SE5->E5_MOTBX="CX1"
    _cConta := "110010001"         
ELSEIF SE5->E5_TIPO ="PA ".AND.SE5->E5_MOTBX="DEB"
    _cConta := "110700004"        
ELSEIF SE5->E5_TIPO ="NDF".AND.SE5->E5_MOTBX="DEB"
    _cConta := "110700010"
ELSEIF Empty(SE5->E5_BANCO).AND.SE5->E5_TIPO ="NF ".AND.SE5->E5_MOTBX="VAR"  
    If Alltrim(SubStr(cNumEmp,1,2)) == "01"
    _cConta := "440310001"
    elseif Alltrim(SubStr(cNumEmp,1,2)) == "10"
    _cConta := "440310002"
    else
    _cConta := "" 
    Endif 
ELSE
	_cConta := SA6->A6_CONTA
ENDIF	
	    
RestArea(_aArea)	    

Return(_cConta)
