#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWBROWSE.CH'
#INCLUDE "FWMVCDEF.CH"

/* ----------------------------------------------------------------------------

Objetico: Rotina criada para suprir as ocorrecias dos clientes da Medicar
Por: Eduardo Amaral
Em: 28/06/2024

---------------------------------------------------------------------------- */

User Function ZMEDCLIOCR(cCodCli,cLojaCli)
   
    //Local oOK := LoadBitmap(GetResources(),'br_verde')
    //Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local cQueryOcor
    Local oDlg as object
    Local oBrowse as object
    Local cCodSA1  
    Local cCliSA1

    //DbSelectArea('SA1')
    //SA1->(DbSetOrder(1))

    cCodSA1 := SA1->A1_COD
    cCliSA1 := SA1->A1_NREDUZ

    Private AliasOcorren := GetNextAlias()

    cQueryOcor := " SELECT  "
    cQueryOcor += " CONCAT(SUBSTRING(A.ZOM_DTOCOR,7,2),'/',SUBSTRING(A.ZOM_DTOCOR,5,2),'/',SUBSTRING(A.ZOM_DTOCOR,1,4)) AS DTOCO, "
    cQueryOcor += " B.X5_DESCRI     AS DESCTIPOCO, "
    cQueryOcor += " ISNULL(CAST(CAST(A.ZOM_OCORRE AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OCORRE, "
    cQueryOcor += " CONCAT(SUBSTRING(A.ZOM_DTINC,7,2),'/',SUBSTRING(A.ZOM_DTINC,5,2),'/',SUBSTRING(A.ZOM_DTINC,1,4)) AS DTINC, "
    cQueryOcor += " A.ZOM_USER      AS USUARIO, "
    cQueryOcor += " C.A1_COD        AS CODCLI, "
    cQueryOcor += " C.A1_NOME       AS CLIENTE,
    cQueryOcor += " A.R_E_C_N_O_    AS IDOCORR "
    cQueryOcor += " FROM ZOM010 A "
    cQueryOcor += " LEFT JOIN SX5010 B ON B.X5_CHAVE = A.ZOM_TIPOCO AND B.X5_TABELA = 'OM' "
    cQueryOcor += " LEFT JOIN SA1010 C ON C.D_E_L_E_T_ = '' AND C.A1_COD = A.ZOM_CODCLI AND C.A1_LOJA = A.ZOM_LOJA "
    cQueryOcor += " WHERE 1=1 "
    cQueryOcor += " AND A.D_E_L_E_T_ = '' "
    cQueryOcor += " AND A.ZOM_CODCLI = '"+cCodCli+"' "
    cQueryOcor += " AND A.ZOM_LOJA = '"+cLojaCli+"' "
    cQueryOcor += " ORDER BY A.ZOM_DTOCOR DESC "

    TCQUERY cQueryOcor NEW ALIAS (AliasOcorren)

    //Verifica resultado da query
	DbSelectArea(AliasOcorren)
    (AliasOcorren)->(DbGoTop())


    DEFINE DIALOG oDlg TITLE "Ocorrencias Clientes Medicar " FROM 0, 0 TO 470, 980 PIXEL
    
        aGrade := {}

        @ 014, 020 SAY oTitParametro PROMPT "Cod. Cli: "   SIZE 070, 020 OF oDlg PIXEL
        @ 010, 045 MSGET oGrupo VAR cCodSA1                SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 014, 095 SAY oTitParametro PROMPT "Cliente: "       SIZE 070, 020 OF oDlg PIXEL
        @ 010, 120 MSGET oGrupo VAR cCliSA1                 SIZE 150, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        

        //@ 005, 210 RADIO oRadMenu1 VAR cOpc ITEMS "Nome","Cpf" SIZE 092, 020 OF oDlg COLOR 0, 16777215 PIXEL


        If (AliasOcorren)->(Eof())

            //MsgInfo("Contrato Sem Beneficiarios Vinculados.", "Contratos Medicar")
            aAdd(aGrade, {'','','','','',0}) // DADOS DA GRADE

        Else

            While (AliasOcorren)->(!Eof())
            
                //aAdd(aGrade, { IF((AliasOcorren)->STATUSB = 'ATIVO',.T.,.F.),(AliasBeneCtr)->CARTEIRA,(AliasBeneCtr)->BENEFI,(AliasBeneCtr)->CPF,(AliasBeneCtr)->ATEND,(AliasBeneCtr)->STATUSB,(AliasBeneCtr)->DTBLOQ,(AliasBeneCtr)->DESCBLO,(AliasBeneCtr)->VALOR,(AliasBeneCtr)->TIPO,(AliasBeneCtr)->MATRIC,(AliasBeneCtr)->TIPREG }) // DADOS DA GRADE
                aAdd(aGrade, { (AliasOcorren)->DTOCO,(AliasOcorren)->DESCTIPOCO,(AliasOcorren)->OCORRE,(AliasOcorren)->DTINC,(AliasOcorren)->USUARIO,(AliasOcorren)->IDOCORR }) // DADOS DA GRADE
                
                (AliasOcorren)->(dBskip())

            EndDo


        EndIF
        
        // CRIA A GRADE
        oBrowse := TCBrowse():New( 35 , 5, 485, 200,, {'Dt. Ocorrencia','Tipo Ocorrencia','Ocorrencia','Dt Inclusao','Usuario','Id Ocorrencia'},{50,50,50,50,50,50}, oDlg,,,,,{||},,,,,,,.F.,"aGrade",.T.,,.F.,,, ) //CABECARIO DA GRADE
        oBrowse:SetArray(aGrade)
        oBrowse:bLine := {||{ aGrade[oBrowse:nAt,01],aGrade[oBrowse:nAt,02],aGrade[oBrowse:nAt,03],aGrade[oBrowse:nAt,04],aGrade[oBrowse:nAt,05],aGrade[oBrowse:nAt,06] }} //EXIBICAO DA GRADE
        
        oBrowse:bLDblClick := {|| fVisOcorr(aGrade[oBrowse:nAt,06]) }
        TButton():New( 007, 370 , "Incluir"         , oDlg, {|| fIncOcorr(aGrade) }, 50,018, ,,,.T.,,,,,,)
        TButton():New( 007, 430 , "Voltar"          , oDlg, {|| oDlg:End( ) }, 50,018, ,,,.T.,,,,,,)
    
    ACTIVATE DIALOG oDlg CENTERED

    (AliasOcorren)->(DbCloseArea())


