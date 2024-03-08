#INCLUDE 'protheus.ch'
#INCLUDE "TOPCONN.CH"

/*
-----------------------------------------------------------------------------# 
							 U_ZTRASNFCTR   							     #
-----------------------------------------------------------------------------# 
Funcao:  U_ZTRASNFCTR														 #
Autor: Eduardo Jorge 													     #
Data: 26/02/2024														     #
Descricao: TRANFERENCIA GRUPO EMPRESA DE CONTRATOS PJ E PF                   #
*****************************************************************************#
*/

/*

    CONSULTAS PADRAO: ZCTRSB, ZCTRFM , ZCTRGP

    PJ = 001020077
    PF = 2519845   

SELECT
A.BQC_SUBCON,
A.BQC_CODEMP AS BQC,
B.BA3_CODEMP AS BA3,
C.BA1_CODEMP AS BA1,
D.BDQ_CODEMP AS BDQ,
E.BQD_CODIGO AS BQD,
F.BT6_CODIGO AS BT6,
G.BDK_CODEMP AS BDK,
H.BF4_CODEMP AS BF4,
'-------------' AS SEPARADOR,
A.R_E_C_N_O_  AS REC_BQC,
B.R_E_C_N_O_  AS REC_BA3,
C.R_E_C_N_O_  AS REC_BA1,
D.R_E_C_N_O_  AS REC_BDQ,
E.R_E_C_N_O_  AS REC_BQD,
F.R_E_C_N_O_  AS REC_BT6,
G.R_E_C_N_O_  AS REC_BDK,
H.R_E_C_N_O_  AS REC_BF4
FROM BQC010 A
LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''
LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''
LEFT JOIN BDQ010 D ON D.BDQ_FILIAL = C.BA1_FILIAL AND D.BDQ_CODINT = C.BA1_CODINT AND D.BDQ_CODEMP = C.BA1_CODEMP AND D.BDQ_MATRIC = C.BA1_MATRIC AND D.BDQ_CODEMP = C.BA1_CODEMP AND D.BDQ_TIPREG = C.BA1_TIPREG AND D.D_E_L_E_T_ = ''
LEFT JOIN BQD010 E ON E.BQD_SUBCON = A.BQC_SUBCON AND E.D_E_L_E_T_ = ''
LEFT JOIN BT6010 F ON F.BT6_SUBCON = A.BQC_SUBCON AND F.D_E_L_E_T_ = ''
LEFT JOIN BDK010 G ON G.BDK_FILIAL = C.BA1_FILIAL AND G.BDK_CODINT = C.BA1_CODINT AND G.BDK_CODEMP = C.BA1_CODEMP AND G.BDK_MATRIC = C.BA1_MATRIC AND G.BDK_TIPREG = C.BA1_TIPREG AND G.D_E_L_E_T_ = ''
LEFT JOIN BF4010 H ON H.BF4_FILIAL = C.BA1_FILIAL AND H.BF4_CODINT = C.BA1_CODINT AND H.BF4_CODEMP = C.BA1_CODEMP AND H.BF4_MATRIC = C.BA1_MATRIC AND H.BF4_TIPREG = C.BA1_TIPREG AND H.D_E_L_E_T_ = ''
WHERE 1=1
AND A.D_E_L_E_T_ = ''
AND A.BQC_SUBCON = '001020077'
AND B.BA3_MATEMP = '2519845'


*/


