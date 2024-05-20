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
        //cQryUpd += "        SA1010.A1_ZZLEGAD = SA1BKP.A1_END "
        //cQryUpd += "    FROM SA1010 "
        //cQryUpd += "    INNER JOIN SA1BKP "
        //cQryUpd += "        ON SA1BKP.A1_NOME = SA1010.A1_CGC "	
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
        //cQryUpd += "    WHERE 1=1"
        //cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BQC010.BQC_ZNFANT = ' ' "

        
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
        //cQryUpd += "        SET BA1010.BA1_ZATEND = BA1BKP.BA1_CONEMP""
        //cQryUpd += "    FROM BA1010 "
        //cQryUpd += "    INNER JOIN BA1BKP "
        //cQryUpd += "        ON BA1BKP.BA1_NOMSOC = BA1010.BA1_IDBENN"	
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
        //cQryUpd += "        SET BA3010.BA3_EQUIPE = BA3BKP.BA3_SUBCON""
        //cQryUpd += "    FROM BA3010 "
        //cQryUpd += "    INNER JOIN BA3BKP "
        //cQryUpd += "        ON BA3BKP.BA3_CONEMP = BA3010.BA3_IDBENN"	
        //cQryUpd += "        AND BA3BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE 1=1"
        //cQryUpd += "    AND BA3010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BA3010.BA3_CODEMP IN ('0003','0006') "
        //cQryUpd += "    AND BA3010.BA3_COBNIV = '1' "

        //cQryUpd := "UPDATE BQC010 "
        //cQryUpd += "        SET BQC010.BQC_EQUIPE = BA3BKP.BA3_SUBCON""
        //cQryUpd += "    FROM BQC010 "
        //cQryUpd += "    INNER JOIN BA3BKP "
        //cQryUpd += "        ON BA3BKP.BA3_CONEMP = BQC010.BQC_ZIRIS"	
        //cQryUpd += "        AND BA3BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE 1=1"
        //cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BQC010.BQC_CODEMP IN ('0004','0005') "
        //cQryUpd += "    AND BQC010.BQC_COBNIV = '1' "


    /* ------------------------------- CONTRATOS DATABASE, CENTROCUSTO E CLASSEVALOR ------------------------------- */

            //Monta o Update - BA3 PF
            //cQryUpd := "UPDATE BA3010 "
            //cQryUpd += "        SET BA3010.BA3_DATBAS = BA3BKP.BA3_SUBCON "
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
            //cQryUpd += "        SET BQC010.BQC_DATCON = BA3BKP.BA3_SUBCON "
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
            //cQryUpd := "UPDATE BQC010 "
            //cQryUpd += "        SET BQC010.BQC_ZIRIS = SUBSTRING(BQC010.BQC_SUBCON,3,7) "
            //cQryUpd += "    FROM BQC010 "
            //cQryUpd += "    WHERE 1=1"
            //cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
            //cQryUpd += "    AND BQC010.BQC_ZIRIS = '' "
            //cQryUpd += "    AND BQC010.BQC_ZIDLEG = '' "


    /* ------------------------------- UPDATE BQC (CAMPO ESPTEL) ------------------------------- */
            
            //Monta o Update - BA3 PF
            //cQryUpd := "UPDATE BQC010 "
            //cQryUpd += "        SET BQC010.BQC_ESPTEL = BA3BKP.BA3_SUBCON "
            //cQryUpd += "    FROM BQC010 "
            //cQryUpd += "    INNER JOIN BA3BKP "
            //cQryUpd += "        ON BA3BKP.BA3_CONEMP = BQC010.BQC_SUBCON "	
            //cQryUpd += "        AND BA3BKP.D_E_L_E_T_ = ' '"
            //cQryUpd += "    WHERE 1=1"
            //cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
            //cQryUpd += "    AND BQC010.BQC_CODEMP IN ('0004','0005') "
            
            
    /* ------------------------------- UPDATE INCISS SA1010 ------------------------------- */
                
            //cQryUpd := " UPDATE SA1010 SET A1_INCISS = 'S' "
            //cQryUpd += " FROM SA1010 A "
            //cQryUpd += " WHERE 1=1 "
            //cQryUpd += " AND A.D_E_L_E_T_ = '' "
            //cQryUpd += " AND A.A1_COD IN ('005315','005844','011017','012887','020906','024865','026644','030027','033935','045924','046616','046636','046645','047228','047551','048609','050097','050099','050787','052689','053336','053471','054025','054156','054579','054622','055114','056855','057679','059209','060198','062140','062690','062850','063067','063691','063716','063771','063788','063798','063849','064226','064436','064481','064542','069587','070365','070518','072557','073143','073885','073979','077241','078120','078182','078188','078190','078200','078202','078203','078205','078204','078224','078226','078227','078229','078230','078231','078232','078233','078234','078235','078238','078240','078255','078258','078263','078264','078265','078266') "

    /* ------------------------------- UPDATE ENDERECO DE COBRANCA SA1010 ------------------------------- */

            //Monta o Update
            //cQryUpd := "UPDATE SA1010 "
            //cQryUpd += "  SET SA1010.A1_ENDCOB = SA1BKP.A1_END "
            //cQryUpd += "FROM SA1010 "
            //cQryUpd += "    INNER JOIN SA1BKP "
            //cQryUpd += "        ON SA1BKP.A1_COD = SA1010.A1_COD "	
            //cQryUpd += "        AND SA1BKP.A1_LOJA = '01' "	
            //cQryUpd += "        AND SA1BKP.D_E_L_E_T_ = ' '"
            //cQryUpd += "    WHERE 1=1"


     /* ------------------------------- UPDATE NATUREZA CLIENTES MEDICARTECH ------------------------------- */

            //Monta o Update
            //cQryUpd := "UPDATE SA1010 "
            //cQryUpd += "  SET SA1010.A1_NATUREZ = '10109' "
            //cQryUpd += "FROM SA1010 "
            //cQryUpd += "    INNER JOIN BQC010 "
            //cQryUpd += "        ON BQC010.BQC_CODCLI = SA1010.A1_COD "	
            //cQryUpd += "        AND BQC010.BQC_LOJA = SA1010.A1_LOJA "	
            //cQryUpd += "        AND BQC010.D_E_L_E_T_ = ' '"
            //cQryUpd += "    INNER JOIN BA3010 "
            //cQryUpd += "        ON BA3010.BA3_CODINT = BQC010.BQC_CODINT "
            //cQryUpd += "        AND BA3010.BA3_CODEMP = BQC010.BQC_CODEMP "
            //cQryUpd += "        AND BA3010.BA3_CONEMP = BQC010.BQC_NUMCON "
            //cQryUpd += "        AND BA3010.BA3_VERCON = BQC010.BQC_VERCON "
            //cQryUpd += "        AND BA3010.BA3_SUBCON = BQC010.BQC_SUBCON "
            //cQryUpd += "        AND BA3010.BA3_VERSUB = BQC010.BQC_VERSUB "
            //cQryUpd += "        AND BA3010.D_E_L_E_T_ = ' ' "
            //cQryUpd += "    WHERE 1=1"
            //cQryUpd += "    AND BQC010.BQC_COBNIV = '1' "
            //cQryUpd += "    AND BQC010.BQC_NUMCON = '000000000002' "
            //cQryUpd += "    AND BA3010.BA3_FILIAL <> '006' "



            /* ------------------------------- UPDATE CENTRO DE CUSTO E CLASSE VALOR BA3 | BQC ------------------------------- */
                
            //Monta o Update BQC
            //cQryUpd := "UPDATE BQC010 "
            //cQryUpd += "  SET BQC010.BQC_CC =  "
            //cQryUpd += " CASE "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000002' THEN '11201' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000004' THEN '10101' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000005' THEN '11201' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000006' THEN '10701' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000007' THEN '11001' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000008' THEN '10201' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000010' THEN '10501' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000012' THEN '10501' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000013' THEN '10201' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000014' THEN '10501' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000017' THEN '11502' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000022' THEN '10401' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000024' THEN '10801' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000025' THEN '11201' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000026' THEN '10701' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000027' THEN '11501' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000028' THEN '11501' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000030' THEN '10501' "
            //cQryUpd += "     WHEN BQC_NUMCON = '000000000031' THEN '10501' "
            //cQryUpd += "     ELSE '' "
            //cQryUpd += " END,  "
            //cQryUpd += " BQC010.BQC_CLVL =  "
            //cQryUpd += " CASE "
            //cQryUpd += "     WHEN BA3_FILIAL = '001' THEN '012013' "
            //cQryUpd += "     WHEN BA3_FILIAL = '002' THEN '012014' "
            //cQryUpd += "     WHEN BA3_FILIAL = '003' THEN '012015' "
            //cQryUpd += "     WHEN BA3_FILIAL = '006' THEN '012046' "
            //cQryUpd += "     WHEN BA3_FILIAL = '008' THEN '012030' "
            //cQryUpd += "     WHEN BA3_FILIAL = '016' THEN '012020' "
            //cQryUpd += "     WHEN BA3_FILIAL = '021' THEN '012049' "
            //cQryUpd += "     ELSE '' "
            //cQryUpd += " END "
            //cQryUpd += " FROM BQC010 A "
            //cQryUpd += " LEFT JOIN BA3010 B ON B.D_E_L_E_T_ = '' AND B.BA3_SUBCON = A.BQC_SUBCON "
            //cQryUpd += " WHERE 1=1 "
            //cQryUpd += " AND A.D_E_L_E_T_ = '' "
            //cQryUpd += " AND A.BQC_COBNIV = '1' "
            //cQryUpd += " AND A.BQC_CODEMP IN ('0004','0005') "
            
            //Monta o Update BA3
            //cQryUpd := "UPDATE BA3010 "
            //cQryUpd += "  SET BA3010.BA3_CC =  "
            //cQryUpd += " CASE "
            //cQryUpd += "     WHEN A.BA3_CONEMP = '000000000003' THEN '10601' "
            //cQryUpd += "     WHEN A.BA3_CONEMP = '000000000004' THEN '10601' "
            //cQryUpd += "     WHEN A.BA3_CONEMP = '000000000005' THEN '10601' "
            //cQryUpd += "     WHEN A.BA3_CONEMP = '000000000006' THEN '10601' "
            //cQryUpd += "     WHEN A.BA3_CONEMP = '000000000007' THEN '10601' "
            //cQryUpd += "     WHEN A.BA3_CONEMP = '000000000008' THEN '10601' "
            //cQryUpd += "     WHEN A.BA3_CONEMP = '000000000009' THEN '11502' "
            //cQryUpd += "     ELSE '' "
            //cQryUpd += " END, "
            //cQryUpd += "  BA3010.BA3_CLVL =  "
            //cQryUpd += " CASE "
            //cQryUpd += " 	WHEN BA3_FILIAL = '001' THEN '012013' "
            //cQryUpd += " 	WHEN BA3_FILIAL = '002' THEN '012014' "
            //cQryUpd += " 	WHEN BA3_FILIAL = '003' THEN '012015' "
            //cQryUpd += " 	WHEN BA3_FILIAL = '006' THEN '012046' "
            //cQryUpd += " 	WHEN BA3_FILIAL = '008' THEN '012030' "
            //cQryUpd += " 	WHEN BA3_FILIAL = '016' THEN '012020' "
            //cQryUpd += " 	WHEN BA3_FILIAL = '021' THEN '012049' "
            //cQryUpd += " 	ELSE '' "
            //cQryUpd += " END  "
            //cQryUpd += " FROM BA3010 A "
            //cQryUpd += " WHERE 1=1 "
            //cQryUpd += " AND A.D_E_L_E_T_ = '' "
            //cQryUpd += " AND A.BA3_COBNIV = '1' "
            //cQryUpd += " AND A.BA3_CODEMP IN ('0003','0006') "

        
        /* ------------------------------- UPDATE SA1 INCSR MUNICIPAL ------------------------------- */

            //cQryUpd := " UPDATE SA1010  "
            //cQryUpd += "     SET SA1010.A1_INSCRM = SA1BKP.A1_NOME "
            //cQryUpd += " FROM SA1010 "
            //cQryUpd += " INNER JOIN SA1BKP  "
            //cQryUpd += " ON  SA1BKP.D_E_L_E_T_ = ''  "
            //cQryUpd += " AND SA1BKP.A1_COD = SA1010.A1_COD  "
            //cQryUpd += " AND SA1BKP.A1_LOJA   = SA1010.A1_LOJA "
            //cQryUpd += " WHERE 1=1 "
            //cQryUpd += " AND SA1010.D_E_L_E_T_ = '' "

        
        /* ------------------------------- UPDATE EUIPE DE VENDAS BA1 ------------------------------- */

        //cQryUpd :=  " UPDATE BA1010 SET BA1010.BA1_EQUIPE = B.BA3_EQUIPE "
        //cQryUpd +=  " FROM BA3010 B "
        //cQryUpd +=  " LEFT JOIN BA1010 C ON  "
        //cQryUpd +=  "     C.D_E_L_E_T_ = ''  "
        //cQryUpd +=  "     AND C.BA1_FILIAL = B.BA3_FILIAL  "
        //cQryUpd +=  "     AND C.BA1_CODINT = B.BA3_CODINT  "
        //cQryUpd +=  "     AND C.BA1_CODEMP = B.BA3_CODEMP "
        //cQryUpd +=  "     AND C.BA1_CONEMP = B.BA3_CONEMP "
        //cQryUpd +=  "     AND C.BA1_SUBCON = B.BA3_SUBCON "
        //cQryUpd +=  "     AND C.BA1_MATEMP = B.BA3_MATEMP "
        //cQryUpd +=  " WHERE 1=1 "
        //cQryUpd +=  "     AND B.D_E_L_E_T_ = ''  "
        //cQryUpd +=  "     AND B.BA3_COBNIV = '1' "
        //cQryUpd +=  "     AND B.BA3_SUBCON = '000000001' "
        //cQryUpd +=  "     AND B.BA3_EQUIPE <> '' "


        /* ------------------------------- UPDATE EUIPE DE VENDAS BQC ------------------------------- */
                
            //Monta o Update
            //cQryUpd := "UPDATE BQC010 "
            //cQryUpd += "        SET BQC010.BQC_EQUIPE = BQCBKP.BQC_CODIGO "
            //cQryUpd += "    FROM BQC010 "
            //cQryUpd += "    INNER JOIN BQCBKP "
            //cQryUpd += "        ON BQCBKP.BQC_SUBCON = BQC010.BQC_SUBCON"	
            //cQryUpd += "        AND BQCBKP.D_E_L_E_T_ = ' '"
            //cQryUpd += "    WHERE"
            //cQryUpd += "    BQC010.D_E_L_E_T_ = ' ' "

        /* ------------------------------- UPDATE ID LEGADO CLIENTE ------------------------------- */
        
        //Monta o Update
        //cQryUpd := "UPDATE SA1010 "
        //cQryUpd += "        SET SA1010.A1_ZZNRCON = SA1BKP.A1_NOME "
        //cQryUpd += "    FROM SA1010 "
        //cQryUpd += "    INNER JOIN SA1BKP "
        //cQryUpd += "        ON SA1BKP.A1_COD = SA1010.A1_COD "	
        //cQryUpd += "        AND SA1BKP.A1_LOJA = SA1010.A1_LOJA "	
        //cQryUpd += "        AND SA1BKP.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    WHERE"
        //cQryUpd += "    SA1010.D_E_L_E_T_ = ' ' "

        
        /* ------------------------------- UPDATE ID LEGADO CLIENTE ------------------------------- */
        
        //cQryUpd := "UPDATE BA1010 SET BA1010.BA1_EQUIPE = A.BQC_EQUIPE "
        //cQryUpd += "FROM BQC010 A "
        //cQryUpd += "LEFT JOIN BA3010 B ON B.BA3_CODINT = A.BQC_CODINT AND B.BA3_CODEMP = A.BQC_CODEMP AND B.BA3_CONEMP = A.BQC_NUMCON AND B.BA3_SUBCON = A.BQC_SUBCON AND B.D_E_L_E_T_ = ''    "
        //cQryUpd += "LEFT JOIN BA1010 C ON C.BA1_FILIAL = B.BA3_FILIAL AND C.BA1_CODINT = B.BA3_CODINT AND C.BA1_CODEMP = B.BA3_CODEMP AND C.BA1_CONEMP = B.BA3_CONEMP AND C.BA1_SUBCON = B.BA3_SUBCON AND C.BA1_MATEMP = B.BA3_MATEMP AND C.D_E_L_E_T_ = ''    "
        //cQryUpd += "LEFT JOIN BXL010 D ON D.D_E_L_E_T_ = '' AND D.BXL_CODEQU = A.BQC_EQUIPE  "
        //cQryUpd += "WHERE 1=1 "
        //cQryUpd += "AND A.D_E_L_E_T_ ='' "
        //cQryUpd += "AND A.BQC_COBNIV = '1' "
        //cQryUpd += "AND A.BQC_EQUIPE <> '' "


    /* ------------------------------- UPDATE CODIGO LEGADO BENEFICIARIO ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BA1010 "
        //cQryUpd += "        SET BA1010.BA1_EQUIPE = BA1BKP.BA1_NOMSOC""
        //cQryUpd += "    FROM BA1010 "
        //cQryUpd += "    INNER JOIN BA1BKP "
        //cQryUpd += "        ON BA1BKP.BA1_SUBCON = BA1010.BA1_SUBCON "	
        //cQryUpd += "        AND BA1BKP.BA1_NOMUSR = BA1010.BA1_NOMUSR "
        //cQryUpd += "        AND BA1BKP.D_E_L_E_T_ = ' '"
        //cQryUpd += "    WHERE"
        //cQryUpd += "    BA1010.D_E_L_E_T_ = ' ' "

    
    /* ------------------------------- UPDATE EQUIPE BA1 ------------------------------- */


        //cQryUpd := " UPDATE BA1010 SET BA1010.BA1_EQUIPE = BA1BKP.BA1_CODINT "
        //cQryUpd += " FROM BA1010  "
        //cQryUpd += " INNER JOIN BA1BKP ON BA1BKP.D_E_L_E_T_ = '' AND BA1BKP.BA1_NOMSOC = BA1010.BA1_IDBENN "
        //cQryUpd += " WHERE 1=1 "
        //cQryUpd += " AND BA1010.D_E_L_E_T_ = '' "


    /* ------------------------------- UPDATE DATA REAJUSTE BA3 ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE BA3010 "
        //cQryUpd += "        SET BA3010.BA3_COBNIV = '1' "
        //cQryUpd += "    WHERE 1=1"
        //cQryUpd += "    AND BA3010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BA3010.BA3_CODEMP IN ('0003','0006')  "

        //cQryUpd := "UPDATE BQC010 "
        //cQryUpd += "        SET BQC010.BQC_COBNIV = '' "
        //cQryUpd += "    WHERE 1=1"
        //cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BQC010.BQC_CODEMP IN ('0003','0006')  "

   /* ------------------------------- UPDATE DATA REAJUSTE BQC ------------------------------- */
        
        //Monta o Update
        //cQryUpd := "UPDATE BQC010 "
        //cQryUpd += "        SET BQC010.BQC_MESREA = SUBSTRING(BQC010.BQC_DATCON,5,2) "
        //cQryUpd += "    WHERE 1=1"
        //cQryUpd += "    AND BQC010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND BQC010.BQC_COBNIV = '1' "
    
    /* ------------------------------- UPDATE CONTA BANCARIA SA1 ------------------------------- */

        //cQryUpd := " UPDATE SA1010 "
        //cQryUpd += " SET SA1010.A1_CODBANC = BA3010.BA3_BCOCLI, "
        //cQryUpd += "     SA1010.A1_ZZAGENC = BA3010.BA3_AGECLI, "
        //cQryUpd += "     SA1010.A1_ZZDVAGG = BA3010.BA3_DTACLI, "
        //cQryUpd += "     SA1010.A1_ZZNRCON = BA3010.BA3_CTACLI, "
        //cQryUpd += "     SA1010.A1_ZZDVCTA = BA3010.BA3_DTCCLI "
        //cQryUpd += " FROM SA1010 "
        //cQryUpd += " LEFT JOIN BA3010 ON BA3010.D_E_L_E_T_ = '' AND BA3010.BA3_CODCLI = SA1010.A1_COD AND BA3010.BA3_LOJA = SA1010.A1_LOJA AND BA3010.BA3_COBNIV = '1'  "
        //cQryUpd += " WHERE 1=1 "
        //cQryUpd += " AND SA1010.D_E_L_E_T_ = '' "
        //cQryUpd += " AND BA3010.BA3_CTACLI <> '' "
        //cQryUpd += " AND SA1010.A1_ZZNRCON = '' "

    /* ------------------------------- UPDATE RECIRRF SA1 ------------------------------- */

        cQryUpd := " UPDATE SA1010 SET SA1010.A1_RECIRRF = 2 "
        cQryUpd += " FROM SA1010 "
        cQryUpd += " WHERE 1=1 "
        cQryUpd += " AND SA1010.D_E_L_E_T_ = '' "
        cQryUpd += " AND SA1010.A1_COD IN ('078575','078424','078610','078502','079043','078449','079068','078467','079055','090765','090831','079107','079137','078471','089970','078572','079069','090832','078584','078585','079071','078556','079067','079060','078570','078619','078493','091541','078601','079117','078488','078506','079086','078599','079049','077436','078423','078574','079051','078593','078491','089973','078602','078430','079135','027477','078474','078425','078598','078498','079121','078458','078583','078444','078442','078586','078609','078608','078443','078494','089988','089979','079072','078486','079142','078485','078497','078489','078507','079048','078606','078441','089980','079110','096829','078505','078473','078438','079054','089982','078614','089981','078480','078504','079075','078426','090833','078481','091530','078496','090209','015522','078468','078446','078460','078462','079083','078456','078495','078592','078564','078573','079088','096830','089989','079058','078429','078621','078484','091528','079062','090830','089974','078613','089978','077455','078500','078620','079082','078612','078604','079079','078503','089977','078420','078445','091542','078603','078457','078499','079089','079070','089983','079057','091529','079081','079059','078492','091537','078617','089975','079084','078436','078578','078433','078509','078476','078615','079047','078466','078557','079108','079115','079091','079056','078569','079061','079044','078590','078591','078607','078478','079143','090836','078454','079045','079076','078600','078605','079085','078616','078431','078451','078558','077702','077703','079080','078571','078439','091535','078508','089968','079064','091538','078587','078463','079087','079073','078510','079066','096828','078475','078437','078482','077463','078611','078440','078483','079053','079063','078487','078470','091536','079078','078479','079046','079065','078582','079052','078469','078618','078594','090008','078472','078477') "

        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction

return