Return


Static Function fIncOcorr(aGrade)

    Local oDlg as object
    Local cCodCli:= SA1->A1_COD
    Local cCoLoja := SA1->A1_LOJA
    Local cNomeCli := SA1->A1_NREDUZ
    Local cCgcCli := SA1->A1_CGC
    Local cTipOco := Space(2)
    Local cDtOco := STOD("")
    Local cDtInc := Date()
    Local cOcorrencia as memo
    Local cCodUser := RetCodUsr()
    Local cUser := UsrRetName(cCodUser)


    DEFINE DIALOG oDlg TITLE "Ocorrencias Clientes Medicar " FROM 0, 0 TO 600, 800 PIXEL
    
        @ 010,020 TO 100,380 LABEL " Dados do Cliente " OF oDlg PIXEL
        
        @ 025,025 SAY oTit PROMPT "Cod. Cli "       SIZE 070, 020 OF oDlg PIXEL
        @ 035,025 MSGET oGrupo VAR  cCodcli         SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025,080 SAY oTit PROMPT "Cliente "        SIZE 070, 020 OF oDlg PIXEL
        @ 035,080 MSGET oGrupo VAR cNomeCli         SIZE 150, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 055,025 SAY oTit PROMPT "Cnpj/Cpf "       SIZE 070, 020 OF oDlg PIXEL
        @ 065,025 MSGET oGrupo VAR cCgcCli          SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"


        @ 110,020 TO 290,380 LABEL " Dados da Ocorrencia " OF oDlg PIXEL

        @ 125, 025 SAY oTitParametro PROMPT " Tipo Ocorrencia "   SIZE 070, 020 OF oDlg PIXEL
        @ 135, 025 MSGET oGrupo VAR cTipOco                       SIZE 100, 011 PIXEL OF oDlg F3 "SX5OM" WHEN .T. Picture "@!"
        
        @ 155, 025 SAY oTitParametro PROMPT " Data Ocorrencia "   SIZE 070, 020 OF oDlg PIXEL
        @ 165, 025 MSGET oGrupo VAR cDtOco                       SIZE 100, 011 PIXEL OF oDlg WHEN .T. Picture "@!"

        @ 185, 025 SAY oTitParametro PROMPT " Data Incluiu "   SIZE 070, 020 OF oDlg PIXEL
        @ 195, 025 MSGET oGrupo VAR cDtInc                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 215, 025 SAY oTitParametro PROMPT " Usuario Inclusao "   SIZE 070, 020 OF oDlg PIXEL
        @ 225, 025 MSGET oGrupo VAR cUser                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 125, 150 SAY oTitParametro PROMPT " Ocorrencia "   SIZE 070, 020 OF oDlg PIXEL
        @ 135,150 GET OMEMO VAR cOcorrencia MEMO             SIZE 220,140 PIXEL OF oDlg WHEN .T.

        TButton():New( 030, 260 , "Salvar"          , oDlg, {|| fIncluir(cCodcli,cCoLoja,cTipOco,cDtInc,cDtOco,cOcorrencia,cCodUser,cUser,aGrade), oDlg:End(),U_ZMEDCLIOCR(cCodcli,cCoLoja) }, 50,018, ,,,.T.,,,,,,)
        TButton():New( 030, 320 , "Voltar"          , oDlg, {|| oDlg:End( ) }, 50,018, ,,,.T.,,,,,,)
    
    ACTIVATE DIALOG oDlg CENTERED


