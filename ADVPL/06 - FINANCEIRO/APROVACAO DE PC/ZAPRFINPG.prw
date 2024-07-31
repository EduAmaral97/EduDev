#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWBROWSE.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PRTOPDEF.CH"

/*

Autor: Eduardo Amaral
Data: 22/07/2024
Objetivo: Tela para visualização de aprovadores de pedidos de compras no contas a pagar

*/


User Function ZAPRFINPG(cFilialTit,cPrefixo,cTitulo,cTipo,cForn,cLojaForn)

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oDlg as object
    Local oBrowse as object
    Local aCoors as array
    Local cQuery
    Private cAlias := GetNextAlias()

    aCoors := FWGetDialogSize()

        cQuery := " SELECT " 
        cQuery += " J.M0_FILIAL		                      AS FILIAL, "
   		cQuery += " A.E2_PREFIXO	                      AS PREFIXO, "
		cQuery += " A.E2_NUM		                      AS NUMTIT, "
		cQuery += " A.E2_TIPO		                      AS TIPO, "
        cQuery += " A.E2_VALOR                            AS VALOR, "
        cQuery += " C.D1_PEDIDO		                      AS PEDIDO, "
		cQuery += " D.CR_USER		                      AS CODUSSER, "
		cQuery += " E.USR_CODIGO 	                      AS APROVADOR, "
		cQuery += " CONCAT(C.D1_CC, ' - ', G.CTT_DESC01)  AS CCUSTO, "
		cQuery += " CONCAT(C.D1_CLVL, ' - ',H.CTH_DESC01) AS CLVL "
        cQuery += " FROM SE2010 A "
		cQuery += " LEFT JOIN SA2010 B ON B.D_E_L_E_T_ = '' AND B.A2_COD = A.E2_FORNECE AND B.A2_LOJA = A.E2_LOJA "
		cQuery += " LEFT JOIN SD1010 C ON C.D_E_L_E_T_ = '' AND C.D1_FILIAL = A.E2_FILIAL AND C.D1_SERIE = A.E2_PREFIXO AND C.D1_DOC = A.E2_NUM AND C.D1_FORNECE = A.E2_FORNECE AND C.D1_LOJA = A.E2_LOJA "
		cQuery += " LEFT JOIN SCR010 D ON D.D_E_L_E_T_ = '' AND D.CR_FILIAL = C.D1_FILIAL AND D.CR_NUM = C.D1_PEDIDO "
		cQuery += " LEFT JOIN SYS_USR E ON E.D_E_L_E_T_ = '' AND E.USR_ID = D.CR_USER "
		cQuery += " LEFT JOIN CTT010 G ON G.D_E_L_E_T_ = '' AND G.CTT_CUSTO = C.D1_CC "
		cQuery += " LEFT JOIN CTH010 H ON H.D_E_L_E_T_ = '' AND H.CTH_CLVL = C.D1_CLVL "
		cQuery += " LEFT JOIN SC7010 I ON I.D_E_L_E_T_ = '' AND I.C7_FILIAL = C.D1_FILIAL AND I.C7_NUM = C.D1_PEDIDO AND I.C7_FORNECE = C.D1_FORNECE AND I.C7_LOJA = C.D1_LOJA "
		cQuery += " LEFT JOIN SYS_COMPANY J ON J.D_E_L_E_T_ = '' AND J.M0_CODFIL = A.E2_FILIAL "
        cQuery += " WHERE 1=1 "
        cQuery += " AND A.D_E_L_E_T_ = '' "
        cQuery += " AND D.CR_USER IS NOT NULL
        cQuery += " AND A.E2_FILIAL = '"+cFilialTit+"' "
        cQuery += " AND A.E2_PREFIXO = '"+cPrefixo+"' "
        cQuery += " AND A.E2_NUM = '"+cTitulo+"' "
        cQuery += " AND A.E2_TIPO = '"+cTipo+"' "
        cQuery += " AND A.E2_FORNECE = '"+cForn+"' "
        cQuery += " AND A.E2_LOJA = '"+cLojaForn+"' "
        cQuery += " GROUP BY J.M0_FILIAL,A.E2_PREFIXO,A.E2_NUM,A.E2_TIPO,A.E2_VALOR,C.D1_PEDIDO,D.CR_USER,E.USR_CODIGO,C.D1_CC,G.CTT_DESC01,C.D1_CLVL,H.CTH_DESC01 "


    TCQUERY cQuery NEW ALIAS (cAlias)

        
    //Verifica resultado da query
	DbSelectArea(cAlias)
    (cAlias)->(DbGoTop())


    If (cAlias)->(Eof())

        MsgInfo("Titulo/Pedido de compras sem aprovação", "Aprovações Medicar")

    Else

        DEFINE DIALOG oDlg TITLE " Aprovações Medicar " FROM aCoors[1], aCoors[2] TO 410 , 750  PIXEL

            aGrade := {}

            @ 010,020 TO 060,250 LABEL " Dados do Titulo " OF oDlg PIXEL

            @ 025, 025 SAY oTitParametro PROMPT "Filial: "        SIZE 070, 020 OF oDlg PIXEL
            @ 035, 025 MSGET oGrupo VAR cFilialTit                   SIZE 030, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

            @ 025, 065 SAY oTitParametro PROMPT "Prefixo: "       SIZE 070, 020 OF oDlg PIXEL
            @ 035, 065 MSGET oGrupo VAR cPrefixo                  SIZE 020, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
            
            @ 025, 095 SAY oTitParametro PROMPT "Titulo: "        SIZE 070, 020 OF oDlg PIXEL
            @ 035, 095 MSGET oGrupo VAR cTitulo                   SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
            
            @ 025, 145 SAY oTitParametro PROMPT "Tipo: "          SIZE 070, 020 OF oDlg PIXEL
            @ 035, 145 MSGET oGrupo VAR cTipo                     SIZE 020, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
               
            @ 070,020 TO 200,350 LABEL " Aprovadores " OF oDlg PIXEL
            
            While (cAlias)->(!Eof())

                aAdd(aGrade, { .T.,(cAlias)->FILIAL,(cAlias)->PEDIDO,(cAlias)->APROVADOR,(cAlias)->CCUSTO,(cAlias)->CLVL }) // DADOS DA GRADE
            
                (cAlias)->(dBskip())

            EndDo
            
            //nRow        numérico            Indica a coordenada vertical.
            //nCol        numérico            Indica a coordenada horizontal.
            //nWidth      numérico            Indica a largura em pixels do objeto.
            //nHeight     numérico            Indica a altura em pixels do objeto.
            oBrowse := TCBrowse():New( aCoors[1]+80 ,aCoors[1]+25, aCoors[1]+315, aCoors[1]+115,, {'','Filial','Pedido','Aprovador','Centro de Custo','Classe valor'},{20,50,50,50,50,100}, oDlg,,,,,{||},,,,,,,.F.,"",.T.,,.F.,,, ) //CABECARIO DA GRADE
            oBrowse:SetArray(aGrade)
            oBrowse:bLine := {||{ If(aGrade[oBrowse:nAt,01],oOK,oNO),aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06] }} //EXIBICAO DA GRADE

            TButton():New( aCoors[1]+30, 300 , "Voltar"            , oDlg, {|| oDlg:End() }, 50,018, ,,,.T.,,,,,,)
 
        ACTIVATE DIALOG oDlg CENTERED
        
    Endif
    
    (cAlias)->(DbCloseArea())

Return
