#include "protheus.ch"
 
User Function F010CQTA()

    Local cQuery := paramixb [1]
    Local aArea := GetArea()

    IF MsgYesNo("Deseja remover titulos 'RA' da listagem? ")

        cQuery := "SELECT E1_FILIAL, E1_FILORIG, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_EMISSAO, "
        cQuery += "E1_VENCTO, E1_BAIXA, E1_VENCREA, E1_VALOR, E1_VLCRUZ, E1_SDACRES, E1_SDDECRE, "
        cQuery += "E1_VALJUR, E1_SALDO, E1_NATUREZ, E1_PORTADO, E1_NUMBCO, E1_NUMLIQ, E1_HIST, "
        cQuery += "E1_CHQDEV, E1_PORCJUR, E1_MOEDA, E1_VALOR, E1_TXMOEDA, E1_NFELETR, E1_SITUACA, SE1.R_E_C_N_O_ SE1RECNO, SX5.X5_DESCRI "
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



