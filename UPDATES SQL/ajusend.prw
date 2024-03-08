#include 'protheus.ch'

user function ajusend()
    Begin Transaction
                
        //Monta o Update
        cQryUpd := "UPDATE SA1010 "
        cQryUpd += "        SET SA1010.A1_END = SA1BKP.A1_END,""
        cQryUpd += "        SA1010.A1_ENDCOB = SA1BKP.A1_ENDCOB""
        cQryUpd += "    FROM SA1010 "
        cQryUpd += "    INNER JOIN SA1BKP "
        cQryUpd += "        ON SA1BKP.A1_FILIAL = SA1010.A1_FILIAL"
        cQryUpd += "        AND SA1BKP.A1_COD = SA1010.A1_COD"
        cQryUpd += "        AND SA1BKP.A1_LOJA = SA1010.A1_LOJA"		
        cQryUpd += "        AND SA1BKP.D_E_L_E_T_ = ' '"
        cQryUpd += "    WHERE"
        cQryUpd += "    SA1010.D_E_L_E_T_ = ' ' "
        //cQryUpd += "    AND SA1010.A1_COD = '000387'  "
        
    
        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transa��o
        If nErro != 0
            MsgStop("Erro na execu��o da query: "+TcSqlError(), "Aten��o")
            DisarmTransaction()
        EndIf
    End Transaction
return
