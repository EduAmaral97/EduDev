#include "PROTHEUS.CH"
#include "PRTOPDEF.CH"

User Function F030TITABER()	

    Local aCamposPe := {}
    
    If Paramixb[1] == 1 // Somente incluir os campos	   
        
        aCamposPe := Paramixb[2]    
        aAdd(aCamposPe,{"VENCTOFORN","D", 10, 0, "Vencimento Real"})                      
        Return aCamposPe
    
    ElseIf Paramixb[1] == 2 // Somente abastacer os campos já inclusos anteriormente
    
        VENCTOFORN := SE2->E2_VENCREA

    ElseIf Paramixb[1] == 3	// Processo de Adicionar os campos tratados no ponto de entrada no objeto LISTBOX da aba titulos em aberto			
        
        aPosObj := Paramixb[2]
        @ aPosObj[2,1]-48,aPosObj[2,2]-2 LISTBOX oLbx FIELDS cArq1->PREFIXO,cArq1->NUMERO,cArq1->PARCELA,cArq1->TIPO,cArq1->EMISSAO,cArq1->DATAVENC,cArq1->VENCTOFORN,cArq1->NATUREZA, ;
        	Transform(cArq1->SALDOPAGAR,PesqPict("SE2","E2_SALDO")),Transform(cArq1->ATRASO,"999999"),Transform(cArq1->VALORJUROS,PesqPict("SE2","E2_SALDO")),;	
            cArq1->NUMBCO,cArq1->HISTORICO,;	
            Transform(cArq1->ACRESCIMO,PesqPict("SE2","E2_ACRESC")),Transform(cArq1->DECRESCIMO,PesqPict("SE2","E2_DECRESC"));	
            HEADER Paramixb[3],Paramixb[4],Paramixb[5],Paramixb[6],Paramixb[7],Paramixb[8], "Vencimento Real",Paramixb[9],Paramixb[10],Paramixb[11],Paramixb[12],Paramixb[16],Paramixb[17],Paramixb[18],Paramixb[19] SIZE aPosObj[2,4]-9,aPosObj[2,3]-82 OF oFolder030:aDialogs[2] PIXEL 					
    
    Endif

Return
