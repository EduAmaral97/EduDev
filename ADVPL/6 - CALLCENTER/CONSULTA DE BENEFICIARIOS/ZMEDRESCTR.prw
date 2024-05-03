#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"


User function ZMEDRESCTR(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)

    Local aArea := GetArea()

    Private AliasCtr	    := GetNextAlias()

    //MsgAlert("Dados: " + cFilialCtr + cCodint + cCodemp + cConemp + cVercon + cSubcon + cVersub + cMatemp)

	//Monta arquivo de trabalho temporário
	Processa({||MontaQuery(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)},"Obtendo Dados...")


    (AliasCtr)->(DbCloseArea())      
    RestArea( aArea )

return


Static Function MontaQuery(cFilialCtr,cCodint,cCodemp,cConemp,cVercon,cSubcon,cVersub,cMatemp)

    Local cQuery
    Local nAtual := 0
    Local nTotal := 0

    /* QUANTIDADES */
    Local cQtdTit   := 0   
    Local cQtdDep   := 0   
    Local cQtdBloq  := 0   
    Local cQtdTotal := 0   

    /* VALORES */
    Local cValorTit   := 0
    Local cValorDep   := 0
    Local cValorBloq  := 0
    Local cValorTotal := 0


    IF cSubcon = '000000001' 

        cQuery := " SELECT "
        cQuery +="  CASE "
        cQuery +="     WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP' "
        cQuery +="     WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP' "
        cQuery +="     WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP' "
        cQuery +="     WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH' "
        cQuery +="     WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL' "
        cQuery +="     WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI' "
        cQuery +="     WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD' "
        cQuery +="     WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ' "
        cQuery +="     ELSE '' "
        cQuery +="  END AS FILIAL, "
        cQuery += " CASE WHEN B.BA3_IDBENN <> '' THEN B.BA3_IDBENN ELSE B.BA3_MATEMP END AS IDCONTRATO,  "
        cQuery += " B.BA3_XCARTE    AS NUMERO,  "
        cQuery += " E.BT5_NOME      AS PERFIL,  "
        cQuery += " F.BQL_DESCRI    AS FORMAPAG,  "
        cQuery += " G.ZI0_DESCRI    AS CONDPAG,  "
        cQuery += " CONCAT(SUBSTRING(B.BA3_DATBAS,7,2),'/',SUBSTRING(B.BA3_DATBAS,5,2),'/',SUBSTRING(B.BA3_DATBAS,1,4))    AS DTBASE,  "
        cQuery += " I.A1_COD        AS CODCLI,  "
        cQuery += " I.A1_LOJA       AS LOJACLI,  "
        cQuery += " I.A1_NREDUZ     AS CLIENTE,  "
        cQuery += " CASE "
        cQuery += "     WHEN I.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(I.A1_CGC,1,3),'.',SUBSTRING(I.A1_CGC,4,3),'.',SUBSTRING(I.A1_CGC,7,3),'-',SUBSTRING(I.A1_CGC,10,2)) "
        cQuery += "     ELSE CONCAT(SUBSTRING(I.A1_CGC,1,2),'.',SUBSTRING(I.A1_CGC,3,3),'.',SUBSTRING(I.A1_CGC,6,3),'/',SUBSTRING(I.A1_CGC,9,4),'-',SUBSTRING(I.A1_CGC,13,2)) "
        cQuery += " END             AS CGC, "
        cQuery += " H.A3_NOME       AS VENDEDOR,  "
        cQuery += " B.BA3_MOTBLO    AS MOTBLOCTR,  "
        cQuery += " CONCAT(SUBSTRING(B.BA3_DATBLO,7,2),'/',SUBSTRING(B.BA3_DATBLO,5,2),'/',SUBSTRING(B.BA3_DATBLO,1,4)) AS DATBLOCTR,  "
        cQuery += " CASE "
        cQuery += "     WHEN C.BA1_DATBLO = '' THEN 'ATIVO' "
        cQuery += "     ELSE 'INATIVO' "
        cQuery += " END AS STATUSBENE, "
        cQuery += " C.BA1_ZATEND    AS ATEND,  "
        cQuery += " CASE "
        cQuery += "    WHEN B.BA3_ESPTEL = '1' THEN 'SIM' "
        cQuery += "    ELSE 'NAO' "
        cQuery += " END             AS ESPETEL, "
        cQuery += " C.BA1_TIPUSU    AS TIPO,  "
        cQuery += " D.BDK_VALOR     AS VALOR  "
        cQuery += " FROM BQC010 A  "
        cQuery += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = C.BA1_SUBCON AND B.BA3_VERCON = C.BA1_VERCON AND C.BA1_VERSUB = B.BA3_VERSUB AND C.BA1_MATEMP = B.BA3_MATEMP "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG "
        cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
        cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
        cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
        cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = B.BA3_ZZVEND "
        cQuery += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = B.BA3_CODCLI AND I.A1_LOJA = B.BA3_LOJA "
        cQuery += " WHERE 1=1  "
        cQuery += " AND A.D_E_L_E_T_ = ''  "
        cQuery += " AND B.BA3_FILIAL = '"+cFilialCtr+"'  "
        cQuery += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
        cQuery += " AND A.BQC_CODINT = '"+cCodint+"'  "
        cQuery += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
        cQuery += " AND A.BQC_NUMCON = '"+cConemp+"'  "
        cQuery += " AND A.BQC_VERCON = '"+cVersub+"'  "
        cQuery += " AND A.BQC_VERSUB = '"+cVercon+"'  "
        cQuery += " AND B.BA3_MATEMP = '"+cMatemp+"'  "
    
    ELSE

        cQuery := " SELECT "
        cQuery +="  CASE "
        cQuery +="     WHEN B.BA3_FILIAL = '001' THEN '001 - MEDICAR RP' "
        cQuery +="     WHEN B.BA3_FILIAL = '002' THEN '002 - MEDICAR CAMP' "
        cQuery +="     WHEN B.BA3_FILIAL = '003' THEN '003 - MEDICAR SP' "
        cQuery +="     WHEN B.BA3_FILIAL = '006' THEN '006 - MEDICAR TECH' "
        cQuery +="     WHEN B.BA3_FILIAL = '008' THEN '008 - MEDICAR LITORAL' "
        cQuery +="     WHEN B.BA3_FILIAL = '014' THEN '014 - LOCAMEDI' "
        cQuery +="     WHEN B.BA3_FILIAL = '016' THEN '016 - N1 CARD' "
        cQuery +="     WHEN B.BA3_FILIAL = '021' THEN '021 - MEDICAR RJ' "
        cQuery +="     ELSE '' "
        cQuery +="  END AS FILIAL, "
        cQuery += " A.BQC_SUBCON    AS IDCONTRATO,  "
        cQuery += " A.BQC_ANTCON    AS NUMERO,  "
        cQuery += " E.BT5_NOME      AS PERFIL,  "
        cQuery += " F.BQL_DESCRI    AS FORMAPAG,  "
        cQuery += " G.ZI0_DESCRI    AS CONDPAG,  "
        cQuery += " CONCAT(SUBSTRING(A.BQC_DATCON,7,2),'/',SUBSTRING(A.BQC_DATCON,5,2),'/',SUBSTRING(A.BQC_DATCON,1,4)) AS DTBASE,  "
        cQuery += " I.A1_COD        AS CODCLI,  "
        cQuery += " I.A1_LOJA       AS LOJACLI,  "
        cQuery += " I.A1_NREDUZ     AS CLIENTE,  "
        cQuery += " CASE "
        cQuery += "     WHEN I.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(I.A1_CGC,1,3),'.',SUBSTRING(I.A1_CGC,4,3),'.',SUBSTRING(I.A1_CGC,7,3),'-',SUBSTRING(I.A1_CGC,10,2)) "
        cQuery += "     ELSE CONCAT(SUBSTRING(I.A1_CGC,1,2),'.',SUBSTRING(I.A1_CGC,3,3),'.',SUBSTRING(I.A1_CGC,6,3),'/',SUBSTRING(I.A1_CGC,9,4),'-',SUBSTRING(I.A1_CGC,13,2)) "
        cQuery += " END             AS CGC, "
        cQuery += " H.A3_NOME       AS VENDEDOR,  "
        cQuery += " A.BQC_CODBLO    AS MOTBLOCTR,  "
        cQuery += " CONCAT(SUBSTRING(A.BQC_DATBLO,7,2),'/',SUBSTRING(A.BQC_DATBLO,5,2),'/',SUBSTRING(A.BQC_DATBLO,1,4)) AS DATBLOCTR,  "
        cQuery += " CASE "
        cQuery += "     WHEN C.BA1_DATBLO = '' THEN 'ATIVO' "
        cQuery += "     ELSE 'INATIVO' "
        cQuery += " END             AS STATUSBENE, "
        cQuery += " C.BA1_ZATEND    AS ATEND,  "
        cQuery += " CASE "
        cQuery += "    WHEN A.BQC_ESPTEL = '1' THEN 'SIM' "
        cQuery += "    ELSE 'NAO' "
        cQuery += " END              AS ESPETEL, "
        cQuery += " C.BA1_TIPUSU    AS TIPO,  "
        cQuery += " D.BDK_VALOR     AS VALOR  "
        cQuery += " FROM BQC010 A  "
        cQuery += " LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''  "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = C.BA1_SUBCON AND B.BA3_VERCON = C.BA1_VERCON AND C.BA1_VERSUB = B.BA3_VERSUB AND C.BA1_MATEMP = B.BA3_MATEMP "
        cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG "
        cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON "
        cQuery += " LEFT JOIN BQL010 F ON F.D_E_L_E_T_ = '' AND F.BQL_CODIGO = A.BQC_TIPPAG "
        cQuery += " LEFT JOIN ZI0010 G ON G.D_E_L_E_T_ = '' AND G.ZI0_CODIGO = A.BQC_XCONDI "
        cQuery += " LEFT JOIN SA3010 H ON H.D_E_L_E_T_ = '' AND H.A3_COD = A.BQC_ZZVEND "
        cQuery += " LEFT JOIN SA1010 I ON I.D_E_L_E_T_ = '' AND I.A1_COD = A.BQC_CODCLI AND I.A1_LOJA = A.BQC_LOJA "
        cQuery += " WHERE 1=1  "
        cQuery += " AND A.D_E_L_E_T_ = ''  "
        cQuery += " AND B.BA3_FILIAL = '"+cFilialCtr+"'  "
        cQuery += " AND A.BQC_SUBCON = '"+cSubcon+"'  "
        cQuery += " AND A.BQC_CODINT = '"+cCodint+"'  "
        cQuery += " AND A.BQC_CODEMP = '"+cCodemp+"'  "
        cQuery += " AND A.BQC_NUMCON = '"+cConemp+"'  "
        cQuery += " AND A.BQC_VERCON = '"+cVersub+"'  "
        cQuery += " AND A.BQC_VERSUB = '"+cVercon+"'  "

    ENDIF

    TCQUERY cQuery NEW ALIAS (AliasCtr)


	//Verifica resultado da query
	DbSelectArea(AliasCtr)
    (AliasCtr)->(DbGoTop())

    //Define o tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
    (AliasCtr)->(DbGoTop())


 	While (AliasCtr)->(!Eof())
    
    nAtual++
    IncProc("Carregando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

        IF (AliasCtr)-> STATUSBENE = 'ATIVO'

            IF (AliasCtr)->TIPO = 'T'

                cQtdTit   := cQtdTit  + 1
                cValorTit := cValorTit + (AliasCtr)->VALOR

            ELSE

                cQtdDep   := cQtdDep  + 1
                cValorDep := cValorDep + (AliasCtr)->VALOR

            ENDIF

        ELSE

            cQtdBloq := cQtdBloq + 1
            cValorBloq := cValorBloq + (AliasCtr)->VALOR

        ENDIF

        (AliasCtr)->(dBskip())

	EndDo

    cQtdTotal   := cQtdTit + cQtdDep
    cValorTotal := cValorTit + cValorDep

    (AliasCtr)->(DbGoTop())

    MsAguarde({||MontaTela(cQtdTit,  cQtdDep,  cQtdBloq, cQtdTotal,cValorTit,  cValorDep,  cValorBloq, cValorTotal)},"Aguarde","Gerando Arquivo em Excel...")



Return 


Static Function MontaTela(cQtdTit,  cQtdDep,  cQtdBloq, cQtdTotal,cValorTit,  cValorDep,  cValorBloq, cValorTotal)


  DEFINE MSDIALOG oDlg FROM 05,10 TO 400,1050 TITLE " RESUMO DO CONTRATO " PIXEL

        @ 010,020 TO 185,300 LABEL " Dados do Contrato " OF oDlg PIXEL

        @ 025, 025 SAY oTitQtdVidas PROMPT "Filial "                        SIZE 070, 020 OF oDlg PIXEL
        @ 035, 025 MSGET oGrupo VAR (AliasCtr)->FILIAL                      SIZE 080, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 110 SAY oTitQtdVidas PROMPT "Id. Contrato "                   SIZE 070, 020 OF oDlg PIXEL
        @ 035, 110 MSGET oGrupo VAR (AliasCtr)->IDCONTRATO                   SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 170 SAY oTitQtdVidas PROMPT "Numero "                         SIZE 070, 020 OF oDlg PIXEL
        @ 035, 170 MSGET oGrupo VAR (AliasCtr)->NUMERO                       SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025, 240 SAY oTitQtdVidas PROMPT "Especialidade "                  SIZE 070, 020 OF oDlg PIXEL
        @ 035, 240 MSGET oGrupo VAR (AliasCtr)->ESPETEL                      SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 055, 025 SAY oTitQtdVidas PROMPT "Perfil "                         SIZE 070, 020 OF oDlg PIXEL
        @ 065, 025 MSGET oGrupo VAR (AliasCtr)->PERFIL                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 055, 130 SAY oTitQtdVidas PROMPT "Dt. Base "                       SIZE 070, 020 OF oDlg PIXEL
        @ 065, 130 MSGET oGrupo VAR (AliasCtr)->DTBASE                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 055, 190 SAY oTitQtdVidas PROMPT "Dt. Bloqueio "                   SIZE 070, 020 OF oDlg PIXEL
        @ 065, 190 MSGET oGrupo VAR (AliasCtr)->DATBLOCTR                    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
    
        @ 085, 025 SAY oTitQtdVidas PROMPT "Forma Pg "                       SIZE 070, 020 OF oDlg PIXEL
        @ 095, 025 MSGET oGrupo VAR (AliasCtr)->FORMAPAG                     SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 085, 100 SAY oTitQtdVidas PROMPT "Cond. Pg "                       SIZE 070, 020 OF oDlg PIXEL
        @ 095, 100 MSGET oGrupo VAR (AliasCtr)->CONDPAG                      SIZE 110, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 115, 025 SAY oTitQtdVidas PROMPT "Cpf/Cnpj "                       SIZE 070, 020 OF oDlg PIXEL
        @ 125, 025 MSGET oGrupo VAR (AliasCtr)->CGC                          SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
   
        @ 115, 100 SAY oTitQtdVidas PROMPT "Cod. Cliente "                   SIZE 070, 020 OF oDlg PIXEL
        @ 125, 100 MSGET oGrupo VAR (AliasCtr)->CODCLI                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 115, 160 SAY oTitQtdVidas PROMPT "Cliente "                        SIZE 070, 020 OF oDlg PIXEL
        @ 125, 160 MSGET oGrupo VAR (AliasCtr)->CLIENTE                      SIZE 120, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 145, 025 SAY oTitQtdVidas PROMPT "Vendedor "                       SIZE 070, 020 OF oDlg PIXEL
        @ 155, 025 MSGET oGrupo VAR (AliasCtr)->VENDEDOR                     SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"


    /* ------------------------------------ QUANTIDADE E VALORES ------------------------------------ */

        @ 010,320 TO 185,500 LABEL " Quantidade e Valores " OF oDlg PIXEL
        @ 030, 400 SAY oTitQtdVidas PROMPT " Qtd  "                        SIZE 070, 020 OF oDlg PIXEL
        @ 030, 445 SAY oTitQtdVidas PROMPT " Vlr R$  "                      SIZE 070, 020 OF oDlg PIXEL
        
        @ 045, 325 SAY oTitQtdVidas PROMPT " Titular  "                      SIZE 070, 020 OF oDlg PIXEL
        @ 060, 325 SAY oTitQtdVidas PROMPT " Depedente  "                    SIZE 070, 020 OF oDlg PIXEL
        @ 075, 325 SAY oTitQtdVidas PROMPT " Bloquados "                     SIZE 070, 020 OF oDlg PIXEL
        @ 090, 325 SAY oTitQtdVidas PROMPT " Total (Ativos) "                SIZE 070, 020 OF oDlg PIXEL

        @ 040, 385 MSGET oTitQtdVidas VAR cQtdTit                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 040, 440 MSGET oTitQtdVidas VAR cValorTit                     SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        @ 055, 385 MSGET oTitQtdVidas VAR cQtdDep                       SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 055, 440 MSGET oTitQtdVidas VAR cValorDep                     SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        @ 070, 385 MSGET oTitQtdVidas VAR cQtdBloq                      SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 070, 440 MSGET oTitQtdVidas VAR cValorBloq                    SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        @ 085, 385 MSGET oTitQtdVidas VAR cQtdTotal                     SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999999"
        @ 085, 440 MSGET oTitQtdVidas VAR cValorTotal                   SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@E 999,999,999.99"
        
        @ 110,325 Button "Titulos Cliente"                              SIZE 037,012  ACTION U_ZMEDTITCLI((AliasCtr)->CODCLI, (AliasCtr)->LOJACLI,(AliasCtr)->CLIENTE) PIXEL OF oDlg
        
        

    DEFINE SBUTTON FROM 155,250 TYPE 1 ACTION ( oDlg:End() ) ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER


Return


Static Function BuscaTitulos()

    MsgAlert("Titulos!")

Return