Return


Static Function fVisOcorr(nIdOcorrenia)

    Local oDlg as object
    Local cQueryVis
    Local cCodcli   
    Local cNomeCli  
    Local cCgcCli   
    Local cTipOco
    Local cDtOco
    Local cDtInc
    Local cUser
    Local cOcorrencia
    Private AliasVis := GetNextAlias()
    
    IF nIdOcorrenia = 0 

        cCodcli     := ""
        cNomeCli    := ""
        cCgcCli     := ""
        cTipOco     := ""
        cDtOco      := ""
        cDtInc      := ""
        cUser       := ""
        cOcorrencia := ""

    ELSE
    
        cQueryVis := " SELECT  "
        cQueryVis += " A.ZOM_CODCLI    AS CODCLI, "
        cQueryVis += " A.ZOM_LOJA      AS LOJA, "
        cQueryVis += " C.A1_NOME       AS CLIENTE, "
        cQueryVis += "	CASE  "
        cQueryVis += "		WHEN C.A1_PESSOA = 'F' THEN CONCAT(SUBSTRING(C.A1_CGC,1,3),'.',SUBSTRING(C.A1_CGC,4,3),'.',SUBSTRING(C.A1_CGC,7,3),'-',SUBSTRING(C.A1_CGC,10,2))  "
        cQueryVis += "		ELSE CONCAT(SUBSTRING(C.A1_CGC,1,2),'.',SUBSTRING(C.A1_CGC,3,3),'.',SUBSTRING(C.A1_CGC,6,3),'/',SUBSTRING(C.A1_CGC,9,4),'-',SUBSTRING(C.A1_CGC,13,2))  "
        cQueryVis += "	END             AS CGC,  "
        cQueryVis += " A.ZOM_TIPOCO    AS TIPOCO, "
        cQueryVis += " B.X5_DESCRI     AS DESCTIPOCO, "
        cQueryVis += " CONCAT(SUBSTRING(A.ZOM_DTINC,7,2),'/',SUBSTRING(A.ZOM_DTINC,5,2),'/',SUBSTRING(A.ZOM_DTINC,1,4)) AS DTINC, "
        cQueryVis += " CONCAT(SUBSTRING(A.ZOM_DTOCOR,7,2),'/',SUBSTRING(A.ZOM_DTOCOR,5,2),'/',SUBSTRING(A.ZOM_DTOCOR,1,4)) AS DTOCO, "
        cQueryVis += " ISNULL(CAST(CAST(A.ZOM_OCORRE AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OCORRE, "
        cQueryVis += " A.ZOM_CODUSU    AS CODUSU, "
        cQueryVis += " A.ZOM_USER      AS USUARIO, "
        cQueryVis += " A.R_E_C_N_O_     AS IDOCO "
        cQueryVis += " FROM ZOM010 A "
        cQueryVis += " LEFT JOIN SX5010 B ON B.X5_CHAVE = A.ZOM_TIPOCO AND B.X5_TABELA = 'OM' "
        cQueryVis += " LEFT JOIN SA1010 C ON C.D_E_L_E_T_ = '' AND C.A1_COD = A.ZOM_CODCLI AND C.A1_LOJA = A.ZOM_LOJA "
        cQueryVis += " WHERE 1=1 "
        cQueryVis += " AND A.D_E_L_E_T_ = '' "
        cQueryVis += " AND A.R_E_C_N_O_ = "+Str(nIdOcorrenia,12,0)+" "

        TCQUERY cQueryVis NEW ALIAS (AliasVis)
            
        //Verifica resultado da query
        DbSelectArea(AliasVis)

        (AliasVis)->(DbGoTop())

        cCodcli     := (AliasVis)->CODCLI
        cNomeCli    := (AliasVis)->CLIENTE
        cCgcCli     := (AliasVis)->CGC
        cTipOco     := (AliasVis)->TIPOCO + ' - ' +(AliasVis)->DESCTIPOCO
        cDtOco      := (AliasVis)->DTOCO
        cDtInc      := (AliasVis)->DTINC
        cUser       := (AliasVis)->USUARIO
        cOcorrencia := (AliasVis)->OCORRE

        (AliasVis)->(DbCloseArea())

    EndIF

    DEFINE DIALOG oDlg TITLE "Ocorrencias Clientes Medicar " FROM 0, 0 TO 600, 800 PIXEL
    
        @ 010,020 TO 100,380 LABEL " Dados do Cliente " OF oDlg PIXEL
        
        @ 025,025 SAY oTit PROMPT "Cod. Cli "       SIZE 070, 020 OF oDlg PIXEL
        @ 035,025 MSGET oGrupo VAR  cCodcli         SIZE 040, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 025,080 SAY oTit PROMPT "Cliente "        SIZE 070, 020 OF oDlg PIXEL
        @ 035,080 MSGET oGrupo VAR cNomeCli         SIZE 150, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 055,025 SAY oTit PROMPT "Cnpj/Cpf "       SIZE 070, 020 OF oDlg PIXEL
        @ 065,025 MSGET oGrupo VAR cCgcCli          SIZE 060, 011 PIXEL OF oDlg WHEN .F. Picture "@!"


        @ 110,020 TO 290,380 LABEL " Dados da Ocorrencia " OF oDlg PIXEL

        @ 125, 025 SAY oTitParametro PROMPT " Tipo Ocorrencia "   SIZE 070, 020 OF oDlg PIXEL
        @ 135, 025 MSGET oGrupo VAR cTipOco                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 155, 025 SAY oTitParametro PROMPT " Data Ocorrencia "   SIZE 070, 020 OF oDlg PIXEL
        @ 165, 025 MSGET oGrupo VAR cDtOco                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 185, 025 SAY oTitParametro PROMPT " Data Incluiu "   SIZE 070, 020 OF oDlg PIXEL
        @ 195, 025 MSGET oGrupo VAR cDtInc                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 215, 025 SAY oTitParametro PROMPT " Usuario Inclusao "   SIZE 070, 020 OF oDlg PIXEL
        @ 225, 025 MSGET oGrupo VAR cUser                       SIZE 100, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 125, 150 SAY oTitParametro PROMPT " Ocorrencia "   SIZE 070, 020 OF oDlg PIXEL
        @ 135,150 GET OMEMO VAR cOcorrencia MEMO             SIZE 220,140 PIXEL OF oDlg WHEN .F.

        TButton():New( 030, 310 , "Voltar"          , oDlg, {|| oDlg:End( ) }, 50,018, ,,,.T.,,,,,,)
    
    ACTIVATE DIALOG oDlg CENTERED

    

