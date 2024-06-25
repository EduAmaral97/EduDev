#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*

-----------------------------------------------------------------------------# 
                            U_ZMEDAUDITORIA 						         #
-----------------------------------------------------------------------------# 
Funcao: U_RESUMOCONTATO														 #
Autor: Eduardo Jorge 													     #
Data: 15/04/2024														     #
Descricao: AUDITORIA CADASTROS                                               #
*****************************************************************************#

*/


/* -------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para consultar quem incluiu e/ou alterou certos cadastros (Nome do usuario e data)

------------------------------------------------------------------------------- */


User function ZMEDAUDITORIA()

    Local aArea := GetArea()

    //cChama a funcao que monta os dados
    MsAguarde({||fPegaUser(aArea)},"Aguarde","Auditando...")

return()

Static Function fPegaUser(aArea)

    // CADASTRO CLIENTES
    If aArea[1] = "SA1"

        //Posicionando no cadastro de produtos
        DbSelectArea('SA1')
        SA1->(DbSetOrder(1))
        SA1->(DbSeek(FWxFilial('SA1') + SA1->A1_COD + SA1->A1_LOJA))
        
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("A1_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("A1_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("A1_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("A1_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")


    // CADASTRO FORNECEDORES
    Elseif aArea[1] = "SA2"

        DbSelectArea('SA2')
        
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("A2_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("A2_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("A2_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("A2_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")


    // CONTAS A PAGAR
    Elseif aArea[1] = "SE2"

        //Posicionando no cadastro de produtos
        DbSelectArea('SE2')
      
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("E2_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("E2_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("E2_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("E2_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")


    // PEDIDO DE COMPRAS
    Elseif aArea[1] = "SC7"

        //Posicionando no cadastro de produtos
        DbSelectArea('SC7')
             
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("C7_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("C7_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("C7_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("C7_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")

    
    // SUBCONTRATO 
    Elseif aArea[1] = "BQC"

        //Posicionando no cadastro de produtos
        DbSelectArea('BQC')     
        
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("BQC_USERGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("BQC_USERGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("BQC_USERGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("BQC_USERGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")


    // FAMILIA/BENEFICIARIOS
    Elseif aArea[1] = "BA1"

        //Posicionando no cadastro de produtos
        DbSelectArea('BA3')
        BA3->(DbSetOrder(1))
        BA3->(DbSeek(FWxFilial('BA1') + BA1->BA1_CODINT + BA1->BA1_CODEMP + BA1->BA1_MATRIC + BA1->BA1_CONEMP + BA1->BA1_VERCON + BA1->BA1_SUBCON + BA1->BA1_VERSUB))

        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("BA3_USERGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("BA3_USERGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("BA3_USERGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("BA3_USERGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")


    // DOCUMENTO DE SAIDA
    Elseif aArea[1] = "SF1"

        DbSelectArea('SF1')
        
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("F1_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("F1_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("F1_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("F1_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")


    // CADASTRO DE BANCOS
    Elseif aArea[1] = "SA6"

        DbSelectArea('SA6')
        
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("A6_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("A6_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("A6_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("A6_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")

    
    // CONTAS A RECEBER
    Elseif aArea[1] = "SE1"

        DbSelectArea('SE1')
        
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("E1_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("E1_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("E1_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("E1_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")

    // CADASTRO DE NATUREZA
    Elseif aArea[1] = "SED"

        DbSelectArea('SED')
        
        //LOG INCLUSAO
        cUsrCodInc := FWLeUserLg("ED_USERLGI", 1)
        cUsrNomInc := UsrRetName(cUsrCodInc)
        cDatInc    := FWLeUserLg("ED_USERLGI", 2)

        //LOG ALTERACAO
        cUsrCodAlt := FWLeUserLg("ED_USERLGA", 1)
        cUsrNomAlt := UsrRetName(cUsrCodAlt)
        cDatAlt    := FWLeUserLg("ED_USERLGA", 2)

        //Chama a funcao que monta a tela
        MsAguarde({||fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)},"Aguarde","Auditando...")
        

    Else   

        MsgAlert("Auditoria nao cadastrado consulte o administrador.")
        
    Endif

    //Limpa a area
    RestArea( aArea )

Return


Static Function fMontatela(cUsrCodInc,cDatInc,cUsrCodAlt,cDatAlt)

    DEFINE MSDIALOG oDlg FROM 05,10 TO 170,470 TITLE "Medicar Auditoria " PIXEL

        @ 010,020 TO 060,110 LABEL " Inclusão " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "Usuario: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 020, 050 MSGET oGrupo VAR cUsrCodInc                          SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        @ 043, 025 SAY oTitQtdVidas PROMPT "Data: "                     SIZE 070, 020 OF oDlg PIXEL
        @ 040, 050 MSGET oGrupo VAR cDatInc                             SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 010,120 TO 060,210 LABEL " Alteração " OF oDlg PIXEL

        @ 025, 125 SAY oTitQtdVidas PROMPT "Usuario: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 020, 150 MSGET oGrupo VAR cUsrCodAlt                          SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        @ 043, 125 SAY oTitQtdVidas PROMPT "Data: "                     SIZE 070, 020 OF oDlg PIXEL
        @ 040, 150 MSGET oGrupo VAR cDatAlt                             SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"


    DEFINE SBUTTON FROM 065,185 TYPE 1 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

Return
