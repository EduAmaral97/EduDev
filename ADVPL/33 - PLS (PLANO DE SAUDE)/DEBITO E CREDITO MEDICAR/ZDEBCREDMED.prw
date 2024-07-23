#INCLUDE "TOTVS.ch"
#iNCLUDE 'PROTHEUS.CH'
#iNCLUDE "TOPCONN.CH"

/*

Autor: Eduardo Amaral
Data: 18/07/2024
Objetivo: Rotina desenvolvida para atender as consultas de debito e credito de registros deletados.

001020577
Exemplo de subcontrato: 001005575

*/


User Function ZDEBCREDMED()

    Local aArea   := FWGetArea()
    Local oBrowse
    Local cAlias := "BSQ"
    Private aRotina := {}
    Private cCadastro := "Debito e Credito Medicar"

    //ATUALIZA OS REGISTROS DELETADOS
    ZATTREGDEL()

 
    //Definicao do menu
    aRotina := MenuDef()
 
    //Instanciando o browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAlias)
    SET DELETED OFF
    oBrowse:SetDescription(cCadastro)
    oBrowse:DisableDetails()

    //ADICIONA AS LEGENDAS
    oBrowse:AddLegend( "BSQ->BSQ_ZDEL != 'DEL' .AND. BSQ->BSQ_NUMCOB == '            '"  , "GREEN",  "Deb/Cred Nao Utilizado" )
    oBrowse:AddLegend( "BSQ->BSQ_ZDEL != 'DEL' .AND. BSQ->BSQ_NUMCOB != '            '"  , "RED",    "Deb/Cred Utilizado" )
    oBrowse:AddLegend( "BSQ->BSQ_ZDEL == 'DEL' "                                      , "BLACK",  "Registro Deletado" )

    //Ativa a Browse
    oBrowse:Activate()
 
    FWRestArea(aArea)

Return Nil


Static Function MenuDef()

    Local aRotina := {}

    //Adicionando opcoes do menu
    aAdd(aRotina, {"Pesquisar", "AXPESQUI", 0, 1})
    aAdd(aRotina, {"Visualizar", "AXVISUAL", 0, 2})
    aAdd(aRotina, {"Incluir", "AXINCLUI", 0, 3})
    aAdd(aRotina, {"Alterar", "AXALTERA", 0, 4})
    aAdd(aRotina, {"Excluir", "AXDELETA", 0, 5})
    aAdd(aRotina, {"Auditoria", "U_ZMEDAUDITORIA", 0, 6})
 
Return aRotina


Static Function ZATTREGDEL()

    Local cQryUpd

    Begin Transaction

        cQryUpd := " UPDATE BSQ010 SET BSQ010.BSQ_ZDEL = 'DEL' "
        cQryUpd += " FROM BSQ010 "
        cQryUpd += " WHERE 1=1 "
        cQryUpd += " AND BSQ010.D_E_L_E_T_ = '*' "
        cQryUpd += " AND BSQ010.BSQ_ZDEL = '' "

        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)
        
        //Se houve erro, mostra a mensagem e cancela a transacao
        If nErro != 0
            MsgStop("Erro na execucao da query: "+TcSqlError(), "Atencao")
            DisarmTransaction()
        EndIf

    End Transaction

Return 