Return


Static Function fIncluir(cCodcli,cLojaCli,cTipOco,dDtInc,dDtOco,cOcorrencia,cCodUser,cUser,aGrade)

    Local cQueryAtt
    Private AliasAtt := GetNextAlias()

        // Grava Ocorrencia
        RecLock("ZOM", .T.)
            ZOM->ZOM_FILIAL  := ""
            ZOM->ZOM_CODCLI  := alltrim(cCodcli)
            ZOM->ZOM_LOJA    := alltrim(cLojaCli)
            ZOM->ZOM_TIPOCO  := alltrim(cTipOco)
            //ZOM->ZOM_DTINC   := CToD("01/07/2024")
            //ZOM->ZOM_DTOCOR  := CToD("01/07/2024")
            ZOM->ZOM_DTINC   := dDtInc
            ZOM->ZOM_DTOCOR  := dDtOco
            ZOM->ZOM_OCORRE  := alltrim(cOcorrencia)
            ZOM->ZOM_CODUSU  := cCodUser
            ZOM->ZOM_USER    := cUser
        ZOM->(MsUnlock())

        MsgInfo("Ocorrencia Cadastrada Com Sucesso.", "Ocorrencia Clientes Medicar.")
        
    /* -------------- atualizar a grade de visualização --------------  */

    cQueryAtt := " SELECT  "
    cQueryAtt += " CONCAT(SUBSTRING(A.ZOM_DTOCOR,7,2),'/',SUBSTRING(A.ZOM_DTOCOR,5,2),'/',SUBSTRING(A.ZOM_DTOCOR,1,4)) AS DTOCO, "
    cQueryAtt += " B.X5_DESCRI     AS DESCTIPOCO, "
    cQueryAtt += " ISNULL(CAST(CAST(A.ZOM_OCORRE AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OCORRE, "
    cQueryAtt += " CONCAT(SUBSTRING(A.ZOM_DTINC,7,2),'/',SUBSTRING(A.ZOM_DTINC,5,2),'/',SUBSTRING(A.ZOM_DTINC,1,4)) AS DTINC, "
    cQueryAtt += " A.ZOM_USER      AS USUARIO, "
    cQueryAtt += " C.A1_COD        AS CODCLI, "
    cQueryAtt += " C.A1_NOME       AS CLIENTE,
    cQueryAtt += " A.R_E_C_N_O_    AS IDOCORR "
    cQueryAtt += " FROM ZOM010 A "
    cQueryAtt += " LEFT JOIN SX5010 B ON B.X5_CHAVE = A.ZOM_TIPOCO AND B.X5_TABELA = 'OM' "
    cQueryAtt += " LEFT JOIN SA1010 C ON C.D_E_L_E_T_ = '' AND C.A1_COD = A.ZOM_CODCLI AND C.A1_LOJA = A.ZOM_LOJA "
    cQueryAtt += " WHERE 1=1 "
    cQueryAtt += " AND A.D_E_L_E_T_ = '' "
    cQueryAtt += " AND A.ZOM_CODCLI = '"+cCodCli+"' "
    cQueryAtt += " AND A.ZOM_LOJA = '"+cLojaCli+"' "
    cQueryAtt += " ORDER BY A.ZOM_DTOCOR DESC "

    TCQUERY cQueryAtt NEW ALIAS (AliasAtt)

        aGrade := {}

        While (AliasOcorren)->(!Eof())
        
            //aAdd(aGrade, { IF((AliasOcorren)->STATUSB = 'ATIVO',.T.,.F.),(AliasBeneCtr)->CARTEIRA,(AliasBeneCtr)->BENEFI,(AliasBeneCtr)->CPF,(AliasBeneCtr)->ATEND,(AliasBeneCtr)->STATUSB,(AliasBeneCtr)->DTBLOQ,(AliasBeneCtr)->DESCBLO,(AliasBeneCtr)->VALOR,(AliasBeneCtr)->TIPO,(AliasBeneCtr)->MATRIC,(AliasBeneCtr)->TIPREG }) // DADOS DA GRADE
            aAdd(aGrade, { (AliasAtt)->DTOCO,(AliasAtt)->DESCTIPOCO,(AliasAtt)->OCORRE,(AliasAtt)->DTINC,(AliasAtt)->USUARIO,(AliasAtt)->IDOCORR }) // DADOS DA GRADE
            
            (AliasOcorren)->(dBskip())

        EndDo

Return
