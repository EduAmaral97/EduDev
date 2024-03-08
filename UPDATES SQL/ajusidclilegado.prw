#include 'protheus.ch'

user function ajusidclilegado()
    Begin Transaction
                
        //Monta o Update
        cQryUpd := "UPDATE SA1010 "
        cQryUpd += "        SET SA1010.A1_ZZLEGAD = SA1BKP.A1_END""
        cQryUpd += "    FROM SA1010 "
        cQryUpd += "    INNER JOIN SA1BKP "
        cQryUpd += "        ON SA1BKP.A1_FILIAL = SA1010.A1_FILIAL"
        cQryUpd += "        AND SA1BKP.A1_COD = SA1010.A1_COD"
        cQryUpd += "        AND SA1BKP.A1_LOJA = SA1010.A1_LOJA"		
        cQryUpd += "        AND SA1BKP.D_E_L_E_T_ = ' '"
        cQryUpd += "    WHERE"
        cQryUpd += "    SA1010.D_E_L_E_T_ = ' ' "
    
        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transação
        If nErro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        EndIf
    End Transaction
return
