#include "TOTVS.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH"

/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para consultar condicao de pagamento na pre-nota

------------------------------------------------------------------------------- */


User Function ZCONDPGPNF()

    Local aArea := GetArea()
    Local cQuery
    Private cAliasCond := GetNextAlias()
    
    cQuery := " SELECT DISTINCT "
    cQuery += " C.E4_CODIGO AS CODCOND, "
    cQuery += " C.E4_DESCRI AS DESCCOND "
    cQuery += " FROM SD1010 A "
    cQuery += " LEFT JOIN SC7010 B ON B.D_E_L_E_T_ = '' AND B.C7_FILIAL = A.D1_FILIAL AND B.C7_NUM = A.D1_PEDIDO AND B.C7_FORNECE = A.D1_FORNECE AND B.C7_LOJA = A.D1_LOJA "
    cQuery += " LEFT JOIN SE4010 C ON C.D_E_L_E_T_ = '' AND C.E4_CODIGO = B.C7_COND "
    cQuery += " WHERE 1=1 "
    cQuery += " AND A.D_E_L_E_T_ = ''  "
    cQuery += " AND A.D1_FILIAL = '"+SF1->F1_FILIAL +"' "
    cQuery += " AND A.D1_DOC = '"+SF1->F1_DOC+"'   "
    cQuery += " AND A.D1_SERIE = '"+SF1->F1_SERIE +"' "
    cQuery += " AND A.D1_FORNECE = '"+SF1->F1_FORNECE+"' "
    cQuery += " AND A.D1_LOJA = '"+SF1->F1_LOJA+"' "

    //Criar alias temporário
    TCQUERY cQuery NEW ALIAS (cAliasCond)
    DbSelectArea(cAliasCond)

    DEFINE MSDIALOG oDlg FROM 05,10 TO 170,380 TITLE " Condicao Pagamento Pre Nota " PIXEL

        @ 010,020 TO 060,150 LABEL " Cond.Pg. Cadastrada " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "Cond.Pg.: "     SIZE 070, 020 OF oDlg PIXEL
        @ 020, 060 MSGET oGrupo VAR (cAliasCond)->CODCOND   SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        @ 043, 025 SAY oTitQtdVidas PROMPT "Descrição: "    SIZE 070, 020 OF oDlg PIXEL
        @ 040, 060 MSGET oGrupo VAR (cAliasCond)->DESCCOND  SIZE 080, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

    DEFINE SBUTTON FROM 065,150 TYPE 1 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

    (cAliasCond)->(DbCloseArea())
    RestArea(aArea)

Return
