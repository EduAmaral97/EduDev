#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"


User Function ZMEDNFPC()

    Local aAreaSC7 := GetArea("SC7")
    Local cQuery
    Private cAlias := GetNextAlias()

    //MsgAlert("Filial:" + SC7->C7_FILIAL + " Pedido: " + SC7->C7_NUM + " Produto: " + SC7->C7_COD)

    cQuery := " SELECT "
    cQuery += " A.D1_FILIAL     AS FILIAL, "
    cQuery += " A.D1_DOC        AS DOC, "
    cQuery += " A.D1_SERIE      AS SERIE, "
    cQuery += " CONCAT(SUBSTRING(A.D1_EMISSAO,7,2),'/',SUBSTRING(A.D1_EMISSAO,5,2),'/',SUBSTRING(A.D1_EMISSAO,1,4)) AS DTEMI, "
    cQuery += " CONCAT(SUBSTRING(A.D1_DTDIGIT,7,2),'/',SUBSTRING(A.D1_DTDIGIT,5,2),'/',SUBSTRING(A.D1_DTDIGIT,1,4)) AS DTDIGI, "
    cQuery += " B.A2_COD        AS CODFOR, "
    cQuery += " B.A2_NREDUZ     AS FORNECEDOR "
    cQuery += " FROM SD1010 A "
    cQuery += " LEFT JOIN SA2010 B ON B.D_E_L_E_T_ = '' AND B.A2_COD = A.D1_FORNECE AND B.A2_LOJA = A.D1_LOJA "
    cQuery += " WHERE 1=1 "
    cQuery += " AND A.D_E_L_E_T_ = '' "
    cQuery += " AND A.D1_FILIAL = '"+SC7->C7_FILIAL+"' "
    cQuery += " AND A.D1_PEDIDO = '"+SC7->C7_NUM+"' "
    cQuery += " AND A.D1_FORNECE = '"+SC7->C7_FORNECE+"'  "
    cQuery += " AND A.D1_LOJA = '"+SC7->C7_LOJA+"' "
    cQuery += " AND A.D1_COD = '"+SC7->C7_PRODUTO+"' "
    
    //Criar alias temporário
    TCQUERY cQuery NEW ALIAS (cAlias)
    DbSelectArea(cAlias)

    (cAlias)->(DbGoTop())


    If (cAlias)->(!EoF())

        DEFINE MSDIALOG oDlg FROM 05,10 TO 255,470 TITLE "Nota Fiscal Pedido de Comrpas " PIXEL

            @ 010,020 TO 120,220 LABEL " Dados da Nota " OF oDlg PIXEL

            @ 025, 025 SAY oTitQtdVidas PROMPT "Filial: "                           SIZE 070, 020 OF oDlg PIXEL
            @ 020, 060 MSGET oGrupo VAR (cAlias)->FILIAL                            SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 043, 025 SAY oTitQtdVidas PROMPT "Serie: "                            SIZE 070, 020 OF oDlg PIXEL
            @ 040, 060 MSGET oGrupo VAR (cAlias)->SERIE                             SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
            @ 043, 095 SAY oTitQtdVidas PROMPT "Nota Fiscal: "                      SIZE 070, 020 OF oDlg PIXEL
            @ 040, 125 MSGET oGrupo VAR (cAlias)->DOC                               SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 063, 025 SAY oTitQtdVidas PROMPT "Emissao: "                          SIZE 070, 020 OF oDlg PIXEL
            @ 060, 060 MSGET oGrupo VAR (cAlias)->DTEMI                             SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
            @ 063, 115 SAY oTitQtdVidas PROMPT "Dt Entrada:"                        SIZE 070, 020 OF oDlg PIXEL
            @ 060, 145 MSGET oGrupo VAR (cAlias)->DTDIGI                            SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 083, 025 SAY oTitQtdVidas PROMPT "Cod. Forn.: "                       SIZE 070, 020 OF oDlg PIXEL
            @ 080, 060 MSGET oGrupo VAR (cAlias)->CODFOR                            SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
            @ 103, 025 SAY oTitQtdVidas PROMPT "Fornecedor :"                       SIZE 070, 020 OF oDlg PIXEL
            @ 100, 060 MSGET oGrupo VAR (cAlias)->FORNECEDOR                        SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"


        DEFINE SBUTTON FROM 100,190 TYPE 1 ACTION ( oDlg:End() ) ENABLE OF oDlg

        ACTIVATE MSDIALOG oDlg CENTER

    Else

        MsgInfo("Nota Fiscal Nao Encontrada ou Pedido em Aberto.", "Nota Fiscal PC Medicar.")

    EndIf
    

    (cAlias)->(DbCloseArea())
    RestArea(aAreaSC7)

Return