User Function ZTRASNFCTR()

    //Local aArea   	          := GetArea()
    Private cCombo 		      := " "
    Private aItems 		      := {"Contrato PF","Contrato PJ"}
    Private cCtrPF            := Space(10)
    Private cContratoPJ       := Space(10)
    Private cFilialCtr        := Space(3)
    Private cGrupo            := Space(4)
    Private cPerfil           := Space(70)
    Private cCpfCnpj          := Space(18)
    Private cNome             := Space(70)
    Private cDescGrupoOrigem  := Space(30)
    Private cGrpDest          := Space(4)
    Private cDescGrpDest      := Space(30)


    
    DEFINE MSDIALOG oDlg FROM 05,10 TO 500,650 TITLE "TRANFERENCIA DE CONTRATO" PIXEL

        @ 010,020 TO 130,300 LABEL " SELECIONE O CONTRATO " OF oDlg PIXEL

        @ 030, 025 SAY oTipoContrato PROMPT "Tipo de Contrato: " SIZE 150, 020 OF oDlg PIXEL
        oCombo := TComboBox():New(025,070,,aItems,060,020,oDlg,,,,,,.T.,,,,,,,,,)
        oCombo:bSetGet:= {|u|if(PCount()==0,cCombo,cCombo:=u)}

        /* --------------------------------------- CONTRATO --------------------------------------- */

        @ 055, 025 SAY oTitContratoPJ PROMPT "Contrato PJ: "                SIZE 070, 020 OF oDlg PIXEL
        @ 050, 060 MSGET oContratoPJ VAR cContratoPJ                        SIZE 050, 011 PIXEL OF oDlg F3 "ZCTRSB" VALID fBuscaContrato() When If( cCombo = "Contrato PJ", .T. , .F. ) Picture "@!"
        @ 055, 115 SAY oTitCtrPF PROMPT "Contrato PF: "                     SIZE 070, 020 OF oDlg PIXEL
        @ 050, 150 MSGET oCtrPF VAR cCtrPF                                  SIZE 050, 011 PIXEL OF oDlg F3 "ZCTRFM" VALID fBuscaContrato() When If( cCombo = "Contrato PF", .T. , .F. ) Picture "@!"
       
        @ 075, 025 SAY oTitFilial PROMPT "Filial: "                         SIZE 070, 020 OF oDlg PIXEL
        @ 070, 050 MSGET oFilial VAR cFilialCtr                             SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 075, 115 SAY oTitGrupoEmpresa PROMPT "Grupo Empresa: "            SIZE 070, 020 OF oDlg PIXEL
        @ 070, 155 MSGET oGrupo VAR cGrupo                                  SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 095, 025 SAY oTitPErfil PROMPT "Pefil: "                          SIZE 070, 020 OF oDlg PIXEL
        @ 090, 050 MSGET oPerfil VAR cPerfil                                SIZE 120, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        
        @ 095, 175 SAY oTitCpfCnpj PROMPT "Cpf/Cnpj: "                      SIZE 070, 020 OF oDlg PIXEL 
        @ 090, 200 MSGET oCpfCnpj VAR cCpfCnpj                              SIZE 080, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        @ 115, 025 SAY oTitNome PROMPT "Nome: "                             SIZE 070, 020 OF oDlg PIXEL
        @ 110, 050 MSGET oNome VAR cNome                                    SIZE 180, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        /* --------------------------------------- TRANFERENCIA --------------------------------------- */

        @ 140,020 TO 230,300 LABEL " TRANSFERENCIA " OF oDlg PIXEL

        @ 160, 025 SAY oTitGrupoOrigem PROMPT "Grupo Origem: "                     SIZE 070, 020 OF oDlg PIXEL
        @ 155, 065 MSGET oGrupoOrigem     VAR cGrupo                               SIZE 050, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
        @ 170, 025 MSGET oGrupoOrigemDesc VAR cDescGrupoOrigem                     SIZE 120, 011 PIXEL OF oDlg WHEN .F. Picture "@!"
    
        @ 200, 025 SAY oTitGrpEmpDestino PROMPT "Grupo Destino: "                  SIZE 070, 020 OF oDlg PIXEL
        @ 195, 065 MSGET oGrpDestino     VAR cGrpDest                              SIZE 050, 011 PIXEL OF oDlg F3 "ZCTRGP" VALID fBuscaGrupoDestino() Picture "@!"
        @ 210, 025 MSGET oGrpDescDestino VAR cDescGrpDest                          SIZE 120, 011 PIXEL OF oDlg WHEN .F. Picture "@!"

        oButtonTransf:= TButton():New( 210, 220, "Transferir",oDlg,{|| fConfirmaTransf() }, 030, 012,,,.F.,.T.,.F.,,.F.,,,.F. )
        oButtonClose := TButton():New( 210, 260, "Fechar",oDlg,{|| oDlg:End() }, 030, 012,,,.F.,.T.,.F.,,.F.,,,.F. )
      
    //DEFINE SBUTTON FROM 210,260 TYPE 1 ACTION ( oDlg:End()) ENABLE OF oDlg
    ACTIVATE MSDIALOG oDlg CENTER

