#include "protheus.ch"
 
User Function F010CQTA()

    Local cQuery := paramixb[1]
    Local aArea := GetArea()
    Local aHeadBKP := aHeader
    //Local nCount
    

    IF MsgYesNo("Deseja remover titulos ('RA','PR') da listagem? ")

        cQuery := " SELECT  "
        cQuery += " E1_LOJA, "
        cQuery += " E1_FILORIG, "
        cQuery += " E1_PREFIXO, "
        cQuery += " E1_NUM, "
        cQuery += " E1_PARCELA, "
        cQuery += " E1_TIPO, "
        cQuery += " E1_NFELETR, "
        cQuery += " E1_CLIENTE, "
        cQuery += " E1_EMISSAO, "
        cQuery += " E1_VENCTO, "
        cQuery += " E1_VENCREA, "
        cQuery += " E1_BAIXA, "
        cQuery += " E1_VALOR, "
        cQuery += " E1_VLCRUZ, "
        cQuery += " E1_SDACRES, "
        cQuery += " E1_SDDECRE, "
        cQuery += " E1_VALJUR, "
        cQuery += " E1_SALDO, "
        cQuery += " E1_NATUREZ, "
        cQuery += " E1_PORTADO, "
        cQuery += " E1_NUMBCO, "
        cQuery += " E1_NUMLIQ, "
        cQuery += " E1_HIST, "
        cQuery += " E1_CHQDEV, "
        cQuery += " E1_SITUACA, "
        cQuery += " E1_PORCJUR, "
        cQuery += " E1_MOEDA, "
        cQuery += " E1_VALOR, "
        cQuery += " E1_TXMOEDA, "
        cQuery += " SE1.R_E_C_N_O_ SE1RECNO, "
        cQuery += " FRV.FRV_DESCRI , "
        cQuery += " CASE  "
        cQuery += "     WHEN E1_ZSTSLD = '1' THEN 'Protestado' "
        cQuery += "     WHEN E1_ZSTSLD = '2' THEN 'Protestado / TMK' "
        cQuery += "     WHEN E1_ZSTSLD = '3' THEN 'Judicializado' "
        cQuery += "     WHEN E1_ZSTSLD = '4' THEN 'Interno' "
        cQuery += "     WHEN E1_ZSTSLD = '5' THEN 'Glosa' "
        cQuery += "     WHEN E1_ZSTSLD = '6' THEN 'TMK' "
        cQuery += " ELSE '' "
        cQuery += " END AS STATTIT, "
        cQuery += " SE1.E1_FILIAL  "
        cQuery += " FROM SE1010 SE1,FRV010 FRV  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND SE1.E1_FILIAL "+ATMPFIL[1][2]+" "
        cQuery += " AND SE1.E1_CLIENTE= '"+SA1->A1_COD+"'  "
        cQuery += " AND SE1.E1_LOJA= '"+SA1->A1_LOJA+"'  "
        cQuery += " AND SE1.E1_EMISSAO>='"+Dtos(MV_PAR01)+"'  "
        cQuery += " AND SE1.E1_EMISSAO<='"+Dtos(MV_PAR02)+"'  "
        cQuery += " AND SE1.E1_VENCREA>='"+Dtos(MV_PAR03)+"'  "
        cQuery += " AND SE1.E1_VENCREA<='"+Dtos(MV_PAR04)+"'  "
        cQuery += " AND SE1.E1_PREFIXO>='"+MV_PAR06+"'  "
        cQuery += " AND SE1.E1_PREFIXO<='"+MV_PAR07+"'  "
        cQuery += " AND SE1.E1_SALDO > 0  "
        cQuery += " AND SE1.D_E_L_E_T_<>'*'  "
        cQuery += " AND FRV.FRV_FILIAL = '      '  "
        cQuery += " AND FRV.FRV_CODIGO = SE1.E1_SITUACA  "
        cQuery += " AND FRV.D_E_L_E_T_<>'*'  "
        cQuery += " AND SE1.E1_TIPO NOT IN ('RA','PR','AB-','CF-','CS-','FB-','FM-','FP-','FU-','I2-','IM-','IN-','IR-','IS-','MN-','PI-','FC-','FE-')  "
        cQuery += " ORDER BY  E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,SE1RECNO" "
    
    Else

        cQuery := " SELECT  "
        cQuery += " E1_LOJA, "
        cQuery += " E1_FILORIG, "
        cQuery += " E1_PREFIXO, "
        cQuery += " E1_NUM, "
        cQuery += " E1_PARCELA, "
        cQuery += " E1_TIPO, "
        cQuery += " E1_NFELETR, "
        cQuery += " E1_CLIENTE, "
        cQuery += " E1_EMISSAO, "
        cQuery += " E1_VENCTO, "
        cQuery += " E1_VENCREA, "
        cQuery += " E1_BAIXA, "
        cQuery += " E1_VALOR, "
        cQuery += " E1_VLCRUZ, "
        cQuery += " E1_SDACRES, "
        cQuery += " E1_SDDECRE, "
        cQuery += " E1_VALJUR, "
        cQuery += " E1_SALDO, "
        cQuery += " E1_NATUREZ, "
        cQuery += " E1_PORTADO, "
        cQuery += " E1_NUMBCO, "
        cQuery += " E1_NUMLIQ, "
        cQuery += " E1_HIST, "
        cQuery += " E1_CHQDEV, "
        cQuery += " E1_SITUACA, "
        cQuery += " E1_PORCJUR, "
        cQuery += " E1_MOEDA, "
        cQuery += " E1_VALOR, "
        cQuery += " E1_TXMOEDA, "
        cQuery += " SE1.R_E_C_N_O_ SE1RECNO, "
        cQuery += " FRV.FRV_DESCRI , "
        cQuery += " CASE  "
        cQuery += "     WHEN E1_ZSTSLD = '1' THEN 'Protestado' "
        cQuery += "     WHEN E1_ZSTSLD = '2' THEN 'Protestado / TMK' "
        cQuery += "     WHEN E1_ZSTSLD = '3' THEN 'Judicializado' "
        cQuery += "     WHEN E1_ZSTSLD = '4' THEN 'Interno' "
        cQuery += "     WHEN E1_ZSTSLD = '5' THEN 'Glosa' "
        cQuery += "     WHEN E1_ZSTSLD = '6' THEN 'TMK' "
        cQuery += " ELSE '' "
        cQuery += " END         AS STATTIT, "
        cQuery += " SE1.E1_FILIAL  "
        cQuery += " FROM SE1010 SE1,FRV010 FRV  "
        cQuery += " WHERE 1=1 "
        cQuery += " AND SE1.E1_FILIAL "+ATMPFIL[1][2]+" "
        cQuery += " AND SE1.E1_CLIENTE= '"+SA1->A1_COD+"'  "
        cQuery += " AND SE1.E1_LOJA= '"+SA1->A1_LOJA+"'  "
        cQuery += " AND SE1.E1_EMISSAO>='"+Dtos(MV_PAR01)+"'  "
        cQuery += " AND SE1.E1_EMISSAO<='"+Dtos(MV_PAR02)+"'  "
        cQuery += " AND SE1.E1_VENCREA>='"+Dtos(MV_PAR03)+"'  "
        cQuery += " AND SE1.E1_VENCREA<='"+Dtos(MV_PAR04)+"'  "
        cQuery += " AND SE1.E1_PREFIXO>='"+MV_PAR06+"'  "
        cQuery += " AND SE1.E1_PREFIXO<='"+MV_PAR07+"'  "
        cQuery += " AND SE1.E1_SALDO > 0  "
        cQuery += " AND SE1.D_E_L_E_T_<>'*'  "
        cQuery += " AND FRV.FRV_FILIAL = '      '  "
        cQuery += " AND FRV.FRV_CODIGO = SE1.E1_SITUACA  "
        cQuery += " AND FRV.D_E_L_E_T_<>'*'  "
        cQuery += " AND SE1.E1_TIPO NOT IN ('AB-','CF-','CS-','FB-','FM-','FP-','FU-','I2-','IM-','IN-','IR-','IS-','MN-','PI-','FC-','FE-')  "
        cQuery += " ORDER BY  E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,SE1RECNO" "

    EndIf

    /* ------------------------------- REORDENA AS COLUNAS DA TABELA ------------------------------- */

    aHeader := {}
    //aHeader[30] - STATTIT

    aadd(aHeader, aHeadBKP[1])
    aadd(aHeader, aHeadBKP[2])
    aadd(aHeader, aHeadBKP[3])
    aadd(aHeader, aHeadBKP[4])
    aadd(aHeader, aHeadBKP[5])
    aadd(aHeader, aHeadBKP[30])
    aadd(aHeader, aHeadBKP[6])
    aadd(aHeader, aHeadBKP[7])
    aadd(aHeader, aHeadBKP[8])
    aadd(aHeader, aHeadBKP[9])
    aadd(aHeader, aHeadBKP[10])
    aadd(aHeader, aHeadBKP[11])
    aadd(aHeader, aHeadBKP[13])
    aadd(aHeader, aHeadBKP[14])
    aadd(aHeader, aHeadBKP[15])
    aadd(aHeader, aHeadBKP[16])
    aadd(aHeader, aHeadBKP[17])
    aadd(aHeader, aHeadBKP[18])
    aadd(aHeader, aHeadBKP[19])
    aadd(aHeader, aHeadBKP[20])
    aadd(aHeader, aHeadBKP[21])
    aadd(aHeader, aHeadBKP[22])
    aadd(aHeader, aHeadBKP[23])
    aadd(aHeader, aHeadBKP[24])
    aadd(aHeader, aHeadBKP[25])
    aadd(aHeader, aHeadBKP[26])
    aadd(aHeader, aHeadBKP[27])
    aadd(aHeader, aHeadBKP[28])
    aadd(aHeader, aHeadBKP[29])
    aadd(aHeader, aHeadBKP[12])



    /*
    For nCount := 1 to len(aHeadBKP)

        if  nCount < 6
            
            aadd(aHeader, aHeadBKP[nCount])

        elseif  nCount = 6

            aadd(aHeader, aHeadBKP[30])

        else
            
            aadd(aHeader, aHeadBKP[nCount-1])

        endif
    
    Next
    */

    RestArea(aArea)

Return cQuery




