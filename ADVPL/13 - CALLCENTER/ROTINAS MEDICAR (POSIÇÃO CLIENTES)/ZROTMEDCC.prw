#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"

/* ---------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para agrupar as rotinas da medicar relacionadas ao Callcenter

----------------------------------------------------------------------------------- */


User Function ZROTMEDCC(cCli, cLojacli, cTipCli)

    Local oDlg as object

 	DEFINE MSDIALOG oDlg FROM 05,10 TO 165,325 TITLE " Rotinas Medicar " PIXEL

        @ 010,020 TO 045,140 LABEL " Rotinas " OF oDlg PIXEL

     	TButton():New( 025, 030 , "Contratos" , oDlg, {|| MsAguarde({||U_ZCONTRATCLI(cCli, cLojacli, cTipCli)},"Aguarde","Filtrando Contratos...") }, 040,011, ,,,.T.,,,,,,)
        TButton():New( 025, 080 , "Ocorrencias" , oDlg, {|| MsAguarde({||U_ZMEDCLIOCR(cCli, cLojacli)},"Aguarde","Filtrando Ocorrencias...") }, 040,011, ,,,.T.,,,,,,)

    	DEFINE SBUTTON FROM 055,110 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

Return Nil
