#include 'protheus.ch'

user function updatesqlmed()
    Begin Transaction
                
        /* ------------------------------- UPDATE ID LEGADO CLIENTE ------------------------------- */
        //Monta o Update
        //cQryUpd := "UPDATE SA1010 "
        //cQryUpd += "        SET SA1010.A1_ZIDLEGA = SA1BKP.A1_END""
        //cQryUpd += "    FROM SA1010 "
        //cQryUpd += "    INNER JOIN SA1BKP "
        //cQryUpd += "        ON SA1BKP.A1_FILIAL = SA1010.A1_FILIAL"
        //cQryUpd += "        AND SA1BKP.A1_COD = SA1010.A1_COD"
        //cQryUpd += "        AND SA1BKP.A1_LOJA = SA1010.A1_LOJA"		
        //cQryUpd += "        AND SA1BKP.D_E_L_E_T_ = ' '"
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
        cQryUpd := "UPDATE BQC010 "
        cQryUpd += "        SET BQC010.BQC_ZNFANT = SA1010.A1_NREDUZ""
        cQryUpd += "    FROM BQC010 "
        cQryUpd += "    INNER JOIN SA1010 "
        cQryUpd += "        ON SA1010.A1_COD = BQC010.BQC_CODCLI"	
        cQryUpd += "        AND SA1010.A1_LOJA = BQC010.BQC_LOJA"	
        cQryUpd += "        AND SA1010.D_E_L_E_T_ = ' '"
        cQryUpd += "    WHERE"
        cQryUpd += "    BQC010.D_E_L_E_T_ = ' ' "




        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transação
        If nErro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        EndIf
    End Transaction
return
