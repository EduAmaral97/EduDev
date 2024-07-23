#INCLUDE "TOTVS.ch"
#iNCLUDE 'PROTHEUS.CH'
#iNCLUDE "TOPCONN.CH"


User Function ZMEDTELA()

    Local aArea   := FWGetArea()
    Local oBrowse
    Local cAlias := "SA1"
    Private cCadastro := "Consultas - Medicar"
 
    //Instanciando o browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAlias)
    // ON - N DELETADOS | OFF - TRAZ DELETADOS
    //SET DELETED OFF
    oBrowse:SetDescription(cCadastro)
    oBrowse:DisableDetails()

    //ADICIONA AS LEGENDAS
    oBrowse:AddLegend( "SA1->A1_PESSOA == 'F' ", "GREEN",  "Pessoa Juridica" )
    oBrowse:AddLegend( "SA1->A1_PESSOA == 'J' ", "BLUE",    "Pessoa Fisica" )

    //ADICIONA OS BOTOES DA ROTINA
    oBrowse:AddButton( "Consultar"       , {|| fConsulta(SA1->A1_COD, SA1->A1_LOJA,SA1->A1_NOME,SA1->A1_PESSOA) } ,, 1 ) 
    
    
    //Ativa a Browse
    oBrowse:Activate()


 
    FWRestArea(aArea)

Return Nil



Static Function fConsulta(cCodcli,cLojacli,cNomCli,cTipCli)

    Local aCoors as array
    //Local oOK := LoadBitmap(GetResources(),'br_verde')
    //Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    

    aCoors := FWGetDialogSize()

    DEFINE DIALOG oDlg TITLE "Consultas - Medicar " FROM aCoors[1], aCoors[1] TO aCoors[3], aCoors[4] PIXEL

        @ 010,010 TO 070,500 LABEL " Dados Cadastrais " OF oDlg PIXEL

        @ 025, 025 SAY oTitParametro PROMPT "Cod Cli: "              SIZE 070, 020 OF oDlg PIXEL
        @ 022, 040 MSGET oGrupo VAR  cCodcli                         SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 100 SAY oTitParametro PROMPT "Loja: "                 SIZE 070, 020 OF oDlg PIXEL
        @ 022, 117 MSGET oGrupo VAR  cLojacli                        SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 177 SAY oTitParametro PROMPT "Cliente: "              SIZE 070, 020 OF oDlg PIXEL
        @ 022, 210 MSGET oGrupo VAR  cNomCli                         SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        TButton():New(aCoors[1]+15,(aCoors[3]/1.03) , "Contratos"       , oDlg, {|| U_ZCONTRATCLI(cCodcli,cLojacli,cTipCli) }, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+40,(aCoors[3]/1.03) , "Ocorrencias"     , oDlg, {|| U_ZMEDCLIOCR(cCodCli,cLojaCli) }, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+65,(aCoors[3]/1.03) , "Contatos"        , oDlg, {|| MsgInfo("Em desenvolvimento!", "Consulta Medicar") }, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+90,(aCoors[3]/1.03) , "Endereços"       , oDlg, {|| MsgInfo("Em desenvolvimento!", "Consulta Medicar") }, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+115,(aCoors[3]/1.03) , "Notas Fiscais"  , oDlg, {|| MsgInfo("Em desenvolvimento!", "Consulta Medicar") }, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+140,(aCoors[3]/1.03) , "Titulos"        , oDlg, {|| MsgInfo("Em desenvolvimento!", "Consulta Medicar") }, 50,018, ,,,.T.,,,,,,)
        TButton():New(aCoors[1]+165,(aCoors[3]/1.03) , "Voltar"         , oDlg, {|| oDlg:End() }, 50,018, ,,,.T.,,,,,,)

    ACTIVATE DIALOG oDlg CENTERED

Return 



