#INCLUDE "PROTHEUS.CH"

/*

- https://tdn.totvs.com/pages/releaseview.action?pageId=309397045

*/

User Function TK062SK1()
    Local cFilSK1:= ""
    //Local cOper  := ""
    Local aParam := PARAMIXB


    If aParam <> Nil

        IF MsgYesNo( "DESEJA FILTRAR SOMENTE 'TMK' ")
        

            MsAguarde({||fAtualizaTit()},"Aguarde","Atualizando Titulos para TMK") //Mensagem de aguarde o update

        
            cFilSK1:= " SK1.K1_TIPO = 'TMK' "

        Else

            MsgInfo("Cancelado pelo usuario.", "Cobranca Medicar")
            cFilSK1:= " SK1.K1_TIPO <> 'TMK' AND SK1.K1_OPERAD = '' "

        Endif





        /*
        cOper  := aParam[1]
        If cOper $'000001|000002|000005'
            cFilSK1 := ' SK1.K1_SALDO > 10000 '
         
        ElseIf cOper $'000003|000004|000007'
            cFilSK1:= ' SK1.K1_SALDO > 5000 '
         
        Else
            cFilSK1:= ' SK1.K1_SALDO > 50 '
         
        EndIf
        */
    EndIf
 
Return cFilSK1


