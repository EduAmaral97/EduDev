#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWBROWSE.CH'
#INCLUDE "FWMVCDEF.CH"


/* ---------------------------------------------------------------------------------

Autor: Eduardo Amaral
Data: 12/06/2024
Objetivo: Rotina desenvolvida para realizar os lancamentos de despesas por placa do departamento de frotas.

----------------------------------------------------------------------------------- */


/* -------------------------- BROWSER DA ROTINA -------------------------- */

User Function ZDETFATPLS()

    Local cNota := Space(9)


 	DEFINE MSDIALOG oDlg FROM 05,10 TO 165,325 TITLE " Comissao Cobranca Medicar " PIXEL

        @ 010,020 TO 045,140 LABEL " Selecione o Numero do Titulo/NF " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "Numero Titulo: "            SIZE 070, 020 OF oDlg PIXEL
        @ 022, 065 MSGET oGrupo  VAR cNota  							SIZE 050, 011 OF oDlg PIXEL HASBUTTON PICTURE "@D"

		TButton():New( 055, 070 , "Ok" , oDlg, {|| MsAguarde({||fMontaTela(cNota)},"Aguarde","Filtrando titulo...") ,  oDlg:End() }, 030,011, ,,,.T.,,,,,,)

    	DEFINE SBUTTON FROM 055,110 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER




Return Nil


Static Function fMontaTela(cNota)

   //Local aIndex := {}
  Local aSeek := {}

    Private cCadastro := "Detalhe Faturamento PLS Medicar"
    Private oBrow
    
    //Private aRotina := {;
    //{ "Pesquisar"     ,'PesqBrw'        ,0,1 },;
    //{ "Visualizar"    ,'AxVisual'       ,0,2 },;
    //{ "Incluir"       ,'AxInclui'       ,0,3 },;
    //{ "AlTerar"       ,'AxAltera'       ,0,4 },;  
    //{ "Excluir"       ,'AxDeleta'       ,0,5 };
    // }

    //aAdd(aIndex, {"BM1_SUBCON"})
    //aAdd(aIndex, {"BM1_NUMTIT"})
    //aAdd(aSeek, {"BM1_SUBCON"  , {{"LookUp", "C", 9, 0, "Subcontrato",,}} , 1, .T. }) // TIPO | TAMANHO | 0
    //aAdd(aSeek, {"BM1_NUMTIT"  , {{"LookUp", "C", 6, 0, "Numero NF/Tit",,}} , 1, .T. }) // TIPO | TAMANHO | 0


    // Monta o mBrowse para exibição dos registros
    oBrowse := FWMBrowse():New() // Inicializa o objeto
    //Adiciona a coluna de Status
    //oBrowse:AddStatusColumns( { || BrwStatus() }, { || BrwLegend() } )
    oBrowse:SetAlias("BM1") // Indica a tabela utilizada
    oBrowse:SetOnlyFields({'BM1_FILIAL','BM1_CODINT','BM1_CODEMP','BM1_CONEMP','BM1_SUBCON','BM1_NOMUSR','BM1_TIPUSU','BM1_MES','BM1_ANO','BM1_TIPO','BM1_VALOR','BM1_PREFIX','BM1_NUMTIT','BM1_TIPTIT'})
    oBrowse:SetDescription(cCadastro) // Titulo
    oBrowse:DisableDetails() // Desabilita os detalhes
    oBrowse:SetSeek(.T.,aSeek)
    //oBrowse:AddFilter("Numero Nota","BM1_NUMTIT == '250419'")
    oBrowse:SetFilterDefault("BM1_NUMTIT == '"+alltrim(cNota)+"'")
    //oBrowse:SetSeeAll(.T.) // Permite visualizar registros todas filiais
    //oBrowse:SetChgAll(.T.) // Permite alterar reg. de outras filiais
    //oBrowse:AddButton( "Resumo"           , {|| ZRESFAT() } ,, 2 )
    //oBrowse:AddButton( "Incluir"          , {|| ZINC() } ,, 3 )
    //oBrowse:AddButton( "Alterar"          , {|| ZALT() } ,, 4 )
    //oBrowse:AddButton( "Excluir"          , {|| ZEXC() } ,, 5 )
    //oBrowse:AddButton( "Importar Placas"  , {|| MINHAFUNCAO() } ,, 6 )

    oBrowse:AddLegend( " BM1_TIPO == '1' "  , "GREEN"     ,  "CREDITO" )
    oBrowse:AddLegend( " BM1_TIPO == '2' "  , "RED"       ,  "DESCONTO" )
      
    oBrowse:Activate() //Ativa



Return



