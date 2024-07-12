#include "protheus.ch"
 
User Function F010CQTA()

    Local cQuery := paramixb [1]
    Local aArea := GetArea()

    IF MsgYesNo("Deseja remover titulos 'RA' da listagem? ")

        cQuery := " E1_LOJA, "
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
        cQuery += " E1_ZSTSLD, "
        cQuery += " SE1.R_E_C_N_O_ SE1RECNO, "
        cQuery += " FRV.FRV_DESCRI , "
        cQuery += " SE1.E1_FILIAL  "
        cQuery += " FROM SE1010 SE1,FRV010 FRV "
        cQuery += " WHERE 1=1 "
        cQuery += " AND SE1.E1_FILIAL " +ATMPFIL[1][2]+ " "
        cQuery += " AND SE1.E1_CLIENTE = '"+SA1->A1_COD+"'  "
        cQuery += " AND SE1.E1_LOJA = '"+SA1->A1_LOJA+"'  "
        cQuery += " AND SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' " 
        cQuery += " AND SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' " 
        cQuery += " AND SE1.E1_VENCREA>='"+DTOS(MV_PAR03)+"' " 
        cQuery += " AND SE1.E1_VENCREA<='"+DTOS(MV_PAR04)+"' " 
        cQuery += " AND SE1.E1_PREFIXO>='"+MV_PAR06+"' " 
        cQuery += " AND SE1.E1_PREFIXO<='"+MV_PAR07+"' " 
        cQuery += " AND SE1.E1_SALDO > 0 "
        cQuery += " AND SE1.D_E_L_E_T_<>'*' " 
        cQuery += " AND FRV.FRV_FILIAL = '      ' "
        cQuery += " AND FRV.FRV_CODIGO = SE1.E1_SITUACA "
        cQuery += " AND FRV.D_E_L_E_T_<>'*' "
        cQuery += " AND SE1.E1_TIPO NOT IN ('PR ','RA ','AB-','CF-','CS-','FB-','FM-','FP-','FU-','I2-','IM-','IN-','IR-','IS-','MN-','PI-','FC-','FE-') "
        cQuery += " ORDER BY  E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,SE1RECNO "

    EndIf

    RestArea(aArea)
    
Return cQuery



