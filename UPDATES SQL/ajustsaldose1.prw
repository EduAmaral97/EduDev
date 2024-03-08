#include 'protheus.ch'

user function ajustsaldose1()
    Begin Transaction
                
        //Monta o Update
        cQryUpd := "UPDATE SE1010 "
        cQryUpd += "        SET SE1010.E1_SALDO = SE1BKP.E1_VALOR""
        cQryUpd += "    FROM SE1010 "
        cQryUpd += "    INNER JOIN SE1BKP "
        cQryUpd += "        ON SE1BKP.E1_NUM = SE1010.E1_NUM"	
        cQryUpd += "        AND SE1BKP.D_E_L_E_T_ = ' '"
        cQryUpd += "    WHERE"
        cQryUpd += "    SE1010.D_E_L_E_T_ = ' ' "
        
    
        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transação
        If nErro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        EndIf
    End Transaction
return
