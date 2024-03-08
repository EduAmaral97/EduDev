#include 'protheus.ch'

user function updatemedicar()

MsAguarde({||execupdatesqlmedicar()},"Aguarde","Executando Update.") //Mensagem de aguarde o update

return


Static function execupdatesqlmedicar

    Begin Transaction
                
        /* ------------------------------- UPDATE ID LEGADO CLIENTE ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE SA1010 "
        //cQryUpd += "        SET SA1010.A1_ZIDLEGA = SA1BKP.A1_NREDUZ, "
        //cQryUpd += "        SA1010.A1_ZZLEGAD = SA1BKP.A1_BAIRRO "
        //cQryUpd += "    FROM SA1010 "
        //cQryUpd += "    INNER JOIN SA1BKP "
        //cQryUpd += "        ON SA1BKP.A1_END = SA1010.A1_CGC "	
        //cQryUpd += "        AND SA1010.A1_ZIDLEGA = '' "
        //cQryUpd += "        AND SA1BKP.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    WHERE"
        //cQryUpd += "    SA1010.D_E_L_E_T_ = ' ' "


        /* ------------------------------- UPDATE ID LEGADO CONTRATO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BQC010 "
        //cQryUpd += "        SET BQC010.BQC_ZIDLEG = BQCBKP.BQC_NUMCON""
        //cQryUpd += "    FROM BQC010 "
        //cQryUpd += "    INNER JOIN BQCBKP "
        //cQryUpd += "        ON BQCBKP.BQC_SUBCON = BQC010.BQC_SUBCON"	
        //cQryUpd += "        AND BQCBKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BQC010.D_E_L_E_T_ = ' ' "


    /* ------------------------------- UPDATE NOME FANTASIA CONTRATO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BQC010 "
        //cQryUpd += "        SET BQC010.BQC_ZNFANT = SA1010.A1_NREDUZ""
        //cQryUpd += "    FROM BQC010 "
        //cQryUpd += "    INNER JOIN SA1010 "
        //cQryUpd += "        ON SA1010.A1_COD = BQC010.BQC_CODCLI"	
        //cQryUpd += "        AND SA1010.A1_LOJA = BQC010.BQC_LOJA"	
        //cQryUpd += "        AND SA1010.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BQC010.D_E_L_E_T_ = ' ' "

        
    /* ------------------------------- UPDATE CODIGO LEGADO BENEFICIARIO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BA1010 "
        //cQryUpd += "        SET BA1010.BA1_ZCODLG = BA1BKP.BA1_NOMSOC""
        //cQryUpd += "    FROM BA1010 "
        //cQryUpd += "    INNER JOIN BA1BKP "
        //cQryUpd += "        ON BA1BKP.BA1_CONEMP = BA1010.BA1_IDBENN"	
        //cQryUpd += "        AND BA1BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BA1010.D_E_L_E_T_ = ' ' "


    /* ------------------------------- UPDATE AJUSTE IDBENNER EM BRANCO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BA3010 "
        //cQryUpd += "        SET BA3010.BA3_IDBENN = '' ""
        //cQryUpd += "    FROM BA3010 "
        //cQryUpd += "    INNER JOIN BA3BKP "
        //cQryUpd += "        ON BA3BKP.BA3_CONEMP = BA3010.BA3_IDBENN"	
        //cQryUpd += "        AND BA3BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BA3010.D_E_L_E_T_ = ' ' "


    /* ------------------------------- UPDATE CARTEIRINHA LEGADO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BA1010 "
        //cQryUpd += "        SET BA1010.BA1_ZCDIMP = BA1BKP.BA1_NOMSOC""
        //cQryUpd += "    FROM BA1010 "
        //cQryUpd += "    INNER JOIN BA1BKP "
        //cQryUpd += "        ON BA1BKP.BA1_CONEMP = BA1010.BA1_IDBENN"	
        //cQryUpd += "        AND BA1BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BA1010.D_E_L_E_T_ = ' ' "


    /* ------------------------------- UPDATE TEM ATENDIMENTO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BA1010 "
        //cQryUpd += "        SET BA1010.BA1_ZATEND = BA1BKP.BA1_NOMSOC""
        //cQryUpd += "    FROM BA1010 "
        //cQryUpd += "    INNER JOIN BA1BKP "
        //cQryUpd += "        ON BA1BKP.BA1_CONEMP = BA1010.BA1_IDBENN"	
        //cQryUpd += "        AND BA1BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BA1010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BA1010.BA1_ZATEND = '' "


    /* ------------------------------- UPDATE VALOR BENEFICIARIO ------------------------------- */
        //Monta o Update
        //cQryUpd := " UPDATE BDK010 "
        //cQryUpd += " SET BDK010.BDK_VALOR = BA1BKP.BA1_NOMSOC "
        //cQryUpd += " FROM BA1010  "     
        //cQryUpd += " INNER JOIN BA1BKP ON BA1BKP.D_E_L_E_T_ = '' AND BA1BKP.BA1_CONEMP = BA1010.BA1_IDBENN  "
        //cQryUpd += " INNER JOIN BDK010 ON BDK010.D_E_L_E_T_ = '' AND BDK010.BDK_FILIAL = BA1010.BA1_FILIAL AND BDK010.BDK_CODINT = BA1010.BA1_CODINT AND BDK010.BDK_CODEMP = BA1010.BA1_CODEMP AND BDK010.BDK_MATRIC = BA1010.BA1_MATRIC AND BDK010.BDK_TIPREG = BA1010.BA1_TIPREG "
        //cQryUpd += " WHERE 1=1 "
        //cQryUpd += " AND BA1010.D_E_L_E_T_ = ' ' "
                                                                                                

    /* ------------------------------- UPDATE TEM ATENDIMENTO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BA1010 "
        //cQryUpd += "        SET BA1010.BA1_ZATEND = BA1BKP.BA1_NOMSOC""
        //cQryUpd += "    FROM BA1010 "
        //cQryUpd += "    INNER JOIN BA1BKP "
        //cQryUpd += "        ON BA1BKP.BA1_CONEMP = BA1010.BA1_IDBENN"	
        //cQryUpd += "        AND BA1BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BA1010.D_E_L_E_T_ = ' ' "


    /* ------------------------------- UPDATE RECIRRF CLIENTES MEDTECH ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE SA1010 "
        //cQryUpd += "        SET SA1010.A1_RECIRRF = '1' ""
        //cQryUpd += "    FROM SA1010 "
        //cQryUpd += "    INNER JOIN BQC010 "
        //cQryUpd += "        ON  BQC010.BQC_CODCLI = SA1010.A1_COD "
        //cQryUpd += "        AND BQC010.BQC_LOJA   = SA1010.A1_LOJA"	
        //cQryUpd += "        AND BQC010.BQC_NATURE = '10116' "	
        //cQryUpd += "        AND BQC010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    WHERE"
        //cQryUpd += "    SA1010.D_E_L_E_T_ = ' ' "


    /* ------------------------------- UPDATE VALOR CONTRATO 001021837 ------------------------------- */

        //cQryUpd := " UPDATE BDK010  "
        //cQryUpd += "     SET BDK010.BDK_VALOR = 8.33 "
        //cQryUpd += " FROM BDK010 "
        //cQryUpd += " INNER JOIN BA1010 "
        //cQryUpd += " ON  BA1010.BA1_FILIAL = BDK010.BDK_FILIAL  "
        //cQryUpd += " AND BA1010.BA1_CODINT = BDK010.BDK_CODINT  "
        //cQryUpd += " AND BA1010.BA1_CODEMP = BDK010.BDK_CODEMP  "
        //cQryUpd += " AND BA1010.BA1_MATRIC = BDK010.BDK_MATRIC "
        //cQryUpd += " AND BA1010.BA1_TIPREG = BDK010.BDK_TIPREG  "
        //cQryUpd += " AND BA1010.D_E_L_E_T_ = '' "
        //cQryUpd += " WHERE 1=1 "
        //cQryUpd += " AND BDK010.D_E_L_E_T_ = '' "
        //cQryUpd += " AND BA1010.BA1_SUBCON = '001021837' "

    /* ------------------------------- UPDATE NATUREZA CLIENTE CONTRATOS MEDTECH ------------------------------- */

        //cQryUpd := " UPDATE SA1010  "
        //cQryUpd += "     SET SA1010.A1_NATUREZ = BQC010.BQC_NATURE "
        //cQryUpd += " FROM SA1010 "
        //cQryUpd += " INNER JOIN BQC010  "
        //cQryUpd += " ON  BQC010.D_E_L_E_T_ = ''  "
        //cQryUpd += " AND BQC010.BQC_CODCLI = SA1010.A1_COD  "
        //cQryUpd += " AND BQC010.BQC_LOJA   = SA1010.A1_LOJA "
        //cQryUpd += " WHERE 1=1 "
        //cQryUpd += " AND SA1010.D_E_L_E_T_ = '' "
        //cQryUpd += " AND BQC010.BQC_NUMCON = '000000000002' "


    /* ------------------------------- UPDATE EQUIPE DE VENDAS BA3 ------------------------------- */

        //Monta o Update
        //cQryUpd := "UPDATE BA3010 "
        //cQryUpd += "        SET BA3010.BA3_EQUIPE = BA1BKP.BA1_NOMSOC""
        //cQryUpd += "    FROM BA3010 "
        //cQryUpd += "    INNER JOIN BA1BKP "
        //cQryUpd += "        ON BA1BKP.BA1_CONEMP = BA3010.BA3_IDBENN"	
        //cQryUpd += "        AND BA1BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE 1=1"
        //cQryUpd += "    AND BA3010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BA3010.BA3_CODEMP IN ('0003','0006') "
        //cQryUpd += "    AND BA3010.BA3_EQUIPE = '' "

    /* ------------------------------- CONTRATOS DATABASE, CENTROCUSTO E CLASSEVALOR ------------------------------- */

            //Monta o Update - BA3 PF
            //cQryUpd := "UPDATE BA3010 "
            //cQryUpd += "        SET BA3010.BA3_DATBAS = BA3BKP.BA3_SUBCON, "
            //cQryUpd += "            BA3010.BA3_CC = BA3BKP.BA3_NUMCON, "
            //cQryUpd += "            BA3010.BA3_CLVL = BA3BKP.BA3_MATRIC "
            //cQryUpd += "    FROM BA3010 "
            //cQryUpd += "    INNER JOIN BA3BKP "
            //cQryUpd += "        ON BA3BKP.BA3_CONEMP = BA3010.BA3_IDBENN "	
            //cQryUpd += "        AND BA3BKP.D_E_L_E_T_ = ' '"
            //cQryUpd += "    WHERE 1=1"
            //cQryUpd += "    AND BA3010.D_E_L_E_T_ = ' ' "
            //cQryUpd += "    AND BA3010.BA3_CODEMP IN ('0003','0006') "

            //Monta o Update - BQC PJ
            //cQryUpd := "UPDATE BQC010 "
            //cQryUpd += "        SET BQC010.BQC_DATCON = BA3BKP.BA3_SUBCON, "
            //cQryUpd += "            BQC010.BQC_CC = BA3BKP.BA3_NUMCON, "
            //cQryUpd += "            BQC010.BQC_CLVL = BA3BKP.BA3_MATRIC "
            //cQryUpd += "    FROM BQC010 "
            //cQryUpd += "    INNER JOIN BA3BKP "
            //cQryUpd += "        ON BA3BKP.BA3_MATEMP = BQC010.BQC_SUBCON"	
            //cQryUpd += "        AND BA3BKP.D_E_L_E_T_ = ' '"
            //cQryUpd += "    WHERE 1=1"
            //cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
            //cQryUpd += "    AND BQC010.BQC_CODEMP IN ('0004','0005') "


    /* ------------------------------- UPDATE BA3 E BQC (CAMPO ZIRIS) ------------------------------- */


            //Monta o Update - BA3 PF
            //cQryUpd := "UPDATE BA3010 "
            //cQryUpd += "        SET BA3010.BA3_ZIRIS = BA3010.BA3_IDBENN "
            //cQryUpd += "    FROM BA3010 "
            //cQryUpd += "    WHERE 1=1"
            //cQryUpd += "    AND BA3010.D_E_L_E_T_ = ' ' "
            //cQryUpd += "    AND BA3010.BA3_ZIRIS = '' "
            //cQryUpd += "    AND BA3010.BA3_IDBENN <> '' "

            //Monta o Update - BQC PJ
            cQryUpd := "UPDATE BQC010 "
            cQryUpd += "        SET BQC010.BQC_ZIRIS = SUBSTRING(BQC010.BQC_SUBCON,3,7) "
            cQryUpd += "    FROM BQC010 "
            cQryUpd += "    WHERE 1=1"
            cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
            cQryUpd += "    AND BQC010.BQC_ZIRIS = '' "
            cQryUpd += "    AND BQC010.BQC_ZIDLEG = '' "
            
            
            
        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction

return
