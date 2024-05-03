#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWBROWSE.CH'

/* ---------------------------------------------------------- */
//
//      TELA DE CONSULTA DE BENEFICIARIOS POR CONTRATO
//
// EMPRESA: MEDICAR
// POR: EDUARDO AMARAL
// DATA: 16/02/2024
// CONTRATOS PJ BQC - TIPBLO = 0  E DATBLO <> ''(É BLOEUQADO/INATIVO)
// CONTRATOS PF BA3 - MOTBLO <> '' E DATBLO <> '' (É BLOQUEADO/INATIVO)
//
// lib: https://tdn.totvs.com/display/public/framework/FWTemporaryTable
/* --------------------------------------------------------- */

/* -------------------------------------------------- BENEFICIARIOS -------------------------------------------------- */

User function ZMEDBENEF()

    local lRet as logical
    local aArea as array
    local cQuery as character
    local oBrwBen as object
    local oTableBen as object
    local aTamX3Flds as array
    local aFields as array
    local aIndex as array
    local aSeek as array
    local oDlgBen as object
    local aCoors as array
    Local aBrowse := {}
    Local cTitulo := "Beneficiarios Medicar"

    lRet := .F.
    aArea := GetArea()
    aTamX3Flds := {}
    aFields := {}
    aIndex := {}
    aSeek := {}

    aAdd(aTamX3Flds, TamSX3("BA1_XCARTE"))
    aAdd(aTamX3Flds, TamSX3("BA1_NOMUSR"))
    aAdd(aTamX3Flds, TamSX3("BDK_VALOR"))
    aAdd(aTamX3Flds, TamSX3("BA1_TIPUSU"))
    aAdd(aTamX3Flds, TamSX3("BA1_FILIAL"))
    aAdd(aTamX3Flds, TamSX3("BA1_CODINT"))
    aAdd(aTamX3Flds, TamSX3("BA1_CODEMP"))
    aAdd(aTamX3Flds, TamSX3("BA1_CONEMP"))
    aAdd(aTamX3Flds, TamSX3("BA1_VERCON"))
    aAdd(aTamX3Flds, TamSX3("BA1_SUBCON"))
    aAdd(aTamX3Flds, TamSX3("BA1_VERSUB"))
    aAdd(aTamX3Flds, TamSX3("BA1_MATEMP"))
    aAdd(aTamX3Flds, TamSX3("BA1_DATNAS"))
    aAdd(aTamX3Flds, TamSX3("BA1_DATINC"))
       
    aAdd(aFields, {"CARTEIRA",   aTamX3Flds[1][3], aTamX3Flds[1][1],  aTamX3Flds[1][2]})
    aAdd(aFields, {"BENEFI",     aTamX3Flds[2][3], aTamX3Flds[2][1],  aTamX3Flds[2][2]})
    aAdd(aFields, {"CPF",        "C",              18,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"ATEND",      "C",              3 ,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"TELEESP",    "C",              3 ,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"STATUSB",    "C",              10,                0}) // TIPO | TAMANHO | DECIMAL
    aAdd(aFields, {"VALOR",      aTamX3Flds[3][3], aTamX3Flds[3][1],  aTamX3Flds[3][2]})
    aAdd(aFields, {"TIPO",       aTamX3Flds[4][3], aTamX3Flds[4][1],  aTamX3Flds[4][2]})
    aAdd(aFields, {"FILIAL",     aTamX3Flds[5][3], aTamX3Flds[5][1],  aTamX3Flds[5][2]})
    aAdd(aFields, {"CODINT",     aTamX3Flds[6][3], aTamX3Flds[6][1],  aTamX3Flds[6][2]})
    aAdd(aFields, {"CODEMP",     aTamX3Flds[7][3], aTamX3Flds[7][1],  aTamX3Flds[7][2]})
    aAdd(aFields, {"CONEMP",     aTamX3Flds[8][3], aTamX3Flds[8][1],  aTamX3Flds[8][2]})
    aAdd(aFields, {"VERCON",     aTamX3Flds[9][3], aTamX3Flds[9][1],  aTamX3Flds[9][2]})
    aAdd(aFields, {"SUBCON",     aTamX3Flds[10][3], aTamX3Flds[10][1],  aTamX3Flds[10][2]})
    aAdd(aFields, {"VERSUB",     aTamX3Flds[11][3], aTamX3Flds[11][1],  aTamX3Flds[11][2]})
    aAdd(aFields, {"MATEMP",     aTamX3Flds[12][3], aTamX3Flds[12][1],  aTamX3Flds[12][2]})
    aAdd(aFields, {"DATNAS",     aTamX3Flds[13][3], aTamX3Flds[13][1],  aTamX3Flds[13][2]})
    aAdd(aFields, {"DATINC",     aTamX3Flds[14][3], aTamX3Flds[14][1],  aTamX3Flds[14][2]})

    aAdd(aIndex, {"Cpf"})
    aAdd(aIndex, {"Nome"})
        
    aAdd(aSeek, {"Cpf"              , {{"LookUp", "C", 18, 0, "Cpf",,}} , 1, .T. }) // TIPO | TAMANHO | 0
    aAdd(aSeek, {"Nome"             , {{"LookUp", "C" ,70, 0, "Nome",,}} , 2, .T. }) // TIPO | TAMANHO | 0

    oTableBen := FWTemporaryTable():New()
    oTableBen:setFields(aFields)
    oTableBen:addIndex("INDEX1", {"CPF"})
    oTableBen:addIndex("INDEX2", {"BENEFI"})
    oTableBen:create()


    cQuery := "INSERT INTO " + oTableBen:getRealName()
    cQuery += " (CARTEIRA,BENEFI,CPF,ATEND,TELEESP,STATUSB,VALOR,TIPO,FILIAL,CODINT,CODEMP,CONEMP,VERCON,SUBCON,VERSUB,MATEMP,DATNAS,DATINC) "
    cQuery += " SELECT  "
    cQuery += " C.BA1_XCARTE      AS CARTEIRA,  "
    cQuery += " C.BA1_NOMUSR      AS BENEFI,  "
    cQuery += " CASE  "
    cQuery += " WHEN LEN(C.BA1_CPFUSR) > 11 THEN CONCAT(SUBSTRING(C.BA1_CPFUSR,1,2),'.',SUBSTRING(C.BA1_CPFUSR,3,3),'.',SUBSTRING(C.BA1_CPFUSR,6,3),'/',SUBSTRING(C.BA1_CPFUSR,9,4),'-',SUBSTRING(C.BA1_CPFUSR,13,2)) "
    cQuery += " ELSE CONCAT(SUBSTRING(C.BA1_CPFUSR,1,3),'.',SUBSTRING(C.BA1_CPFUSR,4,3),'.',SUBSTRING(C.BA1_CPFUSR,7,3),'-',SUBSTRING(C.BA1_CPFUSR,10,2))  "
    cQuery += " END               AS CPF,  "
    cQuery += " CASE  "
    cQuery += " WHEN C.BA1_ZATEND = '1' THEN 'SIM'  "
    cQuery += " ELSE 'NAO'  "
    cQuery += " END               AS ATEND,  "
    cQuery += " CASE   "
    cQuery += " WHEN A.BQC_ESPTEL = '1' THEN 'SIM'  "
    cQuery += " WHEN B.BA3_ESPTEL = '1' THEN 'SIM'  "
    cQuery += " ELSE 'NAO'  "
    cQuery += " END               AS TELEESP, "
    cQuery += " CASE  "
    cQuery += " WHEN C.BA1_DATBLO <> '' AND C.BA1_MOTBLO <> '' THEN 'INATIVO'  "
    cQuery += " WHEN C.BA1_DATBLO = ''  AND C.BA1_MOTBLO = '' AND A.BQC_ESPTEL =  '1' THEN 'ATIVOCESP'  "
    cQuery += " WHEN C.BA1_DATBLO = ''  AND C.BA1_MOTBLO = '' AND B.BA3_ESPTEL =  '1' THEN 'ATIVOCESP'  "
    cQuery += " WHEN C.BA1_DATBLO = ''  AND C.BA1_MOTBLO = '' AND C.BA1_ZATEND =  '1' THEN 'ATIVOCATM'  "
    cQuery += " ELSE 'U'  "
    cQuery += " END               AS STATUSB,  "
    cQuery += " SUM(D.BDK_VALOR)  AS VALOR,  "
    cQuery += " C.BA1_TIPUSU      AS TIPO,  "
    cQuery += " C.BA1_FILIAL      AS FILIAL,  "
    cQuery += " C.BA1_CODINT      AS CODINT,  "
    cQuery += " C.BA1_CODEMP      AS CODEMP,  "
    cQuery += " C.BA1_CONEMP      AS CONEMP,  "
    cQuery += " C.BA1_VERCON      AS VERCON,  "
    cQuery += " C.BA1_SUBCON      AS SUBCON,  "
    cQuery += " C.BA1_VERSUB      AS VERSUB,  "
    cQuery += " C.BA1_MATEMP      AS MATEMP,  "
    cQuery += " C.BA1_DATNAS      AS DATNAS,  "
    cQuery += " C.BA1_DATINC      AS DATINC  "
    cQuery += " FROM BQC010 A  "
    cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON   "
    cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP  "
    cQuery += " LEFT JOIN BDK010 D ON D.D_E_L_E_T_ = '' AND D.BDK_FILIAL = C.BA1_FILIAL AND D.BDK_CODINT = C.BA1_CODINT AND D.BDK_CODEMP = C.BA1_CODEMP AND D.BDK_MATRIC = C.BA1_MATRIC AND D.BDK_TIPREG = C.BA1_TIPREG   "
    cQuery += " LEFT JOIN BT5010 E ON E.D_E_L_E_T_ = '' AND E.BT5_FILIAL = A.BQC_FILIAL AND E.BT5_CODINT = A.BQC_CODINT AND E.BT5_CODIGO = A.BQC_CODEMP AND E.BT5_NUMCON = A.BQC_NUMCON AND E.BT5_VERSAO = A.BQC_VERCON  "
    cQuery += " WHERE 1=1   "
    cQuery += " AND A.D_E_L_E_T_ = ''  "
    cQuery += " AND C.BA1_NOMUSR <> ''  "
    cQuery += " GROUP BY C.BA1_XCARTE,C.BA1_NOMUSR,C.BA1_CPFUSR,C.BA1_ZATEND,BA1_DATBLO,BA1_MOTBLO,C.BA1_TIPUSU,A.BQC_ESPTEL,B.BA3_ESPTEL,C.BA1_TIPUSU,C.BA1_FILIAL,C.BA1_CODINT,C.BA1_CODEMP,C.BA1_CONEMP,C.BA1_VERCON,C.BA1_SUBCON,C.BA1_VERSUB,C.BA1_MATEMP,C.BA1_DATNAS,C.BA1_DATINC "

    if TCSqlExec(cQuery) >= 0

        aAdd(aBrowse, {"Carteira",      "CARTEIRA",     "C",aTamX3Flds[1][1]      ,0,"@!"})
        aAdd(aBrowse, {"Cpf",           "CPF",          "C",18                    ,0,"@!"})
        aAdd(aBrowse, {"Beneficiario",  "BENEFI",       "C",aTamX3Flds[2][1]      ,0,"@!"})
        aAdd(aBrowse, {"Tipo",          "TIPO",         "C",aTamX3Flds[4][1]      ,0,"@!"})
        aAdd(aBrowse, {"Tem Atend",     "ATEND",        "C",3                     ,0,"@!"})
        aAdd(aBrowse, {"Telemed Esp.",  "TELEESP",      "C",3                     ,0,"@!"})
        aAdd(aBrowse, {"Valor",         "VALOR",        "C",aTamX3Flds[3][1]      ,0,"@E 999,999,999.99"})
        aAdd(aBrowse, {"Dt Mascimento", "DATNAS",        "C",aTamX3Flds[13][1]    ,0,"@!"})
        aAdd(aBrowse, {"Dt Inclusao",   "DATINC",        "C",aTamX3Flds[14][1]    ,0,"@!"})
        

        aCoors := FWGetDialogSize()

        //Se os botões de Ok e Fecha devem fechar o browse, então você deve ser o responsável pelo oOwner do browse
        oDlgBen = MsDialog():New( aCoors[1], aCoors[2], aCoors[3], aCoors[4], "",,,.F., nOR(WS_VISIBLE, WS_POPUP),,,,,.T.,, ,.F. )

        oBrwBen := FWMBrowse():New(oDlgBen)
        oBrwBen:SetDescription(cTitulo)     
        oBrwBen:SetDataTable()
        oBrwBen:SetTemporary(.T.)
        
        oBrwBen:SetAlias(oTableBen:getAlias())

        //oBrwBen:AddButton( "Voltar"  ,{|| lRet := .T., oDlgBen:end() } ,, 2 )
        oBrwBen:AddButton( "Filtro de Tela"  , {|| FiltroTela() } ,, 3 ) 
        oBrwBen:AddButton( "Resumo Contrato"  , {|| U_ZMEDRESCTR((oTableBen:getAlias())->FILIAL,(oTableBen:getAlias())->CODINT,(oTableBen:getAlias())->CODEMP,(oTableBen:getAlias())->CONEMP,(oTableBen:getAlias())->VERCON,(oTableBen:getAlias())->SUBCON,(oTableBen:getAlias())->VERSUB,(oTableBen:getAlias())->MATEMP)} ,, 4 ) 
     
        oBrwBen:SetQueryIndex(aIndex)
        oBrwBen:SetUseFilter(.T.) //Using Filter
        oBrwBen:SetSeek(.T.,aSeek)
        oBrwBen:SetFields(aBrowse)

        //Adicionando legendas (alguns exemplos - PINK, WHITE, GRAY, YELLOW, ORANGE, BLACK, BLUE)
        //oBrwBen:AddLegend( " STATUSB = 'ATIVO' "    , "GREEN"       ,  "Ativo" )
        
        oBrwBen:AddLegend( " STATUSB = 'ATIVOCESP' " , "BLUE"       ,  "Ativo Com Especialidade" )        
        oBrwBen:AddLegend( " STATUSB = 'ATIVOCATM' " , "GREEN"      ,  "Ativo Com Atendimtno" )
        oBrwBen:AddLegend( " STATUSB = 'INATIVO' "   , "RED"        ,  "Bloqueado" )
        oBrwBen:AddLegend( " STATUSB = 'U' "         , "GRAY"       ,  "Ativo sem Atendimento/Especialidade" )
        
        oBrwBen:Activate(oDlgBen)
        oDlgBen:Activate()

        oBrwBen:deActivate()
        oBrwBen:destroy()
        FreeObj(oBrwBen)
        oBrwBen := nil
    else

        lRet := .F.
        // Caso deseja gerar exceção...
        // UserException(TCSqlError())

    endif

    oTableBen:delete()
    FreeObj(oTableBen)
    oTableBen := nil

    RestArea(aArea)

Return lRet


Static Function FiltroTela()

    MsgInfo("Em Desenvolvimento.", "Beneficiarios Medicar")

Return