Static Function fAtualizaTit()

    Local cQryUpdSE1
    Local cQryUpdSK1
    Local cQryUpdSE1PJ
    Local cQryUpdSK1PJ

    Local cQryRSE1PJ
    Local cQryRSK1PJ
    Local cQryRSE1PF
    Local cQryRSK1PF

    
    Begin Transaction

        cQryUpdSE1 := " UPDATE SE1010 SET SE1010.E1_TIPO = 'TMK' "
        cQryUpdSE1 += " FROM SE1010  "
        cQryUpdSE1 += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SE1010.E1_CLIENTE AND SA1010.A1_LOJA = SE1010.E1_LOJA " 
        cQryUpdSE1 += " WHERE 1=1 "
        cQryUpdSE1 += " AND SE1010.D_E_L_E_T_ = '' "
        cQryUpdSE1 += " AND SE1010.E1_FILIAL NOT IN ('016001','016002') "
        cQryUpdSE1 += " AND SE1010.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryUpdSE1 += " AND SE1010.E1_SALDO > 0 "
        cQryUpdSE1 += " AND DATEDIFF(DAY, SE1010.E1_VENCREA, GETDATE()) >= 61 "
        cQryUpdSE1 += " AND SA1010.A1_PESSOA = 'F' "

       //Tenta executar o update
        nErro := TcSqlExec(cQryUpdSE1)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction

    Begin Transaction

        cQryUpdSK1 := " UPDATE SK1010 SET SK1010.K1_TIPO = 'TMK' "
        cQryUpdSK1 += " FROM SK1010  "
        cQryUpdSK1 += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SK1010.K1_CLIENTE AND SA1010.A1_LOJA = SK1010.K1_LOJA "
        cQryUpdSK1 += " WHERE 1=1 "
        cQryUpdSK1 += " AND SK1010.D_E_L_E_T_ = '' "
        cQryUpdSK1 += " AND SK1010.K1_FILIAL NOT IN ('016001','016002') "
        cQryUpdSK1 += " AND SK1010.K1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryUpdSK1 += " AND SK1010.K1_SALDO > 0 "
        cQryUpdSK1 += " AND DATEDIFF(DAY, SK1010.K1_VENCREA, GETDATE()) >= 61 "
        cQryUpdSK1 += " AND SA1010.A1_PESSOA = 'F' "

       //Tenta executar o update
        nErro := TcSqlExec(cQryUpdSK1)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction

    Begin Transaction

        cQryUpdSE1PJ := " UPDATE SE1010 SET SE1010.E1_TIPO = 'TMK' "
        cQryUpdSE1PJ += " FROM SE1010  "
        cQryUpdSE1PJ += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SE1010.E1_CLIENTE AND SA1010.A1_LOJA = SE1010.E1_LOJA " 
        cQryUpdSE1PJ += " WHERE 1=1 "
        cQryUpdSE1PJ += " AND SE1010.D_E_L_E_T_ = '' "
        cQryUpdSE1PJ += " AND SE1010.E1_FILIAL IN ('003001','008001') "
        cQryUpdSE1PJ += " AND SE1010.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryUpdSE1PJ += " AND SE1010.E1_SALDO > 0 "
        cQryUpdSE1PJ += " AND DATEDIFF(DAY, SE1010.E1_VENCREA, GETDATE()) >= 61 "
        cQryUpdSE1PJ += " AND SA1010.A1_PESSOA = 'J' "

       //Tenta executar o update
        nErro := TcSqlExec(cQryUpdSE1PJ)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction


    Begin Transaction

        cQryUpdSK1PJ := " UPDATE SK1010 SET SK1010.K1_TIPO = 'TMK' "
        cQryUpdSK1PJ += " FROM SK1010  "
        cQryUpdSK1PJ += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SK1010.K1_CLIENTE AND SA1010.A1_LOJA = SK1010.K1_LOJA "
        cQryUpdSK1PJ += " WHERE 1=1 "
        cQryUpdSK1PJ += " AND SK1010.D_E_L_E_T_ = '' "
        cQryUpdSK1PJ += " AND SK1010.K1_FILIAL IN ('003001','008001') "
        cQryUpdSK1PJ += " AND SK1010.K1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryUpdSK1PJ += " AND SK1010.K1_SALDO > 0 "
        cQryUpdSK1PJ += " AND DATEDIFF(DAY, SK1010.K1_VENCREA, GETDATE()) >= 61 "
        cQryUpdSK1PJ += " AND SA1010.A1_PESSOA = 'J' "

       //Tenta executar o update
        nErro := TcSqlExec(cQryUpdSK1)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction

    /* ------------------------------------- REALIZAR UPDATE NOS RESTANTE DOS TITULOS QUE FALTARAM ------------------------------------- */


    Begin Transaction

        /* SE1 PJ */
        cQryRSE1PJ := " UPDATE SE1010 SET SE1010.E1_TIPO = 'TMK' "
        cQryRSE1PJ += " FROM SE1010 "
        cQryRSE1PJ += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SE1010.E1_CLIENTE AND SA1010.A1_LOJA = SE1010.E1_LOJA "
        cQryRSE1PJ += " WHERE 1=1 "
        cQryRSE1PJ += " AND SE1010.D_E_L_E_T_ = '' "
        cQryRSE1PJ += " AND ISNULL(( SELECT TOP 1 SE1.E1_CLIENTE FROM SE1010 SE1 WHERE 1=1 AND SE1.D_E_L_E_T_ = '' AND SE1.E1_TIPO = 'TMK' AND SE1.E1_SALDO >  0 AND SE1.E1_CLIENTE = SE1010.E1_CLIENTE AND SE1.E1_LOJA = SE1010.E1_LOJA ),'') <> '' "
        cQryRSE1PJ += " AND SE1010.E1_FILIAL IN ('003001','008001') "
        cQryRSE1PJ += " AND SE1010.E1_SALDO > 0 "
        cQryRSE1PJ += " AND SE1010.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryRSE1PJ += " AND SE1010.E1_VENCREA <= DATEADD(DAY, -5, GETDATE()) "
        cQryRSE1PJ += " AND SA1010.A1_PESSOA = 'J' "

        //Tenta executar o update
        nErro := TcSqlExec(cQryRSE1PJ)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction
        

    Begin Transaction

        /* SE1 PF */
        cQryRSE1PF := " UPDATE SE1010 SET SE1010.E1_TIPO = 'TMK' "
        cQryRSE1PF += " FROM SE1010 "
        cQryRSE1PF += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SE1010.E1_CLIENTE AND SA1010.A1_LOJA = SE1010.E1_LOJA "
        cQryRSE1PF += " WHERE 1=1 "
        cQryRSE1PF += " AND SE1010.D_E_L_E_T_ = '' "
        cQryRSE1PF += " AND ISNULL(( SELECT TOP 1 SE1.E1_CLIENTE FROM SE1010 SE1 WHERE 1=1 AND SE1.D_E_L_E_T_ = '' AND SE1.E1_TIPO = 'TMK' AND SE1.E1_SALDO >  0 AND SE1.E1_CLIENTE = SE1010.E1_CLIENTE AND SE1.E1_LOJA = SE1010.E1_LOJA ),'') <> '' "
        cQryRSE1PF += " AND SE1010.E1_FILIAL NOT IN ('016001','016002') "
        cQryRSE1PF += " AND SE1010.E1_SALDO > 0 "
        cQryRSE1PF += " AND SE1010.E1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryRSE1PF += " AND SE1010.E1_VENCREA <= DATEADD(DAY, -5, GETDATE()) "
        cQryRSE1PF += " AND SA1010.A1_PESSOA = 'F' "

            //Tenta executar o update
        nErro := TcSqlExec(cQryRSE1PF)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction


    Begin Transaction

        /* SK1 PJ */
        cQryRSK1PJ := " UPDATE SK1010 SET SK1010.K1_TIPO = 'TMK' "
        cQryRSK1PJ += " FROM SK1010 "
        cQryRSK1PJ += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SK1010.K1_CLIENTE AND SA1010.A1_LOJA = SK1010.K1_LOJA "
        cQryRSK1PJ += " WHERE 1=1 "
        cQryRSK1PJ += " AND SK1010.D_E_L_E_T_ = '' "
        cQryRSK1PJ += " AND ISNULL(( SELECT TOP 1 SE1.E1_CLIENTE FROM SE1010 SE1 WHERE 1=1 AND SE1.D_E_L_E_T_ = '' AND SE1.E1_TIPO = 'TMK' AND SE1.E1_SALDO >  0 AND SE1.E1_CLIENTE = SK1010.K1_CLIENTE AND SE1.E1_LOJA = SK1010.K1_LOJA ),'') <> '' "
        cQryRSK1PJ += " AND SK1010.K1_FILIAL IN ('003001','008001') "
        cQryRSK1PJ += " AND SK1010.K1_SALDO > 0 "
        cQryRSK1PJ += " AND SK1010.K1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryRSK1PJ += " AND SK1010.K1_VENCREA <= DATEADD(DAY, -5, GETDATE()) "
        cQryRSK1PJ += " AND SA1010.A1_PESSOA = 'J' "

        //Tenta executar o update
        nErro := TcSqlExec(cQryRSK1PJ)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction

    
    Begin Transaction

        /* SK1 PF */
        cQryRSK1PF := " UPDATE SK1010 SET SK1010.K1_TIPO = 'TMK' "
        cQryRSK1PF += " FROM SK1010 "
        cQryRSK1PF += " LEFT JOIN SA1010 ON SA1010.D_E_L_E_T_ = '' AND SA1010.A1_COD = SK1010.K1_CLIENTE AND SA1010.A1_LOJA = SK1010.K1_LOJA "
        cQryRSK1PF += " WHERE 1=1 "
        cQryRSK1PF += " AND SK1010.D_E_L_E_T_ = '' "
        cQryRSK1PF += " AND ISNULL(( SELECT TOP 1 SE1.E1_CLIENTE FROM SE1010 SE1 WHERE 1=1 AND SE1.D_E_L_E_T_ = '' AND SE1.E1_TIPO = 'TMK' AND SE1.E1_SALDO >  0 AND SE1.E1_CLIENTE = SK1010.K1_CLIENTE AND SE1.E1_LOJA = SK1010.K1_LOJA ),'') <> '' "
        cQryRSK1PF += " AND SK1010.K1_FILIAL NOT IN ('016001','016002') "
        cQryRSK1PF += " AND SK1010.K1_SALDO > 0 "
        cQryRSK1PF += " AND SK1010.K1_TIPO NOT IN ('RA','CF-','PI-','CS-','IN-','IS-','IR-','PR', 'TMK') "
        cQryRSK1PF += " AND SK1010.K1_VENCREA <= DATEADD(DAY, -5, GETDATE()) "
        cQryRSK1PF += " AND SA1010.A1_PESSOA = 'F' "

        //Tenta executar o update
        nErro := TcSqlExec(cQryRSK1PJ)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction


    MsgInfo("Titulos Atualizados com Sucesso", "Cobranca Medicar")

Return 