Return()

Static Function fBuscaContrato()

    Local cQuery

    if cCombo = "Contrato PJ"

        cCtrPF := Space(10)

        cQuery := " SELECT TOP 1 "
        cQuery += " C.BA1_FILIAL AS FILIAL, "
        cQuery += " A.BQC_CODEMP AS GRUPOEMPRESA, "
        cQuery += " D.BT5_NOME   AS PERFIL,  "
        cQuery += " A.BQC_CNPJ   AS CNPJ, "
        cQuery += " A.BQC_DESCRI AS NOME, "
        cQuery += " E.BG9_DESCRI AS DESCGRUPO "
        cQuery += " FROM BQC010 A  "
        cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP "
        cQuery += " LEFT JOIN BT5010 D ON D.D_E_L_E_T_ = '' AND D.BT5_FILIAL = A.BQC_FILIAL AND D.BT5_CODINT = A.BQC_CODINT AND D.BT5_CODIGO = A.BQC_CODEMP AND D.BT5_NUMCON = A.BQC_NUMCON AND D.BT5_VERSAO = A.BQC_VERCON "
        cQuery += " LEFT JOIN BG9010 E ON E.D_E_L_E_T_ = '' AND E.BG9_FILIAL = A.BQC_FILIAL AND E.BG9_CODINT = A.BQC_CODINT AND E.BG9_CODIGO = A.BQC_CODEMP "
        cQuery += " WHERE 1=1  "
        cQuery += " AND A.D_E_L_E_T_ = ''  "
        cQuery += " AND A.BQC_SUBCON = '"+cContratoPJ+"' "

        TcQuery cQuery New Alias AliasCtr
        dbSelectArea("AliasCtr")

            cFilialCtr       := AliasCtr->FILIAL
            cGrupo           := AliasCtr->GRUPOEMPRESA
            cPerfil          := AliasCtr->PERFIL
            cCpfCnpj         := AliasCtr->CNPJ
            cNome            := AliasCtr->NOME
            cGrupoOrigem     := AliasCtr->GRUPOEMPRESA
            cDescGrupoOrigem := AliasCtr->DESCGRUPO

        AliasCtr->(dbCloseArea())
    
    Else

        cContratoPJ := Space(10)

        cQuery := " SELECT TOP 1 "
        cQuery += " C.BA1_FILIAL   AS FILIAL, "
        cQuery += " C.BA1_CODEMP   AS GRUPOEMPRESA, "
        cQuery += " D.BT5_NOME     AS PERFIL,  "
        cQuery += " C.BA1_CPFUSR   AS CNPJ, "
        cQuery += " C.BA1_NOMUSR   AS NOME, "
        cQuery += " E.BG9_DESCRI   AS DESCGRUPO "
        cQuery += " FROM BQC010 A  "
        cQuery += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON "
        cQuery += " LEFT JOIN BA1010 C ON C.D_E_L_E_T_ = '' AND C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP "
        cQuery += " LEFT JOIN BT5010 D ON D.D_E_L_E_T_ = '' AND D.BT5_FILIAL = A.BQC_FILIAL AND D.BT5_CODINT = A.BQC_CODINT AND D.BT5_CODIGO = A.BQC_CODEMP AND D.BT5_NUMCON = A.BQC_NUMCON AND D.BT5_VERSAO = A.BQC_VERCON "
        cQuery += " LEFT JOIN BG9010 E ON E.D_E_L_E_T_ = '' AND E.BG9_FILIAL = A.BQC_FILIAL AND E.BG9_CODINT = A.BQC_CODINT AND E.BG9_CODIGO = A.BQC_CODEMP "
        cQuery += " WHERE 1=1  "
        cQuery += " AND A.D_E_L_E_T_ = ''  "
        cQuery += " AND C.BA1_TIPREG = '00'  "
        cQuery += " AND B.BA3_MATEMP = '"+cCtrPF+"' "

        TcQuery cQuery New Alias AliasCtrPF
        dbSelectArea("AliasCtrPF")

            cFilialCtr       := AliasCtrPF->FILIAL
            cGrupo           := AliasCtrPF->GRUPOEMPRESA
            cPerfil          := AliasCtrPF->PERFIL
            cCpfCnpj         := AliasCtrPF->CNPJ
            cNome            := AliasCtrPF->NOME
            cGrupoOrigem     := AliasCtrPF->GRUPOEMPRESA
            cDescGrupoOrigem := AliasCtrPF->DESCGRUPO

        AliasCtrPF->(dbCloseArea())

    Endif

