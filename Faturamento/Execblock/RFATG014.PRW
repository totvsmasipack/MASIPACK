#Include "Rwmake.ch"
#Include "Topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Programa   RFATG014        Autor Solange Ap.Vezu        Data  25/04/08  ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Descricao  Atualiza os Livros Fiscais de acordo com o SD2               ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function RFATG014(cNFiscal)

Private nFrete := 0
Private nSegur := 0

If SD2->(DbSeek(xFilial("SD2")+cNFiscal)) 
	Alert("SD2 NFiscal "+SD2->D2_DOC)
		Alert("SD2 Cfop "+SD2->D2_CF)
		cColICMS 		:= SF4->F4_LFICM
        cColIPI 		:= SF4->F4_LFIPI
        cEntra 			:= DTOS(SD2->D2_EMISSAO)
        dEmiss 			:= DTOS(SD2->D2_EMISSAO)
        cDocum 			:= SD2->D2_DOC
        cSerie			:= SD2->D2_SERIE
        cForcl 			:= SD2->D2_CLIENTE
		cLoja			:= SD2->D2_LOJA
        cCfisc 	 		:= SD2->D2_CF
        nVlrCont 		:= 0
        nBaseICMS 		:= 0
        cAlicm 			:= Str(SD2->D2_PICM,5,2)
        nICMS 			:= 0
        nIsentasICMS 	:= 0
        nOutrasICMS 	:= 0
        nBaseIPI 		:= 0
        nIPI 			:= 0
        nIsentasIPI		:= 0
        nOutrasIPI 		:= 0
       	cClifor 		:= SD2->D2_CLIENTE  
        If SA1->(DbSeek(xFilial("SA1")+cClifor))
        	cEstado := SA1->A1_EST
            cClieFor := "C"
        Else
            cClifor := cClifor
            SA2->(DbSeek(xFilial("SA2")+cClifor))
            cEstado := SA2->A2_EST
        Endif
        nFrete := 0
        nSegur := 0
        If SF2->(DbSeek(SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE))
        	nFrete := SF2->F2_FRETE
            nSegur := SF2->F2_SEGURO
        Endif
//        Do While cEntra == DTOS(SD2->D2_EMISSAO) .AND. cCfisc == SD2->D2_CF .AND. cDocum == SD2->D2_DOC .AND. ;
//        	cforcl == SD2->D2_CLIENTE .AND. (cAlicm == STR(SD2->D2_PICM,5,2) .OR. Empty(SD2->D2_PICM)) .AND. !SD2->(Eof())
//			Alert("SD2 Dentro do Do While "+SD2->D2_DOC)
            nVlrCont += SD2->D2_TOTAL + SD2->D2_VALIPI  
            If Alltrim(SD2->D2_TES) == "149"
            	nVlrCont += SD2->D2_VALICM
            Endif
            nBaseICMS += SD2->D2_BASEICM
            nICMS += SD2->D2_VALICM
            If cColIPI == "T"
            	If SD2->D2_VALIPI > 0
                	nBaseIPI += SD2->D2_TOTAL
                  	nIPI += SD2->D2_VALIPI
               	Else
                  	nIsentasIPI += SD2->D2_TOTAL
               	Endif
            ElseIf cColIPI == "I"
               	nIsentasIPI += SD2->D2_TOTAL
            ElseIf cColIPI == "O"
               	nOutrasIPI += SD2->D2_TOTAL
            Else
               	nOutrasIPI += SD2->D2_TOTAL
            Endif
