#include 'protheus.ch'

user function ajusdvcta()
    Begin Transaction
                
        //Monta o Update
        cQryUpd := "UPDATE SA2010 "
        cQryUpd += "        SET SA2010.A2_BANCO = SA2BKP.A2_BANCO,""
        cQryUpd += "        SA2010.A2_AGENCIA = SA2BKP.A2_AGENCIA,""
        cQryUpd += "        SA2010.A2_NUMCON = SA2BKP.A2_NUMCON,""
        cQryUpd += "        SA2010.A2_DVCTA = SA2BKP.A2_SWIFT""
        cQryUpd += "    FROM SA2010 "
        cQryUpd += "    INNER JOIN SA2BKP "
        cQryUpd += "        ON SA2BKP.A2_FILIAL = SA2010.A2_FILIAL"
        cQryUpd += "        AND SA2BKP.A2_COD = SA2010.A2_COD"
        cQryUpd += "        AND SA2BKP.A2_LOJA = SA2010.A2_LOJA"		
        cQryUpd += "        AND SA2BKP.D_E_L_E_T_ = ' '"
        cQryUpd += "    WHERE"
        cQryUpd += "    SA2010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND SA2010.A1_COD = '000387'  "
        
    
        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transação
        If nErro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        EndIf
    End Transaction
return


