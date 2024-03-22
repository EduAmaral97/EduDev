#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*/ 
-----------------------------------------------------------------------------# 
							 U_RESUMOCONTATO							     #
-----------------------------------------------------------------------------# 
Funcao: U_RESUMOCONTATO														 #
Autor: Eduardo Jorge 													     #
Data: 15/01/2023														     #
Descricao: RESUMO DE VALORES E QUANTIDDADDE DE VIDAS DE UM CONTTRATO         #
*****************************************************************************#

*/

user function RESUMOCONTRATO()


    Local aArea   	:= GetArea()
    Local aAreaBQC	:= ("BQC") -> ( GetArea() )
    Local cSubcon	:= BQC->BQC_SUBCON
    local cCodint   := BQC->BQC_CODINT
    local cCodemp   := BQC->BQC_CODEMP
    local cConemp   := BQC->BQC_NUMCON

    Local cQuery
    Local cQueryTit
    Local cQueryDep

    DbSelectArea("BQC")

    /* TOTAL GERAL*/

    cQuery := " SELECT  "
    cQuery += " A.BQC_SUBCON AS ID_CONTRATO,  "
    cQuery += " COUNT(CONCAT(C.BA1_MATRIC, C.BA1_TIPREG)) AS QTD_VIDAS,  "
    cQuery += " SUM(D.BDK_VALOR) AS VALOR_TOTAL  "
    cQuery += " FROM BQC010 A  "
    cQuery += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
    cQuery += " LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''  "
    cQuery += " LEFT JOIN BDK010 D ON D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG AND D.D_E_L_E_T_ = ''  "
    cQuery += " WHERE 1=1  "
    cQuery += " AND A.D_E_L_E_T_ = ''  "
    cQuery += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
    cQuery += " AND A.BQC_CODINT = '"+cCodint+"'  "
    cQuery += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
    cQuery += " AND A.BQC_NUMCON = '"+cConemp+"'  "
    cQuery += " GROUP BY A.BQC_SUBCON "
    
    /* TITULAR */

    cQueryTit := " SELECT  "
    cQueryTit += " COUNT(CONCAT(C.BA1_MATRIC, C.BA1_TIPREG)) AS QTD_VIDAS,  "
    cQueryTit += " SUM(D.BDK_VALOR) AS VALOR_TOTAL  "
    cQueryTit += " FROM BQC010 A  "
    cQueryTit += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
    cQueryTit += " LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''  "
    cQueryTit += " LEFT JOIN BDK010 D ON D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG AND D.D_E_L_E_T_ = ''  "
    cQueryTit += " WHERE 1=1  "
    cQueryTit += " AND A.D_E_L_E_T_ = ''  "
    cQueryTit += " AND C.BA1_TIPUSU = 'T'  "
    cQueryTit += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
    cQueryTit += " AND A.BQC_CODINT = '"+cCodint+"'  "
    cQueryTit += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
    cQueryTit += " AND A.BQC_NUMCON = '"+cConemp+"'  "
    cQueryTit += " AND C.BA1_MOTBLO = '' "
    cQueryTit += " AND C.BA1_DATBLO = '' "
    cQueryTit += " GROUP BY A.BQC_SUBCON  "

    /* DEPEDENTE */
    
    cQueryDep := " SELECT  "
    cQueryDep += " COUNT(CONCAT(C.BA1_MATRIC, C.BA1_TIPREG)) AS QTD_VIDAS,  "
    cQueryDep += " CASE "
    cQueryDep += "     WHEN D.BDK_VALOR > 0.01 THEN SUM(D.BDK_VALOR)  "
    cQueryDep += "     ELSE 0 "
    cQueryDep += " END AS VALOR_TOTAL "
    cQueryDep += " FROM BQC010 A  "
    cQueryDep += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
    cQueryDep += " LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''  "
    cQueryDep += " LEFT JOIN BDK010 D ON D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG AND D.D_E_L_E_T_ = ''  "
    cQueryDep += " WHERE 1=1  "
    cQueryDep += " AND A.D_E_L_E_T_ = ''  "
    cQueryDep += " AND C.BA1_TIPUSU = 'D'  "
    cQueryDep += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
    cQueryDep += " AND A.BQC_CODINT = '"+cCodint+"' "
    cQueryDep += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
    cQueryDep += " AND A.BQC_NUMCON = '"+cConemp+"'  "
    cQueryDep += " AND C.BA1_MOTBLO = '' "
    cQueryDep += " AND C.BA1_DATBLO = '' "
    cQueryDep += " GROUP BY A.BQC_SUBCON, D.BDK_VALOR "


    TcQuery cQuery New Alias AliasCtr
    dbSelectArea("AliasCtr")

    TcQuery cQueryTit New Alias AliasCtrTit
    dbSelectArea("AliasCtrTit")

    TcQuery cQueryDep New Alias AliasCtrDep
    dbSelectArea("AliasCtrDep")


    LOCAL cValorTit := "R$ " + Str(AliasCtrTit->VALOR_TOTAL,10,2) 
    LOCAL cValorDep := "R$ " + Str(AliasCtrDep->VALOR_TOTAL,10,2) 
    LOCAL cValorTot := "R$ " + Str((AliasCtrTit->VALOR_TOTAL + AliasCtrDep->VALOR_TOTAL),10,2)
    

    DEFINE MSDIALOG oDlg FROM 05,10 TO 320,450 TITLE "RESUMO DO CONTRATO: " PIXEL

        @ 010,020 TO 075,180 LABEL " VALORES " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "VALOR TITULAR: "                    SIZE 070, 020 OF oDlg PIXEL
        @ 032, 025 SAY oTitQtdVidas PROMPT cValorTit                            SIZE 050, 020 OF oDlg PIXEL
        
        @ 025, 120 SAY oTitQtdVidas PROMPT "VALOR DEPEDENTE: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 032, 120 SAY oTitQtdVidas PROMPT cValorDep                            SIZE 060, 020 OF oDlg PIXEL

        @ 050, 025 SAY oTitQtdVidas PROMPT "VALOR TOTAL VIDAS: "                SIZE 070, 020 OF oDlg PIXEL
        @ 057, 025 SAY oTitQtdVidas PROMPT cValorTot                            SIZE 050, 020 OF oDlg PIXEL
        
        @ 080,020 TO 135,180 LABEL " QUANTIDADE " OF oDlg PIXEL

        @ 090, 025 SAY oTitQtdVidas PROMPT "VIDAS TITULAR: "                    SIZE 070, 020 OF oDlg PIXEL
        @ 097, 025 SAY oTitQtdVidas PROMPT AliasCtrTit->QTD_VIDAS               SIZE 050, 020 OF oDlg PIXEL
        
        @ 090, 120 SAY oTitQtdVidas PROMPT "VIDAS DEPEDENTE: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 097, 120 SAY oTitQtdVidas PROMPT AliasCtrDep->QTD_VIDAS               SIZE 050, 020 OF oDlg PIXEL

        @ 115, 025 SAY oTitQtdVidas PROMPT "TOTAL VIDAS: "                      SIZE 070, 020 OF oDlg PIXEL
        @ 122, 025 SAY oTitQtdVidas PROMPT AliasCtrTit->QTD_VIDAS + AliasCtrDep->QTD_VIDAS SIZE 050, 020 OF oDlg PIXEL


    DEFINE SBUTTON FROM 140,180 TYPE 1 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

    AliasCtr->(dbCloseArea())
    AliasCtrTit->(dbCloseArea())
    AliasCtrDep->(dbCloseArea())
    RestArea( aAreaBQC )
    RestArea( aArea    )

return()