//            Dbskip(1)
//        Enddo
        If SF3->(Dbseek(xFilial("SF3")+cEntra+cDocum+cSerie+cCliFor+cLoja+cCFisc+cAlIcm))
			Alert("Encontrou NF no SF3 "+cDocum)
        	If SF3->(Rlock())
            	SF3->F3_REPROC := "N"
            	SF3->F3_ESTADO := cEstado
            	SF3->F3_EMISSAO := sTOd(dEmiss)
            	SF3->F3_OBSERV := ""
            	SF3->F3_DTCANC := CTOD(Space(8))
            	If nVlrCont < 0
            		nVlrCont := nVlrCont * (-1)
            	Endif
            	SF3->F3_VALCONT := nVlrCont + nFrete + nSegur
            	SF3->F3_OUTRICM += (nFrete + nSegur)
            	SF3->F3_OUTRIPI += (nFrete + nSegur)
            	nFrete := 0
            	nSegur := 0
            	SF3->F3_BASEICM := nBaseICMS
            	SF3->F3_VALICM := nICMS
            	If cColICMS == "I"
            		nIsentasICMS := nVlrCont - (nBaseICMS + nIPI)
            		If nIsentasICMS > 0
            			SF3->F3_ISENICM := nIsentasICMS
            		Endif 
            	Elseif cColICMS == "O"
            		nOutrasICMS := nVlrCont - (nBaseICMS + nIPI)
               		If nOutrasICMS > 0
                		SF3->F3_OUTRICM := nOutrasICMS 		//+= nOutrasICMS
               		Endif
            	Elseif cColICMS == "T"
            		nIsentasICMS := nVlrCont - (nBaseICMS + nIPI)
               		If nIsentasICMS > 0
               			SF3->F3_ISENICM := nIsentasICMS
            		Endif 
            	Endif
            	SF3->F3_BASEIPI := nBaseIPI
            	SF3->F3_VALIPI := nIPI
            	If Substr(cCFisc,2,3) $ "551_556"
            		If nIsentasIPI <> 0
               			nIsentasIPI += nIPI
            		Endif
            		If nOutrasIPI <> 0
              			nOutrasIPI += nIPI
            		Endif
            	Endif
            	SF3->F3_ISENIPI := nIsentasIPI
            	SF3->F3_OUTRIPI += nOutrasIPI
            	SF3->F3_ESPECIE := "NF"
            	SF3->F3_MSCLIFO := cClieFor
           		If STR(SF3->F3_VALCONT,12,3) == STR(SF3->F3_BASEICM,12,3)
            		SF3->F3_IPIOBS := nIPI
        	    Endif
    	    Endif
			SF3->(DbrUnlock())
		Else 
       		RecLock("SF3",.T.)
            SF3->F3_FILIAL := "01"
            SF3->F3_ENTRADA := CTOD(Substr(cEntra,7,2) + "/" + Substr(cEntra,5,2) + "/" + Substr(cEntra,1,4))
            SF3->F3_NFISCAL := cDocum
            SF3->F3_SERIE := cSerie
            SF3->F3_CLIEFOR := cCliFor
            SF3->F3_LOJA := cloja
            SF3->F3_CFO := cCFisc
            SF3->F3_ALIQICM := Val(cAlICM)
	        If SF3->(Rlock())
    	        SF3->F3_REPROC := "N"
        	    SF3->F3_ESTADO := cEstado
           		SF3->F3_EMISSAO := sTOd(dEmiss)
            	SF3->F3_OBSERV := ""
            	SF3->F3_DTCANC := CTOD(Space(8))
            	If nVlrCont < 0
            		nVlrCont := nVlrCont * (-1)
            	Endif
            	SF3->F3_VALCONT := nVlrCont + nFrete + nSegur
            	SF3->F3_OUTRICM += (nFrete + nSegur)
            	SF3->F3_OUTRIPI += (nFrete + nSegur)
            	nFrete := 0
            	nSegur := 0
            	SF3->F3_BASEICM := nBaseICMS
            	SF3->F3_VALICM := nICMS
            	If cColICMS == "I"
            		nIsentasICMS := nVlrCont - (nBaseICMS + nIPI)
            		If nIsentasICMS > 0
            			SF3->F3_ISENICM := nIsentasICMS
            		Endif 
            	Elseif cColICMS == "O"
            		nOutrasICMS := nVlrCont - (nBaseICMS + nIPI)
               		If nOutrasICMS > 0
                		SF3->F3_OUTRICM := nOutrasICMS 		//+= nOutrasICMS
	               	Endif
            	Elseif cColICMS == "T"
            		nIsentasICMS := nVlrCont - (nBaseICMS + nIPI)
            		If nIsentasICMS > 0
               			SF3->F3_ISENICM := nIsentasICMS
            		Endif 
            	Endif
            	SF3->F3_BASEIPI := nBaseIPI
            	SF3->F3_VALIPI := nIPI
            	If Substr(cCFisc,2,3) $ "551_556"
            		If nIsentasIPI <> 0
               			nIsentasIPI += nIPI
            		Endif
            		If nOutrasIPI <> 0
              			nOutrasIPI += nIPI
            		Endif
            	Endif
            	SF3->F3_ISENIPI := nIsentasIPI
            	SF3->F3_OUTRIPI += nOutrasIPI
            	SF3->F3_ESPECIE := "NF"
            	SF3->F3_MSCLIFO := cClieFor
            	If STR(SF3->F3_VALCONT,12,3) == STR(SF3->F3_BASEICM,12,3)
            		SF3->F3_IPIOBS := nIPI
           	 	Endif
        	Endif
			SF3->(DbrUnlock())
        Endif
EndIf       

SD2->(DbSeek(xFilial("SD2")+cNFiscal)) 

Alert("SD2 NFiscal "+SD2->D2_DOC)

Return(.T.)