Return

Static Function fBuscaGrupoDestino()

    Local cQueryGrupo

    cQueryGrupo := " SELECT BG9_DESCRI AS GRUPODESC FROM BG9010 WHERE D_E_L_E_T_ = '' AND BG9_CODIGO = '"+cGrpDest+"' "

    TcQuery cQueryGrupo New Alias AliasGrupo
    dbSelectArea("AliasGrupo")

    cDescGrpDest := AliasGrupo->GRUPODESC

    AliasGrupo->(dbCloseArea())

Return

Static Function fTransferir()

    If cCombo = "Contrato PJ"
    // CONTRATOS PESSOA JURIDICA
    /* BQC | BA3 | BA1| BQD | BT6 | BDK  | BF4  */

        /*BQC*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BQC010 "
            cQryUpd += "        SET BQC010.BQC_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BQC010 "
            cQryUpd += "    WHERE"
            cQryUpd += "    BQC010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BQC010.BQC_SUBCON = '"+cContratoPJ+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BA3*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BA3010 "
            cQryUpd += "        SET BA3010.BA3_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BA3010 "
            cQryUpd += "    WHERE"
            cQryUpd += "    BA3010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA3010.BA3_SUBCON = '"+cContratoPJ+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BDQ*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BDQ010 "
            cQryUpd += "        SET BDQ010.BDQ_CODEMP = '"+cGrpDest+"' " 
            cQryUpd += "    FROM BDQ010 "
            cQryUpd += "    INNER JOIN BA1010" 
            cQryUpd += "        ON  BA1010.BA1_FILIAL = BDQ010.BDQ_FILIAL "
            cQryUpd += "        AND BA1010.BA1_CODINT = BDQ010.BDQ_CODINT "
            cQryUpd += "        AND BA1010.BA1_CODEMP = BDQ010.BDQ_CODEMP "
            cQryUpd += "        AND BA1010.BA1_MATRIC = BDQ010.BDQ_MATRIC "
            cQryUpd += "        AND BA1010.BA1_TIPREG = BDQ010.BDQ_TIPREG "
            cQryUpd += "        AND BA1010.D_E_L_E_T_ = '' "    
            cQryUpd += "    WHERE"
            cQryUpd += "    BDQ010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_SUBCON = '"+cContratoPJ+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BQD*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BQD010 "
            cQryUpd += "        SET BQD010.BQD_CODIGO = '"+("1001"+cGrpDest)+"' " //(PRECISA SER 1001 + cGrpDest)
            cQryUpd += "    FROM BQD010 "
            cQryUpd += "    WHERE"
            cQryUpd += "    BQD010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BQD010.BQD_SUBCON = '"+cContratoPJ+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BT6*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BT6010 "
            cQryUpd += "        SET BT6010.BT6_CODIGO = '"+cGrpDest+"' " 
            cQryUpd += "    FROM BT6010 "
            cQryUpd += "    WHERE"
            cQryUpd += "    BT6010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BT6010.BT6_SUBCON = '"+cContratoPJ+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BDK*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BDK010 "
            cQryUpd += "        SET BDK010.BDK_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BDK010 "
            cQryUpd += "    INNER JOIN BA1010" 
            cQryUpd += "        ON  BA1010.BA1_FILIAL = BDK010.BDK_FILIAL "
            cQryUpd += "        AND BA1010.BA1_CODINT = BDK010.BDK_CODINT "
            cQryUpd += "        AND BA1010.BA1_CODEMP = BDK010.BDK_CODEMP "
            cQryUpd += "        AND BA1010.BA1_MATRIC = BDK010.BDK_MATRIC "
            cQryUpd += "        AND BA1010.BA1_TIPREG = BDK010.BDK_TIPREG "
            cQryUpd += "        AND BA1010.D_E_L_E_T_ = '' "    
            cQryUpd += "    WHERE"
            cQryUpd += "    BDK010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_SUBCON = '"+cContratoPJ+"' "


            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BF4*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BF4010 "
            cQryUpd += "        SET BF4010.BF4_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BF4010 "
            cQryUpd += "    INNER JOIN BA1010" 
            cQryUpd += "        ON  BA1010.BA1_FILIAL = BF4010.BF4_FILIAL "
            cQryUpd += "        AND BA1010.BA1_CODINT = BF4010.BF4_CODINT "
            cQryUpd += "        AND BA1010.BA1_CODEMP = BF4010.BF4_CODEMP "
            cQryUpd += "        AND BA1010.BA1_MATRIC = BF4010.BF4_MATRIC "
            cQryUpd += "        AND BA1010.BA1_TIPREG = BF4010.BF4_TIPREG "
            cQryUpd += "        AND BA1010.D_E_L_E_T_ = '' "    
            cQryUpd += "    WHERE"
            cQryUpd += "    BF4010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_SUBCON = '"+cContratoPJ+"' "

         

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BA1*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BA1010 "
            cQryUpd += "        SET BA1010.BA1_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BA1010 "
            cQryUpd += "    WHERE"
            cQryUpd += "    BA1010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_SUBCON = '"+cContratoPJ+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        MsgInfo( "Contrato Transferido!", "Transferencia de Contrato" )

    Else
    // CONTRATOS PESSOAS FISICA
    /* BA3 | BA1| BDK | BDQ | BF4  */

        /*BA3*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BA3010 "
            cQryUpd += "        SET BA3010.BA3_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BA3010 "
            cQryUpd += "    WHERE"
            cQryUpd += "    BA3010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA3010.BA3_MATEMP = '"+cCtrPF+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BDQ*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BDQ010 "
            cQryUpd += "        SET BDQ010.BDQ_CODEMP = '"+cGrpDest+"' " 
            cQryUpd += "    FROM BDQ010 "
            cQryUpd += "    INNER JOIN BA1010" 
            cQryUpd += "        ON  BA1010.BA1_FILIAL = BDQ010.BDQ_FILIAL "
            cQryUpd += "        AND BA1010.BA1_CODINT = BDQ010.BDQ_CODINT "
            cQryUpd += "        AND BA1010.BA1_CODEMP = BDQ010.BDQ_CODEMP "
            cQryUpd += "        AND BA1010.BA1_MATRIC = BDQ010.BDQ_MATRIC "
            cQryUpd += "        AND BA1010.BA1_TIPREG = BDQ010.BDQ_TIPREG "
            cQryUpd += "        AND BA1010.D_E_L_E_T_ = '' "    
            cQryUpd += "    WHERE"
            cQryUpd += "    BDQ010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_MATEMP = '"+cCtrPF+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BDK*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BDK010 "
            cQryUpd += "        SET BDK010.BDK_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BDK010 "
            cQryUpd += "    INNER JOIN BA1010" 
            cQryUpd += "        ON  BA1010.BA1_FILIAL = BDK010.BDK_FILIAL "
            cQryUpd += "        AND BA1010.BA1_CODINT = BDK010.BDK_CODINT "
            cQryUpd += "        AND BA1010.BA1_CODEMP = BDK010.BDK_CODEMP "
            cQryUpd += "        AND BA1010.BA1_MATRIC = BDK010.BDK_MATRIC "
            cQryUpd += "        AND BA1010.BA1_TIPREG = BDK010.BDK_TIPREG "
            cQryUpd += "        AND BA1010.D_E_L_E_T_ = '' "    
            cQryUpd += "    WHERE"
            cQryUpd += "    BDK010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_MATEMP = '"+cCtrPF+"' "


            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BF4*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BF4010 "
            cQryUpd += "        SET BF4010.BF4_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BF4010 "
            cQryUpd += "    INNER JOIN BA1010" 
            cQryUpd += "        ON  BA1010.BA1_FILIAL = BF4010.BF4_FILIAL "
            cQryUpd += "        AND BA1010.BA1_CODINT = BF4010.BF4_CODINT "
            cQryUpd += "        AND BA1010.BA1_CODEMP = BF4010.BF4_CODEMP "
            cQryUpd += "        AND BA1010.BA1_MATRIC = BF4010.BF4_MATRIC "
            cQryUpd += "        AND BA1010.BA1_TIPREG = BF4010.BF4_TIPREG "
            cQryUpd += "        AND BA1010.D_E_L_E_T_ = '' "    
            cQryUpd += "    WHERE"
            cQryUpd += "    BF4010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_MATEMP = '"+cCtrPF+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction

        /*BA1*/
        Begin Transaction

            //Monta o Update
            cQryUpd := "UPDATE BA1010 "
            cQryUpd += "        SET BA1010.BA1_CODEMP = '"+cGrpDest+"' "
            cQryUpd += "    FROM BA1010 "
            cQryUpd += "    WHERE"
            cQryUpd += "    BA1010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BA1010.BA1_MATEMP = '"+cCtrPF+"' "

            //Tenta executar o update
            nErro := TcSqlExec(cQryUpd)
            
            //Se houve erro, mostra a mensagem e cancela a transacao
            If nErro != 0
                MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
                DisarmTransaction()
            EndIf

        End Transaction
  
    MsgInfo( "Contrato Transferido!", "Transferencia de Contrato" )

    Endif

Return 

Static Function fConfirmaTransf()

    If cCombo = "Contrato PJ"

        If MsgYesNo(" - Contrato: " + alltrim(cContratoPJ) +  CHR(13)+CHR(10) + " - De: " + alltrim(cGrupo) + " - " + alltrim(cDescGrupoOrigem) + CHR(13)+CHR(10) + " - Para: " + alltrim(cGrpDest) + " - " + alltrim(cDescGrpDest) + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "Confirma Tranferencia?", "Tranferencia de Contrato")
            fTransferir()
        Else
            Alert("Tranferencia Cancelada!")
        EndIf
      
    else

        If MsgYesNo(" - Contrato: " + alltrim(cCtrPF) +  CHR(13)+CHR(10) + " - De: " + alltrim(cGrupo) + " - " + alltrim(cDescGrupoOrigem) + CHR(13)+CHR(10) + " - Para: " + alltrim(cGrpDest) + " - " + alltrim(cDescGrpDest) + CHR(13)+CHR(10) + CHR(13)+CHR(10) + "Confirma Tranferencia?", "Tranferencia de Contrato")
           fTransferir()
        Else
            Alert("Tranferencia Cancelada!")
        EndIf
        
    Endif


Return
